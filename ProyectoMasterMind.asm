include "entorno.asm"

data segment
  DEFINIR_Variables
      
  ;Aqui puedes definir tus propias variables
  vectorAuxiliar DB 6 DUP(?)                   
ends

stack segment
    
  DW 128 DUP(0)
  
ends


code segment

  DEFINIR_BorrarPantalla
  DEFINIR_ColocarCursor
  DEFINIR_Imprimir
  DEFINIR_LeerTecla
  DEFINIR_ImprimeCaracterColor
  DEFINIR_DibujarIntentos                                 
  DEFINIR_DibujarCodigo
  DEFINIR_DibujarInstrucciones
  DEFINIR_DibujaEntorno    
  DEFINIR_MuestraAciertos
  DEFINIR_MuestraCombinacion
  DEFINIR_MuestraGana
  

  ;Aqui puedes definir tus propios procedimientos
  
    AveriguarAciertos PROC

        
    mov aciertosPos, 0
    mov aciertosColor, 0
    
    Buscando1:
    ;Almaceno en ax la posicion desde donde tengo que empezar a buscar 
    mov dx, 0   ;auxiliar
    
    mov ax, 0
    mov al, indJuego
    mov bx, 0
    mov bl, 6
    mul bl
    
    mov di, ax ;desde donde empiezo a comparar en el vector juegos
    mov vectorAuxiliar[0], al   ;guardo en la primera posicion del vector,
                                ;desde donde tengo que empezar a buscar en el vector juegos
    
    Buscando3:
    mov si, 0
    mov cx, 0
    mov cl, npiezas
    
    Buscando2:
    mov bx,0
    mov bl, combinacion[si]
    cmp juegos[di], bl    
    je AciertoColor
    
       
    inc si
    loop Buscando2
    
    SiguienteCaracter:
    add dx, 1   ;para controlar las letras que llevo
    inc di
    mov bx,0
    mov bl, npiezas
    cmp dx, bx
    jl Buscando3
    
    jmp FinAveriguar
    
    AciertoColor:
    mov bx, di
    mov vectorAuxiliar[1], bl
    mov bx, di
    
    sub bl,vectorAuxiliar[0] 
    cmp si, bx
    je AciertoPosicion
    mov bl, vectorAuxiliar[1]
    mov di, bx 
    inc aciertosColor
    jmp SiguienteCaracter
     
    
    AciertoPosicion:
    mov bl, vectorAuxiliar[1]
    mov di, bx
    inc aciertosPos
    jmp SiguienteCaracter
         
    FinAveriguar:
     
     ret
     
    AveriguarAciertos ENDP
    
    
  TeclaI PROC
    push di

    

    NuevaTecla:
    mov si, 0   ;para recorrer el vector combinacion
    
    mov aciertosPos, 0
    mov aciertosColor, 0
    
    mov bx, 0                                 
    mov bl, f_intento                         ;fila= f_intento + 2*intento(si)   
    mov ax,0
    mov al, 2   
    mul intento          
    add ax, bx
    mov fila, al
    
    mov bx,0
    mov bl, c_intento     ;n de intentos      ;tengo que mover a colum,
    mov ax, 0                                ;colum=c_intento + 2*intento(si)
    mov al, 2
    mul di
    add ax, bx
    mov colum, al
   
    NoValida:
    call ColocarCursor
    call LeerTecla
    
    ;Averiguar que no se repita la letra en el vector combinacion
    
    cmp di, 0
    je Paso1
    
    mov ax, 0
    mov al, caracter
    mov cx, di
    mov si, 0
    BuscarRepetido:
    cmp combinacion[si], al
    je NoValida
    inc si
    loop BuscarRepetido
    
    
    
    
    
    
    
    ;Compara con las posibles letras que pueden entrar
    Paso1: 
    mov ax, 0
    mov al, caracter
    
    cmp al, piezas_letra[2] ;letra A(amarillo)
    je Color1
    cmp al, piezas_letra[0] ;letra R(rojo)
    je Color2
    cmp al, piezas_letra[4] ;letra B(blanco)
    je Color3    
    cmp al, piezas_letra[1] ;letra V(verde)
    je Color4
    cmp al, piezas_letra[3] ;letra Z(azul)
    je Color5
    cmp al, piezas_letra[5] ;letra M(marron)
    je Color6
    jne NoValida    
    
    Color1:
    mov bx, 0
    mov bl, piezas_color[2] 
    jmp Paso2 
    
    Color2: 
    mov bx, 0
    mov bl, piezas_color[0]
    jmp Paso2
    
    Color3:
    mov bx, 0
    mov bl, piezas_color[4]     
    jmp Paso2
    
    Color4:
    mov bx, 0
    mov bl, piezas_color[1] 
    jmp Paso2
    
    Color5:
    mov bx, 0
    mov bl, piezas_color[3]
    jmp Paso2 
    
    Color6:
    mov bx, 0
    mov bl, piezas_color[5]
    jmp Paso2
    
    
    Paso2:
    
    
    mov ax, 0
    mov al, caracter   
    call ImprimeCaracterColor
    
    mov combinacion[di], al
    
    ;Incremento la variable di
    inc di
    
    mov ax, 0
    mov al, npiezas
    cmp ax, di
    je Fin
       
    
    jmp NuevaTecla
    
    
    CambioBandera:
    mov finJuego, 1
    jmp Fin2
    
    
    Fin:  
    
    
    call AveriguarAciertos
    jmp Final3
    
    
    FinalGana:
    mov finJuego, 1
    
    jmp Fin2
    
    
    
    Final3:
    call MuestraAciertos
    mov dx, 0
    mov dl, npiezas
    cmp aciertosPos, dl
    je FinalGana
    
    cmp intento, 9
    je CambioBandera
    
    Fin2:
    
    pop di
    ret
    
    TeclaI ENDP
  
  
  
  
  MenuJuego PROC
    
    call BorrarPantalla
    mov fila, f_inicio1
    mov colum, c_inicio1
    call ColocarCursor
     
    lea dx, d_Inicio1
    call Imprimir
    
    mov fila, f_inicio2
    mov colum, c_inicio2
    call ColocarCursor
  
    lea dx, d_Inicio2
    call Imprimir
    
    Iterac1:  
    
    call LeerTecla
    
    mov ax, 0
    mov al, caracter
    
    sub ax,30h      ;pasa caracter a numero
    cmp ax, 3       ;en caracter se almacena la variable LeerTecla
    jl  Iterac1
    cmp ax, 6
    jg  Iterac1
    
    mov npiezas, al
    

    
    mov ax, 0
    mov al, caracter
    mov bx, 0
    mov bl, 07h
    call ImprimeCaracterColor
    
    
    mov fila, f_inicio3
    mov colum, c_inicio3
    call ColocarCursor
    
    lea dx, d_Inicio3
    call Imprimir
    
     
    
    Iterac2:  
    
    
    
    call LeerTecla
    mov ax, 0
    mov al, caracter
    sub ax, 30h      ;pasa caracter a numero
    cmp ax, 0        ;en caracter se almacena la variable LeerTecla
    jl  Iterac2
    cmp ax, 4
    jg  Iterac2 
    
    mov ax, 0
    mov al, caracter
    mov bx, 0
    mov bl, 07h
    call ImprimeCaracterColor
    
    mov ax, 0
    mov al, caracter
    sub ax, 30h
    
    mov indJuego, al
    mov intento, 0
    mov finJuego, 0
    
    mov di, 0         ;lo uso para comprobar que ya he usado todas las posibilidades
                      ;de cada intento
    
                      
    call BorrarPantalla
    mov fila, f_titulo
    mov colum, c_titulo
    call ColocarCursor
     
    call DibujaEntorno
    
    Juego:
    ;9 intentos o acierto
    cmp finJuego, 1
    je  Final2
    
    cmp intento, 9
    je  FinIntentos
    ;Pido una nueva tecla de accion
    mov fila, f_mensajes
    mov colum, c_mensajes
    call ColocarCursor
    
    call LeerTecla
    
    ;letra I(Introducir Nueva Combinacion) 
    mov ax, 0
    mov al, 49h 
    cmp caracter, al
    je Chance
    
    ;letra S(Resolver)
    mov ax, 0
    mov al, 53h
    cmp caracter, al
    je Solucion
    
    ;letra N(Nuevo Juego)
    mov ax, 0
    mov al, 4Eh
    cmp caracter, al
    je MenuJuego
    
    ;letra Esc(                            
    cmp caracter, 27                       
    je Final
    
    IntroduceTeclaDeAccion:
        jmp Juego
    
    
    Chance:                                
        call TeclaI
        
        ;Incrementa el intento
        mov bx, 0
        mov bl, intento
        add bx, 1
        mov intento, bl
        
        jmp Juego

     
    
    Solucion:
    mov finJuego, 1
     
    call MuestraCombinacion
    mov fila, f_mensajes
    mov colum, c_mensajes
    call ColocarCursor
    
    lea dx, msj_TeclaAccion
    call Imprimir 
    
    jmp Final1
    
    FinIntentos:
     
    mov fila, f_mensajes
    mov colum, c_mensajes
    call ColocarCursor
    
    lea dx, msj_superaIntentos
    call Imprimir
    
    jmp Final1
    
    Final2:
    
    
    call MuestraCombinacion
    
    mov fila, f_mensajes
    mov colum, c_mensajes
    call ColocarCursor
    
    lea dx, msj_gana
    call Imprimir
    
    Final1:
    call LeerTecla  
    
    ;letra N(Nuevo Juego)
    mov ax, 0
    mov al, 4Eh
    cmp caracter, al
    je MenuJuego
    
    ;letra Esc(                            
    cmp caracter, 27                       
    je Final
    
    jmp Final1
    
    Final:
    

     ret
  MenuJuego ENDP
  
  
  
    
    
start:
    mov ax, data
    mov ds, ax
           
           
    ;Aqui puedes definir tu codigo principal
    call MenuJuego

    mov ax, 4C00h
    int 21h  

ends

end start
