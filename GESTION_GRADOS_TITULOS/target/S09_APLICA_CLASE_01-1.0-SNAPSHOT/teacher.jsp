<%-- 
    Document    : teacher.jsp
    DESCRIPCIÓN: Portal del Docente - Diseño Ejecutivo Azul (Blue Theme)
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %> 
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="es" class="h-full bg-blue-50/30">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Portal del Docente - UPLA</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Iconos -->
    <script src="https://unpkg.com/lucide@latest"></script>
    <style>
        body { font-family: 'Inter', sans-serif; }
        .fade-in { animation: fadeIn 0.5s cubic-bezier(0.4, 0, 0.2, 1); }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
        
        /* Navegación Sidebar */
        .tab-button { transition: all 0.3s ease; border-radius: 0.75rem; }
        /* Estado Activo: Azul brillante y blanco */
        .tab-active { background: linear-gradient(90deg, #2563eb 0%, #1d4ed8 100%); color: #ffffff; box-shadow: 0 4px 10px -2px rgba(37, 99, 235, 0.3); }
        /* Estado Inactivo */
        .tab-inactive { color: #93c5fd; } /* Blue-300 */
        .tab-inactive:hover { background-color: #1e3a8a; color: #ffffff; padding-left: 1.25rem; }
        
        .tab-content { display: none; }
        .tab-content.active { display: block; }

        /* Modales */
        .modal-overlay { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background-color: rgba(15, 23, 42, 0.6); backdrop-filter: blur(4px); display: none; align-items: center; justify-content: center; z-index: 50; animation: fadeIn 0.2s ease-out; }
        
        .modal-content { background-color: white; border-radius: 1rem; box-shadow: 0 25px 50px -12px rgba(30, 58, 138, 0.25); width: 90%; max-width: 600px; display: flex; flex-direction: column; max-height: 90vh; animation: slideUp 0.3s ease-out; border: 1px solid #dbeafe; }
        
        .modal-content-xl { max-width: 1100px; width: 98%; height: 92vh; display: flex; flex-direction: column; }
        
        @keyframes slideUp { from { transform: translateY(20px) scale(0.95); opacity: 0; } to { transform: translateY(0) scale(1); opacity: 1; } }
        .modal-overlay.active { display: flex; }
        
        /* Rúbrica */
        .rubrica-table { width: 100%; border-collapse: collapse; font-size: 0.8125rem; }
        /* Headers de Tabla Azulados */
        .rubrica-table th { background-color: #eff6ff; /* Blue-50 */ position: sticky; top: 0; z-index: 10; padding: 0.75rem; text-align: center; font-weight: 700; color: #1e40af; /* Blue-800 */ border-bottom: 2px solid #bfdbfe; /* Blue-200 */ text-transform: uppercase; letter-spacing: 0.05em; }
        .rubrica-table th:nth-child(2) { text-align: left; }
        .rubrica-table td { padding: 0.5rem 0.75rem; border-bottom: 1px solid #f1f5f9; color: #334155; vertical-align: middle; }
        
        /* Secciones de la Rúbrica */
        .rubrica-section-row td { background-color: #dbeafe; /* Blue-100 */ color: #1e3a8a; /* Blue-900 */ font-weight: 800; text-transform: uppercase; font-size: 0.75rem; padding: 0.75rem 1rem; letter-spacing: 0.05em; border-top: 1px solid #93c5fd; }
        .rubrica-row:hover { background-color: #f8fafc; }
        
        /* Radio Buttons Custom */
        .radio-score { cursor: pointer; width: 1.25rem; height: 1.25rem; accent-color: #2563eb; }
        .score-label { display: flex; width: 100%; height: 100%; justify-content: center; align-items: center; cursor: pointer; transition: background 0.2s; border-radius: 4px; }
        .score-label:hover { background-color: #dbeafe; }

        /* Scrollbar Azulado */
        .custom-scroll::-webkit-scrollbar { width: 8px; height: 8px; }
        .custom-scroll::-webkit-scrollbar-track { background: #f1f5f9; }
        .custom-scroll::-webkit-scrollbar-thumb { background: #93c5fd; border-radius: 4px; } /* Blue-300 */
        .custom-scroll::-webkit-scrollbar-thumb:hover { background: #60a5fa; } /* Blue-400 */
        
        /* Utilidad Gradiente */
        .bg-gradient-primary { background: linear-gradient(to right, #2563eb, #4338ca); } /* Blue-600 to Indigo-700 */
    </style>
</head>
<body class="h-full flex flex-col lg:flex-row overflow-hidden bg-blue-50/30 text-slate-800">
    
    <!-- Sidebar (AHORA AZUL PROFUNDO) -->
    <aside class="w-full lg:w-72 bg-blue-950 shadow-2xl flex-shrink-0 text-blue-100 z-30 flex flex-col h-full border-r border-blue-900">
        <div class="p-6 flex flex-col h-full">
            <!-- Perfil -->
            <div class="text-center mb-8 pt-4">
                <div class="relative mx-auto w-20 h-20 mb-4 group cursor-pointer">
                    <div class="absolute inset-0 bg-blue-500 rounded-full blur opacity-40 group-hover:opacity-70 transition duration-500"></div>
                    <div class="relative w-full h-full bg-blue-900 rounded-full flex items-center justify-center border-2 border-blue-400 text-white text-2xl font-bold shadow-inner">
                        ${fn:substring(sessionScope.usuarioLogueado.nombres, 0, 1)}${fn:substring(sessionScope.usuarioLogueado.apellidos, 0, 1)}
                    </div>
                </div>
                <h3 class="text-white font-bold text-lg tracking-tight">${sessionScope.usuarioLogueado.getNombreCompleto()}</h3>
                <span class="inline-flex items-center px-3 py-0.5 rounded-full text-[10px] font-bold bg-blue-900 text-blue-200 border border-blue-700 mt-2 uppercase tracking-wider">
                    Docente Investigador
                </span>
            </div>

            <!-- Menú -->
            <nav class="space-y-1.5 flex-1 overflow-y-auto custom-scroll pr-2">
                <button id="btn-dashboard" class="tab-button tab-active w-full text-left px-4 py-3 text-sm font-medium flex items-center group">
                    <svg class="w-5 h-5 mr-3 opacity-90" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg>
                    Dashboard
                </button>

                <p class="px-4 text-[10px] font-bold text-blue-400 uppercase tracking-widest mb-2 mt-6">Supervisión</p>
                <button id="btn-tesis-asignadas" class="tab-button tab-inactive w-full text-left px-4 py-3 text-sm font-medium flex items-center group">
                    <svg class="w-5 h-5 mr-3 opacity-70 group-hover:opacity-100" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"></path></svg>
                    Tesis Asignadas
                </button>
                <button id="btn-mis-estudiantes" class="tab-button tab-inactive w-full text-left px-4 py-3 text-sm font-medium flex items-center group">
                    <svg class="w-5 h-5 mr-3 opacity-70 group-hover:opacity-100" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197m13.5-9a2.5 2.5 0 11-5 0 2.5 2.5 0 015 0z"></path></svg>
                    Mis Estudiantes
                </button>
                <button id="btn-revisiones" class="tab-button tab-inactive w-full text-left px-4 py-3 text-sm font-medium flex items-center group">
                    <svg class="w-5 h-5 mr-3 opacity-70 group-hover:opacity-100" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                    Historial Revisiones
                </button>

                <p class="px-4 text-[10px] font-bold text-blue-400 uppercase tracking-widest mb-2 mt-6">Jurado & Reportes</p>
                <button id="btn-jurado" class="tab-button tab-inactive w-full text-left px-4 py-3 text-sm font-medium flex items-center group">
                    <svg class="w-5 h-5 mr-3 opacity-70 group-hover:opacity-100" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"></path></svg>
                    Sustentaciones
                </button>
                <button id="btn-reportes" class="tab-button tab-inactive w-full text-left px-4 py-3 text-sm font-medium flex items-center group">
                    <svg class="w-5 h-5 mr-3 opacity-70 group-hover:opacity-100" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17v-2m3 2v-4m3 4v-6m2 10H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path></svg>
                    Reportes
                </button>
            </nav>

            <!-- Botón Logout Mobile -->
            <div class="mt-auto pt-4 border-t border-blue-900 lg:hidden">
                <button onclick="logout()" class="w-full bg-blue-800 hover:bg-blue-700 text-white px-4 py-3 rounded-xl text-sm font-medium transition flex items-center justify-center">
                    <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path></svg>
                    Cerrar Sesión
                </button>
            </div>
        </div>
    </aside>

    <!-- Contenido Principal -->
    <div class="flex-1 flex flex-col h-screen overflow-hidden relative">
        
        <!-- Header -->
        <header class="bg-white border-b border-blue-100 h-16 flex items-center justify-between px-8 shrink-0 shadow-sm z-20">
            <div>
                <h1 id="header-title" class="text-xl font-bold text-blue-900">Dashboard</h1>
            </div>
            <div class="flex items-center space-x-4">
                <span class="text-sm text-blue-900/60 font-medium">Periodo 2025-II</span>
                <div class="h-8 w-px bg-blue-100"></div>
                <!-- Botón Salir: AZUL como solicitado -->
                <button onclick="logout()" class="hidden lg:flex bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-700 hover:to-indigo-700 text-white px-5 py-2 rounded-lg text-sm font-bold transition shadow-md items-center">
                    <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path></svg>
                    Cerrar Sesión
                </button>
            </div>
        </header>

        <!-- Main -->
        <main class="flex-1 overflow-y-auto p-8 scroll-smooth bg-blue-50/30">
            
            <!-- 1. DASHBOARD -->
            <div id="dashboard" class="tab-content active fade-in">
                
                <!-- Banner de Bienvenida (Referencia de color) -->
                <div class="bg-gradient-primary rounded-2xl p-8 mb-8 text-white shadow-lg shadow-blue-200 relative overflow-hidden border border-blue-500/20">
                    <div class="relative z-10">
                        <h2 class="text-3xl font-bold mb-2">¡Bienvenido, ${sessionScope.usuarioLogueado.nombres}!</h2>
                        <p class="text-blue-100 text-lg">Gestión de Tesis y Evaluaciones.</p>
                    </div>
                    <div class="absolute right-0 top-0 h-full w-1/2 bg-white/10 transform skew-x-12 blur-3xl"></div>
                </div>

                <!-- Stats -->
                <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
                    <div class="bg-white p-6 rounded-xl shadow-sm border border-blue-100/80 hover:border-blue-200 transition">
                        <p class="text-xs font-bold text-blue-400 uppercase tracking-wide">Asignadas</p>
                        <h3 class="text-3xl font-bold text-blue-900 mt-1">${totalAsignadas}</h3>
                    </div>
                    <div class="bg-white p-6 rounded-xl shadow-sm border border-blue-100/80 hover:border-blue-200 transition">
                        <p class="text-xs font-bold text-blue-400 uppercase tracking-wide">Pendientes</p>
                        <h3 class="text-3xl font-bold text-yellow-600 mt-1">${pendientesRevision}</h3>
                    </div>
                    <div class="bg-white p-6 rounded-xl shadow-sm border border-blue-100/80 hover:border-blue-200 transition">
                        <p class="text-xs font-bold text-blue-400 uppercase tracking-wide">Aprobadas</p>
                        <h3 class="text-3xl font-bold text-green-600 mt-1">${completadas}</h3>
                    </div>
                    <div class="bg-white p-6 rounded-xl shadow-sm border border-blue-100/80 hover:border-blue-200 transition">
                        <p class="text-xs font-bold text-blue-400 uppercase tracking-wide">Estudiantes</p>
                        <h3 class="text-3xl font-bold text-blue-900 mt-1">${totalEstudiantes}</h3>
                    </div>
                </div>

                <!-- Cola de Revisión -->
                <div class="bg-white rounded-2xl shadow-sm border border-blue-100 overflow-hidden">
                    <div class="px-6 py-5 border-b border-blue-100 bg-blue-50/40 flex justify-between items-center">
                        <h3 class="font-bold text-blue-900 text-lg">Pendientes de Revisión</h3>
                    </div>
                    <div class="divide-y divide-blue-50">
                        <c:forEach var="tesis" items="${listaTesis}">
                            <c:if test="${tesis.estado == 'Pendiente de Revisión' || tesis.estado == 'Revisión Solicitada' || tesis.estado == 'En Proceso'}">
                                <div class="p-5 hover:bg-blue-50/60 transition flex items-center justify-between group">
                                    <div class="flex items-center gap-4">
                                        <div class="w-10 h-10 rounded-full bg-blue-100 text-blue-700 flex items-center justify-center font-bold shadow-sm border border-blue-200">
                                            ${fn:substring(tesis.nombreEstudiante, 0, 1)}
                                        </div>
                                        <div>
                                            <h4 class="text-sm font-bold text-slate-900 group-hover:text-blue-700 transition">${tesis.titulo}</h4>
                                            <p class="text-xs text-slate-500">${tesis.nombreEstudiante} • <span class="text-yellow-600 font-semibold">${tesis.estado}</span></p>
                                        </div>
                                    </div>
                                    <button class="btn-trigger-eval bg-blue-600 text-white hover:bg-blue-700 px-5 py-2 rounded-lg text-sm font-bold transition shadow-md shadow-blue-200"
                                            data-tesis-title="${tesis.titulo}" 
                                            data-tesis-id="${tesis.idTesis}"
                                            data-archivo-path="${tesis.archivoPath}">
                                            Evaluar
                                    </button>
                                </div>
                            </c:if>
                        </c:forEach>
                        <c:if test="${pendientesRevision == 0}">
                            <div class="p-8 text-center text-blue-300 italic">No hay revisiones pendientes.</div>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- 2. TESIS ASIGNADAS -->
            <div id="tesis-asignadas" class="tab-content fade-in">
                <h2 class="text-xl font-bold text-blue-900 mb-6">Tesis Asignadas</h2>
                <div class="bg-white rounded-2xl shadow-sm border border-blue-100 overflow-hidden">
                    <table class="min-w-full divide-y divide-blue-100">
                        <thead class="bg-blue-50/50"><tr><th class="px-6 py-4 text-left text-xs font-bold text-blue-500 uppercase tracking-wider">Título</th><th class="px-6 py-4 text-left text-xs font-bold text-blue-500 uppercase tracking-wider">Estudiante</th><th class="px-6 py-4 text-left text-xs font-bold text-blue-500 uppercase tracking-wider">Estado</th><th class="px-6 py-4 text-left text-xs font-bold text-blue-500 uppercase tracking-wider">Acción</th></tr></thead>
                        <tbody class="divide-y divide-blue-50">
                            <c:forEach var="tesis" items="${listaTesis}">
                                <tr class="hover:bg-blue-50/30 transition">
                                    <td class="px-6 py-4 text-sm text-slate-900 font-medium">${tesis.titulo}</td>
                                    <td class="px-6 py-4 text-sm text-slate-500">${tesis.nombreEstudiante}</td>
                                    <td class="px-6 py-4"><span class="px-3 py-1 rounded-full text-xs font-bold ${tesis.estado == 'Aprobado' ? 'bg-green-100 text-green-700' : 'bg-blue-100 text-blue-700'}">${tesis.estado}</span></td>
                                    <td class="px-6 py-4">
                                        <button class="btn-trigger-eval text-sm font-bold px-3 py-1 rounded border transition
                                            ${tesis.estado == 'Aprobado' ? 'border-green-200 text-green-700 hover:bg-green-50' : 'bg-blue-600 text-white hover:bg-blue-700 border-transparent'}"
                                            data-tesis-title="${tesis.titulo}" 
                                            data-tesis-id="${tesis.idTesis}" 
                                            data-archivo-path="${tesis.archivoPath}">
                                            ${tesis.estado == 'Aprobado' ? 'Ver Evaluación' : 'Evaluar'}
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
            
            <!-- 3. MIS ESTUDIANTES -->
            <div id="mis-estudiantes" class="tab-content fade-in">
                <h2 class="text-xl font-bold text-blue-900 mb-6">Directorio de Estudiantes</h2>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                    <c:forEach var="tesis" items="${listaTesis}">
                        <div class="bg-white p-6 rounded-2xl shadow-sm border border-blue-100 hover:shadow-lg hover:border-blue-200 transition group">
                            <div class="flex items-center mb-4">
                                <div class="w-10 h-10 bg-blue-50 text-blue-600 border border-blue-100 rounded-full flex items-center justify-center font-bold mr-3 group-hover:bg-blue-600 group-hover:text-white transition">${fn:substring(tesis.nombreEstudiante,0,1)}</div>
                                <div><h4 class="font-bold text-slate-900 text-sm">${tesis.nombreEstudiante}</h4><p class="text-xs text-blue-400 font-mono">${tesis.codigoEstudiante}</p></div>
                            </div>
                            <p class="text-xs text-slate-500 mb-4 h-8 line-clamp-2 italic">"${tesis.titulo}"</p>
                            <div class="border-t border-blue-50 pt-4 flex justify-between items-center">
                                <span class="text-xs font-bold px-2 py-1 rounded ${tesis.estado == 'Aprobado' ? 'bg-green-50 text-green-700' : 'bg-blue-50 text-blue-700'}">${tesis.estado}</span>
                                <button class="btn-trigger-detail text-xs text-blue-600 font-bold hover:text-blue-800 transition"
                                        data-nombre-estudiante="${tesis.nombreEstudiante}" 
                                        data-codigo-estudiante="${tesis.codigoEstudiante}" 
                                        data-tesis-titulo="${tesis.titulo}" 
                                        data-tesis-estado="${tesis.estado}">
                                    Ver Detalles &rarr;
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- 4. HISTORIAL -->
            <div id="revisiones" class="tab-content fade-in">
                <h2 class="text-xl font-bold text-blue-900 mb-6">Historial de Revisiones</h2>
                <div class="bg-white rounded-2xl shadow-sm border border-blue-100 overflow-hidden">
                    <table class="min-w-full divide-y divide-blue-100">
                        <thead class="bg-blue-50/50"><tr><th class="px-6 py-4 text-left text-xs font-bold text-blue-500 uppercase">Fecha</th><th class="px-6 py-4 text-left text-xs font-bold text-blue-500 uppercase">Tesis</th><th class="px-6 py-4 text-left text-xs font-bold text-blue-500 uppercase">Condición</th><th class="px-6 py-4 text-left text-xs font-bold text-blue-500 uppercase">Comentarios</th></tr></thead>
                        <tbody class="divide-y divide-blue-50">
                            <c:forEach var="eval" items="${historialEvaluaciones}">
                                <tr>
                                    <td class="px-6 py-4 text-sm text-slate-500"><fmt:formatDate value="${eval.fechaEvaluacion}" pattern="dd/MM/yyyy"/></td>
                                    <td class="px-6 py-4 text-sm font-medium text-slate-900">${eval.tituloTesis}</td>
                                    <td class="px-6 py-4"><span class="px-2 py-1 rounded text-xs font-bold ${eval.condicion == 'Aprobado' ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}">${eval.condicion}</span></td>
                                    <td class="px-6 py-4 text-sm text-slate-500 max-w-xs truncate">${eval.comentarios}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
            
            <!-- 5. JURADO -->
            <div id="jurado" class="tab-content fade-in">
                <h2 class="text-xl font-bold text-blue-900 mb-6">Sustentaciones Programadas</h2>
                <div class="bg-white rounded-2xl shadow-sm border border-blue-100 p-6">
                    <table class="min-w-full divide-y divide-blue-100">
                        <thead class="bg-blue-50/50"><tr><th class="px-6 py-4 text-left text-xs font-bold text-blue-500 uppercase">Expediente</th><th class="px-6 py-4 text-left text-xs font-bold text-blue-500 uppercase">Rol</th><th class="px-6 py-4 text-left text-xs font-bold text-blue-500 uppercase">Fecha</th><th class="px-6 py-4 text-left text-xs font-bold text-blue-500 uppercase">Lugar</th><th class="px-6 py-4 text-left text-xs font-bold text-blue-500 uppercase">Acción</th></tr></thead>
                        <tbody class="divide-y divide-blue-50">
                            <c:forEach var="sus" items="${listaSustentaciones}">
                                <tr>
                                    <td class="px-6 py-4 text-sm font-bold text-blue-900">#${sus.idTramite}<br><span class="text-xs font-normal text-slate-500">${sus.nombreEstudiante}</span></td>
                                    <td class="px-6 py-4 text-sm text-slate-600">
                                        <c:choose>
                                            <c:when test="${sus.codigoPresidente == sessionScope.usuarioLogueado.codigo}"><span class="text-blue-600 font-bold">Presidente</span></c:when>
                                            <c:when test="${sus.codigoSecretario == sessionScope.usuarioLogueado.codigo}"><span class="text-indigo-600 font-bold">Secretario</span></c:when>
                                            <c:otherwise><span class="text-purple-600 font-bold">Vocal</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="px-6 py-4 text-sm text-slate-600"><fmt:formatDate value="${sus.fechaHora}" pattern="dd/MM/yyyy HH:mm"/></td>
                                    <td class="px-6 py-4 text-sm text-slate-600">${sus.lugarEnlace}</td>
                                    <td class="px-6 py-4">
                                        <button class="btn-jurado-detalle bg-blue-50 hover:bg-blue-100 text-blue-700 px-3 py-1 rounded text-xs font-bold transition border border-blue-200"
                                            data-estudiante="${sus.nombreEstudiante}"
                                            data-fecha="<fmt:formatDate value='${sus.fechaHora}' pattern='dd/MM/yyyy HH:mm'/>"
                                            data-lugar="${sus.lugarEnlace}">Ver</button>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty listaSustentaciones}"><tr><td colspan="5" class="px-6 py-12 text-center text-blue-300 italic">No hay sustentaciones programadas.</td></tr></c:if>
                        </tbody>
                    </table>
                </div>
            </div>
            
            <!-- 6. REPORTES -->
            <div id="reportes" class="tab-content fade-in">
                <div class="bg-white rounded-2xl shadow-sm border border-blue-100 p-10 text-center">
                    <div class="mx-auto w-16 h-16 bg-blue-50 rounded-full flex items-center justify-center text-blue-500 mb-4">
                         <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17v-2m3 2v-4m3 4v-6m2 10H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path></svg>
                    </div>
                    <h3 class="text-lg font-bold text-blue-900 mb-2">Generar Reportes</h3>
                    <p class="text-slate-500 mb-6 max-w-md mx-auto">Descarga un archivo CSV consolidado con el estado, notas y observaciones de todas las tesis asignadas en este periodo.</p>
                    <form action="${pageContext.request.contextPath}/ReporteServlet" method="POST">
                        <input type="hidden" name="tipo_reporte" value="tesis_asignadas">
                        <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white px-8 py-3 rounded-xl font-bold shadow-lg shadow-blue-200 transition transform hover:-translate-y-0.5">Descargar Reporte CSV</button>
                    </form>
                </div>
            </div>

        </main>
    </div>

    <!-- MODALES -->
    
    <!-- Modal Evaluación (Rúbrica Completa) - Header Azul -->
    <div id="evaluation-modal" class="modal-overlay">
        <div class="modal-content modal-content-xl bg-slate-50 overflow-hidden">
            <form id="evaluation-form" action="${pageContext.request.contextPath}/EvaluarServlet" method="POST" class="flex flex-col h-full">
                <input type="hidden" name="id_tesis" id="modal-hidden-tesis-id">
                
                <!-- Header con Gradiente Azul -->
                <div class="bg-gradient-primary p-6 border-b border-blue-600 flex justify-between items-center sticky top-0 z-10 shadow-md">
                    <div class="text-white">
                        <h3 class="text-xl font-bold">Evaluación de Tesis</h3>
                        <p class="text-sm text-blue-100 mt-1 opacity-90">Proyecto: <span id="modal-tesis-title" class="font-semibold text-white"></span></p>
                    </div>
                    <div class="flex items-center space-x-4">
                        <a href="#" id="modal-tesis-download-link" target="_blank" class="text-sm bg-white/10 hover:bg-white/20 text-white border border-white/20 px-3 py-1.5 rounded-lg font-medium flex items-center transition">
                            <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"></path></svg> 
                            Ver PDF
                        </a>
                        <button type="button" class="btn-close-modal p-2 bg-white/10 hover:bg-white/20 rounded-full text-white transition" data-modal-id="evaluation-modal">
                            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                        </button>
                    </div>
                </div>
                
                <!-- Body con Scrollbar Fix -->
                <div class="modal-body bg-slate-50 flex-1 overflow-y-auto custom-scroll p-6">
    
                    <div class="bg-white rounded-xl shadow-sm border border-blue-100 overflow-hidden mb-6">
                         <table class="rubrica-table w-full">
                            <thead class="bg-blue-50"><tr><th class="w-12 text-center">#</th><th>Indicador</th><th class="w-24 text-center">1.0</th><th class="w-24 text-center">0.5</th><th class="w-24 text-center">0.0</th></tr></thead>
                            <tbody class="divide-y divide-blue-50">
                                <c:set var="titulos" value="${fn:split('I. Título,II. Resumen,III. Introducción,IV. Problema,V. Justificación,VI. Objetivos,VII. Ética,VIII. Marco Teórico,IX. Hipótesis,X. Variables,XI. Metodología,XII. Resultados,XIII. Análisis,XIV. Conclusiones,XV. Recomendaciones,XVI. Referencias,XVII. Anexos,XVIII. Forma', ',')}" />
                                <c:set var="indices" value="${fn:split('1,2,4,5,7,10,12,13,17,18,20,29,31,33,34,35,36,37', ',')}" />
                                <c:set var="count_sec" value="0" />
                                
                                <c:forEach var="i" begin="1" end="38">
                                     <!-- Headers de Sección -->
                                     <c:forEach var="idx" items="${indices}" varStatus="status">
                                         <c:if test="${i == idx}">
                                              <tr><td colspan="5" class="rubrica-section-row"><div class="rubrica-section">${titulos[status.index]}</div></td></tr>
                                         </c:if>
                                     </c:forEach>
                                     
                                     <tr class="rubrica-row">
                                         <td class="text-center font-mono text-blue-300 font-bold">${i}</td>
                                         <td>
                                              <c:choose>
                                                   <c:when test="${i==1}">Es concordante con las variables de estudio, nivel y alcance de la investigación.</c:when>
                                                   <c:when test="${i==2}">El resumen contempla, objetivo, metodología,resultado principal y conclusión general, en español e inglés, impersonal y en tiempo pasado excepto las conclusiones que debe estar tiempo presente.</c:when>
                                                   <c:when test="${i==3}">El resumen no excede las 250 palabras con presenta entre 4 a 6 palabras claves, según TSAURO.</c:when>
                                                   <c:when test="${i==4}">Sintetiza el tema de investigación de forma clara y resumida, dando a conocer el esquema del contenido por capítulos.</c:when>
                                                   <c:when test="${i==5}">Describe el problema desde el punto de vista científico considerando causas, síntomas y pronósticos  basado  en  datos  e  información relevante.</c:when>
                                                   <c:when test="${i==6}">La formulación del problema considera variables y dimensiones.</c:when>
                                                   <c:when test="${i==7}">La justificación social determina la contribución hacia la sociedad con la investigación. </c:when>
                                                   <c:when test="${i==8}">La justificación teórica determina la generalización de los resultados o llena algún vacío del conocimiento. </c:when>
                                                   <c:when test="${i==9}">La justificación metodológica considera las razones de los métodos planteados, la propuesta de nuevos métodos o estrategias de investigación. </c:when>
                                                   <c:when test="${i==10}">El objetivo general tiene relación con el problema y el título de la investigación.</c:when>
                                                   <c:when test="${i==11}">Los objetivos específicos están en relación con los problemas específicos considerando las variables y/o dimensiones del estudio.</c:when>
                                                   <c:when test="${i==12}">Describe las  implicancias  éticas  del  estudio basado en principios y normas de los reglamentos.</c:when>
                                                   <c:when test="${i==13}">Los antecedentes consideran el objetivo de la investigación, breve descripción de la metodología, variables, resultados principales y una conclusión general.</c:when>
                                                   <c:when test="${i==14}">Los antecedentes deben ser artículos de investigación y tesis de grado, considerando autor, año, objetivo, metodología, resultado principal y/o conclusión general tanto Nacionales como Internacionales con una antigüedad no mayor de cinco años.</c:when>
                                                   <c:when test="${i==15}">Las bases teóricas consideran información de las variables y dimensiones de la investigación.</c:when>
                                                   <c:when test="${i==16}">El marco conceptual considera una descripción breve de las variables, dimensiones y términos que permitan el entendimiento del estudio.</c:when>
                                                   <c:when test="${i==17}">Las hipótesis son claras, dan respuesta a los problemas planteados y existe una relación recíproca con los objetivos.</c:when>
                                                   <c:when test="${i==18}">Identifica, clasifica y describe las variables del estudio.</c:when>
                                                   <c:when test="${i==18}">Identifica, clasifica y describe las variables del estudio.</c:when>
                                                   <c:when test="${i==19}">Operacionaliza las variables considerando como mínimo, la definición conceptual, operacional, dimensiones, indicador y escala de medición.</c:when>
                                                   <c:when test="${i==20}">Identifica y describe correctamente el método general y específico de la investigación.</c:when>
                                                   <c:when test="${i==21}">Identifica y describe el tipo de investigación con claridad.</c:when>
                                                   <c:when test="${i==22}">Identifica y describe el nivel de investigación de manera correcta en relación con la formulación del problema.</c:when>
                                                   <c:when test="${i==23}">Describe el diseño de investigación, señalando el grado de manipulación de las variables y su alcance.</c:when>
                                                   <c:when test="${i==24}">Identifica y describe características de la población.</c:when>
                                                   <c:when test="${i==25}">Identifica la muestra, estableciendo el cálculo muestral, considerando los criterios de inclusión y exclusión.</c:when>
                                                   <c:when test="${i==26}">Describe e identifica la técnica e instrumento de investigación, sus criterios de confiabilidad y validez relacionada a la evaluación adecuada devariables.</c:when>
                                                   <c:when test="${i==27}">Establece las técnicas de procesamiento de datos (estadísticas descriptivas y/o inferenciales).</c:when>
                                                   <c:when test="${i==28}">Establece el procedimiento de contrastación de hipótesis. (significancia y valor del coeficiente).</c:when>
                                                   <c:when test="${i==29}">Los resultados son presentados mediante tablas y/o gráficos estadísticos de acuerdo a variables y dimensiones establecidas, explicadas en tiempo pasado y bajo la interpretación del autor.</c:when>
                                                   <c:when test="${i==30}">Se presenta la contrastación de hipótesis (De utilizar estadística inferencial) y describe la interpretación de los resultados según la técnica estadística empleada.</c:when>
                                                   <c:when test="${i==31}">Se establece y redacta de forma ordenada por cada objetivo y/o variable.</c:when>
                                                   <c:when test="${i==32}">Contrasta la similitud o discrepancias teóricas entre los resultados de la investigación y los antecedentes considerados en el marco teórico. (establece las similitudes y diferencias y el porqué de éstas)</c:when>
                                                   <c:when test="${i==33}">Establece de forma breve el nivel de alcance hallado en relación a los objetivos y contrastación de hipótesis.</c:when>
                                                   <c:when test="${i==34}">Deben derivarse de las conclusiones de la investigación, realizando propuestas y/o sugerencias de mejoras sustanciales en relación al problema estudiado.</c:when>
                                                   <c:when test="${i==35}">Están establecidas de acuerdo al estilo de la norma bibliográfica correspondiente.</c:when>
                                                   <c:when test="${i==36}">Considera los anexos exigidos en la estructura de forma ordenada.</c:when>
                                                   <c:when test="${i==37}">Considera el formato correspondiente señalado por el presente Reglamento.</c:when>
                                                   <c:when test="${i==38}">Establece un documento ordenado, párrafos congruentes, formato adecuado (Tipo y tamaño de letra, sangrías, títulos y subtítulos, mayúsculas y minúsculas)</c:when>
                                              </c:choose>
                                         </td>
                                         <td class="text-center"><label class="score-label"><input type="radio" name="item_${i}" value="1.0" class="radio-score" onchange="calcularPuntaje()"></label></td>
                                         <td class="text-center"><label class="score-label"><input type="radio" name="item_${i}" value="0.5" class="radio-score" onchange="calcularPuntaje()"></label></td>
                                         <td class="text-center"><label class="score-label"><input type="radio" name="item_${i}" value="0.0" class="radio-score" checked onchange="calcularPuntaje()"></label></td>
                                     </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    
                    <div>
                        <label class="block text-sm font-bold text-blue-900 mb-2">Comentarios Finales</label>
                        <textarea name="comentarios_revision" rows="4" class="w-full border border-blue-200 rounded-xl p-4 text-sm focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none bg-white" placeholder="Escriba aquí las observaciones..." required></textarea>
                    </div>
                </div>
                
                <div class="modal-footer flex justify-between items-center gap-4 bg-white border-t border-blue-100 p-6">
                    <div class="text-left">
                        <span class="text-2xl font-bold text-slate-800">Puntaje: <span id="puntaje-total" class="text-blue-600">0.0</span> / 38</span>
                        <p id="condicion-calculada" class="text-sm font-bold text-red-500 mt-1">Desaprobado</p>
                    </div>
                    <div class="flex space-x-3">
                        <button type="button" class="btn-cancel-modal bg-white border border-blue-200 text-slate-600 hover:bg-slate-50 px-6 py-3 rounded-xl font-bold transition" data-modal-id="evaluation-modal">Cancelar</button>
                        <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white px-8 py-3 rounded-xl font-bold shadow-lg shadow-blue-200 transition">Guardar Evaluación</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
    
    <!-- Modal Detalle Estudiante (Header Azul) -->
    <div id="modal-detalle-estudiante" class="modal-overlay">
        <div class="modal-content overflow-hidden">
            <div class="bg-gradient-primary p-6 flex justify-between items-center">
                <h3 class="text-xl font-bold text-white">Detalle del Estudiante</h3>
                <button type="button" class="btn-close-modal text-blue-100 hover:text-white transition" data-modal-id="modal-detalle-estudiante">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>
            </div>
            <div class="p-8 space-y-4">
                <div class="bg-blue-50 p-4 rounded-xl grid grid-cols-2 gap-4 border border-blue-100">
                    <div><p class="text-xs font-bold text-blue-400 uppercase">Nombre</p><p class="font-semibold text-blue-900" id="detalle-nombre-estudiante"></p></div>
                    <div><p class="text-xs font-bold text-blue-400 uppercase">Código</p><p class="font-semibold text-blue-900" id="detalle-codigo-estudiante"></p></div>
                </div>
                <div><p class="text-xs font-bold text-blue-400 uppercase mb-1">Proyecto</p><p class="font-medium text-slate-800 leading-snug" id="detalle-tesis-titulo"></p></div>
                <div><p class="text-xs font-bold text-blue-400 uppercase mb-1">Estado</p><p class="font-bold text-blue-600" id="detalle-tesis-estado"></p></div>
            </div>
            <div class="p-6 border-t border-blue-100 text-right bg-slate-50">
                <button type="button" class="btn-cancel-modal bg-white border border-blue-200 text-slate-600 px-6 py-2.5 rounded-xl font-bold shadow-sm" data-modal-id="modal-detalle-estudiante">Cerrar</button>
            </div>
        </div>
    </div>
    
    <!-- Modal Detalle Jurado (Header Azul) -->
    <div id="modal-jurado-detalle" class="modal-overlay">
        <div class="modal-content overflow-hidden">
            <div class="bg-gradient-primary p-6 flex justify-between items-center">
                <h3 class="text-xl font-bold text-white">Detalle de Sustentación</h3>
                <button type="button" class="btn-close-modal text-blue-100 hover:text-white transition" data-modal-id="modal-jurado-detalle">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>
            </div>
            <div class="p-8 space-y-6">
                 <div class="p-6 bg-indigo-50 rounded-xl border border-indigo-100 text-center">
                     <p class="text-indigo-900 font-bold text-xl" id="jurado-estudiante"></p>
                     <p class="text-indigo-500 text-sm font-medium uppercase tracking-wide mt-1">Sustentante</p>
                 </div>
                 <div class="grid grid-cols-2 gap-4">
                     <div><p class="text-xs font-bold text-slate-400 uppercase">Fecha</p><p class="text-slate-800 font-semibold" id="jurado-fecha"></p></div>
                     <div><p class="text-xs font-bold text-slate-400 uppercase">Lugar</p><p class="text-blue-600 font-medium" id="jurado-lugar"></p></div>
                 </div>
            </div>
             <div class="p-6 border-t border-blue-100 text-right bg-slate-50">
                <button type="button" class="btn-cancel-modal bg-white border border-blue-200 text-slate-600 px-6 py-2 rounded-xl font-bold shadow-sm" data-modal-id="modal-jurado-detalle">Cerrar</button>
            </div>
        </div>
    </div>

    <!-- SCRIPT CENTRALIZADO -->
    <script>
        function showTab(tabId) {
            document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active', 'fade-in'));
            document.querySelectorAll('.tab-button').forEach(b => { b.classList.remove('tab-active'); b.classList.add('tab-inactive'); });
            document.getElementById(tabId).classList.add('active', 'fade-in');
            
            const btn = document.getElementById('btn-' + tabId);
            if(btn) {
                btn.classList.add('tab-active');
                btn.classList.remove('tab-inactive');
            }
            
            const titles = {'dashboard':'Dashboard', 'tesis-asignadas':'Tesis Asignadas', 'mis-estudiantes':'Mis Estudiantes', 'revisiones':'Historial', 'jurado':'Sustentaciones', 'reportes':'Reportes'};
            document.getElementById('header-title').textContent = titles[tabId] || 'Panel del Docente';
        }
        
        function openModal(id) { document.getElementById(id).classList.add('active'); }
        function closeModal(id) { document.getElementById(id).classList.remove('active'); }
        function logout() { window.location.href = '${pageContext.request.contextPath}/LogoutServlet'; }

        function calcularPuntaje() {
            let total = 0;
            document.querySelectorAll('#evaluation-form input[type="radio"]:checked').forEach(r => total += parseFloat(r.value));
            document.getElementById('puntaje-total').textContent = total.toFixed(1);
            const cond = document.getElementById('condicion-calculada');
            if(total >= 25) { cond.textContent = "APROBADO"; cond.className = "text-sm font-bold text-green-600 mt-1"; }
            else if(total >= 13) { cond.textContent = "OBSERVADO"; cond.className = "text-sm font-bold text-yellow-600 mt-1"; }
            else { cond.textContent = "DESAPROBADO"; cond.className = "text-sm font-bold text-red-600 mt-1"; }
        }

        function resetRubricaForm() {
            const f = document.getElementById('evaluation-form');
            f.reset();
            f.querySelectorAll('input[value="0.0"]').forEach(r => r.checked = true);
            calcularPuntaje();
        }

        document.addEventListener('DOMContentLoaded', () => {
            // Navegación
            ['dashboard', 'tesis-asignadas', 'mis-estudiantes', 'revisiones', 'reportes', 'jurado'].forEach(id => {
                document.getElementById('btn-' + id)?.addEventListener('click', () => showTab(id));
            });
            
            // DELEGACIÓN DE EVENTOS
            document.body.addEventListener('click', function(e) {
                // 1. EVALUAR
                if(e.target.closest('.btn-trigger-eval')) {
                    const btn = e.target.closest('.btn-trigger-eval');
                    document.getElementById('modal-tesis-title').textContent = btn.dataset.tesisTitle;
                    document.getElementById('modal-hidden-tesis-id').value = btn.dataset.tesisId;
                    const link = document.getElementById('modal-tesis-download-link');
                    const path = btn.dataset.archivoPath;
                    if(path && path !== 'null') { link.href = '${pageContext.request.contextPath}/DownloadServlet?file=' + path; link.style.display = 'flex'; } 
                    else { link.style.display = 'none'; }
                    resetRubricaForm();
                    openModal('evaluation-modal');
                }
                // 2. DETALLES
                if(e.target.closest('.btn-trigger-detail')) {
                    const d = e.target.closest('.btn-trigger-detail').dataset;
                    document.getElementById('detalle-nombre-estudiante').textContent = d.nombreEstudiante;
                    document.getElementById('detalle-codigo-estudiante').textContent = d.codigoEstudiante;
                    document.getElementById('detalle-tesis-titulo').textContent = d.tesisTitulo;
                    document.getElementById('detalle-tesis-estado').textContent = d.tesisEstado;
                    openModal('modal-detalle-estudiante');
                }
                // 3. JURADO
                if(e.target.closest('.btn-jurado-detalle')) {
                    const d = e.target.closest('.btn-jurado-detalle').dataset;
                    document.getElementById('jurado-estudiante').textContent = d.estudiante;
                    document.getElementById('jurado-fecha').textContent = d.fecha;
                    document.getElementById('jurado-lugar').textContent = d.lugar;
                    openModal('modal-jurado-detalle');
                }
                // 4. CERRAR
                if(e.target.closest('.btn-close-modal') || e.target.closest('.btn-cancel-modal')) {
                    const mId = e.target.closest('[data-modal-id]').getAttribute('data-modal-id');
                    closeModal(mId);
                }
                // 5. OVERLAY
                if(e.target.classList.contains('modal-overlay')) closeModal(e.target.id);
            });
            
            document.getElementById('evaluation-form').addEventListener('change', calcularPuntaje);
            showTab('dashboard');
        });
    </script>
</body>
</html>