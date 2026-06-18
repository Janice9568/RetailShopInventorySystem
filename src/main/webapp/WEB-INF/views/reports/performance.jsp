<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../common/header.jsp" />

<div class="row">
    <div class="col-md-7">
        <div class="card shadow-sm">
            <div class="card-header bg-info text-white">Best Selling Products (Top Performance)</div>
            <div class="card-body">
                <ul class="list-group list-group-flush">
                    <c:forEach var="entry" items="${performanceData}">
                        <li class="list-group-item d-flex justify-content-between align-items-center">
                                ${entry.key}
                            <span class="badge bg-primary rounded-pill">${entry.value} Units Sold</span>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </div>
    </div>

    <div class="col-md-5">
        <div class="card shadow-sm">
            <div class="card-header bg-dark text-white">Inventory Summary</div>
            <div class="card-body">
                <table class="table table-sm">
                    <tr>
                        <td>Total Product Varieties:</td>
                        <td class="text-end fw-bold">${totalProducts}</td>
                    </tr>
                    <tr>
                        <td>Low Stock Alerts:</td>
                        <td class="text-end fw-bold text-danger">${lowStockCount}</td>
                    </tr>
                </table>
                <hr>
                <div class="d-grid gap-2">
                    <button onclick="window.print()" class="btn btn-outline-secondary">
                        <i class="bi bi-printer"></i> Print Report
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />