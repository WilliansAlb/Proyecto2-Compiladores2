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
public class Clase implements Serializable {
    List<Metodo> metodos;
    List<Declaracion> declaraciones;
    List<String> extiende;
    String id;
    Simbolos tab;

    public Clase(List<Metodo> metodos, List<Declaracion> declaraciones, List<String> extiende, String id) {
        this.metodos = metodos;
        this.declaraciones = declaraciones;
        this.extiende = extiende;
        this.id = id;
    }
    
    public String codigo3D(Simbolos tabla){
        for (int i = 0; i < declaraciones.size(); i++) {
            Declaracion dc = declaraciones.get(i);
            String s = dc.codigo3D(tabla);
        }
        
        for (int i = 0; i < metodos.size(); i++) {
            Metodo m = metodos.get(i);
            
        }
        
        System.out.println(tabla.codigo3D);
        return "";
    }
    
    public String codigo3D_1(){
        tab = new Simbolos();
        int cantidad = declaraciones.size()+metodos.size();
        tab.agregar(new Simbolo(id,cantidad,"clase",-1,"global","clase"));
        tab.agregar(new Simbolo("this",1,"",0,id,"variable"));
        tab.posicion_memoria++;
        for (int i = 0; i < declaraciones.size(); i++) {
            Declaracion dc = declaraciones.get(i);
            String s = dc.codigo3D_1(tab,id);
        }
        
        for (int i = 0; i < metodos.size(); i++) {
            Metodo m = metodos.get(i);
            tab.agregar(new Simbolo(id+"."+m.id,tab.posicion_memoria,m.tipo,-1,id,"metodo"));
            String s2 = m.codigo3D(tab, id);
        }
        
        System.out.println(tab.codigo3D);
        return "";
    }
}
