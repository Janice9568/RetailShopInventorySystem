<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../common/header.jsp" />

<main class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3><i class="bi bi-tags"></i> Category Management</h3>
        <button class="btn btn-primary" id="btnAddCategory">
            <i class="bi bi-plus-lg"></i> Add New Category
        </button>
    </div>

    <c:if test="${param.msg == 'success'}">
        <div class="alert alert-success alert-dismissible fade show">
            Category saved successfully!
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="card shadow-sm col-md-8 mx-auto border-0">
        <div class="card-body p-0">
            <table class="table table-hover mb-0">
                <thead class="table-dark">
                <tr>
                    <th class="ps-3">Category Name</th>
                    <th class="text-center" width="200">Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="cat" items="${categoryList}">
                    <tr>
                        <td class="ps-3"><strong>${cat.categoryName}</strong></td>
                        <td class="text-center">
                            <button class="btn btn-sm btn-outline-info btn-edit-cat"
                                    data-id="${cat.categoryId}"
                                    data-name="${cat.categoryName}">
                                <i class="bi bi-pencil"></i> Edit
                            </button>
                            <a href="${pageContext.request.contextPath}/categories?action=delete&id=${cat.categoryId}"
                               class="btn btn-sm btn-outline-danger"
                               onclick="return confirm('Deleting this category may affect existing products. Proceed?')">
                                <i class="bi bi-trash"></i>
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty categoryList}">
                    <tr><td colspan="2" class="text-center py-4">No categories defined.</td></tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</main>

<!-- Category Modal -->
<div class="modal fade" id="categoryModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <form action="${pageContext.request.contextPath}/categories" method="post" id="categoryForm" class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalTitle">Category Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" name="categoryId" id="formId">
                <div class="mb-3">
                    <label class="form-label">Category Name</label>
                    <input type="text" name="categoryName" id="formName" class="form-control" required>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-primary">Save Category</button>
            </div>
        </form>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const modalEl = document.getElementById('categoryModal');
        const catModal = new bootstrap.Modal(modalEl);
        const form = document.getElementById('categoryForm');

        document.getElementById('btnAddCategory').addEventListener('click', function() {
            form.reset();
            document.getElementById('formId').value = "";
            document.getElementById('modalTitle').innerText = "Add New Category";
            catModal.show();
        });

        document.querySelectorAll('.btn-edit-cat').forEach(btn => {
            btn.addEventListener('click', function() {
                document.getElementById('formId').value = this.dataset.id;
                document.getElementById('formName').value = this.dataset.name;
                document.getElementById('modalTitle').innerText = "Edit Category";
                catModal.show();
            });
        });
    });
</script>

<jsp:include page="../common/footer.jsp" />