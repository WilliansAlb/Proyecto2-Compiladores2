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
public class Primitivo extends Termino implements Serializable{
    private String tipo;
    private int linea;
    private int columna;
    private Object valor;

    public Primitivo(String tipo, int linea, int columna, Object valor) {
        this.tipo = tipo;
        this.linea = linea;
        this.columna = columna;
        this.valor = valor;
    }

    @Override
    public String getTipo() {
        return this.tipo;
    }

    public int getLinea() {
        return linea;
    }

    public void setLinea(int linea) {
        this.linea = linea;
    }

    public int getColumna() {
        return columna;
    }

    public void setColumna(int columna) {
        this.columna = columna;
    }

    public Object getValor() {
        return valor;
    }

    public void setValor(Object valor) {
        this.valor = valor;
    }
    
    
}
