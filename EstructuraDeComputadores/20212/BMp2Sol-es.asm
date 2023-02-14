section .data               
;Cambiar Nombre y Apellido por vuestros datos.
developer db "_Nombre_ _Apellido1_",0

;Constantes que también están definidas en C.
DIMMATRIX    equ 10
SIZEMATRIX   equ 100

section .text            
;Variables definidas en Ensamblador.
global developer     
                         
;Subrutinas de ensamblador que se llaman desde C.
global countMinesP2, showMinesP2  , showCharBoardP2, moveCursorP2
global mineMarkerP2  , searchMinesP2, checkEndP2   , playP2	 

;Variables globales definidas en C.
extern marksIni, mines

;Funciones de C que se llaman desde ensamblador
extern clearScreen_C, gotoxyP2_C, getchP2_C, printchP2_C
extern printBoardP2_C, printMessageP2_C

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ATENCIÓN: Recordad que en ensamblador las variables y los parámetros 
;;   de tipo 'char' se tienen que asignar a registros de tipo
;;   BYTE (1 byte): al, ah, bl, bh, cl, ch, dl, dh, sil, dil, ..., r15b
;;   las de tipo 'short' se tiene que assignar a registros de tipo 
;;   WORD (2 bytes): ax, bx, cx, dx, si, di, ...., r15w
;;   las de tipo 'int' se tiene que assignar a registros de tipo  
;;   DWORD (4 bytes): eax, ebx, ecx, edx, esi, edi, ...., r15d
;;   las de tipo 'long' se tiene que assignar a registros de tipo 
;;   QWORD (8 bytes): rax, rbx, rcx, rdx, rsi, rdi, ...., r15
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Les subrutinas en ensamblador que hay que modificar para 
;; implementar el paso de parámetros son:
;;   countMinesP2, showMinesP2,  showCharBoardP2, moveCursorP2
;;   mineMarkerP2, searchMinesP2, checkEndP2
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Esta subrutina se da hecha. NO LA PODÉIS MODIFICAR.
; Situar el cursor en una posición de la pantalla
; llamando a la función gotoxyP2_C.
; 
; Variables globales utilizadas:   
; Ninguna
; 
; Parámetros de entrada: 
; (row_num) : rdi(edi) : Fila.
; (col_num) : rsi(esi) : Columna.
; 
; Parámetros de salida : 
; Ninguno
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gotoxyP2:
   push rbp
   mov  rbp, rsp
   ;guardamos el estado de los registros del procesador porque
   ;las funciones de C no mantienen el estado de los registros.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   ; Cuando llamamos a la función gotoxyP2_C(int row_num, int row_num) 
   ; desde ensamblador el primer parámetro (row_num) se tiene que 
   ; pasar por el registro rdi(edi), y el segundo  parámetro (col_num)
   ; se tiene que pasar por el registro rsi(esi).
   call gotoxyP2_C
 
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Esta subrutina se da hecha. NO LA PODÉIS MODIFICAR.
; Mostrar un carácter en pantalla en la posición del cursor
; llamando a la función printchP2_C.
; 
; Variables globales utilizadas:   
; Ninguna
; 
; Parámetros de entrada: 
; (c): rdi(dil): Carácter a mostrar.
; 
; Parámetros de salida : 
; Ninguno
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printchP2:
   push rbp
   mov  rbp, rsp
   ;guardamos el estado de los registros del procesador porque
   ;las funciones de C no mantienen el estado de los registros.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   ; Cuando llamamos a la función printchP2_C(char c) desde ensamblador, 
   ; el parámetro (c) se tiene que pasar por el registro rdi(dil).
   call printchP2_C
 
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret
   

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Esta subrutina se da hecha. NO LA PODÉIS MODIFICAR.
; Leer un carácter desde el teclado sin mostrarlo en la pantalla
; y retornarlo llamando a la función getchP2_C
; 
; Variables globales utilizadas:   
; Ninguna
; 
; Parámetros de entrada: 
; Ninguno
; 
; Parámetros de salida : 
; (c): rax(al): Carácter leído desde el teclado.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getchP2:
   push rbp
   mov  rbp, rsp
   ;guardamos el estado de los registros del procesador porque
   ;las funciones de C no mantienen el estado de los registros.
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   mov rax, 0
   ; llamamos a la función getchP2_C(char c) desde ensamblador, 
   ; retorna sobre el registro rax(al) el carácter leído.
   call getchP2_C
 
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   
   mov rsp, rbp
   pop rbp
   ret 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Recorrer la matriz (mines) para contar el número de minas que hay.
