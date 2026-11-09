<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Applications | CPMS</title>
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
            <a href="${pageContext.request.contextPath}/student/jobs" class="sidebar-link">
                <i class="bi bi-briefcase"></i> <span>Job Openings</span>
            </a>
            <a href="${pageContext.request.contextPath}/student/applications" class="sidebar-link active">
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
                <h4>My Job Applications History</h4>
            </div>
            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}/student/jobs" class="btn btn-primary-cpms py-1.5 px-3">
                    <i class="bi bi-plus-lg me-1"></i> Browse More Jobs
                </a>
            </div>
        </header>

        <div class="content-body">

            <c:if test="${param.success == 'applied'}">
                <div class="alert alert-success d-flex align-items-center gap-2 mb-4">
                    <i class="bi bi-check-circle-fill fs-5"></i>
                    <div>Application submitted successfully! The recruiter and placement cell have been notified.</div>
                </div>
            </c:if>

            <c:if test="${param.success == 'withdrawn'}">
                <div class="alert alert-info d-flex align-items-center gap-2 mb-4">
                    <i class="bi bi-info-circle-fill fs-5"></i>
                    <div>Your application has been successfully withdrawn.</div>
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
                    <h5><i class="bi bi-send-check-fill text-primary"></i> Application Pipeline</h5>
                </div>
                <div class="table-responsive">
                    <table class="cpms-table">
                        <thead>
                            <tr>
                                <th>Position & Company</th>
                                <th>Package</th>
                                <th>Submitted Resume</th>
                                <th>Applied Date</th>
                                <th>Application Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty applications}">
                                    <c:forEach var="app" items="${applications}">
                                        <tr>
                                            <td>
                                                <div class="fw-bold text-navy-900"><c:out value="${app.jobTitle}"/></div>
                                                <div class="text-muted small"><i class="bi bi-building me-1"></i><c:out value="${app.companyName}"/> • <c:out value="${app.location}"/></div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty app.packageLpa}">
                                                        <span class="fw-semibold text-success"><c:out value="${app.packageLpa}"/> LPA</span>
                                                    </c:when>
                                                    <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty app.resumeId}">
                                                        <a href="${pageContext.request.contextPath}/resume/download?id=${app.resumeId}" target="_blank" class="small text-decoration-none">
                                                            <i class="bi bi-file-earmark-pdf text-danger me-1"></i>View Resume
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise><span class="text-muted small">Default Resume</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <span class="small"><c:out value="${app.appliedAt}"/></span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${app.applicationStatus == 'APPLIED'}">
                                                        <span class="status-pill status-applied"><i class="bi bi-send me-1"></i>Applied</span>
                                                    </c:when>
                                                    <c:when test="${app.applicationStatus == 'UNDER_REVIEW'}">
                                                        <span class="status-pill status-under-review"><i class="bi bi-hourglass-split me-1"></i>Under Review</span>
                                                    </c:when>
                                                    <c:when test="${app.applicationStatus == 'SHORTLISTED'}">
                                                        <span class="status-pill status-shortlisted"><i class="bi bi-star-fill me-1"></i>Shortlisted</span>
                                                    </c:when>
                                                    <c:when test="${app.applicationStatus == 'SELECTED'}">
                                                        <span class="status-pill status-selected"><i class="bi bi-trophy-fill me-1"></i>Selected / Placed</span>
                                                    </c:when>
                                                    <c:when test="${app.applicationStatus == 'REJECTED'}">
                                                        <span class="status-pill status-rejected"><i class="bi bi-x-circle me-1"></i>Not Selected</span>
                                                    </c:when>
                                                    <c:when test="${app.applicationStatus == 'WITHDRAWN'}">
                                                        <span class="status-pill status-withdrawn"><i class="bi bi-slash-circle me-1"></i>Withdrawn</span>
                                                    </c:when>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:if test="${app.applicationStatus == 'APPLIED' or app.applicationStatus == 'UNDER_REVIEW'}">
                                                    <form action="${pageContext.request.contextPath}/student/applications" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to withdraw this application?');">
                                                        <input type="hidden" name="action" value="withdraw">
                                                        <input type="hidden" name="applicationId" value="${app.applicationId}">
                                                        <button type="submit" class="btn btn-outline-danger btn-sm py-1 px-2.5">
                                                            Withdraw
                                                        </button>
                                                    </form>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="6" class="text-center py-5 text-muted">
                                            <i class="bi bi-inbox fs-2 d-block mb-2 text-muted"></i>
                                            You haven't applied to any job drives yet.
                                            <div class="mt-2">
                                                <a href="${pageContext.request.contextPath}/student/jobs" class="btn btn-primary-cpms btn-sm">Explore Open Jobs</a>
                                            </div>
                                        </td>
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

