CyberShield – Cyber Security Incident Management System

📌 Project Overview

CyberShield is a web-based Cyber Security Incident Management System developed for reporting, tracking, and monitoring security incidents through a centralized security dashboard.

The system provides user authentication, incident reporting, incident tracking, and security alert monitoring.

🚀 Features

- User Registration
- Secure User Login
- Password Hashing
- Session Management
- Logout
- Security Incident Reporting
- My Incidents
- Incident Severity Classification
  - Low
  - Medium
  - High
  - Critical
- Incident Status Tracking
  - Reported
  - Under Investigation
  - Resolved
- Security Dashboard
- Incident Statistics
- Automatic High/Critical Security Alerts
- Recent Security Alerts
- User Profile

🛠️ Technologies Used

Frontend

- HTML
- CSS
- JavaScript
- JSP (JavaServer Pages)

Backend

- Java
- Java Servlets
- JDBC

Database

- MySQL

Server & Build Tools

- Apache Tomcat
- Maven

🏗️ Project Architecture

HTML / CSS / JavaScript
        ↓
       JSP
        ↓
Java Servlets
        ↓
      JDBC
        ↓
MySQL Database

Architecture Explanation

- HTML / CSS / JavaScript – Used for the user interface and client-side interactions.
- JSP – Used for dynamic web pages and displaying application data.
- Java Servlets – Handle server-side processing, authentication, incident management, and application logic.
- JDBC – Provides connectivity between the Java application and MySQL database.
- MySQL – Stores user and incident-related data.

📂 Project Structure

CyberShield/
│
├── pom.xml
├── .gitignore
├── README.md
│
└── src/
    └── main/
        ├── java/
        │   └── com/
        │       └── cybershield/
        │           ├── IncidentServlet.java
        │           ├── LoginServlet.java
        │           ├── LogoutServlet.java
        │           └── RegisterServlet.java
        │
        └── webapp/
            ├── WEB-INF/
            │   └── web.xml
            │
            ├── dashboard.jsp
            ├── index.jsp
            ├── login.jsp
            ├── my-incidents.jsp
            ├── profile.jsp
            ├── register.jsp
            ├── report-incident.jsp
            ├── security-alerts.jsp
            ├── script.js
            └── style.css

🔐 Authentication & Security

CyberShield includes:

- User authentication
- Password hashing
- Session-based login management
- Logout and session invalidation
- Security incident tracking
- High and Critical incident alert monitoring

Passwords are stored using hashing rather than plain-text storage.

📝 Incident Management

Users can report security incidents by providing information such as:

- Incident Title
- Description
- Severity
- Date
- Status

Supported incident statuses include:

Reported
Under Investigation
Resolved

The system provides incident tracking through the My Incidents section.

🚨 Security Alert Dashboard

The Security Dashboard provides an overview of security incidents and alerts, including:

- Total Incidents
- Critical Alerts
- High Alerts
- Resolved Incidents
- Recent Security Alerts

High and Critical incidents can automatically generate security alerts.

🗄️ Database

CyberShield uses MySQL for storing application data such as:

- User information
- Security incidents
- Security alert-related data

Database credentials are kept outside the GitHub repository and should be configured according to the local development environment.

▶️ How to Run

Prerequisites

- Java JDK
- MySQL
- Apache Tomcat
- Maven

Steps

1. Clone the repository.
2. Configure the MySQL database for the application.
3. Configure the local database connection.
4. Build the project using Maven:

mvn clean package

5. Deploy the generated application/WAR file to Apache Tomcat.
6. Start the Tomcat server.
7. Open the application in a web browser.

🔄 Application Flow

User
 ↓
Registration / Login
 ↓
Security Dashboard
 ↓
Report Incident
 ↓
Java Servlet
 ↓
JDBC
 ↓
MySQL Database
 ↓
Incident / Alert Data
 ↓
Dashboard / My Incidents / Security Alerts

🎯 Project Objective

The main objective of CyberShield is to provide a centralized platform for reporting, tracking, and monitoring cybersecurity incidents.

The project demonstrates practical implementation of:

- Web application development
- Java Servlets and JSP
- MySQL database connectivity
- User authentication
- Password hashing
- Session management
- Security incident management
- Security alert monitoring

👨‍💻 Author

Abhijeet Mishra

B.Tech CSE – Cyber Security

📌 Note

This project was developed for educational and portfolio purposes.