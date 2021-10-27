%{ var indents = [0], indent = 0, indent_actual = 0, dedents = 0, val_actual = "" %}
%lex
%{  
    if (!('codigo3D' in yy)){ yy.codigo3D = "#include <stdio.h>\nstruct dato {\n\tint tipo;\n\tint intv;\n\tchar charv;\n\tfloat floatv;\n};\nstruct dato stack[100];\n\t"; }
    if (!('etiquetas' in yy)){ yy.etiquetas = 0; } 
    if (!('bloques' in yy)){ yy.bloques = 0; } 
    if (!('bloques_codes' in yy)){ yy.bloques_codes = 0; } 
    if (!('simbolos' in yy)){ yy.simbolos = []; } 
    if (!('idsSimbolos' in yy)){ yy.idsSimbolos = []; } 
    if (!('addSimbolos' in yy)){ yy.addSimbolos = function(simbolo,linea,columna){
        if (yy.idsSimbolos.includes(simbolo.id)){
            agregarErrores(simbolo.id,"SEMANTICO","Ya has declarado la variable",linea,columna);
        } else {
            yy.simbolos.push(simbolo);
            yy.idsSimbolos.push(simbolo.id);
        }
    }} 
    if (!('getTipo' in yy)){ yy.getTipo = function(simbolo,linea,columna){
        if (yy.idsSimbolos.includes(simbolo.id)){
            for (var i = 0; i < yy.simbolos.length; i++){
                if (yy.simbolos[i].id == simbolo.id){
                    if (yy.simbolos[i].arreglo == simbolo.arreglo){
                        return yy.simbolos[i].tipo;
                    } else {
                        var es = (simbolo.arreglo)?"El arreglo que solicitas es una variable normal":"La variable que solicitas es un arreglo";
                        agregarErrores(simbolo.id,"SEMANTICO",es,linea,columna);
                        return 'error';
                    }
                }
            }
        } else {
            agregarErrores(simbolo.id,"SEMANTICO","No has declarado la variable",linea,columna);
            return 'error';
        }
    }} 
%}
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
<JAVA>{shortstring_double}                  %{ return 'STRING'; %}
<JAVA>"'"."'"                               %{ return 'CHAR'; %}
<JAVA>{identifier}                          %{ return 'IDENTIFICADOR'; %}
<PROGRAMA>[\ \n\t\s\r]+                     %{ /*nada*/ %}
<PROGRAMA>'#include'                        %{ return 'INCLUDE'; %}
<PROGRAMA>'"PY"'                            %{ return 'TODOPY'; %}
<PROGRAMA>'"PY.'{identifier}'.'{identifier}'"'  %{ 
    var prueba = yytext.substring(1,yytext.length-1);
    yytext = prueba;
    return 'ESPY'; 
    %}
<PROGRAMA>'"JAVA.*"'                            %{ 
    var prueba = yytext.substring(1,yytext.length-1);
    yytext = prueba;
     return 'TODOJAVA'; %}
<PROGRAMA>'"JAVA.'{identifier}'.'{identifier}'"'  %{  
    var prueba = yytext.substring(1,yytext.length-1);
    yytext = prueba;
    return 'JAVAARCHIVO'; %}
<PROGRAMA>'"JAVA.'{identifier}'.*"'         %{  
    var prueba = yytext.substring(1,yytext.length-1);
    yytext = prueba;
    return 'JAVACLASES'; %}
<PROGRAMA>'"JAVA.'{identifier}'"'         %{  
    var prueba = yytext.substring(1,yytext.length-1);
    yytext = prueba;
    return 'JAVACLASE'; %}
<PROGRAMA>'main'                          %{ return 'MAIN'; %}
<PROGRAMA>'void'                          %{ return 'VOID'; %}
<PROGRAMA>':'                          %{ return 'DOS_P'; %}
<PROGRAMA>'('                          %{ return 'PAR_A'; %}
<PROGRAMA>'='                          %{ return 'IGUAL'; %}
<PROGRAMA>')'                          %{ return 'PAR_C'; %}
<PROGRAMA>'{'                          %{ return 'LLAVE_A'; %}
<PROGRAMA>'}'                          %{ return 'LLAVE_C'; %}
<PROGRAMA>'['                          %{ return 'COR_A'; %}
<PROGRAMA>']'                          %{ return 'COR_C'; %}
<PROGRAMA>'++'                          %{ return 'MAS'; %}
<PROGRAMA>'+'                          %{ return 'SUMA'; %}
<PROGRAMA>'--'                          %{ return 'MENOS'; %}
<PROGRAMA>'-'                          %{ return 'RESTA'; %}
<PROGRAMA>'*'                          %{ return 'POR'; %}
<PROGRAMA>'/*'                         %{ this.begin('BLOQUE_COMENTARIO'); %}
<PROGRAMA>'//'                         %{ this.begin("COMENTARIO"); %}
<COMENTARIO>[\n]                       %{ this.begin('PROGRAMA'); %}
<COMENTARIO>[^\n]+                     %{ /*agregarErrores(yytext,'COMENTARIO BLOQUE','COMENTARIO',yylineno,0);*/ %}
<BLOQUE_COMENTARIO>'*/'                %{ this.begin('PROGRAMA'); %}
<BLOQUE_COMENTARIO>[^'*/']+            %{ /*agregarErrores(yytext,'COMENTARIO','COMENTARIO',yylineno,0);*/ %}
<PROGRAMA>'/'                          %{ return 'ENTRE'; %}
<PROGRAMA>'%'                          %{ return 'MOD'; %}
<PROGRAMA>'&&'                          %{ return 'AND'; %}
<PROGRAMA>'||'                          %{ return 'OR'; %}
<PROGRAMA>'<'                          %{ return 'MENOR'; %}
<PROGRAMA>'>'                          %{ return 'MAYOR'; %}
<PROGRAMA>'=='                          %{ return 'IGUAL_IGUAL'; %}
<PROGRAMA>'!='                          %{ return 'DIFF'; %}
<PROGRAMA>'!'                          %{ return 'NOT'; %}
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
<PROGRAMA>'printf'                          %{ return 'PRINTF'; %}
<PROGRAMA>'case'                          %{ return 'CASE'; %}
<PROGRAMA>'switch'                          %{ return 'SWITCH'; %}
<PROGRAMA>'default'                          %{ return 'DEFAULT'; %}
<PROGRAMA>'clrscr'                          %{ return 'CLEAR'; %}
<PROGRAMA>'getch'                          %{ return 'GETCH'; %}
<PROGRAMA>{float}                          %{ return 'FLOATV'; %}
<PROGRAMA>{digit}                          %{ return 'INTV'; %}
<PROGRAMA>"'"."'"                          %{ return 'CHARV'; %}
<PROGRAMA>{shortstring_double} %{ 
    var prueba = yytext.substring(1,yytext.length-1);
    yytext = prueba;
    if (yytext.includes('%c')){
        return 'SCANCHAR';
    } else if (yytext.includes('%d')){
        return 'SCANINT';
    } else if (yytext.includes('%f')){
        return 'SCANFLOAT';
    } else {
        return 'STRING';
    } %}
<PROGRAMA>'&'{identifier}                     %{ return 'IDENTIFICADORREF'; %}
<PROGRAMA>{identifier}                     %{ return 'IDENTIFICADOR'; %}
<PROGRAMA>';'                          %{ return 'PUNTOC'; %}
<PROGRAMA>','                          %{ return 'COMA'; %}

<<EOF>>                        %{ return 'EOF'; %}
/lex
/* operator associations and precedence */
%{
var errores = [];
var conteo_errores= 0;

function agregarErrores(valor,tipo,razon,linea,columna){
    errores.push({valor:valor,tipo:tipo,razon:razon,linea:linea,columna:columna});
    conteo_errores++;
}

function soloNumeros(dato){
    if (dato.tipo=="char"){
        dato.valor = dato.valor.charCodeAt(0);
        dato.tipo = "int";
        return dato;
    } else {
        return dato;
    }
}
%}
%left MAS MENOS
%left SUMA RESTA
%left POR ENTRE MOD
%left POT
%left OR
%left AND
%left IGUAL_IGUAL DIFERENTE DIFF MAYOR MAYOR_IGUAL MENOR MENOR_IGUAL
%right NOT
%left UMINUS

