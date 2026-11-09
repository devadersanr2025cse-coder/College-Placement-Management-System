<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Access Notice | CPMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/cpms-theme.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8fafc;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1.5rem;
        }
        .notice-card {
            background: #ffffff;
            border-radius: 16px;
            border: 1px solid var(--cpms-slate-200);
            max-width: 520px;
            width: 100%;
            padding: 2.5rem;
            text-align: center;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.05);
        }
        .icon-circle {
            width: 64px;
            height: 64px;
            border-radius: 50%;
            background-color: #fef3c7;
            color: #d97706;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            margin-bottom: 1.25rem;
        }
    </style>
</head>
<body>

<div class="notice-card">
    <div class="icon-circle">
        <i class="bi bi-shield-lock-fill"></i>
    </div>
    <h4 class="fw-bold text-navy-900 mb-2">Role Switch Required</h4>
    <p class="text-muted mb-4">
        You are currently signed in as <strong><c:out value="${sessionScope.role != null ? sessionScope.role : param.current}"/></strong> (<c:out value="${sessionScope.email}"/>).
        This portal section requires <strong><c:out value="${param.required}"/></strong> privileges.
    </p>

    <div class="d-grid gap-2">
        <c:choose>
            <c:when test="${sessionScope.role == 'STUDENT'}">
                <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-primary-cpms py-2.5 fw-semibold">
                    <i class="bi bi-grid-1x2-fill me-1"></i> Return to Student Dashboard
                </a>
            </c:when>
            <c:when test="${sessionScope.role == 'OFFICER'}">
                <a href="${pageContext.request.contextPath}/officer/dashboard" class="btn btn-primary-cpms py-2.5 fw-semibold">
                    <i class="bi bi-grid-1x2-fill me-1"></i> Return to Officer Dashboard
                </a>
            </c:when>
            <c:when test="${sessionScope.role == 'RECRUITER'}">
                <a href="${pageContext.request.contextPath}/recruiter/dashboard" class="btn btn-primary-cpms py-2.5 fw-semibold">
                    <i class="bi bi-grid-1x2-fill me-1"></i> Return to Recruiter Dashboard
                </a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary-cpms py-2.5 fw-semibold">
                    <i class="bi bi-box-arrow-in-right me-1"></i> Go to Sign In
                </a>
            </c:otherwise>
        </c:choose>

        <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger py-2.5 fw-semibold">
            <i class="bi bi-box-arrow-right me-1"></i> Sign Out & Switch Account
        </a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

