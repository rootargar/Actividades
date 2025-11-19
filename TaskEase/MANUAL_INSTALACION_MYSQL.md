# 📚 MANUAL DE INSTALACIÓN - TaskEase Pro (MySQL)

## 🎯 Requisitos del Sistema

### **Servidor Web:**
- PHP 7.4 o superior
- MySQL 5.7 o superior (o MariaDB 10.2+)
- Servidor Web: Apache 2.4+ o Nginx
- Extensiones PHP requeridas:
  - `pdo_mysql` (incluido por defecto en PHP)
  - `mysqli` (opcional, para compatibilidad)
  - `mbstring`
  - `openssl`
  - `fileinfo`
  - `gd` o `imagick` (para procesamiento de imágenes)

### **Cliente:**
- Navegadores modernos: Chrome 90+, Firefox 88+, Edge 90+, Safari 14+
- JavaScript habilitado
- Resolución mínima: 1024x768

---

## 📥 PASO 1: Instalar Prerequisites

### **1.1. Instalar PHP**

**Windows (XAMPP):**
```bash
# Descargar XAMPP desde: https://www.apachefriends.org/
# XAMPP incluye: Apache, PHP, MySQL (MariaDB) y phpMyAdmin
# Instalar y ejecutar
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt update
sudo apt install php8.1 php8.1-cli php8.1-common php8.1-mysql php8.1-mbstring php8.1-xml php8.1-gd
```

### **1.2. Instalar MySQL**

**Windows (con XAMPP):**
- MySQL (MariaDB) ya viene incluido con XAMPP
- No requiere instalación adicional

**Linux:**
```bash
# Opción 1: MySQL Community Server
sudo apt install mysql-server
sudo mysql_secure_installation

# Opción 2: MariaDB (compatible con MySQL)
sudo apt install mariadb-server
sudo mysql_secure_installation
```

### **1.3. Instalar Apache**

**Linux:**
```bash
sudo apt install apache2
sudo systemctl start apache2
sudo systemctl enable apache2
```

**Windows:**
- Apache viene incluido con XAMPP
- Iniciar desde el Panel de Control de XAMPP

---

## 📂 PASO 2: Copiar Archivos del Proyecto

### **2.1. Ubicación de los archivos**

**XAMPP (Windows/Linux):**
```bash
# Copiar proyecto a:
C:\xampp\htdocs\TaskEase  (Windows)
/opt/lampp/htdocs/TaskEase  (Linux)
```

**Apache (Linux):**
```bash
# Copiar proyecto a la raíz web
sudo cp -r TaskEase /var/www/html/
sudo chown -R www-data:www-data /var/www/html/TaskEase
sudo chmod -R 755 /var/www/html/TaskEase
sudo chmod -R 777 /var/www/html/TaskEase/uploads
```

---

## 💾 PASO 3: Crear la Base de Datos

### **3.1. Opción 1: Usando phpMyAdmin (Más fácil)**

1. Abrir navegador: `http://localhost/phpmyadmin`
2. Iniciar sesión (usuario: `root`, contraseña: vacía o la que configuraste)
3. Click en "Importar" en el menú superior
4. Click en "Seleccionar archivo"
5. Buscar y seleccionar: `TaskEase/database_mysql.sql`
6. Click en "Continuar" al final de la página
7. Esperar a que termine la importación
8. Verificar que aparezca: "Base de datos TaskEaseDB creada exitosamente"

### **3.2. Opción 2: Usando línea de comandos**

**Windows (desde XAMPP):**
```bash
# Abrir CMD en la carpeta de XAMPP
cd C:\xampp\mysql\bin

# Ejecutar el script
mysql -u root -p < C:\xampp\htdocs\TaskEase\database_mysql.sql
# Presionar Enter (sin contraseña) o ingresar tu contraseña
```

**Linux:**
```bash
# Conectarse a MySQL
mysql -u root -p

# Dentro de MySQL, ejecutar:
source /var/www/html/TaskEase/database_mysql.sql

# O desde la terminal directamente:
mysql -u root -p < /var/www/html/TaskEase/database_mysql.sql
```

### **3.3. Verificar la Instalación**

**Desde phpMyAdmin:**
1. Click en "TaskEaseDB" en el panel izquierdo
2. Verificar que se hayan creado 13 tablas
3. Click en "users" y verificar que hay 4 usuarios

