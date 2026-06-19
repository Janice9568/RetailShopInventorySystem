<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | RetailPOS</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #f0f2f5;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
        }
        .login-card {
            width: 100%;
            max-width: 400px;
        }
        .card {
            border: none;
            border-radius: 15px;
            padding: 20px;
        }
        .brand-logo {
            font-size: 2.5rem;
            font-weight: 800;
            color: #0d6efd;
        }
    </style>
</head>
<body>

<div class="login-card px-3">
    <div class="card shadow-lg">
        <div class="card-body p-4">
            <div class="text-center mb-4">
                <h1 class="brand-logo mb-0">RetailPOS</h1>
                <p class="text-muted">Please sign in to continue</p>
            </div>

            <%-- Alert for Password Reset Success --%>
            <c:if test="${param.msg == 'reset_success'}">
                <div class="alert alert-success alert-dismissible fade show small py-2" role="alert">
                    <i class="bi bi-check-circle-fill"></i> Password reset! Please login.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <%-- Alert for Login Errors --%>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show small py-2" role="alert">
                    <i class="bi bi-exclamation-triangle-fill"></i> ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="post">
                <div class="mb-3">
                    <label class="form-label small fw-bold">Username</label>
                    <input type="text" name="username" class="form-control form-control-lg" placeholder="Enter username" required autofocus>
                </div>

                <div class="mb-4">
                    <label class="form-label small fw-bold">Password</label>
                    <input type="password" name="password" class="form-control form-control-lg" placeholder="Enter password" required>
                </div>

                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-primary btn-lg fw-bold">Login</button>

                    <%-- FIXED: Added Forgot Password Link --%>
                    <div class="text-center mt-2">
                        <a href="${pageContext.request.contextPath}/forgot-password" class="text-decoration-none small text-muted">
                            Forgot Password?
                        </a>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>