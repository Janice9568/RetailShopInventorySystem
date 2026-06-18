<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../common/header.jsp" />

<div class="alert alert-warning">
    <i class="bi bi-exclamation-triangle-fill"></i>
    The following items have reached or fallen below their minimum stock threshold.
</div>

<div class="card shadow-sm border-danger">
    <div class="card-header bg-danger text-white">Critical Stock Alert</div>
    <div class="card-body">
        <table class="table table-striped">
            <thead>
            <tr>
                <th>Product Name</th>
                <th>Supplier</th>
                <th>Current Stock</th>
                <th>Threshold</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="p" items="${lowStockList}">
                <tr>
                    <td>${p.productName}</td>
                    <td>${p.supplierName}</td>
                    <td class="text-danger fw-bold">${p.stockQuantity}</td>
                    <td>${p.lowStockThreshold}</td>
                    <td>
                        <a href="inventory?productId=${p.productId}" class="btn btn-sm btn-dark">Update Stock</a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />