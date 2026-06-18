<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../common/header.jsp" />

<div class="row justify-content-center my-5">
    <div class="col-md-8 col-lg-6">
        <div class="card shadow border-0" style="background: linear-gradient(to bottom, #ffffff, #f1f5f9);">
            <div class="card-body p-4">
                <div class="text-center mb-4">
                    <span class="badge bg-success-subtle text-success fs-6 mb-2">
                        <i class="bi bi-check-circle-fill"></i> Transaction Successful
                    </span>
                    <h2 class="card-title h3 fw-bold text-dark">Sales Confirmation</h2>
                </div>

                <hr class="text-muted">

                <!-- 交易流水号 (从 Session 或者后台取，这里加上默认值) -->
                <div class="d-flex justify-content-between my-3">
                    <span class="text-secondary">Transaction ID:</span>
                    <span class="fw-medium">${not empty sessionScope.txnId ? sessionScope.txnId : 'TXN-20260517-0001'}</span>
                </div>

                <div class="d-flex justify-content-between my-3">
                    <span class="text-secondary">Date & Time:</span>
                    <span class="fw-medium">
                        <!-- 动态获取当前时间，如果没有就显示默认 -->
                        <jsp:useBean id="now" class="java.util.Date" />
                        <fmt:formatDate value="${now}" pattern="dd MMM yyyy, HH:mm" />
                    </span>
                </div>

                <!-- 支付方式 -->
                <div class="d-flex justify-content-between my-3">
                    <span class="text-secondary">Payment Method:</span>
                    <span class="badge bg-secondary">${sessionScope.paymentMethod}</span>
                </div>

                <!-- 支付状态 -->
                <div class="d-flex justify-content-between my-3">
                    <span class="text-secondary">Payment Status:</span>
                    <span class="badge ${sessionScope.paymentStatus == 'PAID' ? 'bg-success' : 'bg-warning text-dark'}">
                        ${sessionScope.paymentStatus}
                    </span>
                </div>

                <hr class="text-muted">

                <!-- 最终总额 (使用 fmt 标签规范化货币格式) -->
                <div class="d-flex justify-content-between align-items-center my-4">
                    <span class="fs-5 fw-bold text-dark">Total Amount:</span>
                    <span class="fs-4 fw-bold text-primary">
                        RM <fmt:formatNumber value="${sessionScope.totalAmount}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                    </span>
                </div>

                <div class="mt-4">
                    <!-- 返回购买收银台页面 (sales?action=pos) -->
                    <a href="${pageContext.request.contextPath}/sales?action=pos" class="btn btn-outline-secondary w-100">
                        <i class="bi bi-arrow-left"></i> Back to Sales
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />