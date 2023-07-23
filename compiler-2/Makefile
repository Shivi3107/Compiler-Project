all:
	@ yacc -d src/compiler.y && lex src/compiler.l && mkdir -p bin && gcc lex.yy.c y.tab.c -o bin/a.out && bin/a.out < 1
clean:
	@ rm -rf bin && rm -f lex.yy.c y.tab.c y.tab.h
