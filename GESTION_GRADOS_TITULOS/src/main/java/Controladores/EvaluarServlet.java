package Controladores;

import Datos.TesisDAO;
import Modelos.Evaluacion;
import Modelos.Usuario;
import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "EvaluarServlet", urlPatterns = {"/EvaluarServlet"})
public class EvaluarServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Validar la sesión del docente
        HttpSession session = request.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuarioLogueado") : null;

        if (usuario == null || !"docente".equals(usuario.getRol())) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. Recoger TODOS los datos del formulario (modal)
        try {
            int idTesis = Integer.parseInt(request.getParameter("id_tesis"));
            String comentarios = request.getParameter("comentarios_revision");
            
            Evaluacion evaluacion = new Evaluacion();
            evaluacion.setIdTesis(idTesis);
            evaluacion.setCodigoDocente(usuario.getCodigo());
            evaluacion.setComentarios(comentarios);

            // 3. Leer y sumar los 38 items
            double puntajeTotal = 0;
            
            // Usamos un helper para no repetir código
            puntajeTotal += getItemValue(request, "item_1", evaluacion::setItem1);
            puntajeTotal += getItemValue(request, "item_2", evaluacion::setItem2);
            puntajeTotal += getItemValue(request, "item_3", evaluacion::setItem3);
            puntajeTotal += getItemValue(request, "item_4", evaluacion::setItem4);
            puntajeTotal += getItemValue(request, "item_5", evaluacion::setItem5);
            puntajeTotal += getItemValue(request, "item_6", evaluacion::setItem6);
            puntajeTotal += getItemValue(request, "item_7", evaluacion::setItem7);
            puntajeTotal += getItemValue(request, "item_8", evaluacion::setItem8);
            puntajeTotal += getItemValue(request, "item_9", evaluacion::setItem9);
            puntajeTotal += getItemValue(request, "item_10", evaluacion::setItem10);
            puntajeTotal += getItemValue(request, "item_11", evaluacion::setItem11);
            puntajeTotal += getItemValue(request, "item_12", evaluacion::setItem12);
            puntajeTotal += getItemValue(request, "item_13", evaluacion::setItem13);
            puntajeTotal += getItemValue(request, "item_14", evaluacion::setItem14);
            puntajeTotal += getItemValue(request, "item_15", evaluacion::setItem15);
            puntajeTotal += getItemValue(request, "item_16", evaluacion::setItem16);
            puntajeTotal += getItemValue(request, "item_17", evaluacion::setItem17);
            puntajeTotal += getItemValue(request, "item_18", evaluacion::setItem18);
            puntajeTotal += getItemValue(request, "item_19", evaluacion::setItem19);
            puntajeTotal += getItemValue(request, "item_20", evaluacion::setItem20);
            puntajeTotal += getItemValue(request, "item_21", evaluacion::setItem21);
            puntajeTotal += getItemValue(request, "item_22", evaluacion::setItem22);
            puntajeTotal += getItemValue(request, "item_23", evaluacion::setItem23);
            puntajeTotal += getItemValue(request, "item_24", evaluacion::setItem24);
            puntajeTotal += getItemValue(request, "item_25", evaluacion::setItem25);
            puntajeTotal += getItemValue(request, "item_26", evaluacion::setItem26);
            puntajeTotal += getItemValue(request, "item_27", evaluacion::setItem27);
            puntajeTotal += getItemValue(request, "item_28", evaluacion::setItem28);
            puntajeTotal += getItemValue(request, "item_29", evaluacion::setItem29);
            puntajeTotal += getItemValue(request, "item_30", evaluacion::setItem30);
            puntajeTotal += getItemValue(request, "item_31", evaluacion::setItem31);
            puntajeTotal += getItemValue(request, "item_32", evaluacion::setItem32);
            puntajeTotal += getItemValue(request, "item_33", evaluacion::setItem33);
            puntajeTotal += getItemValue(request, "item_34", evaluacion::setItem34);
            puntajeTotal += getItemValue(request, "item_35", evaluacion::setItem35);
            puntajeTotal += getItemValue(request, "item_36", evaluacion::setItem36);
            puntajeTotal += getItemValue(request, "item_37", evaluacion::setItem37);
            puntajeTotal += getItemValue(request, "item_38", evaluacion::setItem38);

            // 4. Calcular Condición y Nuevo Estado
            String condicion;
            String nuevoEstadoTesis;
            
            if (puntajeTotal >= 25) {
                condicion = "Aprobado";
                nuevoEstadoTesis = "Aprobado"; // Estado final en tabla 'tesis'
            } else if (puntajeTotal >= 13) {
                condicion = "Aprobado con observaciones menores";
                nuevoEstadoTesis = "Necesita Correcciones"; // Estado en tabla 'tesis'
            } else {
                condicion = "Desaprobado con observaciones mayores";
                nuevoEstadoTesis = "Necesita Correcciones"; // Estado en tabla 'tesis'
            }
            
            evaluacion.setPuntajeTotal(puntajeTotal);
            evaluacion.setCondicion(condicion);
            
            // 5. Guardar en la BD usando el DAO
            TesisDAO tesisDAO = new TesisDAO();
            boolean exito = tesisDAO.guardarEvaluacion(evaluacion, nuevoEstadoTesis);
            
            if (exito) {
                System.out.println("EvaluarServlet: Evaluación (38 items) guardada con éxito. Puntaje: " + puntajeTotal);
            } else {
                System.out.println("EvaluarServlet: Error al guardar la evaluación.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("EvaluarServlet: Error de SQL. " + e.getMessage());
        } catch (NumberFormatException e) {
            e.printStackTrace();
            System.out.println("EvaluarServlet: Error, ID de Tesis o valor de item no válido.");
        }

        // 6. Redirigir de vuelta al TeacherServlet
        response.sendRedirect("TeacherServlet");
    }

    /**
     * Helper para leer un item del request, setearlo en el objeto Evaluacion y devolver su valor.
     */
    private double getItemValue(HttpServletRequest request, String paramName, java.util.function.Consumer<Double> setter) {
        try {
            double value = Double.parseDouble(request.getParameter(paramName));
            setter.accept(value);
            return value;
        } catch (Exception e) {
            // Si el valor no llega (ej. no se marca radio button), asumimos 0.
            setter.accept(0.0);
            return 0.0;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("TeacherServlet");
    }
}