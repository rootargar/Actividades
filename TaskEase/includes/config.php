<?php
/**
 * Archivo de Configuración General
 * TaskEase - Sistema de Gestión de Tareas
 */

// Configuración de errores (cambiar en producción)
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Configuración de sesión segura
ini_set('session.cookie_httponly', 1);
ini_set('session.use_only_cookies', 1);
ini_set('session.cookie_secure', 0); // Cambiar a 1 si usas HTTPS

// Información de la aplicación
define('APP_NAME', 'TaskEase Pro');
define('APP_VERSION', '2.0');
define('APP_URL', 'http://localhost/TaskEase');

// Configuración de archivos adjuntos
define('UPLOAD_DIR', __DIR__ . '/../uploads/');
define('MAX_FILE_SIZE', 10 * 1024 * 1024); // 10MB
define('ALLOWED_EXTENSIONS', array('pdf', 'doc', 'docx', 'xls', 'xlsx', 'png', 'jpg', 'jpeg', 'gif', 'txt', 'zip'));

// Configuración de email (para notificaciones)
define('SMTP_HOST', 'smtp.gmail.com');
define('SMTP_PORT', 587);
define('SMTP_USERNAME', 'tu_email@gmail.com');
define('SMTP_PASSWORD', 'tu_contraseña_app');
define('SMTP_FROM_EMAIL', 'noreply@taskease.com');
define('SMTP_FROM_NAME', 'TaskEase Notificaciones');

// Configuración de paginación
define('ITEMS_PER_PAGE', 20);

// Roles del sistema
define('ROLE_ADMIN', 1);
define('ROLE_SUPERVISOR', 2);
define('ROLE_COLABORADOR', 3);

// Estados de tareas
define('STATUS_PENDIENTE', 1);
define('STATUS_EN_PROCESO', 2);
define('STATUS_EN_REVISION', 3);
define('STATUS_BLOQUEADO', 4);
define('STATUS_COMPLETADO', 5);

// Prioridades
define('PRIORITY_BAJA', 1);
define('PRIORITY_MEDIA', 2);
define('PRIORITY_ALTA', 3);
define('PRIORITY_URGENTE', 4);

// Zona horaria
date_default_timezone_set('America/Mexico_City');

// Incluir archivo de conexión
require_once __DIR__ . '/conexion.php';
?>
