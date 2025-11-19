-- =============================================
-- SISTEMA DE GESTIÓN DE TAREAS ESTILO NOTION/TRELLO
-- Base de Datos: SQL Server
-- Versión: 1.0
-- =============================================

USE master;
GO

-- Crear base de datos
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'TaskEaseDB')
BEGIN
    ALTER DATABASE TaskEaseDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE TaskEaseDB;
END
GO

CREATE DATABASE TaskEaseDB;
GO

USE TaskEaseDB;
GO

-- =============================================
-- TABLA: Roles de Usuario
-- =============================================
CREATE TABLE roles (
    role_id INT IDENTITY(1,1) PRIMARY KEY,
    role_name NVARCHAR(50) NOT NULL UNIQUE,
    description NVARCHAR(255),
    created_at DATETIME DEFAULT GETDATE()
);
GO

-- Insertar roles predefinidos
INSERT INTO roles (role_name, description) VALUES
('Administrador', 'Acceso total al sistema'),
('Supervisor', 'Puede gestionar tableros y tareas de su equipo'),
('Colaborador', 'Solo puede ver y actualizar tareas asignadas');
GO

-- =============================================
-- TABLA: Departamentos
-- =============================================
CREATE TABLE departments (
    department_id INT IDENTITY(1,1) PRIMARY KEY,
    department_name NVARCHAR(100) NOT NULL,
    description NVARCHAR(500),
    created_at DATETIME DEFAULT GETDATE(),
    is_active BIT DEFAULT 1
);
GO

INSERT INTO departments (department_name, description) VALUES
('Desarrollo', 'Equipo de desarrollo de software'),
('Diseño', 'Equipo de diseño gráfico y UX'),
('Marketing', 'Equipo de marketing digital'),
('Ventas', 'Equipo comercial'),
('Recursos Humanos', 'Gestión de personal');
GO

-- =============================================
-- TABLA: Usuarios
-- =============================================
CREATE TABLE users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(50) NOT NULL UNIQUE,
    email NVARCHAR(100) NOT NULL UNIQUE,
    password_hash NVARCHAR(255) NOT NULL,
    full_name NVARCHAR(150) NOT NULL,
    phone NVARCHAR(20),
    role_id INT NOT NULL,
    department_id INT,
    profile_image NVARCHAR(255),
    is_active BIT DEFAULT 1,
    email_notifications BIT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    last_login DATETIME,
    CONSTRAINT FK_users_roles FOREIGN KEY (role_id) REFERENCES roles(role_id),
    CONSTRAINT FK_users_departments FOREIGN KEY (department_id) REFERENCES departments(department_id)
);
GO

-- Insertar usuarios de ejemplo (contraseña: Admin123)
-- Hash MD5 simple para demo: 42f749ade7f9e195bf475f37a44cafcb
INSERT INTO users (username, email, password_hash, full_name, phone, role_id, department_id) VALUES
('admin', 'admin@taskease.com', '42f749ade7f9e195bf475f37a44cafcb', 'Administrador General', '1234567890', 1, NULL),
('supervisor1', 'supervisor@taskease.com', '42f749ade7f9e195bf475f37a44cafcb', 'Juan Pérez', '1234567891', 2, 1),
('colaborador1', 'colaborador1@taskease.com', '42f749ade7f9e195bf475f37a44cafcb', 'María García', '1234567892', 3, 1),
('colaborador2', 'colaborador2@taskease.com', '42f749ade7f9e195bf475f37a44cafcb', 'Carlos López', '1234567893', 3, 2);
GO

-- =============================================
-- TABLA: Tableros/Espacios de trabajo
-- =============================================
CREATE TABLE boards (
    board_id INT IDENTITY(1,1) PRIMARY KEY,
    board_name NVARCHAR(150) NOT NULL,
    description NVARCHAR(1000),
    color NVARCHAR(7) DEFAULT '#0079BF',
    icon NVARCHAR(50) DEFAULT '📋',
    created_by INT NOT NULL,
    department_id INT,
    is_active BIT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_boards_users FOREIGN KEY (created_by) REFERENCES users(user_id),
    CONSTRAINT FK_boards_departments FOREIGN KEY (department_id) REFERENCES departments(department_id)
);
GO

INSERT INTO boards (board_name, description, color, icon, created_by, department_id) VALUES
('Proyecto Principal', 'Desarrollo del sistema de gestión', '#0079BF', '🚀', 1, 1),
('Campaña Marketing Q1', 'Campaña digital primer trimestre', '#61BD4F', '📢', 2, 3),
('Diseño Web', 'Rediseño del sitio corporativo', '#F2D600', '🎨', 2, 2);
GO

-- =============================================
-- TABLA: Estados de Tareas
-- =============================================
CREATE TABLE task_statuses (
    status_id INT IDENTITY(1,1) PRIMARY KEY,
    status_name NVARCHAR(50) NOT NULL UNIQUE,
    color NVARCHAR(7) DEFAULT '#808080',
    sort_order INT DEFAULT 0,
    is_active BIT DEFAULT 1
);
GO

INSERT INTO task_statuses (status_name, color, sort_order) VALUES
('Pendiente', '#808080', 1),
('En Proceso', '#0079BF', 2),
('En Revisión', '#F2D600', 3),
('Bloqueado', '#EB5A46', 4),
('Completado', '#61BD4F', 5);
GO

-- =============================================
-- TABLA: Prioridades
-- =============================================
CREATE TABLE priorities (
    priority_id INT IDENTITY(1,1) PRIMARY KEY,
    priority_name NVARCHAR(50) NOT NULL UNIQUE,
    color NVARCHAR(7) DEFAULT '#808080',
    level INT NOT NULL
);
GO

INSERT INTO priorities (priority_name, color, level) VALUES
('Baja', '#61BD4F', 1),
('Media', '#F2D600', 2),
('Alta', '#FF9F1A', 3),
('Urgente', '#EB5A46', 4);
GO

-- =============================================
-- TABLA: Tareas/Actividades
-- =============================================
CREATE TABLE tasks (
    task_id INT IDENTITY(1,1) PRIMARY KEY,
    board_id INT NOT NULL,
    title NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX),
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
    is_archived BIT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_tasks_boards FOREIGN KEY (board_id) REFERENCES boards(board_id),
    CONSTRAINT FK_tasks_assigned FOREIGN KEY (assigned_to) REFERENCES users(user_id),
    CONSTRAINT FK_tasks_created FOREIGN KEY (created_by) REFERENCES users(user_id),
    CONSTRAINT FK_tasks_status FOREIGN KEY (status_id) REFERENCES task_statuses(status_id),
    CONSTRAINT FK_tasks_priority FOREIGN KEY (priority_id) REFERENCES priorities(priority_id),
    CONSTRAINT FK_tasks_parent FOREIGN KEY (parent_task_id) REFERENCES tasks(task_id),
    CONSTRAINT CHK_progress CHECK (progress_percentage BETWEEN 0 AND 100)
);
GO

-- Insertar tareas de ejemplo
INSERT INTO tasks (board_id, title, description, assigned_to, created_by, status_id, priority_id, start_date, due_date) VALUES
(1, 'Diseñar base de datos', 'Crear el esquema completo de la base de datos SQL Server', 3, 1, 2, 3, '2025-01-10', '2025-01-15'),
(1, 'Desarrollar módulo de autenticación', 'Implementar login, logout y gestión de sesiones', 3, 1, 1, 4, '2025-01-16', '2025-01-20'),
(1, 'Crear interfaz de usuario', 'Diseñar y maquetar las pantallas principales', 4, 1, 1, 2, '2025-01-12', '2025-01-18');
GO

-- =============================================
-- TABLA: Subtareas
-- =============================================
CREATE TABLE subtasks (
    subtask_id INT IDENTITY(1,1) PRIMARY KEY,
    task_id INT NOT NULL,
    title NVARCHAR(255) NOT NULL,
    is_completed BIT DEFAULT 0,
    sort_order INT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE(),
    completed_at DATETIME,
    CONSTRAINT FK_subtasks_tasks FOREIGN KEY (task_id) REFERENCES tasks(task_id) ON DELETE CASCADE
);
GO

INSERT INTO subtasks (task_id, title, is_completed) VALUES
(1, 'Identificar entidades principales', 1),
(1, 'Definir relaciones entre tablas', 1),
(1, 'Crear script SQL Server', 0),
(2, 'Diseñar formulario de login', 0),
(2, 'Implementar validación de credenciales', 0);
GO

-- =============================================
-- TABLA: Comentarios
-- =============================================
CREATE TABLE comments (
    comment_id INT IDENTITY(1,1) PRIMARY KEY,
    task_id INT NOT NULL,
    user_id INT NOT NULL,
    comment_text NVARCHAR(MAX) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    is_edited BIT DEFAULT 0,
    CONSTRAINT FK_comments_tasks FOREIGN KEY (task_id) REFERENCES tasks(task_id) ON DELETE CASCADE,
    CONSTRAINT FK_comments_users FOREIGN KEY (user_id) REFERENCES users(user_id)
);
GO

INSERT INTO comments (task_id, user_id, comment_text) VALUES
(1, 2, 'He revisado el diseño inicial, muy bien organizado.'),
(1, 3, 'Gracias, voy a añadir las tablas de notificaciones.'),
(2, 1, 'Recuerden implementar hash de contraseñas con password_hash de PHP.');
GO

-- =============================================
-- TABLA: Archivos Adjuntos
-- =============================================
CREATE TABLE attachments (
    attachment_id INT IDENTITY(1,1) PRIMARY KEY,
    task_id INT NOT NULL,
    uploaded_by INT NOT NULL,
    file_name NVARCHAR(255) NOT NULL,
    file_path NVARCHAR(500) NOT NULL,
    file_type NVARCHAR(50),
    file_size BIGINT,
    uploaded_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_attachments_tasks FOREIGN KEY (task_id) REFERENCES tasks(task_id) ON DELETE CASCADE,
    CONSTRAINT FK_attachments_users FOREIGN KEY (uploaded_by) REFERENCES users(user_id)
);
GO

-- =============================================
-- TABLA: Historial de Cambios
-- =============================================
CREATE TABLE activity_log (
    log_id INT IDENTITY(1,1) PRIMARY KEY,
    task_id INT NOT NULL,
    user_id INT NOT NULL,
    action_type NVARCHAR(50) NOT NULL,
    field_changed NVARCHAR(100),
    old_value NVARCHAR(MAX),
    new_value NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_activity_tasks FOREIGN KEY (task_id) REFERENCES tasks(task_id) ON DELETE CASCADE,
    CONSTRAINT FK_activity_users FOREIGN KEY (user_id) REFERENCES users(user_id)
);
GO

INSERT INTO activity_log (task_id, user_id, action_type, field_changed, old_value, new_value) VALUES
(1, 1, 'created', NULL, NULL, 'Tarea creada'),
(1, 3, 'status_changed', 'status_id', '1', '2'),
(1, 2, 'comment_added', NULL, NULL, 'Nuevo comentario añadido');
GO

-- =============================================
-- TABLA: Notificaciones
-- =============================================
CREATE TABLE notifications (
    notification_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    task_id INT,
    notification_type NVARCHAR(50) NOT NULL,
    title NVARCHAR(255) NOT NULL,
    message NVARCHAR(1000) NOT NULL,
    is_read BIT DEFAULT 0,
    is_sent_email BIT DEFAULT 0,
    link_url NVARCHAR(500),
    created_at DATETIME DEFAULT GETDATE(),
    read_at DATETIME,
    CONSTRAINT FK_notifications_users FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT FK_notifications_tasks FOREIGN KEY (task_id) REFERENCES tasks(task_id) ON DELETE SET NULL
);
GO

-- Tipos de notificación: task_assigned, task_due_soon, task_overdue, assignee_changed, comment_added, status_changed

INSERT INTO notifications (user_id, task_id, notification_type, title, message, link_url) VALUES
(3, 1, 'task_assigned', 'Nueva tarea asignada', 'Se te ha asignado la tarea: Diseñar base de datos', '/task.php?id=1'),
(3, 2, 'task_assigned', 'Nueva tarea asignada', 'Se te ha asignado la tarea: Desarrollar módulo de autenticación', '/task.php?id=2');
GO

-- =============================================
-- TABLA: Configuración de Notificaciones por Usuario
-- =============================================
CREATE TABLE notification_settings (
    setting_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    email_task_assigned BIT DEFAULT 1,
    email_task_due_soon BIT DEFAULT 1,
    email_task_overdue BIT DEFAULT 1,
    email_assignee_changed BIT DEFAULT 1,
    email_comment_added BIT DEFAULT 1,
    email_status_changed BIT DEFAULT 0,
    days_before_due INT DEFAULT 1,
    CONSTRAINT FK_notification_settings_users FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);
GO

INSERT INTO notification_settings (user_id) VALUES (1), (2), (3), (4);
GO

-- =============================================
-- VISTAS ÚTILES
-- =============================================

-- Vista: Tareas con información completa
CREATE VIEW v_tasks_full AS
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
        WHEN t.due_date < CAST(GETDATE() AS DATE) AND ts.status_name != 'Completado' THEN 'Vencida'
        WHEN DATEDIFF(DAY, GETDATE(), t.due_date) <= 2 AND ts.status_name != 'Completado' THEN 'Próxima a vencer'
        ELSE 'Normal'
    END AS urgency_status
FROM tasks t
INNER JOIN boards b ON t.board_id = b.board_id
INNER JOIN task_statuses ts ON t.status_id = ts.status_id
INNER JOIN priorities p ON t.priority_id = p.priority_id
LEFT JOIN users u_assigned ON t.assigned_to = u_assigned.user_id
INNER JOIN users u_created ON t.created_by = u_created.user_id
WHERE t.is_archived = 0;
GO

-- Vista: Resumen de notificaciones por usuario
CREATE VIEW v_user_notifications AS
SELECT
    n.user_id,
    u.full_name,
    COUNT(*) AS total_notifications,
    SUM(CASE WHEN n.is_read = 0 THEN 1 ELSE 0 END) AS unread_count,
    MAX(n.created_at) AS last_notification_date
FROM notifications n
INNER JOIN users u ON n.user_id = u.user_id
GROUP BY n.user_id, u.full_name;
GO

-- Vista: Estadísticas de tareas por usuario
CREATE VIEW v_user_task_stats AS
SELECT
    u.user_id,
    u.full_name,
    COUNT(t.task_id) AS total_tasks,
    SUM(CASE WHEN ts.status_name = 'Completado' THEN 1 ELSE 0 END) AS completed_tasks,
    SUM(CASE WHEN ts.status_name = 'En Proceso' THEN 1 ELSE 0 END) AS in_progress_tasks,
    SUM(CASE WHEN t.due_date < CAST(GETDATE() AS DATE) AND ts.status_name != 'Completado' THEN 1 ELSE 0 END) AS overdue_tasks
FROM users u
LEFT JOIN tasks t ON u.user_id = t.assigned_to
LEFT JOIN task_statuses ts ON t.status_id = ts.status_id
WHERE t.is_archived = 0 OR t.task_id IS NULL
GROUP BY u.user_id, u.full_name;
GO

-- =============================================
-- PROCEDIMIENTOS ALMACENADOS
-- =============================================

-- Procedimiento: Crear notificación de nueva tarea
CREATE PROCEDURE sp_create_task_notification
    @task_id INT,
    @assigned_user_id INT
AS
BEGIN
    DECLARE @task_title NVARCHAR(255);
    DECLARE @notification_msg NVARCHAR(1000);

    SELECT @task_title = title FROM tasks WHERE task_id = @task_id;
    SET @notification_msg = 'Se te ha asignado la tarea: ' + @task_title;

    INSERT INTO notifications (user_id, task_id, notification_type, title, message, link_url)
    VALUES (@assigned_user_id, @task_id, 'task_assigned', 'Nueva tarea asignada', @notification_msg, '/task_detail.php?id=' + CAST(@task_id AS NVARCHAR));
END;
GO

-- Procedimiento: Marcar notificación como leída
CREATE PROCEDURE sp_mark_notification_read
    @notification_id INT
AS
BEGIN
    UPDATE notifications
    SET is_read = 1, read_at = GETDATE()
    WHERE notification_id = @notification_id;
END;
GO

-- Procedimiento: Verificar tareas próximas a vencer
CREATE PROCEDURE sp_check_due_soon_tasks
AS
BEGIN
    INSERT INTO notifications (user_id, task_id, notification_type, title, message, link_url)
    SELECT
        t.assigned_to,
        t.task_id,
        'task_due_soon',
        'Tarea próxima a vencer',
        'La tarea "' + t.title + '" vence el ' + CONVERT(VARCHAR, t.due_date, 103),
        '/task_detail.php?id=' + CAST(t.task_id AS NVARCHAR)
    FROM tasks t
    INNER JOIN task_statuses ts ON t.status_id = ts.status_id
    INNER JOIN notification_settings ns ON t.assigned_to = ns.user_id
    WHERE t.due_date = DATEADD(DAY, ns.days_before_due, CAST(GETDATE() AS DATE))
    AND ts.status_name != 'Completado'
    AND ns.email_task_due_soon = 1
    AND NOT EXISTS (
        SELECT 1 FROM notifications n
        WHERE n.task_id = t.task_id
        AND n.notification_type = 'task_due_soon'
        AND CAST(n.created_at AS DATE) = CAST(GETDATE() AS DATE)
    );
END;
GO

-- Procedimiento: Verificar tareas vencidas
CREATE PROCEDURE sp_check_overdue_tasks
AS
BEGIN
    INSERT INTO notifications (user_id, task_id, notification_type, title, message, link_url)
    SELECT
        t.assigned_to,
        t.task_id,
        'task_overdue',
        '¡Tarea vencida!',
        'La tarea "' + t.title + '" está vencida desde el ' + CONVERT(VARCHAR, t.due_date, 103),
        '/task_detail.php?id=' + CAST(t.task_id AS NVARCHAR)
    FROM tasks t
    INNER JOIN task_statuses ts ON t.status_id = ts.status_id
    INNER JOIN notification_settings ns ON t.assigned_to = ns.user_id
    WHERE t.due_date < CAST(GETDATE() AS DATE)
    AND ts.status_name != 'Completado'
    AND ns.email_task_overdue = 1
    AND NOT EXISTS (
        SELECT 1 FROM notifications n
        WHERE n.task_id = t.task_id
        AND n.notification_type = 'task_overdue'
        AND CAST(n.created_at AS DATE) = CAST(GETDATE() AS DATE)
    );
END;
GO

-- =============================================
-- ÍNDICES PARA OPTIMIZACIÓN
-- =============================================

CREATE NONCLUSTERED INDEX IX_tasks_assigned_to ON tasks(assigned_to);
CREATE NONCLUSTERED INDEX IX_tasks_board_id ON tasks(board_id);
CREATE NONCLUSTERED INDEX IX_tasks_status_id ON tasks(status_id);
CREATE NONCLUSTERED INDEX IX_tasks_due_date ON tasks(due_date);
CREATE NONCLUSTERED INDEX IX_notifications_user_id ON notifications(user_id);
CREATE NONCLUSTERED INDEX IX_notifications_is_read ON notifications(is_read);
CREATE NONCLUSTERED INDEX IX_comments_task_id ON comments(task_id);
CREATE NONCLUSTERED INDEX IX_activity_log_task_id ON activity_log(task_id);
GO

PRINT 'Base de datos TaskEaseDB creada exitosamente con todas las tablas, vistas, procedimientos e índices.';
GO