%start expressions

%% /* language grammar */
expressions
    : EOF
        {console.log("Vacio");}
    |
        PAQUETE URL PYTHON codigo_python JAVA codigo_java PROGRAMA includes constantes globales main EOF
        {
            var obj = new Object();
            obj.errores = errores;
            obj.codigo3D = yy.codigo3D;
            obj.conteo = conteo_errores;
            obj.simbolos = yy.simbolos;
            var C = new Object();
            C.includes = $8;
            C.constantes = $9;
            C.globales = $10;
            C.cuadruplasMain = $11;
            C.tablaSimbolos = yy.simbolos;
            obj.C = C;
            return obj;
        }
    |   error EOF
        {
            var obj = new Object();
            obj.errores = errores;
            obj.codigo3D = yy.codigo3D;
            obj.conteo = conteo_errores;
            obj.simbolos = yy.simbolos;
            return obj;
        }
;

constantes:
    {
        $$ = null;
    }
    | lista_constantes
    {
        $$ = $1;
    }
;

lista_constantes:
    lista_constantes constante
    {
        Array.prototype.push.apply($1,$2.cuadruplas);
        $$ = $1;
    }
    |   constante
    {
        $$ = $1.cuadruplas;
    }
;

constante:
    CONSTANTE tipos_datos IDENTIFICADOR IGUAL expresion_c PUNTOC
    {
        var objeto = new Object();
        objeto.id = $3;
        objeto.tipo = $2;
        objeto.constante = true;
        objeto.tamanio = 1;
        objeto.arreglo = false;
        objeto.rol = "variable";
        objeto.cuadruplas = [];
        $$ = objeto;
        if ($5.tipo != 'error'){
            if ($2 == $5.tipo){
                yy.addSimbolos(objeto,@3.first_line,@3.first_column);
                $$.codigo3D = $5.codigo3D + "const "+$2+" "+$3+" = "+$5.etiqueta+" ;\n";
                $$.etiqueta = "";
                objeto.cuadruplas = $5.cuadruplas;
                objeto.cuadruplas.push(new yy.Cuadrupla("d=",$5.etiqueta,null,$3));
                yy.codigo3D += $$.codigo3D;
            } else {
                if (($2 == 'char' && $5.tipo=='int') || ($2 == 'float' && ($5.tipo=='int' || $5.tipo=='char')) || ($2 == 'int' && $5.tipo=='char') ){
                    yy.addSimbolos(objeto,@3.first_line,@3.first_column);
                    $$.codigo3D = $5.codigo3D + "const "+$2+" "+$3+" = "+$5.etiqueta+" ;\n";
                    objeto.cuadruplas = $5.cuadruplas;
                    objeto.cuadruplas.push(new yy.Cuadrupla("d=",$5.etiqueta,null,$3));
                    $$.etiqueta = "";
                    yy.codigo3D += $$.codigo3D;
                } else {
                    agregarErrores($3,'SEMANTICO','Asignación de datos incompatibles '+$2+' no es compatible con '+$5.tipo,@3.first_line,@3.first_column);
                }
            }
        }
    }
    |   CONSTANTE tipos_datos IDENTIFICADOR dimensiones PUNTOC
    {
        var objeto = new Object();
        objeto.id = $2;
        objeto.tipo = $1;
        objeto.constante = true;
        objeto.tamanio = 1;
        objeto.arreglo = true;
        objeto.rol = "variable";
        objeto.codigo3D = $4.codigo3D+" "+$2+" "+$3+"["+$4.etiqueta+"];\n";
        objeto.etiqueta = "";
        objeto.cuadruplas = $4.cuadruplas;
        objeto.cuadruplas.push(new yy.Cuadrupla("d=[]",$4.etiqueta,null,$3));
        yy.codigo3D += objeto.codigo3D;
        yy.addSimbolos(objeto,@3.first_line,@3.first_column);
        $$ = objeto;
    }
;

globales:
    {
        $$ = null;
    }
    | lista_globales
    {
        $$ = $1;
    }
;

lista_globales:
    lista_globales var_global
    {
        Array.prototype.push.apply($1,$2.cuadruplas);
        $$ = $1;
    }
    |   var_global
    {
        $$ = $1.cuadruplas;
    }
;

var_global:
    tipos_datos IDENTIFICADOR IGUAL expresion_c PUNTOC
    {
        var objeto = new Object();
        objeto.id = $2;
        objeto.tipo = $1;
        objeto.constante = false;
        objeto.tamanio = 1;
        objeto.arreglo = false;
        objeto.rol = "variable";
        objeto.codigo3D = $4.codigo3D+" "+$1+" "+$2+" = "+$4.etiqueta+";\n";
        objeto.cuadruplas = $4.cuadruplas;
        objeto.cuadruplas.push(new yy.Cuadrupla("d=",$4.etiqueta,null,$2));
        yy.codigo3D += objeto.codigo3D;
        objeto.etiqueta = "";
        yy.addSimbolos(objeto,@2.first_line,@2.first_column);
        $$ = objeto;
    }
    |   tipos_datos IDENTIFICADOR dimensiones PUNTOC
    {
        var objeto = new Object();
        objeto.id = $2;
        objeto.tipo = $1;
        objeto.constante = false;
        objeto.tamanio = 1;
        objeto.arreglo = true;
        objeto.rol = "variable";
        objeto.codigo3D = $3.codigo3D+" "+$1+" "+$2+"["+$3.etiqueta+"];\n";
        objeto.etiqueta = "";
        objeto.cuadruplas = $3.cuadruplas;
        objeto.cuadruplas.push(new yy.Cuadrupla("d=[]",$3.etiqueta,null,$2));
        yy.codigo3D += objeto.codigo3D;
        yy.addSimbolos(objeto,@2.first_line,@2.first_column);
        $$ = objeto;
    }
;

dimensiones:
    dimensiones COR_A expresion_c COR_C
    {
        var tem = new Object();
        tem.codigo3D = $1.codigo3D + $3.codigo3D + " int t"+yy.etiquetas+" = "+$1.etiqueta+" * "+$3.etiqueta+" ;\n";
        tem.etiqueta = "t"+yy.etiquetas;
        tem.cuadruplas = $1.cuadruplas;
        tem.cuadruplas.push(new yy.Cuadrupla("*",$1.etiqueta,$3.etiqueta,tem.etiqueta));
        yy.etiquetas++;
        $$ = tem;
    }
    |   COR_A expresion_c COR_C 
    {
        var tem = new Object();
        tem.codigo3D = $2.codigo3D;
        tem.etiqueta = $2.etiqueta;
        tem.cuadruplas = $2.cuadruplas;
        $$ = tem;
    }
;

tipos_datos:
    INT
    {
        $$ = "int";
    }
    | CHAR
    {
        $$ = "char";
    }
    | FLOAT
    {
        $$ = "float";
    }
;

dato:
    INTV 
        {
            var obj = new Object();
            obj.valor = parseInt($1);
            obj.respuesta = parseInt($1);
            obj.tipo = "int";
            obj.linea = @1.first_line;
            obj.columna = @1.first_column;
            $$ = obj;
        }
    | CHARV
        {
            var obj = new Object();
            obj.valor = $1;
            obj.respuesta = $1;
            obj.tipo = "char";
            obj.linea = @1.first_line;
            obj.columna = @1.first_column;
            $$ = obj;
        }
    | FLOATV
        {
            var obj = new Object();
            obj.valor = parseFloat($1);
            obj.respuesta = parseFloat($1);
            obj.tipo = "float";
            obj.linea = @1.first_line;
            obj.columna = @1.first_column;
            $$ = obj;
        }     
;

main:
    VOID MAIN PAR_A PAR_C LLAVE_A lista_sentencias_c LLAVE_C
    {
        console.log("CODIGO");
        yy.codigo3D+= "void main(){\n\t"+$6.codigo3D+"}";
        $$ = $6.cuadruplas;
        console.log("FIN CODIGO");
    }
;

lista_sentencias_c:
    {
        $$ = null;
    }
    |   sentencias_c
    {
        $$ = $1;
        var boo = false;
        var cod3d = "";
        var temp = [];
        temp.push(new yy.Cuadrupla("bloque","B"+yy.bloques_codes,null,null));
        for (var i = 0; i < $$.length; i++){
            var ob = $$[i];
            cod3d+=ob.codigo3D;
            Array.prototype.push.apply(temp,$$[i].cuadruplas);
        }
        temp.push(new yy.Cuadrupla("bloque","B"+yy.bloques_codes,null,null));
        yy.bloques_codes++;
        $$ = new Object();
        $$.codigo3D = cod3d;
        $$.cuadruplas = temp;
        $$.etiqueta = "";
    }
;

sentencias_c:
    sentencias_c sentencia_c
    {
        $1.push($2);
        $$ = $1;
    }
    |   sentencia_c
    {
        $$ = [];
        $$.push($1);
    }
;

sentencia_c:
    una_linea_c
    {
        $$ = $1;
    }
    |   bloque_c
    {
        $$ = $1;
    }
;

bloque_c:
	if_c
    {
        var temp = new Object();
        temp.tipo = $1.tipo_if;
        temp.if = $1;
        temp.codigo3D = $1.codigo3D;
        temp.etiqueta = "";
        temp.cuadruplas = $1.cuadruplas;
        $$ = temp;
    }
	|	for_c
    {
        var temp = new Object();
        temp.tipo = "for";
        temp.for = $1;
        temp.codigo3D = $1.codigo3D;
        temp.etiqueta = "";
        temp.cuadruplas = $1.cuadruplas;
        $$ = temp;
    }
	|	while_c
    {
        var temp = new Object();
        temp.tipo = "while";
        temp.while = $1;
        temp.codigo3D = $1.codigo3D;
        temp.etiqueta = "";
        temp.cuadruplas = $1.cuadruplas;
        $$ = temp;
    }
    |   switch_c
    {
        var temp = new Object();
        temp.tipo = "switch";
        temp.switch = $1;
        temp.codigo3D = $1.codigo3D;
        temp.etiqueta = "";
        temp.cuadruplas = $1.cuadruplas;
        $$ = temp;
    }
    |   error LLAVE_C
;

una_linea_c:
    asignacion_c
    {
        var temp = new Object();
        temp.tipo = "asignacion";
        temp.asignacion = $1;
        temp.codigo3D = $1.codigo3D;
        temp.etiqueta = "";
        temp.cuadruplas = $1.cuadruplas;
        $$ = temp;
    }
    |   declaracion_c
    {
        var temp = new Object();
        temp.tipo = "declaracion";
        temp.declaracion = $1;
        temp.codigo3D = $1.codigo3D;
        temp.etiqueta = "";
        temp.cuadruplas = $1.cuadruplas;
        $$ = temp;
    }
    |   BREAK PUNTOC
    {
        var temp = new Object();
        temp.tipo = "break";
        temp.codigo3D = "";
        temp.etiqueta = "";
        temp.cuadruplas = [];
        temp.cuadruplas.push(new yy.Cuadrupla("break",null,null,null));
        $$ = temp;
    }
    |   CONTINUE PUNTOC
    {
        var temp = new Object();
        temp.tipo = "continue";
        temp.codigo3D = "";
        temp.etiqueta = "";
        temp.cuadruplas = [];
        temp.cuadruplas.push(new yy.Cuadrupla("continue",null,null,null));
        $$ = temp;
    }
    |   CLEAR PAR_A PAR_C PUNTOC
    {
        var temp = new Object();
        temp.tipo = "clear";
        temp.codigo3D = "";
        temp.etiqueta = "";
        temp.cuadruplas = [];
        temp.cuadruplas.push(new yy.Cuadrupla("clear",null,null,null));
        $$ = temp;
    }
    |   GETCH PAR_A PAR_C PUNTOC
    {
        var temp = new Object();
        temp.tipo = "getch";
        temp.codigo3D = "";
        temp.etiqueta = "";
        temp.cuadruplas = [];
        temp.cuadruplas.push(new yy.Cuadrupla("getch",null,null,null));
        $$ = temp;
    }
    |   SCANF PAR_A tipos_scan_c COMA IDENTIFICADORREF PAR_C PUNTOC
    {
        var temp = new Object();
        temp.tipo = "scanf";
        temp.tipo_scan = $3;
        temp.variable = $5;
        temp.codigo3D = "";
        temp.etiqueta = "";
        temp.cuadruplas = [];
        var obj = new Object();
        obj.id = $5.substring(1,$5.length);
        obj.arreglo = false;
        var tipo = yy.getTipo(obj,@5.first_line,@5.first_column);
        if (tipo!="error"){
            if (temp.tipo_scan.scan==tipo){
                temp.cuadruplas.push(new yy.Cuadrupla("scanf",$3.texto,obj.id,null));
                temp.codigo3D = "scanf("+temp.tipo_scan.texto+","+$5+");\n";
            } else {
                agregarErrores(obj.id,"SEMANTICO","Ingresaste un "+tipo+" cuando scanf esperaba un "+temp.tipo_scan.scan,@5.first_line,@5.first_column);
            }
        }
        $$ = temp;
    }
    |   printf_c
    {
        $$ = $1;
    }
    |   do_while_c
    {
        var temp = new Object();
        temp.tipo = "do";
        temp.do = $1;
        temp.codigo3D = $1.codigo3D;
        temp.etiqueta = "";
        temp.cuadruplas = $1.cuadruplas;
        $$ = temp;
    }
    |   error PUNTOC
;

ids_c:
    ids_c COMA IDENTIFICADOR
    {
        var temp = new Object();
        temp.id = $3;
        temp.arreglo = false;
        var tipo = yy.getTipo(temp,@1.first_line,@1.first_column);
        temp.tipo = tipo;
        temp.linea = @1.first_line;
        temp.columna = @1.first_column;
        $1.push(temp);
        $$ = $1;
    }
    |   IDENTIFICADOR
    {
        var temp = new Object();
        temp.id = $1;
        temp.arreglo = false;
        var tipo = yy.getTipo(temp,@1.first_line,@1.first_column);
        temp.tipo = tipo;
        temp.linea = @1.first_line;
        temp.columna = @1.first_column;
        $$ = [];
        $$.push(temp);
    }
;

printf_c:
    PRINTF PAR_A tipos_scan_c COMA ids_c PAR_C PUNTOC
    {
        var temp = new Object();
        temp.tipo = "printf";
        temp.tipo_scan = $3;
        temp.variable = $5;
        temp.codigo3D = "";
        temp.etiqueta = "";
        temp.cuadruplas = [];
        var obj = new Object();
        obj.id = $5.length;
        var texto = $3.texto;
        var scan = $3.scan;
        var textotemp = "";
        var esperando = false;
        var ids = $5;
        var conteo_ids = 0;
        for (var i = 1; i < (texto.length-1); i++){
            if (esperando){
                if (texto.charAt(i)!='c' || texto.charAt(i)!='d' || texto.charAt(i)!='f'){
                    var tip = "char";
                    tip = (texto.charAt(i)=='d')?"int":"char";
                    tip = (texto.charAt(i)=='f')?"float":tip;
                    textotemp += texto.charAt(i)+"";
                    if (ids.length > conteo_ids){
                        if (ids[conteo_ids].tipo == tip){
                            temp.cuadruplas.push(new yy.Cuadrupla("printf",textotemp,ids[conteo_ids].id,null));
                            conteo_ids++;
                        } else {
                            agregarErrores(ids[conteo_ids].id,"SEMANTICO","Los tipos no coinciden para imprimir la variable "+ids[conteo_ids].id,ids[conteo_ids].linea,ids[conteo_ids].columna);
                            conteo_ids++;
                        }
                    } else {
                        agregarErrores(texto,"SEMANTICO","No coinciden el numero de variables",@2.last_line,@2.last_column);
                    }
                    textotemp = "";
                } else {
                    textotemp += texto.charAt(i)+"";
                }
                esperando=false;
            } else {
                if (texto.charAt(i)!='%'){
                    textotemp += texto.charAt(i)+"";
                } else {
                    textotemp += texto.charAt(i)+"";
                    esperando = true;
                }
            }
        }
        if (textotemp!=""){
            temp.cuadruplas.push(new yy.Cuadrupla("printf",textotemp,null,null));
        } else {
            if (conteo_ids<ids.length){
                agregarErrores(texto,"SEMANTICO","No coinciden el numero de variables",@2.last_line,@2.last_column);
            }
        }
        $$ = temp;
    }
    |   PRINTF PAR_A STRING PAR_C PUNTOC
    {
        var temp = new Object();
        temp.cuadruplas = [];
        temp.cuadruplas.push(new yy.Cuadrupla("printf",$3,null,null));
        $$ = temp;
    }
