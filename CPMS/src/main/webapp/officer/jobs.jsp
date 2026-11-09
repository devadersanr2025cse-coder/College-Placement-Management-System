<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Placement Job Postings | CPMS Officer</title>
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
                <h4>Campus Recruitment Job Drives</h4>
            </div>
            <div class="topbar-actions">
                <button type="button" class="btn btn-primary-cpms py-1.5 px-3" data-bs-toggle="modal" data-bs-target="#createJobModal">
                    <i class="bi bi-plus-circle me-1"></i> Post New Job Drive
                </button>
            </div>
        </header>

        <div class="content-body">

            <c:if test="${param.success == 'saved'}">
                <div class="alert alert-success d-flex align-items-center gap-2 mb-4">
                    <i class="bi bi-check-circle-fill fs-5"></i>
                    <div>Job drive posted and announced to eligible students!</div>
                </div>
            </c:if>

            <c:if test="${param.success == 'closed'}">
                <div class="alert alert-info d-flex align-items-center gap-2 mb-4">
                    <i class="bi bi-info-circle-fill fs-5"></i>
                    <div>Job drive closed successfully.</div>
                </div>
            </c:if>

            <div class="cpms-card">
                <div class="cpms-card-header">
                    <h5><i class="bi bi-briefcase-fill text-primary"></i> Active & Past Job Drives (${jobs.size()})</h5>
                </div>
                <div class="table-responsive">
                    <table class="cpms-table">
                        <thead>
                            <tr>
                                <th>Job Title & Company</th>
                                <th>Package</th>
                                <th>Eligibility Criteria</th>
                                <th>Eligible Departments</th>
                                <th>Applicants</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty jobs}">
                                    <c:forEach var="j" items="${jobs}">
                                        <tr>
                                            <td>
                                                <div class="fw-bold text-navy-900"><c:out value="${j.jobTitle}"/></div>
                                                <div class="text-muted small"><i class="bi bi-building me-1"></i><c:out value="${j.companyName}"/> • <c:out value="${j.location}"/></div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty j.packageLpa}">
                                                        <span class="fw-bold text-success"><c:out value="${j.packageLpa}"/> LPA</span>
                                                    </c:when>
                                                    <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="small">Min CGPA: <strong>${j.minCgpa}</strong></div>
                                                <div class="small text-muted">Max Backlogs: <strong>${j.maxBacklogs}</strong></div>
                                            </td>
                                            <td>
                                                <span class="small text-navy-900"><c:out value="${j.departmentNamesString}"/></span>
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/officer/applicants?jobId=${j.jobId}" class="badge bg-primary-subtle text-primary text-decoration-none border border-primary-subtle fs-6">
                                                    <i class="bi bi-people me-1"></i>${j.applicantCount} Applicants
                                                </a>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${j.jobStatus == 'OPEN'}">
                                                        <span class="status-pill status-approved">Open</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-pill status-rejected">Closed</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="d-flex gap-1">
                                                    <a href="${pageContext.request.contextPath}/officer/applicants?jobId=${j.jobId}" class="btn btn-sm btn-outline-primary py-0.5 px-2">
                                                        Applicants
                                                    </a>
                                                    <c:if test="${j.jobStatus == 'OPEN'}">
                                                        <a href="${pageContext.request.contextPath}/officer/jobs?close=${j.jobId}" class="btn btn-sm btn-outline-danger py-0.5 px-2" onclick="return confirm('Close this job posting?');">
                                                            Close
                                                        </a>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" class="text-center py-5 text-muted">No job postings created yet. Click Post New Job Drive to start.</td>
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

<!-- Create Job Drive Modal -->
<div class="modal fade" id="createJobModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/officer/jobs" method="post">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Post New Campus Recruitment Drive</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-muted">Select Company *</label>
                            <select name="companyId" class="form-select" required>
                                <option value="">Choose Company</option>
                                <c:forEach var="c" items="${companies}">
                                    <option value="${c.companyId}">${c.companyName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-muted">Job Title *</label>
                            <input type="text" name="jobTitle" class="form-control" placeholder="e.g. Graduate Software Engineer" required>
                        </div>

                        <div class="col-12">
                            <label class="form-label small fw-semibold text-muted">Job Description & Responsibilities</label>
                            <textarea name="jobDescription" class="form-control" rows="3" placeholder="Overview of the role, technical requirements..."></textarea>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label small fw-semibold text-muted">Employment Type</label>
                            <select name="jobType" class="form-select">
                                <option value="FULL_TIME">Full Time</option>
                                <option value="INTERNSHIP">Internship</option>
                                <option value="CONTRACT">Contract</option>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label small fw-semibold text-muted">Job Location</label>
                            <input type="text" name="location" class="form-control" placeholder="e.g. Bengaluru / Hybrid">
                        </div>

                        <div class="col-md-4">
                            <label class="form-label small fw-semibold text-muted">Annual Package (LPA)</label>
                            <input type="number" step="0.1" name="packageLpa" class="form-control" placeholder="e.g. 8.5">
                        </div>

                        <div class="col-md-4">
                            <label class="form-label small fw-semibold text-muted">Minimum CGPA (0-10)</label>
                            <input type="number" step="0.01" min="0" max="10" name="minCgpa" class="form-control" value="6.00" required>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label small fw-semibold text-muted">Max Allowed Backlogs</label>
                            <input type="number" min="0" max="10" name="maxBacklogs" class="form-control" value="0" required>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label small fw-semibold text-muted">Application Deadline</label>
                            <input type="datetime-local" name="applicationDeadline" class="form-control">
                        </div>

                        <div class="col-12">
                            <label class="form-label small fw-semibold text-muted">Eligible Academic Departments (Hold Ctrl to select multiple)</label>
                            <select name="departmentIds" class="form-select" multiple size="4">
                                <c:forEach var="dept" items="${departments}">
                                    <option value="${dept.departmentId}" selected>${dept.departmentName} (${dept.departmentCode})</option>
                                </c:forEach>
                            </select>
                            <div class="form-text">Students belonging only to selected departments will be marked eligible.</div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary-cpms">Publish Job Drive</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

