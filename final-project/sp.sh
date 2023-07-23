make clean
make
clear
bin/a.out < $1 > ans.c
gcc -o ans ans.c
./ans
