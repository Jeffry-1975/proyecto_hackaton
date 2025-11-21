<%-- 
    Document   : index
    Created on : 27 oct. 2025, 08:19:14
    Author     : diego
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es" class="h-full">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sistema de Gestión de Grados y Títulos</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Crimson+Text:wght@400;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            box-sizing: border-box;
            font-family: 'Inter', sans-serif;
        }
        .academic-title {
            font-family: 'Crimson Text', serif;
        }
        .fade-in {
            animation: fadeIn 0.8s ease-in;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .academic-pattern {
            background-image: 
                radial-gradient(circle at 25% 25%, rgba(59, 130, 246, 0.05) 0%, transparent 50%),
                radial-gradient(circle at 75% 75%, rgba(99, 102, 241, 0.05) 0%, transparent 50%);
        }
        /* --- Estilos para el Modal --- */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(0, 0, 0, 0.5);
            display: none; /* Oculto por defecto */
            align-items: center;
            justify-content: center;
            z-index: 50;
            animation: fadeIn 0.3s ease;
        }
        .modal-content {
            background-color: white;
            border-radius: 0.75rem; /* rounded-xl */
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
            width: 90%;
            max-width: 450px;
            animation: fadeIn 0.3s ease;
            max-height: 90vh;
            overflow-y: auto;
        }
        .modal-overlay.active {
            display: flex;
        }
    </style>
