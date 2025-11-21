package Controladores;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Filtro de autenticación y autorización para la aplicación.
 */
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Inicialización (si es necesaria)
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false); // No crear una nueva sesión

        String path = httpRequest.getServletPath();
        
        // --- 1. Rutas Públicas (Excluidas del filtro) ---
        // Permitir acceso al LoginServlet, LogoutServlet y a la página de login
        if (path.equals("/login.jsp") || path.equals("/LoginServlet") || path.equals("/LogoutServlet")) {
            chain.doFilter(request, response);
            return;
        }

        // --- 2. Revisión de Sesión ---
        boolean isLoggedIn = (session != null && session.getAttribute("usuarioLogueado") != null);
        
        if (!isLoggedIn) {
            // Si no está logueado, redirigir al login
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp?error=session_expired");
            return;
        }
        
        // --- 3. Revisión de Autorización (Roles) ---
        String rol = (String) session.getAttribute("usuarioRol");
        boolean tienePermiso = false;
        
        try {
            // Reglas de Admin
            if ( (path.equals("/admin.jsp") || 
                   path.equals("/AdminServlet") ||
                   path.equals("/UsuarioAdminServlet") ||
                   path.equals("/TesisAdminServlet")) 
                   && rol.equals("admin")) 
            {
                tienePermiso = true;
            } 
            // Reglas de Alumno
            else if ( (path.equals("/student.jsp") || 
                        path.equals("/StudentServlet") ||
                        path.equals("/SubirCorreccionServlet") ||
                        path.equals("/ReporteEvaluacionServlet"))
                        && rol.equals("alumno")) 
            {
                tienePermiso = true;
            } 
            // Reglas de Docente
            else if ( (path.equals("/teacher.jsp") || 
                        path.equals("/TeacherServlet") || 
                        path.equals("/EvaluarServlet") ||
                        path.equals("/ReporteServlet"))
                        && rol.equals("docente")) 
            {
                tienePermiso = true;
            }

            // --- 4. Ejecución ---
            if (tienePermiso) {
                chain.doFilter(request, response);
            } else {
                // Si está logueado pero intenta acceder a una ruta de otro rol
                System.out.println("Acceso denegado. Rol: " + rol + ", Path: " + path);
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp?error=unauthorized");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp?error=filter_exception");
        }
    }

    @Override
    public void destroy() {
        // Limpieza (si es necesaria)
    }
}