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
public class Expresion implements Serializable {

    public String retorna;
    private final String tipo;
    /**
     * Operador izquierdo de la operación.
     */
    private Expresion izquierda;
    /**
     * Operador derecho de la operación.
     */
    private Expresion derecha;
    /**
     * Valor específico si se tratara de una literal, es decir un número o una
     * cadena.
     */
    private Termino valor;

    /**
     * Constructor de la clase para operaciones binarias (con dos operadores),
     * estas operaciones son: SUMA, RESTA, MULTIPLICACION, DIVISION,
     * CONCATENACION, MAYOR_QUE, MENOR_QUE
     *
     * @param izquierda Operador izquierdo de la operación
     * @param derecha Opeardor derecho de la operación
     * @param tipo Tipo de la operación
     */
    public Expresion(Expresion izquierda, Expresion derecha, String tipo) {
        this.tipo = tipo;
        this.izquierda = izquierda;
        this.derecha = derecha;
    }

    /**
     * Constructor para operaciones unarias (un operador), estas operaciones
     * son: NEGATIVO NOT
     *
     * @param izquierda Único operador de la operación
     * @param tipo Tipo de operación
     */
    public Expresion(Expresion izquierda, String tipo) {
        this.tipo = tipo;
        this.izquierda = izquierda;
    }

    /**
     * Constructor para operaciones unarias (un operador), cuyo operador es
     * específicamente una cadena, estas operaciones son: IDENTIFICADOR, CADENA
     *
     * @param a Cadena que representa la operación a realizar
     * @param tipo Tipo de operación
     */
    public Expresion(Termino a, String tipo) {
        this.valor = a;
        this.tipo = tipo;
    }

    public String codigo3D(Simbolos tabla) {
        String codigo = "";
        if (tipo.equalsIgnoreCase("id")) {
            Identificador id = (Identificador) valor;
            String temporal = id.codigo3D(tabla);
            retorna = id.retorna;
            return temporal;
        } else if (tipo.equalsIgnoreCase("llamada")) {
            //por el momento nada
            return "";
        } else if (tipo.equalsIgnoreCase("valor")) {
            Primitivo id = (Primitivo) valor;
            if (id.getTipo().equalsIgnoreCase("string")) {
                codigo += " " + id.getValor().toString().charAt(0) + " ";
                retorna = "char";
            } else if (id.getTipo().equalsIgnoreCase("boolean")) {
                int temp = (id.getValor().toString().equalsIgnoreCase("true")) ? 1 : 0;
                codigo += " " + temp + " ";
                retorna = "int";
            } else {
                codigo += " " + id.getValor().toString() + " ";
                retorna = id.getTipo();
            }
            return codigo;
        } else {
            if (tipo.equalsIgnoreCase("menos")) {
                String r = izquierda.codigo3D(tabla);
                String tip = izquierda.retorna;
                if (tip.equalsIgnoreCase("int") || tip.equalsIgnoreCase("boolean")) {
                    tabla.codigo3D += "int t" + tabla.etiquetas + " = -"+r+";\n";
                    retorna = "int";
                } else if (tip.equalsIgnoreCase("char") || tip.equalsIgnoreCase("string")) {
                    tabla.codigo3D += "char t" + tabla.etiquetas + " = -"+r+";\n";
                    retorna = "char";
                } else if (tip.equalsIgnoreCase("float")) {
                    tabla.codigo3D += "float t" + tabla.etiquetas + " = -"+r+";\n";
                    retorna = "float";
                }
                String variable_retorno = "t"+tabla.etiquetas;
                tabla.etiquetas++;
                return variable_retorno;
            } else if (tipo.equalsIgnoreCase("!")) {
                String r = izquierda.codigo3D(tabla);
                String tip = izquierda.retorna;
                if (tip.equalsIgnoreCase("int") || tip.equalsIgnoreCase("boolean")) {
                    tabla.codigo3D += "int t" + tabla.etiquetas + " = !"+r+";\n";
                    retorna = "int";
                } else if (tip.equalsIgnoreCase("char") || tip.equalsIgnoreCase("string")) {
                    tabla.codigo3D += "char t" + tabla.etiquetas + " = !"+r+";\n";
                    retorna = "char";
                } else if (tip.equalsIgnoreCase("float")) {
                    tabla.codigo3D += "float t" + tabla.etiquetas + " = !"+r+";\n";
                    retorna = "float";
                }
                String variable_retorno = "t"+tabla.etiquetas;
                tabla.etiquetas++;
                return variable_retorno;
            } else {
                String codigo1 = izquierda.codigo3D(tabla);
                String codigo2 = derecha.codigo3D(tabla);
                String ti = "char";
                ti = (izquierda.retorna.equalsIgnoreCase("int")||derecha.retorna.equalsIgnoreCase("int"))?"int":ti;
                ti = (izquierda.retorna.equalsIgnoreCase("float")||derecha.retorna.equalsIgnoreCase("float"))?"float":ti;
                tabla.codigo3D += ti+" t"+tabla.etiquetas+" = " + codigo1 + " "+tipo+" "+codigo2+";\n";
                retorna = ti;
                String variable_retorno = "t"+tabla.etiquetas;
                tabla.etiquetas++;
                return variable_retorno;
            }
        }
    }

