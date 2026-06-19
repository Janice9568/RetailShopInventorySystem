package com.retail.controller;

import com.retail.model.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward to the reset password page
        request.getRequestDispatcher("WEB-INF/views/auth/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // 1. Basic Server-side Validation
        if (username == null || email == null || newPassword == null || confirmPassword == null ||
                username.isEmpty() || email.isEmpty() || newPassword.isEmpty()) {
            response.sendRedirect("forgot-password?error=empty_fields");
            return;
        }

        // 2. Check if passwords match
        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect("forgot-password?error=mismatch");
            return;
        }

        // 3. Attempt to reset in DB (matches username AND email)
        boolean isReset = userDAO.resetPassword(username, email, newPassword);

        if (isReset) {
            // Success: Redirect to login with success message
            response.sendRedirect("login?msg=reset_success");
        } else {
            // Failure: Username and Email combination didn't match any record
            response.sendRedirect("forgot-password?error=invalid_user");
        }
    }
}