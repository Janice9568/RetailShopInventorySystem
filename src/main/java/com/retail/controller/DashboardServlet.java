package com.retail.controller;

import com.retail.model.dao.ReportDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private ReportDAO reportDAO;

    @Override
    public void init() {
        reportDAO = new ReportDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Fetch stats for the summary cards
        request.setAttribute("todaySales", reportDAO.getTodaySales());
        request.setAttribute("totalProducts", reportDAO.getTotalProducts());
        request.setAttribute("lowStockCount", reportDAO.getLowStockCount());
        request.setAttribute("todayTransactions", reportDAO.getTodayTransactions());

        // Forward to the dashboard view
        request.getRequestDispatcher("WEB-INF/views/dashboard.jsp").forward(request, response);
    }
}