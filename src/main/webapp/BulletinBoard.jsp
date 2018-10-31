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
        LoginInfo loginInfo = (LoginInfo) request.getAttribute("LoginInfo");
//            System.out.println("JSP map is empty?:"+request.getParameterMap().isEmpty());

        if (loginInfo.getStatus() != null) {
            if (!(loginInfo.getStatus().equalsIgnoreCase("ok"))) {
                out.println("" +
                        "<form method=\"POST\"\n" +
                        "   action=\"https://api.worldoftanks.ru/wot/auth/login/?application_id=" +
                        loginInfo.getApplicationId() +
//                    "               4e67660611202f132151e26f8cce5a27" +
                        "&redirect_uri=http://" +
//                    "               localhost:8080/BulletinBoard" +
                        loginInfo.getDomainName() + ":" + loginInfo.getServerPort() +
                        "\">" +
                        "   <button type=\"submit\">Войти</button>\n" +
                        "</form>");
            } else {
//                out.println("" +
//                        "<form method=\"POST\"\n" +
//                        "   action=\"https://api.worldoftanks.ru/wot/auth/logout/?application_id=" +
//                        loginInfo.getApplicationId() +
//                        "&access_token=" +
//                        loginInfo.getAccess_token() +
////                        "&redirect_uri=http://" +loginInfo.getDomainName() + ":" + loginInfo.getServerPort() +
//                        "\">" +
//                        "   <button type=\"submit\">Выйти</button>\n" +
//                        "</form>");

                out.println("" +
                        "<form method=\"POST\"\n" +
                        "   action=\"http://" +loginInfo.getDomainName() + ":" + loginInfo.getServerPort() +
                        "/Logout"+
                        "\">" +
                        "   <button type=\"submit\">Выйти</button>\n" +
                        "</form>");


            }

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
            loginInfo = (LoginInfo) request.getAttribute("LoginInfo");
//            System.out.println("JSP map is empty?:"+request.getParameterMap().isEmpty());
            System.out.println("status at JSP:" + loginInfo.getStatus());
            if (loginInfo.getStatus() != null) {
                if (loginInfo.getStatus().equalsIgnoreCase("ok")) {

                    out.println(loginInfo.getNickname());
                    out.println(loginInfo.getAccount_id());
                    out.println("До: " + loginInfo.getExpires_at());
                    out.println(loginInfo.getAccess_token());
                    out.println(loginInfo.getStatus());

                } else { //клиент пока не авторизован
                    out.println("Auth_Status: " + loginInfo.getStatus());
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

        <%--panel_begin--%>
        <div class="js-filters-zone-fakeblock" style="height: 111px;"><div class="b-filters-zone js-filters-zone">
            <div class="b-filters clearfix js-filters">
                <div class="b-filters-bg">
                    <div class="b-filters-wrapper clearfix">
                        <ul class="b-filters-link-wrpr">
                            <li id="js-rss" class="b-filters-link_item">
                                <a href="#" class="b-filters-link b-filters-link__rss js-visible-wnd">
                                    <span>RSS</span>
                                    <span class="b-filters-link_arr"></span>
                                </a>
                                <ul class="b-dropdown-menu b-dropdown-menu__small js-expand-wnd js-expand-wnd__center js-hidden">
                                    <li class="b-dropdown-menu_item">
                                        <a href="http://wargag.ru/rss/" class="b-dropdown-menu_link" id="js-rss_link_all">Всё</a>
                                    </li>
                                    <li class="b-dropdown-menu_item">
                                        <a href="http://wargag.ru/rss/post/" class="b-dropdown-menu_link" id="js-rss_link_posts">Пост</a>
                                    </li>
                                    <li class="b-dropdown-menu_item">
                                        <a href="http://wargag.ru/rss/picture/" class="b-dropdown-menu_link" id="js-rss_link_pictures">Картинки</a>
                                    </li>
                                    <li class="b-dropdown-menu_item">
                                        <a href="http://wargag.ru/rss/quote/" class="b-dropdown-menu_link" id="js-rss_link_quotes">Цитаты</a>
                                    </li>
                                </ul>
                            </li>
                        </ul>

                        <div class="b-filters-content js-filters-wrapper">
                            <form action="/" method="post" onsubmit="return false;">
                                <div class="b-filters-separator b-filters-separator__right b-filters-separator__nobg js-filters-block">
                                    <div class="b-button b-button__add" id="js-add">
                                        <a href="#" class="b-button_right b-button_right__add js-visible-wnd">
                                            <span class="b-button-txt">Добавить</span>
                                        </a>
                                        <%--<ul class="b-dropdown-menu js-expand-wnd js-expand-wnd__center js-hidden">--%>
                                            <%--<li class="b-dropdown-menu_item">--%>
                                                <%--<a href="/login/?add_content=post" class="b-dropdown-menu_link "><span class="b-ico-add b-ico-add__vid">+</span>Пост</a>--%>
                                            <%--</li>--%>
                                            <%--<li class="b-dropdown-menu_item">--%>
                                                <%--<a href="/login/?add_content=picture" class="b-dropdown-menu_link "><span class="b-ico-add b-ico-add__img">+</span>Картинку</a>--%>
                                            <%--</li>--%>
                                            <%--<li class="b-dropdown-menu_item">--%>
                                                <%--<a href="/login/?add_content=quote" class="b-dropdown-menu_link "><span class="b-ico-add b-ico-add__quot">+</span>Цитату</a>--%>
                                            <%--</li>--%>
                                        <%--</ul>--%>
                                    </div>
                                </div>
                                <div class="b-filters-separator b-filters-separator__noindent-top b-filters-separator__noindent-left b-filters-filter-big js-filters-block" style="min-width: 368px;">
                                    <ul class="b-filters-filter js-filters-list" id="filter_root_tag" style="display: block;">
                                        <li class="b-filters-filter_item b-filters-filter_item__all b-filters-filter_item__current">
                                            <a href="" class="b-filters-filter_link js-filters-filter_link" data-filter=".js-content-item" root-tag-id="0">Все</a>
                                        </li>
                                        <li class="b-filters-filter_item b-filters-filter_item__1 ">
                                            <a href="" class="b-filters-filter_link js-filters-filter_link" data-filter=".js-content-item__rt1" root-tag-code="wot" root-tag-id="1">
                                                <span class="b-filters-filter_ico b-filters-filter_ico__1"><img alt="1" src="http://wargagstatic.wargaming.net/f/fc99b0db176315f25503db626e5635e155ed9559682217.67713248.png"></span>
                                                <span>WoT</span>
                                            </a>
                                        </li>
                                        <li class="b-filters-filter_item b-filters-filter_item__2 ">
                                            <a href="" class="b-filters-filter_link js-filters-filter_link" data-filter=".js-content-item__rt2" root-tag-code="wowp" root-tag-id="2">
                                                <span class="b-filters-filter_ico b-filters-filter_ico__2"><img alt="2" src="http://wargagstatic.wargaming.net/7/7310e2709514512e6ac76cc546f0ab3955ed958807df65.14380222.png"></span>
                                                <span>WoWP</span>
                                            </a>
                                        </li>
                                        <li class="b-filters-filter_item b-filters-filter_item__3 ">
                                            <a href="" class="b-filters-filter_link js-filters-filter_link" data-filter=".js-content-item__rt3" root-tag-code="wows" root-tag-id="3">
                                                <span class="b-filters-filter_ico b-filters-filter_ico__3"><img alt="3" src="http://wargagstatic.wargaming.net/3/34085e2d6c0bfd2b3441b785db38d25455ed8caf335582.22727016.png"></span>
                                                <span>WoWS</span>
                                            </a>
                                        </li>
                                        <li class="b-filters-filter_item b-filters-filter_item__7 ">
                                            <a href="" class="b-filters-filter_link js-filters-filter_link" data-filter=".js-content-item__rt7" root-tag-code="wg" root-tag-id="7">
                                                <span class="b-filters-filter_ico b-filters-filter_ico__7"><img alt="7" src="http://wargagstatic.wargaming.net/0/04f73a0bd91616b94d3017b882c2d1c855ed8ccbdbe884.09850047.png"></span>
                                                <span>WG</span>
                                            </a>
                                        </li>
                                        <li class="b-filters-filter_item b-filters-filter_item__other js-filters-other" id="js-other" style="display: none;">
                                            <a href="" class="b-filters-filter_link b-filters-filter_link__other js-visible-wnd">
                                                Другие<span class="b-filters-arrow"></span>
                                            </a>
                                            <ul class="b-dropdown-menu b-dropdown-menu__filter js-expand-wnd js-hidden">
                                                <li class="b-dropdown-menu_item js-filters-other-list_item ">
                                                    <a href="#" class="b-dropdown-menu_link js-filters-other-rt" data-tag-code="wot" data-tag-id="1">
                                                        <span class="b-filters-filter_ico b-filters-filter_ico__1"><img alt="1" src="http://wargagstatic.wargaming.net/f/fc99b0db176315f25503db626e5635e155ed9559682217.67713248.png"></span>
                                                        <span>WoT</span>
                                                    </a>
                                                </li>
                                                <li class="b-dropdown-menu_item js-filters-other-list_item ">
                                                    <a href="#" class="b-dropdown-menu_link js-filters-other-rt" data-tag-code="wowp" data-tag-id="2">
                                                        <span class="b-filters-filter_ico b-filters-filter_ico__2"><img alt="2" src="http://wargagstatic.wargaming.net/7/7310e2709514512e6ac76cc546f0ab3955ed958807df65.14380222.png"></span>
                                                        <span>WoWP</span>
                                                    </a>
                                                </li>
                                                <li class="b-dropdown-menu_item js-filters-other-list_item ">
                                                    <a href="#" class="b-dropdown-menu_link js-filters-other-rt" data-tag-code="wows" data-tag-id="3">
                                                        <span class="b-filters-filter_ico b-filters-filter_ico__3"><img alt="3" src="http://wargagstatic.wargaming.net/3/34085e2d6c0bfd2b3441b785db38d25455ed8caf335582.22727016.png"></span>
                                                        <span>WoWS</span>
                                                    </a>
                                                </li>
                                                <li class="b-dropdown-menu_item js-filters-other-list_item ">
                                                    <a href="#" class="b-dropdown-menu_link js-filters-other-rt" data-tag-code="wg" data-tag-id="7">
                                                        <span class="b-filters-filter_ico b-filters-filter_ico__7"><img alt="7" src="http://wargagstatic.wargaming.net/0/04f73a0bd91616b94d3017b882c2d1c855ed8ccbdbe884.09850047.png"></span>
                                                        <span>WG</span>
                                                    </a>
                                                </li>
                                            </ul>
                                        </li>
                                    </ul>
                                </div>


                                <div class="b-filters-separator b-filters-filter-date js-filters-open js-filters-block js-filter-orderby">
                                    <div class="b-ondate-selectbox">
                                        <div tabindex="1" class="b-selectbox" style="width: 85px;"><select id="filter_order_by" name="order_by" class="js-wg_combobox-activated" style="display: none;">
                                            <option value="date" class="js-filter_orderby_option_date js-wg_combobox-activated js-wg-state-selected" selected="selected">по дате</option>
                                            <option value="rating" class="js-ondate js-filter_orderby_option_rating js-wg_combobox-activated">по рейтингу</option>
                                            <option value="random" class="js-filter_orderby_option_random js-wg_combobox-activated">случайно</option>
                                        </select><div class="b-selectbox_text"><span>по дате</span></div><span class="b-selectbox_arrow-bar"><a class="b-selectbox_arrow"></a></span></div>
                                    </div>
                                    <div class="b-ondate-ico js-ondate-ico" id="js-ondate-ico_link" style="display: none;">
                                        <a href="" class="js-visible-wnd b-ondate-ico_link "></a>
                                        <ul id="filter_last_time" class="b-dropdown-menu js-expand-wnd js-expand-wnd__center js-hidden">
                                            <li class="b-dropdown-menu_item ">
                                                <a class="b-dropdown-menu_link js-filter_date " href="#" name="last_day">за день</a>
                                            </li>
                                            <li class="b-dropdown-menu_item ">
                                                <a class="b-dropdown-menu_link js-filter_date " href="#" name="last_week">за неделю</a>
                                            </li>
                                            <li class="b-dropdown-menu_item ">
                                                <a class="b-dropdown-menu_link js-filter_date " href="#" name="last_month">за месяц</a>
                                            </li>
                                            <li class="b-dropdown-menu_item ">
                                                <a class="b-dropdown-menu_link js-filter_date " href="#" name="last_year">за год</a>
                                            </li>
                                            <li class="b-dropdown-menu_item b-dropdown-menu_item__current">
                                                <a class="b-dropdown-menu_link js-filter_date js-filter_date__current" href="#" name="all_time">за все время</a>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                                <div class="b-filters-separator b-filters-separator__indent-top b-filters-separator__nobg b-filters-filter-nonegative js-filters-open js-update-content-onlclick js-filters-block js-filter-only-positive-rating">
                                    <div tabindex="1" class="b-checkbox"><input type="checkbox" id="filter_only_positive_rating" name="only_positive_rating" class="js-wg_combobox-activated" style="display: none;"><span class="b-checkbox_checker"></span></div>
                                    <label class="b-form_label__checkbox b-combobox-label" for="filter_only_positive_rating">
                                        Без <span class="b-txt-bigres">минусов</span><span class="b-txt-minres">«−»</span>
                                    </label>
                                </div>
                                <div class="b-filters-separator b-filters-separator__overflow js-filters-search js-filters-block" style="display: block; width: auto;">
                                    <div class="b-input-clear-wrpr js-input-clear-wrpr">
                                        <input id="filter_search_query" class="b-form_input b-form_input__search js-input-clear" maxlength="250" value="" type="text" name="search_query" autocomplete="off"><a class="b-search-clear" href="#" style="display: none;">x</a>
                                        <input type="submit" value="" class="b-form_button__search">
                                    </div>
                                </div>
                                <input type="hidden" name="content_type" id="filter_content_type" value="">
                            </form>
                        </div>

                    </div>
                </div>
            </div>
        </div></div>
        <%--panel_end--%>


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