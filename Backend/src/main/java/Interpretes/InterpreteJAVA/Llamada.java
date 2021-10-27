/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Interpretes.InterpreteJAVA;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;

/**
 *
 * @author willi
 */
public class Llamada extends Instruccion implements Serializable {

    private String id;
    private List<Expresion> parametros;
    public Object retorno;
    public String retorno_tipo;
    public boolean existe = true;

    public Llamada(String id, List<Expresion> parametros) {
        this.id = id;
        this.parametros = parametros;
    }

}