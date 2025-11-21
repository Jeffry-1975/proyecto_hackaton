package Modelos;

import java.sql.Timestamp;

/**
 * Representa la entidad 'tesis' de la base de datos.
 */
public class Tesis {

    private int idTesis;
    private String titulo;
    private String codigoEstudiante;
    private String codigoDocenteRevisor;
    private String estado;
    private Timestamp fechaSubida;
    private String nombreDocenteRevisor;
    private String nombreEstudiante;
    private String archivoPath;
    
    
    // Constructor vacío
    public Tesis() {
    }

    // --- Getters y Setters ---

    public int getIdTesis() {
        return idTesis;
    }

    public void setIdTesis(int idTesis) {
        this.idTesis = idTesis;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getCodigoEstudiante() {
        return codigoEstudiante;
    }

    public void setCodigoEstudiante(String codigoEstudiante) {
        this.codigoEstudiante = codigoEstudiante;
    }

    public String getCodigoDocenteRevisor() {
        return codigoDocenteRevisor;
    }

    public void setCodigoDocenteRevisor(String codigoDocenteRevisor) {
        this.codigoDocenteRevisor = codigoDocenteRevisor;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getArchivoPath() {
        return archivoPath;
    }

    public void setArchivoPath(String archivoPath) {
        this.archivoPath = archivoPath;
    }

    public Timestamp getFechaSubida() {
        return fechaSubida;
    }

    public void setFechaSubida(Timestamp fechaSubida) {
        this.fechaSubida = fechaSubida;
    }

    public String getNombreDocenteRevisor() {
        return nombreDocenteRevisor;
    }

    public void setNombreDocenteRevisor(String nombreDocenteRevisor) {
        this.nombreDocenteRevisor = nombreDocenteRevisor;
    }
    
    public String getNombreEstudiante() {
        return nombreEstudiante;
    }

    public void setNombreEstudiante(String nombreEstudiante) {
        this.nombreEstudiante = nombreEstudiante;
    }
}