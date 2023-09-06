; -------------------------------------------
; Into The Eagle's Nest Amiga
; Disasembled, Debugged & Improved by Franck "hitchhikr" Charlet
; -------------------------------------------

_LVOSetIntVector    equ     -162
_LVOAddIntServer    equ     -168
_LVOAllocMem        equ     -198
_LVOCloseLibrary    equ     -414
_LVOOpenDevice      equ     -444
_LVODoIO            equ     -456
_LVOOpenLibrary     equ     -552

_LVOOpen            equ     -30
_LVOClose           equ     -36
_LVORead            equ     -42
_LVOIoErr           equ     -132

; -------------------------------------------

                    section  eagle_nest,code

start:
                    bra.w    START_ALL

VARS:
KBDSTDIO:           dcb.l    7,0
KBD_CMD:            dc.w     1
KBD_FLAGS:          dc.b     1
KBD_ERROR:          dc.b     0
KBD_ACTUAL:         dcb.b    4,0
KBD_LENGTH:         dc.l     13
KBD_DATA:           dc.l     KBDMATRIX
KBD_OFFSET:         dc.l     0
KBD_RESERVED1:      dc.l     0
KBD_RESERVED2:      dc.l     0
VERTBINTR:          dcb.w    11,0
ADSTRUCT:           dcb.l    5,0
ADDEV:              dc.l     0
ADUNIT:             dcb.w    2,0
ADCMD:              dc.w     0
ADFLAGS:            dc.b     0
ADERROR:            dc.b     0
ADALLOCKEY:         dcb.b    2,0
ADDATA:             dcb.b    4,0
ADLENGTH:           dc.l     0
ADPERIOD:           dc.w     0
ADVOLUME:           dc.w     0
ADCYCLES:           dc.w     0
ADWRITEMSG:         dcb.w    10,0
AUDINT0:            dcb.w    11,0
AUDINT1:            dcb.w    11,0
AUDINT2:            dcb.w    11,0
AUDINT3:            dcb.w    11,0
MUSIC_COUNT:        dc.w     0
DOSBASE:            dc.l     0
CLISTPTR:           dc.l     0
VIDPTR:             dc.l     0
TEMP:               dc.l     0
STPTR:              dc.l     0
FILEHANDLE:         dc.l     0
MAPSPTR:            dc.l     0
CHRSETPTR:          dc.l     0
BLOCKPTR:           dc.l     0
MD0CSTPTR:          dc.l     0
BUFFERPTR:          dc.l     0
NMELSTPTR:          dc.l     0
PANELPTR:           dc.l     0
CLANKPTR:           dc.l     0
GUNPTR:             dc.l     0
BANGPTR:            dc.l     0
MUSPTR:             dc.l     0
KBDMATRIX:          dcb.l    4,0
KBDPTR:             dc.l     KBDMATRIX
; mindscape title screen (amiga format)
MINDFN:             dc.b     'data/ms.raw',0
                    even
; game title screen (amiga format)
SCRNFN:             dc.b     'data/scrn.raw',0
                    even
; castle 1 map (4 levels)
MAPSFN:             dc.b     'data/maps',0
                    even
; castle 2 map (4 levels)
MAPS2FN:            dc.b     'data/maps2',0
                    even
; blocks (?) 128*16 bytes 
BLKSFN:             dc.b     'data/blocks',0
                    even
; gfx 256*64 bytes tiles
GFXFN:              dc.b     'data/gfx',0
                    even
; font (46 * 64 bytes)
MD0CSTFN:           dc.b     'data/font',0
                    even
; hud (amiga format)
PANELFN:            dc.b     'data/panel.raw',0
                    even
; samples (mono 8 bit unsigned)
CLANKFN:            dc.b     'data/clank.dig',0
                    even
BANGFN:             dc.b     'data/bang.dig',0
                    even
GUNFN:              dc.b     'data/gun2.dig',0
                    even
; music in two parts (mono 8 bit unsigned)
MUS0FN:             dc.b     'data/music0',0
                    even
MUS1FN:             dc.b     'data/music1',0
                    even
DOSNAME:            dc.b     'dos.library',0
                    even
KBDNAME:            dc.b     'keyboard.device',0
                    even
AUDIONAME:          dc.b     'audio.device',0
                    even
VERTBNAME:          dc.b     0
AUD0NAME:           dc.b     0
                    even
; game palette
COLS:               dc.w     $000,$444,$777,$330
                    dc.w     $760,$020,$040,$232
                    dc.w     $077,$110,$743,$773
                    dc.w     $017,$730,$300,$710

; -------------------------------------------

START_ALL:
                    lea      VARS(pc),a2
                    clr.l    (DOSBASE)-VARS(a2)
                    lea      (DOSNAME)-VARS(a2),a1
                    moveq    #0,d0
                    move.l   a6,-(sp)
                    movea.l  (4).w,a6
                    jsr      (_LVOOpenLibrary,a6)
                    movea.l  (sp)+,a6
                    tst.l    d0
                    beq.w    ERROR
                    move.l   d0,(DOSBASE)-VARS(a2)

                    move.l   #(200*4*40)+32,d0
                    move.l   #$10000,d1
                    move.l   a6,-(sp)
                    movea.l  (4).w,a6
                    jsr      (_LVOAllocMem,a6)
                    movea.l  (sp)+,a6
                    tst.l    d0
                    beq.w    ERROR
                    move.l   d0,(STPTR)-VARS(a2)

                    moveq    #(ECLIST-CLIST),d0
                    move.l   #$10002,d1
                    move.l   a6,-(sp)
                    movea.l  (4).w,a6
                    jsr      (_LVOAllocMem,a6)
                    movea.l  (sp)+,a6
                    tst.l    d0
                    beq.w    ERROR
                    move.l   d0,(CLISTPTR)-VARS(a2)

                    move.l   #(200*4*40),d0
                    move.l   #$10002,d1
                    move.l   a6,-(sp)
                    movea.l  (4).w,a6
                    jsr      (_LVOAllocMem,a6)
                    movea.l  (sp)+,a6
                    tst.l    d0
                    beq.w    ERROR
                    move.l   d0,(VIDPTR)-VARS(a2)

                    move.l   (VIDPTR)-VARS(a2),d0
                    move.l   d0,(TEMP)-VARS(a2)
                    move.w   (TEMP)-VARS(a2),(CLVID0)-VARS(a2)
                    move.w   (TEMP+2)-VARS(a2),(CLVID1)-VARS(a2)
                    addi.l   #(200*40),(TEMP)-VARS(a2)
                    move.w   (TEMP)-VARS(a2),(CLVID2)-VARS(a2)
                    move.w   (TEMP+2)-VARS(a2),(CLVID3)-VARS(a2)
                    addi.l   #(200*40),(TEMP)-VARS(a2)
                    move.w   (TEMP)-VARS(a2),(CLVID4)-VARS(a2)
                    move.w   (TEMP+2),(CLVID5)-VARS(a2)
                    addi.l   #(200*40),(TEMP)-VARS(a2)
                    move.w   (TEMP)-VARS(a2),(CLVID6)-VARS(a2)
                    move.w   (TEMP+2)-VARS(a2),(CLVID7)-VARS(a2)

                    movea.l  (CLISTPTR)-VARS(a2),a0
                    lea      (CLIST)-VARS(a2),a1
                    moveq    #(ECLIST-CLIST)-1,d1
STARTA0:            move.b   (a1)+,(a0)+
                    dbra     d1,STARTA0

                    lea      ($DFF000),a0
                    move.w   #$4200,($100,a0)
                    clr.w    ($102,a0)
                    clr.w    ($106,a0)
                    clr.w    ($1FC,a0)
                    move.w   #$38,($92,a0)
                    move.w   #$D0,($94,a0)
                    move.w   #$2C81,($8E,a0)
                    move.w   #$F4C1,($90,a0)
                    move.l   (CLISTPTR)-VARS(a2),d0
                    move.l   d0,($DFF080)
                    move.w   ($DFF088),d0
                    move.w   #$8080,d0
                    move.w   d0,($DFF096)
                    move.w   #$25,d0
                    move.w   d0,($DFF096)

                    ; load mindscape picture
                    move.l   #MINDFN,d1
                    move.l   #$3ED,d2
                    move.l   a6,-(sp)
                    movea.l  (DOSBASE)-VARS(a2),a6
                    jsr      (_LVOOpen,a6)
                    movea.l  (sp)+,a6
                    tst.l    d0
                    beq.w    ERROR0
                    move.l   d0,(FILEHANDLE)-VARS(a2)
                    move.l   (FILEHANDLE)-VARS(a2),d1
                    move.l   (STPTR)-VARS(a2),d2
                    move.l   #32032,d3
                    move.l   a6,-(sp)
                    movea.l  (DOSBASE)-VARS(a2),a6
                    jsr      (_LVORead,a6)
                    movea.l  (sp)+,a6
                    tst.l    d0
                    bmi.w    ERROR0
                    move.l   (FILEHANDLE)-VARS(a2),d1
                    move.l   a6,-(sp)
                    movea.l  (DOSBASE)-VARS(a2),a6
                    jsr      (_LVOClose,a6)
                    movea.l  (sp)+,a6

                    ; set colors to mindscape picture's palette
                    lea      ($DFF180),a0
                    movea.l  (STPTR)-VARS(a2),a1
                    moveq    #16-1,d1
STARTA2:            move.w   (a1)+,(a0)+
                    dbra     d1,STARTA2

                    ; copy the picture to video memory
                    movea.l  (VIDPTR)-VARS(a2),a0
                    movea.l  (STPTR)-VARS(a2),a1
                    lea      32(a1),a1
                    move.w   #(200*40*4)/4-1,d0
STARTA1:            move.l   (a1)+,(a0)+
                    dbra     d0,STARTA1

                    move.l   #2048,d0
                    moveq    #0,d1
                    move.l   a6,-(sp)
                    movea.l  (4).w,a6
                    jsr      (_LVOAllocMem,a6)
                    movea.l  (sp)+,a6
                    tst.l    d0
                    beq.w    ERROR
                    move.l   d0,(BLOCKPTR)-VARS(a2)

                    move.l   #BLKSFN,d1
                    move.l   #$3ED,d2
                    move.l   a6,-(sp)
                    movea.l  (DOSBASE)-VARS(a2),a6
                    jsr      (_LVOOpen,a6)
                    movea.l  (sp)+,a6
                    tst.l    d0
                    beq.w    ERROR0
                    move.l   d0,(FILEHANDLE)-VARS(a2)
                    move.l   (FILEHANDLE)-VARS(a2),d1
                    move.l   (BLOCKPTR)-VARS(a2),d2
                    move.l   #2048,d3
                    move.l   a6,-(sp)
                    movea.l  (DOSBASE)-VARS(a2),a6
                    jsr      (_LVORead,a6)
                    movea.l  (sp)+,a6
                    tst.l    d0
                    bmi.w    ERROR0
                    move.l   (FILEHANDLE)-VARS(a2),d1
                    move.l   a6,-(sp)
                    movea.l  (DOSBASE)-VARS(a2),a6
                    jsr      (_LVOClose,a6)
                    movea.l  (sp)+,a6

                    move.l   #141840,d0
                    moveq    #0,d1
                    move.l   a6,-(sp)
                    movea.l  (4).w,a6
                    jsr      (_LVOAllocMem,a6)
                    movea.l  (sp)+,a6
                    tst.l    d0
                    beq.w    ERROR
                    move.l   d0,(BUFFERPTR)-VARS(a2)

                    move.l   #2048,d0
                    moveq    #0,d1
                    move.l   a6,-(sp)
                    movea.l  (4).w,a6
                    jsr      (_LVOAllocMem,a6)
                    movea.l  (sp)+,a6
                    tst.l    d0
                    beq.w    ERROR
                    move.l   d0,(NMELSTPTR)-VARS(a2)

                    move.l   #16384,d0
                    moveq    #0,d1
                    move.l   a6,-(sp)
                    movea.l  (4).w,a6
                    jsr      (_LVOAllocMem,a6)
                    movea.l  (sp)+,a6
                    tst.l    d0
                    beq.w    ERROR
                    move.l   d0,(CHRSETPTR)-VARS(a2)

                    move.l   #GFXFN,d1
                    move.l   #$3ED,d2
                    move.l   a6,-(sp)
                    movea.l  (DOSBASE)-VARS(a2),a6
                    jsr      (_LVOOpen,a6)
                    movea.l  (sp)+,a6
                    tst.l    d0
                    beq.w    ERROR0
                    move.l   d0,(FILEHANDLE)-VARS(a2)
                    move.l   (FILEHANDLE)-VARS(a2),d1
                    move.l   (CHRSETPTR)-VARS(a2),d2
                    move.l   #16384,d3
                    move.l   a6,-(sp)
                    movea.l  (DOSBASE)-VARS(a2),a6
                    jsr      (_LVORead,a6)
                    movea.l  (sp)+,a6
                    tst.l    d0
                    bmi.w    ERROR0
                    move.l   (FILEHANDLE)-VARS(a2),d1
                    move.l   a6,-(sp)
                    movea.l  (DOSBASE)-VARS(a2),a6
                    jsr      (_LVOClose,a6)
                    movea.l  (sp)+,a6

                    move.l   #4096,d0
                    moveq    #0,d1
                    move.l   a6,-(sp)
                    movea.l  (4).w,a6
                    jsr      (_LVOAllocMem,a6)
                    movea.l  (sp)+,a6
                    tst.l    d0
                    beq.w    ERROR
                    move.l   d0,(MD0CSTPTR)-VARS(a2)

                    move.l   #MD0CSTFN,d1
                    move.l   #$3ED,d2
                    move.l   a6,-(sp)
                    movea.l  (DOSBASE)-VARS(a2),a6
                    jsr      (_LVOOpen,a6)
                    movea.l  (sp)+,a6
                    tst.l    d0
                    beq.w    ERROR0
                    move.l   d0,(FILEHANDLE)-VARS(a2)
                    move.l   (FILEHANDLE)-VARS(a2),d1
                    move.l   (MD0CSTPTR)-VARS(a2),d2
                    move.l   #4096,d3
                    move.l   a6,-(sp)
                    movea.l  (DOSBASE)-VARS(a2),a6
                    jsr      (_LVORead,a6)
                    movea.l  (sp)+,a6
                    tst.l    d0
                    bmi.w    ERROR0
                    move.l   (FILEHANDLE)-VARS(a2),d1
                    move.l   a6,-(sp)
                    movea.l  (DOSBASE)-VARS(a2),a6
                    jsr      (_LVOClose,a6)
                    movea.l  (sp)+,a6

                    ; load title picture
                    move.l   #SCRNFN,d1
                    move.l   #$3ED,d2
                    move.l   a6,-(sp)
                    movea.l  (DOSBASE)-VARS(a2),a6
                    jsr      (_LVOOpen,a6)
                    movea.l  (sp)+,a6
                    tst.l    d0
                    beq.w    ERROR0
                    move.l   d0,(FILEHANDLE)-VARS(a2)
                    move.l   (FILEHANDLE)-VARS(a2),d1
                    move.l   (STPTR)-VARS(a2),d2
                    move.l   #32032,d3
                    move.l   a6,-(sp)
                    movea.l  (DOSBASE)-VARS(a2),a6
                    jsr      (_LVORead,a6)
                    movea.l  (sp)+,a6
                    tst.l    d0
                    bmi.w    ERROR0
                    move.l   (FILEHANDLE)-VARS(a2),d1
                    move.l   a6,-(sp)
                    movea.l  (DOSBASE)-VARS(a2),a6
                    jsr      (_LVOClose,a6)
                    movea.l  (sp)+,a6

                    move.w   #90-1,d0
.wait1:             btst.b   #0,($DFF005)
                    beq.b    .wait1
.wait2:             btst.b   #0,($DFF005)
                    bne.b    .wait2
                    dbf      d0,.wait1

                    ; set colors to title picture's palette
                    lea      ($DFF180),a0
                    movea.l  (STPTR)-VARS(a2),a1
                    moveq    #16-1,d1
PSTARTA2:           move.w   (a1)+,(a0)+
                    dbra     d1,PSTARTA2

                    ; copy the picture to video memory
                    movea.l  (VIDPTR)-VARS(a2),a0
                    movea.l  (STPTR)-VARS(a2),a1
                    lea      32(a1),a1
                    move.w   #(200*40*4)/4-1,d0
PSTARTA1:           move.l   (a1)+,(a0)+
                    dbra     d0,PSTARTA1

                    ; load panel picture
                    move.l   #PANELFN,d1
                    move.l   #$3ED,d2
                    move.l   a6,-(sp)
                    movea.l  (DOSBASE)-VARS(a2),a6
                    jsr      (_LVOOpen,a6)
                    movea.l  (sp)+,a6
                    tst.l    d0
                    beq.w    ERROR0
                    move.l   d0,(FILEHANDLE)-VARS(a2)
                    move.l   (FILEHANDLE)-VARS(a2),d1
                    move.l   (STPTR)-VARS(a2),d2
                    move.l   #32000,d3
                    move.l   a6,-(sp)
                    movea.l  (DOSBASE),a6
                    jsr      (_LVORead,a6)
                    movea.l  (sp)+,a6
                    tst.l    d0
                    bmi.w    ERROR0
                    move.l   (FILEHANDLE)-VARS(a2),d1
                    move.l   a6,-(sp)
                    movea.l  (DOSBASE)-VARS(a2),a6
                    jsr      (_LVOClose,a6)
                    movea.l  (sp)+,a6

                    move.l   (STPTR)-VARS(a2),(PANELPTR)-VARS(a2)

                    move.l   #8192,d0
                    moveq    #0,d1
                    move.l   a6,-(sp)
                    movea.l  (4).w,a6
                    jsr      (_LVOAllocMem,a6)
                    movea.l  (sp)+,a6
                    tst.l    d0
                    beq.w    ERROR
                    move.l   d0,(MAPSPTR)-VARS(a2)

                    move.l   #MAPSFN,d1
                    move.l   #$3ED,d2
                    move.l   a6,-(sp)
                    movea.l  (DOSBASE)-VARS(a2),a6
                    jsr      (_LVOOpen,a6)
                    movea.l  (sp)+,a6
                    tst.l    d0
                    beq.w    ERROR0
                    move.l   d0,(FILEHANDLE)-VARS(a2)
                    move.l   (FILEHANDLE)-VARS(a2),d1
                    move.l   (MAPSPTR)-VARS(a2),d2
                    move.l   #4096,d3
                    move.l   a6,-(sp)
                    movea.l  (DOSBASE)-VARS(a2),a6
                    jsr      (_LVORead,a6)
                    movea.l  (sp)+,a6
                    tst.l    d0
                    bmi.w    ERROR0
                    move.l   (FILEHANDLE)-VARS(a2),d1
                    move.l   a6,-(sp)
                    movea.l  (DOSBASE)-VARS(a2),a6
                    jsr      (_LVOClose,a6)
                    movea.l  (sp)+,a6

                    move.l   #MAPS2FN,d1
                    move.l   #$3ED,d2
                    move.l   a6,-(sp)
                    movea.l  (DOSBASE)-VARS(a2),a6
                    jsr      (_LVOOpen,a6)
                    movea.l  (sp)+,a6
                    tst.l    d0
                    beq.w    ERROR0
                    move.l   d0,(FILEHANDLE)-VARS(a2)
                    move.l   (FILEHANDLE)-VARS(a2),d1
                    move.l   (BUFFERPTR)-VARS(a2),d2
                    move.l   #4096,d3
                    move.l   a6,-(sp)
                    movea.l  (DOSBASE)-VARS(a2),a6
                    jsr      (_LVORead,a6)
                    movea.l  (sp)+,a6
                    tst.l    d0
                    bmi.w    ERROR0
                    move.l   (FILEHANDLE)-VARS(a2),d1
                    move.l   a6,-(sp)
                    movea.l  (DOSBASE)-VARS(a2),a6
                    jsr      (_LVOClose,a6)
                    movea.l  (sp)+,a6

                    movea.l  (BUFFERPTR)-VARS(a2),a0
                    movea.l  (MAPSPTR)-VARS(a2),a1
                    lea      4096(a1),a1
                    move.w   #4096-1,d0
STARTA9:            move.b   (a0)+,(a1)+
                    dbra     d0,STARTA9

                    ; load the samples
                    move.l   #4070,d0
                    move.l   #$10002,d1
                    move.l   a6,-(sp)
                    movea.l  (4).w,a6
                    jsr      (_LVOAllocMem,a6)
                    movea.l  (sp)+,a6
                    tst.l    d0
                    beq.w    ERROR
                    move.l   d0,(CLANKPTR)-VARS(a2)
                    move.l   #CLANKFN,d1
                    move.l   #$3ED,d2
                    move.l   a6,-(sp)
                    movea.l  (DOSBASE)-VARS(a2),a6
                    jsr      (_LVOOpen,a6)
                    movea.l  (sp)+,a6
                    tst.l    d0
                    beq.w    ERROR0
                    move.l   d0,(FILEHANDLE)-VARS(a2)
                    move.l   (FILEHANDLE)-VARS(a2),d1
                    move.l   (BUFFERPTR)-VARS(a2),d2
                    move.l   #4068,d3
                    move.l   a6,-(sp)
                    movea.l  (DOSBASE)-VARS(a2),a6
                    jsr      (_LVORead,a6)
                    movea.l  (sp)+,a6
                    tst.l    d0
                    bmi.w    ERROR0
                    move.l   (FILEHANDLE)-VARS(a2),d1
                    move.l   a6,-(sp)
                    movea.l  (DOSBASE)-VARS(a2),a6
                    jsr      (_LVOClose,a6)
                    movea.l  (sp)+,a6
                    movea.l  (CLANKPTR)-VARS(a2),a0
                    move.l   #4068,d0
                    bsr.w    COPYMUS

                    move.l   #23290,d0
                    move.l   #$10002,d1
                    move.l   a6,-(sp)
                    movea.l  (4).w,a6
                    jsr      (_LVOAllocMem,a6)
                    movea.l  (sp)+,a6
                    tst.l    d0
                    beq.w    ERROR
                    move.l   d0,(BANGPTR)-VARS(a2)
                    move.l   #BANGFN,d1
                    move.l   #$3ED,d2
                    move.l   a6,-(sp)
                    movea.l  (DOSBASE)-VARS(a2),a6
                    jsr      (_LVOOpen,a6)
                    movea.l  (sp)+,a6
                    tst.l    d0
                    beq.w    ERROR0
                    move.l   d0,(FILEHANDLE)-VARS(a2)
                    move.l   (FILEHANDLE)-VARS(a2),d1
                    move.l   (BUFFERPTR)-VARS(a2),d2
                    move.l   #23284,d3
                    move.l   a6,-(sp)
                    movea.l  (DOSBASE)-VARS(a2),a6
                    jsr      (_LVORead,a6)
                    movea.l  (sp)+,a6
                    tst.l    d0
                    bmi.w    ERROR0
                    move.l   (FILEHANDLE)-VARS(a2),d1
                    move.l   a6,-(sp)
                    movea.l  (DOSBASE)-VARS(a2),a6
                    jsr      (_LVOClose,a6)
                    movea.l  (sp)+,a6
                    movea.l  (BANGPTR)-VARS(a2),a0
                    move.l   #23284,d0
                    bsr.w    COPYMUS

                    move.l   #2090,d0
                    move.l   #$10002,d1
                    move.l   a6,-(sp)
                    movea.l  (4).w,a6
                    jsr      (_LVOAllocMem,a6)
                    movea.l  (sp)+,a6
                    tst.l    d0
                    beq.w    ERROR
                    move.l   d0,(GUNPTR)-VARS(a2)
                    move.l   #GUNFN,d1
                    move.l   #$3ED,d2
                    move.l   a6,-(sp)
                    movea.l  (DOSBASE)-VARS(a2),a6
                    jsr      (_LVOOpen,a6)
                    movea.l  (sp)+,a6
                    tst.l    d0
                    beq.w    ERROR0
                    move.l   d0,(FILEHANDLE)-VARS(a2)
                    move.l   (FILEHANDLE)-VARS(a2),d1
                    move.l   (BUFFERPTR)-VARS(a2),d2
                    move.l   #2088,d3
                    move.l   a6,-(sp)
                    movea.l  (DOSBASE)-VARS(a2),a6
                    jsr      (_LVORead,a6)
                    movea.l  (sp)+,a6
                    tst.l    d0
                    bmi.w    ERROR0
                    move.l   (FILEHANDLE)-VARS(a2),d1
                    move.l   a6,-(sp)
                    movea.l  (DOSBASE)-VARS(a2),a6
                    jsr      (_LVOClose,a6)
                    movea.l  (sp)+,a6
                    movea.l  (GUNPTR)-VARS(a2),a0
                    move.l   #2088,d0
                    bsr.w    COPYMUS

                    ; load the music
                    move.l   #70920,d0
                    move.l   #$10002,d1
                    move.l   a6,-(sp)
                    movea.l  (4).w,a6
                    jsr      (_LVOAllocMem,a6)
                    movea.l  (sp)+,a6
                    tst.l    d0
                    beq.w    ERROR
                    move.l   d0,(MUSPTR)-VARS(a2)

                    move.l   #MUS0FN,d1
                    move.l   #$3ED,d2
                    move.l   a6,-(sp)
                    movea.l  (DOSBASE)-VARS(a2),a6
                    jsr      (_LVOOpen,a6)
                    movea.l  (sp)+,a6
                    tst.l    d0
                    beq.w    ERROR0
                    move.l   d0,(FILEHANDLE)-VARS(a2)
                    move.l   (FILEHANDLE)-VARS(a2),d1
                    move.l   (BUFFERPTR)-VARS(a2),d2
                    move.l   #70920,d3
                    move.l   a6,-(sp)
                    movea.l  (DOSBASE)-VARS(a2),a6
                    jsr      (_LVORead,a6)
                    movea.l  (sp)+,a6
                    tst.l    d0
                    bmi.w    ERROR0
                    move.l   (FILEHANDLE)-VARS(a2),d1
                    move.l   a6,-(sp)
                    movea.l  (DOSBASE)-VARS(a2),a6
                    jsr      (_LVOClose,a6)
                    movea.l  (sp)+,a6
                    movea.l  (MUSPTR)-VARS(a2),a0
                    move.l   #70920,d0
                    bsr.w    COPYMUS

                    move.l   #MUS1FN,d1
                    move.l   #$3ED,d2
                    move.l   a6,-(sp)
                    movea.l  (DOSBASE)-VARS(a2),a6
                    jsr      (_LVOOpen,a6)
                    movea.l  (sp)+,a6
                    tst.l    d0
                    beq.w    ERROR0
                    move.l   d0,(FILEHANDLE)-VARS(a2)
                    move.l   (FILEHANDLE)-VARS(a2),d1
                    move.l   (BUFFERPTR)-VARS(a2),d2
                    move.l   #70920,d3
                    move.l   a6,-(sp)
                    movea.l  (DOSBASE)-VARS(a2),a6
                    jsr      (_LVORead,a6)
                    movea.l  (sp)+,a6
                    tst.l    d0
                    bmi.w    ERROR0
                    move.l   (FILEHANDLE)-VARS(a2),d1
                    move.l   a6,-(sp)
                    movea.l  (DOSBASE)-VARS(a2),a6
                    jsr      (_LVOClose,a6)
                    movea.l  (sp)+,a6
                    movea.l  (MUSPTR)-VARS(a2),a0
                    add.l    #70920,a0
                    move.l   #70920,d0
                    bsr.w    COPYMUS

                    lea      (KBDNAME)-VARS(a2),a0
                    clr.w    d0
                    lea      (KBDSTDIO)-VARS(a2),a1
                    move.w   #1,(KBD_CMD)-VARS(a2)
                    clr.w    d1
                    movem.l  a2/a6,-(sp)
                    movea.l  (4).w,a6
                    jsr      (_LVOOpenDevice,a6)
                    movem.l  (sp)+,a2/a6
                    tst.l    d0
                    bne.w    ERROR

                    lea      (KBDSTDIO)-VARS(a2),a0
                    move.w   #10,(KBD_CMD)-VARS(a2)
                    move.l   #KBDMATRIX,(KBD_DATA)-VARS(a2)
                    move.l   #13,(KBD_LENGTH)-VARS(a2)
                    move.b   #1,(KBD_FLAGS)-VARS(a2)
                    lea      (AUDIONAME)-VARS(a2),a0
                    clr.w    d0
                    lea      (ADSTRUCT)-VARS(a2),a1
                    move.w   #1,(ADCMD)-VARS(a2)
                    move.w   #15,(ADUNIT)-VARS(a2)
                    sf.b     (ADFLAGS)-VARS(a2)
                    clr.w    d1

                    movem.l  a2/a6,-(sp)
                    movea.l  (4).w,a6
                    jsr      (_LVOOpenDevice,a6)
                    movem.l  (sp)+,a2/a6
                    move.w   #$20,(ADCMD)-VARS(a2)
                    clr.l    (ADLENGTH)-VARS(a2)
                    lea      (ADSTRUCT)-VARS(a2),a1
                    movem.l  a2/a6,-(sp)
                    movea.l  (4).w,a6
                    jsr      (_LVODoIO,a6)
                    movem.l  (sp)+,a2/a6

                    lea      (VERTBINTR)-VARS(a2),a1
                    move.b   #2,(8,a1)
                    move.b   #$7F,(9,a1)
                    move.l   #VERTBNAME,(10,a1)
                    move.l   #VERTBSERVER,($12,a1)
                    move.w   #5,d0
                    movem.l  a2/a6,-(sp)
                    movea.l  (4).w,a6
                    jsr      (_LVOAddIntServer,a6)
                    movem.l  (sp)+,a2/a6

                    lea      (AUDINT0)-VARS(a2),a1
                    move.b   #2,(8,a1)
                    move.b   #$7F,(9,a1)
                    move.l   #AUD0NAME,(10,a1)
                    move.l   #ASERV,(18,a1)
                    move.w   #7,d0
                    movem.l  a2/a6,-(sp)
                    movea.l  (4).w,a6
                    jsr      (_LVOSetIntVector,a6)
                    movem.l  (sp)+,a2/a6

                    lea      (AUDINT1)-VARS(a2),a1
                    move.b   #2,(8,a1)
                    move.b   #$7F,(9,a1)
                    move.l   #AUD0NAME,(10,a1)
                    move.l   #ASERV,(18,a1)
                    move.w   #8,d0
                    movem.l  a2/a6,-(sp)
                    movea.l  (4).w,a6
                    jsr      (_LVOSetIntVector,a6)
                    movem.l  (sp)+,a2/a6

                    lea      (AUDINT2)-VARS(a2),a1
                    move.b   #2,(8,a1)
                    move.b   #$7F,(9,a1)
                    move.l   #AUD0NAME,(10,a1)
                    move.l   #ASERV,(18,a1)
                    move.w   #9,d0
                    movem.l  a2/a6,-(sp)
                    movea.l  (4).w,a6
                    jsr      (_LVOSetIntVector,a6)
                    movem.l  (sp)+,a2/a6

                    lea      (AUDINT3)-VARS(a2),a1
                    move.b   #2,(8,a1)
                    move.b   #$7F,(9,a1)
                    move.l   #AUD0NAME,(10,a1)
                    move.l   #ASERV,(18,a1)
                    move.w   #10,d0
                    movem.l  a2/a6,-(sp)
                    movea.l  (4).w,a6
                    jsr      (_LVOSetIntVector,a6)
                    movem.l  (sp)+,a2/a6

                    move.w   #$8020,($DFF09A)

                    bsr.w    START

EXIT:               movea.l  (DOSBASE)-VARS(a2),a1
                    move.l   a6,-(sp)
                    movea.l  (4).w,a6
                    jsr      (_LVOCloseLibrary,a6)
                    movea.l  (sp)+,a6
                    moveq    #0,d0
                    rts

ERROR:              bra.w    EXIT

ERROR0:             move.l   a6,-(sp)
                    movea.l  (DOSBASE)-VARS(a2),a6
                    jsr      (_LVOIoErr,a6)
                    movea.l  (sp)+,a6
                    bra.w    EXIT

CLIST:              dc.w     $9C,$8004
                    dc.w     $E0
CLVID0:             dc.w     0,$E2
CLVID1:             dc.w     0,$E4
CLVID2:             dc.w     0,$E6
CLVID3:             dc.w     0,$E8
CLVID4:             dc.w     0,$EA
CLVID5:             dc.w     0,$EC
CLVID6:             dc.w     0,$EE
CLVID7:             dc.w     0
                    dc.w     $FFFF,$FFFE
ECLIST:

; convert sample from unsigned to signed
COPYMUS:            movea.l  (BUFFERPTR)-VARS(a2),a1
COPYMUS1:           move.b   (a1)+,(a0)
                    addi.b   #128,(a0)+
                    subq.l   #1,d0
                    bne.b    COPYMUS1
                    rts

XLOAD:              eori.w   #1,(LOADED)-VARS(a2)
                    andi.w   #1,(LOADED)-VARS(a2)
                    rts

LOADED:             dc.w     0
INTCTR:             dc.w     0
JOYVAL:             dc.w     0
JYVAL2:             dc.w     0
FLYCTR:             dc.w     0
BILLX:              dc.w     0
BILLY:              dc.w     0
LPCTR:              dc.w     0
SCRX:               dc.w     0
SCRY:               dc.w     0
YOUX:               dc.w     0
YOUY:               dc.w     0
BILLOX:             dc.w     0
BILLOY:             dc.w     0
YOLDX:              dc.w     0
YOLDY:              dc.w     0
YFRAME:             dc.w     0
BULLS:              dc.w     0
HITS:               dc.w     0
LEVEL:              dc.w     0
XLEVEL:             dc.w     0
FIREFL:             dc.w     0
YOLDFR:             dc.w     0
ESCFLG:             dc.w     0
NMEOLX:             dc.w     0
NMEOLY:             dc.w     0
SCORE:              dc.l     0
HITFLG:             dc.w     0
HSCFLG:             dc.w     0
ANIMCT:             dc.w     0
RSTFLG:             dc.w     0
LVLPSS:             dc.w     0
LPSFLG:             dc.w     0
BILLLV:             dc.w     0
BILLFR:             dc.w     0
BILLHT:             dc.w     0
BILLFL:             dc.w     0
BILLOF:             dc.w     0
BILLXX:             dc.w     0
NMEMAX:             dc.w     0
BRNDLY:             dc.w     0
BILLCT:             dc.w     0
BILLDR:             dc.w     0
BILLOS:             dc.w     0
BILLAC:             dc.w     0
CELLX:              dc.w     0
CELLY:              dc.w     0
BILLLF:             dc.w     0
KEYS:               dc.w     0
TTLPAG:             dc.w     0
BORDER:             dc.w     0
SFX:                dc.w     0
MSNRFL:             dc.w     0
MSNNUM:             dc.w     0
BLSTLV:             dc.w     0
TTAFLG:             dc.w     0
TTADIR:             dc.w     0
TTAPOS:             dc.w     0
TTACNT:             dc.w     0
TTADLY:             dc.w     0
DIFLVL:             dc.w     0
ENVCT:              dc.w     0
ANIMXX:             dc.w     0
WLKSFX:             dc.w     0
YDLY:               dc.w     0
RUNFLG:             dc.w     0
MAPMOD:             dc.w     0
CHTFLG:             dc.w     0
NMECHT:             dc.w     0

START:
                    bra.w    B00

START0:             clr.w    (INTCTR)-VARS(a2)
                    clr.w    (RSTFLG)-VARS(a2)
                    clr.w    (BORDER)-VARS(a2)
                    tst.w    (RUNFLG)-VARS(a2)
                    beq.w    START
                    bsr.w    NEWHSC

B00:                bsr.w    INIT_MUSIC
                    move.w   #1,(BILLDR)-VARS(a2)
                    move.w   #1,(BRNDLY)-VARS(a2)
                    move.w   #1,(MSNRFL)-VARS(a2)
                    move.w   #0,(YDLY)-VARS(a2)
                    move.w   #0,(KEYS)-VARS(a2)
                    move.w   #0,(JOYVAL)-VARS(a2)
                    move.w   #0,(YFRAME)-VARS(a2)
                    move.w   #0,(HITS)-VARS(a2)
                    move.w   #0,(FIREFL)-VARS(a2)
                    move.l   #0,(SCORE)-VARS(a2)
                    move.w   #0,(HSCFLG)-VARS(a2)
                    move.w   #0,(BILLHT)-VARS(a2)
                    move.w   #0,(BILLFR)-VARS(a2)
                    move.w   #0,(BILLCT)-VARS(a2)
                    move.w   #0,(BILLOS)-VARS(a2)
                    move.w   #0,(BILLLF)-VARS(a2)
                    move.w   #0,(TTLPAG)-VARS(a2)
                    move.w   #0,(SCRX)-VARS(a2)
                    move.w   #0,(SCRY)-VARS(a2)
                    move.w   #0,(MSNNUM)-VARS(a2)
                    move.w   #0,(ESCFLG)-VARS(a2)
                    move.b   #$FF,(lbB002658)-VARS(a2)
                    move.b   #$FF,(lbB00265B)-VARS(a2)
                    move.b   #$FF,(lbB00265E)-VARS(a2)
                    move.b   #$FF,(lbB002661)-VARS(a2)
                    move.b   #$FF,(lbB002664)-VARS(a2)
                    move.b   #$FF,(lbB002667)-VARS(a2)
                    move.b   #$FF,(lbB00266A)-VARS(a2)
                    move.b   #$FF,(lbB00266D)-VARS(a2)
                    move.w   #$FFFF,(RUNFLG)-VARS(a2)
                    move.w   #$FFFF,(BILLFL)-VARS(a2)
                    move.w   #$FE,(XLEVEL)-VARS(a2)
                    move.w   #$FE,(RSTFLG)-VARS(a2)
                    move.w   #$99,(BULLS)-VARS(a2)
                    lea      (DIELST)-VARS(a2),a4
                    moveq    #15-1,d4
S01:                sf.b     (a4)+
                    dbra     d4,S01
                    move.w   #3,(LPCTR)-VARS(a2)
S10:                bsr.w    FRAME
                    bsr.w    BLACK
                    bsr.w    CLS
                    move.w   (TTLPAG)-VARS(a2),d0
                    andi.l   #3,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    lea      (TTLTBL)-VARS(a2),a0
                    adda.l   d0,a0
                    movea.l  (a0)+,a1
                    jsr      (a1)
                    bsr.w    SETCOL

                    move.w   #255-1,d7
S12:                bsr.w    FRAME
                    bsr.w    FRAME
                    bsr.w    TTANIM
                    bsr.w    KSCAN
                    btst     #4,(JOYVAL)-VARS(a2)
                    bne.w    CTRLMNU
                    dbra     d7,S12
                    addq.w   #1,(TTLPAG)-VARS(a2)
                    bra.w    S10

S13:                bsr.w    FRAME
                    bsr.w    FRAME
                    bsr.w    TTANIM
                    bsr.w    KSCAN
                    btst     #4,(JOYVAL)-VARS(a2)
                    bne.w    S13

START_GAME:         bsr.w    INTOBJ
                    bsr.w    GETDIF
                    moveq    #3,d0
                    sub.w    (DIFLVL)-VARS(a2),d0
                    move.w   d0,(DIFLVL)-VARS(a2)
                    bsr.w    BLACK
                    bsr.w    EXIT_MUSIC
                    clr.w    (SFX)-VARS(a2)
S19:                bsr.w    FRAME
                    bsr.w    BLACK
                    cmpi.w   #$FE,(XLEVEL)-VARS(a2)
                    bne.w    S16
                    move.w   #144,(SCRY)-VARS(a2)
                    move.w   #40,(SCRX)-VARS(a2)
                    move.w   #47,(YOUX)-VARS(a2)
                    move.w   #161,(YOUY)-VARS(a2)
                    move.w   #1,(LEVEL)-VARS(a2)
                    bra.w    S24

S16:                move.w   #10,(YOUX)-VARS(a2)
                    move.w   #151,(YOUY)-VARS(a2)
                    clr.w    (SCRX)-VARS(a2)
                    move.w   #144,(SCRY)-VARS(a2)
S24:                move.w   #2,(YFRAME)-VARS(a2)
                    clr.w    (LVLPSS)-VARS(a2)
                    lea      (BULLDT)-VARS(a2),a0
                    moveq    #32-1,d0
S02:                sf.b     (a0)+
                    dbra     d0,S02
                    lea      (DIELST)-VARS(a2),a0
                    moveq    #15-1,d0
S03:                sf.b     (a0)+
                    dbra     d0,S03
                    bsr.w    MAKEMP
                    bsr.w    MAKEMP
                    bsr.w    INTDIF
                    bsr.w    ERADET
                    bsr.w    PYOU
                    bsr.w    PBAK
                    bsr.w    RPSCR
                    bsr.w    FRAME
                    bsr.w    SETCOL
                    tst.w    (MSNRFL)-VARS(a2)
                    beq.w    S20
                    move.w   #0,(MSNRFL)-VARS(a2)
                    moveq    #0,d4
                    moveq    #9,d5
                    moveq    #16,d2
                    moveq    #6,d3
                    bsr.w    WINDOW
                    lea      (MSN)-VARS(a2),a1
                    moveq    #1,d4
                    moveq    #10,d5
                    bsr.w    WSPRNT
                    move.w   #10,d4
                    move.w   #10,d5
                    move.w   (MSNNUM)-VARS(a2),d0
                    ext.l    d0
                    mulu.w   #4,d0
                    lea      (MSNTB)-VARS(a2),a0
                    adda.l   d0,a0
                    movea.l  (a0),a1
                    bsr.w    WSPRNT
                    cmpi.w   #3,(DIFLVL)-VARS(a2)
                    bcs.w    S18
                    lea      (CAST0)-VARS(a2),a1
                    moveq    #4,d4
                    moveq    #12,d5
                    bsr.w    WSPRNT
                    lea      (CAST1)-VARS(a2),a1
                    moveq    #2,d4
                    moveq    #13,d5
                    bsr.w    WSPRNT
                    bra.w    S18A

S18:                lea      (RESC0)-VARS(a2),a1
                    moveq    #4,d4
                    moveq    #12,d5
                    bsr.w    WSPRNT
                    lea      (RESC1)-VARS(a2),a1
                    moveq    #2,d4
                    moveq    #13,d5
                    bsr.w    WSPRNT
S18A:               bsr.w    WAIT
S20:                moveq    #0,d4
                    moveq    #11,d5
                    moveq    #16,d2
                    moveq    #4,d3
                    bsr.w    WINDOW
                    lea      (YANI)-VARS(a2),a1
                    move.w   #12,d5
                    move.w   #1,d4
                    tst.w    (LEVEL)-VARS(a2)
                    beq.w    S21
                    lea      (YANO)-VARS(a2),a1
S21:                bsr.w    WSPRNT
                    move.w   (LEVEL)-VARS(a2),d0
                    ext.l    d0
                    mulu.w   #4,d0
                    lea      (LVLTB)-VARS(a2),a1
                    adda.l   d0,a1
                    movea.l  (a1),a1
                    move.w   #13,d5
                    move.w   #0,d4
                    bsr.w    WSPRNT
                    bsr.w    WAIT
                    clr.w    (XLEVEL)-VARS(a2)
S25:                tst.w    (MAPMOD)-VARS(a2)
                    beq.w    LOOP
MAPMD:              bsr.w    MAKEMP
MAPLP:              bsr.w    FRAME
                    move.w   (SCRX)-VARS(a2),d0
                    move.w   (SCRY)-VARS(a2),d1
                    addq.w   #8,d0
                    addi.w   #12,d1
                    bsr.w    CLCMAP
                    move.b   (a0),-(sp)
                    move.b   #1,(a0)
                    move.l   a0,-(sp)
                    bsr.w    PBAK
                    movea.l  (sp)+,a0
                    move.b   (sp)+,(a0)
                    move.w   (SCRX)-VARS(a2),d0
                    addq.w   #8,d0
                    moveq    #17,d4
                    moveq    #13,d5
                    bsr.w    WPHEXB
                    move.w   (SCRY)-VARS(a2),d0
                    addi.w   #12,d0
                    moveq    #17,d4
                    moveq    #15,d5
                    bsr.w    WPHEXB
                    bsr.w    KSCAN
                    btst     #4,(JOYVAL)-VARS(a2)
                    bne.w    MAPF
                    btst     #0,(JOYVAL)-VARS(a2)
                    bne.w    MAPU
                    btst     #1,(JOYVAL)-VARS(a2)
                    bne.w    MAPD
                    btst     #2,(JOYVAL)-VARS(a2)
                    bne.w    MAPL
                    btst     #3,(JOYVAL)-VARS(a2)
                    bne.w    MAPR
                    tst.w    (ESCFLG)-VARS(a2)
                    bne.w    START0
                    bra.w    MAPLP

MAPF:               addq.w   #1,(LEVEL)-VARS(a2)
                    andi.w   #3,(LEVEL)-VARS(a2)
                    bra.w    MAPMD

MAPU:               tst.w    (SCRY)-VARS(a2)
                    beq.w    MAPLP
                    subq.w   #1,(SCRY)-VARS(a2)
                    bra.w    MAPLP

MAPD:               cmpi.w   #144,(SCRY)-VARS(a2)
                    beq.w    MAPLP
                    addq.w   #1,(SCRY)-VARS(a2)
                    bra.w    MAPLP

MAPL:               tst.w    (SCRX)-VARS(a2)
                    beq.w    MAPLP
                    subq.w   #1,(SCRX)-VARS(a2)
                    bra.w    MAPLP

MAPR:               cmpi.w   #80,(SCRX)-VARS(a2)
                    beq.w    MAPLP
                    addq.w   #1,(SCRX)-VARS(a2)
                    bra.w    MAPLP

INTRO0:             dc.b     'WELCOME TO THE',$FF
INTRO1:             dc.b     'EAGLES  NEST',$FF
INTRO2:             dc.b     0,'PRESS FIRE',$FF
LVLTB:              dc.l     LVL1
                    dc.l     LVL2
                    dc.l     LVL3
                    dc.l     LVL4
LVL1:               dc.b     '  THE BASEMENT',$FF
LVL2:               dc.b     'THE GROUND FLOOR',$FF
LVL3:               dc.b     'THE FIRST FLOOR',$FF
LVL4:               dc.b     'THE SECOND FLOOR',$FF
YANO:               dc.b     'YOU ARE NOW ON',$FF
YANI:               dc.b     'YOU ARE NOW IN',$FF
MSN:                dc.b     'MISSION',$FF
                    even
MSNTB:              dc.l     MSN1
                    dc.l     MSN2
                    dc.l     MSN3
                    dc.l     MSN4
MSN1:               dc.b     '  ONE',$FF
MSN2:               dc.b     '  TWO',$FF
MSN3:               dc.b     'THREE',$FF
MSN4:               dc.b     ' FOUR',$FF
RESC0:              dc.b     ' RESCUE',$FF
RESC1:              dc.b     'THE PRISONER',$FF
CAST0:              dc.b     'BLOW  UP',$FF
CAST1:              dc.b     ' THE CASTLE',$FF
BLLVTB:             dc.b     ' BC',$FF
HIGH0:              dc.b     'CURRENT  HEROES',$FF
HSCTBL:             dc.b     'PANDORA ',$10,0,0
                    dc.b     'PANDORA ',$09,0,0
                    dc.b     'PANDORA ',$08,0,0
                    dc.b     'PANDORA ',$07,0,0
                    dc.b     'PANDORA ',$06,0,0
                    dc.b     'PANDORA ',$05,0,0
                    dc.b     'PANDORA ',$04,0,0
lbB001695:          dc.b     'PANDORA ',$03,0,0
lbB0016A0:          dc.b     'PANDORA '
HISCORE:            dc.b     0,$10,0
                    even

KSCAN:              movem.l  d0-d7/a0-a6,-(sp)
                    clr.w    (JOYVAL)-VARS(a2)
                    clr.w    (ESCFLG)-VARS(a2)
                    lea      (KBDSTDIO)-VARS(a2),a1
                    move.l   a6,-(sp)
                    movea.l  (4).w,a6
                    jsr      (_LVODoIO,a6)
                    movea.l  (sp)+,a6
                    lea      (KBDMATRIX)-VARS(a2),a0
                    btst     #5,(8,a0)
                    beq.w    NOBRK
                    tst.w    (RSTFLG)-VARS(a2)
                    beq.w    NOBRK
                    jmp      (JUMP_START)-VARS(a2)

NOBRK:              btst     #4,(9,a0)
                    beq.w    KSCK0
                    bset     #0,(JOYVAL)-VARS(a2)
KSCK0:              btst     #5,(9,a0)
                    beq.w    KSCK1
                    bset     #1,(JOYVAL)-VARS(a2)
KSCK1:              btst     #7,(9,a0)
                    beq.w    KSCK2
                    bset     #2,(JOYVAL)-VARS(a2)
KSCK2:              btst     #6,(9,a0)
                    beq.w    KSCK3
                    bset     #3,(JOYVAL)-VARS(a2)
KSCK3:              btst     #0,(8,a0)
                    beq.w    KSCK4
                    bset     #4,(JOYVAL)-VARS(a2)
KSCK4:              btst     #3,(12,a0)
                    beq.w    KSCK5
                    st       (ESCFLG)-VARS(a2)
KSCK5:              btst     #7,($BFE001)
                    bne.w    KSC0
                    bset     #4,(JOYVAL)-VARS(a2)
KSC0:               move.w   ($DFF00C),d0
                    btst     #1,d0
                    beq.w    KSC1
                    bset     #3,(JOYVAL)-VARS(a2)
KSC1:               btst     #9,d0
                    beq.w    KSC2
                    bset     #2,(JOYVAL)-VARS(a2)
KSC2:               btst     #0,d0
                    bne.w    KSC3
                    btst     #1,d0
                    beq.w    KSC4
                    bset     #1,(JOYVAL)-VARS(a2)
                    bra.w    KSC4
KSC3:               btst     #1,d0
                    bne.w    KSC4
                    bset     #1,(JOYVAL)-VARS(a2)
KSC4:               btst     #8,d0
                    bne.w    KSC5
                    btst     #9,d0
                    beq.w    KSC6
                    bset     #0,(JOYVAL)-VARS(a2)
                    bra.w    KSC6
KSC5:               btst     #9,d0
                    bne.w    KSC6
                    bset     #0,(JOYVAL)-VARS(a2)
KSC6:               movem.l  (sp)+,d0-d7/a0-a6
                    rts

JUMP_START:         movem.l  (sp)+,d0-d7/a0-a6
                    bra.w    START0

JPACK:              clr.w    (JYVAL2)-VARS(a2)
                    move.b   (2,a0),d0
                    move.b   d0,(JYVAL2)-VARS(a2)
                    rts

FLYFLAG:            dc.w     0

VERTBSERVER:        move.l   a2,-(sp)
                    lea      VARS(pc),a2
                    addq.w   #1,(INTCTR)-VARS(a2)
                    addq.w   #1,(FLYFLAG)-VARS(a2)
                    addq.w   #1,(FLYCTR)-VARS(a2)
                    addi.l   #$87654321,(SEED)-VARS(a2)
                    move.w   (BORDER)-VARS(a2),($DFF180)
                    move.l   (sp)+,a2
RTS:                rts

; set the color palette of the game itself
SETCOL:             lea      (COLS)-VARS(a2),a1
STCLR:              move.w   d0,-(sp)
                    lea      ($DFF180),a0
                    move.w   (a1)+,d0
                    add.l    d0,d0
                    move.w   d0,(a0)+
                    move.w   (a1)+,d0
                    add.l    d0,d0
                    move.w   d0,(a0)+
                    move.w   (a1)+,d0
                    add.l    d0,d0
                    move.w   d0,(a0)+
                    move.w   (a1)+,d0
                    add.l    d0,d0
                    move.w   d0,(a0)+
                    move.w   (a1)+,d0
                    add.l    d0,d0
                    move.w   d0,(a0)+
                    move.w   (a1)+,d0
                    add.l    d0,d0
                    move.w   d0,(a0)+
                    move.w   (a1)+,d0
                    add.l    d0,d0
                    move.w   d0,(a0)+
                    move.w   (a1)+,d0
                    add.l    d0,d0
                    move.w   d0,(a0)+
                    move.w   (a1)+,d0
                    add.l    d0,d0
                    move.w   d0,(a0)+
                    move.w   (a1)+,d0
                    add.l    d0,d0
                    move.w   d0,(a0)+
                    move.w   (a1)+,d0
                    add.l    d0,d0
                    move.w   d0,(a0)+
                    move.w   (a1)+,d0
                    add.l    d0,d0
                    move.w   d0,(a0)+
                    move.w   (a1)+,d0
                    add.l    d0,d0
                    move.w   d0,(a0)+
                    move.w   (a1)+,d0
                    add.l    d0,d0
                    move.w   d0,(a0)+
                    move.w   (a1)+,d0
                    add.l    d0,d0
                    move.w   d0,(a0)+
                    move.w   (a1)+,d0
                    add.l    d0,d0
                    move.w   d0,(a0)+
                    move.w   (sp)+,d0
                    rts

; set palette to black
BLACK:              lea      (BLKDAT)-VARS(a2),a1
                    bra.w    STCLR

BLKDAT:             dcb.w    16,0

FRAME:              move.w   d0,-(sp)
                    move.w   (FLYFLAG)-VARS(a2),d0
FRAME0:             cmp.w    (FLYFLAG)-VARS(a2),d0
                    beq.w    FRAME0
                    move.w   #4,($DFF09C)
                    move.w   (sp)+,d0
                    rts

CLS:                movea.l  (VIDPTR)-VARS(a2),a0
                    move.w   #192-1,d0
                    moveq.l  #0,d1
CLS1:               move.w   #8-1,d2
CLS1A:              move.l   d1,(a0)
                    move.l   d1,((200*40),a0)
                    move.l   d1,((200*2*40),a0)
                    move.l   d1,((200*3*40),a0)
                    addq.l   #4,a0
                    dbra     d2,CLS1A
                    lea      (8,a0),a0
                    dbra     d0,CLS1
                    movea.l  (VIDPTR)-VARS(a2),a0
                    adda.l   #40-8,a0
                    movea.l  (PANELPTR)-VARS(a2),a1
                    adda.l   #40-8,a1
                    move.w   #200-1,d0
CLS0:               
                    move.w   ((200*3*40),a1),((200*3*40),a0)
                    move.w   ((200*2*40),a1),((200*2*40),a0)
                    move.w   ((200*40),a1),((200*40),a0)
                    move.w   (a1)+,(a0)+
                    move.w   ((200*3*40),a1),((200*3*40),a0)
                    move.w   ((200*2*40),a1),((200*2*40),a0)
                    move.w   ((200*40),a1),((200*40),a0)
                    move.w   (a1)+,(a0)+
                    move.w   ((200*3*40),a1),((200*3*40),a0)
                    move.w   ((200*2*40),a1),((200*2*40),a0)
                    move.w   ((200*40),a1),((200*40),a0)
                    move.w   (a1)+,(a0)+
                    move.w   ((200*3*40),a1),((200*3*40),a0)
                    move.w   ((200*2*40),a1),((200*2*40),a0)
                    move.w   ((200*40),a1),((200*40),a0)
                    move.w   (a1)+,(a0)+
                    lea      (40-8,a0),a0
                    lea      (40-8,a1),a1
                    dbra     d0,CLS0

                    movea.l  (VIDPTR)-VARS(a2),a0
                    adda.l   #(192*40),a0
                    movea.l  (PANELPTR)-VARS(a2),a1
                    adda.l   #(192*40),a1
                    move.w   #8-1,d1
