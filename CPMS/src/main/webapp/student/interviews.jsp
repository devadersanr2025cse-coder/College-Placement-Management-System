<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Interview Schedules | CPMS</title>
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
            <a href="${pageContext.request.contextPath}/student/applications" class="sidebar-link">
                <i class="bi bi-send-check"></i> <span>Applications</span>
            </a>
            <a href="${pageContext.request.contextPath}/student/resume" class="sidebar-link">
                <i class="bi bi-file-earmark-pdf"></i> <span>Resume Manager</span>
            </a>
            <a href="${pageContext.request.contextPath}/student/interviews" class="sidebar-link active">
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
                <h4>Interview Schedules & Results</h4>
            </div>
            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-outline-cpms py-1.5 px-3">
                    <i class="bi bi-arrow-left me-1"></i> Dashboard
                </a>
            </div>
        </header>

        <div class="content-body">

            <div class="cpms-card">
                <div class="cpms-card-header">
                    <h5><i class="bi bi-calendar-event-fill text-primary"></i> Scheduled Interview Rounds</h5>
                </div>
                <div class="table-responsive">
                    <table class="cpms-table">
                        <thead>
                            <tr>
                                <th>Company & Job Title</th>
                                <th>Round</th>
                                <th>Date & Time</th>
                                <th>Interview Mode</th>
                                <th>Venue / Meeting Link</th>
                                <th>Result / Status</th>
                                <th>Officer Notes</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty interviews}">
                                    <c:forEach var="iv" items="${interviews}">
                                        <tr>
                                            <td>
                                                <div class="fw-bold text-navy-900"><c:out value="${iv.companyName}"/></div>
                                                <div class="text-muted small"><c:out value="${iv.jobTitle}"/></div>
                                            </td>
                                            <td>
                                                <span class="badge bg-primary-subtle text-primary border border-primary-subtle fw-semibold">
                                                    Round ${iv.roundNumber}
                                                </span>
                                            </td>
                                            <td><span class="small fw-semibold"><c:out value="${iv.interviewDatetime}"/></span></td>
                                            <td>
                                                <span class="badge ${iv.mode == 'ONLINE' ? 'bg-info-subtle text-info border border-info-subtle' : 'bg-secondary-subtle text-secondary border border-secondary-subtle'}">
                                                    <i class="bi ${iv.mode == 'ONLINE' ? 'bi-camera-video' : 'bi-geo-alt'} me-1"></i><c:out value="${iv.mode}"/>
                                                </span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${iv.meetingOrVenue.startsWith('http')}">
                                                        <a href="<c:out value='${iv.meetingOrVenue}'/>" target="_blank" class="btn btn-sm btn-outline-primary py-0.5 px-2">
                                                            <i class="bi bi-box-arrow-up-right me-1"></i> Join Meeting
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="small text-muted"><c:out value="${iv.meetingOrVenue}"/></span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${iv.result == 'PASSED'}">
                                                        <span class="status-pill status-selected"><i class="bi bi-check-circle me-1"></i>Passed</span>
                                                    </c:when>
                                                    <c:when test="${iv.result == 'FAILED'}">
                                                        <span class="status-pill status-rejected"><i class="bi bi-x-circle me-1"></i>Not Cleared</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-pill status-pending"><i class="bi bi-hourglass-split me-1"></i>Scheduled</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <span class="small text-muted"><c:out value="${not empty iv.notes ? iv.notes : '—'}"/></span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" class="text-center py-5 text-muted">
                                            <i class="bi bi-calendar-x fs-2 d-block mb-2 text-muted"></i>
                                            No interviews scheduled yet. You will be notified when a recruiter shortlists your application.
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

