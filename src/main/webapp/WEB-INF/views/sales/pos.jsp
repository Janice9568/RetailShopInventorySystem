<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../common/header.jsp" />

<div class="row">
    <!-- 1. 商品选择区域 (融合了你队友的动态数据) -->
    <div class="col-md-4">
        <div class="card shadow-sm mb-4">
            <div class="card-header bg-dark text-white">
                <h5 class="mb-0">Select Products</h5>
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <label class="form-label">Choose a Product</label>
                    <select id="productPicker" class="form-select">
                        <option value="">-- Choose a Product --</option>
                        <c:forEach var="p" items="${products}">
                            <option value="${p.productId}"
                                    data-name="${p.productName}"
                                    data-price="${p.price}"
                                    data-stock="${p.stockQuantity}">
                                    ${p.productName} (RM ${p.price} - Stock: ${p.stockQuantity})
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">Quantity</label>
                    <input type="number" id="productQty" class="form-control" min="1" value="1">
                </div>
                <button type="button" onclick="addToCart()" class="btn btn-primary w-100">
                    <i class="bi bi-plus-lg"></i> Add to Cart
                </button>
            </div>
        </div>
    </div>

    <!-- 2. 购物车与交易详情 (融合了你的后端表单提交) -->
    <div class="col-md-8">
        <!-- 提交到后端的 Servlet，如果没有写 Servlet，这里可以暂时先指向你的结果页 processSale.jsp -->
        <form action="${pageContext.request.contextPath}/sales" method="post" id="salesForm">
            <!-- 隐藏域，用来告诉后端是什么操作 -->
            <input type="hidden" name="action" id="formAction" value="confirm">

            <div class="card shadow-sm">
                <div class="card-header bg-white">
                    <h5 class="mb-0">Current Transaction</h5>
                </div>
                <div class="card-body">
                    <table class="table table-bordered align-middle" id="cartTable">
                        <thead class="table-light">
                        <tr>
                            <th>Product</th>
                            <th width="120">Price</th>
                            <th width="100">Qty</th>
                            <th width="140">Subtotal</th>
                            <th width="50"></th>
                        </tr>
                        </thead>
                        <tbody>
                        <!-- 由 JavaScript 动态生成行，类似你写的逻辑 -->
                        </tbody>
                        <tfoot>
                        <tr>
                            <th colspan="3" class="text-end">Total Amount:</th>
                            <th id="grandTotalText" class="text-success fs-5">RM 0.00</th>
                        </tr>
                        </tfoot>
                    </table>

                    <div class="row mt-4">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Payment Method*</label>
                            <select name="paymentMethod" class="form-select" required>
                                <option value="CASH">Cash</option>
                                <option value="CREDIT_CARD">Credit Card</option>
                                <option value="E-WALLET">E-Wallet</option>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Payment Status*</label>
                            <select name="paymentStatus" class="form-select" required>
                                <option value="PAID">Paid</option>
                                <option value="UNPAID">Unpaid</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="card-footer d-flex justify-content-between">
                    <!-- 清空购物车按钮 (融合自你的 btn-clear) -->
                    <button type="button" onclick="clearCart()" class="btn btn-danger">
                        <i class="bi bi-trash"></i> Clear Cart
                    </button>
                    <!-- 确认提交按钮 (融合自你的 btn-confirm) -->
                    <button type="submit" class="btn btn-success btn-lg">
                        <i class="bi bi-check-circle"></i> Confirm Sale
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>

<!-- 纯前端动态交互 JS，比在 JSP 里不停刷新页面体验好一万倍 -->
<script>
    function addToCart() {
        const picker = document.getElementById('productPicker');
        const qtyInput = document.getElementById('productQty');
        const selected = picker.options[picker.selectedIndex];
        const inputQty = parseInt(qtyInput.value) || 1;

        if (!selected.value) {
            alert('Please select a product!');
            return;
        }

        const id = selected.value;
        const name = selected.getAttribute('data-name');
        const price = parseFloat(selected.getAttribute('data-price'));
        const stock = parseInt(selected.getAttribute('data-stock'));

        // 检查是否已经在购物车中
        const existingRow = document.querySelector(`tr[data-id="${id}"]`);
        if (existingRow) {
            const rowQtyInput = existingRow.querySelector('.qty-input');
            const newQty = parseInt(rowQtyInput.value) + inputQty;
            if (newQty <= stock) {
                rowQtyInput.value = newQty;
                updateRowTotal(rowQtyInput);
            } else {
                alert(`Insufficient stock! Max available: ${stock}`);
            }
            return;
        }

        if (stock < inputQty) {
            alert(`Insufficient stock! Available: ${stock}`);
            return;
        }
        function validateCart() {
            // 寻找你购物车表格里，所有带有 name="productId[]" 的隐藏域或者输入框
            var items = document.getElementsByName('productId[]');

            if (items.length === 0) {
                // 如果购物车里没有任何商品元素
                alert("🚨 Stop right there! Your shopping cart is empty. Please add at least one product before checking out!");
                return false; // 返回 false，表单将绝对无法提交到后端！
            }
            return true; // 有商品，放行！
        }

        const tbody = document.querySelector('#cartTable tbody');
        const row = document.createElement('tr');
        row.setAttribute('data-id', id);
        row.innerHTML = `
            <td>
                <strong>\${name}</strong>
                <input type="hidden" name="productId[]" value="\${id}">
            </td>
            <td>RM \${price.toFixed(2)}</td>
            <td>
                <input type="number" name="qty[]" class="form-control form-control-sm qty-input"
                       value="\${inputQty}" min="1" max="\${stock}" onchange="updateRowTotal(this)">
            </td>
            <td class="row-total fw-bold text-secondary" data-price="\${price}">RM \${(price * inputQty).toFixed(2)}</td>
            <td>
                <button type="button" class="btn btn-sm btn-outline-danger" onclick="this.closest('tr').remove(); calculateGrandTotal();">
                    <i class="bi bi-x"></i>
                </button>
            </td>
        `;
        tbody.appendChild(row);
        calculateGrandTotal();

        // 重置选择器
        picker.selectedIndex = 0;
        qtyInput.value = 1;
    }

    function updateRowTotal(input) {
        const row = input.closest('tr');
        const price = parseFloat(row.querySelector('.row-total').getAttribute('data-price'));
        let qty = parseInt(input.value);
        const maxStock = parseInt(input.getAttribute('max'));

        if (qty > maxStock) {
            alert(`Exceeded available stock! Setting to max: \${maxStock}`);
            qty = maxStock;
            input.value = maxStock;
        }
        if (qty < 1 || isNaN(qty)) {
            qty = 1;
            input.value = 1;
        }

        const subtotal = price * qty;
        row.querySelector('.row-total').innerText = 'RM ' + subtotal.toFixed(2);
        calculateGrandTotal();
    }

    function calculateGrandTotal() {
        let total = 0;
        document.querySelectorAll('.row-total').forEach(cell => {
            total += parseFloat(cell.innerText.replace('RM ', ''));
        });
        document.getElementById('grandTotalText').innerText = 'RM ' + total.toFixed(2);
    }

    function clearCart() {
        document.querySelector('#cartTable tbody').innerHTML = '';
        calculateGrandTotal();
    }
</script>

<jsp:include page="../common/footer.jsp" />