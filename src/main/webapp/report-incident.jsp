```jsp
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String userName = (String) session.getAttribute("userName");

    if (userName == null) {
        userName = "User";
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>CyberShield | Report Incident</title>

    <style>

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, Helvetica, sans-serif;
            background: #f4f7fb;
            color: #172033;
        }

        /* ================= NAVBAR ================= */

        .navbar {
            height: 72px;
            background: #0b1f3a;
            color: white;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 32px;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1000;
            box-shadow: 0 3px 15px rgba(0,0,0,0.12);
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .shield-icon {
            width: 40px;
            height: 40px;
            background: #2563eb;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
        }

        .shield-icon::before {
            content: "";
            width: 17px;
            height: 21px;
            border: 2px solid white;
            border-radius: 4px 4px 9px 9px;
            transform: rotate(45deg);
        }

        .brand h2 {
            font-size: 21px;
        }

        .brand span {
            display: block;
            color: #93c5fd;
            font-size: 12px;
            margin-top: 2px;
        }

        .user-section {
            display: flex;
            align-items: center;
            gap: 11px;
        }

        .user-avatar {
            width: 38px;
            height: 38px;
            border-radius: 50%;
            background: #2563eb;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }

        .user-name {
            font-size: 14px;
            font-weight: 600;
        }

        /* ================= SIDEBAR ================= */

        .sidebar {
            position: fixed;
            top: 72px;
            left: 0;
            bottom: 0;
            width: 245px;
            background: #102a4c;
            padding: 28px 16px;
        }

        .menu-title {
            color: #8fa9c7;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 1.2px;
            margin: 0 12px 14px;
        }

        .menu {
            list-style: none;
        }

        .menu li {
            margin-bottom: 7px;
        }

        .menu a {
            display: flex;
            align-items: center;
            gap: 13px;
            padding: 13px 14px;
            color: #d9e7f7;
            text-decoration: none;
            border-radius: 9px;
            font-size: 14px;
            font-weight: 600;
            transition: 0.2s;
        }

        .menu a:hover {
            background: #193b65;
            color: white;
        }

        .menu a.active {
            background: #2563eb;
            color: white;
        }

        .menu-icon {
            width: 20px;
            text-align: center;
            font-size: 17px;
        }

        .sidebar-bottom {
            position: absolute;
            bottom: 25px;
            left: 16px;
            right: 16px;
        }

        .logout {
            display: block;
            text-align: center;
            padding: 11px;
            border: 1px solid #365579;
            border-radius: 8px;
            color: #d9e7f7;
            text-decoration: none;
            font-size: 13px;
            font-weight: 600;
        }

        .logout:hover {
            background: #193b65;
        }

        /* ================= MAIN ================= */

        .main {
            margin-left: 245px;
            padding: 112px 42px 45px;
            min-height: 100vh;
        }

        .page-header {
            margin-bottom: 28px;
        }

        .page-header h1 {
            font-size: 30px;
            margin-bottom: 7px;
        }

        .page-header p {
            color: #68758a;
            font-size: 14px;
        }

        /* ================= FORM CARD ================= */

        .form-card {
            max-width: 950px;
            background: white;
            border: 1px solid #e5eaf1;
            border-radius: 14px;
            box-shadow: 0 6px 22px rgba(15,23,42,0.06);
            overflow: hidden;
        }

        .form-header {
            padding: 25px 28px;
            border-bottom: 1px solid #edf0f5;
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .form-icon {
            width: 48px;
            height: 48px;
            border-radius: 11px;
            background: #e8f0ff;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
        }

        .form-icon::before {
            content: "";
            width: 20px;
            height: 25px;
            border: 2px solid #2563eb;
            border-radius: 5px 5px 10px 10px;
            transform: rotate(45deg);
        }

        .form-header h2 {
            font-size: 19px;
            margin-bottom: 5px;
        }

        .form-header p {
            color: #78859a;
            font-size: 13px;
        }

        .form-body {
            padding: 30px;
        }

        /* ================= FORM ================= */

        .form-group {
            margin-bottom: 22px;
        }

        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 700;
            color: #263247;
            margin-bottom: 8px;
        }

        .required {
            color: #dc2626;
        }

        input,
        textarea,
        select {
            width: 100%;
            padding: 13px 14px;
            border: 1px solid #d6dde8;
            border-radius: 8px;
            background: #fff;
            color: #172033;
            font-family: Arial, Helvetica, sans-serif;
            font-size: 14px;
            outline: none;
            transition: 0.2s;
        }

        input:focus,
        textarea:focus,
        select:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37,99,235,0.10);
        }

        textarea {
            min-height: 145px;
            resize: vertical;
        }

        .field-help {
            color: #8a95a6;
            font-size: 11px;
            margin-top: 6px;
        }

        /* ================= TWO COLUMNS ================= */

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        /* ================= SEVERITY INFO ================= */

        .severity-info {
            margin-top: 8px;
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 10px;
        }

        .severity-box {
            padding: 12px;
            border-radius: 8px;
            border: 1px solid #e5eaf1;
        }

        .severity-box strong {
            display: block;
            font-size: 12px;
            margin-bottom: 4px;
        }

        .severity-box span {
            font-size: 10px;
            color: #7b8798;
        }

        .low {
            background: #f0fdf4;
            border-color: #bbf7d0;
        }

        .low strong {
            color: #15803d;
        }

        .medium {
            background: #fffbeb;
            border-color: #fde68a;
        }

        .medium strong {
            color: #a16207;
        }

        .high {
            background: #fff7ed;
            border-color: #fed7aa;
        }

        .high strong {
            color: #c2410c;
        }

        .critical {
            background: #fef2f2;
            border-color: #fecaca;
        }

        .critical strong {
            color: #b91c1c;
        }

        /* ================= BUTTONS ================= */

        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 30px;
            padding-top: 22px;
            border-top: 1px solid #edf0f5;
        }

        .btn {
            padding: 12px 21px;
            border-radius: 8px;
            text-decoration: none;
            font-size: 13px;
            font-weight: 700;
            cursor: pointer;
            border: none;
        }

        .btn-cancel {
            background: #f1f4f8;
            color: #536176;
        }

        .btn-cancel:hover {
            background: #e5eaf0;
        }

        .btn-submit {
            background: #2563eb;
            color: white;
            box-shadow: 0 5px 12px rgba(37,99,235,0.18);
        }

        .btn-submit:hover {
            background: #1d4ed8;
            transform: translateY(-1px);
        }

        /* ================= SECURITY NOTICE ================= */

        .security-notice {
            max-width: 950px;
            margin-top: 20px;
            padding: 16px 19px;
            background: #f0fdf4;
            border: 1px solid #bbf7d0;
            border-radius: 10px;
            color: #166534;
            font-size: 12px;
        }

        .security-notice strong {
            display: block;
            margin-bottom: 4px;
        }

        /* ================= RESPONSIVE ================= */

        @media (max-width: 900px) {

            .severity-info {
                grid-template-columns: repeat(2, 1fr);
            }

            .form-row {
                grid-template-columns: 1fr;
            }

        }

        @media (max-width: 750px) {

            .sidebar {
                width: 70px;
                padding: 20px 10px;
            }

            .sidebar .menu-title,
            .menu a span:not(.menu-icon),
            .logout {
                display: none;
            }

            .menu a {
                justify-content: center;
                padding: 14px 5px;
            }

            .main {
                margin-left: 70px;
                padding: 100px 20px 35px;
            }

            .user-name {
                display: none;
            }

        }

        @media (max-width: 500px) {

            .main {
                padding-left: 14px;
                padding-right: 14px;
            }

            .form-body {
                padding: 20px;
            }

            .severity-info {
                grid-template-columns: 1fr;
            }

        }

    </style>

</head>

<body>


    <!-- ================= NAVBAR ================= -->

    <div class="navbar">

        <div class="brand">

            <div class="shield-icon"></div>

            <div>
                <h2>CyberShield</h2>
                <span>Security Management System</span>
            </div>

        </div>

        <div class="user-section">

            <div class="user-avatar">
                <%= userName.substring(0, 1).toUpperCase() %>
            </div>

            <div class="user-name">
                <%= userName %>
            </div>

        </div>

    </div>


    <!-- ================= SIDEBAR ================= -->

    <aside class="sidebar">

        <div class="menu-title">
            Security
        </div>

        <ul class="menu">

            <li>
                <a href="dashboard.jsp">
                    <span class="menu-icon">▣</span>
                    <span>Dashboard</span>
                </a>
            </li>

            <li>
                <a href="report-incident.jsp" class="active">
                    <span class="menu-icon">+</span>
                    <span>Report Incident</span>
                </a>
            </li>

            <li>
                <a href="dashboard.jsp">
                    <span class="menu-icon">◫</span>
                    <span>My Incidents</span>
                </a>
            </li>

            <li>
                <a href="dashboard.jsp">
                    <span class="menu-icon">◉</span>
                    <span>Security Alerts</span>
                </a>
            </li>

            <li>
                <a href="dashboard.jsp">
                    <span class="menu-icon">◎</span>
                    <span>Profile</span>
                </a>
            </li>

        </ul>

        <div class="sidebar-bottom">

            <a href="logout" class="logout">
                Logout
            </a>

        </div>

    </aside>


    <!-- ================= MAIN ================= -->

    <main class="main">

        <div class="page-header">

            <h1>Report Security Incident</h1>

            <p>
                Submit a detailed report to help identify and manage security threats.
            </p>

        </div>


        <!-- ================= FORM CARD ================= -->

        <div class="form-card">

            <div class="form-header">

                <div class="form-icon"></div>

                <div>

                    <h2>Incident Details</h2>

                    <p>
                        Provide accurate information about the security incident.
                    </p>

                </div>

            </div>


            <div class="form-body">

                <form action="reportIncident" method="post">


                    <!-- INCIDENT TITLE -->

                    <div class="form-group">

                        <label for="title">
                            Incident Title
                            <span class="required">*</span>
                        </label>

                        <input
                            type="text"
                            id="title"
                            name="title"
                            placeholder="Example: Suspicious Login Attempt"
                            required>

                    </div>


                    <!-- DESCRIPTION -->

                    <div class="form-group">

                        <label for="description">
                            Incident Description
                            <span class="required">*</span>
                        </label>

                        <textarea
                            id="description"
                            name="description"
                            placeholder="Describe what happened, when it happened, and any suspicious activity you observed."
                            required></textarea>

                        <div class="field-help">
                            Include relevant details that can help with investigation.
                        </div>

                    </div>


                    <!-- SEVERITY + DATE -->

                    <div class="form-row">

                        <div class="form-group">

                            <label for="severity">
                                Severity Level
                                <span class="required">*</span>
                            </label>

                            <select
                                id="severity"
                                name="severity"
                                required>

                                <option value="">
                                    Select severity level
                                </option>

                                <option value="Low">
                                    Low
                                </option>

                                <option value="Medium">
                                    Medium
                                </option>

                                <option value="High">
                                    High
                                </option>

                                <option value="Critical">
                                    Critical
                                </option>

                            </select>

                        </div>


                        <div class="form-group">

                            <label for="incident_date">
                                Incident Date
                                <span class="required">*</span>
                            </label>

                            <input
                                type="date"
                                id="incident_date"
                                name="incident_date"
                                required>

                        </div>

                    </div>


                    <!-- SEVERITY INFORMATION -->

                    <div class="form-group">

                        <label>
                            Severity Guidelines
                        </label>

                        <div class="severity-info">

                            <div class="severity-box low">
                                <strong>Low</strong>
                                <span>Minor security event</span>
                            </div>

                            <div class="severity-box medium">
                                <strong>Medium</strong>
                                <span>Requires investigation</span>
                            </div>

                            <div class="severity-box high">
                                <strong>High</strong>
                                <span>Significant security risk</span>
                            </div>

                            <div class="severity-box critical">
                                <strong>Critical</strong>
                                <span>Immediate attention required</span>
                            </div>

                        </div>

                    </div>


                    <!-- ACTIONS -->

                    <div class="form-actions">

                        <a
                            href="dashboard.jsp"
                            class="btn btn-cancel">
                            Cancel
                        </a>

                        <button
                            type="submit"
                            class="btn btn-submit">
                            Report Incident
                        </button>

                    </div>

                </form>

            </div>

        </div>


        <!-- ================= SECURITY NOTICE ================= -->

        <div class="security-notice">

            <strong>Security Monitoring Active</strong>

            Your incident will be securely recorded and evaluated
            according to its selected severity level.

        </div>

    </main>

</body>

</html>
```
