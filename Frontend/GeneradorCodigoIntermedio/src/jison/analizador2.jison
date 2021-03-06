%{ var indents = [0], indent = 0, indent_actual = 0, dedents = 0, val_actual = "" %}
%lex
reserved                                {keywords}|{operators}
keywords                                "continue"|"finally"|"return"|"global"|
                                        "assert"|"except"|"import"|"lambda"|
                                        "raise"|"class"|"print"|"break"|"while"|
                                        "yield"|"from"|"elif"|"else"|"with"|
                                        "pass"|"exec"|"and"|"del"|"not"|"def"|
                                        "for"|"try"|"as"|"or"|"if"|"input"|"in"|"is"|"range"|"true"|"false"
reservadas                              "public" | "private" | "class" | "extends" | "intinput" | "floatinput" | "charinput" | "int" |
                                        "String" | "char" | "float" | "boolean" | "true" | "false" |
                                        "else" | "while" | "for" | "do" | "break" | "continue" |
                                        "return" | "(" | ")" | "{" | "}" | "," | ":" | ";" | 
                                        "," | "void" | "case" | "switch" | "default" | "println"| "print" 
operators                               ">>="|"<<="|"**="|"//="|"+="|"-="|"*="|
                                        "/="|"%="|"&="|"|="|"^="|"**"|"//"|"<<"|
                                        ">>"|"<="|">="|"=="|"!="|"<>"|"+"|"-"|
                                        "*"|"/"|"%"|"&"|"|"|"^"|"~"|"<"|">"|"("|
                                        ")"|"["|"]"|"{"|"}"|"@"|","|":"|"."|"`"|
                                        "="|";"|"'"|"""|"#"|"\"          
/** identifiers **/
identifier                              ("_"|{letter})({letter}|{digit}|"_")*
url                                     {identifier}('.'{identifier})?
letter                                  {lowercase}|{uppercase}
lowercase                               [a-z]
uppercase                               [A-Z]
digit                                   ([0]|[1-9][0-9]*)
apertura_python                         "%%PYTHON"
apertura_java                           "%%JAVA"

/** strings **/
longstring                              {longstring_double}|{longstring_single}
longstring_double                       '"""'{longstringitem}*'"""'
longstring_single                       "'''"{longstringitem}*"'''"
longstringitem                          {longstringchar}|{escapeseq}
longstringchar                          [^\\]

shortstring                             {shortstring_double}|{shortstring_single}
shortstring_double                      '"'{shortstringitem_double}*'"'
shortstring_single                      "'"{shortstringitem_single}*"'"
shortstringitem_double                  {shortstringchar_double}|{escapeseq}
shortstringitem_single                  {shortstringchar_single}|{escapeseq}
shortstringchar_single                  [^\\\n\']
shortstringchar_double                  [^\\\n\"]
escapeseq                               \\.

/** floats **/
float                                   ([0]|[1-9][0-9]*)("."[0-9]+)

/** reserved **/                            

%s INITIAL PYTHON DEDENT INDENT JAVA PROGRAMA COMENTARIO BLOQUE_COMENTARIO

%%
<INITIAL>[\ \n\r]+                        %{ console.log("eninicio"); %}
<INITIAL>[\t]                           %{ console.log("tabulacion"); %}
<INITIAL>'paquete'                      %{ return 'PAQUETE'; %}
<INITIAL>{url}                          %{ return 'URL'; %}
<INITIAL>{apertura_python}              %{ this.begin("PYTHON"); return 'PYTHON'; %}
<PYTHON>[\ ]+                           %{ /*espacios en blanco*/ %}
<PYTHON>\t                              %{ /*tabulacion*/ %}
<PYTHON>(\r?\n)+                     	%{ indent_actual = 0; this.begin("INDENT"); return 'SALTO'; %}
<PYTHON>{apertura_java}                 %{ this.begin("JAVA"); return 'JAVA' %}
<PYTHON>'if'                              %{ return 'IF'; %}
<PYTHON>'else'                            %{ return 'ELSE'; %}
<PYTHON>'elif'                          %{ return 'ELIF'; %}
<PYTHON>'+='                            %{ return 'MAS_ASIGNAR'; %}
<PYTHON>'++'                            %{ return 'MAS'; %}
<PYTHON>'--'                            %{ return 'MENOS'; %}
<PYTHON>'+'                             %{ return 'SUMA'; %}
<PYTHON>'-'                             %{ return 'RESTA'; %}
<PYTHON>'*'                             %{ return 'POR'; %}
<PYTHON>'/'                             %{ return 'ENTRE'; %}
<PYTHON>'^'                             %{ return 'POT'; %}
<PYTHON>'%'                             %{ return 'MOD'; %}
<PYTHON>'&&'                            %{ return 'AND'; %}
<PYTHON>'||'                            %{ return 'OR'; %}
<PYTHON>'!'                             %{ return 'NOT'; %}
<PYTHON>'='                             %{ return 'ASIGNAR'; %}
<PYTHON>'=='                            %{ return 'IGUAL_IGUAL'; %}
<PYTHON>'!='                            %{ return 'DIFERENTE'; %}
<PYTHON>'>'                             %{ return 'MAYOR'; %}
<PYTHON>'>='                            %{ return 'MAYOR_IGUAL'; %}
<PYTHON>'<'                             %{ return 'MENOR'; %}
<PYTHON>'<='                            %{ return 'MENOR_IGUAL'; %}
<PYTHON>{reserved}                      %{ return yytext; %}
<PYTHON>{digit}                         %{ return 'INT'; %}
<PYTHON>{float}                         %{ return 'FLOAT'; %}
<PYTHON>{shortstring_double}            %{ return 'STRING'; %}
<PYTHON>{shortstring_single}            %{ return 'CHAR'; %}
<PYTHON>{identifier}                    %{ return 'IDENTIFICADOR'; %}
<INDENT>\t                              %{ indent_actual += 1; %}
<INDENT>' '                             %{ /* espacios en blanco */ %}
<INDENT>(\r?\n)+                     	%{ indent_actual = 0; %}
<INDENT>.                               %{ 
                                            var posible = indent - indent_actual;
                                            this.unput(yytext);
                                            if (posible==-1){
                                                indent = indent_actual;
                                                this.begin('PYTHON');
                                                return 'INDENT';
                                            } else if (posible > 0){
                                                indent = indent_actual;
                                                dedents = posible;
                                                this.begin('DEDENT');
                                            } else if (posible==0){
                                                dedents = 0;
                                                this.begin('PYTHON');
                                            } else {
                                                var cuantos = (posible*-1)-1;
                                                console.log("Sobran "+cuantos+" indents");
                                                console.log("."+yytext+".");
                                                this.begin('PYTHON');
                                                indent++;
                                                return 'INDENT';
                                            } 
                                        %}
<DEDENT>.                               %{
                                            this.unput(yytext);
                                            if (dedents!=0){
                                                dedents--;
                                                return 'DEDENT';
                                            } else {
                                                this.begin("PYTHON");
                                            }
                                        %}
<JAVA>[\ \n\t\s\r]+                     %{ /*nada*/ %}
<JAVA>'%%PROGRAMA'                      %{ this.begin("PROGRAMA"); return 'PROGRAMA'; %}
<JAVA>'if'                              %{ return 'IF'; %}
<JAVA>'else'                            %{ return 'ELSE'; %}
<JAVA>'+='                               %{ return 'MAS_ASIGNAR'; %}
<JAVA>'++'                               %{ return 'MAS'; %}
<JAVA>'--'                               %{ return 'MENOS'; %}
<JAVA>'+'                               %{ return 'SUMA'; %}
<JAVA>'-'                               %{ return 'RESTA'; %}
<JAVA>'*'                               %{ return 'POR'; %}
<JAVA>'/'                               %{ return 'ENTRE'; %}
<JAVA>'^'                               %{ return 'POT'; %}
<JAVA>'%'                               %{ return 'MOD'; %}
<JAVA>'&&'                               %{ return 'AND'; %}
<JAVA>'||'                               %{ return 'OR'; %}
<JAVA>'!'                               %{ return 'NOT'; %}
<JAVA>'='                               %{ return 'ASIGNAR'; %}
<JAVA>'=='                               %{ return 'IGUAL_IGUAL'; %}
<JAVA>'!='                               %{ return 'DIFERENTE'; %}
<JAVA>'>'                               %{ return 'MAYOR'; %}
<JAVA>'>='                               %{ return 'MAYOR_IGUAL'; %}
<JAVA>'<'                               %{ return 'MENOR'; %}
<JAVA>'<='                               %{ return 'MENOR_IGUAL'; %}
<JAVA>{reservadas}                      %{ return yytext; %}
<JAVA>{float}                           %{ return 'FLOAT'; %}
<JAVA>{digit}                           %{ return 'INT'; %}
<JAVA>{shortstring_double}                   %{ return 'STRING'; %}
<JAVA>{shortstring_single}                   %{ return 'CHAR'; %}
<JAVA>{identifier}                          %{ return 'IDENTIFICADOR'; %}
<PROGRAMA>[\ \n\t\s\r]+                     %{ /*nada*/ %}
<PROGRAMA>'#include'                        %{ return 'INCLUDE'; %}
<PROGRAMA>'"PY"'                            %{ return 'TODOPY'; %}
<PROGRAMA>'"PY.'{identifier}'.'{identifier}'"'  %{ return 'ESPY'; %}
<PROGRAMA>'"JAVA.*"'                            %{ return 'TODOJAVA'; %}
<PROGRAMA>'"JAVA.'{identifier}'.'{identifier}'"'  %{ return 'JAVAARCHIVO'; %}
<PROGRAMA>'"JAVA.'{identifier}'.*"'         %{ return 'JAVACLASES'; %}
<PROGRAMA>'"JAVA.'{identifier}'"'         %{ return 'JAVACLASE'; %}
<PROGRAMA>'main'                          %{ return 'MAIN'; %}
<PROGRAMA>'void'                          %{ return 'VOID'; %}
<PROGRAMA>'('                          %{ return 'PAR_A'; %}
<PROGRAMA>'='                          %{ return 'IGUAL'; %}
<PROGRAMA>')'                          %{ return 'PAR_C'; %}
<PROGRAMA>'{'                          %{ return 'LLAVE_A'; %}
<PROGRAMA>'}'                          %{ return 'LLAVE_C'; %}
<PROGRAMA>'['                          %{ return 'COR_A'; %}
<PROGRAMA>']'                          %{ return 'COR_C'; %}
<PROGRAMA>'+'                          %{ return 'SUMA'; %}
<PROGRAMA>'-'                          %{ return 'RESTA'; %}
<PROGRAMA>'*'                          %{ return 'POR'; %}
<PROGRAMA>'/*'                         %{ this.begin('BLOQUE_COMENTARIO'); %}
<PROGRAMA>'//'                         %{ this.begin("COMENTARIO"); %}
<COMENTARIO>[\n]                       %{ this.begin('PROGRAMA'); %}
<COMENTARIO>[^\n]+                     %{ agregarErrores(yytext,'COMENTARIO BLOQUE','COMENTARIO',yylineno,yyleng) %}
<BLOQUE_COMENTARIO>'*/'                %{ this.begin('PROGRAMA'); %}
<BLOQUE_COMENTARIO>[^'*/']+            %{ agregarErrores(yytext,'COMENTARIO','COMENTARIO',yylineno,yyleng) %}
<PROGRAMA>'/'                          %{ return 'ENTRE'; %}
<PROGRAMA>'%'                          %{ return 'MOD'; %}
<PROGRAMA>'const'                          %{ return 'CONSTANTE'; %}
<PROGRAMA>'int'                          %{ return 'INT'; %}
<PROGRAMA>'float'                          %{ return 'FLOAT'; %}
<PROGRAMA>'char'                          %{ return 'CHAR'; %}
<PROGRAMA>'if'                          %{ return 'IF'; %}
<PROGRAMA>'else'                          %{ return 'ELSE'; %}
<PROGRAMA>'while'                          %{ return 'WHILE'; %}
<PROGRAMA>'do'                          %{ return 'DO'; %}
<PROGRAMA>'for'                          %{ return 'FOR'; %}
<PROGRAMA>'continue'                          %{ return 'CONTINUE'; %}
<PROGRAMA>'break'                          %{ return 'BREAK'; %}
<PROGRAMA>'scanf'                          %{ return 'SCANF'; %}
<PROGRAMA>'scanf'                          %{ return 'SCANF'; %}
<PROGRAMA>'clrscr'                          %{ return 'CLEAR'; %}
<PROGRAMA>'getch'                          %{ return 'GETCH'; %}
<PROGRAMA>{float}                          %{ return 'FLOATV'; %}
<PROGRAMA>{digit}                          %{ return 'INTV'; %}
<PROGRAMA>"'"."'"                          %{ return 'CHARV'; %}
<PROGRAMA>'&'{identifier}                     %{ return 'IDENTIFICADORREF'; %}
<PROGRAMA>{identifier}                     %{ return 'IDENTIFICADOR'; %}
<PROGRAMA>';'                          %{ return 'PUNTOC'; %}

<<EOF>>                        %{ return 'EOF'; %}

/lex
/* operator associations and precedence */
%{
	var errores = [];

    function agregarErrores(valor,tipo,razon,linea,columna){
        errores.push({valor:valor,tipo:tipo,razon:razon,linea:linea,columna:columna});
    }
%}

%left MAS MENOS
%left SUMA RESTA
%left POR ENTRE MOD
%left POT
%left OR
%left AND
%left IGUAL_IGUAL DIFERENTE MAYOR MAYOR_IGUAL MENOR MENOR_IGUAL
%right NOT
%left UMINUS

%start expressions

%% /* language grammar */

expressions
    : EOF
        {console.log("Vacio");}
    |   PAQUETE URL PYTHON codigo_python JAVA codigo_java PROGRAMA includes constantes globales EOF
        {console.log("Encontrados bloques de python y de java "); console.log(errores);}
;

constantes:
    | lista_constantes
;

lista_constantes:
    constante lista_constantesp
;

lista_constantesp:
    |   lista_constantes
;

globales:
    | lista_globales
;

lista_globales:
    var_global lista_globalesp
;

lista_globalesp:
    |   lista_globales
;

var_global:
    tipos_datos IDENTIFICADOR IGUAL dato PUNTOC
    |   tipos_datos IDENTIFICADOR dimensiones PUNTOC
;

dimensiones:
    COR_A expresion COR_C dimensionesp
;

dimensionesp:
    |   dimensiones
;

expresion:
    | INTV
;

constante:
    CONSTANTE tipos_datos IDENTIFICADOR IGUAL dato PUNTOC
;

tipos_datos:
    INT
    | CHAR
    | FLOAT
;

dato:
    INTV
    | CHARV
    | FLOATV
;

main:
    VOID MAIN PAR_A PAR_C LLAVE_A lista_sentencias_c LLAVE_C
;

lista_sentencias_c:
    |   sentencias_c
;

sentencias_c:
    sentencias_c sentencia_c
    |   sentencia_c
;

sentencia_c:
    asignacion_c
    |   declaracion_c
;

declaracion_c:
    tipos_datos IDENTIFICADOR IGUAL dato PUNTOC
    | tipos_datos IDENTIFICADOR dimensiones PUNTOC
;

asignacion_c:
    IDENTIFICADOR IGUAL dato PUNTOC
    |   IDENTIFICADOR dimensiones IGUAL dato PUNTOC
;

includes:
    |   lista_includes
;

lista_includes:
    include lista_includesp
;

lista_includesp:
    |   lista_includes
;

include:
    INCLUDE tipos_include
;

tipos_include:
    TODOPY
    |   ESPY
    |   TODOJAVA
    |   JAVAARCHIVO
    |   JAVACLASE
    |   JAVACLASES
;

codigo_java:
    |   clases
;

clases:
    clases clase
    | clase
;
clase:
    'public' 'class' IDENTIFICADOR herencia '{' body_classp '}'
;

body_classp:
        {console.log("clase sin cuerpo");}
    | body_class
;

body_class:
    body_class parte_java
    | parte_java
;

parte_java:
    declaracion_global_java
    | metodo_java
    | constructorl
;

declaracion_global_java:
    modificador_java tipo_java IDENTIFICADOR ';'
;

metodo_java:
    modificador_java tipo_java IDENTIFICADOR '(' lista_parametros_java ')' '{' listado_java '}'
    | modificador_java 'void' IDENTIFICADOR '(' lista_parametros_java ')' '{' listado_java '}'
;

modificador_java:
    'public'
    | 'private'
;

sentencias_java:
    sentencias_java sentencia_java
    | sentencia_java
;

sentencia_java:
    if_java
    | declaracion_java
    | for_java
    | while_java
    | do_while_java
    | asignacion_java
    | switch_java
    | 'continue' ';'
    | 'break' ';'
    | 'return' expresion_java ';'
        {console.log("Retorna "+$2);}
    | imprimir_java
        {console.log("Imprime");}
    | error ';'
;

imprimir_java:
    'print' '(' lista_imprimir_java ')' ';'
    | 'println' '(' lista_imprimir_java ')' ';' 
;

lista_imprimir_java:
    lista_imprimir_java ',' expresion_java
    | expresion_java
;

switch_java:
    'switch' '(' IDENTIFICADOR ')' '{' casos_java default_java '}'
;

casos_java:
    casos_java caso_java
    | caso_java
;

caso_java:
    'case' valor ':' sentencias_java
;

default_java:
    | 'default' ':' sentencias_java
;

declaracion_java:
    tipo_java IDENTIFICADOR declaracion_cola_java ';'
    | tipo_java IDENTIFICADOR ASIGNAR tipo_input_java '(' ')' ';'
;

asignacion_java:
    IDENTIFICADOR ASIGNAR expresion_java ';'
        {console.log("Asignacion normal"); var asig = new yy.asignacion_java($1,$3,"normal",0,0); asig.ejecutar(); }
    | IDENTIFICADOR MAS_ASIGNAR expresion_java ';'
        {console.log("Asignacion incremencial");}
    | IDENTIFICADOR MAS ';'
        {console.log("Asignacion ++");}
    | IDENTIFICADOR MENOS ';'
        {console.log("Asignacion --");}
    | IDENTIFICADOR ASIGNAR tipo_input_java '(' ')' ';'
;

tipo_input_java:
    'intinput'
    |   'floatinput'
    |   'charinput'
;

declaracion_cola_java:
    | ASIGNAR expresion_java
;

valor_java:
    INT
    |   STRING
    |   FLOAT
;

if_java:
    IF '(' expresion_java ')' '{' listado_java '}'
        {console.log("encuentra if");}
    | IF '(' expresion_java ')' '{' listado_java '}' ELSE '{' listado_java '}'
        {console.log("encuentra if-else");}
    | IF '(' expresion_java ')' '{' listado_java '}' ELSE if_java
        {console.log("encuentra if-elseif");}
;

for_java:
    'for' '(' declaracion_for ';' expresion_java ';' accion_posterior_java ')' '{' listado_java '}'
;

while_java:
    'while' '(' expresion_java ')' '{' listado_java '}'
;

do_while_java:
    'do' '{' listado_java '}' 'while' '(' expresion_java ')' ';'
;

declaracion_for:
    'int' IDENTIFICADOR ASIGNAR INT
    |   IDENTIFICADOR ASIGNAR INT
;

accion_posterior_java:
    IDENTIFICADOR MAS
    | IDENTIFICADOR MENOS
;


listado_java:
    | sentencias_java
;

constructorl:
    'public' IDENTIFICADOR '(' lista_parametros_java ')' '{' listado_java '}'
;

lista_parametros_java:
    |   parametros_java
;

parametros_java:
    parametros_java ',' parametro_java
    | parametro_java
;

parametro_java:
    tipo_java IDENTIFICADOR
;

tipo_java:
    'int'
    | 'String'
    | 'float'
    | 'char'
    | 'boolean'
;

herencia:
    | 'extends' IDENTIFICADOR
;


expresion_java:
    expresion_java SUMA expresion_java
        { $$ = new yy.expresion_java("+",$1,$3,null,0,0);}
    | expresion_java POR expresion_java
        { $$ = new yy.expresion_java("*",$1,$3,null,0,0);}
    | expresion_java ENTRE expresion_java
        { $$ = new yy.expresion_java("/",$1,$3,null,0,0);}
    | expresion_java POT expresion_java
        { $$ = new yy.expresion_java("^",$1,$3,null,0,0);}
    | expresion_java MOD expresion_java
        { $$ = new yy.expresion_java("%",$1,$3,null,0,0);}
    | expresion_java RESTA expresion_java
        { $$ = new yy.expresion_java("-",$1,$3,null,0,0);}
    | RESTA expresion_java
    %prec UMINUS
    | expresion_java AND expresion_java
    | expresion_java OR expresion_java
    | NOT expresion_java
    | expresion_java IGUAL_IGUAL expresion_java
    | expresion_java DIFERENTE expresion_java
    | expresion_java MAYOR expresion_java
    | expresion_java MAYOR_IGUAL expresion_java
    | expresion_java MENOR expresion_java
    | expresion_java MENOR_IGUAL expresion_java
    | '(' expresion_java ')'
        { $$ = $2; }
    | IDENTIFICADOR
        { $$ = new yy.expresion_java("val",null,null,new yy.valor_java($1,"identificador",0,0),0,0);}
    | INT
        { $$ = new yy.expresion_java("val",null,null,new yy.valor_java($1,"int",0,0),0,0);}
    | STRING
        { $$ = new yy.expresion_java("val",null,null,new yy.valor_java($1,"string",0,0),0,0);}
    | FLOAT
        { $$ = new yy.expresion_java("val",null,null,new yy.valor_java($1,"float",0,0),0,0);}
    | CHAR
        { $$ = new yy.expresion_java("val",null,null,new yy.valor_java($1,"char",0,0),0,0);}
    | IDENTIFICADOR '(' ')'
    | 'true'
        { $$ = new yy.expresion_java("val",null,null,new yy.valor_java($1,"boolean",0,0),0,0);}
    | 'false'
        { $$ = new yy.expresion_java("val",null,null,new yy.valor_java($1,"false",0,0),0,0);}
;

codigo_python:
    |   SALTO
    |   SALTO funciones_python
;

funciones_python:
        funciones_python funcion_python
        {console.log("otra funcion");}
    |   funcion_python
        {console.log("una funcion"); } 
    ;

funcion_python:
    'def' IDENTIFICADOR '(' lista_parametros_python ')' ':' SALTO INDENT sentencias_python DEDENT
    ;

lista_parametros_python:
    | parametros_python
;

parametros_python:
    IDENTIFICADOR parametros_pythonp
;

parametros_pythonp:
    | ',' IDENTIFICADOR
;

sentencias_python:
    sentencia_python sentencias_pythonp
;

sentencias_pythonp:
    | sentencias_python
;

sentencia_python:
    asignacion_python
    |   if_python
    |   for_python
    |   print_python
    |   while_python
    |   error SALTO
;

print_python:
    'print' '(' lista_imprimir_python ')' SALTO
    |   'println' '(' lista_imprimir_python ')' SALTO
;


lista_imprimir_python:
    lista_imprimir_python ',' expresion_python
    | expresion_python
;

asignacion_python:
    IDENTIFICADOR ASIGNAR expresion_python SALTO
		{console.log("una asignacion");}
    |   IDENTIFICADOR ASIGNAR 'input' '(' ')' SALTO
        {console.log("input");}
    ;

valor:
    STRING
    |   FLOAT
    |   INT
    |   CHAR
        {console.log("Encuentra char");}
    ;

for_python:
    'for' IDENTIFICADOR 'in' 'range' '(' ')' ':' SALTO INDENT sentencias_python DEDENT
        {console.log("Encontrado for");}
;

while_python:
    'while' expresion_python ':' SALTO INDENT sentencias_python DEDENT
        {console.log("Encuentra while");}
;

if_python
    : IF expresion_python ':' SALTO INDENT sentencias_python DEDENT               { console.log("if"); }
    | IF expresion_python ':' SALTO INDENT sentencias_python DEDENT if_python_cola  { console.log("if-cola"); }
    ;
if_python_cola
    : ELSE ':' SALTO INDENT sentencias_python DEDENT                  { console.log("if-else"); }
    | elif_python ELSE ':' SALTO INDENT sentencias_python DEDENT     { console.log("if-elif-else"); }
    | elif_python                                           { console.log("if-elif"); }
    ;
elif_python
    : ELIF expresion_python ':' SALTO INDENT sentencias_python DEDENT            { console.log("elif"); }
    | ELIF expresion_python ':' SALTO INDENT sentencias_python DEDENT elif_python    { console.log("elif-elif"); }
    ;

expresion_python:
    expresion_python SUMA expresion_python
    | expresion_python POR expresion_python
    | expresion_python ENTRE expresion_python
    | expresion_python POT expresion_python
    | expresion_python MOD expresion_python
    | expresion_python RESTA expresion_python
    | RESTA expresion_python
    %prec UMINUS
    | expresion_python AND expresion_python
    | expresion_python OR expresion_python
    | NOT expresion_python
    | expresion_python IGUAL_IGUAL expresion_python
    | expresion_python DIFERENTE expresion_python
    | expresion_python MAYOR expresion_python
    | expresion_python MAYOR_IGUAL expresion_python
    | expresion_python MENOR expresion_python
    | expresion_python MENOR_IGUAL expresion_python
    | '(' expresion_python ')'
        { $$ = $2; }
    | IDENTIFICADOR
    | INT
        { $$ = $1; }
    | STRING
        { $$ = $1; }
    | FLOAT
        { $$ = $1; }
    | CHAR
        { $$ = $1; }
    | 'true'
        { $$ = true; }
    | 'false'
        { $$ = false; }
;