package com.retail.filter;

import com.retail.model.bean.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Authentication and Role-Based Access Control Filter.
 * Enforces FR1 (Authentication) and role-specific access for Owner, Cashier, and Staff.
 */
@WebFilter("/*")
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig fConfig) throws ServletException {
        // Initialization logic if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String path = httpRequest.getServletPath();
        String contextPath = httpRequest.getContextPath();

        // 1. Define Publicly Accessible Paths (No Login Required)
        boolean isLoginRequest = path.equals("/login") || path.equals("/login.jsp") || path.equals("/index.jsp");
        boolean isForgotPassword = path.equals("/forgot-password") || path.equals("/forgot-password.jsp");
        boolean isStaticResource = path.startsWith("/assets/");

        if (isLoginRequest || isForgotPassword || isStaticResource) {
            chain.doFilter(request, response);
            return;
        }

        // 2. Authentication Check: Ensure user is logged in
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (user == null) {
            // Not logged in: redirect to login page
            httpResponse.sendRedirect(contextPath + "/login");
            return;
        }

        // 3. Role-Based Access Control (RBAC) Logic
        String role = user.getRole();
        boolean isAuthorized = true;

        // OWNER: Has full access to everything. No restrictions.
        if (role.equals("OWNER")) {
            chain.doFilter(request, response);
            return;
        }

        // CASHIER: Can manage sales only.
        if (role.equals("CASHIER")) {
            // Block access to Inventory, Suppliers, User Management, Reports, and Categories
            if (path.startsWith("/products") ||
                    path.startsWith("/inventory") ||
                    path.startsWith("/inventory-logs") ||
                    path.startsWith("/suppliers") ||
                    path.startsWith("/users") ||
                    path.startsWith("/reports") ||
                    path.startsWith("/categories")) {
                isAuthorized = false;
            }
        }

        // INVENTORY STAFF: Can update inventory and view stock-related reports.
        else if (role.equals("INVENTORY_STAFF")) {
            // Block access to Sales, Payments, Suppliers, and User Management
            if (path.startsWith("/sales") ||
                    path.startsWith("/payments") ||
                    path.startsWith("/suppliers") ||
                    path.startsWith("/users") ||
                    path.startsWith("/categories")) {
                isAuthorized = false;
            }

            // Refined Report access: Only allow Low Stock and Inventory Status
            if (path.startsWith("/reports")) {
                String action = request.getParameter("action");
                // Block financial summaries and product performance
                if (action == null || action.equals("salesSummary") || action.equals("performance")) {
                    isAuthorized = false;
                }
            }
        }

        // 4. Final Decision
        if (isAuthorized) {
            // User is authenticated and authorized for this path
            chain.doFilter(request, response);
        } else {
            // User is logged in but NOT authorized for this specific feature
            // Redirect to dashboard with an error message
            httpResponse.sendRedirect(contextPath + "/dashboard?error=unauthorized_access");
        }
    }

    @Override
    public void destroy() {
        // Cleanup logic if needed
    }
}