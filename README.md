# College Placement Management System (CPMS)

A centralized, role-based web application designed to streamline and manage the college placement process by connecting students, placement officers, and company recruiters through a single platform.

## Overview

The **College Placement Management System (CPMS)** aims to simplify the placement activities conducted within a college. It provides a centralized platform where students can explore placement opportunities, recruiters can manage recruitment activities, and placement officers can oversee and coordinate the entire placement process.

Instead of managing placement information through disconnected spreadsheets, manual records, and separate communication channels, CPMS brings important placement-related activities together in one system.

The application follows a role-based architecture with dedicated modules for Students, Recruiters, and Placement Officers.

## Key Features

### 1. Student Module
- Student registration and login.
- Personalized student dashboard.
- Profile and academic information management.
- Browse available placement opportunities.
- View job eligibility information.
- Apply for job opportunities.
- Track application status.
- Upload and manage resumes.
- View interview schedules.
- Receive placement notifications.
- Communicate through the messaging module.

### 2. Recruiter Module
- Recruiter registration and profile management.
- Dedicated recruiter dashboard.
- Manage company and recruitment information.
- Post and manage job opportunities.
- Browse eligible student candidates.
- View candidate details.
- Manage interview schedules.
- Access recruitment-related information.

### 3. Placement Officer Module
- Centralized placement administration dashboard.
- Manage student records.
- Manage company information.
- Create and manage job opportunities.
- Review student applications.
- Monitor placement activities.
- Manage interview schedules.
- Verify student and recruiter information.
- Review and provide resume feedback.
- Manage notifications and messages.
- Generate placement-related reports.

## Technology Stack

| Component | Technology |
|---|---|
| Backend | Java |
| Web Technology | Jakarta Servlets |
| Frontend | JSP, HTML, CSS, JavaScript |
| Database | MySQL |
| Database Connectivity | JDBC |
| Build Automation | Apache Maven |
| Authentication | Role-based authentication |
| Password Security | BCrypt password hashing |
| Version Control | Git and GitHub |

## Application Architecture

The project follows a layered architecture to separate application responsibilities and improve maintainability.

```text
              USER INTERFACE
                    |
               JSP Pages
                    |
             Jakarta Servlets
                    |
             Service Layer
                    |
               DAO Layer
                    |
              JDBC Connection
                    |
                MySQL
```

### Project Layers

- **Controller Layer:** Handles HTTP requests, user interactions, and application navigation through Servlets.
- **Service Layer:** Contains business logic and coordinates application operations.
- **DAO Layer:** Handles database operations and SQL queries.
- **Model Layer:** Represents application entities such as Students, Companies, Jobs, Applications, and Interviews.
- **Filter Layer:** Handles authentication-related request filtering.
- **View Layer:** Provides the user interface using JSP, CSS, HTML, and JavaScript.

## Project Structure

```text
College Placement Management System/
│
├── CPMS/
│   ├── database/
│   │   ├── cpms_schema.sql
│   │   ├── migration_v2.sql
│   │   └── sample_data.sql
│   │
│   ├── src/
│   │   └── main/
│   │       ├── java/com/cpms/
│   │       │   ├── controller/
│   │       │   ├── dao/
│   │       │   ├── desktop/
│   │       │   ├── filter/
│   │       │   ├── model/
│   │       │   ├── report/
│   │       │   ├── service/
│   │       │   ├── test/
│   │       │   └── util/
│   │       │
│   │       ├── resources/
│   │       └── webapp/
│   │           ├── admin/
│   │           ├── assets/
│   │           ├── officer/
│   │           ├── recruiter/
│   │           ├── student/
│   │           └── WEB-INF/
│   │
│   └── pom.xml
│
├── CPMS_Database_Starter/
│   ├── database/
│   ├── src/
│   └── pom.xml
│
├── run.bat
├── start-server.bat
├── README.md
└── .gitignore
```

## Database

CPMS uses MySQL as its relational database management system.

The database includes tables and supporting database objects for:

- User accounts and authentication.
- Student profiles and departments.
- Placement officers.
- Companies and recruiters.
- Job opportunities.
- Job eligibility and applications.
- Resumes and resume feedback.
- Interview schedules.
- Placement offers.
- Notifications and messaging.
- Placement reports and reporting views.

Database scripts are available in:

`CPMS/database/`

| File | Purpose |
|---|---|
| `cpms_schema.sql` | Database schema creation |
| `migration_v2.sql` | Database migration |
| `sample_data.sql` | Sample database records |

**Important:** The schema creation script drops and recreates CPMS tables. Back up existing data before executing it.

## Getting Started

### Prerequisites

Install the following software before setting up the application:

- JDK 21
- MySQL 8.0.16 or later
- Apache Maven
- Git
- A compatible Jakarta Servlet container

### 1. Clone the Repository

```bash
git clone https://github.com/devadersanr2025cse-coder/College-Placement-Management-System.git
```

### 2. Navigate to the Project

```bash
cd College-Placement-Management-System
```

### 3. Set Up the Database

Create the CPMS database using the SQL scripts provided in:

```text
CPMS/database/
```

Import the schema and configure the database connection according to the application's `DBConnection.java` implementation.

### 4. Configure Database Credentials

Use the database connection configuration expected by the application.

Do not commit actual database passwords or other sensitive credentials to GitHub.

### 5. Build the Application

Navigate to the CPMS directory:

```bash
cd CPMS
```

Run:

```bash
mvn clean package
```

### 6. Run the Application

Use the provided startup scripts:

```text
run.bat
start-server.bat
```

Follow the scripts' instructions to start the application and access it through the configured local server address.

*Note: Confirm the server configuration and database connection settings before following the setup instructions on a new machine.*

## Why CPMS?

Traditional college placement management often involves multiple disconnected processes, including maintaining student records, sharing job opportunities, collecting applications, coordinating interviews, and tracking placement results.

CPMS brings these activities into a centralized system.

### Advantages

- **Centralized Management:** Placement-related information is maintained in one application.
- **Role-Based Access:** Students, recruiters, and placement officers have separate application modules.
- **Improved Coordination:** Recruitment activities and communication are organized through a common platform.
- **Efficient Tracking:** Application and interview information can be monitored systematically.
- **Better Data Organization:** Relational database management helps maintain structured information.
- **Maintainable Architecture:** Separation of controllers, services, DAOs, and models makes the application easier to extend.

## Future Enhancements

Potential improvements for future versions include:

- Email and SMS integration for placement notifications.
- Advanced analytics and placement statistics.
- Automated resume parsing.
- AI-assisted job recommendations.
- Advanced candidate filtering.
- Cloud deployment and online access.
- Integration with external recruitment platforms.

## Learning Outcomes

This project provides practical experience in:

- Java web application development.
- Object-oriented programming.
- Servlet and JSP-based application development.
- Relational database design and SQL.
- JDBC connectivity.
- Layered software architecture.
- Authentication and access control.
- Maven-based project management.
- Git and GitHub version control.

## Repository

**GitHub:** https://github.com/devadersanr2025cse-coder/College-Placement-Management-System

---

**College Placement Management System (CPMS)**

*Developed as an academic project to simplify and organize the college placement process.*
