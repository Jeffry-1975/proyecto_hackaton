package Controladores;

import Datos.UsuarioDAO;
import Modelos.Usuario;
import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet para manejar las acciones del CRUD de Usuarios (Crear, Editar, Eliminar)
 * desde el panel de admin.
 */
@WebServlet(name = "UsuarioAdminServlet", urlPatterns = {"/UsuarioAdminServlet"})
public class UsuarioAdminServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Determinar la acción (Crear, Editar, Eliminar)
        String action = request.getParameter("action");
        if (action == null) {
            action = "crear"; // Acción por defecto si no se especifica
        }

        UsuarioDAO dao = new UsuarioDAO();
        HttpSession session = request.getSession();
        
        try {
            switch (action) {
                case "crear":
                    handleCrearUsuario(request, dao);
                    session.setAttribute("adminMsg", "Usuario creado con éxito."); // <-- AÑADIDO
                    break;
                case "editar":
                    handleEditarUsuario(request, dao);
                    session.setAttribute("adminMsg", "Usuario actualizado con éxito."); // <-- AÑADIDO
                    break;
                case "eliminar": // <-- AÑADIDO
                    handleEliminarUsuario(request, dao, session); // <-- AÑADIDO
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("UsuarioAdminServlet: Error de SQL: " + e.getMessage());
            
            // --- MANEJO DE ERROR MEJORADO ---
            String errorMsg = "Error al procesar la solicitud.";
            if (e.getSQLState().startsWith("23")) { // Código de Violación de Integridad (ej. Llave duplicada o Foránea)
                if (action.equals("eliminar")) {
                    errorMsg = "No se puede eliminar: El usuario tiene tesis u otros registros asignados.";
                } else {
                    errorMsg = "No se puede guardar: El código o email ya existe.";
                }
            }
            session.setAttribute("adminError", errorMsg); // <-- AÑADIDO
        }
        
        // 5. Redirigir de vuelta al AdminServlet (siempre)
        response.sendRedirect("AdminServlet");
    }

    // --- MANEJADOR DE ACCIÓN: CREAR ---
    private void handleCrearUsuario(HttpServletRequest request, UsuarioDAO dao) throws SQLException {
        // 1. Recoger los datos del formulario del modal "Crear"
        String codigo = request.getParameter("codigo");
        String nombres = request.getParameter("nombres");
        String apellidos = request.getParameter("apellidos");
        String email = request.getParameter("email");
        String rol = request.getParameter("rol"); // "docente" o "alumno"
        
        // 2. Lógica de negocio (Contraseña por defecto)
        String password = codigo; 
        
        // 3. Crear el objeto Usuario
        Usuario nuevoUsuario = new Usuario();
        nuevoUsuario.setCodigo(codigo);
        nuevoUsuario.setNombres(nombres);
        nuevoUsuario.setApellidos(apellidos);
        nuevoUsuario.setEmail(email);
        nuevoUsuario.setPassword(password);
        nuevoUsuario.setRol(rol);
        
        // 4. Guardar en la BD
        boolean exito = dao.insertarUsuario(nuevoUsuario);
        if (exito) {
            System.out.println("UsuarioAdminServlet: Usuario CREADO con éxito: " + codigo);
        } else {
            System.out.println("UsuarioAdminServlet: Error al CREAR usuario: " + codigo);
        }
    }

    // --- MANEJADOR DE ACCIÓN: EDITAR ---
    private void handleEditarUsuario(HttpServletRequest request, UsuarioDAO dao) throws SQLException {
        // 1. Recoger los datos del formulario del modal "Editar"
        String codigo = request.getParameter("codigo"); // Viene del campo readonly
        String nombres = request.getParameter("nombres");
        String apellidos = request.getParameter("apellidos");
        String email = request.getParameter("email");
        
        // 2. Crear el objeto Usuario
        Usuario usuarioEditado = new Usuario();
        usuarioEditado.setCodigo(codigo);
        usuarioEditado.setNombres(nombres);
        usuarioEditado.setApellidos(apellidos);
        usuarioEditado.setEmail(email);
        
        // 3. Actualizar en la BD
        boolean exito = dao.actualizarUsuario(usuarioEditado);
        if (exito) {
            System.out.println("UsuarioAdminServlet: Usuario ACTUALIZADO con éxito: " + codigo);
        } else {
            System.out.println("UsuarioAdminServlet: Error al ACTUALIZAR usuario: " + codigo);
        }
    }
    
    // --- NUEVO MANEJADOR DE ACCIÓN: ELIMINAR ---
    private void handleEliminarUsuario(HttpServletRequest request, UsuarioDAO dao, HttpSession session) throws SQLException {
        // 1. Recoger el código del formulario del modal "Eliminar"
        String codigo = request.getParameter("codigo");
        
        // 2. Eliminar de la BD
        boolean exito = dao.eliminarUsuario(codigo);
        
        if (exito) {
            System.out.println("UsuarioAdminServlet: Usuario ELIMINADO con éxito: " + codigo);
            session.setAttribute("adminMsg", "Usuario eliminado con éxito.");
        } else {
            System.out.println("UsuarioAdminServlet: Error al ELIMINAR usuario: " + codigo);
            session.setAttribute("adminError", "No se pudo eliminar al usuario (código no encontrado).");
        }
    }

}