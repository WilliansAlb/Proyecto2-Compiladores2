/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Servlets;

import POJO.Archivo;
import com.google.gson.Gson;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.io.IOUtils;

/**
 *
 * @author willi
 */
public class Texto extends HttpServlet {

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
            out.println("<title>Servlet Texto</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Texto at " + request.getContextPath() + "</h1>");
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
        File archivoPrueba = new File("C:/Users/willi/OneDrive/Escritorio/Proyectos a2021s6/Organizacion de Lenguajes y Compiladores/ProyectosIDE/Prueba/ArchivoPrueba.txt");
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        String todo = "";
        try (FileInputStream inputStream = new FileInputStream("C:/Users/willi/OneDrive/Escritorio/Proyectos a2021s6/Organizacion de Lenguajes y Compiladores/ProyectosIDE/Prueba/ArchivoPrueba.txt")) {
            todo = IOUtils.toString(inputStream);
            Gson gson = new Gson();
            Archivo ar = new Archivo(todo);
            String json = gson.toJson(ar);
            response.getWriter().write(json);
        }
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
