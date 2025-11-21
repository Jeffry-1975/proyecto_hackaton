package Controladores;

import Datos.TesisDAO; 
import Datos.TramitesDAO; 
import Modelos.Evaluacion; 
import Modelos.Tesis; 
import Modelos.Usuario;
import Modelos.Tramite; 
import Modelos.Notificacion; 
import Modelos.DocumentoRequisito; // Import necesario para la lista
import java.io.IOException;
import java.sql.SQLException; 
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

/**
 * Carga los datos para el portal del estudiante de manera independiente.
 */
@WebServlet(name = "StudentServlet", urlPatterns = {"/StudentServlet"})
public class StudentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuarioLogueado") : null;

        if (usuario == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // --- Mensajes Flash ---
        if (session.getAttribute("studentMsg") != null) {
            request.setAttribute("studentMsg", session.getAttribute("studentMsg"));
            session.removeAttribute("studentMsg");
        }
        if (session.getAttribute("studentError") != null) {
            request.setAttribute("studentError", session.getAttribute("studentError"));
            session.removeAttribute("studentError");
        }
        
        TesisDAO tesisDAO = new TesisDAO();
        TramitesDAO tramitesDAO = new TramitesDAO();
        
        Tesis tesis = null;
        Evaluacion evaluacion = null;
        List<Evaluacion> historial = null;
        Tramite tramite = null;
        List<DocumentoRequisito> listaDocumentos = null;
        
        try {
            String codigoEstudiante = usuario.getCodigo();

            // 1. CARGAR DATOS DE TESIS (Puede ser null si es nuevo)
            tesis = tesisDAO.getTesisPorEstudiante(codigoEstudiante);
            
            if (tesis != null) {
                evaluacion = tesisDAO.getUltimaEvaluacionPorTesis(tesis.getIdTesis());
                historial = tesisDAO.getHistorialEvaluaciones(tesis.getIdTesis());
            }
            
            // 2. CARGAR DATOS DE TRÁMITE (Independiente de la tesis)
            tramite = tramitesDAO.getTramitePorEstudiante(codigoEstudiante);
            
            // Si el alumno entra y no tiene trámite iniciado, lo creamos automáticamente aquí también por seguridad
            if (tramite == null) {
                tramitesDAO.iniciarTramite(codigoEstudiante);
                tramite = tramitesDAO.getTramitePorEstudiante(codigoEstudiante);
            }
            
            // Cargar los documentos que ya ha subido
            if (tramite != null) {
                listaDocumentos = tramitesDAO.getDocumentosPorTramite(tramite.getIdTramite());
            }
            
            // 3. NOTIFICACIONES
            List<Notificacion> notificaciones = tramitesDAO.getNotificacionesNoLeidas(codigoEstudiante);
            
            // --- Setear Atributos al Request ---
            request.setAttribute("tesis", tesis);
            request.setAttribute("evaluacion", evaluacion);
            request.setAttribute("historial", historial);
            
            request.setAttribute("tramiteActual", tramite);
            request.setAttribute("listaDocumentos", listaDocumentos);
            request.setAttribute("notificaciones", notificaciones);
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=db_student");
            return;
        }
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("student.jsp");
        dispatcher.forward(request, response);
    }
}