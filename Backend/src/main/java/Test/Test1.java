/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Test;

import Analizador.lexerJAVA;
import Analizador.parserJAVA;
import Interpretes.InterpreteJAVA.*;
import POJO.Archivo;
import com.google.gson.Gson;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.ArrayList;
import org.apache.commons.io.IOUtils;

/**
 *
 * @author willi
 */
public class Test1 {
    public static void main(String[] args) throws FileNotFoundException, IOException, Exception {
        File archivito = new File("C:/Users/willi/OneDrive/Escritorio/Proyectos a2021s6/Organizacion de Lenguajes y Compiladores/ProyectosIDE/Prueba/test.txt");
        parserJAVA n = new parserJAVA(new lexerJAVA(new FileReader(archivito)));
        
        n.parse();
        
        Clases ew = n.programa;
        ew.probar();
    }
    
    public static void crear(Clases ew){
    File archivo = new File("C:/Users/willi/OneDrive/Escritorio/Proyectos a2021s6/Organizacion de Lenguajes y Compiladores/Binario/clases.dat");
        try {
            // Para poder escribir utilizaremos un FileOutputStream pasandole
            // como referencia el archivo de tipo File.
            FileOutputStream fos = new FileOutputStream(archivo);

            // Y crearemos también una instancia del tipo ObjectOutputStream
            // al que le pasaremos por parámetro
            // el objeto de tipo FileOutputStream
            ObjectOutputStream escribir = new ObjectOutputStream(fos);

            // Escribimos los objetos en el archivo.
            escribir.writeObject(ew);
            // Cerramos los objetos para no consumir recursos.
            escribir.close();
            fos.close();
        } catch (Exception e) {
            System.out.println("Error al escribir en el archivo. "
                    + e.getMessage());
        }
    }
    
    public static Clases leer(){
        Clases ew = null;
        File archivo = new File("C:/Users/willi/OneDrive/Escritorio/Proyectos a2021s6/Organizacion de Lenguajes y Compiladores/Binario/clases.dat");
        try {
            // Para poder leer utilizaremos un FileInputStream pasandole
            // como referencia el archivo de tipo File.
            FileInputStream fis = new FileInputStream(archivo);
            // Declaramos una variable objeto del tipo ObjectInputStream
            ObjectInputStream leer;
            // Creamos un bucle para leer la información
            // Mientras haya bytes en el archivo.
            while (fis.available() > 0) {
                leer = new ObjectInputStream(fis);
                // En una variable objeto de tipo Persona almacenaremos
                // el objeto leido de tipo Object convertido en un objeto
                // de tipo persona
                ew = (Clases) leer.readObject();
            }

        } catch (Exception e) {
            System.out.println("Error al leer el archivo. "
                    + e.getMessage());
        }
        return ew;
    }
}
