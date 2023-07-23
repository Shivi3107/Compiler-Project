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
	struct exper * check;
	struct stmtlist * s1;
	struct stmtlist * s2;
};
