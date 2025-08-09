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
    <title>Transactions - Admin</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ccc;
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        .filter-form {
            margin-bottom: 15px;
        }
        .filter-form input {
            padding: 6px 10px;
            margin-right: 10px;
            width: 150px;
        }
        .filter-form button {
            padding: 6px 12px;
            background-color: #3498db;
            color: white;
            border: none;
            cursor: pointer;
            border-radius: 4px;
        }
        .filter-form button:hover {
            background-color: #2980b9;
        }
        .update-btn {
            padding: 5px 10px;
            background-color: #27ae60;
            color: white;
            border: none;
            cursor: pointer;
            border-radius: 4px;
            text-decoration: none;
        }
        .update-btn:hover {
            background-color: #1e8449;
        }
        .msg {
            margin: 15px 0;
            color: green;
        }
    </style>
</head>
<body>

<h2>Transactions</h2>

<%
    String msg = request.getParameter("msg");
    if (msg != null) {
%>
    <div class="msg"><%= msg.replace("+", " ") %></div>
<%
    }
%>

<form class="filter-form" method="get" action="AdminTransaction.jsp">
    <label>Search by:
        <select name="searchBy" id="searchBy" onchange="updatePlaceholder()">
            <option value="user_id" <%= "user_id".equals(request.getParameter("searchBy")) ? "selected" : "" %>>User ID</option>
            <option value="book_id" <%= "book_id".equals(request.getParameter("searchBy")) ? "selected" : "" %>>Book ID</option>
            <option value="user_name" <%= "user_name".equals(request.getParameter("searchBy")) ? "selected" : "" %>>User Name</option>
            <option value="book_title" <%= "book_title".equals(request.getParameter("searchBy")) ? "selected" : "" %>>Book Title</option>
        </select>
    </label>

    <label>
        Search value:
        <input type="text" name="searchValue" id="searchValue" 
            value="<%= request.getParameter("searchValue") != null ? request.getParameter("searchValue") : "" %>" 
            placeholder="Enter search value">
    </label>

    <button type="submit">Search</button>
    <a href="AdminTransaction.jsp" style="margin-left:10px; text-decoration:none;">Clear</a>
</form>

<script>
    function updatePlaceholder() {
        var searchBy = document.getElementById("searchBy").value;
        var input = document.getElementById("searchValue");
        switch(searchBy) {
            case "user_id":
                input.placeholder = "Enter User ID (number)";
                break;
            case "book_id":
                input.placeholder = "Enter Book ID (number)";
                break;
            case "user_name":
                input.placeholder = "Enter User Name";
                break;
            case "book_title":
                input.placeholder = "Enter Book Title";
                break;
            default:
                input.placeholder = "Enter search value";
        }
    }
    window.onload = updatePlaceholder;
</script>

<%
String searchBy = request.getParameter("searchBy");
String searchValue = request.getParameter("searchValue");

Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/LMS", "Vamsi", "Vamsi@826742");

    String baseSql = "SELECT t.transaction_id, t.user_id, u.name AS user_name, t.book_id, b.title AS book_title, " +
                     "t.transaction_type, t.status, t.start_date, t.due_date, t.fine, t.paid_fine " +  // Added paid_fine here
                     "FROM transactions t " +
                     "JOIN users u ON t.user_id = u.id " +
                     "JOIN books b ON t.book_id = b.id ";

    String whereClause = "";
    boolean isSearchValueValid = (searchValue != null && !searchValue.trim().isEmpty());

    if (isSearchValueValid) {
        switch (searchBy) {
            case "user_id":
                whereClause = " WHERE t.user_id = ?";
                break;
            case "book_id":
                whereClause = " WHERE t.book_id = ?";
                break;
            case "user_name":
                whereClause = " WHERE u.name LIKE ?";
                searchValue = "%" + searchValue + "%";
                break;
            case "book_title":
                whereClause = " WHERE b.title LIKE ?";
                searchValue = "%" + searchValue + "%";
                break;
            default:
                // no filter
        }
    }

    String finalSql = baseSql + whereClause + " ORDER BY t.start_date DESC";

    ps = conn.prepareStatement(finalSql);

    if (isSearchValueValid && (searchBy.equals("user_id") || searchBy.equals("book_id"))) {
        ps.setInt(1, Integer.parseInt(searchValue)); // user_id and book_id are integers
    } else if (isSearchValueValid) {
        ps.setString(1, searchValue);
    }

    rs = ps.executeQuery();
%>

<table>
    <thead>
        <tr>
        	<th>User ID</th>
            <th>User Name</th>
            <th>Book ID</th>
            <th>Book Title</th>
            <th>Transaction Type</th>
            <th>Status</th>
            <th>Start Date</th>
            <th>Due Date</th>
            <th>Fine (₹)</th>
            <th>Paid Fine (₹)</th> <!-- New column -->
            <th>Action</th>
        </tr>
    </thead>
    <tbody>
<%
        boolean hasRows = false;
        while (rs.next()) {
            hasRows = true;
%>
        <tr>
        	<td><%= rs.getString("user_id") %></td>
            <td><%= rs.getString("user_name") %></td>
            <td><%= rs.getString("book_id") %></td>
            <td><%= rs.getString("book_title") %></td>
            <td><%= rs.getString("transaction_type") %></td>
            <td><%= rs.getString("status") %></td>
            <td><%= rs.getDate("start_date") != null ? rs.getDate("start_date") : "" %></td>
            <td><%= rs.getDate("due_date") != null ? rs.getDate("due_date") : "" %></td>
            <td><%= rs.getBigDecimal("fine") != null ? rs.getBigDecimal("fine") : "0.00" %></td>
            <td><%= rs.getBigDecimal("paid_fine") != null ? rs.getBigDecimal("paid_fine") : "0.00" %></td> <!-- Show paid_fine -->
            <td><a class="update-btn" href="TransactionUpdate.jsp?transaction_id=<%= rs.getInt("transaction_id") %>">Update</a></td>
        </tr>
<%
        }
        if (!hasRows) {
%>
        <tr>
            <td colspan="11" style="text-align:center; font-style: italic;">No transactions found.</td>
        </tr>
<%
        }
    } catch (Exception e) {
%>
        <tr><td colspan="11" style="color:red;">Error: <%= e.getMessage() %></td></tr>
<%
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ignored) {}
        if (ps != null) try { ps.close(); } catch (Exception ignored) {}
        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
    }
%>
    </tbody>
</table>

</body>
</html>