;

tipos_scan_c:
    SCANINT
    {
        var temp = new Object();
        temp.scan = "int";
        temp.texto = $1;
        $$ = temp;
    }
    |   SCANCHAR
    {
        var temp = new Object();
        temp.scan = "char";
        temp.texto = $1;
        $$ = temp;
    }
    |   SCANFLOAT
    {
        var temp = new Object();
        temp.scan = "float";
        temp.texto = $1;
        $$ = temp;
    }
;

expresion_c:
    expresion_c SUMA expresion_c
        { 
            if ($1.tipo == 'error' || $3.tipo == 'error'){
                $$.tipo = 'error';
            } else {
                var res = ($1.tipo=='float' || $3.tipo =='float')?'float':'int';
                $$ = new Object();
                $$.tipo = res;
                $$.codigo3D = $1.codigo3D + $3.codigo3D + res +" t"+ yy.etiquetas+" = "+$1.etiqueta+" + "+$3.etiqueta+";\n";
                $$.etiqueta = "t"+yy.etiquetas;
                $$.cuadruplas = [];
                Array.prototype.push.apply($$.cuadruplas,$1.cuadruplas);
                Array.prototype.push.apply($$.cuadruplas,$3.cuadruplas);
                $$.cuadruplas.push(new yy.Cuadrupla("+",$1.etiqueta,$3.etiqueta,$$.etiqueta));
                yy.etiquetas++;
            }
        }
    |   expresion_c POR expresion_c
        { 
            if ($1.tipo == 'error' || $3.tipo == 'error'){
                $$.tipo = 'error';
            } else {
                var res = ($1.tipo=='float' || $2.tipo =='float')?'float':'int';
                $$ = new Object();
                $$.tipo = res;
                $$.codigo3D = $1.codigo3D + $3.codigo3D + res +" t"+ yy.etiquetas+" = "+$1.etiqueta+" * "+$3.etiqueta+";\n";
                $$.etiqueta = "t"+yy.etiquetas;
                $$.cuadruplas = [];
                console.log($1.cuadruplas);
                Array.prototype.push.apply($$.cuadruplas,$1.cuadruplas);
                Array.prototype.push.apply($$.cuadruplas,$3.cuadruplas);
                $$.cuadruplas.push(new yy.Cuadrupla("*",$1.etiqueta,$3.etiqueta,$$.etiqueta));
                yy.etiquetas++;
            }
        }
    |   expresion_c ENTRE expresion_c
        { 
            if ($1.tipo == 'error' || $3.tipo == 'error'){
                $$.tipo = 'error';
            } else {
                var res = ($1.tipo=='float' || $2.tipo =='float')?'float':'int';
                $$ = new Object();
                $$.tipo = res;
                $$.codigo3D = $1.codigo3D + $3.codigo3D + res +" t"+ yy.etiquetas+" = "+$1.etiqueta+" / "+$3.etiqueta+";\n";
                $$.etiqueta = "t"+yy.etiquetas;
                $$.cuadruplas = [];
                Array.prototype.push.apply($$.cuadruplas,$1.cuadruplas);
                Array.prototype.push.apply($$.cuadruplas,$3.cuadruplas);
                $$.cuadruplas.push(new yy.Cuadrupla("/",$1.etiqueta,$3.etiqueta,$$.etiqueta));
                yy.etiquetas++;
            }
        }
    |   expresion_c MOD expresion_c
        { 
            if ($1.tipo == 'error' || $3.tipo == 'error'){
                $$.tipo = 'error';
            } else {
                var res = ($1.tipo=='float' || $2.tipo =='float')?'float':'int';
                $$ = new Object();
                $$.tipo = res;
                $$.codigo3D = $1.codigo3D + $3.codigo3D + res +" t"+ yy.etiquetas+" = "+$1.etiqueta+" % "+$3.etiqueta+";\n";
                $$.etiqueta = "t"+yy.etiquetas;
                $$.cuadruplas = [];
                Array.prototype.push.apply($$.cuadruplas,$1.cuadruplas);
                Array.prototype.push.apply($$.cuadruplas,$3.cuadruplas);
                $$.cuadruplas.push(new yy.Cuadrupla("%",$1.etiqueta,$3.etiqueta,$$.etiqueta));
                yy.etiquetas++;
            }
        }
    |   expresion_c RESTA expresion_c
        { 
            if ($1.tipo == 'error' || $3.tipo == 'error'){
                $$.tipo = 'error';
            } else {
                var res = ($1.tipo=='float' || $2.tipo =='float')?'float':'int';
                $$ = new Object();
                $$.tipo = res;
                $$.codigo3D = $1.codigo3D + $3.codigo3D + res +" t"+ yy.etiquetas+" = "+$1.etiqueta+" - "+$3.etiqueta+";\n";
                $$.etiqueta = "t"+yy.etiquetas;
                $$.cuadruplas = [];
                Array.prototype.push.apply($$.cuadruplas,$1.cuadruplas);
                Array.prototype.push.apply($$.cuadruplas,$3.cuadruplas);
                $$.cuadruplas.push(new yy.Cuadrupla("-",$1.etiqueta,$3.etiqueta,$$.etiqueta));
                yy.etiquetas++;
            }
        }
    |   RESTA expresion_c
    %prec UMINUS
        { 
            if ($2.tipo == 'error'){
                $$.tipo = 'error';
            } else {
                var res = $2.tipo;
                $$ = new Object();
                $$.tipo = res;
                $$.codigo3D = $2.codigo3D + res +" t"+ yy.etiquetas+" = -"+$2.etiqueta+" ;\n";
                $$.etiqueta = "t"+yy.etiquetas;
                $$.cuadruplas = [];
                Array.prototype.push.apply($$.cuadruplas,$2.cuadruplas);
                $$.cuadruplas.push(new yy.Cuadrupla("negativo",$2.etiqueta,null,$$.etiqueta));
                yy.etiquetas++;
            }
        }
    |   expresion_c MAYOR expresion_c
        { 
            if ($1.tipo == 'error' || $3.tipo == 'error'){
                $$.tipo = 'error';
            } else {
                var res = 'int';
                $$ = new Object();
                $$.tipo = 'int';
                $$.codigo3D = $1.codigo3D + $3.codigo3D + res +" t"+ yy.etiquetas+" = "+$1.etiqueta+" > "+$3.etiqueta+";\n";
                $$.etiqueta = "t"+yy.etiquetas;
                $$.cuadruplas = [];
                Array.prototype.push.apply($$.cuadruplas,$1.cuadruplas);
                Array.prototype.push.apply($$.cuadruplas,$3.cuadruplas);
                $$.cuadruplas.push(new yy.Cuadrupla(">",$1.etiqueta,$3.etiqueta,$$.etiqueta));
                yy.etiquetas++;
            }
        }
    |   expresion_c MENOR expresion_c
        { 
            if ($1.tipo == 'error' || $3.tipo == 'error'){
                $$.tipo = 'error';
            } else {
                $$ = new Object();
                $$.tipo = 'int';
                $$.codigo3D = $1.codigo3D + $3.codigo3D + $$.tipo +" t"+ yy.etiquetas+" = "+$1.etiqueta+" < "+$3.etiqueta+";\n";
                $$.etiqueta = "t"+yy.etiquetas;
                $$.cuadruplas = [];
                Array.prototype.push.apply($$.cuadruplas,$1.cuadruplas);
                Array.prototype.push.apply($$.cuadruplas,$3.cuadruplas);
                $$.cuadruplas.push(new yy.Cuadrupla("<",$1.etiqueta,$3.etiqueta,$$.etiqueta));
                yy.etiquetas++;
            }
        }
    |   expresion_c IGUAL_IGUAL expresion_c
        { 
            if ($1.tipo == 'error' || $3.tipo == 'error'){
                $$.tipo = 'error';
            } else {
                var res = 'int';
                $$ = new Object();
                $$.tipo = 'int';
                $$.codigo3D = $1.codigo3D + $3.codigo3D + res +" t"+ yy.etiquetas+" = "+$1.etiqueta+" == "+$3.etiqueta+";\n";
                $$.etiqueta = "t"+yy.etiquetas;
                $$.cuadruplas = [];
                Array.prototype.push.apply($$.cuadruplas,$1.cuadruplas);
                Array.prototype.push.apply($$.cuadruplas,$3.cuadruplas);
                $$.cuadruplas.push(new yy.Cuadrupla("==",$1.etiqueta,$3.etiqueta,$$.etiqueta));
                yy.etiquetas++;
            }
        }
    |   expresion_c DIFF expresion_c
        { 
            if ($1.tipo == 'error' || $3.tipo == 'error'){
                $$.tipo = 'error';
            } else {
                var res = 'int';
                $$ = new Object();
                $$.tipo = 'int';
                $$.codigo3D = $1.codigo3D + $3.codigo3D + res +" t"+ yy.etiquetas+" = "+$1.etiqueta+" != "+$3.etiqueta+";\n";
                $$.etiqueta = "t"+yy.etiquetas;
                $$.cuadruplas = [];
                Array.prototype.push.apply($$.cuadruplas,$1.cuadruplas);
                Array.prototype.push.apply($$.cuadruplas,$3.cuadruplas);
                $$.cuadruplas.push(new yy.Cuadrupla("!=",$1.etiqueta,$3.etiqueta,$$.etiqueta));
                yy.etiquetas++;
            }
        }
    |   expresion_c AND expresion_c
        { 
            if ($1.tipo == 'error' || $3.tipo == 'error'){
                $$.tipo = 'error';
            } else {
                var res = 'int';
                $$ = new Object();
                $$.tipo = 'int';
                $$.codigo3D = $1.codigo3D + $3.codigo3D + res +" t"+ yy.etiquetas+" = "+$1.etiqueta+" && "+$3.etiqueta+";\n";
                $$.etiqueta = "t"+yy.etiquetas;
                $$.cuadruplas = [];
                Array.prototype.push.apply($$.cuadruplas,$1.cuadruplas);
                Array.prototype.push.apply($$.cuadruplas,$3.cuadruplas);
                $$.cuadruplas.push(new yy.Cuadrupla("&&",$1.etiqueta,$3.etiqueta,$$.etiqueta));
                yy.etiquetas++;
            }
        }
    |   expresion_c OR expresion_c
        { 
            if ($1.tipo == 'error' || $3.tipo == 'error'){
                $$.tipo = 'error';
            } else {
                var res = 'int';
                $$ = new Object();
                $$.tipo = 'int';
                $$.codigo3D = $1.codigo3D + $3.codigo3D + res +" t"+ yy.etiquetas+" = "+$1.etiqueta+" || "+$3.etiqueta+";\n";
                $$.etiqueta = "t"+yy.etiquetas;
                $$.cuadruplas = [];
                Array.prototype.push.apply($$.cuadruplas,$1.cuadruplas);
                Array.prototype.push.apply($$.cuadruplas,$3.cuadruplas);
                $$.cuadruplas.push(new yy.Cuadrupla("||",$1.etiqueta,$3.etiqueta,$$.etiqueta));
                yy.etiquetas++;
            }
        }
    |   PAR_A expresion_c PAR_C
        { 
            if ($2.tipo == 'error'){
                $$.tipo = 'error';
            } else {
                $$ = new Object();
                $$.tipo = 'int';
                $$.cuadruplas = [];
                Array.prototype.push.apply($$.cuadruplas,$2.cuadruplas);
                $$.codigo3D = $2.codigo3D;
            }
        }
    |   NOT expresion_c
        { 
            if ($2.tipo == 'error'){
                $$.tipo = 'error';
            } else {
                $$ = new Object();
                $$.tipo = 'int';
                $$.codigo3D = $2.codigo3D + res +" t"+ yy.etiquetas+" = !"+$2.etiqueta+" ;\n";
                $$.etiqueta = "t"+yy.etiquetas;
                $$.cuadruplas = [];
                Array.prototype.push.apply($$.cuadruplas,$2.cuadruplas);
                $$.cuadruplas.push(new yy.Cuadrupla("!",$2.etiqueta,null,"t"+ yy.etiquetas));
                yy.etiquetas++;
            }
        }
    |   dato
        { 
            $$ = $1; 
            var obj = new Object();
            obj.etiqueta = $$.valor; 
            obj.tipo = $$.tipo; 
            obj.codigo3D = ""; 
            obj.cuadruplas = [];
            $$ = obj;
        }
    |   IDENTIFICADOR
        { 
            var temp = new Object();
            temp.id = $1;
            temp.arreglo = false;
            var tipo1 = yy.getTipo(temp,@1.first_line,@1.first_column);
            var obj = new Object();
            obj.valor = $1;
            obj.respuesta = $1;
            obj.tipo = tipo1;
            obj.cuadruplas = [];
            obj.codigo3D = "";
            obj.etiqueta = $1;
            $$ = obj;
        }
    |   IDENTIFICADOR dimensiones
        { 
            var obj = new Object();
            obj.valor = $1;
            obj.respuesta = $1;
            //codigo para averiguar si es arreglo y su tipo
            var temp = new Object();
            temp.id = $1;
            temp.arreglo = true;
            var tipo1 = yy.getTipo(temp,@1.first_line,@1.first_column);
            //fin del codigo
            obj.tipo = tipo1;
            obj.cuadruplas = [];
            Array.prototype.push.apply(obj.cuadruplas, $2.cuadruplas);
            obj.codigo3D = $2.codigo3D;
            obj.codigo3D += "int t"+ yy.etiquetas+" = " +$1+"["+ $2.etiqueta+"];\n";
            obj.cuadruplas.push(new yy.Cuadrupla("e=[]",$1,$2.etiqueta,"t"+ yy.etiquetas));
            obj.etiqueta = "t"+ yy.etiquetas;
            yy.etiquetas++;
            $$ = obj;
        }
