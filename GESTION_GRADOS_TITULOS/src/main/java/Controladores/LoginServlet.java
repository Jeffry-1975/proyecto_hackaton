package Controladores; // <-- Tu paquete está correcto

import Datos.UsuarioDAO; // Importamos el DAO
import Modelos.Usuario; // Importamos el Modelo
import java.io.IOException;
import jakarta.servlet.RequestDispatcher; // <-- Importante
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession; // <-- Importante
import java.sql.SQLException;

/**
 *
 * @author diego
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Obtener parámetros (igual que antes)
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // 2. Lógica de validación (¡AHORA CON DAO!)
        UsuarioDAO dao = new UsuarioDAO();
        Usuario usuario = null;

        try {
            usuario = dao.validarLogin(email, password);
        } catch (SQLException e) {
            // Manejo básico de error de base de datos
            e.printStackTrace(); // Imprime el error en la consola de Tomcat
            request.setAttribute("errorMsg", "Error de conexión con la base de datos.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
            dispatcher.forward(request, response);
            return; // Detiene la ejecución
        }
        
        // 3. Gestión de Sesión y Redirección
        if (usuario != null) {
            // ----- INICIO DE SESIÓN EXITOSO -----
            
            HttpSession session = request.getSession();
            
            // Guardamos el OBJETO USUARIO COMPLETO en la sesión
            session.setAttribute("usuarioLogueado", usuario);
            
            // También guardamos el rol y el código para acceso rápido (útil para el filtro)
            session.setAttribute("usuarioRol", usuario.getRol());
            session.setAttribute("usuarioCodigo", usuario.getCodigo());
            
            session.setMaxInactiveInterval(30 * 60);
            
            // Redirigimos según el rol
            String destinoJSP = "login.jsp"; // Default
            switch (usuario.getRol()) {
                case "admin":
                    destinoJSP = "AdminServlet";
                    break;
                case "alumno":
                    destinoJSP = "StudentServlet";
                    break;
                case "docente":
                    destinoJSP = "TeacherServlet";
                    break;
            }
            response.sendRedirect(destinoJSP);
            
        } else {
            // ----- FALLO EN EL INICIO DE SESIÓN -----
            
            request.setAttribute("errorMsg", "Credenciales incorrectas. Por favor, intenta de nuevo.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
            dispatcher.forward(request, response);
        }
    }

    /**
     * Handles the HTTP <code>GET</code> method.
     * Si alguien escribe /LoginServlet en la URL, lo mandamos al login.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirige al login.jsp si intentan acceder por GET
        response.sendRedirect("login.jsp");
    }

    /**
     * Returns a short description of the servlet.
     */
    @Override
    public String getServletInfo() {
        return "Servlet para procesar el inicio de sesión";
    }// </editor-fold>

}