    DEVICE ZXSPECTRUM48

ROM_CLS        = $0DAF  ; ROM address for "Clear Screen" routine    
    org $8000
    jp start
    
string:
    db 255, 66, 129,129,129,129,66,60
STRING_LENGTH  = $ - string
   
start:
    call ROM_CLS         ; Call clear screen routine from ROM (extended immediate)
;change border color
    ld a,3
    out ($FE),a
;load ball coordinates
    ld b,2
    ld c,2
    
gameloop:    
    call printball
    call wait_routine
    call deleteball
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


wait_routine:
    push bc
    ld b, 55
    ld a,255
wait_loop:
    dec a
    jp nz,wait_loop
    ld a,255
    dec b
    jp nz,wait_loop
    pop bc
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
; arguments: b=x_pos   c=y_pos
; video memory: hl
    push bc
    exx
    pop bc
    ld de,string
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
    ret

; Deployment: Snapshot
   SAVESNA "load.sna", start
   ;SAVETAP "load.tap", start