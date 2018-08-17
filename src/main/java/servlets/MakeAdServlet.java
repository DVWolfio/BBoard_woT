package servlets;

import Classes.Database;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Classes.CookiesProcessing;

import java.io.IOException;
import java.nio.charset.Charset;
import java.sql.SQLException;

import static Classes.CookiesProcessing.getCookie;

@WebServlet("/MakeAd")
public class MakeAdServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        super.doGet(req, resp);
        doPost(req, resp); //вдруг кто код метода изменит
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        super.doPost(req, resp);
//        doGet(req, resp);
        String textAd;
        int duration;
        int accIdl;
        String nickName;
        try {


            duration = req.getIntHeader("duration_time");
            textAd = new String(
                    req.getParameter("AdText").getBytes("ISO-8859-1")
                    , Charset.forName("UTF-8"));


            // FIXME: 26.11.2017 добавить передачу тегов в будущем
            nickName = getCookie(req, CookiesProcessing.CookieName.WOT_USERNAME);
            accIdl = Integer.parseInt(getCookie(req, CookiesProcessing.CookieName.WOT_USER_ID));

            try {
                Database.addNewAd(accIdl, duration, textAd, nickName);
                // FIXME: 26.11.2017 подумать на счет вставки служебных симвлолов
            } catch (SQLException sqlEx) {
                System.out.println("Ошибка добавления объявления в БД");
                sqlEx.printStackTrace();
            }
        } catch (Exception e) {
            System.out.println("Ошибка получения параметров для добавления нового объявления");
            e.printStackTrace();
        }

        resp.sendRedirect("/BulletinBoard");
    }
}
