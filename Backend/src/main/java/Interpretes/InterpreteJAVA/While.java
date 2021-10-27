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
public class While extends Instruccion implements Serializable{

    private Expresion condicion;
    private List<Instruccion> instrucciones;

    public While(Expresion condicion, List<Instruccion> instrucciones) {
        this.condicion = condicion;
        this.instrucciones = instrucciones;
    }
}
