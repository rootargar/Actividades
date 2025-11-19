-- =============================================
-- SISTEMA DE GESTIÓN DE TAREAS ESTILO NOTION/TRELLO
-- Base de Datos: MySQL 5.7+
-- Versión: 2.0
-- =============================================

-- Crear base de datos
DROP DATABASE IF EXISTS TaskEaseDB;
CREATE DATABASE TaskEaseDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE TaskEaseDB;

-- =============================================
-- TABLA: Roles de Usuario
-- =============================================
CREATE TABLE roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insertar roles predefinidos
INSERT INTO roles (role_name, description) VALUES
('Administrador', 'Acceso total al sistema'),
('Supervisor', 'Puede gestionar tableros y tareas de su equipo'),
('Colaborador', 'Solo puede ver y actualizar tareas asignadas');

-- =============================================
-- TABLA: Departamentos
-- =============================================
CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    description VARCHAR(500),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_active TINYINT(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO departments (department_name, description) VALUES
('Desarrollo', 'Equipo de desarrollo de software'),
('Diseño', 'Equipo de diseño gráfico y UX'),
('Marketing', 'Equipo de marketing digital'),
('Ventas', 'Equipo comercial'),
('Recursos Humanos', 'Gestión de personal');

-- =============================================
-- TABLA: Usuarios
-- =============================================
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    phone VARCHAR(20),
    role_id INT NOT NULL,
    department_id INT,
    profile_image VARCHAR(255),
    is_active TINYINT(1) DEFAULT 1,
    email_notifications TINYINT(1) DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_login DATETIME,
    CONSTRAINT FK_users_roles FOREIGN KEY (role_id) REFERENCES roles(role_id),
    CONSTRAINT FK_users_departments FOREIGN KEY (department_id) REFERENCES departments(department_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insertar usuarios de ejemplo (contraseña: Admin123)
-- Hash bcrypt: $2y$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5NN0xkqwkbLmW
INSERT INTO users (username, email, password_hash, full_name, phone, role_id, department_id) VALUES
('admin', 'admin@taskease.com', '$2y$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5NN0xkqwkbLmW', 'Administrador General', '1234567890', 1, NULL),
('supervisor1', 'supervisor@taskease.com', '$2y$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5NN0xkqwkbLmW', 'Juan Pérez', '1234567891', 2, 1),
('colaborador1', 'colaborador1@taskease.com', '$2y$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5NN0xkqwkbLmW', 'María García', '1234567892', 3, 1),
('colaborador2', 'colaborador2@taskease.com', '$2y$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5NN0xkqwkbLmW', 'Carlos López', '1234567893', 3, 2);

-- =============================================
-- TABLA: Tableros/Espacios de trabajo
-- =============================================
CREATE TABLE boards (
    board_id INT AUTO_INCREMENT PRIMARY KEY,
    board_name VARCHAR(150) NOT NULL,
    description TEXT,
    color VARCHAR(7) DEFAULT '#0079BF',
    icon VARCHAR(50) DEFAULT '📋',
    created_by INT NOT NULL,
    department_id INT,
    is_active TINYINT(1) DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT FK_boards_users FOREIGN KEY (created_by) REFERENCES users(user_id),
    CONSTRAINT FK_boards_departments FOREIGN KEY (department_id) REFERENCES departments(department_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO boards (board_name, description, color, icon, created_by, department_id) VALUES
('Proyecto Principal', 'Desarrollo del sistema de gestión', '#0079BF', '🚀', 1, 1),
('Campaña Marketing Q1', 'Campaña digital primer trimestre', '#61BD4F', '📢', 2, 3),
('Diseño Web', 'Rediseño del sitio corporativo', '#F2D600', '🎨', 2, 2);

-- =============================================
-- TABLA: Estados de Tareas
-- =============================================
CREATE TABLE task_statuses (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL UNIQUE,
    color VARCHAR(7) DEFAULT '#808080',
    sort_order INT DEFAULT 0,
    is_active TINYINT(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO task_statuses (status_name, color, sort_order) VALUES
('Pendiente', '#808080', 1),
('En Proceso', '#0079BF', 2),
('En Revisión', '#F2D600', 3),
('Bloqueado', '#EB5A46', 4),
('Completado', '#61BD4F', 5);

-- =============================================
-- TABLA: Prioridades
-- =============================================
CREATE TABLE priorities (
    priority_id INT AUTO_INCREMENT PRIMARY KEY,
    priority_name VARCHAR(50) NOT NULL UNIQUE,
    color VARCHAR(7) DEFAULT '#808080',
    level INT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO priorities (priority_name, color, level) VALUES
('Baja', '#61BD4F', 1),
('Media', '#F2D600', 2),
('Alta', '#FF9F1A', 3),
('Urgente', '#EB5A46', 4);

-- =============================================
-- TABLA: Tareas/Actividades
-- =============================================
CREATE TABLE tasks (
    task_id INT AUTO_INCREMENT PRIMARY KEY,
    board_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    assigned_to INT,
    created_by INT NOT NULL,
    status_id INT NOT NULL DEFAULT 1,
    priority_id INT NOT NULL DEFAULT 2,
    start_date DATE,
    due_date DATE,
    completed_date DATETIME,
    estimated_hours DECIMAL(10,2),
    actual_hours DECIMAL(10,2),
    progress_percentage INT DEFAULT 0,
    parent_task_id INT NULL,
    sort_order INT DEFAULT 0,
    is_archived TINYINT(1) DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT FK_tasks_boards FOREIGN KEY (board_id) REFERENCES boards(board_id),
    CONSTRAINT FK_tasks_assigned FOREIGN KEY (assigned_to) REFERENCES users(user_id),
    CONSTRAINT FK_tasks_created FOREIGN KEY (created_by) REFERENCES users(user_id),
    CONSTRAINT FK_tasks_status FOREIGN KEY (status_id) REFERENCES task_statuses(status_id),
    CONSTRAINT FK_tasks_priority FOREIGN KEY (priority_id) REFERENCES priorities(priority_id),
    CONSTRAINT FK_tasks_parent FOREIGN KEY (parent_task_id) REFERENCES tasks(task_id),
    CONSTRAINT CHK_progress CHECK (progress_percentage BETWEEN 0 AND 100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insertar tareas de ejemplo
INSERT INTO tasks (board_id, title, description, assigned_to, created_by, status_id, priority_id, start_date, due_date) VALUES
(1, 'Diseñar base de datos', 'Crear el esquema completo de la base de datos MySQL', 3, 1, 2, 3, '2025-01-10', '2025-01-15'),
(1, 'Desarrollar módulo de autenticación', 'Implementar login, logout y gestión de sesiones', 3, 1, 1, 4, '2025-01-16', '2025-01-20'),
(1, 'Crear interfaz de usuario', 'Diseñar y maquetar las pantallas principales', 4, 1, 1, 2, '2025-01-12', '2025-01-18');

-- =============================================
-- TABLA: Subtareas
-- =============================================
CREATE TABLE subtasks (
    subtask_id INT AUTO_INCREMENT PRIMARY KEY,
    task_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    is_completed TINYINT(1) DEFAULT 0,
    sort_order INT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    completed_at DATETIME,
    CONSTRAINT FK_subtasks_tasks FOREIGN KEY (task_id) REFERENCES tasks(task_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO subtasks (task_id, title, is_completed) VALUES
(1, 'Identificar entidades principales', 1),
(1, 'Definir relaciones entre tablas', 1),
(1, 'Crear script MySQL', 0),
(2, 'Diseñar formulario de login', 0),
(2, 'Implementar validación de credenciales', 0);

-- =============================================
-- TABLA: Comentarios
-- =============================================
CREATE TABLE comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    task_id INT NOT NULL,
    user_id INT NOT NULL,
    comment_text TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_edited TINYINT(1) DEFAULT 0,
    CONSTRAINT FK_comments_tasks FOREIGN KEY (task_id) REFERENCES tasks(task_id) ON DELETE CASCADE,
    CONSTRAINT FK_comments_users FOREIGN KEY (user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO comments (task_id, user_id, comment_text) VALUES
(1, 2, 'He revisado el diseño inicial, muy bien organizado.'),
(1, 3, 'Gracias, voy a añadir las tablas de notificaciones.'),
(2, 1, 'Recuerden implementar hash de contraseñas con password_hash de PHP.');

-- =============================================
-- TABLA: Archivos Adjuntos
-- =============================================
CREATE TABLE attachments (
    attachment_id INT AUTO_INCREMENT PRIMARY KEY,
    task_id INT NOT NULL,
    uploaded_by INT NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    file_type VARCHAR(50),
    file_size BIGINT,
    uploaded_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FK_attachments_tasks FOREIGN KEY (task_id) REFERENCES tasks(task_id) ON DELETE CASCADE,
    CONSTRAINT FK_attachments_users FOREIGN KEY (uploaded_by) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- TABLA: Historial de Cambios
-- =============================================
CREATE TABLE activity_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    task_id INT NOT NULL,
    user_id INT NOT NULL,
    action_type VARCHAR(50) NOT NULL,
    field_changed VARCHAR(100),
    old_value TEXT,
    new_value TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FK_activity_tasks FOREIGN KEY (task_id) REFERENCES tasks(task_id) ON DELETE CASCADE,
    CONSTRAINT FK_activity_users FOREIGN KEY (user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO activity_log (task_id, user_id, action_type, field_changed, old_value, new_value) VALUES
(1, 1, 'created', NULL, NULL, 'Tarea creada'),
(1, 3, 'status_changed', 'status_id', '1', '2'),
(1, 2, 'comment_added', NULL, NULL, 'Nuevo comentario añadido');

-- =============================================
-- TABLA: Notificaciones
-- =============================================
CREATE TABLE notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    task_id INT,
    notification_type VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    is_read TINYINT(1) DEFAULT 0,
    is_sent_email TINYINT(1) DEFAULT 0,
    link_url VARCHAR(500),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    read_at DATETIME,
    CONSTRAINT FK_notifications_users FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT FK_notifications_tasks FOREIGN KEY (task_id) REFERENCES tasks(task_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tipos de notificación: task_assigned, task_due_soon, task_overdue, assignee_changed, comment_added, status_changed

INSERT INTO notifications (user_id, task_id, notification_type, title, message, link_url) VALUES
(3, 1, 'task_assigned', 'Nueva tarea asignada', 'Se te ha asignado la tarea: Diseñar base de datos', '/task.php?id=1'),
(3, 2, 'task_assigned', 'Nueva tarea asignada', 'Se te ha asignado la tarea: Desarrollar módulo de autenticación', '/task.php?id=2');

-- =============================================
-- TABLA: Configuración de Notificaciones por Usuario
-- =============================================
CREATE TABLE notification_settings (
    setting_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    email_task_assigned TINYINT(1) DEFAULT 1,
    email_task_due_soon TINYINT(1) DEFAULT 1,
    email_task_overdue TINYINT(1) DEFAULT 1,
    email_assignee_changed TINYINT(1) DEFAULT 1,
    email_comment_added TINYINT(1) DEFAULT 1,
    email_status_changed TINYINT(1) DEFAULT 0,
    days_before_due INT DEFAULT 1,
    CONSTRAINT FK_notification_settings_users FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO notification_settings (user_id) VALUES (1), (2), (3), (4);

-- =============================================
-- VISTAS ÚTILES
-- =============================================

-- Vista: Tareas con información completa
CREATE OR REPLACE VIEW v_tasks_full AS
SELECT
    t.task_id,
    t.title,
    t.description,
    t.start_date,
    t.due_date,
    t.completed_date,
    t.progress_percentage,
    b.board_name,
    b.board_id,
    ts.status_name,
    ts.color AS status_color,
    p.priority_name,
    p.color AS priority_color,
    u_assigned.full_name AS assigned_to_name,
    u_assigned.email AS assigned_to_email,
    u_created.full_name AS created_by_name,
    t.created_at,
    t.updated_at,
    CASE
        WHEN t.due_date < CURDATE() AND ts.status_name != 'Completado' THEN 'Vencida'
        WHEN DATEDIFF(t.due_date, CURDATE()) <= 2 AND ts.status_name != 'Completado' THEN 'Próxima a vencer'
        ELSE 'Normal'
    END AS urgency_status
FROM tasks t
INNER JOIN boards b ON t.board_id = b.board_id
INNER JOIN task_statuses ts ON t.status_id = ts.status_id
INNER JOIN priorities p ON t.priority_id = p.priority_id
LEFT JOIN users u_assigned ON t.assigned_to = u_assigned.user_id
INNER JOIN users u_created ON t.created_by = u_created.user_id
WHERE t.is_archived = 0;

-- Vista: Resumen de notificaciones por usuario
CREATE OR REPLACE VIEW v_user_notifications AS
SELECT
    n.user_id,
    u.full_name,
    COUNT(*) AS total_notifications,
    SUM(CASE WHEN n.is_read = 0 THEN 1 ELSE 0 END) AS unread_count,
    MAX(n.created_at) AS last_notification_date
FROM notifications n
INNER JOIN users u ON n.user_id = u.user_id
GROUP BY n.user_id, u.full_name;

-- Vista: Estadísticas de tareas por usuario
CREATE OR REPLACE VIEW v_user_task_stats AS
SELECT
    u.user_id,
    u.full_name,
    COUNT(t.task_id) AS total_tasks,
    SUM(CASE WHEN ts.status_name = 'Completado' THEN 1 ELSE 0 END) AS completed_tasks,
    SUM(CASE WHEN ts.status_name = 'En Proceso' THEN 1 ELSE 0 END) AS in_progress_tasks,
    SUM(CASE WHEN t.due_date < CURDATE() AND ts.status_name != 'Completado' THEN 1 ELSE 0 END) AS overdue_tasks
FROM users u
LEFT JOIN tasks t ON u.user_id = t.assigned_to AND t.is_archived = 0
LEFT JOIN task_statuses ts ON t.status_id = ts.status_id
GROUP BY u.user_id, u.full_name;

-- =============================================
-- PROCEDIMIENTOS ALMACENADOS
-- =============================================

DELIMITER $$

-- Procedimiento: Crear notificación de nueva tarea
CREATE PROCEDURE sp_create_task_notification(
    IN p_task_id INT,
    IN p_assigned_user_id INT
)
BEGIN
    DECLARE v_task_title VARCHAR(255);
    DECLARE v_notification_msg TEXT;

    SELECT title INTO v_task_title FROM tasks WHERE task_id = p_task_id;
    SET v_notification_msg = CONCAT('Se te ha asignado la tarea: ', v_task_title);

    INSERT INTO notifications (user_id, task_id, notification_type, title, message, link_url)
    VALUES (p_assigned_user_id, p_task_id, 'task_assigned', 'Nueva tarea asignada', v_notification_msg, CONCAT('/task_detail.php?id=', p_task_id));
END$$

-- Procedimiento: Marcar notificación como leída
CREATE PROCEDURE sp_mark_notification_read(
    IN p_notification_id INT
)
BEGIN
    UPDATE notifications
    SET is_read = 1, read_at = NOW()
    WHERE notification_id = p_notification_id;
END$$

-- Procedimiento: Verificar tareas próximas a vencer
CREATE PROCEDURE sp_check_due_soon_tasks()
BEGIN
    INSERT INTO notifications (user_id, task_id, notification_type, title, message, link_url)
    SELECT
        t.assigned_to,
        t.task_id,
        'task_due_soon',
        'Tarea próxima a vencer',
        CONCAT('La tarea "', t.title, '" vence el ', DATE_FORMAT(t.due_date, '%d/%m/%Y')),
        CONCAT('/task_detail.php?id=', t.task_id)
    FROM tasks t
    INNER JOIN task_statuses ts ON t.status_id = ts.status_id
    INNER JOIN notification_settings ns ON t.assigned_to = ns.user_id
    WHERE t.due_date = DATE_ADD(CURDATE(), INTERVAL ns.days_before_due DAY)
    AND ts.status_name != 'Completado'
    AND ns.email_task_due_soon = 1
    AND NOT EXISTS (
        SELECT 1 FROM notifications n
        WHERE n.task_id = t.task_id
        AND n.notification_type = 'task_due_soon'
        AND DATE(n.created_at) = CURDATE()
    );
END$$

-- Procedimiento: Verificar tareas vencidas
CREATE PROCEDURE sp_check_overdue_tasks()
BEGIN
    INSERT INTO notifications (user_id, task_id, notification_type, title, message, link_url)
    SELECT
        t.assigned_to,
        t.task_id,
        'task_overdue',
        '¡Tarea vencida!',
        CONCAT('La tarea "', t.title, '" está vencida desde el ', DATE_FORMAT(t.due_date, '%d/%m/%Y')),
        CONCAT('/task_detail.php?id=', t.task_id)
    FROM tasks t
    INNER JOIN task_statuses ts ON t.status_id = ts.status_id
    INNER JOIN notification_settings ns ON t.assigned_to = ns.user_id
    WHERE t.due_date < CURDATE()
    AND ts.status_name != 'Completado'
    AND ns.email_task_overdue = 1
    AND NOT EXISTS (
        SELECT 1 FROM notifications n
        WHERE n.task_id = t.task_id
        AND n.notification_type = 'task_overdue'
        AND DATE(n.created_at) = CURDATE()
    );
END$$

DELIMITER ;

-- =============================================
-- ÍNDICES PARA OPTIMIZACIÓN
-- =============================================

CREATE INDEX idx_tasks_assigned_to ON tasks(assigned_to);
CREATE INDEX idx_tasks_board_id ON tasks(board_id);
CREATE INDEX idx_tasks_status_id ON tasks(status_id);
CREATE INDEX idx_tasks_due_date ON tasks(due_date);
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);
CREATE INDEX idx_comments_task_id ON comments(task_id);
CREATE INDEX idx_activity_log_task_id ON activity_log(task_id);

-- =============================================
-- MENSAJE FINAL
-- =============================================

SELECT 'Base de datos TaskEaseDB creada exitosamente con todas las tablas, vistas, procedimientos e índices.' AS mensaje;
