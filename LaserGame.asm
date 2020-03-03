;EQUIVALENCIAS USADAS PARA REPRESENTAR LAS POSICIONES DE LA IMPRESION DE CADENAS EN PANTALLA Y LOS COLORES 

;Posiciones en pantalla para imprimir mensajes para el usuario
INIXMSJ EQU 3
INIYMSJ EQU 23 

;Posiciones en pantalla para pedir al usuario datos de entrada
INIXPEDIR EQU 54
INIYPEDIR EQU 23 

FILLASERARR EQU 2
FILLASERABJ EQU 20
COLLASERIZQ EQU 7
COLLASERDCH EQU 45

;Para escribir en color (fondo frontal)
COLORRESOLVER EQU 0Bh 
COLORMARCAR EQU 9Bh

;Constantes de tablero y espejos
NUMCASILLASJUEGO EQU 64
NUMESPEJOSDEBUG EQU 8 
NUMCOLFILJUEGO EQU 8
NUMTIPOSESPEJOS EQU 4   

;Caracter de marcado de celda
CARACTMARCADO EQU '*'

data segment       
  ;Posicion en MatrizJuego
  filMatrizJuego DB ?  ;0-7
  colMatrizJuego DB ?  ;0-7
  posMatrizJuego DB ?  ;0-63  

  ;Matriz tablero de juego
  matrizJuego DB 64 dup(0)

  ;Para el numero de espejos del juego, las posiciones que ocupan en el tablero y su tipo
  vectorPosEspejos DB 2, 13, 16, 30, 41, 43, 53, 63, 12 dup(0)
  vectorTiposEspejos DB 1, 4, 2, 3, 2, 4, 2, 4, 12 dup(0)
  numEspejos DB 20
  
  ;Para los espejos que el usuario marca como existentes  
  vectorPosEspejosMarcados DB 20 dup (-1)
  numEspejosMarcados DB 0

  ;Posicion desde la que se dispara el laser
  posLaser DB ?
  direcDisparoLaser DB ?  ;0:arriba
                          ;1:derecha
                          ;2:abajo
                          ;3:izquierda

  ;Para calcular trayectoria
  ;posSalidaLaser DB ?                       
  cambioTrayTipo1 DB 0, 3, 2, 1
  cambioTrayTipo2 DB 1, 0, 3, 2
  cambioTrayTipo3 DB 2, 1, 0, 3
  cambioTrayTipo4 DB 3, 2, 1, 0   

  ;Para imprimir la la MatrizJuego al resolver
  caractImprimirMatrizJuego DB ' '  ; espacioEnBlanco
                            DB '³'  ; espejoTipo1 
                            DB '/'  ; espejoTipo2
                            DB 'Ä'  ; espejoTipo3 
                            DB '\'  ; espejoTipo4 

  ;Para el PROC colocarCursor
  fila    DB ?
  colum   DB ?

  ;Para la E de texto por parte del usuario
  cadenaE DB 7 dup (0)                                                  
                                                     
  tablero DB "F,C         1   2   3   4   5   6   7   8              ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿", 10, 13
          DB "            L1  L2  L3  L4  L5  L6  L7  L8             ³             ³", 10, 13
          DB "          ³   ³   ³   ³   ³   ³   ³   ³   ³            ³  LASER1-32  ³", 10, 13
          DB "      ÄÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÄ        ³  _          ³", 10, 13
          DB "1  L32    ³   ³   ³   ³   ³   ³   ³   ³   ³    L9      ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ", 10, 13
          DB "      ÄÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÄ", 10, 13
          DB "2  L31    ³   ³   ³   ³   ³   ³   ³   ³   ³    L10     ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿", 10, 13
          DB "      ÄÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÄ        ³             ³", 10, 13
          DB "3  L30    ³   ³   ³   ³   ³   ³   ³   ³   ³    L11     ³MARCAR1-8,1-8³", 10, 13
          DB "      ÄÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÄ        ³_            ³", 10, 13
          DB "4  L29    ³   ³   ³   ³   ³   ³   ³   ³   ³    L12     ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ", 10, 13
          DB "      ÄÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÄ", 10, 13
          DB "5  L28    ³   ³   ³   ³   ³   ³   ³   ³   ³    L13     ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿", 10, 13
          DB "      ÄÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÄ        ³             ³", 10, 13
          DB "6  L27    ³   ³   ³   ³   ³   ³   ³   ³   ³    L14     ³   RESOLVER  ³", 10, 13
          DB "      ÄÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÄ        ³   _         ³", 10, 13
          DB "7  L26    ³   ³   ³   ³   ³   ³   ³   ³   ³    L15     ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ", 10, 13
          DB "      ÄÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÄ", 10, 13
          DB "8  L25    ³   ³   ³   ³   ³   ³   ³   ³   ³    L16     ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿", 10, 13
          DB "      ÄÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÄ        ³             ³", 10, 13
          DB "          ³   ³   ³   ³   ³   ³   ³   ³   ³            ³    SALIR    ³", 10, 13
          DB "           L24 L23 L22 L21 L20 L19 L18 L17             ³    _        ³", 10, 13
          DB "                                                       ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ$"

  ;Mensajes de Interfaz
  msjDebug DB "Modo debug (con tablero precargado)? (S/N)$"  
  msjOpcion DB "Introduce Mf,c para marcar R S o Lz para disparar: $" 
  msjPerdida DB "Has perdido la partida$"
  msjGanada DB "Enhorabuena! Has ganado la partida$" 
   
data ends



stack segment
  DW 128 DUP(0)
stack ends



code segment

;*************************************************************************************                                                                                                                        
;********** Procedimientos utilizados en practicas previas ****************************                                                                                                                        
;*************************************************************************************                                                                                                                        
  
  ;Convierte una cadena de caracteres a un numero entero 
  ;E: DX contiene la direccion de la cadena a convertir (debe apuntar al 1er caracter numerico y terminar en 13 o '$')
  ;S: AX contiene el resultado de la conversion, 0 si hay error o si la cadena a convertir es "0"
  CadenaANumero PROC
    push bx
    push cx
    push dx ; cambia con MUL de 16bits
    push si 
    push di
    
    mov si, dx
    xor ax, ax    
    mov bx, 10  
    
    cmp [si], '-'
    jne BCadNum
    
    mov di, si  ;Ajustes si viene un '-' como primer caracter
    inc si

   BCadNum:
    mov cl, [si]          ;Controles de fin
    cmp cl, 13
    je compruebaNeg
    cmp cl, '$'
    je compruebaNeg
    
    cmp cl, '0'
    jl error
    cmp cl, '9'
    jg error
    
    mul bx
    sub cl, '0'
    xor ch, ch
    add ax, cx
    inc si     
    jmp BCadNum
        
   compruebaNeg:   
    cmp [di], '-'
    jne finCadenaANumero
    neg ax
    jmp finCadenaANumero
   
   error:
    xor ax, ax
   
   finCadenaANumero:
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    ret
  CadenaANumero ENDP
  

                                                                                                                        
  ;Convierte un numero entero a una cadena de caracteres terminada en $
  ;E: AX contiene el numero a convertir
  ;   DX contiene la direccion de la cadena donde almacena la cadena resultado
  NumeroACadena PROC 
    push ax
    push bx
    push cx
    push dx
    push di
    
    mov bx, 10
    mov di, dx
    
    xor cx, cx

    cmp ax, 0  
    jge BNumCad

    mov [di], '-'
    inc di 
    neg ax
    
   BNumCad:        ;Bucle que transforma cada digito a caracter, de menor a mayor peso     
    xor dx, dx
    div bx
    add dl, '0'
    push dx 
    inc cx
    cmp ax, 0
    jne BNumCad

   BInvertir:      ;Bucle para invertir los restos    
    pop [di]
    inc di
    loop BInvertir

    mov [di], '$'

    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret
  NumeroACadena ENDP

 
 
  ;F: Imprime una cadena terminada en $ en la posicion donde se encuentre el cursor 
  ;E: DX direccion de comienzo de la cadena a imprimir    
  Imprimir PROC
    push ax

    mov ah,9h
    int 21h

    pop ax
    ret
  Imprimir ENDP 

 
 
  ;F: Imprime un caracter a color en la posicion actual del cursor
  ;E: AL contiene el caracter
  ;   BL el codigo de color a imprimir
  ImprimirCarColor PROC
    push ax
    push bx
    push cx

    mov ah, 9
    xor bh, bh
    mov cx, 1
    int 10h

    pop cx
    pop bx
    pop ax
    ret
  ImprimirCarColor ENDP
 
 

  ;F: Coloca el cursor en una determinada fila y colum de pantalla
  ;E: las variables fila y colum deben contener los valores de posicionamiento
  ColocarCursor PROC
    push ax
    push bx
    push dx

    mov ah, 2
    mov dh, fila
    mov dl, colum
    xor bh, bh
    int 10h

    pop dx
    pop bx
    pop ax
    ret         
  ColocarCursor ENDP                                                                                                   

   
   
  ;Lee una cadena por teclado
  ;E: DX contiene la direccion de la cadena donde se almacenar  la cadena leida                        
  ;E: la posicion 0 de esa cadena debe contener el numero maximo de caracteres a leer
  LeerCadena PROC
    push ax

    mov ah, 0ah
    int 21h

    pop ax
    ret
  LeerCadena ENDP
  
  
;**************************************************************************************
;************************** Nuevos procedimientos que se entregan ***************************
;**************************************************************************************


  ;F: Calcula un valor aleatorio entre 0 y un valor maximo dado-1
  ;E: BL valor maximo 
  ;S: AH valor aleatorio calculado
   NumAleatorio PROC
    push cx
    push dx

    mov ah,2Ch ;interrupcion que recupera la hora actual del sistema operativo
    int 21h
    ;ch=horas cl=minutos dh=segundos dl=centesimas de segundo, 1/100 secs

    xor ah,ah
    mov al,dl  
    div bl
    
    pop dx
    pop cx
    ret
  NumAleatorio ENDP 
               
               
  
  ;F: Lee un caracter por teclado sin eco por pantalla
  ;S: AL caracter ASCII leido
  LeerTeclaSinEco PROC 
    mov ah,8 ;1 para que sea con eco
    int 21h 

    ret  
  LeerTeclaSinEco ENDP   
  
  

  ;F: Oculta el cursor del teclado
  OcultarCursor PROC
    push ax
    push cx

    mov ah,1
    mov ch,20h
    xor cl,cl
    int 10h

    pop cx
    pop ax
    ret
  OcultarCursor ENDP
  
               
               
  ;F: Muestra el cusor del teclado
  MostrarCursor PROC
    push ax
    push cx

    mov ah,1
    mov ch,0Bh
    mov cl,0Ch
    int 10h

    pop cx
    pop ax
    ret
  MostrarCursor ENDP       
  


  ;F: Borra la pantalla (la deja en negro)
  BorrarPantalla PROC
    push ax
    push bx
    push cx
    push dx

    mov ah, 6h
    xor al, al
    mov bh, 7
    xor cx, cx
    mov dh, 24
    mov dl, 79
    int 10h 

    pop dx
    pop cx
    pop bx
    pop ax
    ret
  BorrarPantalla ENDP

              
  ;F: Borra la linea de mensajes completa            
  BorrarLineaMsj PROC  
    push ax
    push bx
    push cx
    push dx

    mov ah, 6h
    xor al, al
    mov bh, 7
    xor cl, cl
    mov ch, INIYMSJ 
    mov dh, INIYMSJ+1
    mov dl, 79
    int 10h 

    pop dx
    pop cx
    pop bx
    pop ax
    ret
  BorrarLineaMsj ENDP    
              
              
  
  ;F: Borra la zona de las cadenas de mensajes que imprimen en pantalla
  BorrarEntradaUsuario PROC
    push ax
    push bx
    push cx
    push dx

    mov ah, 6h
    xor al, al
    mov bh, 7
    mov cl, INIXPEDIR
    mov ch, INIYMSJ 
    mov dh, INIYMSJ+1
    mov dl, INIXPEDIR+4
    int 10h 

    pop dx
    pop cx
    pop bx
    pop ax 
    ret
  BorrarEntradaUsuario ENDP    
  
  
  
  ;F: Limpia el buffer de entrada del teclado por si tuviera algo
;  LimpiarBufferTeclado PROC
;    push ax
;
;    mov ax,0C00h
;    int 21h
;
;    pop ax
;    ret
;  LimpiarBufferTeclado ENDP               
             

;**************************************************************************************
;******************** Procedimientos de IU ********************************************
;**************************************************************************************
  ;F: Inicia el entorno grafico del juego con el mensaje de si queremos un tablero aleatorio o debug
  
  InicializarEntorno PROC  
    
    push ax
    push dx
    
    lea dx,tablero 
    call Imprimir
    
     
    
    
    mov fila,INIYMSJ
    mov colum,INIXMSJ
    
    call  ColocarCursor
    
    lea dx, msjDebug
    
    call Imprimir
    
    LeerCaracter: 
    
    call LeerTeclaSinEco
    
    cmp al, 'S'
    je MatrizDebug  
    cmp al, 'N'
    jne LeerCaracter
    
    
    Juego: 
   
    call BorrarLineaMsj
    call BorrarEntradaUsuario
    call IniciarMatrizJuego
    jmp FinInicioEntorno
    
    
    
    MatrizDebug: 
    
    
    call BorrarLineaMsj
    call BorrarEntradaUsuario
    call InicializarMatrizJuegoDebug
    jmp FinInicioEntorno
    
    
    FinInicioEntorno:
 
    
    pop dx
    pop ax
    
    ret



 InicializarEntorno ENDP





;**************************************************************************************
;******************** Procedimientos para la logica del juego *************************
;**************************************************************************************
   ;F: Insertar en la primera posicion vacia de un vector un elemento.
    ;   El vector esta inicializado a -1 y los elementos a introducir son 0...255
    ;E: AL contiene el numero a introducir
    ;   SI la direccion del 1er elemento del vector
    ;E: CX tamano del vector
    ;S: la variable apuntada por SI
  insertarVect PROC
      push cx
      push si  
          
      bucleIns:        
      cmp [si],-1
      je insertar 
      inc si     
      loop bucleIns
      
      jmp final
      
     insertar: 
      mov [si], al
     
     final: 
      pop si
      pop cx 
      ret 
  insertarVect ENDP
  
  ;F: Convierte dos vectores sen una posicion de la matriz
  ;E:  filMatrizJuego  
  ;    colMatrizJuego
  ;    NUMCOLFILJUEGO 
  ;S: la variable posMatrizJuego
    
  
  MatrizAVector PROC
    push bx
   
   
    
   mov bh,0
   mov bl,NUMCOLFILJUEGO
   
   mov ah,0
   mov al,filMatrizJuego  ; en al = numcolfiljuego*filamatrizjuego
   mul bl
   
   
   mov bl,colMatrizJuego
                           
   add al, bl  ; en al = numcolfiljuego*filamatrizjuegod + colMatrizJuego 
   mov posMatrizJuego, al 
   
                     
   pop bx
  
  
  
  ret
  MatrizAVector ENDP
                   
;  F: Convierte una posicion de matrizJuego en los vectores filMatrizJuego y colMatrizjuego
;  E: posMatrizJuego
;     NUMCOLFILJUEGO
;  S: filMatrizJuego
;     colMatrizJuego      
  
  VectorAMatriz PROC 
    push bx
    push ax
    
    

    mov ah,0
    mov al,posMatrizJuego    
    
    mov bh,0      
    mov bl,NUMCOLFILJUEGO
    
    div bl
    
    mov filMatrizJuego, al
    mov colMatrizJuego, ah
    
    pop ax
    pop bx
    
      
  
    
  
 
 
 
  ret
  VectorAMatriz ENDP
                                
;  F: Valida la entrada de la cadena introducida
;  E: si: Contiene la cadena a comprobar
;  S: bl: devuelve un valor en bl 
  
  ValidarEntradaOpcion PROC
    
    push ax
    push dx
    
    
    
    cmp [si+2], 'L'
    je RespuestaL
    cmp  [si+2], 'M'
    je RespuestaM       ;Comprobamos la primera letra introducida
    cmp  [si+2], 'R'
    je RespuestaR
    cmp [si+2], 'S'
    je RespuestaS
    
    
    
    
    
    mov bl,0
    jmp finalValidar
    
    
    
    RespuestaS: 
    
    cmp [si+1],1
    
    jne finalValidar
    
    
                             ;Si es S directamente y solo hay un valor en la cadena devuelve 4
    
    mov bl,4
    
    
    jmp finalValidar
    
    
    
    RespuestaL: 
    
    
    lea dx, [si+3]                   ;Pasamos la cadena a un numero
    call CadenaANumero
    
    ;Comprobamos el rango
          
    mov posLaser,al 
    cmp al,1
    jl finalValidar
    cmp al,32
    jg finalValidar
    
    mov bl,1                              
    
    
    
    jmp finalValidar
    
    
    
    
    RespuestaM: 
    
    cmp [si+4], ','                  ;Comprobamos que se haya introducido bien la coma
    jne finalValidar
    
    mov [si+4],13                     ;Introducimos un espacio para hacer la primera comprobacion solo hasta la coma
    
    lea dx, [si+3]
    call CadenaANumero
    ;Comprobamos el rango del primer numero
    
    cmp al,1
    jl finalValidar
    cmp al,8
    jg finalValidar
    
    sub al,1
    mov filMatrizJuego,al
    
    
    lea dx, [si+5]
    call CadenaANumero
    ;Comprobamos el rango del segundo numero
    cmp ax,1
    jl finalValidar
    cmp ax,8
    jg finalValidar
    
    sub al,1
    mov colMatrizJuego,al
    
    
    
    mov bl,2 
    
     
    jmp finalValidar
    
    RespuestaR:
    
    cmp [si+1],1                  ;Si es R  y solo hay un valor en la cadena devuelve 3
    
    mov bl,3 
    
    finalValidar: 
    
    pop dx
    pop ax
    
    
     ret
  ValidarEntradaOpcion ENDP
 
 
    ;F:Busca el elemento deseado en el vector y si lo encuentra, devuelve 1, si no devuelve 0.
    ;E:CX contiene el tamaño del vecor
    ;  SI la direccion del 1er elemento del vector
    ;  BL El valor a buscar 
    ;S: devuevle 1 o 0 
    BuscarElemento PROC  
    push si  
    push cx
    
              
    bucleBuscar:
    
    cmp [si],bl
    
    
    je devolver
    inc si 
    loop bucleBuscar 
    mov al,0
    jmp terminar

    devolver:
    mov al,1
    
    
    terminar:
    
    pop cx
   
    pop si
    
    ret
    BuscarElemento ENDP
    
   

 
