%{
# include  <string.h>
# include  "yacc.h"
# include  "rdlNumber.h"
extern int rdl_keyword_code(const char*str, unsigned nstr);
extern void yyerror (char *s);

static int comment_enter;

%}

%x CCOMMENT
%x PCOMMENT
%x LCOMMENT
%x CSTRING

%%

[ \t\b\f\r] { ; }
\n { ; }

  /* C++ style comments start with / / and run to the end of the
     current line. These are very easy to handle. */

"//".* { comment_enter = YY_START; BEGIN(LCOMMENT); }
<LCOMMENT>.    { yymore(); }
<LCOMMENT>\n   { BEGIN(comment_enter); }


  /* The contents of C-style comments are ignored, like white space. */

"/*" { comment_enter = YY_START; BEGIN(CCOMMENT); }
<CCOMMENT>.    { yymore(); }
<CCOMMENT>\n   { yymore(); }
<CCOMMENT>"*/" { BEGIN(comment_enter); }

\"            { BEGIN(CSTRING); }
<CSTRING>\\\\ { yymore(); /* Catch \\, which is a \ escaping itself */ }
<CSTRING>\\\" { yymore(); /* Catch \", which is an escaped quote */ }
<CSTRING>\n   { BEGIN(0);
                yylval.text = strdup(yytext);
                yyerror("Missing close quote of string.");
                return STRING; }
<CSTRING>\"   { BEGIN(0);
                yylval.text = strdup(yytext);
                yylval.text[strlen(yytext)-1] = 0;
                return STRING; }
<CSTRING>.    { yymore(); }

[a-zA-Z_][a-zA-Z0-9$_]* {
                          int rc = rdl_keyword_code(yytext, yyleng);
                          switch (rc) {
                            case IDENTIFIER:
                              yylval.text = strdup(yytext);
                              break;
                            default:
                              yylval.text = 0;
                              break;
                          }
                          return rc;
                        }
\\[^ \t\b\f\r\n]+       {
                          yylval.text = strdup(yytext+1);
                          return IDENTIFIER;
                        }
[0-9][0-9_]*            {
                          yylval.text = strdup(yytext);
                          return DEC_NUMBER;
                        }
0x[0-9a-fA-F]+          {
                          yylval.text = strdup(yytext);
                          return HEX_NUMBER;
                        }
\'[sS]?[dD][ \t]*[0-9][0-9_]*  {
                                 yylval.text = strdup(yytext);
                                 return BASED_NUMBER;
                               }
\'[sS]?[bB][ \t]*[0-1xzXZ_\?]+ {
                                 yylval.text = strdup(yytext);
                                 return BASED_NUMBER;
                               }
\'[sS]?[oO][ \t]*[0-7xzXZ_\?]+ {
                                 yylval.text = strdup(yytext);
                                 return BASED_NUMBER;
                               }
\'[sS]?[hH][ \t]*[0-9a-fA-FxzXZ_\?]+ {
                                       yylval.text = strdup(yytext);
                                       return BASED_NUMBER;
                                     }
"->"                    { return DREF; }
"+="                    { return INC; }
"%="                    { return INC; }
;                       { return SEMI; }
=                       { return EQ; }
@                       { return AT; }
:                       { return COLON; }
,                       { return COMA; }
\]                      { return RSQ; }
\[                      { return LSQ; }
\|                      { return OR; }
\{                      { return LBRAC; }
\}                      { return RBRAC; }
\.                      { return DOT; }

%%

int yywrap()
{
      return 1;
}