;

switch_c:
    SWITCH PAR_A IDENTIFICADOR PAR_C LLAVE_A lista_casos_c default_c LLAVE_C
    {
        var tem = new Object();
        tem.id = $3;
        tem.arreglo = false;
        var tipo = yy.getTipo(tem,@3.first_line,@3.first_column);
        var eti = "L"+yy.bloques;
        var sentencias = "goto "+eti+";\n";
        //codigo para cuadruplas
        tem.cuadruplas = [];
        var cut1 = [];
        var cut2 = [];
        cut1.push(new yy.Cuadrupla("goto",eti,null,null));
        cut2.push(new yy.Cuadrupla("etiqueta",eti,null,null));
        //fin codigo para cuadruplas
        var condiciones = eti+":\n";
        yy.bloques++;
        for (var i = 0; i < $6.length; i++){
            var ca = $6[i];
            if (ca.tipo==tipo){
                var eti2 = "L"+yy.bloques;
                cut1.push(new yy.Cuadrupla("etiqueta",eti2,null,null));
                Array.prototype.push.apply(cut1,ca.sentencias.cuadruplas);
                cut2.push(new yy.Cuadrupla("==",$3,ca.dato,"t"+yy.etiquetas));
                cut2.push(new yy.Cuadrupla("if","t"+yy.etiquetas,eti2,null));
                yy.etiquetas++;
                yy.bloques++;
                if (i==($6.length-1) && ($7==null)){
                    var te2 = ca.sentencias.cuadruplas;
                    var tiene = false;
                    for (var q = 0; q < te2.length; q++){
                        if (te2[q].operacion=="break"){
                            tiene = true;
                            break;
                        }
                    }
                    if (!tiene){
                        cut1.push(new yy.Cuadrupla("break",null,null,null));
                    }
                }
            } else {
                agregarErrores(ca.dato,"SEMANTICO","Comparación invalida entre datos "+tipo+" y "+ca.tipo,ca.linea,ca.columna);
            }
        }
        if ($7!=null){
            var eti3 = "L"+yy.bloques;
            cut1.push(new yy.Cuadrupla("etiqueta",eti3,null,null));
            Array.prototype.push.apply(cut1,$7.sentencias.cuadruplas);
            cut2.push(new yy.Cuadrupla("goto",eti3,null,null));
            yy.bloques++;
            var ter2 = $7.sentencias.cuadruplas;
            var tiene2 = false;
            for (var q = 0; q < ter2.length; q++){
                if (ter2[q].operacion=="break"){
                    tiene2 = true;
                    break;
                }
            }
            if (!tiene2){
                cut1.push(new yy.Cuadrupla("break",null,null,null));
            }
        }
        var etiFinal = "L"+yy.bloques;
        cut2.push(new yy.Cuadrupla("etiqueta",etiFinal,null,null));
        for (var p = 0; p<cut1.length; p++){
            if (cut1[p].operacion=="break" && cut1[p].argumento1==null){
                cut1[p].operacion = "goto";
                cut1[p].argumento1 = etiFinal;
            }
        }
        yy.bloques++;
        Array.prototype.push.apply(cut1,cut2);
        tem.cuadruplas = cut1;
        $$ = tem;
    }
