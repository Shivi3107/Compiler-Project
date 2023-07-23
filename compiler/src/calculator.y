%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <stdarg.h>
	#include <limits.h>
	#include <string.h>
	
	struct L{
		char* name; /* operator */
		int val; /* number of operands */
		struct L *next;
	};

	struct tree{
		char* val;
		int x;
		struct tree *left;
		struct tree *right;
	};
	
	/* prototypes */
	int opr(int oper, int a, int b);
	int yylex(void);

	void yyerror(char *s);
	struct L *first;
	struct L *lst;
	void decl(char *p);
	int find(char *p);
	void ini(char *p, int x);
	void prn(char *p);
	void prn2(char *p);
	void inorder(struct tree *ptr);
	int tr(int a);
	
	struct tree *fst;
	struct tree *opre;
	struct tree *num;
	
	
%}

%union {
	int iValue; /* integer value */
	char* sIndex; /* symbol table index */
};

%token <iValue> NUMBER
%token <sIndex> VARIABLE
%token PRINT INT BGN END
%left	'+' '-'	  /* left associative, same precedence */
%left	'*' '/'	  /* left assoc., higher precedence */
%type <iValue> expr

%%
program:
	stmtlist { exit(0); }
	;
stmtlist:
	stmtlist stmttype { ; }
	| /* NULL */
	;
stmttype:
	beginsss
	| stmt
	;
beginsss:
	BGN INT varlist ';' END { printf("\n"); }
	;

varlist:
	VARIABLE { printf("DECL "); decl($1); }
	| varlist ',' VARIABLE { decl($3); }
	;
stmt:
	';' { ; }
	| expr ';' { ; }
	| PRINT '(' list ')' ';' { printf("\n"); }
	| VARIABLE '=' expr ';' { ini($1, $3); prn2($1); }
	;
list:
	VARIABLE   {  printf("CALL print ");  prn($1); }
	| list ','  VARIABLE { prn($3); }
	;	
expr:	  NUMBER	{ $$ = tr($1); }
	| VARIABLE { $$ = find($1); }
	| expr '+' expr { $$ = opr('+', $1, $3); }
	| expr '-' expr { $$ = opr('-', $1, $3); }
	| expr '*' expr { $$ = opr('*', $1, $3); }
	| expr '/' expr { $$ = opr('/', $1, $3); }
	| '(' expr ')' { $$ = $2; }
	;
%%
	/* end of grammar */
//#define SIZEOF_NODETYPE ((char *)&p->con - (char *)p)

void decl(char *p){
	struct L *curr;
	curr = first->next;
	while((curr != NULL)){
		if(strcmp(curr->name, p) == 0){
			yyerror("variable is already declared");
			exit(0);
		}
		curr = curr->next;
	}
	
	struct L *new;
	if ((new = (struct L *) malloc(sizeof (struct L))) == NULL)
		yyerror("out of memory");
	lst->next = new;
	lst = lst->next;
	lst->name = p;
	lst->val = INT_MIN;
	lst->next = NULL;
	printf("%s ", p);
}
int find(char *p){
	struct L *curr;
	curr = first->next;
	while((curr != NULL)){
		if(strcmp(curr->name, p) == 0){
			//
			struct tree *new;
			new = (struct tree *) malloc(sizeof (struct tree));
			struct tree *new2;
			new2 = (struct tree *) malloc(sizeof (struct tree));
			new2->left = NULL;
			new2->right = NULL;
			new2->val = p;
			new->left = new2;
			new->right = NULL;
			num->right = new;
			num = num->right;
			//
			return curr->val;
		}
		curr = curr->next;
	}
	yyerror("variable is not declared");
	exit(0);
	return 0;
}
void ini(char *p, int x){
	struct L *curr;
	curr = first->next;
	while((curr != NULL)){
		if(strcmp(curr->name, p) == 0){
			curr->val = x;
		}
		curr = curr->next;
	}
	free(curr);
}

int opr(int oper, int a, int b) {
	switch(oper) {
	
		case '+':	(opre->right)->val = "PLUS";
				opre = opre->right;
				return a + b;
		case '-':	(opre->right)->val = "SUB";
				opre = opre->right;
				return a - b;
		case '*':	(opre->right)->val = "MUL";
				opre = opre->right;
				return a * b;
		case '/':	(opre->right)->val = "DIV";
				opre = opre->right;
				return a / b;
		default :	return 0;
	}
}

void prn(char *p){
	printf("%s ", p);
}
void prn2(char *p){
	(fst->left)->val = p;
	(num->val) = (num->left)->val;
	(num->x) = (num->left)->x;
	num->left = NULL;
	inorder(fst);
	printf("\n");
	opre = fst;
	num = fst;
	struct tree *new;
	new = num->right;
	num->right = NULL;
	free(new);
}
void inorder(struct tree *ptr){
	if(ptr != NULL){
		
		if(ptr->val == NULL){
			printf("%d ", ptr->x);
		}
		else{
			printf("%s ", ptr->val);
		}
		inorder(ptr->left);
		inorder(ptr->right);
	}
}
int tr(int a){
	struct tree *new;
	new = (struct tree *) malloc(sizeof (struct tree));
	struct tree *new2;
	new2 = (struct tree *) malloc(sizeof (struct tree));
	new2->left = NULL;
	new2->right = NULL;
	new2->val = NULL;
	new2->x = a;
	new->left = new2;
	new->right = NULL;
	num->right = new;
	num = num->right;
	return a;
}

void yyerror(char *s) {
	//printf("");
	fprintf(stdout, "\033[31merror\033[0m %s\n", s);
}

int main(void) {
	first = (struct L *) malloc(sizeof (struct L));
	lst = first;
	
	fst = (struct tree *) malloc(sizeof (struct tree));
	fst->val = "ASSIGN";
	struct tree *new;
	new = (struct tree *) malloc(sizeof (struct tree));
	new->left = NULL;
	new->right = NULL;
	fst->right = NULL;
	fst->left = new;
	opre = fst;
	num = fst;
	yyparse();
	return 0;
}
