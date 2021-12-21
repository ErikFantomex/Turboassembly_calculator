;------------------------------------------------------------------------
;Macros
;------------------------------------------------------------------------
; Imprime un n?mero de 2 d?gitos
imprimeNumero macro numero
    mov al, numero
    aam; Separa un n?mero de 4 d?gitos en 2 y 2 (en ah y al)
    
    mov dl, ah
    mov ah, 02h
    add dl, 30h; Ajuste para el n?mero en ascii
    int 21h
    
    mov al, numero
    aam
    mov dl, al
    mov ah, 02h
    add dl, 30h; Ajuste para el n?mero en ascii
    int 21h
    
    ;mov ax, 0000h
endm 
;------------------------------------------------------------------------
;Imprime un mensaje desde el segmento de datos
imprimeMensaje macro mensaje  
    mov ax, @data
    mov ds, ax
    
    mov ah, 09h
    lea dx, mensaje
    int 21h
endm
;------------------------------------------------------------------------
;Modelo del sistema
;------------------------------------------------------------------------
.model small
;------------------------------------------------------------------------

;------------------------------------------------------------------------
;Tama?o de la pila
;------------------------------------------------------------------------
.stack 100h
;------------------------------------------------------------------------

;------------------------------------------------------------------------
;Segmento de datos
;------------------------------------------------------------------------
.data
    ;------------------------------------------------------------------------
    ;Menu de inicio
    ;------------------------------------------------------------------------ 
    saltoLinea  db ' ', 13, 10, '$'
    menu    db "Bienvenido, elija una opci?n:", 13, 10
            db "1) Programa 01", 13, 10
            db "2) Programa 05", 13, 10
            db "3) Programa 09", 13, 10
            db "4) Programa 13", 13, 10
            db "0) Salir", 13, 10
            db ' ', 13, 10
            db "Selecci?n: ", '$'  
    
            opc     db ?
    ;------------------------------------------------------------------------
    ;Mensajes de encabezados
    ;------------------------------------------------------------------------
    opcion01 db "Operacion 1 Imprimir numeros primos (valor decimal y hexadecimal) utilizando un valor maximo de 25.", '$'
    opcion02 db "Operacion 2 Verificar cuales corresponden a la serie de numeros primos y multiplos de 4.", '$'
    opcion03 db "Operacion 3 Sumar los numeros mayores a 3 de la serie de numeros primos.", '$'
    opcion04 db "Operacion 4 Mostrar la serie X = n + 2 con la serie generada de numeros primos.", '$'
    ;------------------------------------------------------------------------
    ;De la operaci?n 1 ISA
    ;------------------------------------------------------------------------
    Enunc       DB "Obtener Los Numeros Primos Hasta el 25...",13,10,"$" ;Enunciado
    Encabezado  DB "Hexadecimal Decimal",13,10,"$" 
    CRLF        DB 13,10,"$" ;Salto de Linea
    Unidades    DB 0 ;Para imprimir un numero de dos cifras
    Decenas     DB 0
    Residuo     DB 0 ;Para convertir a Hexadecimal
    num         DB 0 ;Numero Actual a Determinar si es primo o no
    contador    DB 0 ;Auxiliar que ayuda a Determinar si es primo o no
    ;------------------------------------------------------------------------
    ;De la operacion 2 Giova
    ;------------------------------------------------------------------------
    iteraciones db 0 ;Contar hasta 10 peticiones de dato
    uni         db 0 ;Unidades para la captura de datos
    dece        db 0 ;Decenas para la captura de datos
    cent        db 0 ;Centenas para la captura de datos
    nume        db 0 ;N?mero de tres digitos para operar con el despues de convertir unidades,decenas, centenas
    salto       db 13,10,"$" ;Salto de Linea
    encabezado2 db "Introduzca por favor 10 datos de hasta 3 digitos",13,10,"$" ;Mensaje para pedir los 10 datos a comparar
    pedir       db "Introducir: ",13,10,"$" ;Se pedira un numero despues de hacer operaciones con el anterior hasta pedir 10
    primosi     db "El numero SI esta en la serie de numeros primos",13,10,"$" ;Si esta en la serie
    primono     db "El numero NO esta en la serie de numeros primos",13,10,"$"; No esta en la serie
    mulsi       db "El numero SI es multiplo de 4",13,10,"$" ;Si es m?ltiplo de 4
    mulno       db "El numero NO es multiplo de 4",13,10,"$" ;Si es m?ltiplo de 4
    ;------------------------------------------------------------------------
    ;De la operacion 3 Horacio
    ;------------------------------------------------------------------------
    sum     db ?
    prom    db ?
    msg1    db 13,10,'Introduce un num: $'
    msg2    db 13,10,"Suma = $"
    msg3    db 13,10,'Promedio = $'
    ;------------------------------------------------------------------------
    ;De la operacion 4 LUIS
    ;------------------------------------------------------------------------
    solicitud   db "Numero hasta el cual se quiere llegar(dos cifras)[n]: ", '$'
    serieG      db "Serie solicitada: ", '$'
    separador   db ", ", '$'
    n           db ?
    cont1       db ?
    cont11      dw ?
    cont2       db ?
    contPrimo   db ?
    ;------------------------------------------------------------------------

;------------------------------------------------------------------------
;Segmento del c?digo
;------------------------------------------------------------------------
.code
inicio:
    ;Inicializamos los datos
    mov ax, @data
    mov ds, ax
    
    siguiente0:
    call mostrarMenu
    
    ;Leemos la opcion elegida y la transformamos a n?mero
    mov ah, 01h
    int 21h
    sub al, 30h
    mov opc, al
    
    ;REALIZAR SALTOS SEG?N LA SELECCI?N
    cmp opc, 01
    jne siguiente1
    call operacion01
    
    siguiente1:
    cmp opc, 02
    jne siguiente2
    call operacion02
    
    siguiente2:
    cmp opc, 03
    jne siguiente3
    call operacion03
   
    siguiente3:
    cmp opc, 04
    jne siguiente0
    call operacion04
    
    ;Finalizamos ejecuci?n
    mov ax, 4c00h
    int 21h

;------------------------------------------------------------------------
;Ejercicios del trabajo
;------------------------------------------------------------------------
;Ejercicio 1
;------------------------------------------------------------------------
operacion01 proc
    call limpiarPantalla
    imprimeMensaje opcion01

    imprimeMensaje Enunc

    imprimeMensaje Encabezado ;Mostramos el encabezado
   

    MOV CX, 0 ;Inicializamos el contador CX en 0 para evitar errores
    MOV num, 2 ;Inicamos nuestro numero en 2 para empezar a encontrar numeros primos  

    PRIMOS:   

        CMP num, 25 ;Aqui elegimos el valor limite a buscar numeros primos. Hasta ahorita es 99.
        JE FIN 

    ;PARA SABER SI UN NUMERO SERA PRIMO, INTENTAMOS DIVIDIRLO ENTRE SUS ANTECESORES. SI SU RESIDUO NO ES CERO, ENTONCES ES PRIMO. 
    ;EXCLUYENDO LA DIVISION ENTRE 1.
         
    MOV contador, 0  
    MOV CL, num ;Asignamos al contador CX el valor del numero actual para comenzar a iterar
    DEC CX

    CICLO1:     

        CMP CX,0
        JZ ESPRIMO

        MOV AX, 0000H ;Vaciamos el registro para no tener errores
        MOV AL, num ;Le asigamos el valor actual de nuestro numero al registro AX para operar con el

        MOV BL, CL ;Vamos a dividir entre el contador CX

        DIV BL ;Divimos nuestro numero entre el contador CX y si el residuo es 0 entonces no es un numero primo
        CMP AH, 0
        JZ INCREMENTAR

        LOOP CICLO1

    INCREMENTAR:

        INC contador
        CMP contador, 2 ;Si el numero es divisible entre dos numeros, entonces no es primo. Dos numeros debido a que el 1 siempre va estar.
        JZ NOPRIMO

        DEC CX

        JMP CICLO1

    ESPRIMO:

        ;Primero convertimos el numero a hexadecimal y lo imprimimos

        JMP CONVERTIR

    DECIMAL:

        ;Tenemos que dividir nuestro numero de dos cifras para poder imprimirlo 

        MOV AL, num ;El numero que tenemos lo movemos a AL   

        AAM ;AJUSTA EL VALOR EN AL A DECIMAL. POR EJEMPLO AL:234 = AH:23 Y AL:4

        MOV Unidades, AL ;En AL se quedan las unidades por la operacion anterior
        MOV Decenas, AH ;En AH se quedan las decenas

        MOV DL, Decenas ;Ajustamos el ASCII a Decimal
        ADD DL, 48
        MOV AH, 02H ;Mandamos a imprimir con la interrupcion 21
        INT 21H

        MOV DL, Unidades ;Ajustamos el ASCII a Decimal
        ADD DL, 48 
        INT 21H ;Mandamos a imprimir con la interrupcion 21

        LEA DX, CRLF ;Salto de Linea
        MOV AH, 09H
        INT 21H

        INC num ;Incrementamos nuestro contador y volvemos al ciclo
        JMP PRIMOS

    NOPRIMO:

        INC num ;Si no es primo solo incrementamos nuestro contador y volvemos al ciclo
        JMP PRIMOS

    FIN:

        MOV AX, 4C00H
        INT 21H    

    CONVERTIR:

        ;Utilizamos el metodo de dividir entre 16 para convertir de decimal a hexadecimal 
        MOV AL, num
        MOV BL, 16
        DIV BL

        MOV Residuo, AH ;El residuo de la division lo guardamos

        MOV DL, AL
        ADD DL, 48 ;Imprimimos la primera cifra
        MOV AH, 02H ;Mandamos a imprimir con la interrupcion 21
        INT 21H

        ;Comparamos el residuo para obtener su equivalente en Hexadecimal si es que es mayor a 9
        CMP Residuo,10
        JE IMPRIMIRA

        CMP Residuo,11
        JE IMPRIMIRB

        CMP Residuo,12
        JE IMPRIMIRC

        CMP Residuo,13
        JE IMPRIMIRD

        CMP Residuo,14
        JE IMPRIMIRE

        CMP Residuo,15
        JE IMPRIMIRF

        ;Si no es mayor a 9 solamento lo imprimimos
        MOV DL, Residuo
        ADD DL, 48
        MOV AH, 02H ;Mandamos a imprimir con la interrupcion 21
        INT 21H
        MOV DL, 32 ;Imprimir un separador
        INT 21H
        JMP DECIMAL

    ;Imprime la letra si es el caso y un separador
    IMPRIMIRA:
        MOV DL, 65
        MOV AH, 02H
        INT 21H
        MOV DL, 32
        INT 21H
        JMP DECIMAL
    IMPRIMIRB:
        MOV DL, 66
        MOV AH, 02H
        INT 21H
        MOV DL, 32
        INT 21H
        JMP DECIMAL
    IMPRIMIRC:
        MOV DL, 67
        MOV AH, 02H
        INT 21H
        MOV DL, 32
        INT 21H
        JMP DECIMAL
    IMPRIMIRD:
        MOV DL, 68
        MOV AH, 02H
        INT 21H
        MOV DL, 32
        INT 21H
        JMP DECIMAL
    IMPRIMIRE:
        MOV DL, 69
        MOV AH, 02H
        INT 21H
        MOV DL, 32
        INT 21H
        JMP DECIMAL
    IMPRIMIRF:
        MOV DL, 70
        MOV AH, 02H
        INT 21H
        MOV DL, 32
        INT 21H
        JMP DECIMAL
    
    .exit
operacion01 endp

;------------------------------------------------------------------------
;Ejercicio 5
;------------------------------------------------------------------------
operacion02 proc
    call limpiarPantalla
    imprimeMensaje opcion02
    
    ;Mostramos el enunciado para pedir los datos
    imprimeMensaje encabezado2
    peticiones:
        cmp iteraciones, 10 ;Se parar? el programa cuando haya 10 datos.
        jne Continuar
        .exit
        
        Continuar: 
        ;Mostramos el enunciado para pedir los datos
        imprimeMensaje pedir
        
        ;Capturamos el primer dato introducido
        mov ah,01h
        int 21h
        sub al,30h
        mov cent,al
        mov al,cent
        
        ;Detectamos las centenas del dato introducido
        mov bl,100  ;Se multiplica por 100 el digito de las centenas
        mul bl
        mov nume,al ;Se ponen las centenas en el numero operable que quedara al final 
        
        mov ah,01h
        int 21h
        sub al,30h
        mov dece,al
        mov al,dece
        
        ;Detectamos las decenas del dato introducido
        mov bl,10  ;Se multiplica por 10 el digito de las decenas
        mul bl
        add al,nume ;Se suman las decenas al numero operable que quedara al final 
        mov nume, al ;Ponemos la suma de decenas y centenas a la variable nume
        
        mov ah,01h
        int 21h
        sub al,30h
        mov uni,al
        mov al,uni
        
        ;Detectamos las unidades del dato introducido
        add al, nume
        mov nume, al ;Ponemos la suma de unidades, decenas y centenas en la variable nume
        jmp compararprimo ;Llevaremos este numero a comparar con los numeros primos que se tienen en la serie  
            
    compararprimo:
        ;Los numeros primos de las series hasta el n?mero 25 son: 002, 003, 005, 007, 011, 013, 017, 019, 023
        cmp nume, 002 ;Comparar con 2
        je esprimo2
        cmp nume, 003 ;Comparar con 3
        je esprimo2
        cmp nume, 005 ;Comparar con 5
        je esprimo2
        cmp nume, 007 ;Comparar con 7
        je esprimo2
        cmp nume, 011 ;Comparar con 11
        je esprimo2
        cmp nume, 013 ;Comparar con 13
        je esprimo2
        cmp nume, 017 ;Comparar con 17
        je esprimo2
        cmp nume, 019 ;Comparar con 19
        je esprimo2
        cmp nume, 023 ;Comparar con 23
        je esprimo2
        ;Si es igual a uno de los numeros anteriores, salta a esprimo para imprimir que esta dentro de la serie
        jmp noesprimo ;Si no es igual a ninguno de los numeros, entonces no esta en la serie y se indicar?

    esprimo2:
        ;Se llegar? aqui si el n?mero esta en la serie de los n?meros primos
        mov ah,09h
        lea dx, salto ;Imprimimos un salto de linea
        int 21h
        
        mov ah,09h
        lea dx, primosi ;Imprimimos que esta en la serie
        int 21h
        
        jmp compararmultiplo
    
    noesprimo:
        ;Se llegar? aqui si el numero no esta en la serie de los numeros primos
        mov ah,09h
        lea dx, salto ;Imprimimos un salto de linea
        int 21h
        
        mov ah,09h
        lea dx, primono ;Imprimimos que no esta en la serie
        int 21h
        
        jmp compararmultiplo

    compararmultiplo:
        ;Comparamos si es multiplo de 4
        mov ah, nume ;Dividiendo
        mov dx, 000
        mov cx, 004  ;Divisor
        div cx    ;Divide el n?mero entre 4
        
        
        cmp dx, 000  ;El residuo se guardo en dx, y si el residuo es 0 significa que el numero es m?ltiplo
        je esmultiplo ;Si es multiplo saltamos a esmultiplo
        jmp noesmultiplo ;Si no es multiplo llegara hasta aca y saltara a noesmultiplo
    
    esmultiplo:
        ;Se llegar? aqui si el n?mero es multiplo de 4
        mov ah,09h
        lea dx, salto ;Imprimimos un salto de linea
        int 21h
        
        mov ah,09h
        lea dx, mulsi ;Imprimimos que es multiplo de 4
        int 21h
        
        ;Le sumamos uno al contador de iteraciones y volvemos a pedir otro n?mero en peticiones
        mov ah,iteraciones
        add ah,1
        mov iteraciones,ah
        jmp peticiones

    noesmultiplo:
        ;Se llegar? aqui si el n?mero no es multiplo de 4
        mov ah,09h
        lea dx, salto ;Imprimimos un salto de linea
        int 21h
        
        mov ah,09h
        lea dx, mulno ;Imprimimos que no es multiplo de 4
        int 21h
        
        ;Le sumamos uno al contador de iteraciones y volvemos a pedir otro n?mero en peticiones
        mov ah,iteraciones
        add ah,1
        mov iteraciones,ah
        jmp peticiones

    
    operacion02 endp

