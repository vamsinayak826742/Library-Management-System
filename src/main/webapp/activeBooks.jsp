<%@ page import="java.sql.*, java.time.*, java.time.temporal.ChronoUnit" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Active Borrowed Books</title>
    <style>
        table { border-collapse: collapse; width: 80%; margin: 20px auto; }
        th, td { border: 1px solid #ccc; padding: 8px 12px; text-align: left; }
        th { background-color: #f2f2f2; }
        h3 { text-align: center; margin-top: 20px; }
        .no-data { text-align: center; padding: 20px; font-style: italic; color: #555; }
    </style>
</head>
<body>
<%
    // Validate session and get user ID safely
    Integer userIdObj = (Integer) session.getAttribute("Id");
    if (userIdObj == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int userId = userIdObj.intValue();

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/LMS", "Vamsi", "Vamsi@826742");

        String sql = "SELECT t.transaction_id, b.title, t.start_date, t.due_date, t.fine " +
                     "FROM transactions t " +
                     "JOIN books b ON t.book_id = b.id " +
                     "WHERE t.user_id = ? AND t.transaction_type = 'borrowed' AND t.status = 'active'";

        ps = conn.prepareStatement(sql);
        ps.setInt(1, userId);
        rs = ps.executeQuery();

        out.println("<h3>Active Borrowed Books for User ID: " + userId + "</h3>");
        out.println("<table>");
        out.println("<tr><th>S.No</th><th>Book Name</th><th>Borrow Date</th><th>Due Date</th><th>Fine (₹)</th></tr>");

        int count = 0;
        LocalDate today = LocalDate.now();

        while (rs.next()) {
            count++;
            String title = rs.getString("title");

            Date startDateSQL = rs.getDate("start_date");
            LocalDate borrowDate = startDateSQL != null ? startDateSQL.toLocalDate() : null;

            Date dueDateSQL = rs.getDate("due_date");
            LocalDate dueDate = dueDateSQL != null ? dueDateSQL.toLocalDate() : null;

            double fine = 0.0;
            if (dueDate != null) {
                long daysOverdue = ChronoUnit.DAYS.between(dueDate, today);
                fine = daysOverdue > 0 ? daysOverdue * 1.0 : 0.0;
            }

            out.println("<tr>");
            out.println("<td>" + count + "</td>");
            out.println("<td>" + title + "</td>");
            out.println("<td>" + (borrowDate != null ? borrowDate : "-") + "</td>");
            out.println("<td>" + (dueDate != null ? dueDate : "-") + "</td>");
            out.println("<td>" + fine + "</td>");
            out.println("</tr>");
        }

        if (count == 0) {
            out.println("<tr><td colspan='5' class='no-data'>No active borrowed books found.</td></tr>");
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
</body>
</html>
