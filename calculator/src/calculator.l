%{
	#include<stdio.h>
	#include "./include/calc3.h"
	#include "./y.tab.h"
	extern YYSTYPE yylval;
%}

%%
[0-9]+ {  yylval.iValue=atoi(yytext);
          return NUMBER;}
          
[\t]+ ;

[ ]+ ;

[\n] {
	return yytext[0];}
  
. return yytext[0];
  
%%
  
int yywrap()
{
 return 1;
}
