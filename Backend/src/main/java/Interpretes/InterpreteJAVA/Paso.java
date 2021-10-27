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
public class Paso extends Instruccion implements Serializable{

    public static enum TIPO {
        INCREMENTO,
        DECREMENTO,
        ASIGNACION,
        SIMPLIFICADA
    }
    public String id;
    public Expresion expresion;
    public TIPO tipo;

    public Paso(String id, Expresion expresion, TIPO tipo) {
        this.id = id;
        this.expresion = expresion;
        this.tipo = tipo;
    }
}
