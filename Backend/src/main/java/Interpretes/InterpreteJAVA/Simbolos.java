/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Interpretes.InterpreteJAVA;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

/**
 *
 * @author willi
 */
public class Simbolos extends LinkedList<Simbolo> implements Serializable {

    public String ambitos = "";
    public int etiquetas = 0;
    public int temporales = 0;
    public int puntero = 0;
    public int posicion_memoria = 0;
    public String codigo3D = "";

    /**
     * Constructor de la clase que lo único que hace es llamar al constructor de
     * la clase padre, es decir, el constructor de LinkedList.
     */
    public Simbolos() {
        super();
    }

    /**
     * Método que busca una variable en la tabla de símbolos y devuelve su
     * valor.
     *
     * @param id Identificador de la variable que quiere buscarse
     * @return Valor de la variable que se buscaba, si no existe se devuelve
     * nulo
     */
    public Object getTipo(String id) {
        for (Simbolo s : this) {
            if (s.getId().equals(id)) {
                return s.getTipo();
            }
        }
        System.out.println("La variable " + id + " no existe en este ámbito.");
        return "Desconocido";
    }
    
    public boolean agregarCodigo(String agregar){
        this.codigo3D += agregar;
        return true;
    }

    public Simbolo obtener(String id_buscar) {
        for (Simbolo s : this) {
            if (s.getId().equals(id_buscar)) {
                return s;
            }
        }
        return null;
    }

    public Simbolo obtener_retorno_actual() {
        for (Simbolo s : this) {
            if (s.getId().equals("$retorno")) {
                if (s.getAmbito() == ambitos) {
                    return s;
                }
            }
        }
        return null;
    }


    public void agregar(Simbolo simbolo) {
        boolean existe = false;
        for (Simbolo s : this) {
            if (s.getId().equals(simbolo.getId())) {
                existe = true;
            }
        }
        if (existe) {
            System.out.println("La variable con identificador " + simbolo.getId() + " ya está declarada");
        } else {
            System.out.println("Declarada " + simbolo.getId());
            this.add(simbolo);
        }
    }

    public boolean existe(String id) {
        for (Simbolo s : this) {
            if (s.getId().equals(id)) {
                return true;
            }
        }
        return false;
    }

    public Simbolo ultimo_retorno() {
        for (int i = this.size() - 1; i >= 0; i--) {
            if (this.get(i).getId().contains("$retorno")) {
                return this.get(i);
            }
        }
        return null;
    }
}
