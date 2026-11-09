<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CPMS | Sign In</title>
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
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 1rem;
        }
        .auth-container {
            width: 100%;
            max-width: 460px;
        }
        .auth-card {
            background: #ffffff;
            border-radius: 16px;
            border: 1px solid var(--cpms-slate-200);
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.05), 0 8px 10px -6px rgba(0, 0, 0, 0.01);
            padding: 2.5rem;
        }
        .brand-logo {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            background: var(--cpms-navy-900);
            color: #ffffff;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            margin-bottom: 1rem;
        }
        .demo-chip {
            cursor: pointer;
            font-size: 0.75rem;
            padding: 0.35rem 0.65rem;
            border-radius: 6px;
            border: 1px solid var(--cpms-slate-200);
            background: var(--cpms-slate-50);
            transition: all 0.2s;
        }
        .demo-chip:hover {
            background: #e2e8f0;
            border-color: #cbd5e1;
        }
    </style>
</head>
<body>

<div class="auth-container">
    <div class="text-center mb-3">
        <a href="${pageContext.request.contextPath}/" class="text-decoration-none">
            <div class="brand-logo shadow-sm">
                <i class="bi bi-mortarboard-fill text-primary"></i>
            </div>
            <h4 class="fw-bold text-navy-900 mb-0">CPMS Portal</h4>
            <p class="text-muted small">College Placement Management System</p>
        </a>
    </div>

    <div class="auth-card">
        <h5 class="fw-bold mb-1">Sign in to your account</h5>
        <p class="text-muted small mb-4">Enter your credentials to access your dashboard.</p>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger py-2 px-3 small d-flex align-items-center gap-2 mb-3">
                <i class="bi bi-exclamation-triangle-fill flex-shrink-0"></i>
                <div><c:out value="${errorMessage}"/></div>
            </div>
        </c:if>

        <c:if test="${param.registered == 'true'}">
            <div class="alert alert-success py-2 px-3 small d-flex align-items-center gap-2 mb-3">
                <i class="bi bi-check-circle-fill flex-shrink-0"></i>
                <div>Account created successfully! Please sign in.</div>
            </div>
        </c:if>

        <c:if test="${param.logout == 'true'}">
            <div class="alert alert-info py-2 px-3 small d-flex align-items-center gap-2 mb-3">
                <i class="bi bi-info-circle-fill flex-shrink-0"></i>
                <div>You have been logged out securely.</div>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="mb-3">
                <label class="form-label small fw-semibold text-muted">Email Address</label>
                <div class="input-group">
                    <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-envelope"></i></span>
                    <input type="email" id="emailInput" name="email" class="form-control border-start-0" placeholder="name@college.edu" required autofocus>
                </div>
            </div>

            <div class="mb-4">
                <label class="form-label small fw-semibold text-muted">Password</label>
                <div class="input-group">
                    <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-lock"></i></span>
                    <input type="password" id="passwordInput" name="password" class="form-control border-start-0" placeholder="••••••••" required>
                </div>
            </div>

            <button type="submit" class="btn btn-primary-cpms w-100 py-2.5 fw-semibold mb-3">
                Sign In <i class="bi bi-arrow-right ms-1"></i>
            </button>
        </form>

        <!-- Quick Demo Accounts Helper -->
        <div class="border-top pt-3 mt-2">
            <div class="d-flex align-items-center justify-content-between mb-2">
                <span class="small text-muted fw-semibold"><i class="bi bi-lightning-charge-fill text-warning me-1"></i>Quick Demo Autofill:</span>
            </div>
            <div class="d-flex flex-wrap gap-2">
                <span class="demo-chip" onclick="fillDemo('student@cpms.test', 'Student@123')">
                    <i class="bi bi-person text-primary me-1"></i> Student
                </span>
                <span class="demo-chip" onclick="fillDemo('officer@cpms.test', 'Officer@123')">
                    <i class="bi bi-shield-check text-warning me-1"></i> Officer
                </span>
                <span class="demo-chip" onclick="fillDemo('recruiter@example.com', 'Recruiter@123')">
                    <i class="bi bi-building text-success me-1"></i> Recruiter
                </span>
            </div>
        </div>

        <div class="text-center mt-4 pt-2 border-top">
            <span class="small text-muted">Don't have an account?</span>
            <a href="${pageContext.request.contextPath}/register" class="small fw-semibold text-primary text-decoration-none ms-1">Register now</a>
        </div>
    </div>
</div>

<script>
function fillDemo(email, pass) {
    document.getElementById('emailInput').value = email;
    document.getElementById('passwordInput').value = pass;
}
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
