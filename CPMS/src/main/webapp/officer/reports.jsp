<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Placement Reports & Analytics | CPMS Officer</title>
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
            <a href="${pageContext.request.contextPath}/officer/messages" class="sidebar-link">
                <i class="bi bi-chat-quote"></i> <span>Announcements</span>
            </a>
            <a href="${pageContext.request.contextPath}/officer/reports" class="sidebar-link active">
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
                <h4>Placement Analytics & Official Report Export</h4>
            </div>
            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}/officer/reports?download=pdf" class="btn btn-danger py-1.5 px-3 fw-semibold">
                    <i class="bi bi-file-earmark-pdf-fill me-1"></i> Export PDF Report
                </a>
                <a href="${pageContext.request.contextPath}/officer/reports?download=excel" class="btn btn-success py-1.5 px-3 fw-semibold">
                    <i class="bi bi-file-earmark-excel-fill me-1"></i> Export Excel Workbook
                </a>
            </div>
        </header>

        <div class="content-body">

            <!-- Executive KPI Metrics Row -->
            <div class="row g-3 mb-4">
                <div class="col-xl-3 col-sm-6">
                    <div class="stat-widget">
                        <div class="stat-content">
                            <div class="stat-label">Placement Percentage</div>
                            <div class="stat-value text-primary"><c:out value="${metrics.placementPercentage}"/>%</div>
                        </div>
                        <div class="stat-icon icon-blue">
                            <i class="bi bi-percent"></i>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-sm-6">
                    <div class="stat-widget">
                        <div class="stat-content">
                            <div class="stat-label">Students Placed</div>
                            <div class="stat-value text-success"><c:out value="${metrics.placedStudents}"/></div>
                        </div>
                        <div class="stat-icon icon-green">
                            <i class="bi bi-award-fill"></i>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-sm-6">
                    <div class="stat-widget">
                        <div class="stat-content">
                            <div class="stat-label">Active Drives</div>
                            <div class="stat-value"><c:out value="${metrics.activeJobs}"/></div>
                        </div>
                        <div class="stat-icon icon-amber">
                            <i class="bi bi-briefcase-fill"></i>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-sm-6">
                    <div class="stat-widget">
                        <div class="stat-content">
                            <div class="stat-label">Total Applications</div>
                            <div class="stat-value"><c:out value="${metrics.totalApplications}"/></div>
                        </div>
                        <div class="stat-icon icon-purple">
                            <i class="bi bi-send-fill"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Department Analytics Table -->
            <div class="cpms-card mb-4">
                <div class="cpms-card-header">
                    <h5><i class="bi bi-mortarboard-fill text-primary"></i> Department-Wise Placement Statistics</h5>
                </div>
                <div class="table-responsive">
                    <table class="cpms-table">
                        <thead>
                            <tr>
                                <th>Department Name</th>
                                <th>Code</th>
                                <th>Total Enrolled</th>
                                <th>Registered on Portal</th>
                                <th>Hired / Placed</th>
                                <th>Placement Percentage</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="d" items="${deptStats}">
                                <tr>
                                    <td class="fw-bold text-navy-900"><c:out value="${d.departmentName}"/></td>
                                    <td><span class="badge bg-light text-dark border"><c:out value="${d.departmentCode}"/></span></td>
                                    <td><c:out value="${d.totalStudents}"/></td>
                                    <td><c:out value="${d.registeredStudents}"/></td>
                                    <td><strong class="text-success"><c:out value="${d.placedStudents}"/></strong></td>
                                    <td>
                                        <div class="d-flex align-items-center gap-2">
                                            <div class="progress flex-grow-1" style="height: 6px; width: 100px;">
                                                <div class="progress-bar bg-primary" style="width: ${d.placementPercentage}%;"></div>
                                            </div>
                                            <span class="fw-semibold small">${d.placementPercentage}%</span>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Company Hiring Partners Table -->
            <div class="cpms-card">
                <div class="cpms-card-header">
                    <h5><i class="bi bi-buildings text-primary"></i> Corporate Partner Hiring Analytics</h5>
                </div>
                <div class="table-responsive">
                    <table class="cpms-table">
                        <thead>
                            <tr>
                                <th>Company Name</th>
                                <th>Industry Sector</th>
                                <th>Job Drives</th>
                                <th>Total Applicants</th>
                                <th>Candidates Hired</th>
                                <th>Highest Package Offered</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="c" items="${companyStats}">
                                <tr>
                                    <td class="fw-bold text-navy-900"><c:out value="${c.companyName}"/></td>
                                    <td><span class="text-muted small"><c:out value="${c.industry}"/></span></td>
                                    <td><c:out value="${c.jobsPosted}"/></td>
                                    <td><c:out value="${c.totalApplicants}"/></td>
                                    <td><strong class="text-success"><c:out value="${c.hiredCount}"/></strong></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty c.highestPackage}">
                                                <span class="badge bg-success-subtle text-success fs-6 fw-bold"><c:out value="${c.highestPackage}"/> LPA</span>
                                            </c:when>
                                            <c:otherwise><span class="text-muted small">—</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
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

