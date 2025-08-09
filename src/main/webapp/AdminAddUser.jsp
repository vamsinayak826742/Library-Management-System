<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Add New User</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        form { max-width: 400px; margin: auto; }
        label { display: block; margin-top: 15px; }
        input, select { width: 100%; padding: 8px; margin-top: 5px; }
        button { margin-top: 20px; padding: 10px 20px; background-color: #3498db; color: white; border: none; cursor: pointer; }
        button:hover { background-color: #2980b9; }
        .message { margin: 20px auto; max-width: 400px; text-align: center; }
    </style>
</head>
<body>

<h2>Add New User</h2>
<%
    // Check session and redirect if not logged in
    if (session == null || session.getAttribute("Id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<%
    String message = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        if (name == null || email == null || password == null || role == null ||
            name.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty() || role.trim().isEmpty()) {
            message = "All fields are required!";
        } else {
            Connection conn = null;
            PreparedStatement ps = null;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/LMS", "Vamsi", "Vamsi@826742");

                String sql = "INSERT INTO users(name, email, password, role) VALUES (?, ?, ?, ?)";
                ps = conn.prepareStatement(sql);
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, password);
                ps.setString(4, role);

                int inserted = ps.executeUpdate();
                if (inserted > 0) {
                	response.sendRedirect("AdminUsers.jsp");
                } else {
                    message = "Failed to add user.";
                }
            } catch (Exception e) {
                message = "Error: " + e.getMessage();
            } finally {
                if (ps != null) try { ps.close(); } catch (Exception ignored) {}
                if (conn != null) try { conn.close(); } catch (Exception ignored) {}
            }
        }
    }
%>

<form method="post" action="AdminAddUser.jsp">
    <label for="name">Name:</label>
    <input type="text" id="name" name="name" required>

    <label for="email">Email:</label>
    <input type="email" id="email" name="email" required>

    <label for="password">Password:</label>
    <input type="password" id="password" name="password" required>

    <label for="role">Role:</label>
    <select id="role" name="role" required>
        <option value="">-- Select Role --</option>
        <option value="user">User</option>
        <option value="admin">Admin</option>
    </select>

    <button type="submit">Add User</button>
</form>

<div class="message"><%= message %></div>



</body>
</html>