;------------------------------------------------------------------------
;Ejercicio 09  
;serie de primos 2,3,5,7,11,13,17,19,23  
;------------------------------------------------------------------------    
operacion03 proc
    call limpiarPantalla
    imprimeMensaje opcion03
    
    imprimeMensaje saltoLinea
    
    mov sum, 0
    mov cl, 10
    l1:
        imprimeMensaje msg1
        mov ah, 01h
        int 21h
        sub al, 30h
        mov bl, 10
        mul bl
        mov n, al
        
        mov ah, 00
        mov cont11, ax
        
        mov ah, 01h
        int 21h
        sub al, 30h
        add n, al
        
        mov bl, 3
        cmp bl, n 
        jnc fin2
        
        mov ah, 00
        add cont11, ax
        
        mov cont1, 1
        mov contPrimo, 0
        verifPrimo2:
            mov bl, cont1
            cmp n, bl
            jc fin3
            
            mov ax, cont11
            mov bl, cont1
            div bl
            mov residuo, ah
            cmp residuo, 0
            je incrementa2
            jne salta2
            
            incrementa2:
                inc contPrimo
            salta2:
                inc cont1
            jmp verifPrimo2
        fin3:
        cmp contPrimo, 2
        jne fin2
        mov bl, n
        add sum, bl
        
        fin2:

        
        loop l1          ;Cicla todas las instrucciones adentro de l1 hasta que CX=0
        imprimeMensaje saltoLinea
        
        imprimeMensaje msg2
        imprimeNumero sum
        imprimeMensaje saltoLinea
        
        imprimeMensaje msg3  
        mov ah, 00
        mov al, sum
        mov bl, 10
        div bl           
        mov prom, al
        imprimeNumero prom  
    
        .exit
        
        operacion03 endp

