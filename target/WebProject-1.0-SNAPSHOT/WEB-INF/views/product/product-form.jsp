<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../common/header.jsp" />

<main class="container mt-4">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-primary text-white py-3">
                    <h5 class="mb-0">${product != null ? 'Edit Product Details' : 'Register New Product'}</h5>
                </div>
                <div class="card-body p-4">
                    <form action="${pageContext.request.contextPath}/products" method="post">
                        <input type="hidden" name="productId" value="${product.productId}">

                        <div class="mb-3">
                            <label class="form-label fw-bold">Product Name</label>
                            <input type="text" name="productName" class="form-control" value="${product.productName}" required>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Category</label>
                                <select name="categoryId" class="form-select" required>
                                    <option value="">-- Select Category --</option>
                                    <c:forEach var="cat" items="${categories}">
                                        <option value="${cat.categoryId}" ${product.categoryId == cat.categoryId ? 'selected' : ''}>
                                                ${cat.categoryName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Model / Brand</label>
                                <input type="text" name="model" class="form-control" value="${product.model}">
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Price (RM)</label>
                                <div class="input-group">
                                    <span class="input-group-text">RM</span>
                                    <input type="number" step="0.01" name="price" class="form-control" value="${product.price}" required>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Supplier</label>
                                <select name="supplierId" class="form-select" required>
                                    <option value="">-- Select Supplier --</option>
                                    <c:forEach var="sup" items="${suppliers}">
                                        <option value="${sup.supplierId}" ${product.supplierId == sup.supplierId ? 'selected' : ''}>
                                                ${sup.supplierName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Initial Stock Quantity</label>
                                <input type="number" name="stockQuantity" class="form-control"
                                       value="${product.stockQuantity}" ${product != null ? 'disabled' : ''} required>
                                <c:if test="${product != null}">
                                    <small class="text-muted">Use 'Update Stock' menu to change inventory.</small>
                                </c:if>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Low Stock Threshold</label>
                                <input type="number" name="lowStockThreshold" class="form-control" value="${product.lowStockThreshold != null ? product.lowStockThreshold : 10}" required>
                            </div>
                        </div>

                        <div class="mt-4 pt-3 border-top d-flex justify-content-end">
                            <a href="${pageContext.request.contextPath}/products" class="btn btn-light me-2">Cancel</a>
                            <button type="submit" class="btn btn-success px-4">Save Product Information</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />