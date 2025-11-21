<%-- 
    Document   : student.jsp
    DESCRIPCIÓN: Portal del Estudiante - Notificaciones por Clic y Ajustes de Texto
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %> 

<!DOCTYPE html>
<html lang="es" class="h-full">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Portal del Estudiante - UPLA</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Iconos (Lucide/Heroicons style) -->
    <script src="https://unpkg.com/lucide@latest"></script>
    <style>
        body { font-family: 'Inter', sans-serif; }
        .fade-in { animation: fadeIn 0.6s cubic-bezier(0.4, 0, 0.2, 1); }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
        
        /* Navegación */
        .tab-button { transition: all 0.3s ease; border-radius: 0.5rem; }
        .tab-active { background-color: #047857; color: #ffffff; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06); transform: translateX(4px); }
        .tab-inactive:hover { background-color: #064e3b; color: #ffffff; padding-left: 1.25rem; }
        
        .tab-content { display: none; }
        .tab-content.active { display: block; }
        
        /* Stepper de Trámites */
        .step-circle { width: 3rem; height: 3rem; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; z-index: 10; transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1); position: relative; }
        .step-active .step-circle { background-color: #059669; color: white; border: 4px solid #d1fae5; box-shadow: 0 0 0 2px #059669; }
        .step-inactive .step-circle { background-color: white; color: #9ca3af; border: 2px solid #e5e7eb; }
        
        /* Modales */
        .modal-overlay { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background-color: rgba(0, 50, 20, 0.5); backdrop-filter: blur(4px); display: none; align-items: center; justify-content: center; z-index: 50; animation: fadeIn 0.2s ease-out; }
        .modal-content { background-color: white; border-radius: 1.5rem; box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25); width: 90%; max-width: 600px; animation: slideUp 0.4s cubic-bezier(0.16, 1, 0.3, 1); transform-origin: bottom; }
        .modal-content-xl { max-width: 1000px; width: 95%; height: 85vh; display: flex; flex-direction: column; }
        @keyframes slideUp { from { transform: translateY(40px) scale(0.95); opacity: 0; } to { transform: translateY(0) scale(1); opacity: 1; } }
        .modal-overlay.active { display: flex; }

        /* Gráfico Circular CSS Puro */
        .circular-chart { display: block; margin: 0 auto; max-width: 80%; max-height: 250px; }
        .circle-bg { fill: none; stroke: #ecfdf5; stroke-width: 2.5; }
        .circle { fill: none; stroke-width: 2.5; stroke-linecap: round; animation: progress 1.5s ease-out forwards; }
        @keyframes progress { 0% { stroke-dasharray: 0 100; } }
        
        /* Tabla Rúbrica */
        .rubric-row:nth-child(even) { background-color: #f0fdf4; }
        .score-cell { text-align: center; font-weight: 600; }
        .score-c { color: #059669; background-color: #d1fae5; } /* Verde Fuerte */
        .score-cp { color: #d97706; background-color: #fffbeb; } /* Amarillo */
        .score-nc { color: #dc2626; background-color: #fef2f2; } /* Rojo */
    </style>
</head>
<body class="h-full bg-gradient-to-br from-green-50 via-emerald-50 to-teal-100">
    <div class="flex flex-col lg:flex-row h-full">
        
        <!-- Sidebar Clásico Verde -->
        <div class="w-full lg:w-72 bg-gradient-to-b from-green-800 to-green-900 shadow-2xl min-h-full flex-shrink-0 text-white z-30">
            <div class="p-6 h-full flex flex-col">
                <!-- Perfil -->
                <div class="text-center mb-10 pt-6">
                    <div class="relative mx-auto w-24 h-24 mb-4 group">
                        <div class="absolute inset-0 bg-green-400 rounded-full blur opacity-40 group-hover:opacity-60 transition duration-500"></div>
                        <div class="relative w-full h-full bg-white/10 backdrop-blur-sm rounded-full flex items-center justify-center border-2 border-green-300/50">
                            <span class="text-3xl font-bold text-white">${fn:substring(sessionScope.usuarioLogueado.nombres, 0, 1)}${fn:substring(sessionScope.usuarioLogueado.apellidos, 0, 1)}</span>
                        </div>
                    </div>
                    <h3 class="text-white font-bold text-lg tracking-tight mb-1">${sessionScope.usuarioLogueado.getNombreCompleto()}</h3>
                    <p class="text-green-200 text-xs uppercase tracking-wider font-semibold">${sessionScope.usuarioLogueado.codigo}</p>
                </div>
                
                <!-- Navegación -->
                <nav class="space-y-1 flex-1">
                    <c:if test="${not empty tesis}">
                        <p class="px-4 text-[10px] font-bold text-green-300 uppercase tracking-widest mb-3 mt-2">Académico</p>
                        <button id="btn-evaluacion" class="tab-button tab-inactive w-full text-left px-4 py-3 text-sm font-medium flex items-center group">
                            <svg class="w-5 h-5 mr-3 opacity-80" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                            Mi Evaluación
                        </button>
                        <button id="btn-subir" class="tab-button tab-inactive w-full text-left px-4 py-3 text-sm font-medium flex items-center group">
                            <svg class="w-5 h-5 mr-3 opacity-80" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12"></path></svg>
                            Subir Tesis
                        </button>
                        <button id="btn-historial" class="tab-button tab-inactive w-full text-left px-4 py-3 text-sm font-medium flex items-center group">
                            <svg class="w-5 h-5 mr-3 opacity-80" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                            Historial
                        </button>
                    </c:if>
                    
                    <p class="px-4 text-[10px] font-bold text-green-300 uppercase tracking-widest mb-3 mt-6">Administrativo</p>
                    <button id="btn-tramites" class="tab-button tab-inactive w-full text-left px-4 py-3 text-sm font-medium flex items-center group">
                        <svg class="w-5 h-5 mr-3 opacity-80" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"></path></svg>
                        Carpeta de Titulación
                    </button>
                </nav>

                <!-- Botón Logout Sidebar (Móvil) - CORREGIDO COLOR -->
                <div class="mt-auto pt-6 border-t border-green-700/50 lg:hidden">
                    <button id="btn-logout-sidebar" onclick="logout()" class="w-full bg-green-900/50 hover:bg-green-700 text-green-100 hover:text-white px-4 py-2.5 rounded-lg text-sm font-semibold transition flex items-center justify-center">
                        <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path></svg> Cerrar Sesión
                    </button>
                </div>
            </div>
        </div>

        <!-- Contenido -->
        <div class="flex-1 flex flex-col min-h-0 relative">
            
            <!-- Header Sticky -->
            <header class="bg-white/80 backdrop-blur-md border-b border-green-100 sticky top-0 z-20">
                <div class="px-8 py-4 flex justify-between items-center">
                    <div>
                        <h1 id="main-title" class="text-2xl font-bold text-gray-800">Panel del Estudiante</h1>
                        <p class="text-xs font-medium text-green-600 mt-0.5">Universidad Peruana Los Andes</p>
                    </div>
                    
                    <div class="flex items-center space-x-4">
                        <!-- Notificaciones (Lógica Click) -->
                        <div class="relative">
                            <button id="btn-notificaciones-toggle" class="p-2.5 hover:bg-green-50 rounded-full transition text-gray-500 hover:text-green-600 relative focus:outline-none">
                                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-5 5v-5zM4 19h6v-7a1 1 0 011-1h4a1 1 0 011 1v7h6"></path></svg>
                                <c:if test="${not empty notificaciones}">
                                    <span class="absolute top-1 right-1 h-2.5 w-2.5 bg-red-500 rounded-full ring-2 ring-white"></span>
                                </c:if>
                            </button>
                            
                            <!-- Dropdown (Oculto por defecto) -->
                            <div id="dropdown-notificaciones" class="hidden absolute right-0 mt-2 w-80 bg-white border border-gray-100 rounded-2xl shadow-xl z-50 overflow-hidden transform transition-all duration-200 origin-top-right">
                                <div class="bg-green-50 px-4 py-3 border-b border-green-100"><p class="text-xs font-bold text-green-800 uppercase">Notificaciones</p></div>
                                <div class="max-h-64 overflow-y-auto">
                                    <c:forEach var="noti" items="${notificaciones}">
                                        <div class="p-4 hover:bg-green-50 border-b border-gray-50 transition">
                                            <p class="text-sm text-gray-800 font-medium">${noti.mensaje}</p>
                                            <p class="text-xs text-gray-400 mt-1"><fmt:formatDate value="${noti.fechaEnvio}" pattern="dd MMM, HH:mm"/></p>
                                        </div>
                                    </c:forEach>
                                    <c:if test="${empty notificaciones}"><div class="p-6 text-center text-sm text-gray-400">Sin novedades.</div></c:if>
                                </div>
                            </div>
                        </div>

                        <!-- Logout Escritorio - VERDE -->
                        <button id="btn-logout-header" onclick="logout()" class="hidden lg:flex bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded-lg text-sm font-semibold transition items-center shadow-sm">
                            <span class="mr-2">Cerrar Sesión</span>
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path></svg>
                        </button>
                    </div>
                </div>
            </header>            

            <main class="flex-1 overflow-y-auto p-4 lg:p-8 scroll-smooth">
                
                <!-- Mensajes del Sistema -->
                <div class="mb-6 space-y-2">
                    <c:if test="${not empty studentMsg}">
                        <div class="p-4 bg-green-100 border-l-4 border-green-600 text-green-800 rounded-r-lg shadow-sm flex items-center animate-pulse">
                            <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg> ${studentMsg}
                        </div>
                    </c:if>
                    <c:if test="${not empty studentError}">
                        <div class="p-4 bg-red-100 border-l-4 border-red-600 text-red-800 rounded-r-lg shadow-sm flex items-center">
                            <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg> ${studentError}
                        </div>
                    </c:if>
                </div>
                
                <!-- DASHBOARD VACÍO -->
                <c:if test="${empty tesis}">
                    <div id="dashboard-empty" class="tab-content active fade-in max-w-3xl mx-auto mt-10">
                        <div class="bg-white shadow-xl rounded-3xl p-12 text-center border border-green-100">
                            <div class="mx-auto w-24 h-24 bg-green-50 rounded-full flex items-center justify-center mb-6 animate-bounce">
                                <svg class="w-12 h-12 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14.828 14.828a4 4 0 01-5.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                            </div>
                            <h2 class="text-3xl font-bold text-gray-800 mb-4">¡Bienvenido a tu Portal!</h2>
                            <p class="text-gray-500 mb-8 text-lg">Actualmente no tienes un proyecto de tesis asignado, pero puedes adelantar tus trámites administrativos.</p>
                            <button onclick="showTab('tramites')" class="bg-green-600 text-white px-8 py-3.5 rounded-xl font-bold hover:bg-green-700 shadow-lg shadow-green-500/30 transition transform hover:-translate-y-1">
                                Ir a mi Carpeta de Titulación
                            </button>
                        </div>
                    </div>
                </c:if>
                
                <c:if test="${not empty tesis}">
                    
                    <!-- ========================================== -->
                    <!-- PESTAÑA 1: MI EVALUACIÓN (DISEÑO MEJORADO - COLORES CLÁSICOS) -->
                    <!-- ========================================== -->
                    <div id="evaluacion" class="tab-content fade-in">
                        
                        <!-- Título de la Tesis -->
                        <div class="mb-8">
                            <span class="text-xs font-bold text-green-600 uppercase tracking-wider">Proyecto de Tesis Actual</span>
                            <h2 class="text-3xl font-bold text-gray-900 mt-1 leading-tight max-w-4xl">${tesis.titulo}</h2>
                            <div class="flex items-center mt-3 space-x-4 text-sm text-gray-500">
                                <span class="flex items-center"><svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path></svg> ${tesis.nombreDocenteRevisor}</span>
                                <span class="px-2.5 py-0.5 rounded-full text-xs font-semibold ${tesis.estado == 'Aprobado' ? 'bg-green-100 text-green-700' : 'bg-yellow-100 text-yellow-700'}">${tesis.estado}</span>
                            </div>
                        </div>

                        <div class="grid grid-cols-1 xl:grid-cols-3 gap-8">
                            
                            <!-- Columna Izquierda: Resultados y Acciones -->
                            <div class="xl:col-span-1 space-y-6">
                                <c:if test="${not empty evaluacion}">
                                    <!-- Tarjeta de Puntaje -->
                                    <div class="bg-white rounded-3xl shadow-xl overflow-hidden border border-green-100 relative group">
                                        <div class="absolute top-0 left-0 w-full h-2 bg-gradient-to-r from-green-500 to-teal-500"></div>
                                        <div class="p-8 text-center relative z-10">
                                            <h3 class="text-lg font-semibold text-gray-800 mb-6">Calificación Final</h3>
                                            
                                            <!-- Gráfico Circular -->
                                            <div class="mb-6 relative">
                                                <svg viewBox="0 0 36 36" class="circular-chart w-48 h-48 mx-auto transform -rotate-90 drop-shadow-lg">
                                                    <path class="circle-bg" d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831" />
                                                    <c:set var="percentage" value="${(evaluacion.puntajeTotal / 38.0) * 100}" />
                                                    <path class="circle" stroke="${evaluacion.condicion == 'Aprobado' ? '#10b981' : (evaluacion.condicion == 'Aprobado con observaciones menores' ? '#f59e0b' : '#ef4444')}" stroke-dasharray="${percentage}, 100" d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831" />
                                                </svg>
                                                <div class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 text-center">
                                                    <span class="text-4xl font-bold text-gray-800 block"><fmt:formatNumber value="${evaluacion.puntajeTotal}" maxFractionDigits="1"/></span>
                                                    <span class="text-xs text-gray-400 uppercase font-bold">de 38 pts</span>
                                                </div>
                                            </div>
                                            
                                            <div class="inline-block px-4 py-2 rounded-lg bg-gray-50 border border-gray-200 mb-6">
                                                <p class="text-sm font-bold ${evaluacion.condicion == 'Aprobado' ? 'text-green-600' : 'text-red-600'}">${evaluacion.condicion}</p>
                                            </div>

                                            <!-- Botones de Acción -->
                                            <div class="space-y-3">
                                                <a href="${pageContext.request.contextPath}/ReporteEvaluacionServlet?id=${evaluacion.idEvaluacion}" class="flex items-center justify-center w-full bg-green-800 hover:bg-green-900 text-white py-3.5 rounded-xl font-semibold transition shadow-lg hover:shadow-xl transform hover:-translate-y-0.5">
                                                    <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"></path></svg>
                                                    Descargar Informe (PDF)
                                                </a>
                                                <button onclick="openModal('modal-rubrica-detalle')" class="flex items-center justify-center w-full bg-white border-2 border-green-100 text-green-700 hover:border-green-200 hover:bg-green-50 py-3.5 rounded-xl font-semibold transition">
                                                    <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"></path></svg>
                                                    Ver Rúbrica Detallada
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                                
                                <c:if test="${empty evaluacion}">
                                    <div class="bg-white rounded-3xl shadow-lg p-10 text-center border border-gray-100">
                                        <div class="w-16 h-16 bg-green-50 rounded-full flex items-center justify-center mx-auto mb-4">
                                            <svg class="w-8 h-8 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                                        </div>
                                        <h3 class="text-lg font-bold text-gray-800">Evaluación Pendiente</h3>
                                        <p class="text-gray-500 text-sm mt-2">Tu asesor aún no ha emitido la calificación para esta tesis.</p>
                                    </div>
                                </c:if>
                            </div>

                            <!-- Columna Derecha: Feedback y Archivos -->
                            <div class="xl:col-span-2 space-y-6">
                                <!-- Feedback -->
                                <c:if test="${not empty evaluacion}">
                                    <div class="bg-white rounded-3xl shadow-lg p-8 border border-green-100">
                                        <h3 class="text-lg font-bold text-gray-800 mb-6 flex items-center">
                                            <span class="w-8 h-8 bg-green-100 rounded-lg flex items-center justify-center mr-3 text-green-600"><svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 10h.01M12 10h.01M16 10h.01M9 16H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-5l-5 5v-5z"></path></svg></span>
                                            Comentarios
                                        </h3>
                                        <div class="relative bg-green-50 p-6 rounded-2xl border border-green-200">
                                            <svg class="absolute top-4 left-4 w-8 h-8 text-green-200 transform -translate-x-2 -translate-y-2" fill="currentColor" viewBox="0 0 24 24"><path d="M14.017 21L14.017 18C14.017 16.8954 14.9124 16 16.017 16H19.017C19.5693 16 20.017 15.5523 20.017 15V9C20.017 8.44772 19.5693 8 19.017 8H15.017C14.4647 8 14.017 8.44772 14.017 9V11C14.017 11.5523 13.5693 12 13.017 12H12.017V5H22.017C22.5693 5 23.017 5.44772 23.017 6V15C23.017 15.5523 22.5693 16 22.017 16H19.017C17.9124 16 17.017 16.8954 17.017 18V21H14.017ZM5.0166 21L5.0166 18C5.0166 16.8954 5.91203 16 7.0166 16H10.0166C10.5689 16 11.0166 15.5523 11.0166 15V9C11.0166 8.44772 10.5689 8 10.0166 8H6.0166C5.46432 8 5.0166 8.44772 5.0166 9V11C5.0166 11.5523 4.56889 12 4.0166 12H3.0166V5H13.0166C13.5689 5 14.0166 5.44772 14.0166 6V15C14.0166 15.5523 13.5689 16 13.0166 16H10.0166C8.91203 16 8.0166 16.8954 8.0166 18V21H5.0166Z"></path></svg>
                                            <p class="text-gray-700 leading-relaxed pl-6 relative z-10 font-medium italic">
                                                "${evaluacion.comentarios}"
                                            </p>
                                        </div>
                                        <div class="mt-4 flex justify-end">
                                            <span class="text-xs font-bold text-gray-400 uppercase tracking-wider">Evaluado el <fmt:formatDate value="${evaluacion.fechaEvaluacion}" pattern="dd MMM yyyy"/></span>
                                        </div>
                                    </div>
                                </c:if>
                                
                                <!-- Archivo Actual -->
                                <div class="bg-white rounded-3xl shadow-lg p-8 border border-green-100">
                                    <h3 class="text-lg font-bold text-gray-800 mb-4">Documento de Tesis</h3>
                                    <div class="flex items-center justify-between p-4 bg-gray-50 rounded-xl border border-gray-200 group hover:border-green-500/50 transition">
                                        <div class="flex items-center">
                                            <div class="w-12 h-12 bg-red-100 rounded-lg flex items-center justify-center mr-4 text-red-600">
                                                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z"></path></svg>
                                            </div>
                                            <div>
                                                <p class="text-sm font-semibold text-gray-900 group-hover:text-green-700 transition">Versión Actual</p>
                                                <p class="text-xs text-gray-500">${tesis.archivoPath}</p>
                                            </div>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/DownloadServlet?file=${tesis.archivoPath}" target="_blank" class="px-4 py-2 bg-white border border-gray-200 rounded-lg text-sm font-medium text-gray-600 hover:text-green-600 hover:border-green-200 transition shadow-sm">
                                            Ver
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Pestaña 2: Subir Correcciones -->
                    <div id="subir" class="tab-content fade-in">
                        <div class="max-w-2xl mx-auto bg-white shadow-xl rounded-3xl p-10 border border-green-100">
                            <h2 class="text-2xl font-bold text-gray-800 mb-2">Subir Nueva Versión</h2>
                            <p class="text-gray-500 mb-8">Asegúrate de que tu archivo PDF incluya todas las correcciones solicitadas.</p>
                            <form action="${pageContext.request.contextPath}/SubirCorreccionServlet" method="POST" enctype="multipart/form-data" class="space-y-6">
                                <input type="hidden" name="id_tesis" value="${tesis.idTesis}">
                                <div class="border-2 border-dashed border-gray-300 rounded-2xl p-8 text-center hover:bg-gray-50 transition cursor-pointer relative">
                                    <input type="file" name="tesis_file" accept=".pdf" class="absolute inset-0 w-full h-full opacity-0 cursor-pointer" required>
                                    <div class="w-12 h-12 bg-green-50 text-green-600 rounded-full flex items-center justify-center mx-auto mb-3"><svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12"></path></svg></div>
                                    <p class="text-sm font-medium text-gray-900">Haz clic para seleccionar</p>
                                    <p class="text-xs text-gray-500 mt-1">Solo archivos PDF (Max 15MB)</p>
                                </div>
                                <div>
                                    <label class="block text-sm font-semibold text-gray-700 mb-2">Nota para el asesor (Opcional)</label>
                                    <textarea name="comentario_alumno" rows="3" class="w-full border border-gray-300 rounded-xl p-3 text-sm focus:ring-2 focus:ring-green-500 outline-none" placeholder="Ej: Se corrigió el capítulo 3..."></textarea>
                                </div>
                                <button type="submit" class="w-full bg-green-600 hover:bg-green-700 text-white py-3.5 rounded-xl font-bold shadow-lg shadow-green-500/30 transition transform hover:-translate-y-1">Enviar Correcciones</button>
                            </form>
                        </div>
                    </div>
                    
                    <!-- Pestaña 3: Historial -->
                    <div id="historial" class="tab-content fade-in">
                         <div class="bg-white shadow-xl rounded-3xl overflow-hidden border border-green-100">
                            <div class="px-8 py-6 border-b border-gray-100"><h2 class="text-xl font-bold text-gray-800">Historial de Revisiones</h2></div>
                            <table class="min-w-full divide-y divide-gray-100">
                                <thead class="bg-gray-50"><tr><th class="px-8 py-4 text-left text-xs font-bold text-gray-500 uppercase">Fecha</th><th class="px-8 py-4 text-left text-xs font-bold text-gray-500 uppercase">Resultado</th><th class="px-8 py-4 text-left text-xs font-bold text-gray-500 uppercase">Comentarios</th></tr></thead>
                                <tbody class="divide-y divide-gray-100">
                                    <c:forEach var="eval" items="${historial}">
                                        <tr class="hover:bg-gray-50 transition">
                                            <td class="px-8 py-4 text-sm text-gray-500"><fmt:formatDate value="${eval.fechaEvaluacion}" pattern="dd MMM yyyy"/></td>
                                            <td class="px-8 py-4"><span class="px-3 py-1 text-xs font-bold rounded-full ${eval.condicion == 'Aprobado' ? 'bg-green-100 text-green-700' : 'bg-orange-100 text-orange-700'}">${eval.condicion}</span></td>
                                            <td class="px-8 py-4 text-sm text-gray-600 max-w-xs truncate">${eval.comentarios}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                         </div>
                    </div>
                </c:if>

                <!-- PESTAÑA: TRÁMITES -->
                <div id="tramites" class="tab-content fade-in">
                    <div class="flex justify-between items-center mb-8">
                        <div><h2 class="text-2xl font-bold text-gray-800">Carpeta de Titulación</h2><p class="text-gray-500 text-sm mt-1">Gestiona tu expediente administrativo.</p></div>
                        <button id="btn-subir-requisito" class="bg-green-600 hover:bg-green-700 text-white px-6 py-2.5 rounded-xl font-bold shadow-lg transition flex items-center transform hover:-translate-y-0.5"><svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12"></path></svg> Adjuntar Documento</button>
                    </div>
                    <div class="bg-white p-8 rounded-3xl shadow-lg border border-green-100 mb-8">
                        <div class="flex justify-between relative px-4">
                            <div class="absolute top-5 left-0 w-full h-1 bg-gray-100 -z-10 rounded-full"></div>
                            <!-- Pasos (Simplificado para ejemplo, usa lógica dinámica real) -->
                            <div class="flex flex-col items-center ${tramiteActual.estadoActual == 'Iniciado' ? 'step-current' : (tramiteActual != null ? 'step-active' : 'step-inactive')} bg-white px-4"><div class="step-circle shadow-sm">1</div><span class="text-xs font-bold mt-2 text-gray-600">Iniciado</span></div>
                            <div class="flex flex-col items-center ${tramiteActual.estadoActual == 'Revisión de Carpeta' ? 'step-current' : (tramiteActual.estadoActual == 'Designación de Jurado' || tramiteActual.estadoActual == 'Apto para Sustentar' || tramiteActual.estadoActual == 'Titulado' ? 'step-active' : 'step-inactive')} bg-white px-4"><div class="step-circle shadow-sm">2</div><span class="text-xs font-bold mt-2 text-gray-600">Revisión</span></div>
                            <div class="flex flex-col items-center ${tramiteActual.estadoActual == 'Designación de Jurado' ? 'step-current' : (tramiteActual.estadoActual == 'Apto para Sustentar' || tramiteActual.estadoActual == 'Titulado' ? 'step-active' : 'step-inactive')} bg-white px-4"><div class="step-circle shadow-sm">3</div><span class="text-xs font-bold mt-2 text-gray-600">Jurado</span></div>
                            <div class="flex flex-col items-center ${tramiteActual.estadoActual == 'Apto para Sustentar' ? 'step-current' : (tramiteActual.estadoActual == 'Titulado' ? 'step-active' : 'step-inactive')} bg-white px-4"><div class="step-circle shadow-sm">4</div><span class="text-xs font-bold mt-2 text-gray-600">Sustentación</span></div>
                        </div>
                    </div>
                    <div class="bg-white shadow-xl rounded-3xl overflow-hidden border border-green-100">
                        <div class="px-8 py-6 bg-gray-50 border-b border-gray-100"><h3 class="font-bold text-gray-800">Documentos</h3></div>
                        <table class="min-w-full divide-y divide-gray-100">
                            <thead class="bg-white"><tr><th class="px-8 py-4 text-left text-xs font-bold text-gray-500 uppercase">Requisito</th><th class="px-8 py-4 text-left text-xs font-bold text-gray-500 uppercase">Estado</th><th class="px-8 py-4 text-left text-xs font-bold text-gray-500 uppercase">Obs</th></tr></thead>
                            <tbody class="divide-y divide-gray-50">
                                <c:set var="tiposDocs" value="${fn:split('DNI,Bachiller,Certificado_Idiomas,Foto', ',')}" />
                                <c:forEach var="tipo" items="${tiposDocs}">
                                    <c:set var="doc" value="${null}" /><c:forEach var="d" items="${listaDocumentos}"><c:if test="${d.tipoDocumento == tipo}"><c:set var="doc" value="${d}" /></c:if></c:forEach>
                                    <tr class="hover:bg-gray-50">
                                        <td class="px-8 py-4 text-sm font-medium text-gray-900">${tipo}</td>
                                        <td class="px-8 py-4"><span class="px-3 py-1 text-xs font-bold rounded-full ${doc.estadoValidacion == 'Validado' ? 'bg-green-100 text-green-700' : (doc.estadoValidacion == 'Rechazado' ? 'bg-red-100 text-red-700' : 'bg-gray-100 text-gray-600')}">${doc != null ? doc.estadoValidacion : 'Pendiente'}</span></td>
                                        <td class="px-8 py-4 text-sm text-red-500">${doc.observacionRechazo}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </main>
        </div>
    </div>
    
    <!-- MODALES -->
    <!-- 1. Modal Detalle Rúbrica -->
    <c:if test="${not empty evaluacion}">
        <div id="modal-rubrica-detalle" class="modal-overlay">
            <div class="modal-content modal-content-xl bg-white rounded-2xl shadow-2xl overflow-hidden flex flex-col h-[90vh]">
                <div class="p-6 border-b border-gray-100 flex justify-between items-center bg-gray-50">
                    <div><h3 class="text-xl font-bold text-gray-800">Detalle de Rúbrica</h3><p class="text-sm text-gray-500">Desglose completo de la evaluación</p></div>
                    <button onclick="closeModal('modal-rubrica-detalle')" class="p-2 hover:bg-gray-200 rounded-full transition"><svg class="w-6 h-6 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg></button>
                </div>
                <div class="flex-1 overflow-y-auto p-0">
                    <table class="w-full text-left border-collapse">
                        <thead class="bg-gray-50 sticky top-0 z-10 shadow-sm"><tr><th class="p-4 text-xs font-bold text-gray-500 uppercase border-b">Criterio / Ítem</th><th class="p-4 text-center text-xs font-bold text-gray-500 uppercase border-b w-24">Puntaje</th><th class="p-4 text-center text-xs font-bold text-gray-500 uppercase border-b w-24">Estado</th></tr></thead>
                        <tbody class="divide-y divide-gray-100 text-sm">
                            <c:forEach var="i" begin="1" end="38">
                                <tr class="rubric-row hover:bg-gray-50">
                                    <td class="p-4 text-gray-700">Ítem de Evaluación #${i}</td>
                                    <c:set var="val" value="${evaluacion['item'.concat(i)]}" />
                                    <td class="p-4 text-center font-mono font-bold text-gray-600">${val}</td>
                                    <td class="p-4 text-center">
                                        <c:choose>
                                            <c:when test="${val == 1.0}"><span class="inline-block w-3 h-3 bg-green-500 rounded-full"></span></c:when>
                                            <c:when test="${val == 0.5}"><span class="inline-block w-3 h-3 bg-yellow-400 rounded-full"></span></c:when>
                                            <c:otherwise><span class="inline-block w-3 h-3 bg-red-500 rounded-full"></span></c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <div class="p-4 border-t border-gray-100 bg-gray-50 text-right"><button onclick="closeModal('modal-rubrica-detalle')" class="bg-green-800 text-white px-6 py-2 rounded-lg font-medium hover:bg-green-700 transition">Cerrar Detalle</button></div>
            </div>
        </div>
    </c:if>
    
    <!-- 2. Modal Subir Documento -->
    <div id="modal-subir-requisito" class="modal-overlay">
        <div class="modal-content bg-white rounded-2xl shadow-2xl p-8 max-w-md">
            <h3 class="text-2xl font-bold text-gray-800 mb-6">Adjuntar Documento</h3>
            <form action="${pageContext.request.contextPath}/TramiteServlet" method="POST" enctype="multipart/form-data" class="space-y-5">
                <input type="hidden" name="id_tramite" value="${tramiteActual != null ? tramiteActual.idTramite : 0}">
                <div><label class="block text-sm font-bold text-gray-700 mb-2">Tipo de Documento</label><select name="tipo_documento" class="w-full border-gray-300 rounded-xl p-3 text-sm focus:ring-2 focus:ring-green-500"><option value="DNI">Copia de DNI</option><option value="Bachiller">Bachiller</option><option value="Certificado_Idiomas">Certificado de Idiomas</option><option value="Foto">Foto Pasaporte</option><option value="Constancia_Practicas">Constancia Prácticas</option></select></div>
                <div><label class="block text-sm font-bold text-gray-700 mb-2">Archivo</label><input type="file" name="archivo_requisito" accept=".pdf,.jpg,.png" class="block w-full text-sm text-gray-500 file:mr-4 file:py-2.5 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-green-50 file:text-green-700 hover:file:bg-green-100" required></div>
                <div class="flex justify-end space-x-3 pt-4"><button type="button" onclick="closeModal('modal-subir-requisito')" class="px-5 py-2.5 rounded-xl text-sm font-medium text-gray-600 hover:bg-gray-100 transition">Cancelar</button><button type="submit" class="bg-green-600 text-white px-6 py-2.5 rounded-xl text-sm font-bold hover:bg-green-700 shadow-lg transition">Subir</button></div>
            </form>
        </div>
    </div>

    <script>
        // Funciones Utilitarias Globales
        function showTab(tabId) {
            document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active', 'fade-in'));
            document.querySelectorAll('.tab-button').forEach(b => { b.classList.remove('tab-active', 'text-white', 'bg-green-700'); b.classList.add('tab-inactive', 'text-green-100'); });
            const activeContent = document.getElementById(tabId);
            const activeButton = document.getElementById('btn-' + tabId);
            if (activeContent) activeContent.classList.add('active', 'fade-in');
            if (activeButton) { activeButton.classList.add('tab-active'); activeButton.classList.remove('tab-inactive', 'text-green-100'); }
        }
        function openModal(id) { const m = document.getElementById(id); if(m) m.classList.add('active'); }
        function closeModal(id) { const m = document.getElementById(id); if(m) m.classList.remove('active'); }
        function logout() { window.location.href = '${pageContext.request.contextPath}/LogoutServlet'; }

        // Control de Notificaciones (Click)
        const notifBtn = document.getElementById('btn-notificaciones-toggle');
        const notifDropdown = document.getElementById('dropdown-notificaciones');

        if (notifBtn && notifDropdown) {
            notifBtn.addEventListener('click', (e) => {
                e.stopPropagation();
                notifDropdown.classList.toggle('hidden');
            });

            document.addEventListener('click', (e) => {
                if (!notifBtn.contains(e.target) && !notifDropdown.contains(e.target)) {
                    notifDropdown.classList.add('hidden');
                }
            });
        }

        document.addEventListener('DOMContentLoaded', () => {
            // Listeners de Navegación
            ['evaluacion', 'subir', 'historial', 'tramites'].forEach(id => { document.getElementById('btn-' + id)?.addEventListener('click', () => showTab(id)); });
            
            // Listeners Globales
            document.getElementById('btn-logout-header')?.addEventListener('click', logout);
            document.getElementById('btn-logout-sidebar')?.addEventListener('click', logout);
            
            document.getElementById('btn-subir-requisito')?.addEventListener('click', () => openModal('modal-subir-requisito'));
            
            // Cerrar modales al hacer clic fuera
            document.querySelectorAll('.modal-overlay').forEach(o => o.addEventListener('click', e => { if(e.target === o) closeModal(o.id); }));

            // Pestaña Inicial
            const urlParams = new URLSearchParams(window.location.search);
            const tab = urlParams.get('tab');
            if (tab) showTab(tab); else { <c:if test="${empty tesis}">showTab('dashboard-empty');</c:if><c:if test="${not empty tesis}">showTab('evaluacion');</c:if> }
        });
    </script>
</body>
</html>