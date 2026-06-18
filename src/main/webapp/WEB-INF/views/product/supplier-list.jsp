<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../common/header.jsp" />

<main class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3><i class="bi bi-truck"></i> Supplier Management</h3>
        <button class="btn btn-primary" id="btnAddSupplier">
            <i class="bi bi-plus-lg"></i> Add New Supplier
        </button>
    </div>

    <c:if test="${param.msg == 'success'}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            Supplier operation successful!
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="card shadow-sm">
        <div class="card-body p-0">
            <table class="table table-hover mb-0">
                <thead class="table-dark">
                <tr>
                    <th>Name</th>
                    <th>Contact</th>
                    <th>Phone</th>
                    <th>Email</th>
                    <th class="text-center">Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="s" items="${supplierList}">
                    <tr>
                        <td><strong>${s.supplierName}</strong></td>
                        <td>${s.contactPerson}</td>
                        <td>${s.phone}</td>
                        <td>${s.email}</td>
                        <td class="text-center">
                            <button class="btn btn-sm btn-outline-info btn-edit"
                                    data-id="${s.supplierId}"
                                    data-name="${s.supplierName}"
                                    data-contact="${s.contactPerson}"
                                    data-phone="${s.phone}"
                                    data-email="${s.email}"
                                    data-address="${s.address}">
                                <i class="bi bi-pencil"></i>
                            </button>
                            <a href="${pageContext.request.contextPath}/suppliers?action=delete&id=${s.supplierId}"
                               class="btn btn-sm btn-outline-danger"
                               onclick="return confirm('Delete this supplier?')">
                                <i class="bi bi-trash"></i>
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</main>

<!-- Modal for Add/Edit -->
<div class="modal fade" id="supplierModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <form action="${pageContext.request.contextPath}/suppliers" method="post" id="supplierForm" class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalTitle">Supplier Information</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" name="supplierId" id="formId">
                <div class="mb-3">
                    <label class="form-label">Supplier Name</label>
                    <input type="text" name="supplierName" id="formName" class="form-control" required>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Contact Person</label>
                        <input type="text" name="contactPerson" id="formContact" class="form-control">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Phone</label>
                        <input type="text" name="phone" id="formPhone" class="form-control">
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="email" name="email" id="formEmail" class="form-control">
                </div>
                <div class="mb-3">
                    <label class="form-label">Address</label>
                    <textarea name="address" id="formAddress" class="form-control" rows="2"></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-primary">Save Supplier</button>
            </div>
        </form>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const modalEl = document.getElementById('supplierModal');
        const supplierModal = new bootstrap.Modal(modalEl);
        const form = document.getElementById('supplierForm');

        // Add Button
        document.getElementById('btnAddSupplier').addEventListener('click', function() {
            form.reset();
            document.getElementById('formId').value = "";
            document.getElementById('modalTitle').innerText = "Add New Supplier";
            supplierModal.show();
        });

        // Edit Buttons
        document.querySelectorAll('.btn-edit').forEach(btn => {
            btn.addEventListener('click', function() {
                document.getElementById('formId').value = this.dataset.id;
                document.getElementById('formName').value = this.dataset.name;
                document.getElementById('formContact').value = this.dataset.contact;
                document.getElementById('formPhone').value = this.dataset.phone;
                document.getElementById('formEmail').value = this.dataset.email;
                document.getElementById('formAddress').value = this.dataset.address;
                document.getElementById('modalTitle').innerText = "Edit Supplier";
                supplierModal.show();
            });
        });
    });
</script>

<jsp:include page="../common/footer.jsp" />