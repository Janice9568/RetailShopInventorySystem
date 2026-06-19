package com.retail.controller;

import com.retail.model.bean.User;
import com.retail.model.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/users")
public class UserServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            userDAO.deleteUser(id);
            // Redirect to the URL so the list refreshes
            response.sendRedirect(request.getContextPath() + "/users?msg=deleted");
            return;
        }

        // Fetch fresh data from DB every time page is viewed
        request.setAttribute("staffList", userDAO.getAllStaff());
        request.getRequestDispatcher("WEB-INF/views/auth/user-management.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("formAction");

        if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("userId"));
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            userDAO.updateStaffContact(id, phone, email);
        } else {
            User u = new User();
            u.setFullName(request.getParameter("fullName"));
            u.setUsername(request.getParameter("username"));
            u.setPassword(request.getParameter("password"));
            u.setRole(request.getParameter("role"));
            u.setPhone(request.getParameter("phone"));
            u.setEmail(request.getParameter("email"));
            userDAO.registerUser(u);
        }

        // Use redirect to clear the POST data and refresh the GET view
        response.sendRedirect(request.getContextPath() + "/users?msg=success");
    }
}