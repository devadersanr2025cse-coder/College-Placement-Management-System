<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Interview Pipeline | CPMS Officer</title>
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
            <a href="${pageContext.request.contextPath}/officer/interviews" class="sidebar-link active">
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
                <h4>Interview Coordination Pipeline</h4>
            </div>
            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}/officer/dashboard" class="btn btn-outline-cpms py-1.5 px-3">
                    <i class="bi bi-arrow-left me-1"></i> Dashboard
                </a>
            </div>
        </header>

        <div class="content-body">

            <c:if test="${param.success == 'scheduled'}">
                <div class="alert alert-success d-flex align-items-center gap-2 mb-4">
                    <i class="bi bi-check-circle-fill fs-5"></i>
                    <div>Interview scheduled and student notified!</div>
                </div>
            </c:if>

            <c:if test="${param.success == 'result'}">
                <div class="alert alert-info d-flex align-items-center gap-2 mb-4">
                    <i class="bi bi-info-circle-fill fs-5"></i>
                    <div>Interview evaluation recorded and candidate notified.</div>
                </div>
            </c:if>

            <div class="cpms-card">
                <div class="cpms-card-header">
                    <h5><i class="bi bi-calendar-check-fill text-primary"></i> Active & Upcoming Interviews (${interviews.size()})</h5>
                </div>
                <div class="table-responsive">
                    <table class="cpms-table">
                        <thead>
                            <tr>
                                <th>Candidate & Reg No</th>
                                <th>Company & Job Title</th>
                                <th>Round</th>
                                <th>Date & Time</th>
                                <th>Mode & Meeting Details</th>
                                <th>Result / Status</th>
                                <th>Notes / Feedback</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty interviews}">
                                    <c:forEach var="iv" items="${interviews}">
                                        <tr>
                                            <td>
                                                <div class="fw-bold text-navy-900"><c:out value="${iv.studentName}"/></div>
                                                <div class="text-muted small"><c:out value="${iv.registerNumber}"/></div>
                                            </td>
                                            <td>
                                                <div><c:out value="${iv.companyName}"/></div>
                                                <div class="text-muted small"><c:out value="${iv.jobTitle}"/></div>
                                            </td>
                                            <td>
                                                <span class="badge bg-primary-subtle text-primary border border-primary-subtle">
                                                    Round ${iv.roundNumber}
                                                </span>
                                            </td>
                                            <td><span class="small fw-semibold"><c:out value="${iv.interviewDatetime}"/></span></td>
                                            <td>
                                                <span class="badge bg-light text-dark border mb-1"><c:out value="${iv.mode}"/></span>
                                                <div class="small text-truncate" style="max-width: 200px;"><c:out value="${iv.meetingOrVenue}"/></div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${iv.result == 'PASSED'}">
                                                        <span class="status-pill status-selected"><i class="bi bi-check-circle me-1"></i>Passed</span>
                                                    </c:when>
                                                    <c:when test="${iv.result == 'FAILED'}">
                                                        <span class="status-pill status-rejected"><i class="bi bi-x-circle me-1"></i>Failed</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-pill status-pending"><i class="bi bi-hourglass-split me-1"></i>Pending</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <span class="small text-muted"><c:out value="${not empty iv.notes ? iv.notes : '—'}"/></span>
                                            </td>
                                            <td>
                                                <button type="button" class="btn btn-sm btn-outline-primary py-0.5 px-2"
                                                        data-bs-toggle="modal" data-bs-target="#recordResultModal"
                                                        onclick="setResultModal(${iv.interviewId}, '${iv.studentName}', ${iv.roundNumber})">
                                                    Record Result
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="8" class="text-center py-5 text-muted">No scheduled interviews currently.</td>
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

<!-- Record Result Modal -->
<div class="modal fade" id="recordResultModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/officer/interviews" method="post">
                <input type="hidden" name="action" value="result">
                <input type="hidden" id="modalResultInterviewId" name="interviewId">

                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Record Interview Evaluation</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p class="small text-muted mb-3">
                        Candidate: <strong id="modalCandidateLabel" class="text-navy-900"></strong> |
                        Round: <strong id="modalRoundLabel" class="text-primary"></strong>
                    </p>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-muted">Interview Evaluation Result *</label>
                        <select name="result" class="form-select" required>
                            <option value="PASSED">Passed (Advance to Next Round / Offer)</option>
                            <option value="FAILED">Failed (Not Qualified)</option>
                            <option value="PENDING">Pending Evaluation</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-muted">Officer / Interviewer Notes</label>
                        <textarea name="notes" class="form-control" rows="3" placeholder="Technical evaluation, coding score, communication feedback..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary-cpms">Save & Release Evaluation</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function setResultModal(ivId, candName, roundNo) {
    document.getElementById('modalResultInterviewId').value = ivId;
    document.getElementById('modalCandidateLabel').innerText = candName;
    document.getElementById('modalRoundLabel').innerText = 'Round ' + roundNo;
}
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