;

lista_casos_c:
    lista_casos_c caso_c
    {
        $1.push($2);
        $$ = $1;
    }
    |   caso_c
    {
        $$ = [];
        $$.push($1);
    }
;

caso_c:
    CASE dato DOS_P lista_sentencias_c
    {
        var obj = new Object();
        obj.tipo = $2.tipo;
        obj.dato = $2.valor;
        obj.sentencias = $4;
        obj.linea = $2.linea;
        obj.columna = $2.columna;
        $$ = obj;
    }
;

default_c:
    {
        $$ = null;
    }
    |   DEFAULT DOS_P lista_sentencias_c
    {
        $$ = new Object();
        $$.sentencias = $3;
    }
;

do_while_c:
    DO LLAVE_A lista_sentencias_c LLAVE_C WHILE PAR_A expresion_c PAR_C PUNTOC
    {
        var temp = new Object();
        temp.sentencias = $3;
        temp.condicion = $7;
        temp.codigo3D = "";
        temp.etiqueta = "";
        temp.cuadruplas = [];
        if ($3!=null){
            var eti = "L"+yy.bloques;
            temp.codigo3D += eti+":\n";
            temp.codigo3D += $3.codigo3D;
            temp.codigo3D += $7.codigo3D+"if ("+$7.etiqueta+") goto "+eti+";\n";
            temp.cuadruplas.push(new yy.Cuadrupla("etiqueta",eti,null,null));
            Array.prototype.push.apply(temp.cuadruplas,$3.cuadruplas);
            Array.prototype.push.apply(temp.cuadruplas,$7.cuadruplas);
            yy.bloques++;
            var eti2 = "L"+yy.bloques;
            temp.codigo3D += eti2+":\n";
            for (var a = 0; a < temp.cuadruplas.length; a++){
                if (temp.cuadruplas[a].operacion == "break"){
                    temp.cuadruplas[a].operacion = "goto";
                    temp.cuadruplas[a].argumento1 = eti2;
                } else if (temp.cuadruplas[a].operacion == "continue"){
                    temp.cuadruplas[a].operacion = "goto";
                    temp.cuadruplas[a].argumento1 = eti;
                }
            }
            temp.cuadruplas.push(new yy.Cuadrupla("if",$7.etiqueta,eti,null));
            temp.cuadruplas.push(new yy.Cuadrupla("etiqueta",eti2,null,null));
        } else {
            temp.codigo3D ="";
        }
        $$ = temp;
    }
;

if_c:
	IF PAR_A expresion_c PAR_C LLAVE_A lista_sentencias_c LLAVE_C
    {
        var temp = new Object();
        temp.tipo_if = "if";
        temp.sentencias_if = $6;
        temp.condicion = $3;
        temp.cuadruplas = $3.cuadruplas;
        if ($6!=null){
            var eti = "L"+yy.bloques;
            temp.codigo3D = "";
            temp.codigo3D+=$3.codigo3D+"if (!"+$3.etiqueta+") goto "+eti+";\n";
            temp.codigo3D+=$6.codigo3D+""+eti+":\n";
            //codigo para cuadruplas
            temp.cuadruplas.push(new yy.Cuadrupla("ifFalse",$3.etiqueta,eti,null));
            Array.prototype.push.apply(temp.cuadruplas,$6.cuadruplas);
            temp.cuadruplas.push(new yy.Cuadrupla("etiqueta",eti,null,null));
            //fin de codigo para cuadruplas
            yy.bloques++;
        }
        $$ = temp;
    }
	|	IF PAR_A expresion_c PAR_C LLAVE_A lista_sentencias_c LLAVE_C ELSE LLAVE_A lista_sentencias_c LLAVE_C
    {
        var temp = new Object();
        temp.tipo_if = "if-else";
        temp.sentencias_if = $6;
        temp.sentencias_else = $10;
        temp.condicion = $3;
        temp.cuadruplas = $3.cuadruplas;
        if ($6!=null){
            var eti = "L"+yy.bloques;
            temp.codigo3D = "";
            temp.codigo3D+=$3.codigo3D+"if (!"+$3.etiqueta+") goto "+eti+";\n";
            temp.codigo3D+=$6.codigo3D;
            //codigo para cuadruplas
            temp.cuadruplas.push(new yy.Cuadrupla("ifFalse",$3.etiqueta,eti,null));
            Array.prototype.push.apply(temp.cuadruplas,$6.cuadruplas);
            //fin de codigo para cuadruplas
            yy.bloques++;
            if ($10!=null){
                var eti2 = "L"+yy.bloques;
                yy.bloques++;
                temp.codigo3D+="goto "+eti2+";\n";
                temp.codigo3D+=eti+":\n";
                temp.codigo3D+=$10.codigo3D;
                temp.codigo3D+=eti2+":\n";
                //codigo para cuadruplas
                temp.cuadruplas.push(new yy.Cuadrupla("goto",eti2,null,null));
                temp.cuadruplas.push(new yy.Cuadrupla("etiqueta",eti,null,null));
                Array.prototype.push.apply(temp.cuadruplas,$10.cuadruplas);
                temp.cuadruplas.push(new yy.Cuadrupla("etiqueta",eti2,null,null));
                //fin de codigo para cuadruplas
            } else {
                temp.codigo3D+=eti+":\n"
                temp.cuadruplas.push(new yy.Cuadrupla("etiqueta",eti,null,null));
            }
        }
        $$ = temp;
    }
;

