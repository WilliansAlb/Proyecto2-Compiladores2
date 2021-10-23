/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package POJO;

import java.util.List;

/**
 *
 * @author willi
 */
public class Directorio {

    private boolean directorio;
    private String nombre;
    private List<Directorio> hijos;
    private String url;

    public Directorio() {
    }
    
    
    
    public Directorio(String nombre, List<Directorio> hijos, boolean directorio){
        this.nombre = nombre;
        this.hijos = hijos;
        this.directorio = directorio;
    }

    public String getNombre() {
        return this.nombre;
    }

    public boolean isDirectorio() {
        return directorio;
    }

    public void setDirectorio(boolean directorio) {
        this.directorio = directorio;
    }

    public List<Directorio> getHijos() {
        return hijos;
    }

    public void setHijos(List<Directorio> hijos) {
        this.hijos = hijos;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }
    
    
    
}
