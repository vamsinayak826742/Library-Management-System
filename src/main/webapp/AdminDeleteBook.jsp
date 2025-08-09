<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Delete Book</title>
</head>
<body>
<%
    // Check session and redirect if not logged in
    if (session == null || session.getAttribute("Id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<%


    String id = request.getParameter("id");
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/LMS", "Vamsi", "Vamsi@826742");

        String sql = "DELETE FROM books WHERE id=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, Integer.parseInt(id));

        int rows = ps.executeUpdate();
        if (rows > 0) {
            // Redirect to AdminBooks.jsp after successful deletion
            response.sendRedirect("Adminbooks.jsp");
            return;
        } else {
            out.println("<p>⚠ No book found with ID " + id + "</p>");
        }
        con.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }

%>
</body>
</html>
