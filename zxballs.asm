    DEVICE ZXSPECTRUM48
;include 'graphics.asm'

ROM_CLS        = $0DAF  ; ROM address for "Clear Screen" routine    
    org $8000
    jp start

video_conversion_h: 
   db  064, 065, 066, 067, 068, 069, 070, 071
   db  064, 065, 066, 067, 068, 069, 070, 071
   db  064, 065, 066, 067, 068, 069, 070, 071
   db  064, 065, 066, 067, 068, 069, 070, 071
   db  064, 065, 066, 067, 068, 069, 070, 071
   db  064, 065, 066, 067, 068, 069, 070, 071
   db  064, 065, 066, 067, 068, 069, 070, 071
   db  064, 065, 066, 067, 068, 069, 070, 071
   db  072, 073, 074, 075, 076, 077, 078, 079
   db  072, 073, 074, 075, 076, 077, 078, 079
   db  072, 073, 074, 075, 076, 077, 078, 079
   db  072, 073, 074, 075, 076, 077, 078, 079
   db  072, 073, 074, 075, 076, 077, 078, 079
   db  072, 073, 074, 075, 076, 077, 078, 079
   db  072, 073, 074, 075, 076, 077, 078, 079
   db  072, 073, 074, 075, 076, 077, 078, 079
   db  080, 081, 082, 083, 084, 085, 086, 087
   db  080, 081, 082, 083, 084, 085, 086, 087
   db  080, 081, 082, 083, 084, 085, 086, 087
   db  080, 081, 082, 083, 084, 085, 086, 087
   db  080, 081, 082, 083, 084, 085, 086, 087
   db  080, 081, 082, 083, 084, 085, 086, 087
   db  080, 081, 082, 083, 084, 085, 086, 087
   db  080, 081, 082, 083, 084, 085, 086, 087
   db  088, 089, 090, 091, 092, 093, 094, 095
   db  088, 089, 090, 091, 092, 093, 094, 095
   db  088, 089, 090, 091, 092, 093, 094, 095
   db  088, 089, 090, 091, 092, 093, 094, 095
   db  088, 089, 090, 091, 092, 093, 094, 095
   db  088, 089, 090, 091, 092, 093, 094, 095
   db  088, 089, 090, 091, 092, 093, 094, 095
   db  088, 089, 090, 091, 092, 093, 094, 095
  
video_conversion_l: 
   db  000, 000, 000, 000, 000, 000, 000, 000
   db  032, 032, 032, 032, 032, 032, 032, 032
   db  064, 064, 064, 064, 064, 064, 064, 064
   db  096, 096, 096, 096, 096, 096, 096, 096
   db  128, 128, 128, 128, 128, 128, 128, 128
   db  160, 160, 160, 160, 160, 160, 160, 160
   db  192, 192, 192, 192, 192, 192, 192, 192
   db  224, 224, 224, 224, 224, 224, 224, 224
   db  000, 000, 000, 000, 000, 000, 000, 000
   db  032, 032, 032, 032, 032, 032, 032, 032
   db  064, 064, 064, 064, 064, 064, 064, 064
   db  096, 096, 096, 096, 096, 096, 096, 096
   db  128, 128, 128, 128, 128, 128, 128, 128
   db  160, 160, 160, 160, 160, 160, 160, 160
   db  192, 192, 192, 192, 192, 192, 192, 192
   db  224, 224, 224, 224, 224, 224, 224, 224
   db  000, 000, 000, 000, 000, 000, 000, 000
   db  032, 032, 032, 032, 032, 032, 032, 032
   db  064, 064, 064, 064, 064, 064, 064, 064
   db  096, 096, 096, 096, 096, 096, 096, 096
   db  128, 128, 128, 128, 128, 128, 128, 128
   db  160, 160, 160, 160, 160, 160, 160, 160
   db  192, 192, 192, 192, 192, 192, 192, 192
   db  224, 224, 224, 224, 224, 224, 224, 224
   db  000, 000, 000, 000, 000, 000, 000, 000
   db  032, 032, 032, 032, 032, 032, 032, 032
   db  064, 064, 064, 064, 064, 064, 064, 064
   db  096, 096, 096, 096, 096, 096, 096, 096
   db  128, 128, 128, 128, 128, 128, 128, 128
   db  160, 160, 160, 160, 160, 160, 160, 160
   db  192, 192, 192, 192, 192, 192, 192, 192
   db  224, 224, 224, 224, 224, 224, 224, 224

  
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
aux_var_1               db 0
   
start:
    call draw_background
    ld a,3
    out ($FE),a     ;change border color
;load ball coordinates
    ei          ;enable interruptions
    halt        ;wait for TV beam at begining 
    ld b,12
again:
    
    ld c,100
;    call print_ball
;hold:
;    jp hold;
    
   
gameloop:    
    call record_backround
    ld a,2
    out ($FE),a     ;change border color
    call print_ball
    call wait_beam_init
    call print_recorded_background
    call next_action
    jp gameloop; 

wait_beam_init:
    ld a,7
    out ($FE),a     ;change border color
    halt
    ld a,1
    out ($FE),a     ;change border color
    ret

next_action:
    push bc
    ld bc,#FDFE
    in a,(c)
    pop bc
try_a:
    srl a           ;flag c holds the carry
    jp c, try_s
    dec b
try_s:
    srl a           ;flag c holds the carry
    jp c, try_d
    inc c
try_d:
    srl a           ;flag c holds the carry
    jp c, try_w
    inc b
try_w:
    push bc
    ld bc,#FBFE
    in a,(c)
    pop bc
    srl a           
    srl a          ;flag c holds the carry    
    jp c, nothing
    dec c
nothing:
    ret


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
    ; arguments: b=x_pos(pixel)  c=y_pos(pixel)

    ; use memory to video in this subroutine
    ld a,0              ; 0 = mem2video
    ld (temp_var), a

    push bc
    ;ld de,background_tile
    srl b
    srl b
    srl b
    ld ix,background_buffer_11
    call transferchar
    inc b
    ld ix,background_buffer_12
    call transferchar
    pop bc
    ret

record_backround:
    ; arguments: b=x_pos (pixel)  c=y_pos (pixel)

    ; use memory to video in this subroutine
    ld a,1              ; 1 = video2mem
    ld (temp_var), a

    push bc
    ;ld de,background_tile
    srl b
    srl b
    srl b
    ld ix,background_buffer_11
    call transferchar
    inc b
    ld ix,background_buffer_12
    call transferchar
    pop bc
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
    
    ld a,3
    out ($FE),a     ;change border color
    
    ; first char
    ld ix, sprite_mask_swipped_11
    ld a,2              ; 2 = apply mask (AND)
    ld (temp_var), a
    call transferchar
    ld ix, sprite_swipped_11
    ld a,3              ; 3= apply sprite (OR)
    ld (temp_var), a
    call transferchar
    
    ld a,4
    out ($FE),a     ;change border color

    
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
; arguments: b=x_pos(char)  c=y_pos(pixel)
;            ix = char memory position
;            temp_var = direction    ->  0=mem2video   ; 1=video2mem 
;                                 2=apply mask  ; 3=apply sprite
; variable hl = video memory address
; variable iy = video_conversion
    push bc     ; changing coordinates (incrementing c=y_pos)
    push de     ; de: 16-bit version of y_pos (pixel)
    push hl     ; video memory address calculation
    push ix     ; char memory position will increase
    push iy     ; calculation of LUT argumnet: coordinate to hl 
    
    ld a,ball_sprite_LENGTH
    ld (aux_var_1),a
calculate_hl:
    ; load y position into 16-bit register
    ld d,0
    ld e,c
    ; h
    ld iy,video_conversion_h       ; calculate video offset 
    add iy, de                      ; add the y pos
    ld a, (iy)                     ; load the h coordinate
    or $40                         ; add constant
    ld h,a                         ; load it to the h video address
    ; l
    ld iy,video_conversion_l       ; calculate video offset 
    add iy, de                      ; add the y pos
    ld a,(iy)                   ; load y5y4y3
    or b                         ; add x7x6x5x4x3
    ld l,a                      ; store it in l
    
; now we have the video coordinates on hl
    ld a,(temp_var)
    cp 0
    jp z, mem2video    ; decides direction of transfer
    cp 1
    jp z, video2mem    ; decides direction of transfer
    cp 2
    jp z, applymask    ; decides direction of transfer
    cp 3
    jp z, applysprite    ; decides direction of transfer
mem2video:
    ld a,(ix)           ; load a with the byte row
    ld (hl),a           ; load byte row into video memory
    inc ix              ; go to next sprite byte row
    inc c;
    jp next_row
video2mem:
    ld a,(hl)           ; load a with the byte row
    ld (ix),a           ; load byte row into video memory
    inc ix              ; go to next sprite byte row
    inc c;
    jp next_row
applymask:
    ld a,(hl)           ; load a with video info
    and (ix)            ; apply the mask to the video info
    ld (hl),a           ; save it back to the video mem
    inc ix              ; go to next sprite byte row
    inc c;
    jp next_row
applysprite:
    ld a,(ix)           ; load a with the byte row
    or (hl)
    ld (hl),a           ; load byte row into video memory
    inc ix              ; go to next sprite byte row
    inc c;
    ;jp next_row
next_row:
    ld a,(aux_var_1)
    dec a
    ld (aux_var_1),a
    cp 0
    jr nz,calculate_hl
    
transferchar_exit:
    pop iy
    pop ix
    pop hl
    pop de
    pop bc
    
    ret
    
        

draw_background:
    ld b,0                              ; starting x pos
    ld c,0                              ; starting y pos
    ;ld ix,#3D50                         ; starting char to print
    ld ix,background_tile               ; load the address of the char bitmap
    ld de,8                             ; increment 8 bytes per char
draw_background_topbot_loop:
    ;add ix,de
    ld a,0
    ld (temp_var), a                    ; memory to video
    call transferchar2
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
    
transferchar2:
; arguments: bc : x_pos(char)  y_pos(char)
;            ix : char memory position
;            temp_var  direction    ->  0=mem2video   ; 1=video2mem 
    push de  ; d as a counter
    push hl  ; video memory address
    push ix  ; incrementing it during the routine
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
    ld d,ball_sprite_LENGTH
    ld a,(temp_var)
    cp a
    jp z, mem2video2    ; decides direction of transfer
    dec a
    jp z, video2mem2    ; decides direction of transfer
mem2video2:
    ld a,(ix)           ; load a with the byte row
    ld (hl),a           ; load byte row into video memory
    inc ix              ; go to next sprite byte row
    inc h               ; go to next row in the video memory
    dec d               ; decrement row counter
    jr nz,mem2video2           ; if B not zero, jump back to top of loop (condition,relative)
    jp transferchar2_exit
video2mem2:
    ld a,(hl)           ; load a with the byte row
    ld (ix),a           ; load byte row into video memory
    inc ix              ; go to next sprite byte row
    inc h               ; go to next row in the video memory
    dec d               ; decrement row counter
    jr nz,video2mem2           ; if B not zero, jump back to top of loop (condition,relative)
transferchar2_exit:    
    pop ix
    pop hl
    pop de
    ret

; Deployment: Snapshot
   SAVESNA "load.sna", start
   ;SAVETAP "load.tap", start
   
   
