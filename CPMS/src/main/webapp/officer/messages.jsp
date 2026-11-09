<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Placement Announcements & Messaging | CPMS Officer</title>
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
            <a href="${pageContext.request.contextPath}/officer/companies" class="sidebar-link">
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
            <a href="${pageContext.request.contextPath}/officer/messages" class="sidebar-link active">
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
                <h4>Announcements & Student Direct Messaging</h4>
            </div>
            <div class="topbar-actions">
                <button type="button" class="btn btn-primary-cpms py-1.5 px-3" data-bs-toggle="modal" data-bs-target="#broadcastModal">
                    <i class="bi bi-megaphone me-1"></i> New Announcement
                </button>
            </div>
        </header>

        <div class="content-body">

            <c:if test="${param.success == 'sent'}">
                <div class="alert alert-success d-flex align-items-center gap-2 mb-4">
                    <i class="bi bi-check-circle-fill fs-5"></i>
                    <div>Message or broadcast announcement dispatched successfully!</div>
                </div>
            </c:if>

            <div class="row g-4">
                
                <!-- Sent Messages & Broadcasts -->
                <div class="col-lg-7">
                    <div class="cpms-card">
                        <div class="cpms-card-header">
                            <h5><i class="bi bi-broadcast text-primary"></i> Dispatched Announcements & Messages (${sent.size()})</h5>
                        </div>
                        <div class="cpms-card-body p-0">
                            <div class="list-group list-group-flush">
                                <c:choose>
                                    <c:when test="${not empty sent}">
                                        <c:forEach var="s" items="${sent}">
                                            <div class="list-group-item p-3">
                                                <div class="d-flex justify-content-between align-items-start mb-1">
                                                    <div>
                                                        <span class="badge bg-primary-subtle text-primary border border-primary-subtle me-2"><c:out value="${s.category}"/></span>
                                                        <strong class="text-navy-900"><c:out value="${s.subject}"/></strong>
                                                    </div>
                                                    <span class="text-muted small">${s.createdAt}</span>
                                                </div>
                                                <div class="text-muted small mb-2">
                                                    Recipient: <strong><c:out value="${not empty s.receiverName ? s.receiverName : 'Broadcast to All Students'}"/></strong>
                                                </div>
                                                <p class="small text-dark mb-0" style="white-space: pre-wrap;"><c:out value="${s.content}"/></p>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-5 text-muted small">No announcements dispatched yet.</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Received Student Queries -->
                <div class="col-lg-5">
                    <div class="cpms-card">
                        <div class="cpms-card-header">
                            <h5><i class="bi bi-inbox-fill text-secondary"></i> Student Queries & Replies (${inbox.size()})</h5>
                        </div>
                        <div class="cpms-card-body p-0">
                            <div class="list-group list-group-flush">
                                <c:choose>
                                    <c:when test="${not empty inbox}">
                                        <c:forEach var="m" items="${inbox}">
                                            <div class="list-group-item p-3">
                                                <div class="d-flex justify-content-between align-items-center mb-1">
                                                    <strong class="text-navy-900 small"><c:out value="${m.subject}"/></strong>
                                                    <span class="text-muted" style="font-size: 0.75rem;">${m.createdAt}</span>
                                                </div>
                                                <div class="text-muted small mb-1">From: <c:out value="${m.senderName}"/></div>
                                                <p class="small text-dark mb-0"><c:out value="${m.content}"/></p>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-4 text-muted small">No student queries received.</div>
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

<!-- Broadcast / Message Modal -->
<div class="modal fade" id="broadcastModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/officer/messages" method="post">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Dispatch Message / Announcement</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-muted">Audience *</label>
                        <select name="receiverId" class="form-select" required>
                            <option value="ALL">Broadcast to All Students</option>
                            <optgroup label="Direct Message to Individual Student">
                                <c:forEach var="s" items="${students}">
                                    <c:if test="${not empty s.userId}">
                                        <option value="${s.userId}">${s.fullName} (${s.registerNumber} - ${s.departmentCode})</option>
                                    </c:if>
                                </c:forEach>
                            </optgroup>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-muted">Category *</label>
                        <select name="category" class="form-select" required>
                            <option value="ANNOUNCEMENT">Placement Announcement</option>
                            <option value="ADVICE">Preparation & Interview Advice</option>
                            <option value="PROFILE">Profile Correction Request</option>
                            <option value="ACADEMIC">Academic Verification Remark</option>
                            <option value="GENERAL">General Notice</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-muted">Subject *</label>
                        <input type="text" name="subject" class="form-control" placeholder="Subject header" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-muted">Announcement / Message Body *</label>
                        <textarea name="content" class="form-control" rows="4" placeholder="Detailed message text..." required></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary-cpms">Send Announcement</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

