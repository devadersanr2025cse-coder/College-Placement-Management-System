<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Academic Verification Queue | CPMS Officer</title>
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
            <a href="${pageContext.request.contextPath}/officer/verifications" class="sidebar-link active">
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
                <h4>Dedicated Academic Verification Panel</h4>
            </div>
            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}/officer/dashboard" class="btn btn-outline-cpms py-1.5 px-3">
                    <i class="bi bi-arrow-left me-1"></i> Dashboard
                </a>
            </div>
        </header>

        <div class="content-body">

            <c:if test="${param.success == 'approved'}">
                <div class="alert alert-success d-flex align-items-center gap-2 mb-4">
                    <i class="bi bi-check-circle-fill fs-5"></i>
                    <div>Academic update approved successfully! Official student records updated and student notified.</div>
                </div>
            </c:if>

            <c:if test="${param.success == 'rejected'}">
                <div class="alert alert-warning d-flex align-items-center gap-2 mb-4">
                    <i class="bi bi-x-circle-fill fs-5"></i>
                    <div>Academic update rejected. Official records preserved and student notified with remarks.</div>
                </div>
            </c:if>

            <div class="cpms-card">
                <div class="cpms-card-header">
                    <h5><i class="bi bi-list-check text-primary"></i> Pending Verification Queue (${pendingUpdates.size()})</h5>
                </div>
                <div class="cpms-card-body">
                    <p class="text-muted small mb-4">
                        Review student submitted CGPA and backlog updates. Compare against their previous verified records. Only approved updates modify official student records used for job eligibility and recruiter candidate search.
                    </p>

                    <c:choose>
                        <c:when test="${not empty pendingUpdates}">
                            <div class="row g-4">
                                <c:forEach var="u" items="${pendingUpdates}">
                                    <div class="col-lg-6">
                                        <div class="p-4 bg-light rounded-3 border">
                                            <div class="d-flex justify-content-between align-items-start mb-3">
                                                <div>
                                                    <h5 class="fw-bold text-navy-900 mb-0"><c:out value="${u.studentName}"/></h5>
                                                    <div class="text-primary fw-semibold small">Reg No: <c:out value="${u.registerNumber}"/></div>
                                                    <div class="text-muted small"><c:out value="${u.departmentName}"/></div>
                                                </div>
                                                <span class="status-pill status-pending"><i class="bi bi-clock me-1"></i>Pending</span>
                                            </div>

                                            <!-- Comparison Table -->
                                            <table class="table table-bordered table-sm bg-white mb-3 text-center">
                                                <thead class="table-light">
                                                    <tr>
                                                        <th>Metric</th>
                                                        <th>Current Verified</th>
                                                        <th>Submitted Update</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <td class="text-start ps-3 fw-semibold">CGPA</td>
                                                        <td><span class="badge bg-secondary-subtle text-secondary fs-6">${u.previousCgpa}</span></td>
                                                        <td><span class="badge bg-success-subtle text-success fs-6 fw-bold">${u.submittedCgpa}</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="text-start ps-3 fw-semibold">Active Backlogs</td>
                                                        <td><span class="badge bg-secondary-subtle text-secondary fs-6">${u.previousBacklogs}</span></td>
                                                        <td><span class="badge ${u.submittedBacklogs == 0 ? 'bg-success-subtle text-success' : 'bg-danger-subtle text-danger'} fs-6 fw-bold">${u.submittedBacklogs}</span></td>
                                                    </tr>
                                                </tbody>
                                            </table>

                                            <c:if test="${not empty u.studentRemarks}">
                                                <div class="p-2.5 bg-white rounded border mb-3 small">
                                                    <strong class="text-muted">Student Remarks:</strong>
                                                    <div class="text-dark">"<c:out value="${u.studentRemarks}"/>"</div>
                                                </div>
                                            </c:if>

                                            <!-- Decision Form -->
                                            <form action="${pageContext.request.contextPath}/officer/verifications" method="post">
                                                <input type="hidden" name="updateId" value="${u.updateId}">
                                                <div class="mb-3">
                                                    <input type="text" name="officerRemarks" class="form-control form-control-sm" placeholder="Officer remarks (optional for approval, required for rejection)">
                                                </div>
                                                <div class="d-flex gap-2">
                                                    <button type="submit" name="action" value="APPROVE" class="btn btn-success btn-sm flex-grow-1">
                                                        <i class="bi bi-check-circle me-1"></i> Approve Update
                                                    </button>
                                                    <button type="submit" name="action" value="REJECT" class="btn btn-outline-danger btn-sm flex-grow-1">
                                                        <i class="bi bi-x-circle me-1"></i> Reject Update
                                                    </button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-5 text-muted">
                                <i class="bi bi-patch-check-fill text-success fs-1 d-block mb-2"></i>
                                <h5>All Caught Up!</h5>
                                <p class="small text-muted">There are no pending academic verification requests at this time.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

