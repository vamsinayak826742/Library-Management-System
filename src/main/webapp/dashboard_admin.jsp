<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Check session and redirect if not logged in
    if (session == null || session.getAttribute("Id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="AdminDashboard.css">
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>

<div class="dashboard">
    <div class="dashboard-card">

        <!-- Sidebar -->
        <div class="dashboard-options">
            <div class="dashboard-logo">
                <i class="fas fa-book"></i> LCMS
            </div>
            <a class="dashboard-option" href="AdminUsers.jsp" target="contentFrame">
                <i class="fas fa-user dashboard-option-icon"></i> Users
            </a>
            
            <a class="dashboard-option" href="Adminbooks.jsp" target="contentFrame">
                <i class="fas fa-book-open dashboard-option-icon"></i> Books
            </a>
            
            <a class="dashboard-option" href="AdminTransaction.jsp" target="contentFrame">
                <i class="fas fa-receipt dashboard-option-icon"></i> Transactions
            </a>
            
            <a class="dashboard-option" href="logout.jsp">
                <i class="fas fa-power-off dashboard-option-icon"></i> Logout
            </a>
        </div>

        <!-- Content Area -->
        <div class="dashboard-option-content">
            <iframe name="contentFrame" style="border:none; width:100%; height:100%;"></iframe>
        </div>

    </div>
</div>

</body>
</html>
