/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Servlets;

import POJO.Archivo;
import POJO.Directorio;
import com.google.gson.Gson;
import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.io.IOUtils;

/**
 *
 * @author willi
 */
public class Paquetes extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet Paquetes</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Paquetes at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        File dir = new File("C:/Users/willi/OneDrive/Escritorio/Proyectos a2021s6/Organizacion de Lenguajes y Compiladores/ProyectosIDE");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        String existe = request.getParameter("existe");
        if (existe != null) {
            if (existe.equalsIgnoreCase("true")) {
                System.out.println(dir.isDirectory() + "es directorio");
                /*if (archivos == null || archivos.length == 0) {
                    response.getWriter().write("no hay archivos");
                } else {
                    String todos = "";
                    for (int i = 0; i < archivos.length; i++) {
                        File archivo = archivos[i];
                        todos += archivo.getName() + " directorio " + archivo.isDirectory();
                    }
                    obtener(archivos);
                    response.getWriter().write(todos);
                }*/
                Gson gson = new Gson();
                String json = gson.toJson(obtener(dir));
                System.out.println(json);
                response.getWriter().write(json);
                //response.getWriter().write("{\"respuesta\":\"NOHAY\"}");
            } else {
                response.getWriter().write("{\"respuesta\":\"NOHAY\"}");
            }
        } else {
            response.getWriter().write("{\"respuesta\":\"ERROR\"}");
        }
    }

    public Directorio obtener(File archivos) {
        Directorio nuevo = new Directorio();
        nuevo.setNombre(archivos.getName());
        nuevo.setDirectorio(archivos.isDirectory());
        List<Directorio> lis = new ArrayList<>();
        String pa = archivos.getPath().replace('\\', '/');
        String cortar = "C:/Users/willi/OneDrive/Escritorio/Proyectos a2021s6/Organizacion de Lenguajes y Compiladores/";
        nuevo.setUrl(pa.substring(cortar.length(), pa.length()));
        if (archivos.isDirectory()) {
            File[] archs = archivos.listFiles();
            if (archs == null || archs.length == 0) {
                //no hace nada
            } else {
                for (int i = 0; i < archs.length; i++) {
                    File ar = archs[i];
                    lis.add(obtener(ar));
                }
                nuevo.setHijos(lis);
            }
        }
        return nuevo;
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
