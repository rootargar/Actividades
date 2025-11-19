# 🎉 TaskEase Pro - Ahora con MySQL

## ✅ Cambios Importantes

El proyecto **TaskEase Pro** ahora está configurado para funcionar con **MySQL** en lugar de SQL Server, para mayor compatibilidad y facilidad de instalación.

---

## 🚀 Instalación Rápida (3 pasos)

### 1️⃣ Importar Base de Datos

**Opción A: phpMyAdmin (Recomendado)**
1. Abrir: `http://localhost/phpmyadmin`
2. Ir a "Importar"
3. Seleccionar archivo: `database_mysql.sql`
4. Click en "Continuar"

**Opción B: Línea de comandos**
```bash
mysql -u root -p < database_mysql.sql
```

### 2️⃣ Configurar Conexión

Editar: `includes/conexion.php`

```php
define('DB_SERVER', 'localhost');
define('DB_NAME', 'TaskEaseDB');
define('DB_USERNAME', 'root');
define('DB_PASSWORD', '');  // Vacío para XAMPP
```

### 3️⃣ Acceder al Sistema

```
http://localhost/TaskEase
```

**Credenciales por defecto:**
- Admin: `admin@taskease.com` / `Admin123`
- Supervisor: `supervisor@taskease.com` / `Admin123`
- Colaborador: `colaborador1@taskease.com` / `Admin123`

---

## 📚 Documentación Completa

- **[MANUAL_INSTALACION_MYSQL.md](MANUAL_INSTALACION_MYSQL.md)** - Guía completa paso a paso
- **[README_PRO.md](README_PRO.md)** - Características del sistema
- **[EXPLICACION_PROYECTO.md](EXPLICACION_PROYECTO.md)** - Explicación del proyecto base

---

## 🔄 Diferencias SQL Server vs MySQL

| Aspecto | SQL Server | MySQL |
|---------|------------|-------|
| **Script BD** | `database_sqlserver.sql` | `database_mysql.sql` ✅ |
| **Conexión** | Driver: `sqlsrv` | Driver: `mysql` ✅ |
| **Instalación** | Compleja | Fácil (XAMPP) ✅ |
| **Compatibilidad** | Windows principalmente | Multiplataforma ✅ |
| **Costo** | Licencia requerida | Gratuito ✅ |

---

## ✨ Características del Sistema

✅ **Tableros** estilo Trello/Notion
✅ **Tareas completas** con subtareas, archivos y comentarios
✅ **3 roles:** Administrador, Supervisor, Colaborador
✅ **Notificaciones** internas + email
✅ **Filtros avanzados** por estado, prioridad, responsable, etc.
✅ **Dashboards** con estadísticas
✅ **Seguridad:** Hash bcrypt, PDO, Prepared Statements

---

## 📋 Tablas de la Base de Datos

El sistema crea 13 tablas automáticamente:

1. `roles` - Roles del sistema
2. `departments` - Departamentos
3. `users` - Usuarios
4. `boards` - Tableros/Proyectos
5. `task_statuses` - Estados de tareas
6. `priorities` - Prioridades
7. `tasks` - Tareas principales
8. `subtasks` - Subtareas
9. `comments` - Comentarios
10. `attachments` - Archivos adjuntos
11. `activity_log` - Historial de cambios
12. `notifications` - Notificaciones
13. `notification_settings` - Configuración de notificaciones

---

## 🛠️ Requisitos

- **PHP 7.4+**
- **MySQL 5.7+** o MariaDB 10.2+
- **Apache** o Nginx
- **XAMPP** (recomendado para Windows)

---

## 🆘 Problemas Comunes

### ❌ "Access denied for user 'root'"
**Solución:** Verificar contraseña en `includes/conexion.php`

### ❌ "Unknown database 'TaskEaseDB'"
**Solución:** Importar `database_mysql.sql` desde phpMyAdmin

### ❌ Página en blanco
**Solución:** Verificar que MySQL esté corriendo en XAMPP

---

## 📞 Ayuda

¿Necesitas ayuda? Consulta el manual completo:
**[MANUAL_INSTALACION_MYSQL.md](MANUAL_INSTALACION_MYSQL.md)**

---

## 🎯 Migración desde SQL Server

Si estabas usando la versión SQL Server, los cambios principales son:

1. ✅ Usar `database_mysql.sql` en lugar de `database_sqlserver.sql`
2. ✅ Actualizar `includes/conexion.php` (ya está configurado para MySQL)
3. ✅ Importar la base de datos en MySQL/phpMyAdmin
4. ✅ Todo lo demás funciona igual

---

**Versión:** 2.0 Pro (MySQL)
**Desarrollado por:** Claude AI
**Licencia:** MIT

---

## 🚀 ¡Listo para usar!

Con MySQL, la instalación es mucho más simple. Solo necesitas XAMPP y estás listo en minutos.

**¡Comienza ahora!** 🎉