for_c:
	FOR PAR_A declaracion_for_c PUNTOC expresion_c PUNTOC inc_dec_c PAR_C LLAVE_A lista_sentencias_c LLAVE_C
    {
        var temp = new Object();
        temp.declaracion = $3;
        temp.sentencias = $10;
        temp.cambio = $7;
        temp.condicion = $5;
        temp.cuadruplas = $3.cuadruplas;
        if ($10!=null){
            temp.codigo3D = "";
            temp.codigo3D += $3.codigo3D;
            var eti = "L"+yy.bloques;
            yy.bloques++;
            temp.codigo3D += eti+":\n";
            var eti2 = "L"+yy.bloques;
            yy.bloques++;
            temp.codigo3D += $5.codigo3D+"if (!"+$5.etiqueta+") goto "+eti2+" ;\n";
            
            temp.cuadruplas.push(new yy.Cuadrupla("etiqueta",eti,null,null));
            Array.prototype.push.apply(temp.cuadruplas,$5.cuadruplas);
            temp.cuadruplas.push(new yy.Cuadrupla("ifFalse",$5.etiqueta,eti2,null));
            Array.prototype.push.apply(temp.cuadruplas,$10.cuadruplas);
            Array.prototype.push.apply(temp.cuadruplas,$7.cuadruplas);
            temp.cuadruplas.push(new yy.Cuadrupla("goto",eti,null,null));
            temp.cuadruplas.push(new yy.Cuadrupla("etiqueta",eti2,null,null));
            for (var a = 0; a < temp.cuadruplas.length; a++){
                if (temp.cuadruplas[a].operacion == "break"){
                    temp.cuadruplas[a].operacion = "goto";
                    temp.cuadruplas[a].argumento1 = eti2;
                } else if (temp.cuadruplas[a].operacion == "continue"){
                    temp.cuadruplas[a].operacion = "goto";
                    temp.cuadruplas[a].argumento1 = eti;
                }
            }
            temp.codigo3D += $10.codigo3D;
            temp.codigo3D += $7.codigo3D;
            temp.codigo3D += "goto "+eti+";\n";
            temp.codigo3D += eti2+":\n";
        } else {
            temp.codigo3D = "";
        }
        $$ = temp;
    }
;

while_c:
	WHILE PAR_A expresion_c PAR_C LLAVE_A lista_sentencias_c LLAVE_C
    {
        var temp = new Object();
        temp.sentencias = $6;
        temp.condicion = $3;
        temp.cuadruplas = [];
        if ($6!=null){
            var eti = "L"+yy.bloques;
            yy.bloques++;
            var eti2 = "L"+yy.bloques;
            temp.codigo3D = "";
            temp.codigo3D += eti+":\n";

            temp.cuadruplas.push(new yy.Cuadrupla("etiqueta",eti,null,null));
            Array.prototype.push.apply(temp.cuadruplas,$3.cuadruplas);
            temp.cuadruplas.push(new yy.Cuadrupla("ifFalse",$3.etiqueta,eti2,null));
            Array.prototype.push.apply(temp.cuadruplas,$6.cuadruplas);
            temp.cuadruplas.push(new yy.Cuadrupla("goto",eti,null,null));
            temp.cuadruplas.push(new yy.Cuadrupla("etiqueta",eti2,null,null));
            for (var a = 0; a < temp.cuadruplas.length; a++){
                if (temp.cuadruplas[a].operacion == "break"){
                    temp.cuadruplas[a].operacion = "goto";
                    temp.cuadruplas[a].argumento1 = eti2;
                } else if (temp.cuadruplas[a].operacion == "continue"){
                    temp.cuadruplas[a].operacion = "goto";
                    temp.cuadruplas[a].argumento1 = eti;
                }
            }
            temp.codigo3D+=$3.codigo3D+"if (!"+$3.etiqueta+") goto "+eti2+";\n";
            temp.codigo3D+=$6.codigo3D;
            temp.codigo3D+="goto "+eti+" ;\n";
            temp.codigo3D+=eti2+":\n";
        } else {
            temp.codigo3D = "";
        }
        $$ = temp;
    }
;

inc_dec_c:
	IDENTIFICADOR MAS
    {
        var temp = new Object();
        temp.tipo_cambio = "incremento";
        temp.valor = $1;
        temp.codigo3D = "";
        temp.codigo3D += $1 + " = " + $1 + " + 1 ;\n";
        temp.cuadruplas = [];
        temp.cuadruplas.push(new yy.Cuadrupla("+",$1,1,$1));
        $$ = temp;
    }
	| IDENTIFICADOR MENOS
    {
        var temp = new Object();
        temp.tipo_cambio = "decremento";
        temp.valor = $1;
        temp.codigo3D = "";
        temp.codigo3D += $1 + " = " + $1 + " - 1 ;\n";
        temp.cuadruplas = [];
        temp.cuadruplas.push(new yy.Cuadrupla("-",$1,1,$1));
        $$ = temp;
    }
;

declaracion_for_c:
	INT IDENTIFICADOR IGUAL expresion_c
    {
        var objeto = new Object();
        objeto.id = $2;
        objeto.tipo = "int";
        objeto.constante = false;
        objeto.tamanio = 1;
        objeto.arreglo = false;
        objeto.rol = "variable";
        objeto.codigo3D = $4.codigo3D+" "+$1+" "+$2+" = "+$4.etiqueta+";\n";
        objeto.etiqueta = "";
        objeto.cuadruplas = $4.cuadruplas;
        objeto.cuadruplas.push(new yy.Cuadrupla("d=",$4.etiqueta,null,$2));
        yy.addSimbolos(objeto,@2.first_line,@2.first_column);
        $$ = objeto;
    }
    |   IDENTIFICADOR IGUAL expresion_c
    {
        var objeto = new Object();
        objeto.id = $1;
        objeto.tipo = "int";
        objeto.constante = false;
        objeto.tamanio = 1;
        objeto.arreglo = false;
        objeto.rol = "variable";
        objeto.cuadruplas = $3.cuadruplas;
        objeto.cuadruplas.push(new yy.Cuadrupla("=",$3.etiqueta,null,$1));
        objeto.codigo3D = $3.codigo3D+" "+$1+" = "+$3.etiqueta+";\n";
        objeto.etiqueta = "";
        $$ = objeto;
    }
;

declaracion_c:
    tipos_datos IDENTIFICADOR IGUAL expresion_c PUNTOC
    {
        var objeto = new Object();
        objeto.id = $2;
        objeto.tipo = $1;
        objeto.constante = false;
        objeto.tamanio = 1;
        objeto.arreglo = false;
        objeto.rol = "variable";
        objeto.codigo3D = $4.codigo3D+$1+" "+$2+" = "+$4.etiqueta+";\n";
        objeto.etiqueta = "";
        objeto.cuadruplas = $4.cuadruplas;
        objeto.cuadruplas.push(new yy.Cuadrupla("d=",$4.etiqueta,null,$2));
        yy.addSimbolos(objeto,@2.first_line,@2.first_column);
        $$ = objeto;
    }
    |   tipos_datos IDENTIFICADOR dimensiones PUNTOC
    {
        var objeto = new Object();
        objeto.id = $2;
        objeto.tipo = $1;
        objeto.constante = false;
        objeto.tamanio = 1;
        objeto.arreglo = true;
        objeto.rol = "variable";
        objeto.codigo3D = $3.codigo3D+$1+" "+$2+"["+$3.etiqueta+"];\n";
        objeto.etiqueta = "";
        objeto.cuadruplas = $3.cuadruplas;
        objeto.cuadruplas.push(new yy.Cuadrupla("d=[]",$2,$3.etiqueta,null));
        yy.addSimbolos(objeto,@2.first_line,@2.first_column);
        $$ = objeto;
    }
;

asignacion_c:
    IDENTIFICADOR IGUAL expresion_c PUNTOC
    {
        var temp = new Object();
        temp.codigo3D = $3.codigo3D + $1 + " = "+$3.etiqueta+" ;\n";
        temp.etiqueta = "";
        temp.cuadruplas = $3.cuadruplas;
        temp.cuadruplas.push(new yy.Cuadrupla("=",$3.etiqueta,null,$1));
        console.log(temp.cuadruplas);
        $$ = temp;
    }
    |   IDENTIFICADOR dimensiones IGUAL expresion_c PUNTOC
    {
        var temp = new Object();
        temp.codigo3D = $2.codigo3D+$4.codigo3D + $1 + "["+$2.etiqueta+"] = "+$4.etiqueta+" ;\n";
        temp.etiqueta = "";
        temp.cuadruplas = [];
        Array.prototype.push.apply($2.cuadruplas, $4.cuadruplas);
        Array.prototype.push.apply(temp.cuadruplas, $4.cuadruplas);
        temp.cuadruplas.push(new yy.Cuadrupla("=[]",$2.etiqueta,$4.etiqueta,$1));
        console.log(temp.cuadruplas);
        $$ = temp;
    }
