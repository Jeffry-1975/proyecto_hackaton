package Controladores;

import Datos.TesisDAO;
import Modelos.Tesis;
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

// La anotación @MultipartConfig es redundante si ya está en web.xml,
// pero no hace daño tenerla.
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,  // 1 MB
    maxFileSize = 1024 * 1024 * 10, // 10 MB
    maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
public class TesisAdminServlet extends HttpServlet {
    
    // --- CORREGIDO: Variable para guardar la ruta fija ---
    private String fixedUploadPath;
    
    @Override
    public void init() throws ServletException {
        // Lee la ruta fija definida en web.xml al iniciar el servlet
        fixedUploadPath = getServletContext().getInitParameter("ruta-tesis-uploads");
        if (fixedUploadPath == null) {
            System.err.println("TesisAdminServlet: ¡ERROR! 'ruta-tesis-uploads' no está configurada en web.xml.");
            throw new ServletException("'ruta-tesis-uploads' no está configurada en web.xml.");
        }
        System.out.println("TesisAdminServlet: Ruta de subidas configurada en: " + fixedUploadPath);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String action = request.getParameter("action"); 
        TesisDAO dao = new TesisDAO();
        
        if (action == null) {
            session.setAttribute("adminError", "Acción no especificada.");
            response.sendRedirect("AdminServlet");
            return;
        }

        try {
            switch (action) {
                case "crear":
                    handleCrearTesis(request, dao, session);
                    break;
                case "reasignar":
                    handleReasignarTesis(request, dao, session);
                    break;
                case "editar":
                    handleEditarTesis(request, dao, session);
                    break;
                case "eliminar":
                    handleEliminarTesis(request, dao, session);
                    break;
            }
        } catch (SQLException e) {
            // --- ¡AQUÍ ESTÁ LA CORRECCIÓN! ---
            // Verificamos si es el error específico de Foreign Key que vimos.
            
            if (e.getMessage().contains("a foreign key constraint fails") && 
                e.getMessage().contains("`evaluaciones`")) {
                
                // Si es así, enviamos un mensaje amigable al admin.
                session.setAttribute("adminError", "Error: No se puede eliminar esta tesis porque ya tiene evaluaciones asociadas. Primero debe eliminar sus evaluaciones.");
            
            } else {
                // Si es cualquier otro error de SQL, mostramos el error técnico.
                e.printStackTrace();
                session.setAttribute("adminError", "Error de SQL: " + e.getMessage());
            }
        }
        
        response.sendRedirect("AdminServlet");
    }

