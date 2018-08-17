<%@ page import="Classes.LoginInfo" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="sun.rmi.runtime.Log" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<%!
    //    https://stackoverflow.com/questions/826932/declaring-functions-in-jsp
    public String doStylizeAd(String accId, String nickN, String cr_date, String text, String tags, String idAd) {
        return ("" +
                "       <div class=\"b_ad\" id=\"" + idAd + "\">\n" +
                "            <div class=\"b_ad_right_side\">\n" +
                "                <p><a href=\"https://worldoftanks.ru/ru/community/accounts/" + accId + "-" + nickN + "/\">" + nickN + "</a></p>\n" +
                "            </div>\n" +
                "            <div class=\"b_ad_left_side\">\n" +
                "                <div class=\"b_ad_text\">\n" +
                "                    <p>" + text + " </p>\n" +
                "                </div>\n" +
                "                <div class=\"b_ad_time_cr\" style=\"float: right\">\n" +
                "                    <p>" + cr_date + "</p>\n" +
                "                </div>\n" +
                "                <button class=\"b-button_right\">Откликнуться</button>\n" +
                " 				 <a href=\"#\" class=\"b_button_responds\">\n" +
                "					<span>Отклики</span></a><div class=\"spoiler-block\"></div>\n" +
                "            </div>\n" +
                "        </div>"
        );
    }
%>


<!DOCTYPE html>
<html>

<head>
    <%--<form method="POST"--%>
    <%--action="https://api.worldoftanks.ru/wot/auth/login/?application_id=4e67660611202f132151e26f8cce5a27&redirect_uri=http://localhost:8080/BulletinBoard">--%>
    <%--<button type="submit">Войти</button>--%>
    <%--</form>--%>
    <%

        if (LoginInfo.domainName == null || LoginInfo.domainName.isEmpty()) {
            out.println("");
        } else {
            out.println("" +
                    "<form method=\"POST\"\n" +
                    "   action=\"https://api.worldoftanks.ru/wot/auth/login/?application_id=" +
                    LoginInfo.getApplicationId() +
//                    "               4e67660611202f132151e26f8cce5a27" +
                    "&redirect_uri=http://" +
//                    "               localhost:8080/BulletinBoard" +
                            LoginInfo.getDomainName()+":"+LoginInfo.getServerPort()+
                    "\">" +
                    "   <button type=\"submit\">Войти</button>\n" +
                    "</form>");
        }
    %>
    <link rel="stylesheet" href="Styles.css"/>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="content-type" content="text/html;charset=UTF-8"/>
    <title>Доска объявлений</title>
</head>

<body>
<h1 class="b-header">
    <div class="b-header_content">
        <a class="b-logo" href="http://localhost:8080/BulletinBoard/">
            <img src="css/wg_logo.png" alt="Wargaming.net">
            <span>LOOKING FOR WG</span>
        </a>
    </div>
    <%--Логотип сюда попозже--%>
</h1>
<div id="RespondNotice"></div>

<h2>
    <%--<div id="RespondNotice" title="Topic"></div>--%>

    <div class="b-content">

        <%
            //    if (request.getAttribute("LoginInfo") != null) {
            LoginInfo loginInfo = (LoginInfo) request.getAttribute("LoginInfo");
//            System.out.println("JSP map is empty?:"+request.getParameterMap().isEmpty());
            if (loginInfo != null) {
                if (loginInfo.getStatus().equalsIgnoreCase("ok")) {

                    out.println(loginInfo.getNickname());
                    out.println(loginInfo.getAccount_id());
                    out.println("До: " + loginInfo.getExpires_at());
                    out.println(loginInfo.getAccess_token());
                } else {
                }

            }
//    else {
//        out.println("<p style=\"color: red;\">Возникла какая-то ошибка. Извините</p>");
//        out.println(request.getAttribute("LoginInfo"));
//        out.println("");
//    }
        %>

        <form action="MakeAd" method="post">
            <p>
                <select size="1" multiple name="duration_time">
                    <option disabled>Время действия</option>
                    <option selected value="15 min">15</option>
                    <option value="30 min">30</option>
                    <option value="45 min">45</option>
                </select>
            <p>Текст объявления
                <textarea name="AdText" cols="100" rows="4" maxlength="225"></textarea>
            </p>
            <p><input type="reset" value="Очистить"></p>
            <p><input type="submit" value="Отправить"></p>
        </form>

        <%--examples------------------------------------------------------------%>
        <div class="b_ad" id="30">
            <div class="b_ad_right_side">
                <p><a href="https://worldoftanks.ru/ru/community/accounts/$$$ACC_ID-$$$NICKNAME/">$$$NICKNAME</a></p>
            </div>
            <div class="b_ad_left_side">
                <div class="b_ad_text">
                    <p>$$$TEXT_MESS </p>
                </div>
                <div class="b_ad_time_cr" style="float: right">
                    <p>$$$TIME_AGO</p>
                </div>
                <button class="b-button_right_">Откликнуться</button>
                <%--<span class="responds_list">Resps</span>--%>
                <a href="#" class="b_button_responds">
                    <span>Отклики(спойлер)</span>
                </a>
                <div class="spoiler-block"></div>
            </div>
        </div>
        <%--examples end------------------------------------------------------------%>


        <% if (request.getAttribute("AdActual") != null) {
            ArrayList<String> adList = (ArrayList<String>) request.getAttribute("AdActual");
//                    int inc = 0;
//                    out.println("<tr>");
            for (int i = 0; i < adList.size(); i += 6) { //каждое 5ое - новое обьявление
                out.println(doStylizeAd(
                        adList.get(i)
                        , adList.get(i + 1)
                        , adList.get(i + 2)
                        , adList.get(i + 3)
                        , adList.get(i + 4)
                        , adList.get(i + 5)
                ));
            }
        } else {
            out.println("Доска пока пуста...");
        }
        %>

        </table>
    </div>


</h2>

</body>
<script
<%--http://jquery.page2page.ru/index.php5/Подключение_jQuery--%>
        src="http://code.jquery.com/jquery-3.2.1.js"
        integrity="sha256-DZAnKJ/6XZ9si04Hgrsxu/8s717jcIzLy3oi35EouyE="
        crossorigin="anonymous"></script>
<script type="text/javascript" src="JsFunctions.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
</html>