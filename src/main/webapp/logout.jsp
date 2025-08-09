<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%
    // Invalidate the session to logout the user
    if (session != null) {
        session.invalidate();
    }
    // Redirect to login page after logout
    response.sendRedirect("login.jsp");
%>
