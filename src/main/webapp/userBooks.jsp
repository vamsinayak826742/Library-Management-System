<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
   
    if (session == null || session.getAttribute("Id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int userId = (int) session.getAttribute("Id");

    Connection conn = null;
    PreparedStatement psCat = null;
    ResultSet rsCat = null;
%>
<html>
<head>
    <title>Available Books - User</title>
    <link rel="stylesheet" type="text/css" href="books.css">
    <style>
        /* Your CSS styling here, keep as is */
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
        .user-buttons {
            margin-top: 10px;
        }
        .user-buttons form {
            display: inline-block;
            margin: 3px;
        }
        .user-buttons button {
            padding: 5px 10px;
            font-size: 14px;
            border-radius: 5px;
            border: none;
            cursor: pointer;
            color: white;
        }
        .reserve-btn {
            background-color: #f39c12; /* orange */
        }
        .borrow-btn {
            background-color: #27ae60; /* green */
        }
        .category-filter {
            margin: 20px;
            text-align: center;
        }
        select {
            padding: 7px 10px;
            font-size: 16px;
            border-radius: 5px;
            border: 1px solid #ccc;
        }
        .search-btn {
            padding: 7px 15px;
            font-size: 16px;
            border-radius: 5px;
            border: none;
            background-color: #3498db;
            color: white;
            cursor: pointer;
            margin-left: 10px;
        }
        .search-btn:hover {
            background-color: #2980b9;
        }
    </style>
</head>
<body>
<div class="popularbooks-container">
    <h1 class="popularbooks-title">Available Books</h1>

    <!-- Category filter form -->
    <div class="category-filter">
        <form method="get" action="userBooks.jsp">
            Category:
            <select name="categoryFilter">
                <option value="">All Categories</option>
                <%
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/LMS", "Vamsi", "Vamsi@826742");
                        String catSql = "SELECT DISTINCT category FROM books";
                        psCat = conn.prepareStatement(catSql);
                        rsCat = psCat.executeQuery();

                        String selectedCategory = request.getParameter("categoryFilter");
                        if (selectedCategory == null) selectedCategory = "";

                        while (rsCat.next()) {
                            String cat = rsCat.getString("category");
                            String selectedAttr = cat.equals(selectedCategory) ? "selected" : "";
                %>
                            <option value="<%=cat%>" <%=selectedAttr%>><%=cat%></option>
                <%
                        }
                    } catch (Exception e) {
                        out.println("Error fetching categories: " + e.getMessage());
                    } finally {
                        if (rsCat != null) try { rsCat.close(); } catch (Exception ignored) {}
                        if (psCat != null) try { psCat.close(); } catch (Exception ignored) {}
                    }
                %>
            </select>
            <button class="search-btn" type="submit">Filter</button>
        </form>
    </div>

    <div class="popularbooks">
        <div class="books-list">
            <%
                PreparedStatement ps = null;
                ResultSet rs = null;
                try {
                    String filter = request.getParameter("categoryFilter");
                    String sql = "SELECT * FROM books";
                    if (filter != null && !filter.trim().isEmpty()) {
                        sql += " WHERE category = ?";
                    }

                    ps = conn.prepareStatement(sql);
                    if (filter != null && !filter.trim().isEmpty()) {
                        ps.setString(1, filter);
                    }

                    rs = ps.executeQuery();

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
                            <div class="user-buttons">
                                

                                <form method="post" action="BorrowBookServlet" onsubmit="return confirm('Are you sure you want to borrow this book?');">
                                    <input type="hidden" name="bookId" value="<%= id %>" />
                                    <!-- No userId field: BorrowBookServlet will get userId from session -->
                                    <button type="submit" class="borrow-btn" <%= quantity == 0 ? "disabled" : "" %>>Borrow</button>
                                </form>
                            </div>
                        </div>
            <%
                    }
                } catch (Exception e) {
                    out.println("Error: " + e.getMessage());
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                    if (ps != null) try { ps.close(); } catch (SQLException ignored) {}
                    if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
                }
            %>
        </div>
    </div>
</div>
</body>
</html>
