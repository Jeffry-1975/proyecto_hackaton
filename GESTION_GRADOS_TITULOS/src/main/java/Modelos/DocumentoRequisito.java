package Modelos;

import java.sql.Timestamp;

public class DocumentoRequisito {
    private int idDocumento;
    private int idTramite;
    private String tipoDocumento;
    private String rutaArchivo;
    private String estadoValidacion; // Pendiente, Validado, Rechazado
    private String observacionRechazo;
    private Timestamp fechaSubida;

    public DocumentoRequisito() {}

    public int getIdDocumento() { return idDocumento; }
    public void setIdDocumento(int idDocumento) { this.idDocumento = idDocumento; }

    public int getIdTramite() { return idTramite; }
    public void setIdTramite(int idTramite) { this.idTramite = idTramite; }

    public String getTipoDocumento() { return tipoDocumento; }
    public void setTipoDocumento(String tipoDocumento) { this.tipoDocumento = tipoDocumento; }

    public String getRutaArchivo() { return rutaArchivo; }
    public void setRutaArchivo(String rutaArchivo) { this.rutaArchivo = rutaArchivo; }

    public String getEstadoValidacion() { return estadoValidacion; }
    public void setEstadoValidacion(String estadoValidacion) { this.estadoValidacion = estadoValidacion; }

    public String getObservacionRechazo() { return observacionRechazo; }
    public void setObservacionRechazo(String observacionRechazo) { this.observacionRechazo = observacionRechazo; }

    public Timestamp getFechaSubida() { return fechaSubida; }
    public void setFechaSubida(Timestamp fechaSubida) { this.fechaSubida = fechaSubida; }
}