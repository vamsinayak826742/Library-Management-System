<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check session and redirect if not logged in
    if (session == null || session.getAttribute("Id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<html>
<head>
    <title>Users - Admin</title>
    <link rel="stylesheet" type="text/css" href="books.css"> <!-- reuse if appropriate -->
    <style>
        .user-frame {
            background-color: white;
            border: 2px solid #ddd;
            border-radius: 10px;
            padding: 15px;
            text-align: center;
            margin: 20px;
            width: 250px;
            box-shadow: 0px 4px 10px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        .user-frame:hover {
            transform: scale(1.05);
        }
        .user-details {
            margin-top: 10px;
            font-family: Arial, sans-serif;
        }
        .user-name {
            font-weight: bold;
            font-size: 18px;
        }
        .user-email, .user-role {
            font-size: 14px;
            color: #555;
        }
        .users-list {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
        }
        .admin-buttons {
            margin-top: 10px;
        }
        .admin-buttons a {
            display: inline-block;
            padding: 5px 10px;
            margin: 3px;
            font-size: 14px;
            border-radius: 5px;
            text-decoration: none;
            color: white;
        }
        .edit-btn {
            background-color: #4CAF50;
        }
        .delete-btn {
            background-color: #e74c3c;
        }
        .add-user-btn {
            display: inline-block;
            margin: 20px;
            padding: 10px 15px;
            background-color: #3498db;
            color: white;
            font-size: 16px;
            border-radius: 5px;
            text-decoration: none;
        }
        .add-user-btn:hover {
            background-color: #2980b9;
        }
    </style>
</head>
<body>
<div class="popularbooks-container">
    <h1 class="popularbooks-title">Users</h1>

    <!-- Add User Button -->
    <a href="AdminAddUser.jsp" class="add-user-btn">+ Add New User</a>

    <div class="popularbooks">
        <div class="users-list">
            <%
                Connection conn = null;
                Statement stmt = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/LMS", "Vamsi", "Vamsi@826742");
                    stmt = conn.createStatement();
                    rs = stmt.executeQuery("SELECT id, name, email, role FROM users");

                    while (rs.next()) {
                        int id = rs.getInt("id");
                        String name = rs.getString("name");
                        String email = rs.getString("email");
                        String role = rs.getString("role");
            %>
                        <div class="user-frame">
                            <div class="user-details">
                                <div class="user-name"><%= name %></div>
                                <div class="user-email">Email: <%= email %></div>
                                <div class="user-role">Role: <%= role %></div>
                            </div>
                            <div class="admin-buttons">
                                <a href="AdminUpdateUser.jsp?id=<%= id %>" class="edit-btn">Edit</a>
                                <a href="AdminDeleteUser.jsp?id=<%= id %>" class="delete-btn" onclick="return confirm('Are you sure you want to delete this user?');">Delete</a>
                            </div>
                        </div>
            <%
                    }
                } catch (Exception e) {
                    out.println("Error: " + e.getMessage());
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                    if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
                    if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
                }
            %>
        </div>
    </div>
</div>
</body>
</html>
