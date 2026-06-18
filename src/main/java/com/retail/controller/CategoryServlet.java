package com.retail.controller;

import com.retail.model.dao.CategoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/categories")
public class CategoryServlet extends HttpServlet {
    private CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            categoryDAO.deleteCategory(Integer.parseInt(request.getParameter("id")));
            response.sendRedirect(request.getContextPath() + "/categories?msg=deleted");
            return;
        }
        request.setAttribute("categoryList", categoryDAO.getAllCategories());
        request.getRequestDispatcher("WEB-INF/views/product/category-management.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        String idStr = request.getParameter("categoryId");
        String name = request.getParameter("categoryName");

        boolean success;
        if (idStr == null || idStr.trim().isEmpty()) {
            success = categoryDAO.addCategory(name);
        } else {
            success = categoryDAO.updateCategory(Integer.parseInt(idStr), name);
        }

        if (success) {
            response.sendRedirect(request.getContextPath() + "/categories?msg=success");
        } else {
            response.sendRedirect(request.getContextPath() + "/categories?msg=error");
        }
    }
}