CLS2b:              move.w   #(32/2)-1,d0
CLS2:               move.w   ((200*3*40),a1),((200*3*40),a0)
                    move.w   ((200*2*40),a1),((200*2*40),a0)
                    move.w   ((200*40),a1),((200*40),a0)
                    move.w   (a1)+,(a0)+
                    dbra     d0,CLS2
                    lea      (40-32,a0),a0
                    lea      (40-32,a1),a1
                    dbra     d1,CLS2b
                    rts

PBAK:               move.w   (SCRY)-VARS(a2),d0
                    mulu.w   #96,d0
                    add.w    (SCRX)-VARS(a2),d0
                    ext.l    d0
                    movea.l  (BUFFERPTR)-VARS(a2),a6
                    adda.l   d0,a6
                    movea.l  (CHRSETPTR)-VARS(a2),a3
                    moveq    #24-1,d6
                    movea.l  (VIDPTR)-VARS(a2),a4
PBAK0:              move.b   (a6)+,d0
                    andi.l   #$FF,d0
                    lsl.l    #6,d0
                    movea.l  a3,a5
                    adda.l   d0,a5
                    move.w   (a5)+,(a4)
                    move.w   (a5)+,((200*40),a4)
                    move.w   (a5)+,((200*2*40),a4)
                    move.w   (a5)+,((200*3*40),a4)
                    move.w   (a5)+,(40,a4)
                    move.w   (a5)+,((200*40)+40,a4)
                    move.w   (a5)+,((200*2*40)+40,a4)
                    move.w   (a5)+,((200*3*40)+40,a4)
                    move.w   (a5)+,(80,a4)
                    move.w   (a5)+,((200*40)+80,a4)
                    move.w   (a5)+,((200*2*40)+80,a4)
                    move.w   (a5)+,((200*3*40)+80,a4)
                    move.w   (a5)+,(120,a4)
                    move.w   (a5)+,((200*40)+120,a4)
                    move.w   (a5)+,((200*2*40)+120,a4)
                    move.w   (a5)+,((200*3*40)+120,a4)
                    move.w   (a5)+,(160,a4)
                    move.w   (a5)+,((200*40)+160,a4)
                    move.w   (a5)+,((200*2*40)+160,a4)
                    move.w   (a5)+,((200*3*40)+160,a4)
                    move.w   (a5)+,(200,a4)
                    move.w   (a5)+,((200*40)+200,a4)
                    move.w   (a5)+,((200*2*40)+200,a4)
                    move.w   (a5)+,((200*3*40)+200,a4)
                    move.w   (a5)+,(240,a4)
                    move.w   (a5)+,((200*40)+240,a4)
                    move.w   (a5)+,((200*2*40)+240,a4)
                    move.w   (a5)+,((200*3*40)+240,a4)
                    move.w   (a5)+,(280,a4)
                    move.w   (a5)+,((200*40)+280,a4)
                    move.w   (a5)+,((200*2*40)+280,a4)
                    move.w   (a5)+,((200*3*40)+280,a4)
                    addq.l   #2,a4
                    move.b   (a6)+,d0
                    andi.l   #$FF,d0
                    lsl.l    #6,d0
                    movea.l  a3,a5
                    adda.l   d0,a5
                    move.w   (a5)+,(a4)
                    move.w   (a5)+,((200*40),a4)
                    move.w   (a5)+,((200*2*40),a4)
                    move.w   (a5)+,((200*3*40),a4)
                    move.w   (a5)+,(40,a4)
                    move.w   (a5)+,((200*40)+40,a4)
                    move.w   (a5)+,((200*2*40)+40,a4)
                    move.w   (a5)+,((200*3*40)+40,a4)
                    move.w   (a5)+,(80,a4)
                    move.w   (a5)+,((200*40)+80,a4)
                    move.w   (a5)+,((200*2*40)+80,a4)
                    move.w   (a5)+,((200*3*40)+80,a4)
                    move.w   (a5)+,(120,a4)
                    move.w   (a5)+,((200*40)+120,a4)
                    move.w   (a5)+,((200*2*40)+120,a4)
                    move.w   (a5)+,((200*3*40)+120,a4)
                    move.w   (a5)+,(160,a4)
                    move.w   (a5)+,((200*40)+160,a4)
                    move.w   (a5)+,((200*2*40)+160,a4)
                    move.w   (a5)+,((200*3*40)+160,a4)
                    move.w   (a5)+,(200,a4)
                    move.w   (a5)+,((200*40)+200,a4)
                    move.w   (a5)+,((200*2*40)+200,a4)
                    move.w   (a5)+,((200*3*40)+200,a4)
                    move.w   (a5)+,(240,a4)
                    move.w   (a5)+,((200*40)+240,a4)
                    move.w   (a5)+,((200*2*40)+240,a4)
                    move.w   (a5)+,((200*3*40)+240,a4)
                    move.w   (a5)+,(280,a4)
                    move.w   (a5)+,((200*40)+280,a4)
                    move.w   (a5)+,((200*2*40)+280,a4)
                    move.w   (a5)+,((200*3*40)+280,a4)
                    addq.l   #2,a4
                    move.b   (a6)+,d0
                    andi.l   #$FF,d0
                    lsl.l    #6,d0
                    movea.l  a3,a5
                    adda.l   d0,a5
                    move.w   (a5)+,(a4)
                    move.w   (a5)+,((200*40),a4)
                    move.w   (a5)+,((200*2*40),a4)
                    move.w   (a5)+,((200*3*40),a4)
                    move.w   (a5)+,(40,a4)
                    move.w   (a5)+,((200*40)+40,a4)
                    move.w   (a5)+,((200*2*40)+40,a4)
                    move.w   (a5)+,((200*3*40)+40,a4)
                    move.w   (a5)+,(80,a4)
                    move.w   (a5)+,((200*40)+80,a4)
                    move.w   (a5)+,((200*2*40)+80,a4)
                    move.w   (a5)+,((200*3*40)+80,a4)
                    move.w   (a5)+,(120,a4)
                    move.w   (a5)+,((200*40)+120,a4)
                    move.w   (a5)+,((200*2*40)+120,a4)
                    move.w   (a5)+,((200*3*40)+120,a4)
                    move.w   (a5)+,(160,a4)
                    move.w   (a5)+,((200*40)+160,a4)
                    move.w   (a5)+,((200*2*40)+160,a4)
                    move.w   (a5)+,((200*3*40)+160,a4)
                    move.w   (a5)+,(200,a4)
                    move.w   (a5)+,((200*40)+200,a4)
                    move.w   (a5)+,((200*2*40)+200,a4)
                    move.w   (a5)+,((200*3*40)+200,a4)
                    move.w   (a5)+,(240,a4)
                    move.w   (a5)+,((200*40)+240,a4)
                    move.w   (a5)+,((200*2*40)+240,a4)
                    move.w   (a5)+,((200*3*40)+240,a4)
                    move.w   (a5)+,(280,a4)
                    move.w   (a5)+,((200*40)+280,a4)
                    move.w   (a5)+,((200*2*40)+280,a4)
                    move.w   (a5)+,((200*3*40)+280,a4)
                    addq.l   #2,a4
                    move.b   (a6)+,d0
                    andi.l   #$FF,d0
                    lsl.l    #6,d0
                    movea.l  a3,a5
                    adda.l   d0,a5
                    move.w   (a5)+,(a4)
                    move.w   (a5)+,((200*40),a4)
                    move.w   (a5)+,((200*2*40),a4)
                    move.w   (a5)+,((200*3*40),a4)
                    move.w   (a5)+,(40,a4)
                    move.w   (a5)+,((200*40)+40,a4)
                    move.w   (a5)+,((200*2*40)+40,a4)
                    move.w   (a5)+,((200*3*40)+40,a4)
                    move.w   (a5)+,(80,a4)
                    move.w   (a5)+,((200*40)+80,a4)
                    move.w   (a5)+,((200*2*40)+80,a4)
                    move.w   (a5)+,((200*3*40)+80,a4)
                    move.w   (a5)+,(120,a4)
                    move.w   (a5)+,((200*40)+120,a4)
                    move.w   (a5)+,((200*2*40)+120,a4)
                    move.w   (a5)+,((200*3*40)+120,a4)
                    move.w   (a5)+,(160,a4)
                    move.w   (a5)+,((200*40)+160,a4)
                    move.w   (a5)+,((200*2*40)+160,a4)
                    move.w   (a5)+,((200*3*40)+160,a4)
                    move.w   (a5)+,(200,a4)
                    move.w   (a5)+,((200*40)+200,a4)
                    move.w   (a5)+,((200*2*40)+200,a4)
                    move.w   (a5)+,((200*3*40)+200,a4)
                    move.w   (a5)+,(240,a4)
                    move.w   (a5)+,((200*40)+240,a4)
                    move.w   (a5)+,((200*2*40)+240,a4)
                    move.w   (a5)+,((200*3*40)+240,a4)
                    move.w   (a5)+,(280,a4)
                    move.w   (a5)+,((200*40)+280,a4)
                    move.w   (a5)+,((200*2*40)+280,a4)
                    move.w   (a5)+,((200*3*40)+280,a4)
                    addq.l   #2,a4
                    move.b   (a6)+,d0
                    andi.l   #$FF,d0
                    lsl.l    #6,d0
                    movea.l  a3,a5
                    adda.l   d0,a5
                    move.w   (a5)+,(a4)
                    move.w   (a5)+,((200*40),a4)
                    move.w   (a5)+,((200*2*40),a4)
                    move.w   (a5)+,((200*3*40),a4)
                    move.w   (a5)+,(40,a4)
                    move.w   (a5)+,((200*40)+40,a4)
                    move.w   (a5)+,((200*2*40)+40,a4)
                    move.w   (a5)+,((200*3*40)+40,a4)
                    move.w   (a5)+,(80,a4)
                    move.w   (a5)+,((200*40)+80,a4)
                    move.w   (a5)+,((200*2*40)+80,a4)
                    move.w   (a5)+,((200*3*40)+80,a4)
                    move.w   (a5)+,(120,a4)
                    move.w   (a5)+,((200*40)+120,a4)
                    move.w   (a5)+,((200*2*40)+120,a4)
                    move.w   (a5)+,((200*3*40)+120,a4)
                    move.w   (a5)+,(160,a4)
                    move.w   (a5)+,((200*40)+160,a4)
                    move.w   (a5)+,((200*2*40)+160,a4)
                    move.w   (a5)+,((200*3*40)+160,a4)
                    move.w   (a5)+,(200,a4)
                    move.w   (a5)+,((200*40)+200,a4)
                    move.w   (a5)+,((200*2*40)+200,a4)
                    move.w   (a5)+,((200*3*40)+200,a4)
                    move.w   (a5)+,(240,a4)
                    move.w   (a5)+,((200*40)+240,a4)
                    move.w   (a5)+,((200*2*40)+240,a4)
                    move.w   (a5)+,((200*3*40)+240,a4)
                    move.w   (a5)+,(280,a4)
                    move.w   (a5)+,((200*40)+280,a4)
                    move.w   (a5)+,((200*2*40)+280,a4)
                    move.w   (a5)+,((200*3*40)+280,a4)
                    addq.l   #2,a4
                    move.b   (a6)+,d0
                    andi.l   #$FF,d0
                    lsl.l    #6,d0
                    movea.l  a3,a5
                    adda.l   d0,a5
                    move.w   (a5)+,(a4)
                    move.w   (a5)+,((200*40),a4)
                    move.w   (a5)+,((200*2*40),a4)
                    move.w   (a5)+,((200*3*40),a4)
                    move.w   (a5)+,(40,a4)
                    move.w   (a5)+,((200*40)+40,a4)
                    move.w   (a5)+,((200*2*40)+40,a4)
                    move.w   (a5)+,((200*3*40)+40,a4)
                    move.w   (a5)+,(80,a4)
                    move.w   (a5)+,((200*40)+80,a4)
                    move.w   (a5)+,((200*2*40)+80,a4)
                    move.w   (a5)+,((200*3*40)+80,a4)
                    move.w   (a5)+,(120,a4)
                    move.w   (a5)+,((200*40)+120,a4)
                    move.w   (a5)+,((200*2*40)+120,a4)
                    move.w   (a5)+,((200*3*40)+120,a4)
                    move.w   (a5)+,(160,a4)
                    move.w   (a5)+,((200*40)+160,a4)
                    move.w   (a5)+,((200*2*40)+160,a4)
                    move.w   (a5)+,((200*3*40)+160,a4)
                    move.w   (a5)+,(200,a4)
                    move.w   (a5)+,((200*40)+200,a4)
                    move.w   (a5)+,((200*2*40)+200,a4)
                    move.w   (a5)+,((200*3*40)+200,a4)
                    move.w   (a5)+,(240,a4)
                    move.w   (a5)+,((200*40)+240,a4)
                    move.w   (a5)+,((200*2*40)+240,a4)
                    move.w   (a5)+,((200*3*40)+240,a4)
                    move.w   (a5)+,(280,a4)
                    move.w   (a5)+,((200*40)+280,a4)
                    move.w   (a5)+,((200*2*40)+280,a4)
                    move.w   (a5)+,((200*3*40)+280,a4)
                    addq.l   #2,a4
                    move.b   (a6)+,d0
                    andi.l   #$FF,d0
                    lsl.l    #6,d0
                    movea.l  a3,a5
                    adda.l   d0,a5
                    move.w   (a5)+,(a4)
                    move.w   (a5)+,((200*40),a4)
                    move.w   (a5)+,((200*2*40),a4)
                    move.w   (a5)+,((200*3*40),a4)
                    move.w   (a5)+,(40,a4)
                    move.w   (a5)+,((200*40)+40,a4)
                    move.w   (a5)+,((200*2*40)+40,a4)
                    move.w   (a5)+,((200*3*40)+40,a4)
                    move.w   (a5)+,(80,a4)
                    move.w   (a5)+,((200*40)+80,a4)
                    move.w   (a5)+,((200*2*40)+80,a4)
                    move.w   (a5)+,((200*3*40)+80,a4)
                    move.w   (a5)+,(120,a4)
                    move.w   (a5)+,((200*40)+120,a4)
                    move.w   (a5)+,((200*2*40)+120,a4)
                    move.w   (a5)+,((200*3*40)+120,a4)
                    move.w   (a5)+,(160,a4)
                    move.w   (a5)+,((200*40)+160,a4)
                    move.w   (a5)+,((200*2*40)+160,a4)
                    move.w   (a5)+,((200*3*40)+160,a4)
                    move.w   (a5)+,(200,a4)
                    move.w   (a5)+,((200*40)+200,a4)
                    move.w   (a5)+,((200*2*40)+200,a4)
                    move.w   (a5)+,((200*3*40)+200,a4)
                    move.w   (a5)+,(240,a4)
                    move.w   (a5)+,((200*40)+240,a4)
                    move.w   (a5)+,((200*2*40)+240,a4)
                    move.w   (a5)+,((200*3*40)+240,a4)
                    move.w   (a5)+,(280,a4)
                    move.w   (a5)+,((200*40)+280,a4)
                    move.w   (a5)+,((200*2*40)+280,a4)
                    move.w   (a5)+,((200*3*40)+280,a4)
                    addq.l   #2,a4
                    move.b   (a6)+,d0
                    andi.l   #$FF,d0
                    lsl.l    #6,d0
                    movea.l  a3,a5
                    adda.l   d0,a5
                    move.w   (a5)+,(a4)
                    move.w   (a5)+,((200*40),a4)
                    move.w   (a5)+,((200*2*40),a4)
                    move.w   (a5)+,((200*3*40),a4)
                    move.w   (a5)+,(40,a4)
                    move.w   (a5)+,((200*40)+40,a4)
                    move.w   (a5)+,((200*2*40)+40,a4)
                    move.w   (a5)+,((200*3*40)+40,a4)
                    move.w   (a5)+,(80,a4)
                    move.w   (a5)+,((200*40)+80,a4)
                    move.w   (a5)+,((200*2*40)+80,a4)
                    move.w   (a5)+,((200*3*40)+80,a4)
                    move.w   (a5)+,(120,a4)
                    move.w   (a5)+,((200*40)+120,a4)
                    move.w   (a5)+,((200*2*40)+120,a4)
                    move.w   (a5)+,((200*3*40)+120,a4)
                    move.w   (a5)+,(160,a4)
                    move.w   (a5)+,((200*40)+160,a4)
                    move.w   (a5)+,((200*2*40)+160,a4)
                    move.w   (a5)+,((200*3*40)+160,a4)
                    move.w   (a5)+,(200,a4)
                    move.w   (a5)+,((200*40)+200,a4)
                    move.w   (a5)+,((200*2*40)+200,a4)
                    move.w   (a5)+,((200*3*40)+200,a4)
                    move.w   (a5)+,(240,a4)
                    move.w   (a5)+,((200*40)+240,a4)
                    move.w   (a5)+,((200*2*40)+240,a4)
                    move.w   (a5)+,((200*3*40)+240,a4)
                    move.w   (a5)+,(280,a4)
                    move.w   (a5)+,((200*40)+280,a4)
                    move.w   (a5)+,((200*2*40)+280,a4)
                    move.w   (a5)+,((200*3*40)+280,a4)
                    addq.l   #2,a4
                    move.b   (a6)+,d0
                    andi.l   #$FF,d0
                    lsl.l    #6,d0
                    movea.l  a3,a5
                    adda.l   d0,a5
                    move.w   (a5)+,(a4)
                    move.w   (a5)+,((200*40),a4)
                    move.w   (a5)+,((200*2*40),a4)
                    move.w   (a5)+,((200*3*40),a4)
                    move.w   (a5)+,(40,a4)
                    move.w   (a5)+,((200*40)+40,a4)
                    move.w   (a5)+,((200*2*40)+40,a4)
                    move.w   (a5)+,((200*3*40)+40,a4)
                    move.w   (a5)+,(80,a4)
                    move.w   (a5)+,((200*40)+80,a4)
                    move.w   (a5)+,((200*2*40)+80,a4)
                    move.w   (a5)+,((200*3*40)+80,a4)
                    move.w   (a5)+,(120,a4)
                    move.w   (a5)+,((200*40)+120,a4)
                    move.w   (a5)+,((200*2*40)+120,a4)
                    move.w   (a5)+,((200*3*40)+120,a4)
                    move.w   (a5)+,(160,a4)
                    move.w   (a5)+,((200*40)+160,a4)
                    move.w   (a5)+,((200*2*40)+160,a4)
                    move.w   (a5)+,((200*3*40)+160,a4)
                    move.w   (a5)+,(200,a4)
                    move.w   (a5)+,((200*40)+200,a4)
                    move.w   (a5)+,((200*2*40)+200,a4)
                    move.w   (a5)+,((200*3*40)+200,a4)
                    move.w   (a5)+,(240,a4)
                    move.w   (a5)+,((200*40)+240,a4)
                    move.w   (a5)+,((200*2*40)+240,a4)
                    move.w   (a5)+,((200*3*40)+240,a4)
                    move.w   (a5)+,(280,a4)
                    move.w   (a5)+,((200*40)+280,a4)
                    move.w   (a5)+,((200*2*40)+280,a4)
                    move.w   (a5)+,((200*3*40)+280,a4)
                    addq.l   #2,a4
                    move.b   (a6)+,d0
                    andi.l   #$FF,d0
                    lsl.l    #6,d0
                    movea.l  a3,a5
                    adda.l   d0,a5
                    move.w   (a5)+,(a4)
                    move.w   (a5)+,((200*40),a4)
                    move.w   (a5)+,((200*2*40),a4)
                    move.w   (a5)+,((200*3*40),a4)
                    move.w   (a5)+,(40,a4)
                    move.w   (a5)+,((200*40)+40,a4)
                    move.w   (a5)+,((200*2*40)+40,a4)
                    move.w   (a5)+,((200*3*40)+40,a4)
                    move.w   (a5)+,(80,a4)
                    move.w   (a5)+,((200*40)+80,a4)
                    move.w   (a5)+,((200*2*40)+80,a4)
                    move.w   (a5)+,((200*3*40)+80,a4)
                    move.w   (a5)+,(120,a4)
                    move.w   (a5)+,((200*40)+120,a4)
                    move.w   (a5)+,((200*2*40)+120,a4)
                    move.w   (a5)+,((200*3*40)+120,a4)
                    move.w   (a5)+,(160,a4)
                    move.w   (a5)+,((200*40)+160,a4)
                    move.w   (a5)+,((200*2*40)+160,a4)
                    move.w   (a5)+,((200*3*40)+160,a4)
                    move.w   (a5)+,(200,a4)
                    move.w   (a5)+,((200*40)+200,a4)
                    move.w   (a5)+,((200*2*40)+200,a4)
                    move.w   (a5)+,((200*3*40)+200,a4)
                    move.w   (a5)+,(240,a4)
                    move.w   (a5)+,((200*40)+240,a4)
                    move.w   (a5)+,((200*2*40)+240,a4)
                    move.w   (a5)+,((200*3*40)+240,a4)
                    move.w   (a5)+,(280,a4)
                    move.w   (a5)+,((200*40)+280,a4)
                    move.w   (a5)+,((200*2*40)+280,a4)
                    move.w   (a5)+,((200*3*40)+280,a4)
                    addq.l   #2,a4
                    move.b   (a6)+,d0
                    andi.l   #$FF,d0
                    lsl.l    #6,d0
                    movea.l  a3,a5
                    adda.l   d0,a5
                    move.w   (a5)+,(a4)
                    move.w   (a5)+,((200*40),a4)
                    move.w   (a5)+,((200*2*40),a4)
                    move.w   (a5)+,((200*3*40),a4)
                    move.w   (a5)+,(40,a4)
                    move.w   (a5)+,((200*40)+40,a4)
                    move.w   (a5)+,((200*2*40)+40,a4)
                    move.w   (a5)+,((200*3*40)+40,a4)
                    move.w   (a5)+,(80,a4)
                    move.w   (a5)+,((200*40)+80,a4)
                    move.w   (a5)+,((200*2*40)+80,a4)
                    move.w   (a5)+,((200*3*40)+80,a4)
                    move.w   (a5)+,(120,a4)
                    move.w   (a5)+,((200*40)+120,a4)
                    move.w   (a5)+,((200*2*40)+120,a4)
                    move.w   (a5)+,((200*3*40)+120,a4)
                    move.w   (a5)+,(160,a4)
                    move.w   (a5)+,((200*40)+160,a4)
                    move.w   (a5)+,((200*2*40)+160,a4)
                    move.w   (a5)+,((200*3*40)+160,a4)
                    move.w   (a5)+,(200,a4)
                    move.w   (a5)+,((200*40)+200,a4)
                    move.w   (a5)+,((200*2*40)+200,a4)
                    move.w   (a5)+,((200*3*40)+200,a4)
                    move.w   (a5)+,(240,a4)
                    move.w   (a5)+,((200*40)+240,a4)
                    move.w   (a5)+,((200*2*40)+240,a4)
                    move.w   (a5)+,((200*3*40)+240,a4)
                    move.w   (a5)+,(280,a4)
                    move.w   (a5)+,((200*40)+280,a4)
                    move.w   (a5)+,((200*2*40)+280,a4)
                    move.w   (a5)+,((200*3*40)+280,a4)
                    addq.l   #2,a4
                    move.b   (a6)+,d0
                    andi.l   #$FF,d0
                    lsl.l    #6,d0
                    movea.l  a3,a5
                    adda.l   d0,a5
                    move.w   (a5)+,(a4)
                    move.w   (a5)+,((200*40),a4)
                    move.w   (a5)+,((200*2*40),a4)
                    move.w   (a5)+,((200*3*40),a4)
                    move.w   (a5)+,(40,a4)
                    move.w   (a5)+,((200*40)+40,a4)
                    move.w   (a5)+,((200*2*40)+40,a4)
                    move.w   (a5)+,((200*3*40)+40,a4)
                    move.w   (a5)+,(80,a4)
                    move.w   (a5)+,((200*40)+80,a4)
                    move.w   (a5)+,((200*2*40)+80,a4)
                    move.w   (a5)+,((200*3*40)+80,a4)
                    move.w   (a5)+,(120,a4)
                    move.w   (a5)+,((200*40)+120,a4)
                    move.w   (a5)+,((200*2*40)+120,a4)
                    move.w   (a5)+,((200*3*40)+120,a4)
                    move.w   (a5)+,(160,a4)
                    move.w   (a5)+,((200*40)+160,a4)
                    move.w   (a5)+,((200*2*40)+160,a4)
                    move.w   (a5)+,((200*3*40)+160,a4)
                    move.w   (a5)+,(200,a4)
                    move.w   (a5)+,((200*40)+200,a4)
                    move.w   (a5)+,((200*2*40)+200,a4)
                    move.w   (a5)+,((200*3*40)+200,a4)
                    move.w   (a5)+,(240,a4)
                    move.w   (a5)+,((200*40)+240,a4)
                    move.w   (a5)+,((200*2*40)+240,a4)
                    move.w   (a5)+,((200*3*40)+240,a4)
                    move.w   (a5)+,(280,a4)
                    move.w   (a5)+,((200*40)+280,a4)
                    move.w   (a5)+,((200*2*40)+280,a4)
                    move.w   (a5)+,((200*3*40)+280,a4)
                    addq.l   #2,a4
                    move.b   (a6)+,d0
                    andi.l   #$FF,d0
                    lsl.l    #6,d0
                    movea.l  a3,a5
                    adda.l   d0,a5
                    move.w   (a5)+,(a4)
                    move.w   (a5)+,((200*40),a4)
                    move.w   (a5)+,((200*2*40),a4)
                    move.w   (a5)+,((200*3*40),a4)
                    move.w   (a5)+,(40,a4)
                    move.w   (a5)+,((200*40)+40,a4)
                    move.w   (a5)+,((200*2*40)+40,a4)
                    move.w   (a5)+,((200*3*40)+40,a4)
                    move.w   (a5)+,(80,a4)
                    move.w   (a5)+,((200*40)+80,a4)
                    move.w   (a5)+,((200*2*40)+80,a4)
                    move.w   (a5)+,((200*3*40)+80,a4)
                    move.w   (a5)+,(120,a4)
                    move.w   (a5)+,((200*40)+120,a4)
                    move.w   (a5)+,((200*2*40)+120,a4)
                    move.w   (a5)+,((200*3*40)+120,a4)
                    move.w   (a5)+,(160,a4)
                    move.w   (a5)+,((200*40)+160,a4)
                    move.w   (a5)+,((200*2*40)+160,a4)
                    move.w   (a5)+,((200*3*40)+160,a4)
                    move.w   (a5)+,(200,a4)
                    move.w   (a5)+,((200*40)+200,a4)
                    move.w   (a5)+,((200*2*40)+200,a4)
                    move.w   (a5)+,((200*3*40)+200,a4)
                    move.w   (a5)+,(240,a4)
                    move.w   (a5)+,((200*40)+240,a4)
                    move.w   (a5)+,((200*2*40)+240,a4)
                    move.w   (a5)+,((200*3*40)+240,a4)
                    move.w   (a5)+,(280,a4)
                    move.w   (a5)+,((200*40)+280,a4)
                    move.w   (a5)+,((200*2*40)+280,a4)
                    move.w   (a5)+,((200*3*40)+280,a4)
                    addq.l   #2,a4
                    move.b   (a6)+,d0
                    andi.l   #$FF,d0
                    lsl.l    #6,d0
                    movea.l  a3,a5
                    adda.l   d0,a5
                    move.w   (a5)+,(a4)
                    move.w   (a5)+,((200*40),a4)
                    move.w   (a5)+,((200*2*40),a4)
                    move.w   (a5)+,((200*3*40),a4)
                    move.w   (a5)+,(40,a4)
                    move.w   (a5)+,((200*40)+40,a4)
                    move.w   (a5)+,((200*2*40)+40,a4)
                    move.w   (a5)+,((200*3*40)+40,a4)
                    move.w   (a5)+,(80,a4)
                    move.w   (a5)+,((200*40)+80,a4)
                    move.w   (a5)+,((200*2*40)+80,a4)
                    move.w   (a5)+,((200*3*40)+80,a4)
                    move.w   (a5)+,(120,a4)
                    move.w   (a5)+,((200*40)+120,a4)
                    move.w   (a5)+,((200*2*40)+120,a4)
                    move.w   (a5)+,((200*3*40)+120,a4)
                    move.w   (a5)+,(160,a4)
                    move.w   (a5)+,((200*40)+160,a4)
                    move.w   (a5)+,((200*2*40)+160,a4)
                    move.w   (a5)+,((200*3*40)+160,a4)
                    move.w   (a5)+,(200,a4)
                    move.w   (a5)+,((200*40)+200,a4)
                    move.w   (a5)+,((200*2*40)+200,a4)
                    move.w   (a5)+,((200*3*40)+200,a4)
                    move.w   (a5)+,(240,a4)
                    move.w   (a5)+,((200*40)+240,a4)
                    move.w   (a5)+,((200*2*40)+240,a4)
                    move.w   (a5)+,((200*3*40)+240,a4)
                    move.w   (a5)+,(280,a4)
                    move.w   (a5)+,((200*40)+280,a4)
                    move.w   (a5)+,((200*2*40)+280,a4)
                    move.w   (a5)+,((200*3*40)+280,a4)
                    addq.l   #2,a4
                    move.b   (a6)+,d0
                    andi.l   #$FF,d0
                    lsl.l    #6,d0
                    movea.l  a3,a5
                    adda.l   d0,a5
                    move.w   (a5)+,(a4)
                    move.w   (a5)+,((200*40),a4)
                    move.w   (a5)+,((200*2*40),a4)
                    move.w   (a5)+,((200*3*40),a4)
                    move.w   (a5)+,(40,a4)
                    move.w   (a5)+,((200*40)+40,a4)
                    move.w   (a5)+,((200*2*40)+40,a4)
                    move.w   (a5)+,((200*3*40)+40,a4)
                    move.w   (a5)+,(80,a4)
                    move.w   (a5)+,((200*40)+80,a4)
                    move.w   (a5)+,((200*2*40)+80,a4)
                    move.w   (a5)+,((200*3*40)+80,a4)
                    move.w   (a5)+,(120,a4)
                    move.w   (a5)+,((200*40)+120,a4)
                    move.w   (a5)+,((200*2*40)+120,a4)
                    move.w   (a5)+,((200*3*40)+120,a4)
                    move.w   (a5)+,(160,a4)
                    move.w   (a5)+,((200*40)+160,a4)
                    move.w   (a5)+,((200*2*40)+160,a4)
                    move.w   (a5)+,((200*3*40)+160,a4)
                    move.w   (a5)+,(200,a4)
                    move.w   (a5)+,((200*40)+200,a4)
                    move.w   (a5)+,((200*2*40)+200,a4)
                    move.w   (a5)+,((200*3*40)+200,a4)
                    move.w   (a5)+,(240,a4)
                    move.w   (a5)+,((200*40)+240,a4)
                    move.w   (a5)+,((200*2*40)+240,a4)
                    move.w   (a5)+,((200*3*40)+240,a4)
                    move.w   (a5)+,(280,a4)
                    move.w   (a5)+,((200*40)+280,a4)
                    move.w   (a5)+,((200*2*40)+280,a4)
                    move.w   (a5)+,((200*3*40)+280,a4)
                    addq.l   #2,a4
                    move.b   (a6)+,d0
                    andi.l   #$FF,d0
                    lsl.l    #6,d0
                    movea.l  a3,a5
                    adda.l   d0,a5
                    move.w   (a5)+,(a4)
                    move.w   (a5)+,((200*40),a4)
                    move.w   (a5)+,((200*2*40),a4)
                    move.w   (a5)+,((200*3*40),a4)
                    move.w   (a5)+,(40,a4)
                    move.w   (a5)+,((200*40)+40,a4)
                    move.w   (a5)+,((200*2*40)+40,a4)
                    move.w   (a5)+,((200*3*40)+40,a4)
                    move.w   (a5)+,(80,a4)
                    move.w   (a5)+,((200*40)+80,a4)
                    move.w   (a5)+,((200*2*40)+80,a4)
                    move.w   (a5)+,((200*3*40)+80,a4)
                    move.w   (a5)+,(120,a4)
                    move.w   (a5)+,((200*40)+120,a4)
                    move.w   (a5)+,((200*2*40)+120,a4)
                    move.w   (a5)+,((200*3*40)+120,a4)
                    move.w   (a5)+,(160,a4)
                    move.w   (a5)+,((200*40)+160,a4)
                    move.w   (a5)+,((200*2*40)+160,a4)
                    move.w   (a5)+,((200*3*40)+160,a4)
                    move.w   (a5)+,(200,a4)
                    move.w   (a5)+,((200*40)+200,a4)
                    move.w   (a5)+,((200*2*40)+200,a4)
                    move.w   (a5)+,((200*3*40)+200,a4)
                    move.w   (a5)+,(240,a4)
                    move.w   (a5)+,((200*40)+240,a4)
                    move.w   (a5)+,((200*2*40)+240,a4)
                    move.w   (a5)+,((200*3*40)+240,a4)
                    move.w   (a5)+,(280,a4)
                    move.w   (a5)+,((200*40)+280,a4)
                    move.w   (a5)+,((200*2*40)+280,a4)
                    move.w   (a5)+,((200*3*40)+280,a4)
                    lea      (290,a4),a4
                    lea      (80,a6),a6
                    dbra     d6,PBAK0
                    rts

