/* Python Parser for Jison */
/* https://docs.python.org/2.7/reference/lexical_analysis.html */
/* https://docs.python.org/2.7/reference/grammar.html */

/* lexical gammar */
%{ var indents = [0], indent = 0, dedents = 0 %}
%lex

/** identifiers **/
identifier                              ("_"|{letter})({letter}|{digit}|"_")*
letter                                  {lowercase}|{uppercase}
lowercase                               [a-z]
uppercase                               [A-Z]
digit                                   [0-9]

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

/** numbers **/
integer                                 {decinteger}|{hexinteger}|{octinteger}
decinteger                              ([1-9]{digit}*)
hexinteger                              "0"[x|X]{hexdigit}+
octinteger                              "0"[o|O]?{octdigit}+
bininteger                              "0"[b|B]({bindigit}+)
hexdigit                                {digit}|[a-fA-F]
octdigit                                [0-7]
bindigit                                [0|1]

/** floats **/
floatnumber                             {exponentfloat}|{pointfloat}
exponentfloat                           ({digit}+|{pointfloat}){exponent}
pointfloat                              ({digit}*{fraction})|({digit}+".")
fraction                                "."{digit}+
exponent                                [e|E][\+|\-]{digit}+

/** reserved **/
reserved                                {keywords}|{operators}
keywords                                "continue"|"finally"|"return"|"global"|
                                        "assert"|"except"|"import"|"lambda"|
                                        "raise"|"class"|"print"|"break"|"while"|
                                        "yield"|"from"|"elif"|"else"|"with"|
                                        "pass"|"exec"|"and"|"del"|"not"|"def"|
                                        "for"|"try"|"as"|"or"|"if"|"in"|"is"
operators                               ">>="|"<<="|"**="|"//="|"+="|"-="|"*="|
                                        "/="|"%="|"&="|"|="|"^="|"**"|"//"|"<<"|
                                        ">>"|"<="|">="|"=="|"!="|"<>"|"+"|"-"|
                                        "*"|"/"|"%"|"&"|"|"|"^"|"~"|"<"|">"|"("|
                                        ")"|"["|"]"|"{"|"}"|"@"|","|":"|"."|"`"|
                                        "="|";"|"'"|"""|"#"|"\"

%s INITIAL PYTHON DEDENTS INLINE

%%
<<EOF>>                                 return 'EOF'
<INITIAL>'%%PYTHON'                    %{ this.begin("PYTHON"); %}
<PYTHON>\                              %{ indent += 1 %}
<PYTHON>\t                             %{ indent = ( indent + 8 ) & -7 %}
<PYTHON>\n                             %{ indent = 0 // blank line %}
<PYTHON>.                              %{ 
                                            this.unput( yytext )
                                            var last = indents[ indents.length - 1 ]
                                            if ( indent > last ) {
                                                this.begin( 'INLINE' )
                                                indents.push( indent )
                                                return 'INDENT'
                                            } else if ( indent < last ) {
                                                this.begin( 'DEDENTS' )
                                                dedents = 0 // how many dedents occured
                                                while( last = indents.pop() ) {
                                                    if ( last == indent ) break
                                                    dedents += 1
                                                }
                                            } else {
                                                this.begin( 'INLINE' )
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
<INLINE>\n+                             %{ 
                                            indent = 0; 
                                            this.begin( 'INITIAL' )
                                            return 'NEWLINE' 
                                        %}
<INLINE>[\ ]+                       /* skip whitespace, separate tokens */
<INLINE>{reserved}                      %{ return yytext %}
<INLINE>{floatnumber}                   return 'NUMBER'
<INLINE>{bininteger}                    %{  
                                            // parseInt to convert to base-10
                                            var i = yytext.substr(2); // binary val
                                            yytext = 'parseInt("'+i+'",2)'
                                            return 'NUMBER'
                                        %}
<INLINE>{integer}                       return 'NUMBER'
<INLINE>{longstring}                    %{  
                                            // escape string and convert to double quotes
                                            // http://stackoverflow.com/questions/770523/escaping-strings-in-javascript
                                            var str = yytext.substr(3, yytext.length-6)
                                                .replace( /[\\"']/g, '\\$&' )
                                                .replace(/\u0000/g, '\\0');
                                            yytext = '"' + str + '"'
                                            return 'STRING'
                                        %}
<INLINE>{shortstring}                   return 'STRING'
<INLINE>{identifier}                    return 'NAME'
/lex
%start expressions
%%
/** grammar **/
expressions
    : file_input    { console.log( $1 ) }
    ;
    
// (NEWLINE | stmt)* ENDMARKER
file_input
    : EOF
    | file_input_head EOF
    ;
file_input_head
    : NEWLINE
    | funcion
    ;
funcion:
    INDENT NUMBER
;