package Modelos;

/**
 * Representa la entidad 'usuarios' de la base de datos.
 * Es un Java Bean (o POJO) para transportar datos.
 */
public class Usuario {
    
    // Campos que coinciden con la tabla 'usuarios'
    private String codigo;
    private String nombres;
    private String apellidos;
    private String email;
    private String password;
    private String rol;

    // Constructor vacío
    public Usuario() {
    }

    // Constructor para el login (podemos añadir más)
    public Usuario(String codigo, String nombres, String apellidos, String email, String password, String rol) {
        this.codigo = codigo;
        this.nombres = nombres;
        this.apellidos = apellidos;
        this.email = email;
        this.password = password;
        this.rol = rol;
    }

    // --- Getters y Setters ---
    
    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public String getNombres() {
        return nombres;
    }

    public void setNombres(String nombres) {
        this.nombres = nombres;
    }

    public String getApellidos() {
        return apellidos;
    }

    public void setApellidos(String apellidos) {
        this.apellidos = apellidos;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRol() {
        return rol;
    }

    public void setRol(String rol) {
        this.rol = rol;
    }

    // (Opcional) Un getter para el nombre completo
    public String getNombreCompleto() {
        return nombres + " " + apellidos;
    }
}