;  F:Rellenar los vectores con n numeros
;  E: si:contiene el vectorTiposEspejos
;    di:contiene la matrizJuego
;    cx:contiene el numero de espejos
;    bx:contiene el vectorPosEspejos
;  S: Devuelve los vectores con los valores ya introducidos  
                     
RellenarVector PROC
    push si
    push di
    push bx
    push cx
    push ax
    
    BucleRellenar:
    
    mov al, [si]  
    
    push bx   
    xor bh,bh
    mov bl,[bx]
    mov [di+bx], al
    pop bx
    
    inc bx
    inc si

    loop BucleRellenar
    
    pop ax
    pop cx
    pop bx
    pop di
    pop si 
    ret
 RellenarVector ENDP 

;:F Inicia la matrizJuego aleatoria

IniciarMatrizJuego PROC
    
    call inicioAleatorio   ;Colocamos primero los valores aleatorios en los vectores tipoEspejos y posEspejos
    
    lea di,matrizJuego
    lea si,vectorTiposEspejos
    
    lea bx,vectorPosEspejos
    mov cl,numEspejos
    call RellenarVector       ;Rellenamos 
    
    
    
    ret
IniciarMatrizJuego ENDP

;:F Inicia la matrizJuego en forma debug con un tablero prestablecido

InicializarMatrizJuegoDebug PROC
    
 
 
    lea di,matrizJuego
    lea bx,vectorPosEspejos
    lea si,vectorTiposEspejos
    
    mov cx, NUMESPEJOSDEBUG                                  
                                    
    mov numEspejos, NUMESPEJOSDEBUG 
 
    call RellenarVector 
 
                                     
    
    
    
     
   ret
InicializarMatrizJuegoDebug ENDP
    
;:Marca de un color la casilla deseada, si ya esta marcada o el numero de marcadas es igual al de espejos no puedes marcarla    

MarcarEspejo PROC
    push ax
    push dx
    push bx
    push cx
    
    
    mov bl, numEspejos
    cmp numEspejosMarcados,bl   ;Comprueba el numero de espejos con el numero de espejos marcados
    jge finalMarcarEspejo:
    
    
    call MatrizAVector
    mov bl,posMatrizJuego 
    
    
    
    
    lea si,vectorPosEspejosMarcados 
    xor ch,ch
    mov cl,numEspejos
                     
    
    
    
    
    
                     
    call BuscarElemento                     ;Busca la posicion en el vectorespejosMarcados
                     
    cmp al,1
    je repetir
    
    
    
    
    
    marcar: 
    
    mov al,posMatrizJuego 
    
                                            ;Inserta la posicion en el vectorEspejosMarcados
    call insertarVect
    
      
                                              ;Calcula la posicion original del tablero
    call Pantalla 
    call ColocarCursor
    
    mov al,CARACTMARCADO
    
    mov bl,COLORMARCAR
    
    
    call ImprimirCarColor                   ;Marca la casilla
    
    inc numEspejosMarcados
    
    repetir:
    
    call LeerCadenaJuego
    
    
    finalMarcarEspejo:
    
 
  
  pop cx
  pop bx
  pop dx
  pop ax
    
    
    
    
    
    ret
    
    
MarcarEspejo ENDP




