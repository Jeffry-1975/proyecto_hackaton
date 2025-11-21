package Modelos;

import java.sql.Timestamp;

/**
 * Representa la entidad 'evaluaciones' de la base de datos, 
 * AHORA BASADA EN LA RÚBRICA DE 38 ÍTEMS.
 */
public class Evaluacion {

    private int idEvaluacion;
    private int idTesis;
    private String codigoDocente;
    private String comentarios;
    private Timestamp fechaEvaluacion;
    
    // --- Campos de la Rúbrica (38 ítems) ---
    private double item1, item2, item3, item4, item5, item6, item7, item8, item9, item10;
    private double item11, item12, item13, item14, item15, item16, item17, item18, item19, item20;
    private double item21, item22, item23, item24, item25, item26, item27, item28, item29, item30;
    private double item31, item32, item33, item34, item35, item36, item37, item38;
    
    // --- Resultados Calculados ---
    private double puntajeTotal;
    private String condicion; // "Aprobado", "Aprobado con observaciones menores", "Desaprobado con observaciones mayores"

    // --- Campos Adicionales (para joins en reportes/historial) ---
    private String tituloTesis;
    private String nombreEstudiante;

    // Constructor vacío
    public Evaluacion() {
    }

    // --- Getters y Setters ---

    public int getIdEvaluacion() {
        return idEvaluacion;
    }

    public void setIdEvaluacion(int idEvaluacion) {
        this.idEvaluacion = idEvaluacion;
    }

    public int getIdTesis() {
        return idTesis;
    }

    public void setIdTesis(int idTesis) {
        this.idTesis = idTesis;
    }

    public String getCodigoDocente() {
        return codigoDocente;
    }

    public void setCodigoDocente(String codigoDocente) {
        this.codigoDocente = codigoDocente;
    }

    public String getComentarios() {
        return comentarios;
    }

    public void setComentarios(String comentarios) {
        this.comentarios = comentarios;
    }

    public Timestamp getFechaEvaluacion() {
        return fechaEvaluacion;
    }

    public void setFechaEvaluacion(Timestamp fechaEvaluacion) {
        this.fechaEvaluacion = fechaEvaluacion;
    }
    
    // --- Getters y Setters para los 38 Items ---
    // (Este es un ejemplo, se repite para los 38)
    
    public double getItem1() { return item1; }
    public void setItem1(double item1) { this.item1 = item1; }
    public double getItem2() { return item2; }
    public void setItem2(double item2) { this.item2 = item2; }
    public double getItem3() { return item3; }
    public void setItem3(double item3) { this.item3 = item3; }
    public double getItem4() { return item4; }
    public void setItem4(double item4) { this.item4 = item4; }
    public double getItem5() { return item5; }
    public void setItem5(double item5) { this.item5 = item5; }
    public double getItem6() { return item6; }
    public void setItem6(double item6) { this.item6 = item6; }
    public double getItem7() { return item7; }
    public void setItem7(double item7) { this.item7 = item7; }
    public double getItem8() { return item8; }
    public void setItem8(double item8) { this.item8 = item8; }
    public double getItem9() { return item9; }
    public void setItem9(double item9) { this.item9 = item9; }
    public double getItem10() { return item10; }
    public void setItem10(double item10) { this.item10 = item10; }
    public double getItem11() { return item11; }
    public void setItem11(double item11) { this.item11 = item11; }
    public double getItem12() { return item12; }
    public void setItem12(double item12) { this.item12 = item12; }
    public double getItem13() { return item13; }
    public void setItem13(double item13) { this.item13 = item13; }
    public double getItem14() { return item14; }
    public void setItem14(double item14) { this.item14 = item14; }
    public double getItem15() { return item15; }
    public void setItem15(double item15) { this.item15 = item15; }
    public double getItem16() { return item16; }
    public void setItem16(double item16) { this.item16 = item16; }
    public double getItem17() { return item17; }
    public void setItem17(double item17) { this.item17 = item17; }
    public double getItem18() { return item18; }
    public void setItem18(double item18) { this.item18 = item18; }
    public double getItem19() { return item19; }
    public void setItem19(double item19) { this.item19 = item19; }
    public double getItem20() { return item20; }
    public void setItem20(double item20) { this.item20 = item20; }
    public double getItem21() { return item21; }
    public void setItem21(double item21) { this.item21 = item21; }
    public double getItem22() { return item22; }
    public void setItem22(double item22) { this.item22 = item22; }
    public double getItem23() { return item23; }
    public void setItem23(double item23) { this.item23 = item23; }
    public double getItem24() { return item24; }
    public void setItem24(double item24) { this.item24 = item24; }
    public double getItem25() { return item25; }
    public void setItem25(double item25) { this.item25 = item25; }
    public double getItem26() { return item26; }
    public void setItem26(double item26) { this.item26 = item26; }
    public double getItem27() { return item27; }
    public void setItem27(double item27) { this.item27 = item27; }
    public double getItem28() { return item28; }
    public void setItem28(double item28) { this.item28 = item28; }
    public double getItem29() { return item29; }
    public void setItem29(double item29) { this.item29 = item29; }
    public double getItem30() { return item30; }
    public void setItem30(double item30) { this.item30 = item30; }
    public double getItem31() { return item31; }
    public void setItem31(double item31) { this.item31 = item31; }
    public double getItem32() { return item32; }
    public void setItem32(double item32) { this.item32 = item32; }
    public double getItem33() { return item33; }
    public void setItem33(double item33) { this.item33 = item33; }
    public double getItem34() { return item34; }
    public void setItem34(double item34) { this.item34 = item34; }
    public double getItem35() { return item35; }
    public void setItem35(double item35) { this.item35 = item35; }
    public double getItem36() { return item36; }
    public void setItem36(double item36) { this.item36 = item36; }
    public double getItem37() { return item37; }
    public void setItem37(double item37) { this.item37 = item37; }
    public double getItem38() { return item38; }
    public void setItem38(double item38) { this.item38 = item38; }

    // --- Getters y Setters para Resultados ---

    public double getPuntajeTotal() {
        return puntajeTotal;
    }

    public void setPuntajeTotal(double puntajeTotal) {
        this.puntajeTotal = puntajeTotal;
    }

    public String getCondicion() {
        return condicion;
    }

    public void setCondicion(String condicion) {
        this.condicion = condicion;
    }
    
    // --- Getters y Setters para Campos Adicionales ---

    public String getTituloTesis() {
        return tituloTesis;
    }

    public void setTituloTesis(String tituloTesis) {
        this.tituloTesis = tituloTesis;
    }

    public String getNombreEstudiante() {
        return nombreEstudiante;
    }

    public void setNombreEstudiante(String nombreEstudiante) {
        this.nombreEstudiante = nombreEstudiante;
    }
    
    // --- MÉTODOS REEMPLAZADOS ---
    // (Estos métodos están ahora obsoletos y se han eliminado 
    // para ser reemplazados por los 38 items)
    /*
    public String getCriterioMetodologia() { return null; }
    public void setCriterioMetodologia(String s) { }
    public String getCriterioMarcoTeorico() { return null; }
    public void setCriterioMarcoTeorico(String s) { }
    public String getCriterioResultados() { return null; }
    public void setCriterioResultados(String s) { }
    public String getCriterioFormato() { return null; }
    public void setCriterioFormato(String s) { }
    public String getDecisionFinal() { return null; }
    public void setDecisionFinal(String s) { }
    */
}