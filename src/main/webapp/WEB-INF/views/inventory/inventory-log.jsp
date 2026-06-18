<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../common/header.jsp" />
<h3>Inventory Adjustment Logs</h3>
<div class="card shadow-sm mt-3">
    <div class="card-body">
        <table class="table table-hover">
            <thead><tr><th>Date</th><th>Product</th><th>Change</th><th>Reason</th><th>Staff</th></tr></thead>
            <tbody>
            <c:forEach var="log" items="${logs}">
                <tr>
                    <td><fmt:formatDate value="${log.logDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                    <td>${log.productName}</td>
                    <td class="${log.changeQuantity > 0 ? 'text-success' : 'text-danger'}">
                        <strong>${log.changeQuantity > 0 ? '+' : ''}${log.changeQuantity}</strong>
                    </td>
                    <td>${log.reason}</td><td>${log.userName}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
<jsp:include page="../common/footer.jsp" />