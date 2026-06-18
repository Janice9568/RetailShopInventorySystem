package com.retail.filter;

import com.retail.model.bean.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter("/*")
public class AuthenticationFilter implements Filter {

    public void init(FilterConfig fConfig) throws ServletException {}

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        String path = req.getServletPath();

        // 1. Public Paths
        if (path.equals("/login") || path.equals("/login.jsp") || path.startsWith("/assets/")) {
            chain.doFilter(request, response);
            return;
        }

        // 2. Auth Check
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // 3. Role Access Logic
        String role = user.getRole();
        boolean authorized = true;

        // CASHIER: Manage sales only
        if (role.equals("CASHIER")) {
            if (path.startsWith("/inventory") || path.startsWith("/products") ||
                    path.startsWith("/suppliers") || path.startsWith("/users") || path.startsWith("/reports")) {
                authorized = false;
            }
        }
        // INVENTORY STAFF: Update inventory and specific reports
        else if (role.equals("INVENTORY_STAFF")) {
            if (path.startsWith("/sales") || path.startsWith("/payments") ||
                    path.startsWith("/suppliers") || path.startsWith("/users")) {
                authorized = false;
            }
            // Report access control for Inventory Staff
            if (path.equals("/reports")) {
                String action = req.getParameter("action");
                // Only allowed to see lowStock report
                if (!"lowStock".equals(action)) {
                    authorized = false;
                }
            }
        }

        if (authorized) {
            chain.doFilter(request, response);
        } else {
            res.sendRedirect(req.getContextPath() + "/dashboard?error=Unauthorized");
        }
    }

    public void destroy() {}
}