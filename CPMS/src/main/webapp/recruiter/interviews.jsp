<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Interview Pipeline | CPMS Recruiter</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <!-- CPMS Theme -->
    <link href="${pageContext.request.contextPath}/assets/css/cpms-theme.css" rel="stylesheet">
</head>
<body>

<div class="app-wrapper">

    <!-- Recruiter Sidebar Navigation -->
    <aside class="app-sidebar">
        <div class="sidebar-brand">
            <a href="${pageContext.request.contextPath}/recruiter/dashboard">
                <i class="bi bi-briefcase-fill text-success"></i>
                <span>CPMS</span>
                <span class="badge-role bg-success text-white ms-auto">Recruiter</span>
            </a>
        </div>

        <div class="sidebar-menu">
            <div class="nav-section-title">Hiring Portal</div>
            <a href="${pageContext.request.contextPath}/recruiter/dashboard" class="sidebar-link">
                <i class="bi bi-speedometer2"></i> <span>Dashboard</span>
            </a>
            <a href="${pageContext.request.contextPath}/recruiter/jobs" class="sidebar-link">
                <i class="bi bi-briefcase"></i> <span>Job Postings</span>
            </a>
            <a href="${pageContext.request.contextPath}/recruiter/candidates" class="sidebar-link">
                <i class="bi bi-person-lines-fill"></i> <span>Candidate Pipeline</span>
            </a>
            <a href="${pageContext.request.contextPath}/recruiter/interviews" class="sidebar-link active">
                <i class="bi bi-calendar-check"></i> <span>Interviews</span>
            </a>
            <a href="${pageContext.request.contextPath}/recruiter/profile" class="sidebar-link">
                <i class="bi bi-building"></i> <span>Company Profile</span>
            </a>
        </div>

        <div class="sidebar-footer">
            <div class="user-profile-widget">
                <div class="user-avatar bg-success text-white">
                    <c:out value="${sessionScope.fullName.substring(0,1)}"/>
                </div>
                <div class="user-info">
                    <div class="name"><c:out value="${sessionScope.fullName}"/></div>
                    <div class="meta text-truncate" title="${sessionScope.companyName}"><c:out value="${sessionScope.companyName}"/></div>
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
                <h4><c:out value="${recruiter.companyName}"/> Interview Schedules & Evaluations</h4>
            </div>
            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}/recruiter/dashboard" class="btn btn-outline-cpms py-1.5 px-3">
                    <i class="bi bi-arrow-left me-1"></i> Dashboard
                </a>
            </div>
        </header>

        <div class="content-body">

            <c:if test="${param.success == 'result'}">
                <div class="alert alert-success d-flex align-items-center gap-2 mb-4">
                    <i class="bi bi-check-circle-fill fs-5"></i>
                    <div>Interview evaluation recorded and synchronized with Placement Cell!</div>
                </div>
            </c:if>

            <div class="cpms-card">
                <div class="cpms-card-header">
                    <h5><i class="bi bi-calendar3-event text-primary"></i> Scheduled Company Interviews (${interviews.size()})</h5>
                </div>
                <div class="table-responsive">
                    <table class="cpms-table">
                        <thead>
                            <tr>
                                <th>Candidate Name</th>
                                <th>Position</th>
                                <th>Round</th>
                                <th>Date & Time</th>
                                <th>Mode & Meeting Details</th>
                                <th>Result / Decision</th>
                                <th>Evaluation Notes</th>
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
                                            <td><div class="small fw-semibold"><c:out value="${iv.jobTitle}"/></div></td>
                                            <td>
                                                <span class="badge bg-primary-subtle text-primary border border-primary-subtle">
                                                    Round ${iv.roundNumber}
                                                </span>
                                            </td>
                                            <td><span class="small fw-semibold"><c:out value="${iv.interviewDatetime}"/></span></td>
                                            <td>
                                                <span class="badge bg-light text-dark border mb-1"><c:out value="${iv.mode}"/></span>
                                                <div class="small text-truncate" style="max-width: 180px;"><c:out value="${iv.meetingOrVenue}"/></div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${iv.result == 'PASSED'}">
                                                        <span class="status-pill status-selected">Passed</span>
                                                    </c:when>
                                                    <c:when test="${iv.result == 'FAILED'}">
                                                        <span class="status-pill status-rejected">Failed</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-pill status-pending">Pending</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <span class="small text-muted"><c:out value="${not empty iv.notes ? iv.notes : '—'}"/></span>
                                            </td>
                                            <td>
                                                <button type="button" class="btn btn-sm btn-outline-primary py-0.5 px-2"
                                                        data-bs-toggle="modal" data-bs-target="#evaluationModal"
                                                        onclick="setRecruiterResultModal(${iv.interviewId}, '${iv.studentName}', ${iv.roundNumber})">
                                                    Evaluate
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="8" class="text-center py-5 text-muted">No interviews scheduled for your company drives currently.</td>
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

<!-- Evaluation Modal -->
<div class="modal fade" id="evaluationModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/recruiter/interviews" method="post">
                <input type="hidden" id="modalEvalInterviewId" name="interviewId">

                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Candidate Interview Evaluation</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p class="small text-muted mb-3">
                        Candidate: <strong id="modalEvalCandidate" class="text-navy-900"></strong> |
                        Round: <strong id="modalEvalRound" class="text-primary"></strong>
                    </p>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-muted">Interview Decision *</label>
                        <select name="result" class="form-select" required>
                            <option value="PASSED">Passed (Recommend for Selection / Next Round)</option>
                            <option value="FAILED">Failed (Not Recommended)</option>
                            <option value="PENDING">Pending Evaluation</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-muted">Recruiter Evaluation Feedback</label>
                        <textarea name="notes" class="form-control" rows="3" placeholder="Technical competencies, problem solving, communication remarks..." required></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary-cpms">Submit Evaluation</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function setRecruiterResultModal(ivId, candName, roundNo) {
    document.getElementById('modalEvalInterviewId').value = ivId;
    document.getElementById('modalEvalCandidate').innerText = candName;
    document.getElementById('modalEvalRound').innerText = 'Round ' + roundNo;
}
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

