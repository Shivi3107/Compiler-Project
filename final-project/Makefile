all:
	@ yacc -d src/compiler_ST.y && lex src/compiler.l && mkdir -p bin && gcc lex.yy.c y.tab.c -o bin/a1.out && bin/a1.out < text_case/1.txt
	@ yacc -d src/compiler_C.y && lex src/compiler.l && mkdir -p bin && gcc lex.yy.c y.tab.c -o bin/a.out && bin/a.out < text_case/1.txt
clean:
	@ rm -rf bin && rm -f lex.yy.c y.tab.c y.tab.h ans ans.c
