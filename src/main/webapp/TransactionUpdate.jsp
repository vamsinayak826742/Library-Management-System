<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session == null || session.getAttribute("Id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String transactionIdStr = request.getParameter("transaction_id");
    if (transactionIdStr == null) {
        response.sendRedirect("AdminTransaction.jsp");
        return;
    }

    int transactionId = 0;
    try {
        transactionId = Integer.parseInt(transactionIdStr);
    } catch (NumberFormatException e) {
        response.sendRedirect("AdminTransaction.jsp");
        return;
    }

    String message = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String status = request.getParameter("status");
        String fineStr = request.getParameter("fine");
        String paidFineStr = request.getParameter("paid_fine");

        java.math.BigDecimal fine = null;
        java.math.BigDecimal paidFine = null;

        try {
            fine = new java.math.BigDecimal(fineStr);
        } catch (Exception e) {
            fine = new java.math.BigDecimal("0.00");
        }

        try {
            paidFine = new java.math.BigDecimal(paidFineStr);
        } catch (Exception e) {
            paidFine = new java.math.BigDecimal("0.00");
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/LMS", "Vamsi", "Vamsi@826742")) {
                PreparedStatement ps = conn.prepareStatement("UPDATE transactions SET status = ?, fine = ?, paid_fine = ? WHERE transaction_id = ?");
                ps.setString(1, status);
                ps.setBigDecimal(2, fine);
                ps.setBigDecimal(3, paidFine);
                ps.setInt(4, transactionId);

                int updated = ps.executeUpdate();
                if (updated > 0) {
                    response.sendRedirect("AdminTransaction.jsp?msg=Transaction+updated+successfully");
                    return;
                } else {
                    message = "Update failed.";
                }
            }
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        }
    }

    // Load transaction details for display in form
    String userName = "";
    String bookTitle = "";
    String transactionType = "";
    String status = "";
    java.math.BigDecimal fine = new java.math.BigDecimal("0.00");
    java.math.BigDecimal paidFine = new java.math.BigDecimal("0.00");
    Date startDate = null;
    Date dueDate = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/LMS", "Vamsi", "Vamsi@826742")) {
            PreparedStatement ps = conn.prepareStatement(
                "SELECT t.transaction_id, u.name AS user_name, b.title AS book_title, t.transaction_type, t.status, t.fine, t.paid_fine, t.start_date, t.due_date " +
                "FROM transactions t " +
                "JOIN users u ON t.user_id = u.id " +
                "JOIN books b ON t.book_id = b.id " +
                "WHERE t.transaction_id = ?");
            ps.setInt(1, transactionId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                userName = rs.getString("user_name");
                bookTitle = rs.getString("book_title");
                transactionType = rs.getString("transaction_type");
                status = rs.getString("status");
                fine = rs.getBigDecimal("fine") != null ? rs.getBigDecimal("fine") : new java.math.BigDecimal("0.00");
                paidFine = rs.getBigDecimal("paid_fine") != null ? rs.getBigDecimal("paid_fine") : new java.math.BigDecimal("0.00");
                startDate = rs.getDate("start_date");
                dueDate = rs.getDate("due_date");
            } else {
                response.sendRedirect("AdminTransaction.jsp?msg=Transaction+not+found");
                return;
            }
            rs.close();
        }
    } catch (Exception e) {
        message = "Error loading transaction: " + e.getMessage();
    }
%>

<html>
<head>
    <title>Update Transaction</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        form { max-width: 400px; margin: auto; }
        label { display: block; margin-top: 10px; }
        input[type="text"], select {
            width: 100%;
            padding: 8px;
            margin-top: 4px;
            box-sizing: border-box;
        }
        .btn {
            margin-top: 20px;
            padding: 10px;
            background-color: #27ae60;
            color: white;
            border: none;
            cursor: pointer;
            width: 100%;
            border-radius: 4px;
            font-size: 16px;
        }
        .btn:hover {
            background-color: #1e8449;
        }
        .message {
            margin-bottom: 15px;
            color: red;
        }
        .info {
            margin-top: 15px;
            font-style: italic;
            background: #fafafa;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        a.back-link {
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
            color: #3498db;
        }
        a.back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<h2>Update Transaction</h2>

<% if (message != null) { %>
    <div class="message"><%= message %></div>
<% } %>

<form method="post" action="TransactionUpdate.jsp?transaction_id=<%= transactionId %>">
    <div class="info">
        <strong>User:</strong> <%= userName %><br>
        <strong>Book:</strong> <%= bookTitle %><br>
        <strong>Transaction Type:</strong> <%= transactionType %><br>
        <strong>Start Date:</strong> <%= startDate != null ? startDate.toString() : "" %><br>
        <strong>Due Date:</strong> <%= dueDate != null ? dueDate.toString() : "" %>
    </div>

    <label for="status">Status:</label>
    <select name="status" id="status" required>
        <option value="active" <%= "active".equalsIgnoreCase(status) ? "selected" : "" %>>Active</option>
        <option value="returned" <%= "returned".equalsIgnoreCase(status) ? "selected" : "" %>>Returned</option>
    </select>

    <label for="fine">Fine (₹):</label>
    <input type="text" name="fine" id="fine" value="<%= fine %>" pattern="^\d+(\.\d{1,2})?$" title="Enter a valid fine amount" required>

    <label for="paid_fine">Paid Fine (₹):</label>
    <input type="text" name="paid_fine" id="paid_fine" value="<%= paidFine %>" pattern="^\d+(\.\d{1,2})?$" title="Enter a valid paid fine amount" required>

    <button type="submit" class="btn">Update</button>
</form>

<a href="AdminTransaction.jsp" class="back-link">Back to Transactions</a>

</body>
</html>
