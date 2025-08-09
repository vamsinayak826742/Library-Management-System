<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check session and redirect if not logged in
    if (session == null || session.getAttribute("Id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<%
    String idStr = request.getParameter("id");
    if (idStr == null) {
        response.sendRedirect("Users.jsp");
        return;
    }
    int id = Integer.parseInt(idStr);

    String message = "";
    String name = "";
    String email = "";
    String role = "";

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/LMS", "Vamsi", "Vamsi@826742");

        if ("POST".equalsIgnoreCase(request.getMethod())) {
            // Update user data
            name = request.getParameter("name");
            email = request.getParameter("email");
            String password = request.getParameter("password");
            role = request.getParameter("role");

            if (name == null || email == null || role == null || name.trim().isEmpty() || email.trim().isEmpty() || role.trim().isEmpty()) {
                message = "Name, Email, and Role are required!";
            } else {
                if (password != null && !password.trim().isEmpty()) {
                    String sqlUpdateWithPass = "UPDATE users SET name=?, email=?, password=?, role=? WHERE id=?";
                    ps = conn.prepareStatement(sqlUpdateWithPass);
                    ps.setString(1, name);
                    ps.setString(2, email);
                    ps.setString(3, password);
                    ps.setString(4, role);
                    ps.setInt(5, id);
                } else {
                    String sqlUpdate = "UPDATE users SET name=?, email=?, role=? WHERE id=?";
                    ps = conn.prepareStatement(sqlUpdate);
                    ps.setString(1, name);
                    ps.setString(2, email);
                    ps.setString(3, role);
                    ps.setInt(4, id);
                }
                int updated = ps.executeUpdate();
                if (updated > 0) {
                	response.sendRedirect("AdminUsers.jsp");
                } else {
                    message = "Failed to update user.";
                }
            }
        }

        // Fetch user details to populate form (also after POST to show updated values)
        if (!"POST".equalsIgnoreCase(request.getMethod()) || !message.isEmpty()) {
            String sqlSelect = "SELECT name, email, role FROM users WHERE id = ?";
            ps = conn.prepareStatement(sqlSelect);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                name = rs.getString("name");
                email = rs.getString("email");
                role = rs.getString("role");
            } else {
                response.sendRedirect("Users.jsp");
                return;
            }
        }
    } catch (Exception e) {
        message = "Error: " + e.getMessage();
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ignored) {}
        if (ps != null) try { ps.close(); } catch (Exception ignored) {}
        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
    }
%>
<html>
<head>
    <title>Edit User</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        form { max-width: 400px; margin: auto; }
        label { display: block; margin-top: 15px; }
        input, select { width: 100%; padding: 8px; margin-top: 5px; }
        button { margin-top: 20px; padding: 10px 20px; background-color: #4CAF50; color: white; border: none; cursor: pointer; }
        button:hover { background-color: #45a049; }
        .message { margin: 20px auto; max-width: 400px; text-align: center; color: red; }
    </style>
</head>
<body>

<h2>Edit User</h2>

<form method="post" action="AdminUpdateUser.jsp?id=<%= id %>">
    <label for="name">Name:</label>
    <input type="text" id="name" name="name" value="<%= name %>" required>

    <label for="email">Email:</label>
    <input type="email" id="email" name="email" value="<%= email %>" required>

    <label for="password">Password: <small>(Leave blank to keep unchanged)</small></label>
    <input type="password" id="password" name="password">

    <label for="role">Role:</label>
    <select id="role" name="role" required>
        <option value="user" <%= "user".equals(role) ? "selected" : "" %>>User</option>
        <option value="admin" <%= "admin".equals(role) ? "selected" : "" %>>Admin</option>
    </select>

    <button type="submit">Update User</button>
</form>

<div class="message"><%= message %></div>



</body>
</html>
