<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.cybershield.DBConnection" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int userId = (Integer) session.getAttribute("userId");

    String name = "";
    String email = "";
    String createdAt = "";

    try {
        Connection con = DBConnection.getConnection();

        String sql =
            "SELECT name, email, created_at FROM users WHERE id = ?";

        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, userId);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            name = rs.getString("name");
            email = rs.getString("email");
            createdAt = rs.getTimestamp("created_at").toString();
        }

        rs.close();
        ps.close();
        con.close();

    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>CyberShield | Profile</title>

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
            max-width: 900px;
            margin: auto;
            padding: 45px;
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

        .profile-card {
            background: white;
            border: 1px solid #e5eaf1;
            border-radius: 13px;
            box-shadow: 0 5px 18px rgba(15, 23, 42, 0.05);
            padding: 35px;
        }

        .profile-top {
            display: flex;
            align-items: center;
            gap: 20px;
            padding-bottom: 25px;
            border-bottom: 1px solid #edf0f5;
            margin-bottom: 25px;
        }

        .avatar {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            background: #2563eb;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            font-weight: 700;
        }

        .profile-top h2 {
            margin: 0 0 6px;
        }

        .profile-top p {
            margin: 0;
            color: #68758a;
        }

        .info {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px;
        }

        .info-box {
            background: #f8fafc;
            border: 1px solid #e5eaf1;
            border-radius: 10px;
            padding: 18px;
        }

        .label {
            color: #68758a;
            font-size: 12px;
            font-weight: 700;
            margin-bottom: 7px;
        }

        .value {
            font-size: 15px;
            font-weight: 600;
        }

        .actions {
            margin-top: 28px;
            display: flex;
            gap: 12px;
        }

        .dashboard-btn,
        .logout-btn {
            text-decoration: none;
            padding: 11px 18px;
            border-radius: 8px;
            font-weight: 700;
            font-size: 13px;
        }

        .dashboard-btn {
            background: #2563eb;
            color: white;
        }

        .logout-btn {
            background: #fee2e2;
            color: #b91c1c;
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

            .info {
                grid-template-columns: 1fr;
            }

            .profile-card {
                padding: 25px;
            }
        }

    </style>

</head>

<body>

    <div class="navbar">

        <div class="brand">

            <div class="brand-icon">
                🛡
            </div>

            <h2>CyberShield</h2>

        </div>

        <div class="user">
            <%= name %>
        </div>

    </div>


    <main class="main">

        <div class="header">

            <div>

                <h1>My Profile</h1>

                <p>
                    View your CyberShield account information.
                </p>

            </div>

            <a href="dashboard.jsp" class="back-btn">
                Dashboard
            </a>

        </div>


        <div class="profile-card">

            <div class="profile-top">

                <div class="avatar">
                    <%= name.length() > 0
                        ? name.substring(0, 1).toUpperCase()
                        : "U" %>
                </div>

                <div>

                    <h2>
                        <%= name %>
                    </h2>

                    <p>
                        CyberShield User
                    </p>

                </div>

            </div>


            <div class="info">

                <div class="info-box">

                    <div class="label">
                        FULL NAME
                    </div>

                    <div class="value">
                        <%= name %>
                    </div>

                </div>


                <div class="info-box">

                    <div class="label">
                        EMAIL ADDRESS
                    </div>

                    <div class="value">
                        <%= email %>
                    </div>

                </div>


                <div class="info-box">

                    <div class="label">
                        USER ID
                    </div>

                    <div class="value">
                        #<%= userId %>
                    </div>

                </div>


                <div class="info-box">

                    <div class="label">
                        ACCOUNT CREATED
                    </div>

                    <div class="value">
                        <%= createdAt %>
                    </div>

                </div>

            </div>


            <div class="actions">

                <a href="dashboard.jsp" class="dashboard-btn">
                    Back to Dashboard
                </a>

                <a href="logout" class="logout-btn">
                    Logout
                </a>

            </div>

        </div>

    </main>

</body>

</html>