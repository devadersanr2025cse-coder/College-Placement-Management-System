<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Directory | CPMS Officer</title>
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
            <a href="${pageContext.request.contextPath}/officer/students" class="sidebar-link active">
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
                <h4>Student Database Management</h4>
            </div>
            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}/officer/dashboard" class="btn btn-outline-cpms py-1.5 px-3">
                    <i class="bi bi-arrow-left me-1"></i> Dashboard
                </a>
            </div>
        </header>

        <div class="content-body">

            <!-- Search & Filter Bar -->
            <div class="cpms-card mb-4">
                <div class="cpms-card-body p-3">
                    <form action="${pageContext.request.contextPath}/officer/students" method="get" class="row g-2 align-items-center">
                        <div class="col-md-5">
                            <div class="input-group">
                                <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
                                <input type="text" name="q" class="form-control" placeholder="Search by student name, register number or email..." value="<c:out value='${query}'/>">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <select name="departmentId" class="form-select">
                                <option value="">All Departments</option>
                                <c:forEach var="dept" items="${departments}">
                                    <option value="${dept.departmentId}" ${selectedDept == dept.departmentId ? 'selected' : ''}>
                                        <c:out value="${dept.departmentName}"/>
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <select name="batchYear" class="form-select">
                                <option value="">All Batches</option>
                                <option value="2026" ${selectedBatch == 2026 ? 'selected' : ''}>Batch 2026</option>
                                <option value="2027" ${selectedBatch == 2027 ? 'selected' : ''}>Batch 2027</option>
                                <option value="2025" ${selectedBatch == 2025 ? 'selected' : ''}>Batch 2025</option>
                            </select>
                        </div>
                        <div class="col-md-2 d-flex gap-2">
                            <button type="submit" class="btn btn-primary-cpms w-100">Filter</button>
                            <a href="${pageContext.request.contextPath}/officer/students" class="btn btn-outline-secondary">Reset</a>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Student Directory Table -->
            <div class="cpms-card">
                <div class="cpms-card-header">
                    <h5><i class="bi bi-people-fill text-primary"></i> Registered & Pre-Seeded Students (${students.size()})</h5>
                </div>
                <div class="table-responsive">
                    <table class="cpms-table">
                        <thead>
                            <tr>
                                <th>Student Name</th>
                                <th>Register Number</th>
                                <th>Department & Batch</th>
                                <th>Verified CGPA</th>
                                <th>Backlogs</th>
                                <th>Account Status</th>
                                <th>Resume</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty students}">
                                    <c:forEach var="s" items="${students}">
                                        <tr>
                                            <td>
                                                <div class="fw-bold text-navy-900"><c:out value="${not empty s.fullName ? s.fullName : 'Pre-seeded Academic Record'}"/></div>
                                                <div class="text-muted small"><c:out value="${s.email}"/></div>
                                            </td>
                                            <td><span class="badge bg-light text-dark border font-monospace"><c:out value="${s.registerNumber}"/></span></td>
                                            <td>
                                                <div><c:out value="${s.departmentName}"/></div>
                                                <div class="text-muted small">Batch <c:out value="${s.batchYear}"/></div>
                                            </td>
                                            <td><span class="badge bg-success-subtle text-success fs-6 fw-bold"><c:out value="${s.cgpa}"/></span></td>
                                            <td>
                                                <span class="badge ${s.activeBacklogs == 0 ? 'bg-success-subtle text-success' : 'bg-danger-subtle text-danger'} fw-bold">
                                                    <c:out value="${s.activeBacklogs}"/>
                                                </span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty s.userId}">
                                                        <span class="badge bg-success"><i class="bi bi-check-circle me-1"></i>Active</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-warning text-dark"><i class="bi bi-clock me-1"></i>Unlinked Record</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty s.activeResumeId}">
                                                        <a href="${pageContext.request.contextPath}/resume/download?id=${s.activeResumeId}" target="_blank" class="btn btn-sm btn-outline-danger py-0.5 px-2">
                                                            <i class="bi bi-file-earmark-pdf"></i> Resume
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise><span class="text-muted small">—</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:if test="${not empty s.activeResumeId}">
                                                    <a href="${pageContext.request.contextPath}/officer/resumes?studentId=${s.studentId}" class="btn btn-sm btn-outline-primary py-0.5 px-2" title="Review Resume">
                                                        <i class="bi bi-chat-left-quote"></i> Feedback
                                                    </a>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="8" class="text-center py-5 text-muted">No students matching your search criteria.</td>
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

