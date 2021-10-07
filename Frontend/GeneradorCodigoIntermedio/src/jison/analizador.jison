%{ var indents = [0], indent = 0, indent_actual = 0, dedents = 0, val_actual = "" %}
%lex

reserved                                {keywords}|{operators}
keywords                                "continue"|"finally"|"return"|"global"|
                                        "assert"|"except"|"import"|"lambda"|
                                        "raise"|"class"|"print"|"break"|"while"|
                                        "yield"|"from"|"elif"|"else"|"with"|
                                        "pass"|"exec"|"and"|"del"|"not"|"def"|
                                        "for"|"try"|"as"|"or"|"if"|"in"|"is"

reservadas                              "public" | "private" | "class" | "extends" | "int" |
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

%s INITIAL PYTHON2 INLINE JAVA DEDENTS

%%
<INITIAL>[\ \n]+                        %{ console.log("eninicio"); %}
<INITIAL>[\t]                           %{ console.log("tabulacion"); %}
<INITIAL>{apertura_python}              %{ this.begin("PYTHON2"); return 'PYTHON'; %}
<PYTHON2>\                              %{ indent += 1 %}
<PYTHON2>\t                             %{ indent += 1; console.log("encuentra tabulacion 2"); %}
<PYTHON2>(\r?\n)+                    %{ indent = 0 // blank line %}
<PYTHON2>\n                             %{ indent = 0 // blank line %}
<PYTHON2>.                              %{ 
                                            this.unput( yytext );
                                            var last = indents[ indents.length - 1 ]
                                            if ( indent > last ) {
                                                this.begin( 'INLINE' )
                                                indents.push( indent );
                                                return 'INDENT';
                                            } else if ( indent < last ) {
                                                this.begin( 'DEDENTS' );
                                                dedents = 0 // how many dedents occured
                                                while( last = indents.pop() ) {
                                                    if ( last == indent ) break
                                                    dedents += 1;
                                                }
                                            } else {
                                                this.begin( 'INLINE' );
                                            }
                                        %}
<DEDENTS>.                              %{
                                            this.unput( yytext )
                                            if ( dedents-- > 0 ) {
                                                dedents -= 1
                                                return 'DEDENT'
                                                
                                            } else {
                                                this.begin( 'INLINE' )
                                            }
                                        %}
<INLINE>(\r?\n)+                     %{ 
                                            indent = 0; 
                                            this.begin( 'PYTHON2' )
                                            return 'SALTO' 
                                        %}
<INLINE>[\ \t\f]+                       /* skip whitespace, separate tokens */
<INLINE>{reserved}                      %{ console.log("Estoy en el estado inline"); return yytext %}
<INLINE>{float}                         return 'FLOAT'
<INLINE>{digit}                         return 'INT'
<INLINE>{shortstring}                   return 'STRING'
<INLINE>{identifier}                    return 'IDENTIFICADOR'
<INLINE><<EOF>>                         return 'EOF'
<JAVA>[\ \n\t\s\r]+                     %{ /*nada*/ %}
<JAVA>'if'                              %{ return 'IF'; %}
<JAVA>'else'                            %{ return 'ELSE'; %}
<JAVA>'elif'                            %{ return 'ELIF'; %}
<JAVA>'+='                               %{ return 'MAS_ASIGNAR'; %}
<JAVA>'++'                               %{ return 'MAS'; %}
<JAVA>'--'                               %{ return 'MENOS'; %}
<JAVA>'+'                               %{ return 'SUMA'; %}
<JAVA>'-'                               %{ return 'RESTA'; %}
<JAVA>'*'                               %{ return 'POR'; %}
<JAVA>'/'                               %{ return 'ENTRE'; %}
<JAVA>'^'                               %{ return 'POT'; %}
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
<JAVA>{shortstring}                     %{ return 'STRING'; %}
<JAVA>{identifier}                      %{ return 'IDENTIFICADOR'; %}
<<EOF>>                        %{ return 'EOF'; %}

/lex

/* operator associations and precedence */
%left MAS MENOS
%left SUMA RESTA
%left POR ENTRE
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
    |   PYTHON codigo_python JAVA codigo_java EOF
        {console.log("Un conjunto de funciones")}
    |   PYTHON codigo_python EOF
        {console.log("Un conjunto de funciones2")}
;

codigo_java:
    |   clases
;

clases:
    clases clase
    | clase
;
clase:
    'public' 'class' IDENTIFICADOR herencia '{' body_class '}'
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
    | 'return' expr ';'
        {console.log("Retorna "+$2);}
    | imprimir_java
        {console.log("Imprime");}
;

imprimir_java:
    'print' '(' lista_imprimir_java ')' ';'
    | 'println' '(' lista_imprimir_java ')' ';' 
;

lista_imprimir_java:
    lista_imprimir_java ',' expr
    | expr
;

switch_java:
    'switch' '(' IDENTIFICADOR ')' '{' casos_java default_java '}'
;

casos_java:
    casos_java caso_java
    | caso_java
;

caso_java:
    'case' valor_java ':' sentencias_java
;

default_java:
    | 'default' ':' sentencias_java
;

declaracion_java:
    tipo_java IDENTIFICADOR declaracion_cola_java ';'
;

asignacion_java:
    IDENTIFICADOR ASIGNAR expr ';'
        {console.log("Asignacion normal");}
    | IDENTIFICADOR MAS_ASIGNAR expr ';'
        {console.log("Asignacion incremencial");}
    | IDENTIFICADOR MAS ';'
        {console.log("Asignacion ++");}
    | IDENTIFICADOR MENOS ';'
        {console.log("Asignacion --");}
;

declaracion_cola_java:
    | ASIGNAR expr
;

valor_java:
    INT
    |   STRING
    |   FLOAT
;

if_java:
    IF '(' expr ')' '{' listado_java '}'
        {console.log("encuentra if");}
    | IF '(' expr ')' '{' listado_java '}' ELSE '{' listado_java '}'
        {console.log("encuentra if-else");}
    | IF '(' expr ')' '{' listado_java '}' ELSE if_java
        {console.log("encuentra if-elseif");}
;

for_java:
    'for' '(' declaracion_for ';' expr ';' accion_posterior_java ')' '{' listado_java '}'
;

while_java:
    'while' '(' expr ')' '{' listado_java '}'
;

do_while_java:
    'do' '{' listado_java '}' 'while' '(' expr ')' ';'
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

expr:
    expr SUMA expr
    | expr POR expr
    | expr ENTRE expr
    | expr POT expr
    | expr RESTA expr
    | RESTA expr
    %prec UMINUS
    | expr AND expr
    | expr OR expr
    | NOT expr
    | expr IGUAL_IGUAL expr
    | expr DIFERENTE expr
    | expr MAYOR expr
    | expr MAYOR_IGUAL expr
    | expr MENOR expr
    | expr MENOR_IGUAL
    | '(' expr ')'
    | IDENTIFICADOR
    | INT
    | STRING
    | FLOAT
    | IDENTIFICADOR '(' ')'
;


codigo_python:
    |   funciones
;

funciones:
        funciones funcion
        {console.log("otra funcion");}
    |   funcion
        {console.log("una funcion"); } 
    ;

funcion:
    'def' IDENTIFICADOR '(' ')' ':' SALTO INDENT 'for'
    ;

bloque:
    asignar
    |   if_python
    ;

asignar:
    IDENTIFICADOR '=' valor SALTO
    ;

valor:
    STRING
    |   FLOAT
    |   INT
    ;

if_python
    : IF expr ':' SALTO INDENT bloque DEDENT               { $$ = 'if(' + $2 + '){' + $4 + '}\n' }
    | IF expr ':' SALTO INDENT bloque DEDENT if_python_cola  { $$ = 'if(' + $2 + '){' + $4 + '}' + $5 }
    ;
if_python_cola
    : 'else' ':' SALTO INDENT bloque DEDENT                  { $$ = 'else{' + $3 + '}' }
    | elif_python 'else' ':' SALTO INDENT bloque DEDENT     { $$ = $1 + 'else{' + $4 + '}' }
    | elif_python
    ;
elif_python
    : 'elif' expr ':' SALTO INDENT bloque DEDENT
        { $$ = 'else if(' + $2 + '){' + $4 + '}' }
    | 'elif' expr ':' SALTO INDENT bloque DEDENT elif_python
        { $$ = 'else if(' + $2 + '){' + $4 + '}' + $5 }
    ;