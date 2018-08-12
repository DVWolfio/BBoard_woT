package servlets;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Paths;
import java.util.Iterator;
import java.util.Map;

@WebServlet("/start")
public class StartServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        super.doPost(request, response);
        System.out.println("START_SERVLET POST");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

//        response.setContentType("text/html");
//        PrintWriter out = response.getWriter();
        System.out.println("START_SERVLET GET");
//
//        out.println("Hello Word!!!");



        response.setContentType("text/html");

//        RequestDispatcher dispatcher = request.getRequestDispatcher("hello.jsp");
//        RequestDispatcher dispatcher = request.getRequestDispatcher("_index_.html");
        RequestDispatcher dispatcher = request.getRequestDispatcher("BulletinBoard.jsp");
        if (dispatcher != null) {
            dispatcher.forward(request, response);
        }

    }


}