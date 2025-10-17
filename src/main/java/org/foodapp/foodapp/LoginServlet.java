package org.foodapp.foodapp;
import org.foodapp.foodapp.UserDAO;
import org.foodapp.foodapp.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO = new UserDAO(); // Uses the MOCKED DAO

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        User user = userDAO.authenticateUser(username, password); // Will use the MOCK logic

        if (user != null) {
            // Success
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("loggedIn", true);

            // Redirect to MenuServlet
            response.sendRedirect("menu");
        } else {
            // Failure
            request.setAttribute("errorMessage", "Invalid username or password. Use testuser/pass.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
