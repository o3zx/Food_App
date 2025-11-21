package org.foodapp.foodapp;

import org.foodapp.foodapp.User;
import org.foodapp.foodapp.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login") // This matches the form action we will set
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        UserDAO userDAO = new UserDAO();
        User user = userDAO.authenticateUser(username, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("loggedIn", true);

            // 4. Role-Based Redirects (Moved from JSP)
            if ("ADMIN".equals(user.getRole())) {
                response.sendRedirect("adminDashboard.jsp");
            } else if ("DRIVER".equals(user.getRole())) {
                response.sendRedirect("driverDashboard.jsp");
            } else {
                response.sendRedirect("menu.jsp");
            }

        } else {
            // 5. Error Handling
            // Instead of setting a local string, we attach it to the request
            request.setAttribute("errorMessage", "Invalid username or password.");

            // Forward back to the JSP to show the error
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
}