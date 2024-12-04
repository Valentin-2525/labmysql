<?php
// Configuración de conexión a la base de datos
$servername = "localhost"; // Cambia a la dirección de tu servidor
$username = "user";        // Usuario de la base de datos
$password = "password";            // Contraseña de la base de datos
$dbname = "base1"; // Nombre de tu base de datos

// Crear la conexión
$conn = new mysqli($servername, $username, $password, $dbname);

// Verificar conexión
if ($conn->connect_error) {
    die("Error de conexión: " . $conn->connect_error);
}

// Procesar el formulario cuando se envía
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $usuario = $_POST['username'];
    $clave = $_POST['password'];

    // Validar que los campos no estén vacíos
    if (empty($usuario) || empty($clave)) {
        echo "Por favor, complete ambos campos.";
    } else {
        // Consultar la base de datos para el usuario
        $stmt = $conn->prepare("SELECT id, password FROM usuarios WHERE username = ?");
        $stmt->bind_param("s", $usuario);
        $stmt->execute();
        $stmt->store_result();

        // Verificar si el usuario existe
        if ($stmt->num_rows > 0) {
            $stmt->bind_result($id, $hashed_password);
            $stmt->fetch();

            // Verificar la contraseña
            if (password_verify($clave, $hashed_password)) {
                // Inicio de sesión exitoso
                session_start();
                $_SESSION['user_id'] = $id;
                echo "Inicio de sesión exitoso. ¡Bienvenido, $usuario!";
                // Redirigir a otra página
                header("Location: dashboard.php");
                exit;
            } else {
                echo "Contraseña incorrecta.";
            }
        } else {
            echo "Nombre de usuario no encontrado.";
        }

        $stmt->close();
    }
}

$conn->close();
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
</head>
<body>
    <h2>Login</h2>
    <form method="POST" action="">
        <label for="username">Usuario:</label>
        <input type="text" name="username" id="username" required>
        <br>
        <label for="password">Contraseña:</label>
        <input type="password" name="password" id="password" required>
        <br>
        <button type="submit">Iniciar Sesión</button>
    </form>
</body>
</html>
