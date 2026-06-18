<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Daily Sales Report - Print Preview</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

  <style>
    body { background-color: #fcfcfd; font-family: 'Segoe UI', system-ui, sans-serif; padding: 20px; }
    .report-wrapper { max-width: 1000px; margin: 20px auto; background: white; padding: 30px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); border-radius: 8px; }
    .report-title { font-size: 26px; font-weight: 800; color: #111; margin-bottom: 5px; }
    .report-date { font-size: 15px; color: #666; margin-bottom: 25px; }

    .purple-header {
      background: linear-gradient(90deg, #5c6bc0 0%, #7e57c2 100%) !important;
      color: white !important;
      font-weight: 600;
      border: none !important;
      padding: 14px 16px !important;
    }

    .table { border-collapse: separate; border-spacing: 0; width: 100%; }
    .table th, .table td { padding: 14px 16px; border-bottom: 1px solid #edf2f7; }

    .total-summary-row { background-color: #f0f4ff !important; font-weight: bold; font-size: 16px; }

    .btn-purple {
      background: linear-gradient(135deg, #5c6bc0 0%, #7e57c2 100%);
      color: white; border: none; padding: 10px 24px; font-weight: 600; border-radius: 8px;
      transition: all 0.2s; text-decoration: none; display: inline-block;
    }
    .btn-purple:hover {
      background: linear-gradient(135deg, #4e5dbc 0%, #6f48b7 100%); color: white; box-shadow: 0 4px 12px rgba(111,72,183,0.3);
    }

    @media print {
      .no-print { display: none !important; }
      .report-wrapper { padding: 0; margin: 0; max-width: 100%; box-shadow: none; }
      body { background: white; padding: 0; }
    }
  </style>
</head>
<body>

<div class="report-wrapper">
  <div class="report-title"><i class="bi bi-file-earmark-text text-primary me-2"></i>Sales Report</div>
  <div class="report-date">
    Date Range:
    <span class="fw-bold text-dark">
        <c:choose>
          <c:when test="${startDate == endDate}">
            ${startDate}
          </c:when>
          <c:otherwise>
            ${startDate} To ${endDate}
          </c:otherwise>
        </c:choose>
    </span>
  </div>

  <table id="reportTable" class="table align-middle">
    <thead>
    <tr>
      <th class="purple-header" style="border-top-left-radius: 8px; width: 160px;">Transaction ID</th>
      <th class="purple-header" style="width: 180px;"><i class="bi bi-calendar3 me-1"></i> Date</th>
      <th class="purple-header">Product</th>
      <th class="purple-header text-center" width="90">Qty</th>
      <th class="purple-header text-end" width="160">Amount</th>
    </tr>
    </thead>
    <tbody>
    <c:set var="grandTotalSales" value="0.0" />
    <c:set var="txnCounter" value="0" />

    <c:forEach var="row" items="${detailedSales}">
      <c:choose>
        <c:when test="${fn:contains(row.productName, '||')}">
          <c:set var="parts" value="${fn:split(row.productName, '||')}" />
          <c:set var="displayDate" value="${parts[0]}" />
          <c:set var="realProductName" value="${parts[1]}" />
        </c:when>
        <c:otherwise>
          <c:set var="displayDate" value="${startDate}" />
          <c:set var="realProductName" value="${row.productName}" />
        </c:otherwise>
      </c:choose>

      <c:set var="grandTotalSales" value="${grandTotalSales + row.subtotal}" />
      <c:set var="txnCounter" value="${txnCounter + row.quantity}" />

      <tr>
        <td class="text-secondary fw-bold">#SAL-TXT</td>
        <td class="text-secondary fw-medium">${displayDate}</td>
        <td class="fw-bold text-dark">${realProductName}</td>
        <td class="text-center fw-bold text-primary">${row.quantity}</td>
        <td class="text-end fw-bold text-dark">
          RM <fmt:formatNumber value="${row.subtotal}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
        </td>
      </tr>
    </c:forEach>

    <c:if test="${empty detailedSales}">
      <tr>
        <td colspan="5" class="text-center text-muted py-5">
          <i class="bi bi-inbox fs-3 d-block mb-2 text-secondary"></i>No validated sale records found for this period.
        </td>
      </tr>
    </c:if>
    </tbody>

    <tfoot>
    <tr class="total-summary-row">
      <td colspan="3" class="text-end py-3">Total Cumulative Revenue:</td>
      <td class="text-center text-primary py-3">${txnCounter} Items</td>
      <td class="text-end text-success py-3">
        RM <fmt:formatNumber value="${grandTotalSales}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
      </td>
    </tr>
    </tfoot>
  </table>

  <div class="mt-4 pt-3 border-top d-flex gap-3 no-print">
    <button onclick="window.print();" class="btn btn-purple">
      <i class="bi bi-printer-fill me-1"></i> Print Report
    </button>
    <button onclick="exportToExcel('reportTable')" class="btn btn-purple" style="background: linear-gradient(135deg, #2e7d32 0%, #43a047 100%);">
      <i class="bi bi-file-earmark-excel-fill me-1"></i> Export to Excel
    </button>
    <button onclick="window.close()" class="btn btn-outline-secondary px-4" style="border-radius: 8px;">
      Close Window
    </button>
  </div>
</div>

<script>
  function exportToExcel(tableID, filename = 'Daily_Sales_Report') {
    var tableSelect = document.getElementById(tableID);
    if (!tableSelect) return;
    var meta = '<meta http-equiv="content-type" content="application/vnd.ms-excel; charset=UTF-8">';
    var tableHTML = meta + tableSelect.outerHTML;
    var dateStr = new Date().toISOString().slice(0, 10);
    filename = filename + '_' + dateStr + '.xls';

    var blob = new Blob([tableHTML], { type: 'application/vnd.ms-excel;charset=utf-8;' });
    if (navigator.msSaveOrOpenBlob) {
      navigator.msSaveOrOpenBlob(blob, filename);
    } else {
      var downloadLink = document.createElement("a");
      downloadLink.href = URL.createObjectURL(blob);
      downloadLink.download = filename;
      document.body.appendChild(downloadLink);
      downloadLink.click();
      document.body.removeChild(downloadLink);
    }
  }
</script>

</body>
</html>