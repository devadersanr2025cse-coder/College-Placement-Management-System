<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Placement Cell Messages | CPMS</title>
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
            <a href="${pageContext.request.contextPath}/student/interviews" class="sidebar-link">
                <i class="bi bi-calendar-event"></i> <span>Interviews</span>
            </a>
            <a href="${pageContext.request.contextPath}/student/messages" class="sidebar-link active">
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
                <h4>Placement Cell Communication</h4>
            </div>
            <div class="topbar-actions">
                <button type="button" class="btn btn-primary-cpms py-1.5 px-3" data-bs-toggle="modal" data-bs-target="#composeModal">
                    <i class="bi bi-pencil-square me-1"></i> Send Query to Officer
                </button>
            </div>
        </header>

        <div class="content-body">

            <c:if test="${param.success == 'sent'}">
                <div class="alert alert-success d-flex align-items-center gap-2 mb-4">
                    <i class="bi bi-check-circle-fill fs-5"></i>
                    <div>Message sent to the Placement Cell!</div>
                </div>
            </c:if>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger d-flex align-items-center gap-2 mb-4">
                    <i class="bi bi-exclamation-triangle-fill fs-5"></i>
                    <div><c:out value="${errorMessage}"/></div>
                </div>
            </c:if>

            <div class="row g-4">
                
                <!-- Inbox -->
                <div class="col-lg-8">
                    <div class="cpms-card">
                        <div class="cpms-card-header">
                            <h5><i class="bi bi-inbox-fill text-primary"></i> Received Messages & Announcements</h5>
                        </div>
                        <div class="cpms-card-body p-0">
                            <div class="list-group list-group-flush">
                                <c:choose>
                                    <c:when test="${not empty inbox}">
                                        <c:forEach var="msg" items="${inbox}">
                                            <div class="list-group-item p-3 ${not msg.read ? 'bg-light' : ''}">
                                                <div class="d-flex justify-content-between align-items-start mb-1">
                                                    <div>
                                                        <span class="badge bg-primary-subtle text-primary border border-primary-subtle small me-2"><c:out value="${msg.category}"/></span>
                                                        <strong class="text-navy-900"><c:out value="${msg.subject}"/></strong>
                                                    </div>
                                                    <span class="text-muted small">${msg.createdAt}</span>
                                                </div>
                                                <div class="text-muted small mb-2">
                                                    From: <strong><c:out value="${msg.senderName}"/></strong> (${msg.senderRole})
                                                </div>
                                                <p class="text-dark small mb-1" style="white-space: pre-wrap;"><c:out value="${msg.content}"/></p>
                                                <c:if test="${not msg.read}">
                                                    <div class="text-end">
                                                        <a href="${pageContext.request.contextPath}/student/messages?read=${msg.messageId}" class="small text-primary text-decoration-none">
                                                            <i class="bi bi-check2"></i> Mark as read
                                                        </a>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-5 text-muted small">No messages in your inbox.</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Sent Messages -->
                <div class="col-lg-4">
                    <div class="cpms-card">
                        <div class="cpms-card-header">
                            <h5><i class="bi bi-send-fill text-secondary"></i> Sent Queries</h5>
                        </div>
                        <div class="cpms-card-body p-0">
                            <div class="list-group list-group-flush">
                                <c:choose>
                                    <c:when test="${not empty sent}">
                                        <c:forEach var="s" items="${sent}">
                                            <div class="list-group-item p-3">
                                                <div class="fw-bold small text-navy-900 mb-1"><c:out value="${s.subject}"/></div>
                                                <p class="text-muted small mb-1 text-truncate"><c:out value="${s.content}"/></p>
                                                <span class="text-muted" style="font-size: 0.75rem;">${s.createdAt}</span>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-4 text-muted small">No sent queries.</div>
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

<!-- Compose Modal -->
<div class="modal fade" id="composeModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/student/messages" method="post">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Send Message to Placement Cell</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-muted">Category *</label>
                        <select name="category" class="form-select" required>
                            <option value="GENERAL">General Query</option>
                            <option value="ACADEMIC">Academic Information</option>
                            <option value="RESUME">Resume Guidance</option>
                            <option value="ADVICE">Interview Preparation</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-muted">Subject *</label>
                        <input type="text" name="subject" class="form-control" placeholder="Brief subject" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-muted">Message Content *</label>
                        <textarea name="content" class="form-control" rows="4" placeholder="Enter your detailed query or message..." required></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary-cpms">Send Message</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

