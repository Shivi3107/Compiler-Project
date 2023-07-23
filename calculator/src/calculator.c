#include <stdio.h>
#include "../include/calc3.h"
#include "../y.tab.h"

int ex(nodeType *p) {
	if (!p) return 0;
		switch(p->type) {
		case typeCon: return p->con.value;
		case typeOpr:
		switch(p->opr.oper) {
			case UMINUS:	return -ex(p->opr.op[0]);
			case '+':	return ex(p->opr.op[0]) + ex(p->opr.op[1]);
			case '-':	return ex(p->opr.op[0]) - ex(p->opr.op[1]);
			case '*':	return ex(p->opr.op[0]) * ex(p->opr.op[1]);
			case '/':	return ex(p->opr.op[0]) / ex(p->opr.op[1]);
			
		}
	}
	return 0;
} 
