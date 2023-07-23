1. Overview / Code Explaination
	It will consist of aminly two files in src directory
		first one --> "" compiler_ST.y "" ==> for printing Syntax Tree
				a1.out  ==> exacutable file for printing Syntax Tree in bin directory
		second one --> "" compiler_C.y "" ==> for printing C code
				a.out  ==> exacutable file for printing C code in bin directory
		
	In both files all part " Creating Tree ", " global declaration ", " Function defintion " and " Main block " are seperated neatly.
	

2. How to run
	--> you can run it by command ""make"", and it will run on test case which is in file ""1.txt"" 
	--> after make you can directly use exaxutable file with your input file such that
		--> "" bin/a1.out < input.file "" --> for Syntax Tree output
		--> "" bin/a.out < input.file "" --> for C code output
	--> you can compile and run C code output by the command
		--> "" ./sp.sh input.file ""
		
3. Constructs
	It can do arithmetic operations(like +,-,*,/, mod), logical operations &
		conditional operations but it can’t handle binary operators.
	can't able to deal with multi-dimension array.
	
