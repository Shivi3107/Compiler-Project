all:
	@ yacc -d src/calculator.y && lex src/calculator.l && mkdir -p bin && gcc lex.yy.c y.tab.c -o bin/a.out && bin/a.out
test1:
	@ bin/a.out < test/test1.txt
test2:
	@ bin/a.out < test/test2.txt
test3:
	@ bin/a.out < test/test3.txt
test4:
	@ bin/a.out < test/test4.txt
clean:
	@ rm -rf bin && rm -f lex.yy.c y.tab.c y.tab.h
