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

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            userDAO.deleteUser(Integer.parseInt(request.getParameter("id")));
        }
        request.setAttribute("staffList", userDAO.getAllStaff());
        request.getRequestDispatcher("WEB-INF/views/auth/user-management.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");

        User u = new User();
        u.setFullName(request.getParameter("fullName"));
        u.setUsername(request.getParameter("username"));
        u.setPassword(request.getParameter("password"));
        u.setRole(request.getParameter("role"));
        u.setPhone(request.getParameter("phone")); // Capture Phone
        u.setEmail(request.getParameter("email")); // Capture Email

        userDAO.registerUser(u);
        response.sendRedirect("users?msg=added");
    }
}