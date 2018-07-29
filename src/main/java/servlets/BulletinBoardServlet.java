package servlets;

import Classes.CookiesProcessing;
import Classes.Database;
import Classes.LoginInfo;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.crypto.Data;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Date;

import static Classes.CookiesProcessing.getCookie;
import static Classes.CookiesProcessing.setCookie;

@WebServlet("/BulletinBoard")
public class BulletinBoardServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        super.doPost(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!request.getParameterMap().isEmpty()) {     // если есть параметры
            String status = request.getParameter("status");
            if (status != null && !status.isEmpty()) { //и статус не пуст

                if (status.equalsIgnoreCase("ok")) {

                    LoginInfo loginInfo = new LoginInfo(
                            request.getParameter("status"),
                            request.getParameter("access_token"),
                            new Date(Long.parseLong(request.getParameter("expires_at")) * 1000),
                            Long.parseLong(request.getParameter("account_id")),
                            request.getParameter("nickname")
                    );
                    createCookies(response, loginInfo);
                    request.setAttribute("LoginInfo", loginInfo);

                    //редиректим только если есть параметры и статус ОК
                    response.sendRedirect("/BulletinBoard");
                    return;//сюда без параметров уже не попасть

                } else if ("error".equalsIgnoreCase(status)) {

//                    processingError(request);    // обрабатываем ошибки
                    // проскакиваем блок else и выскакиваем во вьюху, строка с ошибкой будет там видна

                    LoginInfo loginInfo = new LoginInfo(
                            request.getParameter("status"),
                            request.getParameter("code"),
                            request.getParameter("message"));
                    response.sendRedirect("/ErrorAuth");  //?? добавить сервлет для страницы с ошибкой авторизации
                }

            }
        } else {// если нет параметров значит пользователь заходит по прямой ссылке, тогда вытаскиваем данные из куки
            String token = getCookie(request, CookiesProcessing.CookieName.WOT_TOKEN);
            String nickname = getCookie(request, CookiesProcessing.CookieName.WOT_USERNAME);
            String accountId = getCookie(request, CookiesProcessing.CookieName.WOT_USER_ID);
            String expiresAt = getCookie(request, CookiesProcessing.CookieName.WOT_EXPIRES);

            LoginInfo loginInfo = new LoginInfo();
            loginInfo.setStatus("ok");
            loginInfo.setAccess_token(token);
            loginInfo.setNickname(nickname);
            loginInfo.setAccount_id(Long.parseLong(accountId));
            loginInfo.setExpires_at(new Date(Long.parseLong(expiresAt) * 1000));

            request.setAttribute("LoginInfo", loginInfo);
        }
        //отображаем все актуальные объявления
        ArrayList<String > alActAds =Database.getActualAd();
        if (alActAds.size()>0) {
            request.setAttribute("AdActual", alActAds);
        }

        response.setContentType("text/html");
//        RequestDispatcher dispatcher = request.getRequestDispatcher("hello.jsp");
        RequestDispatcher dispatcher = request.getRequestDispatcher("BulletinBoard.jsp");
        if (dispatcher != null) {
            dispatcher.forward(request, response);
        }
    }


    private void createCookies(HttpServletResponse resp, LoginInfo loginInfo) {
        String domain = "lfwg.ru";
//        String domain1 = "localhost";

        // готовим свойство max time для куки (срок годности), которое равно времени до окончания срока действия токена
        long currentTime = System.currentTimeMillis();
        int maxAge = (int) ((loginInfo.getExpires_at().getTime() - currentTime) / 1000);    // оно в секуднах, поэтому делим на 1000

        // выпекаем печеньки (куки)
        setCookie(resp,
                CookiesProcessing.CookieName.WOT_USERNAME,
                loginInfo.getNickname(),
                domain,
                maxAge);

        setCookie(resp,
                CookiesProcessing.CookieName.WOT_USER_ID,
                String.valueOf(loginInfo.getAccount_id()),
                domain,
                maxAge);

        setCookie(resp,
                CookiesProcessing.CookieName.WOT_TOKEN,
                loginInfo.getAccess_token(),
                domain,
                maxAge);

        setCookie(resp,
                CookiesProcessing.CookieName.WOT_EXPIRES,
                String.valueOf(loginInfo.getExpires_at().getTime()),   // в куки нельзя хранить символы [ ] ( ) = , " / ? @ : ; поэтому дату будем хранить в милисекундах
                domain,
                maxAge);
    }
}
