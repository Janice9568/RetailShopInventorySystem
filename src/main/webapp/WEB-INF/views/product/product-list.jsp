<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../common/header.jsp" />

<main class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold"><i class="bi bi-box-seam"></i> Product Inventory</h3>
        <c:if test="${currentUser.role == 'OWNER'}">
            <a href="${pageContext.request.contextPath}/products?action=new" class="btn btn-primary shadow-sm">
                <i class="bi bi-plus-circle"></i> Add New Product
            </a>
        </c:if>
    </div>

    <div class="card shadow-sm border-0">
        <div class="card-body p-0">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-dark">
                <tr>
                    <th class="ps-3">Product Name</th>
                    <th>Category</th>
                    <th>Model/Brand</th>
                    <th class="text-end">Price</th>
                    <th class="text-center">Stock</th>
                    <c:if test="${currentUser.role == 'OWNER'}">
                        <th class="text-center">Actions</th>
                    </c:if>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="p" items="${productList}">
                    <tr class="${p.stockQuantity <= p.lowStockThreshold ? 'table-danger' : ''}">
                        <td class="ps-3">
                            <strong>${p.productName}</strong>
                            <c:if test="${p.stockQuantity <= p.lowStockThreshold}">
                                <span class="badge bg-danger ms-1">LOW</span>
                            </c:if>
                        </td>
                        <td>${p.categoryName}</td>
                        <td>${p.model}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/suppliers?action=view&id=${p.supplierId}"
                               class="text-decoration-none fw-bold text-dark">
                                <i class="bi bi-info-circle small"></i> ${p.supplierName}
                            </a>
                        </td>
                        <td class="text-end">RM <fmt:formatNumber value="${p.price}" minFractionDigits="2" /></td>
                        <td class="text-center">
                            <span class="fw-bold">${p.stockQuantity}</span>
                        </td>
                        <c:if test="${currentUser.role == 'OWNER'}">
                            <td class="text-center">
                                <a href="${pageContext.request.contextPath}/products?action=edit&id=${p.productId}" class="btn btn-sm btn-outline-primary">
                                    <i class="bi bi-pencil"></i> Edit
                                </a>
                            </td>
                        </c:if>
                    </tr>
                </c:forEach>
                <c:if test="${empty productList}">
                    <tr><td colspan="6" class="text-center py-5 text-muted">No products found in inventory.</td></tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />