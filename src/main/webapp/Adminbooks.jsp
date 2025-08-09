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
    <title>Available Books - Admin</title>
    <link rel="stylesheet" type="text/css" href="books.css">
    <style>
        .book-frame {
            background-color: white;
            border: 2px solid #ddd;
            border-radius: 10px;
            padding: 15px;
            text-align: center;
            margin: 20px;
            width: 200px;
            box-shadow: 0px 4px 10px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        .book-frame:hover {
            transform: scale(1.05);
        }
        .book-image {
            width: 150px;
            height: 200px;
            object-fit: cover;
            border-radius: 5px;
        }
        .book-details {
            margin-top: 10px;
            font-family: Arial, sans-serif;
        }
        .book-title {
            font-weight: bold;
            font-size: 18px;
        }
        .book-author, .book-category, .book-quantity {
            font-size: 14px;
            color: #555;
        }
        .books-list {
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
        .add-book-btn {
            display: inline-block;
            margin: 20px;
            padding: 10px 15px;
            background-color: #3498db;
            color: white;
            font-size: 16px;
            border-radius: 5px;
            text-decoration: none;
        }
        .add-book-btn:hover {
            background-color: #2980b9;
        }
    </style>
</head>
<body>
<div class="popularbooks-container">
    <h1 class="popularbooks-title">Available Books</h1>

    <!-- Add Book Button -->
    <a href="AdminAddBook.jsp" class="add-book-btn">+ Add New Book</a>

    <div class="popularbooks">
        <div class="books-list">
            <%
                Connection conn = null;
                Statement stmt = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/LMS", "Vamsi", "Vamsi@826742");
                    stmt = conn.createStatement();
                    rs = stmt.executeQuery("SELECT * FROM books");

                    while (rs.next()) {
                        int id = rs.getInt("id");
                        String title = rs.getString("title");
                        String author = rs.getString("author");
                        String category = rs.getString("category");
                        int quantity = rs.getInt("quantity");
                        String imageUrl = rs.getString("image_url");
            %>
                        <div class="book-frame">
                            <img src="<%= imageUrl %>" alt="<%= title %>" class="book-image">
                            <div class="book-details">
                                <div class="book-title"><%= title %></div>
                                <div class="book-author">Author: <%= author %></div>
                                <div class="book-category">Category: <%= category %></div>
                                <div class="book-quantity">Available: <%= quantity %></div>
                            </div>
                            <div class="admin-buttons">
                                <a href="AdminUpdateBook.jsp?id=<%= id %>" class="edit-btn">Edit</a>
                                <a href="AdminDeleteBook.jsp?id=<%= id %>" class="delete-btn" onclick="return confirm('Are you sure you want to delete this book?');">Delete</a>
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
