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
    <title>Add Book</title>
</head>
<body>

<h2>Add New Book</h2>
<form action="" method="post">
    <label for="title">Title:</label>
    <input type="text" name="title" id="title" required><br><br>

    <label for="author">Author:</label>
    <input type="text" name="author" id="author" required><br><br>

    <label for="category">Category:</label>
    <input type="text" name="category" id="category" required><br><br>

    <label for="quantity">Quantity:</label>
    <input type="number" name="quantity" id="quantity" min="1" required><br><br>

    <label for="image_url">Image URL:</label>
    <input type="url" name="image_url" id="image_url" placeholder="https://example.com/image.jpg" required><br><br>

    <input type="submit" value="Add Book">
</form>

<%
if ("POST".equalsIgnoreCase(request.getMethod())) {
    String title = request.getParameter("title");
    String author = request.getParameter("author");
    String category = request.getParameter("category");
    int quantity = Integer.parseInt(request.getParameter("quantity"));
    String imageUrl = request.getParameter("image_url");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/LMS", 
            "Vamsi", 
            "Vamsi@826742"
        );

        String sql = "INSERT INTO books (title, author, category, quantity, image_url) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, title);
        ps.setString(2, author);
        ps.setString(3, category);
        ps.setInt(4, quantity);
        ps.setString(5, imageUrl);

        int rows = ps.executeUpdate();
        if (rows > 0) {
            // Redirect to AdminBooks.jsp after successful insertion
            response.sendRedirect("Adminbooks.jsp");
            return;
        } else {
            out.println("<p style='color:red;'>❌ Failed to add book.</p>");
        }
        con.close();
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    }
}
%>
</body>
</html>