;------------------------------------------------------------------------
;Ejercicio 13
;------------------------------------------------------------------------
operacion04 proc
    call limpiarPantalla
    ;Mensajes con informaci?n
    imprimeMensaje opcion04
    imprimeMensaje saltoLinea
    
    imprimeMensaje solicitud
    
    mov ah, 01h
    int 21h
    sub al, 30h
    mov bl, 10
    mul bl
    mov n, al

    mov ah, 01h
    int 21h
    sub al, 30h
    add n, al

    imprimeMensaje saltoLinea
    imprimeMensaje saltoLinea
    imprimeMensaje serieG
    
    ; Comienza a generar la serie x = n + 2 con la serie de numeros primos
    mov cl, n; N?mero l?mite del cual verificaremos si es primo para ponerlo en la serie
    mov cont1, 1  
    mov cont11,1
    imprimeNum:
        mov cont2, 1
        mov contPrimo, 0
        verifPrimo:
            mov bl, cont2
            cmp cont1, bl
            jc salir3
            
            mov ax, cont11
            mov bl, cont2
            div bl
            mov residuo, ah
            cmp residuo, 0
            je incrementa
            jne salta
            
            incrementa:
                inc contPrimo
            salta:
                inc cont2
        jmp verifPrimo
        salir3:
        cmp contPrimo, 2
        jne salir2
        
        imprimirNum:
            mov bl, cont1
            add bl, 2
            imprimeNumero bl
            imprimeMensaje separador
        salir2:
            inc cont1
            inc cont11
    loop imprimeNum
    
    salir1:
        .exit
    operacion04 endp
    
;------------------------------------------------------------------------    
;Funciones extras
;------------------------------------------------------------------------
limpiarPantalla proc
    ;Se borra y crea una nueva ventana de 80x25
    mov ah, 06h; BORRAR - Instruccion para desplazar l?neas hacia arriba
    mov al, 0; n?mero de lineas a desplazar(al ser 0 se desplaza toda)
    mov bh, 0fh; atributo a usar en lineas borradas
    mov cx, 0000h; l?nea y columna donde empieza la ventana de texto
    mov dx, 184fh; linea y columna donde acaba la ventana de texto
    int 10h

    mov ah, 02h; BORRAR - Interrupci?n para posicionar el curor
    mov bh, 00; pagina de video
    mov dh, 00; linea donde situar cursor
    mov dl, 00; columna donde situarlo
    int 10h
    
    ret
limpiarPantalla endp
;------------------------------------------------------------------------
mostrarMenu proc
    call limpiarPantalla
    ;Utilizamos la macro imprimeMensaje para mostrar las opciones
    imprimeMensaje menu
    
    ret
mostrarMenu endp
;------------------------------------------------------------------------

end inicio