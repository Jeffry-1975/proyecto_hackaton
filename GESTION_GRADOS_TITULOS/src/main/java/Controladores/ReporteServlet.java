package Controladores;

import Datos.TesisDAO;
import Modelos.Tesis;
import Modelos.Usuario;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Genera y sirve un reporte en CSV de las tesis asignadas al docente.
 */
@WebServlet(name = "ReporteServlet", urlPatterns = {"/ReporteServlet"})
public class ReporteServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuarioLogueado") : null;

        if (usuario == null || !"docente".equals(usuario.getRol())) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 1. Configurar la respuesta para forzar la descarga de un CSV
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"reporte_tesis_asignadas.csv\"");
        
        TesisDAO tesisDAO = new TesisDAO();
        
        try (PrintWriter writer = response.getWriter()) {
            
            // 2. Escribir la cabecera del CSV
            writer.println("ID Tesis;Titulo;Codigo Estudiante;Nombre Estudiante;Estado;Fecha Subida");
            
            // 3. Obtener los datos
            List<Tesis> listaTesis = tesisDAO.getTesisPorDocente(usuario.getCodigo());
            
            // 4. Escribir las filas del CSV
            for (Tesis tesis : listaTesis) {
                writer.printf("%d;\"%s\";\"%s\";\"%s\";\"%s\";%s\n",
                        tesis.getIdTesis(),
                        tesis.getTitulo(),
                        tesis.getCodigoEstudiante(),
                        tesis.getNombreEstudiante(),
                        tesis.getEstado(),
                        tesis.getFechaSubida().toString()
                );
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            // Si falla, redirigir (aunque la respuesta ya puede estar parcialmente enviada)
            response.setContentType("text/html");
            response.sendRedirect("TeacherServlet?error=reporte_sql");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // El formulario en el JSP usa POST, así que lo redirigimos a doGet.
        doGet(request, response);
    }
}