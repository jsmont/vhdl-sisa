; Incluir las macros necesarias
.include "macros.s"


.set PILA, 0x4000               ;una posicion de memoria de una zona no ocupada para usarse como PILA

.data
       .balign 2

       exceptions_vector: 
           .word RSE_default_halt   ; 0 Instrucción ilegal 
           .word RSE_default_halt   ; 1 Acceso a memoria no alineado 
           .word RSE_default_resume ; 2 Overflow en coma flotante
           .word RSE_default_halt   ; 3 División por cero

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
       $MOVEI r6, inici   ;adreça de la rutina principal
       jmp    r6

       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
       ; Rutina de servicio de interrupcion
       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
       RSG: ; Salvar el estado 
            $push  R0, R1, R2, R3, R4, R5, R6 
            rds    R1, S0 
            rds    R2, S1 
            rds    R3, S3 
            $push  R1, R2, R3 
            rds    R1, S2                    ;consultamos el contenido de S2
            out    10, r1
            movi   R2, 15 
            cmplt  R3, R1, R2                ;si es menor a 15 es una excepción
            bz     R3, __interrupcion        ;saltamos a las interrupciones si S2 es igual a 15
       __excepcion: 
            movi   R2, lo(exceptions_vector) 
            movhi  R2, hi(exceptions_vector) 
            add    R1, R1, R1                ;R1 contiene el identificador de excepción
            add    R2, R2, R1 
            ld     R2, 0(R2) 
            jal    R6, R2 
            bnz    R3, __finRSG 
       __interrupcion: 
            getiid R1 
            add    r1, r1, r1
            ld     r3, 0(r1)
            addi   r3, r3, 1
            st     0(r1), r2
            movi   r2, 6
            cmpeq  r1, r1, r2
            bz     r1, __switch
       __finRSG:    ;Restaurar el estado 
            $pop  R3, R2, R1 
            wrs   S3, R3 
            wrs   S1, R2 
            wrs   S0, R1 
            $pop  R6, R5, R4, R3, R2, R1, R0 
            reti 
       __switch:
            in    r1, 8
            movi  r2, 1
            and   r1, r1, r2
            cmpeq r3, r1, r2
            bnz   r3, __finRSG
            movi  r1, 0
            divu  r2, r2, r1
            bnz   r3, __finRSG


       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
       ; Rutina principal
       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
inici: 
       ei               ;activa las interrupciones
binf:	 movi R0, 0       ;Entre estas dos instrucciones se coloca la instruccion erronea 
       bz  r0,binf      ;bucle infinito a la espera de que lleguen interrupciones
       halt


RSE_default_halt:   HALT 
RSE_default_resume: JMP R6 
