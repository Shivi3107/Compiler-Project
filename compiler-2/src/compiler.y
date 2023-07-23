/*
 *   This file is part of SIL Compiler.
 *
 *  SIL Compiler is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  SIL Compiler is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with SIL Compiler.  If not, see <http://www.gnu.org/licenses/>.
 */

%{	
	#include <stdio.h>
	#include <stdlib.h>
	#include <stdarg.h>
	#include <limits.h>
	#include <string.h>
	#include <string.h>
	#include "include/AbsSynTree.h"
		int yylex();
		void yyerror( char* );
			int i;

	int yylex(void);
	void yyerror(char *s);
	
	struct L{
		int type;
		char* name; /* operator */
		int val;
		struct L *next;
		struct L *pre;
	};
	struct Larray{
		int type;
		char* name; /* operator */
		int *val;
		int size;
		struct Larray *next;
	};
	
	void decl(char *p);
	void arr_decl(char *z, int p);
	struct L *first;
	struct L *lst;
	struct Larray *first_array;
	struct Larray *lst_array;
	int curr_type;
	int find(char *p);
	int find2(char *p, int a);
	void ini(char *p, int x);
	void arr_ini(char *p, int i, int x);
	void ans();
	int c = 0;
	
	struct exper * exp_tree(struct exper * lft, char p, struct exper * rght);
	struct exper * exp_tree2(char p, int a);
	struct exper * exp_tree3(struct var_exper * ptr);
	struct var_exper * var_exp_tree(int x, struct exper * ptr, char* p);
	struct argstmt * assign(char* p, int i, struct exper * index, struct exper * value);
	struct cond_stmt * cond(int x, struct exper * ptr, struct stmtlist * stmt1, struct stmtlist * stmt2);
	void str_seq(struct str * st1, char* p);
	void stmtss(struct stmtlist * st1, struct stmt * st2);
	
	void execute_stmtlist();
	int execute_exper();
	int execute_var_exper();
	void execute_stmt();
	void execute_argstmt();
	void execute_writestmt();
	void execute_str();
	void execute_cond_stmt();
	
	void print_expr_tree(struct exper * ex);
	void print_tree(struct stmtlist * st);
	void printc();
%}

%union {
	int iValue; 
	char* sIndex;
	struct stmtlist * typ1;
	struct exper * typ2;
	struct var_exper * typ3;
	struct stmt * typ4;
	struct argstmt * typ5;
	struct writestmt * typ6;
	struct str * typ7;
	struct cond_stmt * typ8;
};

%token BEG END
%token T_INT T_BOOL
%token READ WRITE
%token DECL ENDDECL

%token <iValue> NUM
%token <sIndex> VAR

%token IF THEN ELSE ENDIF
%token LOGICAL_AND LOGICAL_NOT LOGICAL_OR
%token EQUALEQUAL LESSTHANOREQUAL GREATERTHANOREQUAL NOTEQUAL
%token WHILE DO ENDWHILE FOR 
%token T F 
%token MAIN RETURN


%left '<' '>'
%left EQUALEQUAL LESSTHANOREQUAL GREATERTHANOREQUAL NOTEQUAL
%left '+' '-'
%left '*' '/'
%left '%'
%left LOGICAL_AND LOGICAL_OR
%left LOGICAL_NOT
%type<typ1> stmt_list
%type<typ2> expr
%type<typ3> var_expr
%type<typ4> statement
%type<typ5> assign_stmt
%type<typ6> write_stmt
%type<typ7> str_expr
%type<typ8> cond_stmt
%%

	Prog	:	Gdecl_sec /*Fdef_sec*/  MainBlock{ ans(); }
		;
		
	Gdecl_sec:	DECL Gdecl_lists ENDDECL		{ ; }
		;
		
	Gdecl_lists: 	Gdecl_list ';'
		| 	Gdecl_lists Gdecl_list ';'
		;
	Gdecl_list: 
		| 	ret_type Glist
		;
		
	ret_type:	T_INT		{ printf("DECL INT "); curr_type = 1; }
		|	T_BOOL		{ printf("DECL BOOL "); curr_type = 0; }
		;
		
	Glist 	:	Gid		{ ; }
		|	Glist ',' Gid	{ ; }
		;
	
	Gid	:	VAR			{ decl($1); printf("VAR"); }
		|	VAR '[' NUM ']'		{ arr_decl($1,$3); printf("ARR VAR %d",$3); }

		;
						
	func_ret_type:	T_INT		{ printf("FUN INT "); }
		|	T_BOOL		{ printf("FUN BOOL "); }
		;
		
	ret_stmt:	
		|	RETURN expr ';'		{ ; }
		;
			
	MainBlock: 	func_ret_type main '('')''{' BEG stmt_list ret_stmt END  '}'		{ print_tree($7); 
													printc(); execute_stmtlist($7); }
		;
		
	main	:	MAIN		{ printf("MAIN\n "); }
		;

	stmt_list:	/* NULL */			{ $$ = (struct stmtlist *)malloc(sizeof(struct stmtlist)); }
		|	stmt_list statement		{ stmtss($1,$2); $$ = $1; }
		;

	statement:	assign_stmt  ';'	{ struct stmt * temp = (struct stmt *)malloc(sizeof(struct stmt));
								temp->ind = 1;
								temp->arg = $1;
								$$ = temp;  }
		|	write_stmt ';'		{ struct stmt * temp = (struct stmt *)malloc(sizeof(struct stmt));
								temp->ind = 2;
								temp->writes = $1;
								$$ = temp;  }
		|	cond_stmt		{ struct stmt * temp = (struct stmt *)malloc(sizeof(struct stmt));
								temp->ind = 3;
								temp->conds = $1;
								$$ = temp;  }
		;

	write_stmt:	WRITE '(' expr ')'		{ struct writestmt * temp = (struct writestmt *)malloc(sizeof(struct writestmt));
								temp->ind = 1;
								temp->val = $3;
								$$ = temp; }
		 |	WRITE '(''"' str_expr '"'')'	{ struct writestmt * temp = (struct writestmt *)malloc(sizeof(struct writestmt));
								temp->ind = 2;
								temp->st = $4;
								$$ = temp; }

		;
	
	assign_stmt:	VAR '=' expr 			{ $$ = assign($1, 0, NULL, $3); }
		|	VAR '[' expr ']' '=' expr 	{ $$ = assign($1, 1, $3, $6); }
		;

	cond_stmt:	IF expr THEN stmt_list ENDIF				{ $$ = cond(1, $2, $4, NULL); }
		|	IF expr THEN stmt_list ELSE stmt_list ENDIF		{ $$ = cond(2, $2, $4, $6); }
		|	WHILE expr DO stmt_list ENDWHILE ';'			{ $$ = cond(3, $2, $4, NULL); }
		;

	expr	:	NUM 			{ $$ = exp_tree2('a', $1); }
		|	'-' NUM			{ $$ = exp_tree2('b', $2); }
		|	var_expr		{ $$ = exp_tree3($1); }
		|	T			{ $$ = exp_tree2('a', 1); }
		|	F			{ $$ = exp_tree2('a', 0); }
		|	'(' expr ')'		{ $$ = $2; }
		|	expr '+' expr 		{ $$ = exp_tree($1,'+',$3); }
		|	expr '-' expr	 	{ $$ = exp_tree($1,'-',$3); }
		|	expr '*' expr 		{ $$ = exp_tree($1,'*',$3); }
		|	expr '/' expr 		{ $$ = exp_tree($1,'/',$3); }
		|	expr '%' expr 		{ $$ = exp_tree($1,'%',$3); }
		|	expr '<' expr		{ $$ = exp_tree($1,'<',$3); }
		|	expr '>' expr		{ $$ = exp_tree($1,'>',$3); }
		|	expr GREATERTHANOREQUAL expr	{ $$ = exp_tree($1,'1',$3); }
		|	expr LESSTHANOREQUAL expr	{ $$ = exp_tree($1,'2',$3); }
		|	expr NOTEQUAL expr		{ $$ = exp_tree($1,'3',$3); }
		|	expr EQUALEQUAL expr		{ $$ = exp_tree($1,'4',$3); }
		|	LOGICAL_NOT expr		{ $$ = exp_tree(NULL,'5',$2); }
		|	expr LOGICAL_AND expr		{ $$ = exp_tree($1,'6',$3); }
		|	expr LOGICAL_OR expr		{ $$ = exp_tree($1,'7',$3); }

		;
	str_expr :  VAR			{ struct str * temp = (struct str *)malloc(sizeof(struct str));
						temp->vari = $1;
						temp->next = NULL;
						$$ = temp;		 }
                | str_expr VAR		{ str_seq($1, $2); $$ = $1; }
                ;
	
	var_expr:	VAR			{ $$ = var_exp_tree(0,NULL,$1); }
		|	VAR '[' expr ']'	{ $$ = var_exp_tree(1,$3,$1); }
		;
%%
void yyerror(char *s) {
	fprintf(stdout, "\033[31merror\033[0m %s\n", s);
}

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
	free(curr);
	if(c) printf(", ");
	else c = 1;
	struct L *new;
	if ((new = (struct L *) malloc(sizeof (struct L))) == NULL)
		yyerror("out of memory");
	lst->next = new;
	new->pre = lst;
	lst = lst->next;
	lst->name = p;
	lst->val = INT_MIN;
	lst->type = curr_type;
	lst->next = NULL;
}

void arr_decl(char *z, int p){
	//lst->arr = p;
	struct Larray *curr;
	curr = first_array->next;
	while((curr != NULL)){
		if(strcmp(curr->name, z) == 0){
			yyerror("variable is already declared");
			exit(0);
		}
		curr = curr->next;
	}
	free(curr);
	if(c) printf(", ");
	else c = 1;
	struct Larray *new;
	if ((new = (struct Larray *) malloc(sizeof (struct Larray))) == NULL)
		yyerror("out of memory");
	lst_array->next = new;
	//new->pre = lst;
	lst_array = lst_array->next;
	lst_array->name = z;
	
	lst_array->val = (int*)malloc(p * sizeof(int));
		
	lst_array->type = curr_type;
	lst_array->size = p;
	lst_array->next = NULL;
	
}

int find(char *p){
	struct L *curr;
	curr = first->next;
	while((curr != NULL)){
		if(strcmp(curr->name, p) == 0){
			return curr->val;
		}
		curr = curr->next;
	}
	yyerror("variable is not declared");
	exit(0);
	return 0;
}
int find2(char *p, int a){
	struct Larray *curr;
	curr = first_array->next;
	while((curr != NULL)){
		if(strcmp(curr->name, p) == 0){
			if(a < curr->size){
				return (curr->val)[a];
			}
			else{
				yyerror("Segmentation fault ");
				exit(0);
;			}
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
void arr_ini(char *p, int i, int x){
	struct Larray *curr;
	curr = first_array->next;
	while((curr != NULL)){
		if(strcmp(curr->name, p) == 0){
			if(i < curr->size){
				(curr->val)[i] = x;
			}
			else{
				yyerror("Segmentation fault ");
				exit(0);
;			}
		}
		curr = curr->next;
	}
	free(curr);
}

//==========================================================================================
//==========================================================================================
//==========================================================================================
//==========================================================================================
//==========================================================================================
//==========================================================================================


struct exper * exp_tree(struct exper * lft, char p, struct exper * rght)
{
	struct exper * temp = (struct exper *)malloc(sizeof(struct exper));
	temp->opr = p;
	temp->val = INT_MIN;
	temp->left = lft;
	temp->right = rght;
	temp->vari = NULL;
	return temp;
}
struct exper * exp_tree2(char p, int a)
{
	struct exper * temp = (struct exper *)malloc(sizeof(struct exper));
	temp->opr = p;
	if(p == 'b') a = (-1) * a;
	temp->val = a;
	temp->left = NULL;
	temp->right = NULL;
	temp->vari = NULL;
	return temp;
}
struct exper * exp_tree3(struct var_exper * ptr)
{
	struct exper * temp = (struct exper *)malloc(sizeof(struct exper));
	temp->val = INT_MIN;
	temp->left = NULL;
	temp->right = NULL;
	temp->vari = ptr;
	return temp;
}
struct var_exper * var_exp_tree(int i, struct exper * ptr, char* p)
{
	struct var_exper * temp = (struct var_exper *)malloc(sizeof(struct var_exper));
	temp->arr = i;
	temp->ind = ptr;
	temp->vari = p;
	return temp;
}
struct argstmt * assign(char* p, int i, struct exper * index, struct exper * value)
{
	struct argstmt * temp = (struct argstmt *)malloc(sizeof(struct argstmt));
	temp->vari = p;
	temp->arr = i;
	temp->ind = index;
	temp->val = value;
	return temp;
}
struct cond_stmt * cond(int x, struct exper * ptr, struct stmtlist * stmt1, struct stmtlist * stmt2)
{
	struct cond_stmt * temp = (struct cond_stmt *)malloc(sizeof(struct cond_stmt));
	temp->ind = x;
	temp->check = ptr;
	temp->s1 = stmt1;
	temp->s2 = stmt2;
	return temp;
}
void str_seq(struct str * st1, char* p)
{
	struct str * temp = (struct str *)malloc(sizeof(struct str));
	temp->vari = p;
	temp->next = NULL;
	while(st1->next != NULL)
	{
		st1 = st1->next;
	}
	st1->next = temp;
}
void stmtss(struct stmtlist * st1, struct stmt * st2)
{
	struct stmtlist * curr = st1;
	struct stmtlist * temp = (struct stmtlist *)malloc(sizeof(struct stmtlist));
	temp->next = NULL;
	while(curr->next != NULL)
	{
		curr = curr->next;
	}
	curr->next = temp;
	curr->val = st2;	
}

//==========================================================================================
//==========================================================================================
//==========================================================================================
//==========================================================================================
//==========================================================================================
//==========================================================================================

void execute_stmtlist(struct stmtlist * st)
{
	while(st->next != NULL){
		execute_stmt(st->val);
		st = st->next;
	}
}
int execute_exper(struct exper * expers)
{
	if(expers->vari != NULL) {
		return execute_var_exper(expers->vari);
	}
	
	switch(expers->opr) {
	
		case 'a':	return expers->val;
		case 'b':	return expers->val;
		
		case '+':	return execute_exper(expers->left) + execute_exper(expers->right);
		case '-':	return execute_exper(expers->left) - execute_exper(expers->right);
		case '*':	return execute_exper(expers->left) * execute_exper(expers->right);
		case '/':	return execute_exper(expers->left) / execute_exper(expers->right);
		case '%':	return execute_exper(expers->left) % execute_exper(expers->right);
		
		case '<':	return execute_exper(expers->left) < execute_exper(expers->right);
		case '>':	return execute_exper(expers->left) > execute_exper(expers->right);
		case '1':	return execute_exper(expers->left) >= execute_exper(expers->right);
		case '2':	return execute_exper(expers->left) <= execute_exper(expers->right);
		case '3':	return execute_exper(expers->left) != execute_exper(expers->right);
		case '4':	return execute_exper(expers->left) == execute_exper(expers->right);
		case '5':	return !(execute_exper(expers->right));
		case '6':	return execute_exper(expers->left) && execute_exper(expers->right);
		case '7':	return execute_exper(expers->left) || execute_exper(expers->right);
		
		default :	return 0;
	}
}
int execute_var_exper(struct var_exper * var)
{
	if(var->arr) return find2(var->vari, execute_exper(var->ind));
	else return find(var->vari);
}
void execute_stmt(struct stmt * stmts)
{
	if(stmts->ind ==  1) execute_argstmt(stmts->arg);
	else if(stmts->ind ==  2) execute_writestmt(stmts->writes);
	else if(stmts->ind ==  3) execute_cond_stmt(stmts->conds);
}
void execute_argstmt(struct argstmt * arg)
{
	int r = execute_exper(arg->val);
	if(arg->arr) return arr_ini(arg->vari, execute_exper(arg->ind), r);
	else return ini(arg->vari, r);
}
void execute_writestmt(struct writestmt * writes)
{
	if(writes->ind == 1) printf("%d\n", execute_exper(writes->val));
	else if(writes->ind == 2) execute_str(writes->st);
}
void execute_str(struct str * st)
{
	while(st != NULL){
		printf("%s ",st->vari);
		st = st->next;
	}
	printf("\n");
}
void execute_cond_stmt(struct cond_stmt * conds)
{
	if(conds->ind ==  1){ 
		if(execute_exper(conds->check)) execute_stmtlist( conds->s1 );
	}	
	else if(conds->ind ==  2){ 
		if(execute_exper(conds->check)) execute_stmtlist( conds->s1 );
		else execute_stmtlist( conds->s2 );
	}
	else if(conds->ind ==  3){ 
		while(execute_exper(conds->check)) execute_stmtlist( conds->s1 );
	}
}

//==========================================================================================
//==========================================================================================
//==========================================================================================
//==========================================================================================
//==========================================================================================
//==========================================================================================

void print_tree(struct stmtlist * st)
{
	while(st->next != NULL){
		if((st->val)->ind == 1){
			
			struct argstmt * curr = (st->val)->arg;
			
			if(curr->arr){
				printf("ASSIGN ARREF VAR ");
				print_expr_tree(curr->ind);
				print_expr_tree(curr->val);
				printf("\n");
			}
			else{
				printf("ASSIGN VAR ");
				print_expr_tree(curr->val);
				printf("\n");
			}
		}
		else if((st->val)->ind == 2){
			struct writestmt * curr = (st->val)->writes;
			printf("FUNCALL ");
			if(curr->ind == 1){
				print_expr_tree(curr->val);
			}
			else{
				struct str * s = curr->st;
				while(s != NULL){
					printf("VAR ");
					s = s->next;
				}
			}
		}
		else if((st->val)->ind == 3){
			struct cond_stmt * curr = (st->val)->conds;
			
			if(curr->ind == 1){
				printf("IF ");
				print_expr_tree(curr->check);
				printf("\n");
				print_tree(curr->s1);
				printf("ENDIF\n");
			}
			else if(curr->ind == 2){
				printf("IF ");
				print_expr_tree(curr->check);
				printf("\n");
				print_tree(curr->s1);
				printf("ELSE ");
				print_tree(curr->s2);
				printf("ENDIF\n");
			}
			else if(curr->ind == 3){
				printf("WHILE ");
				print_expr_tree(curr->check);
				printf("\n");
				print_tree(curr->s1);
				printf("ENDWHILE\n");
			}
		}
		printf("\n");
		st = st->next;
	}
}
void print_expr_tree(struct exper * ex)
{
	if(ex == NULL) return;
	if(ex->vari != NULL) {
		if((ex->vari)->arr){
			printf("ARREF VAR ");
			print_expr_tree((ex->vari)->ind);
		}
		else printf("VAR ");
		return;
	}
	
	if(ex->opr == 'a'){ 
		printf("NUM ");
	}
	else if(ex->opr == 'b'){ 
		printf("UMINUS NUM ");
	}
	else if(ex->opr == '5'){ 
		printf("LOGICAL_NOT ");
		print_expr_tree(ex->right);
	}
	else{
		switch(ex->opr) {
			case '+':	printf("PLUS "); break;
			case '-':	printf("SUB "); break;
			case '*':	printf("MUL "); break;
			case '/':	printf("DIV "); break;
			case '%':	printf("MOD "); break;
			
			case '<':	printf("LESSTHAN "); break;
			case '>':	printf("GREATERTHAN "); break;
			case '1':	printf("GREATERTHANOREQUAL "); break;
			case '2':	printf("LESSTHANOREQUAL "); break;
			case '3':	printf("NOTEQUAL "); break;
			case '4':	printf("EQUALEQUAL "); break;
			case '6':	printf("LOGICAL_AND "); break;
			case '7':	printf("LOGICAL_OR "); break;
		}
		print_expr_tree(ex->left);
		print_expr_tree(ex->right);
	}
}
void printc(){
	printf("=============================================================\n");
	printf("Evauating\n");
	//printf("=============================================================\n");
}
void ans(){
	printf("=============================================================\n");
	printf("Printing Symbol Table\n");
	//printf("=============================================================\n");
	struct L *curr;
	curr = first->next;
	while((curr != NULL)){
		printf("%s = %d\n",curr->name, curr->val);
		curr = curr->next;
	}
	free(curr);

	struct Larray *curr1;
	curr1 = first_array->next;
	while((curr1 != NULL)){
		for(int i = 0; i < (curr1->size); i++){
			printf("%s[%d] = %d\n", curr1->name, i, (curr1->val)[i]);
		}
		curr1 = curr1->next;
	}
	free(curr1);
}

int main(void) {
	first = (struct L *) malloc(sizeof (struct L));
	lst = first;
	first_array = (struct Larray *) malloc(sizeof (struct Larray));
	lst_array = first_array;
	
	yyparse();
	return 0;
}
