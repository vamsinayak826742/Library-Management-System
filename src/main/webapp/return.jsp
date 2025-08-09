<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="java.time.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Session check
    if (session == null || session.getAttribute("Id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    Integer userId = (Integer) session.getAttribute("Id");

    String message = null;

    // Handle return form submission
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String transactionIdStr = request.getParameter("transactionId");
        if (transactionIdStr != null) {
            int transactionId = Integer.parseInt(transactionIdStr);

            Connection conn = null;
            PreparedStatement psSelect = null;
            PreparedStatement psUpdate = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/LMS", "Vamsi", "Vamsi@826742");
                conn.setAutoCommit(false);

                // Lock and get current fine and paid_fine
                psSelect = conn.prepareStatement("SELECT fine, paid_fine FROM transactions WHERE transaction_id = ? FOR UPDATE");
                psSelect.setInt(1, transactionId);
                rs = psSelect.executeQuery();

                if (rs.next()) {
                    double fine = rs.getDouble("fine");
                    double paidFine = rs.getDouble("paid_fine");
                    rs.close();
                    psSelect.close();

                    double updatedPaidFine = paidFine + fine;

                    // Update fine = 0, paid_fine = paid_fine + fine, status = 'returned'
                    psUpdate = conn.prepareStatement(
                        "UPDATE transactions SET fine = 0, paid_fine = ?, status = 'returned' WHERE transaction_id = ?"
                    );
                    psUpdate.setDouble(1, updatedPaidFine);
                    psUpdate.setInt(2, transactionId);
                    int updated = psUpdate.executeUpdate();

                    if (updated > 0) {
                        conn.commit();
                        message = "Book returned successfully.";
                    } else {
                        conn.rollback();
                        message = "Failed to update transaction.";
                    }
                } else {
                    message = "Transaction not found.";
                }
            } catch (Exception e) {
                message = "Error: " + e.getMessage();
                if (conn != null) try { conn.rollback(); } catch (SQLException ignored) {}
            } finally {
                try { if (rs != null) rs.close(); } catch (Exception ignored) {}
                try { if (psSelect != null) psSelect.close(); } catch (Exception ignored) {}
                try { if (psUpdate != null) psUpdate.close(); } catch (Exception ignored) {}
                try { if (conn != null) conn.close(); } catch (Exception ignored) {}
            }
        }
    }
%>

<html>
<head>
    <title>Return Books</title>
    <style>
        table { border-collapse: collapse; width: 90%; margin: 20px auto; }
        th, td { border: 1px solid #ccc; padding: 8px 12px; text-align: left; }
        th { background-color: #f2f2f2; }
        h3 { text-align: center; margin-top: 20px; }
        .no-data { text-align: center; padding: 20px; font-style: italic; color: #555; }
        button.return-btn {
            padding: 10px 18px;
            background-color: #4CAF50;
            color: white;
            border: none;
            cursor: pointer;
            border-radius: 4px;
            font-size: 16px;
            font-weight: bold;
        }
        button.return-btn:hover {
            background-color: #45a049;
        }
        .message {
            text-align: center;
            font-weight: bold;
            color: green;
            margin-top: 10px;
        }
    </style>
    <script>
        function handleReturn(transactionId, fine) {
            if (fine > 0) {
                if (confirm("You have a fine of ₹" + fine.toFixed(2) + ". Please pay fine to proceed.")) {
                    document.getElementById('transactionId').value = transactionId;
                    document.getElementById('returnForm').submit();
                }
            } else {
                if (confirm("Are you sure you want to return this book?")) {
                    document.getElementById('transactionId').value = transactionId;
                    document.getElementById('returnForm').submit();
                }
            }
        }
    </script>
</head>
<body>

<% if (message != null) { %>
    <p class="message"><%= message %></p>
<% } %>

<h3>Books to Return for User ID: <%= userId %></h3>

<%
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/LMS", "Vamsi", "Vamsi@826742");

        String sql = "SELECT t.transaction_id, b.title, t.transaction_type, t.start_date, t.due_date, t.fine " +
                     "FROM transactions t " +
                     "JOIN books b ON t.book_id = b.id " +
                     "WHERE t.user_id = ? AND t.status = 'active'";

        ps = conn.prepareStatement(sql);
        ps.setInt(1, userId);
        rs = ps.executeQuery();

        out.println("<table>");
        out.println("<tr><th>S.No</th><th>Book Name</th><th>Type</th><th>Start Date</th><th>Due Date</th><th>Fine (₹)</th><th>Return</th></tr>");

        int count = 0;
        while (rs.next()) {
            count++;
            int transactionId = rs.getInt("transaction_id");
            String title = rs.getString("title");
            String type = rs.getString("transaction_type");
            java.sql.Date startDate = rs.getDate("start_date");
            java.sql.Date dueDate = rs.getDate("due_date");
            double fine = rs.getDouble("fine");

            out.println("<tr>");
            out.println("<td>" + count + "</td>");
            out.println("<td>" + title + "</td>");
            out.println("<td>" + type + "</td>");
            out.println("<td>" + startDate + "</td>");
            out.println("<td>" + (dueDate != null ? dueDate.toString() : "-") + "</td>");
            out.println("<td>" + String.format("%.2f", fine) + "</td>");
            out.println("<td><button class='return-btn' onclick='handleReturn(" + transactionId + ", " + fine + ")'>Return</button></td>");
            out.println("</tr>");
        }

        if (count == 0) {
            out.println("<tr><td colspan='7' class='no-data'>No borrowed or reserved books to return.</td></tr>");
        }
        out.println("</table>");

    } catch (Exception e) {
        out.println("<p class='no-data'>Error: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ignored) {}
        if (ps != null) try { ps.close(); } catch (Exception ignored) {}
        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
    }
%>

<!-- Hidden form to submit return request -->
<form id="returnForm" method="post" action="return.jsp" style="display:none;">
    <input type="hidden" id="transactionId" name="transactionId" value="" />
</form>

</body>
</html>
