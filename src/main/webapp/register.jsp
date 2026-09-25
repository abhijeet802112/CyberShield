<!DOCTYPE html>
<html>
<head>
    <title>CyberShield - Registration</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

    <div class="container">
        <h1>CyberShield</h1>
        <h2>Create Account</h2>

        <form action="register" method="post">
            <input type="text" name="name" placeholder="Enter your name" required>

            <input type="email" name="email" placeholder="Enter your email" required>

            <input type="password" name="password" placeholder="Enter your password" required>

            <button type="submit">Register</button>
        </form>

        <p>Already have an account?
            <a href="login.jsp">Login</a>
        </p>
    </div>

</body>
</html>