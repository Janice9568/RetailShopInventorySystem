<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../common/header.jsp" />

<main class="container mt-4">
    <div class="row">
        <!-- Register Sidebar -->
        <div class="col-md-4">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-primary text-white py-3"><h5 class="mb-0">Register Staff</h5></div>
                <div class="card-body">
                    <form action="users" method="post">
                        <div class="mb-2"><label class="small fw-bold">Real Name</label><input type="text" name="fullName" class="form-control" required></div>
                        <div class="mb-2"><label class="small fw-bold">Phone</label><input type="text" name="phone" class="form-control"></div>
                        <div class="mb-2"><label class="small fw-bold">Email</label><input type="email" name="email" class="form-control"></div>
                        <hr>
                        <div class="mb-2"><label class="small fw-bold">Username</label><input type="text" name="username" class="form-control" required></div>
                        <div class="mb-2"><label class="small fw-bold">Password</label><input type="password" name="password" class="form-control" required></div>
                        <div class="mb-3">
                            <label class="small fw-bold">Role</label>
                            <select name="role" class="form-select">
                                <option value="CASHIER">Cashier Staff</option>
                                <option value="INVENTORY_STAFF">Inventory Staff</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-primary w-100">Create Account</button>
                    </form>
                </div>
            </div>
        </div>

        <!-- Directory -->
        <div class="col-md-8">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-white py-3"><h5 class="mb-0 fw-bold">Staff Directory</h5></div>
                <div class="card-body p-0">
                    <table class="table table-hover mb-0 align-middle">
                        <thead class="table-light">
                        <tr>
                            <th class="ps-3">Name / Role</th>
                            <th>Contact Info</th>
                            <th class="text-center">Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="u" items="${staffList}">
                            <tr>
                                <td class="ps-3">
                                    <div class="fw-bold">${u.fullName}</div>
                                    <span class="badge bg-secondary x-small">${u.role}</span>
                                </td>
                                <td>
                                    <div class="small"><i class="bi bi-telephone text-muted"></i> ${u.phone}</div>
                                    <div class="small"><i class="bi bi-envelope text-muted"></i> ${u.email}</div>
                                </td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-outline-info"
                                            onclick="openEditModal('${u.userId}', '${u.fullName}', '${u.role}', '${u.phone}', '${u.email}')">
                                        Edit
                                    </button>
                                    <a href="users?action=delete&id=${u.userId}" class="btn btn-sm btn-outline-danger" onclick="return confirm('Delete user?')">Remove</a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Edit Staff Modal -->
<div class="modal fade" id="editStaffModal" tabindex="-1">
    <div class="modal-dialog">
        <form action="users" method="post" class="modal-content">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="userId" id="editId">
            <div class="modal-header bg-light"><h5 class="modal-title">Edit Staff Contact</h5></div>
            <div class="modal-body">
                <div class="mb-3">
                    <label class="form-label text-muted small">Real Name & Role (Fixed)</label>
                    <input type="text" id="editDisplayName" class="form-control bg-light" readonly>
                </div>
                <div class="mb-3">
                    <label class="form-label">Phone Number</label>
                    <input type="text" name="phone" id="editPhone" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Email Address</label>
                    <input type="email" name="email" id="editEmail" class="form-control" required>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="submit" class="btn btn-primary">Save Changes</button>
            </div>
        </form>
    </div>
</div>

<script>
    const editModal = new bootstrap.Modal(document.getElementById('editStaffModal'));
    function openEditModal(id, name, role, phone, email) {
        document.getElementById('editId').value = id;
        document.getElementById('editDisplayName').value = name + " (" + role + ")";
        document.getElementById('editPhone').value = phone;
        document.getElementById('editEmail').value = email;
        editModal.show();
    }
</script>
<jsp:include page="../common/footer.jsp" />