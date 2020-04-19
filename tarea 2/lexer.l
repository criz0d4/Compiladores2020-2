%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void error(char *s);

%}

%s COMENTARIO
%x COMENTARIO2

%option yylineno
%option noyywrap

letra [a-zA-Z]
digito [0-9]
entero {digito}+
real {digito}*"."{digito}+|{digito}+"."{digito}*

id [#]({letra}|{digito})+
reservadas (@if|@else|@while)

aritmeticos ("+"|"-"|"*"|"/"|"%")
relacionales (">"|"<"|">="|"<="|"=="|"!=")
asignacion ("=")
logicos ("\/"|"^"|"~")

puntuacion ("{"|"}"|"("|")"|";"|",")
%%
	/*n Expresion Regular Accion Lexica */

<INITIAL>{reservadas}	{
			printf( "%d: Palabra reservada: %s\n",yylineno,  yytext );
		}

<INITIAL>{id}	{
	 		printf( "%d: Identificador: %s\n",yylineno,  yytext );
		}

<INITIAL>{entero} {
	 		printf( "%d: Entero: %s\n", yylineno, yytext );
		 }

<INITIAL>{real} {
	 		printf( "%d: Real: %s\n", yylineno, yytext );
		 }

<INITIAL>{aritmeticos} {
	 		printf( "%d: Op. Aritmetico: %s\n", yylineno, yytext );
		 }

<INITIAL>{relacionales} {
	 		printf( "%d: Op. Relacional: %s\n", yylineno, yytext );
		 }

<INITIAL>{asignacion} {
	 		printf( "%d: Op. de asignacion: %s\n", yylineno, yytext );
		 }

<INITIAL>{logicos} {
	 		printf( "%d: Op. Lógico: %s\n", yylineno, yytext );
		 }

<INITIAL>{puntuacion} {
	 		printf( "%d: Signo de puntuacion: %s\n", yylineno, yytext );
		 }

<INITIAL>[ \n\t\r]+ {}

<INITIAL>"/*" {BEGIN(COMENTARIO);}
<INITIAL>. { error(yytext);}

<COMENTARIO>[^*/] {}
<COMENTARIO>[*/]  {}
<COMENTARIO>"*/"	{ BEGIN(INITIAL);}

%%

void error(char *s){
	printf("%d: Sin identificar: %s\n", yylineno, s);
}

int main(int argc, char **argv){
	FILE *f;
	if(argc < 2){
		printf("Falta el archivo\n");
		exit(-1);
	}
	f = fopen(argv[1], "r");
	if(!f){
		printf("No se pudo abrir el archivo\n");
		exit(-1);
	}
	yyin = f;
	int tok = yylex();
	while(tok != 0){
		printf("<%d, \n",tok);
		tok = yylex();
	}
	fclose(yyin);
	return 0;
}