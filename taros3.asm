  org 0x7c00

  ; Initialize registers.
  mov ax, 0
  mov ss, ax
  mov sp, 0x7c00
  mov ds, ax

; Load program from drive.
  mov ax, 0x0820
  mov es, ax   ; Buffer address pointer (ES:BX)
  mov ch, 0    ; Cylinder
  mov dh, 0    ; Head
  mov cl, 2    ; Sector

  mov si, 0 ; failure counter

retry:
  mov ah, 0x02 ; Read from drive
  mov al, 1    ; Sectors to read count
  mov bx, 0
  mov dl, 0x00 ; Drive (1st floppy disk)
  int 0x13
  jnc fin

  ; If failure
  add si, 1
  cmp si, 5
  jae error

  ; Reset dist system
  mov ah, 00
  mov dl, 0x00
  int 0x13
  jmp retry

fin:
  hlt
  jmp fin

error:
  mov si, msg

putloop:
  mov al, [si]
  add si, 1
  cmp al, 0
  je fin

  ; Display character.
  ; (AL = character,
  ;  BH = page number,
  ;  BL = color)
  mov ah, 0x0e
  mov bx, 15
  int 0x10

  jmp putloop

msg:
  db 0x0a, 0x0a
  db "load error"
  db 0x0a
  db 0

  times 510-($-$$) db 0
  db 0x55, 0xaa
