<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Academic Information & Verification | CPMS</title>
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
            <a href="${pageContext.request.contextPath}/student/academic" class="sidebar-link active">
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
                <h4>Academic Verification Management</h4>
            </div>
            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-outline-cpms py-1.5 px-3">
                    <i class="bi bi-arrow-left me-1"></i> Dashboard
                </a>
            </div>
        </header>

        <div class="content-body">

            <c:if test="${param.success == 'submitted'}">
                <div class="alert alert-success d-flex align-items-center gap-2 mb-4">
                    <i class="bi bi-check-circle-fill fs-5"></i>
                    <div>
                        <strong>Academic update request submitted!</strong> Your submission is queued for Placement Officer verification. Your official record will update once approved.
                    </div>
                </div>
            </c:if>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger d-flex align-items-center gap-2 mb-4">
                    <i class="bi bi-exclamation-triangle-fill fs-5"></i>
                    <div><c:out value="${errorMessage}"/></div>
                </div>
            </c:if>

            <!-- Current Official Verified Record Card -->
            <div class="cpms-card mb-4">
                <div class="cpms-card-header">
                    <h5><i class="bi bi-shield-check text-success"></i> Official Verified Academic Record</h5>
                    <span class="badge bg-success-subtle text-success px-3 py-1.5 fw-semibold">
                        <i class="bi bi-patch-check-fill me-1"></i> Verified by Placement Cell
                    </span>
                </div>
                <div class="cpms-card-body">
                    <div class="row g-4">
                        <div class="col-md-3">
                            <div class="text-muted small">Department</div>
                            <div class="fs-5 fw-bold text-navy-900"><c:out value="${student.departmentName}"/> (<c:out value="${student.departmentCode}"/>)</div>
                        </div>
                        <div class="col-md-3">
                            <div class="text-muted small">Graduation Year</div>
                            <div class="fs-5 fw-bold text-navy-900"><c:out value="${student.batchYear}"/></div>
                        </div>
                        <div class="col-md-3">
                            <div class="text-muted small">Official Verified CGPA</div>
                            <div class="fs-4 fw-bold text-success"><c:out value="${student.cgpa}"/> / 10.00</div>
                        </div>
                        <div class="col-md-3">
                            <div class="text-muted small">Official Active Backlogs</div>
                            <div class="fs-4 fw-bold ${student.activeBacklogs == 0 ? 'text-success' : 'text-danger'}"><c:out value="${student.activeBacklogs}"/></div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Submit Academic Update Form Card -->
            <div class="cpms-card mb-4">
                <div class="cpms-card-header">
                    <h5><i class="bi bi-pencil-square text-primary"></i> Request CGPA / Backlog Update</h5>
                </div>
                <div class="cpms-card-body">

                    <c:choose>
                        <c:when test="${student.hasPendingUpdate}">
                            <div class="alert alert-warning d-flex align-items-start gap-3 p-3">
                                <i class="bi bi-clock-history fs-3 text-warning"></i>
                                <div>
                                    <h6 class="fw-bold mb-1">Update Under Review by Placement Officer</h6>
                                    <p class="mb-1 small">
                                        You have submitted updated academic values:
                                        <strong>CGPA: ${student.pendingCgpa}</strong>, 
                                        <strong>Active Backlogs: ${student.pendingBacklogs}</strong>.
                                    </p>
                                    <p class="small text-muted mb-0">
                                        Per placement security guidelines, you cannot submit a new request while an existing update is pending officer approval. Recruiters continue to view only your approved record.
                                    </p>
                                </div>
                            </div>
                        </c:when>

                        <c:otherwise>
                            <p class="text-muted small mb-4">
                                Semester results declared? Submit your updated CGPA and current backlog count below with remarks or semester details. A placement officer will verify your mark sheets and approve the update.
                            </p>

                            <form action="${pageContext.request.contextPath}/student/academic" method="post">
                                <div class="row g-3">
                                    <div class="col-md-4">
                                        <label class="form-label small fw-semibold text-muted">New CGPA (0.00 - 10.00) *</label>
                                        <input type="number" step="0.01" min="0.00" max="10.00" name="submittedCgpa" class="form-control" placeholder="e.g. 8.65" required>
                                    </div>

                                    <div class="col-md-4">
                                        <label class="form-label small fw-semibold text-muted">New Active Backlogs *</label>
                                        <input type="number" min="0" max="50" name="submittedBacklogs" class="form-control" placeholder="0 if all cleared" required>
                                    </div>

                                    <div class="col-md-4">
                                        <label class="form-label small fw-semibold text-muted">Student Remarks / Semester Info</label>
                                        <input type="text" name="studentRemarks" class="form-control" placeholder="e.g. Semester 7 grade sheet published">
                                    </div>
                                </div>

                                <div class="mt-4 pt-3 border-top">
                                    <button type="submit" class="btn btn-primary-cpms px-4">
                                        <i class="bi bi-send me-1"></i> Submit for Officer Verification
                                    </button>
                                </div>
                            </form>
                        </c:otherwise>
                    </c:choose>

                </div>
            </div>

            <!-- Complete Verification Audit History -->
            <div class="cpms-card">
                <div class="cpms-card-header">
                    <h5><i class="bi bi-clock-history text-secondary"></i> Verification Audit History</h5>
                </div>
                <div class="table-responsive">
                    <table class="cpms-table">
                        <thead>
                            <tr>
                                <th>Submitted Date</th>
                                <th>Previous Values</th>
                                <th>Submitted Values</th>
                                <th>Status</th>
                                <th>Officer Remarks</th>
                                <th>Review Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty history}">
                                    <c:forEach var="item" items="${history}">
                                        <tr>
                                            <td><c:out value="${item.submittedAt}"/></td>
                                            <td>
                                                <span class="small">CGPA: <strong>${item.previousCgpa}</strong>, Backlogs: <strong>${item.previousBacklogs}</strong></span>
                                            </td>
                                            <td>
                                                <span class="small fw-bold text-primary">CGPA: ${item.submittedCgpa}, Backlogs: ${item.submittedBacklogs}</span>
                                                <c:if test="${not empty item.studentRemarks}">
                                                    <div class="text-muted" style="font-size: 0.75rem;">"<c:out value='${item.studentRemarks}'/>"</div>
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${item.status == 'APPROVED'}">
                                                        <span class="status-pill status-approved"><i class="bi bi-check-circle me-1"></i>Approved</span>
                                                    </c:when>
                                                    <c:when test="${item.status == 'REJECTED'}">
                                                        <span class="status-pill status-rejected"><i class="bi bi-x-circle me-1"></i>Rejected</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-pill status-pending"><i class="bi bi-hourglass-split me-1"></i>Pending</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty item.officerRemarks}">
                                                        <span class="text-dark small"><c:out value="${item.officerRemarks}"/></span>
                                                    </c:when>
                                                    <c:otherwise><span class="text-muted small">—</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty item.reviewDate}">
                                                        <span class="small"><c:out value="${item.reviewDate}"/></span>
                                                    </c:when>
                                                    <c:otherwise><span class="text-muted small">Pending Review</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="6" class="text-center py-4 text-muted small">No past academic verification requests found.</td>
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

