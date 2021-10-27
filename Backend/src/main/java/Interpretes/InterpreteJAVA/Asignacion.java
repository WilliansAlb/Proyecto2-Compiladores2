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
public class Asignacion extends Instruccion implements Serializable {
    String id;
    Expresion expresion;

    public Asignacion(String id, Expresion expresion) {
        this.id = id;
        this.expresion = expresion;
    }
}
