<?php
/**
 * Archivo de Conexión a SQL Server
 * TaskEase - Sistema de Gestión de Tareas
 *
 * Configuración de conexión a SQL Server usando PDO
 * PDO proporciona una capa de abstracción de datos y soporte para prepared statements
 */

// Configuración de la base de datos
define('DB_SERVER', 'localhost');
define('DB_NAME', 'TaskEaseDB');
define('DB_USERNAME', 'sa');
define('DB_PASSWORD', 'tu_contraseña_aqui');

// Variable global de conexión
$connection = null;

try {
    // Crear conexión PDO a SQL Server
    // DSN (Data Source Name) para SQL Server
    $dsn = "sqlsrv:Server=" . DB_SERVER . ";Database=" . DB_NAME;

    // Opciones de PDO para mejorar seguridad y rendimiento
    $options = array(
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,  // Modo de error: excepciones
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,  // Modo de fetch por defecto: array asociativo
        PDO::ATTR_EMULATE_PREPARES => false,  // No emular prepared statements
        PDO::SQLSRV_ATTR_ENCODING => PDO::SQLSRV_ENCODING_UTF8  // Codificación UTF-8
    );

    // Crear la conexión
    $connection = new PDO($dsn, DB_USERNAME, DB_PASSWORD, $options);

} catch (PDOException $e) {
    // En caso de error, mostrar mensaje y detener ejecución
    die("Error de conexión a la base de datos: " . $e->getMessage());
}

/**
 * Función auxiliar para ejecutar consultas preparadas
 * Evita inyección SQL usando prepared statements
 *
 * @param string $sql Consulta SQL con placeholders
 * @param array $params Parámetros para la consulta
 * @return PDOStatement Resultado de la consulta
 */
function executeQuery($sql, $params = array()) {
    global $connection;

    try {
        $stmt = $connection->prepare($sql);
        $stmt->execute($params);
        return $stmt;
    } catch (PDOException $e) {
        error_log("Error en consulta SQL: " . $e->getMessage());
        return false;
    }
}

/**
 * Función para obtener un solo registro
 *
 * @param string $sql Consulta SQL
 * @param array $params Parámetros
 * @return array|false Registro encontrado o false
 */
function fetchOne($sql, $params = array()) {
    $stmt = executeQuery($sql, $params);
    if ($stmt) {
        return $stmt->fetch();
    }
    return false;
}

/**
 * Función para obtener múltiples registros
 *
 * @param string $sql Consulta SQL
 * @param array $params Parámetros
 * @return array Array de registros
 */
function fetchAll($sql, $params = array()) {
    $stmt = executeQuery($sql, $params);
    if ($stmt) {
        return $stmt->fetchAll();
    }
    return array();
}

/**
 * Función para obtener el último ID insertado
 *
 * @return int Último ID insertado
 */
function getLastInsertId() {
    global $connection;
    return $connection->lastInsertId();
}

/**
 * Función para sanitizar entradas de texto
 * Previene XSS (Cross-Site Scripting)
 *
 * @param string $data Datos a sanitizar
 * @return string Datos sanitizados
 */
function sanitize($data) {
    if (is_array($data)) {
        foreach ($data as $key => $value) {
            $data[$key] = sanitize($value);
        }
        return $data;
    }

    $data = trim($data);
    $data = stripslashes($data);
    $data = htmlspecialchars($data, ENT_QUOTES, 'UTF-8');
    return $data;
}

/**
 * Función para validar email
 *
 * @param string $email Email a validar
 * @return bool True si es válido
 */
function validateEmail($email) {
    return filter_var($email, FILTER_VALIDATE_EMAIL);
}

/**
 * Función para hashear contraseñas
 * Usa bcrypt (algoritmo seguro)
 *
 * @param string $password Contraseña en texto plano
 * @return string Hash de la contraseña
 */
function hashPassword($password) {
    return password_hash($password, PASSWORD_BCRYPT, ['cost' => 12]);
}

/**
 * Función para verificar contraseñas
 *
 * @param string $password Contraseña en texto plano
 * @param string $hash Hash almacenado
 * @return bool True si coincide
 */
function verifyPassword($password, $hash) {
    return password_verify($password, $hash);
}

/**
 * Función para cerrar la conexión
 */
function closeConnection() {
    global $connection;
    $connection = null;
}

// Configurar zona horaria
date_default_timezone_set('America/Mexico_City');

// Iniciar sesión si no está iniciada
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}
?>
