<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../common/header.jsp" />

<div class="container-fluid mt-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold">Sales Transaction History</h2>
        <c:if test="${not empty param.msg}">
            <div class="alert alert-success alert-dismissible fade show m-0 py-2" role="alert">
                <i class="bi bi-check-circle-fill"></i> ${param.msg}
                <button type="button" class="btn-close py-2" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show m-0 py-2" role="alert">
                <i class="bi bi-exclamation-triangle-fill"></i> ${param.error}
                <button type="button" class="btn-close py-2" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
    </div>

    <div class="card shadow-sm border-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light text-uppercase fs-7 text-muted">
                <tr>
                    <th class="ps-4">Date</th>
                    <th>Transaction ID</th>
                    <th>Cashier</th>
                    <th>Total</th>
                    <th>Method</th>
                    <th>Status</th>
                    <th class="pe-4 text-end">Action</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="sale" items="${salesList}">
                    <tr class="${sale.paymentStatus == 'CANCELLED' ? 'table-light text-muted text-decoration-line-through' : ''}">
                        <td class="ps-4">
                            <fmt:formatDate value="${sale.saleDate}" pattern="yyyy-MM-dd HH:mm" />
                        </td>
                        <td class="fw-bold">#SAL-${sale.saleId}</td>
                        <td>${sale.sellerName}</td>
                        <td class="fw-bold">
                            <fmt:formatNumber value="${sale.totalAmount}" type="currency" currencySymbol="RM " />
                        </td>
                        <td>
                            <span class="badge bg-outline-secondary text-dark border border-secondary small">${sale.paymentMethod}</span>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${sale.paymentStatus == 'CANCELLED'}">
                                    <span class="badge bg-danger" data-bs-toggle="tooltip" title="Reason: ${sale.cancelReason}">Cancelled</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-success">${sale.paymentStatus}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="pe-4 text-end">
                            <c:choose>
                                <c:when test="${sale.paymentStatus == 'CANCELLED'}">
                                    <button class="btn btn-sm btn-light border" disabled>
                                        <i class="bi bi-dash-circle"></i> Closed
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <c:if test="${currentUser.role == 'OWNER'}">
                                        <button onclick="performOrderCancellation(${sale.saleId})" class="btn btn-sm btn-outline-danger shadow-sm">
                                            <i class="bi bi-x-circle"></i> Cancel Order
                                        </button>
                                    </c:if>
                                    <c:if test="${currentUser.role != 'OWNER'}">
                                        <span class="text-muted small">No Permission</span>
                                    </c:if>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    function performOrderCancellation(saleId) {
        let reason = prompt("⚠️ CRITICAL ACTION: You are cancelling Order #SAL-" + saleId + ".\nThis will reverse financial totals and restock products.\n\nPlease enter a valid reason for cancellation:");

        if (reason === null) {
            return; // 用户点击了取消弹窗，什么都不做
        }

        if (reason.trim() === "") {
            alert("Operation Aborted: A valid reason must be provided to maintain log consistency.");
            return;
        }

        // 带着数据请求定向到后端路由
        window.location.href = "sales?action=cancel&saleId=" + saleId + "&reason=" + encodeURIComponent(reason);
    }

    // 初始化 Bootstrap Tooltips 用于悬停查看取消原因
    document.addEventListener("DOMContentLoaded", function() {
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl)
        })
    });
</script>

<jsp:include page="../common/footer.jsp" />