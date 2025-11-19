# 📚 MANUAL DE INSTALACIÓN - TaskEase Pro

## 🎯 Requisitos del Sistema

### **Servidor Web:**
- PHP 7.4 o superior
- Microsoft SQL Server 2016 o superior (o Azure SQL Database)
- Servidor Web: Apache 2.4+ o IIS 10+
- Extensiones PHP requeridas:
  - `pdo_sqlsrv` (PHP Driver for SQL Server)
  - `sqlsrv` (Microsoft Drivers for PHP)
  - `mbstring`
  - `openssl`
  - `fileinfo`
  - `gd` o `imagick` (para procesamiento de imágenes)

### **Cliente:**
- Navegadores modernos: Chrome 90+, Firefox 88+, Edge 90+, Safari 14+
- JavaScript habilitado
- Resolución mínima: 1024x768

---

## 📥 PASO 1: Descargar e Instalar Prerequisites

### **1.1. Instalar PHP**

**Windows:**
```bash
# Descargar PHP desde: https://windows.php.net/download/
# Extraer en C:\php
# Agregar C:\php a las variables de entorno PATH
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt update
sudo apt install php8.1 php8.1-cli php8.1-common php8.1-mbstring php8.1-xml
```

### **1.2. Instalar Microsoft SQL Server**

**Windows:**
1. Descargar SQL Server Express: https://www.microsoft.com/sql-server/sql-server-downloads
2. Ejecutar el instalador
3. Seleccionar "Instalación básica"
4. Anotar la cadena de conexión mostrada

**Linux:**
```bash
# Importar clave GPG
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

# Agregar repositorio
sudo add-apt-repository "$(curl https://packages.microsoft.com/config/ubuntu/20.04/mssql-server-2019.list)"

# Instalar SQL Server
sudo apt-get update
sudo apt-get install -y mssql-server

# Configurar SQL Server
sudo /opt/mssql/bin/mssql-conf setup
```

### **1.3. Instalar Drivers PHP para SQL Server**

**Windows:**
1. Descargar: https://docs.microsoft.com/en-us/sql/connect/php/download-drivers-php-sql-server
2. Extraer archivos DLL apropiados en `C:\php\ext\`
3. Editar `php.ini` y agregar:
```ini
extension=php_sqlsrv_81_ts_x64.dll
extension=php_pdo_sqlsrv_81_ts_x64.dll
```

**Linux:**
```bash
# Instalar drivers
sudo pecl install sqlsrv
sudo pecl install pdo_sqlsrv

# Agregar extensiones en php.ini
echo "extension=sqlsrv.so" | sudo tee -a /etc/php/8.1/cli/php.ini
echo "extension=pdo_sqlsrv.so" | sudo tee -a /etc/php/8.1/cli/php.ini
```

### **1.4. Instalar Apache o IIS**

**Apache (Linux):**
```bash
sudo apt install apache2
sudo systemctl start apache2
sudo systemctl enable apache2
```

**IIS (Windows):**
1. Panel de Control > Programas > Activar o desactivar características de Windows
2. Seleccionar "Internet Information Services"
3. Instalar y configurar

---

## 📂 PASO 2: Copiar Archivos del Proyecto

### **2.1. Ubicación de los archivos**

**Apache (Linux):**
```bash
# Copiar proyecto a la raíz web
sudo cp -r TaskEase /var/www/html/
sudo chown -R www-data:www-data /var/www/html/TaskEase
sudo chmod -R 755 /var/www/html/TaskEase
sudo chmod -R 777 /var/www/html/TaskEase/uploads
```

**IIS (Windows):**
```batch
# Copiar proyecto a:
C:\inetpub\wwwroot\TaskEase

# Dar permisos de escritura a la carpeta uploads
icacls "C:\inetpub\wwwroot\TaskEase\uploads" /grant "IIS_IUSRS:(OI)(CI)F" /T
```

**XAMPP/WAMP:**
```batch
# Copiar a:
C:\xampp\htdocs\TaskEase
```

---

## 💾 PASO 3: Crear la Base de Datos

### **3.1. Conectarse a SQL Server**

**Usando SQL Server Management Studio (SSMS):**
1. Abrir SSMS
2. Conectar al servidor local: `localhost` o `(local)`
3. Usar autenticación de Windows o SQL Server

**Usando línea de comandos:**
```bash
# Linux
sqlcmd -S localhost -U sa -P 'TuContraseñaSegura'

