<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>User Registration</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="index.css">

    <script>
        function validateForm() {
            let password = document.getElementById("password").value.trim();
            if (password.length < 4 || password.length > 8) {
                alert("Password must be between 4 and 8 characters.");
                return false; // Stop form submit
            }
            return true;
        }
    </script>
    
    <style>
        .signin-container {
          display: grid;
          place-items: center;
          height: 100vh;
          background-color: wheat;
        }
        a { text-decoration: none; }
        .signin-card {
          font-family: sans-serif;
          width: 100%;
          max-width: 350px;
          margin: auto;
          border-radius: 10px;
          background-color: #fff;
          box-shadow: 2px 5px 20px rgba(0, 0, 0, 0.1);
        }
        form { padding: 30px; }
        .signin-title { text-align: center; font-weight: bold; }
        .signin-fields { display: flex; flex-direction: column; }
        .signin-fields label { color: rgb(170 166 166); margin-top: 25px; }
        .signin-textbox {
          padding: 15px 20px;
          margin-top: 8px;
          margin-bottom: 15px;
          border: 1px solid #ccc;
          border-radius: 8px;
          outline: none;
        }
        .signin-button {
          background-color: rgb(69, 69, 185);
          color: white;
          padding: 18px 20px;
          margin-top: 25px;
          width: 100%;
          border-radius: 10px;
          border: none;
        }
    </style>
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
        <h2 class="signin-title">User Register Form</h2>
        <form action="RegisterServlet" method="post" onsubmit="return validateForm()">
            <div class="signin-fields">
                <label>Name</label>
                <input type="text" name="name" class="signin-textbox" required>

                <label>Email</label>
                <input type="email" name="email" class="signin-textbox" required>

                <label>Password</label>
                <input type="password" id="password" name="password" class="signin-textbox" required>

                <label>Role</label>
                <input type="text" name="Role" class="signin-textbox" value="user" readonly>

                <button type="submit" class="signin-button">Register</button>
            </div>
            <div class="signup-option">
            	<p class="signup-question">Login: <a href="login.jsp">Login</a></p>
           	 	
        	</div>
        </form>
    </div>
</div>
</body>
</html>
