#!/usr/bin/zsh


echo "Ensamblando ..."
#compila el ensamblador
sisa-as entrada.s -o entrada.o

echo "Compilando ..."
#compila el c (solo compila)  (para ver el codigo fuente entre el codigo desensamblado hay que compilar con la opcion -O0)
sisa-gcc -g3 -c -Wall -Wextra lib_sisa.c -o lib_sisa.o
sisa-gcc -g3 -c -Wall -Wextra MaquinaEscribir.c -o MaquinaEscribir.o

echo "Linkando ..."
#Linkamos los ficheros (la opcion -s es para que genere menos comentarios)
sisa-ld -s -T system.lds entrada.o lib_sisa.o MaquinaEscribir.o -o temp_MaquinaEscribir.o

#desensamblamos el codigo
sisa-objdump -d --section=.sistema temp_MaquinaEscribir.o >MaquinaEscribir.code
sisa-objdump -s --section=.sysdata temp_MaquinaEscribir.o >MaquinaEscribir.data

limpiar.pl codigo MaquinaEscribir.code
limpiar.pl datos MaquinaEscribir.data

#Linkamos los ficheros (sin la opcion -s es para que genere mas comentarios) y desensamblamos
#(para ver el codigo fuente entre el codigo desensamblado hay que haber compilado con la opcion -O0)
sisa-ld -T system.lds entrada.o lib_sisa.o MaquinaEscribir.o -o temp_MaquinaEscribir.o

sisa-objdump -S -x --section=.sistema temp_MaquinaEscribir.o >MaquinaEscribir.dis
sisa-objdump -S -x --section=.sysdata temp_MaquinaEscribir.o >>MaquinaEscribir.dis

rm entrada.o lib_sisa.o temp_MaquinaEscribir.o MaquinaEscribir.o MaquinaEscribir.code MaquinaEscribir.data
