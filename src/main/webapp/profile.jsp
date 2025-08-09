<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%
    // Check session and redirect if not logged in
    if (session == null || session.getAttribute("Id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<%
    // Get user ID from session
    Integer userId = (Integer) session.getAttribute("Id");

    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String name = "";
    String email = "";
    String password = "";
    String role = "";

    // DB connection variables
    String jdbcURL = "jdbc:mysql://localhost:3306/LMS";
    String dbUser = "Vamsi";
    String dbPass = "Vamsi@826742";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPass);

        String sql = "SELECT * FROM users WHERE id = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, userId);

        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            name = rs.getString("name");
            email = rs.getString("email");
            password = rs.getString("Password");
            role = rs.getString("role");
        }

        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>User Profile</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f2f2f2;
            display: flex;
            justify-content: center;
            padding: 50px;
        }
        .profile-card {
            background: #fff;
            padding: 20px;
            border-radius: 15px;
            width: 350px;
            text-align: center;
            box-shadow: 0px 4px 8px rgba(0,0,0,0.1);
        }
        .profile-pic {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            margin-bottom: 15px;
        }
        .info {
            text-align: left;
            margin-top: 10px;
        }
        .info p {
            margin: 8px 0;
            font-size: 16px;
        }
        .label {
            font-weight: bold;
            color: #555;
        }
        .profile-pic {
    width: 150px;
    height: 150px;
    border-radius: 50%;
    object-fit: cover;
    display: block;
    margin: 20px auto;
    border: 3px solid #ccc;
}
    </style>
</head>
<body>

<div class="profile-card">
   <img src="https://cdn-icons-png.flaticon.com/512/2302/2302834.png" 
     alt="Profile Picture"
     class="profile-pic">

     

    <h2><%= name %></h2>
    <div class="info">
        <p><span class="label">ID:</span> <%= userId %></p>
        <p><span class="label">Email:</span> <%= email %></p>
        <p><span class="label">Password:</span> <%= password %></p>
        <p><span class="label">Role:</span> <%= role %></p>
    </div>
</div>

</body>
</html>
