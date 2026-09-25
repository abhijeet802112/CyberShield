<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.cybershield.DBConnection" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int userId = (Integer) session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");

    if (userName == null) {
        userName = "User";
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>CyberShield | Security Alerts</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, Helvetica, sans-serif;
            background: #f4f7fb;
            color: #172033;
        }

        .navbar {
            height: 72px;
            background: #0b1f3a;
            color: white;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 32px;
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .brand-icon {
            width: 40px;
            height: 40px;
            background: #2563eb;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .brand h2 {
            margin: 0;
            font-size: 21px;
        }

        .user {
            font-weight: 600;
        }

        .main {
            max-width: 1100px;
            margin: auto;
            padding: 45px;
        }

        .header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 25px;
        }

        .header h1 {
            margin: 0 0 7px;
        }

        .header p {
            margin: 0;
            color: #68758a;
        }

        .back-btn {
            text-decoration: none;
            color: #2563eb;
            background: white;
            border: 1px solid #dbe3ef;
            padding: 11px 17px;
            border-radius: 8px;
            font-weight: 700;
            font-size: 13px;
        }

        .panel {
            background: white;
            border: 1px solid #e5eaf1;
            border-radius: 13px;
            box-shadow: 0 5px 18px rgba(15, 23, 42, 0.05);
            overflow: hidden;
        }

        .panel-header {
            padding: 21px 23px;
            border-bottom: 1px solid #edf0f5;
        }

        .panel-header h2 {
            margin: 0;
            font-size: 17px;
        }

        .alert {
            padding: 20px 23px;
            border-bottom: 1px solid #edf0f5;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
        }

        .alert:last-child {
            border-bottom: none;
        }

        .alert-left {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .alert-icon {
            width: 45px;
            height: 45px;
            border-radius: 10px;
            background: #fee2e2;
            color: #dc2626;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
        }

        .message {
            font-weight: 700;
            font-size: 14px;
        }

        .time {
            color: #8b95a5;
            font-size: 11px;
            margin-top: 5px;
        }

        .severity {
            padding: 7px 11px;
            border-radius: 20px;
            font-size: 10px;
            font-weight: 800;
            text-transform: uppercase;
        }

        .high {
            background: #fff1df;
            color: #c2410c;
        }

        .critical {
            background: #fee2e2;
            color: #b91c1c;
        }

        .empty {
            padding: 55px 20px;
            text-align: center;
            color: #8994a6;
            font-size: 13px;
        }

        @media (max-width: 650px) {
            .main {
                padding: 25px 15px;
            }

            .header {
                flex-direction: column;
                align-items: flex-start;
                gap: 18px;
            }

            .alert {
                align-items: flex-start;
                flex-direction: column;
            }
        }
    </style>

</head>

<body>

    <div class="navbar">

        <div class="brand">
            <div class="brand-icon">🛡</div>

            <div>
                <h2>CyberShield</h2>
            </div>
        </div>

        <div class="user">
            <%= userName %>
        </div>

    </div>

    <main class="main">

        <div class="header">

            <div>
                <h1>Security Alerts</h1>
                <p>Monitor security alerts generated from your incidents.</p>
            </div>

            <a href="dashboard.jsp" class="back-btn">
                Dashboard
            </a>

        </div>

        <div class="panel">

            <div class="panel-header">
                <h2>Recent Alerts</h2>
            </div>

            <%
                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                boolean hasAlerts = false;

                try {

                    con = DBConnection.getConnection();

                    String sql =
                        "SELECT a.alert_message, a.severity, a.created_at " +
                        "FROM alerts a " +
                        "JOIN incidents i ON a.incident_id = i.id " +
                        "WHERE i.user_id = ? " +
                        "ORDER BY a.created_at DESC";

                    ps = con.prepareStatement(sql);
                    ps.setInt(1, userId);

                    rs = ps.executeQuery();

                    while (rs.next()) {

                        hasAlerts = true;

                        String severity = rs.getString("severity");
                        String severityClass = severity.toLowerCase();
            %>

            <div class="alert">

                <div class="alert-left">

                    <div class="alert-icon">
                        !
                    </div>

                    <div>

                        <div class="message">
                            <%= rs.getString("alert_message") %>
                        </div>

                        <div class="time">
                            <%= rs.getTimestamp("created_at") %>
                        </div>

                    </div>

                </div>

                <span class="severity <%= severityClass %>">
                    <%= severity %>
                </span>

            </div>

            <%
                    }

                    if (!hasAlerts) {
            %>

                <div class="empty">
                    No security alerts found.
                </div>

            <%
                    }

                } catch (Exception e) {

                    e.printStackTrace();
            %>

                <div class="empty">
                    Unable to load security alerts.
                </div>

            <%
                } finally {

                    try {
                        if (rs != null) rs.close();
                    } catch (Exception e) {}

                    try {
                        if (ps != null) ps.close();
                    } catch (Exception e) {}

                    try {
                        if (con != null) con.close();
                    } catch (Exception e) {}
                }
            %>

        </div>

    </main>

</body>

</html>