;F:Recoloca a la posicion verdadera del tablero
;E: colMatrizJuego
;   filMatrizJuego
;   
;   
; S: devuelve la variable colum y fila
 
 Pantalla PROC
    push bx
    push ax
    
    
    mov ax, 4
    mov bl, colMatrizJuego
    mul bl
    add al, 12
    mov colum,al
    
    
    mov ax, 2
    mov bl, filMatrizJuego
    mul bl                       ;fila = filMatrizJuego * alto de la celda (2) + posicion de la fila(4)
                                 ;colum = colMatrizJuego * ancho celda (4) + posicion de la col(12)
    add al, 4
    mov fila,al
    
    pop ax
    pop bx
    ret
    
 Pantalla ENDP
 
 ;:F efectua el disparo del laser que rebota en espejos o no y acaba en un borde del tablero
            
 DispararLaser PROC  
    
    push ax
    push bx
    push dx
    push si 
    
    
    mov al,PosLaser
    
    cmp al,8
    jle DireccionDisparoLaserABAJO
    
    cmp al,16
    jle DireccionDisparoLaserIZQUIERDA         ;Comprobamos de donde sale el laser
    
    cmp al,24
    jle DireccionDisparoLaserARRIBA
    
    cmp al,32
    jle DireccionDisparoLaserDERECHA
    
    
    
    
    
    
    
    
   DireccionDisparoLaserABAJO:
   
   mov direcDisparoLaser, 2 
   mov filMatrizJuego, 0
   
   sub al,1
   mov colMatrizJuego, al
   
   call MatrizAVector
   
   
   
   lea si,matrizJuego
   xor bh,bh
   mov bl,posMatrizJuego                                  ;Segun la direcion del disparo comprobamos
   add si,bx  
   
   
   jmp ComprobacionABAJO
   
   
   
   
   
   DireccionDisparoLaserARRIBA:  
    
   mov direcDisparoLaser, 0
   mov filMatrizJuego,7
   mov bl,24
   sub bl,al
   mov colMatrizJuego, bl
   
   call MatrizAVector
   
   
   
   lea si,matrizJuego       
   xor bh,bh
   mov bl,posMatrizJuego
   add si,bx  
    
   
   jmp ComprobacionARRIBA
   
   
   
   
   
   
   DireccionDisparoLaserDERECHA:
                            
   mov direcDisparoLaser, 1 
   mov bl,32                             
   sub bl,al
   mov filMatrizJuego ,bl
   mov colMatrizJuego, 0 
   
   call MatrizAVector
   
   
   lea si,matrizJuego
   xor bh,bh
   mov bl,posMatrizJuego
   add si,bx  
     
                 
   jmp ComprobacionDERECHA
   

   
   DireccionDisparoLaserIZQUIERDA: 
   
   mov direcDisparoLaser, 3  
   sub al,9
   mov filMatrizJuego , al
   mov colMatrizJuego, 7   
                           
                           
   call MatrizAVector
   
   lea si,matrizJuego
   xor bh,bh
   mov bl,posMatrizJuego
   add si,bx  
        
   
   jmp ComprobacionIZQUIERDA
   
   
   direccionLaserABAJO:
   
   
   
  
    inc filMatrizJuego
    call  MatrizAVector  
    
    cmp filMatrizJuego,0
    jl finTrayecto
    cmp filMatrizJuego,7
    jg finTrayecto                ;Comprueba si esta en el final del tablero si no sigue jugando
    cmp colMatrizJuego,0
    jl finTrayecto
    cmp colMatrizJuego,7
    jg finTrayecto     
    
                                 ;Mueve el "laser" dependiendo de la direccion
  
   lea si,matrizJuego
   xor bh,bh
   mov bl,posMatrizJuego
   add si,bx  
                            
   
   jmp ComprobacionABAJO                        
  
    
    
    
    
   
   
   
   
   direccionLaserARRIBA:
   
   
   
   dec filMatrizJuego
   call MatrizAVector 
   
    cmp filMatrizJuego,0
    jl finTrayecto
    cmp filMatrizJuego,7
    jg finTrayecto
    cmp colMatrizJuego,0
    jl finTrayecto
    cmp colMatrizJuego,7
    jg finTrayecto     
    
   
   lea si,matrizJuego
   xor bh,bh
   mov bl,posMatrizJuego
   add si,bx  
    
   
   
   jmp ComprobacionARRIBA
   
   direccionLaserDERECHA:
   
    
   
   
   inc colMatrizJuego
   call MatrizAVector  
   
                    
    cmp filMatrizJuego,0
    jl finTrayecto
    cmp filMatrizJuego,7
    jg finTrayecto
    cmp colMatrizJuego,0
    jl finTrayecto
    cmp colMatrizJuego,7
    jg finTrayecto     
    
   
   lea si,matrizJuego
   xor bh,bh
   mov bl,posMatrizJuego
   add si,bx  
     
                 
   
   jmp ComprobacionDERECHA
  
   
   direccionLaserIZQUIERDA:
   
   
  
   dec colMatrizJuego
   call MatrizAVector
   
                      
                      
                   
    cmp filMatrizJuego,0
    jl finTrayecto
    cmp filMatrizJuego,7
    jg finTrayecto
    cmp colMatrizJuego,0
    jl finTrayecto
    cmp colMatrizJuego,7
    jg finTrayecto     
    
  
  
  
   lea si,matrizJuego
   xor bh,bh
   mov bl,posMatrizJuego
   add si,bx  
        
   jmp ComprobacionIZQUIERDA
   
                           
    ComprobacionABAJO:  
   
   
   cmp [si],0
   je  direccionLaserABAJO
   cmp [si],1
   je  direccionLaserABAJO
   cmp [si],2
   je  direccionLaserIZQUIERDA
   cmp [si],3
   je  direccionLaserARRIBA
   cmp [si],4
   je  direccionLaserDERECHA
  
    
    
    ComprobacionARRIBA: 
    cmp [si],0
   je  direccionLaserARRIBA
   cmp [si],1
   je  direccionLaserARRIBA
   cmp [si],2                    ;Comprueba segun la direccion y el tipo de espejo hacia donde rebota
                                                           
   je  direccionLaserDERECHA
   cmp [si],3
   je  direccionLaserABAJO
   cmp [si],4                
   je  direccionLaserIZQUIERDA
   
    
    
    ComprobacionDERECHA:
     cmp [si],0
   je  direccionLaserDERECHA
   cmp [si],1
   je  direccionLaserIZQUIERDA
   cmp [si],2
   je  direccionLaserARRIBA
   cmp [si],3
   je  direccionLaserDERECHA
   cmp [si],4
   je  direccionLaserABAJO
  
    
    
    ComprobacionIZQUIERDA:
     cmp [si],0
   je  direccionLaserIZQUIERDA
   cmp [si],1
   je  direccionLaserDERECHA
   cmp [si],2
   je  direccionLaserABAJO
   cmp [si],3
   je  direccionLaserIZQUIERDA
   cmp [si],4
   je  direccionLaserARRIBA
  
    
    
    
      finTrayecto: 
     
     
      call Pantalla
      
      call ColocarCursor
      
     
      xor ax,ax                           ;Imprimimos en pantalla si ha llegado al final
      mov al,PosLaser 
      lea dx,cadenaE
      
        
      call NumeroACadena
      
      call Imprimir                     
       
                   
   finalLaser:
   pop si 
   pop dx
   pop bx
   pop ax
    
    
    
    ret
    
 DispararLaser ENDP 
 
 
 ;F: Resuelve el juego mostrando los espejos y colocando un mensaje segun si ganastes o no
         
         
 ResolverJuego PROC 
    
    push ax
    push si
    push bx
    push di 
    push dx 
                                       ;Muestra todo los espejos
    call ComprobarEspejoImprimir
    xor ah,ah
    lea si,vectorPosEspejosMarcados
    lea di,vectorPosEspejos
    
                   
    xor ch,ch
    mov cl,numEspejos
    xor bh,bh
    mov bh,cl
    bucleComprobar:
    
    mov bl,[di]
    inc di                 ;Comprueba si el espejo esta marcado, si es asi incrementa ah
    call BuscarElemento
    cmp al,1    
    jne siguiente 
    
    
    add ah,1 
    
    siguiente:            
 
    mov al,[di-1]
    
    mov posMatrizJuego, al 
    
    
                
    dec bh
    cmp bh,0               
    
    jne bucleComprobar
                              ;Comprueba con ah si es igual al numEspejos.Si lo es, has ganado
    cmp ah,numEspejos
    
    
    je MensajeVictoria 
    
    
    
    PartidaPerdida :
    call BorrarLineaMsj
    call BorrarEntradaUsuario
    
    mov fila,INIYMSJ
    mov colum,INIXMSJ
    
    call  ColocarCursor 
    
    lea dx,msjPerdida
    
    call Imprimir  
    
    Call OcultarCursor 
                                         ;Imprime los mensajes segun el resultado
    
    jmp finalResolverJuego
    
    
    
    MensajeVictoria:
    call BorrarLineaMsj
    call BorrarEntradaUsuario
    
    mov fila,INIYMSJ
    mov colum,INIXMSJ
    
    call  ColocarCursor 
    
    lea dx, msjGanada
    
    call Imprimir  
    
    Call OcultarCursor
  
    
   finalResolverJuego:
    
   pop dx 
   pop di 
   pop bx
   pop si
   pop ax
    
    ret
 
 ResolverJuego ENDP     
 
   ;F:Muestra todo los espejos en pantalla
 
 ComprobarEspejoImprimir PROC
    push si
    push di
    push ax
    push bx
    push cx           
        
        
        xor ch,ch
        mov cl,numEspejos         
        
        lea si,vectorTiposEspejos
        lea di,vectorPosEspejos
        
        bucleComp:
        
        
        mov al,[di]
        inc di                                ;Va recorriendo los vectores
        mov bh,[si]
        inc si
        
        
        mov posMatrizJuego, al
        call VectorAMatriz
        call Pantalla
        call ColocarCursor
        
        
    
       cmp bh,1
       je pint1
       cmp bh,2
       je pint2
       cmp bh,3
       je pint3                                ;Segun el tipo de espejo, imprime un caracter o otro
       cmp bh,4
       je pint4
                 
    pint1:        
    
      mov bl,COLORRESOLVER 
      mov al, caractImprimirMatrizJuego[1]
      
      jmp pintar
                 
    
    pint2:       
    
      mov bl,COLORRESOLVER 
      mov al, caractImprimirMatrizJuego[2]
      
      jmp pintar
                 
                 
                 
    pint3:       
    
      mov bl,COLORRESOLVER 
      mov al, caractImprimirMatrizJuego[3]
      
      jmp pintar
                 
    
    pint4: 
    
    
      mov bl,COLORRESOLVER 
      mov al, caractImprimirMatrizJuego[4]
      
    
    
     
   
    pintar:
                         
     
    call ImprimirCarColor 
    
    loop bucleComp
    
    
           
    pop cx       
    pop bx
    pop ax
    pop di
    pop si
    
    ret
 
 
 ComprobarEspejoImprimir ENDP  
 
 ;F: rellena el vectorposespejos con aleatorios
 ;E: cx contiene el numespejos
 ;   di contiene el vectorPosEspejos
 ;  bl contiene el numero de casillas existentes
 
 
 posEspejo PROC
           
    push dx
    push si
    push cx
    push di
    push ax
           
    mov si,di            ;mueve el vector a si
    
    repetirPos:
    call NumAleatorio
    cmp ah,0
    je repetirPos         ; va comprobando que el numeroaleatorio no sea 0
    
    cmp cl, numEspejos    ;comprueba que cl sea igual al numero de espejos si es asi mete una posicion sin comprobar
    
    je meterPOS 
    
    push cx
    push bx
    
    
    xor dh,dh
    mov dl,numEspejos
    sub dl,cl                     ; comprueba que no este repetido
    mov cx,dx
    mov bl,ah
    call BuscarElemento 
    
    
    
    pop bx                            ; si lo esta repite el bucle si no introduce el valor 
    pop cx
    cmp al,1
    
    
    je repetirPos
    
    meterPOS:
    
    mov [di],ah
    add di,1
    
    loop repetirPos
    
    pop ax
    pop di
    pop cx
    pop si
    pop dx 
    ret
               
 
 posEspejo ENDP
                
                
 ;F: Rellena el vectoTipoEspejos con tipos de espejos
 ;E: di contiene el vector
 ;   cx el numero de espejos
 ; bx el numero de tipos de espejos
 tipoEspejo PROC
        push cx
        push ax
        push di
         
         
         vueltaL:
         call NumAleatorio
         cmp ah,0                   ; comprueba que el numero aleatorio no sea 0
         jle vueltaL
         
         
         
         mov [di], ah                 ; lo introduce
         add di,1
         
         loop vueltaL
         
         
        pop di
        pop ax
        pop cx
        
        
 
 
 
        ret   
 tipoEspejo ENDP
 
 
 
 ;F: Rellena los vectores tiposEspejos y posEspejos de aleatorios
 
 inicioAleatorio PROC
    
    
    
    lea di, vectorTiposEspejos
    xor ch,ch
    mov cl,numEspejos
    mov bl,NUMTIPOSESPEJOS+1
    call tipoEspejo                ;Carga los vectores de forma aleatoria
    
    
    lea di, vectorPosEspejos
    xor ch,ch
    mov cl,numEspejos
    mov bl,NUMCASILLASJUEGO
    call posEspejo
    
    ret
    
  inicioAleatorio ENDP
 
    
    
