package Datos;

import Modelos.Evaluacion;
import Modelos.Tesis;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO para gestionar las tablas 'tesis' y 'evaluaciones'.
 * ACTUALIZADO PARA RÚBRICA DE 38 ÍTEMS.
 */
public class TesisDAO {

    // (Desde StudentServlet)
    private static final String SQL_SELECT_TESIS_BY_ESTUDIANTE = 
        "SELECT t.*, u.nombres AS docente_nombres, u.apellidos AS docente_apellidos, t.archivo_path " +
        "FROM tesis t " +
        "LEFT JOIN usuarios u ON t.codigo_docente_revisor = u.codigo " +
        "WHERE t.codigo_estudiante = ? LIMIT 1";

    // (Desde StudentServlet) - ACTUALIZADO
    private static final String SQL_SELECT_LAST_EVALUACION_BY_TESIS = 
        "SELECT * FROM evaluaciones WHERE id_tesis = ? ORDER BY fecha_evaluacion DESC LIMIT 1";

    // (Desde TeacherServlet)
    private static final String SQL_SELECT_TESIS_BY_DOCENTE = 
        "SELECT t.*, u.nombres AS estudiante_nombres, u.apellidos AS estudiante_apellidos, t.archivo_path " +
        "FROM tesis t " +
        "LEFT JOIN usuarios u ON t.codigo_estudiante = u.codigo " +
        "WHERE t.codigo_docente_revisor = ?";
        
    // (Desde AdminServlet)
    private static final String SQL_COUNT_TESIS_BY_ESTADOS = "SELECT COUNT(*) FROM tesis WHERE estado IN (";

    // (Desde EvaluarServlet) - ¡TOTALMENTE MODIFICADO!
    private static final String SQL_INSERT_EVALUACION = 
        "INSERT INTO evaluaciones (id_tesis, codigo_docente, comentarios, " +
        "item_1, item_2, item_3, item_4, item_5, item_6, item_7, item_8, item_9, item_10, " +
        "item_11, item_12, item_13, item_14, item_15, item_16, item_17, item_18, item_19, item_20, " +
        "item_21, item_22, item_23, item_24, item_25, item_26, item_27, item_28, item_29, item_30, " +
        "item_31, item_32, item_33, item_34, item_35, item_36, item_37, item_38, " +
        "puntaje_total, condicion) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, " +
        "?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"; // 43 '?' en total

    private static final String SQL_UPDATE_TESIS_ESTADO = 
        "UPDATE tesis SET estado = ? WHERE id_tesis = ?";
    
    private static final String SQL_SELECT_ALL_TESIS_CON_NOMBRES = 
        "SELECT t.id_tesis, t.titulo, t.estado, t.archivo_path, " +
        "t.codigo_estudiante, CONCAT(e.nombres, ' ', e.apellidos) AS nombre_estudiante, " +
        "t.codigo_docente_revisor, CONCAT(d.nombres, ' ', d.apellidos) AS nombre_docente " +
        "FROM tesis t " +
        "JOIN usuarios e ON t.codigo_estudiante = e.codigo " +
        "LEFT JOIN usuarios d ON t.codigo_docente_revisor = d.codigo " +
        "ORDER BY t.fecha_subida DESC";

    private static final String SQL_INSERT_TESIS = 
        "INSERT INTO tesis (titulo, codigo_estudiante, codigo_docente_revisor, estado, archivo_path) " +
        "VALUES (?, ?, ?, ?, ?)";
    
    private static final String SQL_UPDATE_TESIS_ASIGNACION = 
        "UPDATE tesis SET codigo_docente_revisor = ?, estado = ? WHERE id_tesis = ?";

    private static final String SQL_UPDATE_TESIS = 
        "UPDATE tesis SET titulo = ?, archivo_path = ? WHERE id_tesis = ?";
        
    private static final String SQL_DELETE_TESIS = 
        "DELETE FROM tesis WHERE id_tesis = ?";
    
    // --- Consultas para Reporte de Estudiante ---
    private static final String SQL_SELECT_TESIS_BY_ID_CON_NOMBRES = 
        "SELECT t.titulo, " +
        "CONCAT(e.nombres, ' ', e.apellidos) AS nombre_estudiante, " +
        "CONCAT(d.nombres, ' ', d.apellidos) AS nombre_docente " +
        "FROM tesis t " +
        "JOIN usuarios e ON t.codigo_estudiante = e.codigo " +
        "LEFT JOIN usuarios d ON t.codigo_docente_revisor = d.codigo " +
        "WHERE t.id_tesis = ?";
        
    // (Desde ReporteEvaluacionServlet) - ACTUALIZADO
    private static final String SQL_SELECT_EVALUACION_BY_ID = 
        "SELECT * FROM evaluaciones WHERE id_evaluacion = ?";

    // (Desde TeacherServlet) - ¡¡CORRECCIÓN IMPORTANTE AQUÍ!!
    // Se cambió 'decision_final' por 'condicion'
    private static final String SQL_SELECT_EVALUACIONES_BY_DOCENTE = 
        "SELECT e.id_evaluacion, e.fecha_evaluacion, e.condicion, e.comentarios, " +
        "t.titulo AS titulo_tesis, CONCAT(u.nombres, ' ', u.apellidos) AS nombre_estudiante " +
        "FROM evaluaciones e " +
        "JOIN tesis t ON e.id_tesis = t.id_tesis " +
        "JOIN usuarios u ON t.codigo_estudiante = u.codigo " +
        "WHERE e.codigo_docente = ? ORDER BY e.fecha_evaluacion DESC";

    // (Desde StudentServlet) - ACTUALIZADO (cambio de decision_final a condicion)
    private static final String SQL_SELECT_HISTORIAL_EVALUACIONES_BY_TESIS = 
        "SELECT id_evaluacion, id_tesis, codigo_docente, comentarios, fecha_evaluacion, condicion " +
        "FROM evaluaciones WHERE id_tesis = ? ORDER BY fecha_evaluacion DESC";
    
    private static final String SQL_UPDATE_TESIS_CORRECCION = 
        "UPDATE tesis SET archivo_path = ?, estado = ?, fecha_subida = CURRENT_TIMESTAMP WHERE id_tesis = ?";
    
    
    // --- MÉTODO 1 (Para StudentServlet) ---
    public Tesis getTesisPorEstudiante(String codigoEstudiante) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Tesis tesis = null;

