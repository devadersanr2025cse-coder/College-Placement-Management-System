<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Placement Officer Dashboard | CPMS</title>
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
            <a href="${pageContext.request.contextPath}/officer/dashboard" class="sidebar-link active">
                <i class="bi bi-speedometer2"></i> <span>Dashboard</span>
            </a>
            <a href="${pageContext.request.contextPath}/officer/verifications" class="sidebar-link">
                <i class="bi bi-check2-circle"></i> <span>Verification Queue</span>
                <c:if test="${not empty pendingUpdates and pendingUpdates.size() > 0}">
                    <span class="badge bg-danger ms-auto">${pendingUpdates.size()}</span>
                </c:if>
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
                <h4>Placement Administration Overview</h4>
            </div>
            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}/officer/reports?download=pdf" class="btn btn-outline-cpms py-1.5 px-3">
                    <i class="bi bi-file-earmark-pdf text-danger me-1"></i> PDF Summary
                </a>
                <a href="${pageContext.request.contextPath}/officer/reports?download=excel" class="btn btn-outline-cpms py-1.5 px-3">
                    <i class="bi bi-file-earmark-excel text-success me-1"></i> Excel Export
                </a>
            </div>
        </header>

        <div class="content-body">

            <!-- Stat Metric Widgets Row -->
            <div class="row g-3 mb-4">
                <div class="col-xl-3 col-sm-6">
                    <div class="stat-widget">
                        <div class="stat-content">
                            <div class="stat-label">Registered Students</div>
                            <div class="stat-value"><c:out value="${metrics.registeredStudents}"/></div>
                        </div>
                        <div class="stat-icon icon-blue">
                            <i class="bi bi-people-fill"></i>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-sm-6">
                    <div class="stat-widget">
                        <div class="stat-content">
                            <div class="stat-label">Pending Verifications</div>
                            <div class="stat-value text-warning"><c:out value="${metrics.pendingVerifications}"/></div>
                        </div>
                        <div class="stat-icon icon-amber">
                            <i class="bi bi-hourglass-split"></i>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-sm-6">
                    <div class="stat-widget">
                        <div class="stat-content">
                            <div class="stat-label">Placed Students</div>
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
                            <div class="stat-label">Placement Rate</div>
                            <div class="stat-value text-primary"><c:out value="${metrics.placementPercentage}"/>%</div>
                        </div>
                        <div class="stat-icon icon-purple">
                            <i class="bi bi-pie-chart-fill"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row g-4">
                
                <!-- Pending Academic Verifications Queue (Priority Module) -->
                <div class="col-lg-8">
                    <div class="cpms-card">
                        <div class="cpms-card-header">
                            <h5>
                                <i class="bi bi-patch-exclamation-fill text-warning"></i>
                                Pending Academic Update Queue (${pendingUpdates.size()})
                            </h5>
                            <a href="${pageContext.request.contextPath}/officer/verifications" class="btn btn-outline-cpms btn-sm">
                                Full Queue &rarr;
                            </a>
                        </div>
                        <div class="table-responsive">
                            <table class="cpms-table">
                                <thead>
                                    <tr>
                                        <th>Student & Reg No</th>
                                        <th>Department</th>
                                        <th>Old &rarr; Submitted CGPA</th>
                                        <th>Old &rarr; Submitted Backlogs</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty pendingUpdates}">
                                            <c:forEach var="u" items="${pendingUpdates}" end="4">
                                                <tr>
                                                    <td>
                                                        <div class="fw-bold text-navy-900"><c:out value="${u.studentName}"/></div>
                                                        <div class="text-muted small"><c:out value="${u.registerNumber}"/></div>
                                                    </td>
                                                    <td><span class="small"><c:out value="${u.departmentName}"/></span></td>
                                                    <td>
                                                        <span class="text-muted">${u.previousCgpa}</span>
                                                        <i class="bi bi-arrow-right text-primary mx-1"></i>
                                                        <strong class="text-success">${u.submittedCgpa}</strong>
                                                    </td>
                                                    <td>
                                                        <span class="text-muted">${u.previousBacklogs}</span>
                                                        <i class="bi bi-arrow-right text-primary mx-1"></i>
                                                        <strong class="${u.submittedBacklogs == 0 ? 'text-success' : 'text-danger'}">${u.submittedBacklogs}</strong>
                                                    </td>
                                                    <td>
                                                        <div class="d-flex gap-1">
                                                            <form action="${pageContext.request.contextPath}/officer/verifications" method="post" style="display:inline;">
                                                                <input type="hidden" name="updateId" value="${u.updateId}">
                                                                <input type="hidden" name="action" value="APPROVE">
                                                                <input type="hidden" name="officerRemarks" value="Verified and approved by Placement Officer.">
                                                                <button type="submit" class="btn btn-sm btn-success py-1 px-2" title="Approve Update">
                                                                    <i class="bi bi-check-lg"></i> Approve
                                                                </button>
                                                            </form>
                                                            <form action="${pageContext.request.contextPath}/officer/verifications" method="post" style="display:inline;">
                                                                <input type="hidden" name="updateId" value="${u.updateId}">
                                                                <input type="hidden" name="action" value="REJECT">
                                                                <input type="hidden" name="officerRemarks" value="Rejected: Verification criteria or mark sheet mismatch.">
                                                                <button type="submit" class="btn btn-sm btn-outline-danger py-1 px-2" title="Reject Update">
                                                                    <i class="bi bi-x-lg"></i>
                                                                </button>
                                                            </form>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="5" class="text-center py-4 text-muted small">
                                                    <i class="bi bi-check-circle text-success fs-5 me-1"></i> No pending academic verification requests. All records are up to date!
                                                </td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Department-Wise Placement Performance -->
                    <div class="cpms-card">
                        <div class="cpms-card-header">
                            <h5><i class="bi bi-diagram-3-fill text-primary"></i> Department Placement Breakdown</h5>
                        </div>
                        <div class="table-responsive">
                            <table class="cpms-table">
                                <thead>
                                    <tr>
                                        <th>Department</th>
                                        <th>Registered</th>
                                        <th>Placed</th>
                                        <th>Placement Rate</th>
                                        <th>Progress</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="dept" items="${deptStats}">
                                        <tr>
                                            <td class="fw-semibold text-navy-900"><c:out value="${dept.departmentName}"/></td>
                                            <td><c:out value="${dept.registeredStudents}"/></td>
                                            <td><strong class="text-success"><c:out value="${dept.placedStudents}"/></strong></td>
                                            <td><strong><c:out value="${dept.placementPercentage}"/>%</strong></td>
                                            <td style="width: 140px;">
                                                <div class="progress" style="height: 6px;">
                                                    <div class="progress-bar bg-success" style="width: ${dept.placementPercentage}%;"></div>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Right Column: Quick Stats & Upcoming Interviews -->
                <div class="col-lg-4">
                    
                    <!-- Quick Actions Card -->
                    <div class="cpms-card mb-4">
                        <div class="cpms-card-header">
                            <h5><i class="bi bi-lightning-charge-fill text-warning"></i> Quick Operations</h5>
                        </div>
                        <div class="cpms-card-body d-grid gap-2">
                            <a href="${pageContext.request.contextPath}/officer/jobs" class="btn btn-primary-cpms text-start py-2">
                                <i class="bi bi-plus-circle me-2"></i> Post New Job Drive
                            </a>
                            <a href="${pageContext.request.contextPath}/officer/companies" class="btn btn-outline-cpms text-start py-2">
                                <i class="bi bi-building-add me-2"></i> Register Hiring Company
                            </a>
                            <a href="${pageContext.request.contextPath}/officer/messages" class="btn btn-outline-cpms text-start py-2">
                                <i class="bi bi-megaphone me-2"></i> Broadcast Announcement
                            </a>
                            <a href="${pageContext.request.contextPath}/officer/students" class="btn btn-outline-cpms text-start py-2">
                                <i class="bi bi-search me-2"></i> Search Candidate Database
                            </a>
                        </div>
                    </div>

                    <!-- Upcoming Interviews Pipeline -->
                    <div class="cpms-card">
                        <div class="cpms-card-header">
                            <h5><i class="bi bi-calendar-event text-primary"></i> Upcoming Interviews</h5>
                            <a href="${pageContext.request.contextPath}/officer/interviews" class="small text-decoration-none">View All</a>
                        </div>
                        <div class="cpms-card-body p-0">
                            <div class="list-group list-group-flush">
                                <c:choose>
                                    <c:when test="${not empty upcomingInterviews}">
                                        <c:forEach var="iv" items="${upcomingInterviews}">
                                            <div class="list-group-item p-3">
                                                <div class="d-flex justify-content-between align-items-center mb-1">
                                                    <strong class="text-navy-900 small"><c:out value="${iv.studentName}"/></strong>
                                                    <span class="badge bg-primary-subtle text-primary">Round ${iv.roundNumber}</span>
                                                </div>
                                                <div class="text-muted small mb-1">
                                                    <c:out value="${iv.companyName}"/> • <c:out value="${iv.jobTitle}"/>
                                                </div>
                                                <div class="small text-muted d-flex align-items-center gap-2">
                                                    <i class="bi bi-clock"></i> <c:out value="${iv.interviewDatetime}"/>
                                                    <span class="badge bg-light text-dark border"><c:out value="${iv.mode}"/></span>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-4 text-muted small">No upcoming interviews scheduled.</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
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

