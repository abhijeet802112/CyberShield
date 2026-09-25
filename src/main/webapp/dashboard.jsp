```jsp
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.cybershield.DBConnection" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String userName = (String) session.getAttribute("userName");
    Integer userIdObj = (Integer) session.getAttribute("userId");

    if (userName == null) {
        userName = "User";
    }

    if (userIdObj == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int userId = userIdObj;

    int totalIncidents = 0;
    int criticalIncidents = 0;
    int highIncidents = 0;
    int resolvedIncidents = 0;

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        con = DBConnection.getConnection();

        ps = con.prepareStatement(
            "SELECT COUNT(*) FROM incidents WHERE user_id = ?"
        );
        ps.setInt(1, userId);
        rs = ps.executeQuery();

        if (rs.next()) {
            totalIncidents = rs.getInt(1);
        }

        rs.close();
        ps.close();

        ps = con.prepareStatement(
            "SELECT COUNT(*) FROM incidents WHERE user_id = ? AND severity = 'Critical'"
        );
        ps.setInt(1, userId);
        rs = ps.executeQuery();

        if (rs.next()) {
            criticalIncidents = rs.getInt(1);
        }

        rs.close();
        ps.close();

        ps = con.prepareStatement(
            "SELECT COUNT(*) FROM incidents WHERE user_id = ? AND severity = 'High'"
        );
        ps.setInt(1, userId);
        rs = ps.executeQuery();

        if (rs.next()) {
            highIncidents = rs.getInt(1);
        }

        rs.close();
        ps.close();

        ps = con.prepareStatement(
            "SELECT COUNT(*) FROM incidents WHERE user_id = ? AND status = 'Resolved'"
        );
        ps.setInt(1, userId);
        rs = ps.executeQuery();

        if (rs.next()) {
            resolvedIncidents = rs.getInt(1);
        }

        rs.close();
        ps.close();

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
        } catch (Exception e) {
        }

        try {
            if (ps != null) ps.close();
        } catch (Exception e) {
        }

        try {
            if (con != null) con.close();
        } catch (Exception e) {
        }
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>CyberShield | Security Dashboard</title>

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

        .brand-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            background: #2563eb;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
        }

        .brand h2 {
            font-size: 21px;
            letter-spacing: 0.3px;
        }

        .brand span {
            color: #93c5fd;
            font-size: 12px;
            display: block;
            margin-top: 2px;
        }

        .user-section {
            display: flex;
            align-items: center;
            gap: 12px;
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
            z-index: 900;
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
            font-size: 16px;
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
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            margin-bottom: 30px;
        }

        .page-header h1 {
            font-size: 30px;
            color: #172033;
            margin-bottom: 7px;
        }

        .page-header p {
            color: #68758a;
            font-size: 14px;
        }

        .report-btn {
            background: #2563eb;
            color: white;
            text-decoration: none;
            padding: 12px 19px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 700;
            box-shadow: 0 5px 12px rgba(37,99,235,0.18);
            transition: 0.2s;
        }

        .report-btn:hover {
            background: #1d4ed8;
            transform: translateY(-1px);
        }

        /* ================= STAT CARDS ================= */

        .cards {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }

        .card {
            background: white;
            border-radius: 13px;
            padding: 22px;
            min-height: 155px;
            border: 1px solid #e5eaf1;
            box-shadow: 0 5px 18px rgba(15,23,42,0.05);
            transition: 0.2s;
        }

        .card:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(15,23,42,0.08);
        }

        .card-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .card-title {
            color: #68758a;
            font-size: 13px;
            font-weight: 700;
        }

        .card-icon {
            width: 42px;
            height: 42px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 19px;
        }

        .blue {
            background: #e8f0ff;
            color: #2563eb;
        }

        .red {
            background: #feecec;
            color: #dc2626;
        }

        .orange {
            background: #fff3df;
            color: #ea8a00;
        }

        .green {
            background: #e6f8ef;
            color: #16a34a;
        }

        .number {
            font-size: 34px;
            font-weight: 800;
            color: #172033;
            margin-top: 20px;
        }

        .card-description {
            font-size: 12px;
            color: #8994a6;
            margin-top: 5px;
        }

        /* ================= CONTENT GRID ================= */

        .content-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 22px;
        }

        .panel {
            background: white;
            border: 1px solid #e5eaf1;
            border-radius: 13px;
            box-shadow: 0 5px 18px rgba(15,23,42,0.05);
            overflow: hidden;
        }

        .panel-header {
            padding: 21px 23px;
            border-bottom: 1px solid #edf0f5;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .panel-header h2 {
            font-size: 17px;
            color: #172033;
        }

        .panel-header span {
            font-size: 12px;
            color: #8994a6;
        }

        /* ================= ALERTS ================= */

        .alert-row {
            padding: 17px 23px;
            border-bottom: 1px solid #edf0f5;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
        }

        .alert-row:last-child {
            border-bottom: none;
        }

        .alert-left {
            display: flex;
            align-items: center;
            gap: 13px;
        }

        .alert-icon {
            width: 38px;
            height: 38px;
            border-radius: 9px;
            background: #fff1f1;
            color: #dc2626;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 17px;
        }

        .alert-message {
            font-size: 13px;
            font-weight: 700;
            color: #263247;
        }

        .alert-time {
            font-size: 11px;
            color: #929dad;
            margin-top: 4px;
        }

        .severity {
            font-size: 10px;
            font-weight: 800;
            padding: 6px 9px;
            border-radius: 20px;
            text-transform: uppercase;
        }

        .severity-high {
            color: #c2410c;
            background: #fff1df;
        }

        .severity-critical {
            color: #b91c1c;
            background: #fee2e2;
        }

        .severity-medium {
            color: #a16207;
            background: #fef9c3;
        }

        .severity-low {
            color: #15803d;
            background: #dcfce7;
        }

        .no-alerts {
            padding: 45px 20px;
            text-align: center;
            color: #8a95a6;
            font-size: 13px;
        }

        /* ================= SECURITY STATUS ================= */

        .status-panel {
            padding: 23px;
        }

        .status-box {
            border: 1px solid #bbf7d0;
            background: #f0fdf4;
            border-radius: 11px;
            padding: 19px;
        }

        .status-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 10px;
        }

        .status-dot {
            width: 12px;
            height: 12px;
            background: #22c55e;
            border-radius: 50%;
            box-shadow: 0 0 0 5px rgba(34,197,94,0.12);
        }

        .status-header h3 {
            font-size: 15px;
            color: #166534;
        }

        .status-box p {
            color: #4b6351;
            font-size: 12px;
            line-height: 1.6;
        }

        .status-details {
            margin-top: 18px;
            border-top: 1px solid #d8f3df;
            padding-top: 15px;
        }

        .status-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 11px;
            font-size: 12px;
        }

        .status-item span:first-child {
            color: #718078;
        }

        .status-item span:last-child {
            color: #166534;
            font-weight: 700;
        }

        /* ================= FOOTER ================= */

        .footer {
            text-align: center;
            color: #9aa4b2;
            font-size: 11px;
            margin-top: 32px;
        }

        /* ================= RESPONSIVE ================= */

        @media (max-width: 1100px) {

            .cards {
                grid-template-columns: repeat(2, 1fr);
            }

            .content-grid {
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

            .navbar {
                padding: 0 18px;
            }

            .brand h2 {
                font-size: 17px;
            }

            .user-name {
                display: none;
            }

            .page-header {
                flex-direction: column;
                gap: 18px;
            }
        }

        @media (max-width: 500px) {

            .cards {
                grid-template-columns: 1fr;
            }

            .main {
                padding-left: 14px;
                padding-right: 14px;
            }

            .page-header h1 {
                font-size: 24px;
            }

            .navbar {
                height: 64px;
            }

            .sidebar {
                top: 64px;
            }

            .main {
                padding-top: 90px;
            }
        }

    </style>

</head>

<body>

    <!-- ================= NAVBAR ================= -->

    <div class="navbar">

        <div class="brand">

            <div class="brand-icon">🛡</div>

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
                <a href="dashboard.jsp" class="active">
                    <span class="menu-icon">▣</span>
                    <span>Dashboard</span>
                </a>
            </li>

            <li>
                <a href="report-incident.jsp">
                    <span class="menu-icon">＋</span>
                    <span>Report Incident</span>
                </a>
            </li>

            <li>
                <a href="my-incidents.jsp">
                    <span class="menu-icon">◫</span>
                    <span>My Incidents</span>
                </a>
            </li>

            <li>
                <a href="security-alerts.jsp">
                    <span class="menu-icon">◉</span>
                    <span>Security Alerts</span>
                </a>
            </li>

            <li>
                <a href="profile.jsp">
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


    <!-- ================= MAIN CONTENT ================= -->

    <main class="main">

        <div class="page-header">

            <div>

                <h1>Security Dashboard</h1>

                <p>
                    Welcome back, <strong><%= userName %></strong>.
                    Monitor and manage your security incidents.
                </p>

            </div>

            <a href="report-incident.jsp" class="report-btn">
                + Report Incident
            </a>

        </div>


        <!-- ================= STATISTICS ================= -->

        <div class="cards">

            <div class="card">

                <div class="card-top">

                    <div class="card-title">
                        TOTAL INCIDENTS
                    </div>

                    <div class="card-icon blue">
                        ▣
                    </div>

                </div>

                <div class="number">
                    <%= totalIncidents %>
                </div>

                <div class="card-description">
                    All reported security incidents
                </div>

            </div>


            <div class="card">

                <div class="card-top">

                    <div class="card-title">
                        CRITICAL ALERTS
                    </div>

                    <div class="card-icon red">
                        !
                    </div>

                </div>

                <div class="number">
                    <%= criticalIncidents %>
                </div>

                <div class="card-description">
                    Critical severity incidents
                </div>

            </div>


            <div class="card">

                <div class="card-top">

                    <div class="card-title">
                        HIGH SEVERITY
                    </div>

                    <div class="card-icon orange">
                        ▲
                    </div>

                </div>

                <div class="number">
                    <%= highIncidents %>
                </div>

                <div class="card-description">
                    High priority incidents
                </div>

            </div>


            <div class="card">

                <div class="card-top">

                    <div class="card-title">
                        RESOLVED
                    </div>

                    <div class="card-icon green">
                        ✓
                    </div>

                </div>

                <div class="number">
                    <%= resolvedIncidents %>
                </div>

                <div class="card-description">
                    Successfully resolved incidents
                </div>

            </div>

        </div>


        <!-- ================= LOWER CONTENT ================= -->

        <div class="content-grid">


            <!-- RECENT ALERTS -->

            <section class="panel">

                <div class="panel-header">

                    <h2>Recent Security Alerts</h2>

                    <span>Latest activity</span>

                </div>

                <%

                    Connection alertCon = null;
                    PreparedStatement alertPs = null;
                    ResultSet alertRs = null;

                    boolean hasAlerts = false;

                    try {

                        alertCon = DBConnection.getConnection();

                        alertPs = alertCon.prepareStatement(
                            "SELECT a.alert_message, a.severity, a.created_at " +
                            "FROM alerts a " +
                            "JOIN incidents i ON a.incident_id = i.id " +
                            "WHERE i.user_id = ? " +
                            "ORDER BY a.created_at DESC LIMIT 5"
                        );

                        alertPs.setInt(1, userId);

                        alertRs = alertPs.executeQuery();

                        while (alertRs.next()) {

                            hasAlerts = true;

                            String alertMessage = alertRs.getString("alert_message");
                            String alertSeverity = alertRs.getString("severity");
                            Timestamp createdAt = alertRs.getTimestamp("created_at");

                            String severityClass = "severity-medium";

                            if ("High".equalsIgnoreCase(alertSeverity)) {
                                severityClass = "severity-high";
                            } else if ("Critical".equalsIgnoreCase(alertSeverity)) {
                                severityClass = "severity-critical";
                            } else if ("Low".equalsIgnoreCase(alertSeverity)) {
                                severityClass = "severity-low";
                            }

                %>

                <div class="alert-row">

                    <div class="alert-left">

                        <div class="alert-icon">
                            !
                        </div>

                        <div>

                            <div class="alert-message">
                                <%= alertMessage %>
                            </div>

                            <div class="alert-time">
                                <%= createdAt %>
                            </div>

                        </div>

                    </div>

                    <div class="severity <%= severityClass %>">
                        <%= alertSeverity %>
                    </div>

                </div>

                <%

                        }

                    } catch (Exception e) {

                        e.printStackTrace();

                %>

                <div class="no-alerts">
                    Unable to load security alerts.
                </div>

                <%

                    } finally {

                        try {
                            if (alertRs != null) alertRs.close();
                        } catch (Exception e) {
                        }

                        try {
                            if (alertPs != null) alertPs.close();
                        } catch (Exception e) {
                        }

                        try {
                            if (alertCon != null) alertCon.close();
                        } catch (Exception e) {
                        }

                    }

                    if (!hasAlerts) {

                %>

                <div class="no-alerts">
                    No security alerts found.
                </div>

                <%

                    }

                %>

            </section>


            <!-- SECURITY STATUS -->

            <section class="panel">

                <div class="panel-header">

                    <h2>System Status</h2>

                    <span>Live</span>

                </div>

                <div class="status-panel">

                    <div class="status-box">

                        <div class="status-header">

                            <div class="status-dot"></div>

                            <h3>
                                Security Monitoring Active
                            </h3>

                        </div>

                        <p>
                            CyberShield is actively monitoring
                            your reported security incidents and
                            generating alerts based on severity.
                        </p>

                        <div class="status-details">

                            <div class="status-item">
                                <span>Monitoring</span>
                                <span>Active</span>
                            </div>

                            <div class="status-item">
                                <span>Alert Engine</span>
                                <span>Operational</span>
                            </div>

                            <div class="status-item">
                                <span>Database</span>
                                <span>Connected</span>
                            </div>

                            <div class="status-item">
                                <span>Session</span>
                                <span>Secure</span>
                            </div>

                        </div>

                    </div>

                </div>

            </section>

        </div>


        <div class="footer">
            CyberShield Security Management System
            &nbsp;•&nbsp;
            Java JSP & MySQL
        </div>

    </main>

</body>

</html>
/* ===== CyberShield UI Polish ===== */

.card {
    position: relative;
    overflow: hidden;
}

.card::before {
    content: "";
    position: absolute;
    top: 0;
    left: 0;
    width: 4px;
    height: 100%;
    background: #2563eb;
}

.cards .card:nth-child(2)::before {
    background: #dc2626;
}

.cards .card:nth-child(3)::before {
    background: #ea8a00;
}

.cards .card:nth-child(4)::before {
    background: #16a34a;
}

.panel {
    transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.panel:hover {
    transform: translateY(-2px);
    box-shadow: 0 10px 28px rgba(15, 23, 42, 0.08);
}

.report-btn {
    transition: all 0.2s ease;
}

.report-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 18px rgba(37, 99, 235, 0.25);
}

.alert-row {
    transition: background 0.2s ease;
}

.alert-row:hover {
    background: #f8fafc;
}

.menu a {
    transition: all 0.2s ease;
}

.user-avatar {
    box-shadow: 0 3px 10px rgba(37, 99, 235, 0.25);
}```
