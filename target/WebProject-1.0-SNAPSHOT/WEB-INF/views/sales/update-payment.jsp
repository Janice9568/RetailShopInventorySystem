<%--
  Created by IntelliJ IDEA.
  User: 60179
  Date: 17/5/2026
  Time: 6:04 pm
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../common/header.jsp" />

<div class="container my-4">
  <div class="row">

    <div class="col-md-7 mb-4">
      <div class="card shadow-sm border-0">
        <div class="card-header bg-dark text-white">
          <h5 class="mb-0"><i class="bi bi-receipt"></i> Transaction Details (#SAL-${sale.saleId})</h5>
        </div>
        <div class="card-body">
          <div class="mb-3 text-secondary small">
            <div><strong>Cashier ID:</strong> ${sale.userId}</div>
            <div><strong>Transaction Date:</strong> <fmt:formatDate value="${sale.saleDate}" pattern="yyyy-MM-dd HH:mm:ss" /></div>
          </div>

          <table class="table table-bordered align-middle">
            <thead class="table-light">
            <tr>
              <th>Product ID</th>
              <th class="text-end">Unit Price</th>
              <th class="text-center" width="80">Qty</th>
              <th class="text-end" width="120">Subtotal</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="item" items="${saleItems}">
              <tr>
                <td><span class="fw-bold">#PROD-${item.productId}</span></td>
                <td class="text-end">RM <fmt:formatNumber value="${item.unitPrice}" type="number" minFractionDigits="2"/></td>
                <td class="text-center">${item.quantity}</td>
                <td class="text-end fw-medium text-secondary">RM <fmt:formatNumber value="${item.subtotal}" type="number" minFractionDigits="2"/></td>
              </tr>
            </c:forEach>
            </tbody>
            <tfoot>
            <tr class="table-light fs-5 fw-bold text-primary">
              <td colspan="3" class="text-end">Total Amount:</td>
              <td class="text-end text-success">RM <fmt:formatNumber value="${sale.totalAmount}" type="number" minFractionDigits="2"/></td>
            </tr>
            </tfoot>
          </table>
        </div>
      </div>
    </div>

    <div class="col-md-5 mb-4">
      <div class="card shadow border-0">
        <div class="card-header bg-primary text-white">
          <h5 class="mb-0"><i class="bi bi-shield-check"></i> Action: Update Status</h5>
        </div>
        <div class="card-body">
          <form action="${pageContext.request.contextPath}/payments" method="post">
            <input type="hidden" name="saleId" value="${sale.saleId}">

            <div class="mb-3">
              <label class="form-label fw-bold">Current Payment Status</label>
              <select name="paymentStatus" class="form-select" required>
                <option value="PAID" ${sale.paymentStatus == 'PAID' ? 'selected' : ''}>PAID</option>
                <option value="UNPAID" ${sale.paymentStatus == 'UNPAID' ? 'selected' : ''}>UNPAID</option>
              </select>
            </div>

            <div class="mb-3">
              <label class="form-label fw-bold">Current Payment Method</label>
              <select name="paymentMethod" class="form-select" required>
                <option value="CASH" ${sale.paymentMethod == 'CASH' ? 'selected' : ''}>Cash</option>
                <option value="CREDIT_CARD" ${sale.paymentMethod == 'CREDIT_CARD' ? 'selected' : ''}>Credit Card</option>
                <option value="E-WALLET" ${sale.paymentMethod == 'E-WALLET' ? 'selected' : ''}>E-Wallet</option>
              </select>
            </div>

            <hr>
            <button type="submit" class="btn btn-success w-100 btn-lg mb-2">
              <i class="bi bi-save"></i> Save Changes
            </button>
            <a href="${pageContext.request.contextPath}/sales?action=history" class="btn btn-outline-secondary w-100">
              Cancel & Go Back
            </a>
          </form>
        </div>
      </div>
    </div>

  </div>
</div>

<jsp:include page="../common/footer.jsp" />