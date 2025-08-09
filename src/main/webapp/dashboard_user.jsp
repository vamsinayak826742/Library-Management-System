<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
   
    if (session == null || session.getAttribute("Id") == null || !"user".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    int id = (int) session.getAttribute("Id");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Dashboard</title>
    <link rel="stylesheet" href="AdminDashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body class="dashboard-body">
<div class="dashboard">
    <div class="dashboard-card">
        <div class="dashboard-options">
            <div class="dashboard-logo">
                <i class="fas fa-book" style="font-size: 50px;"></i>
                <p class="logo-name">LCMS</p>
            </div>
            
            <a class="dashboard-option" href="profile.jsp" target="contentFrame">
                <i class="fas fa-book-reader dashboard-option-icon"></i> Profile
            </a>
            <a class="dashboard-option" href="userBooks.jsp" target="contentFrame">
                <i class="fas fa-book-reader dashboard-option-icon"></i> Books
            </a>
            <a class="dashboard-option" href="activeBooks.jsp" target="contentFrame">
                <i class="fas fa-book-reader dashboard-option-icon"></i> Active
            </a>
            
            <a class="dashboard-option" href="return.jsp" target="contentFrame">
                <i class="fas fa-history dashboard-option-icon"></i> Return
            </a>
            <a class="dashboard-option" href="history.jsp" target="contentFrame">
                <i class="fas fa-history dashboard-option-icon"></i> History
            </a>
            <a class="dashboard-option" href="logout.jsp">
                <i class="fas fa-sign-out-alt dashboard-option-icon"></i> Logout
            </a>
        </div>

        <div class="dashboard-option-content">
            <div class="user-details-topbar">
                <!-- you can add user info here if needed -->
            </div>
            <iframe name="contentFrame" style="border:none; width:100%; height:calc(100% - 70px);"></iframe>
        </div>
    </div>
</div>
</body>
</html>