    private void handleCrearTesis(HttpServletRequest request, TesisDAO dao, HttpSession session) 
            throws SQLException, IOException, ServletException {
        
        String titulo = request.getParameter("tesis_titulo");
        String codigoEstudiante = request.getParameter("alumno_id");
        String codigoDocente = request.getParameter("docente_id");
        
        Tesis nuevaTesis = new Tesis();
        nuevaTesis.setTitulo(titulo);
        nuevaTesis.setCodigoEstudiante(codigoEstudiante);

        if (codigoDocente != null && !codigoDocente.isEmpty()) {
            nuevaTesis.setCodigoDocenteRevisor(codigoDocente);
            nuevaTesis.setEstado("En Proceso");
        } else {
            nuevaTesis.setCodigoDocenteRevisor(null);
            nuevaTesis.setEstado("Iniciado");
        }
        
        String dbPath = null;
        try {
            Part filePart = request.getPart("tesis_file");
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString(); 

            if (fileName != null && !fileName.isEmpty()) {
                
                // --- ¡SECCIÓN CORREGIDA! ---
                // 1. Usamos la ruta fija leída del web.xml
                // (ej: "C:/tesis")
                String osUploadFilePath = fixedUploadPath;
                
                File uploadDir = new File(osUploadFilePath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                
                // 2. Guardar el archivo en esa ruta física
                filePart.write(osUploadFilePath + File.separator + fileName);
                
                // 3. Construir la ruta web (solo el nombre del archivo) que se guardará en la BD
                // (ej: "mi_archivo.pdf")
                dbPath = fileName;
                
                System.out.println("TesisAdminServlet: Archivo subido con éxito a: " + osUploadFilePath + File.separator + fileName);
                System.out.println("TesisAdminServlet: Guardando en BD solo el nombre: " + dbPath);
                
            } else {
                System.out.println("TesisAdminServlet: No se subió archivo, se guardará path nulo.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("adminError", "Error al subir el archivo: " + e.getMessage());
            return;
        }
        
        nuevaTesis.setArchivoPath(dbPath);
        boolean exito = dao.insertarTesis(nuevaTesis);
        
        if (exito) {
            session.setAttribute("adminMsg", "Tesis creada y asignada con éxito.");
        } else {
            session.setAttribute("adminError", "No se pudo guardar la tesis en la base de datos.");
        }
    }
    
    private void handleReasignarTesis(HttpServletRequest request, TesisDAO dao, HttpSession session) throws SQLException {
        // ... (Este método no maneja archivos, no necesita cambios) ...
        int idTesis = Integer.parseInt(request.getParameter("id_tesis"));
        String codigoDocente = request.getParameter("docente_id");
        String nuevoEstado;
        String codigoDocenteFinal;
        
        if (codigoDocente == null || codigoDocente.isEmpty()) {
            codigoDocenteFinal = null;
            nuevoEstado = "Iniciado";
        } else {
            codigoDocenteFinal = codigoDocente;
            nuevoEstado = "En Proceso";
        }
        
        boolean exito = dao.actualizarAsignacion(idTesis, codigoDocenteFinal, nuevoEstado);
        
        if (exito) {
            session.setAttribute("adminMsg", "Asignación de tesis actualizada con éxito.");
        } else {
            session.setAttribute("adminError", "No se pudo actualizar la asignación.");
        }
    }
    
    private void handleEditarTesis(HttpServletRequest request, TesisDAO dao, HttpSession session)
            throws SQLException, IOException, ServletException {
        
        int idTesis = Integer.parseInt(request.getParameter("id_tesis"));
        String titulo = request.getParameter("tesis_titulo");
        String existingFilePath = request.getParameter("existing_file_path"); // Esto ahora es solo el nombre (ej: "antiguo.pdf")
        
        // --- ¡CORREGIDO! ---
        // Ya no usamos getRealPath("")
        // String applicationPath = request.getServletContext().getRealPath("");

        String dbPath = existingFilePath; // Por defecto, mantenemos el nombre del archivo antiguo

        try {
            Part filePart = request.getPart("tesis_file");
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString(); 

            if (fileName != null && !fileName.isEmpty()) {
                System.out.println("TesisAdminServlet(Editar): Detectado nuevo archivo: " + fileName);

                // A. Construir ruta física de guardado (en la carpeta fija)
                String osUploadFilePath = fixedUploadPath;
                File uploadDir = new File(osUploadFilePath);
                if (!uploadDir.exists()) uploadDir.mkdirs();
                
                String newFilePathOnServer = osUploadFilePath + File.separator + fileName;
                filePart.write(newFilePathOnServer);
                
                // B. Actualizar la ruta que irá a la BD (solo el nuevo nombre)
                dbPath = fileName;

                // C. Borrar el archivo antiguo (si existía)
                if (existingFilePath != null && !existingFilePath.isEmpty()) {
                    // Construir la ruta física del archivo ANTIGUO
                    String oldFilePath = fixedUploadPath + File.separator + existingFilePath;
                    File oldFile = new File(oldFilePath);
                    if (oldFile.exists()) {
                        oldFile.delete();
                        System.out.println("TesisAdminServlet(Editar): Archivo antiguo borrado: " + oldFilePath);
                    }
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("adminError", "Error al procesar el archivo: " + e.getMessage());
            return;
        }

        Tesis tesisActualizada = new Tesis();
        tesisActualizada.setIdTesis(idTesis);
        tesisActualizada.setTitulo(titulo);
        tesisActualizada.setArchivoPath(dbPath);
        
        boolean exito = dao.actualizarTesis(tesisActualizada);

        if (exito) {
            session.setAttribute("adminMsg", "Tesis actualizada con éxito.");
        } else {
            session.setAttribute("adminError", "No se pudo actualizar la tesis.");
        }
    }

    private void handleEliminarTesis(HttpServletRequest request, TesisDAO dao, HttpSession session) 
            throws SQLException, IOException, ServletException {
        
        int idTesis = Integer.parseInt(request.getParameter("id_tesis"));
        String existingFilePath = request.getParameter("existing_file_path"); // Esto ahora es solo el nombre (ej: "antiguo.pdf")
        
        // --- ¡CORREGIDO! ---
        // Ya no usamos getRealPath("")
        // String applicationPath = request.getServletContext().getRealPath("");

        boolean exitoBD = dao.eliminarTesis(idTesis);

        if (exitoBD) {
            if (existingFilePath != null && !existingFilePath.isEmpty()) {
                try {
                    // Construir la ruta física del archivo a borrar
                    String oldFilePath = fixedUploadPath + File.separator + existingFilePath;
                    File oldFile = new File(oldFilePath);
                    if (oldFile.exists()) {
                        oldFile.delete();
                        System.out.println("TesisAdminServlet(Eliminar): Archivo físico borrado: " + oldFilePath);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    session.setAttribute("adminError", "Tesis borrada de la BD, pero falló al borrar el archivo físico.");
                    return;
                }
            }
            session.setAttribute("adminMsg", "Tesis eliminada con éxito.");
        } else {
            session.setAttribute("adminError", "No se pudo eliminar la tesis (posiblemente tiene evaluaciones asociadas).");
        }
    }
}