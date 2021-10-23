/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package POJO;

/**
 *
 * @author willi
 */
public class Proyecto {
    private String nombre;
    private Directorio carpeta;

    public Proyecto(String nombre, Directorio carpeta) {
        this.nombre = nombre;
        this.carpeta = carpeta;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public Directorio getCarpeta() {
        return carpeta;
    }

    public void setCarpeta(Directorio carpeta) {
        this.carpeta = carpeta;
    }
    
    
}
