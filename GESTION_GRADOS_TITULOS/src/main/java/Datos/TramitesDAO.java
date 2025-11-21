package Datos;

import Modelos.DocumentoRequisito;
import Modelos.Notificacion;
import Modelos.Sustentacion;
import Modelos.Tramite;
import Modelos.Usuario;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TramitesDAO {

    // ==========================================
    // SECCIÓN 1: TRÁMITES
    // ==========================================
    
    public Tramite getTramitePorEstudiante(String codigoEstudiante) throws SQLException {
        Connection conn = null; PreparedStatement stmt = null; ResultSet rs = null;
        Tramite tramite = null;
        try {
            conn = Conexion.getConnection();
            String sql = "SELECT * FROM tramites WHERE codigo_estudiante = ? LIMIT 1";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, codigoEstudiante);
            rs = stmt.executeQuery();
            if (rs.next()) {
                tramite = new Tramite();
                tramite.setIdTramite(rs.getInt("id_tramite"));
                tramite.setCodigoEstudiante(rs.getString("codigo_estudiante"));
                tramite.setEstadoActual(rs.getString("estado_actual"));
                tramite.setFechaInicio(rs.getTimestamp("fecha_inicio"));
                tramite.setFechaActualizacion(rs.getTimestamp("fecha_actualizacion"));
            }
        } finally { Conexion.close(rs); Conexion.close(stmt); Conexion.close(conn); }
        return tramite;
    }

    public int iniciarTramite(String codigoEstudiante) throws SQLException {
        Connection conn = null; PreparedStatement stmt = null; ResultSet rs = null;
        try {
            conn = Conexion.getConnection();
            String sql = "INSERT INTO tramites (codigo_estudiante, estado_actual) VALUES (?, 'Iniciado')";
            stmt = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, codigoEstudiante);
            stmt.executeUpdate();
            rs = stmt.getGeneratedKeys();
            if (rs.next()) return rs.getInt(1); 
        } finally { Conexion.close(rs); Conexion.close(stmt); Conexion.close(conn); }
        return -1;
    }
    
    public List<Tramite> listarTodosLosTramites() throws SQLException {
        List<Tramite> lista = new ArrayList<>();
        Connection conn = null; PreparedStatement stmt = null; ResultSet rs = null;
        try {
            conn = Conexion.getConnection();
            String sql = "SELECT t.*, CONCAT(u.nombres, ' ', u.apellidos) as nombre_completo " +
                         "FROM tramites t " +
                         "JOIN usuarios u ON t.codigo_estudiante = u.codigo " +
                         "ORDER BY t.fecha_actualizacion DESC";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            while (rs.next()) {
                Tramite t = new Tramite();
                t.setIdTramite(rs.getInt("id_tramite"));
                t.setCodigoEstudiante(rs.getString("codigo_estudiante"));
                t.setNombreEstudiante(rs.getString("nombre_completo"));
                t.setEstadoActual(rs.getString("estado_actual"));
                t.setFechaInicio(rs.getTimestamp("fecha_inicio"));
                t.setFechaActualizacion(rs.getTimestamp("fecha_actualizacion"));
                lista.add(t);
            }
        } finally { Conexion.close(rs); Conexion.close(stmt); Conexion.close(conn); }
        return lista;
    }
    
    public boolean avanzarFaseTramite(int idTramite, String nuevoEstado) throws SQLException {
        Connection conn = null; PreparedStatement stmt = null;
        try {
            conn = Conexion.getConnection();
            String sql = "UPDATE tramites SET estado_actual = ? WHERE id_tramite = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, nuevoEstado);
            stmt.setInt(2, idTramite);
            return stmt.executeUpdate() > 0;
        } finally { Conexion.close(stmt); Conexion.close(conn); }
    }
    
    public String getCodigoEstudiantePorTramite(int idTramite) throws SQLException {
        Connection conn = null; PreparedStatement stmt = null; ResultSet rs = null;
        try {
            conn = Conexion.getConnection();
            String sql = "SELECT codigo_estudiante FROM tramites WHERE id_tramite = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idTramite);
            rs = stmt.executeQuery();
            if (rs.next()) return rs.getString(1);
        } finally { Conexion.close(rs); Conexion.close(stmt); Conexion.close(conn); }
        return null;
    }

    // ==========================================
    // SECCIÓN 2: DOCUMENTOS
    // ==========================================

    public List<DocumentoRequisito> getDocumentosPorTramite(int idTramite) throws SQLException {
        List<DocumentoRequisito> lista = new ArrayList<>();
        Connection conn = null; PreparedStatement stmt = null; ResultSet rs = null;
        try {
            conn = Conexion.getConnection();
            String sql = "SELECT * FROM documentos_requisito WHERE id_tramite = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idTramite);
            rs = stmt.executeQuery();
            while (rs.next()) {
                DocumentoRequisito doc = new DocumentoRequisito();
                doc.setIdDocumento(rs.getInt("id_documento"));
                doc.setIdTramite(rs.getInt("id_tramite"));
                doc.setTipoDocumento(rs.getString("tipo_documento"));
                doc.setRutaArchivo(rs.getString("ruta_archivo"));
                doc.setEstadoValidacion(rs.getString("estado_validacion"));
                doc.setObservacionRechazo(rs.getString("observacion_rechazo"));
                doc.setFechaSubida(rs.getTimestamp("fecha_subida"));
                lista.add(doc);
            }
        } finally { Conexion.close(rs); Conexion.close(stmt); Conexion.close(conn); }
        return lista;
    }

    public boolean subirDocumento(DocumentoRequisito doc) throws SQLException {
        Connection conn = null; PreparedStatement stmt = null;
        try {
            conn = Conexion.getConnection();
            // Upsert lógico: Si ya existe un doc de ese tipo, actualizarlo.
            String sqlCheck = "SELECT id_documento FROM documentos_requisito WHERE id_tramite = ? AND tipo_documento = ?";
            PreparedStatement check = conn.prepareStatement(sqlCheck);
            check.setInt(1, doc.getIdTramite());
            check.setString(2, doc.getTipoDocumento());
            ResultSet rs = check.executeQuery();
            
            if (rs.next()) {
                String sqlUpdate = "UPDATE documentos_requisito SET ruta_archivo = ?, estado_validacion = 'Pendiente', observacion_rechazo = NULL, fecha_subida = CURRENT_TIMESTAMP WHERE id_documento = ?";
                stmt = conn.prepareStatement(sqlUpdate);
                stmt.setString(1, doc.getRutaArchivo());
                stmt.setInt(2, rs.getInt("id_documento"));
            } else {
                String sqlInsert = "INSERT INTO documentos_requisito (id_tramite, tipo_documento, ruta_archivo, estado_validacion) VALUES (?, ?, ?, 'Pendiente')";
                stmt = conn.prepareStatement(sqlInsert);
                stmt.setInt(1, doc.getIdTramite());
                stmt.setString(2, doc.getTipoDocumento());
                stmt.setString(3, doc.getRutaArchivo());
            }
            return stmt.executeUpdate() > 0;
        } finally { Conexion.close(stmt); Conexion.close(conn); }
    }
    
    public boolean actualizarEstadoDocumento(int idDocumento, String estado, String observacion) throws SQLException {
        Connection conn = null; PreparedStatement stmt = null;
        try {
            conn = Conexion.getConnection();
            String sql = "UPDATE documentos_requisito SET estado_validacion = ?, observacion_rechazo = ? WHERE id_documento = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, estado);
            stmt.setString(2, observacion);
            stmt.setInt(3, idDocumento);
            return stmt.executeUpdate() > 0;
        } finally { Conexion.close(stmt); Conexion.close(conn); }
    }

    // ==========================================
    // SECCIÓN 3: NOTIFICACIONES
    // ==========================================

    public void crearNotificacion(Notificacion noti) throws SQLException {
        Connection conn = null; PreparedStatement stmt = null;
        try {
            conn = Conexion.getConnection();
            String sql = "INSERT INTO notificaciones (codigo_usuario_destino, mensaje, tipo) VALUES (?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, noti.getCodigoUsuarioDestino());
            stmt.setString(2, noti.getMensaje());
            stmt.setString(3, noti.getTipo());
            stmt.executeUpdate();
        } finally { Conexion.close(stmt); Conexion.close(conn); }
    }
    
    public List<Notificacion> getNotificacionesNoLeidas(String codigoUsuario) throws SQLException {
        List<Notificacion> lista = new ArrayList<>();
        Connection conn = null; PreparedStatement stmt = null; ResultSet rs = null;
        try {
            conn = Conexion.getConnection();
            String sql = "SELECT * FROM notificaciones WHERE codigo_usuario_destino = ? AND leido = FALSE ORDER BY fecha_envio DESC";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, codigoUsuario);
            rs = stmt.executeQuery();
            while(rs.next()) {
                Notificacion n = new Notificacion();
                n.setIdNotificacion(rs.getInt("id_notificacion"));
                n.setMensaje(rs.getString("mensaje"));
                n.setTipo(rs.getString("tipo"));
                n.setFechaEnvio(rs.getTimestamp("fecha_envio"));
                lista.add(n);
            }
        } finally { Conexion.close(rs); Conexion.close(stmt); Conexion.close(conn); }
        return lista;
    }

    // ==========================================
    // SECCIÓN 4: SUSTENTACIONES Y JURADOS
    // ==========================================

    public boolean guardarSustentacion(Sustentacion s) throws SQLException {
        Connection conn = null; PreparedStatement stmt = null;
        try {
            conn = Conexion.getConnection();
            String sqlCheck = "SELECT id_sustentacion FROM sustentaciones WHERE id_tramite = ?";
            PreparedStatement check = conn.prepareStatement(sqlCheck);
            check.setInt(1, s.getIdTramite());
            ResultSet rs = check.executeQuery();

            if (rs.next()) {
                String sqlUpdate = "UPDATE sustentaciones SET codigo_presidente=?, codigo_secretario=?, codigo_vocal=?, fecha_hora=?, lugar_enlace=? WHERE id_tramite=?";
                stmt = conn.prepareStatement(sqlUpdate);
                stmt.setString(1, s.getCodigoPresidente());
                stmt.setString(2, s.getCodigoSecretario());
                stmt.setString(3, s.getCodigoVocal());
                stmt.setTimestamp(4, s.getFechaHora());
                stmt.setString(5, s.getLugarEnlace());
                stmt.setInt(6, s.getIdTramite());
            } else {
                String sqlInsert = "INSERT INTO sustentaciones (id_tramite, codigo_presidente, codigo_secretario, codigo_vocal, fecha_hora, lugar_enlace, resultado_defensa) VALUES (?, ?, ?, ?, ?, ?, 'Pendiente')";
                stmt = conn.prepareStatement(sqlInsert);
                stmt.setInt(1, s.getIdTramite());
                stmt.setString(2, s.getCodigoPresidente());
                stmt.setString(3, s.getCodigoSecretario());
                stmt.setString(4, s.getCodigoVocal());
                stmt.setTimestamp(5, s.getFechaHora());
                stmt.setString(6, s.getLugarEnlace());
            }
            return stmt.executeUpdate() > 0;
        } finally { Conexion.close(stmt); Conexion.close(conn); }
    }

    public Sustentacion getSustentacionPorTramite(int idTramite) throws SQLException {
        Connection conn = null; PreparedStatement stmt = null; ResultSet rs = null;
        Sustentacion sus = null;
        try {
            conn = Conexion.getConnection();
            String sql = "SELECT s.*, " +
                         "CONCAT(p.nombres, ' ', p.apellidos) as nombre_p, " +
                         "CONCAT(sec.nombres, ' ', sec.apellidos) as nombre_s, " +
                         "CONCAT(v.nombres, ' ', v.apellidos) as nombre_v " +
                         "FROM sustentaciones s " +
                         "LEFT JOIN usuarios p ON s.codigo_presidente = p.codigo " +
                         "LEFT JOIN usuarios sec ON s.codigo_secretario = sec.codigo " +
                         "LEFT JOIN usuarios v ON s.codigo_vocal = v.codigo " +
                         "WHERE s.id_tramite = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idTramite);
            rs = stmt.executeQuery();
            if (rs.next()) {
                sus = new Sustentacion();
                sus.setIdSustentacion(rs.getInt("id_sustentacion"));
                sus.setIdTramite(rs.getInt("id_tramite"));
                sus.setCodigoPresidente(rs.getString("codigo_presidente"));
                sus.setNombrePresidente(rs.getString("nombre_p"));
                sus.setCodigoSecretario(rs.getString("codigo_secretario"));
                sus.setNombreSecretario(rs.getString("nombre_s"));
                sus.setCodigoVocal(rs.getString("codigo_vocal"));
                sus.setNombreVocal(rs.getString("nombre_v"));
                sus.setFechaHora(rs.getTimestamp("fecha_hora"));
                sus.setLugarEnlace(rs.getString("lugar_enlace"));
                sus.setResultadoDefensa(rs.getString("resultado_defensa"));
            }
        } finally { Conexion.close(rs); Conexion.close(stmt); Conexion.close(conn); }
        return sus;
    }
    
    public List<Usuario> listarDocentesSimple() throws SQLException {
        List<Usuario> lista = new ArrayList<>();
        Connection conn = null; PreparedStatement stmt = null; ResultSet rs = null;
        try {
            conn = Conexion.getConnection();
            String sql = "SELECT codigo, nombres, apellidos FROM usuarios WHERE rol = 'docente'";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            while (rs.next()) {
                Usuario u = new Usuario();
                u.setCodigo(rs.getString("codigo"));
                u.setNombres(rs.getString("nombres"));
                u.setApellidos(rs.getString("apellidos"));
                lista.add(u);
            }
        } finally { Conexion.close(rs); Conexion.close(stmt); Conexion.close(conn); }
        return lista;
    }

    // --- IMPORTANTE: MÉTODO PARA EL PANEL DEL DOCENTE ---
    public List<Sustentacion> getSustentacionesPorJurado(String codigoDocente) throws SQLException {
        List<Sustentacion> lista = new ArrayList<>();
        Connection conn = null; PreparedStatement stmt = null; ResultSet rs = null;
        try {
            conn = Conexion.getConnection();
            // Buscamos donde el docente sea Presidente, Secretario O Vocal
            String sql = "SELECT s.*, " +
                         "CONCAT(u.nombres, ' ', u.apellidos) as nombre_estudiante " +
                         // Eliminé el JOIN con 'tesis' para evitar que falle si el alumno no tiene tesis registrada en la tabla académica
                         "FROM sustentaciones s " +
                         "JOIN tramites tr ON s.id_tramite = tr.id_tramite " +
                         "JOIN usuarios u ON tr.codigo_estudiante = u.codigo " +
                         "WHERE s.codigo_presidente = ? OR s.codigo_secretario = ? OR s.codigo_vocal = ? " +
                         "ORDER BY s.fecha_hora DESC";
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, codigoDocente);
            stmt.setString(2, codigoDocente);
            stmt.setString(3, codigoDocente);
            
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Sustentacion sus = new Sustentacion();
                sus.setIdSustentacion(rs.getInt("id_sustentacion"));
                sus.setIdTramite(rs.getInt("id_tramite"));
                sus.setCodigoPresidente(rs.getString("codigo_presidente"));
                sus.setCodigoSecretario(rs.getString("codigo_secretario"));
                sus.setCodigoVocal(rs.getString("codigo_vocal"));
                sus.setFechaHora(rs.getTimestamp("fecha_hora"));
                sus.setLugarEnlace(rs.getString("lugar_enlace"));
                sus.setResultadoDefensa(rs.getString("resultado_defensa"));
                
                sus.setNombreEstudiante(rs.getString("nombre_estudiante"));
                // Título opcional o genérico si no hay join
                sus.setTituloTesis("Trámite de Titulación #" + rs.getInt("id_tramite")); 
                
                lista.add(sus);
            }
        } finally { Conexion.close(rs); Conexion.close(stmt); Conexion.close(conn); }
        return lista;
    }
}