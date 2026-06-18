package com.retail.controller;

import com.retail.model.bean.User;
import com.retail.model.dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/inventory")
public class InventoryServlet extends HttpServlet {
    private ProductDAO productDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("productList", productDAO.getAllProducts());
        request.getRequestDispatcher("WEB-INF/views/inventory/stock-update.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("currentUser");

        int productId = Integer.parseInt(request.getParameter("productId"));
        int changeQty = Integer.parseInt(request.getParameter("changeQty"));
        String reason = request.getParameter("reason");

        // FR3.1: Update stock and log transaction
        boolean success = productDAO.updateStock(productId, changeQty, user.getUserId(), reason);

        if (success) {
            response.sendRedirect("inventory?success=Stock Updated");
        } else {
            response.sendRedirect("inventory?error=Update Failed");
        }
    }
}