<?php
/**
 * Cerrar Sesión
 * TaskEase - Sistema de Gestión de Tareas
 */

session_start();

// Limpiar todas las variables de sesión
$_SESSION = array();

// Destruir la sesión
if (ini_get("session.use_cookies")) {
    $params = session_get_cookie_params();
    setcookie(session_name(), '', time() - 42000,
        $params["path"], $params["domain"],
        $params["secure"], $params["httponly"]
    );
}

session_destroy();

// Redirigir al login
header('Location: login.php');
exit();
?>