**Desde línea de comandos:**
```sql
mysql -u root -p
USE TaskEaseDB;
SHOW TABLES;
SELECT * FROM users;
```

Deberías ver 13 tablas:
- roles
- departments
- users
- boards
- task_statuses
- priorities
- tasks
- subtasks
- comments
- attachments
- activity_log
- notifications
- notification_settings

---

## ⚙️ PASO 4: Configurar la Conexión

### **4.1. Editar archivo de conexión**

Abrir: `TaskEase/includes/conexion.php`

Modificar las siguientes líneas:

```php
// Configuración de la base de datos
define('DB_SERVER', 'localhost');        // Servidor MySQL
define('DB_NAME', 'TaskEaseDB');         // Nombre de la base de datos
define('DB_USERNAME', 'root');           // Usuario de MySQL
define('DB_PASSWORD', '');               // Contraseña (vacío para XAMPP por defecto)
```

**Configuraciones comunes:**

**XAMPP (por defecto):**
```php
define('DB_SERVER', 'localhost');
define('DB_NAME', 'TaskEaseDB');
define('DB_USERNAME', 'root');
define('DB_PASSWORD', '');  // Sin contraseña
```

**MySQL con contraseña:**
```php
define('DB_SERVER', 'localhost');
define('DB_NAME', 'TaskEaseDB');
define('DB_USERNAME', 'root');
define('DB_PASSWORD', 'tu_contraseña_segura');
```

**Servidor remoto:**
```php
define('DB_SERVER', '192.168.1.100');
define('DB_NAME', 'TaskEaseDB');
define('DB_USERNAME', 'taskease_user');
define('DB_PASSWORD', 'P@ssw0rd_Segura!');
```

### **4.2. Configurar parámetros generales**

Abrir: `TaskEase/includes/config.php`

Modificar:

```php
// URL de la aplicación
define('APP_URL', 'http://localhost/TaskEase');  // Cambiar según tu dominio

// Configuración de email (para notificaciones)
define('SMTP_HOST', 'smtp.gmail.com');
define('SMTP_PORT', 587);
define('SMTP_USERNAME', 'tu_email@gmail.com');        // ⚠️ CAMBIAR
define('SMTP_PASSWORD', 'tu_contraseña_aplicacion');  // ⚠️ CAMBIAR
define('SMTP_FROM_EMAIL', 'noreply@tuempresa.com');
define('SMTP_FROM_NAME', 'TaskEase Notificaciones');

// Zona horaria
date_default_timezone_set('America/Mexico_City');  // Cambiar según tu zona
```

### **4.3. Crear carpeta de uploads**

```bash
# XAMPP Windows
mkdir C:\xampp\htdocs\TaskEase\uploads

# Linux
mkdir -p /var/www/html/TaskEase/uploads
chmod 777 /var/www/html/TaskEase/uploads
```

---

## 🚀 PASO 5: Acceder al Sistema

### **5.1. Iniciar servicios (XAMPP)**

1. Abrir Panel de Control de XAMPP
2. Iniciar "Apache"
3. Iniciar "MySQL"
4. Ambos deben mostrar luz verde

### **5.2. Abrir en el navegador**

```
http://localhost/TaskEase
```

O si configuraste un dominio:
```
http://taskease.tuempresa.com
```

### **5.3. Credenciales por Defecto**

El sistema tiene 4 usuarios de ejemplo:

**Administrador:**
- Email: `admin@taskease.com`
- Contraseña: `Admin123`

**Supervisor:**
- Email: `supervisor@taskease.com`
- Contraseña: `Admin123`

**Colaborador 1:**
- Email: `colaborador1@taskease.com`
- Contraseña: `Admin123`

**Colaborador 2:**
- Email: `colaborador2@taskease.com`
- Contraseña: `Admin123`

### **5.4. Primer login y cambio de contraseña**

⚠️ **IMPORTANTE:** Cambiar todas las contraseñas después del primer acceso.

---

## 🔧 PASO 6: Configuración de Notificaciones por Email (Opcional)

### **6.1. Configurar Gmail para SMTP**

1. Ir a: https://myaccount.google.com/security
2. Activar "Verificación en 2 pasos"
3. Buscar "Contraseñas de aplicaciones"
4. Generar una contraseña de aplicación
5. Copiar la contraseña generada (16 caracteres)
6. Pegar en `includes/config.php`:

```php
define('SMTP_USERNAME', 'tu_email@gmail.com');
define('SMTP_PASSWORD', 'abcd efgh ijkl mnop');  // Contraseña de aplicación de 16 caracteres
```

### **6.2. Probar envío de emails**

Crear archivo: `test_email.php` en la raíz del proyecto

```php
<?php
require_once 'includes/config.php';
require_once 'includes/functions.php';

$result = sendEmail(
    'tu_email_destino@gmail.com',
    'Prueba TaskEase',
    '<h1>Email de prueba</h1><p>El sistema de notificaciones funciona correctamente.</p>'
);

echo $result ? 'Email enviado correctamente' : 'Error al enviar email';
?>
```

Ejecutar desde el navegador:
```
http://localhost/TaskEase/test_email.php
```

---

## ⏰ PASO 7: Configurar Tareas Programadas (CRON) - Opcional

### **7.1. Crear script de notificaciones**

Crear archivo: `TaskEase/cron/check_notifications.php`

```php
<?php
require_once '../includes/config.php';

// Ejecutar procedimientos almacenados
executeQuery("CALL sp_check_due_soon_tasks()");
executeQuery("CALL sp_check_overdue_tasks()");

echo "Notificaciones verificadas: " . date('Y-m-d H:i:s') . "\n";
?>
```

### **7.2. Configurar CRON (Linux)**

```bash
# Editar crontab
crontab -e

# Agregar (ejecutar diariamente a las 8:00 AM)
0 8 * * * /usr/bin/php /var/www/html/TaskEase/cron/check_notifications.php >> /var/log/taskease_cron.log 2>&1
```

### **7.3. Configurar Tarea Programada (Windows)**

1. Abrir: "Programador de tareas"
2. Crear tarea básica
3. Nombre: "TaskEase Notificaciones"
4. Desencadenador: Diariamente a las 8:00 AM
5. Acción: Iniciar programa
6. Programa: `C:\xampp\php\php.exe`
7. Argumentos: `C:\xampp\htdocs\TaskEase\cron\check_notifications.php`

---

## 🔒 PASO 8: Seguridad Adicional (Producción)

### **8.1. Crear usuario de base de datos específico**

No usar el usuario `root` en producción:

```sql
-- Conectarse como root
mysql -u root -p

-- Crear usuario específico
CREATE USER 'taskease'@'localhost' IDENTIFIED BY 'contraseña_segura_aqui';
GRANT ALL PRIVILEGES ON TaskEaseDB.* TO 'taskease'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

Actualizar `includes/conexion.php`:
```php
define('DB_USERNAME', 'taskease');
define('DB_PASSWORD', 'contraseña_segura_aqui');
```

### **8.2. Deshabilitar errores en pantalla**

Editar `includes/config.php`:

```php
// En PRODUCCIÓN cambiar a:
error_reporting(0);
ini_set('display_errors', 0);
ini_set('log_errors', 1);
ini_set('error_log', '/var/log/taskease_errors.log');
```

### **8.3. Proteger archivos sensibles**

Crear archivo `.htaccess` en la raíz del proyecto:

```apache
# Proteger archivos de configuración
<FilesMatch "^(config\.php|conexion\.php|functions\.php)$">
    Order Allow,Deny
    Deny from all
</FilesMatch>

# Proteger archivos SQL
<FilesMatch "\.(sql|bak)$">
    Order Allow,Deny
    Deny from all
</FilesMatch>

# Proteger directorio includes
<IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteRule ^includes/ - [F,L]
</IfModule>
```

### **8.4. Configurar backup automático**

**Linux:**
```bash
# Crear script de backup
cat > /usr/local/bin/backup_taskease.sh << 'EOF'
#!/bin/bash
FECHA=$(date +%Y%m%d_%H%M%S)
mysqldump -u root -p'tu_contraseña' TaskEaseDB > /var/backups/taskease_$FECHA.sql
gzip /var/backups/taskease_$FECHA.sql
find /var/backups -name "taskease_*.sql.gz" -mtime +30 -delete
EOF

chmod +x /usr/local/bin/backup_taskease.sh

