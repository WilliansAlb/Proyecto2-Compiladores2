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
public class Metodo implements Serializable {
    String id;
    String tipo;
    List<Parametro> parametros;
    List<Instruccion> instrucciones;
    String tipo_uso;
    boolean constructor;
    Object objeto_retorno;
    String tipo_retorno;

    public Metodo(String tipo, String id, List<Parametro> parametros, List<Instruccion> instrucciones, boolean constructor, String tipo_uso) {
        this.id = id;
        this.tipo = tipo;
        this.parametros = parametros;
        this.instrucciones = instrucciones;
        this.constructor = constructor;
        this.tipo_uso = tipo_uso;
    }

    public Metodo() {

    }
    
    public String codigo3D(Simbolos tab, String clase){
        for (int i = 0; i < parametros.size(); i++) {
            tab.add(new Simbolo(clase+"."+parametros.get(i).getId(),1,parametros.get(i).getTipo(),i,clase,"parametro"));
        }
        for (Instruccion instruccion : instrucciones) {
        }
        return "";
    }
}