;

includes:
    {
        $$ = null;
    }
    |   lista_includes
    {
        $$ = $1;
    }
;

lista_includes:
    lista_includes include
    {
        Array.prototype.push.apply($1,$2);
        $$ = $1;
    }
    |   include
    {
        $$ = $1;
    }
;

include:
    INCLUDE tipos_include
    {
        $$ = $2.cuadruplas;
    }
;

tipos_include:
    TODOPY
    {
        var temp = new Object();
        temp.cuadruplas = [];
        temp.cuadruplas.push(new yy.Cuadrupla("PY","TODO",null,null));
        $$ = temp;
    }
    |   ESPY
    {
        var temp = new Object();
        temp.cuadruplas = [];
        var strs = $1.split(".");
        temp.cuadruplas.push(new yy.Cuadrupla("PY","FUNCION",strs[1],strs[2]));
        $$ = temp;
    }
    |   TODOJAVA
    {
        var temp = new Object();
        temp.cuadruplas = [];
        temp.cuadruplas.push(new yy.Cuadrupla("JAVA","TODO",null,null));
        $$ = temp;
    }
    |   JAVAARCHIVO
    {
        var temp = new Object();
        temp.cuadruplas = [];
        var strs = $1.split(".");
        temp.cuadruplas.push(new yy.Cuadrupla("JAVA","ARCHIVO",strs[1],strs[2]));
        $$ = temp;
    }
    |   JAVACLASE
    {
        var temp = new Object();
        temp.cuadruplas = [];
        var strs = $1.split(".");
        temp.cuadruplas.push(new yy.Cuadrupla("JAVA","CLASE",strs[1],null));
        $$ = temp;
    }
    |   JAVACLASES
    {
        var temp = new Object();
        temp.cuadruplas = [];
        var strs = $1.split(".");
        temp.cuadruplas.push(new yy.Cuadrupla("JAVA","CLASES",strs[1],strs[2]));
        $$ = temp;
    }
;

codigo_java:
    {
        yy.simbolos = [];
    }
    |   clases
    {
        yy.simbolos = [];
    }
;

clases:
    clases clase
    | clase
;
clase:
    'public' 'class' IDENTIFICADOR herencia '{' body_classp '}'
;

body_classp:
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
    {
        var temp = new Object();
        temp.cuadruplas = [];
        temp.cuadruplas.push("continue",null,null,null);
        $$ = temp;
    }
    | 'break' ';'
    {
        var temp = new Object();
        temp.cuadruplas = [];
        temp.cuadruplas.push("break",null,null,null);
        $$ = temp;
    }
    | 'return' expresion_java ';'
    {
        var temp = new Object();
        temp.cuadruplas = [];
        temp.cuadruplas.push("continue",null,null,null);
        $$ = temp;
    }
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
    | IDENTIFICADOR MAS_ASIGNAR expresion_java ';'
    | IDENTIFICADOR MAS ';'
    | IDENTIFICADOR MENOS ';'
    | IDENTIFICADOR ASIGNAR tipo_input_java '(' ')' ';'
;

tipo_input_java:
    'intinput'
    {
        var temp = new Object();
        temp.tipo = "int";
        $$ = temp;
    }
    |   'floatinput'
    {
        var temp = new Object();
        temp.tipo = "float";
        $$ = temp;
    }
    |   'charinput'
    {
        var temp = new Object();
        temp.tipo = "char";
        $$ = temp;
    }
;

declaracion_cola_java:
    {
        $$ = [];
    }
    | ASIGNAR expresion_java
    {
        $$ = $2.cuadruplas;
    }
;

valor_java:
    INT
    {
        var temp = new Object();
        temp.tipo = "int";
        temp.valor = parseInt($1);
        temp.columna = @1.first_column;
        temp.linea = @1.first_line;
    }
    |   STRING
    {
        var temp = new Object();
        temp.tipo = "string";
        temp.valor = $1;
        temp.columna = @1.first_column;
        temp.linea = @1.first_line;
    }
    |   FLOAT
    {
        var temp = new Object();
        temp.tipo = "float";
        temp.valor = parseInt($1);
        temp.columna = @1.first_column;
        temp.linea = @1.first_line;
    }
    |   CHAR
    {
        var temp = new Object();
        temp.tipo = "char";
        temp.valor = $1.charAt(1);
        temp.columna = @1.first_column;
        temp.linea = @1.first_line;
    }
    |   'true'
    {
        var temp = new Object();
        temp.tipo = "boolean";
        temp.valor = true;
        temp.columna = @1.first_column;
        temp.linea = @1.first_line;
    }
    |   'false'
    {
        var temp = new Object();
        temp.tipo = "boolean";
        temp.valor = false;
        temp.columna = @1.first_column;
        temp.linea = @1.first_line;
    }
;

if_java:
    IF '(' expresion_java ')' '{' listado_java '}'
    | IF '(' expresion_java ')' '{' listado_java '}' ELSE '{' listado_java '}'
    | IF '(' expresion_java ')' '{' listado_java '}' ELSE if_java
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
    {
        var temp = new Object();
        temp.cuadruplas = [];
    }
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
    {
        if ($1.tipo == 'error' || $3.tipo == 'error'){
                $$.tipo = 'error';
            } else {
                var res = ($1.tipo=='float' || $3.tipo =='float')?'float':'int';
                $$ = new Object();
                $$.tipo = res;
                $$.etiqueta = "t"+yy.etiquetas;
                $$.cuadruplas = [];
                Array.prototype.push.apply($$.cuadruplas,$1.cuadruplas);
                Array.prototype.push.apply($$.cuadruplas,$3.cuadruplas);
                $$.cuadruplas.push(new yy.Cuadrupla("+",$1.etiqueta,$3.etiqueta,$$.etiqueta));
                yy.etiquetas++;
            }
    }
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
    | valor_java
    {
        $$ = $1;
    }
    | IDENTIFICADOR '(' ')'
;

codigo_python:
    |   SALTO
    |   SALTO funciones_python
;

funciones_python:
        funciones_python funcion_python
    |   funcion_python
    ;

funcion_python:
    'def' IDENTIFICADOR '(' lista_parametros_python ')' ':' SALTO INDENT sentencias_python DEDENT
    |   error DEDENT
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
    |   IDENTIFICADOR ASIGNAR 'input' '(' ')' SALTO
    ;

valor:
    STRING
    |   FLOAT
    |   INT
    |   CHAR
    ;

for_python:
    'for' IDENTIFICADOR 'in' 'range' '(' ')' ':' SALTO INDENT sentencias_python DEDENT
;

while_python:
    'while' expresion_python ':' SALTO INDENT sentencias_python DEDENT
;

if_python
    : IF expresion_python ':' SALTO INDENT sentencias_python DEDENT               
    {
        
    }
    | IF expresion_python ':' SALTO INDENT sentencias_python DEDENT if_python_cola  
    {
        
    }
    ;
if_python_cola
    : ELSE ':' SALTO INDENT sentencias_python DEDENT
    | elif_python ELSE ':' SALTO INDENT sentencias_python DEDENT
    | elif_python
    ;
elif_python
    : ELIF expresion_python ':' SALTO INDENT sentencias_python DEDENT
    | ELIF expresion_python ':' SALTO INDENT sentencias_python DEDENT elif_python
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
    | IDENTIFICADOR
    | INT
    | STRING
    | FLOAT
    | CHAR
    | 'true'
    | 'false'
;