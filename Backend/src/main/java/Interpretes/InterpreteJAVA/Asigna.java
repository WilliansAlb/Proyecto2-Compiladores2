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
public class Asigna implements Serializable{

    private String id;
    private Expresion inicializado;

    public Asigna(String id, Expresion inicializado) {
        this.id = id;
        this.inicializado = inicializado;
    }
}
