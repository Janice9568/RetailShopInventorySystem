package com.retail.controller;

import com.retail.model.bean.Supplier;
import com.retail.model.dao.SupplierDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/suppliers")
public class SupplierServlet extends HttpServlet {
    private SupplierDAO supplierDAO = new SupplierDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            supplierDAO.deleteSupplier(Integer.parseInt(request.getParameter("id")));
            response.sendRedirect(request.getContextPath() + "/suppliers?msg=success");
            return;
        }else if ("view".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Supplier s = supplierDAO.getSupplierById(id);
            request.setAttribute("supplier", s);
            request.getRequestDispatcher("WEB-INF/views/product/supplier-view.jsp").forward(request, response);
            return;
        }
        request.setAttribute("supplierList", supplierDAO.getAllSuppliers());
        request.getRequestDispatcher("WEB-INF/views/product/supplier-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String idStr = request.getParameter("supplierId");

        Supplier s = new Supplier();
        s.setSupplierName(request.getParameter("supplierName"));
        s.setContactPerson(request.getParameter("contactPerson"));
        s.setPhone(request.getParameter("phone"));
        s.setEmail(request.getParameter("email"));
        s.setAddress(request.getParameter("address"));

        if (idStr == null || idStr.trim().isEmpty()) {
            supplierDAO.addSupplier(s);
        } else {
            s.setSupplierId(Integer.parseInt(idStr));
            supplierDAO.updateSupplier(s);
        }
        response.sendRedirect(request.getContextPath() + "/suppliers?msg=success");
    }
}