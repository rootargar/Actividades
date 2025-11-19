<?php
/**
 * Página de Inicio - Redirige al Login
 * TaskEase - Sistema de Gestión de Tareas
 */

require_once 'includes/config.php';
require_once 'includes/functions.php';

// Si ya está logueado, redirigir al dashboard correspondiente
if (isLoggedIn()) {
    if (isAdmin() || isSupervisor()) {
        redirect('admin/dashboard.php');
    } else {
        redirect('user/dashboard.php');
    }
} else {
    // Si no está logueado, redirigir al login
    redirect('login.php');
}
?>