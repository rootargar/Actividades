<?php
/**
 * Página de Login
 * TaskEase - Sistema de Gestión de Tareas
 */

require_once 'includes/config.php';
require_once 'includes/functions.php';

// Si ya está logueado, redirigir al dashboard
if (isLoggedIn()) {
    if (isAdmin() || isSupervisor()) {
        redirect('admin/dashboard.php');
    } else {
        redirect('user/dashboard.php');
    }
}

$error = '';

// Procesar formulario de login
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $email = sanitize($_POST['email'] ?? '');
    $password = $_POST['password'] ?? '';

    if (empty($email) || empty($password)) {
        $error = 'Por favor complete todos los campos';
    } else if (!validateEmail($email)) {
        $error = 'Email inválido';
    } else {
        // Buscar usuario en la base de datos
        $sql = "SELECT u.*, r.role_name
                FROM users u
                INNER JOIN roles r ON u.role_id = r.role_id
                WHERE u.email = ? AND u.is_active = 1";

        $user = fetchOne($sql, array($email));

        if ($user && verifyPassword($password, $user['password_hash'])) {
            // Login exitoso
            $_SESSION['user_id'] = $user['user_id'];
            $_SESSION['username'] = $user['username'];
            $_SESSION['email'] = $user['email'];
            $_SESSION['full_name'] = $user['full_name'];
            $_SESSION['role_id'] = $user['role_id'];
            $_SESSION['role_name'] = $user['role_name'];
            $_SESSION['department_id'] = $user['department_id'];

            // Actualizar último login
            $update_sql = "UPDATE users SET last_login = GETDATE() WHERE user_id = ?";
            executeQuery($update_sql, array($user['user_id']));

            // Redirigir según rol
            if ($user['role_id'] == ROLE_ADMIN || $user['role_id'] == ROLE_SUPERVISOR) {
                redirect('admin/dashboard.php');
            } else {
                redirect('user/dashboard.php');
            }
        } else {
            $error = 'Email o contraseña incorrectos';
        }
    }
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - <?php echo APP_NAME; ?></title>
    <link rel="stylesheet" type="text/css" href="bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="css/styles.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .login-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            overflow: hidden;
            max-width: 900px;
            width: 90%;
        }
        .login-left {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 50px;
            text-align: center;
        }
        .login-left h1 {
            font-size: 2.5em;
            margin-bottom: 20px;
            font-weight: bold;
        }
        .login-left p {
            font-size: 1.1em;
            opacity: 0.9;
        }
        .login-right {
            padding: 50px;
        }
        .login-right h2 {
            color: #333;
            margin-bottom: 30px;
        }
        .form-control {
            border-radius: 8px;
            padding: 12px;
            border: 1px solid #ddd;
        }
        .btn-login {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 8px;
            padding: 12px;
            color: white;
            font-weight: bold;
            width: 100%;
            margin-top: 20px;
            transition: transform 0.2s;
        }
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
        }
        .alert {
            border-radius: 8px;
        }
        .icon-large {
            font-size: 5em;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="login-container row">
        <div class="col-md-5 login-left">
            <div class="icon-large">📋</div>
            <h1><?php echo APP_NAME; ?></h1>
            <p>Sistema de Gestión de Tareas y Proyectos</p>
            <p style="margin-top: 30px; font-size: 0.9em;">
                Organiza tus proyectos, asigna tareas, realiza seguimiento del progreso y colabora con tu equipo de manera eficiente.
            </p>
        </div>
        <div class="col-md-7 login-right">
            <h2>Iniciar Sesión</h2>

            <?php if (!empty($error)): ?>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <?php echo htmlspecialchars($error); ?>
                    <button type="button" class="close" data-dismiss="alert">
                        <span>&times;</span>
                    </button>
                </div>
            <?php endif; ?>

            <form method="POST" action="">
                <div class="form-group">
                    <label for="email">Correo Electrónico</label>
                    <input type="email" class="form-control" id="email" name="email"
                           placeholder="ejemplo@correo.com" required
                           value="<?php echo isset($_POST['email']) ? htmlspecialchars($_POST['email']) : ''; ?>">
                </div>

                <div class="form-group">
                    <label for="password">Contraseña</label>
                    <input type="password" class="form-control" id="password" name="password"
                           placeholder="********" required>
                </div>

                <div class="form-check">
                    <input type="checkbox" class="form-check-input" id="remember">
                    <label class="form-check-label" for="remember">
                        Recordar mi sesión
                    </label>
                </div>

                <button type="submit" class="btn btn-login">Iniciar Sesión</button>
            </form>

            <hr style="margin: 30px 0;">

            <div class="text-center">
                <small class="text-muted">
                    <strong>Usuarios de prueba:</strong><br>
                    Admin: admin@taskease.com / Admin123<br>
                    Supervisor: supervisor@taskease.com / Admin123<br>
                    Colaborador: colaborador1@taskease.com / Admin123
                </small>
            </div>
        </div>
    </div>

    <script src="includes/jquery_latest.js"></script>
    <script src="bootstrap/js/bootstrap.min.js"></script>
</body>
</html>
