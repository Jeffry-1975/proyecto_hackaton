package Modelos;

import java.sql.Timestamp;

public class Sustentacion {
    private int idSustentacion;
    private int idTramite;
    
    // Códigos de los docentes
    private String codigoPresidente;
    private String codigoSecretario;
    private String codigoVocal;
    
    private Timestamp fechaHora;
    private String lugarEnlace;
    private double notaFinal;
    private String resultadoDefensa; // 'Pendiente', 'Aprobado', 'Desaprobado'
    private String observaciones;
    
    // --- Campos Auxiliares para Visualización (No están en la tabla sustentaciones) ---
    private String nombrePresidente;
    private String nombreSecretario;
    private String nombreVocal;
    
    // Datos del Estudiante/Tesis (Útil para la vista de "Soy Jurado")
    private String nombreEstudiante;
    private String tituloTesis;

    public Sustentacion() {}

    // --- Getters y Setters ---

    public int getIdSustentacion() { return idSustentacion; }
    public void setIdSustentacion(int idSustentacion) { this.idSustentacion = idSustentacion; }

    public int getIdTramite() { return idTramite; }
    public void setIdTramite(int idTramite) { this.idTramite = idTramite; }

    public String getCodigoPresidente() { return codigoPresidente; }
    public void setCodigoPresidente(String codigoPresidente) { this.codigoPresidente = codigoPresidente; }

    public String getCodigoSecretario() { return codigoSecretario; }
    public void setCodigoSecretario(String codigoSecretario) { this.codigoSecretario = codigoSecretario; }

    public String getCodigoVocal() { return codigoVocal; }
    public void setCodigoVocal(String codigoVocal) { this.codigoVocal = codigoVocal; }

    public Timestamp getFechaHora() { return fechaHora; }
    public void setFechaHora(Timestamp fechaHora) { this.fechaHora = fechaHora; }

    public String getLugarEnlace() { return lugarEnlace; }
    public void setLugarEnlace(String lugarEnlace) { this.lugarEnlace = lugarEnlace; }

    public double getNotaFinal() { return notaFinal; }
    public void setNotaFinal(double notaFinal) { this.notaFinal = notaFinal; }

    public String getResultadoDefensa() { return resultadoDefensa; }
    public void setResultadoDefensa(String resultadoDefensa) { this.resultadoDefensa = resultadoDefensa; }

    public String getObservaciones() { return observaciones; }
    public void setObservaciones(String observaciones) { this.observaciones = observaciones; }

    // --- Getters y Setters Auxiliares ---

    public String getNombrePresidente() { return nombrePresidente; }
    public void setNombrePresidente(String nombrePresidente) { this.nombrePresidente = nombrePresidente; }

    public String getNombreSecretario() { return nombreSecretario; }
    public void setNombreSecretario(String nombreSecretario) { this.nombreSecretario = nombreSecretario; }

    public String getNombreVocal() { return nombreVocal; }
    public void setNombreVocal(String nombreVocal) { this.nombreVocal = nombreVocal; }

    public String getNombreEstudiante() { return nombreEstudiante; }
    public void setNombreEstudiante(String nombreEstudiante) { this.nombreEstudiante = nombreEstudiante; }

    public String getTituloTesis() { return tituloTesis; }
    public void setTituloTesis(String tituloTesis) { this.tituloTesis = tituloTesis; }
}