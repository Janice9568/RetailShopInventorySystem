<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../common/header.jsp" />

<main class="container mt-4">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="javascript:history.back()">Back</a></li>
            <li class="breadcrumb-item active">Supplier Details</li>
        </ol>
    </nav>

    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-dark text-white py-3">
                    <h5 class="mb-0"><i class="bi bi-person-lines-fill"></i> Contact Information</h5>
                </div>
                <div class="card-body p-4">
                    <h3 class="fw-bold text-primary mb-4">${supplier.supplierName}</h3>

                    <div class="mb-3">
                        <label class="text-muted small text-uppercase fw-bold">Contact Person</label>
                        <p class="fs-5">${supplier.contactPerson != null ? supplier.contactPerson : 'Not Specified'}</p>
                    </div>

                    <div class="mb-3">
                        <label class="text-muted small text-uppercase fw-bold">Phone Number</label>
                        <p class="fs-5 text-success fw-bold">
                            <i class="bi bi-telephone"></i> ${supplier.phone}
                        </p>
                    </div>

                    <div class="mb-3">
                        <label class="text-muted small text-uppercase fw-bold">Email Address</label>
                        <p class="fs-5">
                            <i class="bi bi-envelope"></i> <a href="mailto:${supplier.email}">${supplier.email}</a>
                        </p>
                    </div>

                    <div class="mb-0">
                        <label class="text-muted small text-uppercase fw-bold">Office Address</label>
                        <p class="fs-6">${supplier.address}</p>
                    </div>
                </div>
                <div class="card-footer bg-light text-center">
                    <button onclick="window.print()" class="btn btn-sm btn-outline-secondary">
                        <i class="bi bi-printer"></i> Print Contact Info
                    </button>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />