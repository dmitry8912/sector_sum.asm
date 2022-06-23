org 7c00h

lea si, op1
sub si, 0x7c00
push si
push 1 ;1 sector
call read_sector
add sp, 2

lea si, op2
sub si, 0x7c00
push si
push 2
call read_sector
add sp, 2

lea di, sum
sub di, 0x7c00
push di

call sum_mem
push 3

call write_sector
int 19h

read_sector:
    push bp
    mov bp, sp
    
    mov ah, 2 ;count
    mov al, 1
    mov dh, 0
    mov dl, 0 ;floppy num
    mov ch, 0
    mov cl, [bp+4] ;sector num
    mov bx, [bp+6] ;buffer
    int 13h
    
    mov sp, bp
    pop bp
    ret
    
write_sector:
    push bp
    mov bp, sp
    
    mov ah, 0x03
    mov al, 2
    mov dh, 0
    mov dl, 0 ;floppy num
    mov ch, 0
    mov cl, [bp+4] ;sector num
    mov bx, [bp+6] ;buffer
    int 13h
    
    mov sp, bp
    pop bp
    ret

sum_mem:
    push bp
    mov bp, sp
    mov di, [bp+4] ;sum mem addr
    mov si, [bp+6] ;op2
    push si ;bp-2
    mov si, [bp+8] ;op1
    push si ;bp-4
    mov cx, 0x200
    
    loop_sum:
        mov sp, bp
        mov si, [bp-2]
        lodsb
        push si
        
        mov bl, al
        
        mov si, [bp-4]
        lodsb
        push si
        
        adc al, bl
        stosb
    loop loop_sum
    
    mov ax, 0
    adc ax, 0
    
    stosb
    
    mov sp, bp
    pop bp
    ret

op1 db 512 dup(0)
op2 db 512 dup(0)
sum dd 1024 dup(0)

