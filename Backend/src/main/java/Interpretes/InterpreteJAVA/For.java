/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Interpretes.InterpreteJAVA;

import java.io.Serializable;
import java.util.List;

/**
 *
 * @author willi
 */
public class For extends Instruccion implements Serializable{

    private Asigna asigna;
    private Expresion condicion;
    private Paso paso;
    private List<Instruccion> instrucciones;

    public For(Asigna asigna, Expresion condicion, Paso paso, List<Instruccion> instrucciones) {
        this.asigna = asigna;
        this.condicion = condicion;
        this.paso = paso;
        this.instrucciones = instrucciones;
    }

}
