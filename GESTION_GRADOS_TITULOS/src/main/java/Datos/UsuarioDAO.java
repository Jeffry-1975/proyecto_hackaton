package Datos;

import Modelos.Usuario;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;  

/**
 * Data Access Object para la tabla 'usuarios'.
 * Contiene todos los métodos para interactuar con la BD.
 */
public class UsuarioDAO {

    private static final String SQL_SELECT_LOGIN = "SELECT * FROM usuarios WHERE email = ? AND password = ?";
    private static final String SQL_SELECT_BY_ROL = "SELECT * FROM usuarios WHERE rol = ?";

    private static final String SQL_INSERT_USUARIO = 
        "INSERT INTO usuarios (codigo, nombres, apellidos, email, password, rol) " +
        "VALUES (?, ?, ?, ?, ?, ?)";
    
    // --- NUEVO SQL: Para iniciar el trámite automáticamente ---
    private static final String SQL_INSERT_TRAMITE_AUTO = 
        "INSERT INTO tramites (codigo_estudiante, estado_actual) VALUES (?, 'Iniciado')";
    
    private static final String SQL_UPDATE_USUARIO = 
        "UPDATE usuarios SET nombres = ?, apellidos = ?, email = ? " +
        "WHERE codigo = ?";
    
    private static final String SQL_DELETE_USUARIO = "DELETE FROM usuarios WHERE codigo = ?";
    
    public Usuario validarLogin(String email, String password) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Usuario usuario = null;

        try {
            conn = Conexion.getConnection();
            stmt = conn.prepareStatement(SQL_SELECT_LOGIN);
            stmt.setString(1, email);
            stmt.setString(2, password);
            
            rs = stmt.executeQuery();

            if (rs.next()) {
                String codigo = rs.getString("codigo");
                String nombres = rs.getString("nombres");
                String apellidos = rs.getString("apellidos");
                String rol = rs.getString("rol");
                
                usuario = new Usuario(codigo, nombres, apellidos, email, password, rol);
            }

        } finally {
            Conexion.close(rs);
            Conexion.close(stmt);
            Conexion.close(conn);
        }

        return usuario;
    }
    
    public List<Usuario> listarPorRol(String rol) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Usuario> usuarios = new ArrayList<>();

        try {
            conn = Conexion.getConnection();
            stmt = conn.prepareStatement(SQL_SELECT_BY_ROL);
            stmt.setString(1, rol);
            rs = stmt.executeQuery();

            while (rs.next()) {
                String codigo = rs.getString("codigo");
                String nombres = rs.getString("nombres");
                String apellidos = rs.getString("apellidos");
                String email = rs.getString("email");
                
                Usuario usuario = new Usuario();
                usuario.setCodigo(codigo);
                usuario.setNombres(nombres);
                usuario.setApellidos(apellidos);
                usuario.setEmail(email);
                usuario.setRol(rol);
                
                usuarios.add(usuario);
            }
        } finally {
            Conexion.close(rs);
            Conexion.close(stmt);
            Conexion.close(conn);
        }

        return usuarios;
    }
    
    public boolean insertarUsuario(Usuario usuario) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        PreparedStatement stmtTramite = null; // Statement adicional
        int filasAfectadas = 0;

        try {
            conn = Conexion.getConnection();
            
            // Desactivar autocommit para asegurar integridad (opcional, pero recomendado)
            // conn.setAutoCommit(false); 

            // 1. Insertar el Usuario
            stmt = conn.prepareStatement(SQL_INSERT_USUARIO);
            
            stmt.setString(1, usuario.getCodigo());
            stmt.setString(2, usuario.getNombres());
            stmt.setString(3, usuario.getApellidos());
            stmt.setString(4, usuario.getEmail());
            stmt.setString(5, usuario.getPassword());
            stmt.setString(6, usuario.getRol());
            
            filasAfectadas = stmt.executeUpdate();

            // 2. LÓGICA NUEVA: Si se creó y es alumno, creamos su trámite
            if (filasAfectadas > 0 && "alumno".equalsIgnoreCase(usuario.getRol())) {
                try {
                    stmtTramite = conn.prepareStatement(SQL_INSERT_TRAMITE_AUTO);
                    stmtTramite.setString(1, usuario.getCodigo());
                    stmtTramite.executeUpdate();
                    System.out.println("UsuarioDAO: Trámite iniciado automáticamente para el alumno " + usuario.getCodigo());
                } catch (SQLException e) {
                    // Si falla la creación del trámite (ej: duplicado), lo logueamos pero no fallamos la creación del usuario
                    e.printStackTrace();
                    System.err.println("UsuarioDAO: Error al crear trámite automático, el usuario sí se creó.");
                }
            }
            
            // conn.commit();

        } finally {
            Conexion.close(stmtTramite);
            Conexion.close(stmt);
            Conexion.close(conn);
        }
        return filasAfectadas > 0;
    }
    
    public boolean actualizarUsuario(Usuario usuario) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        int filasAfectadas = 0;

        try {
            conn = Conexion.getConnection();
            stmt = conn.prepareStatement(SQL_UPDATE_USUARIO);
            
            stmt.setString(1, usuario.getNombres());
            stmt.setString(2, usuario.getApellidos());
            stmt.setString(3, usuario.getEmail());
            stmt.setString(4, usuario.getCodigo()); // El WHERE
            
            filasAfectadas = stmt.executeUpdate();

        } finally {
            Conexion.close(stmt);
            Conexion.close(conn);
        }
        return filasAfectadas > 0;
    }
    
    public boolean eliminarUsuario(String codigo) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        int filasAfectadas = 0;

        try {
            conn = Conexion.getConnection();
            stmt = conn.prepareStatement(SQL_DELETE_USUARIO);
            stmt.setString(1, codigo);
            
            filasAfectadas = stmt.executeUpdate();

        } finally {
            Conexion.close(stmt);
            Conexion.close(conn);
        }
        return filasAfectadas > 0;
    }
}