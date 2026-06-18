package com.retail.controller;

import com.retail.model.bean.SaleItem;
import com.retail.model.bean.Sale;
import com.retail.model.dao.ReportDAO;
import com.retail.model.dao.ProductDAO; // 假设你的低库存DAO在这里，若没有可根据你实际的DAO包名调整

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ReportServlet", urlPatterns = {"/reports"})
public class ReportServlet extends HttpServlet {

    private ReportDAO reportDAO;

    @Override
    public void init() {
        reportDAO = new ReportDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        // 💡 1. 兜底防护：如果前端没传日期，默认卡死在今天 (2026-06-18)
        if (startDate == null || startDate.trim().isEmpty() || endDate == null || endDate.trim().isEmpty()) {
            startDate = "2026-06-18";
            endDate = "2026-06-18";
        }

        // 💡 2. 强力阻断：如果前端发来了 Today 专属指令标记 (isTodayScope == true)
        // 强制把作用域抹杀到只有今天单日！
        String isTodayScope = request.getParameter("isTodayScope");
        if ("true".equals(isTodayScope)) {
            startDate = "2026-06-18";
            endDate = "2026-06-18";
        }

        request.setAttribute("selectedStartDate", startDate);
        request.setAttribute("selectedEndDate", endDate);

        if ("printReport".equals(action)) {
            List<SaleItem> detailedSales = reportDAO.getDetailedSalesRows(startDate, endDate);
            request.setAttribute("detailedSales", detailedSales);

            // 💡 绝杀修复 1：把日期死死塞回给 print-report.jsp 页面，让 "Date Range:" 不再空白！
            request.setAttribute("startDate", startDate);
            request.setAttribute("endDate", endDate);

            request.getRequestDispatcher("/WEB-INF/views/reports/print-report.jsp").forward(request, response);

        } else {
            // 💡 4. 处理主看板（salesSummary）渲染分支
            Map<String, Double> salesData = reportDAO.getSalesSummary(startDate, endDate);
            List<SaleItem> detailedSales = reportDAO.getDetailedSalesRows(startDate, endDate);
            Map<String, Integer> performanceData = reportDAO.getProductPerformance();
            List<Sale> salesList = reportDAO.getFilteredSalesList(startDate, endDate);

            request.setAttribute("salesData", salesData);
            request.setAttribute("detailedSales", detailedSales);
            request.setAttribute("performanceData", performanceData);
            request.setAttribute("salesList", salesList);

            // 顺便把低库存报警数据带过去（根据你实际项目补齐）
            request.getRequestDispatcher("/WEB-INF/views/reports/sales-report.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}