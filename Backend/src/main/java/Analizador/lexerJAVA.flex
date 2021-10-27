package Analizador;
import java_cup.runtime.Symbol;
%%
%class lexerJAVA
%type java_cup.runtime.Symbol
%cup
%unicode
%line
%column
%char
%public
D= [0-9]+
espacio=[ \r\t\n]+
DEC = [0-9]+\.[0-9]+
ID = [a-zA-Z$_][a-zA-Z0-9$_]*
%state STRING, COMENTARIO, BLOQUE_COMENTARIO, SALIDA
%{
    String str = "";
    private Symbol symbol(int type, Object value){
        return new Symbol(type, yyline, yycolumn, value);
    }
    private Symbol symbol(int type){
        return new Symbol(type, yyline, yycolumn, yytext());
    }
%}
%%
/*Palabras reservadas*/
<YYINITIAL> {
    ("if")                                  { return symbol(symJAVA.IF); }
    ("public")                              { return symbol(symJAVA.PUBLIC); }
    ("private")                             { return symbol(symJAVA.PRIVATE); }
    ("class")                               { return symbol(symJAVA.CLASE); }
    ("extends")                             { return symbol(symJAVA.EXTENDS); }
    ("int")                                 { return symbol(symJAVA.INT); }
    ("string")                              { return symbol(symJAVA.STRING); }
    ("boolean")                             { return symbol(symJAVA.BOOLEAN); }
    ("float")                               { return symbol(symJAVA.FLOAT); }
    ("char")                                { return symbol(symJAVA.CHAR); }
    ("void")                                { return symbol(symJAVA.VOID); }
    ("if")                                  { return symbol(symJAVA.IF); }
    ("else")                                { return symbol(symJAVA.ELSE); }
    ("for")                                 { return symbol(symJAVA.FOR); }
    ("switch")                              { return symbol(symJAVA.SWITCH); }
    ("case")                                { return symbol(symJAVA.CASE); }
    ("do")                                  { return symbol(symJAVA.DO); }
    ("while")                               { return symbol(symJAVA.WHILE); }
    ("continue")                            { return symbol(symJAVA.CONTINUE); }
    ("break")                               { return symbol(symJAVA.BREAK); }
    ("return")                              { return symbol(symJAVA.RETURN); }
    ("default")                             { return symbol(symJAVA.DEFAULT); }
    ("true"|"false")                        { return symbol(symJAVA.BOOLEANV); }
    ("!")                                   { return symbol(symJAVA.NOT); }
    ("!=")                                  { return symbol(symJAVA.DIFF); }
    (">")                                   { return symbol(symJAVA.MAYOR); }
    ("<")                                   { return symbol(symJAVA.MENOR); }
    (">=")                                  { return symbol(symJAVA.MAYOR_I); }
    ("<=")                                  { return symbol(symJAVA.MENOR_I); }
    ("!!")                                  { return symbol(symJAVA.NULO); }
    ("&&")                                  { return symbol(symJAVA.AND); }
    ("!&&")                                 { return symbol(symJAVA.NAND); }
    ("||")                                  { return symbol(symJAVA.OR); }
    ("!||")                                 { return symbol(symJAVA.NOR); }
    ("&|")                                  { return symbol(symJAVA.XOR); }
    ("=")                                   { return symbol(symJAVA.ASIGNAR); }
    ("==")                                  { return symbol(symJAVA.IGUAL); }
    ("+")                                   { return symbol(symJAVA.SUMA); }
    ("-")                                   { return symbol(symJAVA.RESTA); }
    ("*")                                   { return symbol(symJAVA.POR); }
    ("/")                                   { return symbol(symJAVA.ENTRE); }
    ("%")                                   { return symbol(symJAVA.MOD); }
    ("^")                                   { return symbol(symJAVA.POT); }
    ("+=")                                  { return symbol(symJAVA.SUMA_S); }
    ("--")                                  { return symbol(symJAVA.DEC); }
    ("++")                                  { return symbol(symJAVA.INC); }
    ("(")                                   { return symbol(symJAVA.PAR_A); }
    (")")                                   { return symbol(symJAVA.PAR_C); }
    (":")                                   { return symbol(symJAVA.DOS_P); }
    (",")                                   { return symbol(symJAVA.COMA); }
    ("{")                                   { return symbol(symJAVA.LLAVE_A); }
    ("}")                                   { return symbol(symJAVA.LLAVE_C); }
    (";")                                   { return symbol(symJAVA.PUNTOC); }
    {D}                                     { return symbol(symJAVA.INTV); }
    {DEC}                                   { return symbol(symJAVA.FLOATV); }
    {ID}                                    { return symbol(symJAVA.ID); }
    "\""                                    { str = ""; yybegin(STRING);}
    "/*"                                    { str = ""; yybegin(BLOQUE_COMENTARIO);}
    "//"                                    { str = ""; yybegin(COMENTARIO);}
    "'"."'"                                 { return symbol(symJAVA.CHARV);}
}

<STRING>{
    \"                              { yybegin(YYINITIAL); return symbol(symJAVA.STRINGV,str); }
    [^\"]+                          { str+=yytext(); }
}

<COMENTARIO>{
    \n                              { yybegin(YYINITIAL); /*return symbol(symJAVA.COMENTARIO,str);*/ }
    [^\n]+                          { str+=yytext(); }
}

<BLOQUE_COMENTARIO>{                
    "*"                             { yybegin(SALIDA); }
    [^"*"]+                         { str+=yytext(); }
}

<SALIDA>{
    '/'                             {
                                        yybegin(YYINITIAL);
                                        /*return symbol(symJAVA.BLOQUE_COMENTARIO,str);*/
                                    }
    [^'/']                          { 
                                        str+= "*"+yytext(); 
                                        yybegin(BLOQUE_COMENTARIO);
                                    } 
}

{espacio}           {/*Ignore*/}
[^]                                 { return new Symbol(symJAVA.ERRORLEX,yycolumn,yyline,yytext()); }

