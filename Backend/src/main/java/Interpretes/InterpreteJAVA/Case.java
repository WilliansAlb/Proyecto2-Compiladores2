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
public class Case implements Serializable{
    private Primitivo valor;
    private List<Instruccion> instrucciones;

    public Case(Primitivo valor, List<Instruccion> instrucciones) {
        this.valor = valor;
        this.instrucciones = instrucciones;
    }
}
