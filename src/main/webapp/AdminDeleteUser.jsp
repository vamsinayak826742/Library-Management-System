<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check session and redirect if not logged in
    if (session == null || session.getAttribute("Id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<%
    String idStr = request.getParameter("id");
    if (idStr == null) {
        response.sendRedirect("Users.jsp");
        return;
    }
    int id = Integer.parseInt(idStr);

    Connection conn = null;
    PreparedStatement ps = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/LMS", "Vamsi", "Vamsi@826742");

        String sql = "DELETE FROM users WHERE id = ?";
        ps = conn.prepareStatement(sql);
        ps.setInt(1, id);

        int deleted = ps.executeUpdate();
        if (deleted > 0) {
        	 response.sendRedirect("AdminUsers.jsp");
        } else {
        	response.sendRedirect("AdminUsers.jsp");
        }
    } catch (Exception e) {
        response.sendRedirect("Users.jsp?msg=Error+occurred:+ " + e.getMessage());
    } finally {
        if (ps != null) try { ps.close(); } catch (Exception ignored) {}
        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
    }
%>
