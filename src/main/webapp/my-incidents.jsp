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
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>CyberShield | My Incidents</title>

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
            padding: 45px;
            max-width: 1200px;
            margin: auto;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .header h1 {
            margin: 0 0 7px;
        }

        .header p {
            color: #68758a;
            margin: 0;
        }

        .back-btn,
        .report-btn {
            text-decoration: none;
            padding: 11px 17px;
            border-radius: 8px;
            font-weight: 700;
            font-size: 13px;
        }

        .back-btn {
            color: #2563eb;
            background: white;
            border: 1px solid #dbe3ef;
            margin-right: 8px;
        }

        .report-btn {
            color: white;
            background: #2563eb;
        }

        .panel {
            background: white;
            border-radius: 13px;
            border: 1px solid #e5eaf1;
            box-shadow: 0 5px 18px rgba(15, 23, 42, 0.05);
            overflow: hidden;
        }

        .panel-header {
            padding: 20px 23px;
            border-bottom: 1px solid #edf0f5;
        }

        .panel-header h2 {
            margin: 0;
            font-size: 17px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: #f8fafc;
            color: #68758a;
            font-size: 12px;
            text-align: left;
            padding: 15px;
        }

        td {
            padding: 15px;
            border-top: 1px solid #edf0f5;
            font-size: 13px;
        }

        .severity,
        .status {
            display: inline-block;
            padding: 6px 9px;
            border-radius: 15px;
            font-size: 11px;
            font-weight: 700;
        }

        .low {
            background: #dcfce7;
            color: #15803d;
        }

        .medium {
            background: #fef9c3;
            color: #a16207;
        }

        .high {
            background: #fff1df;
            color: #c2410c;
        }

        .critical {
            background: #fee2e2;
            color: #b91c1c;
        }

        .reported {
            background: #e8f0ff;
            color: #2563eb;
        }

        .investigation {
            background: #fff3df;
            color: #c2410c;
        }

        .resolved {
            background: #dcfce7;
            color: #15803d;
        }

        .empty {
            text-align: center;
            padding: 50px;
            color: #8994a6;
        }

        @media (max-width: 800px) {
            .main {
                padding: 25px 15px;
            }

            .header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }

            .panel {
                overflow-x: auto;
            }

            table {
                min-width: 750px;
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
                <h1>My Incidents</h1>
                <p>View and track your reported security incidents.</p>
            </div>

            <div>
                <a href="dashboard.jsp" class="back-btn">
                    Dashboard
                </a>

                <a href="report-incident.jsp" class="report-btn">
                    + Report Incident
                </a>
            </div>

        </div>

        <div class="panel">

            <div class="panel-header">
                <h2>Reported Incidents</h2>
            </div>

            <%
                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                boolean hasIncidents = false;

                try {

                    con = DBConnection.getConnection();

                    String sql =
                        "SELECT id, title, description, severity, incident_date, status " +
                        "FROM incidents " +
                        "WHERE user_id = ? " +
                        "ORDER BY created_at DESC";

                    ps = con.prepareStatement(sql);
                    ps.setInt(1, userId);

                    rs = ps.executeQuery();
            %>

            <table>

                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Incident</th>
                        <th>Description</th>
                        <th>Severity</th>
                        <th>Date</th>
                        <th>Status</th>
                    </tr>
                </thead>

                <tbody>

                <%
                    while (rs.next()) {

                        hasIncidents = true;

                        String severity = rs.getString("severity");
                        String status = rs.getString("status");

                        String severityClass = severity.toLowerCase();
                        String statusClass = status.equals("Under Investigation")
                                ? "investigation"
                                : status.toLowerCase().replace(" ", "");
                %>

                    <tr>

                        <td>
                            #<%= rs.getInt("id") %>
                        </td>

                        <td>
                            <strong>
                                <%= rs.getString("title") %>
                            </strong>
                        </td>

                        <td>
                            <%= rs.getString("description") %>
                        </td>

                        <td>
                            <span class="severity <%= severityClass %>">
                                <%= severity %>
                            </span>
                        </td>

                        <td>
                            <%= rs.getDate("incident_date") %>
                        </td>

                        <td>
                            <span class="status <%= statusClass %>">
                                <%= status %>
                            </span>
                        </td>

                    </tr>

                <%
                    }
                %>

                </tbody>

            </table>

            <%
                    if (!hasIncidents) {
            %>

                <div class="empty">
                    No incidents have been reported yet.
                </div>

            <%
                    }

                } catch (Exception e) {

                    e.printStackTrace();
            %>

                <div class="empty">
                    Unable to load incidents.
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