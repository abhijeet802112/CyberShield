package com.cybershield;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/reportIncident")
public class IncidentServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String severity = request.getParameter("severity");
        String incidentDate = request.getParameter("incident_date");

        String incidentSql =
                "INSERT INTO incidents " +
                "(user_id, title, description, severity, incident_date) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     incidentSql,
                     PreparedStatement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, userId);
            ps.setString(2, title);
            ps.setString(3, description);
            ps.setString(4, severity);
            ps.setString(5, incidentDate);

            ps.executeUpdate();

            ResultSet keys = ps.getGeneratedKeys();

            int incidentId = 0;

            if (keys.next()) {
                incidentId = keys.getInt(1);
            }

            keys.close();

            // Create alert only for High or Critical incidents
            if (severity.equals("High") || severity.equals("Critical")) {

                String alertMessage =
                        severity + " severity incident reported: " + title;

                String alertSql =
                        "INSERT INTO alerts " +
                        "(incident_id, alert_message, severity) " +
                        "VALUES (?, ?, ?)";

                try (PreparedStatement alertPs =
                             con.prepareStatement(alertSql)) {

                    alertPs.setInt(1, incidentId);
                    alertPs.setString(2, alertMessage);
                    alertPs.setString(3, severity);

                    alertPs.executeUpdate();
                }
            }

            response.sendRedirect("dashboard.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println(
                    "Incident reporting failed: " + e.getMessage()
            );
        }
    }
}