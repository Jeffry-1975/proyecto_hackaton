package Controladores;

import Datos.TramitesDAO;
import Modelos.DocumentoRequisito;
import Modelos.Tramite;
import Modelos.Usuario;
import Servicios.NotificacionService;
import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet; // <-- IMPORTANTE: Importar esto
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

// --- CORRECCIÓN: Faltaba esta anotación para que la URL funcione ---
@WebServlet(name = "TramiteServlet", urlPatterns = {"/TramiteServlet"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, 
    maxFileSize = 1024 * 1024 * 10,      
    maxRequestSize = 1024 * 1024 * 15    
)
public class TramiteServlet extends HttpServlet {

    private String fixedUploadPath;
    private NotificacionService notificacionService;

    @Override
    public void init() throws ServletException {
        // Intentamos obtener la ruta del web.xml
        fixedUploadPath = getServletContext().getInitParameter("ruta-tesis-uploads");
        
        // FALLBACK DE SEGURIDAD: Si no está en web.xml, usamos una ruta por defecto
        if (fixedUploadPath == null) {
            fixedUploadPath = "C:/tesis_uploads"; // Ruta por defecto si falla la configuración
            File dir = new File(fixedUploadPath);
            if (!dir.exists()) dir.mkdirs();
        }
        
        notificacionService = new NotificacionService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuarioLogueado") : null;

        if (usuario == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String codigoEstudiante = usuario.getCodigo(); 

        TramitesDAO dao = new TramitesDAO();
        try {
            Tramite tramite = dao.getTramitePorEstudiante(codigoEstudiante);
            
            if (tramite == null) {
                int idNuevo = dao.iniciarTramite(codigoEstudiante);
                tramite = dao.getTramitePorEstudiante(codigoEstudiante);
                // Solo notificar si se creó con éxito
                if (tramite != null) {
                    notificacionService.notificarCambioEstado(codigoEstudiante, "Iniciado");
                }
            }

            if (tramite != null) {
                List<DocumentoRequisito> docs = dao.getDocumentosPorTramite(tramite.getIdTramite());
                request.setAttribute("tramiteActual", tramite);
                request.setAttribute("listaDocumentos", docs);
            }
            
            // Redirigimos con la pestaña activa
            request.setAttribute("activeTab", "tramites"); 
            request.getRequestDispatcher("StudentServlet").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("student.jsp?error=db_tramite");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuarioLogueado") : null;
        
        if (usuario == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String tipoDoc = request.getParameter("tipo_documento");
        // Validación básica
        String idTramiteStr = request.getParameter("id_tramite");
        if (idTramiteStr == null || idTramiteStr.equals("0")) {
             session.setAttribute("studentError", "Error: No se encontró un trámite activo. Recarga la página.");
             response.sendRedirect("StudentServlet?tab=tramites");
             return;
        }
        
        int idTramite = Integer.parseInt(idTramiteStr);
        String codigoEstudiante = usuario.getCodigo();

        try {
            Part filePart = request.getPart("archivo_requisito");
            
            if (filePart == null || filePart.getSize() == 0) {
                session.setAttribute("studentError", "Error: Debes seleccionar un archivo.");
                response.sendRedirect("StudentServlet?tab=tramites");
                return;
            }

            // Nombre único para evitar colisiones
            String fileName = "req_" + idTramite + "_" + tipoDoc + "_" + System.currentTimeMillis() + ".pdf";
            
            // Guardar físico
            File uploadDir = new File(fixedUploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();
            
            filePart.write(fixedUploadPath + File.separator + fileName);

            // Guardar lógico (BD)
            DocumentoRequisito doc = new DocumentoRequisito();
            doc.setIdTramite(idTramite);
            doc.setTipoDocumento(tipoDoc);
            doc.setRutaArchivo(fileName);
            
            TramitesDAO dao = new TramitesDAO();
            boolean subido = dao.subirDocumento(doc);

            if (subido) {
                notificacionService.notificarDocumentoRecibido(codigoEstudiante, tipoDoc);
                session.setAttribute("studentMsg", "Documento " + tipoDoc + " subido correctamente.");
            } else {
                session.setAttribute("studentError", "Error al registrar el documento en base de datos.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("studentError", "Error crítico al subir documento: " + e.getMessage());
        }

        // Redirigir forzando la pestaña
        response.sendRedirect("StudentServlet?tab=tramites"); 
    }
}