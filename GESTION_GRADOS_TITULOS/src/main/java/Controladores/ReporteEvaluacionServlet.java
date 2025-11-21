package Controladores;

import Datos.TesisDAO;
import Modelos.Evaluacion;
import Modelos.Tesis;
import Modelos.Usuario;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Genera un informe .txt detallado de una evaluación específica.
 * ¡ACTUALIZADO PARA RÚBRICA DE 38 ÍTEMS!
 */
@WebServlet(name = "ReporteEvaluacionServlet", urlPatterns = {"/ReporteEvaluacionServlet"})
public class ReporteEvaluacionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuarioLogueado") : null;

        if (usuario == null) { // Permitir a docentes O alumnos ver el reporte
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int idEvaluacion = Integer.parseInt(request.getParameter("id"));
            TesisDAO dao = new TesisDAO();
            Evaluacion evaluacion = dao.getEvaluacionPorId(idEvaluacion);
            
            if (evaluacion == null) {
                throw new ServletException("Evaluación no encontrada.");
            }
            
            Tesis tesis = dao.getTesisPorId(evaluacion.getIdTesis());
            if (tesis == null) {
                throw new ServletException("Tesis no encontrada.");
            }
            
            // Verificación de seguridad (Docente o Alumno de esa tesis)
            if ("alumno".equals(usuario.getRol())) {
                Tesis tesisDelAlumno = dao.getTesisPorEstudiante(usuario.getCodigo());
                if (tesisDelAlumno == null || tesisDelAlumno.getIdTesis() != tesis.getIdTesis()) {
                    response.sendRedirect("StudentServlet?error=auth_failed");
                    return;
                }
            } else if ("docente".equals(usuario.getRol())) {
                // (Opcional) Se podría verificar si el docente es el revisor
                // Por ahora, si es docente, puede ver el reporte que generó
            }

            response.setContentType("text/plain; charset=UTF-8"); // Asegurar UTF-8
            response.setHeader("Content-Disposition", "attachment; filename=\"reporte_evaluacion_" + idEvaluacion + ".txt\"");
            
            try (PrintWriter writer = response.getWriter()) {
                writer.println("========================================================");
                writer.println(" INFORME DETALLADO DE EVALUACIÓN DE TESIS");
                writer.println("========================================================");
                writer.println();
                writer.printf("ID de Evaluación: %d\n", evaluacion.getIdEvaluacion());
                writer.printf("Fecha de Evaluación: %s\n", evaluacion.getFechaEvaluacion().toString());
                writer.println();
                writer.println("--------------------------------------------------------");
                writer.println(" DATOS DE LA TESIS");
                writer.println("--------------------------------------------------------");
                writer.printf("Estudiante: %s\n", tesis.getNombreEstudiante());
                writer.printf("Título: %s\n", tesis.getTitulo());
                writer.printf("Docente Revisor: %s\n", tesis.getNombreDocenteRevisor());
                writer.println();
                writer.println("--------------------------------------------------------");
                writer.println(" RESULTADO DE LA EVALUACIÓN");
                writer.println("--------------------------------------------------------");
                writer.printf("PUNTAJE TOTAL: %.1f / 38.0\n", evaluacion.getPuntajeTotal());
                writer.printf("CONDICIÓN: %s\n", evaluacion.getCondicion());
                writer.println();
                writer.println("Comentarios Generales del Docente:");
                writer.println("----------------------------------");
                writer.println(evaluacion.getComentarios() != null ? evaluacion.getComentarios() : "Sin comentarios generales.");
                writer.println();
                writer.println("--------------------------------------------------------");
                writer.println(" DETALLE DE LA RÚBRICA (C=1.0, CP=0.5, NC=0.0)");
                writer.println("--------------------------------------------------------");
                
                // Imprimir la rúbrica
                printRubricaItem(writer, "I. Título", "");
                printRubricaItem(writer, "1. Concordancia...", evaluacion.getItem1());
                printRubricaItem(writer, "II. Resumen/Abstract", "");
                printRubricaItem(writer, "2. Contempla objetivo, metodología...", evaluacion.getItem2());
                printRubricaItem(writer, "3. No excede 250 palabras...", evaluacion.getItem3());
                printRubricaItem(writer, "III. Introducción", "");
                printRubricaItem(writer, "4. Sintetiza tema...", evaluacion.getItem4());
                printRubricaItem(writer, "IV. Problema", "");
                printRubricaItem(writer, "5. Describe problema científico...", evaluacion.getItem5());
                printRubricaItem(writer, "6. Formulación del problema...", evaluacion.getItem6());
                printRubricaItem(writer, "V. Justificación", "");
                printRubricaItem(writer, "7. Justificación social...", evaluacion.getItem7());
                printRubricaItem(writer, "8. Justificación teórica...", evaluacion.getItem8());
                printRubricaItem(writer, "9. Justificación metodológica...", evaluacion.getItem9());
                printRubricaItem(writer, "VI. Objetivos", "");
                printRubricaItem(writer, "10. Objetivo general...", evaluacion.getItem10());
                printRubricaItem(writer, "11. Objetivos específicos...", evaluacion.getItem11());
                printRubricaItem(writer, "VII. Aspectos éticos", "");
                printRubricaItem(writer, "12. Describe implicancias éticas...", evaluacion.getItem12());
                printRubricaItem(writer, "VIII. Marco Teórico", "");
                printRubricaItem(writer, "13. Antecedentes (objetivo, meto...).", evaluacion.getItem13());
                printRubricaItem(writer, "14. Antecedentes (artículos/tesis < 5 años...).", evaluacion.getItem14());
                printRubricaItem(writer, "15. Bases teóricas...", evaluacion.getItem15());
                printRubricaItem(writer, "16. Marco conceptual...", evaluacion.getItem16());
                printRubricaItem(writer, "IX. Hipótesis", "");
                printRubricaItem(writer, "17. Hipótesis claras...", evaluacion.getItem17());
                printRubricaItem(writer, "X. Variables", "");
                printRubricaItem(writer, "18. Identifica, clasifica y describe...", evaluacion.getItem18());
                printRubricaItem(writer, "19. Operacionaliza variables...", evaluacion.getItem19());
                printRubricaItem(writer, "XI. Metodología", "");
                printRubricaItem(writer, "20. Método general y específico.", evaluacion.getItem20());
                printRubricaItem(writer, "21. Tipo de investigación.", evaluacion.getItem21());
                printRubricaItem(writer, "22. Nivel de investigación.", evaluacion.getItem22());
                printRubricaItem(writer, "23. Diseño de investigación.", evaluacion.getItem23());
                printRubricaItem(writer, "24. Características de la población.", evaluacion.getItem24());
                printRubricaItem(writer, "25. Muestra (cálculo, criterios).", evaluacion.getItem25());
                printRubricaItem(writer, "26. Técnica/instrumento (confiabilidad, validez).", evaluacion.getItem26());
                printRubricaItem(writer, "27. Técnicas de procesamiento.", evaluacion.getItem27());
                printRubricaItem(writer, "28. Procedimiento de contrastación.", evaluacion.getItem28());
                printRubricaItem(writer, "XII. Resultados", "");
                printRubricaItem(writer, "29. Presentación (tablas/gráficos).", evaluacion.getItem29());
                printRubricaItem(writer, "30. Contrastación de hipótesis (inferencial).", evaluacion.getItem30());
                printRubricaItem(writer, "XIII. Análisis y discusión", "");
                printRubricaItem(writer, "31. Redacta en orden (objetivo/variable).", evaluacion.getItem31());
                printRubricaItem(writer, "32. Contrasta resultados con antecedentes.", evaluacion.getItem32());
                printRubricaItem(writer, "XIV. Conclusiones", "");
                printRubricaItem(writer, "33. Nivel de alcance (objetivos, hipótesis).", evaluacion.getItem33());
                printRubricaItem(writer, "XV. Recomendaciones", "");
                printRubricaItem(writer, "34. Derivadas de conclusiones.", evaluacion.getItem34());
                printRubricaItem(writer, "XVI. Referencias", "");
                printRubricaItem(writer, "35. Según norma bibliográfica.", evaluacion.getItem35());
                printRubricaItem(writer, "XVII. Anexos", "");
                printRubricaItem(writer, "36. Anexos exigidos en orden.", evaluacion.getItem36());
                printRubricaItem(writer, "XVIII. Aspectos de Forma", "");
                printRubricaItem(writer, "37. Formato del Reglamento.", evaluacion.getItem37());
                printRubricaItem(writer, "38. Documento ordenado, formato adecuado.", evaluacion.getItem38());
                
                writer.println();
                writer.println("========================================================");
                writer.println(" Fin del Reporte");
                writer.println("========================================================");
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect(getRedirectURL(usuario) + "?error=invalid_id");
        } catch (SQLException | ServletException e) {
            e.printStackTrace();
            response.sendRedirect(getRedirectURL(usuario) + "?error=report_failed");
        }
    }
    
    // Helper para imprimir la rúbrica de forma bonita
    private void printRubricaItem(PrintWriter writer, String descripcion, double puntaje) {
        writer.printf("- %-45s: %.1f\n", descripcion, puntaje);
    }
    
    // Helper para secciones
    private void printRubricaItem(PrintWriter writer, String seccion, String s) {
        writer.println();
        writer.printf("%s\n", seccion);
    }
    
    // Helper para redirigir
    private String getRedirectURL(Usuario usuario) {
        if (usuario == null) return "login.jsp";
        return "alumno".equals(usuario.getRol()) ? "StudentServlet" : "TeacherServlet";
    }
}