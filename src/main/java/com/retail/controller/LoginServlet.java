package com.retail.controller;

import com.retail.model.bean.User;
import com.retail.model.dao.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login", "/logout"})
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();

        if ("/logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            // 💡 绝杀修复：登出后，不要直接去撞不存在的 login.jsp
            // 而是重定向去你的 /login 控制器路径，让下面的 else 分支安全转发！
            response.sendRedirect(request.getContextPath() + "/login");

        } else {
            // 💡 顺藤摸瓜：带上你的真实安全视图路径
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userStr = request.getParameter("username");
        String passStr = request.getParameter("password");

        User user = userDAO.authenticate(userStr, passStr);

        // 💡 打印调试（保留你的排查日志）
        System.out.println("=== Grace的登录大排查 ===");
        System.out.println("1. 数据库里查出的用户对象是不是空的?: " + (user == null));
        if (user != null) {
            System.out.println("2. 这个用户的角色(Role)到底是什么?: " + user.getRole());
        }
        System.out.println("========================");

        if (user != null) {
            HttpSession session = request.getSession();

            // 💡 终极绝招：管你的 Filter 要哪个名字，我同时塞进 "currentUser" 和 "user"！
            // 这样不管你的原始 Filter 怎么抓取，都绝对能 100% 验证通过，再也无法拦截你！
            session.setAttribute("currentUser", user);
            session.setAttribute("user", user);

            // Redirect based on role
            switch (user.getRole()) {
                case "OWNER":
                    response.sendRedirect("dashboard");
                    break;
                case "CASHIER":
                    response.sendRedirect("sales?action=pos");
                    break;
                case "INVENTORY_STAFF":
                    response.sendRedirect("products");
                    break;
                default:
                    // 💡 这里的角色未识别也同样重定向回 /login 控制器
                    response.sendRedirect(request.getContextPath() + "/login?error=Role Not Recognized");
            }
        } else {
            request.setAttribute("errorMessage", "Invalid Username or Password");
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
        }
    }
}