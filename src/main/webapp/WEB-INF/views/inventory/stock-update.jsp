<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../common/header.jsp" />

<main class="container mt-4">
    <div class="row justify-content-center">
        <div class="col-md-7">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-dark text-white py-3">
                    <h5 class="mb-0"><i class="bi bi-arrow-repeat"></i> Manual Stock Adjustment</h5>
                </div>
                <div class="card-body p-4">

                    <%-- Status Messages --%>
                    <c:if test="${not empty param.success}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="bi bi-check-circle-fill"></i> ${param.success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty param.error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-octagon-fill"></i> ${param.error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/inventory" method="post" id="stockForm">

                        <div class="mb-4">
                            <label class="form-label fw-bold">1. Select Product to Adjust</label>
                            <select name="productId" id="productSelector" class="form-select form-select-lg" required>
                                <option value="" selected disabled>-- Search Product Name --</option>
                                <c:forEach var="p" items="${productList}">
                                    <option value="${p.productId}"
                                            data-stock="${p.stockQuantity}"
                                            data-sup-id="${p.supplierId}"
                                            data-sup-name="${p.supplierName}">
                                            ${p.productName} (Current: ${p.stockQuantity})
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <%-- Dynamic Supplier Info Alert (Hidden by default) --%>
                        <div id="supplierAlert" class="alert alert-info border-0 shadow-sm d-none mb-4">
                            <div class="d-flex align-items-center">
                                <i class="bi bi-telephone-outbound fs-3 me-3"></i>
                                <div>
                                    <p class="mb-0">Low on stock for this item?</p>
                                    <a id="supplierLink" href="#" class="fw-bold text-decoration-none">
                                        View Contact Details for <span id="supplierNameSpan"></span> <i class="bi bi-arrow-right-short"></i>
                                    </a>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">2. Adjustment Quantity</label>
                                <div class="input-group">
                                    <input type="number" name="changeQty" class="form-control" placeholder="e.g. 50 or -10" required>
                                    <span class="input-group-text">Units</span>
                                </div>
                                <small class="text-muted">Use positive to add stock, negative to deduct.</small>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">3. Reason</label>
                                <select name="reason" class="form-select" required>
                                    <option value="Restock / New Shipment">Restock / New Shipment</option>
                                    <option value="Manual Correction">Manual Correction</option>
                                    <option value="Returned Goods">Returned Goods</option>
                                    <option value="Damaged / Expired">Damaged / Expired</option>
                                    <option value="Other">Other (Audit)</option>
                                </select>
                            </div>
                        </div>

                        <div class="mt-4 pt-3 border-top d-flex justify-content-between align-items-center">
                            <a href="${pageContext.request.contextPath}/inventory-logs" class="text-decoration-none">
                                <i class="bi bi-clock-history"></i> View Adjustment History
                            </a>
                            <button type="submit" class="btn btn-primary px-5 btn-lg">
                                Update Inventory
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
    // Handle the dynamic supplier link logic
    document.getElementById('productSelector').addEventListener('change', function() {
        const selectedOption = this.options[this.selectedIndex];
        const alertBox = document.getElementById('supplierAlert');
        const spanName = document.getElementById('supplierNameSpan');
        const linkElem = document.getElementById('supplierLink');

        if (selectedOption.value) {
            const supplierId = selectedOption.getAttribute('data-sup-id');
            const supplierName = selectedOption.getAttribute('data-sup-name');

            // Update text and link
            spanName.innerText = supplierName;
            linkElem.href = "${pageContext.request.contextPath}/suppliers?action=view&id=" + supplierId;

            // Show the alert box
            alertBox.classList.remove('d-none');
            alertBox.classList.add('animate__animated', 'animate__fadeIn');
        } else {
            alertBox.classList.add('d-none');
        }
    });
</script>

<jsp:include page="../common/footer.jsp" />