    public String codigo3D_1(Simbolos tabla) {
        String codigo = "";
        if (tipo.equalsIgnoreCase("id")) {
            Identificador id = (Identificador) valor;
            String temporal = id.codigo3D_1(tabla);
            retorna = id.retorna;
            return temporal;
        } else if (tipo.equalsIgnoreCase("llamada")) {
            //por el momento nada
            return "";
        } else if (tipo.equalsIgnoreCase("valor")) {
            Primitivo id = (Primitivo) valor;
            if (id.getTipo().equalsIgnoreCase("string")) {
                codigo += " " + id.getValor().toString().charAt(0) + " ";
                retorna = "char";
            } else if (id.getTipo().equalsIgnoreCase("boolean")) {
                int temp = (id.getValor().toString().equalsIgnoreCase("true")) ? 1 : 0;
                codigo += " " + temp + " ";
                retorna = "int";
            } else {
                codigo += " " + id.getValor().toString() + " ";
                retorna = id.getTipo();
            }
            return codigo;
        } else {
            if (tipo.equalsIgnoreCase("menos")) {
                String r = izquierda.codigo3D(tabla);
                String tip = izquierda.retorna;
                if (tip.equalsIgnoreCase("int") || tip.equalsIgnoreCase("boolean")) {
                    tabla.codigo3D += "int t" + tabla.etiquetas + " = -"+r+";\n";
                    retorna = "int";
                } else if (tip.equalsIgnoreCase("char") || tip.equalsIgnoreCase("string")) {
                    tabla.codigo3D += "char t" + tabla.etiquetas + " = -"+r+";\n";
                    retorna = "char";
                } else if (tip.equalsIgnoreCase("float")) {
                    tabla.codigo3D += "float t" + tabla.etiquetas + " = -"+r+";\n";
                    retorna = "float";
                }
                String variable_retorno = "t"+tabla.etiquetas;
                tabla.etiquetas++;
                return variable_retorno;
            } else if (tipo.equalsIgnoreCase("!")) {
                String r = izquierda.codigo3D(tabla);
                String tip = izquierda.retorna;
                if (tip.equalsIgnoreCase("int") || tip.equalsIgnoreCase("boolean")) {
                    tabla.codigo3D += "int t" + tabla.etiquetas + " = !"+r+";\n";
                    retorna = "int";
                } else if (tip.equalsIgnoreCase("char") || tip.equalsIgnoreCase("string")) {
                    tabla.codigo3D += "char t" + tabla.etiquetas + " = !"+r+";\n";
                    retorna = "char";
                } else if (tip.equalsIgnoreCase("float")) {
                    tabla.codigo3D += "float t" + tabla.etiquetas + " = !"+r+";\n";
                    retorna = "float";
                }
                String variable_retorno = "t"+tabla.etiquetas;
                tabla.etiquetas++;
                return variable_retorno;
            } else {
                String codigo1 = izquierda.codigo3D(tabla);
                String codigo2 = derecha.codigo3D(tabla);
                String ti = "char";
                ti = (izquierda.retorna.equalsIgnoreCase("int")||derecha.retorna.equalsIgnoreCase("int"))?"int":ti;
                ti = (izquierda.retorna.equalsIgnoreCase("float")||derecha.retorna.equalsIgnoreCase("float"))?"float":ti;
                tabla.codigo3D += ti+" t"+tabla.etiquetas+" = " + codigo1 + " "+tipo+" "+codigo2+";\n";
                retorna = ti;
                String variable_retorno = "t"+tabla.etiquetas;
                tabla.etiquetas++;
                return variable_retorno;
            }
        }
    }

    
    public String getRetorna() {
        return retorna;
    }

    public void setRetorna(String retorna) {
        this.retorna = retorna;
    }

    public Expresion getIzquierda() {
        return izquierda;
    }

    public void setIzquierda(Expresion izquierda) {
        this.izquierda = izquierda;
    }

    public Expresion getDerecha() {
        return derecha;
    }

    public void setDerecha(Expresion derecha) {
        this.derecha = derecha;
    }

    public Termino getValor() {
        return valor;
    }

    public void setValor(Termino valor) {
        this.valor = valor;
    }

}
