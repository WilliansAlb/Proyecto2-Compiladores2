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
public class If extends Instruccion implements Serializable {
    Expresion condicion;
    List<Instruccion> instrucciones;
    List<Instruccion> sino;
    If sinosi;

    public If(Expresion condicion, List<Instruccion> instrucciones, List<Instruccion> sino, If sinosi) {
        this.condicion = condicion;
        this.instrucciones = instrucciones;
        this.sino = sino;
        this.sinosi = sinosi;
    }
    
    public String codigo3D(Simbolos tabla){
        
        return "";
    }
}