;*************************************************************************************
;************************** Programa Principal ***************************************
;*************************************************************************************


start:
    mov ax, data
    mov ds, ax 
    
    Call InicializarEntorno
                                        ;Iniciamos entorno
   
   InicioJuego:
   
    mov fila,INIYMSJ
    mov colum,INIXMSJ
    
    call ColocarCursor  ;Colocamos el mensaje de opcion que preguntara por si cargar el tablero aleatorio o no
    
    lea dx,msjOpcion
    call Imprimir   
    
   LeerCadenaJuego: 
    
       
    mov fila,INIYPEDIR
    mov colum,INIXPEDIR
    
    call ColocarCursor
    
    call BorrarEntradaUsuario
                                ;Pedimos la cadena a introducir
    mov CadenaE[0],5           
    lea dx,CadenaE
     xor bl,bl          
    
    call LeerCadena
    
    lea si,CadenaE 
                           
    call ValidarEntradaOpcion 
                            ;Dependiendo del valor de bl que devuelva el validar tendremos una funcion
    cmp bl,4 
    je finPrincipal         ;bl=4 termina el juego
                            ;bl=1 disparar el laser
                            
    
    cmp bl,1                ;bl=2 marcar la casilla deseada
    jne CompararDemas
    
    
                            ;bl=3 resuelve el tablero y te dice si has ganado o no
    jmp Laser
    
    
    
    
   CompararDemas:
    
    cmp bl,2
    je marcarE:
    
    cmp bl,3 
    
    je resolver:
    
 
    call LeerCadenaJuego:
    
   marcarE:
    
    call MarcarEspejo
    
    call LeerCadenaJuego 
   Laser:
    
    call DispararLaser  
    
    call LeerCadenaJuego 
    
    
   resolver: 
    
    call ResolverJuego
    
   finPrincipal:
    

    mov ah, 4ch
    int 21h
    
code ends
END Start
       
                          