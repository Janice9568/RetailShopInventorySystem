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
        // Accessing the hidden JSP inside WEB-INF
        request.getRequestDispatcher("WEB-INF/views/auth/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Ensure support for special characters in names
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");

        // Update the bean with new form data
        currentUser.setFullName(request.getParameter("fullName"));
        currentUser.setPhone(request.getParameter("phone"));
        currentUser.setEmail(request.getParameter("email"));

        // Call the missing method in DAO
        if (userDAO.updateProfile(currentUser)) {
            // Update the session bean so the header shows the new name immediately
            session.setAttribute("currentUser", currentUser);
            response.sendRedirect(request.getContextPath() + "/profile?msg=updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/profile?msg=error");
        }
    }
}