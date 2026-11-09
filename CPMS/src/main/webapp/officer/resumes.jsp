<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Resume Review Center | CPMS Officer</title>
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
            <a href="${pageContext.request.contextPath}/officer/resumes" class="sidebar-link active">
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
                <h4>Student Resume Verification & Review Repository</h4>
            </div>
            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}/officer/dashboard" class="btn btn-outline-cpms py-1.5 px-3">
                    <i class="bi bi-arrow-left me-1"></i> Dashboard
                </a>
            </div>
        </header>

        <div class="content-body">

            <div class="cpms-card">
                <div class="cpms-card-header">
                    <h5><i class="bi bi-file-earmark-text-fill text-primary"></i> Uploaded Student Resumes</h5>
                </div>
                <div class="table-responsive">
                    <table class="cpms-table">
                        <thead>
                            <tr>
                                <th>Student Name</th>
                                <th>Register Number</th>
                                <th>Department & Batch</th>
                                <th>Verified CGPA</th>
                                <th>Resume Document</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty students}">
                                    <c:forEach var="s" items="${students}">
                                        <c:if test="${not empty s.activeResumeId}">
                                            <tr>
                                                <td>
                                                    <div class="fw-bold text-navy-900"><c:out value="${s.fullName}"/></div>
                                                    <div class="text-muted small"><c:out value="${s.email}"/></div>
                                                </td>
                                                <td><span class="badge bg-light text-dark border font-monospace"><c:out value="${s.registerNumber}"/></span></td>
                                                <td>
                                                    <div><c:out value="${s.departmentName}"/></div>
                                                    <div class="text-muted small">Batch <c:out value="${s.batchYear}"/></div>
                                                </td>
                                                <td><span class="badge bg-success-subtle text-success fs-6 fw-bold"><c:out value="${s.cgpa}"/></span></td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/resume/download?id=${s.activeResumeId}" target="_blank" class="btn btn-sm btn-outline-danger py-0.5 px-2">
                                                        <i class="bi bi-file-earmark-pdf me-1"></i><c:out value="${s.resumeFileName}"/>
                                                    </a>
                                                </td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/officer/resumes?studentId=${s.studentId}" class="btn btn-sm btn-primary-cpms py-0.5 px-2.5">
                                                        <i class="bi bi-chat-dots me-1"></i> Review & Feedback
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="6" class="text-center py-5 text-muted">No student resumes available for review.</td>
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

