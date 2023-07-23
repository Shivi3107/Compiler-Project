all:
	@ yacc -d src/calculator.y && lex src/calculator.l && mkdir -p bin && gcc lex.yy.c y.tab.c src/calculator.c -o bin/a.out && bin/a.out
clean:
	@ rm -rf bin && rm -f lex.yy.c y.tab.c y.tab.h
