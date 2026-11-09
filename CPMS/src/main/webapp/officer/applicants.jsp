<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Drive Applicants | CPMS Officer</title>
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
            <a href="${pageContext.request.contextPath}/officer/jobs" class="sidebar-link active">
                <i class="bi bi-briefcase"></i> <span>Job Postings</span>
            </a>
            <a href="${pageContext.request.contextPath}/officer/interviews" class="sidebar-link">
                <i class="bi bi-calendar3"></i> <span>Interviews</span>
            </a>
            <a href="${pageContext.request.contextPath}/officer/resumes" class="sidebar-link">
                <i class="bi bi-file-earmark-person"></i> <span>Resume Review</span>
            </a>
            <a href="${pageContext.request.contextPath}/officer/messages" class="sidebar-link">
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
                <h4>Drive Applicants: <c:out value="${job.jobTitle}"/> (<c:out value="${job.companyName}"/>)</h4>
            </div>
            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}/officer/jobs" class="btn btn-outline-cpms py-1.5 px-3">
                    <i class="bi bi-arrow-left me-1"></i> Back to Jobs
                </a>
            </div>
        </header>

        <div class="content-body">

            <c:if test="${param.success == 'status'}">
                <div class="alert alert-success d-flex align-items-center gap-2 mb-4">
                    <i class="bi bi-check-circle-fill fs-5"></i>
                    <div>Applicant status updated successfully! Student has been notified.</div>
                </div>
            </c:if>

            <div class="cpms-card">
                <div class="cpms-card-header">
                    <h5><i class="bi bi-people text-primary"></i> Registered Applicants (${applicants.size()})</h5>
                </div>
                <div class="table-responsive">
                    <table class="cpms-table">
                        <thead>
                            <tr>
                                <th>Candidate Name</th>
                                <th>Register Number</th>
                                <th>Department & Batch</th>
                                <th>Verified CGPA</th>
                                <th>Backlogs</th>
                                <th>Resume</th>
                                <th>Application Status</th>
                                <th>Update Status</th>
                                <th>Schedule Interview</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty applicants}">
                                    <c:forEach var="app" items="${applicants}">
                                        <tr>
                                            <td>
                                                <div class="fw-bold text-navy-900"><c:out value="${app.studentName}"/></div>
                                                <div class="text-muted small"><c:out value="${app.studentEmail}"/></div>
                                            </td>
                                            <td><span class="badge bg-light text-dark border font-monospace"><c:out value="${app.registerNumber}"/></span></td>
                                            <td>
                                                <div><c:out value="${app.departmentName}"/></div>
                                                <div class="text-muted small">Batch <c:out value="${app.batchYear}"/></div>
                                            </td>
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
                                                            <i class="bi bi-file-earmark-pdf"></i> Resume
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise><span class="text-muted small">—</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${app.applicationStatus == 'APPLIED'}"><span class="status-pill status-applied">Applied</span></c:when>
                                                    <c:when test="${app.applicationStatus == 'SHORTLISTED'}"><span class="status-pill status-shortlisted">Shortlisted</span></c:when>
                                                    <c:when test="${app.applicationStatus == 'SELECTED'}"><span class="status-pill status-selected">Selected</span></c:when>
                                                    <c:when test="${app.applicationStatus == 'REJECTED'}"><span class="status-pill status-rejected">Rejected</span></c:when>
                                                    <c:otherwise><span class="status-pill status-under-review">${app.applicationStatus}</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <form action="${pageContext.request.contextPath}/officer/applicants" method="post" class="d-flex gap-1">
                                                    <input type="hidden" name="applicationId" value="${app.applicationId}">
                                                    <input type="hidden" name="jobId" value="${job.jobId}">
                                                    <select name="status" class="form-select form-select-sm" style="width: 130px;">
                                                        <option value="SHORTLISTED" ${app.applicationStatus == 'SHORTLISTED' ? 'selected' : ''}>Shortlist</option>
                                                        <option value="SELECTED" ${app.applicationStatus == 'SELECTED' ? 'selected' : ''}>Select / Hire</option>
                                                        <option value="REJECTED" ${app.applicationStatus == 'REJECTED' ? 'selected' : ''}>Reject</option>
                                                        <option value="UNDER_REVIEW" ${app.applicationStatus == 'UNDER_REVIEW' ? 'selected' : ''}>Review</option>
                                                    </select>
                                                    <button type="submit" class="btn btn-sm btn-outline-primary py-0.5 px-2">Save</button>
                                                </form>
                                            </td>
                                            <td>
                                                <button type="button" class="btn btn-sm btn-outline-success py-0.5 px-2"
                                                        data-bs-toggle="modal" data-bs-target="#interviewModal"
                                                        onclick="setScheduleModal(${app.applicationId}, '${app.studentName}')">
                                                    <i class="bi bi-calendar-plus"></i> Schedule
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="9" class="text-center py-5 text-muted">No applicants registered for this job drive yet.</td>
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

<!-- Schedule Interview Modal -->
<div class="modal fade" id="interviewModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/officer/interviews" method="post">
                <input type="hidden" name="action" value="schedule">
                <input type="hidden" id="modalApplicationId" name="applicationId">

                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Schedule Interview Round</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p class="small text-muted mb-3">Scheduling interview for: <strong id="modalCandidateName" class="text-navy-900"></strong></p>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-muted">Round Number *</label>
                        <select name="roundNumber" class="form-select" required>
                            <option value="1">Round 1 (Technical Screening)</option>
                            <option value="2">Round 2 (Technical Coding)</option>
                            <option value="3">Round 3 (Managerial / HR)</option>
                            <option value="4">Round 4 (Final Discussion)</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-muted">Interview Date & Time *</label>
                        <input type="datetime-local" name="interviewDatetime" class="form-control" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-muted">Mode *</label>
                        <select name="mode" class="form-select" required>
                            <option value="ONLINE">Online (Virtual Meeting)</option>
                            <option value="OFFLINE">Offline (Campus Venue)</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-muted">Meeting URL or Campus Venue *</label>
                        <input type="text" name="meetingOrVenue" class="form-control" placeholder="https://meet.google.com/xyz or Placement Hall B" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary-cpms">Confirm & Dispatch Schedule</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function setScheduleModal(appId, candName) {
    document.getElementById('modalApplicationId').value = appId;
    document.getElementById('modalCandidateName').innerText = candName;
}
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

