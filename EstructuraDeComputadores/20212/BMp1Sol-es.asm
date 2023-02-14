section .data               
;Cambiar Nombre y Apellido por vuestros datos.
developer db "_Nombre_Apellido1_",0

;Constantes que también están definidas en C.
DIMMATRIX    equ 10
SIZEMATRIX   equ 100

section .text            
;Variables definidas en Ensamblador.
global developer                        

;Subrutinas de ensamblador que se llaman desde C.
global countMinesP1, showMinesP1, showCharBoardP1
global moveCursorP1, mineMarkerP1, checkEndP1, playP1	  

;Variables globales definidas en C.
extern rowScreen, colScreen, charac, indexMat
extern mines, marksIni, marks, numMines, state

;Funciones de C que es llaman desde ensamblador.
extern gotoxyP1_C, getchP1_C, printchP1_C
extern printBoardP1_C, printMessageP1_C	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
;; Les subrutinas en ensamblador se teneis que implementar son:
;;   countMinesP1, showMinesP1,  showCharBoardP1, moveCursorP1
;;   mineMarkerP1, checkEndP1.  
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Esta subrutina se da hecha. NO LA PODÉIS MODIFICAR.
; Situar el cursor en una posición de la pantalla
; llamando a la función gotoxyP1_C.
; 
; Variables globales utilizadas:	
; (rowScreen) : Fila de la pantalla donde se situa el cursor.
; (colScreen) : Columna de la pantalla donde se situa el cursor.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gotoxyP1:
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

   call gotoxyP1_C
 
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
; llamando a la función printchP1_C.
; 
; Variables globales utilizadas:	
; (charac) : Carácter a mostrar.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printchP1:
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

   call printchP1_C
 
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
; y almacenarlo en la variable (charac) llamando a la función getchP1_C.
; 
; Variables globales utilizadas:	
; (charac) : Carácter leído desde el teclado.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getchP1:
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

   call getchP1_C
 
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
   

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Recorrer la matriz (mines) para contar el número de minas que hay.
; 
; Variables globales utilizadas:	
; (mines)    : Matriz donde ponemos las minas.
; (numMines) : Minas que quedan por marcar.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
countMinesP1:
   push rbp
   mov  rbp, rsp
   
   push rsi

   mov ax, 0        ;numMines = 0;
   mov esi,0
   cm_for:
   cmp esi, SIZEMATRIX
   jge cm_endfor    ;for (i=0;i<DIMMATRIX;i++){
	                ;for (j=0;j<DIMMATRIX;j++){
     cmp BYTE[mines+esi], '*'   ;if(mines[i][j]=='*') 
     jne cm_endif
       inc ax       ;numMines++;
     cm_endif:      ;}
     inc esi
   jmp cm_for
   cm_endfor:        ;}
   mov WORD[numMines], ax
   
   pop rsi
			
   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Convierte el valor del número de minas que quedan por marcar (numMines)
; (entre 0 y 99) en dos caracteres ASCII. 
; Se tiene que dividir el valor (numMines) entre 10, el cociente 
; representará las decenas y el residuo las unidades, y después se
; tienen que convertir a ASCII sumando 48, carácter '0'.
; Mostrar los dígitos (carácter ASCII) de les decenas en la fila 3, 
; columna 44 de la pantalla y las unidades en la fila 3, columna 45.
; Para posicionar el cursor se llama a la subrutina gotoxyP1 y para 
; mostrar los caracteres a la subrutina printch.
; 
; Variables globales utilizadas:
; (rowScreen) : Fila de la pantalla donde se situa el cursor.
; (colScreen) : Columna de la pantalla donde se situa el cursor.
; (numMines)  : Minas que quedan para marcar.
; (charac)    : Carácter a escribir en pantalla.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
showMinesP1:
   push rbp
   mov  rbp, rsp

   push rax
   push rbx
   push rdx

   mov rax, 0
   mov ax, WORD[numMines]
   mov rdx, 0

   mov bx,10
   div bx	        ;AX=DX:AX/BX DX=DX:AX%BX
	                ;AX=(nMines/10) DX=(nMines%10) 
	            
   mov DWORD[rowScreen], 3 ;rowScreen = 3;
   mov DWORD[colScreen], 44 ;colScreen = 44
   call gotoxyP1
   add al,'0'       ;charac = tens + '0';
   mov BYTE[charac], al
   call printchP1   ;printchP1_C();

   mov DWORD[colScreen], 45 ;colScreen = 45
   call gotoxyP1   
   add dl, '0'      ;charac = units + '0';
   mov BYTE[charac], dl
   call printchP1   ;printchP1_C();

   sm_End:
   pop rdx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Mostrar el carácter de la posición indicada por (indexMat) de la
