/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Interpretes.InterpreteJAVA;

import java.io.Serializable;

/**
 *
 * @author willi
 */
public class Retorno extends Termino implements Serializable {
    private Llamada llamada;
    private final String tipo = "llamada";

    public Retorno(Llamada llamada) {
        this.llamada = llamada;
    }

    @Override
    public String getTipo() {
        return this.tipo; //To change body of generated methods, choose Tools | Templates.
    }
}
