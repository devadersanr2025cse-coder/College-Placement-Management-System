<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Company Partners | CPMS Officer</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <!-- CPMS Theme -->
    <link href="${pageContext.request.contextPath}/assets/css/cpms-theme.css" rel="stylesheet">
</head>
<body>

<div class="app-wrapper">

    <!-- Officer Sidebar Navigation -->
    <aside class="app-sidebar">
        <div class="sidebar-brand">
            <a href="${pageContext.request.contextPath}/officer/dashboard">
                <i class="bi bi-shield-check text-warning"></i>
                <span>CPMS</span>
                <span class="badge-role bg-warning text-dark ms-auto">Officer</span>
            </a>
        </div>

        <div class="sidebar-menu">
            <div class="nav-section-title">Administration</div>
            <a href="${pageContext.request.contextPath}/officer/dashboard" class="sidebar-link">
                <i class="bi bi-speedometer2"></i> <span>Dashboard</span>
            </a>
            <a href="${pageContext.request.contextPath}/officer/verifications" class="sidebar-link">
                <i class="bi bi-check2-circle"></i> <span>Verification Queue</span>
            </a>
            <a href="${pageContext.request.contextPath}/officer/students" class="sidebar-link">
                <i class="bi bi-people"></i> <span>Student Directory</span>
            </a>
            <a href="${pageContext.request.contextPath}/officer/companies" class="sidebar-link active">
                <i class="bi bi-building"></i> <span>Companies</span>
            </a>
            <a href="${pageContext.request.contextPath}/officer/jobs" class="sidebar-link">
                <i class="bi bi-briefcase"></i> <span>Job Postings</span>
            </a>
            <a href="${pageContext.request.contextPath}/officer/interviews" class="sidebar-link">
                <i class="bi bi-calendar3"></i> <span>Interviews</span>
            </a>
            <a href="${pageContext.request.contextPath}/officer/resumes" class="sidebar-link">
                <i class="bi bi-file-earmark-person"></i> <span>Resume Review</span>
            </a>
            <a href="${pageContext.request.contextPath}/officer/messages" class="sidebar-link">
                <i class="bi bi-chat-quote"></i> <span>Announcements</span>
            </a>
            <a href="${pageContext.request.contextPath}/officer/reports" class="sidebar-link">
                <i class="bi bi-file-earmark-bar-graph"></i> <span>Reports & Export</span>
            </a>
        </div>

        <div class="sidebar-footer">
            <div class="user-profile-widget">
                <div class="user-avatar bg-warning text-dark">
                    <c:out value="${sessionScope.fullName.substring(0,1)}"/>
                </div>
                <div class="user-info">
                    <div class="name"><c:out value="${sessionScope.fullName}"/></div>
                    <div class="meta">Placement Officer</div>
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
                <h4>Hiring Company Partners</h4>
            </div>
            <div class="topbar-actions">
                <button type="button" class="btn btn-primary-cpms py-1.5 px-3" data-bs-toggle="modal" data-bs-target="#addCompanyModal">
                    <i class="bi bi-building-add me-1"></i> Register Company
                </button>
            </div>
        </header>

        <div class="content-body">

            <c:if test="${param.success == 'saved'}">
                <div class="alert alert-success d-flex align-items-center gap-2 mb-4">
                    <i class="bi bi-check-circle-fill fs-5"></i>
                    <div>Company details saved successfully!</div>
                </div>
            </c:if>

            <c:if test="${param.success == 'status'}">
                <div class="alert alert-info d-flex align-items-center gap-2 mb-4">
                    <i class="bi bi-info-circle-fill fs-5"></i>
                    <div>Company status updated.</div>
                </div>
            </c:if>

            <div class="cpms-card">
                <div class="cpms-card-header">
                    <h5><i class="bi bi-buildings-fill text-primary"></i> Partner Directory (${companies.size()})</h5>
                </div>
                <div class="table-responsive">
                    <table class="cpms-table">
                        <thead>
                            <tr>
                                <th>Company Name</th>
                                <th>Industry</th>
                                <th>HR Contact Person</th>
                                <th>Contact Email & Phone</th>
                                <th>Jobs Posted</th>
                                <th>Total Hired</th>
                                <th>Access Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty companies}">
                                    <c:forEach var="comp" items="${companies}">
                                        <tr>
                                            <td>
                                                <div class="fw-bold text-navy-900"><c:out value="${comp.companyName}"/></div>
                                                <c:if test="${not empty comp.website}">
                                                    <a href="<c:out value='${comp.website}'/>" target="_blank" class="small text-muted text-decoration-none">
                                                        <i class="bi bi-globe me-1"></i><c:out value="${comp.website}"/>
                                                    </a>
                                                </c:if>
                                            </td>
                                            <td><span class="small"><c:out value="${comp.industry}"/></span></td>
                                            <td><span class="small fw-semibold"><c:out value="${comp.contactPerson}"/></span></td>
                                            <td>
                                                <div class="small"><c:out value="${comp.contactEmail}"/></div>
                                                <div class="small text-muted"><c:out value="${comp.contactPhone}"/></div>
                                            </td>
                                            <td><span class="badge bg-light text-dark border">${comp.jobCount}</span></td>
                                            <td><strong class="text-success">${comp.placementCount}</strong></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${comp.active}">
                                                        <span class="badge bg-success-subtle text-success border border-success-subtle">Active</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-danger-subtle text-danger border border-danger-subtle">Inactive</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/officer/companies?toggle=${comp.companyId}&active=${not comp.active}" class="btn btn-sm ${comp.active ? 'btn-outline-danger' : 'btn-outline-success'} py-0.5 px-2">
                                                    ${comp.active ? 'Deactivate' : 'Activate'}
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="8" class="text-center py-5 text-muted">No hiring companies registered yet.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </main>
</div>

<!-- Add Company Modal -->
<div class="modal fade" id="addCompanyModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/officer/companies" method="post">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Register Hiring Partner Company</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-muted">Company Name *</label>
                        <input type="text" name="companyName" class="form-control" placeholder="e.g. Acme Technologies" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-muted">Website</label>
                        <input type="url" name="website" class="form-control" placeholder="https://example.com">
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-muted">Industry Sector</label>
                        <input type="text" name="industry" class="form-control" placeholder="e.g. Software & Cloud Computing">
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-muted">Description</label>
                        <textarea name="description" class="form-control" rows="2" placeholder="Brief company summary"></textarea>
                    </div>
                    <div class="row g-2 mb-3">
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-muted">Contact Person</label>
                            <input type="text" name="contactPerson" class="form-control" placeholder="HR Lead / Recruiter">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-muted">Contact Phone</label>
                            <input type="text" name="contactPhone" class="form-control" placeholder="Mobile / Phone">
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-muted">Contact Email</label>
                        <input type="email" name="contactEmail" class="form-control" placeholder="careers@company.com">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary-cpms">Register Company</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