; 
; Variables globales utilizadas:	
; (mines)  : Matriz donde ponemos las minas.
; 
; Parámetros de entrada: 
; Ninguno
; 
; Parámetros de salida :  
; rax(ax) : (nMines) : Minas que quedan por marcar.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
countMinesP2
   push rbp
   mov  rbp, rsp
	  
   push rsi

   mov ax, 0        ;short nMines = 0;
   
   mov rsi,0
   cm_for:
   cmp rsi, SIZEMATRIX
   jge cm_endfor    ;for (i=0;i<DIMMATRIX;i++){
	                ;for (j=0;j<DIMMATRIX;j++){
     cmp BYTE[mines+rsi], '*'   ;if(mines[i][j]=='*') 
     jne cm_endif
       inc ax       ;nMines++;
     cm_endif:      ;}
     inc rsi
   jmp cm_for
   cm_endfor:        ;}
   
   pop rsi
				
   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Convierte el valor (nMines), minas que quedan por marcar
; (valor entre 0 y 99) en dos caracteres ASCII. 
; Se tiene que dividir el valor (nMines) entre 10, el cociente 
; representará las decenas (tens) y el residuo las unidades, (units) y 
; después se tienen que convertir a ASCII sumando 48, carácter '0'.
; Mostrar los dígitos (carácter ASCII) de les decenas en la fila 3, 
; columna 44 de la pantalla y las unidades en la fila 3, columna 45.
; Para posicionar el cursor se llama a la subrutina gotoxyP2 y para 
; mostrar los caracteres a la subrutina printchP2.
; 
; Variables globales utilizadas:	
; Ninguna
; 
; Parámetros de entrada: 
; (nMines) : rdi(di)  : Minas que quedan para marcar.
; 
; Parámetros de salida : 
; Ninguno
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
showMinesP2:
	push rbp
	mov  rbp, rsp
		
	push rax
	push rbx
	push rdx
	push rsi
	push rdi

	mov rax, 0
	mov ax, di
	mov rdx, 0

	mov bx,10       ;AX=DX:AX/BX DX=DX:AX%BX
	div bx	        ;AX=(nMines/10) DX=(nMines%10) 
	                
	add al,'0'      ;tens = tens + '0';
	add dl,'0'      ;units = units + '0';

	mov  edi, 3     
	mov  esi, 44    
	call gotoxyP2   ;gotoxyP2_C(3, 44);
 
    push rdi
	mov  dil, al
	call printchP2  ;printchP2_C(tens)
	pop  rdi
	
	mov  esi, 45     
	call gotoxyP2   ;gotoxyP2_C(3, 45)

	mov  dil, dl
	call printchP2  ;printchP2_C(units);

	sm_End:
	pop rdi
	pop rsi
  	pop rdx
	pop rbx
	pop rax
	
	mov rsp, rbp
	pop rbp
	ret
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Mostrar el carácter de la posición indicada por (indexM) de la
; matriz (marks) en la posición del cursor en pantalla dentro del 
; tablero en función del índice de la matriz (indexMat). Dejar el 
; cursor en la posición donde hemos mostrado el carácter.
; Para calcular la posición del cursor en pantalla utilizar 
; esta fórmula:
; rowScreen=((indexMat/10)*2)+7
; colScreen=((indexMat%10)*4)+7
; Para posicionar el cursor llamar a la subrutina gotoxyP2 y 
; para mostrar el carácter a la subrutina printchP2.
; 
; Variables globales utilizadas:	
; Ninguna
; 
; Parámetros de entrada: 
; (mMarks) : rdi(rdi) : Dirección de la matriz con las minas marcadas.
; (indexM) : rsi(esi) : Índice para acceder a las matrices mines y marks desde ensamblador.
; 
; Parámetros de salida : 
; Ninguno
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
showCharBoardP2:
   push rbp
   mov  rbp, rsp
	  
   push rax
   push rbx
   push rdx
   push rdi           
   push rsi
   push r8
   push r9
	                      

   mov r8, rdi      ;mMarks
   mov r9, 0
   mov r9d, esi     ;indexM 
   
   mov edx, 0
   mov eax, esi     ;row = (indexM/10);
   mov ebx, 10      ;col = (indexM%10);
   div ebx          ;EAX = EDX:EAX / EBX, EDX = EDX:EAX mod EBX 
		
   mov edi, eax
   shl edi, 1       ;(row)*2)
   add edi, 7       ;rowScreen=((row)*2)+7

   mov esi, edx
   shl esi, 2       ; ((col)*4)
   add esi, 7       ; colScreen=((col%10)*4)+7
	
   call gotoxyP2    ;gotoxyP2_C(rowScreen, colScreen);
	
   push rdi
   mov  dil, BYTE[r8+r9] ;char c = m[row][col];
   call printchP2        ;printchP2_C(c);
   pop  rdi
   
   call gotoxyP2    ;gotoxyP2_C(rowScreen, colScreen);

   scb_end:
   pop r9
   pop r8
   pop rsi            
   pop rdi
   pop rdx
   pop rbx
   pop rax
			
   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
