<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>RetailPOS System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        body { background-color: #f8f9fa; min-height: 100vh; display: flex; flex-direction: column; }
        .navbar-brand { font-weight: bold; }
        footer { margin-top: auto; }
        /* Style for the profile dropdown */
        .user-dropdown .dropdown-toggle::after { vertical-align: middle; }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/dashboard">
            <i class="bi bi-shop"></i> RetailPOS
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>

                <c:if test="${currentUser.role == 'CASHIER' || currentUser.role == 'OWNER'}">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown">Sales</a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/sales?action=pos">New Sale (POS)</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/sales?action=history">Sales History</a></li>
                        </ul>
                    </li>
                </c:if>

                <c:if test="${currentUser.role == 'INVENTORY_STAFF' || currentUser.role == 'OWNER'}">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown">Inventory</a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/products">Products List</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/inventory">Update Stock</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/inventory-logs">Inventory Logs</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/reports?action=lowStock">Low-Stock Report</a></li>
                        </ul>
                    </li>
                </c:if>

                <c:if test="${currentUser.role == 'OWNER'}">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown">Administration</a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/reports?action=salesSummary">Sales Reports</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/reports?action=performance">Performance</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/categories"><i class="bi bi-tags"></i> Manage Categories</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/suppliers">Suppliers</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/users">Staff Management</a></li>
                        </ul>
                    </li>
                </c:if>
            </ul>

            <!-- User Profile Dropdown Section -->
            <div class="user-dropdown">
                <div class="dropdown">
                    <button class="btn btn-outline-light dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="bi bi-person-circle"></i> ${currentUser.fullName}
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end shadow">
                        <li><h6 class="dropdown-header">User: ${currentUser.username}</h6></li>
                        <li><span class="dropdown-item-text small text-muted">Role: ${currentUser.role}</span></li>
                        <li><hr class="dropdown-divider"></li>
                        <li>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/profile">
                                <i class="bi bi-person-gear"></i> My Profile
                            </a>
                        </li>
                        <li>
                            <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">
                                <i class="bi bi-box-arrow-right"></i> Logout
                            </a>
                        </li>
                    </ul>
                </div>
            </div>

        </div>
    </div>
</nav>