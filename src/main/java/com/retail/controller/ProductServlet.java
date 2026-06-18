package com.retail.controller;

import com.retail.model.bean.Product;
import com.retail.model.bean.Supplier;
import com.retail.model.dao.ProductDAO;
import com.retail.model.dao.SupplierDAO;
import com.retail.model.dao.CategoryDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/products")
public class ProductServlet extends HttpServlet {
    private ProductDAO productDAO = new ProductDAO();
    private SupplierDAO supplierDAO = new SupplierDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "new":
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                int id = Integer.parseInt(request.getParameter("id"));
                productDAO.deleteProduct(id);
                response.sendRedirect("products");
                break;
            default:
                request.setAttribute("productList", productDAO.getAllProducts());
                request.getRequestDispatcher("WEB-INF/views/product/product-list.jsp").forward(request, response);
                break;
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id = request.getParameter("id");
        if (id != null) {
            Product existingProduct = productDAO.getProductById(Integer.parseInt(id));
            request.setAttribute("product", existingProduct);
        }
        request.setAttribute("suppliers", supplierDAO.getAllSuppliers());
        request.setAttribute("categories", categoryDAO.getAllCategories()); // Dynamic Categories
        request.getRequestDispatcher("WEB-INF/views/product/product-form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String idStr = request.getParameter("productId");

        Product product = new Product();
        product.setProductName(request.getParameter("productName"));
        product.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
        product.setSupplierId(Integer.parseInt(request.getParameter("supplierId")));
        product.setModel(request.getParameter("model"));
        product.setPrice(Double.parseDouble(request.getParameter("price")));
        product.setLowStockThreshold(Integer.parseInt(request.getParameter("lowStockThreshold")));

        if (idStr == null || idStr.trim().isEmpty()) {
            product.setStockQuantity(Integer.parseInt(request.getParameter("stockQuantity")));
            productDAO.addProduct(product);
        } else {
            product.setProductId(Integer.parseInt(idStr));
            productDAO.updateProduct(product);
        }
        response.sendRedirect("products");
    }
}