# Windows
sqlcmd -S localhost -E
```

### **3.2. Ejecutar el Script de Base de Datos**

**Método 1: Desde SSMS**
1. Abrir archivo: `database_sqlserver.sql`
2. Presionar F5 para ejecutar
3. Verificar que aparezca: "Base de datos TaskEaseDB creada exitosamente"

**Método 2: Desde línea de comandos**
```bash
sqlcmd -S localhost -U sa -P 'TuContraseña' -i database_sqlserver.sql
```

### **3.3. Verificar la Instalación**

```sql
USE TaskEaseDB;
GO

-- Ver todas las tablas
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES;

-- Verificar datos de ejemplo
SELECT * FROM users;
SELECT * FROM roles;
SELECT * FROM boards;
```

---

## ⚙️ PASO 4: Configurar la Conexión

### **4.1. Editar archivo de conexión**

Abrir: `includes/conexion.php`

Modificar las siguientes líneas:

```php
// Configuración de la base de datos
define('DB_SERVER', 'localhost');        // Cambiar si SQL Server está en otro servidor
define('DB_NAME', 'TaskEaseDB');
define('DB_USERNAME', 'sa');             // Usuario de SQL Server
define('DB_PASSWORD', 'TuContraseña');   // ⚠️ CAMBIAR ESTA CONTRASEÑA
```

**Ejemplo con servidor remoto:**
```php
define('DB_SERVER', '192.168.1.100\SQLEXPRESS');
define('DB_USERNAME', 'taskease_user');
define('DB_PASSWORD', 'P@ssw0rd_Segura!');
```

### **4.2. Configurar parámetros generales**

Abrir: `includes/config.php`

Modificar:

```php
// URL de la aplicación
define('APP_URL', 'http://localhost/TaskEase');  // Cambiar según tu dominio

// Configuración de email
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
# Linux
mkdir -p /var/www/html/TaskEase/uploads
chmod 777 /var/www/html/TaskEase/uploads

# Windows (no requiere permisos especiales)
mkdir C:\inetpub\wwwroot\TaskEase\uploads
```

---

## 🔑 PASO 5: Generar Contraseñas Hash (Migración)

### **5.1. Script para actualizar contraseñas**

Crear archivo: `migration_passwords.php`

```php
<?php
require_once 'includes/conexion.php';

// Nueva contraseña para todos los usuarios: Admin123
$new_password = 'Admin123';
$password_hash = password_hash($new_password, PASSWORD_BCRYPT, ['cost' => 12]);

// Actualizar todos los usuarios
$sql = "UPDATE users SET password_hash = ?";
executeQuery($sql, array($password_hash));

echo "Contraseñas actualizadas correctamente.\n";
echo "Nueva contraseña para todos los usuarios: Admin123\n";
echo "Por favor, cambiar contraseñas después del primer login.\n";
?>
```

### **5.2. Ejecutar migración**

```bash
php migration_passwords.php
```

---

## 🚀 PASO 6: Acceder al Sistema

### **6.1. Abrir en el navegador**

```
http://localhost/TaskEase
```

O si configuraste un dominio:
```
http://taskease.tuempresa.com
```

### **6.2. Credenciales por Defecto**

**Administrador:**
- Email: `admin@taskease.com`
- Contraseña: `Admin123`

**Supervisor:**
- Email: `supervisor@taskease.com`
- Contraseña: `Admin123`

**Colaborador:**
- Email: `colaborador1@taskease.com`
- Contraseña: `Admin123`

### **6.3. Primer login y cambio de contraseña**

⚠️ **IMPORTANTE:** Cambiar todas las contraseñas después del primer acceso.

1. Iniciar sesión con usuario admin
2. Ir a: Configuración > Mi Perfil
3. Cambiar contraseña
4. Repetir para todos los usuarios

---

## 🔧 PASO 7: Configuración de Notificaciones por Email

### **7.1. Configurar Gmail para SMTP**

1. Ir a: https://myaccount.google.com/security
2. Activar "Verificación en 2 pasos"
3. Generar "Contraseña de aplicación"
4. Copiar la contraseña generada
5. Pegar en `includes/config.php`:

```php
define('SMTP_USERNAME', 'tu_email@gmail.com');
define('SMTP_PASSWORD', 'abcd efgh ijkl mnop');  // Contraseña de aplicación
```

### **7.2. Instalar PHPMailer (Opcional pero Recomendado)**

```bash
cd TaskEase
composer require phpmailer/phpmailer
```

O descargar manualmente:
```bash
wget https://github.com/PHPMailer/PHPMailer/archive/v6.8.0.zip
unzip v6.8.0.zip
mv PHPMailer-6.8.0 includes/phpmailer
```

### **7.3. Probar envío de emails**

Crear: `test_email.php`

```php
<?php
require_once 'includes/config.php';
require_once 'includes/functions.php';

