package servlets;

import Classes.Database;

import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RespondsList")
public class RespondsListServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        super.doPost(req, resp);
//        doGet(req,resp);
        System.out.println("RespondsList_POST");
        int advertId = Integer.parseInt(req.getParameter("AdId"));
        System.out.println("advertId: " + advertId);
        //исп.массив,чтобы не терялась ссылка на обьект.
        final Integer[] columnsCount = {0};
        try {
            ArrayList<String> responds = Database.getRespondsList(advertId, columnsCount);
            resp.setContentType("text/html; charset=UTF-8");
            PrintWriter outStream = resp.getWriter();
            /*todo
            Вставить ответ, с разбором запроса:*/
            StringBuilder respondsTable = new StringBuilder();
            respondsTable = respondsTable
                    .append("<table class=\"t_responds\" style=\"width: 600px;\">")
                    .append("<tbody>")
                    .append("<tr>")
                    .append("<th style=\"min-width:50px;\">")
                    .append("<span class=\"measure\">Боец</span>")
                    .append("</th>")
                    .append("<th style=\"min-width:50px; max-width:150px;\">Количество<br>")
                    .append("<span class=\"measure\">боев</span>")
                    .append("</th>")
                    .append("</th>")
                    .append("<th style=\"min-width:50px; max-width:180px;\">Процент побед<br>")
                    .append("<span class=\"measure\">(%)</span>")
                    .append("</th>")
                    .append("<th style=\"min-width:50px; max-width:180px;\">Личный рейтинг<br>")
                    .append("<span class=\"measure\">(WG)</span>")
                    .append("</th>")
                    .append("</tr>");
            for (int i = 0; i < responds.size()+1 / columnsCount[0]; i+=columnsCount[0]) {
                respondsTable
                        .append("<tr>")
                        .append("<td><p><a target=\"_blank\" rel=\"noopener noreferrer\" href=\"https://worldoftanks.ru/ru/community/accounts/")
                        .append(responds.get(i + 1)).append("-")
                        .append(responds.get(i))
                        .append("/\">").append(responds.get(i))
                        .append("</a></p></td>")
                        .append("<td>")
                        .append(responds.get(i + 2))
                        .append("</td>")
                        .append("<td>")
                        .append(responds.get(i + 3))
                        .append("</td>")
                        .append("<td>")
                        .append(responds.get(i + 4))
                        .append("</td>")
                        .append("</tr>");
//                System.out.println(i);

            }
            respondsTable.append("</tbody>")
                    .append("</table>");
            outStream.write(respondsTable.toString());
//            outStream.write(responds.toString().replaceAll("[\\[\\]]",""));
            System.out.println(responds.toString());

            outStream.flush();
            outStream.close();
        } catch (SQLException e) {
            System.out.println("Ошибка получения списка откликов. Объявление ID=" + advertId);
            e.printStackTrace();
        }
    }

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("RespondsList_GET");
//        doPost(request, response);

//        String userName = request.getParameter("userName").trim();
//        if(userName == null || "".equals(userName))
//            userName = "Guest";
//
//        String content = "Привет, " + userName;
//        response.setContentType("text/plain");
//
//        OutputStream outStream = response.getOutputStream();
//        outStream.write(content.getBytes("UTF-8"));
//        outStream.flush();
//        outStream.close();
    }
}