package Modelos;

import java.sql.Timestamp;

public class Notificacion {
    private int idNotificacion;
    private String codigoUsuarioDestino; // <-- CAMBIO: String en lugar de int
    private String mensaje;
    private String tipo; 
    private boolean leido;
    private Timestamp fechaEnvio;

    public Notificacion() {}

    public int getIdNotificacion() { return idNotificacion; }
    public void setIdNotificacion(int idNotificacion) { this.idNotificacion = idNotificacion; }

    public String getCodigoUsuarioDestino() { return codigoUsuarioDestino; } // <-- CAMBIO
    public void setCodigoUsuarioDestino(String codigoUsuarioDestino) { this.codigoUsuarioDestino = codigoUsuarioDestino; } // <-- CAMBIO

    public String getMensaje() { return mensaje; }
    public void setMensaje(String mensaje) { this.mensaje = mensaje; }

    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }

    public boolean isLeido() { return leido; }
    public void setLeido(boolean leido) { this.leido = leido; }

    public Timestamp getFechaEnvio() { return fechaEnvio; }
    public void setFechaEnvio(Timestamp fechaEnvio) { this.fechaEnvio = fechaEnvio; }
}