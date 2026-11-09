<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Resume Management & Feedback | CPMS</title>
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
            <a href="${pageContext.request.contextPath}/student/resume" class="sidebar-link active">
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
                <h4>Resume Manager & Officer Review</h4>
            </div>
            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-outline-cpms py-1.5 px-3">
                    <i class="bi bi-arrow-left me-1"></i> Dashboard
                </a>
            </div>
        </header>

        <div class="content-body">

            <c:if test="${param.success == 'uploaded'}">
                <div class="alert alert-success d-flex align-items-center gap-2 mb-4">
                    <i class="bi bi-check-circle-fill fs-5"></i>
                    <div>Resume uploaded and activated successfully! The Placement Cell has been notified.</div>
                </div>
            </c:if>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger d-flex align-items-center gap-2 mb-4">
                    <i class="bi bi-exclamation-triangle-fill fs-5"></i>
                    <div><c:out value="${errorMessage}"/></div>
                </div>
            </c:if>

            <div class="row g-4">
                
                <!-- Current Active Resume -->
                <div class="col-lg-5">
                    <div class="cpms-card h-100">
                        <div class="cpms-card-header">
                            <h5><i class="bi bi-file-earmark-check-fill text-success"></i> Active Placement Resume</h5>
                        </div>
                        <div class="cpms-card-body">
                            <c:choose>
                                <c:when test="${not empty activeResume}">
                                    <div class="p-4 bg-light rounded-3 text-center border mb-4">
                                        <i class="bi bi-file-earmark-pdf-fill text-danger" style="font-size: 3.5rem;"></i>
                                        <h6 class="fw-bold text-navy-900 mt-2 mb-1 text-truncate" title="${activeResume.fileName}">
                                            <c:out value="${activeResume.fileName}"/>
                                        </h6>
                                        <div class="text-muted small mb-3">
                                            Uploaded on: <strong><c:out value="${activeResume.uploadedAt}"/></strong>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/resume/download?id=${activeResume.resumeId}" target="_blank" class="btn btn-primary-cpms btn-sm px-4">
                                            <i class="bi bi-eye me-1"></i> View / Download Resume
                                        </a>
                                    </div>
                                    <div class="small text-muted">
                                        <i class="bi bi-info-circle me-1"></i> This resume will be automatically shared with recruiters when you submit job applications.
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-5">
                                        <i class="bi bi-file-earmark-x text-muted" style="font-size: 3rem;"></i>
                                        <h6 class="mt-3 text-muted">No Active Resume</h6>
                                        <p class="small text-muted">Please upload your official PDF resume to apply for campus placements.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- Upload / Replace Form -->
                <div class="col-lg-7">
                    <div class="cpms-card h-100">
                        <div class="cpms-card-header">
                            <h5><i class="bi bi-cloud-arrow-up-fill text-primary"></i> ${not empty activeResume ? 'Replace' : 'Upload'} PDF Resume</h5>
                        </div>
                        <div class="cpms-card-body">
                            
                            <form action="${pageContext.request.contextPath}/student/resume" method="post" enctype="multipart/form-data">
                                
                                <div class="mb-4">
                                    <label class="form-label small fw-semibold text-muted">Select PDF Document *</label>
                                    <input type="file" name="resumeFile" class="form-control" accept="application/pdf" required>
                                    <div class="form-text small mt-2">
                                        <i class="bi bi-shield-check text-success me-1"></i> File format must be <strong>.PDF</strong>. Maximum file size allowed: <strong>5 MB</strong>.
                                    </div>
                                </div>

                                <div class="p-3 bg-light rounded-3 border mb-4">
                                    <h6 class="fw-bold small text-navy-900 mb-2">Resume Quality Guidelines:</h6>
                                    <ul class="text-muted small mb-0 ps-3">
                                        <li>Include verified CGPA matching your college records.</li>
                                        <li>List academic projects, technical proficiencies, and internships.</li>
                                        <li>Ensure contact phone and college email are clearly legible.</li>
                                    </ul>
                                </div>

                                <button type="submit" class="btn btn-primary-cpms px-4">
                                    <i class="bi bi-upload me-1"></i> Upload and Save Resume
                                </button>
                            </form>

                        </div>
                    </div>
                </div>

                <!-- Placement Officer Feedback & Suggestions Section -->
                <div class="col-12">
                    <div class="cpms-card">
                        <div class="cpms-card-header">
                            <h5><i class="bi bi-chat-quote-fill text-primary"></i> Placement Officer Resume Feedback</h5>
                        </div>
                        <div class="table-responsive">
                            <table class="cpms-table">
                                <thead>
                                    <tr>
                                        <th>Feedback Date</th>
                                        <th>Officer</th>
                                        <th>Type</th>
                                        <th>Improvement Comments & Suggestions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty feedbacks}">
                                            <c:forEach var="fb" items="${feedbacks}">
                                                <tr>
                                                    <td><span class="small"><c:out value="${fb.createdAt}"/></span></td>
                                                    <td>
                                                        <div class="fw-bold small"><c:out value="${fb.officerName}"/></div>
                                                        <div class="text-muted" style="font-size: 0.75rem;"><c:out value="${fb.officerDesignation}"/></div>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${fb.feedbackType == 'SUGGESTION'}">
                                                                <span class="badge bg-info-subtle text-info border border-info-subtle">Suggestion</span>
                                                            </c:when>
                                                            <c:when test="${fb.feedbackType == 'CORRECTION'}">
                                                                <span class="badge bg-warning-subtle text-warning border border-warning-subtle">Correction</span>
                                                            </c:when>
                                                            <c:when test="${fb.feedbackType == 'APPROVAL'}">
                                                                <span class="badge bg-success-subtle text-success border border-success-subtle">Approved</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary"><c:out value="${fb.feedbackType}"/></span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <span class="text-navy-900 small"><c:out value="${fb.comments}"/></span>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="4" class="text-center py-4 text-muted small">No officer feedback recorded for your resume yet.</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
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

