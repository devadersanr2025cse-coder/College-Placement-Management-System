<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recruiter Dashboard | CPMS</title>
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
            <a href="${pageContext.request.contextPath}/recruiter/dashboard" class="sidebar-link active">
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
                <h4><i class="bi bi-building text-primary me-2"></i><c:out value="${recruiter.companyName}"/> — Recruitment Console</h4>
            </div>
            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}/recruiter/jobs" class="btn btn-primary-cpms py-1.5 px-3">
                    <i class="bi bi-plus-lg me-1"></i> Post New Job
                </a>
            </div>
        </header>

        <div class="content-body">

            <!-- Company Welcome Banner -->
            <div class="cpms-card mb-4" style="background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%); color: #ffffff;">
                <div class="cpms-card-body p-4">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <span class="badge bg-success px-3 py-1 mb-2 text-uppercase fw-semibold">Authorized Corporate Recruiter</span>
                            <h3 class="fw-bold mb-1"><c:out value="${recruiter.companyName}"/></h3>
                            <p class="text-slate-400 mb-0" style="color: #94a3b8;">
                                Logged in as: <strong class="text-white"><c:out value="${recruiter.fullName}"/></strong> (<c:out value="${recruiter.designation}"/>)
                            </p>
                        </div>
                        <a href="${pageContext.request.contextPath}/recruiter/profile" class="btn btn-outline-light btn-sm px-3">
                            <i class="bi bi-pencil-square me-1"></i> Edit Company Info
                        </a>
                    </div>
                </div>
            </div>

            <!-- Recruiter Metric Cards Row -->
            <div class="row g-3 mb-4">
                <div class="col-xl-3 col-sm-6">
                    <div class="stat-widget">
                        <div class="stat-content">
                            <div class="stat-label">Active Drives</div>
                            <div class="stat-value"><c:out value="${metrics.activeJobs}"/></div>
                        </div>
                        <div class="stat-icon icon-blue">
                            <i class="bi bi-briefcase-fill"></i>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-sm-6">
                    <div class="stat-widget">
                        <div class="stat-content">
                            <div class="stat-label">Total Applicants</div>
                            <div class="stat-value"><c:out value="${metrics.totalApplicants}"/></div>
                        </div>
                        <div class="stat-icon icon-purple">
                            <i class="bi bi-people-fill"></i>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-sm-6">
                    <div class="stat-widget">
                        <div class="stat-content">
                            <div class="stat-label">Shortlisted Candidates</div>
                            <div class="stat-value text-warning"><c:out value="${metrics.shortlistedCount}"/></div>
                        </div>
                        <div class="stat-icon icon-amber">
                            <i class="bi bi-star-fill"></i>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-sm-6">
                    <div class="stat-widget">
                        <div class="stat-content">
                            <div class="stat-label">Selected / Hired</div>
                            <div class="stat-value text-success"><c:out value="${metrics.selectedCount}"/></div>
                        </div>
                        <div class="stat-icon icon-green">
                            <i class="bi bi-trophy-fill"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row g-4">
                
                <!-- Recent Candidate Applications -->
                <div class="col-lg-8">
                    <div class="cpms-card">
                        <div class="cpms-card-header">
                            <h5><i class="bi bi-person-check-fill text-primary"></i> Candidate Submissions (${applicants.size()})</h5>
                            <a href="${pageContext.request.contextPath}/recruiter/candidates" class="btn btn-outline-cpms btn-sm">Full Pipeline &rarr;</a>
                        </div>
                        <div class="table-responsive">
                            <table class="cpms-table">
                                <thead>
                                    <tr>
                                        <th>Candidate</th>
                                        <th>Applied Job</th>
                                        <th>Verified CGPA</th>
                                        <th>Backlogs</th>
                                        <th>Resume</th>
                                        <th>Status</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty applicants}">
                                            <c:forEach var="app" items="${applicants}" end="5">
                                                <tr>
                                                    <td>
                                                        <div class="fw-bold text-navy-900"><c:out value="${app.studentName}"/></div>
                                                        <div class="text-muted small"><c:out value="${app.registerNumber}"/> • <c:out value="${app.departmentName}"/></div>
                                                    </td>
                                                    <td><div class="small fw-semibold"><c:out value="${app.jobTitle}"/></div></td>
                                                    <td><span class="badge bg-success-subtle text-success fs-6 fw-bold"><c:out value="${app.cgpa}"/></span></td>
                                                    <td>
                                                        <span class="badge ${app.activeBacklogs == 0 ? 'bg-success-subtle text-success' : 'bg-danger-subtle text-danger'} fw-bold">
                                                            <c:out value="${app.activeBacklogs}"/>
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty app.resumeId}">
                                                                <a href="${pageContext.request.contextPath}/resume/download?id=${app.resumeId}" target="_blank" class="btn btn-sm btn-outline-danger py-0.5 px-2">
                                                                    <i class="bi bi-file-earmark-pdf"></i> PDF
                                                                </a>
                                                            </c:when>
                                                            <c:otherwise><span class="text-muted small">—</span></c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${app.applicationStatus == 'SHORTLISTED'}"><span class="status-pill status-shortlisted">Shortlisted</span></c:when>
                                                            <c:when test="${app.applicationStatus == 'SELECTED'}"><span class="status-pill status-selected">Selected</span></c:when>
                                                            <c:when test="${app.applicationStatus == 'REJECTED'}"><span class="status-pill status-rejected">Rejected</span></c:when>
                                                            <c:otherwise><span class="status-pill status-applied">${app.applicationStatus}</span></c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/recruiter/candidates?viewStudentId=${app.studentId}" class="btn btn-sm btn-outline-primary py-0.5 px-2">
                                                            View
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="7" class="text-center py-4 text-muted small">No candidate applications received yet.</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Right Column: Company Drives -->
                <div class="col-lg-4">
                    <div class="cpms-card">
                        <div class="cpms-card-header">
                            <h5><i class="bi bi-briefcase text-primary"></i> Company Job Postings</h5>
                            <a href="${pageContext.request.contextPath}/recruiter/jobs" class="small text-decoration-none">View All</a>
                        </div>
                        <div class="cpms-card-body p-0">
                            <div class="list-group list-group-flush">
                                <c:choose>
                                    <c:when test="${not empty jobs}">
                                        <c:forEach var="j" items="${jobs}">
                                            <div class="list-group-item p-3">
                                                <div class="d-flex justify-content-between align-items-center mb-1">
                                                    <strong class="text-navy-900 small"><c:out value="${j.jobTitle}"/></strong>
                                                    <span class="status-pill ${j.jobStatus == 'OPEN' ? 'status-approved' : 'status-rejected'}">${j.jobStatus}</span>
                                                </div>
                                                <div class="text-muted small mb-1">
                                                    <c:out value="${j.location}"/> • <c:out value="${j.packageLpa}"/> LPA
                                                </div>
                                                <div class="small text-primary">
                                                    <i class="bi bi-people me-1"></i>${j.applicantCount} Candidates Applied
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-4 text-muted small">No job postings active.</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
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

