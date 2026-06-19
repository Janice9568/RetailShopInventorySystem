package com.retail.controller;

import com.retail.model.bean.Product;
import com.retail.model.bean.Sale;
import com.retail.model.bean.SaleItem;
import com.retail.model.bean.User;
import com.retail.model.dao.ProductDAO;
import com.retail.model.dao.SalesDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/sales")
public class SalesServlet extends HttpServlet {
    private SalesDAO salesDAO;
    private ProductDAO productDAO;

    @Override
    public void init() {
        salesDAO = new SalesDAO();
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "pos";

        switch (action) {
            case "pos":
                List<Product> products = productDAO.getAllProducts();
                request.setAttribute("products", products);
                request.getRequestDispatcher("WEB-INF/views/sales/pos.jsp").forward(request, response);
                break;

            case "status":
                request.getRequestDispatcher("WEB-INF/views/sales/payment-status.jsp").forward(request, response);
                break;

            case "history":
                // Fetch updated sales with defensive LEFT JOIN structural mapping rules applied
                List<Sale> salesList = salesDAO.getAllSales();
                request.setAttribute("salesList", salesList);
                request.getRequestDispatcher("WEB-INF/views/sales/sales-history.jsp").forward(request, response);
                break;

            case "cancel":
                try {
                    int cancelSaleId = Integer.parseInt(request.getParameter("saleId"));
                    String cancelReason = request.getParameter("reason");

                    if (cancelReason == null || cancelReason.trim().isEmpty()) {
                        cancelReason = "Staff Correction / Manual Cancel";
                    }

                    HttpSession session = request.getSession();
                    User currentUser = (User) session.getAttribute("currentUser");
                    int userId = (currentUser != null) ? currentUser.getUserId() : 1;

                    boolean isCancelled = salesDAO.cancelSaleById(cancelSaleId, userId, cancelReason);

                    if (isCancelled) {
                        response.sendRedirect("sales?action=history&msg=Order Cancelled and Stock Restored Successfully!");
                    } else {
                        response.sendRedirect("sales?action=history&error=Cancellation Failed");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendRedirect("sales?action=history&error=Invalid Request");
                }
                break;

            case "updatePayment":
                try {
                    int saleId = Integer.parseInt(request.getParameter("id"));
                    String status = request.getParameter("status");
                    String method = request.getParameter("method");
                    salesDAO.updatePaymentStatus(saleId, status, method);
                    response.sendRedirect("sales?action=history");
                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendRedirect("sales?action=history&error=Invalid Update Data");
                }
                break;

            default:
                response.sendRedirect("dashboard");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("currentUser");

        // Fallback context validation if testing without active login session cookies
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // 🔥 FIXED: Capture action type parameters sent via hidden POS inputs safely
        String action = request.getParameter("action");

        String[] productIds = request.getParameterValues("productId[]");
        String[] quantities = request.getParameterValues("qty[]");
        String paymentMethod = request.getParameter("paymentMethod");
        String paymentStatus = request.getParameter("paymentStatus");

        if (productIds == null || productIds.length == 0 || quantities == null || quantities.length == 0) {
            response.sendRedirect("sales?action=pos&error=Cannot confirm an empty sale!");
            return;
        }

        double totalAmount = 0;
        List<SaleItem> items = new ArrayList<>();

        for (int i = 0; i < productIds.length; i++) {
            int pid = Integer.parseInt(productIds[i]);
            int qty = Integer.parseInt(quantities[i]);
            Product p = productDAO.getProductById(pid);

            if (p != null) {
                SaleItem item = new SaleItem();
                item.setProductId(pid);
                item.setQuantity(qty);
                item.setUnitPrice(p.getPrice());
                item.setSubtotal(p.getPrice() * qty);
                items.add(item);
                totalAmount += item.getSubtotal();
            }
        }

        Sale sale = new Sale();
        sale.setTotalAmount(totalAmount);
        sale.setPaymentMethod(paymentMethod);
        sale.setPaymentStatus(paymentStatus);
        sale.setUserId(user.getUserId());

        // Call updated transaction stack
        boolean success = salesDAO.recordSale(sale, items);

        if (success) {
            session.setAttribute("paymentMethod", paymentMethod);
            session.setAttribute("paymentStatus", paymentStatus);
            session.setAttribute("totalAmount", totalAmount);

            // 🔥 FIXED: Added defensive fallback processing check if ID auto-generation gets delayed by driver settings
            int assignedId = sale.getSaleId();
            session.setAttribute("txnId", "SAL-" + (assignedId > 0 ? assignedId : "TEMP-" + System.currentTimeMillis() / 1000));

            response.sendRedirect("sales?action=status");
        } else {
            response.sendRedirect("sales?action=pos&error=Transaction Failed (Insufficient Stock or DB Constraint Fail)");
        }
    }
}