$result = sendEmail(
    'tu_email@gmail.com',
    'Prueba TaskEase',
    '<h1>Email de prueba</h1><p>El sistema de notificaciones funciona correctamente.</p>'
);

echo $result ? 'Email enviado correctamente' : 'Error al enviar email';
?>
```

---

## ⏰ PASO 8: Configurar Tareas Programadas (CRON)

### **8.1. Crear script de notificaciones**

Crear: `cron/check_notifications.php`

```php
<?php
require_once '../includes/config.php';

// Ejecutar procedimientos almacenados
executeQuery("EXEC sp_check_due_soon_tasks");
executeQuery("EXEC sp_check_overdue_tasks");

echo "Notificaciones verificadas: " . date('Y-m-d H:i:s') . "\n";
?>
```

### **8.2. Configurar CRON (Linux)**

```bash
# Editar crontab
crontab -e

# Agregar (ejecutar diariamente a las 8:00 AM)
0 8 * * * /usr/bin/php /var/www/html/TaskEase/cron/check_notifications.php >> /var/log/taskease_cron.log 2>&1
```

### **8.3. Configurar Tarea Programada (Windows)**

1. Abrir: "Programador de tareas"
2. Crear tarea básica
3. Nombre: "TaskEase Notificaciones"
4. Desencadenador: Diariamente a las 8:00 AM
5. Acción: Iniciar programa
6. Programa: `C:\php\php.exe`
7. Argumentos: `C:\inetpub\wwwroot\TaskEase\cron\check_notifications.php`

---

## 🔒 PASO 9: Seguridad Adicional (Producción)

### **9.1. Configurar HTTPS**

**Apache:**
```bash
# Habilitar SSL
sudo a2enmod ssl
sudo a2ensite default-ssl

# Obtener certificado Let's Encrypt
sudo apt install certbot python3-certbot-apache
sudo certbot --apache -d taskease.tuempresa.com
```

**IIS:**
1. Obtener certificado SSL
2. Importar en IIS
3. Configurar binding HTTPS en sitio

### **9.2. Deshabilitar errores en pantalla**

Editar `includes/config.php`:

```php
// En PRODUCCIÓN cambiar a:
error_reporting(0);
ini_set('display_errors', 0);
ini_set('log_errors', 1);
ini_set('error_log', '/var/log/taskease_errors.log');
```

### **9.3. Restringir acceso a archivos sensibles**

Crear: `.htaccess` (Apache)

```apache
# Proteger archivos de configuración
<FilesMatch "^(config\.php|conexion\.php|functions\.php)$">
    Order Allow,Deny
    Deny from all
</FilesMatch>

# Proteger archivos SQL
<FilesMatch "\.sql$">
    Order Allow,Deny
    Deny from all
</FilesMatch>
```

### **9.4. Configurar backup automático**

**Linux:**
```bash
# Crear script de backup
cat > /usr/local/bin/backup_taskease.sh << 'EOF'
#!/bin/bash
FECHA=$(date +%Y%m%d_%H%M%S)
sqlcmd -S localhost -U sa -P 'TuContraseña' -Q "BACKUP DATABASE TaskEaseDB TO DISK = '/var/backups/taskease_$FECHA.bak'"
find /var/backups -name "taskease_*.bak" -mtime +30 -delete
EOF

