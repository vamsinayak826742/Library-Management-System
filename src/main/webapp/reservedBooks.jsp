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
    <title>Reserved Books</title>
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
    Integer userId = (Integer) session.getAttribute("Id");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/LMS", "Vamsi", "Vamsi@826742");

        String sql = "SELECT t.transaction_id, b.title, t.start_date " +
                     "FROM transactions t " +
                     "JOIN books b ON t.book_id = b.id " +
                     "WHERE t.user_id = ? AND t.transaction_type = 'reserved' AND t.status = 'active'";

        ps = conn.prepareStatement(sql);
        ps.setInt(1, userId);
        rs = ps.executeQuery();

        out.println("<h3>Reserved Books for User ID: " + userId + "</h3>");
        out.println("<table>");
        out.println("<tr><th>S.No</th><th>Book Name</th><th>Reserved Date</th></tr>");

        int count = 0;

        while (rs.next()) {
            count++;
            String title = rs.getString("title");
            java.sql.Date reservedDate = rs.getDate("start_date");

            out.println("<tr>");
            out.println("<td>" + count + "</td>");
            out.println("<td>" + title + "</td>");
            out.println("<td>" + reservedDate + "</td>");
            out.println("</tr>");
        }

        if (count == 0) {
            out.println("<tr><td colspan='3' class='no-data'>No active reserved books found.</td></tr>");
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