; matriz (marks) en la posición del cursor en pantalla dentro del 
; tablero en función del índice de la matriz (indexMat). Dejar el 
; cursor en la posición donde hemos mostrado el carácter.
; Para calcular la posición del cursor en pantalla utilizar 
; esta fórmula:
; rowScreen=((indexMat/10)*2)+7
; colScreen=((indexMat%10)*4)+7
; Para posicionar el cursor se llama a la subrutina gotoxyP1 y para 
; mostrar los caracteres a la subrutina printchP1.
; 
; Variables globales utilizadas:	
; (marks)     : Matriz con las minas marcadas.
; (indexMat)  : Índice para acceder a las matrices mines y marks desde ensamblador.
; (rowScreen) : Fila de la pantalla donde se situa el cursor.
; (colScreen) : Columna de la pantalla donde se situa el cursor.
; (charac)    : Carácter a escribir en pantalla.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
showCharBoardP1:
   push rbp
   mov  rbp, rsp
	  
   push rax
   push rbx
   push rdx
   push rdi           
   push rsi
   push r9
	                      
   mov r9, 0
   mov r9d, DWORD[indexMat]
   
   mov edx, 0
   mov eax, r9d     ;row = (indexM/10);
   mov ebx, 10      ;col = (indexM%10);
   div ebx          ;EAX = EDX:EAX / EBX, EDX = EDX:EAX mod EBX 
		
   mov edi, eax
   shl edi, 1       ;(row)*2)
   add edi, 7       ;rowScreen=((row)*2)+7
   mov DWORD[rowScreen], edi
   mov esi, edx
   shl esi, 2       ; ((col)*4)
   add esi, 7       ; colScreen=((col%10)*4)+7
   mov DWORD[colScreen], esi
   call gotoxyP1    ;gotoxyP1_C();
	
   mov dil, BYTE[marks+r9d] 
   mov BYTE[charac], dil ;char c = m[row][col];
   call printchP1        ;printchP1_C();
   
   
   call gotoxyP1    ;gotoxyP1_C(n);

   scb_end:
   pop r9
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
; con la variable (indexMat), en función de la tecla pulsada (charac). 
; Si se sale fuera del tablero no actualizar la posición del cursor.
; (i:arriba, j:izquierda, k:a bajo, l:derecha)
; Arriba y abajo: ( indexMat = indexMat +/- 10 ) 
; Derecha ye izquierda( indexMat = indexMat +/- 1 ) 
; No se tiene que posicionar el cursor en pantalla.
;  
; Variables globales utilizadas:
; (charac)   : Carácter leído de teclado.
; (indexMat) : Índice para acceder a las matrices mines y marks desde ensamblador.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
moveCursorP1:
	push rbp
	mov  rbp, rsp

	push rax
	push rdx
	push rsi
	
	mov edx, 0
	mov eax, DWORD[indexMat]
	mov esi, 10           
	div esi               ;EAX = EDX:EAX / EDI, EDX = EDX:EAX mod EDI
                          ;EAX=(indexMat/10) EDX=(indexMat%10) 
	
	cmp BYTE[charac], 'i'     ;case 'i': 
	je moveCursorP1_Up
	cmp BYTE[charac], 'j'     ;case 'j': 
	je moveCursorP1_Left
	cmp BYTE[charac], 'k'     ;case 'k': 
	je moveCursorP1_Down
	cmp BYTE[charac], 'l'     ;case 'l': 
	je moveCursorP1_Right

	moveCursorP1_Up:
		cmp eax, 0                 ;if (row>0) 
		jle moveCursorP1_End  
		sub DWORD[indexMat], 10    ;indexMat=indexMat-10;
		jmp moveCursorP1_End       ;break;

	moveCursorP1_Left:
		cmp edx, 0                 ;if (col>0) 
		jle  moveCursorP1_End 
		dec DWORD[indexMat]        ;indexMat--;
		jmp moveCursorP1_End       ;break;

	moveCursorP1_Down:
		cmp eax, DIMMATRIX-1       ;if (row<DIMMATRIX-1) 
		jge moveCursorP1_End  
		add DWORD[indexMat], 10    ;indexMat+10;
		jmp moveCursorP1_End       ;break;

	moveCursorP1_Right:
		cmp edx, DIMMATRIX-1       ;if (col<DIMMATRIX-1) 
		jge moveCursorP1_End
		inc DWORD[indexMat]        ;indexMat++;
		jmp moveCursorP1_End       ;break;

	moveCursorP1_End:
	
	pop rsi
	pop rbx
	pop rax
	
	mov rsp, rbp
	pop rbp
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
; Marcar/desmarcar una mina en la matriz (marks) en la posición actual 
; del cursor, indicada por la variable (indexMat).
; Si en aquella posición de la matriz (marks) hay un espacio en blanco
; y no hemos marcado todas las minas, marcamos una mina poniendo una 
; 'M' en la matriz (marks) y decrementamos el número de minas que quedan
; por marcar (numMines), si en aquella posición de la matriz (marks) 
; hay una 'M', pondremos un espacio (' ') e incrementaremos el número 
; de minas que quedan por marcar (numMines).
; Si hay otro valor no cambiaremos nada.
; No se tiene que mostrar la matriz, sólo actualizar la matriz (marks) 
; y la variable (numMines).
; 
; Variables globales utilizadas:
; (marks)    : Matriz con las minas marcadas y las minas de las abiertas.
; (indexMat) : Índice para acceder a las matrices mines y marks desde ensamblador.
; (numMines) : Minas que quedan por marcar.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mineMarkerP1:
	push rbp
	mov  rbp, rsp

	push rdi
		
	mov edi,DWORD[indexMat]
      
	cmp BYTE[marks+edi], ' '       ;if (marks[row][col] == ' ' 
	jne  mm_unmark
	cmp WORD[numMines], 0          ;&& numMines > 0) {
	jle  mm_unmark

	mm_mark:          
		mov BYTE[marks+edi], 'M'   ;marks[row][col] = 'M';
		dec WORD[numMines]         ;numMines--;
		jmp mm_end

	mm_unmark:        
		cmp BYTE[marks+edi], 'M'   ;if (marks[row][col] == 'M' 
		jne  mm_end
		mov BYTE[marks+edi], ' '   ;marks[row][col] = ' ';
		inc WORD[numMines]         ;numMines++;

	mm_end:  
	pop rdi            
	
	mov rsp, rbp
	pop rbp
	ret
	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Verificar si hemos marcado todas las minas. 
; Si (numMines==0) cambiar el estado (state='2') "Gana la partida".
; 
; Variables globals utilitzades:	
; (numMines) : Minas que quedan por marcar.
; (state)    : Estado del juego.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
checkEndP1:
	push rbp
	mov  rbp, rsp

	cmp WORD[numMines], 0    ;if (numMines == 0) {	
	jne checkEndP1_End

	mov BYTE[state], '2'      ;state = '2';
	
	checkEndP1_End:
	mov rsp, rbp
	pop rbp
	ret
   
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Juego del Buscaminas
; Subrutina principal del juego
; Permite jugar al juego del buscaminas llamando a todas las funcionalidades.
;
; Pseudo código:
; Inicializar estado del juego, (state=1')
; Mostrar el tablero de juego llamando la función PrintBoardP1_C).
; Copiar la matriz (marksIni) a (marks) con las marcas iniciales.
; Mostrar en el tablero los movimientos marcados inicialmente en (marksIni).
; Decrementar (numMines) según las minas marcadas inicialmente.
; Inicializar (indexMat=54) para indicar la posición inicial del cursor.
; 
; Mientras (state='1') hacer:
;   Mostrar en el tablero las minas que quedan por marcar 
;     llamando a la subrutina showMinesP1.
;   Mostrar el carácter de la posición indicada por (indexMat) de la
;     matriz (marks) en la posición del cursor en pantalla dentro 
;     del tablero en función del índice de la matriz (indexMat) y 
;     dejar el cursor en la posición donde hemos mostrado el carácter  
;     llamando a la subrutina showCharBoarP1.
;   Leer una tecla y guardara en la variable (charac) lamando a 
;     la subrutina getchP1. 
;     y guardarla en la variable local (charac). 
;   Según la tecla leída llamaremos a la función correspondiente.
;     - ['i','j','k' o 'l']       (llamar a la subrutina moveCursorP1).
;     - 'x'                       (llamar a la subrutina mineMarkerP1).
;     - '<ESC>'  (codi ASCII 27) poner (state = '0') para salir.   
;   Verificar si hemos marcado todas las minas llamando a la subrutina checkEndP1).
; Fin mientras.
; Salir: 
;   Mostrar en el tablero las minas que quedan por marcar 
;     llamando a la subrutina showMinesP1_C.
;   Mostrar el carácter de la posición indicada por (indexMat) de la
;     matriz (marks) en la posición del cursor en pantalla dentro 
;     del tablero en función del índice de la matriz (indexMat) y 
;     dejar el cursor en la posición donde hemos mostrado el carácter  
;     llamando a la subrutina showCharBoarP1.
;   Mostrar el mensaje de salida que corresponda llamando a la función
;   printMessageP1_C.
; Se acaba el juego.
; 
; Variables globales utilizadas:	
; (state)    : Estado del juego.
; (marksIni) : Matriz con las minas marcadas inicialmente.
; (marks)    : Matriz con las minas marcadas.
; (mines)    : Matriz donde ponemos las minas.
; (indexMat) : Índice para acceder a las matrices mines y marks desde ensamblador.
; (numMines) : Minas que quedan por marcar.
; (charac)   : Carácter leído desde el teclado y a mostrar.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
playP1:
   push rbp
   mov  rbp, rsp
   
   push rax
   push rbx

   mov BYTE[state], '1'  ;state = '1';
	
   call printBoardP1_C   ;printBoardP1_C();

   mov rbx, 0
   p_for1:               ;for(int i=0; i<DIMMATRIX; i++){ 
	                     ; for(int j=0; j<DIMMATRIX; j++){
     mov al, BYTE[marksIni+rbx]
     mov BYTE[marks+rbx], al;marks[i][j]=marksIni[i][j];
     inc rbx
   cmp rbx, SIZEMATRIX   ;}
   jl  p_for1            ;}
   
   call countMinesP1     ;numMines = countMinesP1_C();
   
   mov DWORD[indexMat],99;indexMat = 99;
   call showCharBoardP1  ;showCharBoardP1_C();
   dec WORD[numMines]    ;numMines--;

   mov DWORD[indexMat], 54;indexMat= 54;         

   p_while:              
	 cmp  BYTE[state], '1' ;while (state == '1')
     jne  p_printMessage

     call showMinesP1      ;showMinesP1_C();
     call showCharBoardP1  ;showCharBoardP1_C();
		
     call getchP1          ;getchP1_C(); 
     mov  al, BYTE[charac] 

     p_move:
     cmp al, 'i'           ;if (charac>='i' && charac<='l')
     jl  p_mark
     cmp al, 'l'           
     jg  p_mark
       call moveCursorP1   ;moveCursorP1_C();
     p_mark:
     cmp al, 'm'           ;if (charac=='m')
     jne  p_esc
       call mineMarkerP1   ;mineMarkerP1_C()
     p_esc:
     cmp al, 27            ;if (charac==27)
     jne  p_check
       mov BYTE[state], '0';state = '0';

     p_check:
     call checkEndP1     ;checkEndP1_C();

     jmp  p_while

   p_printMessage:
   call showMinesP1      ;showMinesP1_C();
   call showCharBoardP1  ;showCharBoardP1_C();          
   call printMessageP1_C ;printMessageP1_C();
    
   p_end:		
   
   pop rbx
   pop rax
   
   mov rsp, rbp
   pop rbp
   ret

