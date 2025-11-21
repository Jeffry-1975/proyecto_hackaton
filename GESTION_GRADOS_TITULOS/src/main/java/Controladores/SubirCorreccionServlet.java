package Controladores;

import Datos.TesisDAO;
import Modelos.Usuario;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

// NO usamos @WebServlet, ya está definido en web.xml
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,  // 1 MB
    maxFileSize = 1024 * 1024 * 10, // 10 MB
    maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
public class SubirCorreccionServlet extends HttpServlet {

    // --- CORREGIDO: Variable para guardar la ruta fija ---
    private String fixedUploadPath;
    
    @Override
    public void init() throws ServletException {
        // Lee la ruta fija definida en web.xml al iniciar el servlet
        // Esta es la MISMA ruta que usa TesisAdminServlet (C:/tesis)
        fixedUploadPath = getServletContext().getInitParameter("ruta-tesis-uploads");
        if (fixedUploadPath == null) {
            System.err.println("SubirCorreccionServlet: ¡ERROR! 'ruta-tesis-uploads' no está configurada en web.xml.");
            throw new ServletException("'ruta-tesis-uploads' no está configurada en web.xml.");
        }
        System.out.println("SubirCorreccionServlet: Ruta de subidas configurada en: " + fixedUploadPath);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuarioLogueado") : null;

        if (usuario == null || !"alumno".equals(usuario.getRol())) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // 1. Obtener datos del formulario
            int idTesis = Integer.parseInt(request.getParameter("id_tesis"));
            String comentario = request.getParameter("comentario_alumno"); // (Opcional)
            Part filePart = request.getPart("tesis_file");
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

            if (fileName == null || fileName.isEmpty()) {
                session.setAttribute("studentError", "Error: Debe seleccionar un archivo PDF.");
                response.sendRedirect("StudentServlet");
                return;
            }

            // --- LÓGICA DE GUARDADO CORREGIDA ---
            // 2. Guardar el archivo nuevo en la carpeta fija (C:/tesis)
            String osUploadFilePath = fixedUploadPath;
            File uploadDir = new File(osUploadFilePath);
            if (!uploadDir.exists()) uploadDir.mkdirs();
            
            filePart.write(osUploadFilePath + File.separator + fileName);
            
            // 3. La ruta para la BD es SÓLO el nombre del archivo
            String dbPath = fileName; 

            // 4. Actualizar la BD
            TesisDAO dao = new TesisDAO();
            // El nuevo estado será "En Proceso" para que el docente lo revise
            boolean exito = dao.actualizarCorreccionTesis(idTesis, dbPath, "En Proceso");

            if (exito) {
                session.setAttribute("studentMsg", "Correcciones subidas con éxito. Tu docente será notificado.");
            } else {
                session.setAttribute("studentError", "No se pudo subir la corrección.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("studentError", "Error de base de datos: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("studentError", "Error al procesar el archivo: " + e.getMessage());
        }

        response.sendRedirect("StudentServlet");
    }
}