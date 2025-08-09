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
    <title>Edit Book</title>
</head>
<body>
<h2>Edit Book</h2>

<!-- Step 1: Search Book by ID -->


<%
String id = request.getParameter("id");

// Step 2: If ID is provided via GET, fetch and display form
if (id != null && !id.isEmpty() && !"POST".equalsIgnoreCase(request.getMethod())) {
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/LMS", "Vamsi", "Vamsi@826742");

        String query = "SELECT * FROM books WHERE id=?";
        PreparedStatement ps = con.prepareStatement(query);
        ps.setInt(1, Integer.parseInt(id));
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
%>
<form method="post">
    <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
    Title: <input type="text" name="title" value="<%= rs.getString("title") %>" required><br><br>
    Author: <input type="text" name="author" value="<%= rs.getString("author") %>" required><br><br>
    Category: <input type="text" name="category" value="<%= rs.getString("category") %>" required><br><br>
    Quantity: <input type="number" name="quantity" value="<%= rs.getInt("quantity") %>" required><br><br>
    Image URL: <input type="url" name="image_url" value="<%= rs.getString("image_url") %>" required><br><br>
    <input type="submit" value="Update Book">
</form>
<%
        } else {
            out.println("<p>⚠ No book found with ID " + id + "</p>");
        }
        con.close();
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    }
}

// Step 3: Handle POST (Update Data)
if ("POST".equalsIgnoreCase(request.getMethod())) {
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/LMS", "Vamsi", "Vamsi@826742");

        String sql = "UPDATE books SET title=?, author=?, category=?, quantity=?, image_url=? WHERE id=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, request.getParameter("title"));
        ps.setString(2, request.getParameter("author"));
        ps.setString(3, request.getParameter("category"));
        ps.setInt(4, Integer.parseInt(request.getParameter("quantity")));
        ps.setString(5, request.getParameter("image_url"));
        ps.setInt(6, Integer.parseInt(request.getParameter("id")));

        int rows = ps.executeUpdate();
        if (rows > 0) {
            // Redirect to AdminBooks.jsp after successful update
            response.sendRedirect("Adminbooks.jsp");
            return;
        } else {
            out.println("<p>❌ Failed to update book.</p>");
        }
        con.close();
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    }
}
%>
</body>
</html>
