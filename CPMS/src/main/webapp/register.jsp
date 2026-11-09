<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CPMS | Account Registration</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <!-- CPMS Theme -->
    <link href="${pageContext.request.contextPath}/assets/css/cpms-theme.css" rel="stylesheet">
    <style>
        body {
            background-color: #f1f5f9;
            min-height: 100vh;
            padding: 3rem 1rem;
        }
        .register-card {
            max-width: 680px;
            margin: 0 auto;
            background: #ffffff;
            border-radius: 16px;
            border: 1px solid var(--cpms-slate-200);
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.05);
            padding: 2.5rem;
        }
        .nav-pills .nav-link {
            color: var(--cpms-slate-600);
            font-weight: 600;
            font-size: 0.9rem;
            border-radius: 8px;
            padding: 0.6rem 1.25rem;
        }
        .nav-pills .nav-link.active {
            background-color: var(--cpms-blue-600);
            color: #ffffff;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="text-center mb-4">
        <a href="${pageContext.request.contextPath}/" class="text-decoration-none">
            <h3 class="fw-bold text-navy-900 mb-0">CPMS Portal</h3>
            <p class="text-muted small">Create your account to get started</p>
        </a>
    </div>

    <div class="register-card">

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger py-2.5 px-3 small d-flex align-items-center gap-2 mb-4">
                <i class="bi bi-exclamation-triangle-fill flex-shrink-0 fs-6"></i>
                <div><c:out value="${errorMessage}"/></div>
            </div>
        </c:if>

        <!-- Role Nav Pills -->
        <ul class="nav nav-pills nav-fill bg-light p-1 rounded-3 mb-4" id="roleTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link ${empty selectedRole or selectedRole == 'STUDENT' ? 'active' : ''}" id="student-tab" data-bs-toggle="pill" data-bs-target="#student-content" type="button" role="tab">
                    <i class="bi bi-mortarboard me-1"></i> Student
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link ${selectedRole == 'RECRUITER' ? 'active' : ''}" id="recruiter-tab" data-bs-toggle="pill" data-bs-target="#recruiter-content" type="button" role="tab">
                    <i class="bi bi-briefcase me-1"></i> Recruiter
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link ${selectedRole == 'OFFICER' ? 'active' : ''}" id="officer-tab" data-bs-toggle="pill" data-bs-target="#officer-content" type="button" role="tab">
                    <i class="bi bi-shield-lock me-1"></i> Placement Officer
                </button>
            </li>
        </ul>

        <div class="tab-content" id="roleTabContent">
            
            <!-- STUDENT REGISTRATION FORM -->
            <div class="tab-pane fade ${empty selectedRole or selectedRole == 'STUDENT' ? 'show active' : ''}" id="student-content" role="tabpanel">
                <form action="${pageContext.request.contextPath}/register" method="post">
                    <input type="hidden" name="role" value="STUDENT">

                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-muted">Full Name *</label>
                            <input type="text" name="fullName" class="form-control" placeholder="e.g. Arun Kumar" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-muted">Register Number *</label>
                            <input type="text" name="registerNumber" class="form-control" placeholder="e.g. CPMS2026002" required>
                            <div class="form-text" style="font-size: 0.75rem;">Must match your academic college record.</div>
                        </div>

                        <div class="col-12">
                            <label class="form-label small fw-semibold text-muted">College Email Address *</label>
                            <input type="email" name="email" class="form-control" placeholder="student@college.edu" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-muted">Department *</label>
                            <select name="departmentId" class="form-select" required>
                                <option value="">Select Department</option>
                                <c:forEach var="dept" items="${departments}">
                                    <option value="${dept.departmentId}">${dept.departmentName} (${dept.departmentCode})</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-muted">Graduation Batch Year *</label>
                            <select name="batchYear" class="form-select" required>
                                <option value="2026" selected>2026</option>
                                <option value="2027">2027</option>
                                <option value="2025">2025</option>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-muted">Password *</label>
                            <input type="password" name="password" class="form-control" placeholder="Min 6 characters" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-muted">Confirm Password *</label>
                            <input type="password" name="confirmPassword" class="form-control" placeholder="Repeat password" required>
                        </div>
                    </div>

                    <div class="mt-4">
                        <button type="submit" class="btn btn-primary-cpms w-100 py-2.5 fw-semibold">
                            Complete Student Registration <i class="bi bi-arrow-right ms-1"></i>
                        </button>
                    </div>
                </form>
            </div>

            <!-- RECRUITER REGISTRATION FORM -->
            <div class="tab-pane fade ${selectedRole == 'RECRUITER' ? 'show active' : ''}" id="recruiter-content" role="tabpanel">
                <form action="${pageContext.request.contextPath}/register" method="post">
                    <input type="hidden" name="role" value="RECRUITER">

                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-muted">Full Name *</label>
                            <input type="text" name="fullName" class="form-control" placeholder="e.g. Elena Vance" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-muted">Designation *</label>
                            <input type="text" name="designation" class="form-control" placeholder="e.g. Lead Talent Acquisition" required>
                        </div>

                        <div class="col-12">
                            <label class="form-label small fw-semibold text-muted">Official Corporate Email *</label>
                            <input type="email" name="email" class="form-control" placeholder="recruiter@company.com" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-muted">Select Partner Company</label>
                            <select name="companyId" class="form-select">
                                <option value="">Select Existing Company</option>
                                <c:forEach var="comp" items="${companies}">
                                    <option value="${comp.companyId}">${comp.companyName}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-muted">Or Enter New Company Name</label>
                            <input type="text" name="newCompanyName" class="form-control" placeholder="e.g. Acme Corp">
                        </div>

                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-muted">Password *</label>
                            <input type="password" name="password" class="form-control" placeholder="Min 6 characters" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-muted">Confirm Password *</label>
                            <input type="password" name="confirmPassword" class="form-control" placeholder="Repeat password" required>
                        </div>
                    </div>

                    <div class="mt-4">
                        <button type="submit" class="btn btn-primary-cpms w-100 py-2.5 fw-semibold">
                            Complete Recruiter Registration <i class="bi bi-arrow-right ms-1"></i>
                        </button>
                    </div>
                </form>
            </div>

            <!-- OFFICER REGISTRATION FORM (REQUIRES INVITE CODE) -->
            <div class="tab-pane fade ${selectedRole == 'OFFICER' ? 'show active' : ''}" id="officer-content" role="tabpanel">
                <form action="${pageContext.request.contextPath}/register" method="post">
                    <input type="hidden" name="role" value="OFFICER">

                    <div class="alert alert-warning py-2 px-3 small d-flex align-items-center gap-2 mb-3">
                        <i class="bi bi-shield-exclamation flex-shrink-0"></i>
                        <div>Officer registration requires an authorized administrator Invitation Code.</div>
                    </div>

                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-muted">Full Name *</label>
                            <input type="text" name="fullName" class="form-control" placeholder="e.g. Dr. Sarah Jenkins" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-muted">Employee Code *</label>
                            <input type="text" name="employeeCode" class="form-control" placeholder="e.g. PO002" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-muted">Official Email *</label>
                            <input type="email" name="email" class="form-control" placeholder="officer@college.edu" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-muted">Designation</label>
                            <input type="text" name="designation" class="form-control" placeholder="e.g. Placement Officer">
                        </div>

                        <div class="col-12">
                            <label class="form-label small fw-semibold text-danger">Administrator Invite Code *</label>
                            <input type="password" name="inviteCode" class="form-control border-warning" placeholder="Enter Invite Code (Default: OFFICER2026)" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-muted">Password *</label>
                            <input type="password" name="password" class="form-control" placeholder="Min 6 characters" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-muted">Confirm Password *</label>
                            <input type="password" name="confirmPassword" class="form-control" placeholder="Repeat password" required>
                        </div>
                    </div>

                    <div class="mt-4">
                        <button type="submit" class="btn btn-primary-cpms w-100 py-2.5 fw-semibold">
                            Complete Officer Registration <i class="bi bi-arrow-right ms-1"></i>
                        </button>
                    </div>
                </form>
            </div>

        </div>

        <div class="text-center mt-4 pt-3 border-top">
            <span class="small text-muted">Already have an account?</span>
            <a href="${pageContext.request.contextPath}/login.jsp" class="small fw-semibold text-primary text-decoration-none ms-1">Sign in here</a>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

