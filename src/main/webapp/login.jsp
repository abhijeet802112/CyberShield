<!DOCTYPE html>
<html>
<head>
    <title>CyberShield - Login</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

    <div class="container">
        <h1>CyberShield</h1>
        <h2>Login</h2>

        <form action="login" method="post">
            <input type="email" name="email" placeholder="Enter your email" required>

            <input type="password" name="password" placeholder="Enter your password" required>

            <button type="submit">Login</button>
        </form>

        <p>Don't have an account?
            <a href="register.jsp">Register</a>
        </p>
    </div>

</body>
</html>