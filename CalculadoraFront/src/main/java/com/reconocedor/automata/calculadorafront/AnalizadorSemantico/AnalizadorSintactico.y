%{
#include <stdio.h>
#include <stdlib.h>
#include "string.h"
extern int yylex(void);
extern char *yytext;
extern int yylineno;
extern FILE *yyin;
void yyerror(char *s);
int operando = 0, numDigito = 0;
int primerNumero = 0, segundoNumero = 0, memoria = 0;
void operacion(int numero,int gramatica);
void evaluar(int valor);
FILE *f;
%}

%union {
  int num;
  char* nombre;
}

%token <nombre> NUMERAL
%token <nombre> MASMENOS IGUAL SUMA RESTA MULT
%token <nombre> MP MR

%type <nombre> expression

%left SUMA RESTA MULT MP IGUAL
%right MASMENOS 

%start program 


%%

program  : exprSequence;

exprSequence:   expression  | expression exprSequence;

expression : NUMERAL 
              {
                operacion($1,1);
                $$ = $1;
                numDigito++;
              } 
            | MR
              {
                operacion($1,2);
                $$ = $1;
                numDigito++;
              }
            
            | expression SUMA expression
              {
                operacion($3,3);
                $$ = $3;
                numDigito++;
              }
            | expression RESTA expression
              {
                operacion($3,4);
                $$ = $3;
                numDigito++;
              }
            
            | expression MULT expression
              {
                operacion($3,5);
                $$ = $3;
                numDigito++;
              }
            | expression MP
              {
                operacion($1,6);
                $$ = $1;
                numDigito++;
              }
            | expression IGUAL
              {
                operacion($1,7);
                $$ = $1;
                numDigito++;
              }
            | expression MASMENOS
              {
                operacion($1,8);
                $$ = $1;
                numDigito++;
              }
             
            ;

%%

void evaluar(int valor)
{
    if(operando==0){
      primerNumero = valor;
      operando = 1;
    }else{
      segundoNumero = valor;
      operando = 0;
    }
}

void operacion(int numero,int gramatica){
  int  num = 0;
  char* aux = numero;
  num = atoi(aux);
  if(gramatica==1){
    //numeral
    if(numDigito>0){
      fprintf(f,"and then\n");
    }
    fprintf(f, "\tgive the value of %d", num);
    fprintf(f, "\tT(%d)\tC %d\n", num, memoria);
    evaluar(num);
  }else if(gramatica==2){
    //MR
    fprintf(f,"and then\n");
    fprintf(f,"\tgive Integer stored in cell1");
    num =  memoria;
    fprintf(f,"\tT(%d)\tC %d\n", num, memoria);
    if(numDigito==0)
      fprintf(f,"Error semantico MR\n");
    evaluar(num);
  }else if(gramatica==3){
    //Suma
    num = primerNumero+segundoNumero;
    fprintf(f,"then");
    fprintf(f,"\tT(%d,%d)\tC %d\n", primerNumero, segundoNumero, memoria);
    fprintf(f,"\tgive sum(the given Integer %d, the given Integer %d)", primerNumero, segundoNumero);
    fprintf(f,"\tT(%d)\tC %d\n", num, memoria);
    evaluar(num);
  }else if(gramatica==4){
    //Resta
    num = primerNumero-segundoNumero;
    fprintf(f,"then");
    fprintf(f,"\tT(%d,%d)\tC %d\n", primerNumero, segundoNumero, memoria);
    fprintf(f,"\tgive difference(the given Integer %d, the given Integer %d)", primerNumero, segundoNumero);
    fprintf(f,"\tT(%d)\tC %d\n", num, memoria);
    evaluar(num);
  }else if(gramatica==5){
    //Multiplicacion
    num = primerNumero*segundoNumero;
    fprintf(f,"then");
    fprintf(f,"\tT(%d,%d)\tC %d\n", primerNumero, segundoNumero, memoria);
    fprintf(f,"\tgive product(the given Integer %d, the given Integer %d)", primerNumero, segundoNumero);
    fprintf(f,"\tT(%d)\tC %d\n", num, memoria);
    evaluar(num);
  }else if(gramatica==6){
    //M+
    if(operando==1){
      memoria += primerNumero;
      num=primerNumero;
    }else{
      memoria += segundoNumero;
      num=segundoNumero;
    }
    fprintf(f,"then\n");
    fprintf(f,"\tstore sum(the given stored in cell1, the given Integer %d) in cell1", num);
    fprintf(f,"\tT()\tC %d\n", memoria);
    fprintf(f,"and\n");
    fprintf(f,"\tregive");
    fprintf(f,"\tT(%d)\tC %d\n", num, memoria);
  }else if(gramatica==7){
    //igual
    if(strcmp(numero,"M+")==0)
      fprintf(f,"Error semantico M+\n");
  }else if(gramatica==8){
    //+/-
    if(operando==1){
      num=primerNumero;
    }else{
      num=segundoNumero;
    }
    fprintf(f,"then\n");
    fprintf(f,"\tgive difference(0, the given Integer %d)", num);
    fprintf(f,"\tT(-%d)\tC %d\n", num, memoria);
    if(operando==1){
      primerNumero *= -1;
    }else{
      segundoNumero *= -1;
    }
  }
}

void yyerror(char *s)
{
  fprintf(f,"Error sintactico. Linea %d.\n", yylineno);
}

int main()
{
    f = fopen("resultados.txt", "w");
    yyin=fopen("codigo.txt","rt");
    yyparse();
    fclose(f);
    return 0;
}