<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Job Openings | CPMS</title>
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
            <a href="${pageContext.request.contextPath}/student/dashboard" class="sidebar-link">
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
            <a href="${pageContext.request.contextPath}/student/jobs" class="sidebar-link active">
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
                <h4>Campus Recruitment Job Drives</h4>
            </div>
            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}/student/applications" class="btn btn-outline-cpms py-1.5 px-3">
                    <i class="bi bi-send-check me-1"></i> Track My Applications
                </a>
            </div>
        </header>

        <div class="content-body">

            <c:if test="${empty activeResume}">
                <div class="alert alert-warning d-flex align-items-center justify-content-between p-3 mb-4">
                    <div class="d-flex align-items-center gap-2">
                        <i class="bi bi-exclamation-triangle-fill fs-5 text-warning"></i>
                        <div>
                            <strong>No active resume uploaded!</strong> You need to upload your PDF resume to apply for campus jobs.
                        </div>
                    </div>
                    <a href="${pageContext.request.contextPath}/student/resume" class="btn btn-warning btn-sm fw-semibold">
                        Upload Resume Now
                    </a>
                </div>
            </c:if>

            <!-- Jobs Listing -->
            <div class="row g-4">
                <c:choose>
                    <c:when test="${not empty jobs}">
                        <c:forEach var="job" items="${jobs}">
                            <div class="col-lg-6">
                                <div class="cpms-card h-100 d-flex flex-direction-column">
                                    <div class="cpms-card-body d-flex flex-column flex-grow-1 p-4">
                                        
                                        <!-- Top metadata -->
                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                            <div>
                                                <h5 class="fw-bold text-navy-900 mb-1"><c:out value="${job.jobTitle}"/></h5>
                                                <span class="text-primary fw-semibold small">
                                                    <i class="bi bi-building me-1"></i><c:out value="${job.companyName}"/>
                                                </span>
                                            </div>
                                            <c:choose>
                                                <c:when test="${appliedJobIds.contains(job.jobId)}">
                                                    <span class="status-pill status-applied"><i class="bi bi-check2-all me-1"></i>Applied</span>
                                                </c:when>
                                                <c:when test="${job.eligibleForCurrentStudent}">
                                                    <span class="status-pill status-approved"><i class="bi bi-check-circle me-1"></i>Eligible</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-pill status-rejected"><i class="bi bi-x-circle me-1"></i>Ineligible</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <p class="text-muted small mb-3 flex-grow-1" style="min-height: 48px;">
                                            <c:out value="${job.jobDescription}"/>
                                        </p>

                                        <!-- Criteria Badges -->
                                        <div class="d-flex flex-wrap gap-2 mb-3">
                                            <span class="badge bg-light text-dark border">
                                                <i class="bi bi-geo-alt me-1"></i><c:out value="${job.location}"/>
                                            </span>
                                            <span class="badge bg-light text-dark border">
                                                <i class="bi bi-clock me-1"></i><c:out value="${job.jobType}"/>
                                            </span>
                                            <c:if test="${not empty job.packageLpa}">
                                                <span class="badge bg-success-subtle text-success border border-success-subtle fw-bold">
                                                    <i class="bi bi-cash-stack me-1"></i><c:out value="${job.packageLpa}"/> LPA
                                                </span>
                                            </c:if>
                                            <span class="badge bg-light text-dark border">
                                                Min CGPA: ${job.minCgpa}
                                            </span>
                                            <span class="badge bg-light text-dark border">
                                                Max Backlogs: ${job.maxBacklogs}
                                            </span>
                                        </div>

                                        <!-- Eligibility Feedback Box -->
                                        <c:if test="${not job.eligibleForCurrentStudent}">
                                            <div class="alert alert-danger py-2 px-3 small mb-3">
                                                <i class="bi bi-info-circle me-1"></i>
                                                <strong>Ineligible:</strong> <c:out value="${job.eligibilityReason}"/>
                                            </div>
                                        </c:if>

                                        <!-- Action Buttons -->
                                        <div class="pt-3 border-top d-flex justify-content-between align-items-center mt-auto">
                                            <div class="small text-muted">
                                                <c:if test="${not empty job.applicationDeadline}">
                                                    <i class="bi bi-calendar-event me-1"></i>Deadline: ${job.applicationDeadline}
                                                </c:if>
                                            </div>

                                            <div>
                                                <c:choose>
                                                    <c:when test="${appliedJobIds.contains(job.jobId)}">
                                                        <a href="${pageContext.request.contextPath}/student/applications" class="btn btn-outline-cpms btn-sm">
                                                            View Application
                                                        </a>
                                                    </c:when>
                                                    <c:when test="${job.eligibleForCurrentStudent and not empty activeResume}">
                                                        <form action="${pageContext.request.contextPath}/student/applications" method="post" style="display:inline;">
                                                            <input type="hidden" name="action" value="apply">
                                                            <input type="hidden" name="jobId" value="${job.jobId}">
                                                            <input type="hidden" name="resumeId" value="${activeResume.resumeId}">
                                                            <button type="submit" class="btn btn-primary-cpms btn-sm px-3">
                                                                <i class="bi bi-send me-1"></i> Apply Now
                                                            </button>
                                                        </form>
                                                    </c:when>
                                                    <c:when test="${job.eligibleForCurrentStudent and empty activeResume}">
                                                        <a href="${pageContext.request.contextPath}/student/resume" class="btn btn-warning btn-sm">
                                                            Upload Resume to Apply
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button class="btn btn-outline-secondary btn-sm" disabled>
                                                            Ineligible to Apply
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="col-12 text-center py-5">
                            <i class="bi bi-briefcase text-muted" style="font-size: 3rem;"></i>
                            <h5 class="mt-3 text-muted">No campus recruitment drives open at this time.</h5>
                            <p class="small text-muted">Check back soon for new corporate placement announcements.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

