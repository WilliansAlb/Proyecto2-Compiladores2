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
public class Identificador extends Termino implements Serializable {

    private String id;
    public String retorna;

    public Identificador(String id) {
        this.id = id;
    }

    @Override
    public String getTipo() {
        return "id";
    }

    public String codigo3D(Simbolos tabla) {
        Simbolo s = tabla.obtener(id);
        if (s.getTipo().equalsIgnoreCase("int") || s.getTipo().equalsIgnoreCase("boolean")) {
            tabla.codigo3D += "int t"+tabla.etiquetas+" = stack[" + s.getPosicion() + "].intv;\n";
            retorna = "int";
        } else if (s.getTipo().equalsIgnoreCase("char") || s.getTipo().equalsIgnoreCase("string")) {
            tabla.codigo3D += "char t"+tabla.etiquetas+" = stack[" + s.getPosicion() + "].charv;\n";
            retorna = "char";
        } else if (s.getTipo().equalsIgnoreCase("float")) {
            tabla.codigo3D += "float t"+tabla.etiquetas+" = stack[" + s.getPosicion() + "].floatv;\n";
            retorna = "float";
        }
        String variable_retorno = "t"+tabla.etiquetas;
        tabla.etiquetas++;
        return variable_retorno;
    }
    
    public String codigo3D_1(Simbolos tabla) {
        Simbolo s = tabla.obtener(id);
        if (s.getTipo().equalsIgnoreCase("int") || s.getTipo().equalsIgnoreCase("boolean")) {
            tabla.codigo3D += "int t"+tabla.etiquetas+" = stack[" + s.getPosicion() + "].intv;\n";
            retorna = "int";
        } else if (s.getTipo().equalsIgnoreCase("char") || s.getTipo().equalsIgnoreCase("string")) {
            tabla.codigo3D += "char t"+tabla.etiquetas+" = stack[" + s.getPosicion() + "].charv;\n";
            retorna = "char";
        } else if (s.getTipo().equalsIgnoreCase("float")) {
            tabla.codigo3D += "float t"+tabla.etiquetas+" = stack[" + s.getPosicion() + "].floatv;\n";
            retorna = "float";
        }
        String variable_retorno = "t"+tabla.etiquetas;
        tabla.etiquetas++;
        return variable_retorno;
    }
}
