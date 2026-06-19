<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../common/header.jsp" />

<main class="container mt-4">
    <div class="row">
        <!-- Register Form -->
        <div class="col-md-4">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-primary text-white py-3">
                    <h5 class="mb-0">Add New Staff</h5>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/users" method="post">
                        <input type="hidden" name="formAction" value="register">
                        <div class="mb-2"><label class="fw-bold small">Real Name</label><input type="text" name="fullName" class="form-control" required></div>
                        <div class="mb-2"><label class="fw-bold small">Phone</label><input type="text" name="phone" class="form-control"></div>
                        <div class="mb-2"><label class="fw-bold small">Email</label><input type="email" name="email" class="form-control"></div>
                        <hr>
                        <div class="mb-2"><label class="fw-bold small">Username</label><input type="text" name="username" class="form-control" required></div>
                        <div class="mb-2"><label class="fw-bold small">Password</label><input type="password" name="password" class="form-control" required></div>
                        <div class="mb-3">
                            <label class="fw-bold small">Role</label>
                            <select name="role" class="form-select">
                                <option value="CASHIER">CASHIER</option>
                                <option value="INVENTORY_STAFF">INVENTORY_STAFF</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-primary w-100">Register Staff</button>
                    </form>
                </div>
            </div>
        </div>

        <!-- Directory Table -->
        <div class="col-md-8">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                    <h5 class="mb-0 fw-bold">User Directory</h5>
                </div>
                <div class="card-body p-0">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                        <tr>
                            <th class="ps-3">Identity</th>
                            <th>Contact Information</th>
                            <th class="text-center">Action</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="u" items="${staffList}">
                            <tr>
                                <td class="ps-3">
                                    <div class="fw-bold">${u.fullName}</div>
                                    <span class="badge ${u.role == 'OWNER' ? 'bg-dark' : 'bg-secondary'}">${u.role}</span>
                                    <div class="small text-muted">@${u.username}</div>
                                </td>
                                <td>
                                    <div class="small"><i class="bi bi-telephone"></i> ${not empty u.phone ? u.phone : '-'}</div>
                                    <div class="small"><i class="bi bi-envelope"></i> ${not empty u.email ? u.email : '-'}</div>
                                </td>
                                <td class="text-center">
                                        <%-- Everyone can be edited --%>
                                    <button class="btn btn-sm btn-outline-info"
                                            onclick="openEditModal('${u.userId}', '${u.fullName}', '${u.role}', '${u.phone}', '${u.email}')">
                                        Edit
                                    </button>
                                        <%-- ONLY Staff can be deleted. Owner delete button is hidden --%>
                                    <c:if test="${u.role != 'OWNER'}">
                                        <a href="users?action=delete&id=${u.userId}"
                                           class="btn btn-sm btn-outline-danger"
                                           onclick="return confirm('Delete this user?')">Delete</a>
                                    </c:if>
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

<!-- Edit Modal -->
<div class="modal fade" id="editModal" tabindex="-1">
    <div class="modal-dialog">
        <form action="${pageContext.request.contextPath}/users" method="post" class="modal-content">
            <input type="hidden" name="formAction" value="update">
            <input type="hidden" name="userId" id="editUserId">
            <div class="modal-header"><h5 class="modal-title">Update Contact</h5></div>
            <div class="modal-body">
                <p class="small text-muted">Editing: <strong id="editName"></strong></p>
                <div class="mb-3"><label class="form-label">Phone</label><input type="text" name="phone" id="editPhone" class="form-control"></div>
                <div class="mb-3"><label class="form-label">Email</label><input type="email" name="email" id="editEmail" class="form-control"></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="submit" class="btn btn-primary">Save Changes</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openEditModal(id, name, role, phone, email) {
        document.getElementById('editUserId').value = id;
        document.getElementById('editName').innerText = name + " (" + role + ")";
        document.getElementById('editPhone').value = (phone === '-' ? '' : phone);
        document.getElementById('editEmail').value = (email === '-' ? '' : email);
        new bootstrap.Modal(document.getElementById('editModal')).show();
    }
</script>
<jsp:include page="../common/footer.jsp" />