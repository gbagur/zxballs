    DEVICE ZXSPECTRUM48

ROM_CLS        = $0DAF  ; ROM address for "Clear Screen" routine    
    org $8000
    jp start
    
ball_sprite:
   db %00111100
   db %01000010
   db %10000001
   db %10100101
   db %10000001
   db %10111101
   db %01000010
   db %00111100

ball_sprite_LENGTH  = $ - ball_sprite

ball_sprite_mask:
   db %11000011
   db %10000001
   db %00000000
   db %00000000
   db %00000000
   db %00000000
   db %10000001
   db %11000011

sprite_swipped_11       db 0,0,0,0,0,0,0,0
sprite_swipped_12       db 0,0,0,0,0,0,0,0

sprite_mask_swipped_11  db 0,0,0,0,0,0,0,0
sprite_mask_swipped_12  db 0,0,0,0,0,0,0,0
   

background_buffer_11    db 0,0,0,0,0,0,0,0
background_buffer_12    db 0,0,0,0,0,0,0,0

background_tile         db $55,0,$AA,0,$55,0,$AA,0

temp_var                db 0
   
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
    ld de,ball_sprite
    ld hl,ball_sprite_mask    
    call printsprite
    ret

print_recorded_background:
    push bc
    ;ld de,background_tile
    srl b
    srl b
    srl b
    ld de,background_buffer_11
    call printchar
    inc b
    ld de,background_buffer_12
    call printchar
    pop bc
    ret

record_backround:
    push bc
    srl b                       ; remove last 3 bits from x
    srl b
    srl b
    ; first char
    ld a,1                  ; 1=video2mem
    ld (temp_var), a
    ld ix,background_buffer_11
    call transferchar
    ; second char
    inc b
    ld a,1                  ; 1=video2mem
    ld (temp_var), a
    ld ix,background_buffer_12
    call transferchar
    pop bc
    ret
    
printchar:
    ; arguments: b=x_pos(char)  c=y_pos(char)
    ;            de = char memory position
    ;            hl = char mask position
    push bc
    ld ix, de
    ld a,0              ; 0 = mem2video
    ld (temp_var), a
    call transferchar
    pop bc                       ;recover x,y postion including x2 x1 x0
    ret

printsprite:
    ; arguments: b=x_pos   c=y_pos
    ;            de = char memory position
    ;            hl = char mask position
    push bc
    ld a,b                      ; record x2 x1 x0
    and $07
    srl b                       ; remove last 3 bits from x
    srl b
    srl b
swipe_it:    
    ld ix, de                    ;load origin address
    ld iy, sprite_swipped_11        ;load destination address
    call swipe_bitmap_right      
    ld ix, hl                    ;load origin address
    ld iy, sprite_mask_swipped_11   ;load destination address    
    call swipe_bitmap_mask_right
    
    ; first char
    ld ix, sprite_mask_swipped_11
    ld a,2              ; 2 = apply mask (AND)
    ld (temp_var), a
    call transferchar
    ld ix, sprite_swipped_11
    ld a,3              ; 3= apply sprite (OR)
    ld (temp_var), a
    call transferchar
    ; second char
    inc b               ; increment x pos
    ld ix, sprite_mask_swipped_12
    ld a,2              ; 2 = apply mask (AND)
    ld (temp_var), a
    call transferchar
    ld ix, sprite_swipped_12
    ld a,3              ; 3= apply sprite (OR)
    ld (temp_var), a
    call transferchar
    
    pop bc                       ;recover x,y postion including x2 x1 x0
    ret

swipe_bitmap_right:
    ; argument a= bits to swipe
    ;       ix = origin char memory position
    ;       iy = destination
    push af
    push ix
    push iy
    push bc
    push de
    push hl
    ld l,a          ; swipe counter max stored in l
    ld b,8          ; restart rows counter
swipe_bitmap_right_next_row:    
    ld c,l          ; restart swipe counter
    ld d,(ix)       ;sprite11 load a with the char slice
    ld e,0          ;sprite12 load all '0'
swipe_bitmap_right_swipe_loop:    
    ld a,c
    cp 0
    jr z, skip_swap
    srl d           ; swipe data
    rr e   
    dec c           ; decrement swipe counter
    jr nz, swipe_bitmap_right_swipe_loop
