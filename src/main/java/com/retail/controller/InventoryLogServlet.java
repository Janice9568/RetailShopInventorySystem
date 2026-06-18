package com.retail.controller;

import com.retail.model.dao.InventoryLogDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/inventory-logs")
public class InventoryLogServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("logs", new InventoryLogDAO().getAllLogs());
        request.getRequestDispatcher("WEB-INF/views/inventory/inventory-log.jsp").forward(request, response);
    }
}