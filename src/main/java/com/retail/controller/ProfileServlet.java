package com.retail.controller;

import com.retail.model.bean.User;
import com.retail.model.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Just forward to the profile page
        request.getRequestDispatcher("WEB-INF/views/auth/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser != null) {
            currentUser.setFullName(request.getParameter("fullName"));
            currentUser.setPhone(request.getParameter("phone"));
            currentUser.setEmail(request.getParameter("email"));

            if (userDAO.updateProfile(currentUser)) {
                session.setAttribute("currentUser", currentUser); // Refresh session data
                response.sendRedirect("profile?msg=updated");
            } else {
                response.sendRedirect("profile?msg=error");
            }
        }
    }
}