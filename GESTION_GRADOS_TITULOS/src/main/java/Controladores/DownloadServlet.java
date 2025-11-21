package Controladores;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Maneja la descarga segura de archivos desde una carpeta fija.
 */
//@WebServlet("/DownloadServlet")
public class DownloadServlet extends HttpServlet {

    private String fixedUploadPath;

    @Override
    public void init() throws ServletException {
        // Lee la ruta fija definida en web.xml
        fixedUploadPath = getServletContext().getInitParameter("ruta-tesis-uploads");
        if (fixedUploadPath == null) {
            System.err.println("DownloadServlet: ¡ERROR! 'ruta-tesis-uploads' no está configurada en web.xml.");
            throw new ServletException("'ruta-tesis-uploads' no está configurada en web.xml.");
        }
        System.out.println("DownloadServlet: Ruta de descargas configurada en: " + fixedUploadPath);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Obtener el nombre del archivo del parámetro 'file'
        String filename = request.getParameter("file");

        // 2. Verificación de seguridad básica (evita Path Traversal)
        if (filename == null || filename.isEmpty() || filename.contains("..") || filename.contains(File.separator)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Nombre de archivo inválido.");
            return;
        }

        // 3. Construir la ruta completa al archivo físico
        File file = new File(fixedUploadPath + File.separator + filename);

        // 4. Verificar si el archivo existe
        if (file.exists() && !file.isDirectory()) {
            
            // 5. Configurar cabeceras de respuesta para forzar la descarga
            response.setContentType("application/octet-stream");
            response.setContentLength((int) file.length());
            String headerKey = "Content-Disposition";
            String headerValue = String.format("attachment; filename=\"%s\"", file.getName());
            response.setHeader(headerKey, headerValue);

            // 6. Escribir el archivo en el 'OutputStream' de la respuesta
            try (InputStream in = new FileInputStream(file);
                 OutputStream os = response.getOutputStream()) {
                
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = in.read(buffer)) != -1) {
                    os.write(buffer, 0, bytesRead);
                }
            }
            
        } else {
            // 7. Si el archivo no se encuentra
            System.err.println("DownloadServlet: Archivo no encontrado en: " + file.getAbsolutePath());
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "El archivo solicitado no fue encontrado en el servidor.");
        }
    }
}