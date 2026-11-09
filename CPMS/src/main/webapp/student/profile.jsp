<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | CPMS</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <!-- CPMS Theme -->
    <link href="${pageContext.request.contextPath}/assets/css/cpms-theme.css" rel="stylesheet">
</head>
<body>

<div class="app-wrapper">

    <!-- Sidebar Navigation -->
    <aside class="app-sidebar">
        <div class="sidebar-brand">
            <a href="${pageContext.request.contextPath}/student/dashboard">
                <i class="bi bi-mortarboard-fill text-primary"></i>
                <span>CPMS</span>
                <span class="badge-role bg-primary text-white ms-auto">Student</span>
            </a>
        </div>

        <div class="sidebar-menu">
            <div class="nav-section-title">Navigation</div>
            <a href="${pageContext.request.contextPath}/student/dashboard" class="sidebar-link">
                <i class="bi bi-grid-1x2-fill"></i> <span>Dashboard</span>
            </a>
            <a href="${pageContext.request.contextPath}/student/profile" class="sidebar-link active">
                <i class="bi bi-person-badge"></i> <span>My Profile</span>
            </a>
            <a href="${pageContext.request.contextPath}/student/academic" class="sidebar-link">
                <i class="bi bi-award"></i> <span>Academic Info</span>
                <c:if test="${student.hasPendingUpdate}">
                    <span class="badge bg-warning text-dark ms-auto" style="font-size: 0.65rem;">Pending</span>
                </c:if>
            </a>
            <a href="${pageContext.request.contextPath}/student/jobs" class="sidebar-link">
                <i class="bi bi-briefcase"></i> <span>Job Openings</span>
            </a>
            <a href="${pageContext.request.contextPath}/student/applications" class="sidebar-link">
                <i class="bi bi-send-check"></i> <span>Applications</span>
            </a>
            <a href="${pageContext.request.contextPath}/student/resume" class="sidebar-link">
                <i class="bi bi-file-earmark-pdf"></i> <span>Resume Manager</span>
            </a>
            <a href="${pageContext.request.contextPath}/student/interviews" class="sidebar-link">
                <i class="bi bi-calendar-event"></i> <span>Interviews</span>
            </a>
            <a href="${pageContext.request.contextPath}/student/messages" class="sidebar-link">
                <i class="bi bi-chat-left-dots"></i> <span>Messages</span>
            </a>
            <a href="${pageContext.request.contextPath}/student/notifications" class="sidebar-link">
                <i class="bi bi-bell"></i> <span>Notifications</span>
            </a>
        </div>

        <div class="sidebar-footer">
            <div class="user-profile-widget">
                <div class="user-avatar">
                    <c:out value="${sessionScope.fullName.substring(0,1)}"/>
                </div>
                <div class="user-info">
                    <div class="name"><c:out value="${sessionScope.fullName}"/></div>
                    <div class="meta"><c:out value="${student.registerNumber}"/></div>
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
                <h4>My Profile Settings</h4>
            </div>
            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-outline-cpms py-1.5 px-3">
                    <i class="bi bi-arrow-left me-1"></i> Dashboard
                </a>
            </div>
        </header>

        <div class="content-body">

            <c:if test="${param.success == 'true'}">
                <div class="alert alert-success d-flex align-items-center gap-2 mb-4">
                    <i class="bi bi-check-circle-fill"></i>
                    <div>Contact information updated successfully!</div>
                </div>
            </c:if>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger d-flex align-items-center gap-2 mb-4">
                    <i class="bi bi-exclamation-triangle-fill"></i>
                    <div><c:out value="${errorMessage}"/></div>
                </div>
            </c:if>

            <div class="row g-4">
                
                <!-- Personal & Contact Details Form -->
                <div class="col-lg-8">
                    <div class="cpms-card">
                        <div class="cpms-card-header">
                            <h5><i class="bi bi-person-lines-fill text-primary"></i> Personal & Contact Information</h5>
                        </div>
                        <div class="cpms-card-body">
                            <form action="${pageContext.request.contextPath}/student/profile" method="post">
                                
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label small fw-semibold text-muted">Full Name</label>
                                        <input type="text" class="form-control bg-light" value="<c:out value='${student.fullName}'/>" readonly>
                                        <div class="form-text">Name linked to your college registration record.</div>
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label small fw-semibold text-muted">Register Number</label>
                                        <input type="text" class="form-control bg-light fw-bold" value="<c:out value='${student.registerNumber}'/>" readonly>
                                        <div class="form-text">Official college roll number.</div>
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label small fw-semibold text-muted">College Email Address</label>
                                        <input type="email" class="form-control bg-light" value="<c:out value='${student.email}'/>" readonly>
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label small fw-semibold text-muted">Phone Number *</label>
                                        <input type="tel" name="phone" class="form-control" pattern="[0-9]{10,15}" maxlength="15" value="<c:out value='${student.phone}'/>" placeholder="10-digit mobile number" required>
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label small fw-semibold text-muted">Date of Birth</label>
                                        <input type="date" name="dateOfBirth" class="form-control" value="${student.dateOfBirth}">
                                    </div>

                                    <div class="col-12">
                                        <label class="form-label small fw-semibold text-muted">Current Address</label>
                                        <textarea name="address" class="form-control" rows="3" maxlength="1000" placeholder="Residential / Communication address"><c:out value="${student.address}"/></textarea>
                                    </div>
                                </div>

                                <div class="mt-4 pt-3 border-top d-flex gap-2">
                                    <button type="submit" class="btn btn-primary-cpms px-4">
                                        <i class="bi bi-save me-1"></i> Save Changes
                                    </button>
                                    <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-outline-cpms">
                                        Cancel
                                    </a>
                                </div>

                            </form>
                        </div>
                    </div>
                </div>

                <!-- Verified Academic Snapshot (Read-Only) -->
                <div class="col-lg-4">
                    <div class="cpms-card">
                        <div class="cpms-card-header">
                            <h5><i class="bi bi-award-fill text-warning"></i> Academic Record</h5>
                        </div>
                        <div class="cpms-card-body">
                            <div class="alert alert-info py-2 px-3 small mb-3">
                                <i class="bi bi-shield-check me-1"></i> Academic details are officially verified by the Placement Cell.
                            </div>

                            <ul class="list-group list-group-flush mb-3">
                                <li class="list-group-item d-flex justify-content-between align-items-center px-0">
                                    <span class="text-muted small">Department</span>
                                    <span class="fw-semibold text-navy-900"><c:out value="${student.departmentName}"/></span>
                                </li>
                                <li class="list-group-item d-flex justify-content-between align-items-center px-0">
                                    <span class="text-muted small">Batch Year</span>
                                    <span class="fw-semibold text-navy-900"><c:out value="${student.batchYear}"/></span>
                                </li>
                                <li class="list-group-item d-flex justify-content-between align-items-center px-0">
                                    <span class="text-muted small">Verified CGPA</span>
                                    <span class="badge bg-success-subtle text-success fs-6 fw-bold"><c:out value="${student.cgpa}"/></span>
                                </li>
                                <li class="list-group-item d-flex justify-content-between align-items-center px-0">
                                    <span class="text-muted small">Active Backlogs</span>
                                    <span class="badge ${student.activeBacklogs == 0 ? 'bg-success-subtle text-success' : 'bg-danger-subtle text-danger'} fs-6 fw-bold"><c:out value="${student.activeBacklogs}"/></span>
                                </li>
                            </ul>

                            <div class="p-3 bg-light rounded-3 text-center border">
                                <p class="small text-muted mb-2">Need to update your CGPA or backlog count?</p>
                                <a href="${pageContext.request.contextPath}/student/academic" class="btn btn-outline-cpms btn-sm w-100">
                                    <i class="bi bi-pencil-square me-1"></i> Submit Academic Update
                                </a>
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
