package Servicios;

import Datos.TramitesDAO;
import Modelos.Notificacion;
import java.sql.SQLException;

public class NotificacionService {

    private TramitesDAO dao;

    public NotificacionService() {
        this.dao = new TramitesDAO();
    }

    // CAMBIO: Recibe String codigoUsuarioDestino
    public void notificarCambioEstado(String codigoUsuarioDestino, String nuevoEstado) {
        String mensaje = "Su trámite de titulación ha cambiado al estado: " + nuevoEstado;
        enviarNotificacionMulticanal(codigoUsuarioDestino, mensaje);
    }
    
    public void notificarDocumentoRecibido(String codigoUsuarioDestino, String tipoDoc) {
        String mensaje = "Hemos recibido su documento: " + tipoDoc + ". Está pendiente de validación.";
        enviarNotificacionMulticanal(codigoUsuarioDestino, mensaje);
    }

    private void enviarNotificacionMulticanal(String codigoUsuario, String mensaje) {
        try {
            // 1. Guardar notificación de sistema
            Notificacion notiWeb = new Notificacion();
            notiWeb.setCodigoUsuarioDestino(codigoUsuario); // <-- Set String
            notiWeb.setMensaje(mensaje);
            notiWeb.setTipo("Sistema");
            dao.crearNotificacion(notiWeb);

            // 2. Simulación EMAIL
            System.out.println("==================================================");
            System.out.println("[SIMULACIÓN EMAIL] Enviando a Usuario: " + codigoUsuario);
            System.out.println("Asunto: Actualización UPLA - Trámites");
            System.out.println("Cuerpo: " + mensaje);
            System.out.println("==================================================");
            
            // (Opcional) Log email
            Notificacion notiEmail = new Notificacion();
            notiEmail.setCodigoUsuarioDestino(codigoUsuario);
            notiEmail.setMensaje("Copia de correo enviado: " + mensaje);
            notiEmail.setTipo("Email_Simulado");
            dao.crearNotificacion(notiEmail);

            // 3. Simulación SMS
            System.out.println("[SIMULACIÓN SMS] +51 9********* : UPLA Informa: " + mensaje);

        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error al registrar notificaciones: " + e.getMessage());
        }
    }
}