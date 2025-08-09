<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="index.css">
    <script>
        function validateForm() {
            let password = document.getElementById("password").value.trim();
            if (password.length < 4 || password.length > 8) {
                alert("Password must be between 4 and 8 characters.");
                return false;
            }

            let userId = document.querySelector('input[name="userId"]').value.trim();
            if (userId === "") {
                alert("Enter Admission/Employee ID");
                return false;
            }
            return true;
        }

        function setupRoleListener() {
            const roleRadios = document.querySelectorAll('input[name="role"]');
            const idLabel = document.getElementById('idLabel');
            const idInput = document.querySelector('input[name="userId"]');

            roleRadios.forEach(radio => {
                radio.addEventListener('change', function () {
                    if (this.value === "admin") {
                        idLabel.innerHTML = "<b>Employee ID</b>";
                        idInput.placeholder = "Enter Employee ID";
                    } else {
                        idLabel.innerHTML = "<b>Admission ID</b>";
                        idInput.placeholder = "Enter Admission ID";
                    }
                });
            });
        }

        window.onload = setupRoleListener;
    </script>
</head>
<body>
<div class="header">
  <div class="logo-nav">
    <a href="index.jsp">LIBRARY</a>
  </div>

  <ul class="nav-options">
    <li class="option"><a href="index.jsp">Home</a></li>
    <li class="option"><a href="books.jsp">Books</a></li>
    
  </ul>
</div>
<div class="signin-container">
    <div class="signin-card">
        <form action="${pageContext.request.contextPath}/loginServlet" method="post" onsubmit="return validateForm()">
            <h2 class="signin-title">Log in Form</h2>
            <p class="line"></p>

            <div class="persontype-question">
                <p>Select your role:</p>
                <label>
                    <input type="radio" name="role" value="admin" required /> Admin
                </label>
                
                <label>
                    <input type="radio" name="role" value="user" required /> User
                </label>
            </div>

            <% String error = request.getParameter("error");
               if (error != null) { %>
               <div class="error-message"><p><%= error %></p></div>
            <% } %>

            <div class="signin-fields">
                <label id="idLabel"><b>Admission ID</b></label>
                <input class="signin-textbox" type="text" placeholder="Enter Admission ID" name="userId" required />

                <label for="password"><b>Password</b></label>
                <input id="password" class="signin-textbox" type="password" placeholder="Enter Password" name="password" required />
            </div>

            <button type="submit" class="signin-button">Log In</button>
            <a class="forget-pass" href="#">Forgot password?</a>
        </form>

        <div class="signup-option">
            <p class="signup-question">Create User Account: <a href="register.jsp">RegisterUser</a></p>
            
        </div>
    </div>
</div>
</body>
</html>
