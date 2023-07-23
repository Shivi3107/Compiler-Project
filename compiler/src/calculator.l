%{
	#include<stdio.h>
	#include "y.tab.h"
	extern YYSTYPE yylval;
%}

%%

"print"		{ return PRINT; }
"begindecl"	{ return BGN; }
"integer"	{ return INT; }
"enddecl"	{ return END; }

[a-z][a-z0-9]* { char* p = (char*) malloc((yyleng+1) * sizeof(char));
		strcpy(p,yytext);
		yylval.sIndex = p;
		return VARIABLE; }

[0-9]+ {  yylval.iValue=atoi(yytext);
          return NUMBER;}
          
[\t]+ ;

[ ]+ ;

[\n] { ;}

. return yytext[0];
  
%%
  
int yywrap()
{
 return 1;
}
