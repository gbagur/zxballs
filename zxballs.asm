    DEVICE ZXSPECTRUM48

ROM_CLS        = $0DAF  ; ROM address for "Clear Screen" routine    
    org $8000
    jp start
    
string:
   db %00111100
   db %01000010
   db %10000001
   db %10100101
   db %10000001
   db %10111101
   db %01000010
   db %00111100
STRING_LENGTH  = $ - string

background_buffer
   db 0,0,0,0,0,0,0,0
   
start:
    call draw_background
;change border color
    ld a,3
    out ($FE),a
;load ball coordinates
    ld b,2
    ld c,2
    ei
    halt
gameloop:    
    call record_backround
    call printball
    halt
    call recover_background
    inc b
    inc c
    ld a,20
    cp b
    jp z, again    
    jp gameloop; 

again:
    ld b,2
    ld c,2
    jp gameloop


;argument a = waiting time
wait_routine:
    halt
    dec a
    jp nz,wait_routine
    ret   

finish:
    halt

deleteball:
    
    ld a, $16
    rst $10
    ld a, c
    rst $10
    ld a, b
    rst $10
    ld a, " "
    rst $10

    ret
    
printball:
    ld de,string
    call printchar
    ret

recover_background:
    ld de,background_buffer
    call printchar
    ret

record_backround:
; arguments: b=x_pos   c=y_pos
;            de = backgound buffer memory position
; variable: video memory: hl
    ld de,background_buffer
    ex af,af'
    push bc
    push de
    exx
    pop de
    pop bc
    ld h, $40
; use x3-7
    ld l,b
; write y3y4y5
    ld a,c
    sla a
    sla a
    sla a
    sla a
    sla a
    and $E0
    or l
    ld l,a
; write y6y7
    ld a,c
    and $18
    or h
    ld h,a
; now we have the video coordinates on hl
    push bc
    ld b,STRING_LENGTH
loop2:
    ld a,(hl)           ; load a with the byte row of the background
    ld (de),a           ; load background byte row into buffer
    inc de              ; go to next sprite byte row
    inc h               ; go to next row in the video memory
    dec b               ; decrement row counter
    jr nz,loop2           ; if B not zero, jump back to top of loop (condition,relative)
    pop bc
    exx
    ex af,af'
    ret

printchar:
; arguments: b=x_pos   c=y_pos
;            de = char memory position
; variable: video memory: hl

    ex af,af'
    push bc
    push de
    exx
    pop de
    pop bc
    ld h, $40
; use x3-7
    ld l,b
; write y3y4y5
    ld a,c
    sla a
    sla a
    sla a
    sla a
    sla a
    and $E0
    or l
    ld l,a
; write y6y7
    ld a,c
    and $18
    or h
    ld h,a
; now we have the video coordinates on hl
    push bc
    ld b,STRING_LENGTH
loop:
    ld a,(de)           ; load a with the byte row
    ld (hl),a           ; load byte row into video memory
    inc de              ; go to next sprite byte row
    inc h               ; go to next row in the video memory
    dec b               ; decrement row counter
    jr nz,loop           ; if B not zero, jump back to top of loop (condition,relative)
    pop bc
    exx
    ex af,af'
    ret

draw_background:
    ld b,0                              ; starting x pos
    ld c,0                              ; starting y pos
draw_background_topbot_loop:
    ld de,10                            ; load the address of the char bitmap
    call printchar
    inc b                               ; increment x pos
    ld a,32                           
    cp b                                ; compare x pos with 32 to detect end of columns
    jp nz,draw_background_topbot_loop
    ld b,0                              ; reset starting x pos
    inc c                               ; go to next row
    ld a,24                           
    cp c                                ; compare y pos with 24 to detect end of columns
    jp nz,draw_background_topbot_loop
    ret
    
    

; Deployment: Snapshot
   SAVESNA "load.sna", start
   ;SAVETAP "load.tap", start