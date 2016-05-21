#!/usr/bin/zsh


echo "Ensamblando ..."
#compila el ensamblador
sisa-as entrada.s -o entrada.o

echo "Compilando ..."
#compila el c (solo compila)  (para ver el codigo fuente entre el codigo desensamblado hay que compilar con la opcion -O0)
sisa-gcc -g3 -c HelloWorld2.c -o HelloWorld2.o

echo "Linkando ..."
#Linkamos los ficheros (la opcion -s es para que genere menos comentarios)
sisa-ld -s -T system.lds entrada.o HelloWorld2.o -o temp_HelloWorld2.o

#desensamblamos el codigo
sisa-objdump -d --section=.sistema temp_HelloWorld2.o >HelloWorld2.code
sisa-objdump -s --section=.sysdata temp_HelloWorld2.o >HelloWorld2.data


limpiar.pl codigo HelloWorld2.code
limpiar.pl datos  HelloWorld2.data

#Linkamos los ficheros (sin la opcion -s es para que genere mas comentarios) y desensamblamos
#(para ver el codigo fuente entre el codigo desensamblado hay que haber compilado con la opcion -O0)
sisa-ld -T system.lds entrada.o HelloWorld2.o -o temp_HelloWorld2.o

sisa-objdump -S -x --section=.sistema temp_HelloWorld2.o >HelloWorld2.dis
sisa-objdump -S -x --section=.sysdata temp_HelloWorld2.o >>HelloWorld2.dis

rm entrada.o temp_HelloWorld2.o HelloWorld2.o HelloWorld2.code HelloWorld2.data


