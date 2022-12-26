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

string_swipped:
   db 0,0,0,0,0,0,0,0
   
background_tile:
   db $55,0,$AA,0,$55,0,$AA,0

background_buffer:
   db 0,0,0,0,0,0,0,0

temp_var:
   db 0
   
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
    call print_ball
    ld a, 4
    call wait_routine
    call print_recorded_background
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
    
print_ball:
    ld de,string
    call printchar
    ret

print_recorded_background:
    ld de,background_buffer
    ;ld de,background_tile
    push bc
    ld a,b
    and $F8
    ld b, a
    call printchar
    pop bc
    ret

record_backround:
    ld a,1                  ; 1=video2mem
    ld (temp_var), a
    ld de,background_buffer
    call transferchar
    ret
    
printchar:
    ; arguments: b=x_pos   c=y_pos
    ;            de = char memory position
    ld a,0              ; 0=mem2video
    ld (temp_var), a
    push bc
    ld a,b                      ; record x2 x1 x0
    and $07
    srl b                       ; remove last 3 bits from x
    srl b
    srl b
    cp a,0
    jr z, dont_swipe_it
    call swipe_bitmap_right
    ld de, string_swipped
dont_swipe_it:
    call transferchar
    pop bc
    ret

swipe_bitmap_right:
    ; argument a= bits to swipe
    ;          de = char memory position
    push bc
    push de         ; save char memory address
    push hl
    ld l,a          ; swipe counter max stored in l
    ld b,8          ; restart rows counter
    ld ix, string_swipped
swipe_bitmap_right_next_row:    
    ld c,l          ; restart swipe counter
    ld a,(de)       ;load a with the byte row
swipe_bitmap_right_swipe_loop:    
    srl a           ; swipe data
    dec c           ; decrement swipe counter
    jr nz, swipe_bitmap_right_swipe_loop
    ld (ix),a       ; store swiped value
    inc de          ; go to next char memory address row
    inc ix
    dec b           ; decrement row counter
    jr nz, swipe_bitmap_right_next_row
    
    pop hl
    pop de         ;recover char memoery address
    pop bc
    ret

transferchar:
; arguments: b=x_pos   c=y_pos
;            de = char memory position
;            a = direction    ->  0=mem2video   ; 1=video2mem
; variable: video memory: hl
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
    ld a,(temp_var)
    cp a,0
    jp nz, video2mem    ; decides direction of transfer
mem2video:
    ld a,(de)           ; load a with the byte row
    ld (hl),a           ; load byte row into video memory
    inc de              ; go to next sprite byte row
    inc h               ; go to next row in the video memory
    dec b               ; decrement row counter
    jr nz,mem2video           ; if B not zero, jump back to top of loop (condition,relative)
    pop bc
    exx
    ret
video2mem:
    ld a,(hl)           ; load a with the byte row
    ld (de),a           ; load byte row into video memory
    inc de              ; go to next sprite byte row
    inc h               ; go to next row in the video memory
    dec b               ; decrement row counter
    jr nz,video2mem           ; if B not zero, jump back to top of loop (condition,relative)
    pop bc
    exx
    ret

draw_background:
    ld b,0                              ; starting x pos
    ld c,0                              ; starting y pos
    ld de,20
draw_background_topbot_loop:
    ;ld de,background_tile               ; load the address of the char bitmap
    inc de
    call printchar
    ld a,b
    add 8                            ; increment x pos
    ld b,a
    ;inc b
    ld a,256
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