package com.cybershield;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        String sql = "SELECT id, name, password FROM users WHERE email = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                int userId = rs.getInt("id");
                String userName = rs.getString("name");
                String storedPassword = rs.getString("password");

                boolean passwordMatched = false;

                // Check whether the stored password is a BCrypt hash
                if (storedPassword != null &&
                    (storedPassword.startsWith("$2a$") ||
                     storedPassword.startsWith("$2b$") ||
                     storedPassword.startsWith("$2y$"))) {

                    // New users: verify BCrypt password
                    passwordMatched = BCrypt.checkpw(password, storedPassword);

                } else {

                    // Old users: temporarily verify the old plain-text password
                    passwordMatched = password.equals(storedPassword);

                    // If old password is correct, immediately upgrade it to BCrypt
                    if (passwordMatched) {

                        String newHashedPassword =
                                BCrypt.hashpw(password, BCrypt.gensalt(12));

                        String updateSql =
                                "UPDATE users SET password = ? WHERE id = ?";

                        try (PreparedStatement updatePs =
                                     con.prepareStatement(updateSql)) {

                            updatePs.setString(1, newHashedPassword);
                            updatePs.setInt(2, userId);
                            updatePs.executeUpdate();
                        }
                    }
                }

                if (passwordMatched) {

                    HttpSession session = request.getSession();

                    session.setAttribute("userId", userId);
                    session.setAttribute("userName", userName);

                    response.sendRedirect("dashboard.jsp");

                } else {

                    response.getWriter().println(
                            "Invalid email or password."
                    );
                }

            } else {

                response.getWriter().println(
                        "Invalid email or password."
                );
            }

        } catch (Exception e) {

            e.printStackTrace();
            response.getWriter().println(
                    "Login failed: " + e.getMessage()
            );
        }
    }
}