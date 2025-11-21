package Controladores;

import Datos.TramitesDAO;
import Modelos.Sustentacion;
import Modelos.Usuario;
import Servicios.NotificacionService;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "AdminTramitesServlet", urlPatterns = {"/AdminTramitesServlet"})
public class AdminTramitesServlet extends HttpServlet {

    private NotificacionService notificacionService;

    @Override
    public void init() throws ServletException {
        notificacionService = new NotificacionService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Ya no usamos este servlet para ver datos. Redirigir al principal.
        response.sendRedirect("AdminServlet?tab=tramites");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        TramitesDAO dao = new TramitesDAO();
        HttpSession session = request.getSession();
        
        // Validar sesión
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuarioLogueado") : null;
        if (usuario == null || !"admin".equals(usuario.getRol())) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            if ("validar_documento".equals(action)) {
                int idDocumento = Integer.parseInt(request.getParameter("id_documento"));
                int idTramite = Integer.parseInt(request.getParameter("id_tramite"));
                String estado = request.getParameter("estado");
                String observacion = request.getParameter("observacion");
                
                dao.actualizarEstadoDocumento(idDocumento, estado, observacion);
                
                // Notificar
                String codigoEstudiante = dao.getCodigoEstudiantePorTramite(idTramite);
                if (codigoEstudiante != null) {
                    if ("Validado".equals(estado)) {
                        notificacionService.notificarCambioEstado(codigoEstudiante, "Documento Aprobado");
                    } else {
                        notificacionService.notificarCambioEstado(codigoEstudiante, "Documento Rechazado: " + observacion);
                    }
                }
                session.setAttribute("adminMsg", "Documento actualizado correctamente.");
                
            } else if ("avanzar_fase".equals(action)) {
                int idTramite = Integer.parseInt(request.getParameter("id_tramite"));
                String nuevaFase = request.getParameter("nueva_fase");
                
                dao.avanzarFaseTramite(idTramite, nuevaFase);
                
                String codigoEstudiante = dao.getCodigoEstudiantePorTramite(idTramite);
                if (codigoEstudiante != null) {
                    notificacionService.notificarCambioEstado(codigoEstudiante, nuevaFase);
                }
                session.setAttribute("adminMsg", "Fase actualizada a: " + nuevaFase);
            
            } else if ("guardar_sustentacion".equals(action)) {
                int idTramite = Integer.parseInt(request.getParameter("id_tramite"));
                String presidente = request.getParameter("presidente");
                String secretario = request.getParameter("secretario");
                String vocal = request.getParameter("vocal");
                String fechaStr = request.getParameter("fecha_hora");
                String lugar = request.getParameter("lugar");
                
                Timestamp fechaHora = Timestamp.valueOf(fechaStr.replace("T", " ") + ":00");
                
                Sustentacion s = new Sustentacion();
                s.setIdTramite(idTramite);
                s.setCodigoPresidente(presidente);
                s.setCodigoSecretario(secretario);
                s.setCodigoVocal(vocal);
                s.setFechaHora(fechaHora);
                s.setLugarEnlace(lugar);
                
                dao.guardarSustentacion(s);
                dao.avanzarFaseTramite(idTramite, "Sustentación Programada");
                
                // Notificaciones masivas
                String codigoEstudiante = dao.getCodigoEstudiantePorTramite(idTramite);
                notificacionService.notificarCambioEstado(codigoEstudiante, "Sustentación Programada");
                notificacionService.notificarCambioEstado(presidente, "Designado Presidente de Jurado");
                notificacionService.notificarCambioEstado(secretario, "Designado Secretario de Jurado");
                notificacionService.notificarCambioEstado(vocal, "Designado Vocal de Jurado");
                
                session.setAttribute("adminMsg", "Jurados asignados y fecha programada.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("adminError", "Error procesando solicitud: " + e.getMessage());
        }

        // IMPORTANTE: Redirigimos al AdminServlet para recargar todos los datos
        // y le decimos que active la pestaña de trámites.
        response.sendRedirect("AdminServlet?tab=tramites");
    }
}