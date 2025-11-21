package org.foodapp.foodapp.Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/logout") // This maps the servlet to the URL "/logout"
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Get the current session (if it exists)
        HttpSession session = request.getSession(false); // false = don't create a new one if none exists

        if (session != null) {
            // 2. Destroy it
            session.invalidate();
        }

        // 3. Redirect to login page
        response.sendRedirect("login.jsp");
    }
}