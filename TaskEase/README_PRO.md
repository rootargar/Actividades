# 📋 TaskEase Pro - Sistema de Gestión de Tareas Empresarial

![Version](https://img.shields.io/badge/version-2.0-blue.svg)
![PHP](https://img.shields.io/badge/PHP-7.4+-777BB4.svg)
![SQL Server](https://img.shields.io/badge/SQL%20Server-2016+-CC2927.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## 🎯 ¿Qué es TaskEase Pro?

TaskEase Pro es un sistema completo de gestión de tareas y proyectos, similar a **Trello**, **Asana**, **Notion** o **ClickUp**, diseñado para empresas que necesitan:

- ✅ Organizar proyectos en tableros
- ✅ Asignar tareas a usuarios responsables
- ✅ Hacer seguimiento del progreso
- ✅ Recibir notificaciones automáticas
- ✅ Colaborar mediante comentarios
- ✅ Adjuntar archivos
- ✅ Generar reportes y dashboards

## 🌟 Características Principales

### 📊 Tableros y Proyectos
- Crear múltiples tableros/espacios de trabajo
- Organizar tareas por proyecto
- Asignar tableros a departamentos
- Colores e íconos personalizables

### ✅ Gestión de Tareas Completa
- **Título y descripción extensa** (estilo Notion)
- **Responsable asignado**
- **5 estados:** Pendiente, En Proceso, En Revisión, Bloqueado, Completado
- **4 niveles de prioridad:** Baja, Media, Alta, Urgente
- **Fechas:** inicio, vencimiento, completado
- **Progreso en porcentaje** (0-100%)
- **Subtareas** con checklist
- **Archivos adjuntos** (PDF, imágenes, documentos)
- **Comentarios tipo chat**
- **Historial completo** de cambios

### 👥 Sistema de Roles y Permisos

**3 roles diferenciados:**

1. **Administrador**
   - Acceso total al sistema
   - Gestionar usuarios y tableros
   - Ver todas las tareas
   - Configurar notificaciones
   - Ver dashboards completos

2. **Supervisor**
   - Gestionar tableros de su departamento
   - Asignar tareas a su equipo
   - Ver tareas de su equipo
   - Dashboard de su departamento

3. **Colaborador**
   - Ver solo tareas asignadas
   - Actualizar progreso
   - Comentar y adjuntar archivos
   - Dashboard personal

### 🔔 Sistema de Notificaciones Completo

**Notificaciones Internas:**
- Campanita con contador de no leídas
- Lista desplegable en header
- Marcar como leída
- Enlace directo a la tarea

**Tipos de notificación:**
- 📥 Nueva tarea asignada
- ⏰ Tarea próxima a vencer
- ⚠️ Tarea vencida
- 🔄 Cambio de responsable
- 💬 Nuevo comentario
- ✏️ Cambio de estado

**Notificaciones por Email:**
- Envío automático configurable
- Template HTML profesional
- Configuración personalizada por usuario

### 🔍 Filtros Avanzados
- Por estado
- Por prioridad
- Por responsable
- Por departamento
- Por tablero
- Por rango de fechas
- Búsqueda por texto

### 📈 Dashboards Analíticos

**Dashboard Administrador:**
- Total de tareas por estado
- Tareas vencidas
- Tareas próximas a vencer
- Carga de trabajo por usuario
- Tareas completadas por semana
- Actividad reciente

**Dashboard Colaborador:**
- Mis tareas pendientes
- Mis tareas en proceso
- Próximos vencimientos
- Notificaciones recientes

### 💬 Comentarios Tipo Chat
- Comentarios en tiempo real
- Usuario y fecha
- Editar/eliminar comentarios
- Notificación automática

### 📎 Archivos Adjuntos
- Subir múltiples archivos por tarea
- Tipos: PDF, DOC, XLS, imágenes, ZIP
- Tamaño máximo: 10MB (configurable)
- Ver/descargar/eliminar archivos

### 📝 Historial de Cambios
- Registro completo de todas las acciones
- Usuario que realizó el cambio
- Fecha y hora exacta
- Campo modificado
- Valor anterior y nuevo

---

## 🛠️ Tecnologías Utilizadas

### **Backend:**
- **PHP 7.4+** (sin frameworks complejos)
- **Microsoft SQL Server 2016+**
- **PDO** para conexión segura
- **Prepared Statements** (protección SQL Injection)

### **Frontend:**
- **HTML5**
- **CSS3**
- **Bootstrap 4** (diseño responsive)
- **jQuery** (interactividad)
- **AJAX** (carga dinámica)

### **Seguridad:**
- **bcrypt** para hash de contraseñas
- **CSRF tokens** en formularios
- **Sanitización** de inputs
- **Sesiones seguras**

---

## 📥 Instalación

### **Requisitos Previos:**
- PHP 7.4 o superior
- Microsoft SQL Server 2016 o superior
- Drivers PHP para SQL Server (pdo_sqlsrv)
- Servidor web (Apache/IIS)

### **Pasos de Instalación:**

1. **Clonar el proyecto:**
```bash
git clone https://github.com/tu-usuario/TaskEase.git
cd TaskEase
```

2. **Crear la base de datos:**
```sql
-- Ejecutar en SQL Server
sqlcmd -S localhost -U sa -P 'TuContraseña' -i database_sqlserver.sql
```

3. **Configurar la conexión:**

Editar `includes/conexion.php`:
```php
define('DB_SERVER', 'localhost');
define('DB_NAME', 'TaskEaseDB');
define('DB_USERNAME', 'sa');
define('DB_PASSWORD', 'TuContraseña');
```

4. **Configurar permisos:**
```bash
chmod 777 uploads/
```

5. **Acceder al sistema:**
```
http://localhost/TaskEase
```

**Credenciales por defecto:**
- Admin: `admin@taskease.com` / `Admin123`
- Supervisor: `supervisor@taskease.com` / `Admin123`
- Colaborador: `colaborador1@taskease.com` / `Admin123`

⚠️ **IMPORTANTE:** Cambiar contraseñas después del primer login.

---

## 📖 Documentación Completa

- **[MANUAL_INSTALACION.md](MANUAL_INSTALACION.md)** - Guía paso a paso de instalación
- **[EXPLICACION_PROYECTO.md](EXPLICACION_PROYECTO.md)** - Explicación del repositorio base y mejoras
- **[LISTA_MEJORAS_APLICADAS.md](LISTA_MEJORAS_APLICADAS.md)** - Lista detallada de todas las mejoras

---

## 📁 Estructura del Proyecto

```
TaskEase/
│
├── admin/                          # Panel de administrador
│   ├── dashboard.php              # Dashboard con gráficos
│   ├── boards.php                 # Gestión de tableros
│   ├── tasks.php                  # Gestión de tareas
│   ├── users.php                  # Gestión de usuarios
│   └── notifications.php          # Centro de notificaciones
│
├── user/                          # Panel de colaborador
│   ├── dashboard.php              # Dashboard personal
│   ├── my_tasks.php               # Mis tareas
│   └── notifications.php          # Mis notificaciones
│
├── includes/                      # Archivos de configuración
│   ├── config.php                 # Configuración general
│   ├── conexion.php               # Conexión SQL Server (PDO)
│   ├── functions.php              # 60+ funciones auxiliares
│   └── ajax/                      # Endpoints AJAX
│
├── uploads/                       # Archivos adjuntos
├── bootstrap/                     # Framework CSS
├── css/                          # Estilos personalizados
├── js/                           # Scripts JavaScript
│
├── database_sqlserver.sql         # Script de base de datos
├── login.php                      # Sistema de login
├── logout.php                     # Cerrar sesión
└── index.php                      # Página de inicio
```

---

## 💾 Base de Datos (SQL Server)

### **13 Tablas:**
1. `roles` - Roles del sistema
2. `departments` - Departamentos
3. `users` - Usuarios (con hash de contraseñas)
4. `boards` - Tableros/Proyectos
5. `task_statuses` - Estados de tareas
6. `priorities` - Prioridades
7. `tasks` - Tareas principales
8. `subtasks` - Subtareas/checklist
9. `comments` - Comentarios
10. `attachments` - Archivos adjuntos
11. `activity_log` - Historial de cambios
12. `notifications` - Notificaciones
13. `notification_settings` - Configuración de notificaciones

### **3 Vistas SQL:**
- `v_tasks_full` - Tareas con toda la información
- `v_user_notifications` - Resumen de notificaciones
- `v_user_task_stats` - Estadísticas por usuario

### **4 Procedimientos Almacenados:**
- `sp_create_task_notification` - Crear notificación
- `sp_mark_notification_read` - Marcar como leída
- `sp_check_due_soon_tasks` - Verificar tareas próximas a vencer
- `sp_check_overdue_tasks` - Verificar tareas vencidas

---

## 🔒 Seguridad

TaskEase Pro implementa las mejores prácticas de seguridad:

- ✅ **Hash bcrypt** para contraseñas (cost 12)
- ✅ **Prepared Statements** en todas las consultas SQL
- ✅ **Sanitización** de todos los inputs
- ✅ **Validación** de emails y datos
- ✅ **Protección CSRF** con tokens
- ✅ **Sesiones seguras** (httponly, secure cookies)
- ✅ **Validación de tipos** de archivo
- ✅ **Límite de tamaño** de archivos

---

## 🚀 Características Avanzadas

### **Notificaciones Automáticas (CRON):**
Configurar tareas programadas para verificar:
- Tareas próximas a vencer (diariamente)
- Tareas vencidas (diariamente)

```bash
# Linux (crontab)
0 8 * * * /usr/bin/php /var/www/html/TaskEase/cron/check_notifications.php
```

### **Envío de Emails:**
Configurar SMTP en `includes/config.php`:
```php
define('SMTP_HOST', 'smtp.gmail.com');
define('SMTP_PORT', 587);
define('SMTP_USERNAME', 'tu_email@gmail.com');
define('SMTP_PASSWORD', 'tu_contraseña_app');
```

---

## 📊 Comparativa: Original vs Pro

| Característica | TaskEase Original | TaskEase Pro |
|----------------|-------------------|--------------|
| Base de Datos | MySQL (4 tablas) | SQL Server (13 tablas) |
| Seguridad | ⚠️ Baja | ✅ Alta |
| Roles | 2 | 3 con permisos |
| Tableros | ❌ | ✅ |
| Notificaciones | ❌ | ✅ Email + Internas |
| Comentarios | ❌ | ✅ Tipo chat |
| Archivos | ❌ | ✅ Múltiples formatos |
| Subtareas | ❌ | ✅ Checklist |
| Filtros | Básicos | ✅ Avanzados |
| Dashboards | Básico | ✅ Con gráficos |
| Historial | ❌ | ✅ Completo |

---

## 🎯 Casos de Uso

### **Empresas de Desarrollo:**
- Gestionar sprints
- Asignar bugs y features
- Seguimiento de proyectos
- Revisión de código

### **Agencias:**
- Proyectos de clientes
- Asignación de tareas a equipos
- Seguimiento de deadlines
- Comunicación interna

### **Departamentos Internos:**
- Proyectos de IT
- Tareas de RR.HH.
- Campañas de marketing
- Procesos de ventas

---

## 🛡️ Licencia

Este proyecto está basado en [TaskEase](https://github.com/Ankurac7/TaskEase) y ha sido completamente renovado y mejorado.

**Desarrollado por:** Claude AI
**Versión:** 2.0 Pro
**Fecha:** Noviembre 2025

---

## 🤝 Soporte

Para soporte e instalación, consultar:
- **[MANUAL_INSTALACION.md](MANUAL_INSTALACION.md)**
- **[EXPLICACION_PROYECTO.md](EXPLICACION_PROYECTO.md)**

---

## 🌟 Agradecimientos

- Proyecto base: [TaskEase por Ankurac7](https://github.com/Ankurac7/TaskEase)
- Bootstrap framework
- jQuery library
- Comunidad PHP

---

## 📸 Capturas de Pantalla

### Dashboard Administrador
![Dashboard](screenshots/dashboard.png)

### Gestión de Tareas
![Tasks](screenshots/tasks.png)

### Detalle de Tarea
![Task Detail](screenshots/task_detail.png)

### Notificaciones
![Notifications](screenshots/notifications.png)

---

**⭐ Si te gusta este proyecto, no olvides darle una estrella!**

**🐛 ¿Encontraste un bug? [Reportarlo aquí](https://github.com/tu-usuario/TaskEase/issues)**

**💡 ¿Tienes una idea? [Sugiere una mejora](https://github.com/tu-usuario/TaskEase/issues)**
