package Controladores;

import Datos.TesisDAO;
import Datos.TramitesDAO; // <-- AÑADIDO
import Datos.UsuarioDAO;
import Modelos.DocumentoRequisito; // <-- AÑADIDO
import Modelos.Sustentacion; // <-- AÑADIDO
import Modelos.Tesis;
import Modelos.Tramite; // <-- AÑADIDO
import Modelos.Usuario;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "AdminServlet", urlPatterns = {"/AdminServlet"})
public class AdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        // Validación de sesión básica
        if (session == null || session.getAttribute("usuarioLogueado") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Mensajes Flash
        if (session.getAttribute("adminMsg") != null) {
            request.setAttribute("adminMsg", session.getAttribute("adminMsg"));
            session.removeAttribute("adminMsg");
        }
        if (session.getAttribute("adminError") != null) {
            request.setAttribute("adminError", session.getAttribute("adminError"));
            session.removeAttribute("adminError");
        }
        
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        TesisDAO tesisDAO = new TesisDAO();
        TramitesDAO tramitesDAO = new TramitesDAO(); // <-- Nuevo DAO
        
        try {
            // --- 1. CARGA DE DATOS GENERALES (Siempre necesarios) ---
            
            // Usuarios
            List<Usuario> listaDocentes = usuarioDAO.listarPorRol("docente");
            List<Usuario> listaEstudiantes = usuarioDAO.listarPorRol("alumno");
            
            // Estadísticas
            int totalDocentes = listaDocentes.size();
            int totalEstudiantes = listaEstudiantes.size();
            List<String> estadosProceso = List.of("Iniciado", "En Proceso", "Necesita Correcciones");
            int tesisEnProceso = tesisDAO.contarTesisPorEstados(estadosProceso);
            List<String> estadosCompletado = List.of("Aprobado");
            int tesisCompletadas = tesisDAO.contarTesisPorEstados(estadosCompletado);
            
            // Tesis
            List<Tesis> listaTotalTesis = tesisDAO.getAllTesisConNombres();
            
            // Trámites (NUEVO: Se carga siempre)
            List<Tramite> listaTramites = tramitesDAO.listarTodosLosTramites();
            
            // Setear atributos comunes
            request.setAttribute("listaDocentes", listaDocentes);
            request.setAttribute("listaEstudiantes", listaEstudiantes);
            request.setAttribute("totalDocentes", totalDocentes);
            request.setAttribute("totalEstudiantes", totalEstudiantes);
            request.setAttribute("tesisEnProceso", tesisEnProceso);
            request.setAttribute("tesisCompletadas", tesisCompletadas);
            request.setAttribute("listaTotalTesis", listaTotalTesis);
            request.setAttribute("listaTramites", listaTramites); // <-- Datos para la tabla de trámites
            
            // --- 2. LÓGICA ESPECÍFICA (Abrir Modal, Cambiar Pestaña) ---
            
            String action = request.getParameter("action");
            String tab = request.getParameter("tab");
            
            // Si la acción es "ver_documentos", cargamos los datos del modal
            if ("ver_documentos".equals(action)) {
                try {
                    int idTramite = Integer.parseInt(request.getParameter("id"));
                    
                    List<DocumentoRequisito> docs = tramitesDAO.getDocumentosPorTramite(idTramite);
                    Sustentacion sust = tramitesDAO.getSustentacionPorTramite(idTramite);
                    
                    request.setAttribute("modalTramiteId", idTramite);
                    request.setAttribute("listaDocumentosModal", docs);
                    request.setAttribute("sustentacionActual", sust);
                    // Reusamos la lista de docentes que ya cargamos arriba para el dropdown
                    request.setAttribute("listaDocentesDropdown", listaDocentes); 
                    
                    request.setAttribute("openModalDocs", true); // Flag para abrir modal
                    request.setAttribute("activeTab", "tramites-gestion"); // Forzar pestaña activa
                    
                } catch (NumberFormatException e) {
                    request.setAttribute("adminError", "ID de trámite inválido.");
                }
            }
            
            // Si hay un parámetro 'tab', lo usamos para activar la pestaña correcta
            if (tab != null && !tab.isEmpty()) {
                if ("tramites".equals(tab)) {
                    request.setAttribute("activeTab", "tramites-gestion");
                } else {
                    request.setAttribute("activeTab", tab);
                }
            } else if (request.getAttribute("activeTab") == null) {
                // Default
                request.setAttribute("activeTab", "dashboard");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=admin_load_failed");
            return;
        }
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("admin.jsp");
        dispatcher.forward(request, response);
    }
}