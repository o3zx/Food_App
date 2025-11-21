package org.foodapp.foodapp.Controller;

import org.foodapp.foodapp.User;
import org.foodapp.foodapp.UserDAO;
// NOTE: We do NOT need to import BCrypt here anymore.

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Get Parameters
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String address = request.getParameter("address");

        // 2. Validation
        if (password == null || !password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // 3. Create User Object
        User newUser = new User();
        newUser.setUsername(username);
        newUser.setEmail(email);

        // --- CRITICAL FIX ---
        // Pass the PLAIN TEXT password.
        // Your UserDAO.addUser() method will handle the hashing!
        newUser.setPasswordHash(password);
        // --------------------

        newUser.setAddress(address);
        newUser.setRole("CUSTOMER");

        // 4. Call DAO
        UserDAO userDAO = new UserDAO();
        boolean isSuccess = userDAO.addUser(newUser);

        if (isSuccess) {
            // 5. Success
            response.sendRedirect("login.jsp?success=Registration successful! Please log in.");
        } else {
            // 6. Failure
            request.setAttribute("errorMessage", "Username already taken. Please choose another.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }
}