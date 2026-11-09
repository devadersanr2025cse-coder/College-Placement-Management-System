<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Company Job Drives | CPMS Recruiter</title>
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
            <a href="${pageContext.request.contextPath}/recruiter/jobs" class="sidebar-link active">
                <i class="bi bi-briefcase"></i> <span>Job Postings</span>
            </a>
            <a href="${pageContext.request.contextPath}/recruiter/candidates" class="sidebar-link">
                <i class="bi bi-person-lines-fill"></i> <span>Candidate Pipeline</span>
            </a>
            <a href="${pageContext.request.contextPath}/recruiter/interviews" class="sidebar-link">
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
                    <div class="meta text-truncate" title="${recruiter.companyName}"><c:out value="${recruiter.companyName}"/></div>
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
                <h4><c:out value="${recruiter.companyName}"/> Job Openings</h4>
            </div>
            <div class="topbar-actions">
                <button type="button" class="btn btn-primary-cpms py-1.5 px-3" data-bs-toggle="modal" data-bs-target="#newJobModal">
                    <i class="bi bi-plus-circle me-1"></i> Post New Job Opening
                </button>
            </div>
        </header>

        <div class="content-body">

            <c:if test="${param.success == 'created'}">
                <div class="alert alert-success d-flex align-items-center gap-2 mb-4">
                    <i class="bi bi-check-circle-fill fs-5"></i>
                    <div>Job drive posted successfully! Eligible students can now discover and apply.</div>
                </div>
            </c:if>

            <div class="cpms-card">
                <div class="cpms-card-header">
                    <h5><i class="bi bi-briefcase-fill text-primary"></i> Current Job Postings (${jobs.size()})</h5>
                </div>
                <div class="table-responsive">
                    <table class="cpms-table">
                        <thead>
                            <tr>
                                <th>Role Title</th>
                                <th>Package</th>
                                <th>Type & Location</th>
                                <th>Criteria (CGPA / Backlogs)</th>
                                <th>Applicants</th>
                                <th>Drive Status</th>
                                <th>Deadline</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty jobs}">
                                    <c:forEach var="j" items="${jobs}">
                                        <tr>
                                            <td>
                                                <div class="fw-bold text-navy-900"><c:out value="${j.jobTitle}"/></div>
                                                <div class="text-muted small text-truncate" style="max-width: 250px;"><c:out value="${j.jobDescription}"/></div>
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
                                                <span class="badge bg-light text-dark border"><c:out value="${j.jobType}"/></span>
                                                <div class="small text-muted"><c:out value="${j.location}"/></div>
                                            </td>
                                            <td>
                                                <div class="small">Min CGPA: <strong>${j.minCgpa}</strong></div>
                                                <div class="small text-muted">Max Backlogs: <strong>${j.maxBacklogs}</strong></div>
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/recruiter/candidates" class="badge bg-primary-subtle text-primary border border-primary-subtle fs-6 text-decoration-none">
                                                    <i class="bi bi-people me-1"></i>${j.applicantCount} Candidates
                                                </a>
                                            </td>
                                            <td>
                                                <span class="status-pill ${j.jobStatus == 'OPEN' ? 'status-approved' : 'status-rejected'}">
                                                    <c:out value="${j.jobStatus}"/>
                                                </span>
                                            </td>
                                            <td>
                                                <span class="small text-muted"><c:out value="${not empty j.applicationDeadline ? j.applicationDeadline : 'Open'}"/></span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" class="text-center py-5 text-muted">No jobs posted for your company yet.</td>
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

<!-- New Job Opening Modal -->
<div class="modal fade" id="newJobModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/recruiter/jobs" method="post">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Post New Job Opening</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-8">
                            <label class="form-label small fw-semibold text-muted">Job Title *</label>
                            <input type="text" name="jobTitle" class="form-control" placeholder="e.g. Software Engineer / Data Analyst" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold text-muted">Employment Type</label>
                            <select name="jobType" class="form-select">
                                <option value="FULL_TIME">Full Time</option>
                                <option value="INTERNSHIP">Internship</option>
                                <option value="CONTRACT">Contract</option>
                            </select>
                        </div>

                        <div class="col-12">
                            <label class="form-label small fw-semibold text-muted">Job Description</label>
                            <textarea name="jobDescription" class="form-control" rows="3" placeholder="Overview of responsibilities and technical qualifications..."></textarea>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-muted">Location</label>
                            <input type="text" name="location" class="form-control" placeholder="e.g. Bengaluru / Hybrid">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-muted">Annual Compensation (LPA)</label>
                            <input type="number" step="0.1" name="packageLpa" class="form-control" placeholder="e.g. 7.5">
                        </div>

                        <div class="col-md-4">
                            <label class="form-label small fw-semibold text-muted">Minimum CGPA (0-10)</label>
                            <input type="number" step="0.01" min="0" max="10" name="minCgpa" class="form-control" value="6.50" required>
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
                            <label class="form-label small fw-semibold text-muted">Eligible Engineering Departments</label>
                            <select name="departmentIds" class="form-select" multiple size="4">
                                <c:forEach var="dept" items="${departments}">
                                    <option value="${dept.departmentId}" selected>${dept.departmentName} (${dept.departmentCode})</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary-cpms">Publish Job Opening</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

