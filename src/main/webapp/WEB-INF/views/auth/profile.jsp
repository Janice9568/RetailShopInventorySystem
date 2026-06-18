<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../common/header.jsp" />

<main class="container mt-4">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-dark text-white py-3">
                    <h5 class="mb-0"><i class="bi bi-person-bounding-box"></i> My Profile</h5>
                </div>
                <div class="card-body p-4">
                    <c:if test="${param.msg == 'updated'}">
                        <div class="alert alert-success">Profile updated successfully!</div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/profile" method="post">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Username</label>
                            <input type="text" class="form-control bg-light" value="${currentUser.username}" readonly>
                            <small class="text-muted">Username cannot be changed.</small>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Role</label>
                            <input type="text" class="form-control bg-light" value="${currentUser.role}" readonly>
                        </div>

                        <hr>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Real Name (Full Name)</label>
                            <input type="text" name="fullName" class="form-control" value="${currentUser.fullName}" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Contact Number</label>
                            <input type="text" name="phone" class="form-control" value="${currentUser.phone}" placeholder="e.g. 012-3456789">
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Email Address</label>
                            <input type="email" name="email" class="form-control" value="${currentUser.email}" placeholder="example@mail.com">
                        </div>

                        <div class="d-grid mt-4">
                            <button type="submit" class="btn btn-primary">Update Profile Information</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />