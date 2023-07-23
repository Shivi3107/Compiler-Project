struct Fdefsec{
	struct Fundef * val;
	struct Fdefsec * next;
};

struct Fundef{
	struct Type * Datatype;
	char* name;
	struct fun_arg_List * lst;
	struct Ldeclsec * locals;
	struct stmtlist * st;
	struct ret * returns;
};

struct Type{
	int types;
};

struct fun_arg_List{
	struct arglist * lst;
};

struct ret{
	struct exper * val;
};

struct Ldeclsec{
	struct Ldecllist * lst;
};

struct Ldecllist{
	struct L_decl * val;
	struct Ldecllist * next;
};

struct L_decl{
	struct Type * Datatype;
	struct L_decl_list * lst;
};

struct L_decl_list{
	char* var;
	struct L_decl_list * next;
};
