package com.retail.controller;

import com.retail.model.bean.Sale;
import com.retail.model.bean.SaleItem;
import com.retail.model.dao.SalesDAO;
import com.retail.model.dao.ProductDAO; // 如果需要查商品名字可以引入
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/payments")
public class PaymentServlet extends HttpServlet {
    private SalesDAO salesDAO;

    @Override
    public void init() {
        salesDAO = new SalesDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // 1. 获取从历史记录页传过来的 saleId
            int saleId = Integer.parseInt(request.getParameter("saleId"));

            // 2. 🔥 核心补齐：调用 DAO 去查出这笔订单的完整主表数据 (总价、日期等)
            Sale sale = salesDAO.getSaleById(saleId);

            // 3. 🔥 核心补齐：调用 DAO 去查出这笔订单里面买的所有商品明细
            List<SaleItem> items = salesDAO.getSaleItemsBySaleId(saleId);

            if (sale != null) {
                // 4. 将数据塞进 request 域，让 JSP 页面可以动态读取并显示出来
                request.setAttribute("sale", sale);
                request.setAttribute("saleItems", items);
            } else {
                response.sendRedirect("sales?action=history&error=Sale Not Found");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("sales?action=history&error=Invalid Request");
            return;
        }

        // 转发到我们升级后的超酷修改页
        request.getRequestDispatcher("WEB-INF/views/sales/update-payment.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int saleId = Integer.parseInt(request.getParameter("saleId"));
        String status = request.getParameter("paymentStatus");
        String method = request.getParameter("paymentMethod");

        boolean success = salesDAO.updatePaymentStatus(saleId, status, method);

        if (success) {
            response.sendRedirect("sales?action=history&success=Payment Updated");
        } else {
            response.sendRedirect("sales?action=history&error=Update Failed");
        }
    }
}