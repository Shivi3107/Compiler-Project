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
	#include "include/AbsSynTree1.h"
	#include "include/AbsSynTree2.h"
	#include "include/AbsSynTree3.h"
		int yylex();
		void yyerror( char* );
			int i;

	int yylex(void);
	void yyerror(char *s);
	
	
	void PrintingSyntaxTree(struct Gdeclsec * Gl, struct Fdefsec * Fn, struct Main_B * Mn);
	void PrintingSymbolTable();
	int c = 0;
	int for_loop = 0;
	
	struct exper * exp_tree(struct exper * lft, char p, struct exper * rght);
	struct exper * exp_tree2(char p, int a);
	struct exper * exp_tree3(struct var_exper * ptr);
	struct exper * exp_tree4(struct funccall * fun_cs);
	struct var_exper * var_exp_tree(int x, struct exper * ptr, char* p);
	struct argstmt * assign(char* p, int i, struct exper * index, struct exper * value);
	struct cond_stmt * cond(int x, struct exper * ptr, struct stmtlist * stmt1, struct stmtlist * stmt2, struct argstmt * ar1, struct argstmt * ar2);
	void str_seq(struct str * st1, char* p);
	void stmtss(struct stmtlist * st1, struct stmt * st2);
	struct Fdefsec * FdecFun(struct Fdefsec * f1, struct Fundef * f2);
	
	void PrintingGdecl_sec_tree(struct Gdeclsec * Gl);
	void PrintingGdecl_list_tree(struct Gdeclsec_list * list);
	void Printingarg_list_tree(struct arglist * curr);
	
	void PrintingFdef_sec_tree(struct Fdefsec * Fn);
	void PrintingLdecl_sec_tree(struct Ldecllist * list);
	void Printingret_stmt_tree(struct ret * rt);
	
	void PrintingMainBlock_tree(struct Main_B * Mn);
	void print_statement_tree(struct stmtlist * st);
	void print_assign_tree(struct argstmt * curr);
	void print_funCall_tree(struct funccall * fun_cs);
	void print_expr_tree(struct exper * ex);
%}

%union {
	int iValue; 
	char* sIndex;
	struct Main_B * typ0;
	struct stmtlist * typ1;
	struct exper * typ2;
	struct var_exper * typ3;
	struct stmt * typ4;
	struct argstmt * typ5;
	struct writestmt * typ6;
	struct str * typ7;
	struct cond_stmt * typ8;
	struct readstmt * typ9;
	struct funstmt * typ10;
	struct funccall * typ11;
	struct para_lst * typ12;
	struct para_lst1 * typ13;
	struct param * typ14;
	
	struct Gdeclsec * typ101;
	struct Gdeclsec_lists * typ102;
	struct Gdeclsec_list * typ103;
	struct G_list * typ104;
	struct G_id * typ105;
	struct Fun_id * typ106;
	struct arglist * typ107;
	struct arglist1 * typ108;
	struct args * typ109;
	struct varlist * typ110;
	
	struct Fdefsec * typ201;
	struct Fundef * typ202;
	struct Type * typ203;
	struct fun_arg_List * typ204;
	struct ret * typ205;
	struct Ldeclsec * typ206;
	struct Ldecllist * typ207;
	struct L_decl * typ208;
	struct L_decl_list * typ209;
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
%type<typ0> MainBlock
%type<typ1> stmt_list
%type<typ2> expr
%type<typ3> var_expr
%type<typ4> statement
%type<typ5> assign_stmt
%type<typ6> write_stmt
%type<typ7> str_expr
%type<typ8> cond_stmt
%type<typ9> read_stmt
%type<typ10> func_stmt
%type<typ11> func_call
%type<typ12> param_list
%type<typ13> param_list1
%type<typ14> para
%type<typ101> Gdecl_sec
%type<typ102> Gdecl_lists
%type<typ103> Gdecl_list
%type<typ104> Glist
%type<typ105> Gid
%type<typ106> func
%type<typ107> arg_list
%type<typ108> arg_list1
%type<typ109> arg
%type<typ110> var_list
%type<typ201> Fdef_sec
%type<typ202> Fdef
%type<typ203> ret_type arg_type func_ret_type type
%type<typ204> FargList
%type<typ205> ret_stmt
%type<typ206> Ldecl_sec
%type<typ207> Ldecl_list
%type<typ208> Ldecl
%type<typ209> Lid_list
%type<sIndex> Lid func_name

%%

	Prog	:	Gdecl_sec  Fdef_sec  MainBlock{ PrintingSyntaxTree($1,$2,$3); }
		;
		
	Gdecl_sec:	DECL Gdecl_lists ENDDECL	{ struct Gdeclsec * temp = (struct Gdeclsec *)malloc(sizeof(struct Gdeclsec));
								temp->lst = $2;
								$$ = temp;   }
		;
		
	Gdecl_lists: 	Gdecl_list ';'			{ struct Gdeclsec_lists * temp = (struct Gdeclsec_lists *)malloc(sizeof(struct Gdeclsec_lists));
								temp->val = $1;
								temp->next = NULL;
								$$ = temp;   }
		| 	Gdecl_list ';' Gdecl_lists	{ struct Gdeclsec_lists * temp = (struct Gdeclsec_lists *)malloc(sizeof(struct Gdeclsec_lists));
								temp->val = $1;
								temp->next = $3;
								$$ = temp;   }
		;
	Gdecl_list: 					{ $$ = NULL; }
		| 	ret_type Glist			{ struct Gdeclsec_list * temp = (struct Gdeclsec_list *)malloc(sizeof(struct Gdeclsec_list));
								temp->Datatype = $1;
								temp->lst = $2;
								$$ = temp; }
		;
		
	ret_type:	T_INT		{ struct Type * temp = (struct Type *)malloc(sizeof(struct Type));
								temp->types = 1;
								$$ = temp; }
		|	T_BOOL		{ struct Type * temp = (struct Type *)malloc(sizeof(struct Type));
								temp->types = 2;
								$$ = temp; }
		;
		
	Glist 	:	Gid			{ struct G_list * temp = (struct G_list *)malloc(sizeof(struct G_list));
								temp->globals = $1;
								temp->funs = NULL;
								temp->next = NULL;
								$$ = temp; }
		| 	func 			{ struct G_list * temp = (struct G_list *)malloc(sizeof(struct G_list));
								temp->globals = NULL;
								temp->funs = $1;
								temp->next = NULL;
								$$ = temp; }
		|	Gid ',' Glist 		{ struct G_list * temp = (struct G_list *)malloc(sizeof(struct G_list));
								temp->globals = $1;
								temp->funs = NULL;
								temp->next = $3;
								$$ = temp; }
		|	func ',' Glist		{ struct G_list * temp = (struct G_list *)malloc(sizeof(struct G_list));
								temp->globals = NULL;
								temp->funs = $1;
								temp->next = $3;
								$$ = temp; }
		;
	
	Gid	:	VAR			{ struct G_id * temp = (struct G_id *)malloc(sizeof(struct G_id));
								temp->arr = 0;
								temp->ind = 0;
								temp->name = $1;
								$$ = temp; }
		|	VAR '[' NUM ']'		{ struct G_id * temp = (struct G_id *)malloc(sizeof(struct G_id));
								temp->arr = 1;
								temp->ind = $3;
								temp->name = $1;
								$$ = temp; }
		;

	func 	:	VAR '(' arg_list ')'	{ struct Fun_id * temp = (struct Fun_id *)malloc(sizeof(struct Fun_id));
								temp->name = $1;
								temp->lst = $3;
								$$ = temp; }
		;
			
	arg_list:				{ $$ = NULL; }
		|	arg_list1		{ struct arglist * temp = (struct arglist *)malloc(sizeof(struct arglist));
								temp->lst = $1;
								$$ = temp; }
		;
		
	arg_list1:	arg ';' arg_list1	{ struct arglist1 * temp = (struct arglist1 *)malloc(sizeof(struct arglist1));
								temp->val = $1;
								temp->next = $3;
								$$ = temp; }
		|	arg			{ struct arglist1 * temp = (struct arglist1 *)malloc(sizeof(struct arglist1));
								temp->val = $1;
								temp->next = NULL;
								$$ = temp; }
		;
		
	arg 	:	arg_type var_list	{  struct args * temp = (struct args *)malloc(sizeof(struct args));
								temp->Datatype = $1;
								temp->vari_lst = $2;
								$$ = temp;  }
		;
		
	arg_type:	T_INT		{ struct Type * temp = (struct Type *)malloc(sizeof(struct Type));
						temp->types = 1;
						$$ = temp; }
		|	T_BOOL		{ struct Type * temp = (struct Type *)malloc(sizeof(struct Type));
						temp->types = 2;
						$$ = temp; }
		;

	var_list:	VAR 			{ struct varlist * temp = (struct varlist *)malloc(sizeof(struct varlist));
							temp->vari = $1;
							temp->next = NULL;
							$$ = temp; }
		|	VAR ',' var_list	{ struct varlist * temp = (struct varlist *)malloc(sizeof(struct varlist));
							temp->vari = $1;
							temp->next = $3;
							$$ = temp; }
		;
		
	Fdef_sec:				{ $$ = NULL; }
		|	 Fdef_sec Fdef		{ $$ = FdecFun($1,$2); }
		;
		
	Fdef	:	func_ret_type func_name '(' FargList ')' '{' Ldecl_sec BEG stmt_list ret_stmt END '}'
						{ struct Fundef * temp = (struct Fundef *)malloc(sizeof(struct Fundef));
							temp->Datatype = $1;
							temp->name = $2;
							temp->lst = $4;
							temp->locals = $7;
							temp->st = $9;
							temp->returns = $10;
							$$ = temp; }
		;
			
	func_name:	VAR		{ $$ = $1; }
		;
		
	FargList:	arg_list	{ struct fun_arg_List * temp = (struct fun_arg_List *)malloc(sizeof(struct fun_arg_List));
							temp->lst = $1;
							$$ = temp; }
		;
					
	func_ret_type:	T_INT		{ struct Type * temp = (struct Type *)malloc(sizeof(struct Type));
						temp->types = 1;
						$$ = temp; }
		|	T_BOOL		{ struct Type * temp = (struct Type *)malloc(sizeof(struct Type));
						temp->types = 2;
						$$ = temp; }
		;
		
	ret_stmt:				{ $$ = NULL; }
		|	RETURN expr ';'		{ struct ret * temp = (struct ret *)malloc(sizeof(struct ret));
							temp->val = $2;
							$$ = temp; }
		;
			
	MainBlock: 	func_ret_type main '('')''{' Ldecl_sec BEG stmt_list ret_stmt END  '}'		
							{  struct Main_B * temp = (struct Main_B *)malloc(sizeof(struct Main_B));
								temp->Datatype = $1;
								temp->locals = $6;
								temp->st = $8;
								temp->returns = $9;
								$$ = temp;  }
		;
		
	main	:	MAIN		{ ; }
		;

	Ldecl_sec:					{ $$ = NULL; }
		|	DECL Ldecl_list ENDDECL		{ struct Ldeclsec * temp = (struct Ldeclsec *)malloc(sizeof(struct Ldeclsec));
								temp->lst = $2;
								$$ = temp; }
		;

	Ldecl_list:				{ $$ = NULL; }
		|	Ldecl Ldecl_list	{ struct Ldecllist * temp = (struct Ldecllist *)malloc(sizeof(struct Ldecllist));
							temp->val = $1;
							temp->next = $2;
							$$ = temp; }
		;

	Ldecl	:	type Lid_list ';'	{ struct L_decl * temp = (struct L_decl *)malloc(sizeof(struct L_decl));
							temp->Datatype = $1;
							temp->lst = $2;
							$$ = temp; }
		;
		;

	type	:	T_INT		{ struct Type * temp = (struct Type *)malloc(sizeof(struct Type));
						temp->types = 1;
						$$ = temp; }
		|	T_BOOL		{ struct Type * temp = (struct Type *)malloc(sizeof(struct Type));
						temp->types = 2;
						$$ = temp; }
		;

	Lid_list:	Lid			{ struct L_decl_list * temp = (struct L_decl_list *)malloc(sizeof(struct L_decl_list));
							temp->var = $1;
							temp->next = NULL;
							$$ = temp; }
		|	Lid ',' Lid_list	{ struct L_decl_list * temp = (struct L_decl_list *)malloc(sizeof(struct L_decl_list));
							temp->var = $1;
							temp->next = $3;
							$$ = temp; }
		;
		
	Lid	:	VAR			{ $$ = $1; }
		;
	
	stmt_list:	/* NULL */		{ $$ = (struct stmtlist *)malloc(sizeof(struct stmtlist)); }
		|	stmt_list statement	{ stmtss($1,$2); $$ = $1; }
		|	error ';'		{  }
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
		|	read_stmt ';'		{ struct stmt * temp = (struct stmt *)malloc(sizeof(struct stmt));
								temp->ind = 4;
								temp->reads = $1;
								$$ = temp;  }

		|	func_stmt ';'		{ struct stmt * temp = (struct stmt *)malloc(sizeof(struct stmt));
								temp->ind = 5;
								temp->funs = $1;
								$$ = temp; }
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

	cond_stmt:	IF expr THEN stmt_list ENDIF ';'			{ $$ = cond(1, $2, $4, NULL, NULL, NULL); }
		|	IF expr THEN stmt_list ELSE stmt_list ENDIF ';'		{ $$ = cond(2, $2, $4, $6, NULL, NULL); }
		|	WHILE expr DO stmt_list ENDWHILE ';'			{ $$ = cond(3, $2, $4, NULL, NULL, NULL); }
		|	FOR '(' assign_stmt  ';'  expr ';'  assign_stmt ')' '{' stmt_list '}'	{ $$ = cond(4, $5, $10, NULL, $3, $7); }
		;

	read_stmt:	READ '(' var_expr ')'		{ struct readstmt * temp = (struct readstmt *)malloc(sizeof(struct readstmt));
								temp->vari = $3;
								$$ = temp; }
		;
	
	func_stmt:	func_call 		{ struct funstmt * temp = (struct funstmt *)malloc(sizeof(struct funstmt));
							temp->fun_c = $1;
							$$ = temp; }
		;
		
	func_call:	VAR '(' param_list ')'	{ struct funccall * temp = (struct funccall *)malloc(sizeof(struct funccall));
							temp->vari = $1;
							temp->p_list = $3;
							$$ = temp;  }
		;
		
	param_list:				{ $$ = NULL; }		
		|	param_list1		{ struct para_lst * temp = (struct para_lst *)malloc(sizeof(struct para_lst));
							temp->p1_list = $1;
							$$ = temp; }
		;
		
	param_list1:	para			{ struct para_lst1 * temp = (struct para_lst1 *)malloc(sizeof(struct para_lst1));
							temp->p = $1;
							temp->next = NULL;
							$$ = temp; }
		|	para ',' param_list1	{ struct para_lst1 * temp = (struct para_lst1 *)malloc(sizeof(struct para_lst1));
							temp->p = $1;
							temp->next = $3;
							$$ = temp; }
		;

	para	:	expr			{ struct param * temp = (struct param *)malloc(sizeof(struct param));
							temp->val = $1;
							$$ = temp;  }
		;

	expr	:	NUM 			{ $$ = exp_tree2('a', $1); }
		|	'-' NUM			{ $$ = exp_tree2('b', $2); }
		|	var_expr		{ $$ = exp_tree3($1); }
		|	T			{ $$ = exp_tree2('a', 1); }
		|	F			{ $$ = exp_tree2('a', 0); }
		|	'(' expr ')'		{ $$ = exp_tree($2,'0',0); }
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
		|	func_call 		{ $$ = exp_tree4($1); }
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
	temp->fun_c = NULL;
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
	temp->fun_c = NULL;
	return temp;
}
struct exper * exp_tree3(struct var_exper * ptr)
{
	struct exper * temp = (struct exper *)malloc(sizeof(struct exper));
	temp->val = INT_MIN;
	temp->left = NULL;
	temp->right = NULL;
	temp->vari = ptr;
	temp->fun_c = NULL;
	return temp;
}
struct exper * exp_tree4(struct funccall * fun_cs)
{
	struct exper * temp = (struct exper *)malloc(sizeof(struct exper));
	temp->val = INT_MIN;
	temp->left = NULL;
	temp->right = NULL;
	temp->vari = NULL;
	temp->fun_c = fun_cs;
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
struct cond_stmt * cond(int x, struct exper * ptr, struct stmtlist * stmt1, struct stmtlist * stmt2, struct argstmt * ar1, struct argstmt * ar2)
{
	struct cond_stmt * temp = (struct cond_stmt *)malloc(sizeof(struct cond_stmt));
	temp->ind = x;
	temp->check = ptr;
	temp->s1 = stmt1;
	temp->s2 = stmt2;
	temp->arg1 = ar1;
	temp->arg2 = ar2;
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

struct Fdefsec * FdecFun(struct Fdefsec * f1, struct Fundef * f2){
	if (f1 == NULL){
		struct Fdefsec * temp = (struct Fdefsec *)malloc(sizeof(struct Fdefsec));
		temp->next = NULL;
		temp->val = f2;
		return f1;
	}
	
	struct Fdefsec * curr = f1;
	struct Fdefsec * temp = (struct Fdefsec *)malloc(sizeof(struct Fdefsec));
	temp->next = NULL;
	while(curr->next != NULL)
	{
		curr = curr->next;
	}
	curr->next = temp;
	curr->val = f2;
	
	return f1;
}

//==========================================================================================
//==========================================================================================
//Global Part
//==========================================================================================
//==========================================================================================
//==========================================================================================

void PrintingGdecl_sec_tree(struct Gdeclsec * Gl){
	printf("DECL ");
	while(Gl->lst != NULL){
		PrintingGdecl_list_tree((Gl->lst)->val);
		(Gl->lst) = (Gl->lst)->next;
		printf("\n");
	}
}

void PrintingGdecl_list_tree(struct Gdeclsec_list * list){
	if(list != NULL){
		if((list->Datatype)->types == 1) printf("INT ");
		else if((list->Datatype)->types == 2) printf("BOOL ");
		
		while(list->lst != NULL){
			
			if((list->lst)->globals != NULL){
				struct G_id * curr = (list->lst)->globals;
				if(curr->arr) printf("ARR VAR %d", curr->ind);
				else printf("VAR ");
			}
			else if((list->lst)->funs != NULL){
				printf("FUN VAR (");
				Printingarg_list_tree(((list->lst)->funs)->lst);
				
			}
			(list->lst) = (list->lst)->next;
			if(list->lst != NULL)printf(", ");
		}
	}
	
}

void Printingarg_list_tree(struct arglist * curr){
	if(curr != NULL){
		
		while((curr->lst) != NULL){
			struct args * crr = (curr->lst)->val;
			if((crr->Datatype)->types == 1) printf("INT ");
			else if((crr->Datatype)->types == 2) printf("BOOL ");
			while(crr->vari_lst != NULL){
				
				
				printf("VAR ");
				
				crr->vari_lst = (crr->vari_lst)->next;
				if(crr->vari_lst != NULL)printf(", ");
			}
			curr->lst = (curr->lst)->next;
			if((curr->lst) != NULL)printf(", ");
		}
		
	}
	printf(")");
}

//==========================================================================================
//==========================================================================================
//==========================================================================================
//==========================================================================================
//==========================================================================================
//==========================================================================================




//==========================================================================================
//==========================================================================================
//Function Part
//==========================================================================================
//==========================================================================================
//==========================================================================================

void PrintingFdef_sec_tree(struct Fdefsec * Fn){
	while(Fn != NULL){
		if(((Fn->val)->Datatype)->types == 1) printf("FUN INT ");
		else if(((Fn->val)->Datatype)->types == 2) printf("FUN BOOL ");
		
		printf("VAR (");
		Printingarg_list_tree(((Fn->val)->lst)->lst);
		printf("\n");
		
		if((Fn->val)->locals != NULL) PrintingLdecl_sec_tree(((Fn->val)->locals)->lst);
		
		print_statement_tree((Fn->val)->st);
		Printingret_stmt_tree((Fn->val)->returns);
		printf("\n");
		
		Fn = Fn->next;
	}
	printf("\n");
}
void PrintingLdecl_sec_tree(struct Ldecllist * list){
	while(list != NULL){
	
		if(((list->val)->Datatype)->types == 1) printf("INT ");
		else if(((list->val)->Datatype)->types == 2) printf("BOOL ");
		
		while((list->val)->lst != NULL){
			
			printf("VAR ");
			((list->val)->lst) = ((list->val)->lst)->next;
			if((list->val)->lst != NULL)printf(", ");
		}
		list = list->next;
		printf("\n");
	}
}

void Printingret_stmt_tree(struct ret * rt){
	printf("RETURN ");
	print_expr_tree(rt->val);
	printf("\n");
}

//==========================================================================================
//==========================================================================================
//==========================================================================================
//==========================================================================================
//==========================================================================================
//==========================================================================================




//==========================================================================================
//==========================================================================================
//Main block Part
//==========================================================================================
//==========================================================================================
//==========================================================================================

void PrintingMainBlock_tree(struct Main_B * Mn){
	if((Mn->Datatype)->types == 1) printf("FUN INT ");
	else if((Mn->Datatype)->types == 2) printf("FUN BOOL ");
	printf("MAIN\n ");
	if(Mn->locals != NULL) PrintingLdecl_sec_tree((Mn->locals)->lst);
	print_statement_tree(Mn->st);
	Printingret_stmt_tree(Mn->returns);
	printf("\n");
}

void print_statement_tree(struct stmtlist * st)
{
	while(st->next != NULL){
		if((st->val)->ind == 1){
			print_assign_tree((st->val)->arg);
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
				printf("\n{");
				print_statement_tree(curr->s1);
				printf("ENDIF\n");
			}
			else if(curr->ind == 2){
				printf("IF ");
				print_expr_tree(curr->check);
				printf("\n");
				print_statement_tree(curr->s1);
				printf("ELSE");
				print_statement_tree(curr->s2);
				printf("ENDIF\n");
			}
			else if(curr->ind == 3){
				printf("WHILE ");
				print_expr_tree(curr->check);
				printf("\n");
				print_statement_tree(curr->s1);
				printf("ENDWHILE\n");
			}
			else if(curr->ind == 4){
				printf("FOR ");
				print_assign_tree(curr->arg1);
				printf(";");
				print_expr_tree(curr->check);
				printf(";");
				for_loop = 1;
				print_assign_tree(curr->arg2);
				for_loop = 0;
				printf("\n");
				print_statement_tree(curr->s1);
				printf("ENDFOR\n");
			}
			
		}
		else if((st->val)->ind == 4){
			struct readstmt * curr = (st->val)->reads;
			printf("READ ");
			
			if((curr->vari)->arr){
				printf("ARREF VAR ");
				print_expr_tree((curr->vari)->ind);
			}
			else printf("VAR ");
			printf("\n");
			
		}
		else if((st->val)->ind == 5){
			print_funCall_tree(((st->val)->funs)->fun_c);
			
		}
		printf("\n");
		st = st->next;
	}
}
void print_assign_tree(struct argstmt * curr){
	if(curr->arr){
		printf("ASSIGN ARREF VAR ");
		print_expr_tree(curr->ind);
		print_expr_tree(curr->val);
		
	}
	else{
		printf("ASSIGN VAR ");
		print_expr_tree(curr->val);
	}
	
}
void print_funCall_tree(struct funccall * fun_cs){
	printf("FUN VAR ( ");
	if((fun_cs->p_list) != NULL){
		while(((fun_cs->p_list)->p1_list)->next != NULL){
			print_expr_tree((((fun_cs->p_list)->p1_list)->p)->val);
			printf(",");
			(fun_cs->p_list)->p1_list = ((fun_cs->p_list)->p1_list)->next;
		}
		print_expr_tree((((fun_cs->p_list)->p1_list)->p)->val);
	}
	printf(")");
	return;
}

void print_expr_tree(struct exper * ex)
{
	if(ex == NULL) return;
	if(ex->fun_c != NULL){
		print_funCall_tree(ex->fun_c);
		return;
	}
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
	else if(ex->opr == '0'){ 
		print_expr_tree(ex->left);
	}
	else if(ex->opr == '5'){ 
		printf("LOGICAL_NOT ");
		print_expr_tree(ex->right);
	}
	else{
		print_expr_tree(ex->left);
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
			default :	break;
		}
		print_expr_tree(ex->right);
	}
}

//==========================================================================================
//==========================================================================================
//==========================================================================================
//==========================================================================================
//==========================================================================================
//==========================================================================================


void PrintingSyntaxTree(struct Gdeclsec * Gl, struct Fdefsec * Fn, struct Main_B * Mn){
	printf("/*\n=================================================================================\n");
	printf("============================== Syntax Tree ======================================\n");
	printf("=================================================================================\n\n");
	
	PrintingGdecl_sec_tree(Gl);
	printf("\n");
	PrintingFdef_sec_tree(Fn);
	PrintingMainBlock_tree(Mn);
	printf("*/");
}

int main(void) {
	yyparse();
	return 0;
}
