<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password | RetailPOS</title>
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
        }
        .reset-card {
            width: 100%;
            max-width: 450px;
        }
    </style>
</head>
<body>

<div class="reset-card px-3">
    <div class="card shadow-lg border-0">
        <div class="card-body p-4 p-md-5">
            <div class="text-center mb-4">
                <h3 class="fw-bold text-primary">Forgot Password?</h3>
                <p class="text-muted small">Verify your identity to set a new password.</p>
            </div>

            <%-- Error Messages --%>
            <c:if test="${param.error == 'empty_fields'}">
                <div class="alert alert-warning py-2 small">All fields are required.</div>
            </c:if>
            <c:if test="${param.error == 'mismatch'}">
                <div class="alert alert-danger py-2 small">New passwords do not match.</div>
            </c:if>
            <c:if test="${param.error == 'invalid_user'}">
                <div class="alert alert-danger py-2 small">Invalid username or email combination.</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/forgot-password" method="post" onsubmit="return validateForm()">
                <div class="mb-3">
                    <label class="form-label small fw-bold text-uppercase">Username</label>
                    <div class="input-group">
                        <span class="input-group-text bg-white"><i class="bi bi-person"></i></span>
                        <input type="text" name="username" class="form-control" placeholder="Your username" required>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label small fw-bold text-uppercase">Registered Email</label>
                    <div class="input-group">
                        <span class="input-group-text bg-white"><i class="bi bi-envelope"></i></span>
                        <input type="email" name="email" class="form-control" placeholder="Email used for registration" required>
                    </div>
                </div>

                <hr class="my-4">

                <div class="mb-3">
                    <label class="form-label small fw-bold text-uppercase">New Password</label>
                    <input type="password" name="newPassword" id="newPassword" class="form-control" placeholder="Enter new password" required>
                </div>

                <div class="mb-4">
                    <label class="form-label small fw-bold text-uppercase">Confirm New Password</label>
                    <input type="password" name="confirmPassword" id="confirmPassword" class="form-control" placeholder="Repeat new password" required>
                </div>

                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-primary btn-lg">Reset Password</button>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-link text-decoration-none">Back to Login</a>
                </div>
            </form>
        </div>
    </div>
    <div class="text-center mt-4">
        <small class="text-muted">Contact the Shop Owner if you cannot remember your email.</small>
    </div>
</div>

<script>
    function validateForm() {
        const p1 = document.getElementById('newPassword').value;
        const p2 = document.getElementById('confirmPassword').value;
        if (p1 !== p2) {
            alert("Passwords do not match!");
            return false;
        }
        return true;
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>