chmod +x /usr/local/bin/backup_taskease.sh

# Programar backup diario (2:00 AM)
echo "0 2 * * * /usr/local/bin/backup_taskease.sh >> /var/log/backup_taskease.log 2>&1" | crontab -
```

---

## ✅ PASO 10: Verificación Final

### **10.1. Checklist de Instalación**

- [ ] PHP 7.4+ instalado
- [ ] SQL Server funcionando
- [ ] Drivers PHP para SQL Server instalados
- [ ] Base de datos creada correctamente
- [ ] Archivos copiados a la raíz web
- [ ] Permisos configurados en carpeta uploads
- [ ] Archivo de conexión configurado
- [ ] Login funciona correctamente
- [ ] Contraseñas cambiadas
- [ ] Emails configurados (opcional)
- [ ] CRON configurado (opcional)
- [ ] HTTPS configurado (producción)
- [ ] Backups configurados (producción)

### **10.2. Pruebas Funcionales**

1. **Login:**
   - Iniciar sesión como Admin
   - Iniciar sesión como Supervisor
   - Iniciar sesión como Colaborador

2. **Tableros:**
   - Crear nuevo tablero
   - Editar tablero
   - Ver lista de tableros

3. **Tareas:**
   - Crear nueva tarea
   - Asignar tarea a usuario
   - Actualizar estado
   - Agregar comentario
   - Subir archivo adjunto

4. **Notificaciones:**
   - Crear tarea → verificar notificación
   - Marcar notificación como leída

5. **Dashboards:**
   - Ver dashboard admin
   - Ver dashboard colaborador
   - Verificar estadísticas

---

## 🆘 SOLUCIÓN DE PROBLEMAS COMUNES

### **Error: "Could not find driver"**

**Causa:** Drivers PHP para SQL Server no instalados

**Solución:**
```bash
# Verificar extensiones cargadas
php -m | grep sqlsrv

# Si no aparece, instalar drivers
sudo pecl install sqlsrv pdo_sqlsrv
```

### **Error: "Login failed for user"**

**Causa:** Credenciales incorrectas en `conexion.php`

**Solución:**
1. Verificar usuario y contraseña de SQL Server
2. Asegurarse que el usuario tiene permisos en la base de datos
3. Verificar autenticación SQL Server habilitada

### **Error: "Permission denied" al subir archivos**

**Causa:** Falta de permisos en carpeta uploads

**Solución:**
```bash
chmod 777 /var/www/html/TaskEase/uploads
chown www-data:www-data /var/www/html/TaskEase/uploads
```

### **Error: "Headers already sent"**

**Causa:** Espacios en blanco antes de `<?php`

**Solución:**
- Verificar que no haya espacios o BOM antes de `<?php`
- Usar editor que soporte UTF-8 sin BOM

### **Notificaciones por email no funcionan**

**Solución:**
1. Verificar configuración SMTP en `config.php`
2. Probar con `test_email.php`
3. Revisar logs de PHP
4. Verificar firewall no bloquee puerto 587

---

## 📞 SOPORTE Y CONTACTO

**Documentación adicional:**
- README.md
- EXPLICACION_PROYECTO.md
- Comentarios en el código fuente

**Repositorio original:**
- https://github.com/Ankurac7/TaskEase

**Desarrollado por:** Claude AI
**Versión:** 2.0 Pro
**Fecha:** Noviembre 2025

---

## 🎉 ¡INSTALACIÓN COMPLETADA!

Si llegaste hasta aquí, **¡felicidades!** TaskEase Pro está instalado y listo para usar.

**Próximos pasos:**
1. Cambiar todas las contraseñas por defecto
2. Crear departamentos de tu empresa
3. Dar de alta a tus usuarios
4. Crear tus primeros tableros
5. Comenzar a gestionar proyectos

**¡Bienvenido a TaskEase Pro!** 🚀