        try {
            conn = Conexion.getConnection();
            stmt = conn.prepareStatement(SQL_SELECT_TESIS_BY_ESTUDIANTE);
            stmt.setString(1, codigoEstudiante);
            rs = stmt.executeQuery();

            if (rs.next()) {
                tesis = new Tesis();
                tesis.setIdTesis(rs.getInt("id_tesis"));
                tesis.setTitulo(rs.getString("titulo"));
                tesis.setCodigoEstudiante(rs.getString("codigo_estudiante"));
                tesis.setCodigoDocenteRevisor(rs.getString("codigo_docente_revisor"));
                tesis.setEstado(rs.getString("estado"));
                tesis.setFechaSubida(rs.getTimestamp("fecha_subida"));
                tesis.setArchivoPath(rs.getString("archivo_path"));
                
                String nombresDocente = rs.getString("docente_nombres");
                String apellidosDocente = rs.getString("docente_apellidos");
                tesis.setNombreDocenteRevisor(nombresDocente != null ? nombresDocente + " " + apellidosDocente : "Aún no asignado");
            }
        } finally {
            Conexion.close(rs);
            Conexion.close(stmt);
            Conexion.close(conn);
        }
        return tesis;
    }

    // --- MÉTODO 2 (Para StudentServlet) ---
    public Evaluacion getUltimaEvaluacionPorTesis(int idTesis) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Evaluacion evaluacion = null;

        try {
            conn = Conexion.getConnection();
            stmt = conn.prepareStatement(SQL_SELECT_LAST_EVALUACION_BY_TESIS);
            stmt.setInt(1, idTesis);
            rs = stmt.executeQuery();

            if (rs.next()) {
                evaluacion = new Evaluacion();
                // Mapear todos los campos
                mapResultSetToEvaluacionCompleta(rs, evaluacion);
            }
        } finally {
            Conexion.close(rs);
            Conexion.close(stmt);
            Conexion.close(conn);
        }
        return evaluacion;
    }

    // --- MÉTODO 3 (Para TeacherServlet) ---
    public List<Tesis> getTesisPorDocente(String codigoDocente) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Tesis> listaTesis = new ArrayList<>();

        try {
            conn = Conexion.getConnection();
            stmt = conn.prepareStatement(SQL_SELECT_TESIS_BY_DOCENTE);
            stmt.setString(1, codigoDocente);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Tesis tesis = new Tesis();
                tesis.setIdTesis(rs.getInt("id_tesis"));
                tesis.setTitulo(rs.getString("titulo"));
                tesis.setCodigoEstudiante(rs.getString("codigo_estudiante"));
                tesis.setCodigoDocenteRevisor(rs.getString("codigo_docente_revisor"));
                tesis.setEstado(rs.getString("estado"));
                tesis.setFechaSubida(rs.getTimestamp("fecha_subida"));
                tesis.setArchivoPath(rs.getString("archivo_path"));
                
                String nombres = rs.getString("estudiante_nombres");
                String apellidos = rs.getString("estudiante_apellidos");
                tesis.setNombreEstudiante(nombres != null ? nombres + " " + apellidos : "Estudiante no encontrado");
                
                listaTesis.add(tesis);
            }
        } finally {
            Conexion.close(rs);
            Conexion.close(stmt);
            Conexion.close(conn);
        }
        return listaTesis;
    }
    
    // --- MÉTODO 4 (Para AdminServlet) ---
    public int contarTesisPorEstados(List<String> estados) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        int conteo = 0;
        
        if (estados == null || estados.isEmpty()) {
            return 0;
        }
        
        String placeholders = String.join(",", java.util.Collections.nCopies(estados.size(), "?"));
        String sql = SQL_COUNT_TESIS_BY_ESTADOS + placeholders + ")";

        try {
            conn = Conexion.getConnection();
            stmt = conn.prepareStatement(sql);
            
            for (int i = 0; i < estados.size(); i++) {
                stmt.setString(i + 1, estados.get(i));
            }
            
            rs = stmt.executeQuery();

            if (rs.next()) {
                conteo = rs.getInt(1);
            }
        } finally {
            Conexion.close(rs);
            Conexion.close(stmt);
            Conexion.close(conn);
        }
        return conteo;
    }
    
    // --- MÉTODO 5 (Para EvaluarServlet) ---
    public boolean guardarEvaluacion(Evaluacion evaluacion, String nuevoEstadoTesis) throws SQLException {
        Connection conn = null;
        PreparedStatement stmtInsert = null;
        PreparedStatement stmtUpdate = null;
        boolean exito = false;

        try {
            conn = Conexion.getConnection();
            conn.setAutoCommit(false); 

            // 1. Insertar la nueva evaluación
            stmtInsert = conn.prepareStatement(SQL_INSERT_EVALUACION);
            
            // Campos base
            stmtInsert.setInt(1, evaluacion.getIdTesis());
            stmtInsert.setString(2, evaluacion.getCodigoDocente());
            stmtInsert.setString(3, evaluacion.getComentarios());
            
            // Campos de la Rúbrica (38)
            stmtInsert.setDouble(4, evaluacion.getItem1());
            stmtInsert.setDouble(5, evaluacion.getItem2());
            stmtInsert.setDouble(6, evaluacion.getItem3());
            stmtInsert.setDouble(7, evaluacion.getItem4());
            stmtInsert.setDouble(8, evaluacion.getItem5());
            stmtInsert.setDouble(9, evaluacion.getItem6());
            stmtInsert.setDouble(10, evaluacion.getItem7());
            stmtInsert.setDouble(11, evaluacion.getItem8());
            stmtInsert.setDouble(12, evaluacion.getItem9());
            stmtInsert.setDouble(13, evaluacion.getItem10());
            stmtInsert.setDouble(14, evaluacion.getItem11());
            stmtInsert.setDouble(15, evaluacion.getItem12());
            stmtInsert.setDouble(16, evaluacion.getItem13());
            stmtInsert.setDouble(17, evaluacion.getItem14());
            stmtInsert.setDouble(18, evaluacion.getItem15());
            stmtInsert.setDouble(19, evaluacion.getItem16());
            stmtInsert.setDouble(20, evaluacion.getItem17());
            stmtInsert.setDouble(21, evaluacion.getItem18());
            stmtInsert.setDouble(22, evaluacion.getItem19());
            stmtInsert.setDouble(23, evaluacion.getItem20());
            stmtInsert.setDouble(24, evaluacion.getItem21());
            stmtInsert.setDouble(25, evaluacion.getItem22());
            stmtInsert.setDouble(26, evaluacion.getItem23());
            stmtInsert.setDouble(27, evaluacion.getItem24());
            stmtInsert.setDouble(28, evaluacion.getItem25());
            stmtInsert.setDouble(29, evaluacion.getItem26());
            stmtInsert.setDouble(30, evaluacion.getItem27());
            stmtInsert.setDouble(31, evaluacion.getItem28());
            stmtInsert.setDouble(32, evaluacion.getItem29());
            stmtInsert.setDouble(33, evaluacion.getItem30());
            stmtInsert.setDouble(34, evaluacion.getItem31());
            stmtInsert.setDouble(35, evaluacion.getItem32());
            stmtInsert.setDouble(36, evaluacion.getItem33());
            stmtInsert.setDouble(37, evaluacion.getItem34());
            stmtInsert.setDouble(38, evaluacion.getItem35());
            stmtInsert.setDouble(39, evaluacion.getItem36());
            stmtInsert.setDouble(40, evaluacion.getItem37());
            stmtInsert.setDouble(41, evaluacion.getItem38());
            
            // Resultados
            stmtInsert.setDouble(42, evaluacion.getPuntajeTotal());
            stmtInsert.setString(43, evaluacion.getCondicion());
            
            int filasInsertadas = stmtInsert.executeUpdate();

            // 2. Actualizar el estado de la tesis
            stmtUpdate = conn.prepareStatement(SQL_UPDATE_TESIS_ESTADO);
            stmtUpdate.setString(1, nuevoEstadoTesis);
            stmtUpdate.setInt(2, evaluacion.getIdTesis());
            
            int filasActualizadas = stmtUpdate.executeUpdate();

            // 3. Confirmar la transacción (Commit)
            if (filasInsertadas > 0 && filasActualizadas > 0) {
                conn.commit();
                exito = true;
            } else {
                conn.rollback(); 
            }

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback(); 
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            throw e; 
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
            }
            Conexion.close(stmtInsert);
            Conexion.close(stmtUpdate);
            Conexion.close(conn);
        }
        return exito;
    }
    
    // --- MÉTODO 6 (Para AdminServlet) ---
    public List<Tesis> getAllTesisConNombres() throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Tesis> listaTesis = new ArrayList<>();

        try {
            conn = Conexion.getConnection();
            stmt = conn.prepareStatement(SQL_SELECT_ALL_TESIS_CON_NOMBRES);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Tesis tesis = new Tesis();
                tesis.setIdTesis(rs.getInt("id_tesis"));
                tesis.setTitulo(rs.getString("titulo"));
                tesis.setEstado(rs.getString("estado"));
                tesis.setArchivoPath(rs.getString("archivo_path")); 
                tesis.setCodigoEstudiante(rs.getString("codigo_estudiante"));
                tesis.setNombreEstudiante(rs.getString("nombre_estudiante"));
                tesis.setCodigoDocenteRevisor(rs.getString("codigo_docente_revisor"));
                tesis.setNombreDocenteRevisor(rs.getString("nombre_docente"));
                
                listaTesis.add(tesis);
            }
        } finally {
            Conexion.close(rs);
            Conexion.close(stmt);
            Conexion.close(conn);
        }
        return listaTesis;
    }
    
    // --- MÉTODOS 7, 8, 9, 10 (Para TesisAdminServlet) ---
    public boolean insertarTesis(Tesis tesis) throws SQLException { 
        Connection conn = null;
        PreparedStatement stmt = null;
        int filasAfectadas = 0;

        try {
            conn = Conexion.getConnection();
            stmt = conn.prepareStatement(SQL_INSERT_TESIS);
            
            stmt.setString(1, tesis.getTitulo());
            stmt.setString(2, tesis.getCodigoEstudiante());
            stmt.setString(3, tesis.getCodigoDocenteRevisor());
            stmt.setString(4, tesis.getEstado());
            stmt.setString(5, tesis.getArchivoPath());
            
            filasAfectadas = stmt.executeUpdate();

        } finally {
            Conexion.close(stmt);
            Conexion.close(conn);
        }
        return filasAfectadas > 0;
    }
    public boolean actualizarAsignacion(int idTesis, String codigoDocente, String nuevoEstado) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        int filasAfectadas = 0;

        try {
            conn = Conexion.getConnection();
            stmt = conn.prepareStatement(SQL_UPDATE_TESIS_ASIGNACION);
            
            if (codigoDocente == null) {
                stmt.setNull(1, java.sql.Types.VARCHAR);
            } else {
                stmt.setString(1, codigoDocente);
            }
            
            stmt.setString(2, nuevoEstado);
            stmt.setInt(3, idTesis);
            
            filasAfectadas = stmt.executeUpdate();

        } finally {
            Conexion.close(stmt);
            Conexion.close(conn);
        }
        return filasAfectadas > 0;
    }
    public boolean actualizarTesis(Tesis tesis) throws SQLException { 
        Connection conn = null;
        PreparedStatement stmt = null;
        int filasAfectadas = 0;

        try {
            conn = Conexion.getConnection();
            stmt = conn.prepareStatement(SQL_UPDATE_TESIS);
            stmt.setString(1, tesis.getTitulo());
            stmt.setString(2, tesis.getArchivoPath());
            stmt.setInt(3, tesis.getIdTesis());
            
            filasAfectadas = stmt.executeUpdate();
        } finally {
            Conexion.close(stmt);
            Conexion.close(conn);
        }
        return filasAfectadas > 0;
    }
    public boolean eliminarTesis(int idTesis) throws SQLException { 
        Connection conn = null;
        PreparedStatement stmt = null;
        int filasAfectadas = 0;

        try {
            conn = Conexion.getConnection();
            stmt = conn.prepareStatement(SQL_DELETE_TESIS);
            stmt.setInt(1, idTesis);
            
            filasAfectadas = stmt.executeUpdate();
        } finally {
            Conexion.close(stmt);
            Conexion.close(conn);
        }
        return filasAfectadas > 0;
    }
    
    // --- MÉTODO 11 (Para TeacherServlet - Historial) ---
    // ¡¡CORRECCIÓN IMPORTANTE!!
    public List<Evaluacion> getEvaluacionesPorDocente(String codigoDocente) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Evaluacion> historial = new ArrayList<>();

        try {
            conn = Conexion.getConnection();
            stmt = conn.prepareStatement(SQL_SELECT_EVALUACIONES_BY_DOCENTE);
            stmt.setString(1, codigoDocente);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Evaluacion evaluacion = new Evaluacion();
                evaluacion.setIdEvaluacion(rs.getInt("id_evaluacion"));
                evaluacion.setFechaEvaluacion(rs.getTimestamp("fecha_evaluacion"));
                evaluacion.setCondicion(rs.getString("condicion")); // <-- CAMBIO AQUÍ
                evaluacion.setComentarios(rs.getString("comentarios"));
                evaluacion.setTituloTesis(rs.getString("titulo_tesis"));
                evaluacion.setNombreEstudiante(rs.getString("nombre_estudiante"));
                historial.add(evaluacion);
            }
        } finally {
            Conexion.close(rs);
            Conexion.close(stmt);
            Conexion.close(conn);
        }
        return historial;
    }

    // --- MÉTODO 12 (Para StudentServlet - Historial) ---
    public List<Evaluacion> getHistorialEvaluaciones(int idTesis) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Evaluacion> historial = new ArrayList<>();

        try {
            conn = Conexion.getConnection();
            stmt = conn.prepareStatement(SQL_SELECT_HISTORIAL_EVALUACIONES_BY_TESIS);
            stmt.setInt(1, idTesis);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Evaluacion evaluacion = new Evaluacion();
                evaluacion.setIdEvaluacion(rs.getInt("id_evaluacion"));
                evaluacion.setIdTesis(rs.getInt("id_tesis"));
                evaluacion.setCodigoDocente(rs.getString("codigo_docente"));
                evaluacion.setComentarios(rs.getString("comentarios"));
                evaluacion.setFechaEvaluacion(rs.getTimestamp("fecha_evaluacion"));
                evaluacion.setCondicion(rs.getString("condicion")); // <-- CAMBIO AQUÍ
                historial.add(evaluacion);
            }
        } finally {
            Conexion.close(rs);
            Conexion.close(stmt);
            Conexion.close(conn);
        }
        return historial;
    }
    
    // --- MÉTODO 13 (Para SubirCorreccionServlet) ---
    public boolean actualizarCorreccionTesis(int idTesis, String nuevoArchivoPath, String nuevoEstado) throws SQLException { 
        Connection conn = null;
        PreparedStatement stmt = null;
        int filasAfectadas = 0;

        try {
            conn = Conexion.getConnection();
            stmt = conn.prepareStatement(SQL_UPDATE_TESIS_CORRECCION);
            stmt.setString(1, nuevoArchivoPath);
            stmt.setString(2, nuevoEstado);
            stmt.setInt(3, idTesis);
            
            filasAfectadas = stmt.executeUpdate();
        } finally {
            Conexion.close(stmt);
            Conexion.close(conn);
        }
        return filasAfectadas > 0;
    }
    
    // --- MÉTODOS 14 y 15 (Para ReporteEvaluacionServlet) ---
    
    public Tesis getTesisPorId(int idTesis) throws SQLException { 
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Tesis tesis = null;

        try {
            conn = Conexion.getConnection();
            stmt = conn.prepareStatement(SQL_SELECT_TESIS_BY_ID_CON_NOMBRES);
            stmt.setInt(1, idTesis);
            rs = stmt.executeQuery();

            if (rs.next()) {
                tesis = new Tesis();
                tesis.setIdTesis(idTesis); 
                tesis.setTitulo(rs.getString("titulo"));
                tesis.setNombreEstudiante(rs.getString("nombre_estudiante"));
                tesis.setNombreDocenteRevisor(rs.getString("nombre_docente"));
            }
        } finally {
            Conexion.close(rs);
            Conexion.close(stmt);
            Conexion.close(conn);
        }
        return tesis;
    }
    
    public Evaluacion getEvaluacionPorId(int idEvaluacion) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Evaluacion evaluacion = null;

        try {
            conn = Conexion.getConnection();
            stmt = conn.prepareStatement(SQL_SELECT_EVALUACION_BY_ID);
            stmt.setInt(1, idEvaluacion);
            rs = stmt.executeQuery();

            if (rs.next()) {
                evaluacion = new Evaluacion();
                // Usar el helper para mapear todos los campos
                mapResultSetToEvaluacionCompleta(rs, evaluacion);
            }
        } finally {
            Conexion.close(rs);
            Conexion.close(stmt);
            Conexion.close(conn);
        }
        return evaluacion;
    }
    
    
    // --- NUEVO MÉTODO HELPER ---
    /**
     * Mapea un ResultSet a un objeto Evaluacion (completo, con 38 items).
     */
    private void mapResultSetToEvaluacionCompleta(ResultSet rs, Evaluacion evaluacion) throws SQLException {
        evaluacion.setIdEvaluacion(rs.getInt("id_evaluacion"));
        evaluacion.setIdTesis(rs.getInt("id_tesis"));
        evaluacion.setCodigoDocente(rs.getString("codigo_docente"));
        evaluacion.setComentarios(rs.getString("comentarios"));
        evaluacion.setFechaEvaluacion(rs.getTimestamp("fecha_evaluacion"));

        // Mapear los 38 items
        evaluacion.setItem1(rs.getDouble("item_1"));
        evaluacion.setItem2(rs.getDouble("item_2"));
        evaluacion.setItem3(rs.getDouble("item_3"));
        evaluacion.setItem4(rs.getDouble("item_4"));
        evaluacion.setItem5(rs.getDouble("item_5"));
        evaluacion.setItem6(rs.getDouble("item_6"));
        evaluacion.setItem7(rs.getDouble("item_7"));
        evaluacion.setItem8(rs.getDouble("item_8"));
        evaluacion.setItem9(rs.getDouble("item_9"));
        evaluacion.setItem10(rs.getDouble("item_10"));
        evaluacion.setItem11(rs.getDouble("item_11"));
        evaluacion.setItem12(rs.getDouble("item_12"));
        evaluacion.setItem13(rs.getDouble("item_13"));
        evaluacion.setItem14(rs.getDouble("item_14"));
        evaluacion.setItem15(rs.getDouble("item_15"));
        evaluacion.setItem16(rs.getDouble("item_16"));
        evaluacion.setItem17(rs.getDouble("item_17"));
        evaluacion.setItem18(rs.getDouble("item_18"));
        evaluacion.setItem19(rs.getDouble("item_19"));
        evaluacion.setItem20(rs.getDouble("item_20"));
        evaluacion.setItem21(rs.getDouble("item_21"));
        evaluacion.setItem22(rs.getDouble("item_22"));
        evaluacion.setItem23(rs.getDouble("item_23"));
        evaluacion.setItem24(rs.getDouble("item_24"));
        evaluacion.setItem25(rs.getDouble("item_25"));
        evaluacion.setItem26(rs.getDouble("item_26"));
        evaluacion.setItem27(rs.getDouble("item_27"));
        evaluacion.setItem28(rs.getDouble("item_28"));
        evaluacion.setItem29(rs.getDouble("item_29"));
        evaluacion.setItem30(rs.getDouble("item_30"));
        evaluacion.setItem31(rs.getDouble("item_31"));
        evaluacion.setItem32(rs.getDouble("item_32"));
        evaluacion.setItem33(rs.getDouble("item_33"));
        evaluacion.setItem34(rs.getDouble("item_34"));
        evaluacion.setItem35(rs.getDouble("item_35"));
        evaluacion.setItem36(rs.getDouble("item_36"));
        evaluacion.setItem37(rs.getDouble("item_37"));
        evaluacion.setItem38(rs.getDouble("item_38"));

        // Mapear resultados
        evaluacion.setPuntajeTotal(rs.getDouble("puntaje_total"));
        evaluacion.setCondicion(rs.getString("condicion"));
    }
}