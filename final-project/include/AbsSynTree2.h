struct Main_B{
	struct Type * Datatype;
	struct Ldeclsec * locals;
	struct stmtlist * st;
	struct ret * returns;
};

struct stmtlist{
	struct stmt * val;
	struct stmtlist * next;
};

struct exper{
	char opr;
	int val;
	struct var_exper * vari;
	struct exper * left;
	struct exper * right;
	struct funccall * fun_c;
};

struct var_exper{
	int arr;
	struct exper * ind;
	char* vari;
};

struct stmt{
	int ind;
	struct argstmt * arg;
	struct writestmt * writes;
	struct cond_stmt * conds;
	struct readstmt * reads;
	struct funstmt * funs;
};

struct argstmt{
	char* vari;
	int arr;
	struct exper * ind;
	struct exper * val;
};

struct writestmt{
	int ind;
	struct exper * val;
	struct str * st;
};

struct str{
	char* vari;
	struct str * next;
};

struct cond_stmt{
	int ind;
	struct argstmt * arg1;
	struct argstmt * arg2;
	struct exper * check;
	struct stmtlist * s1;
	struct stmtlist * s2;
};

struct readstmt{
	struct var_exper * vari;
};

struct funstmt{
	struct funccall * fun_c;
};

struct funccall{
	char* vari;
	struct para_lst * p_list;
};

struct para_lst{
	struct para_lst1 * p1_list;
};

struct para_lst1{
	struct param * p;
	struct para_lst1 * next;
};

struct param{
	struct exper * val;
};
