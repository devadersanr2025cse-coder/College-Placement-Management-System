<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Candidate Profile | CPMS Recruiter</title>
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
                <h4>Candidate Dossier: <c:out value="${candidate.fullName}"/></h4>
            </div>
            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}/recruiter/candidates" class="btn btn-outline-cpms py-1.5 px-3">
                    <i class="bi bi-arrow-left me-1"></i> Back to Candidates
                </a>
            </div>
        </header>

        <div class="content-body">

            <div class="row g-4">
                
                <!-- Candidate Details Card -->
                <div class="col-lg-5">
                    <div class="cpms-card">
                        <div class="cpms-card-header">
                            <h5><i class="bi bi-person-badge-fill text-primary"></i> Academic & Contact Information</h5>
                        </div>
                        <div class="cpms-card-body">
                            <div class="text-center py-3 border-bottom mb-3">
                                <div class="user-avatar bg-primary text-white mx-auto mb-2" style="width: 56px; height: 56px; font-size: 1.5rem;">
                                    <c:out value="${candidate.fullName.substring(0,1)}"/>
                                </div>
                                <h5 class="fw-bold mb-0 text-navy-900"><c:out value="${candidate.fullName}"/></h5>
                                <div class="text-muted small font-monospace"><c:out value="${candidate.registerNumber}"/></div>
                            </div>

                            <ul class="list-group list-group-flush mb-4">
                                <li class="list-group-item d-flex justify-content-between px-0">
                                    <span class="text-muted small">Department</span>
                                    <span class="fw-semibold text-navy-900"><c:out value="${candidate.departmentName}"/></span>
                                </li>
                                <li class="list-group-item d-flex justify-content-between px-0">
                                    <span class="text-muted small">Batch Year</span>
                                    <span class="fw-semibold text-navy-900"><c:out value="${candidate.batchYear}"/></span>
                                </li>
                                <li class="list-group-item d-flex justify-content-between px-0">
                                    <span class="text-muted small">Verified CGPA</span>
                                    <span class="badge bg-success-subtle text-success fs-6 fw-bold"><c:out value="${candidate.cgpa}"/> / 10.00</span>
                                </li>
                                <li class="list-group-item d-flex justify-content-between px-0">
                                    <span class="text-muted small">Active Backlogs</span>
                                    <span class="badge ${candidate.activeBacklogs == 0 ? 'bg-success-subtle text-success' : 'bg-danger-subtle text-danger'} fs-6 fw-bold"><c:out value="${candidate.activeBacklogs}"/></span>
                                </li>
                                <li class="list-group-item d-flex justify-content-between px-0">
                                    <span class="text-muted small">Email Address</span>
                                    <span class="small text-navy-900"><c:out value="${candidate.email}"/></span>
                                </li>
                                <li class="list-group-item d-flex justify-content-between px-0">
                                    <span class="text-muted small">Phone Contact</span>
                                    <span class="small text-navy-900"><c:out value="${not empty candidate.phone ? candidate.phone : '—'}"/></span>
                                </li>
                            </ul>

                            <c:if test="${not empty candidate.activeResumeId}">
                                <a href="${pageContext.request.contextPath}/resume/download?id=${candidate.activeResumeId}" target="_blank" class="btn btn-danger w-100 py-2">
                                    <i class="bi bi-file-earmark-pdf-fill me-1"></i> Download Verified Resume
                                </a>
                            </c:if>
                        </div>
                    </div>
                </div>

                <!-- Resume Preview Column -->
                <div class="col-lg-7">
                    <div class="cpms-card h-100">
                        <div class="cpms-card-header">
                            <h5><i class="bi bi-file-earmark-pdf text-danger"></i> Candidate Resume Document</h5>
                            <c:if test="${not empty candidate.activeResumeId}">
                                <a href="${pageContext.request.contextPath}/resume/download?id=${candidate.activeResumeId}" target="_blank" class="btn btn-outline-cpms btn-sm">
                                    <i class="bi bi-box-arrow-up-right me-1"></i> Pop-Out Viewer
                                </a>
                            </c:if>
                        </div>
                        <div class="cpms-card-body p-0" style="min-height: 550px;">
                            <c:choose>
                                <c:when test="${not empty candidate.activeResumeId}">
                                    <iframe src="${pageContext.request.contextPath}/resume/download?id=${candidate.activeResumeId}" width="100%" height="550" style="border: none;"></iframe>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-5 text-muted">
                                        <i class="bi bi-file-earmark-x fs-1 d-block mb-2"></i>
                                        No active resume file uploaded by candidate.
                                    </div>
                                </c:otherwise>
                            </c:choose>
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

