<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:include page="../common/header.jsp" />

<div class="container my-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="fw-bold text-dark mb-1">Analytics Dashboard</h2>
            <p class="text-secondary mb-0">Monitor sales performance, item analytics, and stock health.</p>
        </div>
    </div>

    <div class="card shadow-sm mb-4">
        <div class="card-header bg-white fw-bold d-flex justify-content-between align-items-center py-3">
            <span><i class="bi bi-filter-left fs-5 me-2"></i>Filter Report Date Range</span>
            <button type="button" onclick="selectTodayAndSubmitAll()" class="btn btn-sm btn-outline-primary fw-bold px-3">
                <i class="bi bi-clock-history me-1"></i> Today
            </button>
        </div>
        <div class="card-body p-4">
            <form action="reports" method="get" id="mainDashboardForm" target="_blank">
                <input type="hidden" name="action" id="formAction" value="printReport">
                <input type="hidden" name="isTodayScope" id="isTodayScope" value="false">

                <div class="row g-2 align-items-end">
                    <div class="col-md-5">
                        <label class="form-label small fw-bold text-secondary">Start Date</label>
                        <input type="date" id="filterStartDate" name="startDate" value="${selectedStartDate}" class="form-control form-control-lg" required>
                    </div>
                    <div class="col-md-5">
                        <label class="form-label small fw-bold text-secondary">End Date</label>
                        <input type="date" id="filterEndDate" name="endDate" value="${selectedEndDate}" class="form-control form-control-lg" required>
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-primary btn-lg w-100 fw-bold shadow-sm" onclick="handleFormClick()">
                            Generate Report
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-lg-7">
            <div class="card shadow-sm h-100">
                <div class="card-header bg-white fw-bold py-3">
                    <i class="bi bi-graph-up-arrow me-2 text-primary"></i>Daily Sales Summary
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                            <tr>
                                <th>Date</th>
                                <th>Items Sold Breakdown</th>
                                <th class="text-end">Revenue Total</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="entry" items="${salesData}">
                                <tr>
                                    <td class="fw-bold text-dark" style="vertical-align: top; width: 130px;">
                                            ${entry.key}
                                    </td>
                                    <td>
                                        <ul class="list-unstyled mb-0">
                                            <c:forEach var="row" items="${detailedSales}">
                                                <c:if test="${fn:contains(row.productName, '||')}">
                                                    <c:set var="parts" value="${fn:split(row.productName, '||')}" />
                                                    <c:set var="rowDate" value="${parts[0]}" />
                                                    <c:set var="realName" value="${parts[1]}" />

                                                    <c:if test="${rowDate == entry.key}">
                                                        <li class="mb-1 small">
                                                            <i class="bi bi-check-circle-fill text-success me-1" style="font-size: 0.75rem;"></i>
                                                            <span class="text-dark fw-medium">${realName}</span>
                                                            <span class="badge bg-light text-secondary border ms-1">x${row.quantity}</span>
                                                        </li>
                                                    </c:if>
                                                </c:if>
                                            </c:forEach>
                                        </ul>
                                    </td>
                                    <td class="text-end fw-bold text-primary" style="vertical-align: top;">
                                        RM <fmt:formatNumber value="${entry.value}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty salesData}">
                                <tr>
                                    <td colspan="3" class="text-center text-muted py-4">No data logged for this timeframe.</td>
                                </tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-5">
            <div class="card shadow-sm h-100">
                <div class="card-header bg-white fw-bold py-3">
                    <i class="bi bi-trophy me-2 text-warning"></i>Top 10 Best Selling Items
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                            <tr>
                                <th>Product Item Name</th>
                                <th class="text-center" width="100">Units Sold</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="entry" items="${performanceData}">
                                <tr>
                                    <td class="fw-medium text-dark">${entry.key}</td>
                                    <td class="text-center fw-bold text-primary">
                                        <span class="badge bg-primary-subtle text-primary rounded-pill px-3">${entry.value}</span>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty performanceData}">
                                <tr>
                                    <td colspan="2" class="text-center text-muted py-4">No item metrics captured yet.</td>
                                </tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-12 mt-2">
            <div class="card shadow-sm">
                <div class="card-header bg-white fw-bold py-3">
                    <i class="bi bi-receipt me-2 text-success"></i>Transaction Flow & Audit Logs
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                            <tr>
                                <th class="ps-4">Date & Time</th>
                                <th>Transaction ID</th>
                                <th>Cashier</th>
                                <th>Amount</th>
                                <th>Payment Method</th>
                                <th class="pe-4">Status & Audit Notes</th>
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
                                        RM <fmt:formatNumber value="${sale.totalAmount}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                    </td>
                                    <td><span class="badge bg-light text-dark border">${sale.paymentMethod}</span></td>
                                    <td class="pe-4">
                                        <c:choose>
                                            <c:when test="${sale.paymentStatus == 'CANCELLED'}">
                                                <span class="badge bg-danger">Cancelled</span>
                                                <div class="text-danger small fw-bold mt-1 text-decoration-none" style="font-size: 0.78rem;">
                                                    <i class="bi bi-info-circle"></i> Reason: ${sale.cancelReason}
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-success-subtle text-success">${sale.paymentStatus}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty salesList}">
                                <tr>
                                    <td colspan="6" class="text-center text-muted py-4">No transactions logged in system history.</td>
                                </tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>

<script>
    // 当点击 Generate Report 时：让主窗口平滑更新大看板，完全不对齐 action 尾巴，杜绝 404
    function handleFormClick() {
        const startDate = document.getElementById('filterStartDate').value;
        const endDate = document.getElementById('filterEndDate').value;
        const isToday = document.getElementById('isTodayScope').value;

        setTimeout(() => {
            window.location.href = `reports?startDate=${startDate}&endDate=${endDate}&isTodayScope=${isToday}`;
        }, 400);
    }

    // Today 捷径按钮：强行将标志位调整，引爆单天数据过滤
    function selectTodayAndSubmitAll() {
        document.getElementById('filterStartDate').value = "2026-06-18";
        document.getElementById('filterEndDate').value = "2026-06-18";
        document.getElementById('isTodayScope').value = "true";

        document.getElementById('formAction').value = "printReport";
        handleFormClick();

        const form = document.getElementById('mainDashboardForm');
        if(form) {
            form.submit();
        }
    }
</script>

<jsp:include page="../common/footer.jsp" />