<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard | CPMS</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <!-- CPMS Theme -->
    <link href="${pageContext.request.contextPath}/assets/css/cpms-theme.css" rel="stylesheet">
</head>
<body>

<div class="app-wrapper">

    <!-- Sidebar Navigation -->
    <aside class="app-sidebar">
        <div class="sidebar-brand">
            <a href="${pageContext.request.contextPath}/student/dashboard">
                <i class="bi bi-mortarboard-fill text-primary"></i>
                <span>CPMS</span>
                <span class="badge-role bg-primary text-white ms-auto">Student</span>
            </a>
        </div>

        <div class="sidebar-menu">
            <div class="nav-section-title">Navigation</div>
            <a href="${pageContext.request.contextPath}/student/dashboard" class="sidebar-link active">
                <i class="bi bi-grid-1x2-fill"></i> <span>Dashboard</span>
            </a>
            <a href="${pageContext.request.contextPath}/student/profile" class="sidebar-link">
                <i class="bi bi-person-badge"></i> <span>My Profile</span>
            </a>
            <a href="${pageContext.request.contextPath}/student/academic" class="sidebar-link">
                <i class="bi bi-award"></i> <span>Academic Info</span>
                <c:if test="${student.hasPendingUpdate}">
                    <span class="badge bg-warning text-dark ms-auto" style="font-size: 0.65rem;">Pending</span>
                </c:if>
            </a>
            <a href="${pageContext.request.contextPath}/student/jobs" class="sidebar-link">
                <i class="bi bi-briefcase"></i> <span>Job Openings</span>
            </a>
            <a href="${pageContext.request.contextPath}/student/applications" class="sidebar-link">
                <i class="bi bi-send-check"></i> <span>Applications</span>
            </a>
            <a href="${pageContext.request.contextPath}/student/resume" class="sidebar-link">
                <i class="bi bi-file-earmark-pdf"></i> <span>Resume Manager</span>
            </a>
            <a href="${pageContext.request.contextPath}/student/interviews" class="sidebar-link">
                <i class="bi bi-calendar-event"></i> <span>Interviews</span>
            </a>
            <a href="${pageContext.request.contextPath}/student/messages" class="sidebar-link">
                <i class="bi bi-chat-left-dots"></i> <span>Messages</span>
            </a>
            <a href="${pageContext.request.contextPath}/student/notifications" class="sidebar-link">
                <i class="bi bi-bell"></i> <span>Notifications</span>
            </a>
        </div>

        <div class="sidebar-footer">
            <div class="user-profile-widget">
                <div class="user-avatar">
                    <c:out value="${sessionScope.fullName.substring(0,1)}"/>
                </div>
                <div class="user-info">
                    <div class="name"><c:out value="${sessionScope.fullName}"/></div>
                    <div class="meta"><c:out value="${student.registerNumber}"/></div>
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
                <h4>Student Placement Dashboard</h4>
            </div>
            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}/student/notifications" class="btn btn-outline-cpms position-relative py-1.5 px-3">
                    <i class="bi bi-bell"></i>
                    <c:if test="${not empty notifications and notifications.size() > 0}">
                        <span class="position-absolute top-0 start-100 translate-middle p-1.5 bg-danger border border-light rounded-circle"></span>
                    </c:if>
                </a>
                <a href="${pageContext.request.contextPath}/student/profile" class="btn btn-outline-cpms py-1.5 px-3">
                    <i class="bi bi-gear me-1"></i> Profile Settings
                </a>
            </div>
        </header>

        <div class="content-body">

            <!-- Welcome & Academic Status Banner -->
            <div class="cpms-card mb-4" style="background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%); color: #ffffff;">
                <div class="cpms-card-body p-4">
                    <div class="row align-items-center">
                        <div class="col-lg-8">
                            <span class="badge bg-primary px-3 py-1 mb-2 text-uppercase fw-semibold" style="letter-spacing: 0.5px;">
                                <c:out value="${student.departmentName}"/> • Batch <c:out value="${student.batchYear}"/>
                            </span>
                            <h3 class="fw-bold mb-1">Welcome back, <c:out value="${student.fullName}"/>!</h3>
                            <p class="text-slate-400 mb-3" style="color: #94a3b8;">
                                Register Number: <strong class="text-white"><c:out value="${student.registerNumber}"/></strong> | 
                                Official CGPA: <strong class="text-success"><c:out value="${student.cgpa}"/></strong> | 
                                Active Backlogs: <strong class="text-white"><c:out value="${student.activeBacklogs}"/></strong>
                            </p>

                            <!-- Profile Completion Bar -->
                            <div class="d-flex align-items-center gap-3" style="max-width: 480px;">
                                <div class="progress flex-grow-1" style="height: 8px; background: rgba(255,255,255,0.15);">
                                    <div class="progress-bar bg-primary" role="progressbar" style="width: ${profileCompletion}%;" aria-valuenow="${profileCompletion}" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                                <span class="small text-slate-300" style="color: #cbd5e1;">Profile: ${profileCompletion}%</span>
                            </div>
                        </div>

                        <div class="col-lg-4 text-lg-end mt-3 mt-lg-0">
                            <c:choose>
                                <c:when test="${student.hasPendingUpdate}">
                                    <div class="p-3 rounded-3" style="background-color: rgba(234, 179, 8, 0.15); border: 1px solid rgba(234, 179, 8, 0.4);">
                                        <div class="d-flex align-items-center gap-2 text-warning mb-1">
                                            <i class="bi bi-clock-history fs-5"></i>
                                            <span class="fw-bold">Academic Update Pending</span>
                                        </div>
                                        <div class="small text-slate-300" style="color: #e2e8f0;">
                                            Submitted CGPA: <strong>${student.pendingCgpa}</strong> (Backlogs: ${student.pendingBacklogs}).
                                            <div class="text-warning-emphasis">Awaiting placement officer review.</div>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="p-3 rounded-3" style="background-color: rgba(34, 197, 94, 0.12); border: 1px solid rgba(34, 197, 94, 0.3);">
                                        <div class="d-flex align-items-center gap-2 text-success mb-1">
                                            <i class="bi bi-check-circle-fill fs-5"></i>
                                            <span class="fw-bold">Academics Verified</span>
                                        </div>
                                        <div class="small" style="color: #cbd5e1;">
                                            Official placement record verified by Placement Cell.
                                            <a href="${pageContext.request.contextPath}/student/academic" class="d-block text-primary text-decoration-none mt-1">Request CGPA Update &rarr;</a>
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Application Metric Cards -->
            <div class="row g-3 mb-4">
                <div class="col-xl-3 col-sm-6">
                    <div class="stat-widget">
                        <div class="stat-content">
                            <div class="stat-label">Total Applications</div>
                            <div class="stat-value">${totalApps}</div>
                        </div>
                        <div class="stat-icon icon-blue">
                            <i class="bi bi-send"></i>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-sm-6">
                    <div class="stat-widget">
                        <div class="stat-content">
                            <div class="stat-label">Shortlisted</div>
                            <div class="stat-value">${shortlistedApps}</div>
                        </div>
                        <div class="stat-icon icon-amber">
                            <i class="bi bi-star"></i>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-sm-6">
                    <div class="stat-widget">
                        <div class="stat-content">
                            <div class="stat-label">Selected / Placed</div>
                            <div class="stat-value text-success">${selectedApps}</div>
                        </div>
                        <div class="stat-icon icon-green">
                            <i class="bi bi-award-fill"></i>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-sm-6">
                    <div class="stat-widget">
                        <div class="stat-content">
                            <div class="stat-label">Interviews Scheduled</div>
                            <div class="stat-value">${interviews.size()}</div>
                        </div>
                        <div class="stat-icon icon-purple">
                            <i class="bi bi-calendar-check"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row g-4">
                
                <!-- Available Recommended Jobs -->
                <div class="col-lg-8">
                    <div class="cpms-card">
                        <div class="cpms-card-header">
                            <h5><i class="bi bi-briefcase-fill text-primary"></i> Active Job Openings</h5>
                            <a href="${pageContext.request.contextPath}/student/jobs" class="btn btn-outline-cpms btn-sm">
                                View All Jobs (${availableJobs.size()}) &rarr;
                            </a>
                        </div>
                        <div class="table-responsive">
                            <table class="cpms-table">
                                <thead>
                                    <tr>
                                        <th>Role & Company</th>
                                        <th>Package</th>
                                        <th>Eligibility Criteria</th>
                                        <th>Status</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty availableJobs}">
                                            <c:forEach var="job" items="${availableJobs}" end="4">
                                                <tr>
                                                    <td>
                                                        <div class="fw-bold text-navy-900"><c:out value="${job.jobTitle}"/></div>
                                                        <div class="text-muted small"><i class="bi bi-building me-1"></i><c:out value="${job.companyName}"/> • <c:out value="${job.location}"/></div>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty job.packageLpa}">
                                                                <span class="fw-bold text-success"><c:out value="${job.packageLpa}"/> LPA</span>
                                                            </c:when>
                                                            <c:otherwise><span class="text-muted">Competitive</span></c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <div class="small">
                                                            Min CGPA: <strong>${job.minCgpa}</strong> | Max Backlogs: <strong>${job.maxBacklogs}</strong>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${job.eligibleForCurrentStudent}">
                                                                <span class="status-pill status-approved"><i class="bi bi-check-circle me-1"></i>Eligible</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="status-pill status-rejected" title="${job.eligibilityReason}"><i class="bi bi-x-circle me-1"></i>Ineligible</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${job.eligibleForCurrentStudent}">
                                                                <form action="${pageContext.request.contextPath}/student/applications" method="post" style="display:inline;">
                                                                    <input type="hidden" name="action" value="apply">
                                                                    <input type="hidden" name="jobId" value="${job.jobId}">
                                                                    <button type="submit" class="btn btn-primary-cpms btn-sm py-1 px-2.5">Apply</button>
                                                                </form>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button class="btn btn-outline-secondary btn-sm py-1 px-2.5" disabled title="${job.eligibilityReason}">Not Eligible</button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="5" class="text-center py-4 text-muted">No active job drives posted currently.</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Upcoming Interviews -->
                    <div class="cpms-card">
                        <div class="cpms-card-header">
                            <h5><i class="bi bi-calendar-check-fill text-primary"></i> My Interview Pipeline</h5>
                            <a href="${pageContext.request.contextPath}/student/interviews" class="btn btn-outline-cpms btn-sm">Full Schedule</a>
                        </div>
                        <div class="table-responsive">
                            <table class="cpms-table">
                                <thead>
                                    <tr>
                                        <th>Company & Role</th>
                                        <th>Round</th>
                                        <th>Date & Time</th>
                                        <th>Mode / Venue</th>
                                        <th>Result</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty interviews}">
                                            <c:forEach var="iv" items="${interviews}">
                                                <tr>
                                                    <td>
                                                        <div class="fw-bold"><c:out value="${iv.companyName}"/></div>
                                                        <div class="text-muted small"><c:out value="${iv.jobTitle}"/></div>
                                                    </td>
                                                    <td><span class="badge bg-light text-dark border">Round ${iv.roundNumber}</span></td>
                                                    <td><c:out value="${iv.interviewDatetime}"/></td>
                                                    <td>
                                                        <span class="badge bg-secondary-subtle text-secondary-emphasis"><c:out value="${iv.mode}"/></span>
                                                        <div class="small text-muted"><c:out value="${iv.meetingOrVenue}"/></div>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${iv.result == 'PASSED'}"><span class="status-pill status-selected">Passed</span></c:when>
                                                            <c:when test="${iv.result == 'FAILED'}"><span class="status-pill status-rejected">Failed</span></c:when>
                                                            <c:otherwise><span class="status-pill status-pending">Scheduled</span></c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="5" class="text-center py-4 text-muted">No upcoming interviews scheduled yet.</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Right Side Column: Resume & Notifications -->
                <div class="col-lg-4">
                    
                    <!-- Active Resume Card -->
                    <div class="cpms-card mb-4">
                        <div class="cpms-card-header">
                            <h5><i class="bi bi-file-earmark-pdf-fill text-danger"></i> Resume Status</h5>
                        </div>
                        <div class="cpms-card-body">
                            <c:choose>
                                <c:when test="${not empty activeResume}">
                                    <div class="d-flex align-items-center gap-3 p-3 bg-light rounded-3 mb-3 border">
                                        <i class="bi bi-file-pdf text-danger fs-1"></i>
                                        <div class="flex-grow-1 min-w-0">
                                            <div class="fw-bold text-truncate" title="${activeResume.fileName}"><c:out value="${activeResume.fileName}"/></div>
                                            <div class="text-muted small">Uploaded: ${activeResume.uploadedAt}</div>
                                        </div>
                                    </div>
                                    <div class="d-flex gap-2">
                                        <a href="${pageContext.request.contextPath}/resume/download?id=${activeResume.resumeId}" target="_blank" class="btn btn-outline-cpms btn-sm flex-grow-1">
                                            <i class="bi bi-eye me-1"></i> Preview
                                        </a>
                                        <a href="${pageContext.request.contextPath}/student/resume" class="btn btn-primary-cpms btn-sm flex-grow-1">
                                            <i class="bi bi-upload me-1"></i> Replace
                                        </a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-3">
                                        <i class="bi bi-cloud-arrow-up text-muted fs-1 mb-2"></i>
                                        <p class="text-muted small mb-3">No PDF resume uploaded. You must upload a resume to apply for company drives.</p>
                                        <a href="${pageContext.request.contextPath}/student/resume" class="btn btn-primary-cpms btn-sm">
                                            Upload PDF Resume
                                        </a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Recent Notifications -->
                    <div class="cpms-card">
                        <div class="cpms-card-header">
                            <h5><i class="bi bi-bell-fill text-primary"></i> Notifications</h5>
                            <a href="${pageContext.request.contextPath}/student/notifications" class="small text-decoration-none">View All</a>
                        </div>
                        <div class="cpms-card-body p-0">
                            <ul class="list-group list-group-flush">
                                <c:choose>
                                    <c:when test="${not empty notifications}">
                                        <c:forEach var="n" items="${notifications}" end="4">
                                            <li class="list-group-item p-3 ${not n.read ? 'bg-light' : ''}">
                                                <div class="d-flex align-items-start gap-2">
                                                    <i class="bi bi-info-circle-fill text-primary mt-1"></i>
                                                    <div>
                                                        <div class="fw-semibold small"><c:out value="${n.title}"/></div>
                                                        <p class="text-muted small mb-1"><c:out value="${n.message}"/></p>
                                                        <span class="text-muted" style="font-size: 0.7rem;">${n.createdAt}</span>
                                                    </div>
                                                </div>
                                            </li>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <li class="list-group-item text-center py-4 text-muted small">No new notifications.</li>
                                    </c:otherwise>
                                </c:choose>
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
