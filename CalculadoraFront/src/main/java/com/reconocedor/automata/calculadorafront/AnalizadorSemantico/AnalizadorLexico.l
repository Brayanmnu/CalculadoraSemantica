%{
#include <stdio.h>
#include <stdlib.h>
#include "Parser.h"
FILE *f;
%}
%option outfile = "Scanner.c"
%option noyywrap
%option yylineno
IGNORA	" "|\t|\n
LETRA	[A-Za-z]
DIGITO	[0-9]
%%
{IGNORA}*		{;}
{DIGITO}+		{yylval.nombre = strdup(yytext);return(NUMERAL);}
"M+"			{yylval.nombre = strdup(yytext);return(MP);}
"MR"			{yylval.nombre = strdup(yytext);return(MR);}
"+/-"			{yylval.nombre = strdup(yytext);return(MASMENOS);}
"="         	{yylval.nombre = strdup(yytext);return(IGUAL);}
"+"             {yylval.nombre = strdup(yytext);return(SUMA);}
"-"             {yylval.nombre = strdup(yytext);return(RESTA);}
"x"             {yylval.nombre = strdup(yytext);return(MULT);}
.				{fprintf(f,"Error lexico en la linea: %d.\n",yylineno);}
%%