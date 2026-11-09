<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Company Profile | CPMS Recruiter</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <!-- CPMS Theme -->
    <link href="${pageContext.request.contextPath}/assets/css/cpms-theme.css" rel="stylesheet">
</head>
<body>

<div class="app-wrapper">

    <!-- Recruiter Sidebar Navigation -->
    <aside class="app-sidebar">
        <div class="sidebar-brand">
            <a href="${pageContext.request.contextPath}/recruiter/dashboard">
                <i class="bi bi-briefcase-fill text-success"></i>
                <span>CPMS</span>
                <span class="badge-role bg-success text-white ms-auto">Recruiter</span>
            </a>
        </div>

        <div class="sidebar-menu">
            <div class="nav-section-title">Hiring Portal</div>
            <a href="${pageContext.request.contextPath}/recruiter/dashboard" class="sidebar-link">
                <i class="bi bi-speedometer2"></i> <span>Dashboard</span>
            </a>
            <a href="${pageContext.request.contextPath}/recruiter/jobs" class="sidebar-link">
                <i class="bi bi-briefcase"></i> <span>Job Postings</span>
            </a>
            <a href="${pageContext.request.contextPath}/recruiter/candidates" class="sidebar-link">
                <i class="bi bi-person-lines-fill"></i> <span>Candidate Pipeline</span>
            </a>
            <a href="${pageContext.request.contextPath}/recruiter/interviews" class="sidebar-link">
                <i class="bi bi-calendar-check"></i> <span>Interviews</span>
            </a>
            <a href="${pageContext.request.contextPath}/recruiter/profile" class="sidebar-link active">
                <i class="bi bi-building"></i> <span>Company Profile</span>
            </a>
        </div>

        <div class="sidebar-footer">
            <div class="user-profile-widget">
                <div class="user-avatar bg-success text-white">
                    <c:out value="${sessionScope.fullName.substring(0,1)}"/>
                </div>
                <div class="user-info">
                    <div class="name"><c:out value="${sessionScope.fullName}"/></div>
                    <div class="meta text-truncate" title="${sessionScope.companyName}"><c:out value="${sessionScope.companyName}"/></div>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="text-danger fs-5" title="Sign Out">
                    <i class="bi bi-box-arrow-right"></i>
                </a>
            </div>
        </div>
    </aside>

    <!-- Main Content Area -->
    <main class="app-main">
        <header class="app-topbar">
            <div class="topbar-title">
                <h4>Company Profile & Recruiter Credentials</h4>
            </div>
            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}/recruiter/dashboard" class="btn btn-outline-cpms py-1.5 px-3">
                    <i class="bi bi-arrow-left me-1"></i> Dashboard
                </a>
            </div>
        </header>

        <div class="content-body">

            <c:if test="${param.success == 'saved'}">
                <div class="alert alert-success d-flex align-items-center gap-2 mb-4">
                    <i class="bi bi-check-circle-fill fs-5"></i>
                    <div>Company details updated successfully!</div>
                </div>
            </c:if>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger d-flex align-items-center gap-2 mb-4">
                    <i class="bi bi-exclamation-triangle-fill fs-5"></i>
                    <div><c:out value="${errorMessage}"/></div>
                </div>
            </c:if>

            <div class="row g-4">
                
                <!-- Company Profile Edit Form -->
                <div class="col-lg-8">
                    <div class="cpms-card">
                        <div class="cpms-card-header">
                            <h5><i class="bi bi-building-gear text-primary"></i> Company Corporate Details</h5>
                        </div>
                        <div class="cpms-card-body">
                            <form action="${pageContext.request.contextPath}/recruiter/profile" method="post">
                                
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label small fw-semibold text-muted">Company Name *</label>
                                        <input type="text" name="companyName" class="form-control" value="<c:out value='${company.companyName}'/>" required>
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label small fw-semibold text-muted">Industry Sector</label>
                                        <input type="text" name="industry" class="form-control" value="<c:out value='${company.industry}'/>">
                                    </div>

                                    <div class="col-12">
                                        <label class="form-label small fw-semibold text-muted">Corporate Website</label>
                                        <input type="url" name="website" class="form-control" value="<c:out value='${company.website}'/>" placeholder="https://example.com">
                                    </div>

                                    <div class="col-12">
                                        <label class="form-label small fw-semibold text-muted">Company Overview & Description</label>
                                        <textarea name="description" class="form-control" rows="3"><c:out value="${company.description}"/></textarea>
                                    </div>

                                    <div class="col-md-4">
                                        <label class="form-label small fw-semibold text-muted">HR Lead / Contact Person</label>
                                        <input type="text" name="contactPerson" class="form-control" value="<c:out value='${company.contactPerson}'/>">
                                    </div>

                                    <div class="col-md-4">
                                        <label class="form-label small fw-semibold text-muted">Official Contact Email</label>
                                        <input type="email" name="contactEmail" class="form-control" value="<c:out value='${company.contactEmail}'/>">
                                    </div>

                                    <div class="col-md-4">
                                        <label class="form-label small fw-semibold text-muted">Contact Phone</label>
                                        <input type="text" name="contactPhone" class="form-control" value="<c:out value='${company.contactPhone}'/>">
                                    </div>
                                </div>

                                <div class="mt-4 pt-3 border-top">
                                    <button type="submit" class="btn btn-primary-cpms px-4">
                                        <i class="bi bi-save me-1"></i> Update Company Profile
                                    </button>
                                </div>

                            </form>
                        </div>
                    </div>
                </div>

                <!-- Recruiter User Card -->
                <div class="col-lg-4">
                    <div class="cpms-card">
                        <div class="cpms-card-header">
                            <h5><i class="bi bi-person-circle text-primary"></i> Recruiter Account</h5>
                        </div>
                        <div class="cpms-card-body">
                            <ul class="list-group list-group-flush mb-3">
                                <li class="list-group-item d-flex justify-content-between px-0">
                                    <span class="text-muted small">Account Name</span>
                                    <span class="fw-semibold text-navy-900"><c:out value="${recruiter.fullName}"/></span>
                                </li>
                                <li class="list-group-item d-flex justify-content-between px-0">
                                    <span class="text-muted small">Company Email</span>
                                    <span class="small text-navy-900"><c:out value="${recruiter.email}"/></span>
                                </li>
                                <li class="list-group-item d-flex justify-content-between px-0">
                                    <span class="text-muted small">Designation</span>
                                    <span class="badge bg-light text-dark border"><c:out value="${recruiter.designation}"/></span>
                                </li>
                                <li class="list-group-item d-flex justify-content-between px-0">
                                    <span class="text-muted small">Associated Company</span>
                                    <span class="fw-bold text-success"><c:out value="${recruiter.companyName}"/></span>
                                </li>
                                <li class="list-group-item d-flex justify-content-between px-0">
                                    <span class="text-muted small">Registration Date</span>
                                    <span class="small text-muted"><c:out value="${recruiter.createdAt}"/></span>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>

            </div>

        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

