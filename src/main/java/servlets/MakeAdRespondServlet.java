package servlets;

import Classes.CookiesProcessing;
import Classes.Database;
import Classes.LoginInfo;
import jdk.nashorn.internal.parser.JSONParser;

import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonReader;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.SQLException;

import static javax.ws.rs.core.HttpHeaders.USER_AGENT;

@WebServlet("/MakeAdRespond")
public class MakeAdRespondServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        super.doGet(req, resp);
        System.out.println("MakeAdRespond_GET");
//        resp.sendRedirect("/BulletinBoard");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        super.doPost(req, resp);
        System.out.println("MakeAdRespond_POST");
//        resp.sendRedirect("/BulletinBoard");
        String username = CookiesProcessing.getCookie(req, CookiesProcessing.CookieName.WOT_USERNAME);
        int accountId = Integer.parseInt(CookiesProcessing.getCookie(req, CookiesProcessing.CookieName.WOT_USER_ID));
        String accessToken = CookiesProcessing.getCookie(req, CookiesProcessing.CookieName.WOT_TOKEN);
        String appId = CookiesProcessing.getApplicationId();

        int advertId = Integer.parseInt(req.getParameter("AdId"));

        //отправим запрос на получение личного рейтинга
        String url = "https://api.worldoftanks.ru/wot/account/info/?" +
                "application_id=" + appId +
                "&account_id=" + accountId +
                "&access_token=" + accessToken +
                "&fields=global_rating%2Cstatistics.random" +
                "&extra=statistics.random";

        System.out.println("url:" + url);
        URL obj = new URL(url);
        HttpURLConnection con = (HttpURLConnection) obj.openConnection();
        // Setting basic post request
        con.setRequestMethod("POST");
        con.setRequestProperty("User-Agent", USER_AGENT);
        con.setRequestProperty("Accept-Language", "en-US,en;q=0.5");
        con.setRequestProperty("Content-Type", "application/json");


        // Send post request
        con.setDoOutput(true);
        DataOutputStream wr = new DataOutputStream(con.getOutputStream());
        wr.flush();
        wr.close();

        int responseCode = con.getResponseCode();

        try {
            InputStream fis = con.getInputStream();
            JsonReader jsonReader = Json.createReader(fis);
            JsonObject jsonObject = jsonReader.readObject();
            jsonReader.close();
            fis.close();
            int globalRating = jsonObject.getJsonObject("data").getJsonObject(String.valueOf(accountId)).getInt("global_rating");
            int battlesCount = jsonObject.getJsonObject("data").getJsonObject(String.valueOf(accountId)).getJsonObject("statistics").getJsonObject("random").getInt("battles");
            int winsCount = jsonObject.getJsonObject("data").getJsonObject(String.valueOf(accountId)).getJsonObject("statistics").getJsonObject("random").getInt("wins");
            double winPercent = (winsCount * 1.0 / battlesCount) * 100; // приведение int в double --> *1.0

            System.out.println("globalRating: " + globalRating);
            System.out.println("battlesCount: " + battlesCount);
            System.out.println("winsCount: " + winsCount);
            System.out.println("winPercent: " + winPercent);

            try {
                //винрейт округляестся базой при вставке отклика в таблицу
                Database.addRespond(advertId, accountId, username, battlesCount, winPercent, globalRating);
            } catch (SQLException ex) {
                System.out.println("Ошибка добавления отклика");
                ex.printStackTrace();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        //вернем ответ для всплывалки, что все успешно
        PrintWriter outStream = resp.getWriter();
        resp.setContentType("text/html");
        outStream.write("Respond Sucessful");// FIXME: 07.02.2018 Кодировку для кирилицы

        outStream.flush();
        outStream.close();


    }


}