</head>
<body class="h-full bg-gradient-to-br from-blue-50 via-indigo-50 to-sky-100 academic-pattern relative overflow-hidden">
    
    <!-- Imagen de fondo con transparencia -->
    <div class="absolute inset-0 z-0">
        <img src="${pageContext.request.contextPath}/img/fondo.jpg" 
             alt="Background" 
             class="w-full h-full object-cover opacity-20"
             onerror="this.style.display='none'">
    </div>

    <!-- Login Screen -->
    <div class="h-full flex items-center justify-center p-4 relative z-10">
        <div class="w-full max-w-6xl grid lg:grid-cols-2 gap-8 lg:gap-12 items-center">
            
            <!-- Left Section - Academic Branding -->
            <div class="text-center space-y-6 fade-in">
                <div class="flex justify-center mb-8">
                    <div class="relative">
                        <img src="${pageContext.request.contextPath}/img/uplaAzul.png"  
                             alt="Logo Universidad" 
                             class="w-32 h-32 object-contain drop-shadow-2xl">
                    </div>
                </div>
                <div class="space-y-4">
                    <h1 class="academic-title text-4xl lg:text-5xl font-bold leading-tight">
                        <span class="text-blue-900">Universidad Peruana</span><br>
                        <span class="bg-gradient-to-r from-blue-700 via-indigo-700 to-blue-800 bg-clip-text text-transparent font-extrabold">Los Andes</span>
                    </h1>
                    <div class="flex items-center justify-center space-x-2">
                        <div class="w-16 h-1 bg-gradient-to-r from-blue-500 to-indigo-600 rounded-full"></div>
                        <div class="w-2 h-2 bg-amber-500 rounded-full"></div>
                        <div class="w-8 h-1 bg-gradient-to-r from-indigo-600 to-blue-500 rounded-full"></div>
                    </div>
                    <p class="text-xl text-blue-800 font-semibold tracking-wide">Sistema de Gestión de Grados y Títulos</p>
                    <p class="text-sm text-blue-600 font-medium italic">Excelencia Académica e Investigación</p>
                </div>
                <div class="space-y-4 mt-8">
                    <div class="flex items-center justify-center space-x-3 group">
                        <div class="w-8 h-8 bg-blue-100 rounded-lg flex items-center justify-center group-hover:bg-blue-200 transition-colors">
                            <div class="w-2.5 h-2.5 bg-blue-700 rounded-full"></div>
                        </div>
                        <span class="text-sm font-semibold text-blue-900">Plataforma Académica Integral</span>
                    </div>
                    <div class="flex items-center justify-center space-x-3 group">
                        <div class="w-8 h-8 bg-indigo-100 rounded-lg flex items-center justify-center group-hover:bg-indigo-200 transition-colors">
                            <div class="w-2.5 h-2.5 bg-indigo-700 rounded-full"></div>
                        </div>
                        <span class="text-sm font-semibold text-blue-900">Seguimiento de Proyectos de Investigación</span>
                    </div>
                    <div class="flex items-center justify-center space-x-3 group">
                        <div class="w-8 h-8 bg-sky-100 rounded-lg flex items-center justify-center group-hover:bg-sky-200 transition-colors">
                            <div class="w-2.5 h-2.5 bg-sky-700 rounded-full"></div>
                        </div>
                        <span class="text-sm font-semibold text-blue-900">Evaluación y Supervisión Académica</span>
                    </div>
                </div>
                <div class="mt-8 pt-6 border-t border-blue-200">
                    <p class="text-xs text-blue-600 font-medium italic text-center">
                        "Lux et Veritas • Ciencia y Conocimiento"
                    </p>
                </div>
            </div>

            <!-- Right Section - Login Form -->
            <div class="w-full max-w-md mx-auto fade-in">
                <div class="bg-white shadow-2xl rounded-2xl border border-slate-200 overflow-hidden">
                    <div class="bg-gradient-to-r from-slate-50 to-blue-50 px-8 py-6 border-b border-slate-200">
                        <div class="text-center">
                            <div class="w-12 h-12 bg-gradient-to-br from-blue-600 to-indigo-600 rounded-xl flex items-center justify-center mx-auto mb-4 shadow-lg">
                                <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 7a2 2 0 012 2m4 0a6 6 0 01-7.743 5.743L11 17H9v2H7v2H4a1 1 0 01-1-1v-2.586a1 1 0 01.293-.707l5.964-5.964A6 6 0 1121 9z"></path></svg>
                            </div>
                            <h2 class="text-2xl font-bold text-slate-800 mb-2">Inicio de Sesión</h2>
                            <p class="text-sm text-slate-600">Ingresa tus credenciales institucionales</p>
                        </div>
                    </div>

                    <div class="px-8 py-6">
                        <form id="login-form" class="space-y-5" action="LoginServlet" method="POST">
                            <div>
                                <label for="email" class="block text-sm font-semibold text-slate-700 mb-2">Correo Institucional</label>
                                <div class="relative">
                                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                        <svg class="h-5 w-5 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 12a4 4 0 10-8 0 4 4 0 008 0zm0 0v1.5a2.5 2.5 0 005 0V12a9 9 0 10-9 9m4.5-1.206a8.959 8.959 0 01-4.5 1.207"></path></svg>
                                    </div>
                                    <input id="email" name="email" type="email" required 
                                        class="block w-full pl-10 pr-3 py-3 border border-slate-300 rounded-lg text-slate-900 placeholder-slate-500 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition duration-200 bg-slate-50 focus:bg-white" 
                                        placeholder="usuario@ms.upla.edu.pe">
                                </div>
                            </div>

                            <div>
                                <label for="password" class="block text-sm font-semibold text-slate-700 mb-2">Contraseña</label>
                                <div class="relative">
                                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                        <svg class="h-5 w-5 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path></svg>
                                    </div>
                                    <input id="password" name="password" type="password" required 
                                        class="block w-full pl-10 pr-10 py-3 border border-slate-300 rounded-lg text-slate-900 placeholder-slate-500 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition duration-200 bg-slate-50 focus:bg-white" 
                                        placeholder="••••••••">
                                    <button type="button" id="btn-toggle-password" class="absolute inset-y-0 right-0 pr-3 flex items-center text-slate-400 hover:text-slate-600">
                                        <svg id="icon-eye-pass" class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-.474 1.26-1.001 2.44-1.59 3.528M15 14l-3-3m-3.97-3.97l-1.55 1.55m-1.4 1.4L6 14m9-2l2 2"></path></svg>
                                        <svg id="icon-eye-slashed-pass" class="h-5 w-5 hidden" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.542-7 .964-2.55 2.86-4.72 5.125-6.108M14.5 9.5A3.5 3.5 0 0011 6c-1.933 0-3.5 1.567-3.5 3.5a3.5 3.5 0 004.28 3.447M19.5 19.5L4.5 4.5"></path></svg>
                                    </button>
                                </div>
                            </div>

                            <div class="flex items-center justify-between text-sm">
                                <div class="flex items-center">
                                    <input id="remember-me" name="remember-me" type="checkbox" 
                                        class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-slate-300 rounded">
                                    <label for="remember-me" class="ml-2 text-slate-700">Recordar sesión</label>
                                </div>
                                <button type="button" id="btn-forgot-password" class="font-medium text-blue-600 hover:text-blue-500 transition duration-200">
                                    ¿Olvidaste tu contraseña?
                                </button>
                            </div>

                            <button type="submit" 
                                    class="w-full flex justify-center py-3 px-4 border border-transparent rounded-lg shadow-lg text-sm font-semibold text-white bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-700 hover:to-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition duration-200 transform hover:scale-[1.02]">
                                <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 16l-4-4m0 0l4-4m-4 4h14m-5 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h7a3 3 0 013 3v1"></path></svg>
                                Iniciar Sesión
                            </button>
                        </form>

                        <div id="login-error-container" class="mt-4">
                            <c:if test="${not empty errorMsg}">
                                <div class="p-3 bg-red-100 border border-red-400 text-red-700 rounded-lg text-sm">
                                    ${errorMsg}
                                </div>
                            </c:if>
                        </div>

                        <div class="mt-6 pt-6 border-t border-slate-200">
                            <p class="text-xs text-center text-slate-500 mb-4 uppercase tracking-wide font-medium">Usuarios de Demostración</p>
                            <div class="grid grid-cols-3 gap-2">
                                <button type="button" id="btn-demo-admin"
                                        class="p-2 bg-red-50 hover:bg-red-100 border border-red-200 rounded-lg transition duration-200 group">
                                    <div class="text-center">
                                        <div class="w-6 h-6 bg-red-500 rounded-full mx-auto mb-1 flex items-center justify-center">
                                            <svg class="w-3 h-3 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"></path></svg>
                                        </div>
                                        <p class="text-xs font-medium text-red-800">Admin</p>
                                    </div>
                                </button>
                                <button type="button" id="btn-demo-alumno" 
                                        class="p-2 bg-green-50 hover:bg-green-100 border border-green-200 rounded-lg transition duration-200 group">
                                    <div class="text-center">
                                        <div class="w-6 h-6 bg-green-500 rounded-full mx-auto mb-1 flex items-center justify-center">
                                            <svg class="w-3 h-3 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path></svg>
                                        </div>
                                        <p class="text-xs font-medium text-green-800">Estudiante</p>
                                    </div>
                                </button>
                                <button type="button" id="btn-demo-docente"
                                        class="p-2 bg-blue-50 hover:bg-blue-100 border border-blue-200 rounded-lg transition duration-200 group">
                                    <div class="text-center">
                                        <div class="w-6 h-6 bg-blue-500 rounded-full mx-auto mb-1 flex items-center justify-center">
                                            <svg class="w-3 h-3 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path></svg>
                                        </div>
                                        <p class="text-xs font-medium text-blue-800">Docente</p>
                                    </div>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="text-center mt-6 text-xs text-slate-500">
                    © 2025 Universidad Peruana Los Andes
                </div>
            </div>
        </div>
    </div>

    <!-- HTML del Modal para Olvidé Contraseña -->
    <div id="forgot-password-modal" class="modal-overlay">
        <div class="modal-content">
            <form id="forgot-form" class="p-6 space-y-4">
                <div class="flex justify-between items-center">
                    <h3 class="text-xl font-semibold text-gray-900">Restablecer Contraseña</h3>
                    <button type="button" id="btn-close-forgot-modal" class="text-gray-400 hover:text-gray-600">
                        <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                    </button>
                </div>
                <div>
                    <label for="forgot_email" class="block text-sm font-medium text-gray-700">Correo Institucional</label>
                    <input type="email" id="forgot_email" name="forgot_email" class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2" placeholder="usuario@ms.upla.edu.pe" required>
                </div>
                <div id="forgot-message-container" class="text-sm"></div>
                <div class="flex justify-end space-x-3 pt-4">
                    <button type="button" id="btn-cancel-forgot-modal" class="bg-gray-100 hover:bg-gray-200 text-gray-700 px-4 py-2 rounded-lg font-medium transition">
                        Cancelar
                    </button>
                    <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg font-medium transition">
                        Enviar Enlace
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // --- FUNCIONES DE MODAL ---
        function openModal(modalId) {
            const modal = document.getElementById(modalId);
            if (modal) modal.classList.add('active');
        }
        function closeModal(modalId) {
            const modal = document.getElementById(modalId);
            if (modal) modal.classList.remove('active');
        }
        
        // --- FUNCIONES DE LOGIN ---
        function fillCredentials(email, password) {
            document.getElementById('email').value = email;
            document.getElementById('password').value = password;
        }

        function handleLogin(event) {
            event.preventDefault();
            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;
            const errorContainer = document.getElementById('login-error-container');
            
            errorContainer.innerHTML = ''; // Limpia errores
            
            if (email === 'admin@ms.upla.edu.pe' && password === 'admin123') {
                window.location.href = 'admin.jsp'; 
            } else if (email === 'a.dflores@ms.upla.edu.pe' && password === 'diego123') {
                window.location.href = 'student.jsp'; 
            } else if (email === 'd.rfernandez@ms.upla.edu.pe' && password === 'raul123') {
                window.location.href = 'teacher.jsp';
            } else {
                errorContainer.innerHTML = `<div class="p-3 bg-red-100 border border-red-400 text-red-700 rounded-lg text-sm">Credenciales incorrectas. Por favor, intenta de nuevo.</div>`;
                setTimeout(() => { errorContainer.innerHTML = ''; }, 3000);
            }
        }
        
        // --- EVENT LISTENERS CENTRALIZADOS ---
        document.addEventListener('DOMContentLoaded', () => {
            
            //document.getElementById('login-form').addEventListener('submit', handleLogin);
            
            document.getElementById('btn-demo-admin').addEventListener('click', () => fillCredentials('admin@ms.upla.edu.pe', 'admin123'));
            document.getElementById('btn-demo-alumno').addEventListener('click', () => fillCredentials('a.dflores@ms.upla.edu.pe', 'diego123'));
            document.getElementById('btn-demo-docente').addEventListener('click', () => fillCredentials('d.rfernandez@ms.upla.edu.pe', 'raul123'));

            // Evento para Ver/Ocultar Contraseña
            const passwordInput = document.getElementById('password');
            const toggleButton = document.getElementById('btn-toggle-password');
            const iconEye = document.getElementById('icon-eye-pass');
            const iconEyeSlashed = document.getElementById('icon-eye-slashed-pass');

            toggleButton.addEventListener('click', () => {
                const isPassword = passwordInput.type === 'password';
                passwordInput.type = isPassword ? 'text' : 'password';
                iconEye.classList.toggle('hidden', isPassword);
                iconEyeSlashed.classList.toggle('hidden', !isPassword);
            });

            // Eventos para Modal "Olvidé Contraseña"
            const forgotModal = document.getElementById('forgot-password-modal');
            
            document.getElementById('btn-forgot-password').addEventListener('click', () => openModal('forgot-password-modal'));
            document.getElementById('btn-close-forgot-modal').addEventListener('click', () => closeModal('forgot-password-modal'));
            document.getElementById('btn-cancel-forgot-modal').addEventListener('click', () => closeModal('forgot-password-modal'));
            
            document.getElementById('forgot-form').addEventListener('submit', (event) => {
                event.preventDefault();
                const email = document.getElementById('forgot_email').value;
                const messageContainer = document.getElementById('forgot-message-container');
                
                console.log(`Simulando envío de enlace a: ${email}`);
                messageContainer.innerHTML = `<div class="p-3 bg-green-100 border border-green-400 text-green-700 rounded-lg text-sm">Si existe una cuenta con ${email}, se ha enviado un enlace.</div>`;
                
                setTimeout(() => {
                    closeModal('forgot-password-modal');
                    messageContainer.innerHTML = '';
                }, 2500);
            });

            forgotModal.addEventListener('click', (event) => {
                if (event.target === event.currentTarget) {
                    closeModal('forgot-password-modal');
                }
            });
        });
    </script>
</body>
</html>