skip_swap:    
    ld (iy),d       ; sprite 11 store swiped value
    ld (iy+8),e     ; sprite 12 store swiped value
    inc ix          ; go to next char slice memory address
    inc iy
    dec b           ; decrement row counter
    jr nz, swipe_bitmap_right_next_row
    
    pop hl
    pop de
    pop bc
    pop iy
    pop ix
    pop af
    ret

swipe_bitmap_mask_right:
    ; argument a= bits to swipe
    ;       ix = origin char memory position
    ;       iy = destination
    push af
    push ix
    push iy
    push bc
    push de
    push hl
    ld l,a          ; swipe counter max stored in l
    ld b,8          ; restart rows counter
swipe_bitmap_right_next_row2:    
    ld c,l          ; restart swipe counter
    ld d,(ix)       ; mask11 load a with the char slice
    ld e,255        ; mask12 load all '1'
swipe_bitmap_right_swipe_loop2:    
    ld a,c
    cp 0
    jr z, skip_swap2
    srl d           ; swipe data
    rr e 
    ld a,d
    or $80          ; add '1' to msb to keep mask on
    ld d,a
    dec c           ; decrement swipe counter
    jr nz, swipe_bitmap_right_swipe_loop2
skip_swap2:  
    ld (iy),d       ; mask11 store swiped value
    ld (iy+8),e     ; mask12 store swiped value
    inc ix          ; go to next char memory address row
    inc iy
    dec b           ; decrement row counter
    jr nz, swipe_bitmap_right_next_row2
    
    pop hl
    pop de
    pop bc
    pop iy
    pop ix
    pop af
    ret

transferchar:
; arguments: b=x_pos(char)  c=y_pos(char)
;            ix = char memory position
;            a = direction    ->  0=mem2video   ; 1=video2mem 
;                                 2=apply mask  ; 3=apply sprite
; variable hl = video memory
    push bc
    push ix
    exx
    pop ix
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
    ld b,ball_sprite_LENGTH
    ld a,(temp_var)
    jp z, mem2video    ; decides direction of transfer
    dec a
    jp z, video2mem    ; decides direction of transfer
    dec a
    jp z, applymask    ; decides direction of transfer
    dec a
    jp z, applysprite    ; decides direction of transfer
mem2video:
    ld a,(ix)           ; load a with the byte row
    ld (hl),a           ; load byte row into video memory
    inc ix              ; go to next sprite byte row
    inc h               ; go to next row in the video memory
    dec b               ; decrement row counter
    jr nz,mem2video           ; if B not zero, jump back to top of loop (condition,relative)
    pop bc
    exx
    ret
video2mem:
    ld a,(hl)           ; load a with the byte row
    ld (ix),a           ; load byte row into video memory
    inc ix              ; go to next sprite byte row
    inc h               ; go to next row in the video memory
    dec b               ; decrement row counter
    jr nz,video2mem           ; if B not zero, jump back to top of loop (condition,relative)
    pop bc
    exx
    ret
applymask:
    ld a,(hl)           ; load a with video info
    and (ix)            ; apply the mask to the video info
    ld (hl),a           ; save it back to the video mem
    inc ix              ; go to next sprite byte row
    inc h               ; go to next row in the video memory
    dec b               ; decrement row counter
    jr nz,applymask           ; if B not zero, jump back to top of loop (condition,relative)
    pop bc
    exx
    ret
applysprite:
    ld a,(ix)           ; load a with the byte row
    or (hl)
    ld (hl),a           ; load byte row into video memory
    inc ix              ; go to next sprite byte row
    inc h               ; go to next row in the video memory
    dec b               ; decrement row counter
    jr nz,applysprite           ; if B not zero, jump back to top of loop (condition,relative)
    pop bc
    exx
    ret
        

draw_background:
    ld b,0                              ; starting x pos
    ld c,0                              ; starting y pos
    ld de,15360  
    ld hl,8
draw_background_topbot_loop:
    ;ld de,background_tile               ; load the address of the char bitmap
    add de,hl
    call printchar
    ld a,b
    add 1                            ; increment x pos
    ld b,a
    ;inc b
    ld a,32
    cp b                                ; compare x pos with 256 (0) to detect end of columns
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