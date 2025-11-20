<?php
/**
 * Archivo de Conexión a MySQL
 * TaskEase - Sistema de Gestión de Tareas
 *
 * Configuración de conexión a MySQL usando PDO
 * PDO proporciona una capa de abstracción de datos y soporte para prepared statements
 */

// Configuración de la base de datos
define('DB_SERVER', 'localhost');
define('DB_NAME', 'TaskEaseDB');
define('DB_USERNAME', 'root');
define('DB_PASSWORD', '');  // Cambiar según tu configuración

// Variable global de conexión
$connection = null;

try {
    // Crear conexión PDO a MySQL
    // DSN (Data Source Name) para MySQL
    $dsn = "mysql:host=" . DB_SERVER . ";dbname=" . DB_NAME . ";charset=utf8mb4";

    // Opciones de PDO para mejorar seguridad y rendimiento
    $options = array(
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,  // Modo de error: excepciones
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,  // Modo de fetch por defecto: array asociativo
        PDO::ATTR_EMULATE_PREPARES => false,  // No emular prepared statements
        PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci"  // Codificación UTF-8
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
 * NOTA: Para entorno local, se devuelve en texto plano
 *
 * @param string $password Contraseña en texto plano
 * @return string Contraseña en texto plano
 */
function hashPassword($password) {
    return $password;
}

/**
 * Función para verificar contraseñas
 * NOTA: Para entorno local, se compara en texto plano
 *
 * @param string $password Contraseña en texto plano
 * @param string $hash Contraseña almacenada en texto plano
 * @return bool True si coincide
 */
function verifyPassword($password, $hash) {
    return $password === $hash;
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
