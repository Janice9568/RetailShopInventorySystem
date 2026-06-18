<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="common/header.jsp" />

<div class="row mb-4">
    <div class="col-12">
        <h2 class="fw-bold">Welcome back, ${currentUser.fullName}!</h2>
        <p class="text-muted">Here is what's happening in your shop today.</p>
    </div>
</div>

<!-- Dashboard Stats Cards -->
<div class="row mb-5">
    <div class="col-md-3">
        <div class="card text-white bg-primary shadow">
            <div class="card-body">
                <h6 class="card-title text-uppercase small">Today's Revenue</h6>
                <h2 class="display-6 fw-bold"><fmt:formatNumber value="${todaySales}" type="currency" /></h2>
                <i class="bi bi-cash-stack position-absolute top-0 end-0 m-3 opacity-50 fs-1"></i>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card text-white bg-success shadow">
            <div class="card-body">
                <h6 class="card-title text-uppercase small">Transactions</h6>
                <h2 class="display-6 fw-bold">${todayTransactions}</h2>
                <i class="bi bi-receipt position-absolute top-0 end-0 m-3 opacity-50 fs-1"></i>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card text-white bg-warning shadow">
            <div class="card-body">
                <h6 class="card-title text-uppercase small">Low Stock Items</h6>
                <h2 class="display-6 fw-bold">${lowStockCount}</h2>
                <i class="bi bi-exclamation-triangle position-absolute top-0 end-0 m-3 opacity-50 fs-1"></i>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card text-white bg-info shadow">
            <div class="card-body">
                <h6 class="card-title text-uppercase small">Total Products</h6>
                <h2 class="display-6 fw-bold">${totalProducts}</h2>
                <i class="bi bi-box-seam position-absolute top-0 end-0 m-3 opacity-50 fs-1"></i>
            </div>
        </div>
    </div>
</div>

<!-- Quick Actions -->
<div class="row">
    <div class="col-md-8">
        <div class="card shadow-sm mb-4">
            <div class="card-header bg-white fw-bold">System Status</div>
            <div class="card-body">
                <p>All systems are operational. You have <strong>${lowStockCount}</strong> items that need restocking.</p>
                <div class="d-flex gap-2">
                    <a href="sales?action=pos" class="btn btn-outline-primary">Open New Sale</a>
                    <a href="inventory" class="btn btn-outline-secondary">Manage Stock</a>
                    <c:if test="${currentUser.role == 'OWNER'}">
                        <a href="reports" class="btn btn-outline-dark">View Detailed Reports</a>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <div class="col-md-4">
        <div class="card shadow-sm">
            <div class="card-header bg-white fw-bold">Recent Updates</div>
            <div class="list-group list-group-flush">
                <div class="list-group-item">
                    <small class="text-muted d-block">Inventory</small>
                    Stock level alerts are currently active.
                </div>
                <div class="list-group-item">
                    <small class="text-muted d-block">Sales</small>
                    Payment methods: Cash, Card, E-Wallet enabled.
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="common/footer.jsp" />