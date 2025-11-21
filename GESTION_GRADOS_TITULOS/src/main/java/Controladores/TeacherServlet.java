package Controladores;

import Datos.TesisDAO;
import Datos.TramitesDAO;
import Modelos.Evaluacion;
import Modelos.Sustentacion;
import Modelos.Tesis;
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

@WebServlet(name = "TeacherServlet", urlPatterns = {"/TeacherServlet"})
public class TeacherServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuarioLogueado") : null;

        if (usuario == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        TesisDAO tesisDAO = new TesisDAO();
        TramitesDAO tramitesDAO = new TramitesDAO();
        
        try {
            // 1. Cargar tesis asignadas (Asesor)
            List<Tesis> listaTesis = tesisDAO.getTesisPorDocente(usuario.getCodigo());
            
            // 2. Cargar historial de evaluaciones
            List<Evaluacion> historialEvaluaciones = tesisDAO.getEvaluacionesPorDocente(usuario.getCodigo());
            
            // 3. Cargar designaciones como JURADO (NUEVO)
            List<Sustentacion> listaSustentaciones = tramitesDAO.getSustentacionesPorJurado(usuario.getCodigo());
            
            // 4. Estadísticas
            long totalAsignadas = listaTesis.size();
            long pendientesRevision = listaTesis.stream()
                    .filter(t -> "Pendiente de Revisión".equals(t.getEstado()) || "Revisión Solicitada".equals(t.getEstado()) || "En Proceso".equals(t.getEstado()))
                    .count();
            long completadas = listaTesis.stream()
                    .filter(t -> "Aprobado".equals(t.getEstado()))
                    .count();
            
            // Contar estudiantes únicos que asesora
            long totalEstudiantes = listaTesis.stream()
                    .map(Tesis::getCodigoEstudiante)
                    .distinct()
                    .count();

            // Enviar al JSP
            request.setAttribute("listaTesis", listaTesis);
            request.setAttribute("historialEvaluaciones", historialEvaluaciones);
            request.setAttribute("listaSustentaciones", listaSustentaciones);
            
            request.setAttribute("totalAsignadas", totalAsignadas);
            request.setAttribute("pendientesRevision", pendientesRevision);
            request.setAttribute("completadas", completadas);
            request.setAttribute("totalEstudiantes", totalEstudiantes);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=db_teacher");
            return;
        }
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("teacher.jsp");
        dispatcher.forward(request, response);
    }
}