; Actualizar la posición del cursor en el tablero, que tenemos indicada
; con la variable (indexMat), en función de la tecla pulsada (c). 
; Si se sale fuera del tablero no actualizar la posición del cursor.
; (i:arriba, j:izquierda, k:a bajo, l:derecha)
; Arriba y abajo: ( indexMat = indexMat +/- 10 ) 
; Derecha ye izquierda( indexMat = indexMat +/- 1 ) 
; No se tiene que posicionar el cursor en pantalla.
;  
; Variables globales utilizadas:	
; Ninguna   
; 
; Parámetros de entrada: 
; (c)      : rdi(dil) : Carácter leído de teclado.
; (indexM) : rsi(esi) : Índice para acceder a las matrices mines y marks desde ensamblador.
; 
; Parámetros de salida : 
; (indexM) : rax(eax) : Índice para acceder a las matrices mines y marks desde ensamblador.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
moveCursorP2:
	push rbp
	mov  rbp, rsp
	
	push rbx
	push rdx
	push rsi
	push rdi
	
	mov rdx, 0
	mov eax, esi
	mov ebx, 10           
	div ebx               ;EAX = EDX:EAX / EDI, EDX = EDX:EAX mod EDI
                          ;EAX=(indexMat/10) EDX=(indexMat%10) 
	cmp dil, 'i'          ;case 'i': //amunt
	je mc_up    
	cmp dil, 'j'          ;case 'j': //esquerra
	je mc_left     
	cmp dil, 'k'          ;case 'k': //avall
	je mc_down   
	cmp dil, 'l'          ;case 'l': //dreta
	je mc_right

	mc_up:
	cmp eax, 0            ;if (row>0) 
	jle mc_end
	sub esi, 10           ;indexM=indexM-10;
	jmp mc_end  ;break;
  
	mc_left:
	cmp edx, 0            ;if (col>0)
	jle  mc_end
	dec esi               ;indexM--;
	jmp mc_end  ;break;

	mc_down:
	cmp eax, DIMMATRIX-1  ;if (row<DIMMATRIX-1)
	jge mc_end
	add esi,10            ;indexM=indexM+10;
	jmp mc_end  ;break;

	mc_right:
	cmp edx, DIMMATRIX-1  ;if (col<DIMMATRIX-1)
	jge mc_end
	inc esi               ;indexM++;
	jmp mc_end  ;break;

	mc_end:
	mov eax, esi          ;return indexM;
	
	pop rdi
	pop rsi
	pop rdx
	pop rbx
		
	mov rsp, rbp
	pop rbp
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
; Marcar/desmarcar una mina en la matriz (mMarks) en la posición actual 
; del cursor, indicada por la variable (indexM).
; Si en aquella posición de la matriz (mMarks) hay un espacio en blanco
; y no hemos marcado todas las minas, marcamos una mina poniendo una 
; 'M' en la matriz (marks) y decrementamos el número de minas que quedan
; por marcar (nMines), si en aquella posición de la matriz (mMarks) 
; hay una 'M', pondremos un espacio (' ') e incrementaremos el número 
; de minas que quedan por marcar (nMines).
; Si hay otro valor no cambiaremos nada.
; Retornar el número de mines (nMines) que quedan por marcar actualizado .
; No se tiene que mostrar la matriz, sólo actualizar la matriz (mMarks) 
; y la variable (nMines).
; 
; Variables globales utilizadas:	
; Ninguna
; 
; Parámetros de entrada: 
; (mMarks)   : rdi(rdi) : Dirección de la matriz con las minas marcadas y las minas de las abiertas.
; (indexMat) : rsi(esi) : Índice para acceder a las matrices mines y marks desde ensamblador.
; (nMines)   : rdx(dx)  : Minas que quedan por marcar.
; 
; Parámetros de salida : 
; (nMines) : rax(ax) : Minas que quedan por marcar.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
mineMarkerP2:
	push rbp
	mov  rbp, rsp

	push rdx
	push rsi
	push rdi
    
	movsxd rsi, esi
	cmp BYTE[rdi+rsi], ' '    ;if (marks[row][col] == ' ' && 
	jne mm_unmark
	cmp dx, 0                 ;&& numMines > 0) {
	jle mm_unmark
	
	mm_mark:
	mov BYTE[rdi+rsi], 'M'    ;marks[row][col] = 'M';
	dec dx                    ;numMines--;
	jmp mm_end

	mm_unmark:
	cmp BYTE[rdi+rsi], 'M'    ;if (marks[row][col] == 'M' 
	jne  mm_end
	mov BYTE[rdi+rsi], ' '    ;marks[row][col] = ' ';
	inc dx                    ;numMines++;

	mm_end:
	mov rax, 0
    mov ax, dx                ;return nMines;
        
	pop rdi
	pop rsi
	pop rdx
	
	mov rsp, rbp
	pop rbp
	ret
		

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
; Abrir casilla. Mirar cuantas minas hay alrededor de la posición 
; actual del cursor, indicada con la variable (indexM),
; de la matriz (mines).
; Si en la posición actual de la matriz (marks) hay un espacio (' ') 
;   Mirar si en la matriz (mines) hay una mina ('*').
;   Si hay una mina cambiar el estado (state), que se recibe como 
;     parámetro y llamamos (status) a 3 "Explosión", para salir.
;	 Si no, contar cuantas minas hay alrededor de la posición 
;     actual y actualizar la posición del matriz (marks) con 
;     el número  de minas (carácter ASCII del valor, para hacerlo, hay 
;     que sumar 48 ('0') al valor).
; Si no hay un espacio, quiere decir que hay una mina marcada ('M') o 
; la casilla ya está abierta (hay el número de minas que ya se ha 
; calculado anteriormente), no hacer nada.
; Retornar el estado del juego actualizado (status).
;  
; Variables globales utilizadas:	
; (mines)  : Matriz donde ponemos las minas.
; 
; Parámetros de entrada:
; (mMarks) : rdi(rdi) : Dirección de la matriz con las minas marcadas y las minas de las abiertas.
; (indexM) : rsi(esi) : Índice para acceder a las matrices mines y marks desde ensamblador.
; (status) : rdx(dl)  : Estado del juego. 
; 
; Parámetros de salida : 
; (status) : rax(al) : Estado del juego.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
searchMinesP2:
   push rbp
   mov  rbp, rsp

   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   
   movsxd rsi, esi
   mov r8b, dl    ;status
   mov rdx, 0
   mov rax, rsi
   mov rbx, 10           
   div rbx          ;RAX = RDX:RAX / EDI, RDX = RDX:RAX mod EDI
                    ;RAX=(indexMat/10) row
                    ;RDX=(indexMat%10) col 
   mov cl, 0                       ;char digit = 0;
   sm_marks:
   cmp BYTE[rdi+rsi], ' '          ;if (marks[row][col]==' ')
   jne sm_end

     sm_mines:
     cmp BYTE[mines+rsi], ' '      ;if (mines[row][col]!=' ') 
     je sm_upLeft
        mov r8b, '3'                ;status = '3';.
     jmp sm_end

     sm_upLeft:                    ;} else {
     cmp rax, 0                    ;if (row > 0)
     jle  sm_centerLeft
     cmp rdx, 0                    ;if (col > 0)
       jle  sm_upCenter
       mov rbx, rsi
       sub rbx, 11
       cmp BYTE[mines+rbx], '*'    ;&& (mines[row-1][col-1]=='*')  
       jne  sm_upCenter
         inc cl                    ;digit++;

       sm_upCenter:
       mov rbx, rsi
       sub rbx, 10
       cmp BYTE[mines+rbx], '*'    ;if (mines[row-1][col-1]=='*')
       jne  sm_upRight
         inc cl                    ; digit++; 

       sm_upRight:
       cmp rdx, DIMMATRIX-1        ;if (col < DIMMATRIX-1)
       jge sm_centerLeft
       mov rbx, rsi
       sub rbx,9
       cmp BYTE[mines+rbx], '*'    ;&& (mines[row-1][col]=='*')
       jne  sm_centerLeft
         inc cl                    ;digit++;

       sm_centerLeft:
       cmp rdx, 0                  ;if (col > 0)
       jle  sm_centerRight
       mov rbx, rsi
       sub rbx, 1
       cmp BYTE[mines+rbx], '*'    ;&& (mines[row][col-1]=='*') 
       jne  sm_centerRight
         inc cl                    ;digit++;

     sm_centerRight:
     cmp edx, DIMMATRIX-1          ;if (col < DIMMATRIX-1)
     jge  sm_downLeft  
     mov rbx, rsi
     add rbx,1 
     cmp BYTE[mines+rbx], '*'      ;&& (mines[row][col+1]=='*') 
     jne  sm_downLeft
       inc cl                      ;digit++;

     sm_downLeft:
     cmp rax, DIMMATRIX-1          ;if (row < DIMMATRIX-1)
     jge  sm_numMines
       cmp rdx, 0                  ;if (col > 0)
       jle  sm_downCenter  
       mov rbx, rsi
       add rbx, 9
       cmp BYTE[mines+rbx], '*'    ;&& (mines[row+1][col-1]=='*')
       jne  sm_downCenter
         inc cl                    ;digit++;

       sm_downCenter:
       mov rbx, rsi
       add rbx, 10
       cmp BYTE[mines+rbx], '*'    ;if (mines[row+1][col]=='*')
       jne  sm_downRight
         inc cl                    ;digit++;

       sm_downRight:
       cmp edx, DIMMATRIX-1        ;if (col < DIMMATRIX-1) 
       jge  sm_numMines  
       mov rbx, rsi
       add rbx, 11
       cmp BYTE[mines+rbx], '*'    ;&& (mines[row+1][col+1]=='*')
       jne sm_numMines
         inc cl                    ;digit++;

     sm_numMines:
     add cl, '0'
     mov BYTE[rdi+rsi],cl          ;marks[row][col] = digit+'0';

   sm_end:
   mov al, r8b                     ;return status;
   
   pop r8
   pop rdi            
   pop rsi
   pop rdx
   pop rcx
   pop rbx
  
   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
; Verificar si hemos marcado todas las minas (nMines=0) y hemos abierto
; o marcado con una mina todas las otras casillas y no hay ningún espacio
; en blanco (' ') en la matriz (mMarks), si es así, cambiar el estado 
; (status) a '2' "Gana la partida".
; Retornar el estado del juego actualizado (status).
; 
; Variables globales utilizadas:	
; Ninguna
; 
; Parámetros de entrada: 
; (mMarks) : rdi(rdi) : Dirección de la matriz con las minas marcadas y las minas de las abiertas.
; (nMines) : rsi(si)  : Minas que quedan por marcar.
; (status) : rdx(dl)  : Estado del juego. 
; 
; Parámetros de salida : 
; (status) : rax(alx) : Estado del juego.  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
checkEndP2:
   push rbp
   mov  rbp, rsp

   push rdx
   push rsi
   push rdi
        
   ce_if1:
   cmp  si, 0                 ;if (nMines == 0)
   jg   ce_endif1
     mov rsi, 0              ;for (i=0;i<DIMMATRIX;i++){
     mov rax, 0              ;for (j=0;j<DIMMATRIX;j++){
     ce_for:
       ce_if:
       cmp BYTE[rdi+rsi], ' '
       jne ce_endif           ;if (marks[i][j] == ' ') 
         inc rax              ;notOpenMarks++;
       ce_endif:              ;}
       inc rsi             
     cmp rsi, SIZEMATRIX      ;DIMMATRIX*DIMMATRIX
     jl ce_for                ;}
     cmp rax, 0               ;if (notOpenMarks == 0) {
     jne ce_endif2
        mov dl, '2'           ;status = 2;
     ce_endif2:               ;}
   ce_endif1:                 ;}
   mov al, dl                 ;return status; 
   
   pop rdi
   pop rsi
   pop rdx
     
   mov rsp, rbp
   pop rbp
   ret




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Juego del Buscaminas
; Subrutina principal del juego
; Permite jugar al juego del buscaminas llamando a todas las funcionalidades.
;
; Pseudo código:
; Inicializar estado del juego, (state='1')
; Mostrar el tablero de juego llamando la función PrintBoardP2_C).
; Copiar la matriz (marksIni) a (marks) con las marcas iniciales.
; Mostrar en el tablero los movimientos marcados inicialmente en (marksIni).
; Decrementar (numMines) según las minas marcadas inicialmente.
; Inicializar (indexMat=54) para indicar la posición inicial del cursor.
; 
; Mientras (state='1') hacer:
;   Mostrar en el tablero las minas que quedan por marcar 
;     llamando a la subrutina showMinesP2.
;   Mostrar el carácter de la posición indicada por (indexMat) de la
;     matriz (marks) en la posición del cursor en pantalla dentro 
;     del tablero en función del índice de la matriz (indexMat) y 
;     dejar el cursor en la posición donde hemos mostrado el carácter  
;     llamando a la subrutina showCharBoarP2.
;   Leer una tecla y guardarla en la variable local (charac) llamando
;     a la subrutina getchP2.
;   Según la tecla leída llamaremos a la subrutina correspondiente.
;     - ['i','j','k' o 'l']       (llamar a la subrutina moveCursorP2).
;     - 'x'                       (llamar a la subrutina mineMarkerP2).
;     - '<espace>'(codi ASCII 32) (llamar a la subrutina searchMinesP2).
;     - '<ESC>'  (codi ASCII 27) poner (state = '0') para salir.   
;   Verificar si hemos marcado todas las minas y si hemos abierto todas  
;     las casillas llamando a la subrutina checkMinesP2.
; Fin mientras.
; Salir: 
;   Mostrar en el tablero las minas que quedan por marcar 
;     llamando a la subrutina showMinesP2.
;   Mostrar el carácter de la posición indicada por (indexMat) de la
;     matriz (marks) en la posición del cursor en pantalla dentro 
;     del tablero en función del índice de la matriz (indexMat) y 
;     dejar el cursor en la posición donde hemos mostrado el carácter  
;     llamando a la subrutina showCharBoarP2.
;   Si se ha abierto una mina (state=='3') mostrar todas las minas de 
;     la matriz (mines) llamando a la subrutina showCharBoardP2.
;   Mostrar el mensaje de salida que corresponda llamando a la función
;   printMessageP2_C.
; Se acaba el juego.
; 
; Variables globales utilizadas:
; (marksIni) : Matriz donde se indican inicialmente les mines marcadas.
; (mines)    : Matriz donde ponemos las minas.
; 
; Parámetros de entrada: 
; Ninguno
; 
; Parámetros de salida : 
; Ninguno.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
playP2:
   push rbp
   mov  rbp, rsp

   sub rsp, 128     ;Reservamos espacio para la matriz marks.
   mov r8, rsp      ;Dirección de la matriz marks.
      
   push rax
   push rbx
   push rcx
   push rdx
   push rdi
   push rsi
   push r9

   push r8
   call printBoardP2_C   ;printBoard2_C();
   pop  r8
   
   mov  r9b, '1'         ;char state = '1'
   
   call countMinesP2     ;short numMines = countMinesP2_C();
   mov cx,  ax
   mov rbx, 0
   p_for:                ;for(int i=0; i<DIMMATRIX; i++){ 
	                     ; for(int j=0; j<DIMMATRIX; j++){
     mov al, BYTE[marksIni+rbx]
     mov BYTE[r8+rbx], al;marks[i][j]=marksIni[i][j];
     inc rbx
   cmp rbx, SIZEMATRIX   ;}
   jl  p_for             ;}
   mov rdi, r8
   mov esi, 0
   call showCharBoardP2  ;showCharBoardP2_C(marks,0);
   mov esi, 11
   call showCharBoardP2  ;showCharBoardP2_C(marks,11);
   mov esi, 22
   call showCharBoardP2  ;showCharBoardP2_C(marks,22);
   mov esi, 99
   call showCharBoardP2  ;showCharBoardP2_C(marks,99);
   dec cx                ;numMines--;
   
   mov ebx, 54           ;indexMat= 54; //Posición inicial del cursor.

   p_while               ;bucle principal del juego.
   cmp  r9b, '1'
   jne  p_printMessage

   mov di, cx
   call showMinesP2      ;showMinesP2_C(numMines);
   mov rdi, r8
   mov esi, ebx
   call showCharBoardP2  ;showCharBoardP2_C(marks,indexMat);

   call getchP2          ;(al)charac = getchP2_C();

   p_move:
   cmp al, 'i'		     ;if (charac>='i'
   jl  p_mark
   cmp al, 'l'		     ;&& charac<='l')
   jle p_moveCursor
   p_mark:
   cmp al, 'm'		
   je  p_mineMarker
   p_open:
   cmp al, ' '		
   je  p_searchMines
   p_esc:
   cmp al, 27		     ;Salir del programa.
   je  p_exit
   jmp p_check  
    
   p_moveCursor:
   mov  dil, al
   mov  esi, ebx
   call moveCursorP2     ;indexMat = moveCursorP2_C(charac, indexMat);
   mov  ebx, eax
   jmp  p_check

   p_mineMarker:
   mov  rdi, r8
   mov  esi, ebx
   mov  dx, cx
   call mineMarkerP2     ;numMines = mineMarkerP2_C(marks, indexMat, numMines);
   mov  cx, ax
   jmp  p_check

   p_searchMines:
   mov  rdi, r8
   mov  esi, ebx
   mov  dl, r9b
   call searchMinesP2    ;state = searchMinesP2_C(marks, indexMat, state);
   mov  r9b, al
   jmp  p_check

   p_exit:
   mov  r9b, '0'         ;state = 0;
 
   p_check:
   mov  rdi, r8
   mov  si, cx
   mov  dl, r9b
   call checkEndP2       ;state = checkEndP2_C(marks, numMines, state);
   mov  r9b, al
   
   jmp  p_while

   p_printMessage:
   mov di, cx
   call showMinesP2      ;showMinesP2_C(numMines);
   mov rdi, r8
   mov esi, ebx
   call showCharBoardP2  ;showCharBoardP2_C(marks,indexMat);
   mov esi, 0            ;int index=0;               
   cmp r9b, '3'          ;if(state=='3'){
   jne p_endif1
     mov rbx, 0
     p_for2:             ;for(int i=0; i<DIMMATRIX; i++){ 
	                     ; for(int j=0; j<DIMMATRIX; j++){
       cmp BYTE[mines+rbx], '*' ;if(mines[i][j]=='*')
       jne p_endif2
         mov  rdi, mines
         mov  esi, ebx        
         call showCharBoardP2;showCharBoardP2_C(mines,index);
       p_endif2:
     inc rbx
     cmp rbx, SIZEMATRIX   ;}
     jl  p_for2            ;}
   p_endif1:
   
   push r9
   mov  dil, r9b
   call printMessageP2_C ;printMessageP2_C(state);
   pop  r9
   
   p_end:
   pop r9
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax
   
   mov rsp, rbp
   pop rbp
   ret
