struct Gdeclsec{
	struct Gdeclsec_lists * lst;
};

struct Gdeclsec_lists{
	struct Gdeclsec_list * val;
	struct Gdeclsec_lists * next;
};

struct Gdeclsec_list{
	struct Type * Datatype;
	struct G_list * lst;
};

struct G_list{
	struct G_id * globals;
	struct Fun_id * funs;
	struct G_list * next;
};

struct G_id{
	int arr;
	int ind;
	char* name;
};

struct Fun_id{
	char* name;
	struct arglist * lst;
};

struct arglist{
	struct arglist1 * lst;
};

struct arglist1{
	struct args * val;
	struct arglist1 * next;
};

struct args{
	struct Type * Datatype;
	struct varlist * vari_lst;
};

struct varlist{
	char* vari;
	struct varlist * next;
};