PCHRMP:             move.l   a4,-(sp)
                    move.l   a5,-(sp)
                    move.w   d4,-(sp)
                    move.w   d5,-(sp)
                    andi.l   #$FF,d0
                    lsl.l    #6,d0
                    movea.l  (CHRSETPTR)-VARS(a2),a5
                    adda.l   d0,a5
                    andi.l   #$FF,d4
                    andi.l   #$FF,d5
                    movea.l  (VIDPTR)-VARS(a2),a4
                    add.l    d4,d4
                    mulu.w   #(8*40),d5
                    adda.l   d4,a4
                    adda.l   d5,a4
                    move.w   (a5)+,(a4)
                    move.w   (a5)+,((200*40),a4)
                    move.w   (a5)+,((200*2*40),a4)
                    move.w   (a5)+,((200*3*40),a4)
                    move.w   (a5)+,(40,a4)
                    move.w   (a5)+,((200*40)+40,a4)
                    move.w   (a5)+,((200*2*40)+40,a4)
                    move.w   (a5)+,((200*3*40)+40,a4)
                    move.w   (a5)+,(80,a4)
                    move.w   (a5)+,((200*40)+80,a4)
                    move.w   (a5)+,((200*2*40)+80,a4)
                    move.w   (a5)+,((200*3*40)+80,a4)
                    move.w   (a5)+,(120,a4)
                    move.w   (a5)+,((200*40)+120,a4)
                    move.w   (a5)+,((200*2*40)+120,a4)
                    move.w   (a5)+,((200*3*40)+120,a4)
                    move.w   (a5)+,(160,a4)
                    move.w   (a5)+,((200*40)+160,a4)
                    move.w   (a5)+,((200*2*40)+160,a4)
                    move.w   (a5)+,((200*3*40)+160,a4)
                    move.w   (a5)+,(200,a4)
                    move.w   (a5)+,((200*40)+200,a4)
                    move.w   (a5)+,((200*2*40)+200,a4)
                    move.w   (a5)+,((200*3*40)+200,a4)
                    move.w   (a5)+,(240,a4)
                    move.w   (a5)+,((200*40)+240,a4)
                    move.w   (a5)+,((200*2*40)+240,a4)
                    move.w   (a5)+,((200*3*40)+240,a4)
                    move.w   (a5)+,(280,a4)
                    move.w   (a5)+,((200*40)+280,a4)
                    move.w   (a5)+,((200*2*40)+280,a4)
                    move.w   (a5)+,((200*3*40)+280,a4)
                    move.w   (sp)+,d5
                    move.w   (sp)+,d4
                    movea.l  (sp)+,a5
                    movea.l  (sp)+,a4
                    rts

RPSCR:              move.b   (SCORE+1)-VARS(a2),d0
                    moveq    #5,d4
                    moveq    #24,d5
                    bsr.w    WPHEXB
                    move.b   (SCORE+2)-VARS(a2),d0
                    moveq    #7,d4
                    moveq    #24,d5
                    bsr.w    WPHEXB
                    move.b   (SCORE+3)-VARS(a2),d0
                    moveq    #9,d4
                    moveq    #24,d5
                    bsr.w    WPHEXB
                    move.w   (HITS)-VARS(a2),d0
                    moveq    #17,d4
                    moveq    #3,d5
                    bsr.w    WPHEXB
                    move.w   (BULLS)-VARS(a2),d0
                    moveq    #17,d4
                    moveq    #6,d5
                    bsr.w    WPHEXB
                    move.w   (KEYS)-VARS(a2),d0
                    moveq    #17,d4
                    moveq    #9,d5
                    bra.w    WPHEXB

CLCMAP:             move.w   d1,-(sp)
                    andi.l   #$FF,d0
                    andi.l   #$FF,d1
                    mulu.w   #96,d1
                    add.w    d0,d1
                    movea.l  (BUFFERPTR)-VARS(a2),a0
                    adda.l   d1,a0
                    move.w   (sp)+,d1
                    rts

MAKEMP:             clr.w    (NMEMAX)-VARS(a2)
                    movea.l  (NMELSTPTR)-VARS(a2),a3
                    move.l   #-1,(a3)
                    move.w   (LEVEL)-VARS(a2),d0
                    mulu.w   #1024,d0
                    andi.l   #$FFFF,d0
                    movea.l  (MAPSPTR)-VARS(a2),a6
                    andi.w   #1,(LOADED)-VARS(a2)
                    beq.w    MAKEM99
                    addi.l   #4096,d0                           ; map 2
MAKEM99:            adda.l   d0,a6
                    movea.l  (BUFFERPTR)-VARS(a2),a5
                    move.w   #42-1,d6
                    moveq    #0,d3
MAKEM0:             moveq    #24-1,d5
                    moveq    #0,d2
MAKEM1:             move.b   (a6)+,d0
                    andi.l   #$FF,d0
                    cmp.w    #$FF,d0
                    beq.w    ADDNME
MAKEM2:             addq.l   #4,d2
                    lsl.l    #4,d0
                    movea.l  (BLOCKPTR)-VARS(a2),a4
                    adda.l   d0,a4
                    move.l   (a4)+,(a5)
                    move.l   (a4)+,(96,a5)
                    move.l   (a4)+,(192,a5)
                    move.l   (a4)+,(288,a5)
                    addq.l   #4,a5
                    dbra     d5,MAKEM1
                    addq.l   #4,d3
                    lea      (288,a5),a5
                    dbra     d6,MAKEM0
                    bsr.w    INTNME
                    bra.w    PUTOBJ

ADDNME:             move.b   d2,(a3)
                    move.b   d3,(1,a3)
                    bsr.w    RND
                    ori.w    #$E0,d0
                    move.b   d0,(3,a3)
                    bsr.w    RND
                    andi.w   #7,d0
                    move.b   d0,(2,a3)
                    lea      (4,a3),a3
                    move.l   #-1,(a3)
                    addq.w   #1,(NMEMAX)-VARS(a2)
                    moveq    #0,d0
                    bra.w    MAKEM2

WAIT:               move.w   d6,-(sp)
                    moveq    #90-1,d6
WAIT0:              bsr.w    FRAME
                    dbra     d6,WAIT0
                    move.w   (sp)+,d6
                    rts

DETTBL:             dc.b     $35,$62
lbB002658:          dc.b     0,5,10
lbB00265B:          dc.b     0,$15,$36
lbB00265E:          dc.b     0,$41,$8A
lbB002661:          dc.b     0
DETTBL2:            dc.b     $59,$52
lbB002664:          dc.b     0,5,$2E
lbB002667:          dc.b     0,9,$36
lbB00266A:          dc.b     0,$55,$3A
lbB00266D:          dc.b     0

LOOP:               bsr.w    KSCAN
                    tst.w    (XLEVEL)-VARS(a2)
                    bne.w    S19
                    cmpi.w   #$51,(HITS)-VARS(a2)
                    bcc.w    DEAD
                    cmpi.w   #$A2,(YOUY)-VARS(a2)
                    bcs.w    LOOP9
                    bsr.w    COMPIT
LOOP9:              move.w   (LPCTR)-VARS(a2),d0
                    move.w   #2,(LPCTR)-VARS(a2)
LOOP0:              cmp.w    (FLYCTR)-VARS(a2),d0
                    bcc.w    LOOP0
                    clr.w    (FLYCTR)-VARS(a2)
                    tst.w    (ESCFLG)-VARS(a2)
                    beq.w    B010
                    bsr.w    PAUSE
B010:               bsr.w    PBAK
                    bsr.w    RPSCR
                    bsr.w    NME
                    bsr.w    DOBULL
                    bsr.w    DOBULL
                    bsr.w    DODIE
                    bsr.w    BORN
                    bsr.w    GIBILL
                    move.w   (YOUX)-VARS(a2),(YOLDX)-VARS(a2)
                    move.w   (YOUY)-VARS(a2),(YOLDY)-VARS(a2)
                    btst     #4,(JOYVAL)-VARS(a2)
                    bne.w    YFIRE
                    move.w   (FIREFL)-VARS(a2),d0
                    clr.w    (FIREFL)-VARS(a2)
                    tst.w    d0
                    bne.w    B02
                    clr.w    (FIREFL)-VARS(a2)
                    bra.w    LOOP3

B02:                clr.w    (FIREFL)-VARS(a2)
                    tst.w    (BULLS)-VARS(a2)
                    beq.w    LOOP3
                    move.w   (YOLDFR)-VARS(a2),(YFRAME)-VARS(a2)
LOOP2:              move.w   (YOLDX)-VARS(a2),d0
                    move.w   (YOLDY)-VARS(a2),d1
                    bsr.w    EBLOCK
                    bsr.w    CYOU
                    beq.w    LOOP4
                    clr.w    (WLKSFX)-VARS(a2)
                    move.w   (YOLDX)-VARS(a2),(YOUX)-VARS(a2)
                    move.w   (YOLDY)-VARS(a2),(YOUY)-VARS(a2)
LOOP4:              bsr.w    PYOU
                    move.w   (WLKSFX)-VARS(a2),d0
                    clr.w    (WLKSFX)-VARS(a2)
                    tst.w    d0
                    beq.w    LOOP
                    tst.w    (SFX)-VARS(a2)
                    bne.w    LOOP
                    move.w   d0,(SFX)-VARS(a2)
                    bra.w    LOOP

LOOP3:              tst.w    (YDLY)-VARS(a2)
                    bne.w    LOOP5
                    bsr.w    MOVEY
                    bra.w    LOOP2

LOOP5:              subq.w   #1,(YDLY)-VARS(a2)
                    bra.w    LOOP2

MOVEY:              btst     #1,(JOYVAL)-VARS(a2)
                    bne.w    YDOWN
                    btst     #2,(JOYVAL)-VARS(a2)
                    bne.w    YLEFT
                    btst     #3,(JOYVAL)-VARS(a2)
                    bne.w    YRIGHT
                    btst     #0,(JOYVAL)-VARS(a2)
                    beq.w    RTS
YUP:                subq.w   #1,(YOUY)-VARS(a2)
                    move.w   (SCRY)-VARS(a2),d0
                    addq.w   #4,d0
                    cmp.w    (YOUY)-VARS(a2),d0
                    blt.w    YUP0
                    moveq    #12-1,d4
SCRLU0:             tst.w    (SCRY)-VARS(a2)
                    beq.w    YUP0
                    subq.w   #1,(SCRY)-VARS(a2)
                    bsr.w    FRAME
                    move.w   d4,-(sp)
                    bsr.w    PBAK
                    move.w   (sp)+,d4
                    dbra     d4,SCRLU0
YUP0:               moveq    #2,d2
                    bra.w    YANIM

YDOWN:              cmpi.w   #$A5,(YOUY)-VARS(a2)
                    beq.w    RTS
                    addq.w   #1,(YOUY)-VARS(a2)
                    move.w   (SCRY)-VARS(a2),d0
                    addi.w   #15,d0
                    cmp.w    (YOUY)-VARS(a2),d0
                    bgt.w    YDOWN0
                    moveq    #12-1,d4
SCRLD0:             cmpi.w   #$90,(SCRY)-VARS(a2)
                    beq.w    YDOWN0
                    addq.w   #1,(SCRY)-VARS(a2)
                    bsr.w    FRAME
                    move.w   d4,-(sp)
                    bsr.w    PBAK
                    move.w   (sp)+,d4
                    dbra     d4,SCRLD0
YDOWN0:             moveq    #0,d2
                    bra.w    YANIM

YLEFT:              subq.w   #1,(YOUX)-VARS(a2)
                    move.w   (SCRX)-VARS(a2),d0
                    addq.w   #2,d0
                    cmp.w    (YOUX)-VARS(a2),d0
                    blt.w    YLEFT0
                    moveq    #9-1,d4
SCRLL0:             tst.w    (SCRX)-VARS(a2)
                    beq.w    YLEFT0
                    subq.w   #1,(SCRX)-VARS(a2)
                    bsr.w    FRAME
                    move.w   d4,-(sp)
                    bsr.w    PBAK
                    move.w   (sp)+,d4
                    dbra     d4,SCRLL0
YLEFT0:             move.w   #4,(LPCTR)-VARS(a2)
                    moveq    #4,d2
                    bra.w    YANIM

YRIGHT:             addq.w   #1,(YOUX)-VARS(a2)
                    move.w   (SCRX)-VARS(a2),d0
                    addi.w   #10,d0
                    cmp.w    (YOUX)-VARS(a2),d0
                    bgt.w    YRIGH0
                    moveq    #9-1,d4
SCRLR0:             cmpi.w   #$50,(SCRX)-VARS(a2)
                    beq.w    YRIGH0
                    addq.w   #1,(SCRX)-VARS(a2)
                    bsr.w    FRAME
                    move.w   d4,-(sp)
                    bsr.w    PBAK
                    move.w   (sp)+,d4
                    dbra     d4,SCRLR0
YRIGH0:             move.w   #4,(LPCTR)-VARS(a2)
                    moveq    #6,d2
YANIM:              eori.w   #1,(ANIMCT)-VARS(a2)
                    move.w   (ANIMCT)-VARS(a2),d1
                    move.w   (YFRAME)-VARS(a2),d0
                    eor.w    d1,d0
                    andi.w   #1,d0
                    or.w     d2,d0
                    move.w   d0,(YFRAME)-VARS(a2)
                    eori.w   #1,(ANIMXX)-VARS(a2)
                    move.w   (ANIMXX)-VARS(a2),d0
                    andi.w   #1,d0
                    beq.w    RTS
                    addq.w   #3,d0
                    move.w   d0,(WLKSFX)-VARS(a2)
                    rts

YFIRE:              tst.w    (FIREFL)-VARS(a2)
                    bne.w    LOOP2
                    tst.w    (YDLY)-VARS(a2)
                    bne.w    LOOP5
                    move.w   #$14,(FIREFL)-VARS(a2)
                    lea      (BULLDT)-VARS(a2),a6
                    moveq    #8-1,d4
YFIRE9:             tst.b    (a6)
                    beq.w    YFIRE8
                    lea      (4,a6),a6
                    dbra     d4,YFIRE9
                    bra.w    LOOP2

YFIRE8:             tst.w    (BULLS)-VARS(a2)
                    beq.w    LOOP2
                    move.w   (BULLS)-VARS(a2),d0
                    moveq    #1,d1
                    move.w   #4,ccr
                    sbcd     d1,d0
                    move.w   d0,(BULLS)-VARS(a2)
                    move.w   #1,(SFX)-VARS(a2)
                    movem.l  d0-d7/a0-a6,-(sp)
                    bsr.w    DOGUN
                    movem.l  (sp)+,d0-d7/a0-a6
                    move.w   (YFRAME)-VARS(a2),d0
                    move.w   d0,(YOLDFR)-VARS(a2)
                    divu.w   #2,d0
                    andi.w   #3,d0
                    move.b   d0,(3,a6)
                    move.w   d0,(YFRAME)-VARS(a2)
                    andi.l   #$FF,d0
                    addq.w   #8,(YFRAME)-VARS(a2)
                    add.w    d0,d0
                    add.w    d0,d0
                    lea      (YFRTBL)-VARS(a2),a3
                    adda.l   d0,a3
                    move.w   (YOUX)-VARS(a2),d0
                    add.w    (a3)+,d0
                    move.w   (YOUY)-VARS(a2),d1
                    add.w    (a3),d1
                    cmp.w    #$A8,d1
                    beq.w    LOOP2
                    move.b   d0,(1,a6)
                    move.b   d1,(2,a6)
                    move.b   #$FF,(a6)
                    bsr.w    CLCMAP
                    tst.b    (a0)
                    bne.w    LOOP2
                    move.b   (3,a6),d0
                    addi.b   #$BA,d0
                    move.b   d0,(a0)
                    bra.w    LOOP2

YFRTBL:             dc.w     0,3,1,-1,-1,0,2,2

PUTOBJ:             move.w   (LEVEL)-VARS(a2),d3
                    andi.w   #3,d3
                    lea      (OBJTBL0)-VARS(a2),a3
                    andi.w   #1,(LOADED)-VARS(a2)
                    beq.w    ADOBJ0
                    lea      (OBJTBL1)-VARS(a2),a3
ADOBJ0:             cmpi.b   #$FF,(2,a3)
                    beq.w    RTS
                    cmp.b    (2,a3),d3
                    beq.w    ADOBJ2
ADOBJ1:             lea      (7,a3),a3
                    bra.w    ADOBJ0

ADOBJ2:             btst     #7,(3,a3)
                    bne.w    ADOBJ1
                    move.b   (a3),d0
                    move.b   (1,a3),d1
                    bsr.w    CLCMAP
                    move.b   (3,a3),d0
                    andi.l   #$F,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    lea      (OBCHTB)-VARS(a2),a4
                    adda.l   d0,a4
                    bsr.w    PTOBCH
                    bsr.w    PTOBCH
                    lea      (96-2,a0),a0
                    bsr.w    PTOBCH
                    bsr.w    PTOBCH
                    bra.w    ADOBJ1

PTOBCH:             tst.b    (a4)
                    beq.w    PTOBC0
                    move.b   (a4),(a0)
PTOBC0:             addq.l   #1,a4
                    addq.l   #1,a0
                    rts

OBCHTB:             dc.b     $60,$61,0,0,$62,0,$63,0,$64,0,$65,0,0,0,0,0,$69,0
                    dc.b     $6A,0,0,0,0,0,$6C,0,$6D,0,$6E,0,$6F,0,$6B,0,0,0

INTOBJ:             lea      (OBJTBL0)-VARS(a2),a6
                    andi.w   #1,(LOADED)-VARS(a2)
                    beq.w    INTOB0
                    lea      (OBJTBL1)-VARS(a2),a6
INTOB0:             cmpi.b   #$FF,(6,a6)
                    beq.w    RTS
                    move.b   (6,a6),(2,a6)
                    move.b   (4,a6),(a6)
                    move.b   (5,a6),(1,a6)
                    andi.b   #$7F,(3,a6)
                    addq.l   #7,a6
                    bra.w    INTOB0

KLLOBJ:             lea      (OBJTBL0)-VARS(a2),a6
                    andi.w   #1,(LOADED)-VARS(a2)
                    beq.w    KLLOB0
                    lea      (OBJTBL1)-VARS(a2),a6
KLLOB0:             move.w   d5,d0
                    move.w   d6,d1
                    cmp.b    (a6),d0
                    beq.w    KLLOB2
                    addq.w   #1,d0
                    cmp.b    (a6),d0
                    bne.w    KLLOB1
KLLOB2:             cmp.b    (1,a6),d1
                    beq.w    KLLOB3
                    subq.w   #1,d1
                    cmp.b    (1,a6),d1
                    bne.w    KLLOB1
KLLOB3:             bset     #7,(3,a6)
                    move.b   (a6),d0
                    move.b   (1,a6),d1
                    bsr.w    CLCMAP
                    sf.b     (a0)
                    sf.b     (1,a0)
                    sf.b     (96,a0)
                    sf.b     (96+1,a0)
                    rts

KLLOB1:             cmpi.b   #$FF,(a6)
                    beq.w    RTS
                    addq.l   #7,a6
                    bra.w    KLLOB0

YHF:                dc.b     '   YOU   FOUND',$FF
YHS:                dc.b     '   YOU   SHOT',$FF
                    even
OBJ:                dc.l     OBJ0
                    dc.l     OBJ1
                    dc.l     OBJ2
                    dc.l     OBJ3
                    dc.l     OBJ4
                    dc.l     OBJ5
                    dc.l     OBJ6
                    dc.l     OBJ7
                    dc.l     OBJ8
                    dc.l     OBJ9
OBJ0:               dc.b     '   AN AMMO BOX',$FF
OBJ1:               dc.b     '   A PAINTING',$FF
OBJ2:               dc.b     '     A VASE',$FF
OBJ3:               dc.b     'BUG',$FF
OBJ4:               dc.b     '    COLD FOOD',$FF
OBJ5:               dc.b     '  i DYNAMITE i',$FF
OBJ6:               dc.b     '    FIRST AID',$FF
OBJ7:               dc.b     '    A PENDANT',$FF
OBJ8:               dc.b     'AN ELEVATOR PASS',$FF
OBJ9:               dc.b     '   A DOOR KEY',$FF
                    even

POBJ:               andi.l   #$F,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    lea      (OBJ)-VARS(a2),a1
                    adda.l   d0,a1
                    movea.l  (a1),a1
                    bra.w    WSPRNT

PAUSE:              bsr.w    PBAK
                    bsr.w    INIT_MUSIC
                    moveq    #3,d4
                    moveq    #10,d5
                    moveq    #10,d2
                    moveq    #3,d3
                    bsr.w    WINDOW
                    lea      (PAUS0)-VARS(a2),a1
                    moveq    #4,d4
                    moveq    #11,d5
                    bsr.w    WSPRNT
PAUSE0:             bsr.w    KSCAN
                    tst.w    (ESCFLG)-VARS(a2)
                    bne.w    PAUSE0
PAUSE1:             bsr.w    KSCAN
                    tst.w    (ESCFLG)-VARS(a2)
                    beq.w    PAUSE1
PAUSE2:             bsr.w    KSCAN
                    tst.w    (ESCFLG)-VARS(a2)
                    bne.w    PAUSE2
                    bsr.w    SETCOL
                    bsr.w    EXIT_MUSIC
                    bra.w    PBAK

PAUS0:              dc.b     'PAUSING',$FF
                    even

ADD50:              lea      (ADD250)-VARS(a2),a0
ADD_0:              lea      (HITFLG)-VARS(a2),a1
                    move.w   #4,ccr
                    abcd     -(a0),-(a1)
                    abcd     -(a0),-(a1)
                    abcd     -(a0),-(a1)
                    abcd     -(a0),-(a1)
                    rts

SC50:               dc.b     0,0,0,$50

ADD250:             lea      (ADD150)-VARS(a2),a0
                    bra.w    ADD_0

SC250:              dc.b     0,0,$25,0

ADD150:             lea      (ADD100)-VARS(a2),a0
                    bra.w    ADD_0

SC150:              dc.b     0,0,$15,0

ADD100:             lea      (ADD25)-VARS(a2),a0
                    bra.w    ADD_0

SC100:              dc.b     0,0,$10,0

ADD25:              lea      (ADD4)-VARS(a2),a0
                    bra.w    ADD_0

SC25:               dc.b     0,0,0,$25

ADD4:               lea      (ADD5)-VARS(a2),a0
                    bra.w    ADD_0

SC4:                dc.b     0,0,4,0

ADD5:               lea      (ADD400)-VARS(a2),a0
                    bra.w    ADD_0

SC5:                dc.b     0,0,$25,0

ADD400:             lea      (DEAD)-VARS(a2),a0
                    bra.w    ADD_0

SC400:              dc.b     0,0,4,0

DEAD:               tst.w    (CHTFLG)-VARS(a2)
                    bne.w    LOOP9
                    moveq    #0,d4
                    moveq    #11,d5
                    moveq    #16,d2
                    moveq    #3,d3
                    bsr.w    WINDOW
                    lea      (DEADS)-VARS(a2),a1
                    moveq    #2,d4
                    moveq    #12,d5
                    bsr.w    WSPRNT
                    bsr.w    WAIT
                    bsr.w    WAIT
                    bra.w    START0

DEADS:              dc.b     'YOU ARE DEAD',$FF
                    even

NEWHSC:             lea      (HISCORE)-VARS(a2),a4
                    lea      (SCORE+1)-VARS(a2),a3
                    bsr.w    CMPSCR
                    tst.w    d0
                    beq.w    RTS
                    lea      (SCORE)-VARS(a2),a4
                    lea      (HISCORE)-VARS(a2),a3
                    move.b   (SCORE+1)-VARS(a2),(HISCORE)-VARS(a2)
                    move.b   (SCORE+2)-VARS(a2),(HISCORE+1)-VARS(a2)
                    move.b   (SCORE+3)-VARS(a2),(HISCORE+2)-VARS(a2)
                    bsr.w    CLS
                    lea      (NHSCS0)-VARS(a2),a1
                    moveq    #4,d4
                    moveq    #1,d5
                    bsr.w    WSLINE
                    lea      (NHSCS1)-VARS(a2),a1
                    moveq    #4,d4
                    moveq    #8,d5
                    bsr.w    WSPRNT
                    lea      (NHSCS2)-VARS(a2),a1
                    moveq    #4,d4
                    moveq    #10,d5
                    bsr.w    WSLINE
                    lea      (NHSCS3)-VARS(a2),a1
                    moveq    #1,d4
                    moveq    #18,d5
                    bsr.w    WSLINE
                    lea      (HSBLNK)-VARS(a2),a1
                    moveq    #4,d4
                    moveq    #22,d5
                    bsr.w    WSPRNT
                    bsr.w    SETCOL
                    lea      (lbB0016A0)-VARS(a2),a6
                    moveq    #8-1,d2
                    moveq    #4,d4
                    moveq    #22,d5
NWHSC0:             move.w   d2,-(sp)
                    move.w   d4,-(sp)
                    move.w   d5,-(sp)
                    bsr.w    GETDIG
                    cmp.b    #$25,d0
                    bne.w    NWHSC9
                    move.w   (sp)+,d5
                    move.w   (sp)+,d4
                    move.w   (sp)+,d2
                    cmp.w    #7,d2
                    beq.w    NWHSC0
                    move.w   d2,-(sp)
                    move.w   d4,-(sp)
                    move.w   d5,-(sp)
                    move.w   #$29,d0
                    bsr.w    WPRT
                    move.w   (sp)+,d5
                    move.w   (sp)+,d4
                    move.w   (sp)+,d2
                    subq.w   #1,d4
                    addq.w   #1,d2
                    subq.l   #1,a6
                    bra.w    NWHSC0

NWHSC9:             move.b   d0,(a6)+
                    move.w   (sp)+,d5
                    move.w   (sp)+,d4
                    addq.w   #1,d4
                    move.w   (sp)+,d2
                    dbra     d2,NWHSC0
                    move.b   (lbB0016A0)-VARS(a2),d0
                    cmp.b    #$FE,d0
                    beq.w    NWHSC7
                    cmp.b    #$FC,d0
                    beq.w    NWHSC6
                    cmp.b    #$FB,d0
                    beq.w    NWHS11
                    cmp.b    #$FD,d0
                    bne.w    NWHSC8
                    clr.w    (MAPMOD)-VARS(a2)
                    sf.b     (lbB0016A0)-VARS(a2)
                    bra.w    NWHSC8

NWHSC7:             move.w   #$FF,(MAPMOD)-VARS(a2)
                    sf.b     (lbB0016A0)-VARS(a2)
                    bra.w    NWHSC8

NWHSC6:             move.w   #1,(CHTFLG)-VARS(a2)
                    sf.b     (lbB0016A0)-VARS(a2)
                    bra.w    NWHSC8

NWHS11:             move.w   #1,(NMECHT)-VARS(a2)
                    sf.b     (lbB0016A0)-VARS(a2)

NWHSC8:             lea      (lbB001695)-VARS(a2),a4
                    lea      (lbB0016A0)-VARS(a2),a3
                    moveq    #8-1,d2
NWHSC1:             move.w   d2,-(sp)
                    move.l   a3,-(sp)
                    move.l   a4,-(sp)
                    lea      (8,a3),a3
                    lea      (8,a4),a4
                    bsr.w    CMPSCR
                    tst.w    d0
                    beq.w    NWHSC2
                    movea.l  (sp)+,a4
                    movea.l  (sp)+,a3
                    move.l   a3,-(sp)
                    move.l   a4,-(sp)
                    moveq    #11-1,d2
NWHSC3:             move.b   (a4),d0
                    move.b   (a3),(a4)
                    move.b   d0,(a3)
                    addq.l   #1,a3
                    addq.l   #1,a4
                    dbra     d2,NWHSC3
NWHSC2:             movea.l  (sp)+,a4
                    movea.l  (sp)+,a3
                    suba.l   #11,a4
                    suba.l   #11,a3
                    move.w   (sp)+,d2
                    dbra     d2,NWHSC1
                    bra.w    BLACK

NHSCS0:             dc.b     'WELL DONE',$FF
NHSCS1:             dc.b     'YOU ARE A',$FF
NHSCS2:             dc.b     'REAL HERO',$FF
NHSCS3:             dc.b     'ENTER YOUR NAME',$FF
HSBLNK:             dc.b     'iiiiiiii',$FF
                    even

CMPSCR:             moveq    #3-1,d3
CMPSC0:             move.b   (a3)+,d0
                    cmp.b    (a4)+,d0
                    bcs.w    CMPSC2
                    bne.w    CMPSC1
                    dbra     d3,CMPSC0
                    bra.w    CMPSC1

CMPSC2:             moveq    #0,d0
                    rts

CMPSC1:             moveq    #-1,d0
                    rts

GETDIG:             moveq    #1,d3
GETDG0:             move.w   d4,-(sp)
                    move.w   d5,-(sp)
                    move.w   d3,-(sp)
                    move.w   d3,d0
                    bsr.w    WPRT
                    bsr.w    KSCAN
                    bsr.w    FRAME
                    bsr.w    FRAME
                    bsr.w    FRAME
                    bsr.w    FRAME
                    bsr.w    FRAME
                    move.w   (sp)+,d3
                    move.w   (sp)+,d5
                    move.w   (sp)+,d4
                    btst     #2,(JOYVAL)-VARS(a2)
                    bne.w    GETDG1
                    btst     #3,(JOYVAL)-VARS(a2)
                    bne.w    GETDG2
                    btst     #4,(JOYVAL)-VARS(a2)
                    beq.w    GETDG0
GETDG3:             move.w   d3,-(sp)
                    bsr.w    KSCAN
                    move.w   (sp)+,d3
                    btst     #4,(JOYVAL)-VARS(a2)
                    bne.w    GETDG3
                    move.w   d3,d0
                    rts

GETDG1:             tst.w    d3
                    beq.w    GETDG5
                    subq.w   #1,d3
                    bra.w    GETDG0

GETDG2:             cmp.w    #$25,d3
                    beq.w    GETDG4
                    addq.w   #1,d3
                    bra.w    GETDG0

GETDG4:             moveq    #0,d3
                    bra.w    GETDG0

GETDG5:             moveq    #$25,d3
                    bra.w    GETDG0

TTL0:               lea      (INTRO0)-VARS(a2),a1
                    moveq    #1,d4
                    moveq    #1,d5
                    bsr.w    WSLINE
                    lea      (INTRO1)-VARS(a2),a1
                    moveq    #2,d4
                    moveq    #4,d5
                    bsr.w    WSLINE
                    lea      (INTRO2)-VARS(a2),a1
                    moveq    #2,d4
                    moveq    #$14,d5
                    bsr.w    WSLINE
                    moveq    #1,d4
                    moveq    #8,d5
                    moveq    #13,d2
                    moveq    #9,d3
                    bsr.w    TTLBK0
                    move.w   #1,(TTAFLG)-VARS(a2)
                    move.w   #1,(TTADIR)-VARS(a2)
                    move.w   #1,(TTADLY)-VARS(a2)
                    move.w   #4,(TTAPOS)-VARS(a2)
                    move.w   #5,(FAKENM+2)-VARS(a2)
                    move.w   #8,(TTACNT)-VARS(a2)
                    rts

TTL1:               lea      (HIGH0)-VARS(a2),a1
                    moveq    #0,d4
                    moveq    #0,d5
                    bsr.w    WSLINE
                    moveq    #0,d4
                    moveq    #3,d5
                    moveq    #9-1,d7
                    lea      (HSCTBL)-VARS(a2),a4
TTL10:              move.l   a4,-(sp)
                    move.w   d4,-(sp)
                    move.w   d5,-(sp)
                    moveq    #8-1,d6
TTL11:              move.b   (a4)+,d0
                    move.l   a4,-(sp)
                    move.w   d6,-(sp)
                    bsr.w    WPRT
                    move.w   (sp)+,d6
                    movea.l  (sp)+,a4
                    dbra     d6,TTL11
                    addq.w   #2,d4
                    moveq    #3-1,d6
TTL12:              move.b   (a4)+,d0
                    move.l   a4,-(sp)
                    move.w   d6,-(sp)
                    bsr.w    WPHEXB
                    move.w   (sp)+,d6
                    movea.l  (sp)+,a4
                    dbra     d6,TTL12
                    move.w   (sp)+,d5
                    move.w   (sp)+,d4
                    addq.w   #2,d5
                    movea.l  (sp)+,a4
                    lea      (11,a4),a4
                    dbra     d7,TTL10
                    clr.w    (TTAFLG)-VARS(a2)
                    lea      (INTRO2)-VARS(a2),a1
                    moveq    #2,d4
                    moveq    #$16,d5
                    bra.w    WSLINE

TTL2:               lea      (TTL2S0)-VARS(a2),a1
                    moveq    #4,d4
                    moveq    #2,d5
                    bsr.w    WSLINE
                    lea      (TTL2S1)-VARS(a2),a1
                    moveq    #6,d4
                    moveq    #7,d5
                    bsr.w    WSPRNT
                    lea      (TTL2S2)-VARS(a2),a1
                    moveq    #6,d4
                    moveq    #8,d5
                    bsr.w    WSPRNT
                    lea      (TTL2S3)-VARS(a2),a1
                    moveq    #6,d4
                    moveq    #11,d5
                    bsr.w    WSPRNT
                    lea      (TTL2S4)-VARS(a2),a1
                    moveq    #6,d4
                    moveq    #12,d5
                    bsr.w    WSPRNT
                    lea      (TTL2S5)-VARS(a2),a1
                    moveq    #6,d4
                    moveq    #15,d5
                    bsr.w    WSPRNT
                    lea      (TTL2S6)-VARS(a2),a1
                    moveq    #6,d4
                    moveq    #16,d5
                    bsr.w    WSPRNT
                    lea      (TTL2S7)-VARS(a2),a1
                    moveq    #6,d4
                    moveq    #19,d5
                    bsr.w    WSPRNT
                    lea      (TTL2S8)-VARS(a2),a1
                    moveq    #6,d4
                    moveq    #20,d5
                    bsr.w    WSPRNT
                    bsr.w    TTLBAK
                    lea      (TTL2OT)-VARS(a2),a6
                    moveq    #3,d4
                    moveq    #7,d5
                    bsr.w    WPOBJ0
                    moveq    #3,d4
                    moveq    #11,d5
                    bsr.w    WPOBJ0
                    moveq    #3,d4
                    moveq    #15,d5
                    bsr.w    WPOBJ0
                    moveq    #3,d4
                    moveq    #$13,d5
                    bra.w    WPOBJ0

TTL3:               lea      (TTL3S0)-VARS(a2),a1
                    moveq    #4,d4
                    moveq    #2,d5
                    bsr.w    WSLINE
                    lea      (TTL3S1)-VARS(a2),a1
                    moveq    #6,d4
                    moveq    #7,d5
                    bsr.w    WSPRNT
                    lea      (TTL3S2)-VARS(a2),a1
                    moveq    #6,d4
                    moveq    #11,d5
                    bsr.w    WSPRNT
                    lea      (TTL3S3)-VARS(a2),a1
                    moveq    #6,d4
                    moveq    #15,d5
                    bsr.w    WSPRNT
                    lea      (TTL3S4)-VARS(a2),a1
                    moveq    #6,d4
                    moveq    #19,d5
                    bsr.w    WSPRNT
                    bsr.w    TTLBAK
                    lea      (TTL3OT)-VARS(a2),a6
                    moveq    #3,d4
                    moveq    #7,d5
                    bsr.w    WPOBJ0
                    moveq    #3,d4
                    moveq    #11,d5
                    bsr.w    WPOBJ0
                    moveq    #3,d4
                    moveq    #15,d5
                    bsr.w    WPOBJ0
                    moveq    #3,d4
                    moveq    #$13,d5
                    bra.w    WPOBJ0

TTLTBL:             dc.l     TTL0
                    dc.l     TTL1
                    dc.l     TTL2
                    dc.l     TTL3
TTL2S0:             dc.b     'VALUABLES',$FF
TTL2S1:             dc.b     'CLASSIC',$FF
TTL2S2:             dc.b     ' PAINTING',$FF
TTL2S3:             dc.b     'PRICELESS',$FF
TTL2S4:             dc.b     '  VASE',$FF
TTL2S5:             dc.b     'GOLDEN',$FF
TTL2S6:             dc.b     '  PENDANT',$FF
TTL2S7:             dc.b     'ASSORTED',$FF
TTL2S8:             dc.b     'GEMSTONES',$FF
TTL3S0:             dc.b     'SUPPLIES',$FF
TTL3S1:             dc.b     'COLD FOOD',$FF
TTL3S2:             dc.b     'DOOR KEY',$FF
TTL3S3:             dc.b     'AMMO BOX',$FF
TTL3S4:             dc.b     'FIRST AID',$FF

TTL2OT:             dc.b     $62,$63,$64,$65,$6E,$6F,$7C,$7D
TTL3OT:             dc.b     $69,$6A,$68,0,$60,0,$6C,$6D
                    even

WPOBJ0:             move.b   (a6)+,d0
                    move.w   d4,-(sp)
                    move.w   d5,-(sp)
                    bsr.w    PCHRMP
                    move.w   (sp)+,d5
                    move.w   (sp)+,d4
WPOBJZ:             addq.w   #1,d5
                    move.b   (a6)+,d0
                    bsr.w    PCHRMP
                    rts

TTLBAK:             moveq    #2,d4
                    moveq    #6,d5
                    moveq    #3-1,d2
                    moveq    #16-1,d3
TTLBK0:             move.w   d4,-(sp)
                    move.w   d2,-(sp)
TTLBK1:             moveq    #0,d0
                    bsr.w    PCHRMP
                    addq.w   #1,d4
                    dbra     d2,TTLBK1
                    move.w   (sp)+,d2
                    move.w   (sp)+,d4
                    addq.w   #1,d5
                    dbra     d3,TTLBK0
                    rts

WSLINE:             move.l   a1,-(sp)
                    move.w   d4,-(sp)
                    move.w   d5,-(sp)
                    bsr.w    WSPRNT
                    move.w   (sp)+,d5
                    move.w   (sp)+,d4
                    movea.l  (sp)+,a1
                    addq.w   #1,d5
TLINE:              move.b   (a1)+,d0
                    beq.b    TLINE0
                    cmp.b    #$FF,d0
                    beq.w    RTS
                    move.l   a1,-(sp)
                    move.w   d4,-(sp)
                    move.w   d5,-(sp)
                    move.w   #$29,d0
                    bsr.w    WPRT
                    move.w   (sp)+,d5
                    move.w   (sp)+,d4
                    movea.l  (sp)+,a1
TLINE0:             addq.w   #1,d4
                    bra.w    TLINE

PYOU:               move.w   (YFRAME)-VARS(a2),d0
                    mulu.w   #6,d0
                    ext.l    d0
                    lea      (YCHRS)-VARS(a2),a5
                    adda.l   d0,a5
                    move.w   (YOUX)-VARS(a2),d0
                    move.w   (YOUY)-VARS(a2),d1
PBLOCK:             bsr.w    CLCMAP
                    move.b   (a5)+,(a0)+
                    move.b   (a5)+,(a0)+
                    lea      (96-2,a0),a0
                    move.b   (a5)+,(a0)+
                    move.b   (a5)+,(a0)+
                    lea      (96-2,a0),a0
                    move.b   (a5)+,(a0)+
                    move.b   (a5)+,(a0)+
                    rts

EBLOCKA:            lea      (EDATA),a5
PBLOCKA:            moveq    #2,d2
PBLKA0:             move.w   d0,-(sp)
                    moveq    #1,d3
PBLKA1:             move.w   d0,-(sp)
                    move.w   d1,-(sp)
                    move.w   d2,-(sp)
                    move.w   d3,-(sp)
                    move.w   d0,d4
                    move.w   d1,d5
                    move.b   (a5)+,d0
                    move.l   a5,-(sp)
                    bsr.w    PCHRMP
                    movea.l  (sp)+,a5
                    move.w   (sp)+,d3
                    move.w   (sp)+,d2
                    move.w   (sp)+,d1
                    move.w   (sp)+,d0
                    addq.w   #1,d0
                    dbra     d3,PBLKA1
                    move.w   (sp)+,d0
                    addq.w   #1,d1
                    dbra     d2,PBLKA0
                    rts

EYOU:               move.w   (YOUX)-VARS(a2),d0
                    move.w   (YOUY)-VARS(a2),d1
EBLOCK:             lea      (EDATA),a5
                    bra.w    PBLOCK

EDATA:              dcb.w    3,0
YOUBFR:             dcb.w    3,0

CYOU:               move.w   (YOUX)-VARS(a2),d0
                    move.w   (YOUY)-VARS(a2),d1
                    move.w   d0,d5
                    move.w   d1,d6
                    bsr.w    CLCMAP
                    move.w   #0,(LPSFLG)-VARS(a2)
                    lea      (YOUBFR)-VARS(a2),a1
                    moveq    #3-1,d4
CYOU0:              move.w   d5,-(sp)
                    move.w   d4,-(sp)
                    moveq    #2-1,d4
CYOU1:              move.w   d4,-(sp)
                    move.l   a1,-(sp)
                    move.b   (a0),d0
                    cmp.b    #$2A,d0
                    beq.w    LIFT
                    cmp.b    #$58,d0
                    bcs.w    CYOU4
                    cmp.b    #$5E,d0
                    bcs.w    CDOOR
                    cmp.b    #$60,d0
                    bcs.w    CYOU4
                    cmp.b    #$70,d0
                    bcs.w    FOUND
                    cmp.b    #$7C,d0
                    beq.w    FNDJW1
                    cmp.b    #$7D,d0
                    beq.w    FNDJW0
CYOU4:              movea.l  (sp)+,a1
                    move.b   d0,(a1)+
                    addq.w   #1,d5
                    addq.l   #1,a0
                    move.w   (sp)+,d4
                    dbra     d4,CYOU1
                    move.w   (sp)+,d4
                    move.w   (sp)+,d5
                    addq.w   #1,d6
                    lea      (96-2,a0),a0
                    dbra     d4,CYOU0
                    lea      (YOUBFR)-VARS(a2),a1
                    moveq    #0,d0
                    moveq    #6-1,d1
CYOU2:              or.b     (a1)+,d0
                    dbra     d1,CYOU2
                    tst.w    d0
                    rts

FOUND:              cmp.b    #$66,d0
                    beq.w    CYOU4
                    cmp.b    #$67,d0
                    beq.w    CYOU4
                    cmp.b    #$61,d0
                    beq.w    CYOU4
                    move.l   a0,-(sp)
                    move.l   a1,-(sp)
                    move.w   d5,-(sp)
                    move.w   d6,-(sp)
                    cmp.b    #$60,d0
                    beq.w    FNDAMO
                    cmp.b    #$6B,d0
                    beq.w    FNDLPS
                    cmp.b    #$68,d0
                    beq.w    FNDKEY
                    bsr.w    KLLOBJ
                    move.b   (3,a6),d0
                    andi.b   #15,d0
                    cmp.b    #1,d0
                    bne.w    FOUND1
                    bsr.w    ADD250
                    bra.w    FOUND9

FOUND1:             cmp.b    #2,d0
                    bne.w    FOUND2
                    bsr.w    ADD150
                    bra.w    FOUND9

FOUND2:             cmp.b    #6,d0
                    bne.w    FOUND3
FOUND8:             clr.w    (HITS)-VARS(a2)
                    bra.w    FOUND9

FOUND3:             cmp.b    #3,d0
                    bne.w    FOUND4
                    bsr.w    ADD150
                    bra.w    FOUND9

FOUND4:             cmp.b    #4,d0
                    bne.w    FOUND5
                    move.w   (HITS)-VARS(a2),d0
                    cmp.b    #16,d0
                    bcs.w    FOUND8
                    moveq    #16,d1
                    move.w   #4,ccr
                    sbcd     d1,d0
                    move.w   d0,(HITS)-VARS(a2)
                    bra.w    FOUND9

FOUND5:             cmp.b    #7,d0
                    bne.w    FOUND9
                    bsr.w    ADD400

FOUND9:             tst.w    (MSFLG)-VARS(a2)
                    beq.w    FOUND0
                    moveq    #0,d4
                    moveq    #11,d5
                    moveq    #16,d2
                    moveq    #4,d3
                    bsr.w    WINDOW
                    lea      (YHF),a1
                    moveq    #0,d4
                    moveq    #12,d5
                    bsr.w    WSPRNT
                    move.w   #0,d4
                    move.w   #13,d5
                    move.b   (3,a6),d0
                    bsr.w    POBJ
                    bsr.w    WAIT
FOUND0:             move.w   (sp)+,d6
                    move.w   (sp)+,d5
                    movea.l  (sp)+,a1
                    movea.l  (sp)+,a0
                    moveq    #0,d0
                    bra.w    CYOU4

FNDAMO:             sf.b     (a0)
                    bsr.w    ADDBUL
                    bra.w    FOUND0

FNDKEY:             sf.b     (a0)
                    move.w   (KEYS)-VARS(a2),d1
                    move.w   #1,d0
                    move.w   #4,ccr
                    abcd     d0,d1
                    move.w   d1,(KEYS)-VARS(a2)
                    lea      (H_MSG)-VARS(a2),a6
                    bra.w    FOUND9

FNDLPS:             move.w   #1,(LVLPSS)-VARS(a2)
                    sf.b     (a0)
                    lea      (lbB00375C)-VARS(a2),a6
                    bra.w    FOUND9

FNDJW0:             move.l   a0,-(sp)
                    move.w   d5,-(sp)
                    move.w   d6,-(sp)
                    suba.l   #96,a0
                    bra.w    FNDJW2

FNDJW1:             move.l   a0,-(sp)
                    move.w   d5,-(sp)
                    move.w   d6,-(sp)
FNDJW2:             move.b   #$7A,(a0)
                    move.b   #$7B,(96,a0)
                    bsr.w    ADD4
                    move.w   (sp)+,d6
                    move.w   (sp)+,d5
                    movea.l  (sp)+,a0
                    moveq    #1,d0
                    bra.w    CYOU4

lbB00375C:          equ      *-2
H_MSG:              equ      *-1
NUM0:               dc.b     0
NUM8:               dc.b     8
NUM9:               dc.b     9
                    dc.b     0

NOLIFT:             tst.w    (LPSFLG)-VARS(a2)
                    bne.w    NOLFT0
                    moveq    #0,d4
                    moveq    #11,d5
                    moveq    #16,d2
                    moveq    #4,d3
                    bsr.w    WINDOW
                    lea      (YNS),a1
                    moveq    #3,d4
                    moveq    #12,d5
                    bsr.w    WSPRNT
                    moveq    #8,d0
                    moveq    #0,d4
                    moveq    #13,d5
                    bsr.w    POBJ
                    bsr.w    WAIT
                    bsr.w    PBAK
NOLFT0:             clr.w    (XLEVEL)-VARS(a2)
                    move.w   #$FF,(LPSFLG)-VARS(a2)
                    move.w   (sp)+,d6
                    move.w   (sp)+,d5
                    movea.l  (sp)+,a0
                    moveq    #-1,d0
                    bra.w    CYOU4

LIFT:               tst.w    (XLEVEL)-VARS(a2)
                    bne.w    CYOU4
                    move.w   #$FF,(XLEVEL)-VARS(a2)
                    move.l   a0,-(sp)
                    move.w   d5,-(sp)
                    move.w   d6,-(sp)
                    tst.w    (LVLPSS)-VARS(a2)
                    beq.w    NOLIFT
                    move.w   #0,(BILLLF)-VARS(a2)
                    move.w   (LEVEL)-VARS(a2),d0
                    cmp.w    (BILLLV)-VARS(a2),d0
                    bne.w    LIFT9
                    tst.w    (BILLAC)-VARS(a2)
                    beq.w    LIFT9
                    tst.w    (BILLOS)-VARS(a2)
                    bne.w    LIFT9
                    move.w   #1,(BILLLF)-VARS(a2)
LIFT9:              moveq    #1,d4
                    moveq    #6,d5
                    moveq    #14,d2
                    moveq    #12,d3
                    bsr.w    WINDOW
                    lea      (LIFTS0)-VARS(a2),a1
                    moveq    #2,d4
                    moveq    #7,d5
                    bsr.w    WSPRNT
                    lea      (LIFTS1)-VARS(a2),a1
                    moveq    #3,d4
                    moveq    #9,d5
                    bsr.w    WSPRNT
                    lea      (LIFTS2)-VARS(a2),a1
                    moveq    #3,d4
                    moveq    #11,d5
                    bsr.w    WSPRNT
                    lea      (LIFTS3)-VARS(a2),a1
                    moveq    #3,d4
                    moveq    #13,d5
                    bsr.w    WSPRNT
                    lea      (LIFTS4)-VARS(a2),a1
                    moveq    #3,d4
                    moveq    #15,d5
                    bsr.w    WSPRNT
                    moveq    #12,d4
                    moveq    #9,d5
                    moveq    #3,d2
LIFT0:              moveq    #$2C,d0
                    bsr.w    WPRT
                    subq.w   #1,d4
                    addq.w   #1,d5
                    moveq    #$26,d0
                    bsr.w    WPRT
                    subq.w   #1,d4
                    addq.w   #1,d5
                    dbra     d2,LIFT0
LIFT3:              move.w   (LEVEL)-VARS(a2),d0
                    andi.w   #3,(LEVEL)-VARS(a2)
                    move.w   (LEVEL)-VARS(a2),d0
                    add.w    d0,d0
                    addi.w   #9,d0
                    move.w   d0,d5
                    moveq    #12,d4
                    moveq    #$27,d0
                    move.w   d4,-(sp)
                    move.w   d5,-(sp)
                    bsr.w    WPRT
                    subq.w   #1,d4
                    addq.w   #1,d5
                    moveq    #$28,d0
                    bsr.w    WPRT
                    moveq    #7,d2
LIFT4:              bsr.w    FRAME
                    dbra     d2,LIFT4
                    move.w   (sp)+,d5
                    move.w   (sp)+,d4
                    moveq    #$2C,d0
                    bsr.w    WPRT
                    subq.w   #1,d4
                    addq.w   #1,d5
                    moveq    #$26,d0
                    bsr.w    WPRT
                    bsr.w    KSCAN
                    btst     #0,(JOYVAL)-VARS(a2)
                    beq.w    LIFT1
                    tst.w    (LEVEL)-VARS(a2)
                    beq.w    LIFT3
                    subq.w   #1,(LEVEL)-VARS(a2)
                    bra.w    LIFT3

LIFT1:              btst     #1,(JOYVAL)-VARS(a2)
                    beq.w    LIFT2
                    cmpi.w   #3,(LEVEL)-VARS(a2)
                    beq.w    LIFT3
                    addq.w   #1,(LEVEL)-VARS(a2)
                    bra.w    LIFT3

LIFT2:              btst     #4,(JOYVAL)-VARS(a2)
                    beq.w    LIFT3
                    move.w   #5,(SFX)-VARS(a2)
                    bsr.w    BLACK
                    move.w   (sp)+,d6
                    move.w   (sp)+,d5
                    movea.l  (sp)+,a0
                    moveq    #1,d0
                    bra.w    CYOU4

LIFTS0:             dc.b     'SELECT FLOOR',$FF
LIFTS1:             dc.b     'BASEMENT',$FF
LIFTS2:             dc.b     'GROUND',$FF
LIFTS3:             dc.b     'FIRST',$FF
LIFTS4:             dc.b     'SECOND',$FF
YNS:                dc.b     ' YOU NEED',$FF
                    even

ADDBUL:             move.w   (BULLS)-VARS(a2),d1
                    cmp.w    #$84,d1
                    bcc.w    ADBUL0
                    move.w   #$15,d0
                    move.w   #4,ccr
                    abcd     d0,d1
                    move.w   d1,(BULLS)-VARS(a2)
                    rts

ADBUL0:             move.w   #$99,(BULLS)-VARS(a2)
                    rts

YCHRS:              dc.b     $88,$89,$8A,$8B,$8C,$8D,$88,$89,$8A,$8B,$8E,$8F
                    dc.b     $80,$81,$82,$83,$84,$85,$86,$87,$82,$83,$84,$85
                    dc.b     $99,$9A,$9B,$9C,$9D,$9E,$9F,$9A,$A0,$9C,$A1,$9E
                    dc.b     $90,$91,$92,$93,$94,$95,$90,$96,$92,$97,$94,$98
                    dc.b     $A8,$A9,$AA,$AB,$AC,$AD,$A2,$A3,$A4,$A5,$A6,$A7
                    dc.b     $B4,$B5,$B6,$B7,$B8,$B9,$AE,$AF,$B0,$B1,$B2,$B3

DOBULL:             lea      (BULLDT)-VARS(a2),a6
                    moveq    #8-1,d6
DOBUL9:             move.l   a6,-(sp)
                    move.w   d6,-(sp)
                    tst.b    (a6)
                    beq.w    DOBUL8
                    tst.b    (a6)
                    bpl.w    DOBUL7
                    move.b   #$14,(0,a6)
                    move.b   (1,a6),d0
                    move.b   (2,a6),d1
                    cmp.b    #$A8,d1
                    beq.w    DOBUL1
                    bsr.w    CLCMAP
                    cmpi.b   #$BA,(a0)
                    blt.w    DOBUL6
                    cmpi.b   #$BD,(a0)
                    bgt.w    DOBUL6
                    sf.b     (a0)
                    bra.w    DOBUL6

DOBUL7:             subq.b   #1,(a6)
                    tst.b    (a6)
                    beq.w    DOBUL1
                    move.b   (3,a6),d0
                    andi.l   #3,d0
                    add.w    d0,d0
                    lea      (DBLTBL)-VARS(a2),a4
                    adda.l   d0,a4
                    move.b   (1,a6),d0
                    move.b   (2,a6),d1
                    add.b    (a4)+,d0
                    add.b    (a4),d1
                    cmp.b    #$A8,d1
                    beq.w    DOBUL1
                    move.b   d0,(1,a6)
                    move.b   d1,(2,a6)
DOBUL6:             move.w   d0,d5
                    move.w   d1,d6
                    bsr.w    CLCMAP
                    move.b   (a0),d0
                    tst.b    d0
                    beq.w    DOBUL8
                    tst.b    d0
                    bpl.w    DOBL10
                    cmp.b    #$BE,d0
                    bcs.w    SHTBLL
                    cmp.b    #$E0,d0
                    bcs.w    KLLNME
                    cmp.b    #$F4,d0
                    bcs.w    SHTBLL
                    bra.w    DOBUL1

DOBL10:             cmp.b    #$70,d0
                    beq.w    SHTOB0
                    cmp.b    #$71,d0
                    beq.w    SHTOB1
                    cmp.b    #$72,d0
                    beq.w    SHTOB2
                    cmp.b    #$73,d0
                    beq.w    SHTOB3
                    cmp.b    #$74,d0
                    beq.w    SHTHDR
                    cmp.b    #$75,d0
                    beq.w    SHTVDR
                    cmp.b    #$76,d0
                    beq.w    SHTDYN
                    cmp.b    #$77,d0
                    beq.w    SHTDYN
                    cmp.b    #$78,d0
                    bcs.w    DOBUL3
                    cmp.b    #$7E,d0
                    bcs.w    SHTJWL
DOBUL3:             cmp.b    #$22,d0
                    beq.w    SHTBOG
                    cmp.b    #$46,d0
                    bcs.w    DOBUL1
                    cmp.b    #$58,d0
                    bcs.w    SHTCMD
                    cmp.b    #$5E,d0
                    bcs.w    DOBUL1
                    cmp.b    #$60,d0
                    bcs.w    SHTDET
                    cmp.b    #$70,d0
                    bcc.w    DOBUL1
                    cmp.b    #$6B,d0
                    beq.w    DOBUL1
                    cmp.b    #$66,d0
                    beq.w    DOBUL1
                    cmp.b    #$67,d0
                    beq.w    DOBUL1
                    cmp.b    #$61,d0
                    beq.w    DOBUL1
                    cmp.b    #$60,d0
                    beq.w    DOBUL2
                    cmp.b    #$68,d0
                    beq.w    SHTKEY
                    bsr.w    KLLOBJ
DOBUL5:             tst.w    (MSFLG)-VARS(a2)
                    beq.w    DOBUL50
                    moveq    #0,d4
                    moveq    #11,d5
                    moveq    #16,d2
                    moveq    #4,d3
                    bsr.w    WINDOW
                    lea      (YHS)-VARS(a2),a1
                    moveq    #0,d4
                    moveq    #12,d5
                    bsr.w    WSPRNT
                    moveq    #0,d4
                    moveq    #13,d5
                    move.b   (3,a6),d0
                    bsr.w    POBJ
                    bsr.w    WAIT
DOBUL50:            bsr.w    PBAK
DOBUL1:             move.w   (sp)+,d6
                    movea.l  (sp)+,a6
                    sf.b     (a6)
                    bra.w    DOBL999

DOBUL8:             move.w   (sp)+,d6
                    movea.l  (sp)+,a6
DOBL999:            addq.l   #4,a6
                    dbra     d6,DOBUL9
                    rts

DOBUL2:             sf.b     (a0)
                    bra.w    DOBUL1

SHTKEY:             bra.w    DOBUL50

SHTBLL:             moveq    #0,d0
                    sub.w    (BILLDR)-VARS(a2),d0
                    move.w   d0,(BILLDR)-VARS(a2)
                    move.w   #$28,(BILLCT)-VARS(a2)
                    bra.w    DOBUL1

SHTBOG:             suba.l   #96,a0
                    cmp.b    (a0),d0
                    beq.w    SHTBOG
                    bra.w    SHTVD0

SHTVDR:             subq.w   #1,d5
                    suba.l   #96,a0
                    cmp.b    (a0),d0
                    beq.w    SHTVDR
SHTVD0:             adda.l   #96,a0
                    cmp.b    (a0),d0
                    bne.w    DOBUL1
                    move.b   #0,(a0)
                    bra.w    SHTVD0

SHTHDR:             suba.l   #1,a0
                    cmp.b    (a0),d0
                    beq.w    SHTHDR
SHTHD0:             adda.l   #1,a0
                    cmp.b    (a0),d0
                    bne.w    DOBUL1
                    move.b   #0,(a0)
                    bra.w    SHTHD0

SHTOB0:             move.b   #$72,(a0)
                    move.b   #$73,(96,a0)
                    bsr.w    ADD25
                    bra.w    DOBUL1

SHTOB1:             move.b   #$72,(-96,a0)
                    move.b   #$73,(a0)
                    bsr.w    ADD25
                    bra.w    DOBUL1

SHTOB2:             move.b   #0,(a0)
                    move.b   #0,(96,a0)
                    bsr.w    ADD25
                    bra.w    DOBUL1

SHTOB3:             move.b   #0,(-96,a0)
                    move.b   #0,(a0)
                    bsr.w    ADD25
                    bra.w    DOBUL1

SHTJWL:             cmp.b    #$78,d0
                    beq.w    SHTJW0
                    cmp.b    #$79,d0
                    beq.w    SHTJW1
                    cmp.b    #$7A,d0
                    beq.w    DOBUL1
                    cmp.b    #$7B,d0
                    beq.w    DOBUL1
                    cmp.b    #$7C,d0
                    beq.w    SHTJW2
SHTJW3:             suba.l   #96,a0
SHTJW2:             lea      (JWLDT0)-VARS(a2),a5
                    bra.w    SHTJW4

SHTJW1:             suba.l   #96,a0
SHTJW0:             lea      (JWLDT0)-VARS(a2),a5
                    bsr.w    CHKJWL
SHTJW4:             move.b   (a5)+,(a0)
                    lea      (96,a0),a0
                    move.b   (a5)+,(a0)
                    bra.w    DOBUL1

JWLDT0:             dc.b     $7A,$7B
JWLDT1:             dc.b     $7C,$7D
JWLDT2:             dc.b     $76,$77

SHTDYN:             moveq    #0,d4
                    moveq    #11,d5
                    moveq    #16,d2
                    moveq    #4,d3
                    bsr.w    WINDOW
                    lea      (YHS)-VARS(a2),a1
                    moveq    #0,d4
                    moveq    #12,d5
                    bsr.w    WSPRNT
                    moveq    #0,d4
                    moveq    #13,d5
                    moveq    #5,d0
                    bsr.w    POBJ
                    tst.w    (SNDFLG)-VARS(a2)
                    beq.w    SHTDYBUG
                    movem.l  d0-d7/a0-a6,-(sp)
                    bsr.w    DOBANG
                    movem.l  (sp)+,d0-d7/a0-a6
SHTDY0:             bsr.w    FRAME
                    move.w   (BORDER)-VARS(a2),($DFF180)
                    addi.w   #$100,(BORDER)-VARS(a2)
                    andi.w   #$F00,(BORDER)-VARS(a2)
                    tst.w    (SFXCFL)-VARS(a2)
                    bne.w    SHTDY0
SHTDYBUGGER:        clr.w    (BORDER)-VARS(a2)
                    move.w   (BORDER)-VARS(a2),($DFF180)
                    bsr.w    PBAK
                    tst.w    (CHTFLG)-VARS(a2)
                    bne.w    DOBUL1
                    bra.w    DEAD

SHTDYBUG:           moveq    #$50,d4
SHTDY0B:            bsr.w    FRAME
                    move.w   (BORDER)-VARS(a2),($DFF180)
                    addi.w   #$100,(BORDER)-VARS(a2)
                    andi.w   #$F00,(BORDER)-VARS(a2)
                    dbra     d4,SHTDY0B
                    bra.w    SHTDYBUGGER

SHTDET:             cmp.b    #$5E,d0
                    bne.w    SHTDT0
                    suba.l   #96,a0
SHTDT0:             sf.b     (a0)
                    sf.b     (96,a0)
                    moveq    #0,d4
                    moveq    #11,d5
                    moveq    #16,d2
                    moveq    #4,d3
                    bsr.w    WINDOW
                    lea      (SHTDS0)-VARS(a2),a1
                    moveq    #3,d4
                    moveq    #12,d5
                    bsr.w    WSPRNT
                    lea      (SHTDS1)-VARS(a2),a1
                    moveq    #4,d4
                    moveq    #13,d5
                    bsr.w    WSPRNT
                    bsr.w    WAIT
                    bsr.w    PBAK
                    move.w   (LEVEL)-VARS(a2),d0
                    andi.l   #3,d0
                    mulu.w   #3,d0
                    lea      (lbB002658)-VARS(a2),a0
                    andi.w   #1,(LOADED)-VARS(a2)
                    beq.w    ZZZZ0
                    lea      (lbB002664)-VARS(a2),a0
ZZZZ0:              adda.l   d0,a0
                    sf.b     (a0)
                    bra.w    DOBUL1

BULLDT:             dcb.b    32,0
SHTDS0:             dc.b     'DETONATOR',$FF
SHTDS1:             dc.b     'ACTIVATED',$FF
DBLTBL:             dc.b     0,1,0,$FF,$FF,0,1,0
CHARTBL:            dc.b     $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F,$10,$11,$12,$13,$14,$15,$16
                    dc.b     $17,$18,$19,$1A,$1B,$1C,$1D,$1E,$1F,$00,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2A,$2B,$2C,$2D
                    dc.b     $2E,$2F,$1B,$1C,$1D,$1E,$1F,$20,$21,$22,$23,$24,$3A,$3B,$3C,$3D,$3E,$3F,$40
                    ;A-Z
                    dc.b     $01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F,$10,$11,$12,$13,$14,$15,$16,$17
                    dc.b     $18,$19,$1A
                    dc.b     $1B,$1C,$1D,$1E,$1F,$20
                    ; a-z
                    dc.b     $21,$22,$23,$24,$25,$26,$27,$28,$29,$2A,$2B,$2C,$2D,$2E,$2F,$30,$31,$32,$33,$34,$35,$36,$37
                    dc.b     $38,$39,$3A,$3B
                    even

; d0: char
; d4: x
; d5: y
WPRT:               andi.l   #$FF,d0
                    lea      (CHARTBL)-VARS(a2),a0
                    move.b   (a0,d0.w),d0
                    lsl.w    #6,d0
                    movea.l  (MD0CSTPTR)-VARS(a2),a0
                    adda.l   d0,a0
                    move.w   d4,-(sp)
                    move.w   d5,-(sp)
                    andi.l   #$1F,d4
                    andi.l   #$1F,d5
                    add.w    d4,d4
                    mulu.w   #(8*40),d5
                    movea.l  (VIDPTR)-VARS(a2),a5
                    adda.l   d4,a5
                    adda.l   d5,a5
                    move.w   (a0)+,(a5)
                    move.w   (a0)+,((200*40),a5)
                    move.w   (a0)+,((200*2*40),a5)
                    move.w   (a0)+,((200*3*40),a5)
                    move.w   (a0)+,(40,a5)
                    move.w   (a0)+,((200*40)+40,a5)
                    move.w   (a0)+,((200*2*40)+40,a5)
                    move.w   (a0)+,((200*3*40)+40,a5)
                    move.w   (a0)+,(80,a5)
                    move.w   (a0)+,((200*40)+80,a5)
                    move.w   (a0)+,((200*2*40)+80,a5)
                    move.w   (a0)+,((200*3*40)+80,a5)
                    move.w   (a0)+,(120,a5)
                    move.w   (a0)+,((200*40)+120,a5)
                    move.w   (a0)+,((200*2*40)+120,a5)
                    move.w   (a0)+,((200*3*40)+120,a5)
                    move.w   (a0)+,(160,a5)
                    move.w   (a0)+,((200*40)+160,a5)
                    move.w   (a0)+,((200*2*40)+160,a5)
                    move.w   (a0)+,((200*3*40)+160,a5)
                    move.w   (a0)+,(200,a5)
                    move.w   (a0)+,((200*40)+200,a5)
                    move.w   (a0)+,((200*2*40)+200,a5)
                    move.w   (a0)+,((200*3*40)+200,a5)
                    move.w   (a0)+,(240,a5)
                    move.w   (a0)+,((200*40)+240,a5)
                    move.w   (a0)+,((200*2*40)+240,a5)
                    move.w   (a0)+,((200*3*40)+240,a5)
                    move.w   (a0)+,(280,a5)
                    move.w   (a0)+,((200*40)+280,a5)
                    move.w   (a0)+,((200*2*40)+280,a5)
                    move.w   (a0)+,((200*3*40)+280,a5)
                    move.w   (sp)+,d5
                    move.w   (sp)+,d4
                    addq.w   #1,d4
                    rts

WINDOW:             subq.w   #1,d2
                    subq.w   #1,d3
WNDW0:              move.w   d2,-(sp)
                    move.w   d4,-(sp)
WNDW1:              moveq    #0,d0
                    bsr.w    WPRT
                    dbra     d2,WNDW1
                    move.w   (sp)+,d4
                    addq.w   #1,d5
                    move.w   (sp)+,d2
                    dbra     d3,WNDW0
                    rts

WSPRNT:             move.b   (a1)+,d0
                    cmp.b    #$FF,d0
                    beq.w    RTS
                    bsr.w    WPRT
                    bra.w    WSPRNT

WPHEXB:             move.w   d0,-(sp)
                    ror.w    #4,d0
                    bsr.w    WPHEXN
                    move.w   (sp)+,d0
WPHEXN:             andi.l   #$F,d0
                    lea      (HEX),a0
                    adda.l   d0,a0
                    move.b   (a0),d0
                    bra.w    WPRT

HEX:                dc.b     '0123456789ABCDEF'
                    even

KLLNME:             move.b   (1,a6),d4
                    move.b   (2,a6),d5
                    move.l   a6,-(sp)
                    movea.l  (NMELSTPTR)-VARS(a2),a6
KLNME0:             btst     #7,(3,a6)
                    beq.w    KLNME2
                    move.b   d4,d0
                    sub.b    (a6),d0
                    cmp.b    #2,d0
                    bcc.w    KLNME2
                    move.b   d5,d0
                    sub.b    (1,a6),d0
                    cmp.b    #3,d0
                    bcs.w    KLNME4
KLNME2:             lea      (4,a6),a6
                    bra.w    KLNME0

KLNME4:             tst.w    (DFCLTY)-VARS(a2)
                    beq.w    EASYGAME
                    btst     #5,(3,a6)
                    bclr     #5,(3,a6)
                    bne.w    KLNME3
EASYGAME:           sf.b      (3,a6)
                    bsr.w    ENME
                    move.b   (a6),d4
                    move.b   (1,a6),d5
                    bsr.w    ADDDIE
KLNME3:             movea.l  (sp)+,a6
                    bsr.w    ADD50
                    bra.w    DOBUL1

CDOOR:              tst.w    (KEYS)-VARS(a2)
                    beq.w    CYOU4
                    move.w   d0,-(sp)
                    move.w   d1,-(sp)
                    move.w   (KEYS)-VARS(a2),d0
                    moveq    #1,d1
                    move.w   #4,ccr
                    sbcd     d1,d0
                    move.w   d0,(KEYS)-VARS(a2)
                    move.w   (sp)+,d1
                    move.w   (sp)+,d0
                    move.w   #6,(SFX)-VARS(a2)
                    movem.l  d0-d7/a0-a6,-(sp)
                    bsr.w    DOCLANK
                    movem.l  (sp)+,d0-d7/a0-a6
                    move.l   a0,-(sp)
                    cmp.b    #$5B,d0
                    bcs.w    CDOOR2
CDOOR0:             move.l   a0,d0
                    andi.l   #$FFFFFFFC,d0
                    movea.l  d0,a0
                    clr.l    (a0)
CDOOR4:             movea.l  (sp)+,a0
                    moveq    #0,d0
                    bra.w    CYOU4

CDOOR2:             move.w   d6,d0
CDOOR3:             andi.w   #3,d0
                    beq.w    CDOR20
                    suba.l   #$60,a0
                    subq.w   #1,d0
                    bra.w    CDOOR3

CDOR20:             sf.b     (a0)
                    sf.b     (96,a0)
                    sf.b     (192,a0)
                    sf.b     (288,a0)
                    bra.w    CDOOR4

COMPIT:             cmpi.w   #3,(DIFLVL)-VARS(a2)
                    bcc.w    COMPM3
                    tst.w    (BILLAC)-VARS(a2)
                    beq.w    RTS
                    move.w   (LEVEL)-VARS(a2),d0
                    cmp.w    (BILLLV)-VARS(a2),d0
                    bne.w    RTS
                    tst.w    (BILLOS)-VARS(a2)
                    bne.w    RTS
                    tst.w    (BILLAC)-VARS(a2)
                    beq.w    RTS
                    move.w   #$FE,(XLEVEL)-VARS(a2)
                    move.w   #$FE,(MSNRFL)-VARS(a2)
                    clr.w    (BILLLF)-VARS(a2)
                    bra.w    MSCOMP

COMPM3:             lea      (lbB002658)-VARS(a2),a4
                    andi.w   #1,(LOADED)-VARS(a2)
                    beq.w    COMPZZZ
                    lea      (lbB002664)-VARS(a2),a4
COMPZZZ:            moveq    #4-1,d2
COMP30:             tst.b    (a4)
                    bne.w    RTS
                    addq.l   #3,a4
                    dbra     d2,COMP30
                    bra.w    MSCOMP

CHKJWL:             bsr.w    RND
                    andi.w   #3,d0
                    bne.w    RTS
                    lea      (JWLDT1)-VARS(a2),a5
                    bsr.w    RND
                    andi.w   #1,d0
                    bne.w    RTS
                    lea      (JWLDT2)-VARS(a2),a5
                    rts

; castle 1
OBJTBL0:            dc.b     $00,$00,$00,$08,$57,$8E,$00
                    dc.b     $00,$00,$00,$04,$04,$0F,$00
                    dc.b     $00,$00,$00,$07,$3A,$81,$00
                    dc.b     $00,$00,$00,$07,$2A,$81,$00
                    dc.b     $00,$00,$00,$07,$4C,$9A,$00
                    dc.b     $00,$00,$00,$06,$52,$A1,$00
                    dc.b     $00,$00,$00,$06,$16,$A2,$00
                    dc.b     $00,$00,$00,$01,$35,$9A,$00
                    dc.b     $00,$00,$00,$01,$45,$85,$00
                    dc.b     $00,$00,$00,$01,$05,$8E,$00
                    dc.b     $00,$00,$00,$01,$06,$5E,$00
                    dc.b     $00,$00,$00,$01,$08,$5E,$00
                    dc.b     $00,$00,$00,$01,$0A,$5E,$00
                    dc.b     $00,$00,$00,$01,$0C,$5E,$00
                    dc.b     $00,$00,$00,$01,$07,$51,$00
                    dc.b     $00,$00,$00,$01,$25,$0C,$00
                    dc.b     $00,$00,$00,$01,$35,$05,$00
                    dc.b     $00,$00,$00,$07,$24,$08,$00
                    dc.b     $00,$00,$00,$07,$1E,$05,$00
                    dc.b     $00,$00,$00,$07,$3D,$11,$00
                    dc.b     $00,$00,$00,$07,$4E,$05,$00
                    dc.b     $00,$00,$00,$07,$37,$3D,$00
                    dc.b     $00,$00,$00,$07,$1A,$29,$01
                    dc.b     $00,$00,$00,$07,$12,$15,$01
                    dc.b     $00,$00,$00,$07,$3E,$06,$01
                    dc.b     $00,$00,$00,$07,$4D,$07,$01
                    dc.b     $00,$00,$00,$07,$12,$15,$01
                    dc.b     $00,$00,$00,$07,$3E,$06,$01
                    dc.b     $00,$00,$00,$07,$4D,$07,$01
                    dc.b     $00,$00,$00,$07,$1A,$8D,$01
                    dc.b     $00,$00,$00,$07,$21,$8C,$01
                    dc.b     $00,$00,$00,$04,$2D,$76,$01
                    dc.b     $00,$00,$00,$07,$43,$58,$01
                    dc.b     $00,$00,$00,$06,$25,$86,$01
                    dc.b     $00,$00,$00,$08,$22,$8F,$01
                    dc.b     $00,$00,$00,$06,$11,$74,$01
                    dc.b     $00,$00,$00,$06,$09,$7A,$01
                    dc.b     $00,$00,$00,$06,$41,$58,$01
                    dc.b     $00,$00,$00,$01,$49,$25,$01
                    dc.b     $00,$00,$00,$02,$49,$1F,$01
                    dc.b     $00,$00,$00,$06,$5A,$64,$01
                    dc.b     $00,$00,$00,$04,$2B,$3B,$01
                    dc.b     $00,$00,$00,$04,$32,$4B,$01
                    dc.b     $00,$00,$00,$04,$49,$22,$01
                    dc.b     $00,$00,$00,$04,$5A,$0C,$01
                    dc.b     $00,$00,$00,$04,$51,$6C,$01
                    dc.b     $00,$00,$00,$07,$1E,$47,$01
                    dc.b     $00,$00,$00,$04,$07,$43,$01
                    dc.b     $00,$00,$00,$07,$0D,$3D,$01
                    dc.b     $00,$00,$00,$07,$0D,$45,$01
                    dc.b     $00,$00,$00,$07,$08,$45,$01
                    dc.b     $00,$00,$00,$07,$0D,$56,$01
                    dc.b     $00,$00,$00,$02,$21,$4A,$01
                    dc.b     $00,$00,$00,$06,$35,$4B,$01
                    dc.b     $00,$00,$00,$06,$3D,$18,$01
                    dc.b     $00,$00,$00,$06,$5A,$42,$01
                    dc.b     $00,$00,$00,$06,$59,$9F,$01
                    dc.b     $00,$00,$00,$06,$41,$58,$01
                    dc.b     $00,$00,$00,$07,$12,$1C,$01
                    dc.b     $00,$00,$00,$07,$3A,$05,$01
                    dc.b     $00,$00,$00,$01,$3A,$24,$02
                    dc.b     $00,$00,$00,$03,$02,$36,$02
                    dc.b     $00,$00,$00,$06,$4D,$12,$02
                    dc.b     $00,$00,$00,$07,$4D,$38,$02
                    dc.b     $00,$00,$00,$08,$33,$04,$02
                    dc.b     $00,$00,$00,$04,$05,$39,$02
                    dc.b     $00,$00,$00,$04,$08,$1C,$02
                    dc.b     $00,$00,$00,$04,$49,$11,$02
                    dc.b     $00,$00,$00,$04,$4A,$14,$02
                    dc.b     $00,$00,$00,$04,$09,$50,$02
                    dc.b     $00,$00,$00,$04,$56,$25,$02
                    dc.b     $00,$00,$00,$04,$36,$79,$02
                    dc.b     $00,$00,$00,$06,$38,$A2,$02
                    dc.b     $00,$00,$00,$06,$55,$A2,$02
                    dc.b     $00,$00,$00,$01,$15,$51,$02
                    dc.b     $00,$00,$00,$01,$42,$64,$02
                    dc.b     $00,$00,$00,$02,$5A,$60,$02
                    dc.b     $00,$00,$00,$07,$42,$74,$02
                    dc.b     $00,$00,$00,$07,$40,$38,$02
                    dc.b     $00,$00,$00,$07,$11,$71,$02
                    dc.b     $00,$00,$00,$07,$14,$54,$02
                    dc.b     $00,$00,$00,$07,$0A,$69,$02
                    dc.b     $00,$00,$00,$07,$27,$3D,$02
                    dc.b     $00,$00,$00,$07,$4C,$28,$02
                    dc.b     $00,$00,$00,$07,$16,$08,$02
                    dc.b     $00,$00,$00,$01,$02,$5D,$02
                    dc.b     $00,$00,$00,$01,$1D,$59,$02
                    dc.b     $00,$00,$00,$01,$2E,$38,$02
                    dc.b     $00,$00,$00,$01,$59,$3D,$02
                    dc.b     $00,$00,$00,$01,$57,$75,$02
                    dc.b     $00,$00,$00,$08,$06,$08,$03
                    dc.b     $00,$00,$00,$01,$24,$7D,$03
                    dc.b     $00,$00,$00,$01,$52,$05,$03
                    dc.b     $00,$00,$00,$01,$5A,$3D,$03
                    dc.b     $00,$00,$00,$02,$1E,$05,$03
                    dc.b     $00,$00,$00,$02,$19,$05,$03
                    dc.b     $00,$00,$00,$02,$07,$1D,$03
                    dc.b     $00,$00,$00,$07,$47,$8A,$03
                    dc.b     $00,$00,$00,$07,$46,$71,$03
                    dc.b     $00,$00,$00,$07,$46,$90,$03
                    dc.b     $00,$00,$00,$07,$3D,$98,$03
                    dc.b     $00,$00,$00,$04,$5A,$0C,$03
                    dc.b     $00,$00,$00,$04,$5A,$29,$03
                    dc.b     $00,$00,$00,$04,$5A,$84,$03
                    dc.b     $00,$00,$00,$07,$23,$A1,$03
                    dc.b     $00,$00,$00,$07,$27,$A1,$03
                    dc.b     $00,$00,$00,$07,$2B,$A1,$03
                    dc.b     $00,$00,$00,$07,$1E,$13,$03
                    dc.b     $00,$00,$00,$07,$20,$12,$03
                    dc.b     $00,$00,$00,$07,$1D,$0F,$03
                    dc.b     $00,$00,$00,$07,$4D,$32,$03
                    dc.b     $00,$00,$00,$01,$49,$05,$03
                    dc.b     $FF,$FF,$FF,$FF,$FF,$FF,$FF
; castle 2
OBJTBL1:            dc.b     $00,$00,$00,$08,$1D,$0C,$00
                    dc.b     $00,$00,$00,$01,$57,$18,$00
                    dc.b     $00,$00,$00,$01,$42,$48,$00
                    dc.b     $00,$00,$00,$01,$44,$48,$00
                    dc.b     $00,$00,$00,$01,$02,$75,$00
                    dc.b     $00,$00,$00,$01,$02,$77,$00
                    dc.b     $00,$00,$00,$01,$07,$79,$00
                    dc.b     $00,$00,$00,$02,$15,$03,$00
                    dc.b     $00,$00,$00,$02,$1D,$28,$00
                    dc.b     $00,$00,$00,$02,$48,$14,$00
                    dc.b     $00,$00,$00,$02,$54,$21,$00
                    dc.b     $00,$00,$00,$02,$44,$32,$00
                    dc.b     $00,$00,$00,$02,$39,$45,$00
                    dc.b     $00,$00,$00,$04,$0D,$0B,$00
                    dc.b     $00,$00,$00,$04,$05,$4D,$00
                    dc.b     $00,$00,$00,$04,$2D,$49,$00
                    dc.b     $00,$00,$00,$04,$2A,$15,$00
                    dc.b     $00,$00,$00,$04,$17,$A0,$00
                    dc.b     $00,$00,$00,$04,$22,$3A,$00
                    dc.b     $00,$00,$00,$06,$54,$06,$00
                    dc.b     $00,$00,$00,$06,$4F,$6D,$00
                    dc.b     $00,$00,$00,$07,$18,$4D,$00
                    dc.b     $00,$00,$00,$07,$23,$28,$00
                    dc.b     $00,$00,$00,$07,$12,$74,$00
                    dc.b     $00,$00,$00,$07,$12,$76,$00
                    dc.b     $00,$00,$00,$07,$3F,$35,$00
                    dc.b     $00,$00,$00,$07,$51,$91,$00
                    dc.b     $00,$00,$00,$08,$4E,$48,$01
                    dc.b     $00,$00,$00,$07,$2E,$90,$01
                    dc.b     $00,$00,$00,$06,$19,$2B,$01
                    dc.b     $00,$00,$00,$07,$1B,$1E,$01
                    dc.b     $00,$00,$00,$04,$0A,$1B,$01
                    dc.b     $00,$00,$00,$04,$16,$81,$01
                    dc.b     $00,$00,$00,$07,$23,$9C,$01
                    dc.b     $00,$00,$00,$01,$56,$78,$01
                    dc.b     $00,$00,$00,$01,$56,$7B,$01
                    dc.b     $00,$00,$00,$07,$56,$80,$01
                    dc.b     $00,$00,$00,$07,$56,$6D,$01
                    dc.b     $00,$00,$00,$04,$3E,$21,$01
                    dc.b     $00,$00,$00,$06,$35,$3F,$01
                    dc.b     $00,$00,$00,$04,$06,$3F,$01
                    dc.b     $00,$00,$00,$01,$1C,$5D,$01
                    dc.b     $00,$00,$00,$07,$15,$61,$01
                    dc.b     $00,$00,$00,$04,$0C,$7D,$01
                    dc.b     $00,$00,$00,$04,$58,$11,$01
                    dc.b     $00,$00,$00,$02,$0E,$1C,$01
                    dc.b     $00,$00,$00,$02,$58,$22,$01
                    dc.b     $00,$00,$00,$02,$40,$4D,$01
                    dc.b     $00,$00,$00,$01,$51,$6B,$01
                    dc.b     $00,$00,$00,$08,$2C,$06,$02
                    dc.b     $00,$00,$00,$04,$09,$0C,$02
                    dc.b     $00,$00,$00,$04,$12,$A0,$02
                    dc.b     $00,$00,$00,$07,$39,$9C,$02
                    dc.b     $00,$00,$00,$07,$39,$A0,$02
                    dc.b     $00,$00,$00,$01,$33,$91,$02
                    dc.b     $00,$00,$00,$01,$35,$91,$02
                    dc.b     $00,$00,$00,$06,$35,$89,$02
                    dc.b     $00,$00,$00,$04,$50,$9D,$02
                    dc.b     $00,$00,$00,$01,$42,$6B,$02
                    dc.b     $00,$00,$00,$02,$5C,$3D,$02
                    dc.b     $00,$00,$00,$06,$2D,$14,$02
                    dc.b     $00,$00,$00,$02,$25,$50,$02
                    dc.b     $00,$00,$00,$01,$06,$41,$02
                    dc.b     $00,$00,$00,$04,$0C,$5D,$02
                    dc.b     $00,$00,$00,$02,$18,$55,$02
                    dc.b     $00,$00,$00,$01,$14,$71,$02
                    dc.b     $00,$00,$00,$07,$0B,$29,$02
                    dc.b     $00,$00,$00,$04,$11,$1F,$02
                    dc.b     $00,$00,$00,$01,$0D,$20,$02
                    dc.b     $00,$00,$00,$07,$1D,$0C,$02
                    dc.b     $00,$00,$00,$04,$2E,$7D,$02
                    dc.b     $00,$00,$00,$07,$28,$7C,$02
                    dc.b     $00,$00,$00,$07,$59,$9B,$02
                    dc.b     $00,$00,$00,$08,$2D,$3D,$03
                    dc.b     $00,$00,$00,$01,$20,$91,$03
                    dc.b     $00,$00,$00,$01,$34,$99,$03
                    dc.b     $00,$00,$00,$01,$4A,$5D,$03
                    dc.b     $00,$00,$00,$01,$38,$49,$03
                    dc.b     $00,$00,$00,$01,$02,$26,$03
                    dc.b     $00,$00,$00,$02,$50,$61,$03
                    dc.b     $00,$00,$00,$02,$08,$1D,$03
                    dc.b     $00,$00,$00,$02,$02,$28,$03
                    dc.b     $00,$00,$00,$04,$50,$55,$03
                    dc.b     $00,$00,$00,$04,$18,$0C,$03
                    dc.b     $00,$00,$00,$04,$10,$1D,$03
                    dc.b     $00,$00,$00,$04,$0C,$29,$03
                    dc.b     $00,$00,$00,$04,$17,$3D,$03
                    dc.b     $00,$00,$00,$04,$08,$85,$03
                    dc.b     $00,$00,$00,$06,$53,$31,$03
                    dc.b     $00,$00,$00,$06,$05,$05,$03
                    dc.b     $00,$00,$00,$07,$06,$73,$03
                    dc.b     $00,$00,$00,$07,$08,$73,$03
                    dc.b     $00,$00,$00,$07,$0E,$73,$03
                    dc.b     $00,$00,$00,$07,$10,$73,$03
                    dc.b     $00,$00,$00,$07,$16,$73,$03
                    dc.b     $00,$00,$00,$07,$18,$73,$03
                    dc.b     $00,$00,$00,$07,$19,$15,$03
                    dc.b     $00,$00,$00,$07,$02,$2A,$03
                    dc.b     $FF,$FF,$FF,$FF,$FF,$FF,$FF
                    even

NONME:              movea.l  (NMELSTPTR)-VARS(a2),a0
                    move.w   #256-1,d0
NONME0:             st.b     (a0)+
                    dbra     d0,NONME0
                    clr.w    (NMEMAX)-VARS(a2)
                    rts

INTNME:             tst.w    (NMECHT)-VARS(a2)
                    bne.w    NONME
                    movea.l  (NMELSTPTR)-VARS(a2),a6
INTNM0:             cmpi.b   #$FF,(a6)
                    beq.w    RTS
                    bsr.w    PNME
                    lea      (4,a6),a6
                    bra.w    INTNM0

ENME:               move.b   (a6),d0
                    move.b   (1,a6),d1
                    move.l   a6,-(sp)
                    bsr.w    EBLOCK
                    movea.l  (sp)+,a6
                    rts

ENMEA:              move.l   a5,-(sp)
                    move.b   (a6),d0
                    move.b   (1,a6),d1
                    move.l   a6,-(sp)
                    bsr.w    EBLOCKA
                    movea.l  (sp)+,a6
                    movea.l  (sp)+,a5
                    rts

PNME:               move.b   (2,a6),d0
                    andi.l   #$FF,d0
                    lea      (NMECHR)-VARS(a2),a5
                    mulu.w   #6,d0
                    adda.l   d0,a5
PNME0:              move.b   (a6),d0
                    move.b   (1,a6),d1
                    move.l   a6,-(sp)
                    bsr.w    PBLOCK
                    movea.l  (sp)+,a6
                    rts

PNMEA:              move.l   a5,-(sp)
                    move.b   (2,a6),d0
                    eori.w   #4,d0
                    andi.l   #$FF,d0
                    lea      (NMECHR)-VARS(a2),a5
                    mulu.w   #6,d0
                    adda.l   d0,a5
PNMEA0:             move.b   (a6),d0
                    move.b   (1,a6),d1
                    move.l   a6,-(sp)
                    bsr.w    PBLOCKA
                    movea.l  (sp)+,a6
                    movea.l  (sp)+,a5
                    rts

NMECHR:             dc.b     $BE,$BF,$C0,$C1,$C2,$C3
                    dc.b     $C4,$C5,$C0,$C1,$C2,$C3
                    dc.b     $C6,$C7,$C8,$C9,$CA,$CB
                    dc.b     $C6,$C7,$C8,$C9,$CC,$CD
                    dc.b     $CE,$CF,$D0,$D1,$D2,$D3
                    dc.b     $CE,$D4,$D0,$D5,$D2,$D6
                    dc.b     $D7,$D8,$D9,$DA,$DB,$DC
                    dc.b     $DD,$D8,$DE,$DA,$DF,$DC

NME:                movea.l  (NMELSTPTR)-VARS(a2),a6
NME1:               btst     #7,(3,a6)
                    beq.w    NME3
                    move.b   (a6),d0
                    cmp.b    #255,d0
                    beq.w    RTS
                    andi.w   #$FF,d0
                    move.w   d0,(NMEOLX)-VARS(a2)
                    addq.w   #7,d0
                    sub.w    (SCRX)-VARS(a2),d0
                    cmp.w    #30,d0
                    bge.w    NME3
                    move.b   (1,a6),d0
                    andi.w   #$FF,d0
                    move.w   d0,(NMEOLY)-VARS(a2)
                    addq.w   #8,d0
                    sub.w    (SCRY)-VARS(a2),d0
                    cmp.w    #39,d0
                    bge.w    NME3
                    clr.w    (HITFLG)-VARS(a2)
                    bsr.w    MOVNME
                    tst.w    (HITFLG)-VARS(a2)
                    beq.w    NME3
                    move.w   (HITS)-VARS(a2),d0
                    moveq    #1,d1
                    move.w   #4,ccr
                    abcd     d1,d0
                    move.w   d0,(HITS)-VARS(a2)
NME3:               lea      (4,a6),a6
                    bra.w    NME1

CNME:               move.b   (a6),d0
                    move.b   (1,a6),d1
                    bsr.w    CLCMAP
                    lea      (NMEBFR)-VARS(a2),a5
                    moveq    #3-1,d5
CNME0:              move.b   (a0)+,d2
                    bsr.w    CNMEBL
                    move.b   d2,(a5)+
                    addq.w   #1,d0
                    move.b   (a0)+,d2
                    bsr.w    CNMEBL
                    move.b   d2,(a5)+
                    subq.w   #1,d0
                    addq.w   #1,d1
                    lea      (96-2,a0),a0
                    dbra     d5,CNME0
                    lea      (NMEBFR)-VARS(a2),a5
                    moveq    #6-1,d5
                    moveq    #0,d0
CNME1:              or.b     (a5)+,d0
                    dbra     d5,CNME1
                    tst.w    d0
                    rts

CNMEBL:             cmp.b    #$80,d2
                    bcs.w    RTS
                    cmp.b    #$BA,d2
                    bcs.w    CNMBL1
                    cmp.b    #$E0,d2
                    bcc.w    RTS
                    cmp.b    #$FC,d2
                    bcc.w    RTS
CNMBL0:             moveq    #1,d2
                    rts

CNMBL1:             move.b   d0,d2
                    andi.w   #$FF,d2
                    sub.w    (YOUX)-VARS(a2),d2
                    cmp.w    #2,d2
                    bcc.w    CNMBL0
                    move.b   d1,d2
                    andi.w   #$FF,d2
                    sub.w    (YOUY)-VARS(a2),d2
                    cmp.w    #3,d2
                    bcc.w    CNMBL0
                    moveq    #1,d2
                    move.w   d2,(HITFLG)-VARS(a2)
                    rts

NMEBFR:             dcb.b    6,0

MOVNME:             eori.b   #1,(3,a6)
                    btst     #0,(3,a6)
                    bne.w    MVNME9
                    eori.b   #2,(3,a6)
                    btst     #1,(3,a6)
                    beq.w    RTS
                    eori.w   #1,(2,a6)
                    rts

MVNME9:             btst     #4,(3,a6)
                    beq.w    MVNME5
MVNME3:             move.w   (YOUX)-VARS(a2),d0
                    cmp.b    (a6),d0
                    beq.w    MVNME5
                    bcc.w    MVNME4
                    subq.b   #1,(a6)
                    moveq    #6,d0
                    bra.w    MVNME1

MVNME4:             addq.b   #1,(a6)
                    moveq    #4,d0
                    bra.w    MVNME1

MVNME5:             move.w   (YOUY)-VARS(a2),d0
                    cmp.b    (1,a6),d0
                    beq.w    MVNME3
                    bcs.w    MVNME6
                    addq.b   #1,(1,a6)
                    moveq    #2,d0
                    bra.w    MVNME1

MVNME6:             subq.b   #1,(1,a6)
                    moveq    #0,d0
MVNME1:             move.w   d0,-(sp)
                    move.l   a6,-(sp)
                    move.w   (NMEOLX)-VARS(a2),d0
                    move.w   (NMEOLY)-VARS(a2),d1
                    bsr.w    EBLOCK
                    movea.l  (sp)+,a6
                    bsr.w    CNME
                    bne.w    MVNME2
                    move.w   (sp)+,d0
                    andi.b   #1,(2,a6)
                    eori.b   #1,(2,a6)
                    or.b     d0,(2,a6)
                    bra.w    PNME

MVNME2:             move.w   (sp)+,d0
                    move.w   (NMEOLX)-VARS(a2),d0
                    move.w   (NMEOLY)-VARS(a2),d1
                    move.b   d0,(a6)
                    move.b   d1,(1,a6)
                    eori.b   #$10,(3,a6)
                    bra.w    PNME

GIBLL9:             tst.w    (BILLAC)-VARS(a2)
                    beq.w    RTS
                    subq.w   #1,(BILLOS)-VARS(a2)
                    cmpi.w   #-128,(BILLOS)-VARS(a2)
                    bne.w    RTS
                    bsr.w    EBILL
                    bra.w    INTBIL

GIBILL:             addq.w   #1,(BILLXX)-VARS(a2)
                    move.w   (BILLXX)-VARS(a2),d0
                    andi.w   #1,d0
                    bne.w    RTS
                    move.w   (LEVEL)-VARS(a2),d0
                    cmp.w    (BILLLV)-VARS(a2),d0
                    bne.w    RTS
                    cmpi.w   #255,(BILLLV)-VARS(a2)
                    beq.w    RTS
                    tst.w    (BILLCT)-VARS(a2)
                    beq.w    GIBLL0
                    subq.w   #1,(BILLCT)-VARS(a2)
                    tst.w    (BILLCT)
                    bne.w    GIBLL0
                    move.w   #1,(BILLDR)-VARS(a2)
GIBLL0:             move.w   (SCRX)-VARS(a2),d3
                    move.w   (BILLX)-VARS(a2),d0
                    move.w   d0,(BILLOX)-VARS(a2)
                    addq.w   #7,d0
                    sub.w    d3,d0
                    cmp.w    #30,d0
                    bcc.w    GIBLL9
                    move.w   (SCRY)-VARS(a2),d3
                    move.w   (BILLY)-VARS(a2),d0
                    move.w   d0,(BILLOY)-VARS(a2)
                    addq.w   #8,d0
                    sub.w    d3,d0
                    cmp.w    #39,d0
                    bcc.w    GIBLL9
                    clr.w    (BILLOS)-VARS(a2)
                    move.w   #1,(BILLAC)-VARS(a2)
                    move.w   (BILLFR),(BILLOF)-VARS(a2)
                    bchg     #0,(BILLFL+1)-VARS(a2)
                    btst     #0,(BILLFL+1)-VARS(a2)
                    bne.w    MVBLL9
                    bchg     #1,(BILLFL+1)-VARS(a2)
                    btst     #1,(BILLFL+1)-VARS(a2)
                    eori.w   #1,(BILLFR)-VARS(a2)
                    rts

MVBLL9:             move.w   (BILLDR)-VARS(a2),d3
                    btst     #4,(BILLFL+1)-VARS(a2)
                    beq.w    MVBLL5
MVBLL3:             move.w   (YOUX)-VARS(a2),d7
                    cmp.w    (BILLX)-VARS(a2),d7
                    beq.w    MVBLL5
                    bcc.w    MVBLL4
                    move.w   (BILLDR)-VARS(a2),d7
                    sub.w    d7,(BILLX)-VARS(a2)
                    moveq    #6,d2
                    moveq    #4,d3
                    bra.w    MVBLL1

MVBLL4:             move.w   (BILLDR)-VARS(a2),d7
                    add.w    d7,(BILLX)-VARS(a2)
                    moveq    #4,d2
                    moveq    #6,d3
                    bra.w    MVBLL1

MVBLL5:             move.w   (YOUY)-VARS(a2),d7
                    cmp.w    (BILLY)-VARS(a2),d7
                    beq.w    MVBLL3
                    bcc.w    MVBLL6
                    move.w   (BILLDR)-VARS(a2),d7
                    sub.w    d7,(BILLY)-VARS(a2)
                    moveq    #0,d2
                    moveq    #2,d3
                    bra.w    MVBLL1

MVBLL6:             move.w   (BILLDR)-VARS(a2),d7
                    add.w    d7,(BILLY)-VARS(a2)
                    moveq    #2,d2
                    moveq    #0,d3
MVBLL1:             btst     #7,(BILLDR+1)-VARS(a2)
                    beq.w    MVBL10
                    move.w   d2,d3
MVBL10:             andi.w   #1,(BILLFR)-VARS(a2)
                    or.w     d3,(BILLFR)-VARS(a2)
                    move.w   (BILLOX)-VARS(a2),d0
                    move.w   (BILLOY)-VARS(a2),d1
                    bsr.w    EBLOCK
                    move.w   (BILLX)-VARS(a2),d0
                    cmp.b    #$A5,d0
                    bcc.w    MVBLBOT
                    bsr.w    CBILL
                    beq.w    PBILL
MVBLBOT:            move.w   (BILLOF)-VARS(a2),(BILLFR)-VARS(a2)
                    move.w   (BILLOX)-VARS(a2),(BILLX)-VARS(a2)
                    move.w   (BILLOY)-VARS(a2),(BILLY)-VARS(a2)
                    bchg     #4,(BILLFL+1)
                    bra.w    PBILL

EBILL:              cmpi.w   #$FF,(BILLLV)-VARS(a2)
                    beq.w    RTS
                    move.w   (BILLX)-VARS(a2),d0
                    move.w   (BILLY)-VARS(a2),d1
                    bra.w    EBLOCK

BLLCHR:             dc.b     $88,$89,$8A,$8B,$E4,$E5,$88,$89,$8A,$8B,$E6,$E7
                    dc.b     $E0,$E1,$82,$83,$84,$85,$E2,$E3,$82,$83,$84,$85
                    dc.b     $E8,$9A,$E9,$9C,$EA,$9E,$EB,$9A,$EC,$9C,$ED,$9E
                    dc.b     $90,$EE,$92,$EF,$94,$F0,$90,$F1,$92,$F2,$94,$F3

PBILL:              cmpi.w   #$FF,(BILLLV)-VARS(a2)
                    beq.w    RTS
                    move.w   (BILLFR)-VARS(a2),d0
                    andi.l   #$F,d0
                    mulu.w   #6,d0
                    lea      (BLLCHR)-VARS(a2),a5
                    adda.l   d0,a5
                    move.w   (BILLX)-VARS(a2),d0
                    move.w   (BILLY)-VARS(a2),d1
                    bra.w    PBLOCK

CBILL:              cmpi.w   #$FF,(BILLLV)-VARS(a2)
                    beq.w    RTS
                    move.w   (BILLLV)-VARS(a2),d0
                    cmp.w    (LEVEL)-VARS(a2),d0
                    beq.w    CBILL9
                    moveq    #0,d0
                    tst.w    d0
                    rts

CBILL9:             move.w   (BILLX)-VARS(a2),d0
                    move.w   (BILLY)-VARS(a2),d1
                    bsr.w    CLCMAP
                    lea      (YOUBFR)-VARS(a2),a3
                    moveq    #3-1,d2
CBILL0:             move.b   (a0)+,(a3)+
                    move.b   (a0)+,(a3)+
                    lea      (96-2,a0),a0
                    dbra     d2,CBILL0
                    lea      (YOUBFR)-VARS(a2),a4
                    moveq    #0,d0
                    moveq    #6-1,d2
CBILL1:             or.b     (a4)+,d0
                    dbra     d2,CBILL1
                    tst.b    d0
                    rts

INTBIL:             move.w   (BLSTLV)-VARS(a2),(BILLLV)-VARS(a2)
                    cmpi.w   #$FF,(BILLLV)-VARS(a2)
                    beq.w    RTS
INTBL2:             bsr.w    RND
                    andi.l   #3,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    move.w   (BLSTLV)-VARS(a2),d1
                    andi.l   #$FF,d1
                    add.w    d1,d1
                    add.w    d1,d1
                    lea      (BILTBL)-VARS(a2),a0
                    tst.w    (LOADED)-VARS(a2)
                    beq.w    INTBILC2
                    lea      (BILTBL2)-VARS(a2),a0
INTBILC2:           adda.l   d1,a0
                    movea.l  (a0),a6
                    adda.l   d0,a6
                    move.w   (SCRX)-VARS(a2),d3
                    move.b   (a6),d4
                    move.b   (1,a6),d5
                    move.b   d4,d0
                    sub.b    d3,d0
                    addq.w   #1,d0
                    cmp.b    #21,d0
                    bcc.w    INTBL1
                    move.w   (SCRY)-VARS(a2),d3
                    move.b   d5,d0
                    sub.b    d3,d0
                    addq.w   #2,d0
                    cmp.b    #26,d0
                    bcs.w    INTBL2
INTBL1:             andi.w   #$FF,d4
                    move.w   d4,(BILLX)-VARS(a2)
                    andi.w   #$FF,d5
                    move.w   d5,(BILLY)-VARS(a2)
                    move.b   (2,a6),d0
                    andi.w   #$FF,d0
                    move.w   d0,(CELLX)-VARS(a2)
                    move.b   (3,a6),d1
                    andi.w   #$FF,d1
                    move.w   d1,(CELLY)-VARS(a2)
                    clr.w    (BILLAC)-VARS(a2)
                    clr.w    (BILLOS)-VARS(a2)
                    move.w   (LEVEL)-VARS(a2),d7
                    cmp.w    (BILLLV)-VARS(a2),d7
                    bne.w    RTS
                    bsr.w    CLCMAP
                    moveq    #4-1,d2
INTBL0:             move.b   #$75,(a0)
                    lea      (96,a0),a0
                    dbra     d2,INTBL0
                    bra.w    PBILL

; castle 1
BILTBL2:            dc.l     BILTB00
                    dc.l     BILTB00
                    dc.l     BILTB20
                    dc.l     BILTB30
BILTB20:            dc.b     $24,$10,$20,$10,$34,$9C,$2C,$98,$4D,$14,$58,$14,$4D,$14,$58,$14
BILTB00:            dc.b     $08,$0C,$0C,$10,$3D,$46,$48,$48,$3C,$74,$44,$74,$3C,$74,$44,$74
BILTB30:            dc.b     $30,$9C,$38,$9C,$45,$84,$54,$8C,$22,$7B,$2C,$6C,$29,$40,$30,$3C

; castle 2
BILTBL:             dc.l     BILTB0
                    dc.l     BILTB0
                    dc.l     BILTB2
                    dc.l     BILTB3
BILTB2:             dc.b     $55,$9F,$54,$94,$5A,$6B,$54,$68,$59,$28,$54,$2C,$30,$4F,$34,$60
BILTB0:             dc.b     $08,$62,$0F,$60,$0A,$16,$10,$18,$20,$08,$18,$08,$58,$3C,$50,$44
BILTB3:             dc.b     $06,$4D,$10,$44,$3D,$A0,$44,$9C,$20,$04,$23,$04,$23,$83,$20,$7C

DODIE:              lea      (DIELST)-VARS(a2),a6
DODIE0:             cmpi.b   #$FF,(a6)
                    beq.w    RTS
                    tst.b    (2,a6)
                    beq.w    DODIE1
                    move.b   (a6),d0
                    move.b   (1,a6),d1
                    lea      (DIECHR)-VARS(a2),a5
                    btst     #0,(2,a6)
                    beq.w    DODIE2
                    lea      (6,a5),a5
DODIE2:             subq.b   #1,(2,a6)
                    tst.b    (2,a6)
                    bne.w    DODIE3
                    lea      (EDATA)-VARS(a2),a5
DODIE3:             bsr.w    PBLOCK
DODIE1:             lea      (3,a6),a6
                    bra.w    DODIE0

DIELST:             dc.b     0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,$FF
DIECHR:             dc.b     $F4,$F5,$F6,$F7,$F8,$F9,$FA,$FB,$FC,$FD,$FE,$FF

ADDDIE:             move.l   a6,-(sp)
                    lea      (DIELST)-VARS(a2),a6
ADDIE0:             cmpi.b   #$FF,(a6)
                    beq.w    ADIERTS
                    tst.b    (2,a6)
                    bne.w    ADDIE1
                    move.b   d4,(a6)
                    move.b   d5,(1,a6)
                    move.b   #3,(2,a6)
ADIERTS:            movea.l  (sp)+,a6
                    rts

ADDIE1:             lea      (3,a6),a6
                    bra.w    ADDIE0

BORN:               tst.w    (NMEMAX)-VARS(a2)
                    beq.w    RTS
                    subq.w   #1,(BRNDLY)-VARS(a2)
                    tst.w    (BRNDLY)-VARS(a2)
                    bne.w    RTS
                    move.w   #5,(BRNDLY)-VARS(a2)
BORN0:              bsr.w    RND
                    andi.l   #$FF,d0
                    move.w   d0,d4
                    move.w   (NMEMAX)-VARS(a2),d0
                    cmp.w    d4,d0
                    bcs.w    BORN0
                    add.w    d4,d4
                    add.w    d4,d4
                    movea.l  (NMELSTPTR)-VARS(a2),a6
                    adda.l   d4,a6
                    btst     #7,(3,a6)
                    bne.w    RTS
                    move.b   (a6),d4
                    move.b   (1,a6),d5
                    move.w   (SCRX)-VARS(a2),d2
                    move.w   (SCRY)-VARS(a2),d3
                    move.b   d4,d0
                    sub.b    d2,d0
                    addq.b   #2,d0
                    cmp.b    #$12,d0
                    bcc.w    BORN1
                    move.b   d5,d0
                    sub.b    d3,d0
                    addq.b   #3,d0
                    cmp.b    #$1B,d0
                    bcs.w    RTS
BORN1:              bsr.w    CNME
                    bne.w    RTS
                    bsr.w    RND
                    ori.b    #$E0,d0
                    move.b   d0,(3,a6)
                    bsr.w    RND
                    andi.b   #7,d0
                    move.b   d0,(2,a6)
                    bra.w    PNME

SHTCMD:             cmp.b    #$48,d0
                    bcs.w    SHTCU1
                    cmp.b    #$4A,d0
                    bcs.w    SHTCD1
                    cmp.b    #$4C,d0
                    bcs.w    SHTCU0
                    cmp.b    #$50,d0
                    bcs.w    SHTCU1
                    cmp.b    #$52,d0
                    bcs.w    SHTCD0
SHTCD1:             suba.l   #$60,a0
                    cmpi.b   #$50,(a0)
                    beq.w    SHTCD0
                    cmpi.b   #$51,(a0)
                    bne.w    SHTCD1
SHTCD0:             cmpi.b   #$51,(a0)
                    bne.w    SHTCD2
                    subq.l   #1,a0
SHTCD2:             lea      (CMDAT0)-VARS(a2),a5
SHTCM0:             moveq    #4-1,d2
SHTCM1:             move.b   (a5)+,d0
                    move.b   d0,(a0)+
                    move.b   (a5)+,d0
                    move.b   d0,(a0)+
                    lea      ($5E,a0),a0
                    dbra     d2,SHTCM1
                    move.l   a6,-(sp)
                    bsr.w    PBAK
                    tst.w    (MSFLG)-VARS(a2)
                    beq.w    WOTNOMESS
                    moveq    #0,d4
                    moveq    #11,d5
                    moveq    #16,d2
                    moveq    #4,d3
                    bsr.w    WINDOW
                    lea      (YHS),a1
                    moveq    #0,d4
                    moveq    #12,d5
                    bsr.w    WSPRNT
                    lea      (SHTCMS)-VARS(a2),a1
                    moveq    #3,d4
                    moveq    #13,d5
                    bsr.w    WSPRNT
                    bsr.w    WAIT
WOTNOMESS:          bsr.w    ADD5
                    movea.l  (sp)+,a6
                    bra.w    DOBUL1

SHTCU1:             suba.l   #$60,a0
                    cmpi.b   #$4A,(a0)
                    beq.w    SHTCU0
                    cmpi.b   #$7E,(a0)
                    beq.w    SHTCU0
                    cmpi.b   #$4B,(a0)
                    bne.w    SHTCU1
SHTCU0:             cmpi.b   #$4A,(a0)
                    beq.w    SHTCU2
                    subq.l   #1,a0
SHTCU2:             lea      (CMDAT1)-VARS(a2),a5
                    bra.w    SHTCM0

CMDAT0:             dc.b     $1C,$1D,$42,$43,$1A,$1A,$1A,$1A
CMDAT1:             dc.b     $1A,$1A,$1A,$1A,$44,$45,$1E,$1F
SHTCMS:             dc.b     'AN OFFICER',$FF
                    even

TTANIM:             tst.w    (TTAFLG)-VARS(a2)
                    beq.w    RTS
                    subq.w   #1,(TTADLY)-VARS(a2)
                    tst.w    (TTADLY)-VARS(a2)
                    bne.w    RTS
                    move.w   #6,(TTADLY)-VARS(a2)
                    lea      (FAKEN0)-VARS(a2),a6
                    bsr.w    ENMEA
                    movea.l  a6,a5
                    lea      (FAKENM)-VARS(a2),a6
                    bsr.w    ENMEA
                    move.w   (TTADIR)-VARS(a2),d0
                    add.w    d0,(TTAPOS)-VARS(a2)
                    move.w   (TTAPOS)-VARS(a2),d0
                    move.b   d0,(a6)
                    moveq    #14,d1
                    sub.w    d0,d1
                    move.b   d1,(a5)
                    subq.w   #1,(TTACNT)-VARS(a2)
                    tst.w    (TTACNT)-VARS(a2)
                    bne.w    TTANM0
                    move.w   #8,(TTACNT)-VARS(a2)
                    neg.w    (TTADIR)-VARS(a2)
                    eori.b   #2,(2,a6)
                    eori.b   #2,(2,a5)
TTANM0:             bsr.w    PNMEA
                    eori.b   #1,(2,a6)
                    move.b   (2,a6),d0
                    eori.b   #2,d0
                    move.b   d0,(2,a5)
                    movea.l  a5,a6
                    bra.w    PNMEA

FAKENM:             dc.b     4,9,4,$80
FAKEN0:             dc.b     11,13,6,$80

GETDIF:             bsr.w    BLACK
                    bsr.w    CLS
                    lea      (GTDFS0)-VARS(a2),a1
                    moveq    #5,d4
                    moveq    #11,d5
                    bsr.w    WSPRNT
                    lea      (GTDFS1)-VARS(a2),a1
                    moveq    #4,d4
                    moveq    #13,d5
                    bsr.w    WSPRNT
                    bsr.w    SETCOL
                    clr.w    (DIFLVL)-VARS(a2)
GTDF0:              move.w   (DIFLVL)-VARS(a2),d0
                    addi.w   #$1C,d0
                    moveq    #11,d4
                    moveq    #13,d5
                    bsr.w    WPRT
                    moveq    #10-1,d2
GTDF9:              bsr.w    FRAME
                    dbra     d2,GTDF9
                    bsr.w    KSCAN
                    btst     #4,(JOYVAL)-VARS(a2)
                    bne.w    RTS
                    btst     #2,(JOYVAL)-VARS(a2)
                    beq.w    GTDF1
                    tst.w    (DIFLVL)-VARS(a2)
                    beq.w    GTDF0
                    subq.w   #1,(DIFLVL)-VARS(a2)
                    bra.w    GTDF0

GTDF1:              btst     #3,(JOYVAL)-VARS(a2)
                    beq.w    GTDF0
                    cmpi.w   #3,(DIFLVL)-VARS(a2)
                    beq.w    GTDF0
                    addq.w   #1,(DIFLVL)-VARS(a2)
                    bra.w    GTDF0

GTDFS1:             dc.b     'LEVEL',$FF
GTDFS0:             dc.b     'SELECT',$FF
                    even

INTDIF:             tst.w    (MSNRFL)-VARS(a2)
                    bne.b    INTDF0
                    tst.w    (BILLLF)-VARS(a2)
                    beq.b    INTDF0
                    clr.w    (BILLLF)-VARS(a2)
                    clr.w    (BILLFR)-VARS(a2)
                    clr.w    (BILLOS)-VARS(a2)
                    move.w   #1,(BILLAC)-VARS(a2)
                    move.w   #8,(BILLX)-VARS(a2)
                    move.w   #151,(BILLY)-VARS(a2)
                    move.w   (LEVEL)-VARS(a2),(BILLLV)-VARS(a2)
                    bra.w    PBILL

INTDF0:             move.w   (DIFLVL)-VARS(a2),d0
                    andi.l   #3,d0
                    lea      (DIFTBL)-VARS(a2),a0
                    adda.l   d0,a0
                    move.b   (a0),d0
                    move.w   d0,(BLSTLV)-VARS(a2)
                    bra.w    INTBIL

DIFTBL:             dc.b     0,2,3,$FF

ERADET:             move.w   (LEVEL)-VARS(a2),d0
                    andi.l   #3,d0
                    mulu.w   #3,d0
                    lea      (DETTBL)-VARS(a2),a0
                    andi.w   #1,(LOADED)-VARS(a2)
                    beq.b    ERADTZZZ
                    lea      (DETTBL2)-VARS(a2),a0
ERADTZZZ:           adda.l   d0,a0
                    move.b   (a0),d0
                    move.b   (1,a0),d1
                    tst.b    (2,a0)
                    beq.w    ERADT0
                    cmpi.w   #3,(DIFLVL)-VARS(a2)
                    beq.w    RTS
ERADT0:             bsr.w    CLCMAP
                    sf.b     (a0)
                    sf.b     (96,a0)
                    rts

MSCOMP:             clr.w    (HITS)-VARS(a2)
                    clr.w    (KEYS)-VARS(a2)
                    move.w   #$99,(BULLS)-VARS(a2)
                    addq.w   #1,(MSNNUM)-VARS(a2)
                    addq.w   #1,(DIFLVL)-VARS(a2)
                    moveq    #0,d4
                    moveq    #8,d5
                    moveq    #16,d2
                    moveq    #7,d3
                    bsr.w    WINDOW
                    lea      (MSCS0)-VARS(a2),a1
                    moveq    #3,d4
                    moveq    #9,d5
                    bsr.w    WSPRNT
                    lea      (MSCS1)-VARS(a2),a1
                    moveq    #0,d4
                    moveq    #12,d5
                    bsr.w    WSPRNT
                    lea      (MSCS2)-VARS(a2),a1
                    moveq    #4,d4
                    moveq    #13,d5
                    bsr.w    WSPRNT
                    bsr.w    WAIT
                    bsr.w    WAIT
                    cmpi.w   #4,(DIFLVL)-VARS(a2)
                    bne.w    PBAK
                    bsr.w    INIT_MUSIC
                    moveq    #0,d4
                    moveq    #7,d5
                    moveq    #16,d2
                    moveq    #9,d3
                    bsr.w    WINDOW
                    lea      (MSCS3)-VARS(a2),a1
                    moveq    #1,d4
                    moveq    #8,d5
                    bsr.w    WSPRNT
                    lea      (MSCS4)-VARS(a2),a1
                    moveq    #1,d4
                    moveq    #9,d5
                    bsr.w    WSPRNT
                    lea      (MSCS5)-VARS(a2),a1
                    moveq    #2,d4
                    moveq    #13,d5
                    bsr.w    WSPRNT
                    lea      (MSCS6)-VARS(a2),a1
                    moveq    #1,d4
                    moveq    #14,d5
                    bsr.w    WSPRNT
ENDING:             bsr.w    KSCAN
                    bra.b    ENDING

MSCS0:              dc.b     'WELL  DONE',$FF
MSCS1:              dc.b     'YOUR MISSION WAS',$FF
MSCS2:              dc.b     'A SUCCESS',$FF
MSCS3:              dc.b     'THE CASTLE HAS',$FF
MSCS4:              dc.b     'BEEN DESTROYED',$FF
MSCS5:              dc.b     'YOU MUST NOW',$FF
MSCS6:              dc.b     'RETURN TO BASE',$FF
                    even
                    
RND:                move.l   d1,-(sp)
                    move.l   #$BB40E62D,d0
                    move.l   (SEED)-VARS(a2),d1
                    mulu.w   d1,d0
                    addq.l   #1,d0
                    move.l   d0,(SEED)-VARS(a2)
                    asr.l    #8,d0
                    andi.l   #$FFFFFF,d0
                    move.l   (sp)+,d1
                    rts

SEED:               dc.l     $12345678
CTRL_CUS:           dc.w     0

CTRLMNU:            jsr      (KSCAN)-VARS(a2)
                    tst.w    (ESCFLG)-VARS(a2)
                    bne.w    CTRLMNU
                    bsr.w    FRAME
                    bsr.w    FRAME
                    clr.w    (CTRL_CUS)-VARS(a2)
                    bsr.w    PPANEL
CTRL_LOOP:          bsr.w    KSCAN
                    btst     #0,(JOYVAL)-VARS(a2)
                    bne.w    CTRL_UP
                    btst     #1,(JOYVAL)-VARS(a2)
                    bne.w    CTRL_DN
                    btst     #4,(JOYVAL)-VARS(a2)
                    beq.b    CTRL_LOOP
CTRL_FR:            bsr.w    KSCAN
                    btst     #4,(JOYVAL)-VARS(a2)
                    bne.w    CTRL_FR
                    movea.l  (PANELPTR)-VARS(a2),a0
                    bsr.w    PGUN
                    bsr.w    FRAME
                    bsr.w    FRAME
                    bsr.w    FRAME
                    movea.l  (PANELPTR)-VARS(a2),a0
                    lea      24/4(a0),a0
                    bsr.w    PGUN
                    tst.w    (CTRL_CUS)-VARS(a2)
                    beq.b    CTRL_0
                    cmpi.w   #1,(CTRL_CUS)-VARS(a2)
                    beq.b    CTRL_1
                    cmpi.w   #2,(CTRL_CUS)-VARS(a2)
                    beq.b    CTRL_2
                    cmpi.w   #3,(CTRL_CUS)-VARS(a2)
                    beq.b    CTRL_3
                    bra.w    START_GAME

CTRL_0:             eori.w   #1,(DFCLTY)-VARS(a2)
                    bsr.w    UNDERLINE
                    bra.w    CTRL_LOOP

DFCLTY:             dc.w     1

CTRL_1:             bsr.w    XLOAD
                    bsr.w    UNDERLINE
                    bra.w    CTRL_LOOP

CTRL_2:             eori.w   #1,(SNDFLG)-VARS(a2)
                    bsr.w    INIT_MUSIC
CTRL21:             bsr.w    UNDERLINE
                    bra.w    CTRL_LOOP

SNDFLG:             dc.w     1

CTRL_3:             eori.w   #1,(MSFLG)-VARS(a2)
                    bsr.w    UNDERLINE
                    bra.w    CTRL_LOOP

MSFLG:              dc.w     1

CTRL_UP:            bsr.w    KSCAN
                    btst     #0,(JOYVAL)-VARS(a2)
                    bne.w    CTRL_UP
                    tst.w    (CTRL_CUS)-VARS(a2)
                    beq.w    CTRL_LOOP
                    movea.l  (PANELPTR)-VARS(a2),a0
                    lea      48/4(a0),a0
                    bsr.w    PGUN
                    subq.w   #1,(CTRL_CUS)-VARS(a2)
                    movea.l  (PANELPTR)-VARS(a2),a0
                    lea.l    24/4(a0),a0
                    bsr.w    PGUN
                    bra.w    CTRL_LOOP

CTRL_DN:            bsr.w    KSCAN
                    btst     #1,(JOYVAL)-VARS(a2)
                    bne.w    CTRL_DN
                    cmpi.w   #4,(CTRL_CUS)-VARS(a2)
                    beq.w    CTRL_LOOP
                    movea.l  (PANELPTR)-VARS(a2),a0
                    lea      48/4(a0),a0
                    bsr.w    PGUN
                    addq.w   #1,(CTRL_CUS)-VARS(a2)
                    movea.l  (PANELPTR)-VARS(a2),a0
                    lea      24/4(a0),a0
                    bsr.w    PGUN
                    bra.w    CTRL_LOOP

PPANEL:             bsr.w    BLACK
                    movea.l  (PANELPTR)-VARS(a2),a0
                    movea.l  (VIDPTR)-VARS(a2),a1
                    move.w   #4000-1,d0
PPNL0:              move.w   ((200*3*40),a0),((200*3*40),a1)
                    move.w   ((200*2*40),a0),((200*2*40),a1)
                    move.w   ((200*40),a0),((200*40),a1)
                    move.w   (a0)+,(a1)+
                    dbra     d0,PPNL0
                    movea.l  (VIDPTR)-VARS(a2),a0
                    moveq    #16-1,d0
                    moveq    #0,d1
PPNL1:              move.l   d1,(a0)
                    move.l   d1,((200*40),a0)
                    move.l   d1,((200*2*40),a0)
                    move.l   d1,((200*3*40),a0)
                    addq.l   #4,a0
                    move.l   d1,(a0)
                    move.l   d1,((200*40),a0)
                    move.l   d1,((200*2*40),a0)
                    move.l   d1,((200*3*40),a0)
                    addq.l   #4,a0
                    move.l   d1,(a0)
                    move.l   d1,((200*40),a0)
                    move.l   d1,((200*2*40),a0)
                    move.l   d1,((200*3*40),a0)
                    addq.l   #4,a0
                    move.l   d1,(a0)
                    move.l   d1,((200*40),a0)
                    move.l   d1,((200*2*40),a0)
                    move.l   d1,((200*3*40),a0)
                    addq.l   #4,a0
                    move.l   d1,(a0)
                    move.l   d1,((200*40),a0)
                    move.l   d1,((200*2*40),a0)
                    move.l   d1,((200*3*40),a0)
                    addq.l   #4,a0
                    move.l   d1,(a0)
                    move.l   d1,((200*40),a0)
                    move.l   d1,((200*2*40),a0)
                    move.l   d1,((200*3*40),a0)
                    addq.l   #4,a0
                    move.l   d1,(a0)
                    move.l   d1,((200*40),a0)
                    move.l   d1,((200*2*40),a0)
                    move.l   d1,((200*3*40),a0)
                    addq.l   #4,a0
                    move.l   d1,(a0)
                    move.l   d1,((200*40),a0)
                    move.l   d1,((200*2*40),a0)
                    move.l   d1,((200*3*40),a0)
                    lea      (40-28,a0),a0
                    dbra     d0,PPNL1
                    movea.l  (PANELPTR)-VARS(a2),a0
                    lea      24/4(a0),a0
                    bsr.b    PGUN
                    bsr.b    UNDERLINE
                    bra.w    SETCOL

PGUNDT:             dc.l     (48*40)
                    dc.l     (67*40)
                    dc.l     (86*40)
                    dc.l     (105*40)
                    dc.l     (124*40)

PGUN:               move.w   (CTRL_CUS)-VARS(a2),d0
                    add.w    d0,d0
                    add.w    d0,d0
                    lea      (PGUNDT)-VARS(a2),a1
                    movea.l  (a1,d0.w),a1
                    adda.l   (VIDPTR)-VARS(a2),a1
                    lea      26(a1),a1
                    moveq    #16-1,d0
PGUN0:              move.w   ((200*40),a0),((200*40),a1)
                    move.w   ((200*2*40),a0),((200*2*40),a1)
                    move.w   ((200*3*40),a0),((200*3*40),a1)
                    move.w   (a0)+,(a1)+
                    move.w   ((200*40),a0),((200*40),a1)
                    move.w   ((200*2*40),a0),((200*2*40),a1)
                    move.w   ((200*3*40),a0),((200*3*40),a1)
                    move.w   (a0)+,(a1)+
                    move.w   ((200*40),a0),((200*40),a1)
                    move.w   ((200*2*40),a0),((200*2*40),a1)
                    move.w   ((200*3*40),a0),((200*3*40),a1)
                    move.w   (a0)+,(a1)+
                    lea      (40-6,a1),a1
                    lea      (40-6,a0),a0
                    dbra     d0,PGUN0
                    rts

UNDERLINE:          tst.w    (DFCLTY)-VARS(a2)
                    bne.b    UNDRLN0
                    move.w   #124,d0
                    move.w   #59,d1
                    move.w   #152,d2
                    move.w   #$FFFF,d3
                    bsr.w    HLINE
                    move.w   #164,d0
                    move.w   #59,d1
                    move.w   #193,d2
                    moveq    #0,d3
                    bsr.w    HLINE
                    bra.b    UNDRLN1

UNDRLN0:            move.w   #164,d0
                    move.w   #59,d1
                    move.w   #193,d2
                    move.w   #$FFFF,d3
                    bsr.w    HLINE
                    move.w   #124,d0
                    move.w   #59,d1
                    move.w   #152,d2
                    moveq    #0,d3
                    bsr.w    HLINE

UNDRLN1:            tst.w    (LOADED)-VARS(a2)
                    beq.b    UNDRLN2
                    move.w   #124,d0
                    move.w   #78,d1
                    move.w   #145,d2
                    moveq    #0,d3
                    bsr.w    HLINE
                    move.w   #157,d0
                    move.w   #78,d1
                    move.w   #177,d2
                    move.w   #$FFFF,d3
                    bsr.w    HLINE
                    bra.b    UNDRLN3

UNDRLN2:            move.w   #124,d0
                    move.w   #78,d1
                    move.w   #145,d2
                    move.w   #$FFFF,d3
                    bsr.w    HLINE
                    move.w   #157,d0
                    move.w   #78,d1
                    move.w   #177,d2
                    moveq    #0,d3
                    bsr.w    HLINE
UNDRLN3:            tst.w    (SNDFLG)-VARS(a2)
                    bne.b    UNDRLN4
                    move.w   #124,d0
                    move.w   #97,d1
                    move.w   #137,d2
                    moveq    #0,d3
                    bsr.w    HLINE
                    move.w   #148,d0
                    move.w   #97,d1
                    move.w   #167,d2
                    move.w   #$FFFF,d3
                    bsr.b    HLINE
                    bra.b    UNDRLN5

UNDRLN4:            move.w   #124,d0
                    move.w   #97,d1
                    move.w   #137,d2
                    move.w   #$FFFF,d3
                    bsr.b    HLINE
                    move.w   #148,d0
                    move.w   #97,d1
                    move.w   #167,d2
                    moveq    #0,d3
                    bsr.w    HLINE
UNDRLN5:            tst.w    (MSFLG)-VARS(a2)
                    bne.b    UNDRLN6
                    move.w   #124,d0
                    move.w   #116,d1
                    move.w   #137,d2
                    moveq    #0,d3
                    bsr.b    HLINE
                    move.w   #148,d0
                    move.w   #116,d1
                    move.w   #167,d2
                    move.w   #$FFFF,d3
                    bsr.b    HLINE
                    bra.b    UNDRLN7

UNDRLN6:            move.w   #124,d0
                    move.w   #116,d1
                    move.w   #137,d2
                    move.w   #$FFFF,d3
                    bsr.b    HLINE
                    move.w   #148,d0
                    move.w   #116,d1
                    move.w   #167,d2
                    moveq    #0,d3
                    bra.b    HLINE
UNDRLN7:            rts

; draw an horizontal line on screen
HLINE:              bsr.b    PLOT
                    addq.l   #1,d0
                    cmp.w    d0,d2
                    bne.b    HLINE
                    rts

; plot dots on screen
PLOT:               move.w   d0,-(sp)
                    move.w   d1,-(sp)
                    move.w   d2,-(sp)
                    move.w   d3,-(sp)
                    andi.l   #$FF,d1
                    mulu.w   #40,d1
                    add.l    (VIDPTR)-VARS(a2),d1
                    move.w   d0,d2
                    andi.w   #$FF0,d0
                    lsr.w    #3,d0
                    add.w    d0,d1
                    movea.l  d1,a1
                    andi.w   #$F,d2
                    add.w    d2,d2
                    lea      (PLOTTBL)-VARS(a2),a0
                    move.w   (a0,d2.w),d2
                    tst.w    d3
                    beq.b    PLOT0
                    or.w     d2,((200*2*40),a1)
                    bra.b    PLOT1
; erase the dot if d3 = 0
PLOT0:              eori.w   #$FFFF,d2
                    and.w    d2,((200*2*40),a1)
PLOT1:              move.w   (sp)+,d3
                    move.w   (sp)+,d2
                    move.w   (sp)+,d1
                    move.w   (sp)+,d0
                    rts

PLOTTBL:            dc.w     $8000
                    dc.w     $4000
                    dc.w     $2000
                    dc.w     $1000
                    dc.w     $800
                    dc.w     $400
                    dc.w     $200
                    dc.w     $100
                    dc.w     $80
                    dc.w     $40
                    dc.w     $20
                    dc.w     $10
                    dc.w     8
                    dc.w     4
                    dc.w     2
                    dc.w     1

SFXCFL:             dc.w     0

DOBANG:             move.w   #63,d5                             ; volume
                    movea.l  (BANGPTR)-VARS(a2),a4
                    move.l   #23284/2,d0                        ; sample length / 2
                    move.w   #$175,d4                           ; frequency
                    bra.w    DOSFX

DOGUN:              move.w   #63,d5
                    movea.l  (GUNPTR)-VARS(a2),a4
                    move.l   #2088/2,d0
                    move.w   #$1D2,d4
                    bra.w    DOSFX

DOCLANK:            move.w   #47,d5
                    movea.l  (CLANKPTR)-VARS(a2),a4
                    move.l   #4068/2,d0
                    move.w   #$175,d4
                    bra.w    DOSFX

INIT_MUSIC:         move.w   #$F,($DFF096)
                    clr.w    (MUSIC_COUNT)
                    move.w   #1,(TYPEFLAG)-VARS(a2)
                    lea      (AUDINT0)-VARS(a2),a1
                    move.l   #MUSSERVER,(18,a1)
                    lea      (AUDINT1)-VARS(a2),a1
                    move.l   #MUSSERVER,(18,a1)
                    lea      (AUDINT2)-VARS(a2),a1
                    move.l   #MUSSERVER,(18,a1)
                    lea      (AUDINT3)-VARS(a2),a1
                    move.l   #MUSSERVER,(18,a1)
                    move.l   (MUSPTR)-VARS(a2),($DFF0A0)
                    move.w   #70920/2,($DFF0A4)
                    move.w   #$175,($DFF0A6)
                    move.w   #47,($DFF0A8)
                    move.l   (MUSPTR)-VARS(a2),($DFF0B0)
                    move.w   #70920/2,($DFF0B4)
                    move.w   #$175,($DFF0B6)
                    move.w   #47,($DFF0B8)
                    move.w   #$8003,($DFF096)
                    move.w   #$8080,($DFF09A)
                    rts

EXIT_MUSIC:         move.w   #$F,($DFF096)
                    clr.w    (SFXCFL)-VARS(a2)
                    move.w   #$380,($DFF09A)
                    rts

DOSFX0:             bsr.b    EXIT_MUSIC
DOSFX:              tst.w    (SFXCFL)-VARS(a2)
                    bne.b    DOSFX0
                    tst.w    (SNDFLG)-VARS(a2)
                    beq.w    RTS
                    move.w   #2,(SFXCFL)-VARS(a2)
                    move.w   #$F,($DFF096)
                    clr.w    (TYPEFLAG)-VARS(a2)
                    lea      (AUDINT0)-VARS(a2),a1
                    move.l   #AUD0SERVER,(18,a1)
                    lea      (AUDINT1)-VARS(a2),a1
                    move.l   #AUD0SERVER,(18,a1)
                    lea      (AUDINT2)-VARS(a2),a1
                    move.l   #AUD0SERVER,(18,a1)
                    lea      (AUDINT3)-VARS(a2),a1
                    move.l   #AUD0SERVER,(18,a1)
                    move.w   d0,($DFF0A4)
                    move.w   d0,($DFF0B4)
                    move.w   d4,($DFF0A6)
                    move.l   a4,($DFF0A0)
                    move.w   d5,($DFF0A8)
                    move.w   d4,($DFF0B6)
                    move.l   a4,($DFF0B0)
                    move.w   d5,($DFF0B8)
                    move.w   #$8003,($DFF096)
                    move.w   #$8080,($DFF09A)
                    rts

TYPEFLAG:           dc.w     0

ASERV:              tst.w    (TYPEFLAG)-VARS(a2)
                    bne.b    MUSSERVER
AUD0SERVER:         tst.w    (SFXCFL)-VARS(a2)
                    beq.b    AUD0SERV1
                    cmpi.w   #1,(SFXCFL)-VARS(a2)
                    bne.b    AUD0SERV0
                    move.w   #3,($DFF096)
                    move.w   #$80,($DFF09A)
AUD0SERV0:          subq.w   #1,(SFXCFL)-VARS(a2)
AUD0SERV1:          move.w   #$380,($DFF09C)
                    moveq    #1,d0
                    rts

MUSSERVER:          move.l   (MUSPTR)-VARS(a2),d0
                    bchg     #0,(MUSIC_COUNT)
                    bne.b    SECMUS
                    add.l    #70920,d0
SECMUS:             move.l   d0,($DFF0A0)
                    move.l   d0,($DFF0B0)
                    move.w   #$380,($DFF09C)
                    moveq    #1,d0
                    rts

                    end
