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
public class CB  extends Instruccion implements Serializable{
    private boolean continuar;

    public CB(boolean continuar) {
        this.continuar = continuar;
    }

    public CB() {
        
    }
}
