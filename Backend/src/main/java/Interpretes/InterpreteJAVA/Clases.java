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
public class Clases implements Serializable {

    List<Clase> clases;

    public Clases() {
        this.clases = new LinkedList<>();
    }

    public Clases(List<Clase> clases) {
        this.clases = clases;
    }
    
    public void probar(){
        for (int i = 0; i < clases.size(); i++) {
            Simbolos nv = new Simbolos();
            Clase clen = clases.get(i);
            System.out.println(clen.codigo3D(nv));
        }
    }
    
}
