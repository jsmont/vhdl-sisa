; Incluir las macros necesarias
.include "macros.s"


.set PILA, 0x4000               ;una posicion de memoria de una zona no ocupada para usarse como PILA


.text
       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
       ; Inicializacion
       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
       $MOVEI r1, RSG
       $MOVEI r5, 0       ;contador de excepción
       addi   r4, r5, 0
       $MOVEI r7, PILA
       wrs    s5, r1      ;inicializamos en S5 la direccion de la rutina de antencion a las interrupcciones
       movi   r1, 0xF
       out     9, r1      ;activa todos los visores hexadecimales
       movi   r1, 0xFF
       out    10, r1      ;muestra el valor 0xFFFF en los visores
       movi   r6, 1
       wrs    s0, r6
       $MOVEI r6, inici   ;adreça de la rutina principal
       wrs    s1, r6
       reti

       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
       ; Rutina de servicio de interrupcion
       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
RSG:   $push  R0, R1, R2, R3, R4, R6 
       rds    R1, S2                    ;consultamos el contenido de S2
       movi   R2, 15 
       cmplt  R3, R1, R2                ;si es menor a 15 es una excepción
       bz     R3, __fin                 ;saltamos a las interrupciones si S2 es igual a 15
       addi   r5, r5, 1                          
__fin: out    10, r5      ;muestra el numero de la interrupcion atendida en los visores hexadecimales
       $pop  R6, R4, R3, R2, R1, R0 
       reti


       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
       ; Rutina principal
       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
inici: 
	movi R0, 50        ;Entre estas dos instrucciones se coloca la instruccion erronea
binf:  divu r3, r0, r4
       addi r0, r0, -1
       bnz   r0,binf      ;bucle infinito a la espera de que lleguen interrupciones
       halt