# Programar backup diario (2:00 AM)
echo "0 2 * * * /usr/local/bin/backup_taskease.sh >> /var/log/backup_taskease.log 2>&1" | crontab -
```

**Windows (con XAMPP):**
Crear archivo `backup_taskease.bat`:
```batch
@echo off
set FECHA=%date:~-4,4%%date:~-7,2%%date:~-10,2%_%time:~0,2%%time:~3,2%
C:\xampp\mysql\bin\mysqldump.exe -u root TaskEaseDB > C:\backups\taskease_%FECHA%.sql
```

Programar en el Programador de tareas para ejecutar diariamente.

---

## ✅ PASO 9: Verificación Final

### **9.1. Checklist de Instalación**

- [ ] PHP 7.4+ instalado
- [ ] MySQL/MariaDB funcionando
- [ ] Base de datos TaskEaseDB creada
- [ ] 13 tablas creadas correctamente
- [ ] Archivos copiados a la raíz web
- [ ] Permisos configurados en carpeta uploads
- [ ] Archivo de conexión configurado
- [ ] Login funciona correctamente
- [ ] Contraseñas cambiadas
- [ ] Emails configurados (opcional)
- [ ] CRON configurado (opcional)
- [ ] Backups configurados (producción)

### **9.2. Pruebas Funcionales**

1. **Login:**
   - ✅ Iniciar sesión como Admin
   - ✅ Iniciar sesión como Supervisor
   - ✅ Iniciar sesión como Colaborador

2. **Tableros:**
   - ✅ Ver tableros existentes
   - ✅ Crear nuevo tablero (Admin/Supervisor)

3. **Tareas:**
   - ✅ Ver lista de tareas
   - ✅ Crear nueva tarea
   - ✅ Asignar tarea a usuario
   - ✅ Actualizar estado de tarea

4. **Notificaciones:**
   - ✅ Ver campanita con contador
   - ✅ Marcar notificación como leída

---

## 🆘 SOLUCIÓN DE PROBLEMAS COMUNES

### **Error: "Access denied for user 'root'@'localhost'"**

**Causa:** Contraseña incorrecta en `conexion.php`

**Solución:**
```bash
# Resetear contraseña de root (XAMPP)
mysql -u root
UPDATE mysql.user SET Password=PASSWORD('nueva_contraseña') WHERE User='root';
FLUSH PRIVILEGES;
```

### **Error: "Unknown database 'TaskEaseDB'"**

**Causa:** Base de datos no creada

**Solución:**
1. Abrir phpMyAdmin
2. Importar `database_mysql.sql`
3. Verificar que se creó TaskEaseDB

### **Error: "SQLSTATE[HY000] [2002] No such file or directory"**

**Causa:** MySQL no está corriendo

**Solución:**
```bash
# Linux
sudo systemctl start mysql

# XAMPP
# Iniciar MySQL desde el Panel de Control
```

### **Error: "Permission denied" al subir archivos**

**Causa:** Falta de permisos en carpeta uploads

**Solución:**
```bash
# Linux
chmod 777 /var/www/html/TaskEase/uploads
chown www-data:www-data /var/www/html/TaskEase/uploads

# XAMPP Windows
# Dar permisos de escritura a la carpeta desde propiedades
```

### **Página en blanco al acceder**

**Causa:** Error de PHP

**Solución:**
```php
// Activar errores temporalmente en index.php
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Verificar logs de Apache
# Linux: /var/log/apache2/error.log
# XAMPP: C:\xampp\apache\logs\error.log
```

---

## 📞 SOPORTE Y CONTACTO

**Documentación adicional:**
- README_PRO.md
- EXPLICACION_PROYECTO.md
- LISTA_MEJORAS_APLICADAS.md

**Archivos importantes:**
- `database_mysql.sql` - Script de base de datos
- `includes/conexion.php` - Configuración de conexión
- `includes/config.php` - Configuración general

**Desarrollado por:** Claude AI
**Versión:** 2.0 Pro (MySQL)
**Fecha:** Noviembre 2025

---

## 🎉 ¡INSTALACIÓN COMPLETADA!

Si llegaste hasta aquí, **¡felicidades!** TaskEase Pro está instalado y listo para usar con MySQL.

**Próximos pasos:**
1. ✅ Cambiar todas las contraseñas por defecto
2. ✅ Crear departamentos de tu empresa
3. ✅ Dar de alta a tus usuarios
4. ✅ Crear tus primeros tableros
5. ✅ Comenzar a gestionar proyectos

**Acceso al sistema:**
```
http://localhost/TaskEase
Usuario: admin@taskease.com
Contraseña: Admin123
```

**¡Bienvenido a TaskEase Pro!** 🚀
