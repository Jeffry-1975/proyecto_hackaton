<%-- 
    Document   : admin.jsp
    DESCRIPCIÓN: Panel Administrativo Integral (Usuarios, Tesis, Trámites y Jurados)
    ESTADO: CORREGIDO (Botones de cierre y funcionalidad de eliminar tesis)
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %> 
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="es" class="h-full">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel Administrador - Gestión de Tesis</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; }
        .fade-in { animation: fadeIn 0.5s ease-in; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
        
        .tab-button { transition: all 0.2s; border-radius: 0.5rem; }
        .tab-active { background-color: #b91c1c; color: #ffffff; }
        .tab-inactive:hover { background-color: #450a0a; color: #ffffff; }
        
        .tab-content { display: none; }
        .tab-content.active { display: block; }

        /* Modales */
        .modal-overlay {
            position: fixed; top: 0; left: 0; right: 0; bottom: 0;
            background-color: rgba(0, 0, 0, 0.5);
            display: none; align-items: center; justify-content: center;
            z-index: 50; animation: fadeIn 0.3s ease;
        }
        .modal-content {
            background-color: white; border-radius: 0.75rem;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
            width: 90%; max-width: 500px;
            animation: fadeIn 0.3s ease; max-height: 90vh; overflow-y: auto;
            position: relative; /* Para posicionar la X absoluta si se desea */
        }
        /* Modal más ancho para revisión de trámites */
        .modal-content-large { max-width: 900px; }
        
        .modal-overlay.active { display: flex; }
        
        /* Botón de cierre explícito */
        .btn-close-icon {
            cursor: pointer;
            padding: 0.5rem;
            border-radius: 50%;
            transition: background-color 0.2s;
        }
        .btn-close-icon:hover {
            background-color: #f3f4f6;
        }
    </style>
</head>
<body class="h-full bg-gradient-to-br from-red-50 to-pink-100">
    <div class="flex flex-col lg:flex-row h-full">
        
        <!-- Sidebar -->
        <div class="w-full lg:w-64 bg-gradient-to-b from-red-800 to-red-900 shadow-xl min-h-full flex-shrink-0">
            <div class="p-6 h-full flex flex-col">
                <div class="text-center mb-8">
                    <div class="mx-auto h-16 w-16 bg-red-600 rounded-full flex items-center justify-center mb-4 shadow-lg">
                        <svg class="h-8 w-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path></svg>
                    </div>
                    <h3 class="text-white font-semibold text-lg">${sessionScope.usuarioLogueado.getNombreCompleto()}</h3>
                    <p class="text-red-200 text-sm">Administrador</p>
                    <div class="mt-2 inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
                        <span class="w-2 h-2 bg-green-400 rounded-full mr-1.5"></span>
                        Disponible
                    </div>
                </div>

                <nav class="space-y-2 flex-1 text-sm">
                    <button id="btn-dashboard" class="tab-button tab-inactive w-full text-left px-4 py-2 text-red-200 hover:text-white transition flex items-center">
                        Inicio
                    </button>
                    
                    <p class="px-4 pt-4 pb-1 text-red-400 text-xs font-semibold uppercase tracking-wider">Gestión de Usuarios</p>
                    <div class="border-t border-red-500 my-2"></div>
                    
                    <button id="btn-docentes" class="tab-button tab-inactive w-full text-left px-4 py-2 text-red-200 hover:text-white transition flex items-center">
                        Docentes
                    </button>
                    <button id="btn-estudiantes" class="tab-button tab-inactive w-full text-left px-4 py-2 text-red-200 hover:text-white transition flex items-center">
                        Estudiantes
                    </button>

                    <p class="px-4 pt-4 pb-1 text-red-400 text-xs font-semibold uppercase tracking-wider">Flujo de Tesis</p>
                    <div class="border-t border-red-500 my-2"></div>
                    
                    <button id="btn-tesis-crud" class="tab-button tab-inactive w-full text-left px-4 py-2 text-red-200 hover:text-white transition flex items-center">
                        Lista de Tesis
                    </button>
                    <button id="btn-tesis-asignacion" class="tab-button tab-inactive w-full text-left px-4 py-2 text-red-200 hover:text-white transition flex items-center">
                        Asignación de Tesis
                    </button>
                    
                    <div class="border-t border-red-500 my-4"></div>
                    <button id="btn-tramites-gestion" class="tab-button tab-inactive w-full text-left px-4 py-2 text-red-200 hover:text-white transition flex items-center">
                        <svg class="h-5 w-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"></path></svg>
                        Trámites de Titulación
                    </button>
                </nav>                
            </div>
        </div>

        <!-- Contenido Principal -->
        <div class="flex-1 flex flex-col min-h-0">
            <header class="bg-white shadow-sm border-b border-red-200 flex-shrink-0">
                <div class="px-4 lg:px-6 py-4 flex justify-between items-center">
                    <h1 id="main-title" class="text-xl lg:text-2xl font-bold text-gray-900">Panel Administrativo</h1>
                    <button id="btn-logout" class="bg-red-600 hover:bg-red-500 text-white px-3 py-2 rounded-lg text-sm transition">Cerrar Sesión</button>
                </div>
            </header>

            <main class="flex-1 overflow-auto p-4 lg:p-6">
                
                <!-- Mensajes Flash -->
                <c:if test="${not empty adminMsg}">
                    <div class="p-3 mb-4 bg-green-100 border border-green-400 text-green-700 rounded-lg text-sm fade-in flex items-center">
                        <svg class="h-5 w-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>
                        ${adminMsg}
                    </div>
                </c:if>
                <c:if test="${not empty adminError}">
                    <div class="p-3 mb-4 bg-red-100 border border-red-400 text-red-700 rounded-lg text-sm fade-in flex items-center">
                        <svg class="h-5 w-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                        ${adminError}
                    </div>
                </c:if>
                
                <!-- 1. PESTAÑA DASHBOARD -->
                <div id="dashboard" class="tab-content ${activeTab == null || activeTab == 'dashboard' ? 'active' : ''} fade-in">
                    <h2 class="text-2xl font-semibold text-gray-800 mb-6">Resumen General</h2>
                    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 lg:gap-6 mb-8">
                        <div class="bg-gradient-to-r from-red-600 to-red-700 overflow-hidden shadow-xl rounded-xl p-4 text-white"><p class="text-sm font-medium opacity-80">Total Estudiantes</p><p class="text-3xl font-bold mt-1">${totalEstudiantes}</p></div>
                        <div class="bg-gradient-to-r from-blue-600 to-blue-700 overflow-hidden shadow-xl rounded-xl p-4 text-white"><p class="text-sm font-medium opacity-80">Total Docentes</p><p class="text-3xl font-bold mt-1">${totalDocentes}</p></div>
                        <div class="bg-gradient-to-r from-yellow-500 to-yellow-600 overflow-hidden shadow-xl rounded-xl p-4 text-white"><p class="text-sm font-medium opacity-80">Tesis En Proceso</p><p class="text-3xl font-bold mt-1">${tesisEnProceso}</p></div>
                        <div class="bg-gradient-to-r from-green-600 to-green-700 overflow-hidden shadow-xl rounded-xl p-4 text-white"><p class="text-sm font-medium opacity-80">Tesis Completadas</p><p class="text-3xl font-bold mt-1">${tesisCompletadas}</p></div>
                    </div>
                    
                    <!-- BOTONES DE ACCESO RÁPIDO -->
                    <div class="bg-white shadow-xl rounded-xl p-6 lg:p-8">
                        <h3 class="text-xl font-semibold text-gray-900 mb-4">Acciones Rápidas</h3>
                        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                            <button id="btn-quick-estudiantes" class="bg-red-50 hover:bg-red-100 text-red-700 p-4 rounded-lg font-medium border border-red-200 transition">Gestión de Estudiantes</button>
                            <button id="btn-quick-tesis" class="bg-yellow-50 hover:bg-yellow-100 text-yellow-700 p-4 rounded-lg font-medium border border-yellow-200 transition">Subir y Asignar Tesis</button>
                            <button id="btn-quick-docentes" class="bg-blue-50 hover:bg-blue-100 text-blue-700 p-4 rounded-lg font-medium border border-blue-200 transition">Gestión de Docentes</button>
                        </div>
                    </div>
                </div>

                <!-- 2. PESTAÑA GESTIÓN DOCENTES -->
                <div id="docentes" class="tab-content fade-in">
                    <h2 class="text-2xl font-semibold text-gray-800 mb-6">Lista de Docentes</h2>
                    <div class="flex justify-between items-center mb-4">
                        <button id="btn-open-modal-docente" class="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-lg font-medium transition flex items-center"><svg class="h-5 w-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path></svg> Crear Nuevo Docente</button>
                        <p class="text-sm text-gray-600">Docentes Activos: ${listaDocentes.size()}</p>
                    </div>
                    <div class="bg-white shadow-xl rounded-xl overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50"><tr><th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Nombre</th><th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Código</th><th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Email</th><th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Acciones</th></tr></thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <c:forEach var="doc" items="${listaDocentes}">
                                <tr>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">${doc.getNombreCompleto()}</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${doc.codigo}</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${doc.email}</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium space-x-2">
                                        <button class="btn-abrir-modal-editar text-indigo-600 hover:text-indigo-900" data-codigo="${doc.codigo}" data-nombres="${doc.nombres}" data-apellidos="${doc.apellidos}" data-email="${doc.email}" data-rol="docente">Editar</button>
                                        <button class="btn-abrir-modal-eliminar text-red-600 hover:text-red-900" data-codigo="${doc.codigo}" data-nombre="${doc.getNombreCompleto()}">Eliminar</button>
                                    </td>
                                </tr>
                                </c:forEach>
                                <c:if test="${empty listaDocentes}">
                                    <tr><td colspan="4" class="px-6 py-4 text-center text-gray-500">No hay docentes registrados.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- 3. PESTAÑA GESTIÓN ESTUDIANTES -->
                <div id="estudiantes" class="tab-content fade-in">
                    <h2 class="text-2xl font-semibold text-gray-800 mb-6">Lista de Estudiantes</h2>
                    <div class="flex justify-between items-center mb-4">
                        <button id="btn-open-modal-estudiante" class="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-lg font-medium transition flex items-center"><svg class="h-5 w-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path></svg> Crear Nuevo Estudiante</button>
                        <p class="text-sm text-gray-600">Estudiantes Registrados: ${listaEstudiantes.size()}</p>
                    </div>
                    <div class="bg-white shadow-xl rounded-xl overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50"><tr><th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Nombre</th><th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Código</th><th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Email</th><th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Acciones</th></tr></thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <c:forEach var="alu" items="${listaEstudiantes}">
                                <tr>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">${alu.getNombreCompleto()}</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${alu.codigo}</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${alu.email}</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium space-x-2">
                                        <button class="btn-abrir-modal-editar text-indigo-600 hover:text-indigo-900" data-codigo="${alu.codigo}" data-nombres="${alu.nombres}" data-apellidos="${alu.apellidos}" data-email="${alu.email}" data-rol="alumno">Editar</button>
                                        <button class="btn-abrir-modal-eliminar text-red-600 hover:text-red-900" data-codigo="${alu.codigo}" data-nombre="${alu.getNombreCompleto()}">Eliminar</button>
                                    </td>
                                </tr>
                                </c:forEach>
                                <c:if test="${empty listaEstudiantes}">
                                    <tr><td colspan="4" class="px-6 py-4 text-center text-gray-500">No hay estudiantes registrados.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- 4. PESTAÑA LISTA DE TESIS -->
                <div id="tesis-crud" class="tab-content fade-in">
                    <h2 class="text-2xl font-semibold text-gray-800 mb-6">Lista de Tesis</h2>
                    <div class="bg-white shadow-xl rounded-xl p-6 overflow-x-auto">
                        <table class="w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50"><tr><th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Título</th><th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Estudiante</th><th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Docente</th><th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Estado</th><th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Archivo</th><th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Acciones</th></tr></thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <c:forEach var="tesis" items="${listaTotalTesis}">
                                    <tr>
                                        <td class="px-4 py-4 text-sm font-medium text-gray-900 max-w-xs break-words">${tesis.titulo}</td>
                                        <td class="px-4 py-4 text-sm text-gray-500">${tesis.nombreEstudiante}</td>
                                        <td class="px-4 py-4 text-sm text-gray-500">${empty tesis.nombreDocenteRevisor ? '- Sin Asignar -' : tesis.nombreDocenteRevisor}</td>
                                        <td class="px-4 py-4"><span class="px-2 text-xs font-semibold rounded-full ${tesis.estado == 'Aprobado' ? 'bg-green-100 text-green-800' : 'bg-yellow-100 text-yellow-800'}">${tesis.estado}</span></td>
                                        <td class="px-4 py-4 text-sm"><c:if test="${not empty tesis.archivoPath}"><a href="DownloadServlet?file=${tesis.archivoPath}" class="text-blue-600 hover:underline">Descargar</a></c:if><c:if test="${empty tesis.archivoPath}"><span class="text-gray-400">N/A</span></c:if></td>
                                        <td class="px-4 py-4 text-sm font-medium space-x-2">
                                            <a href="#" class="btn-abrir-modal-reasignar text-indigo-600 hover:text-indigo-900" data-tesis-id="${tesis.idTesis}" data-tesis-titulo="${tesis.titulo}" data-docente-actual="${tesis.codigoDocenteRevisor}">${not empty tesis.codigoDocenteRevisor ? 'Re-asignar' : 'Asignar'}</a>
                                            <button class="btn-abrir-modal-editar-tesis text-blue-600 hover:text-blue-800" data-tesis-id="${tesis.idTesis}" data-tesis-titulo="${tesis.titulo}" data-archivo-actual="${tesis.archivoPath}">Editar</button>
                                            <button class="btn-abrir-modal-eliminar-tesis text-red-600 hover:text-red-800" data-tesis-id="${tesis.idTesis}" data-tesis-titulo="${tesis.titulo}" data-archivo-actual="${tesis.archivoPath}">Eliminar</button>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty listaTotalTesis}">
                                    <tr><td colspan="6" class="px-4 py-4 text-center text-gray-500">No hay tesis registradas.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- 5. PESTAÑA ASIGNACIÓN DE TESIS -->
                <div id="tesis-asignacion" class="tab-content fade-in">
                    <h2 class="text-2xl font-semibold text-gray-800 mb-6">Asignación de Tesis</h2>
                    <div class="bg-white shadow-xl rounded-xl p-6 border-l-4 border-yellow-500">
                        <h3 class="text-xl font-semibold text-gray-900 mb-4">Crear y Asignar</h3>
                        <form action="TesisAdminServlet" method="POST" enctype="multipart/form-data" class="space-y-4">
                            <input type="hidden" name="action" value="crear">
                            <div><label class="block text-sm font-medium text-gray-700">Título</label><input type="text" name="tesis_titulo" class="mt-1 w-full border rounded p-2" required></div>
                            <div class="grid grid-cols-2 gap-4">
                                <div><label class="block text-sm font-medium text-gray-700">Estudiante</label><select name="alumno_id" class="mt-1 w-full border rounded p-2" required><option value="">Seleccionar...</option><c:forEach var="alu" items="${listaEstudiantes}"><option value="${alu.codigo}">${alu.getNombreCompleto()}</option></c:forEach></select></div>
                                <div><label class="block text-sm font-medium text-gray-700">Docente</label><select name="docente_id" class="mt-1 w-full border rounded p-2"><option value="">Seleccionar...</option><c:forEach var="doc" items="${listaDocentes}"><option value="${doc.codigo}">${doc.getNombreCompleto()}</option></c:forEach></select></div>
                            </div>
                            <div><label class="block text-sm font-medium text-gray-700">Archivo PDF</label><input type="file" name="tesis_file" accept=".pdf" class="mt-1 w-full" required></div>
                            <button type="submit" class="bg-red-600 text-white px-6 py-2 rounded font-semibold hover:bg-red-700 transition">Guardar</button>
                        </form>
                    </div>
                </div>

                <!-- 6. PESTAÑA GESTIÓN DE TRÁMITES (MODULO NUEVO) -->
                <div id="tramites-gestion" class="tab-content ${activeTab == 'tramites-gestion' ? 'active' : ''} fade-in">
                    <h2 class="text-2xl font-semibold text-gray-800 mb-6">Gestión de Trámites de Titulación</h2>
                    <div class="bg-white shadow-xl rounded-xl overflow-x-auto p-6">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50"><tr><th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Estudiante</th><th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Estado Actual</th><th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Última Actualización</th><th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Acciones</th></tr></thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <c:forEach var="t" items="${listaTramites}">
                                    <tr>
                                        <td class="px-4 py-4"><div class="text-sm font-medium text-gray-900">${t.nombreEstudiante}</div><div class="text-xs text-gray-500">${t.codigoEstudiante}</div></td>
                                        <td class="px-4 py-4"><span class="px-2 py-1 text-xs font-semibold rounded-full ${t.estadoActual == 'Titulado' ? 'bg-green-100 text-green-800' : 'bg-blue-100 text-blue-800'}">${t.estadoActual}</span></td>
                                        <td class="px-4 py-4 text-sm text-gray-500"><fmt:formatDate value="${t.fechaActualizacion}" pattern="dd/MM HH:mm"/></td>
                                        <td class="px-4 py-4 text-sm font-medium">
                                            <!-- Enlace corregido que abre el modal y carga los datos -->
                                            <a href="${pageContext.request.contextPath}/AdminServlet?action=ver_documentos&id=${t.idTramite}" class="text-blue-600 hover:text-blue-900">Gestionar</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty listaTramites}"><tr><td colspan="4" class="px-4 py-4 text-center text-gray-500">No hay trámites activos.</td></tr></c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

            </main>
        </div>
    </div>

    <!-- --- MODALES --- -->

    <!-- 1. Crear Docente -->
    <div id="modal-docente" class="modal-overlay"><div class="modal-content"><form action="${pageContext.request.contextPath}/UsuarioAdminServlet" method="POST"><input type="hidden" name="action" value="crear"><input type="hidden" name="rol" value="docente"><div class="p-6 border-b flex justify-between items-center"><h3 class="text-xl font-semibold">Crear Docente</h3><button type="button" class="btn-close-modal btn-close-icon text-gray-400 hover:text-gray-600" data-modal-id="modal-docente"><svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg></button></div><div class="p-6 space-y-4"><input type="text" name="codigo" class="w-full border p-2 rounded" placeholder="Código" required><input type="text" name="nombres" class="w-full border p-2 rounded" placeholder="Nombres" required><input type="text" name="apellidos" class="w-full border p-2 rounded" placeholder="Apellidos" required><input type="email" name="email" class="w-full border p-2 rounded" placeholder="Email" required><input type="password" name="password" class="w-full border p-2 rounded" placeholder="Contraseña" required></div><div class="p-6 flex justify-end bg-gray-50"><button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded">Guardar</button></div></form></div></div>

    <!-- 2. Crear Estudiante -->
    <div id="modal-estudiante" class="modal-overlay"><div class="modal-content"><form action="${pageContext.request.contextPath}/UsuarioAdminServlet" method="POST"><input type="hidden" name="action" value="crear"><input type="hidden" name="rol" value="alumno"><div class="p-6 border-b flex justify-between items-center"><h3 class="text-xl font-semibold">Crear Estudiante</h3><button type="button" class="btn-close-modal btn-close-icon text-gray-400 hover:text-gray-600" data-modal-id="modal-estudiante"><svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg></button></div><div class="p-6 space-y-4"><input type="text" name="codigo" class="w-full border p-2 rounded" placeholder="Código" required><input type="text" name="nombres" class="w-full border p-2 rounded" placeholder="Nombres" required><input type="text" name="apellidos" class="w-full border p-2 rounded" placeholder="Apellidos" required><input type="email" name="email" class="w-full border p-2 rounded" placeholder="Email" required><input type="password" name="password" class="w-full border p-2 rounded" placeholder="Contraseña" required></div><div class="p-6 flex justify-end bg-gray-50"><button type="submit" class="bg-red-600 text-white px-4 py-2 rounded">Guardar</button></div></form></div></div>

    <!-- 3. Editar Usuario -->
    <div id="modal-editar-usuario" class="modal-overlay"><div class="modal-content"><form action="${pageContext.request.contextPath}/UsuarioAdminServlet" method="POST"><input type="hidden" name="action" value="editar"><input type="hidden" id="editar_codigo" name="codigo"><input type="hidden" id="editar_rol" name="rol"><div class="p-6 border-b flex justify-between items-center"><h3 class="text-xl font-semibold" id="editar_titulo_modal">Editar</h3><button type="button" class="btn-close-modal btn-close-icon text-gray-400 hover:text-gray-600" data-modal-id="modal-editar-usuario"><svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg></button></div><div class="p-6 space-y-4"><input type="text" id="editar_codigo_display" class="w-full border p-2 rounded bg-gray-100" readonly><input type="text" id="editar_nombres" name="nombres" class="w-full border p-2 rounded" required><input type="text" id="editar_apellidos" name="apellidos" class="w-full border p-2 rounded" required><input type="email" id="editar_email" name="email" class="w-full border p-2 rounded" required><input type="password" name="password" class="w-full border p-2 rounded" placeholder="Nueva Contraseña (Opcional)"></div><div class="p-6 flex justify-end bg-gray-50"><button type="submit" class="bg-indigo-600 text-white px-4 py-2 rounded">Actualizar</button></div></form></div></div>

    <!-- 4. Eliminar Usuario -->
    <div id="modal-eliminar-usuario" class="modal-overlay"><div class="modal-content"><form action="${pageContext.request.contextPath}/UsuarioAdminServlet" method="POST"><input type="hidden" name="action" value="eliminar"><input type="hidden" id="eliminar_codigo" name="codigo"><div class="p-6 text-center"><h3 class="text-lg font-medium">¿Eliminar a <span id="eliminar_nombre"></span>?</h3><div class="mt-4 flex justify-center space-x-3"><button type="button" class="btn-cancel-modal bg-gray-200 px-4 py-2 rounded" data-modal-id="modal-eliminar-usuario">Cancelar</button><button type="submit" class="bg-red-600 text-white px-4 py-2 rounded">Eliminar</button></div></div></form></div></div>

    <!-- 5. Reasignar Tesis -->
    <div id="modal-reasignar-tesis" class="modal-overlay"><div class="modal-content"><form action="${pageContext.request.contextPath}/TesisAdminServlet" method="POST"><input type="hidden" name="action" value="reasignar"><input type="hidden" name="id_tesis" id="reasignar_id_tesis"><div class="p-6 border-b flex justify-between items-center"><h3 class="text-xl font-semibold">Asignar Docente</h3><button type="button" class="btn-close-modal btn-close-icon text-gray-400 hover:text-gray-600" data-modal-id="modal-reasignar-tesis"><svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg></button></div><div class="p-6 space-y-4"><p id="reasignar_tesis_titulo" class="font-bold"></p><select name="docente_id" id="reasignar_docente_id" class="w-full border p-2 rounded"><option value="">[Sin Asignar]</option><c:forEach var="doc" items="${listaDocentes}"><option value="${doc.codigo}">${doc.getNombreCompleto()}</option></c:forEach></select></div><div class="p-6 flex justify-end bg-gray-50"><button type="submit" class="bg-red-600 text-white px-4 py-2 rounded">Guardar</button></div></form></div></div>

    <!-- 6. Editar Tesis -->
    <div id="modal-editar-tesis" class="modal-overlay"><div class="modal-content"><form action="${pageContext.request.contextPath}/TesisAdminServlet" method="POST" enctype="multipart/form-data"><input type="hidden" name="action" value="editar"><input type="hidden" name="id_tesis" id="editar_id_tesis"><input type="hidden" name="existing_file_path" id="editar_existing_file_path"><div class="p-6 border-b flex justify-between items-center"><h3 class="text-xl font-semibold">Editar Tesis</h3><button type="button" class="btn-close-modal btn-close-icon text-gray-400 hover:text-gray-600" data-modal-id="modal-editar-tesis"><svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg></button></div><div class="p-6 space-y-4"><input type="text" id="editar_tesis_titulo" name="tesis_titulo" class="w-full border p-2 rounded" required><p class="text-xs">Archivo: <span id="editar_archivo_actual_nombre"></span></p><input type="file" name="tesis_file" accept=".pdf" class="w-full"></div><div class="p-6 flex justify-end bg-gray-50"><button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded">Actualizar</button></div></form></div></div>

    <!-- 7. Eliminar Tesis (CORREGIDO) -->
    <div id="modal-eliminar-tesis" class="modal-overlay">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/TesisAdminServlet" method="POST">
                <input type="hidden" name="action" value="eliminar">
                <input type="hidden" id="eliminar_id_tesis" name="id_tesis">
                <input type="hidden" id="eliminar_existing_file_path" name="existing_file_path">
                <div class="p-6 text-center">
                    <h3 class="text-lg font-medium">¿Eliminar Tesis?</h3>
                    <p id="eliminar_tesis_titulo" class="text-sm text-gray-500 my-2 font-semibold"></p>
                    <div class="mt-4 flex justify-center space-x-3">
                        <button type="button" class="btn-cancel-modal bg-gray-200 px-4 py-2 rounded" data-modal-id="modal-eliminar-tesis">Cancelar</button>
                        <button type="submit" class="bg-red-600 text-white px-4 py-2 rounded">Eliminar</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- 8. MODAL GESTIÓN TRÁMITE + JURADOS -->
    <c:if test="${openModalDocs}">
        <div id="modal-gestionar-tramite" class="modal-overlay active">
            <div class="modal-content modal-content-large">
                <div class="p-6 border-b flex justify-between items-center">
                    <h3 class="text-xl font-semibold text-gray-900">Revisión de Trámite #${modalTramiteId}</h3>
                    <a href="${pageContext.request.contextPath}/AdminServlet?tab=tramites" class="text-gray-400 hover:text-gray-600"><svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg></a>
                </div>
                <div class="p-6 space-y-6">
                    
                    <!-- SECCIÓN 1: DOCUMENTOS -->
                    <div>
                        <h4 class="font-medium text-gray-900 mb-2 border-b pb-1">1. Revisión de Documentos</h4>
                        <div class="space-y-3">
                            <c:forEach var="doc" items="${listaDocumentosModal}">
                                <div class="border rounded-lg p-3 flex justify-between items-center bg-gray-50">
                                    <div>
                                        <p class="font-bold text-sm text-gray-800">${doc.tipoDocumento}</p>
                                        <p class="text-xs text-gray-500">Subido: <fmt:formatDate value="${doc.fechaSubida}" pattern="dd/MM HH:mm"/></p>
                                        <a href="${pageContext.request.contextPath}/DownloadServlet?file=${doc.rutaArchivo}" target="_blank" class="text-xs text-blue-600 hover:underline flex items-center mt-1">Ver Archivo</a>
                                    </div>
                                    <div class="flex items-center space-x-2">
                                        <c:if test="${doc.estadoValidacion == 'Pendiente'}">
                                            <form action="AdminTramitesServlet" method="POST" class="inline">
                                                <input type="hidden" name="action" value="validar_documento"><input type="hidden" name="id_documento" value="${doc.idDocumento}"><input type="hidden" name="id_tramite" value="${doc.idTramite}"><input type="hidden" name="estado" value="Validado">
                                                <button type="submit" class="bg-green-100 text-green-700 px-2 py-1 rounded text-xs hover:bg-green-200">Aprobar</button>
                                            </form>
                                            <button onclick="mostrarRechazo(${doc.idDocumento})" class="bg-red-100 text-red-700 px-2 py-1 rounded text-xs hover:bg-red-200">Rechazar</button>
                                            <div id="rechazo-form-${doc.idDocumento}" class="hidden absolute bg-white border shadow-lg p-2 rounded mt-2 right-10 z-10 w-64">
                                                <form action="AdminTramitesServlet" method="POST">
                                                    <input type="hidden" name="action" value="validar_documento"><input type="hidden" name="id_documento" value="${doc.idDocumento}"><input type="hidden" name="id_tramite" value="${doc.idTramite}"><input type="hidden" name="estado" value="Rechazado">
                                                    <textarea name="observacion" placeholder="Motivo del rechazo..." class="w-full border text-xs p-1 mb-1" required></textarea>
                                                    <button type="submit" class="bg-red-600 text-white w-full text-xs py-1 rounded">Confirmar Rechazo</button>
                                                </form>
                                            </div>
                                        </c:if>
                                        <c:if test="${doc.estadoValidacion == 'Validado'}"><span class="text-green-600 text-sm font-bold">Aprobado</span></c:if>
                                        <c:if test="${doc.estadoValidacion == 'Rechazado'}"><span class="text-red-600 text-sm font-bold">Rechazado</span></c:if>
                                    </div>
                                </div>
                            </c:forEach>
                            <c:if test="${empty listaDocumentosModal}"><p class="text-sm text-gray-500 italic">No hay documentos subidos aún.</p></c:if>
                        </div>
                    </div>

                    <!-- SECCIÓN 2: DESIGNACIÓN DE JURADO -->
                    <div class="bg-blue-50 p-4 rounded-lg border border-blue-100">
                        <h4 class="font-medium text-blue-900 mb-3 border-b border-blue-200 pb-1">2. Designación de Jurado y Fecha</h4>
                        
                        <form action="AdminTramitesServlet" method="POST" class="space-y-4">
                            <input type="hidden" name="action" value="guardar_sustentacion">
                            <input type="hidden" name="id_tramite" value="${modalTramiteId}">
                            
                            <div class="grid grid-cols-3 gap-3">
                                <div>
                                    <label class="text-xs font-bold text-gray-600">Presidente</label>
                                    <select name="presidente" class="w-full border p-1 rounded text-sm" required>
                                        <option value="">Seleccionar...</option>
                                        <c:forEach var="d" items="${listaDocentes}">
                                            <option value="${d.codigo}" ${sustentacionActual.codigoPresidente == d.codigo ? 'selected' : ''}>${d.nombres} ${d.apellidos}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div>
                                    <label class="text-xs font-bold text-gray-600">Secretario</label>
                                    <select name="secretario" class="w-full border p-1 rounded text-sm" required>
                                        <option value="">Seleccionar...</option>
                                        <c:forEach var="d" items="${listaDocentes}">
                                            <option value="${d.codigo}" ${sustentacionActual.codigoSecretario == d.codigo ? 'selected' : ''}>${d.nombres} ${d.apellidos}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div>
                                    <label class="text-xs font-bold text-gray-600">Vocal</label>
                                    <select name="vocal" class="w-full border p-1 rounded text-sm" required>
                                        <option value="">Seleccionar...</option>
                                        <c:forEach var="d" items="${listaDocentes}">
                                            <option value="${d.codigo}" ${sustentacionActual.codigoVocal == d.codigo ? 'selected' : ''}>${d.nombres} ${d.apellidos}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="grid grid-cols-2 gap-3">
                                <div>
                                    <label class="text-xs font-bold text-gray-600">Fecha y Hora</label>
                                    <input type="datetime-local" name="fecha_hora" class="w-full border p-1 rounded text-sm" required value="${fn:replace(sustentacionActual.fechaHora, ' ', 'T')}">
                                </div>
                                <div>
                                    <label class="text-xs font-bold text-gray-600">Lugar / Enlace Zoom</label>
                                    <input type="text" name="lugar" class="w-full border p-1 rounded text-sm" placeholder="Ej: Auditorio o Link" value="${sustentacionActual.lugarEnlace}" required>
                                </div>
                            </div>
                            
                            <button type="submit" class="w-full bg-blue-600 text-white py-2 rounded text-sm hover:bg-blue-700 font-semibold shadow">
                                Guardar Designación y Programar Sustentación
                            </button>
                        </form>
                    </div>

                    <!-- SECCIÓN 3: CONTROL MANUAL DE FASE -->
                    <div>
                        <h4 class="font-medium text-gray-900 mb-2 border-b pb-1">3. Control Manual de Estado</h4>
                        <form action="AdminTramitesServlet" method="POST" class="flex space-x-2 items-center">
                            <input type="hidden" name="action" value="avanzar_fase"><input type="hidden" name="id_tramite" value="${modalTramiteId}">
                            <select name="nueva_fase" class="border border-gray-300 rounded p-2 text-sm flex-1">
                                <option value="Iniciado">Iniciado</option>
                                <option value="Revisión de Carpeta">Revisión de Carpeta</option>
                                <option value="Designación de Jurado">Designación de Jurado</option>
                                <option value="Apto para Sustentar">Apto para Sustentar</option>
                                <option value="Sustentación Programada">Sustentación Programada</option>
                                <option value="Titulado">Titulado</option>
                            </select>
                            <button type="submit" class="bg-gray-600 text-white px-4 py-2 rounded text-sm hover:bg-gray-700">Actualizar</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </c:if>

    <script>
        function mostrarRechazo(id) { document.getElementById('rechazo-form-' + id).classList.toggle('hidden'); }
        
        function showTab(tabId) {
            document.querySelectorAll('.tab-content').forEach(c => c.style.display = 'none');
            document.querySelectorAll('.tab-button').forEach(b => { b.classList.remove('tab-active'); b.classList.add('tab-inactive'); });
            
            const activeContent = document.getElementById(tabId);
            const activeButton = document.getElementById('btn-' + tabId);
            
            if(activeContent) activeContent.style.display = 'block';
            if(activeButton) { activeButton.classList.add('tab-active'); activeButton.classList.remove('tab-inactive'); }
        }
        
        function openModal(modalId) { document.getElementById(modalId)?.classList.add('active'); }
        function closeModal(modalId) { document.getElementById(modalId)?.classList.remove('active'); }
        function logout() { window.location.href = 'LogoutServlet'; }

        document.addEventListener('DOMContentLoaded', () => {
            // Navegación
            ['dashboard', 'docentes', 'estudiantes', 'tesis-crud', 'tesis-asignacion', 'tramites-gestion'].forEach(t => {
                document.getElementById('btn-' + t)?.addEventListener('click', () => showTab(t));
            });
            document.getElementById('btn-logout').addEventListener('click', logout);

            // Acciones Rápidas (CORREGIDO: Ahora sí funcionan)
            document.getElementById('btn-quick-estudiantes')?.addEventListener('click', () => showTab('estudiantes'));
            document.getElementById('btn-quick-tesis')?.addEventListener('click', () => showTab('tesis-asignacion'));
            document.getElementById('btn-quick-docentes')?.addEventListener('click', () => showTab('docentes'));
            
            // Modales Docentes/Estudiantes
            document.getElementById('btn-open-modal-docente').addEventListener('click', () => openModal('modal-docente'));
            document.getElementById('btn-open-modal-estudiante').addEventListener('click', () => openModal('modal-estudiante'));
            
            document.querySelectorAll('.btn-abrir-modal-editar').forEach(btn => {
                btn.addEventListener('click', (e) => {
                    const d = e.currentTarget.dataset;
                    document.getElementById('editar_titulo_modal').textContent = 'Editar ' + d.rol;
                    document.getElementById('editar_codigo').value = d.codigo; document.getElementById('editar_codigo_display').value = d.codigo;
                    document.getElementById('editar_rol').value = d.rol; document.getElementById('editar_nombres').value = d.nombres;
                    document.getElementById('editar_apellidos').value = d.apellidos; document.getElementById('editar_email').value = d.email;
                    openModal('modal-editar-usuario');
                });
            });
            
            document.querySelectorAll('.btn-abrir-modal-eliminar').forEach(btn => {
                btn.addEventListener('click', (e) => {
                    document.getElementById('eliminar_codigo').value = e.currentTarget.dataset.codigo;
                    document.getElementById('eliminar_nombre').textContent = e.currentTarget.dataset.nombre;
                    openModal('modal-eliminar-usuario');
                });
            });

            // Modales Tesis
            document.querySelectorAll('.btn-abrir-modal-reasignar').forEach(btn => {
                btn.addEventListener('click', (e) => {
                    e.preventDefault();
                    document.getElementById('reasignar_id_tesis').value = e.currentTarget.dataset.tesisId;
                    document.getElementById('reasignar_tesis_titulo').textContent = e.currentTarget.dataset.tesisTitulo;
                    document.getElementById('reasignar_docente_id').value = e.currentTarget.dataset.docenteActual || "";
                    openModal('modal-reasignar-tesis');
                });
            });
            
            document.querySelectorAll('.btn-abrir-modal-editar-tesis').forEach(btn => {
                btn.addEventListener('click', (e) => {
                    e.preventDefault();
                    const d = e.currentTarget.dataset;
                    document.getElementById('editar_id_tesis').value = d.tesisId; document.getElementById('editar_tesis_titulo').value = d.tesisTitulo;
                    document.getElementById('editar_existing_file_path').value = d.archivoActual;
                    document.getElementById('editar_archivo_actual_nombre').textContent = d.archivoActual ? d.archivoActual.split('/').pop() : 'Ninguno';
                    openModal('modal-editar-tesis');
                });
            });
            
            // ELIMINAR TESIS (Corregido)
            document.querySelectorAll('.btn-abrir-modal-eliminar-tesis').forEach(btn => {
                btn.addEventListener('click', (e) => {
                    e.preventDefault();
                    const d = e.currentTarget.dataset;
                    document.getElementById('eliminar_id_tesis').value = d.tesisId; 
                    document.getElementById('eliminar_tesis_titulo').textContent = d.tesisTitulo;
                    document.getElementById('eliminar_existing_file_path').value = d.archivoActual;
                    openModal('modal-eliminar-tesis');
                });
            });

            // Cerrar modales (Ahora todos los botones funcionan)
            document.querySelectorAll('.btn-close-modal, .btn-cancel-modal').forEach(btn => btn.addEventListener('click', () => closeModal(btn.getAttribute('data-modal-id'))));
            document.querySelectorAll('.modal-overlay').forEach(o => o.addEventListener('click', (e) => { if(e.target === o) closeModal(o.id); }));

            <c:if test="${activeTab == 'tramites-gestion'}">showTab('tramites-gestion');</c:if>
            <c:if test="${activeTab != 'tramites-gestion'}">showTab('dashboard');</c:if>
        });
    </script>
</body>
</html>