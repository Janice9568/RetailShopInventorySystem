<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../common/header.jsp" />

<main class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold">
            <i class="bi bi-box-seam"></i> Product Inventory
        </h3>
        <c:if test="${currentUser.role == 'OWNER'}">
            <a href="${pageContext.request.contextPath}/products?action=new" class="btn btn-primary shadow-sm">
                <i class="bi bi-plus-circle"></i> Add New Product
            </a>
        </c:if>
    </div>

    <%-- Success/Error Messages --%>
    <c:if test="${param.msg == 'deleted'}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            Product removed successfully.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${param.msg == 'error_constraint'}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <strong>Action Blocked:</strong> Cannot delete product with sales history. Update stock to 0 instead.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="card shadow-sm border-0">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-dark">
                    <tr>
                        <th class="ps-3">Product Name</th>
                        <th>Category</th>
                        <th>Model/Brand</th>
                        <th>Supplier</th> <%-- Added missing header --%>
                        <th class="text-end">Price</th> <%-- Aligned text-end --%>
                        <th class="text-center">Stock</th> <%-- Aligned text-center --%>
                        <c:if test="${currentUser.role == 'OWNER'}">
                            <th class="text-center">Actions</th> <%-- Aligned text-center --%>
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
                            <td><span class="badge bg-light text-dark border">${p.categoryName}</span></td>
                            <td>${p.model}</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/suppliers?action=view&id=${p.supplierId}"
                                   class="text-decoration-none text-dark">
                                    <i class="bi bi-info-circle text-primary"></i> ${p.supplierName}
                                </a>
                            </td>
                            <td class="text-end fw-bold">
                                RM <fmt:formatNumber value="${p.price}" minFractionDigits="2" maxFractionDigits="2" />
                            </td>
                            <td class="text-center">
                                    <span class="badge ${p.stockQuantity <= p.lowStockThreshold ? 'bg-danger' : 'bg-success'} rounded-pill px-3">
                                            ${p.stockQuantity}
                                    </span>
                            </td>
                            <c:if test="${currentUser.role == 'OWNER'}">
                                <td class="text-center">
                                    <div class="btn-group shadow-sm">
                                        <a href="${pageContext.request.contextPath}/products?action=edit&id=${p.productId}"
                                           class="btn btn-sm btn-outline-primary">
                                            <i class="bi bi-pencil"></i> Edit
                                        </a>
                                        <a href="${pageContext.request.contextPath}/products?action=delete&id=${p.productId}"
                                           class="btn btn-sm btn-outline-danger"
                                           onclick="return confirm('Permanently delete ${p.productName}?')">
                                            <i class="bi bi-trash"></i> Delete
                                        </a>
                                    </div>
                                </td>
                            </c:if>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty productList}">
                        <tr>
                            <td colspan="7" class="text-center py-5 text-muted">No products found.</td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />