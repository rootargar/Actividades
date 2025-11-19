<?php
/**
 * Funciones Auxiliares del Sistema
 * TaskEase - Sistema de Gestión de Tareas
 */

/**
 * Verifica si el usuario está autenticado
 * @return bool
 */
function isLoggedIn() {
    return isset($_SESSION['user_id']) && !empty($_SESSION['user_id']);
}

/**
 * Verifica si el usuario tiene un rol específico
 * @param int $role_id ID del rol
 * @return bool
 */
function hasRole($role_id) {
    return isset($_SESSION['role_id']) && $_SESSION['role_id'] == $role_id;
}

/**
 * Verifica si el usuario es administrador
 * @return bool
 */
function isAdmin() {
    return hasRole(ROLE_ADMIN);
}

/**
 * Verifica si el usuario es supervisor
 * @return bool
 */
function isSupervisor() {
    return hasRole(ROLE_SUPERVISOR);
}

/**
 * Verifica si el usuario es colaborador
 * @return bool
 */
function isColaborador() {
    return hasRole(ROLE_COLABORADOR);
}

/**
 * Redirige a una página específica
 * @param string $url URL de destino
 */
function redirect($url) {
    header("Location: " . $url);
    exit();
}

/**
 * Verifica autenticación y redirige si no está logueado
 * @param string $redirect_url URL de redirección
 */
function requireLogin($redirect_url = 'index.php') {
    if (!isLoggedIn()) {
        redirect($redirect_url);
    }
}

/**
 * Verifica que el usuario tenga un rol específico
 * @param int $required_role ID del rol requerido
 * @param string $redirect_url URL de redirección
 */
function requireRole($required_role, $redirect_url = 'index.php') {
    requireLogin();
    if (!hasRole($required_role)) {
        redirect($redirect_url);
    }
}

/**
 * Verifica que el usuario sea administrador
 * @param string $redirect_url URL de redirección
 */
function requireAdmin($redirect_url = '../index.php') {
    requireRole(ROLE_ADMIN, $redirect_url);
}

/**
 * Formatea una fecha para mostrar
 * @param string $date Fecha a formatear
 * @param string $format Formato de salida
 * @return string Fecha formateada
 */
function formatDate($date, $format = 'd/m/Y') {
    if (empty($date) || $date == '0000-00-00' || $date == null) {
        return '-';
    }
    return date($format, strtotime($date));
}

/**
 * Formatea una fecha y hora para mostrar
 * @param string $datetime Fecha/hora a formatear
 * @return string Fecha/hora formateada
 */
function formatDateTime($datetime) {
    if (empty($datetime)) {
        return '-';
    }
    return date('d/m/Y H:i', strtotime($datetime));
}

/**
 * Calcula días restantes hasta una fecha
 * @param string $date Fecha objetivo
 * @return int Días restantes (negativo si ya pasó)
 */
function daysUntil($date) {
    $today = new DateTime();
    $target = new DateTime($date);
    $interval = $today->diff($target);
    return ($interval->invert) ? -$interval->days : $interval->days;
}

/**
 * Obtiene el estado de urgencia de una tarea
 * @param string $due_date Fecha de vencimiento
 * @param string $status_name Nombre del estado
 * @return string Clase CSS de urgencia
 */
function getUrgencyClass($due_date, $status_name) {
    if ($status_name == 'Completado') {
        return 'success';
    }

    $days = daysUntil($due_date);

    if ($days < 0) {
        return 'danger'; // Vencida
    } elseif ($days <= 2) {
        return 'warning'; // Próxima a vencer
    } else {
        return 'info'; // Normal
    }
}

/**
 * Genera un mensaje de alerta (flash message)
 * @param string $message Mensaje
 * @param string $type Tipo: success, danger, warning, info
 */
function setAlert($message, $type = 'info') {
    $_SESSION['alert'] = array(
        'message' => $message,
        'type' => $type
    );
}

/**
 * Muestra y limpia el mensaje de alerta
 * @return string HTML del mensaje de alerta
 */
function displayAlert() {
    if (isset($_SESSION['alert'])) {
        $alert = $_SESSION['alert'];
        unset($_SESSION['alert']);

        return '<div class="alert alert-' . $alert['type'] . ' alert-dismissible fade show" role="alert">
                ' . htmlspecialchars($alert['message']) . '
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>';
    }
    return '';
}

/**
 * Sube un archivo al servidor
 * @param array $file Archivo ($_FILES['nombre'])
 * @param string $destination Carpeta de destino
 * @return array Array con 'success' y 'filename' o 'error'
 */
function uploadFile($file, $destination = null) {
    if ($destination === null) {
        $destination = UPLOAD_DIR;
    }

    // Verificar errores
    if ($file['error'] !== UPLOAD_ERR_OK) {
        return array('success' => false, 'error' => 'Error al subir el archivo');
    }

    // Verificar tamaño
    if ($file['size'] > MAX_FILE_SIZE) {
        return array('success' => false, 'error' => 'El archivo es demasiado grande (máx: ' . (MAX_FILE_SIZE / 1024 / 1024) . 'MB)');
    }

    // Verificar extensión
    $extension = strtolower(pathinfo($file['name'], PATHINFO_EXTENSION));
    if (!in_array($extension, ALLOWED_EXTENSIONS)) {
        return array('success' => false, 'error' => 'Tipo de archivo no permitido');
    }

    // Generar nombre único
    $filename = uniqid() . '_' . time() . '.' . $extension;
    $filepath = $destination . $filename;

    // Crear directorio si no existe
    if (!file_exists($destination)) {
        mkdir($destination, 0777, true);
    }

    // Mover archivo
    if (move_uploaded_file($file['tmp_name'], $filepath)) {
        return array(
            'success' => true,
            'filename' => $filename,
            'filepath' => $filepath,
            'size' => $file['size'],
            'type' => $file['type']
        );
    } else {
        return array('success' => false, 'error' => 'No se pudo guardar el archivo');
    }
}

/**
 * Elimina un archivo del servidor
 * @param string $filename Nombre del archivo
 * @param string $directory Directorio donde está el archivo
 * @return bool True si se eliminó correctamente
 */
function deleteFile($filename, $directory = null) {
    if ($directory === null) {
        $directory = UPLOAD_DIR;
    }

    $filepath = $directory . $filename;

    if (file_exists($filepath)) {
        return unlink($filepath);
    }

    return false;
}

/**
 * Formatea el tamaño de un archivo
 * @param int $bytes Tamaño en bytes
 * @return string Tamaño formateado
 */
function formatFileSize($bytes) {
    if ($bytes >= 1073741824) {
        return number_format($bytes / 1073741824, 2) . ' GB';
    } elseif ($bytes >= 1048576) {
        return number_format($bytes / 1048576, 2) . ' MB';
    } elseif ($bytes >= 1024) {
        return number_format($bytes / 1024, 2) . ' KB';
    } else {
        return $bytes . ' bytes';
    }
}

/**
 * Trunca un texto a una longitud específica
 * @param string $text Texto a truncar
 * @param int $length Longitud máxima
 * @param string $suffix Sufijo (ej: ...)
 * @return string Texto truncado
 */
function truncate($text, $length = 100, $suffix = '...') {
    if (strlen($text) <= $length) {
        return $text;
    }

    return substr($text, 0, $length) . $suffix;
}

/**
 * Genera un token CSRF único para formularios
 * @return string Token CSRF
 */
function generateCSRFToken() {
    if (!isset($_SESSION['csrf_token'])) {
        $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
    }
    return $_SESSION['csrf_token'];
}

/**
 * Verifica un token CSRF
 * @param string $token Token a verificar
 * @return bool True si es válido
 */
function verifyCSRFToken($token) {
    return isset($_SESSION['csrf_token']) && hash_equals($_SESSION['csrf_token'], $token);
}

/**
 * Obtiene el nombre del rol
 * @param int $role_id ID del rol
 * @return string Nombre del rol
 */
function getRoleName($role_id) {
    $roles = array(
        ROLE_ADMIN => 'Administrador',
        ROLE_SUPERVISOR => 'Supervisor',
        ROLE_COLABORADOR => 'Colaborador'
    );
    return isset($roles[$role_id]) ? $roles[$role_id] : 'Desconocido';
}

/**
 * Obtiene el conteo de notificaciones no leídas
 * @param int $user_id ID del usuario
 * @return int Número de notificaciones no leídas
 */
function getUnreadNotificationCount($user_id) {
    $sql = "SELECT COUNT(*) as total FROM notifications WHERE user_id = ? AND is_read = 0";
    $result = fetchOne($sql, array($user_id));
    return $result ? $result['total'] : 0;
}

/**
 * Crea una notificación
 * @param int $user_id ID del usuario
 * @param int $task_id ID de la tarea (opcional)
 * @param string $type Tipo de notificación
 * @param string $title Título
 * @param string $message Mensaje
 * @param string $link_url URL del enlace (opcional)
 * @return bool True si se creó correctamente
 */
function createNotification($user_id, $task_id, $type, $title, $message, $link_url = null) {
    $sql = "INSERT INTO notifications (user_id, task_id, notification_type, title, message, link_url)
            VALUES (?, ?, ?, ?, ?, ?)";
    $result = executeQuery($sql, array($user_id, $task_id, $type, $title, $message, $link_url));
    return $result !== false;
}

/**
 * Registra una actividad en el historial
 * @param int $task_id ID de la tarea
 * @param int $user_id ID del usuario
 * @param string $action_type Tipo de acción
 * @param string $field_changed Campo modificado (opcional)
 * @param string $old_value Valor anterior (opcional)
 * @param string $new_value Valor nuevo (opcional)
 * @return bool True si se registró correctamente
 */
function logActivity($task_id, $user_id, $action_type, $field_changed = null, $old_value = null, $new_value = null) {
    $sql = "INSERT INTO activity_log (task_id, user_id, action_type, field_changed, old_value, new_value)
            VALUES (?, ?, ?, ?, ?, ?)";
    $result = executeQuery($sql, array($task_id, $user_id, $action_type, $field_changed, $old_value, $new_value));
    return $result !== false;
}

/**
 * Envía un email (requiere configurar SMTP)
 * @param string $to Email destinatario
 * @param string $subject Asunto
 * @param string $body Cuerpo del mensaje (HTML)
 * @return bool True si se envió correctamente
 */
function sendEmail($to, $subject, $body) {
    // Aquí se puede implementar PHPMailer o similar
    // Por ahora, retornamos true para no generar errores
    // TODO: Implementar envío de email real con PHPMailer

    // Ejemplo básico con mail() de PHP (no recomendado para producción)
    $headers = "From: " . SMTP_FROM_NAME . " <" . SMTP_FROM_EMAIL . ">\r\n";
    $headers .= "Reply-To: " . SMTP_FROM_EMAIL . "\r\n";
    $headers .= "Content-Type: text/html; charset=UTF-8\r\n";

    return mail($to, $subject, $body, $headers);
}

/**
 * Obtiene el avatar/iniciales de un usuario
 * @param string $full_name Nombre completo
 * @return string Iniciales
 */
function getUserInitials($full_name) {
    $parts = explode(' ', $full_name);
    if (count($parts) >= 2) {
        return strtoupper(substr($parts[0], 0, 1) . substr($parts[1], 0, 1));
    } else {
        return strtoupper(substr($full_name, 0, 2));
    }
}

/**
 * Obtiene un color de badge aleatorio consistente basado en texto
 * @param string $text Texto base
 * @return string Clase de color
 */
function getConsistentBadgeColor($text) {
    $colors = array('primary', 'secondary', 'success', 'danger', 'warning', 'info');
    $hash = crc32($text);
    return $colors[$hash % count($colors)];
}

/**
 * Debug: Imprime variable de forma legible (solo en desarrollo)
 * @param mixed $var Variable a imprimir
 * @param bool $die Terminar ejecución después de imprimir
 */
function dd($var, $die = true) {
    echo '<pre>';
    var_dump($var);
    echo '</pre>';
    if ($die) {
        die();
    }
}
?>
