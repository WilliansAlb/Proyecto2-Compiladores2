/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Interpretes.InterpreteJAVA;

import java.io.Serializable;
import java.util.LinkedList;
import java.util.List;

/**
 *
 * @author willi
 */
public class Declaracion extends Instruccion implements Serializable {

    List<String> ids;
    String tipo;
    String tipo_uso;
    Expresion dato;

    public Declaracion() {
        this.ids = new LinkedList<>();
        this.tipo = "";
        this.dato = null;
        this.tipo_uso = "";
    }

    public Declaracion(List<String> ids, String tipo, Expresion dato, String tipo_uso) {
        this.ids = ids;
        this.tipo = tipo;
        this.dato = dato;
        this.tipo_uso = tipo_uso;
    }

    public String codigo3D(Simbolos tabla) {
        String codigo = "";
        for (String strs : ids) {
            if (dato != null) {
                if (tipo.equalsIgnoreCase("int") || tipo.equalsIgnoreCase("boolean")) {
                    codigo += "stack[" + tabla.size() + "].intv = ";
                } else if (tipo.equalsIgnoreCase("char") || tipo.equalsIgnoreCase("string")) {
                    codigo += "stack[" + tabla.size() + "].charv = ";
                } else if (tipo.equalsIgnoreCase("float")) {
                    codigo += "stack[" + tabla.size() + "].floatv = ";
                }
                codigo+= dato.codigo3D(tabla)+" ;\n";
                tabla.codigo3D += codigo;
            }
            tabla.agregar(new Simbolo(strs, 1, tipo, tabla.size(), "Calculadora", "variable"));
        }
        return codigo;
    }
    
    public String codigo3D_1(Simbolos tabla, String ambito) {
        String codigo = "";
        for (String strs : ids) {
            if (dato != null) {
                if (tipo.equalsIgnoreCase("int") || tipo.equalsIgnoreCase("boolean")) {
                    codigo += "stack[" + tabla.posicion_memoria + "].intv = ";
                } else if (tipo.equalsIgnoreCase("char") || tipo.equalsIgnoreCase("string")) {
                    codigo += "stack[" + tabla.posicion_memoria + "].charv = ";
                } else if (tipo.equalsIgnoreCase("float")) {
                    codigo += "stack[" + tabla.posicion_memoria + "].floatv = ";
                }
                codigo+= dato.codigo3D(tabla)+" ;\n";
                tabla.codigo3D += codigo;
            }
            tabla.agregar(new Simbolo(strs, 1, tipo, tabla.size(), ambito, "variable"));
        }
        return codigo;
    }

}
