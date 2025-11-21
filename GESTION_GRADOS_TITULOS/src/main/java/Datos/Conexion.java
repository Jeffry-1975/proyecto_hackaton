package Datos; // Un nuevo paquete para organizar las clases de BD

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Clase para gestionar la conexión a la base de datos MySQL.
 * * NOTA: Esta es una implementación simple. Para producción, se recomienda
 * usar un Pool de Conexiones (como HikariCP o el JNDI de Tomcat).
 */
public class Conexion {

    // --- ¡¡IMPORTANTE!! ---
    // Cambia estos valores por los de tu servidor MySQL
    
    // CORREGIDO: El nombre de la BD ahora es "bdgestiontesis"
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/bdgestiontesis?useSSL=false&serverTimezone=UTC";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASS = "admin";
    
    private static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";

    /**
     * Obtiene una conexión a la base de datos.
     * @return Un objeto Connection.
     * @throws SQLException
     */
    public static Connection getConnection() throws SQLException {
        try {
            // 1. Cargar el driver (solo es necesario una vez, pero no hace daño)
            Class.forName(JDBC_DRIVER);
        } catch (ClassNotFoundException e) {
            System.err.println("Error: No se encontró el driver de MySQL.");
            throw new SQLException("Error de driver", e);
        }
        
        // 2. Obtener la conexión
        return DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
    }

    /**
     * Cierra una conexión.
     * @param conn La conexión a cerrar.
     */
    public static void close(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                // Log del error (en un sistema real)
                e.printStackTrace();
            }
        }
    }
    
    // --- AÑADIDOS AHORA ---
    
    /**
     * Cierra un ResultSet.
     * @param rs El ResultSet a cerrar.
     */
    public static void close(ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Cierra un PreparedStatement.
     * @param stmt El PreparedStatement a cerrar.
     */
    public static void close(PreparedStatement stmt) {
        if (stmt != null) {
            try {
                stmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}