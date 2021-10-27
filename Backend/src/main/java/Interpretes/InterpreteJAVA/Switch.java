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
public class Switch extends Instruccion implements Serializable {

    private String id;
    private List<Case> casos;
    private List<Instruccion> defecto;

    public Switch(String id, List<Case> casos, List<Instruccion> defecto) {
        this.id = id;
        this.casos = casos;
        this.defecto = defecto;
    }
    
    public String volver3D(Simbolos tabla){
        Identificador nes = new Identificador(id);
        
        return "";
    }
}