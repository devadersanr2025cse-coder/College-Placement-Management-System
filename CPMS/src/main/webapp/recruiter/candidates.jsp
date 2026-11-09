<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Candidate Pipeline | CPMS Recruiter</title>
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
            <a href="${pageContext.request.contextPath}/recruiter/candidates" class="sidebar-link active">
                <i class="bi bi-person-lines-fill"></i> <span>Candidate Pipeline</span>
            </a>
            <a href="${pageContext.request.contextPath}/recruiter/interviews" class="sidebar-link">
                <i class="bi bi-calendar-check"></i> <span>Interviews</span>
            </a>
            <a href="${pageContext.request.contextPath}/recruiter/profile" class="sidebar-link">
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
                    <div class="meta text-truncate" title="${recruiter.companyName}"><c:out value="${recruiter.companyName}"/></div>
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
                <h4><c:out value="${recruiter.companyName}"/> Candidate Pipeline</h4>
            </div>
            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}/recruiter/dashboard" class="btn btn-outline-cpms py-1.5 px-3">
                    <i class="bi bi-arrow-left me-1"></i> Dashboard
                </a>
            </div>
        </header>

        <div class="content-body">

            <c:if test="${param.success == 'status'}">
                <div class="alert alert-success d-flex align-items-center gap-2 mb-4">
                    <i class="bi bi-check-circle-fill fs-5"></i>
                    <div>Candidate status updated and synchronized with Placement Cell!</div>
                </div>
            </c:if>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger d-flex align-items-center gap-2 mb-4">
                    <i class="bi bi-exclamation-triangle-fill fs-5"></i>
                    <div><c:out value="${errorMessage}"/></div>
                </div>
            </c:if>

            <div class="cpms-card">
                <div class="cpms-card-header">
                    <h5><i class="bi bi-people-fill text-primary"></i> Applied Candidates (${applicants.size()})</h5>
                    <div class="text-muted small">
                        <i class="bi bi-shield-check text-success me-1"></i> Verified Academic Data Only
                    </div>
                </div>
                <div class="table-responsive">
                    <table class="cpms-table">
                        <thead>
                            <tr>
                                <th>Candidate Name</th>
                                <th>Register Number</th>
                                <th>Department & Batch</th>
                                <th>Verified CGPA</th>
                                <th>Backlogs</th>
                                <th>Job Applied</th>
                                <th>Resume Document</th>
                                <th>Current Status</th>
                                <th>Update Decision</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty applicants}">
                                    <c:forEach var="app" items="${applicants}">
                                        <tr>
                                            <td>
                                                <div class="fw-bold text-navy-900"><c:out value="${app.studentName}"/></div>
                                                <div class="text-muted small"><c:out value="${app.studentEmail}"/></div>
                                            </td>
                                            <td><span class="badge bg-light text-dark border font-monospace"><c:out value="${app.registerNumber}"/></span></td>
                                            <td>
                                                <div><c:out value="${app.departmentName}"/></div>
                                                <div class="text-muted small">Batch <c:out value="${app.batchYear}"/></div>
                                            </td>
                                            <td><span class="badge bg-success-subtle text-success fs-6 fw-bold"><c:out value="${app.cgpa}"/></span></td>
                                            <td>
                                                <span class="badge ${app.activeBacklogs == 0 ? 'bg-success-subtle text-success' : 'bg-danger-subtle text-danger'} fw-bold">
                                                    <c:out value="${app.activeBacklogs}"/>
                                                </span>
                                            </td>
                                            <td>
                                                <div class="small fw-semibold text-navy-900"><c:out value="${app.jobTitle}"/></div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty app.resumeId}">
                                                        <a href="${pageContext.request.contextPath}/resume/download?id=${app.resumeId}" target="_blank" class="btn btn-sm btn-outline-danger py-0.5 px-2">
                                                            <i class="bi bi-file-earmark-pdf me-1"></i> Resume
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise><span class="text-muted small">—</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${app.applicationStatus == 'APPLIED'}"><span class="status-pill status-applied">Applied</span></c:when>
                                                    <c:when test="${app.applicationStatus == 'SHORTLISTED'}"><span class="status-pill status-shortlisted">Shortlisted</span></c:when>
                                                    <c:when test="${app.applicationStatus == 'SELECTED'}"><span class="status-pill status-selected">Selected / Hired</span></c:when>
                                                    <c:when test="${app.applicationStatus == 'REJECTED'}"><span class="status-pill status-rejected">Rejected</span></c:when>
                                                    <c:otherwise><span class="status-pill status-under-review">${app.applicationStatus}</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <form action="${pageContext.request.contextPath}/recruiter/candidates" method="post" class="d-flex gap-1">
                                                    <input type="hidden" name="applicationId" value="${app.applicationId}">
                                                    <select name="status" class="form-select form-select-sm" style="width: 125px;">
                                                        <option value="SHORTLISTED" ${app.applicationStatus == 'SHORTLISTED' ? 'selected' : ''}>Shortlist</option>
                                                        <option value="SELECTED" ${app.applicationStatus == 'SELECTED' ? 'selected' : ''}>Select / Hire</option>
                                                        <option value="REJECTED" ${app.applicationStatus == 'REJECTED' ? 'selected' : ''}>Reject</option>
                                                        <option value="UNDER_REVIEW" ${app.applicationStatus == 'UNDER_REVIEW' ? 'selected' : ''}>Under Review</option>
                                                    </select>
                                                    <button type="submit" class="btn btn-sm btn-primary-cpms py-0.5 px-2">Save</button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="9" class="text-center py-5 text-muted">No candidate applications in your pipeline.</td>
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

