<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../common/header.jsp" />

<main class="container mt-4">
    <div class="row">
        <!-- Registration Form -->
        <div class="col-md-4">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-primary text-white py-3">
                    <h5 class="mb-0">Register New Staff</h5>
                </div>
                <div class="card-body">
                    <form action="users" method="post">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Real Name</label>
                            <input type="text" name="fullName" class="form-control" placeholder="e.g. John Doe" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Contact Number</label>
                            <input type="text" name="phone" class="form-control" placeholder="e.g. 012-3456789">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Email Address</label>
                            <input type="email" name="email" class="form-control" placeholder="staff@mail.com">
                        </div>

                        <hr>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Username</label>
                            <input type="text" name="username" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Password</label>
                            <input type="password" name="password" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Staff Role</label>
                            <select name="role" class="form-select">
                                <option value="CASHIER">Cashier Staff</option>
                                <option value="INVENTORY_STAFF">Inventory Staff</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-primary w-100 py-2 mt-2">
                            <i class="bi bi-person-plus"></i> Create Account
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <!-- Staff List Table -->
        <div class="col-md-8">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-white py-3">
                    <h5 class="mb-0 fw-bold">Registered Staff Directory</h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0 align-middle">
                            <thead class="table-light">
                            <tr>
                                <th class="ps-3">Name / Username</th>
                                <th>Contact Info</th>
                                <th>Role</th>
                                <th class="text-center">Action</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="u" items="${staffList}">
                                <tr>
                                    <td class="ps-3">
                                        <div class="fw-bold">${u.fullName}</div>
                                        <small class="text-muted">@${u.username}</small>
                                    </td>
                                    <td>
                                        <div class="small"><i class="bi bi-telephone text-muted me-1"></i> ${u.phone}</div>
                                        <div class="small"><i class="bi bi-envelope text-muted me-1"></i> ${u.email}</div>
                                    </td>
                                    <td>
                                            <span class="badge ${u.role == 'CASHIER' ? 'bg-info' : 'bg-secondary'}">
                                                    ${u.role}
                                            </span>
                                    </td>
                                    <td class="text-center">
                                        <a href="users?action=delete&id=${u.userId}"
                                           class="btn btn-sm btn-outline-danger"
                                           onclick="return confirm('Permanently remove this staff member?')">
                                            <i class="bi bi-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty staffList}">
                                <tr><td colspan="4" class="text-center py-4 text-muted">No staff members registered yet.</td></tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />