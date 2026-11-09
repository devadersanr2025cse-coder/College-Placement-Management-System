<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    // Auto-redirect authenticated users directly to their respective dashboard
    if (session != null && session.getAttribute("role") != null) {
        String userRole = (String) session.getAttribute("role");
        if ("STUDENT".equalsIgnoreCase(userRole)) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard");
            return;
        } else if ("OFFICER".equalsIgnoreCase(userRole)) {
            response.sendRedirect(request.getContextPath() + "/officer/dashboard");
            return;
        } else if ("RECRUITER".equalsIgnoreCase(userRole)) {
            response.sendRedirect(request.getContextPath() + "/recruiter/dashboard");
            return;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>College Placement Management System (CPMS)</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <!-- CPMS Theme -->
    <link href="${pageContext.request.contextPath}/assets/css/cpms-theme.css" rel="stylesheet">
    <style>
        .hero-section {
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
            color: #ffffff;
            padding: 4rem 0 5rem;
            position: relative;
            overflow: hidden;
        }
        .hero-section::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: radial-gradient(circle at 80% 20%, rgba(37, 99, 235, 0.15), transparent 40%);
            pointer-events: none;
        }
        .role-card {
            background: #ffffff;
            border: 1px solid var(--cpms-slate-200);
            border-radius: 16px;
            padding: 2rem 1.75rem;
            transition: all 0.3s ease;
            height: 100%;
            display: flex;
            flex-direction: column;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
        }
        .role-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.08);
            border-color: var(--cpms-blue-400);
        }
        .role-icon {
            width: 52px;
            height: 52px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.6rem;
            margin-bottom: 1.25rem;
        }
        .login-box {
            background: #ffffff;
            color: var(--cpms-slate-900);
            border-radius: 16px;
            padding: 2rem;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.3), 0 10px 10px -5px rgba(0, 0, 0, 0.2);
        }
        .demo-chip {
            cursor: pointer;
            font-size: 0.75rem;
            padding: 0.35rem 0.65rem;
            border-radius: 6px;
            border: 1px solid var(--cpms-slate-200);
            background: var(--cpms-slate-50);
            transition: all 0.2s;
            font-weight: 500;
        }
        .demo-chip:hover {
            background: #e2e8f0;
            border-color: #cbd5e1;
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark" style="background-color: var(--cpms-navy-900); border-bottom: 1px solid rgba(255,255,255,0.08);">
    <div class="container py-2">
        <a class="navbar-brand fw-bold d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/">
            <i class="bi bi-mortarboard-fill text-primary fs-3"></i>
            <span>CPMS<span class="text-primary">.Portal</span></span>
        </a>
        <div class="d-flex align-items-center gap-3">
            <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-light btn-sm px-3 fw-semibold">
                <i class="bi bi-box-arrow-in-right me-1"></i> Sign In
            </a>
            <a href="${pageContext.request.contextPath}/register" class="btn btn-primary-cpms btn-sm px-3 fw-semibold">
                <i class="bi bi-person-plus me-1"></i> Register
            </a>
        </div>
    </div>
</nav>

<!-- Hero Section with Unified Sign-In Box -->
<section class="hero-section">
    <div class="container">
        <div class="row align-items-center g-5">
            <div class="col-lg-7">
                <div class="d-inline-flex align-items-center gap-2 px-3 py-1.5 rounded-pill mb-4" style="background-color: rgba(37, 99, 235, 0.15); border: 1px solid rgba(37, 99, 235, 0.3);">
                    <i class="bi bi-shield-check text-primary"></i>
                    <span class="small text-light fw-medium">Unified Campus Career & Placement Portal</span>
                </div>
                <h1 class="display-5 fw-bold mb-3 tracking-tight">Streamlining Campus Recruitment with Real-Time Intelligence</h1>
                <p class="lead text-slate-300 mb-4" style="color: #94a3b8; font-size: 1.15rem;">
                    Sign in with your email and password. Our portal automatically recognizes your role and directs you straight to your dedicated dashboard.
                </p>
                <div class="d-flex flex-wrap gap-3">
                    <div class="d-flex align-items-center gap-2 text-slate-300 small text-light">
                        <i class="bi bi-check-circle-fill text-success"></i> Student Eligibility Verification
                    </div>
                    <div class="d-flex align-items-center gap-2 text-slate-300 small text-light">
                        <i class="bi bi-check-circle-fill text-success"></i> Placement Officer Governance
                    </div>
                    <div class="d-flex align-items-center gap-2 text-slate-300 small text-light">
                        <i class="bi bi-check-circle-fill text-success"></i> Recruiter Pipeline
                    </div>
                </div>
            </div>

            <!-- Single Integrated Sign-In Card -->
            <div class="col-lg-5">
                <div class="login-box">
                    <h5 class="fw-bold mb-1 text-navy-900">Direct Portal Sign In</h5>
                    <p class="text-muted small mb-3">Enter your credentials to route to your dashboard:</p>

                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger py-2 px-3 small d-flex align-items-center gap-2 mb-3">
                            <i class="bi bi-exclamation-triangle-fill flex-shrink-0"></i>
                            <div><c:out value="${errorMessage}"/></div>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/login" method="post">
                        <div class="mb-3">
                            <label class="form-label small fw-semibold text-muted">Email Address</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-envelope"></i></span>
                                <input type="email" id="homeEmail" name="email" class="form-control border-start-0" placeholder="name@college.edu" required>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-semibold text-muted">Password</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-lock"></i></span>
                                <input type="password" id="homePassword" name="password" class="form-control border-start-0" placeholder="••••••••" required>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary-cpms w-100 py-2.5 fw-semibold mb-3">
                            Sign In Directly <i class="bi bi-arrow-right ms-1"></i>
                        </button>
                    </form>

                    <!-- 1-Click Demo Fill for All 3 Roles -->
                    <div class="border-top pt-2">
                        <div class="small text-muted fw-semibold mb-2"><i class="bi bi-lightning-charge-fill text-warning me-1"></i>1-Click Test Login:</div>
                        <div class="d-flex flex-wrap gap-2">
                            <span class="demo-chip" onclick="fillHome('student@cpms.test', 'Student@123')">
                                <i class="bi bi-person text-primary me-1"></i> Student
                            </span>
                            <span class="demo-chip" onclick="fillHome('officer@cpms.test', 'Officer@123')">
                                <i class="bi bi-shield-check text-warning me-1"></i> Officer
                            </span>
                            <span class="demo-chip" onclick="fillHome('recruiter@example.com', 'Recruiter@123')">
                                <i class="bi bi-building text-success me-1"></i> Recruiter
                            </span>
                        </div>
                    </div>

                    <div class="text-center mt-3 pt-2 border-top">
                        <span class="small text-muted">New student or recruiter?</span>
                        <a href="${pageContext.request.contextPath}/register" class="small fw-semibold text-primary text-decoration-none ms-1">Create Account</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Role Description Cards -->
<section class="py-5" style="background-color: #f8fafc;">
    <div class="container">
        <div class="text-center mb-5">
            <h3 class="fw-bold text-navy-900">Three Distinct Portals, One Integrated Platform</h3>
            <p class="text-muted">Role-based security ensures each user accesses their designated workspace seamlessly.</p>
        </div>

        <div class="row g-4">
            
            <!-- Student Card -->
            <div class="col-lg-4 col-md-6">
                <div class="role-card">
                    <div class="role-icon" style="background-color: #eff6ff; color: #1d4ed8;">
                        <i class="bi bi-mortarboard"></i>
                    </div>
                    <h4 class="fw-bold text-navy-900 mb-2">Student Portal</h4>
                    <p class="text-muted flex-grow-1">
                        View verified CGPA and backlogs, submit update requests with proof, browse eligible company drives, track applications, upload PDF resumes, and view interview calls.
                    </p>
                    <div class="mt-4 pt-3 border-top">
                        <button onclick="fillHome('student@cpms.test', 'Student@123'); window.scrollTo({top: 0, behavior: 'smooth'});" class="btn btn-outline-cpms w-100 fw-semibold">
                            Fill Student Login <i class="bi bi-arrow-up-right ms-1"></i>
                        </button>
                    </div>
                </div>
            </div>

            <!-- Officer Card -->
            <div class="col-lg-4 col-md-6">
                <div class="role-card">
                    <div class="role-icon" style="background-color: #fef9c3; color: #a16207;">
                        <i class="bi bi-building-gear"></i>
                    </div>
                    <h4 class="fw-bold text-navy-900 mb-2">Placement Officer</h4>
                    <p class="text-muted flex-grow-1">
                        Approve or reject student CGPA/backlog verification requests with audit remarks, manage partner companies, schedule interview rounds, review resumes, and export PDF & Excel reports.
                    </p>
                    <div class="mt-4 pt-3 border-top">
                        <button onclick="fillHome('officer@cpms.test', 'Officer@123'); window.scrollTo({top: 0, behavior: 'smooth'});" class="btn btn-outline-cpms w-100 fw-semibold">
                            Fill Officer Login <i class="bi bi-arrow-up-right ms-1"></i>
                        </button>
                    </div>
                </div>
            </div>

            <!-- Recruiter Card -->
            <div class="col-lg-4 col-md-6">
                <div class="role-card">
                    <div class="role-icon" style="background-color: #ecfdf5; color: #047857;">
                        <i class="bi bi-briefcase"></i>
                    </div>
                    <h4 class="fw-bold text-navy-900 mb-2">Company Recruiter</h4>
                    <p class="text-muted flex-grow-1">
                        Manage company job postings, review applicant pools with strictly verified academic metrics, download authorized candidate resumes, and coordinate interview rounds.
                    </p>
                    <div class="mt-4 pt-3 border-top">
                        <button onclick="fillHome('recruiter@example.com', 'Recruiter@123'); window.scrollTo({top: 0, behavior: 'smooth'});" class="btn btn-outline-cpms w-100 fw-semibold">
                            Fill Recruiter Login <i class="bi bi-arrow-up-right ms-1"></i>
                        </button>
                    </div>
                </div>
            </div>

        </div>
    </div>
</section>

<!-- Footer -->
<footer class="py-4 text-center border-top bg-white text-muted small">
    <div class="container">
        <p class="mb-0">&copy; 2026 College Placement Management System (CPMS). All rights reserved.</p>
    </div>
</footer>

<script>
function fillHome(email, pass) {
    document.getElementById('homeEmail').value = email;
    document.getElementById('homePassword').value = pass;
}
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
