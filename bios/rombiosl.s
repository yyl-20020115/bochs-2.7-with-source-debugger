! 1 
! 1 # 1 "_rombiosl_.c"
! 1 #asm
!BCC_ASM
.rom
.org 0x0000
use16 386
MACRO HALT
  ;; the HALT macro is called with the line number of the HALT call.
  ;; The line number is then sent to the 0x400, causing Bochs/Plex
  ;; to print a BX_PANIC message. This will normally halt the simulation
  ;; with a message such as "BIOS panic at rombios.c, line 4091".
  ;; However, users can choose to make panics non-fatal and continue.
  mov dx,#0x400
  mov ax,#?1
  out dx,ax
MEND
MACRO JMP_AP
  db 0xea
  dw ?2
  dw ?1
MEND
MACRO SET_INT_VECTOR
  mov ax, ?3
  mov ?1*4, ax
  mov ax, ?2
  mov ?1*4+2, ax
MEND
! 26 endasm
!BCC_ENDASM
! 27 typedef unsigned char Bit8u;
!BCC_EOS
! 28 typedef unsigned short Bit16u;
!BCC_EOS
! 29 typedef unsigned short bx_bool;
!BCC_EOS
! 30 typedef unsigned long Bit32u;
!BCC_EOS
! 31   void _memsetb(value,offset,seg,count);
!BCC_EOS
! 32   void _memcpyb(doffset,dseg,soffset,sseg,count);
!BCC_EOS
! 33   void _memcpyd(doffset,dseg,soffset,sseg,count);
!BCC_EOS
! 34     void
! 35   _memsetb(value,offset,seg,count)
! 36     Bit16u value;
export	__memsetb
__memsetb:
!BCC_EOS
! 37     Bit16u offset;
!BCC_EOS
! 38     Bit16u seg;
!BCC_EOS
! 39     Bit16u count;
!BCC_EOS
! 40   {
! 41 #asm
!BCC_ASM
__memsetb.count	set	8
__memsetb.seg	set	6
__memsetb.value	set	2
__memsetb.offset	set	4
    push bp
    mov bp, sp
      push ax
      push cx
      push es
      push di
      mov cx, 10[bp] ; count
      jcxz memsetb_end
      les di, 6[bp] ; segment & offset
      mov al, 4[bp] ; value
      cld
      rep
       stosb
  memsetb_end:
      pop di
      pop es
      pop cx
      pop ax
    pop bp
! 61 endasm
!BCC_ENDASM
! 62   }
ret
! 63     void
! 64   _memcpyb(doffset,dseg,soffset,sseg,count)
! 65     Bit16u doffset;
export	__memcpyb
__memcpyb:
!BCC_EOS
! 66     Bit16u dseg;
!BCC_EOS
! 67     Bit16u soffset;
!BCC_EOS
! 68     Bit16u sseg;
!BCC_EOS
! 69     Bit16u count;
!BCC_EOS
! 70   {
! 71 #asm
!BCC_ASM
__memcpyb.count	set	$A
__memcpyb.sseg	set	8
__memcpyb.soffset	set	6
__memcpyb.dseg	set	4
__memcpyb.doffset	set	2
    push bp
    mov bp, sp
      push cx
      push es
      push di
      push ds
      push si
      mov cx, 12[bp] ; count
      jcxz memcpyb_end
      les di, 4[bp] ; dsegment & doffset
      lds si, 8[bp] ; ssegment & soffset
      cld
      rep
       movsb
  memcpyb_end:
      pop si
      pop ds
      pop di
      pop es
      pop cx
    pop bp
! 93 endasm
!BCC_ENDASM
! 94   }
ret
! 95     void
! 96   _memcpyd(doffset,dseg,soffset,sseg,count)
! 97     Bit16u doffset;
export	__memcpyd
__memcpyd:
!BCC_EOS
! 98     Bit16u dseg;
!BCC_EOS
! 99     Bit16u soffset;
!BCC_EOS
! 100     Bit16u sseg;
!BCC_EOS
! 101     Bit16u count;
!BCC_EOS
! 102   {
! 103 #asm
!BCC_ASM
__memcpyd.count	set	$A
__memcpyd.sseg	set	8
__memcpyd.soffset	set	6
__memcpyd.dseg	set	4
__memcpyd.doffset	set	2
    push bp
    mov bp, sp
      push cx
      push es
      push di
      push ds
      push si
      mov cx, 12[bp] ; count
      jcxz memcpyd_end
      les di, 4[bp] ; dsegment & doffset
      lds si, 8[bp] ; ssegment & soffset
      cld
      rep
       movsd
  memcpyd_end:
      pop si
      pop ds
      pop di
      pop es
      pop cx
    pop bp
! 125 endasm
!BCC_ENDASM
! 126   }
ret
! 127   static Bit32u _read_dword();
!BCC_EOS
! 128   static void _write_dword();
!BCC_EOS
! 129   static Bit32u read_dword_SS();
!BCC_EOS
! 130     Bit32u
! 131   _read_dword(offset, seg)
! 132     Bit16u seg;
export	__read_dword
__read_dword:
!BCC_EOS
! 133     Bit16u offset;
!BCC_EOS
! 134   {
! 135 #asm
!BCC_ASM
__read_dword.seg	set	4
__read_dword.offset	set	2
    push bp
    mov bp, sp
      push bx
      push ds
      lds bx, 4[bp] ; segment & offset
      mov ax, [bx]
      mov dx, 2[bx]
      ;; ax = return value (word)
      ;; dx = return value (word)
      pop ds
      pop bx
    pop bp
! 148 endasm
!BCC_ENDASM
! 149   }
ret
! 150     void
! 151   _write_dword(data, offset, seg)
! 152     Bit32u data;
export	__write_dword
__write_dword:
!BCC_EOS
! 153     Bit16u offset;
!BCC_EOS
! 154     Bit16u seg;
!BCC_EOS
! 155   {
! 156 #asm
!BCC_ASM
__write_dword.seg	set	8
__write_dword.data	set	2
__write_dword.offset	set	6
    push bp
    mov bp, sp
      push eax
      push bx
      push ds
      lds bx, 8[bp] ; segment & offset
      mov eax, 4[bp] ; data dword
      mov [bx], eax ; write data dword
      pop ds
      pop bx
      pop eax
    pop bp
! 169 endasm
!BCC_ENDASM
! 170   }
ret
! 171     Bit32u
! 172   read_dword_SS(offset)
! 173     Bit16u offset;
export	_read_dword_SS
_read_dword_SS:
!BCC_EOS
! 174   {
! 175 #asm
!BCC_ASM
_read_dword_SS.offset	set	2
    push bp
    mov bp, sp
    mov bp, 4[bp] ; offset
    mov ax, [bp]
    mov dx, 2[bp]
    ;; ax = return value (word)
    ;; dx = return value (word)
    pop bp
! 184 endasm
!BCC_ENDASM
! 185   }
ret
! 186 #asm
!BCC_ASM
_read_dword_SS.offset	set	2
  ;; and function
  landl:
  landul:
    SEG SS
      and ax,[di]
    SEG SS
      and bx,2[di]
    ret
  ;; add function
  laddl:
  laddul:
    SEG SS
      add ax,[di]
    SEG SS
      adc bx,2[di]
    ret
  ;; cmp function
  lcmpl:
  lcmpul:
    and eax, #0x0000FFFF
    shl ebx, #16
    or eax, ebx
    shr ebx, #16
    SEG SS
      cmp eax, dword ptr [di]
    ret
  ;; sub function
  lsubl:
  lsubul:
    SEG SS
    sub ax,[di]
    SEG SS
    sbb bx,2[di]
    ret
  ;; mul function
  lmull:
  lmulul:
    and eax, #0x0000FFFF
    shl ebx, #16
    or eax, ebx
    SEG SS
    mul eax, dword ptr [di]
    mov ebx, eax
    shr ebx, #16
    ret
  ;; dec function
  ldecl:
  ldecul:
    SEG SS
    dec dword ptr [bx]
    ret
  ;; or function
  lorl:
  lorul:
    SEG SS
    or ax,[di]
    SEG SS
    or bx,2[di]
    ret
  ;; inc function
  lincl:
  lincul:
    SEG SS
    inc dword ptr [bx]
    ret
  ;; tst function
  ltstl:
  ltstul:
    and eax, #0x0000FFFF
    shl ebx, #16
    or eax, ebx
    shr ebx, #16
    test eax, eax
    ret
  ;; sr function
  lsrul:
    mov cx,di
    jcxz lsr_exit
    and eax, #0x0000FFFF
    shl ebx, #16
    or eax, ebx
  lsr_loop:
    shr eax, #1
    loop lsr_loop
    mov ebx, eax
    shr ebx, #16
  lsr_exit:
    ret
  ;; sl function
  lsll:
  lslul:
    mov cx,di
    jcxz lsl_exit
    and eax, #0x0000FFFF
    shl ebx, #16
    or eax, ebx
  lsl_loop:
    shl eax, #1
    loop lsl_loop
    mov ebx, eax
    shr ebx, #16
  lsl_exit:
    ret
  idiv_:
    cwd
    idiv bx
    ret
  idiv_u:
    xor dx,dx
    div bx
    ret
  ldivul:
    and eax, #0x0000FFFF
    shl ebx, #16
    or eax, ebx
    xor edx, edx
    SEG SS
    mov bx, 2[di]
    shl ebx, #16
    SEG SS
    mov bx, [di]
    div ebx
    mov ebx, eax
    shr ebx, #16
    ret
! 312 endasm
!BCC_ENDASM
! 313 typedef struct {
! 314   unsigned char filler1[0x400];
!BCC_EOS
! 315   unsigned char filler2[0x6c];
!BCC_EOS
! 316   Bit16u ticks_low;
!BCC_EOS
! 317   Bit16u ticks_high;
!BCC_EOS
! 318   Bit8u midnight_flag;
!BCC_EOS
! 319 } bios_data_t;
!BCC_EOS
! 320   typedef struct {
! 321     Bit16u heads;
!BCC_EOS
! 322     Bit16u cylinders;
!BCC_EOS
! 323     Bit16u spt;
!BCC_EOS
! 324   } chs_t;
!BCC_EOS
! 325   typedef struct {
! 326     Bit16u iobase1;
!BCC_EOS
! 327     Bit16u iobase2;
!BCC_EOS
! 328     Bit8u prefix;
!BCC_EOS
! 329     Bit8u unused;
!BCC_EOS
! 330     Bit8u irq;
!BCC_EOS
! 331     Bit8u blkcount;
!BCC_EOS
! 332     Bit8u dma;
!BCC_EOS
! 333     Bit8u pio;
!BCC_EOS
! 334     Bit16u options;
!BCC_EOS
! 335     Bit16u reserved;
!BCC_EOS
! 336     Bit8u revision;
!BCC_EOS
! 337     Bit8u checksum;
!BCC_EOS
! 338   } dpte_t;
!BCC_EOS
! 339   typedef struct {
! 340     Bit8u iface;
!BCC_EOS
! 341     Bit16u iobase1;
!BCC_EOS
! 342     Bit16u iobase2;
!BCC_EOS
! 343     Bit8u irq;
!BCC_EOS
! 344   } ata_channel_t;
!BCC_EOS
! 345   typedef struct {
! 346     Bit8u type;
!BCC_EOS
! 347     Bit8u device;
!BCC_EOS
! 348     Bit8u removable;
!BCC_EOS
! 349     Bit8u lock;
!BCC_EOS
! 350     Bit8u mode;
!BCC_EOS
! 351     Bit16u blksize;
!BCC_EOS
! 352     Bit8u translation;
!BCC_EOS
! 353     chs_t lchs;
!BCC_EOS
! 354     chs_t pchs;
!BCC_EOS
! 355     Bit32u sectors_low;
!BCC_EOS
! 356     Bit32u sectors_high;
!BCC_EOS
! 357   } ata_device_t;
!BCC_EOS
! 358   typedef struct {
! 359     ata_channel_t channels[4];
!BCC_EOS
! 360     ata_device_t devices[(4*2)];
!BCC_EOS
! 361     Bit8u hdcount, hdidmap[(4*2)];
!BCC_EOS
! 362     Bit8u cdcount, cdidmap[(4*2
! 362 )];
!BCC_EOS
! 363     dpte_t dpte;
!BCC_EOS
! 364     Bit16u trsfsectors;
!BCC_EOS
! 365     Bit32u trsfbytes;
!BCC_EOS
! 366   } ata_t;
!BCC_EOS
! 367   typedef struct {
! 368     Bit8u active;
!BCC_EOS
! 369     Bit8u media;
!BCC_EOS
! 370     Bit8u emulated_drive;
!BCC_EOS
! 371     Bit8u controller_index;
!BCC_EOS
! 372     Bit16u device_spec;
!BCC_EOS
! 373     Bit32u ilba;
!BCC_EOS
! 374     Bit16u buffer_segment;
!BCC_EOS
! 375     Bit16u load_segment;
!BCC_EOS
! 376     Bit16u sector_count;
!BCC_EOS
! 377     chs_t vdevice;
!BCC_EOS
! 378   } cdemu_t;
!BCC_EOS
! 379   typedef struct {
! 380     Bit8u size;
!BCC_EOS
! 381     unsigned char filler0[0x21];
!BCC_EOS
! 382     Bit16u mouse_driver_offset;
!BCC_EOS
! 383     Bit16u mouse_driver_seg;
!BCC_EOS
! 384     Bit8u mouse_flag1;
!BCC_EOS
! 385     Bit8u mouse_flag2;
!BCC_EOS
! 386     Bit8u mouse_data[0x08];
!BCC_EOS
! 387     unsigned char filler1[0x0D];
!BCC_EOS
! 388     unsigned char fdpt0[0x10];
!BCC_EOS
! 389     unsigned char fdpt1[0x10];
!BCC_EOS
! 390     unsigned char filler2[0xC4];
!BCC_EOS
! 391     ata_t ata;
!BCC_EOS
! 392     cdemu_t cdemu;
!BCC_EOS
! 393   } ebda_data_t;
!BCC_EOS
! 394   typedef struct {
! 395     Bit8u size;
!BCC_EOS
! 396     Bit8u reserved;
!BCC_EOS
! 397     Bit16u count;
!BCC_EOS
! 398     Bit16u offset;
!BCC_EOS
! 399     Bit16u segment;
!BCC_EOS
! 400     Bit32u lba1;
!BCC_EOS
! 401     Bit32u lba2;
!BCC_EOS
! 402   } int13ext_t;
!BCC_EOS
! 403   typedef struct {
! 404     Bit16u size;
!BCC_EOS
! 405     Bit16u infos;
!BCC_EOS
! 406     Bit32u cylinders;
!BCC_EOS
! 407     Bit32u heads;
!BCC_EOS
! 408     Bit32u spt;
!BCC_EOS
! 409     Bit32u sector_count1;
!BCC_EOS
! 410     Bit32u sector_count2;
!BCC_EOS
! 411     Bit16u blksize;
!BCC_EOS
! 412     Bit16u dpte_offset;
!BCC_EOS
! 413     Bit16u dpte_segment;
!BCC_EOS
! 414     union {
! 415       struct {
! 416         Bit16u key;
!BCC_EOS
! 417         Bit8u dpi_length;
!BCC_EOS
! 418         Bit8u reserved1;
!BCC_EOS
! 419         Bit16u reserved2;
!BCC_EOS
! 420         Bit8u host_bus[4];
!BCC_EOS
! 421         Bit8u iface_type[8];
!BCC_EOS
! 422         Bit8u iface_path[8];
!BCC_EOS
! 423         Bit8u device_path[8];
!BCC_EOS
! 424         Bit8u reserved3;
!BCC_EOS
! 425         Bit8u checksum;
!BCC_EOS
! 426       } phoenix;
!BCC_EOS
! 427       struct {
! 428         Bit16u key;
!BCC_EOS
! 429         Bit8u dpi_length;
!BCC_EOS
! 430         Bit8u reserved1;
!BCC_EOS
! 431         Bit16u reserved2;
!BCC_EOS
! 432         Bit8u host_bus[4];
!BCC_EOS
! 433         Bit8u iface_type[8];
!BCC_EOS
! 434         Bit8u iface_path[8];
!BCC_EOS
! 435         Bit8u device_path[16];
!BCC_EOS
! 436         Bit8u reserved3;
!BCC_EOS
! 437         Bit8u checksum;
!BCC_EOS
! 438       } t13;
!BCC_EOS
! 439     } dpi;
!BCC_EOS
! 440   } dpt_t;
!BCC_EOS
! 441 typedef struct {
! 442   union {
! 443     struct {
! 444       Bit16u di, si, bp, sp;
!BCC_EOS
! 445       Bit16u bx, dx, cx, ax;
!BCC_EOS
! 446     } r16;
!BCC_EOS
! 447     struct {
! 448       Bit16u filler[4];
!BCC_EOS
! 449       Bit8u bl, bh, dl, dh, cl, ch, al, ah;
!BCC_EOS
! 450     } r8;
!BCC_EOS
! 451   } u;
!BCC_EOS
! 452 } pusha_regs_t;
!BCC_EOS
! 453 typedef struct {
! 454  union {
! 455   struct {
! 456     Bit32u edi, esi, ebp, esp;
!BCC_EOS
! 457     Bit32u ebx, edx, ecx, eax
! 457 ;
!BCC_EOS
! 458   } r32;
!BCC_EOS
! 459   struct {
! 460     Bit16u di, filler1, si, filler2, bp, filler3, sp, filler4;
!BCC_EOS
! 461     Bit16u bx, filler5, dx, filler6, cx, filler7, ax, filler8;
!BCC_EOS
! 462   } r16;
!BCC_EOS
! 463   struct {
! 464     Bit32u filler[4];
!BCC_EOS
! 465     Bit8u bl, bh;
!BCC_EOS
! 466     Bit16u filler1;
!BCC_EOS
! 467     Bit8u dl, dh;
!BCC_EOS
! 468     Bit16u filler2;
!BCC_EOS
! 469     Bit8u cl, ch;
!BCC_EOS
! 470     Bit16u filler3;
!BCC_EOS
! 471     Bit8u al, ah;
!BCC_EOS
! 472     Bit16u filler4;
!BCC_EOS
! 473   } r8;
!BCC_EOS
! 474  } u;
!BCC_EOS
! 475 } pushad_regs_t;
!BCC_EOS
! 476 typedef struct {
! 477   union {
! 478     struct {
! 479       Bit16u flags;
!BCC_EOS
! 480     } r16;
!BCC_EOS
! 481     struct {
! 482       Bit8u flagsl;
!BCC_EOS
! 483       Bit8u flagsh;
!BCC_EOS
! 484     } r8;
!BCC_EOS
! 485   } u;
!BCC_EOS
! 486 } flags_t;
!BCC_EOS
! 487 typedef struct {
! 488   Bit16u ip;
!BCC_EOS
! 489   Bit16u cs;
!BCC_EOS
! 490   flags_t flags;
!BCC_EOS
! 491 } iret_addr_t;
!BCC_EOS
! 492 typedef struct {
! 493   Bit16u type;
!BCC_EOS
! 494   Bit16u flags;
!BCC_EOS
! 495   Bit32u vector;
!BCC_EOS
! 496   Bit32u description;
!BCC_EOS
! 497   Bit32u reserved;
!BCC_EOS
! 498 } ipl_entry_t;
!BCC_EOS
! 499 static Bit8u inb();
!BCC_EOS
! 500 static Bit8u inb_cmos();
!BCC_EOS
! 501 static void outb();
!BCC_EOS
! 502 static void outb_cmos();
!BCC_EOS
! 503 static Bit16u inw();
!BCC_EOS
! 504 static void outw();
!BCC_EOS
! 505 static void init_rtc();
!BCC_EOS
! 506 static bx_bool rtc_updating();
!BCC_EOS
! 507 static Bit8u _read_byte();
!BCC_EOS
! 508 static Bit16u _read_word();
!BCC_EOS
! 509 static void _write_byte();
!BCC_EOS
! 510 static void _write_word();
!BCC_EOS
! 511 static Bit8u read_byte_SS();
!BCC_EOS
! 512 static Bit16u read_word_SS();
!BCC_EOS
! 513 static void _write_byte_SS();
!BCC_EOS
! 514 static void _write_word_SS();
!BCC_EOS
! 515 static void bios_printf();
!BCC_EOS
! 516 static Bit8u inhibit_mouse_int_and_events();
!BCC_EOS
! 517 static void enable_mouse_int_and_events();
!BCC_EOS
! 518 static Bit8u send_to_mouse_ctrl();
!BCC_EOS
! 519 static Bit8u get_mouse_data();
!BCC_EOS
! 520 static void set_kbd_command_byte();
!BCC_EOS
! 521 static void int09_function();
!BCC_EOS
! 522 static void int13_harddisk();
!BCC_EOS
! 523 static void int13_cdrom();
!BCC_EOS
! 524 static void int13_cdemu();
!BCC_EOS
! 525 static void int13_eltorito();
!BCC_EOS
! 526 static void int13_diskette_function();
!BCC_EOS
! 527 static void int14_function();
!BCC_EOS
! 528 static void int15_function();
!BCC_EOS
! 529 static void int16_function();
!BCC_EOS
! 530 static void int17_function();
!BCC_EOS
! 531 static void int19_function();
!BCC_EOS
! 532 static void int1a_function();
!BCC_EOS
! 533 static void int70_function();
!BCC_EOS
! 534 static void int74_function();
!BCC_EOS
! 535 static Bit16u get_CS();
!BCC_EOS
! 536 static Bit16u get_SS();
!BCC_EOS
! 537 static Bit16u set_DS();
!BCC_EOS
! 538 static unsigned int enqueue_key();
!BCC_EOS
! 539 static unsigned int dequeue_key();
!BCC_EOS
! 540 static void get_hd_geometry();
!BCC_EOS
! 541 static void set_diskette_ret_status();
!BCC_EOS
! 542 static void set_diskette_current_cyl();
!BCC_EOS
! 543 static void determine
! 543 _floppy_media();
!BCC_EOS
! 544 static bx_bool floppy_drive_exists();
!BCC_EOS
! 545 static bx_bool floppy_drive_recal();
!BCC_EOS
! 546 static bx_bool floppy_media_known();
!BCC_EOS
! 547 static bx_bool floppy_media_sense();
!BCC_EOS
! 548 static bx_bool set_enable_a20();
!BCC_EOS
! 549 static void debugger_on();
!BCC_EOS
! 550 static void debugger_off();
!BCC_EOS
! 551 static void keyboard_init();
!BCC_EOS
! 552 static void keyboard_panic();
!BCC_EOS
! 553 static void shutdown_status_panic();
!BCC_EOS
! 554 static void nmi_handler_msg();
!BCC_EOS
! 555 static void delay_ticks();
!BCC_EOS
! 556 static void delay_ticks_and_check_for_keystroke();
!BCC_EOS
! 557 static void interactive_bootkey();
!BCC_EOS
! 558 static void print_bios_banner();
!BCC_EOS
! 559 static void print_boot_device();
!BCC_EOS
! 560 static void print_boot_failure();
!BCC_EOS
! 561 static void print_cdromboot_failure();
!BCC_EOS
! 562 void ata_init();
!BCC_EOS
! 563 void ata_detect();
!BCC_EOS
! 564 void ata_reset();
!BCC_EOS
! 565 Bit16u ata_cmd_non_data();
!BCC_EOS
! 566 Bit16u ata_cmd_data_io();
!BCC_EOS
! 567 Bit16u ata_cmd_packet();
!BCC_EOS
! 568 Bit16u atapi_get_sense();
!BCC_EOS
! 569 Bit16u atapi_is_ready();
!BCC_EOS
! 570 Bit16u atapi_is_cdrom();
!BCC_EOS
! 571 void cdemu_init();
!BCC_EOS
! 572 Bit8u cdemu_isactive();
!BCC_EOS
! 573 Bit8u cdemu_emulated_drive();
!BCC_EOS
! 574 Bit16u cdrom_boot();
!BCC_EOS
! 575 static char bios_svn_version_string[] = "$Revision: 14314 $ $Date: 2021-07-14 18:10:19 +0200 (Mi, 14. Jul 2021) $";
.data
_bios_svn_version_string:
.1:
.ascii	"$Revision: 14314 $ $Date: 2021-07-14 18:"
.ascii	"10:19 +0200 (Mi, 14. Jul 2021) $"
.byte	0
!BCC_EOS
! 576 static struct {
! 577   Bit16u normal;
!BCC_EOS
! 578   Bit16u shift;
!BCC_EOS
! 579   Bit16u control;
!BCC_EOS
! 580   Bit16u alt;
!BCC_EOS
! 581   Bit8u lock_flags;
!BCC_EOS
! 582   } scan_to_scanascii[0x58 + 1] = {
.blkb	1
_scan_to_scanascii:
! 583       { 0, 0, 0, 0, 0 },
.word	0
.word	0
.word	0
.word	0
.byte	0
.blkb	1
! 584       { 0x011b, 0x011b, 0x011b, 0x0100, 0 },
.word	$11B
.word	$11B
.word	$11B
.word	$100
.byte	0
.blkb	1
! 585       { 0x0231, 0x0221, 0, 0x7800, 0 },
.word	$231
.word	$221
.word	0
.word	$7800
.byte	0
.blkb	1
! 586       { 0x0332, 0x0340, 0x0300, 0x7900, 0 },
.word	$332
.word	$340
.word	$300
.word	$7900
.byte	0
.blkb	1
! 587       { 0x0433, 0x0423, 0, 0x7a00, 0 },
.word	$433
.word	$423
.word	0
.word	$7A00
.byte	0
.blkb	1
! 588       { 0x0534, 0x0524, 0, 0x7b00, 0 },
.word	$534
.word	$524
.word	0
.word	$7B00
.byte	0
.blkb	1
! 589       { 0x0635, 0x0625, 0, 0x7c00, 0 },
.word	$635
.word	$625
.word	0
.word	$7C00
.byte	0
.blkb	1
! 590       { 0x0736, 0x075e, 0x071e, 0x7d00, 0 },
.word	$736
.word	$75E
.word	$71E
.word	$7D00
.byte	0
.blkb	1
! 591       { 0x0837, 0x0826, 0, 0x7e00, 0 },
.word	$837
.word	$826
.word	0
.word	$7E00
.byte	0
.blkb	1
! 592       { 0x0938, 0x092a, 0, 0x7f00, 0 },
.word	$938
.word	$92A
.word	0
.word	$7F00
.byte	0
.blkb	1
! 593       { 0x0a39, 0x0a28, 0, 0x8000, 0 },
.word	$A39
.word	$A28
.word	0
.word	$8000
.byte	0
.blkb	1
! 594       { 0x0b30, 0x0b29, 0, 0x8100, 0 },
.word	$B30
.word	$B29
.word	0
.word	$8100
.byte	0
.blkb	1
! 595       { 0x0c2d, 0x0c5f, 0x0c1f, 0x8200, 0 },
.word	$C2D
.word	$C5F
.word	$C1F
.word	$8200
.byte	0
.blkb	1
! 596       { 0x0d3d, 0x0d2b, 0, 0x8300, 0 },
.word	$D3D
.word	$D2B
.word	0
.word	$8300
.byte	0
.blkb	1
! 597       { 0x0e08, 0x0e08, 0x0e7f, 0, 0 },
.word	$E08
.word	$E08
.word	$E7F
.word	0
.byte	0
.blkb	1
! 598       { 0x0f09, 0x0f00, 0, 0, 0 },
.word	$F09
.word	$F00
.word	0
.word	0
.byte	0
.blkb	1
! 599       { 0x1071, 0x1051, 0x1011, 0x1000, 0x40 },
.word	$1071
.word	$1051
.word	$1011
.word	$1000
.byte	$40
.blkb	1
! 600       { 0x1177, 0x1157, 0x1117, 0x1100, 0x40 },
.word	$1177
.word	$1157
.word	$1117
.word	$1100
.byte	$40
.blkb	1
! 601       { 0x1265, 0x1245, 0x1205, 0x1200, 0x40 },
.word	$1265
.word	$1245
.word	$1205
.word	$1200
.byte	$40
.blkb	1
! 602       { 0x1372, 0x1352, 0x1312, 0x1300, 0x40 },
.word	$1372
.word	$1352
.word	$1312
.word	$1300
.byte	$40
.blkb	1
! 603       { 0x1474, 0x1454, 0x14
.word	$1474
.word	$1454
! 603 14, 0x1400, 0x40 },
.word	$1414
.word	$1400
.byte	$40
.blkb	1
! 604       { 0x1579, 0x1559, 0x1519, 0x1500, 0x40 },
.word	$1579
.word	$1559
.word	$1519
.word	$1500
.byte	$40
.blkb	1
! 605       { 0x1675, 0x1655, 0x1615, 0x1600, 0x40 },
.word	$1675
.word	$1655
.word	$1615
.word	$1600
.byte	$40
.blkb	1
! 606       { 0x1769, 0x1749, 0x1709, 0x1700, 0x40 },
.word	$1769
.word	$1749
.word	$1709
.word	$1700
.byte	$40
.blkb	1
! 607       { 0x186f, 0x184f, 0x180f, 0x1800, 0x40 },
.word	$186F
.word	$184F
.word	$180F
.word	$1800
.byte	$40
.blkb	1
! 608       { 0x1970, 0x1950, 0x1910, 0x1900, 0x40 },
.word	$1970
.word	$1950
.word	$1910
.word	$1900
.byte	$40
.blkb	1
! 609       { 0x1a5b, 0x1a7b, 0x1a1b, 0, 0 },
.word	$1A5B
.word	$1A7B
.word	$1A1B
.word	0
.byte	0
.blkb	1
! 610       { 0x1b5d, 0x1b7d, 0x1b1d, 0, 0 },
.word	$1B5D
.word	$1B7D
.word	$1B1D
.word	0
.byte	0
.blkb	1
! 611       { 0x1c0d, 0x1c0d, 0x1c0a, 0, 0 },
.word	$1C0D
.word	$1C0D
.word	$1C0A
.word	0
.byte	0
.blkb	1
! 612       { 0, 0, 0, 0, 0 },
.word	0
.word	0
.word	0
.word	0
.byte	0
.blkb	1
! 613       { 0x1e61, 0x1e41, 0x1e01, 0x1e00, 0x40 },
.word	$1E61
.word	$1E41
.word	$1E01
.word	$1E00
.byte	$40
.blkb	1
! 614       { 0x1f73, 0x1f53, 0x1f13, 0x1f00, 0x40 },
.word	$1F73
.word	$1F53
.word	$1F13
.word	$1F00
.byte	$40
.blkb	1
! 615       { 0x2064, 0x2044, 0x2004, 0x2000, 0x40 },
.word	$2064
.word	$2044
.word	$2004
.word	$2000
.byte	$40
.blkb	1
! 616       { 0x2166, 0x2146, 0x2106, 0x2100, 0x40 },
.word	$2166
.word	$2146
.word	$2106
.word	$2100
.byte	$40
.blkb	1
! 617       { 0x2267, 0x2247, 0x2207, 0x2200, 0x40 },
.word	$2267
.word	$2247
.word	$2207
.word	$2200
.byte	$40
.blkb	1
! 618       { 0x2368, 0x2348, 0x2308, 0x2300, 0x40 },
.word	$2368
.word	$2348
.word	$2308
.word	$2300
.byte	$40
.blkb	1
! 619       { 0x246a, 0x244a, 0x240a, 0x2400, 0x40 },
.word	$246A
.word	$244A
.word	$240A
.word	$2400
.byte	$40
.blkb	1
! 620       { 0x256b, 0x254b, 0x250b, 0x2500, 0x40 },
.word	$256B
.word	$254B
.word	$250B
.word	$2500
.byte	$40
.blkb	1
! 621       { 0x266c, 0x264c, 0x260c, 0x2600, 0x40 },
.word	$266C
.word	$264C
.word	$260C
.word	$2600
.byte	$40
.blkb	1
! 622       { 0x273b, 0x273a, 0, 0, 0 },
.word	$273B
.word	$273A
.word	0
.word	0
.byte	0
.blkb	1
! 623       { 0x2827, 0x2822, 0, 0, 0 },
.word	$2827
.word	$2822
.word	0
.word	0
.byte	0
.blkb	1
! 624       { 0x2960, 0x297e, 0, 0, 0 },
.word	$2960
.word	$297E
.word	0
.word	0
.byte	0
.blkb	1
! 625       { 0, 0, 0, 0, 0 },
.word	0
.word	0
.word	0
.word	0
.byte	0
.blkb	1
! 626       { 0x2b5c, 0x2b7c, 0x2b1c, 0, 0 },
.word	$2B5C
.word	$2B7C
.word	$2B1C
.word	0
.byte	0
.blkb	1
! 627       { 0x2c7a, 0x2c5a, 0x2c1a, 0x2c00, 0x40 },
.word	$2C7A
.word	$2C5A
.word	$2C1A
.word	$2C00
.byte	$40
.blkb	1
! 628       { 0x2d78, 0x2d58, 0x2d18, 0x2d00, 0x40 },
.word	$2D78
.word	$2D58
.word	$2D18
.word	$2D00
.byte	$40
.blkb	1
! 629       { 0x2e63, 0x2e43, 0x2e03, 0x2e00, 0x40 },
.word	$2E63
.word	$2E43
.word	$2E03
.word	$2E00
.byte	$40
.blkb	1
! 630       { 0x2f76, 0x2f56, 0x2f16, 0x2f00, 0x40 },
.word	$2F76
.word	$2F56
.word	$2F16
.word	$2F00
.byte	$40
.blkb	1
! 631       { 0x3062, 0x3042, 0x3002, 0x3000, 0x40 },
.word	$3062
.word	$3042
.word	$3002
.word	$3000
.byte	$40
.blkb	1
! 632       { 0x316e, 0x314e, 0x310e, 0x3100, 0x40 },
.word	$316E
.word	$314E
.word	$310E
.word	$3100
.byte	$40
.blkb	1
! 633       { 0x326d, 0x324d, 0x320d, 0x3200, 0x40 },
.word	$326D
.word	$324D
.word	$320D
.word	$3200
.byte	$40
.blkb	1
! 634       { 0x332c, 0x333c, 0, 0, 0 },
.word	$332C
.word	$333C
.word	0
.word	0
.byte	0
.blkb	1
! 635       { 0x342e, 0x343e, 0, 0, 0 },
.word	$342E
.word	$343E
.word	0
.word	0
.byte	0
.blkb	1
! 636       { 0x352f, 0x353f, 0, 0, 0 },
.word	$352F
.word	$353F
.word	0
.word	0
.byte	0
.blkb	1
! 637       { 0, 0, 0, 0, 0 },
.word	0
.word	0
.word	0
.word	0
.byte	0
.blkb	1
! 638       { 0x372a, 0x372a, 0, 0, 0 },
.word	$372A
.word	$372A
.word	0
.word	0
.byte	0
.blkb	1
! 639       { 0, 0, 0, 0, 0 },
.word	0
.word	0
.word	0
.word	0
.byte	0
.blkb	1
! 640       { 0x3920, 0x3920, 0x3920, 0x3920, 0 },
.word	$3920
.word	$3920
.word	$3920
.word	$3920
.byte	0
.blkb	1
! 641       { 0, 0, 0, 0, 0 },
.word	0
.word	0
.word	0
.word	0
.byte	0
.blkb	1
! 642       { 0x3b00, 0x5400, 0x5e00, 0x6800, 0 },
.word	$3B00
.word	$5400
.word	$5E00
.word	$6800
.byte	0
.blkb	1
! 643       { 0x3c00, 0x5500, 0x5f00, 0x6900, 0 },
.word	$3C00
.word	$5500
.word	$5F00
.word	$6900
.byte	0
.blkb	1
! 644       { 0x3d00, 0x5600, 0x6000, 0x6a00, 0 },
.word	$3D00
.word	$5600
.word	$6000
.word	$6A00
.byte	0
.blkb	1
! 645       { 0x3e00, 0x5700, 0x6100, 0x6b00, 0 },
.word	$3E00
.word	$5700
.word	$6100
.word	$6B00
.byte	0
.blkb	1
! 646       { 0x3f00, 0x5800, 0x6200, 0x6c00, 0 },
.word	$3F00
.word	$5800
.word	$6200
.word	$6C00
.byte	0
.blkb	1
! 647       { 0x4000, 0x5900, 0x6300, 0x6d00, 0 },
.word	$4000
.word	$5900
.word	$6300
.word	$6D00
.byte	0
.blkb	1
! 648       { 0x4100, 0x5a00, 0x6400, 0x6e00, 0 },
.word	$4100
.word	$5A00
.word	$6400
.word	$6E00
.byte	0
.blkb	1
! 649       { 0x4200, 0x5b00, 0x6500, 0x6f00, 0 },
.word	$4200
.word	$5B00
.word	$6500
.word	$6F00
.byte	0
.blkb	1
! 650       { 0x4300, 0x5c00, 0x6600, 0x7000, 0 },
.word	$4300
.word	$5C00
.word	$6600
.word	$7000
.byte	0
.blkb	1
! 651       { 0x4400, 0x5d00, 0x6700, 0x7100, 
.word	$4400
.word	$5D00
.word	$6700
.word	$7100
! 651 0 },
.byte	0
.blkb	1
! 652       { 0, 0, 0, 0, 0 },
.word	0
.word	0
.word	0
.word	0
.byte	0
.blkb	1
! 653       { 0, 0, 0, 0, 0 },
.word	0
.word	0
.word	0
.word	0
.byte	0
.blkb	1
! 654       { 0x4700, 0x4737, 0x7700, 0, 0x20 },
.word	$4700
.word	$4737
.word	$7700
.word	0
.byte	$20
.blkb	1
! 655       { 0x4800, 0x4838, 0, 0, 0x20 },
.word	$4800
.word	$4838
.word	0
.word	0
.byte	$20
.blkb	1
! 656       { 0x4900, 0x4939, 0x8400, 0, 0x20 },
.word	$4900
.word	$4939
.word	$8400
.word	0
.byte	$20
.blkb	1
! 657       { 0x4a2d, 0x4a2d, 0, 0, 0 },
.word	$4A2D
.word	$4A2D
.word	0
.word	0
.byte	0
.blkb	1
! 658       { 0x4b00, 0x4b34, 0x7300, 0, 0x20 },
.word	$4B00
.word	$4B34
.word	$7300
.word	0
.byte	$20
.blkb	1
! 659       { 0x4c00, 0x4c35, 0, 0, 0x20 },
.word	$4C00
.word	$4C35
.word	0
.word	0
.byte	$20
.blkb	1
! 660       { 0x4d00, 0x4d36, 0x7400, 0, 0x20 },
.word	$4D00
.word	$4D36
.word	$7400
.word	0
.byte	$20
.blkb	1
! 661       { 0x4e2b, 0x4e2b, 0, 0, 0 },
.word	$4E2B
.word	$4E2B
.word	0
.word	0
.byte	0
.blkb	1
! 662       { 0x4f00, 0x4f31, 0x7500, 0, 0x20 },
.word	$4F00
.word	$4F31
.word	$7500
.word	0
.byte	$20
.blkb	1
! 663       { 0x5000, 0x5032, 0, 0, 0x20 },
.word	$5000
.word	$5032
.word	0
.word	0
.byte	$20
.blkb	1
! 664       { 0x5100, 0x5133, 0x7600, 0, 0x20 },
.word	$5100
.word	$5133
.word	$7600
.word	0
.byte	$20
.blkb	1
! 665       { 0x5200, 0x5230, 0, 0, 0x20 },
.word	$5200
.word	$5230
.word	0
.word	0
.byte	$20
.blkb	1
! 666       { 0x5300, 0x532e, 0, 0, 0x20 },
.word	$5300
.word	$532E
.word	0
.word	0
.byte	$20
.blkb	1
! 667       { 0, 0, 0, 0, 0 },
.word	0
.word	0
.word	0
.word	0
.byte	0
.blkb	1
! 668       { 0, 0, 0, 0, 0 },
.word	0
.word	0
.word	0
.word	0
.byte	0
.blkb	1
! 669       { 0x565c, 0x567c, 0, 0, 0 },
.word	$565C
.word	$567C
.word	0
.word	0
.byte	0
.blkb	1
! 670       { 0x8500, 0x8700, 0x8900, 0x8b00, 0 },
.word	$8500
.word	$8700
.word	$8900
.word	$8B00
.byte	0
.blkb	1
! 671       { 0x8600, 0x8800, 0x8a00, 0x8c00, 0 },
.word	$8600
.word	$8800
.word	$8A00
.word	$8C00
.byte	0
.blkb	1
! 672       };
!BCC_EOS
! 673   Bit8u
! 674 inb(port)
! 675   Bit16u port;
.text
export	_inb
_inb:
!BCC_EOS
! 676 {
! 677 #asm
!BCC_ASM
_inb.port	set	2
  push bp
  mov bp, sp
    push dx
    mov dx, 4[bp]
    in al, dx
    pop dx
  pop bp
! 685 endasm
!BCC_ENDASM
! 686 }
ret
! 687   Bit16u
! 688 inw(port)
! 689   Bit16u port;
export	_inw
_inw:
!BCC_EOS
! 690 {
! 691 #asm
!BCC_ASM
_inw.port	set	2
  push bp
  mov bp, sp
    push dx
    mov dx, 4[bp]
    in ax, dx
    pop dx
  pop bp
! 699 endasm
!BCC_ENDASM
! 700 }
ret
! 701   void
! 702 outb(port, val)
! 703   Bit16u port;
export	_outb
_outb:
!BCC_EOS
! 704   Bit8u val;
!BCC_EOS
! 705 {
! 706 #asm
!BCC_ASM
_outb.val	set	4
_outb.port	set	2
  push bp
  mov bp, sp
    push ax
    push dx
    mov dx, 4[bp]
    mov al, 6[bp]
    out dx, al
    pop dx
    pop ax
  pop bp
! 717 endasm
!BCC_ENDASM
! 718 }
ret
! 719   void
! 720 outw(port, val)
! 721   Bit16u port;
export	_outw
_outw:
!BCC_EOS
! 722   Bit16u val;
!BCC_EOS
! 723 {
! 724 #asm
!BCC_ASM
_outw.val	set	4
_outw.port	set	2
  push bp
  mov bp, sp
    push ax
    push dx
    mov dx, 4[bp]
    mov ax, 6[bp]
    out dx, ax
    pop dx
    pop ax
  pop bp
! 735 endasm
!BCC_ENDASM
! 736 }
ret
! 737   void
! 738 outb_cmos(cmos_reg, val)
! 739   Bit8u cmos_reg;
export	_outb_cmos
_outb_cmos:
!BCC_EOS
! 740   Bit8u val;
!BCC_EOS
! 741 {
! 742 #asm
!BCC_ASM
_outb_cmos.cmos_reg	set	2
_outb_cmos.val	set	4
  push bp
  mov bp, sp
    mov al, 4[bp] ;; cmos_reg
    out 0x0070, al
    mov al, 6[bp] ;; val
    out 0x0071, al
  pop bp
! 750 endasm
!BCC_ENDASM
! 751 }
ret
! 752   Bit8u
! 753 inb_cmos(cmos_reg)
! 754   Bit8u cmos_reg;
export	_inb_cmos
_inb_cmos:
!BCC_EOS
! 755 {
! 756 #asm
!BCC_ASM
_inb_cmos.cmos_reg	set	2
  push bp
  mov bp, sp
    mov al, 4[bp] ;; cmos_reg
    out 0x0070, al
    in al, 0x0071
  pop bp
! 763 endasm
!BCC_ENDASM
! 764 }
ret
! 765   void
! 766 init_rtc()
! 767 {
export	_init_rtc
_init_rtc:
! 768   outb_cmos(0x0a, 0x26);
push	bp
mov	bp,sp
! Debug: list int = const $26 (used reg = )
mov	ax,*$26
push	ax
! Debug: list int = const $A (used reg = )
mov	ax,*$A
push	ax
! Debug: func () void = outb_cmos+0 (used reg = )
call	_outb_cmos
mov	sp,bp
!BCC_EOS
! 769   outb_cmos(0x0b, 0x02);
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: list int = const $B (used reg = )
mov	ax,*$B
push	ax
! Debug: func () void = outb_cmos+0 (used reg = )
call	_outb_cmos
mov	sp,bp
!BCC_EOS
! 770   inb_cmos(0x0c);
! Debug: list int = const $C (used reg = )
mov	ax,*$C
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
mov	sp,bp
!BCC_EOS
! 771   inb_cmos(0x0d);
! Debug: list int = const $D (used reg = )
mov	ax,*$D
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
mov	sp,bp
!BCC_EOS
! 772 }
pop	bp
ret
! 773   bx_bool
! 774 rtc_updating()
! 775 {
export	_rtc_updating
_rtc_updating:
! 776   Bit16u count;
!BCC_EOS
! 777   count = 25000;
push	bp
mov	bp,sp
dec	sp
dec	sp
! Debug: eq int = const $61A8 to unsigned short count = [S+4-4] (used reg = )
mov	ax,#$61A8
mov	-2[bp],ax
!BCC_EOS
! 778   while (--count != 0) {
jmp .3
.4:
! 779     if ( (inb_cmos(0x0a) & 0x80) == 0 )
! Debug: list int = const $A (used reg = )
mov	ax,*$A
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: and int = const $80 to unsigned char = al+0 (used reg = )
and	al,#$80
! Debug: logeq int = const 0 to unsigned char = al+0 (used reg = )
test	al,al
jne 	.5
.6:
! 780       return(0);
xor	ax,ax
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 781     }
! 781 
.5:
! 782   return(1);
.3:
! Debug: predec unsigned short count = [S+4-4] (used reg = )
mov	ax,-2[bp]
dec	ax
mov	-2[bp],ax
! Debug: ne int = const 0 to unsigned short = ax+0 (used reg = )
test	ax,ax
jne	.4
.7:
.2:
mov	ax,*1
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 783 }
! 784   Bit8u
! 785 _read_byte(offset, seg)
! 786   Bit16u offset;
export	__read_byte
__read_byte:
!BCC_EOS
! 787   Bit16u seg;
!BCC_EOS
! 788 {
! 789 #asm
!BCC_ASM
__read_byte.seg	set	4
__read_byte.offset	set	2
  push bp
  mov bp, sp
    push bx
    push ds
    lds bx, 4[bp] ; segment & offset
    mov al, [bx]
    ;; al = return value (byte)
    pop ds
    pop bx
  pop bp
! 800 endasm
!BCC_ENDASM
! 801 }
ret
! 802   Bit16u
! 803 _read_word(offset, seg)
! 804   Bit16u offset;
export	__read_word
__read_word:
!BCC_EOS
! 805   Bit16u seg;
!BCC_EOS
! 806 {
! 807 #asm
!BCC_ASM
__read_word.seg	set	4
__read_word.offset	set	2
  push bp
  mov bp, sp
    push bx
    push ds
    lds bx, 4[bp] ; segment & offset
    mov ax, [bx]
    ;; ax = return value (word)
    pop ds
    pop bx
  pop bp
! 818 endasm
!BCC_ENDASM
! 819 }
ret
! 820   void
! 821 _write_byte(data, offset, seg)
! 822   Bit8u data;
export	__write_byte
__write_byte:
!BCC_EOS
! 823   Bit16u offset;
!BCC_EOS
! 824   Bit16u seg;
!BCC_EOS
! 825 {
! 826 #asm
!BCC_ASM
__write_byte.seg	set	6
__write_byte.data	set	2
__write_byte.offset	set	4
  push bp
  mov bp, sp
    push ax
    push bx
    push ds
    lds bx, 6[bp] ; segment & offset
    mov al, 4[bp] ; data byte
    mov [bx], al ; write data byte
    pop ds
    pop bx
    pop ax
  pop bp
! 839 endasm
!BCC_ENDASM
! 840 }
ret
! 841   void
! 842 _write_word(data, offset, seg)
! 843   Bit16u data;
export	__write_word
__write_word:
!BCC_EOS
! 844   Bit16u offset;
!BCC_EOS
! 845   Bit16u seg;
!BCC_EOS
! 846 {
! 847 #asm
!BCC_ASM
__write_word.seg	set	6
__write_word.data	set	2
__write_word.offset	set	4
  push bp
  mov bp, sp
    push ax
    push bx
    push ds
    lds bx, 6[bp] ; segment & offset
    mov ax, 4[bp] ; data word
    mov [bx], ax ; write data word
    pop ds
    pop bx
    pop ax
  pop bp
! 860 endasm
!BCC_ENDASM
! 861 }
ret
! 862   Bit8u
! 863 read_byte_SS(offset)
! 864   Bit16u offset;
export	_read_byte_SS
_read_byte_SS:
!BCC_EOS
! 865 {
! 866 #asm
!BCC_ASM
_read_byte_SS.offset	set	2
  push bp
  mov bp, sp
  mov bp, 4[bp] ; offset
  mov al, [bp]
  ;; al = return value (byte)
  pop bp
! 873 endasm
!BCC_ENDASM
! 874 }
ret
! 875   Bit16u
! 876 read_word_SS(offset)
! 877   Bit16u offset;
export	_read_word_SS
_read_word_SS:
!BCC_EOS
! 878 {
! 879 #asm
!BCC_ASM
_read_word_SS.offset	set	2
  push bp
  mov bp, sp
  mov bp, 4[bp] ; offset
  mov ax, [bp]
  ;; ax = return value (word)
  pop bp
! 886 endasm
!BCC_ENDASM
! 887 }
ret
! 888   void
! 889 _write_byte_SS(data, offset)
! 890   Bit8u data;
export	__write_byte_SS
__write_byte_SS:
!BCC_EOS
! 891   Bit16u offset;
!BCC_EOS
! 892 {
! 893 #asm
!BCC_ASM
__write_byte_SS.data	set	2
__write_byte_SS.offset	set	4
  push bp
  mov bp, sp
  push ax
  mov al, 4[bp] ; data byte
  mov bp, 6[bp] ; offset
  mov [bp], al ; write data byte
  pop ax
  pop bp
! 902 endasm
!BCC_ENDASM
! 903 }
ret
! 904   void
! 905 _write_word_SS(data, offset)
! 906   Bit16u data;
export	__write_word_SS
__write_word_SS:
!BCC_EOS
! 907   Bit16u offset;
!BCC_EOS
! 908 {
! 909 #asm
!BCC_ASM
__write_word_SS.data	set	2
__write_word_SS.offset	set	4
  push bp
  mov bp, sp
  push ax
  mov ax, 4[bp] ; data word
  mov bp, 6[bp] ; offset
  mov [bp], ax ; write data word
  pop ax
  pop bp
! 918 endasm
!BCC_ENDASM
! 919 }
ret
! 920   Bit16u
! 921 get_CS()
! 922 {
export	_get_CS
_get_CS:
! 923 #asm
!BCC_ASM
  mov ax, cs
! 925 endasm
!BCC_ENDASM
! 926 }
ret
! 927   Bit16u
! 928 get_SS()
! 929 {
export	_get_SS
_get_SS:
! 930 #asm
!BCC_ASM
  mov ax, ss
! 932 endasm
!BCC_ENDASM
! 933 }
ret
! 934   Bit16u
! 935 set_DS(seg)
! 936   Bit16u seg;
export	_set_DS
_set_DS:
!BCC_EOS
! 937 {
! 938 #asm
!BCC_ASM
_set_DS.seg	set	2
  push bp
  mov bp, sp
  push ds
  mov ds, 4[bp] ;; seg
  pop ax
  pop bp
! 945 endasm
!BCC_ENDASM
! 946 }
ret
! 947   Bit16u
! 948 get_ebda_seg()
! 949 {
export	_get_ebda_seg
_get_ebda_seg:
! 950 #asm
!BCC_ASM
  push bx
  push ds
  mov ax, #0x0040
  mov ds, ax
  mov bx, #0x000e
  mov ax, [bx]
  ;; ax = return value (word)
  pop ds
  pop bx
! 960 endasm
!BCC_ENDASM
! 961 }
ret
! 962   void
! 963 wrch(c)
! 964   Bit8u c;
export	_wrch
_wrch:
!BCC_EOS
! 965 {
! 966 #asm
!BCC_ASM
_wrch.c	set	2
  push bp
  mov bp, sp
  push bx
  mov ah, #0x0e
  mov al, 4[bp]
  xor bx,bx
  int #0x10
  pop bx
  pop bp
! 976 endasm
!BCC_ENDASM
! 977 }
ret
! 978   void
! 979 send(action, c)
! 980   Bit16u action;
export	_send
_send:
!BCC_EOS
! 981   Bit8u c;
!BCC_EOS
! 982 {
! 983   if (action & 8) outb(0x403, c);
push	bp
mov	bp,sp
! Debug: and int = const 8 to unsigned short action = [S+2+2] (used reg = )
mov	al,4[bp]
and	al,*8
test	al,al
je  	.8
.9:
! Debug: list unsigned char c = [S+2+4] (used reg = )
mov	al,6[bp]
xor	ah,ah
push	ax
! Debug: list int = const $403 (used reg = )
mov	ax,#$403
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
mov	sp,bp
!BCC_EOS
! 984   if (action & 4) outb(0x402, c);
.8:
! Debug: and int = const 4 to unsigned short action = [S+2+2] (used reg = )
mov	al,4[bp]
and	al,*4
test	al,al
je  	.A
.B:
! Debug: list unsigned char c = [S+2+4] (used reg = )
mov	al,6[bp]
xor	ah,ah
push	ax
! Debug: list int = const $402 (used reg = )
mov	ax,#$402
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
mov	sp,bp
!BCC_EOS
! 985   if (action & 2) {
.A:
! Debug: and int = const 2 to unsigned short action = [S+2+2] (used reg = )
mov	al,4[bp]
and	al,*2
test	al,al
je  	.C
.D:
! 986     if (c == '\n') wrch('\r');
! Debug: logeq int = const $A to unsigned char c = [S+2+4] (used reg = )
mov	al,6[bp]
cmp	al,*$A
jne 	.E
.F:
! Debug: list int = const $D (used reg = )
mov	ax,*$D
push	ax
! Debug: func () void = wrch+0 (used reg = )
call	_wrch
mov	sp,bp
!BCC_EOS
! 987     wrch(c);
.E:
! Debug: list unsigned char c = [S+2+4] (used reg = )
mov	al,6[bp]
xor	ah,ah
push	ax
! Debug: func () void = wrch+0 (used reg = )
call	_wrch
mov	sp,bp
!BCC_EOS
! 988   }
! 989 }
.C:
pop	bp
ret
! 990   void
! 991 put_uint(action, val, width, neg)
! 992   Bit16u action;
export	_put_uint
_put_uint:
!BCC_EOS
! 993   unsigned short val;
!BCC_EOS
! 994   short width;
!BCC_EOS
! 995   bx_bool neg;
!BCC_EOS
! 996 {
! 997   unsigned short nval = val / 10;
push	bp
mov	bp,sp
dec	sp
dec	sp
! Debug: div int = const $A to unsigned short val = [S+4+4] (used reg = )
mov	ax,6[bp]
mov	bx,*$A
call	idiv_u
! Debug: eq unsigned int = ax+0 to unsigned short nval = [S+4-4] (used reg = )
mov	-2[bp],ax
!BCC_EOS
! 998   if (nval)
mov	ax,-2[bp]
test	ax,ax
je  	.10
.11:
! 999     put_uint(action, nval, width - 1, neg);
! Debug: list unsigned short neg = [S+4+8] (used reg = )
push	$A[bp]
! Debug: sub int = const 1 to short width = [S+6+6] (used reg = )
mov	ax,8[bp]
! Debug: list int = ax-1 (used reg = )
dec	ax
push	ax
! Debug: list unsigned short nval = [S+8-4] (used reg = )
push	-2[bp]
! Debug: list unsigned short action = [S+$A+2] (used reg = )
push	4[bp]
! Debug: func () void = put_uint+0 (used reg = )
call	_put_uint
add	sp,*8
!BCC_EOS
! 1000   else {
jmp .12
.10:
! 1001     while (--width > 0) send(action, ' ');
jmp .14
.15:
! Debug: list int = const $20 (used reg = )
mov	ax,*$20
push	ax
! Debug: list unsigned short action = [S+6+2] (used reg = )
push	4[bp]
! Debug: func () void = send+0 (used reg = )
call	_send
add	sp,*4
!BCC_EOS
! 1002     if (neg) send(action, '-');
.14:
! Debug: predec short width = [S+4+6] (used reg = )
mov	ax,8[bp]
dec	ax
mov	8[bp],ax
! Debug: gt int = const 0 to short = ax+0 (used reg = )
test	ax,ax
jg 	.15
.16:
.13:
mov	ax,$A[bp]
test	ax,ax
je  	.17
.18:
! Debug: list int = const $2D (used reg = )
mov	ax,*$2D
push	ax
! Debug: list unsigned short action = [S+6+2] (used reg = )
push	4[bp]
! Debug: func () void = send+0 (used reg = )
call	_send
add	sp,*4
!BCC_EOS
! 1003   }
.17:
! 1004   send(action, val - (nval * 10) + '0');
.12:
! Debug: mul int = const $A to unsigned short nval = [S+4-4] (used reg = )
mov	ax,-2[bp]
mov	dx,ax
shl	ax,*1
shl	ax,*1
add	ax,dx
shl	ax,*1
! Debug: sub unsigned int = ax+0 to unsigned short val = [S+4+4] (used reg = )
push	ax
mov	ax,6[bp]
sub	ax,-4[bp]
inc	sp
inc	sp
! Debug: add int = const $30 to unsigned int = ax+0 (used reg = )
! Debug: list unsigned int = ax+$30 (used reg = )
add	ax,*$30
push	ax
! Debug: list unsigned short action = [S+6+2] (used reg = )
push	4[bp]
! Debug: func () void = send+0 (used reg = )
call	_send
add	sp,*4
!BCC_EOS
! 1005 }
mov	sp,bp
pop	bp
ret
! 1006   void
! Register BX used in function put_uint
! 1007 put_luint(action, val, width, neg)
! 1008   Bit16u action;
export	_put_luint
_put_luint:
!BCC_EOS
! 1009   unsigned long val;
!BCC_EOS
! 1010   short width;
!BCC_EOS
! 1011   bx_bool neg;
!BCC_EOS
! 1012 {
! 1013   unsigned long nval = val / 10;
push	bp
mov	bp,sp
add	sp,*-4
! Debug: div unsigned long = const $A to unsigned long val = [S+6+4] (used reg = )
mov	ax,*$A
xor	bx,bx
push	bx
push	ax
mov	ax,6[bp]
mov	bx,8[bp]
lea	di,-8[bp]
call	ldivul
add	sp,*4
! Debug: eq unsigned long = bx+0 to unsigned long nval = [S+6-6] (used reg = )
mov	-4[bp],ax
mov	-2[bp],bx
!BCC_EOS
! 1014   if (nval)
mov	ax,-4[bp]
mov	bx,-2[bp]
call	ltstl
je  	.19
.1A:
! 1015     put_luint(action, nval, width - 1, neg);
! Debug: list unsigned short neg = [S+6+$A] (used reg = )
push	$C[bp]
! Debug: sub int = const 1 to short width = [S+8+8] (used reg = )
mov	ax,$A[bp]
! Debug: list int = ax-1 (used reg = )
dec	ax
push	ax
! Debug: list unsigned long nval = [S+$A-6] (used reg = )
push	-2[bp]
push	-4[bp]
! Debug: list unsigned short action = [S+$E+2] (used reg = )
push	4[bp]
! Debug: func () void = put_luint+0 (used reg = )
call	_put_luint
add	sp,*$A
!BCC_EOS
! 1016   else {
jmp .1B
.19:
! 1017     while (--width > 0) send(action, ' ');
jmp .1D
.1E:
! Debug: list int = const $20 (used reg = )
mov	ax,*$20
push	ax
! Debug: list unsigned short action = [S+8+2] (used reg = )
push	4[bp]
! Debug: func () void = send+0 (used reg = )
call	_send
add	sp,*4
!BCC_EOS
! 1018     if (neg) send(action, '-');
.1D:
! Debug: predec short width = [S+6+8] (used reg = )
mov	ax,$A[bp]
dec	ax
mov	$A[bp],ax
! Debug: gt int = const 0 to short = ax+0 (used reg = )
test	ax,ax
jg 	.1E
.1F:
.1C:
mov	ax,$C[bp]
test	ax,ax
je  	.20
.21:
! Debug: list int = const $2D (used reg = )
mov	ax,*$2D
push	ax
! Debug: list unsigned short action = [S+8+2] (used reg = )
push	4[bp]
! Debug: func () void = send+0 (used reg = )
call	_send
add	sp,*4
!BCC_EOS
! 1019   }
.20:
! 1020   send(action, val - (nval * 10) + '0');
.1B:
! Debug: mul unsigned long = const $A to unsigned long nval = [S+6-6] (used reg = )
! Debug: expression subtree swapping
mov	ax,*$A
xor	bx,bx
lea	di,-4[bp]
call	lmulul
! Debug: sub unsigned long = bx+0 to unsigned long val = [S+6+4] (used reg = )
push	bx
push	ax
mov	ax,6[bp]
mov	bx,8[bp]
lea	di,-8[bp]
call	lsubul
add	sp,*4
! Debug: add unsigned long = const $30 to unsigned long = bx+0 (used reg = )
push	bx
push	ax
mov	ax,*$30
xor	bx,bx
push	bx
push	ax
mov	ax,-8[bp]
mov	bx,-6[bp]
lea	di,-$C[bp]
call	laddul
add	sp,*8
! Debug: list unsigned long = bx+0 (used reg = )
push	bx
push	ax
! Debug: list unsigned short action = [S+$A+2] (used reg = )
push	4[bp]
! Debug: func () void = send+0 (used reg = )
call	_send
add	sp,*6
!BCC_EOS
! 1021 }
mov	sp,bp
pop	bp
ret
! 1022 void put_str(action, segment, offset)
! Register BX used in function put_luint
! 1023   Bit16u action;
export	_put_str
_put_str:
!BCC_EOS
! 1024   Bit16u segment;
!BCC_EOS
! 1025   Bit16u offset;
!BCC_EOS
! 1026 {
! 1027   Bit8u c;
!BCC_EOS
! 1028   while (c = _read_byte(offset, segment)) {
push	bp
mov	bp,sp
dec	sp
dec	sp
jmp .23
.24:
! 1029     send(action, c);
! Debug: list unsigned char c = [S+4-3] (used reg = )
mov	al,-1[bp]
xor	ah,ah
push	ax
! Debug: list unsigned short action = [S+6+2] (used reg = )
push	4[bp]
! Debug: func () void = send+0 (used reg = )
call	_send
add	sp,*4
!BCC_EOS
! 1030     offset++;
! Debug: postinc unsigned short offset = [S+4+6] (used reg = )
mov	ax,8[bp]
inc	ax
mov	8[bp],ax
!BCC_EOS
! 1031   }
! 1032 }
.23:
! Debug: list unsigned short segment = [S+4+4] (used reg = )
push	6[bp]
! Debug: list unsigned short offset = [S+6+6] (used reg = )
push	8[bp]
! Debug: func () unsigned char = _read_byte+0 (used reg = )
call	__read_byte
add	sp,*4
! Debug: eq unsigned char = al+0 to unsigned char c = [S+4-3] (used reg = )
mov	-1[bp],al
test	al,al
jne	.24
.25:
.22:
mov	sp,bp
pop	bp
ret
! 1033   void
! 1034 delay_ticks(ticks)
! 1035   Bit16u ticks;
export	_delay_ticks
_delay_ticks:
!BCC_EOS
! 1036 {
! 1037   long ticks_to_wait, delta;
!BCC_EOS
! 1038   Bit32u prev_ticks, t;
!BCC_EOS
! 1039 #asm
push	bp
mov	bp,sp
add	sp,*-$10
!BCC_EOS
!BCC_ASM
_delay_ticks.ticks	set	$14
.delay_ticks.ticks	set	4
_delay_ticks.t	set	0
.delay_ticks.t	set	-$10
_delay_ticks.prev_ticks	set	4
.delay_ticks.prev_ticks	set	-$C
_delay_ticks.delta	set	8
.delay_ticks.delta	set	-8
_delay_ticks.ticks_to_wait	set	$C
.delay_ticks.ticks_to_wait	set	-4
  pushf
  push ds
  push #0x00
  pop ds
  sti
! 1045 endasm
!BCC_ENDASM
!BCC_EOS
! 1046   ticks_to_wait = ticks;
! Debug: eq unsigned short ticks = [S+$12+2] to long ticks_to_wait = [S+$12-6] (used reg = )
mov	ax,4[bp]
xor	bx,bx
mov	-4[bp],ax
mov	-2[bp],bx
!BCC_EOS
! 1047   prev_ticks = *((Bit32u *)(0x46c));
! Debug: eq unsigned long = [+$46C] to unsigned long prev_ticks = [S+$12-$E] (used reg = )
mov	ax,[$46C]
mov	bx,[$46E]
mov	-$C[bp],ax
mov	-$A[bp],bx
!BCC_EOS
! 1048   do
! 1049   {
.28:
! 1050 #asm
!BCC_EOS
!BCC_ASM
_delay_ticks.ticks	set	$14
.delay_ticks.ticks	set	4
_delay_ticks.t	set	0
.delay_ticks.t	set	-$10
_delay_ticks.prev_ticks	set	4
.delay_ticks.prev_ticks	set	-$C
_delay_ticks.delta	set	8
.delay_ticks.delta	set	-8
_delay_ticks.ticks_to_wait	set	$C
.delay_ticks.ticks_to_wait	set	-4
    hlt
! 1052 endasm
!BCC_ENDASM
!BCC_EOS
! 1053     t = *((Bit32u *)(0x46c));
! Debug: eq unsigned long = [+$46C] to unsigned long t = [S+$12-$12] (used reg = )
mov	ax,[$46C]
mov	bx,[$46E]
mov	-$10[bp],ax
mov	-$E[bp],bx
!BCC_EOS
! 1054     if (t > prev_ticks)
! Debug: gt unsigned long prev_ticks = [S+$12-$E] to unsigned long t = [S+$12-$12] (used reg = )
mov	ax,-$C[bp]
mov	bx,-$A[bp]
lea	di,-$10[bp]
call	lcmpul
jae 	.29
.2A:
! 1055     {
! 1056       delta = t - prev_ticks;
! Debug: sub unsigned long prev_ticks = [S+$12-$E] to unsigned long t = [S+$12-$12] (used reg = )
mov	ax,-$10[bp]
mov	bx,-$E[bp]
lea	di,-$C[bp]
call	lsubul
! Debug: eq unsigned long = bx+0 to long delta = [S+$12-$A] (used reg = )
mov	-8[bp],ax
mov	-6[bp],bx
!BCC_EOS
! 1057       ticks_to_wait -= delta;
! Debug: subab long delta = [S+$12-$A] to long ticks_to_wait = [S+$12-6] (used reg = )
mov	ax,-4[bp]
mov	bx,-2[bp]
lea	di,-8[bp]
call	lsubl
mov	-4[bp],ax
mov	-2[bp],bx
!BCC_EOS
! 1058     }
! 1059     else if (t < prev_ticks)
jmp .2B
.29:
! Debug: lt unsigned long prev_ticks = [S+$12-$E] to unsigned long t = [S+$12-$12] (used reg = )
mov	ax,-$C[bp]
mov	bx,-$A[bp]
lea	di,-$10[bp]
call	lcmpul
jbe 	.2C
.2D:
! 1060     {
! 1061       ticks_to_wait -= t;
! Debug: subab unsigned long t = [S+$12-$12] to long ticks_to_wait = [S+$12-6] (used reg = )
mov	ax,-4[bp]
mov	bx,-2[bp]
lea	di,-$10[bp]
call	lsubul
mov	-4[bp],ax
mov	-2[bp],bx
!BCC_EOS
! 1062     }
! 1063     prev_ticks = t;
.2C:
.2B:
! Debug: eq unsigned long t = [S+$12-$12] to unsigned long prev_ticks = [S+$12-$E] (used reg = )
mov	ax,-$10[bp]
mov	bx,-$E[bp]
mov	-$C[bp],ax
mov	-$A[bp],bx
!BCC_EOS
! 1064   } while (ticks_to_wait > 0);
.27:
! Debug: gt long = const 0 to long ticks_to_wait = [S+$12-6] (used reg = )
xor	ax,ax
xor	bx,bx
lea	di,-4[bp]
call	lcmpl
jl 	.28
.2E:
!BCC_EOS
! 1065 #asm
.26:
!BCC_EOS
!BCC_ASM
_delay_ticks.ticks	set	$14
.delay_ticks.ticks	set	4
_delay_ticks.t	set	0
.delay_ticks.t	set	-$10
_delay_ticks.prev_ticks	set	4
.delay_ticks.prev_ticks	set	-$C
_delay_ticks.delta	set	8
.delay_ticks.delta	set	-8
_delay_ticks.ticks_to_wait	set	$C
.delay_ticks.ticks_to_wait	set	-4
  cli
  pop ds
  popf
! 1069 endasm
!BCC_ENDASM
!BCC_EOS
! 1070 }
mov	sp,bp
pop	bp
ret
! 1071   Bit8u
! Register BX used in function delay_ticks
! 1072 check_for_keystroke()
! 1073 {
export	_check_for_keystroke
_check_for_keystroke:
! 1074 #asm
!BCC_ASM
  mov ax, #0x100
  int #0x16
  jz no_key
  mov al, #1
  jmp done
no_key:
  xor al, al
done:
! 1083 endasm
!BCC_ENDASM
! 1084 }
ret
! 1085   Bit8u
! 1086 get_keystroke()
! 1087 {
export	_get_keystroke
_get_keystroke:
! 1088 #asm
!BCC_ASM
  mov ax, #0x0
  int #0x16
  xchg ah, al
! 1092 endasm
!BCC_ENDASM
! 1093 }
ret
! 1094   void
! 1095 delay_ticks_and_check_for_keystroke(ticks, count)
! 1096   Bit16u ticks, count;
export	_delay_ticks_and_check_for_keystroke
_delay_ticks_and_check_for_keystroke:
!BCC_EOS
! 1097 {
! 1098   Bit16u i;
!BCC_EOS
! 1099   for (i = 1; i <= count; i++) {
push	bp
mov	bp,sp
dec	sp
dec	sp
! Debug: eq int = const 1 to unsigned short i = [S+4-4] (used reg = )
mov	ax,*1
mov	-2[bp],ax
!BCC_EOS
!BCC_EOS
jmp .31
.32:
! 1100     delay_ticks(ticks);
! Debug: list unsigned short ticks = [S+4+2] (used reg = )
push	4[bp]
! Debug: func () void = delay_ticks+0 (used reg = )
call	_delay_ticks
inc	sp
inc	sp
!BCC_EOS
! 1101     if (check_for_keystroke())
! Debug: func () unsigned char = check_for_keystroke+0 (used reg = )
call	_check_for_keystroke
test	al,al
je  	.33
.34:
! 1102       break;
jmp .2F
!BCC_EOS
! 1103   }
.33:
! 1104 }
.30:
! Debug: postinc unsigned short i = [S+4-4] (used reg = )
mov	ax,-2[bp]
inc	ax
mov	-2[bp],ax
.31:
! Debug: le unsigned short count = [S+4+4] to unsigned short i = [S+4-4] (used reg = )
mov	ax,-2[bp]
cmp	ax,6[bp]
jbe	.32
.35:
.2F:
mov	sp,bp
pop	bp
ret
! 1105   void
! 1106 bios_printf(action, s)
! 1107   Bit16u action;
export	_bios_printf
_bios_printf:
!BCC_EOS
! 1108   Bit8u *s;
!BCC_EOS
! 1109 {
! 1110   Bit8u c, format_char;
!BCC_EOS
! 1111   bx_bool in_format;
!BCC_EOS
! 1112   short i;
!BCC_EOS
! 1113   Bit16u *arg_ptr;
!BCC_EOS
! 1114   Bit16u arg, nibble, shift_count, format_width;
!BCC_EOS
! 1115   Bit16u old_ds = set_DS(get_CS());
push	bp
mov	bp,sp
add	sp,*-$12
! Debug: func () unsigned short = get_CS+0 (used reg = )
call	_get_CS
! Debug: list unsigned short = ax+0 (used reg = )
push	ax
! Debug: func () unsigned short = set_DS+0 (used reg = )
call	_set_DS
inc	sp
inc	sp
! Debug: eq unsigned short = ax+0 to unsigned short old_ds = [S+$14-$14] (used reg = )
mov	-$12[bp],ax
!BCC_EOS
! 1116   Bit32u lval;
!BCC_EOS
! 1117   arg_ptr = &s;
add	sp,*-4
! Debug: eq * * unsigned char s = S+$18+4 to * unsigned short arg_ptr = [S+$18-$A] (used reg = )
lea	bx,6[bp]
mov	-8[bp],bx
!BCC_EOS
! 1118   in_format = 0;
! Debug: eq int = const 0 to unsigned short in_format = [S+$18-6] (used reg = )
xor	ax,ax
mov	-4[bp],ax
!BCC_EOS
! 1119   format_width = 0;
! Debug: eq int = const 0 to unsigned short format_width = [S+$18-$12] (used reg = )
xor	ax,ax
mov	-$10[bp],ax
!BCC_EOS
! 1120   if ((action & (2 | 4 | 1)) == (2 | 4 | 1)) {
! Debug: and int = const 7 to unsigned short action = [S+$18+2] (used reg = )
mov	al,4[bp]
and	al,*7
! Debug: logeq int = const 7 to unsigned char = al+0 (used reg = )
cmp	al,*7
jne 	.36
.37:
! 1121     outb(0x401, 0x00);
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const $401 (used reg = )
mov	ax,#$401
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1122     bios_printf (2, "FATAL: ");
! Debug: list * char = .38+0 (used reg = )
mov	bx,#.38
push	bx
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*4
!BCC_EOS
! 1123   }
! 1124   while (c = *((Bit8u *)(s))) {
.36:
br 	.3A
.3B:
! 1125     if ( c == '%' ) {
! Debug: logeq int = const $25 to unsigned char c = [S+$18-3] (used reg = )
mov	al,-1[bp]
cmp	al,*$25
jne 	.3C
.3D:
! 1126       in_format = 1;
! Debug: eq int = const 1 to unsigned short in_format = [S+$18-6] (used reg = )
mov	ax,*1
mov	-4[bp],ax
!BCC_EOS
! 1127       format_width = 0;
! Debug: eq int = const 0 to unsigned short format_width = [S+$18-$12] (used reg = )
xor	ax,ax
mov	-$10[bp],ax
!BCC_EOS
! 1128     }
! 1129     else if (in_format) {
br 	.3E
.3C:
mov	ax,-4[bp]
test	ax,ax
beq 	.3F
.40:
! 1130       if ( (c>='0') && (c<='9') ) {
! Debug: ge int = const $30 to unsigned char c = [S+$18-3] (used reg = )
mov	al,-1[bp]
cmp	al,*$30
jb  	.41
.43:
! Debug: le int = const $39 to unsigned char c = [S+$18-3] (used reg = )
mov	al,-1[bp]
cmp	al,*$39
ja  	.41
.42:
! 1131         format_width = (format_width * 10) + (c - '0');
! Debug: sub int = const $30 to unsigned char c = [S+$18-3] (used reg = )
mov	al,-1[bp]
xor	ah,ah
add	ax,*-$30
push	ax
! Debug: mul int = const $A to unsigned short format_width = [S+$1A-$12] (used reg = )
mov	ax,-$10[bp]
mov	dx,ax
shl	ax,*1
shl	ax,*1
add	ax,dx
shl	ax,*1
! Debug: add unsigned int (temp) = [S+$1A-$1A] to unsigned int = ax+0 (used reg = )
add	ax,-$18[bp]
inc	sp
inc	sp
! Debug: eq unsigned int = ax+0 to unsigned short format_width = [S+$18-$12] (used reg = )
mov	-$10[bp],ax
!BCC_EOS
! 1132       }
! 1133       else {
br 	.44
.41:
! 1134         arg_ptr++;
! Debug: postinc * unsigned short arg_ptr = [S+$18-$A] (used reg = )
mov	bx,-8[bp]
inc	bx
inc	bx
mov	-8[bp],bx
!BCC_EOS
! 1135         arg = read_word_SS(arg_ptr);
! Debug: list * unsigned short arg_ptr = [S+$18-$A] (used reg = )
push	-8[bp]
! Debug: func () unsigned short = read_word_SS+0 (used reg = )
call	_read_word_SS
inc	sp
inc	sp
! Debug: eq unsigned short = ax+0 to unsigned short arg = [S+$18-$C] (used reg = )
mov	-$A[bp],ax
!BCC_EOS
! 1136         if ((c & 0xdf) == 'X') {
! Debug: and int = const $DF to unsigned char c = [S+$18-3] (used reg = )
mov	al,-1[bp]
and	al,#$DF
! Debug: logeq int = const $58 to unsigned char = al+0 (used reg = )
cmp	al,*$58
jne 	.45
.46:
! 1137           if (format_width == 0)
! Debug: logeq int = const 0 to unsigned short format_width = [S+$18-$12] (used reg = )
mov	ax,-$10[bp]
test	ax,ax
jne 	.47
.48:
! 1138             format_width = 4;
! Debug: eq int = const 4 to unsigned short format_width = [S+$18-$12] (used reg = )
mov	ax,*4
mov	-$10[bp],ax
!BCC_EOS
! 1139           for (i=format_width-1; i>=0; i--) {
.47:
! Debug: sub int = const 1 to unsigned short format_width = [S+$18-$12] (used reg = )
mov	ax,-$10[bp]
! Debug: eq unsigned int = ax-1 to short i = [S+$18-8] (used reg = )
dec	ax
mov	-6[bp],ax
!BCC_EOS
!BCC_EOS
jmp .4B
.4C:
! 1140             nibble = (arg >> (4 * i)) & 0x000f;
! Debug: mul short i = [S+$18-8] to int = const 4 (used reg = )
! Debug: expression subtree swapping
mov	ax,-6[bp]
shl	ax,*1
shl	ax,*1
! Debug: sr int = ax+0 to unsigned short arg = [S+$18-$C] (used reg = )
mov	bx,ax
mov	ax,-$A[bp]
mov	cx,bx
shr	ax,cl
! Debug: and int = const $F to unsigned int = ax+0 (used reg = )
and	al,*$F
! Debug: eq unsigned char = al+0 to unsigned short nibble = [S+$18-$E] (used reg = )
xor	ah,ah
mov	-$C[bp],ax
!BCC_EOS
! 1141             send (action, (nibble<=9)? (nibble+'0') : (nibble+c-33));
! Debug: le int = const 9 to unsigned short nibble = [S+$18-$E] (used reg = )
mov	ax,-$C[bp]
cmp	ax,*9
ja  	.4D
.4E:
! Debug: add int = const $30 to unsigned short nibble = [S+$18-$E] (used reg = )
mov	ax,-$C[bp]
add	ax,*$30
jmp .4F
.4D:
! Debug: add unsigned char c = [S+$18-3] to unsigned short nibble = [S+$18-$E] (used reg = )
mov	ax,-$C[bp]
add	al,-1[bp]
adc	ah,*0
! Debug: sub int = const $21 to unsigned int = ax+0 (used reg = )
add	ax,*-$21
.4F:
! Debug: list unsigned int = ax+0 (used reg = )
push	ax
! Debug: list unsigned short action = [S+$1A+2] (used reg = )
push	4[bp]
! Debug: func () void = send+0 (used reg = )
call	_send
add	sp,*4
!BCC_EOS
! 1142           }
! 1143         }
.4A:
! Debug: postdec short i = [S+$18-8] (used reg = )
mov	ax,-6[bp]
dec	ax
mov	-6[bp],ax
.4B:
! Debug: ge int = const 0 to short i = [S+$18-8] (used reg = )
mov	ax,-6[bp]
test	ax,ax
jge	.4C
.50:
.49:
! 1144         else if (c == 'u') {
br 	.51
.45:
! Debug: logeq int = const $75 to unsigned char c = [S+$18-3] (used reg = )
mov	al,-1[bp]
cmp	al,*$75
jne 	.52
.53:
! 1145           put_uint(action, arg, format_width, 0);
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list unsigned short format_width = [S+$1A-$12] (used reg = )
push	-$10[bp]
! Debug: list unsigned short arg = [S+$1C-$C] (used reg = )
push	-$A[bp]
! Debug: list unsigned short action = [S+$1E+2] (used reg = )
push	4[bp]
! Debug: func () void = put_uint+0 (used reg = )
call	_put_uint
add	sp,*8
!BCC_EOS
! 1146         }
! 1147         else if (c == 'l') {
br 	.54
.52:
! Debug: logeq int = const $6C to unsigned char c = [S+$18-3] (used reg = )
mov	al,-1[bp]
cmp	al,*$6C
bne 	.55
.56:
! 1148           s++;
! Debug: postinc * unsigned char s = [S+$18+4] (used reg = )
mov	bx,6[bp]
inc	bx
mov	6[bp],bx
!BCC_EOS
! 1149           c = *((Bit8u *)(s));
mov	bx,6[bp]
! Debug: eq unsigned char = [bx+0] to unsigned char c = [S+$18-3] (used reg = )
mov	al,[bx]
mov	-1[bp],al
!BCC_EOS
! 1150           arg_ptr++;
! Debug: postinc * unsigned short arg_ptr = [S+$18-$A] (used reg = )
mov	bx,-8[bp]
inc	bx
inc	bx
mov	-8[bp],bx
!BCC_EOS
! 1151           *(((Bit16u *)&lval)+1) = read_word_SS(arg_ptr);
! Debug: list * unsigned short arg_ptr = [S+$18-$A] (used reg = )
push	-8[bp]
! Debug: func () unsigned short = read_word_SS+0 (used reg = )
call	_read_word_SS
inc	sp
inc	sp
! Debug: eq unsigned short = ax+0 to unsigned short lval = [S+$18-$16] (used reg = )
mov	-$14[bp],ax
!BCC_EOS
! 1152           *((Bit16u *)&lval) = arg;
! Debug: eq unsigned short arg = [S+$18-$C] to unsigned short lval = [S+$18-$18] (used reg = )
mov	ax,-$A[bp]
mov	-$16[bp],ax
!BCC_EOS
! 1153           if (c == 'd') {
! Debug: logeq int = const $64 to unsigned char c = [S+$18-3] (used reg = )
mov	al,-1[bp]
cmp	al,*$64
jne 	.57
.58:
! 1154             if (*(((Bit16u *)&lval)+1) & 0x8000)
! Debug: and unsigned int = const $8000 to unsigned short lval = [S+$18-$16] (used reg = )
mov	ax,-$14[bp]
and	ax,#$8000
test	ax,ax
je  	.59
.5A:
! 1155               put_luint(action, 0L-lval, format_width-1, 1);
! Debug: list int = const 1 (used reg = )
mov	ax,*1
push	ax
! Debug: sub int = const 1 to unsigned short format_width = [S+$1A-$12] (used reg = )
mov	ax,-$10[bp]
! Debug: list unsigned int = ax-1 (used reg = )
dec	ax
push	ax
! Debug: sub unsigned long lval = [S+$1C-$18] to long = const 0 (used reg = )
xor	ax,ax
xor	bx,bx
lea	di,-$16[bp]
call	lsubul
! Debug: list unsigned long = bx+0 (used reg = )
push	bx
push	ax
! Debug: list unsigned short action = [S+$20+2] (used reg = )
push	4[bp]
! Debug: func () void = put_luint+0 (used reg = )
call	_put_luint
add	sp,*$A
!BCC_EOS
! 1156             else
! 1157               put_luint(action, lval, format_width, 0);
jmp .5B
.59:
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list unsigned short format_width = [S+$1A-$12] (used reg = )
push	-$10[bp]
! Debug: list unsigned long lval = [S+$1C-$18] (used reg = )
push	-$14[bp]
push	-$16[bp]
! Debug: list unsigned short action = [S+$20+2] (used reg = )
push	4[bp]
! Debug: func () void = put_luint+0 (used reg = )
call	_put_luint
add	sp,*$A
!BCC_EOS
! 1158           }
.5B:
! 1159           else if (c == 'u') {
br 	.5C
.57:
! Debug: logeq int = const $75 to unsigned char c = [S+$18-3] (used reg = )
mov	al,-1[bp]
cmp	al,*$75
jne 	.5D
.5E:
! 1160             put_luint(action, lval, format_width, 0);
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list unsigned short format_width = [S+$1A-$12] (used reg = )
push	-$10[bp]
! Debug: list unsigned long lval = [S+$1C-$18] (used reg = )
push	-$14[bp]
push	-$16[bp]
! Debug: list unsigned short action = [S+$20+2] (used reg = )
push	4[bp]
! Debug: func () void = put_luint+0 (used reg = )
call	_put_luint
add	sp,*$A
!BCC_EOS
! 1161           }
! 1162           else if ((c & 0xdf) == 'X')
jmp .5F
.5D:
! Debug: and int = const $DF to unsigned char c = [S+$18-3] (used reg = )
mov	al,-1[bp]
and	al,#$DF
! Debug: logeq int = const $58 to unsigned char = al+0 (used reg = )
cmp	al,*$58
jne 	.60
.61:
! 1163           {
! 1164             if (format_width == 0)
! Debug: logeq int = const 0 to unsigned short format_width = [S+$18-$12] (used reg = )
mov	ax,-$10[bp]
test	ax,ax
jne 	.62
.63:
! 1165               format_width = 8;
! Debug: eq int = const 8 to unsigned short format_width = [S+$18-$12] (used reg = )
mov	ax,*8
mov	-$10[bp],ax
!BCC_EOS
! 1166             for (i=format_
.62:
! 1166 width-1; i>=0; i--) {
! Debug: sub int = const 1 to unsigned short format_width = [S+$18-$12] (used reg = )
mov	ax,-$10[bp]
! Debug: eq unsigned int = ax-1 to short i = [S+$18-8] (used reg = )
dec	ax
mov	-6[bp],ax
!BCC_EOS
!BCC_EOS
jmp .66
.67:
! 1167               nibble = ((Bit16u)(lval >> (4 * i))) & 0x000f;
! Debug: mul short i = [S+$18-8] to int = const 4 (used reg = )
! Debug: expression subtree swapping
mov	ax,-6[bp]
shl	ax,*1
shl	ax,*1
! Debug: sr int = ax+0 to unsigned long lval = [S+$18-$18] (used reg = )
push	ax
mov	ax,-$16[bp]
mov	bx,-$14[bp]
mov	di,-$18[bp]
call	lsrul
inc	sp
inc	sp
! Debug: cast unsigned short = const 0 to unsigned long = bx+0 (used reg = )
! Debug: and int = const $F to unsigned short = ax+0 (used reg = )
and	al,*$F
! Debug: eq unsigned char = al+0 to unsigned short nibble = [S+$18-$E] (used reg = )
xor	ah,ah
mov	-$C[bp],ax
!BCC_EOS
! 1168               send (action, (nibble<=9)? (nibble+'0') : (nibble+c-33));
! Debug: le int = const 9 to unsigned short nibble = [S+$18-$E] (used reg = )
mov	ax,-$C[bp]
cmp	ax,*9
ja  	.68
.69:
! Debug: add int = const $30 to unsigned short nibble = [S+$18-$E] (used reg = )
mov	ax,-$C[bp]
add	ax,*$30
jmp .6A
.68:
! Debug: add unsigned char c = [S+$18-3] to unsigned short nibble = [S+$18-$E] (used reg = )
mov	ax,-$C[bp]
add	al,-1[bp]
adc	ah,*0
! Debug: sub int = const $21 to unsigned int = ax+0 (used reg = )
add	ax,*-$21
.6A:
! Debug: list unsigned int = ax+0 (used reg = )
push	ax
! Debug: list unsigned short action = [S+$1A+2] (used reg = )
push	4[bp]
! Debug: func () void = send+0 (used reg = )
call	_send
add	sp,*4
!BCC_EOS
! 1169             }
! 1170           }
.65:
! Debug: postdec short i = [S+$18-8] (used reg = )
mov	ax,-6[bp]
dec	ax
mov	-6[bp],ax
.66:
! Debug: ge int = const 0 to short i = [S+$18-8] (used reg = )
mov	ax,-6[bp]
test	ax,ax
jge	.67
.6B:
.64:
! 1171         }
.60:
.5F:
.5C:
! 1172         else if (c == 'd') {
br 	.6C
.55:
! Debug: logeq int = const $64 to unsigned char c = [S+$18-3] (used reg = )
mov	al,-1[bp]
cmp	al,*$64
jne 	.6D
.6E:
! 1173           if (arg & 0x8000)
! Debug: and unsigned int = const $8000 to unsigned short arg = [S+$18-$C] (used reg = )
mov	ax,-$A[bp]
and	ax,#$8000
test	ax,ax
je  	.6F
.70:
! 1174             put_uint(action, -arg, format_width - 1, 1);
! Debug: list int = const 1 (used reg = )
mov	ax,*1
push	ax
! Debug: sub int = const 1 to unsigned short format_width = [S+$1A-$12] (used reg = )
mov	ax,-$10[bp]
! Debug: list unsigned int = ax-1 (used reg = )
dec	ax
push	ax
! Debug: neg unsigned short arg = [S+$1C-$C] (used reg = )
xor	ax,ax
sub	ax,-$A[bp]
! Debug: list unsigned int = ax+0 (used reg = )
push	ax
! Debug: list unsigned short action = [S+$1E+2] (used reg = )
push	4[bp]
! Debug: func () void = put_uint+0 (used reg = )
call	_put_uint
add	sp,*8
!BCC_EOS
! 1175           else
! 1176             put_uint(action, arg, format_width, 0);
jmp .71
.6F:
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list unsigned short format_width = [S+$1A-$12] (used reg = )
push	-$10[bp]
! Debug: list unsigned short arg = [S+$1C-$C] (used reg = )
push	-$A[bp]
! Debug: list unsigned short action = [S+$1E+2] (used reg = )
push	4[bp]
! Debug: func () void = put_uint+0 (used reg = )
call	_put_uint
add	sp,*8
!BCC_EOS
! 1177         }
.71:
! 1178         else if (c == 's') {
jmp .72
.6D:
! Debug: logeq int = const $73 to unsigned char c = [S+$18-3] (used reg = )
mov	al,-1[bp]
cmp	al,*$73
jne 	.73
.74:
! 1179           put_str(action, get_CS(), arg);
! Debug: list unsigned short arg = [S+$18-$C] (used reg = )
push	-$A[bp]
! Debug: func () unsigned short = get_CS+0 (used reg = )
call	_get_CS
! Debug: list unsigned short = ax+0 (used reg = )
push	ax
! Debug: list unsigned short action = [S+$1C+2] (used reg = )
push	4[bp]
! Debug: func () void = put_str+0 (used reg = )
call	_put_str
add	sp,*6
!BCC_EOS
! 1180         }
! 1181         else if (c == 'S') {
jmp .75
.73:
! Debug: logeq int = const $53 to unsigned char c = [S+$18-3] (used reg = )
mov	al,-1[bp]
cmp	al,*$53
jne 	.76
.77:
! 1182           arg_ptr++;
! Debug: postinc * unsigned short arg_ptr = [S+$18-$A] (used reg = )
mov	bx,-8[bp]
inc	bx
inc	bx
mov	-8[bp],bx
!BCC_EOS
! 1183           put_str(action, arg, read_word_SS(arg_ptr));
! Debug: list * unsigned short arg_ptr = [S+$18-$A] (used reg = )
push	-8[bp]
! Debug: func () unsigned short = read_word_SS+0 (used reg = )
call	_read_word_SS
inc	sp
inc	sp
! Debug: list unsigned short = ax+0 (used reg = )
push	ax
! Debug: list unsigned short arg = [S+$1A-$C] (used reg = )
push	-$A[bp]
! Debug: list unsigned short action = [S+$1C+2] (used reg = )
push	4[bp]
! Debug: func () void = put_str+0 (used reg = )
call	_put_str
add	sp,*6
!BCC_EOS
! 1184         }
! 1185         else if (c == 'c') {
jmp .78
.76:
! Debug: logeq int = const $63 to unsigned char c = [S+$18-3] (used reg = )
mov	al,-1[bp]
cmp	al,*$63
jne 	.79
.7A:
! 1186           send(action, arg);
! Debug: list unsigned short arg = [S+$18-$C] (used reg = )
push	-$A[bp]
! Debug: list unsigned short action = [S+$1A+2] (used reg = )
push	4[bp]
! Debug: func () void = send+0 (used reg = )
call	_send
add	sp,*4
!BCC_EOS
! 1187         }
! 1188         else
! 1189           bios_printf((2 | 4 | 1), "bios_printf: unknown format\n");
jmp .7B
.79:
! Debug: list * char = .7C+0 (used reg = )
mov	bx,#.7C
push	bx
! Debug: list int = const 7 (used reg = )
mov	ax,*7
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*4
!BCC_EOS
! 1190           in_format = 0;
.7B:
.78:
.75:
.72:
.6C:
.54:
.51:
! Debug: eq int = const 0 to unsigned short in_format = [S+$18-6] (used reg = )
xor	ax,ax
mov	-4[bp],ax
!BCC_EOS
! 1191       }
! 1192     }
.44:
! 1193     else {
jmp .7D
.3F:
! 1194       send(action, c);
! Debug: list unsigned char c = [S+$18-3] (used reg = )
mov	al,-1[bp]
xor	ah,ah
push	ax
! Debug: list unsigned short action = [S+$1A+2] (used reg = )
push	4[bp]
! Debug: func () void = send+0 (used reg = )
call	_send
add	sp,*4
!BCC_EOS
! 1195     }
! 1196     s ++;
.7D:
.3E:
! Debug: postinc * unsigned char s = [S+$18+4] (used reg = )
mov	bx,6[bp]
inc	bx
mov	6[bp],bx
!BCC_EOS
! 1197   }
! 1198   if (action & 1) {
.3A:
mov	bx,6[bp]
! Debug: eq unsigned char = [bx+0] to unsigned char c = [S+$18-3] (used reg = )
mov	al,[bx]
mov	-1[bp],al
test	al,al
bne 	.3B
.7E:
.39:
! Debug: and int = const 1 to unsigned short action = [S+$18+2] (used reg = )
mov	al,4[bp]
and	al,*1
test	al,al
je  	.7F
.80:
! 1199 #asm
!BCC_EOS
!BCC_ASM
_bios_printf.format_width	set	6
.bios_printf.format_width	set	-$10
_bios_printf.format_char	set	$14
.bios_printf.format_char	set	-2
_bios_printf.arg_ptr	set	$E
.bios_printf.arg_ptr	set	-8
_bios_printf.action	set	$1A
.bios_printf.action	set	4
_bios_printf.i	set	$10
.bios_printf.i	set	-6
_bios_printf.shift_count	set	8
.bios_printf.shift_count	set	-$E
_bios_printf.in_format	set	$12
.bios_printf.in_format	set	-4
_bios_printf.s	set	$1C
.bios_printf.s	set	6
_bios_printf.lval	set	0
.bios_printf.lval	set	-$16
_bios_printf.nibble	set	$A
.bios_printf.nibble	set	-$C
_bios_printf.c	set	$15
.bios_printf.c	set	-1
_bios_printf.arg	set	$C
.bios_printf.arg	set	-$A
_bios_printf.old_ds	set	4
.bios_printf.old_ds	set	-$12
    cli
 halt2_loop:
    hlt
    jmp halt2_loop
! 1204 endasm
!BCC_ENDASM
!BCC_EOS
! 1205   }
! 1206   set_DS(old_ds);
.7F:
! Debug: list unsigned short old_ds = [S+$18-$14] (used reg = )
push	-$12[bp]
! Debug: func () unsigned short = set_DS+0 (used reg = )
call	_set_DS
inc	sp
inc	sp
!BCC_EOS
! 1207 }
mov	sp,bp
pop	bp
ret
! 1208   void
! Register BX used in function bios_printf
! 1209 keyboard_init()
! 1210 {
export	_keyboard_init
_keyboard_init:
! 1211     Bit16u max;
!BCC_EOS
! 1212     max=0xffff;
push	bp
mov	bp,sp
dec	sp
dec	sp
! Debug: eq unsigned int = const $FFFF to unsigned short max = [S+4-4] (used reg = )
mov	ax,#$FFFF
mov	-2[bp],ax
!BCC_EOS
! 1213     while ( (inb(0x0064) & 0x02) && (--max>0)) outb(0x0080, 0x00);
jmp .82
.83:
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const $80 (used reg = )
mov	ax,#$80
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1214     max=0x2000;
.82:
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: and int = const 2 to unsigned char = al+0 (used reg = )
and	al,*2
test	al,al
je  	.84
.85:
! Debug: predec unsigned short max = [S+4-4] (used reg = )
mov	ax,-2[bp]
dec	ax
mov	-2[bp],ax
! Debug: gt int = const 0 to unsigned short = ax+0 (used reg = )
test	ax,ax
jne	.83
.84:
.81:
! Debug: eq int = const $2000 to unsigned short max = [S+4-4] (used reg = )
mov	ax,#$2000
mov	-2[bp],ax
!BCC_EOS
! 1215     while (--max > 0) {
jmp .87
.88:
! 1216         outb(0x0080, 0x00);
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const $80 (used reg = )
mov	ax,#$80
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1217         if (inb(0x0064) & 0x01) {
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: and int = const 1 to unsigned char = al+0 (used reg = )
and	al,*1
test	al,al
je  	.89
.8A:
! 1218             inb(0x0060);
! Debug: list int = const $60 (used reg = )
mov	ax,*$60
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
!BCC_EOS
! 1219             max = 0x2000;
! Debug: eq int = const $2000 to unsigned short max = [S+4-4] (used reg = )
mov	ax,#$2000
mov	-2[bp],ax
!BCC_EOS
! 1220         }
! 1221     }
.89:
! 1222     outb(0x0064, 0xaa);
.87:
! Debug: predec unsigned short max = [S+4-4] (used reg = )
mov	ax,-2[bp]
dec	ax
mov	-2[bp],ax
! Debug: gt int = const 0 to unsigned short = ax+0 (used reg = )
test	ax,ax
jne	.88
.8B:
.86:
! Debug: list int = const $AA (used reg = )
mov	ax,#$AA
push	ax
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1223     max=0xffff;
! Debug: eq unsigned int = const $FFFF to unsigned short max = [S+4-4] (used reg = )
mov	ax,#$FFFF
mov	-2[bp],ax
!BCC_EOS
! 1224     while ( (inb(0x0064) & 0x02) && (--max>0)) outb(0x0080, 0x00);
jmp .8D
.8E:
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const $80 (used reg = )
mov	ax,#$80
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1225     if (max==0x0) keyboard_panic(00);
.8D:
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: and int = const 2 to unsigned char = al+0 (used reg = )
and	al,*2
test	al,al
je  	.8F
.90:
! Debug: predec unsigned short max = [S+4-4] (used reg = )
mov	ax,-2[bp]
dec	ax
mov	-2[bp],ax
! Debug: gt int = const 0 to unsigned short = ax+0 (used reg = )
test	ax,ax
jne	.8E
.8F:
.8C:
! Debug: logeq int = const 0 to unsigned short max = [S+4-4] (used reg = )
mov	ax,-2[bp]
test	ax,ax
jne 	.91
.92:
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: func () void = keyboard_panic+0 (used reg = )
call	_keyboard_panic
inc	sp
inc	sp
!BCC_EOS
! 1226     max=0xffff;
.91:
! Debug: eq unsigned int = const $FFFF to unsigned short max = [S+4-4] (used reg = )
mov	ax,#$FFFF
mov	-2[bp],ax
!BCC_EOS
! 1227     while ( ((inb(0x0064) & 0x01) == 0) && (--max>0) ) outb(0x0080, 0x01);
jmp .94
.95:
! Debug: list int = const 1 (used reg = )
mov	ax,*1
push	ax
! Debug: list int = const $80 (used reg = )
mov	ax,#$80
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1228     if (max==0x0) keyboard_panic(01);
.94:
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: and int = const 1 to unsigned char = al+0 (used reg = )
and	al,*1
! Debug: logeq int = const 0 to unsigned char = al+0 (used reg = )
test	al,al
jne 	.96
.97:
! Debug: predec unsigned short max = [S+4-4] (used reg = )
mov	ax,-2[bp]
dec	ax
mov	-2[bp],ax
! Debug: gt int = const 0 to unsigned short = ax+0 (used reg = )
test	ax,ax
jne	.95
.96:
.93:
! Debug: logeq int = const 0 to unsigned short max = [S+4-4] (used reg = )
mov	ax,-2[bp]
test	ax,ax
jne 	.98
.99:
! Debug: list int = const 1 (used reg = )
mov	ax,*1
push	ax
! Debug: func () void = keyboard_panic+0 (used reg = )
call	_keyboard_panic
inc	sp
inc	sp
!BCC_EOS
! 1229     if ((inb(0x0060) != 0x55)){
.98:
! Debug: list int = const $60 (used reg = )
mov	ax,*$60
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: ne int = const $55 to unsigned char = al+0 (used reg = )
cmp	al,*$55
je  	.9A
.9B:
! 1230         keyboard_panic(991);
! Debug: list int = const $3DF (used reg = )
mov	ax,#$3DF
push	ax
! Debug: func () void = keyboard_panic+0 (used reg = )
call	_keyboard_panic
inc	sp
inc	sp
!BCC_EOS
! 1231     }
! 1232     outb(0x0064,0xab);
.9A:
! Debug: list int = const $AB (used reg = )
mov	ax,#$AB
push	ax
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1233     max=0xffff;
! Debug: eq unsigned int = const $FFFF to unsigned short max = [S+4-4] (used reg = )
mov	ax,#$FFFF
mov	-2[bp],ax
!BCC_EOS
! 1234     while ((inb(0x0064) & 0x02) && (--max>0)) outb(0x0080, 0x10);
jmp .9D
.9E:
! Debug: list int = const $10 (used reg = )
mov	ax,*$10
push	ax
! Debug: list int = const $80 (used reg = )
mov	ax,#$80
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1235     if (max==0x0) keyboard_panic(10);
.9D:
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: and int = const 2 to unsigned char = al+0 (used reg = )
and	al,*2
test	al,al
je  	.9F
.A0:
! Debug: predec unsigned short max = [S+4-4] (used reg = )
mov	ax,-2[bp]
dec	ax
mov	-2[bp],ax
! Debug: gt int = const 0 to unsigned short = ax+0 (used reg = )
test	ax,ax
jne	.9E
.9F:
.9C:
! Debug: logeq int = const 0 to unsigned short max = [S+4-4] (used reg = )
mov	ax,-2[bp]
test	ax,ax
jne 	.A1
.A2:
! Debug: list int = const $A (used reg = )
mov	ax,*$A
push	ax
! Debug: func () void = keyboard_panic+0 (used reg = )
call	_keyboard_panic
inc	sp
inc	sp
!BCC_EOS
! 1236     max=0xffff;
.A1:
! Debug: eq unsigned int = const $FFFF to unsigned short max = [S+4-4] (used reg = )
mov	ax,#$FFFF
mov	-2[bp],ax
!BCC_EOS
! 1237     while ( ((inb(0x0064) & 0x01) == 0) && (--max>0) ) outb(0x0080, 0x11);
jmp .A4
.A5:
! Debug: list int = const $11 (used reg = )
mov	ax,*$11
push	ax
! Debug: list int = const $80 (used reg = )
mov	ax,#$80
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1238     if (max==0x0) keyboard_panic(11);
.A4:
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: and int = const 1 to unsigned char = al+0 (used reg = )
and	al,*1
! Debug: logeq int = const 0 to unsigned char = al+0 (used reg = )
test	al,al
jne 	.A6
.A7:
! Debug: predec unsigned short max = [S+4-4] (used reg = )
mov	ax,-2[bp]
dec	ax
mov	-2[bp],ax
! Debug: gt int = const 0 to unsigned short = ax+0 (used reg = )
test	ax,ax
jne	.A5
.A6:
.A3:
! Debug: logeq int = const 0 to unsigned short max = [S+4-4] (used reg = )
mov	ax,-2[bp]
test	ax,ax
jne 	.A8
.A9:
! Debug: list int = const $B (used reg = )
mov	ax,*$B
push	ax
! Debug: func () void = keyboard_panic+0 (used reg = )
call	_keyboard_panic
inc	sp
inc	sp
!BCC_EOS
! 1239     if ((inb(0x0060) != 0x00)) {
.A8:
! Debug: list int = const $60 (used reg = )
mov	ax,*$60
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: ne int = const 0 to unsigned char = al+0 (used reg = )
test	al,al
je  	.AA
.AB:
! 1240         keyboard_panic(992);
! Debug: list int = const $3E0 (used reg = )
mov	ax,#$3E0
push	ax
! Debug: func () void = keyboard_panic+0 (used reg = )
call	_keyboard_panic
inc	sp
inc	sp
!BCC_EOS
! 1241     }
! 1242     outb(0x0064,0xae);
.AA:
! Debug: list int = const $AE (used reg = )
mov	ax,#$AE
push	ax
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1243     max=0xffff;
! Debug: eq unsigned int = const $FFFF to unsigned short max = [S+4-4] (used reg = )
mov	ax,#$FFFF
mov	-2[bp],ax
!BCC_EOS
! 1244     while ((inb(0x0064) & 0x02) && (--max>0)) outb(0x0080, 0x10);
jmp .AD
.AE:
! Debug: list int = const $10 (used reg = )
mov	ax,*$10
push	ax
! Debug: list int = const $80 (used reg = )
mov	ax,#$80
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1245     if (max==0x0) keyboard_panic(10);
.AD:
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: and int = const 2 to unsigned char = al+0 (used reg = )
and	al,*2
test	al,al
je  	.AF
.B0:
! Debug: predec unsigned short max = [S+4-4] (used reg = )
mov	ax,-2[bp]
dec	ax
mov	-2[bp],ax
! Debug: gt int = const 0 to unsigned short = ax+0 (used reg = )
test	ax,ax
jne	.AE
.AF:
.AC:
! Debug: logeq int = const 0 to unsigned short max = [S+4-4] (used reg = )
mov	ax,-2[bp]
test	ax,ax
jne 	.B1
.B2:
! Debug: list int = const $A (used reg = )
mov	ax,*$A
push	ax
! Debug: func () void = keyboard_panic+0 (used reg = )
call	_keyboard_panic
inc	sp
inc	sp
!BCC_EOS
! 1246     o
! 1246 utb(0x0064,0xa8);
.B1:
! Debug: list int = const $A8 (used reg = )
mov	ax,#$A8
push	ax
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1247     max=0xffff;
! Debug: eq unsigned int = const $FFFF to unsigned short max = [S+4-4] (used reg = )
mov	ax,#$FFFF
mov	-2[bp],ax
!BCC_EOS
! 1248     while ((inb(0x0064) & 0x02) && (--max>0)) outb(0x0080, 0x10);
jmp .B4
.B5:
! Debug: list int = const $10 (used reg = )
mov	ax,*$10
push	ax
! Debug: list int = const $80 (used reg = )
mov	ax,#$80
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1249     if (max==0x0) keyboard_panic(10);
.B4:
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: and int = const 2 to unsigned char = al+0 (used reg = )
and	al,*2
test	al,al
je  	.B6
.B7:
! Debug: predec unsigned short max = [S+4-4] (used reg = )
mov	ax,-2[bp]
dec	ax
mov	-2[bp],ax
! Debug: gt int = const 0 to unsigned short = ax+0 (used reg = )
test	ax,ax
jne	.B5
.B6:
.B3:
! Debug: logeq int = const 0 to unsigned short max = [S+4-4] (used reg = )
mov	ax,-2[bp]
test	ax,ax
jne 	.B8
.B9:
! Debug: list int = const $A (used reg = )
mov	ax,*$A
push	ax
! Debug: func () void = keyboard_panic+0 (used reg = )
call	_keyboard_panic
inc	sp
inc	sp
!BCC_EOS
! 1250     outb(0x0060, 0xff);
.B8:
! Debug: list int = const $FF (used reg = )
mov	ax,#$FF
push	ax
! Debug: list int = const $60 (used reg = )
mov	ax,*$60
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1251     max=0xffff;
! Debug: eq unsigned int = const $FFFF to unsigned short max = [S+4-4] (used reg = )
mov	ax,#$FFFF
mov	-2[bp],ax
!BCC_EOS
! 1252     while ((inb(0x0064) & 0x02) && (--max>0)) outb(0x0080, 0x20);
jmp .BB
.BC:
! Debug: list int = const $20 (used reg = )
mov	ax,*$20
push	ax
! Debug: list int = const $80 (used reg = )
mov	ax,#$80
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1253     if (max==0x0) keyboard_panic(20);
.BB:
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: and int = const 2 to unsigned char = al+0 (used reg = )
and	al,*2
test	al,al
je  	.BD
.BE:
! Debug: predec unsigned short max = [S+4-4] (used reg = )
mov	ax,-2[bp]
dec	ax
mov	-2[bp],ax
! Debug: gt int = const 0 to unsigned short = ax+0 (used reg = )
test	ax,ax
jne	.BC
.BD:
.BA:
! Debug: logeq int = const 0 to unsigned short max = [S+4-4] (used reg = )
mov	ax,-2[bp]
test	ax,ax
jne 	.BF
.C0:
! Debug: list int = const $14 (used reg = )
mov	ax,*$14
push	ax
! Debug: func () void = keyboard_panic+0 (used reg = )
call	_keyboard_panic
inc	sp
inc	sp
!BCC_EOS
! 1254     max=0xffff;
.BF:
! Debug: eq unsigned int = const $FFFF to unsigned short max = [S+4-4] (used reg = )
mov	ax,#$FFFF
mov	-2[bp],ax
!BCC_EOS
! 1255     while ( ((inb(0x0064) & 0x01) == 0) && (--max>0) ) outb(0x0080, 0x21);
jmp .C2
.C3:
! Debug: list int = const $21 (used reg = )
mov	ax,*$21
push	ax
! Debug: list int = const $80 (used reg = )
mov	ax,#$80
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1256     if (max==0x0) keyboard_panic(21);
.C2:
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: and int = const 1 to unsigned char = al+0 (used reg = )
and	al,*1
! Debug: logeq int = const 0 to unsigned char = al+0 (used reg = )
test	al,al
jne 	.C4
.C5:
! Debug: predec unsigned short max = [S+4-4] (used reg = )
mov	ax,-2[bp]
dec	ax
mov	-2[bp],ax
! Debug: gt int = const 0 to unsigned short = ax+0 (used reg = )
test	ax,ax
jne	.C3
.C4:
.C1:
! Debug: logeq int = const 0 to unsigned short max = [S+4-4] (used reg = )
mov	ax,-2[bp]
test	ax,ax
jne 	.C6
.C7:
! Debug: list int = const $15 (used reg = )
mov	ax,*$15
push	ax
! Debug: func () void = keyboard_panic+0 (used reg = )
call	_keyboard_panic
inc	sp
inc	sp
!BCC_EOS
! 1257     if ((inb(0x0060) != 0xfa)) {
.C6:
! Debug: list int = const $60 (used reg = )
mov	ax,*$60
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: ne int = const $FA to unsigned char = al+0 (used reg = )
cmp	al,#$FA
je  	.C8
.C9:
! 1258         keyboard_panic(993);
! Debug: list int = const $3E1 (used reg = )
mov	ax,#$3E1
push	ax
! Debug: func () void = keyboard_panic+0 (used reg = )
call	_keyboard_panic
inc	sp
inc	sp
!BCC_EOS
! 1259     }
! 1260     max=0xffff;
.C8:
! Debug: eq unsigned int = const $FFFF to unsigned short max = [S+4-4] (used reg = )
mov	ax,#$FFFF
mov	-2[bp],ax
!BCC_EOS
! 1261     while ( ((inb(0x0064) & 0x01) == 0) && (--max>0) ) outb(0x0080, 0x31);
jmp .CB
.CC:
! Debug: list int = const $31 (used reg = )
mov	ax,*$31
push	ax
! Debug: list int = const $80 (used reg = )
mov	ax,#$80
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1262     if (max==0x0) keyboard_panic(31);
.CB:
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: and int = const 1 to unsigned char = al+0 (used reg = )
and	al,*1
! Debug: logeq int = const 0 to unsigned char = al+0 (used reg = )
test	al,al
jne 	.CD
.CE:
! Debug: predec unsigned short max = [S+4-4] (used reg = )
mov	ax,-2[bp]
dec	ax
mov	-2[bp],ax
! Debug: gt int = const 0 to unsigned short = ax+0 (used reg = )
test	ax,ax
jne	.CC
.CD:
.CA:
! Debug: logeq int = const 0 to unsigned short max = [S+4-4] (used reg = )
mov	ax,-2[bp]
test	ax,ax
jne 	.CF
.D0:
! Debug: list int = const $1F (used reg = )
mov	ax,*$1F
push	ax
! Debug: func () void = keyboard_panic+0 (used reg = )
call	_keyboard_panic
inc	sp
inc	sp
!BCC_EOS
! 1263     if ((inb(0x0060) != 0xaa)) {
.CF:
! Debug: list int = const $60 (used reg = )
mov	ax,*$60
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: ne int = const $AA to unsigned char = al+0 (used reg = )
cmp	al,#$AA
je  	.D1
.D2:
! 1264         keyboard_panic(994);
! Debug: list int = const $3E2 (used reg = )
mov	ax,#$3E2
push	ax
! Debug: func () void = keyboard_panic+0 (used reg = )
call	_keyboard_panic
inc	sp
inc	sp
!BCC_EOS
! 1265     }
! 1266     outb(0x0060, 0xf5);
.D1:
! Debug: list int = const $F5 (used reg = )
mov	ax,#$F5
push	ax
! Debug: list int = const $60 (used reg = )
mov	ax,*$60
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1267     max=0xffff;
! Debug: eq unsigned int = const $FFFF to unsigned short max = [S+4-4] (used reg = )
mov	ax,#$FFFF
mov	-2[bp],ax
!BCC_EOS
! 1268     while ((inb(0x0064) & 0x02) && (--max>0)) outb(0x0080, 0x40);
jmp .D4
.D5:
! Debug: list int = const $40 (used reg = )
mov	ax,*$40
push	ax
! Debug: list int = const $80 (used reg = )
mov	ax,#$80
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1269     if (max==0x0) keyboard_panic(40);
.D4:
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: and int = const 2 to unsigned char = al+0 (used reg = )
and	al,*2
test	al,al
je  	.D6
.D7:
! Debug: predec unsigned short max = [S+4-4] (used reg = )
mov	ax,-2[bp]
dec	ax
mov	-2[bp],ax
! Debug: gt int = const 0 to unsigned short = ax+0 (used reg = )
test	ax,ax
jne	.D5
.D6:
.D3:
! Debug: logeq int = const 0 to unsigned short max = [S+4-4] (used reg = )
mov	ax,-2[bp]
test	ax,ax
jne 	.D8
.D9:
! Debug: list int = const $28 (used reg = )
mov	ax,*$28
push	ax
! Debug: func () void = keyboard_panic+0 (used reg = )
call	_keyboard_panic
inc	sp
inc	sp
!BCC_EOS
! 1270     max=0xffff;
.D8:
! Debug: eq unsigned int = const $FFFF to unsigned short max = [S+4-4] (used reg = )
mov	ax,#$FFFF
mov	-2[bp],ax
!BCC_EOS
! 1271     while ( ((inb(0x0064) & 0x01) == 0) && (--max>0) ) outb(0x0080, 0x41);
jmp .DB
.DC:
! Debug: list int = const $41 (used reg = )
mov	ax,*$41
push	ax
! Debug: list int = const $80 (used reg = )
mov	ax,#$80
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1272     if (max==0x0) keyboard_panic(41);
.DB:
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: and int = const 1 to unsigned char = al+0 (used reg = )
and	al,*1
! Debug: logeq int = const 0 to unsigned char = al+0 (used reg = )
test	al,al
jne 	.DD
.DE:
! Debug: predec unsigned short max = [S+4-4] (used reg = )
mov	ax,-2[bp]
dec	ax
mov	-2[bp],ax
! Debug: gt int = const 0 to unsigned short = ax+0 (used reg = )
test	ax,ax
jne	.DC
.DD:
.DA:
! Debug: logeq int = const 0 to unsigned short max = [S+4-4] (used reg = )
mov	ax,-2[bp]
test	ax,ax
jne 	.DF
.E0:
! Debug: list int = const $29 (used reg = )
mov	ax,*$29
push	ax
! Debug: func () void = keyboard_panic+0 (used reg = )
call	_keyboard_panic
inc	sp
inc	sp
!BCC_EOS
! 1273     if ((inb(0x0060) != 0xfa)) {
.DF:
! Debug: list int = const $60 (used reg = )
mov	ax,*$60
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: ne int = const $FA to unsigned char = al+0 (used reg = )
cmp	al,#$FA
je  	.E1
.E2:
! 1274         keyboard_panic(995);
! Debug: list int = const $3E3 (used reg = )
mov	ax,#$3E3
push	ax
! Debug: func () void = keyboard_panic+0 (used reg = )
call	_keyboard_panic
inc	sp
inc	sp
!BCC_EOS
! 1275     }
! 1276     outb(0x0064, 0x60);
.E1:
! Debug: list int = const $60 (used reg = )
mov	ax,*$60
push	ax
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1277     max=0xffff;
! Debug: eq unsigned int = const $FFFF to unsigned short max = [S+4-4] (used reg = )
mov	ax,#$FFFF
mov	-2[bp],ax
!BCC_EOS
! 1278     while ((inb(0x0064) & 0x02) && (--max>0)) outb(0x0080, 0x50);
jmp .E4
.E5:
! Debug: list int = const $50 (used reg = )
mov	ax,*$50
push	ax
! Debug: list int = const $80 (used reg = )
mov	ax,#$80
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1279     if (max==0x0) keyboard_panic(50);
.E4:
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: and int = const 2 to unsigned char = al+0 (used reg = )
and	al,*2
test	al,al
je  	.E6
.E7:
! Debug: predec unsigned short max = [S+4-4] (used reg = )
mov	ax,-2[bp]
dec	ax
mov	-2[bp],ax
! Debug: gt int = const 0 to unsigned short = ax+0 (used reg = )
test	ax,ax
jne	.E5
.E6:
.E3:
! Debug: logeq int = const 0 to unsigned short max = [S+4-4] (used reg = )
mov	ax,-2[bp]
test	ax,ax
jne 	.E8
.E9:
! Debug: list int = const $32 (used reg = )
mov	ax,*$32
push	ax
! Debug: func () void = keyboard_panic+0 (used reg = )
call	_keyboard_panic
inc	sp
inc	sp
!BCC_EOS
! 1280     outb(0x0060, 0x61);
.E8:
! Debug: list int = const $61 (used reg = )
mov	ax,*$61
push	ax
! Debug: list int = const $60 (used reg = )
mov	ax,*$60
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1281     max=0xffff;
! Debug: eq unsigned int = const $FFFF to unsigned short max = [S+4-4] (used reg = )
mov	ax,#$FFFF
mov	-2[bp],ax
!BCC_EOS
! 1282     while ((inb(0x0064) & 0x02) && (--max>0)) outb(0x0080, 0x60);
jmp .EB
.EC:
! Debug: list int = const $60 (used reg = )
mov	ax,*$60
push	ax
! Debug: list int = const $80 (used reg = )
mov	ax,#$80
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1283     if (max==0x0) keyboard_panic(60);
.EB:
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: and int = const 2 to unsigned char = al+0 (used reg = )
and	al,*2
test	al,al
je  	.ED
.EE:
! Debug: predec unsigned short max = [S+4-4] (used reg = )
mov	ax,-2[bp]
dec	ax
mov	-2[bp],ax
! Debug: gt int = const 0 to unsigned short = ax+0 (used reg = )
test	ax,ax
jne	.EC
.ED:
.EA:
! Debug: logeq int = const 0 to unsigned short max = [S+4-4] (used reg = )
mov	ax,-2[bp]
test	ax,ax
jne 	.EF
.F0:
! Debug: list int = const $3C (used reg = )
mov	ax,*$3C
push	ax
! Debug: func () void = keyboard_panic+0 (used reg = )
call	_keyboard_panic
inc	sp
inc	sp
!BCC_EOS
! 1284     outb(0x0060, 0xf4);
.EF:
! Debug: list int = const $F4 (used reg = )
mov	ax,#$F4
push	ax
! Debug: list int = const $60 (used reg = )
mov	ax,*$60
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1285     max=0xffff;
! Debug: eq unsigned int = const $FFFF to unsigned short max = [S+4-4] (used reg = )
mov	ax,#$FFFF
mov	-2[bp],ax
!BCC_EOS
! 1286     while ((inb(0x0064) & 0x02) && (--max>0)) outb(0x0080, 0x70);
jmp .F2
.F3:
! Debug: list int = const $70 (used reg = )
mov	ax,*$70
push	ax
! Debug: list int = const $80 (used reg = )
mov	ax,#$80
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1287     if (max==0x0) keyboard_panic(70);
.F2:
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: and int = const 2 to unsigned char = al+0 (used reg = )
and	al,*2
test	al,al
je  	.F4
.F5:
! Debug: predec unsigned short max = [S+4-4] (used reg = )
mov	ax,-2[bp]
dec	ax
mov	-2[bp],ax
! Debug: gt int = const 0 to unsigned short = ax+0 (used reg = )
test	ax,ax
jne	.F3
.F4:
.F1:
! Debug: logeq int = const 0 to unsigned short max = [S+4-4] (used reg = )
mov	ax,-2[bp]
test	ax,ax
jne 	.F6
.F7:
! Debug: list int = const $46 (used reg = )
mov	ax,*$46
push	ax
! Debug: func () void = keyboard_panic+0 (used reg = )
call	_keyboard_panic
inc	sp
inc	sp
!BCC_EOS
! 1288     max=0xffff;
.F6:
! Debug: eq unsigned int = const $FFFF to unsigned short max = [S+4-4] (used reg = )
mov	ax,#$FFFF
mov	-2[bp],ax
!BCC_EOS
! 1289     while ( ((inb(0x0064) & 0x01) == 0) && (--max>0) ) outb(0x0080, 0x71);
jmp .F9
.FA:
! Debug: list int = const $71 (used reg = )
mov	ax,*$71
push	ax
! Debug: list int = const $80 (used reg = )
mov	ax,#$80
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1290     if (max==0x0) keyboard_panic(70);
.F9:
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: and int = const 1 to unsigned char = al+0 (used reg = )
and	al,*1
! Debug: logeq int = const 0 to unsigned char = al+0 (used reg = )
test	al,al
jne 	.FB
.FC:
! Debug: predec unsigned short max = [S+4-4] (used reg = )
mov	ax,-2[bp]
dec	ax
mov	-2[bp],ax
! Debug: gt int = const 0 to unsigned short = ax+0 (used reg = )
test	ax,ax
jne	.FA
.FB:
.F8:
! Debug: logeq int = const 0 to unsigned short max = [S+4-4] (used reg = )
mov	ax,-2[bp]
test	ax,ax
jne 	.FD
.FE:
! Debug: list int = const $46 (used reg = )
mov	ax,*$46
push	ax
! Debug: func () void = keyboard_panic+0 (used reg = )
call	_keyboard_panic
inc	sp
inc	sp
!BCC_EOS
! 1291     if ((inb(0x0060) != 0xfa)) {
.FD:
! Debug: list int = const $60 (used reg = )
mov	ax,*$60
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: ne int = const $FA to unsigned char = al+0 (used reg = )
cmp	al,#$FA
je  	.FF
.100:
! 1292         keyboard_panic(996);
! Debug: list int = const $3E4 (used reg = )
mov	ax,#$3E4
push	ax
! Debug: func () void = keyboard_panic+0 (used reg = )
call	_keyboard_panic
inc	sp
inc	sp
!BCC_EOS
! 1293     }
! 1294     outb(0x0080, 0x77);
.FF:
! Debug: list int = const $77 (used reg = )
mov	ax,*$77
push	ax
! Debug: list int = const $80 (used reg = )
mov	ax,#$80
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1295 }
mov	sp,bp
pop	bp
ret
! 1296   void
! 1297 keyboard_panic(status)
! 1298   Bit16u status;
export	_keyboard_panic
_keyboard_panic:
!BCC_EOS
! 1299 {
! 1300   bios_printf((2 | 4 | 1), "Keyboard error:%u\n",status);
push	bp
mov	bp,sp
! Debug: list unsigned short status = [S+2+2] (used reg = )
push	4[bp]
! Debug: list * char = .101+0 (used reg = )
mov	bx,#.101
push	bx
! Debug: list int = const 7 (used reg = )
mov	ax,*7
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
mov	sp,bp
!BCC_EOS
! 1301 }
pop	bp
ret
! 1302   void
! Register BX used in function keyboard_panic
! 1303 shutdown_status_panic(status)
! 1304   Bit16u status;
export	_shutdown_status_panic
_shutdown_status_panic:
!BCC_EOS
! 1305 {
! 1306   bios_printf((2 | 4 | 1), "Unimplemented shutdown status: %02x\n",(Bit8u)status);
push	bp
mov	bp,sp
! Debug: list unsigned char status = [S+2+2] (used reg = )
mov	al,4[bp]
xor	ah,ah
push	ax
! Debug: list * char = .102+0 (used reg = )
mov	bx,#.102
push	bx
! Debug: list int = const 7 (used reg = )
mov	ax,*7
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
mov	sp,bp
!BCC_EOS
! 1307 }
pop	bp
ret
! 1308 void s3_resume_panic()
! Register BX used in function shutdown_status_panic
! 1309 {
export	_s3_resume_panic
_s3_resume_panic:
! 1310   bios_printf((2 | 4 | 1), "Returned from s3_resume.\n");
push	bp
mov	bp,sp
! Debug: list * char = .103+0 (used reg = )
mov	bx,#.103
push	bx
! Debug: list int = const 7 (used reg = )
mov	ax,*7
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
mov	sp,bp
!BCC_EOS
! 1311 }
pop	bp
ret
! 1312 void
! Register BX used in function s3_resume_panic
! 1313 print_bios_banner()
! 1314 {
export	_print_bios_banner
_print_bios_banner:
! 1315   bios_printf(
push	bp
mov	bp,sp
! 1315 2, "Bochs ""2.7"" BIOS - build: %s\n%s\nOptions: ", "08/01/21", bios_svn_version_string);
! Debug: list * char = bios_svn_version_string+0 (used reg = )
mov	bx,#_bios_svn_version_string
push	bx
! Debug: list * char = .105+0 (used reg = )
mov	bx,#.105
push	bx
! Debug: list * char = .104+0 (used reg = )
mov	bx,#.104
push	bx
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
mov	sp,bp
!BCC_EOS
! 1316   bios_printf(2, "apmbios " "pcibios " "pnpbios " "eltorito " "\n\n");
! Debug: list * char = .106+0 (used reg = )
mov	bx,#.106
push	bx
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
mov	sp,bp
!BCC_EOS
! 1317 }
pop	bp
ret
! 1318 static char drivetypes[][10]={"", "Floppy","Hard Disk","CD-Rom", "Network"};
! Register BX used in function print_bios_banner
.data
_drivetypes:
.107:
.byte	0
.blkb	9
.108:
.ascii	"Floppy"
.byte	0
.blkb	3
.109:
.ascii	"Hard Disk"
.byte	0
.10A:
.ascii	"CD-Rom"
.byte	0
.blkb	3
.10B:
.ascii	"Network"
.byte	0
.blkb	2
!BCC_EOS
! 1319 static void
! 1320 init_boot_vectors()
! 1321 {
.text
_init_boot_vectors:
! 1322   ipl_entry_t e;
!BCC_EOS
! 1323   Bit16u count = 0;
push	bp
mov	bp,sp
add	sp,*-$12
! Debug: eq int = const 0 to unsigned short count = [S+$14-$14] (used reg = )
xor	ax,ax
mov	-$12[bp],ax
!BCC_EOS
! 1324   Bit16u ss = get_SS();
dec	sp
dec	sp
! Debug: func () unsigned short = get_SS+0 (used reg = )
call	_get_SS
! Debug: eq unsigned short = ax+0 to unsigned short ss = [S+$16-$16] (used reg = )
mov	-$14[bp],ax
!BCC_EOS
! 1325 #asm
!BCC_EOS
!BCC_ASM
_init_boot_vectors.count	set	2
.init_boot_vectors.count	set	-$12
_init_boot_vectors.ss	set	0
.init_boot_vectors.ss	set	-$14
_init_boot_vectors.e	set	4
.init_boot_vectors.e	set	-$10
  push ds
! 1327 endasm
!BCC_ENDASM
!BCC_EOS
! 1328   set_DS(0x9ff0);
! Debug: list unsigned int = const $9FF0 (used reg = )
mov	ax,#$9FF0
push	ax
! Debug: func () unsigned short = set_DS+0 (used reg = )
call	_set_DS
inc	sp
inc	sp
!BCC_EOS
! 1329   _memsetb(0,0x0000,0x9ff0,0x86);
! Debug: list int = const $86 (used reg = )
mov	ax,#$86
push	ax
! Debug: list unsigned int = const $9FF0 (used reg = )
mov	ax,#$9FF0
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: func () void = _memsetb+0 (used reg = )
call	__memsetb
add	sp,*8
!BCC_EOS
! 1330   *((Bit16u *)(0x0084)) = (0xFFFF);
! Debug: eq unsigned int = const $FFFF to unsigned short = [+$84] (used reg = )
mov	ax,#$FFFF
mov	[$84],ax
!BCC_EOS
! 1331   e.type = 0x01; e.flags = 0; e.vector = 0; e.description = 0; e.reserved = 0;
! Debug: eq int = const 1 to unsigned short e = [S+$16-$12] (used reg = )
mov	ax,*1
mov	-$10[bp],ax
!BCC_EOS
! Debug: eq int = const 0 to unsigned short e = [S+$16-$10] (used reg = )
xor	ax,ax
mov	-$E[bp],ax
!BCC_EOS
! Debug: eq int = const 0 to unsigned long e = [S+$16-$E] (used reg = )
xor	ax,ax
xor	bx,bx
mov	-$C[bp],ax
mov	-$A[bp],bx
!BCC_EOS
! Debug: eq int = const 0 to unsigned long e = [S+$16-$A] (used reg = )
xor	ax,ax
xor	bx,bx
mov	-8[bp],ax
mov	-6[bp],bx
!BCC_EOS
! Debug: eq int = const 0 to unsigned long e = [S+$16-6] (used reg = )
xor	ax,ax
xor	bx,bx
mov	-4[bp],ax
mov	-2[bp],bx
!BCC_EOS
! 1332   _memcpyb(0x0000 + count * sizeof (e),0x9ff0,&e,ss,sizeof (e));
! Debug: list int = const $10 (used reg = )
mov	ax,*$10
push	ax
! Debug: list unsigned short ss = [S+$18-$16] (used reg = )
push	-$14[bp]
! Debug: list * struct  e = S+$1A-$12 (used reg = )
lea	bx,-$10[bp]
push	bx
! Debug: list unsigned int = const $9FF0 (used reg = )
mov	ax,#$9FF0
push	ax
! Debug: mul int = const $10 to unsigned short count = [S+$1E-$14] (used reg = )
mov	ax,-$12[bp]
mov	cl,*4
shl	ax,cl
! Debug: add unsigned int = ax+0 to int = const 0 (used reg = )
! Debug: expression subtree swapping
! Debug: list unsigned int = ax+0 (used reg = )
push	ax
! Debug: func () void = _memcpyb+0 (used reg = )
call	__memcpyb
add	sp,*$A
!BCC_EOS
! 1333   count++;
! Debug: postinc unsigned short count = [S+$16-$14] (used reg = )
mov	ax,-$12[bp]
inc	ax
mov	-$12[bp],ax
!BCC_EOS
! 1334   e.type = 0x02; e.flags = 0; e.vector = 0; e.description = 0; e.reserved = 0;
! Debug: eq int = const 2 to unsigned short e = [S+$16-$12] (used reg = )
mov	ax,*2
mov	-$10[bp],ax
!BCC_EOS
! Debug: eq int = const 0 to unsigned short e = [S+$16-$10] (used reg = )
xor	ax,ax
mov	-$E[bp],ax
!BCC_EOS
! Debug: eq int = const 0 to unsigned long e = [S+$16-$E] (used reg = )
xor	ax,ax
xor	bx,bx
mov	-$C[bp],ax
mov	-$A[bp],bx
!BCC_EOS
! Debug: eq int = const 0 to unsigned long e = [S+$16-$A] (used reg = )
xor	ax,ax
xor	bx,bx
mov	-8[bp],ax
mov	-6[bp],bx
!BCC_EOS
! Debug: eq int = const 0 to unsigned long e = [S+$16-6] (used reg = )
xor	ax,ax
xor	bx,bx
mov	-4[bp],ax
mov	-2[bp],bx
!BCC_EOS
! 1335   _memcpyb(0x0000 + count * sizeof (e),0x9ff0,&e,ss,sizeof (e));
! Debug: list int = const $10 (used reg = )
mov	ax,*$10
push	ax
! Debug: list unsigned short ss = [S+$18-$16] (used reg = )
push	-$14[bp]
! Debug: list * struct  e = S+$1A-$12 (used reg = )
lea	bx,-$10[bp]
push	bx
! Debug: list unsigned int = const $9FF0 (used reg = )
mov	ax,#$9FF0
push	ax
! Debug: mul int = const $10 to unsigned short count = [S+$1E-$14] (used reg = )
mov	ax,-$12[bp]
mov	cl,*4
shl	ax,cl
! Debug: add unsigned int = ax+0 to int = const 0 (used reg = )
! Debug: expression subtree swapping
! Debug: list unsigned int = ax+0 (used reg = )
push	ax
! Debug: func () void = _memcpyb+0 (used reg = )
call	__memcpyb
add	sp,*$A
!BCC_EOS
! 1336   count++;
! Debug: postinc unsigned short count = [S+$16-$14] (used reg = )
mov	ax,-$12[bp]
inc	ax
mov	-$12[bp],ax
!BCC_EOS
! 1337   e.type = 0x03; e.flags = 0; e.vector = 0; e.description = 0; e.reserved = 0;
! Debug: eq int = const 3 to unsigned short e = [S+$16-$12] (used reg = )
mov	ax,*3
mov	-$10[bp],ax
!BCC_EOS
! Debug: eq int = const 0 to unsigned short e = [S+$16-$10] (used reg = )
xor	ax,ax
mov	-$E[bp],ax
!BCC_EOS
! Debug: eq int = const 0 to unsigned long e = [S+$16-$E] (used reg = )
xor	ax,ax
xor	bx,bx
mov	-$C[bp],ax
mov	-$A[bp],bx
!BCC_EOS
! Debug: eq int = const 0 to unsigned long e = [S+$16-$A] (used reg = )
xor	ax,ax
xor	bx,bx
mov	-8[bp],ax
mov	-6[bp],bx
!BCC_EOS
! Debug: eq int = const 0 to unsigned long e = [S+$16-6] (used reg = )
xor	ax,ax
xor	bx,bx
mov	-4[bp],ax
mov	-2[bp],bx
!BCC_EOS
! 1338   _memcpyb(0x0000 + count * sizeof (e),0x9ff0,&e,ss,sizeof (e));
! Debug: list int = const $10 (used reg = )
mov	ax,*$10
push	ax
! Debug: list unsigned short ss = [S+$18-$16] (used reg = )
push	-$14[bp]
! Debug: list * struct  e = S+$1A-$12 (used reg = )
lea	bx,-$10[bp]
push	bx
! Debug: list unsigned int = const $9FF0 (used reg = )
mov	ax,#$9FF0
push	ax
! Debug: mul int = const $10 to unsigned short count = [S+$1E-$14] (used reg = )
mov	ax,-$12[bp]
mov	cl,*4
shl	ax,cl
! Debug: add unsigned int = ax+0 to int = const 0 (used reg = )
! Debug: expression subtree swapping
! Debug: list unsigned int = ax+0 (used reg = )
push	ax
! Debug: func () void = _memcpyb+0 (used reg = )
call	__memcpyb
add	sp,*$A
!BCC_EOS
! 1339   count++;
! Debug: postinc unsigned short count = [S+$16-$14] (used reg = )
mov	ax,-$12[bp]
inc	ax
mov	-$12[bp],ax
!BCC_EOS
! 1340   *((Bit16u *)(0x0080)) = (count);
! Debug: eq unsigned short count = [S+$16-$14] to unsigned short = [+$80] (used reg = )
mov	ax,-$12[bp]
mov	[$80],ax
!BCC_EOS
! 1341   *((Bit16u *)(0x0082)) = (0xffff);
! Debug: eq unsigned int = const $FFFF to unsigned short = [+$82] (used reg = )
mov	ax,#$FFFF
mov	[$82],ax
!BCC_EOS
! 1342 #asm
!BCC_EOS
!BCC_ASM
_init_boot_vectors.count	set	2
.init_boot_vectors.count	set	-$12
_init_boot_vectors.ss	set	0
.init_boot_vectors.ss	set	-$14
_init_boot_vectors.e	set	4
.init_boot_vectors.e	set	-$10
  pop ds
! 1344 endasm
!BCC_ENDASM
!BCC_EOS
! 1345 }
mov	sp,bp
pop	bp
ret
! 1346 static Bit8u
! Register BX used in function init_boot_vectors
! 1347 get_boot_vector(i, e)
! 1348 Bit16u i; ipl_entry_t *e;
_get_boot_vector:
!BCC_EOS
!BCC_EOS
! 1349 {
! 1350   Bit16u count;
!BCC_EOS
! 1351   Bit16u ss = get_SS();
push	bp
mov	bp,sp
add	sp,*-4
! Debug: func () unsigned short = get_SS+0 (used reg = )
call	_get_SS
! Debug: eq unsigned short = ax+0 to unsigned short ss = [S+6-6] (used reg = )
mov	-4[bp],ax
!BCC_EOS
! 1352   count = _read_word(0x0080, 0x9ff0);
! Debug: list unsigned int = const $9FF0 (used reg = )
mov	ax,#$9FF0
push	ax
! Debug: list int = const $80 (used reg = )
mov	ax,#$80
push	ax
! Debug: func () unsigned short = _read_word+0 (used reg = )
call	__read_word
add	sp,*4
! Debug: eq unsigned short = ax+0 to unsigned short count = [S+6-4] (used reg = )
mov	-2[bp],ax
!BCC_EOS
! 1353   if (i >= count) return 0;
! Debug: ge unsigned short count = [S+6-4] to unsigned short i = [S+6+2] (used reg = )
mov	ax,4[bp]
cmp	ax,-2[bp]
jb  	.10C
.10D:
xor	al,al
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 1354   _memcpyb(e,ss,0x0000 + i * sizeof (*e),0x9ff0,sizeof (*e));
.10C:
! Debug: list int = const $10 (used reg = )
mov	ax,*$10
push	ax
! Debug: list unsigned int = const $9FF0 (used reg = )
mov	ax,#$9FF0
push	ax
! Debug: mul int = const $10 to unsigned short i = [S+$A+2] (used reg = )
mov	ax,4[bp]
mov	cl,*4
shl	ax,cl
! Debug: add unsigned int = ax+0 to int = const 0 (used reg = )
! Debug: expression subtree swapping
! Debug: list unsigned int = ax+0 (used reg = )
push	ax
! Debug: list unsigned short ss = [S+$C-6] (used reg = )
push	-4[bp]
! Debug: list * struct  e = [S+$E+4] (used reg = )
push	6[bp]
! Debug: func () void = _memcpyb+0 (used reg = )
call	__memcpyb
add	sp,*$A
!BCC_EOS
! 1355   return 1;
mov	al,*1
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 1356 }
! 1357   void
! 1358 interactive_bootkey()
! 1359 {
export	_interactive_bootkey
_interactive_bootkey:
! 1360   ipl_entry_t e;
!BCC_EOS
! 1361   Bit16u count;
!BCC_EOS
! 1362   char description[33];
!BCC_EOS
! 1363   Bit8u scan_code;
!BCC_EOS
! 1364   Bit8u i;
!BCC_EOS
! 1365   Bit16u ss = get_SS();
push	bp
mov	bp,sp
add	sp,*-$38
! Debug: func () unsigned short = get_SS+0 (used reg = )
call	_get_SS
! Debug: eq unsigned short = ax+0 to unsigned short ss = [S+$3A-$3A] (used reg = )
mov	-$38[bp],ax
!BCC_EOS
! 1366   Bit16u valid_choice = 0;
dec	sp
dec	sp
! Debug: eq int = const 0 to unsigned short valid_choice = [S+$3C-$3C] (used reg = )
xor	ax,ax
mov	-$3A[bp],ax
!BCC_EOS
! 1367   while (check_for_keystroke())
! 1368     get_keystroke();
jmp .10F
.110:
! Debug: func () unsigned char = get_keystroke+0 (used reg = )
call	_get_keystroke
!BCC_EOS
! 1369   if ((inb_cmos(0x3f) & 0x01) == 0x01)
.10F:
! Debug: func () unsigned char = check_for_keystroke+0 (used reg = )
call	_check_for_keystroke
test	al,al
jne	.110
.111:
.10E:
! Debug: list int = const $3F (used reg = )
mov	ax,*$3F
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: and int = const 1 to unsigned char = al+0 (used reg = )
and	al,*1
! Debug: logeq int = const 1 to unsigned char = al+0 (used reg = )
cmp	al,*1
jne 	.112
.113:
! 1370     return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 1371   bios_printf(2, "Press F12 for boot menu.\n\n");
.112:
! Debug: list * char = .114+0 (used reg = )
mov	bx,#.114
push	bx
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*4
!BCC_EOS
! 1372   delay_ticks_and_check_for_keystroke(11, 5);
! Debug: list int = const 5 (used reg = )
mov	ax,*5
push	ax
! Debug: list int = const $B (used reg = )
mov	ax,*$B
push	ax
! Debug: func () void = delay_ticks_and_check_for_keystroke+0 (used reg = )
call	_delay_ticks_and_check_for_keystroke
add	sp,*4
!BCC_EOS
! 1373   if (check_for_keystroke())
! Debug: func () unsigned char = check_for_keystroke+0 (used reg = )
call	_check_for_keystroke
test	al,al
beq 	.115
.116:
! 1374   {
! 1375     scan_code = get_keystroke();
! Debug: func () unsigned char = get_keystroke+0 (used reg = )
call	_get_keystroke
! Debug: eq unsigned char = al+0 to unsigned char scan_code = [S+$3C-$36] (used reg = )
mov	-$34[bp],al
!BCC_EOS
! 1376     if (scan_code == 0x86)
! Debug: logeq int = const $86 to unsigned char scan_code = [S+$3C-$36] (used reg = )
mov	al,-$34[bp]
cmp	al,#$86
bne 	.117
.118:
! 1377     {
! 1378       while (check_for_keystroke())
! 1379         get_keystroke();
jmp .11A
.11B:
! Debug: func () unsigned char = get_keystroke+0 (used reg = )
call	_get_keystroke
!BCC_EOS
! 1380       bios_printf(2, "Select boot device:\n\n");
.11A:
! Debug: func () unsigned char = check_for_keystroke+0 (used reg = )
call	_check_for_keystroke
test	al,al
jne	.11B
.11C:
.119:
! Debug: list * char = .11D+0 (used reg = )
mov	bx,#.11D
push	bx
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*4
!BCC_EOS
! 1381       count = _read_word(0x0080, 0x9ff0);
! Debug: list unsigned int = const $9FF0 (used reg = )
mov	ax,#$9FF0
push	ax
! Debug: list int = const $80 (used reg = )
mov	ax,#$80
push	ax
! Debug: func () unsigned short = _read_word+0 (used reg = )
call	__read_word
add	sp,*4
! Debug: eq unsigned short = ax+0 to unsigned short count = [S+$3C-$14] (used reg = )
mov	-$12[bp],ax
!BCC_EOS
! 1382       for (i = 0; i < count; i++)
! Debug: eq int = const 0 to unsigned char i = [S+$3C-$37] (used reg = )
xor	al,al
mov	-$35[bp],al
!BCC_EOS
!BCC_EOS
! 1383       {
br 	.120
.121:
! 1384         _memcpyb(&e,ss,0x0000 + i * sizeof (e),0x9ff0,sizeof (e));
! Debug: list int = const $10 (used reg = )
mov	ax,*$10
push	ax
! Debug: list unsigned int = const $9FF0 (used reg = )
mov	ax,#$9FF0
push	ax
! Debug: mul int = const $10 to unsigned char i = [S+$40-$37] (used reg = )
mov	al,-$35[bp]
xor	ah,ah
mov	cl,*4
shl	ax,cl
! Debug: add unsigned int = ax+0 to int = const 0 (used reg = )
! Debug: expression subtree swapping
! Debug: list unsigned int = ax+0 (used reg = )
push	ax
! Debug: list unsigned short ss = [S+$42-$3A] (used reg = )
push	-$38[bp]
! Debug: list * struct  e = S+$44-$12 (used reg = )
lea	bx,-$10[bp]
push	bx
! Debug: func () void = _memcpyb+0 (used reg = )
call	__memcpyb
add	sp,*$A
!BCC_EOS
! 1385         bios_printf(2, "%d. ", i+1);
! Debug: add int = const 1 to unsigned char i = [S+$3C-$37] (used reg = )
mov	al,-$35[bp]
xor	ah,ah
! Debug: list unsigned int = ax+1 (used reg = )
inc	ax
push	ax
! Debug: list * char = .122+0 (used reg = )
mov	bx,#.122
push	bx
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*6
!BCC_EOS
! 1386         switch(e.type)
mov	ax,-$10[bp]
! 1387         
! 1387 {
br 	.125
! 1388           case 0x01:
! 1389           case 0x02:
.126:
! 1390           case 0x03:
.127:
! 1391             bios_printf(2, "%s\n", drivetypes[e.type]);
.128:
! Debug: ptradd unsigned short e = [S+$3C-$12] to [5] [$A] char = drivetypes+0 (used reg = )
mov	bx,-$10[bp]
mov	dx,bx
shl	bx,*1
shl	bx,*1
add	bx,dx
shl	bx,*1
! Debug: cast * char = const 0 to [$A] char = bx+_drivetypes+0 (used reg = )
! Debug: list * char = bx+_drivetypes+0 (used reg = )
add	bx,#_drivetypes
push	bx
! Debug: list * char = .129+0 (used reg = )
mov	bx,#.129
push	bx
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*6
!BCC_EOS
! 1392             break;
br 	.123
!BCC_EOS
! 1393           case 0x80:
! 1394             bios_printf(2, "%s", drivetypes[4]);
.12A:
! Debug: list * char = drivetypes+$28 (used reg = )
mov	bx,#_drivetypes+$28
push	bx
! Debug: list * char = .12B+0 (used reg = )
mov	bx,#.12B
push	bx
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*6
!BCC_EOS
! 1395             if (e.description != 0)
! Debug: ne unsigned long = const 0 to unsigned long e = [S+$3C-$A] (used reg = )
! Debug: expression subtree swapping
xor	ax,ax
xor	bx,bx
push	bx
push	ax
mov	ax,-8[bp]
mov	bx,-6[bp]
lea	di,-2+..FFFF[bp]
call	lcmpul
lea	sp,2+..FFFF[bp]
je  	.12C
.12D:
! 1396             {
! 1397               _memcpyb(&description,ss,*((Bit16u *)&e.description),*(((Bit16u *)&e.description)+1),32);
! Debug: list int = const $20 (used reg = )
mov	ax,*$20
push	ax
! Debug: list unsigned short e = [S+$3E-8] (used reg = )
push	-6[bp]
! Debug: list unsigned short e = [S+$40-$A] (used reg = )
push	-8[bp]
! Debug: list unsigned short ss = [S+$42-$3A] (used reg = )
push	-$38[bp]
! Debug: list * [$21] char description = S+$44-$35 (used reg = )
lea	bx,-$33[bp]
push	bx
! Debug: func () void = _memcpyb+0 (used reg = )
call	__memcpyb
add	sp,*$A
!BCC_EOS
! 1398               description[32] = 0;
! Debug: eq int = const 0 to char description = [S+$3C-$15] (used reg = )
xor	al,al
mov	-$13[bp],al
!BCC_EOS
! 1399               bios_printf(2, " [%S]", ss, description);
! Debug: list * char description = S+$3C-$35 (used reg = )
lea	bx,-$33[bp]
push	bx
! Debug: list unsigned short ss = [S+$3E-$3A] (used reg = )
push	-$38[bp]
! Debug: list * char = .12E+0 (used reg = )
mov	bx,#.12E
push	bx
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*8
!BCC_EOS
! 1400            }
! 1401            bios_printf(2, "\n");
.12C:
! Debug: list * char = .12F+0 (used reg = )
mov	bx,#.12F
push	bx
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*4
!BCC_EOS
! 1402            break;
jmp .123
!BCC_EOS
! 1403         }
! 1404       }
jmp .123
.125:
sub	ax,*1
beq 	.126
sub	ax,*1
beq 	.127
sub	ax,*1
beq 	.128
sub	ax,*$7D
beq 	.12A
.123:
..FFFF	=	-$3C
! 1405       count++;
.11F:
! Debug: postinc unsigned char i = [S+$3C-$37] (used reg = )
mov	al,-$35[bp]
inc	ax
mov	-$35[bp],al
.120:
! Debug: lt unsigned short count = [S+$3C-$14] to unsigned char i = [S+$3C-$37] (used reg = )
mov	al,-$35[bp]
xor	ah,ah
cmp	ax,-$12[bp]
blo 	.121
.130:
.11E:
! Debug: postinc unsigned short count = [S+$3C-$14] (used reg = )
mov	ax,-$12[bp]
inc	ax
mov	-$12[bp],ax
!BCC_EOS
! 1406       while (!valid_choice) {
jmp .132
.133:
! 1407         scan_code = get_keystroke();
! Debug: func () unsigned char = get_keystroke+0 (used reg = )
call	_get_keystroke
! Debug: eq unsigned char = al+0 to unsigned char scan_code = [S+$3C-$36] (used reg = )
mov	-$34[bp],al
!BCC_EOS
! 1408         if (scan_code == 0x01 || scan_code == 0x58)
! Debug: logeq int = const 1 to unsigned char scan_code = [S+$3C-$36] (used reg = )
mov	al,-$34[bp]
cmp	al,*1
je  	.135
.136:
! Debug: logeq int = const $58 to unsigned char scan_code = [S+$3C-$36] (used reg = )
mov	al,-$34[bp]
cmp	al,*$58
jne 	.134
.135:
! 1409         {
! 1410           valid_choice = 1;
! Debug: eq int = const 1 to unsigned short valid_choice = [S+$3C-$3C] (used reg = )
mov	ax,*1
mov	-$3A[bp],ax
!BCC_EOS
! 1411         }
! 1412         else if (scan_code <= count)
jmp .137
.134:
! Debug: le unsigned short count = [S+$3C-$14] to unsigned char scan_code = [S+$3C-$36] (used reg = )
mov	al,-$34[bp]
xor	ah,ah
cmp	ax,-$12[bp]
ja  	.138
.139:
! 1413         {
! 1414           valid_choice = 1;
! Debug: eq int = const 1 to unsigned short valid_choice = [S+$3C-$3C] (used reg = )
mov	ax,*1
mov	-$3A[bp],ax
!BCC_EOS
! 1415           scan_code -= 1;
! Debug: subab int = const 1 to unsigned char scan_code = [S+$3C-$36] (used reg = )
mov	al,-$34[bp]
xor	ah,ah
dec	ax
mov	-$34[bp],al
!BCC_EOS
! 1416           _write_word(scan_code, 0x0084, 0x9ff0);
! Debug: list unsigned int = const $9FF0 (used reg = )
mov	ax,#$9FF0
push	ax
! Debug: list int = const $84 (used reg = )
mov	ax,#$84
push	ax
! Debug: list unsigned char scan_code = [S+$40-$36] (used reg = )
mov	al,-$34[bp]
xor	ah,ah
push	ax
! Debug: func () void = _write_word+0 (used reg = )
call	__write_word
add	sp,*6
!BCC_EOS
! 1417         }
! 1418       }
.138:
.137:
! 1419       bios_printf(2, "\n");
.132:
mov	ax,-$3A[bp]
test	ax,ax
je 	.133
.13A:
.131:
! Debug: list * char = .13B+0 (used reg = )
mov	bx,#.13B
push	bx
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*4
!BCC_EOS
! 1420     }
! 1421   }
.117:
! 1422 }
.115:
mov	sp,bp
pop	bp
ret
! 1423 void
! Register BX used in function interactive_bootkey
! 1424 print_boot_device(e)
! 1425   ipl_entry_t *e;
export	_print_boot_device
_print_boot_device:
!BCC_EOS
! 1426 {
! 1427   Bit16u type;
!BCC_EOS
! 1428   char description[33];
!BCC_EOS
! 1429   Bit16u ss = get_SS();
push	bp
mov	bp,sp
add	sp,*-$26
! Debug: func () unsigned short = get_SS+0 (used reg = )
call	_get_SS
! Debug: eq unsigned short = ax+0 to unsigned short ss = [S+$28-$28] (used reg = )
mov	-$26[bp],ax
!BCC_EOS
! 1430   type = e->type;
mov	bx,4[bp]
! Debug: eq unsigned short = [bx+0] to unsigned short type = [S+$28-4] (used reg = )
mov	bx,[bx]
mov	-2[bp],bx
!BCC_EOS
! 1431   if (type == 0x80) type = 0x4;
! Debug: logeq int = const $80 to unsigned short type = [S+$28-4] (used reg = )
mov	ax,-2[bp]
cmp	ax,#$80
jne 	.13C
.13D:
! Debug: eq int = const 4 to unsigned short type = [S+$28-4] (used reg = )
mov	ax,*4
mov	-2[bp],ax
!BCC_EOS
! 1432   if (type == 0 || type > 0x4) bios_printf((2 | 4 | 1), "Bad drive type\n");
.13C:
! Debug: logeq int = const 0 to unsigned short type = [S+$28-4] (used reg = )
mov	ax,-2[bp]
test	ax,ax
je  	.13F
.140:
! Debug: gt int = const 4 to unsigned short type = [S+$28-4] (used reg = )
mov	ax,-2[bp]
cmp	ax,*4
jbe 	.13E
.13F:
! Debug: list * char = .141+0 (used reg = )
mov	bx,#.141
push	bx
! Debug: list int = const 7 (used reg = )
mov	ax,*7
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*4
!BCC_EOS
! 1433   bios_printf(2, "Booting from %s", drivetypes[type]);
.13E:
! Debug: ptradd unsigned short type = [S+$28-4] to [5] [$A] char = drivetypes+0 (used reg = )
mov	bx,-2[bp]
mov	dx,bx
shl	bx,*1
shl	bx,*1
add	bx,dx
shl	bx,*1
! Debug: cast * char = const 0 to [$A] char = bx+_drivetypes+0 (used reg = )
! Debug: list * char = bx+_drivetypes+0 (used reg = )
add	bx,#_drivetypes
push	bx
! Debug: list * char = .142+0 (used reg = )
mov	bx,#.142
push	bx
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*6
!BCC_EOS
! 1434   if (type == 4 && e->description != 0) {
! Debug: logeq int = const 4 to unsigned short type = [S+$28-4] (used reg = )
mov	ax,-2[bp]
cmp	ax,*4
jne 	.143
.145:
mov	bx,4[bp]
! Debug: ne unsigned long = const 0 to unsigned long = [bx+8] (used reg = )
! Debug: expression subtree swapping
xor	ax,ax
xor	si,si
push	si
push	ax
mov	ax,8[bx]
mov	bx,$A[bx]
lea	di,-$2A[bp]
call	lcmpul
lea	sp,-$26[bp]
je  	.143
.144:
! 1435     _memcpyb(&description,ss,*((Bit16u *)&e->description),*(((Bit16u *)&e->description)+1),32);
! Debug: list int = const $20 (used reg = )
mov	ax,*$20
push	ax
mov	bx,4[bp]
! Debug: address unsigned long = [bx+8] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned long = bx+8 (used reg = )
! Debug: ptradd int = const 1 to * unsigned short = bx+8 (used reg = )
! Debug: list unsigned short = [bx+$A] (used reg = )
push	$A[bx]
mov	bx,4[bp]
! Debug: address unsigned long = [bx+8] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned long = bx+8 (used reg = )
! Debug: list unsigned short = [bx+8] (used reg = )
push	8[bx]
! Debug: list unsigned short ss = [S+$2E-$28] (used reg = )
push	-$26[bp]
! Debug: list * [$21] char description = S+$30-$25 (used reg = )
lea	bx,-$23[bp]
push	bx
! Debug: func () void = _memcpyb+0 (used reg = )
call	__memcpyb
add	sp,*$A
!BCC_EOS
! 1436     description[32] = 0;
! Debug: eq int = const 0 to char description = [S+$28-5] (used reg = )
xor	al,al
mov	-3[bp],al
!BCC_EOS
! 1437     bios_printf(2, " [%S]", ss, description);
! Debug: list * char description = S+$28-$25 (used reg = )
lea	bx,-$23[bp]
push	bx
! Debug: list unsigned short ss = [S+$2A-$28] (used reg = )
push	-$26[bp]
! Debug: list * char = .146+0 (used reg = )
mov	bx,#.146
push	bx
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*8
!BCC_EOS
! 1438   }
! 1439   bios_printf(2, "...\n");
.143:
! Debug: list * char = .147+0 (used reg = )
mov	bx,#.147
push	bx
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*4
!BCC_EOS
! 1440 }
mov	sp,bp
pop	bp
ret
! 1441   void
! Register BX used in function print_boot_device
! 1442 print_boot_failure(type, reason)
! 1443   Bit16u type; Bit8u reason;
export	_print_boot_failure
_print_boot_failure:
!BCC_EOS
!BCC_EOS
! 1444 {
! 1445   if (type == 0 || type > 0x3) bios_printf((2 | 4 | 1), "Bad drive type\n");
push	bp
mov	bp,sp
! Debug: logeq int = const 0 to unsigned short type = [S+2+2] (used reg = )
mov	ax,4[bp]
test	ax,ax
je  	.149
.14A:
! Debug: gt int = const 3 to unsigned short type = [S+2+2] (used reg = )
mov	ax,4[bp]
cmp	ax,*3
jbe 	.148
.149:
! Debug: list * char = .14B+0 (used reg = )
mov	bx,#.14B
push	bx
! Debug: list int = const 7 (used reg = )
mov	ax,*7
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
mov	sp,bp
!BCC_EOS
! 1446   bios_printf(2, "Boot failed");
.148:
! Debug: list * char = .14C+0 (used reg = )
mov	bx,#.14C
push	bx
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
mov	sp,bp
!BCC_EOS
! 1447   if (type < 4) {
! Debug: lt int = const 4 to unsigned short type = [S+2+2] (used reg = )
mov	ax,4[bp]
cmp	ax,*4
jae 	.14D
.14E:
! 1448     if (reason==0)
! Debug: logeq int = const 0 to unsigned char reason = [S+2+4] (used reg = )
mov	al,6[bp]
test	al,al
jne 	.14F
.150:
! 1449       bios_printf(2, ": not a bootable disk");
! Debug: list * char = .151+0 (used reg = )
mov	bx,#.151
push	bx
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
mov	sp,bp
!BCC_EOS
! 1450     else
! 1451       bios_printf(2, ": could not read the boot disk");
jmp .152
.14F:
! Debug: list * char = .153+0 (used reg = )
mov	bx,#.153
push	bx
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
mov	sp,bp
!BCC_EOS
! 1452   }
.152:
! 1453   bios_printf(2, "\n\n");
.14D:
! Debug: list * char = .154+0 (used reg = )
mov	bx,#.154
push	bx
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
mov	sp,bp
!BCC_EOS
! 1454 }
pop	bp
ret
! 1455   void
! Register BX used in function print_boot_failure
! 1456 print_cdromboot_failure( code )
! 1457   Bit16u code;
export	_print_cdromboot_failure
_print_cdromboot_failure:
!BCC_EOS
! 1458 {
! 1459   bios_printf(2 | 4, "CDROM boot failure code : %04x\n",code);
push	bp
mov	bp,sp
! Debug: list unsigned short code = [S+2+2] (used reg = )
push	4[bp]
! Debug: list * char = .155+0 (used reg = )
mov	bx,#.155
push	bx
! Debug: list int = const 6 (used reg = )
mov	ax,*6
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
mov	sp,bp
!BCC_EOS
! 1460   return;
pop	bp
ret
!BCC_EOS
! 1461 }
! 1462 void
! Register BX used in function print_cdromboot_failure
! 1463 nmi_handler_msg()
! 1464 {
export	_nmi_handler_msg
_nmi_handler_msg:
! 1465   bios_printf((2 | 4 | 1), "NMI Handler called\n");
push	bp
mov	bp,sp
! Debug: list * char = .156+0 (used reg = )
mov	bx,#.156
push	bx
! Debug: list int = const 7 (used reg = )
mov	ax,*7
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
mov	sp,bp
!BCC_EOS
! 1466 }
pop	bp
ret
! 1467 void
! Register BX used in function nmi_handler_msg
! 1468 int18_pani
! 1468 c_msg()
! 1469 {
export	_int18_panic_msg
_int18_panic_msg:
! 1470   bios_printf((2 | 4 | 1), "INT18: BOOT FAILURE\n");
push	bp
mov	bp,sp
! Debug: list * char = .157+0 (used reg = )
mov	bx,#.157
push	bx
! Debug: list int = const 7 (used reg = )
mov	ax,*7
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
mov	sp,bp
!BCC_EOS
! 1471 }
pop	bp
ret
! 1472 void
! Register BX used in function int18_panic_msg
! 1473 log_bios_start()
! 1474 {
export	_log_bios_start
_log_bios_start:
! 1475   bios_printf(4, "%s\n", bios_svn_version_string);
push	bp
mov	bp,sp
! Debug: list * char = bios_svn_version_string+0 (used reg = )
mov	bx,#_bios_svn_version_string
push	bx
! Debug: list * char = .158+0 (used reg = )
mov	bx,#.158
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
mov	sp,bp
!BCC_EOS
! 1476 }
pop	bp
ret
! 1477   bx_bool
! Register BX used in function log_bios_start
! 1478 set_enable_a20(val)
! 1479   bx_bool val;
export	_set_enable_a20
_set_enable_a20:
!BCC_EOS
! 1480 {
! 1481   Bit8u oldval;
!BCC_EOS
! 1482   oldval = inb(0x0092);
push	bp
mov	bp,sp
dec	sp
dec	sp
! Debug: list int = const $92 (used reg = )
mov	ax,#$92
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char oldval = [S+4-3] (used reg = )
mov	-1[bp],al
!BCC_EOS
! 1483   if (val)
mov	ax,4[bp]
test	ax,ax
je  	.159
.15A:
! 1484     outb(0x0092, oldval | 0x02);
! Debug: or int = const 2 to unsigned char oldval = [S+4-3] (used reg = )
mov	al,-1[bp]
or	al,*2
! Debug: list unsigned char = al+0 (used reg = )
xor	ah,ah
push	ax
! Debug: list int = const $92 (used reg = )
mov	ax,#$92
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1485   else
! 1486     outb(0x0092, oldval & 0xfd);
jmp .15B
.159:
! Debug: and int = const $FD to unsigned char oldval = [S+4-3] (used reg = )
mov	al,-1[bp]
and	al,#$FD
! Debug: list unsigned char = al+0 (used reg = )
xor	ah,ah
push	ax
! Debug: list int = const $92 (used reg = )
mov	ax,#$92
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1487   return((oldval & 0x02) != 0);
.15B:
! Debug: and int = const 2 to unsigned char oldval = [S+4-3] (used reg = )
mov	al,-1[bp]
and	al,*2
! Debug: ne int = const 0 to unsigned char = al+0 (used reg = )
test	al,al
je 	.15C
mov	al,*1
jmp	.15D
.15C:
xor	al,al
.15D:
! Debug: cast unsigned short = const 0 to char = al+0 (used reg = )
xor	ah,ah
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 1488 }
! 1489   void
! 1490 debugger_on()
! 1491 {
export	_debugger_on
_debugger_on:
! 1492   outb(0xfedc, 0x01);
push	bp
mov	bp,sp
! Debug: list int = const 1 (used reg = )
mov	ax,*1
push	ax
! Debug: list unsigned int = const $FEDC (used reg = )
mov	ax,#$FEDC
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
mov	sp,bp
!BCC_EOS
! 1493 }
pop	bp
ret
! 1494   void
! 1495 debugger_off()
! 1496 {
export	_debugger_off
_debugger_off:
! 1497   outb(0xfedc, 0x00);
push	bp
mov	bp,sp
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list unsigned int = const $FEDC (used reg = )
mov	ax,#$FEDC
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
mov	sp,bp
!BCC_EOS
! 1498 }
pop	bp
ret
! 1499 int
! 1500 s3_resume()
! 1501 {
export	_s3_resume
_s3_resume:
! 1502     Bit32u s3_wakeup_vector;
!BCC_EOS
! 1503     Bit8u s3_resume_flag;
!BCC_EOS
! 1504     s3_resume_flag = *((Bit8u *)(0x04b0));
push	bp
mov	bp,sp
add	sp,*-6
! Debug: eq unsigned char = [+$4B0] to unsigned char s3_resume_flag = [S+8-7] (used reg = )
mov	al,[$4B0]
mov	-5[bp],al
!BCC_EOS
! 1505     s3_wakeup_vector = *((Bit32u *)(0x04b2));
! Debug: eq unsigned long = [+$4B2] to unsigned long s3_wakeup_vector = [S+8-6] (used reg = )
mov	ax,[$4B2]
mov	bx,[$4B4]
mov	-4[bp],ax
mov	-2[bp],bx
!BCC_EOS
! 1506     bios_printf(4, "S3 resume called %x 0x%lx\n", s3_resume_flag, s3_wakeup_vector);
! Debug: list unsigned long s3_wakeup_vector = [S+8-6] (used reg = )
push	-2[bp]
push	-4[bp]
! Debug: list unsigned char s3_resume_flag = [S+$C-7] (used reg = )
mov	al,-5[bp]
xor	ah,ah
push	ax
! Debug: list * char = .15E+0 (used reg = )
mov	bx,#.15E
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*$A
!BCC_EOS
! 1507     if (s3_resume_flag != 0xFE || !s3_wakeup_vector)
! Debug: ne int = const $FE to unsigned char s3_resume_flag = [S+8-7] (used reg = )
mov	al,-5[bp]
cmp	al,#$FE
jne 	.160
.161:
mov	ax,-4[bp]
mov	bx,-2[bp]
call	ltstl
jne 	.15F
.160:
! 1508      return 0;
xor	ax,ax
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 1509     *((Bit8u *)(0x04b0)) = (0);
.15F:
! Debug: eq int = const 0 to unsigned char = [+$4B0] (used reg = )
xor	al,al
mov	[$4B0],al
!BCC_EOS
! 1510     *((Bit16u *)(0x04b6)) = ((s3_wakeup_vector & 0xF));
! Debug: and unsigned long = const $F to unsigned long s3_wakeup_vector = [S+8-6] (used reg = )
! Debug: expression subtree swapping
mov	ax,*$F
xor	bx,bx
lea	di,-4[bp]
call	landul
! Debug: eq unsigned long = bx+0 to unsigned short = [+$4B6] (used reg = )
mov	[$4B6],ax
!BCC_EOS
! 1511     *((Bit16u *)(0x04b8)) = ((s3_wakeup_vector >> 4));
! Debug: sr int = const 4 to unsigned long s3_wakeup_vector = [S+8-6] (used reg = )
mov	ax,-4[bp]
mov	bx,-2[bp]
mov	di,*4
call	lsrul
! Debug: eq unsigned long = bx+0 to unsigned short = [+$4B8] (used reg = )
mov	[$4B8],ax
!BCC_EOS
! 1512     bios_printf(4, "S3 resume jump to %x:%x\n", (s3_wakeup_vector >> 4), (s3_wakeup_vector & 0xF));
! Debug: and unsigned long = const $F to unsigned long s3_wakeup_vector = [S+8-6] (used reg = )
! Debug: expression subtree swapping
mov	ax,*$F
xor	bx,bx
lea	di,-4[bp]
call	landul
! Debug: list unsigned long = bx+0 (used reg = )
push	bx
push	ax
! Debug: sr int = const 4 to unsigned long s3_wakeup_vector = [S+$C-6] (used reg = )
mov	ax,-4[bp]
mov	bx,-2[bp]
mov	di,*4
call	lsrul
! Debug: list unsigned long = bx+0 (used reg = )
push	bx
push	ax
! Debug: list * char = .162+0 (used reg = )
mov	bx,#.162
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*$C
!BCC_EOS
! 1513 #asm
!BCC_EOS
!BCC_ASM
_s3_resume.s3_resume_flag	set	1
.s3_resume.s3_resume_flag	set	-5
_s3_resume.s3_wakeup_vector	set	2
.s3_resume.s3_wakeup_vector	set	-4
    jmpf [0x04b6]
! 1515 endasm
!BCC_ENDASM
!BCC_EOS
! 1516     return 1;
mov	ax,*1
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 1517 }
! 1518 void ata_init( )
! Register BX used in function s3_resume
! 1519 {
export	_ata_init
_ata_init:
! 1520   Bit8u channel, device;
!BCC_EOS
! 1521   Bit16u old_ds = set_DS(get_ebda_seg());
push	bp
mov	bp,sp
add	sp,*-4
! Debug: func () unsigned short = get_ebda_seg+0 (used reg = )
call	_get_ebda_seg
! Debug: list unsigned short = ax+0 (used reg = )
push	ax
! Debug: func () unsigned short = set_DS+0 (used reg = )
call	_set_DS
inc	sp
inc	sp
! Debug: eq unsigned short = ax+0 to unsigned short old_ds = [S+6-6] (used reg = )
mov	-4[bp],ax
!BCC_EOS
! 1522   for (channel=0; channel<4; channel++) {
! Debug: eq int = const 0 to unsigned char channel = [S+6-3] (used reg = )
xor	al,al
mov	-1[bp],al
!BCC_EOS
!BCC_EOS
jmp .165
.166:
! 1523     *((Bit8u *)(&((ebda_data_t *) 0)->ata.channels[channel].iface)) = (0x00);
! Debug: ptradd unsigned char channel = [S+6-3] to [4] struct  = const $122 (used reg = )
mov	al,-1[bp]
xor	ah,ah
mov	cl,*3
shl	ax,cl
mov	bx,ax
! Debug: address unsigned char = [bx+$122] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$122 (used reg = )
! Debug: eq int = const 0 to unsigned char = [bx+$122] (used reg = )
xor	al,al
mov	$122[bx],al
!BCC_EOS
! 1524     *((Bit16u *)(&((ebda_data_t *) 0)->ata.channels[channel].iobase1)) = (0x0);
! Debug: ptradd unsigned char channel = [S+6-3] to [4] struct  = const $122 (used reg = )
mov	al,-1[bp]
xor	ah,ah
mov	cl,*3
shl	ax,cl
mov	bx,ax
! Debug: address unsigned short = [bx+$124] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$124 (used reg = )
! Debug: eq int = const 0 to unsigned short = [bx+$124] (used reg = )
xor	ax,ax
mov	$124[bx],ax
!BCC_EOS
! 1525     *((Bit16u *)(&((ebda_data_t *) 0)->ata.channels[channel].iobase2)) = (0x0);
! Debug: ptradd unsigned char channel = [S+6-3] to [4] struct  = const $122 (used reg = )
mov	al,-1[bp]
xor	ah,ah
mov	cl,*3
shl	ax,cl
mov	bx,ax
! Debug: address unsigned short = [bx+$126] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$126 (used reg = )
! Debug: eq int = const 0 to unsigned short = [bx+$126] (used reg = )
xor	ax,ax
mov	$126[bx],ax
!BCC_EOS
! 1526     *((Bit8u *)(&((ebda_data_t *) 0)->ata.channels[channel].irq)) = (0);
! Debug: ptradd unsigned char channel = [S+6-3] to [4] struct  = const $122 (used reg = )
mov	al,-1[bp]
xor	ah,ah
mov	cl,*3
shl	ax,cl
mov	bx,ax
! Debug: address unsigned char = [bx+$128] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$128 (used reg = )
! Debug: eq int = const 0 to unsigned char = [bx+$128] (used reg = )
xor	al,al
mov	$128[bx],al
!BCC_EOS
! 1527   }
! 1528   for (device=0; device<(4*2); device++) {
.164:
! Debug: postinc unsigned char channel = [S+6-3] (used reg = )
mov	al,-1[bp]
inc	ax
mov	-1[bp],al
.165:
! Debug: lt int = const 4 to unsigned char channel = [S+6-3] (used reg = )
mov	al,-1[bp]
cmp	al,*4
jb 	.166
.167:
.163:
! Debug: eq int = const 0 to unsigned char device = [S+6-4] (used reg = )
xor	al,al
mov	-2[bp],al
!BCC_EOS
!BCC_EOS
br 	.16A
.16B:
! 1529     *((Bit8u *)(&((ebda_data_t *) 0)->ata.devices[device].type)) = (0x00);
! Debug: ptradd unsigned char device = [S+6-4] to [8] struct  = const $142 (used reg = )
mov	al,-2[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned char = [bx+$142] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$142 (used reg = )
! Debug: eq int = const 0 to unsigned char = [bx+$142] (used reg = )
xor	al,al
mov	$142[bx],al
!BCC_EOS
! 1530     *((Bit8u *)(&((ebda_data_t *) 0)->ata.devices[device].device)) = (0x00);
! Debug: ptradd unsigned char device = [S+6-4] to [8] struct  = const $142 (used reg = )
mov	al,-2[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned char = [bx+$143] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$143 (used reg = )
! Debug: eq int = const 0 to unsigned char = [bx+$143] (used reg = )
xor	al,al
mov	$143[bx],al
!BCC_EOS
! 1531     *((Bit8u *)(&((ebda_data_t *) 0)->ata.devices[device].removable)) = (0);
! Debug: ptradd unsigned char device = [S+6-4] to [8] struct  = const $142 (used reg = )
mov	al,-2[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned char = [bx+$144] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$144 (used reg = )
! Debug: eq int = const 0 to unsigned char = [bx+$144] (used reg = )
xor	al,al
mov	$144[bx],al
!BCC_EOS
! 1532     *((Bit8u *)(&((ebda_data_t *) 0)->ata.devices[device].lock)) = (0);
! Debug: ptradd unsigned char device = [S+6-4] to [8] struct  = const $142 (used reg = )
mov	al,-2[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned char = [bx+$145] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$145 (used reg = )
! Debug: eq int = const 0 to unsigned char = [bx+$145] (used reg = )
xor	al,al
mov	$145[bx],al
!BCC_EOS
! 1533     *((Bit8u *)(&((ebda_data_t *) 0)->ata.devices[device].mode)) = (0x00);
! Debug: ptradd unsigned char device = [S+6-4] to [8] struct  = const $142 (used reg = )
mov	al,-2[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned char = [bx+$146] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$146 (used reg = )
! Debug: eq int = const 0 to unsigned char = [bx+$146] (used reg = )
xor	al,al
mov	$146[bx],al
!BCC_EOS
! 1534     *((Bit16u *)(&((ebda_data_t *) 0)->ata.devices[device].blksize)) = (0);
! Debug: ptradd unsigned char device = [S+6-4] to [8] struct  = const $142 (used reg = )
mov	al,-2[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned short = [bx+$148] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$148 (used reg = )
! Debug: eq int = const 0 to unsigned short = [bx+$148] (used reg = )
xor	ax,ax
mov	$148[bx],ax
!BCC_EOS
! 1535     *((Bit8u *)(&((ebda_data_t *) 0)->ata.devices[device].trans
! 1535 lation)) = (0);
! Debug: ptradd unsigned char device = [S+6-4] to [8] struct  = const $142 (used reg = )
mov	al,-2[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned char = [bx+$14A] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$14A (used reg = )
! Debug: eq int = const 0 to unsigned char = [bx+$14A] (used reg = )
xor	al,al
mov	$14A[bx],al
!BCC_EOS
! 1536     *((Bit16u *)(&((ebda_data_t *) 0)->ata.devices[device].lchs.heads)) = (0);
! Debug: ptradd unsigned char device = [S+6-4] to [8] struct  = const $142 (used reg = )
mov	al,-2[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned short = [bx+$14C] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$14C (used reg = )
! Debug: eq int = const 0 to unsigned short = [bx+$14C] (used reg = )
xor	ax,ax
mov	$14C[bx],ax
!BCC_EOS
! 1537     *((Bit16u *)(&((ebda_data_t *) 0)->ata.devices[device].lchs.cylinders)) = (0);
! Debug: ptradd unsigned char device = [S+6-4] to [8] struct  = const $142 (used reg = )
mov	al,-2[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned short = [bx+$14E] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$14E (used reg = )
! Debug: eq int = const 0 to unsigned short = [bx+$14E] (used reg = )
xor	ax,ax
mov	$14E[bx],ax
!BCC_EOS
! 1538     *((Bit16u *)(&((ebda_data_t *) 0)->ata.devices[device].lchs.spt)) = (0);
! Debug: ptradd unsigned char device = [S+6-4] to [8] struct  = const $142 (used reg = )
mov	al,-2[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned short = [bx+$150] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$150 (used reg = )
! Debug: eq int = const 0 to unsigned short = [bx+$150] (used reg = )
xor	ax,ax
mov	$150[bx],ax
!BCC_EOS
! 1539     *((Bit16u *)(&((ebda_data_t *) 0)->ata.devices[device].pchs.heads)) = (0);
! Debug: ptradd unsigned char device = [S+6-4] to [8] struct  = const $142 (used reg = )
mov	al,-2[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned short = [bx+$152] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$152 (used reg = )
! Debug: eq int = const 0 to unsigned short = [bx+$152] (used reg = )
xor	ax,ax
mov	$152[bx],ax
!BCC_EOS
! 1540     *((Bit16u *)(&((ebda_data_t *) 0)->ata.devices[device].pchs.cylinders)) = (0);
! Debug: ptradd unsigned char device = [S+6-4] to [8] struct  = const $142 (used reg = )
mov	al,-2[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned short = [bx+$154] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$154 (used reg = )
! Debug: eq int = const 0 to unsigned short = [bx+$154] (used reg = )
xor	ax,ax
mov	$154[bx],ax
!BCC_EOS
! 1541     *((Bit16u *)(&((ebda_data_t *) 0)->ata.devices[device].pchs.spt)) = (0);
! Debug: ptradd unsigned char device = [S+6-4] to [8] struct  = const $142 (used reg = )
mov	al,-2[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned short = [bx+$156] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$156 (used reg = )
! Debug: eq int = const 0 to unsigned short = [bx+$156] (used reg = )
xor	ax,ax
mov	$156[bx],ax
!BCC_EOS
! 1542     *((Bit32u *)(&((ebda_data_t *) 0)->ata.devices[device].sectors_low)) = (0L);
! Debug: ptradd unsigned char device = [S+6-4] to [8] struct  = const $142 (used reg = )
mov	al,-2[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned long = [bx+$158] (used reg = )
! Debug: cast * unsigned long = const 0 to * unsigned long = bx+$158 (used reg = )
! Debug: eq long = const 0 to unsigned long = [bx+$158] (used reg = )
xor	ax,ax
xor	si,si
mov	$158[bx],ax
mov	$15A[bx],si
!BCC_EOS
! 1543     *((Bit32u *)(&((ebda_data_t *) 0)->ata.devices[device].sectors_high)) = (0L);
! Debug: ptradd unsigned char device = [S+6-4] to [8] struct  = const $142 (used reg = )
mov	al,-2[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned long = [bx+$15C] (used reg = )
! Debug: cast * unsigned long = const 0 to * unsigned long = bx+$15C (used reg = )
! Debug: eq long = const 0 to unsigned long = [bx+$15C] (used reg = )
xor	ax,ax
xor	si,si
mov	$15C[bx],ax
mov	$15E[bx],si
!BCC_EOS
! 1544   }
! 1545   for (device=0; device<(4*2); device++) {
.169:
! Debug: postinc unsigned char device = [S+6-4] (used reg = )
mov	al,-2[bp]
inc	ax
mov	-2[bp],al
.16A:
! Debug: lt int = const 8 to unsigned char device = [S+6-4] (used reg = )
mov	al,-2[bp]
cmp	al,*8
blo 	.16B
.16C:
.168:
! Debug: eq int = const 0 to unsigned char device = [S+6-4] (used reg = )
xor	al,al
mov	-2[bp],al
!BCC_EOS
!BCC_EOS
jmp .16F
.170:
! 1546     *((Bit8u *)(&((ebda_data_t *) 0)->ata.hdidmap[device])) = ((4*2));
! Debug: ptradd unsigned char device = [S+6-4] to [8] unsigned char = const $233 (used reg = )
mov	al,-2[bp]
xor	ah,ah
mov	bx,ax
! Debug: address unsigned char = [bx+$233] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$233 (used reg = )
! Debug: eq int = const 8 to unsigned char = [bx+$233] (used reg = )
mov	al,*8
mov	$233[bx],al
!BCC_EOS
! 1547     *((Bit8u *)(&((ebda_data_t *) 0)->ata.cdidmap[device])) = ((4*2));
! Debug: ptradd unsigned char device = [S+6-4] to [8] unsigned char = const $23C (used reg = )
mov	al,-2[bp]
xor	ah,ah
mov	bx,ax
! Debug: address unsigned char = [bx+$23C] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$23C (used reg = )
! Debug: eq int = const 8 to unsigned char = [bx+$23C] (used reg = )
mov	al,*8
mov	$23C[bx],al
!BCC_EOS
! 1548   }
! 1549   *((Bit8u *)(&((ebda_data_t *) 0)->ata.hdcount)) = (0);
.16E:
! Debug: postinc unsigned char device = [S+6-4] (used reg = )
mov	al,-2[bp]
inc	ax
mov	-2[bp],al
.16F:
! Debug: lt int = const 8 to unsigned char device = [S+6-4] (used reg = )
mov	al,-2[bp]
cmp	al,*8
jb 	.170
.171:
.16D:
! Debug: eq int = const 0 to unsigned char = [+$232] (used reg = )
xor	al,al
mov	[$232],al
!BCC_EOS
! 1550   *((Bit8u *)(&((ebda_data_t *) 0)->ata.cdcount)) = (0);
! Debug: eq int = const 0 to unsigned char = [+$23B] (used reg = )
xor	al,al
mov	[$23B],al
!BCC_EOS
! 1551   set_DS(old_ds);
! Debug: list unsigned short old_ds = [S+6-6] (used reg = )
push	-4[bp]
! Debug: func () unsigned short = set_DS+0 (used reg = )
call	_set_DS
inc	sp
inc	sp
!BCC_EOS
! 1552 }
mov	sp,bp
pop	bp
ret
! 1553 int await_ide();
! Register BX used in function ata_init
!BCC_EOS
! 1554 static int await_ide(when_done,base,timeout)
! 1555   Bit8u when_done;
_await_ide:
!BCC_EOS
! 1556   Bit16u base;
!BCC_EOS
! 1557   Bit16u timeout;
!BCC_EOS
! 1558 {
! 1559   Bit32u time=0;
push	bp
mov	bp,sp
add	sp,*-4
! Debug: eq int = const 0 to unsigned long time = [S+6-6] (used reg = )
xor	ax,ax
xor	bx,bx
mov	-4[bp],ax
mov	-2[bp],bx
!BCC_EOS
! 1560   Bit16u status,last=0;
add	sp,*-4
! Debug: eq int = const 0 to unsigned short last = [S+$A-$A] (used reg = )
xor	ax,ax
mov	-8[bp],ax
!BCC_EOS
! 1561   Bit8u result;
!BCC_EOS
! 1562   status = inb(base + 7);
dec	sp
dec	sp
! Debug: add int = const 7 to unsigned short base = [S+$C+4] (used reg = )
mov	ax,6[bp]
! Debug: list unsigned int = ax+7 (used reg = )
add	ax,*7
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned short status = [S+$C-8] (used reg = )
xor	ah,ah
mov	-6[bp],ax
!BCC_EOS
! 1563   for(;;) {
!BCC_EOS
!BCC_EOS
.174:
! 1564     status = inb(base+7);
! Debug: add int = const 7 to unsigned short base = [S+$C+4] (used reg = )
mov	ax,6[bp]
! Debug: list unsigned int = ax+7 (used reg = )
add	ax,*7
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned short status = [S+$C-8] (used reg = )
xor	ah,ah
mov	-6[bp],ax
!BCC_EOS
! 1565     time++;
! Debug: postinc unsigned long time = [S+$C-6] (used reg = )
mov	ax,-4[bp]
mov	si,-2[bp]
lea	bx,-4[bp]
call	lincl
!BCC_EOS
! 1566     if (when_done == 1)
! Debug: logeq int = const 1 to unsigned char when_done = [S+$C+2] (used reg = )
mov	al,4[bp]
cmp	al,*1
jne 	.175
.176:
! 1567       result = status & 0x80;
! Debug: and int = const $80 to unsigned short status = [S+$C-8] (used reg = )
mov	al,-6[bp]
and	al,#$80
! Debug: eq unsigned char = al+0 to unsigned char result = [S+$C-$B] (used reg = )
mov	-9[bp],al
!BCC_EOS
! 1568     else if (when_done == 2)
br 	.177
.175:
! Debug: logeq int = const 2 to unsigned char when_done = [S+$C+2] (used reg = )
mov	al,4[bp]
cmp	al,*2
jne 	.178
.179:
! 1569       result = !(status & 0x80);
! Debug: and int = const $80 to unsigned short status = [S+$C-8] (used reg = )
mov	al,-6[bp]
and	al,#$80
test	al,al
jne 	.17A
.17B:
mov	al,*1
jmp	.17C
.17A:
xor	al,al
.17C:
! Debug: eq char = al+0 to unsigned char result = [S+$C-$B] (used reg = )
mov	-9[bp],al
!BCC_EOS
! 1570     else if (when_done == 3)
br 	.17D
.178:
! Debug: logeq int = const 3 to unsigned char when_done = [S+$C+2] (used reg = )
mov	al,4[bp]
cmp	al,*3
jne 	.17E
.17F:
! 1571       result = !(status & 0x80) && (status & 0x08);
! Debug: and int = const $80 to unsigned short status = [S+$C-8] (used reg = )
mov	al,-6[bp]
and	al,#$80
test	al,al
jne 	.180
.182:
! Debug: and int = const 8 to unsigned short status = [S+$C-8] (used reg = )
mov	al,-6[bp]
and	al,*8
test	al,al
je  	.180
.181:
mov	al,*1
jmp	.183
.180:
xor	al,al
.183:
! Debug: eq char = al+0 to unsigned char result = [S+$C-$B] (used reg = )
mov	-9[bp],al
!BCC_EOS
! 1572     else if (when_done == 4)
jmp .184
.17E:
! Debug: logeq int = const 4 to unsigned char when_done = [S+$C+2] (used reg = )
mov	al,4[bp]
cmp	al,*4
jne 	.185
.186:
! 1573       result = !(status & 0x80) && !(status & 0x08);
! Debug: and int = const $80 to unsigned short status = [S+$C-8] (used reg = )
mov	al,-6[bp]
and	al,#$80
test	al,al
jne 	.187
.189:
! Debug: and int = const 8 to unsigned short status = [S+$C-8] (used reg = )
mov	al,-6[bp]
and	al,*8
test	al,al
jne 	.187
.188:
mov	al,*1
jmp	.18A
.187:
xor	al,al
.18A:
! Debug: eq char = al+0 to unsigned char result = [S+$C-$B] (used reg = )
mov	-9[bp],al
!BCC_EOS
! 1574     else if (when_done == 5)
jmp .18B
.185:
! Debug: logeq int = const 5 to unsigned char when_done = [S+$C+2] (used reg = )
mov	al,4[bp]
cmp	al,*5
jne 	.18C
.18D:
! 1575       result = !(status & 0x80) && (status & 0x40);
! Debug: and int = const $80 to unsigned short status = [S+$C-8] (used reg = )
mov	al,-6[bp]
and	al,#$80
test	al,al
jne 	.18E
.190:
! Debug: and int = const $40 to unsigned short status = [S+$C-8] (used reg = )
mov	al,-6[bp]
and	al,*$40
test	al,al
je  	.18E
.18F:
mov	al,*1
jmp	.191
.18E:
xor	al,al
.191:
! Debug: eq char = al+0 to unsigned char result = [S+$C-$B] (used reg = )
mov	-9[bp],al
!BCC_EOS
! 1576     else if (when_done == 0)
jmp .192
.18C:
! Debug: logeq int = const 0 to unsigned char when_done = [S+$C+2] (used reg = )
mov	al,4[bp]
test	al,al
jne 	.193
.194:
! 1577       result = 0;
! Debug: eq int = const 0 to unsigned char result = [S+$C-$B] (used reg = )
xor	al,al
mov	-9[bp],al
!BCC_EOS
! 1578     if (result) return 0;
.193:
.192:
.18B:
.184:
.17D:
.177:
mov	al,-9[bp]
test	al,al
je  	.195
.196:
xor	ax,ax
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 1579     if (*(((Bit16u *)&time)+1) != last)
.195:
! Debug: ne unsigned short last = [S+$C-$A] to unsigned short time = [S+$C-4] (used reg = )
mov	ax,-2[bp]
cmp	ax,-8[bp]
je  	.197
.198:
! 1580     {
! 1581       last = *(((Bit16u *)&time)+1);
! Debug: eq unsigned short time = [S+$C-4] to unsigned short last = [S+$C-$A] (used reg = )
mov	ax,-2[bp]
mov	-8[bp],ax
!BCC_EOS
! 1582       ;
!BCC_EOS
! 1583     }
! 1584     if (status & 0x01)
.197:
! Debug: and int = const 1 to unsigned short status = [S+$C-8] (used reg = )
mov	al,-6[bp]
and	al,*1
test	al,al
je  	.199
.19A:
! 1585     {
! 1586       ;
!BCC_EOS
! 1587       return -1;
mov	ax,*-1
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 1588     }
! 1589     if ((timeout == 0) || ((time>>11) > timeout)) break;
.199:
! Debug: logeq int = const 0 to unsigned short timeout = [S+$C+6] (used reg = )
mov	ax,8[bp]
test	ax,ax
je  	.19C
.19D:
! Debug: cast unsigned long = const 0 to unsigned short timeout = [S+$C+6] (used reg = )
mov	ax,8[bp]
xor	bx,bx
push	bx
push	ax
! Debug: sr int = const $B to unsigned long time = [S+$10-6] (used reg = )
mov	ax,-4[bp]
mov	bx,-2[bp]
mov	al,ah
mov	ah,bl
mov	bl,bh
sub	bh,bh
mov	di,*3
call	lsrul
! Debug: gt unsigned long (temp) = [S+$10-$10] to unsigned long = bx+0 (used reg = )
lea	di,-$E[bp]
call	lcmpul
lea	sp,-$A[bp]
jbe 	.19B
.19C:
jmp .172
!BCC_EOS
! 1590   }
.19B:
! 1591   bios_printf(4, "IDE time out\n");
.173:
br 	.174
.172:
! Debug: list * char = .19E+0 (used reg = )
mov	bx,#.19E
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*4
!BCC_EOS
! 1592   return -1;
mov	ax,*-1
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 1593 }
! 1594 void ata_detect( )
! Register BX used in function await_ide
! 1595 {
export	_ata_detect
_ata_detect:
! 1596   Bit8u hdcount, cdcount, device, type;
!BCC_EOS
! 1597   Bit8u buffer[0x0200];
!BCC_EOS
! 1598   Bit16u old_ds = set_DS(get
push	bp
mov	bp,sp
add	sp,#-$206
! 1598 _ebda_seg());
! Debug: func () unsigned short = get_ebda_seg+0 (used reg = )
call	_get_ebda_seg
! Debug: list unsigned short = ax+0 (used reg = )
push	ax
! Debug: func () unsigned short = set_DS+0 (used reg = )
call	_set_DS
inc	sp
inc	sp
! Debug: eq unsigned short = ax+0 to unsigned short old_ds = [S+$208-$208] (used reg = )
mov	-$206[bp],ax
!BCC_EOS
! 1599   *((Bit8u *)(&((ebda_data_t *) 0)->ata.channels[0].iface)) = (0x00);
! Debug: eq int = const 0 to unsigned char = [+$122] (used reg = )
xor	al,al
mov	[$122],al
!BCC_EOS
! 1600   *((Bit16u *)(&((ebda_data_t *) 0)->ata.channels[0].iobase1)) = (0x01f0);
! Debug: eq int = const $1F0 to unsigned short = [+$124] (used reg = )
mov	ax,#$1F0
mov	[$124],ax
!BCC_EOS
! 1601   *((Bit16u *)(&((ebda_data_t *) 0)->ata.channels[0].iobase2)) = (0x3f0);
! Debug: eq int = const $3F0 to unsigned short = [+$126] (used reg = )
mov	ax,#$3F0
mov	[$126],ax
!BCC_EOS
! 1602   *((Bit8u *)(&((ebda_data_t *) 0)->ata.channels[0].irq)) = (14);
! Debug: eq int = const $E to unsigned char = [+$128] (used reg = )
mov	al,*$E
mov	[$128],al
!BCC_EOS
! 1603   *((Bit8u *)(&((ebda_data_t *) 0)->ata.channels[1].iface)) = (0x00);
! Debug: eq int = const 0 to unsigned char = [+$12A] (used reg = )
xor	al,al
mov	[$12A],al
!BCC_EOS
! 1604   *((Bit16u *)(&((ebda_data_t *) 0)->ata.channels[1].iobase1)) = (0x0170);
! Debug: eq int = const $170 to unsigned short = [+$12C] (used reg = )
mov	ax,#$170
mov	[$12C],ax
!BCC_EOS
! 1605   *((Bit16u *)(&((ebda_data_t *) 0)->ata.channels[1].iobase2)) = (0x370);
! Debug: eq int = const $370 to unsigned short = [+$12E] (used reg = )
mov	ax,#$370
mov	[$12E],ax
!BCC_EOS
! 1606   *((Bit8u *)(&((ebda_data_t *) 0)->ata.channels[1].irq)) = (15);
! Debug: eq int = const $F to unsigned char = [+$130] (used reg = )
mov	al,*$F
mov	[$130],al
!BCC_EOS
! 1607   *((Bit8u *)(&((ebda_data_t *) 0)->ata.channels[2].iface)) = (0x00);
! Debug: eq int = const 0 to unsigned char = [+$132] (used reg = )
xor	al,al
mov	[$132],al
!BCC_EOS
! 1608   *((Bit16u *)(&((ebda_data_t *) 0)->ata.channels[2].iobase1)) = (0x1e8);
! Debug: eq int = const $1E8 to unsigned short = [+$134] (used reg = )
mov	ax,#$1E8
mov	[$134],ax
!BCC_EOS
! 1609   *((Bit16u *)(&((ebda_data_t *) 0)->ata.channels[2].iobase2)) = (0x3e0);
! Debug: eq int = const $3E0 to unsigned short = [+$136] (used reg = )
mov	ax,#$3E0
mov	[$136],ax
!BCC_EOS
! 1610   *((Bit8u *)(&((ebda_data_t *) 0)->ata.channels[2].irq)) = (12);
! Debug: eq int = const $C to unsigned char = [+$138] (used reg = )
mov	al,*$C
mov	[$138],al
!BCC_EOS
! 1611   *((Bit8u *)(&((ebda_data_t *) 0)->ata.channels[3].iface)) = (0x00);
! Debug: eq int = const 0 to unsigned char = [+$13A] (used reg = )
xor	al,al
mov	[$13A],al
!BCC_EOS
! 1612   *((Bit16u *)(&((ebda_data_t *) 0)->ata.channels[3].iobase1)) = (0x168);
! Debug: eq int = const $168 to unsigned short = [+$13C] (used reg = )
mov	ax,#$168
mov	[$13C],ax
!BCC_EOS
! 1613   *((Bit16u *)(&((ebda_data_t *) 0)->ata.channels[3].iobase2)) = (0x360);
! Debug: eq int = const $360 to unsigned short = [+$13E] (used reg = )
mov	ax,#$360
mov	[$13E],ax
!BCC_EOS
! 1614   *((Bit8u *)(&((ebda_data_t *) 0)->ata.channels[3].irq)) = (11);
! Debug: eq int = const $B to unsigned char = [+$140] (used reg = )
mov	al,*$B
mov	[$140],al
!BCC_EOS
! 1615   hdcount=cdcount=0;
! Debug: eq int = const 0 to unsigned char cdcount = [S+$208-4] (used reg = )
xor	al,al
mov	-2[bp],al
! Debug: eq unsigned char = al+0 to unsigned char hdcount = [S+$208-3] (used reg = )
mov	-1[bp],al
!BCC_EOS
! 1616   for(device=0; device<(4*2); device++) {
! Debug: eq int = const 0 to unsigned char device = [S+$208-5] (used reg = )
xor	al,al
mov	-3[bp],al
!BCC_EOS
!BCC_EOS
br 	.1A1
.1A2:
! 1617     Bit16u iobase1, iobase2, blksize;
!BCC_EOS
! 1618     Bit8u channel, slave, shift;
!BCC_EOS
! 1619     Bit8u sc, sn, cl, ch, st;
!BCC_EOS
! 1620     channel = device / 2;
add	sp,*-$E
! Debug: div int = const 2 to unsigned char device = [S+$216-5] (used reg = )
mov	al,-3[bp]
xor	ah,ah
shr	ax,*1
! Debug: eq unsigned int = ax+0 to unsigned char channel = [S+$216-$20F] (used reg = )
mov	-$20D[bp],al
!BCC_EOS
! 1621     slave = device % 2;
! Debug: mod int = const 2 to unsigned char device = [S+$216-5] (used reg = )
mov	al,-3[bp]
xor	ah,ah
and	al,*1
! Debug: eq unsigned char = al+0 to unsigned char slave = [S+$216-$210] (used reg = )
mov	-$20E[bp],al
!BCC_EOS
! 1622     iobase1 =*((Bit16u *)(&((ebda_data_t *) 0)->ata.channels[channel].iobase1));
! Debug: ptradd unsigned char channel = [S+$216-$20F] to [4] struct  = const $122 (used reg = )
mov	al,-$20D[bp]
xor	ah,ah
mov	cl,*3
shl	ax,cl
mov	bx,ax
! Debug: address unsigned short = [bx+$124] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$124 (used reg = )
! Debug: eq unsigned short = [bx+$124] to unsigned short iobase1 = [S+$216-$20A] (used reg = )
mov	bx,$124[bx]
mov	-$208[bp],bx
!BCC_EOS
! 1623     iobase2 =*((Bit16u *)(&((ebda_data_t *) 0)->ata.channels[channel].iobase2));
! Debug: ptradd unsigned char channel = [S+$216-$20F] to [4] struct  = const $122 (used reg = )
mov	al,-$20D[bp]
xor	ah,ah
mov	cl,*3
shl	ax,cl
mov	bx,ax
! Debug: address unsigned short = [bx+$126] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$126 (used reg = )
! Debug: eq unsigned short = [bx+$126] to unsigned short iobase2 = [S+$216-$20C] (used reg = )
mov	bx,$126[bx]
mov	-$20A[bp],bx
!BCC_EOS
! 1624     outb(iobase2+6, 0x08 | 0x02);
! Debug: list int = const $A (used reg = )
mov	ax,*$A
push	ax
! Debug: add int = const 6 to unsigned short iobase2 = [S+$218-$20C] (used reg = )
mov	ax,-$20A[bp]
! Debug: list unsigned int = ax+6 (used reg = )
add	ax,*6
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1625     outb(iobase1+6, slave ? 0xb0 : 0xa0);
mov	al,-$20E[bp]
test	al,al
je  	.1A3
.1A4:
mov	al,#$B0
jmp .1A5
.1A3:
mov	al,#$A0
.1A5:
! Debug: list char = al+0 (used reg = )
xor	ah,ah
push	ax
! Debug: add int = const 6 to unsigned short iobase1 = [S+$218-$20A] (used reg = )
mov	ax,-$208[bp]
! Debug: list unsigned int = ax+6 (used reg = )
add	ax,*6
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1626     outb(iobase1+2, 0x55);
! Debug: list int = const $55 (used reg = )
mov	ax,*$55
push	ax
! Debug: add int = const 2 to unsigned short iobase1 = [S+$218-$20A] (used reg = )
mov	ax,-$208[bp]
! Debug: list unsigned int = ax+2 (used reg = )
inc	ax
inc	ax
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1627     outb(iobase1+3, 0xaa);
! Debug: list int = const $AA (used reg = )
mov	ax,#$AA
push	ax
! Debug: add int = const 3 to unsigned short iobase1 = [S+$218-$20A] (used reg = )
mov	ax,-$208[bp]
! Debug: list unsigned int = ax+3 (used reg = )
add	ax,*3
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1628     outb(iobase1+2, 0xaa);
! Debug: list int = const $AA (used reg = )
mov	ax,#$AA
push	ax
! Debug: add int = const 2 to unsigned short iobase1 = [S+$218-$20A] (used reg = )
mov	ax,-$208[bp]
! Debug: list unsigned int = ax+2 (used reg = )
inc	ax
inc	ax
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1629     outb(iobase1+3, 0x55);
! Debug: list int = const $55 (used reg = )
mov	ax,*$55
push	ax
! Debug: add int = const 3 to unsigned short iobase1 = [S+$218-$20A] (used reg = )
mov	ax,-$208[bp]
! Debug: list unsigned int = ax+3 (used reg = )
add	ax,*3
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1630     outb(iobase1+2, 0x55);
! Debug: list int = const $55 (used reg = )
mov	ax,*$55
push	ax
! Debug: add int = const 2 to unsigned short iobase1 = [S+$218-$20A] (used reg = )
mov	ax,-$208[bp]
! Debug: list unsigned int = ax+2 (used reg = )
inc	ax
inc	ax
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1631     outb(iobase1+3, 0xaa);
! Debug: list int = const $AA (used reg = )
mov	ax,#$AA
push	ax
! Debug: add int = const 3 to unsigned short iobase1 = [S+$218-$20A] (used reg = )
mov	ax,-$208[bp]
! Debug: list unsigned int = ax+3 (used reg = )
add	ax,*3
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1632     sc = inb(iobase1+2);
! Debug: add int = const 2 to unsigned short iobase1 = [S+$216-$20A] (used reg = )
mov	ax,-$208[bp]
! Debug: list unsigned int = ax+2 (used reg = )
inc	ax
inc	ax
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char sc = [S+$216-$212] (used reg = )
mov	-$210[bp],al
!BCC_EOS
! 1633     sn = inb(iobase1+3);
! Debug: add int = const 3 to unsigned short iobase1 = [S+$216-$20A] (used reg = )
mov	ax,-$208[bp]
! Debug: list unsigned int = ax+3 (used reg = )
add	ax,*3
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char sn = [S+$216-$213] (used reg = )
mov	-$211[bp],al
!BCC_EOS
! 1634     if ( (sc == 0x55) && (sn == 0xaa) ) {
! Debug: logeq int = const $55 to unsigned char sc = [S+$216-$212] (used reg = )
mov	al,-$210[bp]
cmp	al,*$55
bne 	.1A6
.1A8:
! Debug: logeq int = const $AA to unsigned char sn = [S+$216-$213] (used reg = )
mov	al,-$211[bp]
cmp	al,#$AA
bne 	.1A6
.1A7:
! 1635       *((Bit8u *)(&((ebda_data_t *) 0)->ata.devices[device].type)) = (0x01);
! Debug: ptradd unsigned char device = [S+$216-5] to [8] struct  = const $142 (used reg = )
mov	al,-3[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned char = [bx+$142] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$142 (used reg = )
! Debug: eq int = const 1 to unsigned char = [bx+$142] (used reg = )
mov	al,*1
mov	$142[bx],al
!BCC_EOS
! 1636       ata_reset(device);
! Debug: list unsigned char device = [S+$216-5] (used reg = )
mov	al,-3[bp]
xor	ah,ah
push	ax
! Debug: func () void = ata_reset+0 (used reg = )
call	_ata_reset
inc	sp
inc	sp
!BCC_EOS
! 1637       outb(iobase1+6, slave ? 0xb0 : 0xa0);
mov	al,-$20E[bp]
test	al,al
je  	.1A9
.1AA:
mov	al,#$B0
jmp .1AB
.1A9:
mov	al,#$A0
.1AB:
! Debug: list char = al+0 (used reg = )
xor	ah,ah
push	ax
! Debug: add int = const 6 to unsigned short iobase1 = [S+$218-$20A] (used reg = )
mov	ax,-$208[bp]
! Debug: list unsigned int = ax+6 (used reg = )
add	ax,*6
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1638       sc = inb(iobase1+2);
! Debug: add int = const 2 to unsigned short iobase1 = [S+$216-$20A] (used reg = )
mov	ax,-$208[bp]
! Debug: list unsigned int = ax+2 (used reg = )
inc	ax
inc	ax
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char sc = [S+$216-$212] (used reg = )
mov	-$210[bp],al
!BCC_EOS
! 1639       sn = inb(io
! 1639 base1+3);
! Debug: add int = const 3 to unsigned short iobase1 = [S+$216-$20A] (used reg = )
mov	ax,-$208[bp]
! Debug: list unsigned int = ax+3 (used reg = )
add	ax,*3
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char sn = [S+$216-$213] (used reg = )
mov	-$211[bp],al
!BCC_EOS
! 1640       if ((sc==0x01) && (sn==0x01)) {
! Debug: logeq int = const 1 to unsigned char sc = [S+$216-$212] (used reg = )
mov	al,-$210[bp]
cmp	al,*1
bne 	.1AC
.1AE:
! Debug: logeq int = const 1 to unsigned char sn = [S+$216-$213] (used reg = )
mov	al,-$211[bp]
cmp	al,*1
bne 	.1AC
.1AD:
! 1641         cl = inb(iobase1+4);
! Debug: add int = const 4 to unsigned short iobase1 = [S+$216-$20A] (used reg = )
mov	ax,-$208[bp]
! Debug: list unsigned int = ax+4 (used reg = )
add	ax,*4
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char cl = [S+$216-$214] (used reg = )
mov	-$212[bp],al
!BCC_EOS
! 1642         ch = inb(iobase1+5);
! Debug: add int = const 5 to unsigned short iobase1 = [S+$216-$20A] (used reg = )
mov	ax,-$208[bp]
! Debug: list unsigned int = ax+5 (used reg = )
add	ax,*5
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char ch = [S+$216-$215] (used reg = )
mov	-$213[bp],al
!BCC_EOS
! 1643         st = inb(iobase1+7);
! Debug: add int = const 7 to unsigned short iobase1 = [S+$216-$20A] (used reg = )
mov	ax,-$208[bp]
! Debug: list unsigned int = ax+7 (used reg = )
add	ax,*7
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char st = [S+$216-$216] (used reg = )
mov	-$214[bp],al
!BCC_EOS
! 1644         if ((cl==0x14) && (ch==0xeb)) {
! Debug: logeq int = const $14 to unsigned char cl = [S+$216-$214] (used reg = )
mov	al,-$212[bp]
cmp	al,*$14
jne 	.1AF
.1B1:
! Debug: logeq int = const $EB to unsigned char ch = [S+$216-$215] (used reg = )
mov	al,-$213[bp]
cmp	al,#$EB
jne 	.1AF
.1B0:
! 1645           *((Bit8u *)(&((ebda_data_t *) 0)->ata.devices[device].type)) = (0x03);
! Debug: ptradd unsigned char device = [S+$216-5] to [8] struct  = const $142 (used reg = )
mov	al,-3[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned char = [bx+$142] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$142 (used reg = )
! Debug: eq int = const 3 to unsigned char = [bx+$142] (used reg = )
mov	al,*3
mov	$142[bx],al
!BCC_EOS
! 1646         } else if ((cl==0x00) && (ch==0x00) && (st!=0x00)) {
jmp .1B2
.1AF:
! Debug: logeq int = const 0 to unsigned char cl = [S+$216-$214] (used reg = )
mov	al,-$212[bp]
test	al,al
jne 	.1B3
.1B6:
! Debug: logeq int = const 0 to unsigned char ch = [S+$216-$215] (used reg = )
mov	al,-$213[bp]
test	al,al
jne 	.1B3
.1B5:
! Debug: ne int = const 0 to unsigned char st = [S+$216-$216] (used reg = )
mov	al,-$214[bp]
test	al,al
je  	.1B3
.1B4:
! 1647           *((Bit8u *)(&((ebda_data_t *) 0)->ata.devices[device].type)) = (0x02);
! Debug: ptradd unsigned char device = [S+$216-5] to [8] struct  = const $142 (used reg = )
mov	al,-3[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned char = [bx+$142] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$142 (used reg = )
! Debug: eq int = const 2 to unsigned char = [bx+$142] (used reg = )
mov	al,*2
mov	$142[bx],al
!BCC_EOS
! 1648         } else if ((cl==0xff) && (ch==0xff)) {
jmp .1B7
.1B3:
! Debug: logeq int = const $FF to unsigned char cl = [S+$216-$214] (used reg = )
mov	al,-$212[bp]
cmp	al,#$FF
jne 	.1B8
.1BA:
! Debug: logeq int = const $FF to unsigned char ch = [S+$216-$215] (used reg = )
mov	al,-$213[bp]
cmp	al,#$FF
jne 	.1B8
.1B9:
! 1649           *((Bit8u *)(&((ebda_data_t *) 0)->ata.devices[device].type)) = (0x00);
! Debug: ptradd unsigned char device = [S+$216-5] to [8] struct  = const $142 (used reg = )
mov	al,-3[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned char = [bx+$142] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$142 (used reg = )
! Debug: eq int = const 0 to unsigned char = [bx+$142] (used reg = )
xor	al,al
mov	$142[bx],al
!BCC_EOS
! 1650         }
! 1651       }
.1B8:
.1B7:
.1B2:
! 1652     }
.1AC:
! 1653     type=*((Bit8u *)(&((ebda_data_t *) 0)->ata.devices[device].type));
.1A6:
! Debug: ptradd unsigned char device = [S+$216-5] to [8] struct  = const $142 (used reg = )
mov	al,-3[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned char = [bx+$142] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$142 (used reg = )
! Debug: eq unsigned char = [bx+$142] to unsigned char type = [S+$216-6] (used reg = )
mov	al,$142[bx]
mov	-4[bp],al
!BCC_EOS
! 1654     if(type == 0x02) {
! Debug: logeq int = const 2 to unsigned char type = [S+$216-6] (used reg = )
mov	al,-4[bp]
cmp	al,*2
bne 	.1BB
.1BC:
! 1655       Bit32u sectors_low, sectors_high;
!BCC_EOS
! 1656       Bit16u cylinders, heads, spt;
!BCC_EOS
! 1657       Bit8u translation, removable, mode;
!BCC_EOS
! 1658       *((Bit8u *)(&((ebda_data_t *) 0)->ata.devices[device].device)) = (0xFF);
add	sp,*-$12
! Debug: ptradd unsigned char device = [S+$228-5] to [8] struct  = const $142 (used reg = )
mov	al,-3[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned char = [bx+$143] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$143 (used reg = )
! Debug: eq int = const $FF to unsigned char = [bx+$143] (used reg = )
mov	al,#$FF
mov	$143[bx],al
!BCC_EOS
! 1659       *((Bit8u *)(&((ebda_data_t *) 0)->ata.devices[device].mode)) = (0x00);
! Debug: ptradd unsigned char device = [S+$228-5] to [8] struct  = const $142 (used reg = )
mov	al,-3[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned char = [bx+$146] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$146 (used reg = )
! Debug: eq int = const 0 to unsigned char = [bx+$146] (used reg = )
xor	al,al
mov	$146[bx],al
!BCC_EOS
! 1660       if (ata_cmd_data_io(0, device,0xEC, 1, 0, 0, 0, 0L, 0L, get_SS(),buffer) !=0 )
! Debug: list * unsigned char buffer = S+$228-$206 (used reg = )
lea	bx,-$204[bp]
push	bx
! Debug: func () unsigned short = get_SS+0 (used reg = )
call	_get_SS
! Debug: list unsigned short = ax+0 (used reg = )
push	ax
! Debug: list long = const 0 (used reg = )
xor	ax,ax
xor	bx,bx
push	bx
push	ax
! Debug: list long = const 0 (used reg = )
xor	ax,ax
xor	bx,bx
push	bx
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 1 (used reg = )
mov	ax,*1
push	ax
! Debug: list int = const $EC (used reg = )
mov	ax,#$EC
push	ax
! Debug: list unsigned char device = [S+$23E-5] (used reg = )
mov	al,-3[bp]
xor	ah,ah
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: func () unsigned short = ata_cmd_data_io+0 (used reg = )
call	_ata_cmd_data_io
add	sp,*$1A
! Debug: ne int = const 0 to unsigned short = ax+0 (used reg = )
test	ax,ax
je  	.1BD
.1BE:
! 1661         bios_printf((2 | 4 | 1), "ata-detect: Failed to detect ATA device\n");
! Debug: list * char = .1BF+0 (used reg = )
mov	bx,#.1BF
push	bx
! Debug: list int = const 7 (used reg = )
mov	ax,*7
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*4
!BCC_EOS
! 1662       removable = (read_byte_SS(buffer+0) & 0x80) >> 7;
.1BD:
! Debug: list * unsigned char buffer = S+$228-$206 (used reg = )
lea	bx,-$204[bp]
push	bx
! Debug: func () unsigned char = read_byte_SS+0 (used reg = )
call	_read_byte_SS
inc	sp
inc	sp
! Debug: and int = const $80 to unsigned char = al+0 (used reg = )
and	al,#$80
! Debug: sr int = const 7 to unsigned char = al+0 (used reg = )
xor	ah,ah
mov	cl,*7
shr	ax,cl
! Debug: eq unsigned int = ax+0 to unsigned char removable = [S+$228-$226] (used reg = )
mov	-$224[bp],al
!BCC_EOS
! 1663       mode = read_byte_SS(buffer+96) ? 0x01 : 0x00;
! Debug: list * unsigned char buffer = S+$228-$1A6 (used reg = )
lea	bx,-$1A4[bp]
push	bx
! Debug: func () unsigned char = read_byte_SS+0 (used reg = )
call	_read_byte_SS
inc	sp
inc	sp
test	al,al
je  	.1C0
.1C1:
mov	al,*1
jmp .1C2
.1C0:
xor	al,al
.1C2:
! Debug: eq char = al+0 to unsigned char mode = [S+$228-$227] (used reg = )
mov	-$225[bp],al
!BCC_EOS
! 1664       blksize = read_word_SS(buffer+10);
! Debug: list * unsigned char buffer = S+$228-$1FC (used reg = )
lea	bx,-$1FA[bp]
push	bx
! Debug: func () unsigned short = read_word_SS+0 (used reg = )
call	_read_word_SS
inc	sp
inc	sp
! Debug: eq unsigned short = ax+0 to unsigned short blksize = [S+$228-$20E] (used reg = )
mov	-$20C[bp],ax
!BCC_EOS
! 1665       cylinders = read_word_SS(buffer+(1*2));
! Debug: list * unsigned char buffer = S+$228-$204 (used reg = )
lea	bx,-$202[bp]
push	bx
! Debug: func () unsigned short = read_word_SS+0 (used reg = )
call	_read_word_SS
inc	sp
inc	sp
! Debug: eq unsigned short = ax+0 to unsigned short cylinders = [S+$228-$220] (used reg = )
mov	-$21E[bp],ax
!BCC_EOS
! 1666       heads = read_word_SS(buffer+(3*2));
! Debug: list * unsigned char buffer = S+$228-$200 (used reg = )
lea	bx,-$1FE[bp]
push	bx
! Debug: func () unsigned short = read_word_SS+0 (used reg = )
call	_read_word_SS
inc	sp
inc	sp
! Debug: eq unsigned short = ax+0 to unsigned short heads = [S+$228-$222] (used reg = )
mov	-$220[bp],ax
!BCC_EOS
! 1667       spt = read_word_SS(buffer+(6*2));
! Debug: list * unsigned char buffer = S+$228-$1FA (used reg = )
lea	bx,-$1F8[bp]
push	bx
! Debug: func () unsigned short = read_word_SS+0 (used reg = )
call	_read_word_SS
inc	sp
inc	sp
! Debug: eq unsigned short = ax+0 to unsigned short spt = [S+$228-$224] (used reg = )
mov	-$222[bp],ax
!BCC_EOS
! 1668       if (read_word_SS(buffer+(83*2)) & (1 << 10)) {
! Debug: list * unsigned char buffer = S+$228-$160 (used reg = )
lea	bx,-$15E[bp]
push	bx
! Debug: func () unsigned short = read_word_SS+0 (used reg = )
call	_read_word_SS
inc	sp
inc	sp
! Debug: and int = const $400 to unsigned short = ax+0 (used reg = )
and	ax,#$400
test	ax,ax
je  	.1C3
.1C4:
! 1669         sectors_low = read_dword_SS(buffer+(100*2));
! Debug: list * unsigned char buffer = S+$228-$13E (used reg = )
lea	bx,-$13C[bp]
push	bx
! Debug: func () unsigned long = read_dword_SS+0 (used reg = )
call	_read_dword_SS
mov	bx,dx
inc	sp
inc	sp
! Debug: eq unsigned long = bx+0 to unsigned long sectors_low = [S+$228-$21A] (used reg = )
mov	-$218[bp],ax
mov	-$216[bp],bx
!BCC_EOS
! 1670         sectors_high = read_dword_SS(buffer+(102*2));
! Debug: list * unsigned char buffer = S+$228-$13A (used reg = )
lea	bx,-$138[bp]
push	bx
! Debug: func () unsigned long = read_dword_SS+0 (used reg = )
call	_read_dword_SS
mov	bx,dx
inc	sp
inc	sp
! Debug: eq unsigned long = bx+0 to unsigned long sectors_high = [S+$228-$21E] (used reg = )
mov	-$21C[bp],ax
mov	-$21A[bp],bx
!BCC_EOS
! 1671       } else {
jmp .1C5
.1C3:
! 1672         sectors_low = read_dword_SS(buffer+(60*2));
! Debug: list * unsigned char buffer = S+$228-$18E (used reg = )
lea	bx,-$18C[bp]
push	bx
! Debug: func () unsigned long = read_dword_SS+0 (used reg = )
call	_read_dword_SS
mov	bx,dx
inc	sp
inc	sp
! Debug: eq unsigned long = bx+0 to unsigned long sectors_low = [S+$228-$21A] (used reg = )
mov	-$218[bp],ax
mov	-$216[bp],bx
!BCC_EOS
! 1673         sectors_high = 0;
! Debug: eq int = const 0 to unsigned long sectors_high = [S+$228-$21E] (used reg = )
xor	ax,ax
xor	bx,bx
mov	-$21C[bp],ax
mov	-$21A[bp],bx
!BCC_EOS
! 1674       }
! 1675       *((Bit8u *)(&((ebda_data_t *) 0)->ata.devices[device].device)) = (0xFF);
.1C5:
! Debug: ptradd unsigned char device = [S+$228-5] to [8] struct  = const $142 (used reg = )
mov	al,-3[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned char = [bx+$143] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$143 (used reg = )
! Debug: eq int = const $FF to unsigned char = [bx+$143] (used reg = )
mov	al,#$FF
mov	$143[bx],al
!BCC_EOS
! 1676       *((Bit8u *)(&((ebda_data_t *) 0)->ata.devices[device].removable)) = (removable);
! Debug: ptradd unsigned char device = [S+$228-5] to [8] struct  = const $142 (used reg = )
mov	al,-3[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned char = [bx+$144] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$144 (used reg = )
! Debug: eq unsigned char removable = [S+$228-$226] to unsigned char = [bx+$144] (used reg = )
mov	al,-$224[bp]
mov	$144[bx],al
!BCC_EOS
! 1677       *((Bit8u *)(&((ebda_data_t *) 0)->ata.devices[device].mode)) = (mode);
! Debug: ptradd unsigned char device = [S+$228-5] to [8] struct  = const $142 (used reg = )
mov	al,-3[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned char = [bx+$146] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$146 (used reg = )
! Debug: eq unsigned char mode = [S+$228-$227] to unsigned char = [bx+$146] (used reg = )
mov	al,-$225[bp]
mov	$146[bx],al
!BCC_EOS
! 1678       *((Bit16u *)(&((ebda_data_t *) 0)->ata.devices[device].blksize)) = (blksize);
! Debug: ptradd unsigned char device = [S+$228-5] to [8] struct  = const $142 (used reg = )
mov	al,-3[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned short = [bx+$148] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$148 (used reg = )
! Debug: eq unsigned short blksize = [S+$228-$20E] to unsigned short = [bx+$148] (used reg = )
mov	ax,-$20C[bp]
mov	$148[bx],ax
!BCC_EOS
! 1679       *((Bit16u *)(&((ebda_data_t *) 0)->ata.devices[device].pchs.heads)) = (heads);
! Debug: ptradd unsigned char device = [S+$228-5] to [8] struct  = const $142 (used reg = )
mov	al,-3[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned short = [bx+$152] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$152 (used reg = )
! Debug: eq unsigned short heads = [S+$228-$222] to unsigned short = [bx+$152] (used reg = )
mov	ax,-$220[bp]
mov	$152[bx],ax
!BCC_EOS
! 1680       *((Bit16u 
! 1680 *)(&((ebda_data_t *) 0)->ata.devices[device].pchs.cylinders)) = (cylinders);
! Debug: ptradd unsigned char device = [S+$228-5] to [8] struct  = const $142 (used reg = )
mov	al,-3[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned short = [bx+$154] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$154 (used reg = )
! Debug: eq unsigned short cylinders = [S+$228-$220] to unsigned short = [bx+$154] (used reg = )
mov	ax,-$21E[bp]
mov	$154[bx],ax
!BCC_EOS
! 1681       *((Bit16u *)(&((ebda_data_t *) 0)->ata.devices[device].pchs.spt)) = (spt);
! Debug: ptradd unsigned char device = [S+$228-5] to [8] struct  = const $142 (used reg = )
mov	al,-3[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned short = [bx+$156] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$156 (used reg = )
! Debug: eq unsigned short spt = [S+$228-$224] to unsigned short = [bx+$156] (used reg = )
mov	ax,-$222[bp]
mov	$156[bx],ax
!BCC_EOS
! 1682       *((Bit32u *)(&((ebda_data_t *) 0)->ata.devices[device].sectors_low)) = (sectors_low);
! Debug: ptradd unsigned char device = [S+$228-5] to [8] struct  = const $142 (used reg = )
mov	al,-3[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned long = [bx+$158] (used reg = )
! Debug: cast * unsigned long = const 0 to * unsigned long = bx+$158 (used reg = )
! Debug: eq unsigned long sectors_low = [S+$228-$21A] to unsigned long = [bx+$158] (used reg = )
mov	ax,-$218[bp]
mov	si,-$216[bp]
mov	$158[bx],ax
mov	$15A[bx],si
!BCC_EOS
! 1683       *((Bit32u *)(&((ebda_data_t *) 0)->ata.devices[device].sectors_high)) = (sectors_high);
! Debug: ptradd unsigned char device = [S+$228-5] to [8] struct  = const $142 (used reg = )
mov	al,-3[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned long = [bx+$15C] (used reg = )
! Debug: cast * unsigned long = const 0 to * unsigned long = bx+$15C (used reg = )
! Debug: eq unsigned long sectors_high = [S+$228-$21E] to unsigned long = [bx+$15C] (used reg = )
mov	ax,-$21C[bp]
mov	si,-$21A[bp]
mov	$15C[bx],ax
mov	$15E[bx],si
!BCC_EOS
! 1684       bios_printf(4, "ata%d-%d: PCHS=%u/%d/%d translation=", channel, slave,cylinders, heads, spt);
! Debug: list unsigned short spt = [S+$228-$224] (used reg = )
push	-$222[bp]
! Debug: list unsigned short heads = [S+$22A-$222] (used reg = )
push	-$220[bp]
! Debug: list unsigned short cylinders = [S+$22C-$220] (used reg = )
push	-$21E[bp]
! Debug: list unsigned char slave = [S+$22E-$210] (used reg = )
mov	al,-$20E[bp]
xor	ah,ah
push	ax
! Debug: list unsigned char channel = [S+$230-$20F] (used reg = )
mov	al,-$20D[bp]
xor	ah,ah
push	ax
! Debug: list * char = .1C6+0 (used reg = )
mov	bx,#.1C6
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*$E
!BCC_EOS
! 1685       translation = inb_cmos(0x39 + channel/2);
! Debug: div int = const 2 to unsigned char channel = [S+$228-$20F] (used reg = )
mov	al,-$20D[bp]
xor	ah,ah
shr	ax,*1
! Debug: add unsigned int = ax+0 to int = const $39 (used reg = )
! Debug: expression subtree swapping
! Debug: list unsigned int = ax+$39 (used reg = )
add	ax,*$39
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char translation = [S+$228-$225] (used reg = )
mov	-$223[bp],al
!BCC_EOS
! 1686       for (shift=device%4; shift>0; shift--) translation >>= 2;
! Debug: mod int = const 4 to unsigned char device = [S+$228-5] (used reg = )
mov	al,-3[bp]
xor	ah,ah
and	al,*3
! Debug: eq unsigned char = al+0 to unsigned char shift = [S+$228-$211] (used reg = )
mov	-$20F[bp],al
!BCC_EOS
!BCC_EOS
br 	.1C9
.1CA:
! Debug: srab int = const 2 to unsigned char translation = [S+$228-$225] (used reg = )
mov	al,-$223[bp]
xor	ah,ah
shr	ax,*1
shr	ax,*1
mov	-$223[bp],al
!BCC_EOS
! 1687       translation &= 0x03;
.1C8:
! Debug: postdec unsigned char shift = [S+$228-$211] (used reg = )
mov	al,-$20F[bp]
dec	ax
mov	-$20F[bp],al
.1C9:
! Debug: gt int = const 0 to unsigned char shift = [S+$228-$211] (used reg = )
mov	al,-$20F[bp]
test	al,al
jne	.1CA
.1CB:
.1C7:
! Debug: andab int = const 3 to unsigned char translation = [S+$228-$225] (used reg = )
mov	al,-$223[bp]
and	al,*3
mov	-$223[bp],al
!BCC_EOS
! 1688       *((Bit8u *)(&((ebda_data_t *) 0)->ata.devices[device].translation)) = (translation);
! Debug: ptradd unsigned char device = [S+$228-5] to [8] struct  = const $142 (used reg = )
mov	al,-3[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned char = [bx+$14A] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$14A (used reg = )
! Debug: eq unsigned char translation = [S+$228-$225] to unsigned char = [bx+$14A] (used reg = )
mov	al,-$223[bp]
mov	$14A[bx],al
!BCC_EOS
! 1689       switch (translation) {
mov	al,-$223[bp]
jmp .1CE
! 1690         case 0:
! 1691           bios_printf(4, "none");
.1CF:
! Debug: list * char = .1D0+0 (used reg = )
mov	bx,#.1D0
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*4
!BCC_EOS
! 1692           break;
jmp .1CC
!BCC_EOS
! 1693         case 1:
! 1694           bios_printf(4, "lba");
.1D1:
! Debug: list * char = .1D2+0 (used reg = )
mov	bx,#.1D2
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*4
!BCC_EOS
! 1695           break;
jmp .1CC
!BCC_EOS
! 1696         case 2:
! 1697           bios_printf(4, "large");
.1D3:
! Debug: list * char = .1D4+0 (used reg = )
mov	bx,#.1D4
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*4
!BCC_EOS
! 1698           break;
jmp .1CC
!BCC_EOS
! 1699         case 3:
! 1700           bios_printf(4, "r-echs");
.1D5:
! Debug: list * char = .1D6+0 (used reg = )
mov	bx,#.1D6
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*4
!BCC_EOS
! 1701           break;
jmp .1CC
!BCC_EOS
! 1702       }
! 1703       switch (translation) {
jmp .1CC
.1CE:
sub	al,*0
je 	.1CF
sub	al,*1
je 	.1D1
sub	al,*1
je 	.1D3
sub	al,*1
je 	.1D5
.1CC:
..FFFE	=	-$228
mov	al,-$223[bp]
br 	.1D9
! 1704         case 0:
! 1705           break;
.1DA:
br 	.1D7
!BCC_EOS
! 1706         case 1:
! 1707           spt = 63;
.1DB:
! Debug: eq int = const $3F to unsigned short spt = [S+$228-$224] (used reg = )
mov	ax,*$3F
mov	-$222[bp],ax
!BCC_EOS
! 1708           sectors_low /= 63;
! Debug: divab unsigned long = const $3F to unsigned long sectors_low = [S+$228-$21A] (used reg = )
mov	ax,*$3F
xor	bx,bx
push	bx
push	ax
mov	ax,-$218[bp]
mov	bx,-$216[bp]
lea	di,-2+..FFFD[bp]
call	ldivul
mov	-$218[bp],ax
mov	-$216[bp],bx
add	sp,*4
!BCC_EOS
! 1709           heads = sectors_low / 1024;
! Debug: div unsigned long = const $400 to unsigned long sectors_low = [S+$228-$21A] (used reg = )
mov	ax,#$400
xor	bx,bx
push	bx
push	ax
mov	ax,-$218[bp]
mov	bx,-$216[bp]
lea	di,-2+..FFFD[bp]
call	ldivul
add	sp,*4
! Debug: eq unsigned long = bx+0 to unsigned short heads = [S+$228-$222] (used reg = )
mov	-$220[bp],ax
!BCC_EOS
! 1710           if (heads>128) heads = 255;
! Debug: gt int = const $80 to unsigned short heads = [S+$228-$222] (used reg = )
mov	ax,-$220[bp]
cmp	ax,#$80
jbe 	.1DC
.1DD:
! Debug: eq int = const $FF to unsigned short heads = [S+$228-$222] (used reg = )
mov	ax,#$FF
mov	-$220[bp],ax
!BCC_EOS
! 1711           else if (heads>64) heads = 128;
jmp .1DE
.1DC:
! Debug: gt int = const $40 to unsigned short heads = [S+$228-$222] (used reg = )
mov	ax,-$220[bp]
cmp	ax,*$40
jbe 	.1DF
.1E0:
! Debug: eq int = const $80 to unsigned short heads = [S+$228-$222] (used reg = )
mov	ax,#$80
mov	-$220[bp],ax
!BCC_EOS
! 1712           else if (heads>32) heads = 64;
jmp .1E1
.1DF:
! Debug: gt int = const $20 to unsigned short heads = [S+$228-$222] (used reg = )
mov	ax,-$220[bp]
cmp	ax,*$20
jbe 	.1E2
.1E3:
! Debug: eq int = const $40 to unsigned short heads = [S+$228-$222] (used reg = )
mov	ax,*$40
mov	-$220[bp],ax
!BCC_EOS
! 1713           else if (heads>16) heads = 32;
jmp .1E4
.1E2:
! Debug: gt int = const $10 to unsigned short heads = [S+$228-$222] (used reg = )
mov	ax,-$220[bp]
cmp	ax,*$10
jbe 	.1E5
.1E6:
! Debug: eq int = const $20 to unsigned short heads = [S+$228-$222] (used reg = )
mov	ax,*$20
mov	-$220[bp],ax
!BCC_EOS
! 1714           else heads=16;
jmp .1E7
.1E5:
! Debug: eq int = const $10 to unsigned short heads = [S+$228-$222] (used reg = )
mov	ax,*$10
mov	-$220[bp],ax
!BCC_EOS
! 1715           cylinders = sectors_low / heads;
.1E7:
.1E4:
.1E1:
.1DE:
! Debug: cast unsigned long = const 0 to unsigned short heads = [S+$228-$222] (used reg = )
mov	ax,-$220[bp]
xor	bx,bx
! Debug: div unsigned long = bx+0 to unsigned long sectors_low = [S+$228-$21A] (used reg = )
push	bx
push	ax
mov	ax,-$218[bp]
mov	bx,-$216[bp]
lea	di,-2+..FFFD[bp]
call	ldivul
add	sp,*4
! Debug: eq unsigned long = bx+0 to unsigned short cylinders = [S+$228-$220] (used reg = )
mov	-$21E[bp],ax
!BCC_EOS
! 1716           break;
br 	.1D7
!BCC_EOS
! 1717         case 3:
! 1718           if (heads==16) {
.1E8:
! Debug: logeq int = const $10 to unsigned short heads = [S+$228-$222] (used reg = )
mov	ax,-$220[bp]
cmp	ax,*$10
jne 	.1E9
.1EA:
! 1719             if(cylinders>61439) cylinders=61439;
! Debug: cast unsigned long = const 0 to unsigned short cylinders = [S+$228-$220] (used reg = )
mov	ax,-$21E[bp]
xor	bx,bx
! Debug: gt long = const $EFFF to unsigned long = bx+0 (used reg = )
push	bx
push	ax
mov	ax,#$EFFF
xor	bx,bx
push	bx
push	ax
mov	ax,-2+..FFFD[bp]
mov	bx,0+..FFFD[bp]
lea	di,-6+..FFFD[bp]
call	lcmpul
lea	sp,2+..FFFD[bp]
jbe 	.1EB
.1EC:
! Debug: eq long = const $EFFF to unsigned short cylinders = [S+$228-$220] (used reg = )
mov	ax,#$EFFF
mov	-$21E[bp],ax
!BCC_EOS
! 1720             heads=15;
.1EB:
! Debug: eq int = const $F to unsigned short heads = [S+$228-$222] (used reg = )
mov	ax,*$F
mov	-$220[bp],ax
!BCC_EOS
! 1721             cylinders = (Bit16u)((Bit32u)(cylinders)*16/15);
! Debug: cast unsigned long = const 0 to unsigned short cylinders = [S+$228-$220] (used reg = )
mov	ax,-$21E[bp]
xor	bx,bx
! Debug: mul unsigned long = const $10 to unsigned long = bx+0 (used reg = )
push	bx
push	ax
mov	ax,*$10
xor	bx,bx
push	bx
push	ax
mov	ax,-2+..FFFD[bp]
mov	bx,0+..FFFD[bp]
lea	di,-6+..FFFD[bp]
call	lmulul
add	sp,*8
! Debug: div unsigned long = const $F to unsigned long = bx+0 (used reg = )
push	bx
push	ax
mov	ax,*$F
xor	bx,bx
push	bx
push	ax
mov	ax,-2+..FFFD[bp]
mov	bx,0+..FFFD[bp]
lea	di,-6+..FFFD[bp]
call	ldivul
add	sp,*8
! Debug: cast unsigned short = const 0 to unsigned long = bx+0 (used reg = )
! Debug: eq unsigned short = ax+0 to unsigned short cylinders = [S+$228-$220] (used reg = )
mov	-$21E[bp],ax
!BCC_EOS
! 1722           }
! 1723         case 2:
.1E9:
! 1724           while(cylinders > 1024) {
.1ED:
jmp .1EF
.1F0:
! 1725             cylinders >>= 1;
! Debug: srab int = const 1 to unsigned short cylinders = [S+$228-$220] (used reg = )
mov	ax,-$21E[bp]
shr	ax,*1
mov	-$21E[bp],ax
!BCC_EOS
! 1726             heads <<= 1;
! Debug: slab int = const 1 to unsigned short heads = [S+$228-$222] (used reg = )
mov	ax,-$220[bp]
shl	ax,*1
mov	-$220[bp],ax
!BCC_EOS
! 1727             if (heads > 127) break;
! Debug: gt int = const $7F to unsigned short heads = [S+$228-$222] (used reg = )
mov	ax,-$220[bp]
cmp	ax,*$7F
jbe 	.1F1
.1F2:
jmp .1EE
!BCC_EOS
! 1728           }
.1F1:
! 1729           break;
.1EF:
! Debug: gt int = const $400 to unsigned short cylinders = [S+$228-$220] (used reg = )
mov	ax,-$21E[bp]
cmp	ax,#$400
ja 	.1F0
.1F3:
.1EE:
jmp .1D7
!BCC_EOS
! 1730       }
! 1731       if (cylinders > 1024) cylinders=1024;
jmp .1D7
.1D9:
sub	al,*0
beq 	.1DA
sub	al,*1
beq 	.1DB
sub	al,*1
je 	.1ED
sub	al,*1
beq 	.1E8
.1D7:
..FFFD	=	-$228
! Debug: gt int = const $400 to unsigned short cylinders = [S+$228-$220] (used reg = )
mov	ax,-$21E[bp]
cmp	ax,#$400
jbe 	.1F4
.1F5:
! Debug: eq int = const $400 to unsigned short cylinders = [S+$228-$220] (used reg = )
mov	ax,#$400
mov	-$21E[bp],ax
!BCC_EOS
! 1732       bios_printf(4, " LCHS=%d/%d/%d\n", cylinders, heads, spt);
.1F4:
! Debug: list unsigned short spt = [S+$228-$224] (used reg = )
push	-$222[bp]
! Debug: list unsigned short heads = [S+$22A-$222] (used reg = )
push	-$220[bp]
! Debug: list unsigned short cylinders = [S+$22C-$220] (used reg = )
push	-$21E[bp]
! Debug: list * char = .1F6+0 (used reg = )
mov	bx,#.1F6
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*$A
!BCC_EOS
! 1733       *((Bit16u *)(&((ebda_data_t *) 0)->ata.devices[device].lchs.heads)) = (heads);
! Debug: ptradd unsigned char device = [S+$228-5] to [8] struct  = const $142 (used reg = )
mov	al,-3[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned short = [bx+$14C] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$14C (used reg = )
! Debug: eq unsigned short heads = [S+$228-$222] to unsigned short = [bx+$14C] (used reg = )
mov	ax,-$220[bp]
mov	$14C[bx],ax
!BCC_EOS
! 1734       *((Bit16u *)(&((ebda_data_t *) 0)->ata.devices[device].lchs.cylinders)) = (cylinders);
! Debug: ptradd unsigned char device = [S+$228-5] to [8] struct  = const $142 (used reg = )
mov	al,-3[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned short = [bx+$14E] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$14E (used reg = )
! Debug: eq unsigned short cylinders = [S+$228-$220] to unsigned short = [bx+$14E] (used reg = )
mov	ax,-$21E[bp]
mov	$14E[bx],ax
!BCC_EOS
! 1735   
! 1735     *((Bit16u *)(&((ebda_data_t *) 0)->ata.devices[device].lchs.spt)) = (spt);
! Debug: ptradd unsigned char device = [S+$228-5] to [8] struct  = const $142 (used reg = )
mov	al,-3[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned short = [bx+$150] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$150 (used reg = )
! Debug: eq unsigned short spt = [S+$228-$224] to unsigned short = [bx+$150] (used reg = )
mov	ax,-$222[bp]
mov	$150[bx],ax
!BCC_EOS
! 1736       *((Bit8u *)(&((ebda_data_t *) 0)->ata.hdidmap[hdcount])) = (device);
! Debug: ptradd unsigned char hdcount = [S+$228-3] to [8] unsigned char = const $233 (used reg = )
mov	al,-1[bp]
xor	ah,ah
mov	bx,ax
! Debug: address unsigned char = [bx+$233] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$233 (used reg = )
! Debug: eq unsigned char device = [S+$228-5] to unsigned char = [bx+$233] (used reg = )
mov	al,-3[bp]
mov	$233[bx],al
!BCC_EOS
! 1737       hdcount++;
! Debug: postinc unsigned char hdcount = [S+$228-3] (used reg = )
mov	al,-1[bp]
inc	ax
mov	-1[bp],al
!BCC_EOS
! 1738     }
add	sp,*$12
! 1739     if(type == 0x03) {
.1BB:
! Debug: logeq int = const 3 to unsigned char type = [S+$216-6] (used reg = )
mov	al,-4[bp]
cmp	al,*3
bne 	.1F7
.1F8:
! 1740       Bit8u type, removable, mode;
!BCC_EOS
! 1741       *((Bit8u *)(&((ebda_data_t *) 0)->ata.devices[device].device)) = (0x05);
add	sp,*-4
! Debug: ptradd unsigned char device = [S+$21A-5] to [8] struct  = const $142 (used reg = )
mov	al,-3[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned char = [bx+$143] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$143 (used reg = )
! Debug: eq int = const 5 to unsigned char = [bx+$143] (used reg = )
mov	al,*5
mov	$143[bx],al
!BCC_EOS
! 1742       *((Bit8u *)(&((ebda_data_t *) 0)->ata.devices[device].mode)) = (0x00);
! Debug: ptradd unsigned char device = [S+$21A-5] to [8] struct  = const $142 (used reg = )
mov	al,-3[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned char = [bx+$146] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$146 (used reg = )
! Debug: eq int = const 0 to unsigned char = [bx+$146] (used reg = )
xor	al,al
mov	$146[bx],al
!BCC_EOS
! 1743       if (ata_cmd_data_io(0, device,0xA1, 1, 0, 0, 0, 0L, 0L, get_SS(),buffer) != 0)
! Debug: list * unsigned char buffer = S+$21A-$206 (used reg = )
lea	bx,-$204[bp]
push	bx
! Debug: func () unsigned short = get_SS+0 (used reg = )
call	_get_SS
! Debug: list unsigned short = ax+0 (used reg = )
push	ax
! Debug: list long = const 0 (used reg = )
xor	ax,ax
xor	bx,bx
push	bx
push	ax
! Debug: list long = const 0 (used reg = )
xor	ax,ax
xor	bx,bx
push	bx
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 1 (used reg = )
mov	ax,*1
push	ax
! Debug: list int = const $A1 (used reg = )
mov	ax,#$A1
push	ax
! Debug: list unsigned char device = [S+$230-5] (used reg = )
mov	al,-3[bp]
xor	ah,ah
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: func () unsigned short = ata_cmd_data_io+0 (used reg = )
call	_ata_cmd_data_io
add	sp,*$1A
! Debug: ne int = const 0 to unsigned short = ax+0 (used reg = )
test	ax,ax
je  	.1F9
.1FA:
! 1744         bios_printf((2 | 4 | 1), "ata-detect: Failed to detect ATAPI device\n");
! Debug: list * char = .1FB+0 (used reg = )
mov	bx,#.1FB
push	bx
! Debug: list int = const 7 (used reg = )
mov	ax,*7
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*4
!BCC_EOS
! 1745       type = read_byte_SS(buffer+1) & 0x1f;
.1F9:
! Debug: list * unsigned char buffer = S+$21A-$205 (used reg = )
lea	bx,-$203[bp]
push	bx
! Debug: func () unsigned char = read_byte_SS+0 (used reg = )
call	_read_byte_SS
inc	sp
inc	sp
! Debug: and int = const $1F to unsigned char = al+0 (used reg = )
and	al,*$1F
! Debug: eq unsigned char = al+0 to unsigned char type = [S+$21A-$217] (used reg = )
mov	-$215[bp],al
!BCC_EOS
! 1746       removable = (read_byte_SS(buffer+0) & 0x80) ? 1 : 0;
! Debug: list * unsigned char buffer = S+$21A-$206 (used reg = )
lea	bx,-$204[bp]
push	bx
! Debug: func () unsigned char = read_byte_SS+0 (used reg = )
call	_read_byte_SS
inc	sp
inc	sp
! Debug: and int = const $80 to unsigned char = al+0 (used reg = )
and	al,#$80
test	al,al
je  	.1FC
.1FD:
mov	al,*1
jmp .1FE
.1FC:
xor	al,al
.1FE:
! Debug: eq char = al+0 to unsigned char removable = [S+$21A-$218] (used reg = )
mov	-$216[bp],al
!BCC_EOS
! 1747       mode = read_byte_SS(buffer+96) ? 0x01 : 0x00;
! Debug: list * unsigned char buffer = S+$21A-$1A6 (used reg = )
lea	bx,-$1A4[bp]
push	bx
! Debug: func () unsigned char = read_byte_SS+0 (used reg = )
call	_read_byte_SS
inc	sp
inc	sp
test	al,al
je  	.1FF
.200:
mov	al,*1
jmp .201
.1FF:
xor	al,al
.201:
! Debug: eq char = al+0 to unsigned char mode = [S+$21A-$219] (used reg = )
mov	-$217[bp],al
!BCC_EOS
! 1748       blksize = 2048;
! Debug: eq int = const $800 to unsigned short blksize = [S+$21A-$20E] (used reg = )
mov	ax,#$800
mov	-$20C[bp],ax
!BCC_EOS
! 1749       *((Bit8u *)(&((ebda_data_t *) 0)->ata.devices[device].device)) = (type);
! Debug: ptradd unsigned char device = [S+$21A-5] to [8] struct  = const $142 (used reg = )
mov	al,-3[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned char = [bx+$143] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$143 (used reg = )
! Debug: eq unsigned char type = [S+$21A-$217] to unsigned char = [bx+$143] (used reg = )
mov	al,-$215[bp]
mov	$143[bx],al
!BCC_EOS
! 1750       *((Bit8u *)(&((ebda_data_t *) 0)->ata.devices[device].removable)) = (removable);
! Debug: ptradd unsigned char device = [S+$21A-5] to [8] struct  = const $142 (used reg = )
mov	al,-3[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned char = [bx+$144] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$144 (used reg = )
! Debug: eq unsigned char removable = [S+$21A-$218] to unsigned char = [bx+$144] (used reg = )
mov	al,-$216[bp]
mov	$144[bx],al
!BCC_EOS
! 1751       *((Bit8u *)(&((ebda_data_t *) 0)->ata.devices[device].mode)) = (mode);
! Debug: ptradd unsigned char device = [S+$21A-5] to [8] struct  = const $142 (used reg = )
mov	al,-3[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned char = [bx+$146] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$146 (used reg = )
! Debug: eq unsigned char mode = [S+$21A-$219] to unsigned char = [bx+$146] (used reg = )
mov	al,-$217[bp]
mov	$146[bx],al
!BCC_EOS
! 1752       *((Bit16u *)(&((ebda_data_t *) 0)->ata.devices[device].blksize)) = (blksize);
! Debug: ptradd unsigned char device = [S+$21A-5] to [8] struct  = const $142 (used reg = )
mov	al,-3[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned short = [bx+$148] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$148 (used reg = )
! Debug: eq unsigned short blksize = [S+$21A-$20E] to unsigned short = [bx+$148] (used reg = )
mov	ax,-$20C[bp]
mov	$148[bx],ax
!BCC_EOS
! 1753       *((Bit8u *)(&((ebda_data_t *) 0)->ata.cdidmap[cdcount])) = (device);
! Debug: ptradd unsigned char cdcount = [S+$21A-4] to [8] unsigned char = const $23C (used reg = )
mov	al,-2[bp]
xor	ah,ah
mov	bx,ax
! Debug: address unsigned char = [bx+$23C] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$23C (used reg = )
! Debug: eq unsigned char device = [S+$21A-5] to unsigned char = [bx+$23C] (used reg = )
mov	al,-3[bp]
mov	$23C[bx],al
!BCC_EOS
! 1754       cdcount++;
! Debug: postinc unsigned char cdcount = [S+$21A-4] (used reg = )
mov	al,-2[bp]
inc	ax
mov	-2[bp],al
!BCC_EOS
! 1755     }
add	sp,*4
! 1756     {
.1F7:
! 1757       Bit32u sizeinmb;
!BCC_EOS
! 1758       Bit16u ataversion;
!BCC_EOS
! 1759       Bit8u c, i, lshift, rshift, version, model[41];
!BCC_EOS
! 1760       switch (type) {
add	sp,*-$34
mov	al,-4[bp]
br 	.204
! 1761         case 0x02:
! 1762           switch (blksize) {
.205:
mov	ax,-$20C[bp]
jmp .208
! 1763             case 1024:
! 1764               lshift = 22;
.209:
! Debug: eq int = const $16 to unsigned char lshift = [S+$24A-$21F] (used reg = )
mov	al,*$16
mov	-$21D[bp],al
!BCC_EOS
! 1765               rshift = 10;
! Debug: eq int = const $A to unsigned char rshift = [S+$24A-$220] (used reg = )
mov	al,*$A
mov	-$21E[bp],al
!BCC_EOS
! 1766               break;
jmp .206
!BCC_EOS
! 1767             case 4096:
! 1768               lshift = 24;
.20A:
! Debug: eq int = const $18 to unsigned char lshift = [S+$24A-$21F] (used reg = )
mov	al,*$18
mov	-$21D[bp],al
!BCC_EOS
! 1769               rshift = 8;
! Debug: eq int = const 8 to unsigned char rshift = [S+$24A-$220] (used reg = )
mov	al,*8
mov	-$21E[bp],al
!BCC_EOS
! 1770               break;
jmp .206
!BCC_EOS
! 1771             default:
! 1772               lshift = 21;
.20B:
! Debug: eq int = const $15 to unsigned char lshift = [S+$24A-$21F] (used reg = )
mov	al,*$15
mov	-$21D[bp],al
!BCC_EOS
! 1773               rshift = 11;
! Debug: eq int = const $B to unsigned char rshift = [S+$24A-$220] (used reg = )
mov	al,*$B
mov	-$21E[bp],al
!BCC_EOS
! 1774           }
! 1775           sizeinmb = (*((Bit32u *)(&((ebda_data_t *) 0)->ata.devices[device].sectors_high)) << lshift)
jmp .206
.208:
sub	ax,#$400
je 	.209
sub	ax,#$C00
je 	.20A
jmp	.20B
.206:
! 1776             | (*((Bit32u *)(&((ebda_data_t *) 0)->ata.devices[device].sectors_low)) >> rshift);
! Debug: ptradd unsigned char device = [S+$24A-5] to [8] struct  = const $142 (used reg = )
mov	al,-3[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned long = [bx+$158] (used reg = )
! Debug: cast * unsigned long = const 0 to * unsigned long = bx+$158 (used reg = )
! Debug: sr unsigned char rshift = [S+$24A-$220] to unsigned long = [bx+$158] (used reg = )
mov	al,-$21E[bp]
push	ax
mov	ax,$158[bx]
mov	bx,$15A[bx]
mov	cl,0+..FFFC[bp]
xor	ch,ch
mov	di,cx
call	lsrul
inc	sp
inc	sp
push	bx
push	ax
! Debug: ptradd unsigned char device = [S+$24E-5] to [8] struct  = const $142 (used reg = )
mov	al,-3[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned long = [bx+$15C] (used reg = )
! Debug: cast * unsigned long = const 0 to * unsigned long = bx+$15C (used reg = )
! Debug: sl unsigned char lshift = [S+$24E-$21F] to unsigned long = [bx+$15C] (used reg = )
mov	al,-$21D[bp]
push	ax
mov	ax,$15C[bx]
mov	bx,$15E[bx]
mov	cl,-4+..FFFC[bp]
xor	ch,ch
mov	di,cx
call	lslul
inc	sp
inc	sp
! Debug: or unsigned long (temp) = [S+$24E-$24E] to unsigned long = bx+0 (used reg = )
lea	di,-2+..FFFC[bp]
call	lorul
add	sp,*4
! Debug: eq unsigned long = bx+0 to unsigned long sizeinmb = [S+$24A-$21A] (used reg = )
mov	-$218[bp],ax
mov	-$216[bp],bx
!BCC_EOS
! 1777         case 0x03:
! 1778           ataversion=((Bit16u)(read_byte_SS(buffer+161))<<8)|read_byte_SS(buffer+160);
.20C:
! Debug: list * unsigned char buffer = S+$24A-$166 (used reg = )
lea	bx,-$164[bp]
push	bx
! Debug: func () unsigned char = read_byte_SS+0 (used reg = )
call	_read_byte_SS
inc	sp
inc	sp
push	ax
! Debug: list * unsigned char buffer = S+$24C-$165 (used reg = )
lea	bx,-$163[bp]
push	bx
! Debug: func () unsigned char = read_byte_SS+0 (used reg = )
call	_read_byte_SS
inc	sp
inc	sp
! Debug: cast unsigned short = const 0 to unsigned char = al+0 (used reg = )
xor	ah,ah
! Debug: sl int = const 8 to unsigned short = ax+0 (used reg = )
mov	ah,al
xor	al,al
! Debug: or unsigned char (temp) = [S+$24C-$24C] to unsigned int = ax+0 (used reg = )
or	al,0+..FFFC[bp]
inc	sp
inc	sp
! Debug: eq unsigned int = ax+0 to unsigned short ataversion = [S+$24A-$21C] (used reg = )
mov	-$21A[bp],ax
!BCC_EOS
! 1779           for(version=15;version>0;version--) {
! Debug: eq int = const $F to unsigned char version = [S+$24A-$221] (used reg = )
mov	al,*$F
mov	-$21F[bp],al
!BCC_EOS
!BCC_EOS
jmp .20F
.210:
! 1780             if((ataversion&(1<<version))!=0)
! Debug: sl unsigned char version = [S+$24A-$221] to int = const 1 (used reg = )
mov	al,-$21F[bp]
xor	ah,ah
mov	bx,ax
mov	ax,*1
mov	cx,bx
shl	ax,cl
! Debug: and int = ax+0 to unsigned short ataversion = [S+$24A-$21C] (used reg = )
! Debug: expression subtree swapping
and	ax,-$21A[bp]
! Debug: ne int = const 0 to unsigned int = ax+0 (used reg = )
test	ax,ax
je  	.211
.212:
! 1781             break;
jmp .20D
!BCC_EOS
! 1782           }
.211:
! 1783 
! 1783           for(i=0;i<20;i++) {
.20E:
! Debug: postdec unsigned char version = [S+$24A-$221] (used reg = )
mov	al,-$21F[bp]
dec	ax
mov	-$21F[bp],al
.20F:
! Debug: gt int = const 0 to unsigned char version = [S+$24A-$221] (used reg = )
mov	al,-$21F[bp]
test	al,al
jne	.210
.213:
.20D:
! Debug: eq int = const 0 to unsigned char i = [S+$24A-$21E] (used reg = )
xor	al,al
mov	-$21C[bp],al
!BCC_EOS
!BCC_EOS
jmp .216
.217:
! 1784             _write_byte_SS(read_byte_SS(buffer+(i*2)+54+1), model+(i*2));
! Debug: mul int = const 2 to unsigned char i = [S+$24A-$21E] (used reg = )
mov	al,-$21C[bp]
xor	ah,ah
shl	ax,*1
! Debug: ptradd unsigned int = ax+0 to [$29] unsigned char model = S+$24A-$24A (used reg = )
mov	bx,bp
add	bx,ax
! Debug: cast * unsigned char = const 0 to [$29] unsigned char = bx-$248 (used reg = )
! Debug: list * unsigned char = bx-$248 (used reg = )
add	bx,#-$248
push	bx
! Debug: mul int = const 2 to unsigned char i = [S+$24C-$21E] (used reg = )
mov	al,-$21C[bp]
xor	ah,ah
shl	ax,*1
! Debug: ptradd unsigned int = ax+0 to [$200] unsigned char buffer = S+$24C-$206 (used reg = )
mov	bx,bp
add	bx,ax
! Debug: ptradd int = const $36 to [$200] unsigned char = bx-$204 (used reg = )
! Debug: ptradd int = const 1 to [$200] unsigned char = bx-$1CE (used reg = )
! Debug: cast * unsigned char = const 0 to [$200] unsigned char = bx-$1CD (used reg = )
! Debug: list * unsigned char = bx-$1CD (used reg = )
add	bx,#-$1CD
push	bx
! Debug: func () unsigned char = read_byte_SS+0 (used reg = )
call	_read_byte_SS
inc	sp
inc	sp
! Debug: list unsigned char = al+0 (used reg = )
xor	ah,ah
push	ax
! Debug: func () void = _write_byte_SS+0 (used reg = )
call	__write_byte_SS
add	sp,*4
!BCC_EOS
! 1785             _write_byte_SS(read_byte_SS(buffer+(i*2)+54), model+(i*2)+1);
! Debug: mul int = const 2 to unsigned char i = [S+$24A-$21E] (used reg = )
mov	al,-$21C[bp]
xor	ah,ah
shl	ax,*1
! Debug: ptradd unsigned int = ax+0 to [$29] unsigned char model = S+$24A-$24A (used reg = )
mov	bx,bp
add	bx,ax
! Debug: ptradd int = const 1 to [$29] unsigned char = bx-$248 (used reg = )
! Debug: cast * unsigned char = const 0 to [$29] unsigned char = bx-$247 (used reg = )
! Debug: list * unsigned char = bx-$247 (used reg = )
add	bx,#-$247
push	bx
! Debug: mul int = const 2 to unsigned char i = [S+$24C-$21E] (used reg = )
mov	al,-$21C[bp]
xor	ah,ah
shl	ax,*1
! Debug: ptradd unsigned int = ax+0 to [$200] unsigned char buffer = S+$24C-$206 (used reg = )
mov	bx,bp
add	bx,ax
! Debug: ptradd int = const $36 to [$200] unsigned char = bx-$204 (used reg = )
! Debug: cast * unsigned char = const 0 to [$200] unsigned char = bx-$1CE (used reg = )
! Debug: list * unsigned char = bx-$1CE (used reg = )
add	bx,#-$1CE
push	bx
! Debug: func () unsigned char = read_byte_SS+0 (used reg = )
call	_read_byte_SS
inc	sp
inc	sp
! Debug: list unsigned char = al+0 (used reg = )
xor	ah,ah
push	ax
! Debug: func () void = _write_byte_SS+0 (used reg = )
call	__write_byte_SS
add	sp,*4
!BCC_EOS
! 1786           }
! 1787           _write_byte_SS(0x00, model+40);
.215:
! Debug: postinc unsigned char i = [S+$24A-$21E] (used reg = )
mov	al,-$21C[bp]
inc	ax
mov	-$21C[bp],al
.216:
! Debug: lt int = const $14 to unsigned char i = [S+$24A-$21E] (used reg = )
mov	al,-$21C[bp]
cmp	al,*$14
jb 	.217
.218:
.214:
! Debug: list * unsigned char model = S+$24A-$222 (used reg = )
lea	bx,-$220[bp]
push	bx
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: func () void = _write_byte_SS+0 (used reg = )
call	__write_byte_SS
add	sp,*4
!BCC_EOS
! 1788           for(i=39;i>0;i--){
! Debug: eq int = const $27 to unsigned char i = [S+$24A-$21E] (used reg = )
mov	al,*$27
mov	-$21C[bp],al
!BCC_EOS
!BCC_EOS
jmp .21B
.21C:
! 1789             if(read_byte_SS(model+i)==0x20)
! Debug: ptradd unsigned char i = [S+$24A-$21E] to [$29] unsigned char model = S+$24A-$24A (used reg = )
mov	al,-$21C[bp]
xor	ah,ah
mov	bx,bp
add	bx,ax
! Debug: cast * unsigned char = const 0 to [$29] unsigned char = bx-$248 (used reg = )
! Debug: list * unsigned char = bx-$248 (used reg = )
add	bx,#-$248
push	bx
! Debug: func () unsigned char = read_byte_SS+0 (used reg = )
call	_read_byte_SS
inc	sp
inc	sp
! Debug: logeq int = const $20 to unsigned char = al+0 (used reg = )
cmp	al,*$20
jne 	.21D
.21E:
! 1790               _write_byte_SS(0x00, model+i);
! Debug: ptradd unsigned char i = [S+$24A-$21E] to [$29] unsigned char model = S+$24A-$24A (used reg = )
mov	al,-$21C[bp]
xor	ah,ah
mov	bx,bp
add	bx,ax
! Debug: cast * unsigned char = const 0 to [$29] unsigned char = bx-$248 (used reg = )
! Debug: list * unsigned char = bx-$248 (used reg = )
add	bx,#-$248
push	bx
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: func () void = _write_byte_SS+0 (used reg = )
call	__write_byte_SS
add	sp,*4
!BCC_EOS
! 1791             else break;
jmp .21F
.21D:
jmp .219
!BCC_EOS
! 1792           }
.21F:
! 1793           if (i>36) {
.21A:
! Debug: postdec unsigned char i = [S+$24A-$21E] (used reg = )
mov	al,-$21C[bp]
dec	ax
mov	-$21C[bp],al
.21B:
! Debug: gt int = const 0 to unsigned char i = [S+$24A-$21E] (used reg = )
mov	al,-$21C[bp]
test	al,al
jne	.21C
.220:
.219:
! Debug: gt int = const $24 to unsigned char i = [S+$24A-$21E] (used reg = )
mov	al,-$21C[bp]
cmp	al,*$24
jbe 	.221
.222:
! 1794             _write_byte_SS(0x00, model+36);
! Debug: list * unsigned char model = S+$24A-$226 (used reg = )
lea	bx,-$224[bp]
push	bx
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: func () void = _write_byte_SS+0 (used reg = )
call	__write_byte_SS
add	sp,*4
!BCC_EOS
! 1795             for(i=35;i>32;i--){
! Debug: eq int = const $23 to unsigned char i = [S+$24A-$21E] (used reg = )
mov	al,*$23
mov	-$21C[bp],al
!BCC_EOS
!BCC_EOS
jmp .225
.226:
! 1796               _write_byte_SS(0x2E, model+i);
! Debug: ptradd unsigned char i = [S+$24A-$21E] to [$29] unsigned char model = S+$24A-$24A (used reg = )
mov	al,-$21C[bp]
xor	ah,ah
mov	bx,bp
add	bx,ax
! Debug: cast * unsigned char = const 0 to [$29] unsigned char = bx-$248 (used reg = )
! Debug: list * unsigned char = bx-$248 (used reg = )
add	bx,#-$248
push	bx
! Debug: list int = const $2E (used reg = )
mov	ax,*$2E
push	ax
! Debug: func () void = _write_byte_SS+0 (used reg = )
call	__write_byte_SS
add	sp,*4
!BCC_EOS
! 1797             }
! 1798           }
.224:
! Debug: postdec unsigned char i = [S+$24A-$21E] (used reg = )
mov	al,-$21C[bp]
dec	ax
mov	-$21C[bp],al
.225:
! Debug: gt int = const $20 to unsigned char i = [S+$24A-$21E] (used reg = )
mov	al,-$21C[bp]
cmp	al,*$20
ja 	.226
.227:
.223:
! 1799           break;
.221:
jmp .202
!BCC_EOS
! 1800       }
! 1801       switch (type) {
jmp .202
.204:
sub	al,*2
beq 	.205
sub	al,*1
beq 	.20C
.202:
..FFFC	=	-$24A
mov	al,-4[bp]
br 	.22A
! 1802         case 0x02:
! 1803           bios_printf(2, "ata%d %s: ",channel,slave?" slave":"master");
.22B:
mov	al,-$20E[bp]
test	al,al
je  	.22F
.230:
mov	bx,#.22D
jmp .231
.22F:
mov	bx,#.22E
.231:
! Debug: list * char = bx+0 (used reg = )
push	bx
! Debug: list unsigned char channel = [S+$24C-$20F] (used reg = )
mov	al,-$20D[bp]
xor	ah,ah
push	ax
! Debug: list * char = .22C+0 (used reg = )
mov	bx,#.22C
push	bx
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*8
!BCC_EOS
! 1804           i=0;
! Debug: eq int = const 0 to unsigned char i = [S+$24A-$21E] (used reg = )
xor	al,al
mov	-$21C[bp],al
!BCC_EOS
! 1805           while(c=read_byte_SS(model+i++))
! 1806             bios_printf(2, "%c",c);
jmp .233
.234:
! Debug: list unsigned char c = [S+$24A-$21D] (used reg = )
mov	al,-$21B[bp]
xor	ah,ah
push	ax
! Debug: list * char = .235+0 (used reg = )
mov	bx,#.235
push	bx
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*6
!BCC_EOS
! 1807           if (sizeinmb < (1UL<<16))
.233:
! Debug: postinc unsigned char i = [S+$24A-$21E] (used reg = )
mov	al,-$21C[bp]
inc	ax
mov	-$21C[bp],al
! Debug: ptradd unsigned char = al-1 to [$29] unsigned char model = S+$24A-$24A (used reg = )
dec	ax
xor	ah,ah
mov	bx,bp
add	bx,ax
! Debug: cast * unsigned char = const 0 to [$29] unsigned char = bx-$248 (used reg = )
! Debug: list * unsigned char = bx-$248 (used reg = )
add	bx,#-$248
push	bx
! Debug: func () unsigned char = read_byte_SS+0 (used reg = )
call	_read_byte_SS
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char c = [S+$24A-$21D] (used reg = )
mov	-$21B[bp],al
test	al,al
jne	.234
.236:
.232:
! Debug: lt unsigned long = const $10000 to unsigned long sizeinmb = [S+$24A-$21A] (used reg = )
xor	ax,ax
mov	bx,*1
lea	di,-$218[bp]
call	lcmpul
jbe 	.237
.238:
! 1808             bios_printf(2, " ATA-%d Hard-Disk (%4u MBytes)\n", version, (Bit16u)sizeinmb);
! Debug: list unsigned short sizeinmb = [S+$24A-$21A] (used reg = )
push	-$218[bp]
! Debug: list unsigned char version = [S+$24C-$221] (used reg = )
mov	al,-$21F[bp]
xor	ah,ah
push	ax
! Debug: list * char = .239+0 (used reg = )
mov	bx,#.239
push	bx
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*8
!BCC_EOS
! 1809           else
! 1810             bios_printf(2, " ATA-%d Hard-Disk (%4u GBytes)\n", version, (Bit16u)(sizeinmb>>10));
jmp .23A
.237:
! Debug: sr int = const $A to unsigned long sizeinmb = [S+$24A-$21A] (used reg = )
mov	ax,-$218[bp]
mov	bx,-$216[bp]
mov	al,ah
mov	ah,bl
mov	bl,bh
sub	bh,bh
mov	di,*2
call	lsrul
! Debug: cast unsigned short = const 0 to unsigned long = bx+0 (used reg = )
! Debug: list unsigned short = ax+0 (used reg = )
push	ax
! Debug: list unsigned char version = [S+$24C-$221] (used reg = )
mov	al,-$21F[bp]
xor	ah,ah
push	ax
! Debug: list * char = .23B+0 (used reg = )
mov	bx,#.23B
push	bx
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*8
!BCC_EOS
! 1811           break;
.23A:
br 	.228
!BCC_EOS
! 1812         case 0x03:
! 1813           bios_printf(2, "ata%d %s: ",channel,slave?" slave":"master");
.23C:
mov	al,-$20E[bp]
test	al,al
je  	.240
.241:
mov	bx,#.23E
jmp .242
.240:
mov	bx,#.23F
.242:
! Debug: list * char = bx+0 (used reg = )
push	bx
! Debug: list unsigned char channel = [S+$24C-$20F] (used reg = )
mov	al,-$20D[bp]
xor	ah,ah
push	ax
! Debug: list * char = .23D+0 (used reg = )
mov	bx,#.23D
push	bx
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*8
!BCC_EOS
! 1814           i=0; while(c=read_byte_SS(model+i++)) bios_printf(2, "%c",c);
! Debug: eq int = const 0 to unsigned char i = [S+$24A-$21E] (used reg = )
xor	al,al
mov	-$21C[bp],al
!BCC_EOS
jmp .244
.245:
! Debug: list unsigned char c = [S+$24A-$21D] (used reg = )
mov	al,-$21B[bp]
xor	ah,ah
push	ax
! Debug: list * char = .246+0 (used reg = )
mov	bx,#.246
push	bx
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*6
!BCC_EOS
! 1815           if(*((Bit8u *)(&((ebda_data_t *) 0)->ata.devices[device].device))==0x05)
.244:
! Debug: postinc unsigned char i = [S+$24A-$21E] (used reg = )
mov	al,-$21C[bp]
inc	ax
mov	-$21C[bp],al
! Debug: ptradd unsigned char = al-1 to [$29] unsigned char model = S+$24A-$24A (used reg = )
dec	ax
xor	ah,ah
mov	bx,bp
add	bx,ax
! Debug: cast * unsigned char = const 0 to [$29] unsigned char = bx-$248 (used reg = )
! Debug: list * unsigned char = bx-$248 (used reg = )
add	bx,#-$248
push	bx
! Debug: func () unsigned char = read_byte_SS+0 (used reg = )
call	_read_byte_SS
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char c = [S+$24A-$21D] (used reg = )
mov	-$21B[bp],al
test	al,al
jne	.245
.247:
.243:
! Debug: ptradd unsigned char device = [S+$24A-5] to [8] struct  = const $142 (used reg = )
mov	al,-3[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned char = [bx+$143] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$143 (used reg = )
! Debug: logeq int = const 5 to unsigned char = [bx+$143] (used reg = )
mov	al,$143[bx]
cmp	al,*5
jne 	.248
.249:
! 1816             bios_printf(2, " ATAPI-%d CD-Rom/DVD-Rom\n",version);
! Debug: list unsigned char version = [S+$24A-$221] (used reg = )
mov	al,-$21F[bp]
xor	ah,ah
push	ax
! Debug: list * char = .24A+0 (used reg = )
mov	bx,#.24A
push	bx
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*6
!BCC_EOS
! 1817           else
! 1818             bios_printf(2, " ATAPI-%d Device\n",version);
jmp .24B
.248:
! Debug: list unsigned char version = [S+$24A-$221] (used reg = )
mov	al,-$21F[bp]
xor	ah,ah
push	ax
! Debug: list * char = .24C+0 (used reg = )
mov	bx,#.24C
push	bx
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*6
!BCC_EOS
! 1819           break;
.24B:
jmp .228
!BCC_EOS
! 1820         case 0x01:
! 1821           bios_printf(2, "ata%d %s: Unknown device\n",channel,slave?" slave":"master");
.24D:
mov	al,-$20E[bp]
test	al,al
je  	.251
.252:
mov	bx,#.24F
jmp .253
.251:
mov	bx,#.250
.253:
! Debug: list * char = bx+0 (used reg = )
push	bx
! Debug: list unsigned char channel = [S+$24C-$20F] (used reg = )
mov	al,-$20D[bp]
xor	ah,ah
push	ax
! Debug: list * char = .24E+0 (used reg = )
mov	bx,#.24E
push	bx
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*8
!BCC_EOS
! 1822           break;
jmp .228
!BCC_EOS
! 1823       }
! 1824     }
jmp .228
.22A:
sub	al,*1
je 	.24D
sub	al,*1
beq 	.22B
sub	al,*1
beq 	.23C
.228:
..FFFB	=	-$24A
add	sp,*$34
! 1825   }
add	sp,*$E
! 1826   *((Bit8u *)(&((ebda_data_t *) 0)->ata.hdcount)) = (hdcount);
.1A0:
! Debug: postinc unsigned char device = [S+$208-5] (used reg = )
mov	al,-3[bp]
inc	ax
mov	-3[bp],al
.1A1:
! Debug: lt int = const 8 to unsigned char device = [S+$208-5] (used reg = )
mov	al,-3[bp]
cmp	al,*8
blo 	.1A2
.254:
.19F:
! Debug: eq unsigned char hdcount = [S+$208-3] to unsigned char = [+$232] (used reg = )
mov	al,-1[bp]
mov	[$232],al
!BCC_EOS
! 1827   *((Bit8u *)(&((ebda_data_t *) 0)->ata.cdcount)) = (cdcount);
! Debug: eq unsigned char cdcount = [S+$208-4] to unsigned char = [+$23B] (used reg = )
mov	al,-2[bp]
mov	[$23B],al
!BCC_EOS
! 1828   _write_byte(hdcount, 0x75, 0x40);
! Debug: list int = const $40 (used reg = )
mov	ax,*$40
push	ax
! Debug: list int = const $75 (used reg = )
mov	ax,*$75
push	ax
! Debug: list unsigned char hdcount = [S+$20C-3] (used reg = )
mov	al,-1[bp]
xor	ah,ah
push	ax
! Debug: func () void = _write_byte+0 (used reg = )
call	__write_byte
add	sp,*6
!BCC_EOS
! 1829   bios_printf(2, "\n");
! Debug: list * char = .255+0 (used reg = )
mov	bx,#.255
push	bx
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*4
!BCC_EOS
! 1830   set_DS(old_ds);
! Debug: list unsigned short old_ds = [S+$208-$208] (used reg = )
push	-$206[bp]
! Debug: func () unsigned short = set_DS+0 (used reg = )
call	_set_DS
inc	sp
inc	sp
!BCC_EOS
! 1831 }
mov	sp,bp
pop	bp
ret
! 1832 void ata_reset(device)
! Register BX used in function ata_detect
! 1833 Bit16u device;
export	_ata_reset
_ata_reset:
!BCC_EOS
! 1834 {
! 1835   Bit16u iobase1, iobase2;
!BCC_EOS
! 1836   Bit8u channel, slave, sn, sc;
!BCC_EOS
! 1837   Bit8u type;
!BCC_EOS
! 1838   Bit16u max;
!BCC_EOS
! 1839   channel = device / 2;
push	bp
mov	bp,sp
add	sp,*-$C
! Debug: div int = const 2 to unsigned short device = [S+$E+2] (used reg = )
mov	ax,4[bp]
shr	ax,*1
! Debug: eq unsigned int = ax+0 to unsigned char channel = [S+$E-7] (used reg = )
mov	-5[bp],al
!BCC_EOS
! 1840   slave = device % 2;
! Debug: mod int = const 2 to unsigned short device = [S+$E+2] (used reg = )
mov	ax,4[bp]
and	al,*1
! Debug: eq unsigned char = al+0 to unsigned char slave = [S+$E-8] (used reg = )
mov	-6[bp],al
!BCC_EOS
! 1841   iobase1 = *((Bit16u *)(&((ebda_data_t *) 0)->ata.channels[channel].iobase1));
! Debug: ptradd unsigned char channel = [S+$E-7] to [4] struct  = const $122 (used reg = )
mov	al,-5[bp]
xor	ah,ah
mov	cl,*3
shl	ax,cl
mov	bx,ax
! Debug: address unsigned short = [bx+$124] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$124 (used reg = )
! Debug: eq unsigned short = [bx+$124] to unsigned short iobase1 = [S+$E-4] (used reg = )
mov	bx,$124[bx]
mov	-2[bp],bx
!BCC_EOS
! 1842   
! 1842 iobase2 = *((Bit16u *)(&((ebda_data_t *) 0)->ata.channels[channel].iobase2));
! Debug: ptradd unsigned char channel = [S+$E-7] to [4] struct  = const $122 (used reg = )
mov	al,-5[bp]
xor	ah,ah
mov	cl,*3
shl	ax,cl
mov	bx,ax
! Debug: address unsigned short = [bx+$126] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$126 (used reg = )
! Debug: eq unsigned short = [bx+$126] to unsigned short iobase2 = [S+$E-6] (used reg = )
mov	bx,$126[bx]
mov	-4[bp],bx
!BCC_EOS
! 1843   outb(iobase2+6, 0x08 | 0x02 | 0x04);
! Debug: list int = const $E (used reg = )
mov	ax,*$E
push	ax
! Debug: add int = const 6 to unsigned short iobase2 = [S+$10-6] (used reg = )
mov	ax,-4[bp]
! Debug: list unsigned int = ax+6 (used reg = )
add	ax,*6
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1844   await_ide(1, iobase1, 20);
! Debug: list int = const $14 (used reg = )
mov	ax,*$14
push	ax
! Debug: list unsigned short iobase1 = [S+$10-4] (used reg = )
push	-2[bp]
! Debug: list int = const 1 (used reg = )
mov	ax,*1
push	ax
! Debug: func () int = await_ide+0 (used reg = )
call	_await_ide
add	sp,*6
!BCC_EOS
! 1845   outb(iobase2+6, 0x08 | 0x02);
! Debug: list int = const $A (used reg = )
mov	ax,*$A
push	ax
! Debug: add int = const 6 to unsigned short iobase2 = [S+$10-6] (used reg = )
mov	ax,-4[bp]
! Debug: list unsigned int = ax+6 (used reg = )
add	ax,*6
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1846   type=*((Bit8u *)(&((ebda_data_t *) 0)->ata.devices[device].type));
! Debug: ptradd unsigned short device = [S+$E+2] to [8] struct  = const $142 (used reg = )
mov	ax,4[bp]
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned char = [bx+$142] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$142 (used reg = )
! Debug: eq unsigned char = [bx+$142] to unsigned char type = [S+$E-$B] (used reg = )
mov	al,$142[bx]
mov	-9[bp],al
!BCC_EOS
! 1847   if (type != 0x00) {
! Debug: ne int = const 0 to unsigned char type = [S+$E-$B] (used reg = )
mov	al,-9[bp]
test	al,al
beq 	.256
.257:
! 1848     outb(iobase1+6, slave?0xb0:0xa0);
mov	al,-6[bp]
test	al,al
je  	.258
.259:
mov	al,#$B0
jmp .25A
.258:
mov	al,#$A0
.25A:
! Debug: list char = al+0 (used reg = )
xor	ah,ah
push	ax
! Debug: add int = const 6 to unsigned short iobase1 = [S+$10-4] (used reg = )
mov	ax,-2[bp]
! Debug: list unsigned int = ax+6 (used reg = )
add	ax,*6
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1849     sc = inb(iobase1+2);
! Debug: add int = const 2 to unsigned short iobase1 = [S+$E-4] (used reg = )
mov	ax,-2[bp]
! Debug: list unsigned int = ax+2 (used reg = )
inc	ax
inc	ax
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char sc = [S+$E-$A] (used reg = )
mov	-8[bp],al
!BCC_EOS
! 1850     sn = inb(iobase1+3);
! Debug: add int = const 3 to unsigned short iobase1 = [S+$E-4] (used reg = )
mov	ax,-2[bp]
! Debug: list unsigned int = ax+3 (used reg = )
add	ax,*3
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char sn = [S+$E-9] (used reg = )
mov	-7[bp],al
!BCC_EOS
! 1851     if ( (sc==0x01) && (sn==0x01) ) {
! Debug: logeq int = const 1 to unsigned char sc = [S+$E-$A] (used reg = )
mov	al,-8[bp]
cmp	al,*1
jne 	.25B
.25D:
! Debug: logeq int = const 1 to unsigned char sn = [S+$E-9] (used reg = )
mov	al,-7[bp]
cmp	al,*1
jne 	.25B
.25C:
! 1852       if (type == 0x02)
! Debug: logeq int = const 2 to unsigned char type = [S+$E-$B] (used reg = )
mov	al,-9[bp]
cmp	al,*2
jne 	.25E
.25F:
! 1853         await_ide(5, iobase1, 32000u);
! Debug: list unsigned int = const $7D00 (used reg = )
mov	ax,#$7D00
push	ax
! Debug: list unsigned short iobase1 = [S+$10-4] (used reg = )
push	-2[bp]
! Debug: list int = const 5 (used reg = )
mov	ax,*5
push	ax
! Debug: func () int = await_ide+0 (used reg = )
call	_await_ide
add	sp,*6
!BCC_EOS
! 1854       else
! 1855         await_ide(2, iobase1, 32000u);
jmp .260
.25E:
! Debug: list unsigned int = const $7D00 (used reg = )
mov	ax,#$7D00
push	ax
! Debug: list unsigned short iobase1 = [S+$10-4] (used reg = )
push	-2[bp]
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: func () int = await_ide+0 (used reg = )
call	_await_ide
add	sp,*6
!BCC_EOS
! 1856     }
.260:
! 1857     await_ide(2, iobase1, 32000u);
.25B:
! Debug: list unsigned int = const $7D00 (used reg = )
mov	ax,#$7D00
push	ax
! Debug: list unsigned short iobase1 = [S+$10-4] (used reg = )
push	-2[bp]
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: func () int = await_ide+0 (used reg = )
call	_await_ide
add	sp,*6
!BCC_EOS
! 1858   }
! 1859   outb(iobase2+6, 0x08);
.256:
! Debug: list int = const 8 (used reg = )
mov	ax,*8
push	ax
! Debug: add int = const 6 to unsigned short iobase2 = [S+$10-6] (used reg = )
mov	ax,-4[bp]
! Debug: list unsigned int = ax+6 (used reg = )
add	ax,*6
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1860 }
mov	sp,bp
pop	bp
ret
! 1861 Bit16u ata_cmd_non_data()
! Register BX used in function ata_reset
! 1862 {return 0;}
export	_ata_cmd_non_data
_ata_cmd_non_data:
push	bp
mov	bp,sp
xor	ax,ax
pop	bp
ret
!BCC_EOS
! 1863 Bit16u ata_cmd_data_io(ioflag, device, command, count, cylinder, head, sector, lba_low, lba_high, segment, offset)
! 1864 Bit16u ioflag, device, command, count, cylinder, head, sector, segment, offset;
export	_ata_cmd_data_io
_ata_cmd_data_io:
!BCC_EOS
! 1865 Bit32u lba_low, lba_high;
!BCC_EOS
! 1866 {
! 1867   Bit16u iobase1, iobase2, blksize;
!BCC_EOS
! 1868   Bit8u channel, slave;
!BCC_EOS
! 1869   Bit8u status, current, mode;
!BCC_EOS
! 1870   channel = device / 2;
push	bp
mov	bp,sp
add	sp,*-$C
! Debug: div int = const 2 to unsigned short device = [S+$E+4] (used reg = )
mov	ax,6[bp]
shr	ax,*1
! Debug: eq unsigned int = ax+0 to unsigned char channel = [S+$E-9] (used reg = )
mov	-7[bp],al
!BCC_EOS
! 1871   slave = device % 2;
! Debug: mod int = const 2 to unsigned short device = [S+$E+4] (used reg = )
mov	ax,6[bp]
and	al,*1
! Debug: eq unsigned char = al+0 to unsigned char slave = [S+$E-$A] (used reg = )
mov	-8[bp],al
!BCC_EOS
! 1872   iobase1 = *((Bit16u *)(&((ebda_data_t *) 0)->ata.channels[channel].iobase1));
! Debug: ptradd unsigned char channel = [S+$E-9] to [4] struct  = const $122 (used reg = )
mov	al,-7[bp]
xor	ah,ah
mov	cl,*3
shl	ax,cl
mov	bx,ax
! Debug: address unsigned short = [bx+$124] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$124 (used reg = )
! Debug: eq unsigned short = [bx+$124] to unsigned short iobase1 = [S+$E-4] (used reg = )
mov	bx,$124[bx]
mov	-2[bp],bx
!BCC_EOS
! 1873   iobase2 = *((Bit16u *)(&((ebda_data_t *) 0)->ata.channels[channel].iobase2));
! Debug: ptradd unsigned char channel = [S+$E-9] to [4] struct  = const $122 (used reg = )
mov	al,-7[bp]
xor	ah,ah
mov	cl,*3
shl	ax,cl
mov	bx,ax
! Debug: address unsigned short = [bx+$126] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$126 (used reg = )
! Debug: eq unsigned short = [bx+$126] to unsigned short iobase2 = [S+$E-6] (used reg = )
mov	bx,$126[bx]
mov	-4[bp],bx
!BCC_EOS
! 1874   mode = *((Bit8u *)(&((ebda_data_t *) 0)->ata.devices[device].mode));
! Debug: ptradd unsigned short device = [S+$E+4] to [8] struct  = const $142 (used reg = )
mov	ax,6[bp]
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned char = [bx+$146] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$146 (used reg = )
! Debug: eq unsigned char = [bx+$146] to unsigned char mode = [S+$E-$D] (used reg = )
mov	al,$146[bx]
mov	-$B[bp],al
!BCC_EOS
! 1875   if ((command == 0xEC) ||
! 1876       (command == 0xA1)) {
! Debug: logeq int = const $EC to unsigned short command = [S+$E+6] (used reg = )
mov	ax,8[bp]
cmp	ax,#$EC
je  	.262
.263:
! Debug: logeq int = const $A1 to unsigned short command = [S+$E+6] (used reg = )
mov	ax,8[bp]
cmp	ax,#$A1
jne 	.261
.262:
! 1877     blksize = 0x200;
! Debug: eq int = const $200 to unsigned short blksize = [S+$E-8] (used reg = )
mov	ax,#$200
mov	-6[bp],ax
!BCC_EOS
! 1878   } else {
jmp .264
.261:
! 1879     blksize = *((Bit16u *)(&((ebda_data_t *) 0)->ata.devices[device].blksize));
! Debug: ptradd unsigned short device = [S+$E+4] to [8] struct  = const $142 (used reg = )
mov	ax,6[bp]
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned short = [bx+$148] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$148 (used reg = )
! Debug: eq unsigned short = [bx+$148] to unsigned short blksize = [S+$E-8] (used reg = )
mov	bx,$148[bx]
mov	-6[bp],bx
!BCC_EOS
! 1880   }
! 1881   if (mode == 0x01) blksize>>=2;
.264:
! Debug: logeq int = const 1 to unsigned char mode = [S+$E-$D] (used reg = )
mov	al,-$B[bp]
cmp	al,*1
jne 	.265
.266:
! Debug: srab int = const 2 to unsigned short blksize = [S+$E-8] (used reg = )
mov	ax,-6[bp]
shr	ax,*1
shr	ax,*1
mov	-6[bp],ax
!BCC_EOS
! 1882   else blksize>>=1;
jmp .267
.265:
! Debug: srab int = const 1 to unsigned short blksize = [S+$E-8] (used reg = )
mov	ax,-6[bp]
shr	ax,*1
mov	-6[bp],ax
!BCC_EOS
! 1883   *((Bit16u *)(&((ebda_data_t *) 0)->ata.trsfsectors)) = (0);
.267:
! Debug: eq int = const 0 to unsigned short = [+$254] (used reg = )
xor	ax,ax
mov	[$254],ax
!BCC_EOS
! 1884   *((Bit32u *)(&((ebda_data_t *) 0)->ata.trsfbytes)) = (0L);
! Debug: eq long = const 0 to unsigned long = [+$256] (used reg = )
xor	ax,ax
xor	bx,bx
mov	[$256],ax
mov	[$258],bx
!BCC_EOS
! 1885   current = 0;
! Debug: eq int = const 0 to unsigned char current = [S+$E-$C] (used reg = )
xor	al,al
mov	-$A[bp],al
!BCC_EOS
! 1886   status = inb(iobase1 + 7);
! Debug: add int = const 7 to unsigned short iobase1 = [S+$E-4] (used reg = )
mov	ax,-2[bp]
! Debug: list unsigned int = ax+7 (used reg = )
add	ax,*7
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char status = [S+$E-$B] (used reg = )
mov	-9[bp],al
!BCC_EOS
! 1887   if (status & 0x80) return 1;
! Debug: and int = const $80 to unsigned char status = [S+$E-$B] (used reg = )
mov	al,-9[bp]
and	al,#$80
test	al,al
je  	.268
.269:
mov	ax,*1
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 1888   outb(iobase2 + 6, 0x08 | 0x02);
.268:
! Debug: list int = const $A (used reg = )
mov	ax,*$A
push	ax
! Debug: add int = const 6 to unsigned short iobase2 = [S+$10-6] (used reg = )
mov	ax,-4[bp]
! Debug: list unsigned int = ax+6 (used reg = )
add	ax,*6
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1889   if (sector == 0) {
! Debug: logeq int = const 0 to unsigned short sector = [S+$E+$E] (used reg = )
mov	ax,$10[bp]
test	ax,ax
bne 	.26A
.26B:
! 1890     if (*(((Bit8u *)&count)+1) >= 1 || lba_high || (lba_low >= ((1UL << 28) - count))) {
! Debug: ge int = const 1 to unsigned char count = [S+$E+9] (used reg = )
mov	al,$B[bp]
cmp	al,*1
jb 	.270
mov	al,*1
jmp	.271
.270:
xor	al,al
.271:
! Debug: cast unsigned long = const 0 to char = al+0 (used reg = )
xor	ah,ah
cwd
mov	bx,dx
call	ltstl
jne 	.26D
.26F:
mov	ax,$16[bp]
mov	bx,$18[bp]
call	ltstl
jne 	.26D
.26E:
! Debug: cast unsigned long = const 0 to unsigned short count = [S+$E+8] (used reg = )
mov	ax,$A[bp]
xor	bx,bx
! Debug: sub unsigned long = bx+0 to unsigned long = const $10000000 (used reg = )
push	bx
push	ax
xor	ax,ax
mov	bx,#$1000
lea	di,-$10[bp]
call	lsubul
add	sp,*4
! Debug: ge unsigned long = bx+0 to unsigned long lba_low = [S+$E+$10] (used reg = )
lea	di,$12[bp]
call	lcmpul
bhi 	.26C
.26D:
! 1891       outb(iobase1 + 1, 0x00);
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: add int = const 1 to unsigned short iobase1 = [S+$10-4] (used reg = )
mov	ax,-2[bp]
! Debug: list unsigned int = ax+1 (used reg = )
inc	ax
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1892       outb(iobase1 + 2, *(((Bit8u *)&count)+1));
! Debug: list unsigned char count = [S+$E+9] (used reg = )
mov	al,$B[bp]
xor	ah,ah
push	ax
! Debug: add int = const 2 to unsigned short iobase1 = [S+$10-4] (used reg = )
mov	ax,-2[bp]
! Debug: list unsigned int = ax+2 (used reg = )
inc	ax
inc	ax
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1893       outb(iobase1 + 3, *(((Bit8u *)&*(((Bit16u *)&lba_low)+1))+1));
! Debug: list unsigned char lba_low = [S+$E+$13] (used reg = )
mov	al,$15[bp]
xor	ah,ah
push	ax
! Debug: add int = const 3 to unsigned short iobase1 = [S+$10-4] (used reg = )
mov	ax,-2[bp]
! Debug: list unsigned int = ax+3 (used reg = )
add	ax,*3
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1894       outb(iobase1 + 4, *((Bit8u *)&lba_high));
! Debug: list unsigned char lba_high = [S+$E+$14] (used reg = )
mov	al,$16[bp]
xor	ah,ah
push	ax
! Debug: add int = const 4 to unsigned short iobase1 = [S+$10-4] (used reg = )
mov	ax,-2[bp]
! Debug: list unsigned int = ax+4 (used reg = )
add	ax,*4
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1895       outb(iobase1 + 5, *(((Bit8u *)&*((Bit16u *)&lba_high))+1));
! Debug: list unsigned char lba_high = [S+$E+$15] (used reg = )
mov	al,$17[bp]
xor	ah,ah
push	ax
! Debug: add int = const 5 to unsigned short iobase1 = [S+$10-4] (used reg = )
mov	ax,-2[bp]
! Debug: list unsigned int = ax+5 (used reg = )
add	ax,*5
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1896       comma
! 1896 nd |= 0x04;
! Debug: orab int = const 4 to unsigned short command = [S+$E+6] (used reg = )
mov	ax,8[bp]
or	al,*4
mov	8[bp],ax
!BCC_EOS
! 1897       count &= (1 << 8) - 1;
! Debug: andab int = const $FF to unsigned short count = [S+$E+8] (used reg = )
mov	al,$A[bp]
xor	ah,ah
mov	$A[bp],ax
!BCC_EOS
! 1898       lba_low &= (1UL << 24) - 1;
! Debug: andab unsigned long = const $FFFFFF to unsigned long lba_low = [S+$E+$10] (used reg = )
mov	ax,#$FFFF
mov	bx,#$FF
push	bx
push	ax
mov	ax,$12[bp]
mov	bx,$14[bp]
lea	di,-$10[bp]
call	landul
mov	$12[bp],ax
mov	$14[bp],bx
add	sp,*4
!BCC_EOS
! 1899     }
! 1900     sector = (Bit16u) *((Bit8u *)&lba_low);
.26C:
! Debug: cast unsigned short = const 0 to unsigned char lba_low = [S+$E+$10] (used reg = )
mov	al,$12[bp]
xor	ah,ah
! Debug: eq unsigned short = ax+0 to unsigned short sector = [S+$E+$E] (used reg = )
mov	$10[bp],ax
!BCC_EOS
! 1901     lba_low >>= 8;
! Debug: srab int = const 8 to unsigned long lba_low = [S+$E+$10] (used reg = )
mov	ax,$12[bp]
mov	bx,$14[bp]
mov	al,ah
mov	ah,bl
mov	bl,bh
sub	bh,bh
mov	$12[bp],ax
mov	$14[bp],bx
!BCC_EOS
! 1902     cylinder = *((Bit16u *)&lba_low);
! Debug: eq unsigned short lba_low = [S+$E+$10] to unsigned short cylinder = [S+$E+$A] (used reg = )
mov	ax,$12[bp]
mov	$C[bp],ax
!BCC_EOS
! 1903     head = (*(((Bit16u *)&lba_low)+1) & 0x000f) | 0x40;
! Debug: and int = const $F to unsigned short lba_low = [S+$E+$12] (used reg = )
mov	al,$14[bp]
and	al,*$F
! Debug: or int = const $40 to unsigned char = al+0 (used reg = )
or	al,*$40
! Debug: eq unsigned char = al+0 to unsigned short head = [S+$E+$C] (used reg = )
xor	ah,ah
mov	$E[bp],ax
!BCC_EOS
! 1904   }
! 1905   outb(iobase1 + 1, 0x00);
.26A:
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: add int = const 1 to unsigned short iobase1 = [S+$10-4] (used reg = )
mov	ax,-2[bp]
! Debug: list unsigned int = ax+1 (used reg = )
inc	ax
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1906   outb(iobase1 + 2, count);
! Debug: list unsigned short count = [S+$E+8] (used reg = )
push	$A[bp]
! Debug: add int = const 2 to unsigned short iobase1 = [S+$10-4] (used reg = )
mov	ax,-2[bp]
! Debug: list unsigned int = ax+2 (used reg = )
inc	ax
inc	ax
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1907   outb(iobase1 + 3, sector);
! Debug: list unsigned short sector = [S+$E+$E] (used reg = )
push	$10[bp]
! Debug: add int = const 3 to unsigned short iobase1 = [S+$10-4] (used reg = )
mov	ax,-2[bp]
! Debug: list unsigned int = ax+3 (used reg = )
add	ax,*3
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1908   outb(iobase1 + 4, *((Bit8u *)&cylinder));
! Debug: list unsigned char cylinder = [S+$E+$A] (used reg = )
mov	al,$C[bp]
xor	ah,ah
push	ax
! Debug: add int = const 4 to unsigned short iobase1 = [S+$10-4] (used reg = )
mov	ax,-2[bp]
! Debug: list unsigned int = ax+4 (used reg = )
add	ax,*4
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1909   outb(iobase1 + 5, *(((Bit8u *)&cylinder)+1));
! Debug: list unsigned char cylinder = [S+$E+$B] (used reg = )
mov	al,$D[bp]
xor	ah,ah
push	ax
! Debug: add int = const 5 to unsigned short iobase1 = [S+$10-4] (used reg = )
mov	ax,-2[bp]
! Debug: list unsigned int = ax+5 (used reg = )
add	ax,*5
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1910   outb(iobase1 + 6, (slave ? 0xb0 : 0xa0) | (Bit8u) head );
mov	al,-8[bp]
test	al,al
je  	.273
.274:
mov	al,#$B0
jmp .275
.273:
mov	al,#$A0
.275:
! Debug: or unsigned char head = [S+$E+$C] to char = al+0 (used reg = )
or	al,$E[bp]
! Debug: list unsigned char = al+0 (used reg = )
xor	ah,ah
push	ax
! Debug: add int = const 6 to unsigned short iobase1 = [S+$10-4] (used reg = )
mov	ax,-2[bp]
! Debug: list unsigned int = ax+6 (used reg = )
add	ax,*6
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1911   outb(iobase1 + 7, command);
! Debug: list unsigned short command = [S+$E+6] (used reg = )
push	8[bp]
! Debug: add int = const 7 to unsigned short iobase1 = [S+$10-4] (used reg = )
mov	ax,-2[bp]
! Debug: list unsigned int = ax+7 (used reg = )
add	ax,*7
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 1912   await_ide(3, iobase1, 32000u);
! Debug: list unsigned int = const $7D00 (used reg = )
mov	ax,#$7D00
push	ax
! Debug: list unsigned short iobase1 = [S+$10-4] (used reg = )
push	-2[bp]
! Debug: list int = const 3 (used reg = )
mov	ax,*3
push	ax
! Debug: func () int = await_ide+0 (used reg = )
call	_await_ide
add	sp,*6
!BCC_EOS
! 1913   status = inb(iobase1 + 7);
! Debug: add int = const 7 to unsigned short iobase1 = [S+$E-4] (used reg = )
mov	ax,-2[bp]
! Debug: list unsigned int = ax+7 (used reg = )
add	ax,*7
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char status = [S+$E-$B] (used reg = )
mov	-9[bp],al
!BCC_EOS
! 1914   if (status & 0x01) {
! Debug: and int = const 1 to unsigned char status = [S+$E-$B] (used reg = )
mov	al,-9[bp]
and	al,*1
test	al,al
je  	.276
.277:
! 1915     ;
!BCC_EOS
! 1916     return 2;
mov	ax,*2
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 1917   } else if ( !(status & 0x08) ) {
jmp .278
.276:
! Debug: and int = const 8 to unsigned char status = [S+$E-$B] (used reg = )
mov	al,-9[bp]
and	al,*8
test	al,al
jne 	.279
.27A:
! 1918     ;
!BCC_EOS
! 1919     return 3;
mov	ax,*3
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 1920   }
! 1921 #asm
.279:
.278:
!BCC_EOS
!BCC_ASM
_ata_cmd_data_io.count	set	$16
.ata_cmd_data_io.count	set	$A
_ata_cmd_data_io.segment	set	$26
.ata_cmd_data_io.segment	set	$1A
_ata_cmd_data_io.iobase1	set	$A
.ata_cmd_data_io.iobase1	set	-2
_ata_cmd_data_io.channel	set	5
.ata_cmd_data_io.channel	set	-7
_ata_cmd_data_io.lba_low	set	$1E
.ata_cmd_data_io.lba_low	set	$12
_ata_cmd_data_io.lba_high	set	$22
.ata_cmd_data_io.lba_high	set	$16
_ata_cmd_data_io.sector	set	$1C
.ata_cmd_data_io.sector	set	$10
_ata_cmd_data_io.blksize	set	6
.ata_cmd_data_io.blksize	set	-6
_ata_cmd_data_io.head	set	$1A
.ata_cmd_data_io.head	set	$E
_ata_cmd_data_io.ioflag	set	$10
.ata_cmd_data_io.ioflag	set	4
_ata_cmd_data_io.cylinder	set	$18
.ata_cmd_data_io.cylinder	set	$C
_ata_cmd_data_io.device	set	$12
.ata_cmd_data_io.device	set	6
_ata_cmd_data_io.status	set	3
.ata_cmd_data_io.status	set	-9
_ata_cmd_data_io.current	set	2
.ata_cmd_data_io.current	set	-$A
_ata_cmd_data_io.command	set	$14
.ata_cmd_data_io.command	set	8
_ata_cmd_data_io.mode	set	1
.ata_cmd_data_io.mode	set	-$B
_ata_cmd_data_io.iobase2	set	8
.ata_cmd_data_io.iobase2	set	-4
_ata_cmd_data_io.offset	set	$28
.ata_cmd_data_io.offset	set	$1C
_ata_cmd_data_io.slave	set	4
.ata_cmd_data_io.slave	set	-8
        sti ;; enable higher priority interrupts
! 1923 endasm
!BCC_ENDASM
!BCC_EOS
! 1924   while (1) {
.27D:
! 1925     if(ioflag == 0)
! Debug: logeq int = const 0 to unsigned short ioflag = [S+$E+2] (used reg = )
mov	ax,4[bp]
test	ax,ax
jne 	.27E
.27F:
! 1926     {
! 1927 #asm
!BCC_EOS
!BCC_ASM
_ata_cmd_data_io.count	set	$16
.ata_cmd_data_io.count	set	$A
_ata_cmd_data_io.segment	set	$26
.ata_cmd_data_io.segment	set	$1A
_ata_cmd_data_io.iobase1	set	$A
.ata_cmd_data_io.iobase1	set	-2
_ata_cmd_data_io.channel	set	5
.ata_cmd_data_io.channel	set	-7
_ata_cmd_data_io.lba_low	set	$1E
.ata_cmd_data_io.lba_low	set	$12
_ata_cmd_data_io.lba_high	set	$22
.ata_cmd_data_io.lba_high	set	$16
_ata_cmd_data_io.sector	set	$1C
.ata_cmd_data_io.sector	set	$10
_ata_cmd_data_io.blksize	set	6
.ata_cmd_data_io.blksize	set	-6
_ata_cmd_data_io.head	set	$1A
.ata_cmd_data_io.head	set	$E
_ata_cmd_data_io.ioflag	set	$10
.ata_cmd_data_io.ioflag	set	4
_ata_cmd_data_io.cylinder	set	$18
.ata_cmd_data_io.cylinder	set	$C
_ata_cmd_data_io.device	set	$12
.ata_cmd_data_io.device	set	6
_ata_cmd_data_io.status	set	3
.ata_cmd_data_io.status	set	-9
_ata_cmd_data_io.current	set	2
.ata_cmd_data_io.current	set	-$A
_ata_cmd_data_io.command	set	$14
.ata_cmd_data_io.command	set	8
_ata_cmd_data_io.mode	set	1
.ata_cmd_data_io.mode	set	-$B
_ata_cmd_data_io.iobase2	set	8
.ata_cmd_data_io.iobase2	set	-4
_ata_cmd_data_io.offset	set	$28
.ata_cmd_data_io.offset	set	$1C
_ata_cmd_data_io.slave	set	4
.ata_cmd_data_io.slave	set	-8
        push bp
        mov bp, sp
        mov di, _ata_cmd_data_io.offset + 2[bp]
        mov ax, _ata_cmd_data_io.segment + 2[bp]
        mov cx, _ata_cmd_data_io.blksize + 2[bp]
        ;; adjust if there will be an overrun. 2K max sector size
        cmp di, #0xf800 ;;
        jbe ata_in_no_adjust
ata_in_adjust:
        sub di, #0x0800 ;; sub 2 kbytes from offset
        add ax, #0x0080 ;; add 2 Kbytes to segment
ata_in_no_adjust:
        mov es, ax ;; segment in es
        mov dx, _ata_cmd_data_io.iobase1 + 2[bp] ;; ATA data read port
        mov ah, _ata_cmd_data_io.mode + 2[bp]
        cmp ah, #0x01
        je ata_in_32
ata_in_16:
        rep
          insw ;; CX words transferred from port(DX) to ES:[DI]
        jmp ata_in_done
ata_in_32:
        rep
          insd ;; CX dwords transferred from port(DX) to ES:[DI]
ata_in_done:
        mov _ata_cmd_data_io.offset + 2[bp], di
        mov _ata_cmd_data_io.segment + 2[bp], es
        pop bp
! 1956 endasm
!BCC_ENDASM
!BCC_EOS
! 1957     }
! 1958     else
! 1959     {
jmp .280
.27E:
! 1960 #asm
!BCC_EOS
!BCC_ASM
_ata_cmd_data_io.count	set	$16
.ata_cmd_data_io.count	set	$A
_ata_cmd_data_io.segment	set	$26
.ata_cmd_data_io.segment	set	$1A
_ata_cmd_data_io.iobase1	set	$A
.ata_cmd_data_io.iobase1	set	-2
_ata_cmd_data_io.channel	set	5
.ata_cmd_data_io.channel	set	-7
_ata_cmd_data_io.lba_low	set	$1E
.ata_cmd_data_io.lba_low	set	$12
_ata_cmd_data_io.lba_high	set	$22
.ata_cmd_data_io.lba_high	set	$16
_ata_cmd_data_io.sector	set	$1C
.ata_cmd_data_io.sector	set	$10
_ata_cmd_data_io.blksize	set	6
.ata_cmd_data_io.blksize	set	-6
_ata_cmd_data_io.head	set	$1A
.ata_cmd_data_io.head	set	$E
_ata_cmd_data_io.ioflag	set	$10
.ata_cmd_data_io.ioflag	set	4
_ata_cmd_data_io.cylinder	set	$18
.ata_cmd_data_io.cylinder	set	$C
_ata_cmd_data_io.device	set	$12
.ata_cmd_data_io.device	set	6
_ata_cmd_data_io.status	set	3
.ata_cmd_data_io.status	set	-9
_ata_cmd_data_io.current	set	2
.ata_cmd_data_io.current	set	-$A
_ata_cmd_data_io.command	set	$14
.ata_cmd_data_io.command	set	8
_ata_cmd_data_io.mode	set	1
.ata_cmd_data_io.mode	set	-$B
_ata_cmd_data_io.iobase2	set	8
.ata_cmd_data_io.iobase2	set	-4
_ata_cmd_data_io.offset	set	$28
.ata_cmd_data_io.offset	set	$1C
_ata_cmd_data_io.slave	set	4
.ata_cmd_data_io.slave	set	-8
        push bp
        mov bp, sp
        mov si, _ata_cmd_data_io.offset + 2[bp]
        mov ax, _ata_cmd_data_io.segment + 2[bp]
        mov cx, _ata_cmd_data_io.blksize + 2[bp]
        ;; adjust if there will be an overrun. 2K max sector size
        cmp si, #0xf800 ;;
        jbe ata_out_no_adjust
ata_out_adjust:
        sub si, #0x0800 ;; sub 2 kbytes from offset
        add ax, #0x0080 ;; add 2 Kbytes to segment
ata_out_no_adjust:
        mov es, ax ;; segment in es
        mov dx, _ata_cmd_data_io.iobase1 + 2[bp] ;; ATA data write port
        mov ah, _ata_cmd_data_io.mode + 2[bp]
        cmp ah, #0x01
        je ata_out_32
ata_out_16:
        seg ES
        rep
          outsw ;; CX words transferred from port(DX) to ES:[SI]
        jmp ata_out_done
ata_out_32:
        seg ES
        rep
          outsd ;; CX dwords transferred from port(DX) to ES:[SI]
ata_out_done:
        mov _ata_cmd_data_io.offset + 2[bp], si
        mov _ata_cmd_data_io.segment + 2[bp], es
        pop bp
! 1991 endasm
!BCC_ENDASM
!BCC_EOS
! 1992     }
! 1993     current++;
.280:
! Debug: postinc unsigned char current = [S+$E-$C] (used reg = )
mov	al,-$A[bp]
inc	ax
mov	-$A[bp],al
!BCC_EOS
! 1994     *((Bit16u *)(&((ebda_data_t *) 0)->ata.trsfsectors)) = (current);
! Debug: eq unsigned char current = [S+$E-$C] to unsigned short = [+$254] (used reg = )
mov	al,-$A[bp]
xor	ah,ah
mov	[$254],ax
!BCC_EOS
! 1995     count--;
! Debug: postdec unsigned short count = [S+$E+8] (used reg = )
mov	ax,$A[bp]
dec	ax
mov	$A[bp],ax
!BCC_EOS
! 1996     if(ioflag == 0) await_ide(2, iobase1, 32000u);
! Debug: logeq int = const 0 to unsigned short ioflag = [S+$E+2] (used reg = )
mov	ax,4[bp]
test	ax,ax
jne 	.281
.282:
! Debug: list unsigned int = const $7D00 (used reg = )
mov	ax,#$7D00
push	ax
! Debug: list unsigned short iobase1 = [S+$10-4] (used reg = )
push	-2[bp]
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: func () int = await_ide+0 (used reg = )
call	_await_ide
add	sp,*6
!BCC_EOS
! 1997     status = inb(iobase1 + 7);
.281:
! Debug: add int = const 7 to unsigned short iobase1 = [S+$E-4] (used reg = )
mov	ax,-2[bp]
! Debug: list unsigned int = ax+7 (used reg = )
add	ax,*7
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char status = [S+$E-$B] (used reg = )
mov	-9[bp],al
!BCC_EOS
! 1998     if(ioflag == 0)
! Debug: logeq int = const 0 to unsigned short ioflag = [S+$E+2] (used reg = )
mov	ax,4[bp]
test	ax,ax
jne 	.283
.284:
! 1999     {
! 2000       if (count == 0) {
! Debug: logeq int = const 0 to unsigned short count = [S+$E+8] (used reg = )
mov	ax,$A[bp]
test	ax,ax
jne 	.285
.286:
! 2001         if ( (status & (0x80 | 0x40 | 0x08 | 0x01) )
! 2002             != 0x40 ) {
! Debug: and int = const $C9 to unsigned char status = [S+$E-$B] (used reg = )
mov	al,-9[bp]
and	al,#$C9
! Debug: ne int = const $40 to unsigned char = al+0 (used reg = )
cmp	al,*$40
je  	.287
.288:
! 2003           ;
!BCC_EOS
! 2004           return 4;
mov	ax,*4
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2005         }
! 2006         break;
.287:
jmp .27B
!BCC_EOS
! 2007       }
! 2008       else {
jmp .289
.285:
! 2009         if ( (status & (0x80 | 0x40 | 0x08 | 0x01) )
! 2010             != (0x40 | 0x08) ) {
! Debug: and int = const $C9 to unsigned char status = [S+$E-$B] (used reg = )
mov	al,-9[bp]
and	al,#$C9
! Debug: ne int = const $48 to unsigned char = al+0 (used reg = )
cmp	al,*$48
je  	.28A
.28B:
! 2011           ;
!BCC_EOS
! 2012           return 5;
mov	ax,*5
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2013         }
! 2014         continue;
.28A:
jmp .27C
!BCC_EOS
! 2015       }
! 2016     }
.289:
! 2017     else
! 2018     {
jmp .28C
.283:
! 2019       if (count == 0) {
! Debug: logeq int = const 0 to unsigned short count = [S+$E+8] (used reg = )
mov	ax,$A[bp]
test	ax,ax
jne 	.28D
.28E:
! 2020         if ( (status & (0x80 | 0x40 | 0x20 | 0x08 | 0x01) )
! 2021             != 0x40 ) {
! Debug: and int = const $E9 to unsigned char status = [S+$E-$B] (used reg = )
mov	al,-9[bp]
and	al,#$E9
! Debug: ne int = const $40 to unsigned char = al+0 (used reg = )
cmp	al,*$40
je  	.28F
.290:
! 2022           ;
!BCC_EOS
! 2023           return 6;
mov	ax,*6
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2024         }
! 2025         break;
.28F:
jmp .27B
!BCC_EOS
! 2026       }
! 2027       else {
jmp .291
.28D:
! 2028         if ( (status & (0x80 | 0x40 | 0x08 | 0x01) )
! 2029             != (0x40 | 0x08) ) {
! Debug: and int = const $C9 to unsigned char status = [S+$E-$B] (used reg = )
mov	al,-9[bp]
and	al,#$C9
! Debug: ne int = const $48 to unsigned char = al+0 (used reg = )
cmp	al,*$48
je  	.292
.293:
! 2030           ;
!BCC_EOS
! 2031           return 7;
mov	ax,*7
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2032         }
! 2033         continue;
.292:
jmp .27C
!BCC_EOS
! 2034       }
! 2035     }
.291:
! 2036   }
.28C:
! 2037   outb(iobase2+6, 0x08);
.27C:
br 	.27D
.294:
.27B:
! Debug: list int = const 8 (used reg = )
mov	ax,*8
push	ax
! Debug: add int = const 6 to unsigned short iobase2 = [S+$10-6] (used reg = )
mov	ax,-4[bp]
! Debug: list unsigned int = ax+6 (used reg = )
add	ax,*6
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 2038   return 0;
xor	ax,ax
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2039 }
! 2040 Bit16u ata_cmd_packet(device, cmdlen, cmdseg, cmdoff, header, length, inout, bufseg, bufoff)
! Register BX used in function ata_cmd_data_io
! 2041 Bit8u cmdlen,inout;
export	_ata_cmd_packet
_ata_cmd_packet:
!BCC_EOS
! 2042 Bit16u device,cmdseg, cmdoff, bufseg, bufoff;
!BCC_EOS
! 2043 Bit16u header;
!BCC_EOS
! 2044 Bit32u length;
!BCC_EOS
! 2045 {
! 2046   Bit16u ebda_seg=get_ebda_seg(), old_ds;
push	bp
mov	bp,sp
dec	sp
dec	sp
! Debug: func () unsigned short = get_ebda_seg+0 (used reg = )
call	_get_ebda_seg
! Debug: eq unsigned short = ax+0 to unsigned short ebda_seg = [S+4-4] (used reg = )
mov	-2[bp],ax
!BCC_EOS
! 2047   Bit16u iobase1, iobase2;
!BCC_EOS
! 2048   Bit16u lcount, lbefore, lafter, count;
!BCC_EOS
! 2049   Bit8u channel, slave;
!BCC_EOS
! 2050   Bit8u status, mode, lmode;
!BCC_EOS
! 2051   Bit32
! 2051 u total, transfer;
!BCC_EOS
! 2052   channel = device / 2;
add	sp,*-$1C
! Debug: div int = const 2 to unsigned short device = [S+$20+2] (used reg = )
mov	ax,4[bp]
shr	ax,*1
! Debug: eq unsigned int = ax+0 to unsigned char channel = [S+$20-$13] (used reg = )
mov	-$11[bp],al
!BCC_EOS
! 2053   slave = device % 2;
! Debug: mod int = const 2 to unsigned short device = [S+$20+2] (used reg = )
mov	ax,4[bp]
and	al,*1
! Debug: eq unsigned char = al+0 to unsigned char slave = [S+$20-$14] (used reg = )
mov	-$12[bp],al
!BCC_EOS
! 2054   if (inout == 0x02) {
! Debug: logeq int = const 2 to unsigned char inout = [S+$20+$10] (used reg = )
mov	al,$12[bp]
cmp	al,*2
jne 	.295
.296:
! 2055     bios_printf(4, "ata_cmd_packet: DATA_OUT not supported yet\n");
! Debug: list * char = .297+0 (used reg = )
mov	bx,#.297
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*4
!BCC_EOS
! 2056     return 1;
mov	ax,*1
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2057   }
! 2058   if (header & 1) {
.295:
! Debug: and int = const 1 to unsigned short header = [S+$20+$A] (used reg = )
mov	al,$C[bp]
and	al,*1
test	al,al
je  	.298
.299:
! 2059     ;
!BCC_EOS
! 2060     return 1;
mov	ax,*1
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2061   }
! 2062   old_ds = set_DS(ebda_seg);
.298:
! Debug: list unsigned short ebda_seg = [S+$20-4] (used reg = )
push	-2[bp]
! Debug: func () unsigned short = set_DS+0 (used reg = )
call	_set_DS
inc	sp
inc	sp
! Debug: eq unsigned short = ax+0 to unsigned short old_ds = [S+$20-6] (used reg = )
mov	-4[bp],ax
!BCC_EOS
! 2063   iobase1 = *((Bit16u *)(&((ebda_data_t *) 0)->ata.channels[channel].iobase1));
! Debug: ptradd unsigned char channel = [S+$20-$13] to [4] struct  = const $122 (used reg = )
mov	al,-$11[bp]
xor	ah,ah
mov	cl,*3
shl	ax,cl
mov	bx,ax
! Debug: address unsigned short = [bx+$124] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$124 (used reg = )
! Debug: eq unsigned short = [bx+$124] to unsigned short iobase1 = [S+$20-8] (used reg = )
mov	bx,$124[bx]
mov	-6[bp],bx
!BCC_EOS
! 2064   iobase2 = *((Bit16u *)(&((ebda_data_t *) 0)->ata.channels[channel].iobase2));
! Debug: ptradd unsigned char channel = [S+$20-$13] to [4] struct  = const $122 (used reg = )
mov	al,-$11[bp]
xor	ah,ah
mov	cl,*3
shl	ax,cl
mov	bx,ax
! Debug: address unsigned short = [bx+$126] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$126 (used reg = )
! Debug: eq unsigned short = [bx+$126] to unsigned short iobase2 = [S+$20-$A] (used reg = )
mov	bx,$126[bx]
mov	-8[bp],bx
!BCC_EOS
! 2065   mode = *((Bit8u *)(&((ebda_data_t *) 0)->ata.devices[device].mode));
! Debug: ptradd unsigned short device = [S+$20+2] to [8] struct  = const $142 (used reg = )
mov	ax,4[bp]
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned char = [bx+$146] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$146 (used reg = )
! Debug: eq unsigned char = [bx+$146] to unsigned char mode = [S+$20-$16] (used reg = )
mov	al,$146[bx]
mov	-$14[bp],al
!BCC_EOS
! 2066   transfer= 0L;
! Debug: eq long = const 0 to unsigned long transfer = [S+$20-$20] (used reg = )
xor	ax,ax
xor	bx,bx
mov	-$1E[bp],ax
mov	-$1C[bp],bx
!BCC_EOS
! 2067   if (cmdlen < 12) cmdlen=12;
! Debug: lt int = const $C to unsigned char cmdlen = [S+$20+4] (used reg = )
mov	al,6[bp]
cmp	al,*$C
jae 	.29A
.29B:
! Debug: eq int = const $C to unsigned char cmdlen = [S+$20+4] (used reg = )
mov	al,*$C
mov	6[bp],al
!BCC_EOS
! 2068   if (cmdlen > 12) cmdlen=16;
.29A:
! Debug: gt int = const $C to unsigned char cmdlen = [S+$20+4] (used reg = )
mov	al,6[bp]
cmp	al,*$C
jbe 	.29C
.29D:
! Debug: eq int = const $10 to unsigned char cmdlen = [S+$20+4] (used reg = )
mov	al,*$10
mov	6[bp],al
!BCC_EOS
! 2069   cmdlen>>=1;
.29C:
! Debug: srab int = const 1 to unsigned char cmdlen = [S+$20+4] (used reg = )
mov	al,6[bp]
xor	ah,ah
shr	ax,*1
mov	6[bp],al
!BCC_EOS
! 2070   *((Bit16u *)(&((ebda_data_t *) 0)->ata.trsfsectors)) = (0);
! Debug: eq int = const 0 to unsigned short = [+$254] (used reg = )
xor	ax,ax
mov	[$254],ax
!BCC_EOS
! 2071   *((Bit32u *)(&((ebda_data_t *) 0)->ata.trsfbytes)) = (0L);
! Debug: eq long = const 0 to unsigned long = [+$256] (used reg = )
xor	ax,ax
xor	bx,bx
mov	[$256],ax
mov	[$258],bx
!BCC_EOS
! 2072   set_DS(old_ds);
! Debug: list unsigned short old_ds = [S+$20-6] (used reg = )
push	-4[bp]
! Debug: func () unsigned short = set_DS+0 (used reg = )
call	_set_DS
inc	sp
inc	sp
!BCC_EOS
! 2073   status = inb(iobase1 + 7);
! Debug: add int = const 7 to unsigned short iobase1 = [S+$20-8] (used reg = )
mov	ax,-6[bp]
! Debug: list unsigned int = ax+7 (used reg = )
add	ax,*7
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char status = [S+$20-$15] (used reg = )
mov	-$13[bp],al
!BCC_EOS
! 2074   if (status & 0x80) return 2;
! Debug: and int = const $80 to unsigned char status = [S+$20-$15] (used reg = )
mov	al,-$13[bp]
and	al,#$80
test	al,al
je  	.29E
.29F:
mov	ax,*2
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2075   outb(iobase2 + 6, 0x08 | 0x02);
.29E:
! Debug: list int = const $A (used reg = )
mov	ax,*$A
push	ax
! Debug: add int = const 6 to unsigned short iobase2 = [S+$22-$A] (used reg = )
mov	ax,-8[bp]
! Debug: list unsigned int = ax+6 (used reg = )
add	ax,*6
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 2076   outb(iobase1 + 1, 0x00);
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: add int = const 1 to unsigned short iobase1 = [S+$22-8] (used reg = )
mov	ax,-6[bp]
! Debug: list unsigned int = ax+1 (used reg = )
inc	ax
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 2077   outb(iobase1 + 2, 0x00);
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: add int = const 2 to unsigned short iobase1 = [S+$22-8] (used reg = )
mov	ax,-6[bp]
! Debug: list unsigned int = ax+2 (used reg = )
inc	ax
inc	ax
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 2078   outb(iobase1 + 3, 0x00);
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: add int = const 3 to unsigned short iobase1 = [S+$22-8] (used reg = )
mov	ax,-6[bp]
! Debug: list unsigned int = ax+3 (used reg = )
add	ax,*3
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 2079   outb(iobase1 + 4, 0xfff0 & 0x00ff);
! Debug: list unsigned int = const $F0 (used reg = )
mov	ax,#$F0
push	ax
! Debug: add int = const 4 to unsigned short iobase1 = [S+$22-8] (used reg = )
mov	ax,-6[bp]
! Debug: list unsigned int = ax+4 (used reg = )
add	ax,*4
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 2080   outb(iobase1 + 5, 0xfff0 >> 8);
! Debug: list unsigned int = const $FF (used reg = )
mov	ax,#$FF
push	ax
! Debug: add int = const 5 to unsigned short iobase1 = [S+$22-8] (used reg = )
mov	ax,-6[bp]
! Debug: list unsigned int = ax+5 (used reg = )
add	ax,*5
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 2081   outb(iobase1 + 6, slave ? 0xb0 : 0xa0);
mov	al,-$12[bp]
test	al,al
je  	.2A0
.2A1:
mov	al,#$B0
jmp .2A2
.2A0:
mov	al,#$A0
.2A2:
! Debug: list char = al+0 (used reg = )
xor	ah,ah
push	ax
! Debug: add int = const 6 to unsigned short iobase1 = [S+$22-8] (used reg = )
mov	ax,-6[bp]
! Debug: list unsigned int = ax+6 (used reg = )
add	ax,*6
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 2082   outb(iobase1 + 7, 0xA0);
! Debug: list int = const $A0 (used reg = )
mov	ax,#$A0
push	ax
! Debug: add int = const 7 to unsigned short iobase1 = [S+$22-8] (used reg = )
mov	ax,-6[bp]
! Debug: list unsigned int = ax+7 (used reg = )
add	ax,*7
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 2083   await_ide(3, iobase1, 32000u);
! Debug: list unsigned int = const $7D00 (used reg = )
mov	ax,#$7D00
push	ax
! Debug: list unsigned short iobase1 = [S+$22-8] (used reg = )
push	-6[bp]
! Debug: list int = const 3 (used reg = )
mov	ax,*3
push	ax
! Debug: func () int = await_ide+0 (used reg = )
call	_await_ide
add	sp,*6
!BCC_EOS
! 2084   status = inb(iobase1 + 7);
! Debug: add int = const 7 to unsigned short iobase1 = [S+$20-8] (used reg = )
mov	ax,-6[bp]
! Debug: list unsigned int = ax+7 (used reg = )
add	ax,*7
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char status = [S+$20-$15] (used reg = )
mov	-$13[bp],al
!BCC_EOS
! 2085   if (status & 0x01) {
! Debug: and int = const 1 to unsigned char status = [S+$20-$15] (used reg = )
mov	al,-$13[bp]
and	al,*1
test	al,al
je  	.2A3
.2A4:
! 2086     ;
!BCC_EOS
! 2087     return 3;
mov	ax,*3
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2088   } else if ( !(status & 0x08) ) {
jmp .2A5
.2A3:
! Debug: and int = const 8 to unsigned char status = [S+$20-$15] (used reg = )
mov	al,-$13[bp]
and	al,*8
test	al,al
jne 	.2A6
.2A7:
! 2089     ;
!BCC_EOS
! 2090     return 4;
mov	ax,*4
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2091   }
! 2092   cmdseg += (cmdoff / 16);
.2A6:
.2A5:
! Debug: div int = const $10 to unsigned short cmdoff = [S+$20+8] (used reg = )
mov	ax,$A[bp]
mov	cl,*4
shr	ax,cl
! Debug: addab unsigned int = ax+0 to unsigned short cmdseg = [S+$20+6] (used reg = )
add	ax,8[bp]
mov	8[bp],ax
!BCC_EOS
! 2093   cmdoff %= 16;
! Debug: modab int = const $10 to unsigned short cmdoff = [S+$20+8] (used reg = )
mov	ax,$A[bp]
and	al,*$F
xor	ah,ah
mov	$A[bp],ax
!BCC_EOS
! 2094 #asm
!BCC_EOS
!BCC_ASM
_ata_cmd_packet.cmdoff	set	$28
.ata_cmd_packet.cmdoff	set	$A
_ata_cmd_packet.header	set	$2A
.ata_cmd_packet.header	set	$C
_ata_cmd_packet.count	set	$E
.ata_cmd_packet.count	set	-$10
_ata_cmd_packet.lafter	set	$10
.ata_cmd_packet.lafter	set	-$E
_ata_cmd_packet.iobase1	set	$18
.ata_cmd_packet.iobase1	set	-6
_ata_cmd_packet.channel	set	$D
.ata_cmd_packet.channel	set	-$11
_ata_cmd_packet.cmdseg	set	$26
.ata_cmd_packet.cmdseg	set	8
_ata_cmd_packet.cmdlen	set	$24
.ata_cmd_packet.cmdlen	set	6
_ata_cmd_packet.lmode	set	9
.ata_cmd_packet.lmode	set	-$15
_ata_cmd_packet.device	set	$22
.ata_cmd_packet.device	set	4
_ata_cmd_packet.ebda_seg	set	$1C
.ata_cmd_packet.ebda_seg	set	-2
_ata_cmd_packet.lcount	set	$14
.ata_cmd_packet.lcount	set	-$A
_ata_cmd_packet.total	set	4
.ata_cmd_packet.total	set	-$1A
_ata_cmd_packet.status	set	$B
.ata_cmd_packet.status	set	-$13
_ata_cmd_packet.mode	set	$A
.ata_cmd_packet.mode	set	-$14
_ata_cmd_packet.bufoff	set	$34
.ata_cmd_packet.bufoff	set	$16
_ata_cmd_packet.transfer	set	0
.ata_cmd_packet.transfer	set	-$1E
_ata_cmd_packet.iobase2	set	$16
.ata_cmd_packet.iobase2	set	-8
_ata_cmd_packet.lbefore	set	$12
.ata_cmd_packet.lbefore	set	-$C
_ata_cmd_packet.bufseg	set	$32
.ata_cmd_packet.bufseg	set	$14
_ata_cmd_packet.slave	set	$C
.ata_cmd_packet.slave	set	-$12
_ata_cmd_packet.inout	set	$30
.ata_cmd_packet.inout	set	$12
_ata_cmd_packet.old_ds	set	$1A
.ata_cmd_packet.old_ds	set	-4
_ata_cmd_packet.length	set	$2C
.ata_cmd_packet.length	set	$E
      sti ;; enable higher priority interrupts
      push bp
      mov bp, sp
      mov si, _ata_cmd_packet.cmdoff + 2[bp]
      mov ax, _ata_cmd_packet.cmdseg + 2[bp]
      mov cx, _ata_cmd_packet.cmdlen + 2[bp]
      mov es, ax ;; segment in es
      mov dx, _ata_cmd_packet.iobase1 + 2[bp] ;; ATA data write port
      seg ES
      rep
        outsw ;; CX words transferred from port(DX) to ES:[SI]
      pop bp
! 2107 endasm
!BCC_ENDASM
!BCC_EOS
! 2108   if (inout == 0x00) {
! Debug: logeq int = const 0 to unsigned char inout = [S+$20+$10] (used reg = )
mov	al,$12[bp]
test	al,al
jne 	.2A8
.2A9:
! 2109     await_ide(2, iobase1, 32000u);
! Debug: list unsigned int = const $7D00 (used reg = )
mov	ax,#$7D00
push	ax
! Debug: list unsigned short iobase1 = [S+$22-8] (used reg = )
push	-6[bp]
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: func () int = await_ide+0 (used reg = )
call	_await_ide
add	sp,*6
!BCC_EOS
! 2110     status = inb(iobase1 + 7);
! Debug: add int = const 7 to unsigned short iobase1 = [S+$20-8] (used reg = )
mov	ax,-6[bp]
! Debug: list unsigned int = ax+7 (used reg = )
add	ax,*7
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char status = [S+$20-$15] (used reg = )
mov	-$13[bp],al
!BCC_EOS
! 2111   }
! 2112   else {
br 	.2AA
.2A8:
! 2113     Bit16u loops = 0;
dec	sp
dec	sp
! Debug: eq int = const 0 to unsigned short loops = [S+$22-$22] (used reg = )
xor	ax,ax
mov	-$20[bp],ax
!BCC_EOS
! 2114     Bit8u sc;
!BCC_EOS
! 2115     while (1) {
dec	sp
dec	sp
.2AD:
! 2116       if (loops == 0) {
! Debug: logeq int = const 0 to unsigned short loops = [S+$24-$22] (used reg = )
mov	ax,-$20[bp]
test	ax,ax
jne 	.2AE
.2AF:
! 2117         status = inb(iobase2 + 6);
! Debug: add int = const 6 to unsigned short iobase2 = [S+$24-$A] (used reg = )
mov	ax,-8[bp]
! Debug: list unsigned int = ax+6 (used reg = )
add	ax,*6
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char status = [S+$24-$15] (used reg = )
mov	-$13[bp],al
!BCC_EOS
! 2118         await_ide(3, iobase1, 32000u);
! Debug: list unsigned int = const $7D00 (used reg = )
mov	ax,#$7D00
push	ax
! Debug: list unsigned short iobase1 = [S+$26-8] (used reg = )
push	-6[bp]
! Debug: list int = const 3 (used reg = )
mov	ax,*3
push	ax
! Debug: func () int = await_ide+0 (used reg = )
call	_await_ide
add	sp,*6
!BCC_EOS
! 2119       }
! 2120       else
! 2121         await_ide(2, iobase1, 32000u);
jmp .2B0
.2AE:
! Debug: list unsigned int = const $7D00 (used reg = )
mov	ax,#$7D00
push	ax
! Debug: list unsigned short iobase1 = [S+$26-8] (used reg = )
push	-6[bp]
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: func () int = await_ide+0 (used reg = )
call	_await_ide
add	sp,*6
!BCC_EOS
! 2122       loops++;
.2B0:
! Debug: postinc unsigned short loops = [S+$24-$22] (used reg = )
mov	ax,-$20[bp]
inc	ax
mov	-$20[bp],ax
!BCC_EOS
! 2123       status = inb(iobase1 + 7);
! Debug: add int = const 7 to unsigned short iobase1 = [S+$24-8] (used reg = )
mov	ax,-6[bp]
! Debug: list unsigned int = ax+7 (used reg = )
add	ax,*7
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char status = [S+$24-$15] (used reg = )
mov	-$13[bp],al
!BCC_EOS
! 2124       sc = inb(iobase1 + 2);
! Debug: add int = const 2 to unsigned short iobase1 = [S+$24-8] (used reg = )
mov	ax,-6[bp]
! Debug: list unsigned int = ax+2 (used reg = )
inc	ax
inc	ax
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char sc = [S+$24-$23] (used reg = )
mov	-$21[bp],al
!BCC_EOS
! 2125  
! 2125      if(((inb(iobase1 + 2)&0x7)==0x3) &&
! 2126          ((status & (0x40 | 0x01)) == 0x40)) break;
! Debug: add int = const 2 to unsigned short iobase1 = [S+$24-8] (used reg = )
mov	ax,-6[bp]
! Debug: list unsigned int = ax+2 (used reg = )
inc	ax
inc	ax
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: and int = const 7 to unsigned char = al+0 (used reg = )
and	al,*7
! Debug: logeq int = const 3 to unsigned char = al+0 (used reg = )
cmp	al,*3
jne 	.2B1
.2B3:
! Debug: and int = const $41 to unsigned char status = [S+$24-$15] (used reg = )
mov	al,-$13[bp]
and	al,*$41
! Debug: logeq int = const $40 to unsigned char = al+0 (used reg = )
cmp	al,*$40
jne 	.2B1
.2B2:
br 	.2AB
!BCC_EOS
! 2127       if (status & 0x01) {
.2B1:
! Debug: and int = const 1 to unsigned char status = [S+$24-$15] (used reg = )
mov	al,-$13[bp]
and	al,*1
test	al,al
je  	.2B4
.2B5:
! 2128         ;
!BCC_EOS
! 2129         return 3;
mov	ax,*3
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2130       }
! 2131       bufseg += (bufoff / 16);
.2B4:
! Debug: div int = const $10 to unsigned short bufoff = [S+$24+$14] (used reg = )
mov	ax,$16[bp]
mov	cl,*4
shr	ax,cl
! Debug: addab unsigned int = ax+0 to unsigned short bufseg = [S+$24+$12] (used reg = )
add	ax,$14[bp]
mov	$14[bp],ax
!BCC_EOS
! 2132       bufoff %= 16;
! Debug: modab int = const $10 to unsigned short bufoff = [S+$24+$14] (used reg = )
mov	ax,$16[bp]
and	al,*$F
xor	ah,ah
mov	$16[bp],ax
!BCC_EOS
! 2133       *((Bit8u *)&lcount) = inb(iobase1 + 4);
! Debug: add int = const 4 to unsigned short iobase1 = [S+$24-8] (used reg = )
mov	ax,-6[bp]
! Debug: list unsigned int = ax+4 (used reg = )
add	ax,*4
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char lcount = [S+$24-$C] (used reg = )
mov	-$A[bp],al
!BCC_EOS
! 2134       *(((Bit8u *)&lcount)+1) = inb(iobase1 + 5);
! Debug: add int = const 5 to unsigned short iobase1 = [S+$24-8] (used reg = )
mov	ax,-6[bp]
! Debug: list unsigned int = ax+5 (used reg = )
add	ax,*5
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char lcount = [S+$24-$B] (used reg = )
mov	-9[bp],al
!BCC_EOS
! 2135       if(header>lcount) {
! Debug: gt unsigned short lcount = [S+$24-$C] to unsigned short header = [S+$24+$A] (used reg = )
mov	ax,$C[bp]
cmp	ax,-$A[bp]
jbe 	.2B6
.2B7:
! 2136          lbefore=lcount;
! Debug: eq unsigned short lcount = [S+$24-$C] to unsigned short lbefore = [S+$24-$E] (used reg = )
mov	ax,-$A[bp]
mov	-$C[bp],ax
!BCC_EOS
! 2137          header-=lcount;
! Debug: subab unsigned short lcount = [S+$24-$C] to unsigned short header = [S+$24+$A] (used reg = )
mov	ax,$C[bp]
sub	ax,-$A[bp]
mov	$C[bp],ax
!BCC_EOS
! 2138          lcount=0;
! Debug: eq int = const 0 to unsigned short lcount = [S+$24-$C] (used reg = )
xor	ax,ax
mov	-$A[bp],ax
!BCC_EOS
! 2139       }
! 2140       else {
jmp .2B8
.2B6:
! 2141         lbefore=header;
! Debug: eq unsigned short header = [S+$24+$A] to unsigned short lbefore = [S+$24-$E] (used reg = )
mov	ax,$C[bp]
mov	-$C[bp],ax
!BCC_EOS
! 2142         header=0;
! Debug: eq int = const 0 to unsigned short header = [S+$24+$A] (used reg = )
xor	ax,ax
mov	$C[bp],ax
!BCC_EOS
! 2143         lcount-=lbefore;
! Debug: subab unsigned short lbefore = [S+$24-$E] to unsigned short lcount = [S+$24-$C] (used reg = )
mov	ax,-$A[bp]
sub	ax,-$C[bp]
mov	-$A[bp],ax
!BCC_EOS
! 2144       }
! 2145       if(lcount>length) {
.2B8:
! Debug: cast unsigned long = const 0 to unsigned short lcount = [S+$24-$C] (used reg = )
mov	ax,-$A[bp]
xor	bx,bx
! Debug: gt unsigned long length = [S+$24+$C] to unsigned long = bx+0 (used reg = )
lea	di,$E[bp]
call	lcmpul
jbe 	.2B9
.2BA:
! 2146         lafter=lcount-length;
! Debug: cast unsigned long = const 0 to unsigned short lcount = [S+$24-$C] (used reg = )
mov	ax,-$A[bp]
xor	bx,bx
! Debug: sub unsigned long length = [S+$24+$C] to unsigned long = bx+0 (used reg = )
lea	di,$E[bp]
call	lsubul
! Debug: eq unsigned long = bx+0 to unsigned short lafter = [S+$24-$10] (used reg = )
mov	-$E[bp],ax
!BCC_EOS
! 2147         lcount=length;
! Debug: eq unsigned long length = [S+$24+$C] to unsigned short lcount = [S+$24-$C] (used reg = )
mov	ax,$E[bp]
mov	-$A[bp],ax
!BCC_EOS
! 2148         length=0;
! Debug: eq int = const 0 to unsigned long length = [S+$24+$C] (used reg = )
xor	ax,ax
xor	bx,bx
mov	$E[bp],ax
mov	$10[bp],bx
!BCC_EOS
! 2149       }
! 2150       else {
jmp .2BB
.2B9:
! 2151         lafter=0;
! Debug: eq int = const 0 to unsigned short lafter = [S+$24-$10] (used reg = )
xor	ax,ax
mov	-$E[bp],ax
!BCC_EOS
! 2152         length-=lcount;
! Debug: cast unsigned long = const 0 to unsigned short lcount = [S+$24-$C] (used reg = )
mov	ax,-$A[bp]
xor	bx,bx
! Debug: subab unsigned long = bx+0 to unsigned long length = [S+$24+$C] (used reg = )
push	bx
push	ax
mov	ax,$E[bp]
mov	bx,$10[bp]
lea	di,-$26[bp]
call	lsubul
mov	$E[bp],ax
mov	$10[bp],bx
add	sp,*4
!BCC_EOS
! 2153       }
! 2154       count = lcount;
.2BB:
! Debug: eq unsigned short lcount = [S+$24-$C] to unsigned short count = [S+$24-$12] (used reg = )
mov	ax,-$A[bp]
mov	-$10[bp],ax
!BCC_EOS
! 2155       ;
!BCC_EOS
! 2156       ;
!BCC_EOS
! 2157       lmode = mode;
! Debug: eq unsigned char mode = [S+$24-$16] to unsigned char lmode = [S+$24-$17] (used reg = )
mov	al,-$14[bp]
mov	-$15[bp],al
!BCC_EOS
! 2158       if (lbefore & 0x03) lmode=0x00;
! Debug: and int = const 3 to unsigned short lbefore = [S+$24-$E] (used reg = )
mov	al,-$C[bp]
and	al,*3
test	al,al
je  	.2BC
.2BD:
! Debug: eq int = const 0 to unsigned char lmode = [S+$24-$17] (used reg = )
xor	al,al
mov	-$15[bp],al
!BCC_EOS
! 2159       if (lcount & 0x03) lmode=0x00;
.2BC:
! Debug: and int = const 3 to unsigned short lcount = [S+$24-$C] (used reg = )
mov	al,-$A[bp]
and	al,*3
test	al,al
je  	.2BE
.2BF:
! Debug: eq int = const 0 to unsigned char lmode = [S+$24-$17] (used reg = )
xor	al,al
mov	-$15[bp],al
!BCC_EOS
! 2160       if (lafter & 0x03) lmode=0x00;
.2BE:
! Debug: and int = const 3 to unsigned short lafter = [S+$24-$10] (used reg = )
mov	al,-$E[bp]
and	al,*3
test	al,al
je  	.2C0
.2C1:
! Debug: eq int = const 0 to unsigned char lmode = [S+$24-$17] (used reg = )
xor	al,al
mov	-$15[bp],al
!BCC_EOS
! 2161       if (lcount & 0x01) {
.2C0:
! Debug: and int = const 1 to unsigned short lcount = [S+$24-$C] (used reg = )
mov	al,-$A[bp]
and	al,*1
test	al,al
je  	.2C2
.2C3:
! 2162         lcount+=1;
! Debug: addab int = const 1 to unsigned short lcount = [S+$24-$C] (used reg = )
mov	ax,-$A[bp]
inc	ax
mov	-$A[bp],ax
!BCC_EOS
! 2163         if ((lafter > 0) && (lafter & 0x01)) {
! Debug: gt int = const 0 to unsigned short lafter = [S+$24-$10] (used reg = )
mov	ax,-$E[bp]
test	ax,ax
je  	.2C4
.2C6:
! Debug: and int = const 1 to unsigned short lafter = [S+$24-$10] (used reg = )
mov	al,-$E[bp]
and	al,*1
test	al,al
je  	.2C4
.2C5:
! 2164           lafter-=1;
! Debug: subab int = const 1 to unsigned short lafter = [S+$24-$10] (used reg = )
mov	ax,-$E[bp]
dec	ax
mov	-$E[bp],ax
!BCC_EOS
! 2165         }
! 2166       }
.2C4:
! 2167       if (lmode == 0x01) {
.2C2:
! Debug: logeq int = const 1 to unsigned char lmode = [S+$24-$17] (used reg = )
mov	al,-$15[bp]
cmp	al,*1
jne 	.2C7
.2C8:
! 2168         lcount>>=2; lbefore>>=2; lafter>>=2;
! Debug: srab int = const 2 to unsigned short lcount = [S+$24-$C] (used reg = )
mov	ax,-$A[bp]
shr	ax,*1
shr	ax,*1
mov	-$A[bp],ax
!BCC_EOS
! Debug: srab int = const 2 to unsigned short lbefore = [S+$24-$E] (used reg = )
mov	ax,-$C[bp]
shr	ax,*1
shr	ax,*1
mov	-$C[bp],ax
!BCC_EOS
! Debug: srab int = const 2 to unsigned short lafter = [S+$24-$10] (used reg = )
mov	ax,-$E[bp]
shr	ax,*1
shr	ax,*1
mov	-$E[bp],ax
!BCC_EOS
! 2169       }
! 2170       else {
jmp .2C9
.2C7:
! 2171         lcount>>=1; lbefore>>=1; lafter>>=1;
! Debug: srab int = const 1 to unsigned short lcount = [S+$24-$C] (used reg = )
mov	ax,-$A[bp]
shr	ax,*1
mov	-$A[bp],ax
!BCC_EOS
! Debug: srab int = const 1 to unsigned short lbefore = [S+$24-$E] (used reg = )
mov	ax,-$C[bp]
shr	ax,*1
mov	-$C[bp],ax
!BCC_EOS
! Debug: srab int = const 1 to unsigned short lafter = [S+$24-$10] (used reg = )
mov	ax,-$E[bp]
shr	ax,*1
mov	-$E[bp],ax
!BCC_EOS
! 2172       }
! 2173        ;
.2C9:
!BCC_EOS
! 2174 #asm
!BCC_EOS
!BCC_ASM
_ata_cmd_packet.cmdoff	set	$2C
.ata_cmd_packet.cmdoff	set	$A
_ata_cmd_packet.header	set	$2E
.ata_cmd_packet.header	set	$C
_ata_cmd_packet.count	set	$12
.ata_cmd_packet.count	set	-$10
_ata_cmd_packet.lafter	set	$14
.ata_cmd_packet.lafter	set	-$E
_ata_cmd_packet.iobase1	set	$1C
.ata_cmd_packet.iobase1	set	-6
_ata_cmd_packet.channel	set	$11
.ata_cmd_packet.channel	set	-$11
_ata_cmd_packet.cmdseg	set	$2A
.ata_cmd_packet.cmdseg	set	8
_ata_cmd_packet.cmdlen	set	$28
.ata_cmd_packet.cmdlen	set	6
_ata_cmd_packet.lmode	set	$D
.ata_cmd_packet.lmode	set	-$15
_ata_cmd_packet.device	set	$26
.ata_cmd_packet.device	set	4
_ata_cmd_packet.loops	set	2
.ata_cmd_packet.loops	set	-$20
_ata_cmd_packet.ebda_seg	set	$20
.ata_cmd_packet.ebda_seg	set	-2
_ata_cmd_packet.lcount	set	$18
.ata_cmd_packet.lcount	set	-$A
_ata_cmd_packet.total	set	8
.ata_cmd_packet.total	set	-$1A
_ata_cmd_packet.status	set	$F
.ata_cmd_packet.status	set	-$13
_ata_cmd_packet.mode	set	$E
.ata_cmd_packet.mode	set	-$14
_ata_cmd_packet.bufoff	set	$38
.ata_cmd_packet.bufoff	set	$16
_ata_cmd_packet.transfer	set	4
.ata_cmd_packet.transfer	set	-$1E
_ata_cmd_packet.sc	set	1
.ata_cmd_packet.sc	set	-$21
_ata_cmd_packet.iobase2	set	$1A
.ata_cmd_packet.iobase2	set	-8
_ata_cmd_packet.lbefore	set	$16
.ata_cmd_packet.lbefore	set	-$C
_ata_cmd_packet.bufseg	set	$36
.ata_cmd_packet.bufseg	set	$14
_ata_cmd_packet.slave	set	$10
.ata_cmd_packet.slave	set	-$12
_ata_cmd_packet.inout	set	$34
.ata_cmd_packet.inout	set	$12
_ata_cmd_packet.old_ds	set	$1E
.ata_cmd_packet.old_ds	set	-4
_ata_cmd_packet.length	set	$30
.ata_cmd_packet.length	set	$E
        push bp
        mov bp, sp
        mov dx, _ata_cmd_packet.iobase1 + 2[bp] ;; ATA data read port
        mov cx, _ata_cmd_packet.lbefore + 2[bp]
        jcxz ata_packet_no_before
        mov ah, _ata_cmd_packet.lmode + 2[bp]
        cmp ah, #0x01
        je ata_packet_in_before_32
ata_packet_in_before_16:
        in ax, dx
        loop ata_packet_in_before_16
        jmp ata_packet_no_before
ata_packet_in_before_32:
        push eax
ata_packet_in_before_32_loop:
        in eax, dx
        loop ata_packet_in_before_32_loop
        pop eax
ata_packet_no_before:
        mov cx, _ata_cmd_packet.lcount + 2[bp]
        jcxz ata_packet_after
        mov di, _ata_cmd_packet.bufoff + 2[bp]
        mov ax, _ata_cmd_packet.bufseg + 2[bp]
        mov es, ax
        mov ah, _ata_cmd_packet.lmode + 2[bp]
        cmp ah, #0x01
        je ata_packet_in_32
ata_packet_in_16:
        rep
          insw ;; CX words transferred to port(DX) to ES:[DI]
        jmp ata_packet_after
ata_packet_in_32:
        rep
          insd ;; CX dwords transferred to port(DX) to ES:[DI]
ata_packet_after:
        mov cx, _ata_cmd_packet.lafter + 2[bp]
        jcxz ata_packet_done
        mov ah, _ata_cmd_packet.lmode + 2[bp]
        cmp ah, #0x01
        je ata_packet_in_after_32
ata_packet_in_after_16:
        in ax, dx
        loop ata_packet_in_after_16
        jmp ata_packet_done
ata_packet_in_after_32:
        push eax
ata_packet_in_after_32_loop:
        in eax, dx
        loop ata_packet_in_after_32_loop
        pop eax
ata_packet_done:
        pop bp
! 2227 endasm
!BCC_ENDASM
!BCC_EOS
! 2228       bufoff += count;
! Debug: addab unsigned short count = [S+$24-$12] to unsigned short bufoff = [S+$24+$14] (used reg = )
mov	ax,$16[bp]
add	ax,-$10[bp]
mov	$16[bp],ax
!BCC_EOS
! 2229       transfer += count;
! Debug: cast unsigned long = const 0 to unsigned short count = [S+$24-$12] (used reg = )
mov	ax,-$10[bp]
xor	bx,bx
! Debug: addab unsigned long = bx+0 to unsigned long transfer = [S+$24-$20] (used reg = )
lea	di,-$1E[bp]
call	laddul
mov	-$1E[bp],ax
mov	-$1C[bp],bx
!BCC_EOS
! 2230       _write_dword(transfer, &((ebda_data_t *) 0)->ata.trsfbytes, ebda_seg);
! Debug: list unsigned short ebda_seg = [S+$24-4] (used reg = )
push	-2[bp]
! Debug: list * unsigned long = const $256 (used reg = )
mov	ax,#$256
push	ax
! Debug: list unsigned long transfer = [S+$28-$20] (used reg = )
push	-$1C[bp]
push	-$1E[bp]
! Debug: func () void = _write_dword+0 (used reg = )
call	__write_dword
add	sp,*8
!BCC_EOS
! 2231     }
! 2232   }
.2AC:
br 	.2AD
.2CA:
.2AB:
add	sp,*4
! 2233   if ( (status & (0x80 | 0x40 | 0x20 | 0x08 | 0x01) )
.2AA:
! 2234          != 0x40 ) {
! Debug: and int = const $E9 to unsigned char status = [S+$20-$15] (used reg = )
mov	al,-$13[bp]
and	al,#$E9
! Debug: ne int = const $40 to unsigned char = al+0 (used reg = )
cmp	al,*$40
je  	.2CB
.2CC:
! 2235     ;
!BCC_EOS
! 2236     return 4;
mov	ax,*4
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2237   }
! 2238   outb(iobase2+6, 0x08);
.2CB:
! Debug: list int = const 8 (used reg = )
mov	ax,*8
push	ax
! Debug: add int = const 6 to unsigned short iobase2 = [S+$22-$A] (used reg = )
mov	ax,-8[bp]
! Debug: list unsigned int = ax+6 (used reg = )
add	ax,*6
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 2239   return 0;
xor	ax,ax
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2240 }
! 2241   Bit16u
! Register BX used in function ata_cmd_packet
! 2242 atapi_get_sense(device, seg, asc, ascq)
! 2243   Bit16u device;
export	_atapi_get_sense
_atapi_get_sense:
!BCC_EOS
! 2244 {
! 2245   Bit8u atacmd[12];
!BCC_EOS
! 2246   Bit8u buffer[18];
!BCC_EOS
! 2247   Bit8u i;
!BCC_EOS
! 2248   _memsetb(0,atacmd,get_SS(),12);
push	bp
mov	bp,sp
add	sp,*-$20
! Debug: list int = const $C (used reg = )
mov	ax,*$C
push	ax
! Debug: func () unsigned short = get_SS+0 (used reg = )
call	_get_SS
! Debug: list unsigned short = ax+0 (used reg = )
push	ax
! Debug: list * unsigned char atacmd = S+$26-$E (used reg = )
lea	bx,-$C[bp]
push	bx
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: func () void = _memsetb+0 (used reg = )
call	__memsetb
add	sp,*8
!BCC_EOS
! 2249   atacmd[0]=0x03;
! Debug: eq int = const 3 to unsigned char atacmd = [S+$22-$E] (used reg = )
mov	al,*3
mov	-$C[bp],al
!BCC_EOS
! 2250   atacmd[4]=sizeof(buffer);
! Debug: eq int = const $12 to unsigned char atacmd = [S+$22-$A] (used reg = )
mov	al,*$12
mov	-8[bp],al
!BCC_EOS
! 2251   if (ata_cmd_packet(device, 12, get_SS(), atacmd, 0, 18L, 0x01, get_SS(), buffer) != 0)
! Debug: list * unsigned char buffer = S+$22-$20 (used reg = )
lea	bx,-$1E[bp]
push	bx
! Debug: func () unsigned short = get_SS+0 (used reg = )
call	_get_SS
! Debug: list unsigned short = ax+0 (used reg = )
push	ax
! Debug: list int = const 1 (used reg = )
mov	ax,*1
push	ax
! Debug: list long = const $12 (used reg = )
mov	ax,*$12
xor	bx,bx
push	bx
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list * unsigned char atacmd = S+$2E-$E (used reg = )
lea	bx,-$C[bp]
push	bx
! Debug: func () unsigned short = get_SS+0 (used reg = )
call	_get_SS
! Debug: list unsigned short = ax+0 (used reg = )
push	ax
! Debug: list int = const $C (used reg = )
mov	ax,*$C
push	ax
! Debug: list unsigned short device = [S+$34+2] (used reg = )
push	4[bp]
! Debug: func () unsigned short = ata_cmd_packet+0 (used reg = )
call	_ata_cmd_packet
add	sp,*$14
! Debug: ne int = const 0 to unsigned short = ax+0 (used reg = )
test	ax,ax
je  	.2CD
.2CE:
! 2252     return 0x0002;
mov	ax,*2
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2253   _write_byte(buffer[12], asc, seg);
.2CD:
! Debug: list int seg = [S+$22+4] (used reg = )
push	6[bp]
! Debug: list int asc = [S+$24+6] (used reg = )
push	8[bp]
! Debug: list unsigned char buffer = [S+$26-$14] (used reg = )
mov	al,-$12[bp]
xor	ah,ah
push	ax
! Debug: func () void = _write_byte+0 (used reg = )
call	__write_byte
add	sp,*6
!BCC_EOS
! 2254   _write_byte(buffer[13], ascq, seg);
! Debug: list int seg = [S+$22+4] (used reg = )
push	6[bp]
! Debug: list int ascq = [S+$24+8] (used reg = )
push	$A[bp]
! Debug: list unsigned char buffer = [S+$26-$13] (used reg = )
mov	al,-$11[bp]
xor	ah,ah
push	ax
! Debug: func () void = _write_byte+0 (used reg = )
call	__write_byte
add	sp,*6
!BCC_EOS
! 2255   return 0;
xor	ax,ax
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2256 }
! 2257   Bit16u
! Register BX used in function atapi_get_sense
! 2258 atapi_is_ready(device)
! 2259   Bit16u device;
export	_atapi_is_ready
_atapi_is_ready:
!BCC_EOS
! 2260 {
! 2261   Bit8u packet[12];
!BCC_EOS
! 2262   Bit8u buf[8];
!BCC_EOS
! 2263   Bit32u block_len;
!BCC_EOS
! 2264   Bit32u sectors;
!BCC_EOS
! 2265   Bit32u timeout;
!BCC_EOS
! 2266   Bit32u time;
!BCC_EOS
! 2267   Bit8u asc, ascq;
!BCC_EOS
! 2268   Bit8u in_progress;
!BCC_EOS
! 2269   Bit16u ebda_seg = get_ebda_seg();
push	bp
mov	bp,sp
add	sp,*-$2A
! Debug: func () unsigned short = get_ebda_seg+0 (used reg = )
call	_get_ebda_seg
! Debug: eq unsigned short = ax+0 to unsigned short ebda_seg = [S+$2C-$2C] (used reg = )
mov	-$2A[bp],ax
!BCC_EOS
! 2270   if (_read_byte(&((ebda_data_t *) 0)->ata.devices[device].type, ebda_seg) != 0x03) {
! Debug: list unsigned short ebda_seg = [S+$2C-$2C] (used reg = )
push	-$2A[bp]
! Debug: ptradd unsigned short device = [S+$2E+2] to [8] struct  = const $142 (used reg = )
mov	ax,4[bp]
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned char = [bx+$142] (used reg = )
! Debug: list * unsigned char = bx+$142 (used reg = )
add	bx,#$142
push	bx
! Debug: func () unsigned char = _read_byte+0 (used reg = )
call	__read_byte
add	sp,*4
! Debug: ne int = const 3 to unsigned char = al+0 (used reg = )
cmp	al,*3
je  	.2CF
.2D0:
! 2271     bios_printf(2, "not implemented for non-ATAPI device\n");
! Debug: list * char = .2D1+0 (used reg = )
mov	bx,#.2D1
push	bx
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*4
!BCC_EOS
! 2272     return -1;
mov	ax,#$FFFF
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2273   }
! 2274   ;
.2CF:
!BCC_EOS
! 2275   _memsetb(0,packet,get_SS(),sizeof packet);
! Debug: list int = const $C (used reg = )
mov	ax,*$C
push	ax
! Debug: func () unsigned short = get_SS+0 (used reg = )
call	_get_SS
! Debug: list unsigned short = ax+0 (used reg = )
push	ax
! Debug: list * unsigned char packet = S+$30-$E (used reg = )
lea	bx,-$C[bp]
push	bx
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: func () void = _memsetb+0 (used reg = )
call	__memsetb
add	sp,*8
!BCC_EOS
! 2276   packet[0] = 0x25;
! Debug: eq int = const $25 to unsigned char packet = [S+$2C-$E] (used reg = )
mov	al,*$25
mov	-$C[bp],al
!BCC_EOS
! 2277   timeout = 5000;
! Debug: eq int = const $1388 to unsigned long timeout = [S+$2C-$22] (used reg = )
mov	ax,#$1388
xor	bx,bx
mov	-$20[bp],ax
mov	-$1E[bp],bx
!BCC_EOS
! 2278   time = 0;
! Debug: eq int = const 0 to unsigned long time = [S+$2C-$26] (used reg = )
xor	ax,ax
xor	bx,bx
mov	-$24[bp],ax
mov	-$22[bp],bx
!BCC_EOS
! 2279   in_progress = 0;
! Debug: eq int = const 0 to unsigned char in_progress = [S+$2C-$29] (used reg = )
xor	al,al
mov	-$27[bp],al
!BCC_EOS
! 2280   while (time < timeout) {
br 	.2D3
.2D4:
! 2281     if (ata_cmd_packet(device, sizeof(packet), get_SS(), packet, 0, 8L, 0x01, get_SS(), buf) == 0)
! Debug: list * unsigned char buf = S+$2C-$16 (used reg = )
lea	bx,-$14[bp]
push	bx
! Debug: func () unsigned short = get_SS+0 (used reg = )
call	_get_SS
! Debug: list unsigned short = ax+0 (used reg = )
push	ax
! Debug: list int = const 1 (used reg = )
mov	ax,*1
push	ax
! Debug: list long = const 8 (used reg = )
mov	ax,*8
xor	bx,bx
push	bx
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list * unsigned char packet = S+$38-$E (used reg = )
lea	bx,-$C[bp]
push	bx
! Debug: func () unsigned short = get_SS+0 (used reg = )
call	_get_SS
! Debug: list unsigned short = ax+0 (used reg = )
push	ax
! Debug: list int = const $C (used reg = )
mov	ax,*$C
push	ax
! Debug: list unsigned short device = [S+$3E+2] (used reg = )
push	4[bp]
! Debug: func () unsigned short = ata_cmd_packet+0 (used reg = )
call	_ata_cmd_packet
add	sp,*$14
! Debug: logeq int = const 0 to unsigned short = ax+0 (used reg = )
test	ax,ax
jne 	.2D5
.2D6:
! 2282       goto ok;
add	sp,#..FFFA+$2C
br 	.FFFA
!BCC_EOS
! 2283     if (atapi_get_sense(device, get_SS(), &asc, &ascq) == 0) {
.2D5:
! Debug: list * unsigned char ascq = S+$2C-$28 (used reg = )
lea	bx,-$26[bp]
push	bx
! Debug: list * unsigned char asc = S+$2E-$27 (used reg = )
lea	bx,-$25[bp]
push	bx
! Debug: func () unsigned short = get_SS+0 (used reg = )
call	_get_SS
! Debug: list unsigned short = ax+0 (used reg = )
push	ax
! Debug: list unsigned short device = [S+$32+2] (used reg = )
push	4[bp]
! Debug: func () unsigned short = atapi_get_sense+0 (used reg = )
call	_atapi_get_sense
add	sp,*8
! Debug: logeq int = const 0 to unsigned short = ax+0 (used reg = )
test	ax,ax
jne 	.2D7
.2D8:
! 2284       if (asc == 0
! 2284 x3a) {
! Debug: logeq int = const $3A to unsigned char asc = [S+$2C-$27] (used reg = )
mov	al,-$25[bp]
cmp	al,*$3A
jne 	.2D9
.2DA:
! 2285         ;
!BCC_EOS
! 2286         return -1;
mov	ax,#$FFFF
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2287       }
! 2288       if (asc == 0x04 && ascq == 0x01 && !in_progress) {
.2D9:
! Debug: logeq int = const 4 to unsigned char asc = [S+$2C-$27] (used reg = )
mov	al,-$25[bp]
cmp	al,*4
jne 	.2DB
.2DE:
! Debug: logeq int = const 1 to unsigned char ascq = [S+$2C-$28] (used reg = )
mov	al,-$26[bp]
cmp	al,*1
jne 	.2DB
.2DD:
mov	al,-$27[bp]
test	al,al
jne 	.2DB
.2DC:
! 2289         bios_printf(2, "Waiting for device to detect medium... ");
! Debug: list * char = .2DF+0 (used reg = )
mov	bx,#.2DF
push	bx
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*4
!BCC_EOS
! 2290         timeout = 30000;
! Debug: eq int = const $7530 to unsigned long timeout = [S+$2C-$22] (used reg = )
mov	ax,#$7530
xor	bx,bx
mov	-$20[bp],ax
mov	-$1E[bp],bx
!BCC_EOS
! 2291         in_progress = 1;
! Debug: eq int = const 1 to unsigned char in_progress = [S+$2C-$29] (used reg = )
mov	al,*1
mov	-$27[bp],al
!BCC_EOS
! 2292       }
! 2293     }
.2DB:
! 2294     time += 100;
.2D7:
! Debug: addab unsigned long = const $64 to unsigned long time = [S+$2C-$26] (used reg = )
mov	ax,*$64
xor	bx,bx
push	bx
push	ax
mov	ax,-$24[bp]
mov	bx,-$22[bp]
lea	di,-$2E[bp]
call	laddul
mov	-$24[bp],ax
mov	-$22[bp],bx
add	sp,*4
!BCC_EOS
! 2295   }
! 2296   ;
.2D3:
! Debug: lt unsigned long timeout = [S+$2C-$22] to unsigned long time = [S+$2C-$26] (used reg = )
mov	ax,-$20[bp]
mov	bx,-$1E[bp]
lea	di,-$24[bp]
call	lcmpul
bhi 	.2D4
.2E0:
.2D2:
!BCC_EOS
! 2297   return -1;
mov	ax,#$FFFF
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2298 ok:
.FFFA:
..FFFA	=	-$2C
! 2299   *(((Bit8u *)&*(((Bit16u *)&block_len)+1))+1) = buf[4];
! Debug: eq unsigned char buf = [S+$2C-$12] to unsigned char block_len = [S+$2C-$17] (used reg = )
mov	al,-$10[bp]
mov	-$15[bp],al
!BCC_EOS
! 2300   *((Bit8u *)&*(((Bit16u *)&block_len)+1)) = buf[5];
! Debug: eq unsigned char buf = [S+$2C-$11] to unsigned char block_len = [S+$2C-$18] (used reg = )
mov	al,-$F[bp]
mov	-$16[bp],al
!BCC_EOS
! 2301   *(((Bit8u *)&*((Bit16u *)&block_len))+1) = buf[6];
! Debug: eq unsigned char buf = [S+$2C-$10] to unsigned char block_len = [S+$2C-$19] (used reg = )
mov	al,-$E[bp]
mov	-$17[bp],al
!BCC_EOS
! 2302   *((Bit8u *)&block_len) = buf[7];
! Debug: eq unsigned char buf = [S+$2C-$F] to unsigned char block_len = [S+$2C-$1A] (used reg = )
mov	al,-$D[bp]
mov	-$18[bp],al
!BCC_EOS
! 2303   ;
!BCC_EOS
! 2304   if (block_len!= 2048 && block_len!= 512)
! Debug: ne unsigned long = const $800 to unsigned long block_len = [S+$2C-$1A] (used reg = )
! Debug: expression subtree swapping
mov	ax,#$800
xor	bx,bx
push	bx
push	ax
mov	ax,-$18[bp]
mov	bx,-$16[bp]
lea	di,-$2E[bp]
call	lcmpul
lea	sp,-$2A[bp]
je  	.2E1
.2E3:
! Debug: ne unsigned long = const $200 to unsigned long block_len = [S+$2C-$1A] (used reg = )
! Debug: expression subtree swapping
mov	ax,#$200
xor	bx,bx
push	bx
push	ax
mov	ax,-$18[bp]
mov	bx,-$16[bp]
lea	di,-$2E[bp]
call	lcmpul
lea	sp,-$2A[bp]
je  	.2E1
.2E2:
! 2305   {
! 2306     bios_printf(2, "Unsupported sector size %u\n", block_len);
! Debug: list unsigned long block_len = [S+$2C-$1A] (used reg = )
push	-$16[bp]
push	-$18[bp]
! Debug: list * char = .2E4+0 (used reg = )
mov	bx,#.2E4
push	bx
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*8
!BCC_EOS
! 2307     return -1;
mov	ax,#$FFFF
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2308   }
! 2309   _write_dword(block_len, &((ebda_data_t *) 0)->ata.devices[device].blksize, ebda_seg);
.2E1:
! Debug: list unsigned short ebda_seg = [S+$2C-$2C] (used reg = )
push	-$2A[bp]
! Debug: ptradd unsigned short device = [S+$2E+2] to [8] struct  = const $142 (used reg = )
mov	ax,4[bp]
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned short = [bx+$148] (used reg = )
! Debug: list * unsigned short = bx+$148 (used reg = )
add	bx,#$148
push	bx
! Debug: list unsigned long block_len = [S+$30-$1A] (used reg = )
push	-$16[bp]
push	-$18[bp]
! Debug: func () void = _write_dword+0 (used reg = )
call	__write_dword
add	sp,*8
!BCC_EOS
! 2310   *(((Bit8u *)&*(((Bit16u *)&sectors)+1))+1) = buf[0];
! Debug: eq unsigned char buf = [S+$2C-$16] to unsigned char sectors = [S+$2C-$1B] (used reg = )
mov	al,-$14[bp]
mov	-$19[bp],al
!BCC_EOS
! 2311   *((Bit8u *)&*(((Bit16u *)&sectors)+1)) = buf[1];
! Debug: eq unsigned char buf = [S+$2C-$15] to unsigned char sectors = [S+$2C-$1C] (used reg = )
mov	al,-$13[bp]
mov	-$1A[bp],al
!BCC_EOS
! 2312   *(((Bit8u *)&*((Bit16u *)&sectors))+1) = buf[2];
! Debug: eq unsigned char buf = [S+$2C-$14] to unsigned char sectors = [S+$2C-$1D] (used reg = )
mov	al,-$12[bp]
mov	-$1B[bp],al
!BCC_EOS
! 2313   *((Bit8u *)&sectors) = buf[3];
! Debug: eq unsigned char buf = [S+$2C-$13] to unsigned char sectors = [S+$2C-$1E] (used reg = )
mov	al,-$11[bp]
mov	-$1C[bp],al
!BCC_EOS
! 2314   ;
!BCC_EOS
! 2315   if (block_len == 2048)
! Debug: logeq unsigned long = const $800 to unsigned long block_len = [S+$2C-$1A] (used reg = )
! Debug: expression subtree swapping
mov	ax,#$800
xor	bx,bx
push	bx
push	ax
mov	ax,-$18[bp]
mov	bx,-$16[bp]
lea	di,-$2E[bp]
call	lcmpul
lea	sp,-$2A[bp]
jne 	.2E5
.2E6:
! 2316     sectors <<= 2;
! Debug: slab int = const 2 to unsigned long sectors = [S+$2C-$1E] (used reg = )
mov	ax,-$1C[bp]
mov	bx,-$1A[bp]
mov	di,*2
call	lslul
mov	-$1C[bp],ax
mov	-$1A[bp],bx
!BCC_EOS
! 2317   if (sectors != _read_dword(&((ebda_data_t *) 0)->ata.devices[device].sectors_low, ebda_seg))
.2E5:
! Debug: list unsigned short ebda_seg = [S+$2C-$2C] (used reg = )
push	-$2A[bp]
! Debug: ptradd unsigned short device = [S+$2E+2] to [8] struct  = const $142 (used reg = )
mov	ax,4[bp]
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned long = [bx+$158] (used reg = )
! Debug: list * unsigned long = bx+$158 (used reg = )
add	bx,#$158
push	bx
! Debug: func () unsigned long = _read_dword+0 (used reg = )
call	__read_dword
mov	bx,dx
add	sp,*4
! Debug: ne unsigned long = bx+0 to unsigned long sectors = [S+$2C-$1E] (used reg = )
! Debug: expression subtree swapping
lea	di,-$1C[bp]
call	lcmpul
je  	.2E7
.2E8:
! 2318     bios_printf(2, "%dMB medium detected\n", sectors>>(20-9));
! Debug: sr int = const $B to unsigned long sectors = [S+$2C-$1E] (used reg = )
mov	ax,-$1C[bp]
mov	bx,-$1A[bp]
mov	al,ah
mov	ah,bl
mov	bl,bh
sub	bh,bh
mov	di,*3
call	lsrul
! Debug: list unsigned long = bx+0 (used reg = )
push	bx
push	ax
! Debug: list * char = .2E9+0 (used reg = )
mov	bx,#.2E9
push	bx
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*8
!BCC_EOS
! 2319   _write_dword(sectors, &((ebda_data_t *) 0)->ata.devices[device].sectors_low, ebda_seg);
.2E7:
! Debug: list unsigned short ebda_seg = [S+$2C-$2C] (used reg = )
push	-$2A[bp]
! Debug: ptradd unsigned short device = [S+$2E+2] to [8] struct  = const $142 (used reg = )
mov	ax,4[bp]
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned long = [bx+$158] (used reg = )
! Debug: list * unsigned long = bx+$158 (used reg = )
add	bx,#$158
push	bx
! Debug: list unsigned long sectors = [S+$30-$1E] (used reg = )
push	-$1A[bp]
push	-$1C[bp]
! Debug: func () void = _write_dword+0 (used reg = )
call	__write_dword
add	sp,*8
!BCC_EOS
! 2320   return 0;
xor	ax,ax
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2321 }
! 2322   Bit16u
! Register BX used in function atapi_is_ready
! 2323 atapi_is_cdrom(device)
! 2324   Bit8u device;
export	_atapi_is_cdrom
_atapi_is_cdrom:
!BCC_EOS
! 2325 {
! 2326   Bit16u ebda_seg=get_ebda_seg();
push	bp
mov	bp,sp
dec	sp
dec	sp
! Debug: func () unsigned short = get_ebda_seg+0 (used reg = )
call	_get_ebda_seg
! Debug: eq unsigned short = ax+0 to unsigned short ebda_seg = [S+4-4] (used reg = )
mov	-2[bp],ax
!BCC_EOS
! 2327   if (device >= (4*2))
! Debug: ge int = const 8 to unsigned char device = [S+4+2] (used reg = )
mov	al,4[bp]
cmp	al,*8
jb  	.2EA
.2EB:
! 2328     return 0;
xor	ax,ax
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2329   if (_read_byte(&((ebda_data_t *) 0)->ata.devices[device].type, ebda_seg) != 0x03)
.2EA:
! Debug: list unsigned short ebda_seg = [S+4-4] (used reg = )
push	-2[bp]
! Debug: ptradd unsigned char device = [S+6+2] to [8] struct  = const $142 (used reg = )
mov	al,4[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned char = [bx+$142] (used reg = )
! Debug: list * unsigned char = bx+$142 (used reg = )
add	bx,#$142
push	bx
! Debug: func () unsigned char = _read_byte+0 (used reg = )
call	__read_byte
add	sp,*4
! Debug: ne int = const 3 to unsigned char = al+0 (used reg = )
cmp	al,*3
je  	.2EC
.2ED:
! 2330     return 0;
xor	ax,ax
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2331   if (_read_byte(&((ebda_data_t *) 0)->ata.devices[device].device, ebda_seg) != 0x05)
.2EC:
! Debug: list unsigned short ebda_seg = [S+4-4] (used reg = )
push	-2[bp]
! Debug: ptradd unsigned char device = [S+6+2] to [8] struct  = const $142 (used reg = )
mov	al,4[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned char = [bx+$143] (used reg = )
! Debug: list * unsigned char = bx+$143 (used reg = )
add	bx,#$143
push	bx
! Debug: func () unsigned char = _read_byte+0 (used reg = )
call	__read_byte
add	sp,*4
! Debug: ne int = const 5 to unsigned char = al+0 (used reg = )
cmp	al,*5
je  	.2EE
.2EF:
! 2332     return 0;
xor	ax,ax
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2333   return 1;
.2EE:
mov	ax,*1
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2334 }
! 2335   void
! Register BX used in function atapi_is_cdrom
! 2336 cdemu_init()
! 2337 {
export	_cdemu_init
_cdemu_init:
! 2338   Bit16u ebda_seg=get_ebda_seg();
push	bp
mov	bp,sp
dec	sp
dec	sp
! Debug: func () unsigned short = get_ebda_seg+0 (used reg = )
call	_get_ebda_seg
! Debug: eq unsigned short = ax+0 to unsigned short ebda_seg = [S+4-4] (used reg = )
mov	-2[bp],ax
!BCC_EOS
! 2339   _write_byte(0x00, &((ebda_data_t *) 0)->cdemu.active, ebda_seg);
! Debug: list unsigned short ebda_seg = [S+4-4] (used reg = )
push	-2[bp]
! Debug: list * unsigned char = const $25A (used reg = )
mov	ax,#$25A
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: func () void = _write_byte+0 (used reg = )
call	__write_byte
add	sp,*6
!BCC_EOS
! 2340 }
mov	sp,bp
pop	bp
ret
! 2341   Bit8u
! 2342 cdemu_isactive()
! 2343 {
export	_cdemu_isactive
_cdemu_isactive:
! 2344   Bit16u ebda_seg=get_ebda_seg();
push	bp
mov	bp,sp
dec	sp
dec	sp
! Debug: func () unsigned short = get_ebda_seg+0 (used reg = )
call	_get_ebda_seg
! Debug: eq unsigned short = ax+0 to unsigned short ebda_seg = [S+4-4] (used reg = )
mov	-2[bp],ax
!BCC_EOS
! 2345   return(_read_byte(&((ebda_data_t *) 0)->cdemu.active, ebda_seg));
! Debug: list unsigned short ebda_seg = [S+4-4] (used reg = )
push	-2[bp]
! Debug: list * unsigned char = const $25A (used reg = )
mov	ax,#$25A
push	ax
! Debug: func () unsigned char = _read_byte+0 (used reg = )
call	__read_byte
add	sp,*4
! Debug: cast unsigned char = const 0 to unsigned char = al+0 (used reg = )
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2346 }
! 2347   Bit8u
! 2348 cdemu_emulated_drive()
! 2349 {
export	_cdemu_emulated_drive
_cdemu_emulated_drive:
! 2350   Bit16u ebda_seg=get_ebda_seg();
push	bp
mov	bp,sp
dec	sp
dec	sp
! Debug: func () unsigned short = get_ebda_seg+0 (used reg = )
call	_get_ebda_seg
! Debug: eq unsigned short = ax+0 to unsigned short ebda_seg = [S+4-4] (used reg = )
mov	-2[bp],ax
!BCC_EOS
! 2351   return(_read_byte(&((ebda_data_t *) 0)->cdemu.emulated_drive, ebda_seg));
! Debug: list unsigned short ebda_seg = [S+4-4] (used reg = )
push	-2[bp]
! Debug: list * unsigned char = const $25C (used reg = )
mov	ax,#$25C
push	ax
! Debug: func () unsigned char = _read_byte+0 (used reg = )
call	__read_byte
add	sp,*4
! Debug: cast unsigned char = const 0 to unsigned char = al+0 (used reg = )
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2352 }
! 2353 static char isotag[6]="CD001";
.data
_isotag:
.2F0:
.ascii	"CD001"
.byte	0
!BCC_EOS
! 2354 static char eltorito[24]="EL TORITO SPECIFICATION";
_eltorito:
.2F1:
.ascii	"EL TORITO SPECIFICATION"
.byte	0
!BCC_EOS
! 2355   Bit16u
! 2356 cdrom_boot()
! 2357 {
.text
export	_cdrom_boot
_cdrom_boot:
! 2358   Bit16u ebda_
! 2358 seg=get_ebda_seg(), old_ds;
push	bp
mov	bp,sp
dec	sp
dec	sp
! Debug: func () unsigned short = get_ebda_seg+0 (used reg = )
call	_get_ebda_seg
! Debug: eq unsigned short = ax+0 to unsigned short ebda_seg = [S+4-4] (used reg = )
mov	-2[bp],ax
!BCC_EOS
! 2359   Bit8u atacmd[12], buffer[2048];
!BCC_EOS
! 2360   Bit32u lba;
!BCC_EOS
! 2361   Bit16u boot_segment, nbsectors, i, error;
!BCC_EOS
! 2362   Bit8u device;
!BCC_EOS
! 2363   for (device=0; device<(4*2);device++) {
add	sp,#-$81C
! Debug: eq int = const 0 to unsigned char device = [S+$820-$81F] (used reg = )
xor	al,al
mov	-$81D[bp],al
!BCC_EOS
!BCC_EOS
jmp .2F4
.2F5:
! 2364     if (atapi_is_cdrom(device)) break;
! Debug: list unsigned char device = [S+$820-$81F] (used reg = )
mov	al,-$81D[bp]
xor	ah,ah
push	ax
! Debug: func () unsigned short = atapi_is_cdrom+0 (used reg = )
call	_atapi_is_cdrom
inc	sp
inc	sp
test	ax,ax
je  	.2F6
.2F7:
jmp .2F2
!BCC_EOS
! 2365   }
.2F6:
! 2366   if(device >= (4*2)) return 2;
.2F3:
! Debug: postinc unsigned char device = [S+$820-$81F] (used reg = )
mov	al,-$81D[bp]
inc	ax
mov	-$81D[bp],al
.2F4:
! Debug: lt int = const 8 to unsigned char device = [S+$820-$81F] (used reg = )
mov	al,-$81D[bp]
cmp	al,*8
jb 	.2F5
.2F8:
.2F2:
! Debug: ge int = const 8 to unsigned char device = [S+$820-$81F] (used reg = )
mov	al,-$81D[bp]
cmp	al,*8
jb  	.2F9
.2FA:
mov	ax,*2
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2367   if(error = atapi_is_ready(device) != 0)
.2F9:
! Debug: list unsigned char device = [S+$820-$81F] (used reg = )
mov	al,-$81D[bp]
xor	ah,ah
push	ax
! Debug: func () unsigned short = atapi_is_ready+0 (used reg = )
call	_atapi_is_ready
inc	sp
inc	sp
! Debug: ne int = const 0 to unsigned short = ax+0 (used reg = )
test	ax,ax
je 	.2FD
mov	al,*1
jmp	.2FE
.2FD:
xor	al,al
.2FE:
! Debug: eq char = al+0 to unsigned short error = [S+$820-$81E] (used reg = )
xor	ah,ah
mov	-$81C[bp],ax
test	ax,ax
je  	.2FB
.2FC:
! 2368     bios_printf(4, "ata_is_ready returned %d\n",error);
! Debug: list unsigned short error = [S+$820-$81E] (used reg = )
push	-$81C[bp]
! Debug: list * char = .2FF+0 (used reg = )
mov	bx,#.2FF
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*6
!BCC_EOS
! 2369   _memsetb(0,atacmd,get_SS(),12);
.2FB:
! Debug: list int = const $C (used reg = )
mov	ax,*$C
push	ax
! Debug: func () unsigned short = get_SS+0 (used reg = )
call	_get_SS
! Debug: list unsigned short = ax+0 (used reg = )
push	ax
! Debug: list * unsigned char atacmd = S+$824-$12 (used reg = )
lea	bx,-$10[bp]
push	bx
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: func () void = _memsetb+0 (used reg = )
call	__memsetb
add	sp,*8
!BCC_EOS
! 2370   atacmd[0]=0x28;
! Debug: eq int = const $28 to unsigned char atacmd = [S+$820-$12] (used reg = )
mov	al,*$28
mov	-$10[bp],al
!BCC_EOS
! 2371   atacmd[7]=(0x01 & 0xff00) >> 8;
! Debug: eq unsigned int = const 0 to unsigned char atacmd = [S+$820-$B] (used reg = )
xor	al,al
mov	-9[bp],al
!BCC_EOS
! 2372   atacmd[8]=(0x01 & 0x00ff);
! Debug: eq int = const 1 to unsigned char atacmd = [S+$820-$A] (used reg = )
mov	al,*1
mov	-8[bp],al
!BCC_EOS
! 2373   atacmd[2]=(0x11 & 0xff000000) >> 24;
! Debug: eq unsigned long = const 0 to unsigned char atacmd = [S+$820-$10] (used reg = )
xor	al,al
mov	-$E[bp],al
!BCC_EOS
! 2374   atacmd[3]=(0x11 & 0x00ff0000) >> 16;
! Debug: eq long = const 0 to unsigned char atacmd = [S+$820-$F] (used reg = )
xor	al,al
mov	-$D[bp],al
!BCC_EOS
! 2375   atacmd[4]=(0x11 & 0x0000ff00) >> 8;
! Debug: eq unsigned int = const 0 to unsigned char atacmd = [S+$820-$E] (used reg = )
xor	al,al
mov	-$C[bp],al
!BCC_EOS
! 2376   atacmd[5]=(0x11 & 0x000000ff);
! Debug: eq int = const $11 to unsigned char atacmd = [S+$820-$D] (used reg = )
mov	al,*$11
mov	-$B[bp],al
!BCC_EOS
! 2377   if((error = ata_cmd_packet(device, 12, get_SS(), atacmd, 0, 2048L, 0x01, get_SS(), buffer)) != 0)
! Debug: list * unsigned char buffer = S+$820-$812 (used reg = )
lea	bx,-$810[bp]
push	bx
! Debug: func () unsigned short = get_SS+0 (used reg = )
call	_get_SS
! Debug: list unsigned short = ax+0 (used reg = )
push	ax
! Debug: list int = const 1 (used reg = )
mov	ax,*1
push	ax
! Debug: list long = const $800 (used reg = )
mov	ax,#$800
xor	bx,bx
push	bx
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list * unsigned char atacmd = S+$82C-$12 (used reg = )
lea	bx,-$10[bp]
push	bx
! Debug: func () unsigned short = get_SS+0 (used reg = )
call	_get_SS
! Debug: list unsigned short = ax+0 (used reg = )
push	ax
! Debug: list int = const $C (used reg = )
mov	ax,*$C
push	ax
! Debug: list unsigned char device = [S+$832-$81F] (used reg = )
mov	al,-$81D[bp]
xor	ah,ah
push	ax
! Debug: func () unsigned short = ata_cmd_packet+0 (used reg = )
call	_ata_cmd_packet
add	sp,*$14
! Debug: eq unsigned short = ax+0 to unsigned short error = [S+$820-$81E] (used reg = )
mov	-$81C[bp],ax
! Debug: ne int = const 0 to unsigned short = ax+0 (used reg = )
test	ax,ax
je  	.300
.301:
! 2378     return 3;
mov	ax,*3
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2379   if(buffer[0]!=0) return 4;
.300:
! Debug: ne int = const 0 to unsigned char buffer = [S+$820-$812] (used reg = )
mov	al,-$810[bp]
test	al,al
je  	.302
.303:
mov	ax,*4
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2380   for(i=0;i<5;i++){
.302:
! Debug: eq int = const 0 to unsigned short i = [S+$820-$81C] (used reg = )
xor	ax,ax
mov	-$81A[bp],ax
!BCC_EOS
!BCC_EOS
jmp .306
.307:
! 2381     if(buffer[1+i]!=_read_byte(&isotag[i], 0xf000)) return 5;
! Debug: list unsigned int = const $F000 (used reg = )
mov	ax,#$F000
push	ax
! Debug: ptradd unsigned short i = [S+$822-$81C] to [6] char = isotag+0 (used reg = )
mov	bx,-$81A[bp]
! Debug: address char = [bx+_isotag+0] (used reg = )
! Debug: list * char = bx+_isotag+0 (used reg = )
add	bx,#_isotag
push	bx
! Debug: func () unsigned char = _read_byte+0 (used reg = )
call	__read_byte
add	sp,*4
push	ax
! Debug: add unsigned short i = [S+$822-$81C] to int = const 1 (used reg = )
! Debug: expression subtree swapping
mov	ax,-$81A[bp]
! Debug: ptradd unsigned int = ax+1 to [$800] unsigned char buffer = S+$822-$812 (used reg = )
inc	ax
mov	bx,bp
add	bx,ax
! Debug: ne unsigned char (temp) = [S+$822-$822] to unsigned char = [bx-$810] (used reg = )
mov	al,-$810[bx]
cmp	al,-$820[bp]
lea	sp,-$81E[bp]
je  	.308
.309:
mov	ax,*5
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2382   }
.308:
! 2383   for(i=0;i<23;i++)
.305:
! Debug: postinc unsigned short i = [S+$820-$81C] (used reg = )
mov	ax,-$81A[bp]
inc	ax
mov	-$81A[bp],ax
.306:
! Debug: lt int = const 5 to unsigned short i = [S+$820-$81C] (used reg = )
mov	ax,-$81A[bp]
cmp	ax,*5
jb 	.307
.30A:
.304:
! Debug: eq int = const 0 to unsigned short i = [S+$820-$81C] (used reg = )
xor	ax,ax
mov	-$81A[bp],ax
!BCC_EOS
!BCC_EOS
! 2384     if(buffer[7+i]!=_read_byte(&eltorito[i], 0xf000)) return 6;
jmp .30D
.30E:
! Debug: list unsigned int = const $F000 (used reg = )
mov	ax,#$F000
push	ax
! Debug: ptradd unsigned short i = [S+$822-$81C] to [$18] char = eltorito+0 (used reg = )
mov	bx,-$81A[bp]
! Debug: address char = [bx+_eltorito+0] (used reg = )
! Debug: list * char = bx+_eltorito+0 (used reg = )
add	bx,#_eltorito
push	bx
! Debug: func () unsigned char = _read_byte+0 (used reg = )
call	__read_byte
add	sp,*4
push	ax
! Debug: add unsigned short i = [S+$822-$81C] to int = const 7 (used reg = )
! Debug: expression subtree swapping
mov	ax,-$81A[bp]
! Debug: ptradd unsigned int = ax+7 to [$800] unsigned char buffer = S+$822-$812 (used reg = )
add	ax,*7
mov	bx,bp
add	bx,ax
! Debug: ne unsigned char (temp) = [S+$822-$822] to unsigned char = [bx-$810] (used reg = )
mov	al,-$810[bx]
cmp	al,-$820[bp]
lea	sp,-$81E[bp]
je  	.30F
.310:
mov	ax,*6
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2385   lba=*((Bit32u *)&buffer[0x47]);
.30F:
.30C:
! Debug: postinc unsigned short i = [S+$820-$81C] (used reg = )
mov	ax,-$81A[bp]
inc	ax
mov	-$81A[bp],ax
.30D:
! Debug: lt int = const $17 to unsigned short i = [S+$820-$81C] (used reg = )
mov	ax,-$81A[bp]
cmp	ax,*$17
jb 	.30E
.311:
.30B:
! Debug: eq unsigned long buffer = [S+$820-$7CB] to unsigned long lba = [S+$820-$816] (used reg = )
mov	ax,-$7C9[bp]
mov	bx,-$7C7[bp]
mov	-$814[bp],ax
mov	-$812[bp],bx
!BCC_EOS
! 2386   _memsetb(0,atacmd,get_SS(),12);
! Debug: list int = const $C (used reg = )
mov	ax,*$C
push	ax
! Debug: func () unsigned short = get_SS+0 (used reg = )
call	_get_SS
! Debug: list unsigned short = ax+0 (used reg = )
push	ax
! Debug: list * unsigned char atacmd = S+$824-$12 (used reg = )
lea	bx,-$10[bp]
push	bx
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: func () void = _memsetb+0 (used reg = )
call	__memsetb
add	sp,*8
!BCC_EOS
! 2387   atacmd[0]=0x28;
! Debug: eq int = const $28 to unsigned char atacmd = [S+$820-$12] (used reg = )
mov	al,*$28
mov	-$10[bp],al
!BCC_EOS
! 2388   atacmd[7]=(0x01 & 0xff00) >> 8;
! Debug: eq unsigned int = const 0 to unsigned char atacmd = [S+$820-$B] (used reg = )
xor	al,al
mov	-9[bp],al
!BCC_EOS
! 2389   atacmd[8]=(0x01 & 0x00ff);
! Debug: eq int = const 1 to unsigned char atacmd = [S+$820-$A] (used reg = )
mov	al,*1
mov	-8[bp],al
!BCC_EOS
! 2390   atacmd[2]=*(((Bit8u *)&*(((Bit16u *)&lba)+1))+1);
! Debug: eq unsigned char lba = [S+$820-$813] to unsigned char atacmd = [S+$820-$10] (used reg = )
mov	al,-$811[bp]
mov	-$E[bp],al
!BCC_EOS
! 2391   atacmd[3]=*((Bit8u *)&*(((Bit16u *)&lba)+1));
! Debug: eq unsigned char lba = [S+$820-$814] to unsigned char atacmd = [S+$820-$F] (used reg = )
mov	al,-$812[bp]
mov	-$D[bp],al
!BCC_EOS
! 2392   atacmd[4]=*(((Bit8u *)&*((Bit16u *)&lba))+1);
! Debug: eq unsigned char lba = [S+$820-$815] to unsigned char atacmd = [S+$820-$E] (used reg = )
mov	al,-$813[bp]
mov	-$C[bp],al
!BCC_EOS
! 2393   atacmd[5]=*((Bit8u *)&lba);
! Debug: eq unsigned char lba = [S+$820-$816] to unsigned char atacmd = [S+$820-$D] (used reg = )
mov	al,-$814[bp]
mov	-$B[bp],al
!BCC_EOS
! 2394   if((error = ata_cmd_packet(device, 12, get_SS(), atacmd, 0, 2048L, 0x01, get_SS(), buffer)) != 0)
! Debug: list * unsigned char buffer = S+$820-$812 (used reg = )
lea	bx,-$810[bp]
push	bx
! Debug: func () unsigned short = get_SS+0 (used reg = )
call	_get_SS
! Debug: list unsigned short = ax+0 (used reg = )
push	ax
! Debug: list int = const 1 (used reg = )
mov	ax,*1
push	ax
! Debug: list long = const $800 (used reg = )
mov	ax,#$800
xor	bx,bx
push	bx
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list * unsigned char atacmd = S+$82C-$12 (used reg = )
lea	bx,-$10[bp]
push	bx
! Debug: func () unsigned short = get_SS+0 (used reg = )
call	_get_SS
! Debug: list unsigned short = ax+0 (used reg = )
push	ax
! Debug: list int = const $C (used reg = )
mov	ax,*$C
push	ax
! Debug: list unsigned char device = [S+$832-$81F] (used reg = )
mov	al,-$81D[bp]
xor	ah,ah
push	ax
! Debug: func () unsigned short = ata_cmd_packet+0 (used reg = )
call	_ata_cmd_packet
add	sp,*$14
! Debug: eq unsigned short = ax+0 to unsigned short error = [S+$820-$81E] (used reg = )
mov	-$81C[bp],ax
! Debug: ne int = const 0 to unsigned short = ax+0 (used reg = )
test	ax,ax
je  	.312
.313:
! 2395     return 7;
mov	ax,*7
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2396   if(buffer[0x00]!=0x01)return 8;
.312:
! Debug: ne int = const 1 to unsigned char buffer = [S+$820-$812] (used reg = )
mov	al,-$810[bp]
cmp	al,*1
je  	.314
.315:
mov	ax,*8
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2397   if(buffer[0x01]!=0x00)return 9;
.314:
! Debug: ne int = const 0 to unsigned char buffer = [S+$820-$811] (used reg = )
mov	al,-$80F[bp]
test	al,al
je  	.316
.317:
mov	ax,*9
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2398   if(buffer[0x1E]!=0x55)return 10;
.316:
! Debug: ne int = const $55 to unsigned char buffer = [S+$820-$7F4] (used reg = )
mov	al,-$7F2[bp]
cmp	al,*$55
je  	.318
.319:
mov	ax,*$A
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2399   if(buffer[0x1F]!=0xAA)return 10;
.318:
! Debug: ne int = const $AA to unsigned char buffer = [S+$820-$7F3] (used reg = )
mov	al,-$7F1[bp]
cmp	al,#$AA
je  	.31A
.31B:
mov	ax,*$A
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2400   if(buffer[0x20]!=0x88)return 11;
.31A:
! Debug: ne int = const $88 to unsigned char buffer = [S+$820-$7F2] (used reg = )
mov	al,-$7F0[bp]
cmp	al,#$88
je  	.31C
.31D:
mov	ax,*$B
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2401   old_ds = set_DS(ebda_seg);
.31C:
! Debug: list unsigned short ebda_seg = [S+$820-4] (used reg = )
push	-2[bp]
! Debug: func () unsigned short = set_DS+0 (used reg = )
call	_set_DS
inc	sp
inc	sp
! Debug: eq unsigned short = ax+0 to unsigned short old_ds = [S+$820-6] (used reg = )
mov	-4[bp],ax
!BCC_EOS
! 2402   *((Bit8u *)(&((ebda_data_t *) 0)->cdemu.media)) = (buffer[0x21]);
! Debug: eq unsigned char buffer = [S+$820-$7F1] to unsigned char = [+$25B] (used reg = )
mov	al,-$7EF[bp]
mov	[$25B],al
!BCC_EOS
! 2403   if(buffer[0x21]==0){
! Debug: logeq int = const 0 to unsigned char buffer = [S+$820-$7F1] (used reg = )
mov	al,-$7EF[bp]
test	al,al
jne 	.31E
.31F:
! 2404     *((Bit8u *)(&((ebda_data_t *) 0)->cdemu.emulated_drive)) = (0xE0);
! Debug: eq int = const $E0 to unsigned char = [+$25C] (used reg = )
mov	al,#$E0
mov	[$25C],al
!BCC_EOS
! 2405   }
! 2406   else if(buffer[0x21]<4)
jmp .320
.31E:
! Debug: lt int = const 4 to unsigned char buffer = [S+$820-$7F1] (used reg = )
mov	al,-$7EF[bp]
cmp	al,*4
jae 	.321
.322:
! 2407     *((Bit8u *)(&((ebda_data_t *) 0)->cdemu.emulated_drive)) = (0x00);
! Debug: eq int = const 0 to unsigned char = [+$25C] (used reg = )
xor	al,al
mov	[$25C],al
!BCC_EOS
! 2408   else
! 2409     *((Bit8u *)(&((ebda_data_t *) 0)->cdemu.emulated_drive)) = (0x80);
jmp .323
.321:
! Debug: eq int = const $80 to unsigned char = [+$25C] (used reg = )
mov	al,#$80
mov	[$25C],al
!BCC_EOS
! 2410   *((Bit8u *)(&((ebda_data_t *) 0)->cdemu.controller_index)) = (device/2);
.323:
.320:
! Debug: div int = const 2 to unsigned char device = [S+$820-$81F] (used reg = )
mov	al,-$81D[bp]
xor	ah,ah
shr	ax,*1
! Debug: eq unsigned int = ax+0 to unsigned char = [+$25D] (used reg = )
mov	[$25D],al
!BCC_EOS
! 2411   *((Bit8u *)(&((ebda_data_t *) 0)->cdemu.device_spec)) = (de
! 2411 vice%2);
! Debug: mod int = const 2 to unsigned char device = [S+$820-$81F] (used reg = )
mov	al,-$81D[bp]
xor	ah,ah
and	al,*1
! Debug: eq unsigned char = al+0 to unsigned char = [+$25E] (used reg = )
mov	[$25E],al
!BCC_EOS
! 2412   boot_segment=*((Bit16u *)&buffer[0x22]);
! Debug: eq unsigned short buffer = [S+$820-$7F0] to unsigned short boot_segment = [S+$820-$818] (used reg = )
mov	ax,-$7EE[bp]
mov	-$816[bp],ax
!BCC_EOS
! 2413   if(boot_segment==0x0000)boot_segment=0x07C0;
! Debug: logeq int = const 0 to unsigned short boot_segment = [S+$820-$818] (used reg = )
mov	ax,-$816[bp]
test	ax,ax
jne 	.324
.325:
! Debug: eq int = const $7C0 to unsigned short boot_segment = [S+$820-$818] (used reg = )
mov	ax,#$7C0
mov	-$816[bp],ax
!BCC_EOS
! 2414   *((Bit16u *)(&((ebda_data_t *) 0)->cdemu.load_segment)) = (boot_segment);
.324:
! Debug: eq unsigned short boot_segment = [S+$820-$818] to unsigned short = [+$266] (used reg = )
mov	ax,-$816[bp]
mov	[$266],ax
!BCC_EOS
! 2415   *((Bit16u *)(&((ebda_data_t *) 0)->cdemu.buffer_segment)) = (0x0000);
! Debug: eq int = const 0 to unsigned short = [+$264] (used reg = )
xor	ax,ax
mov	[$264],ax
!BCC_EOS
! 2416   nbsectors=*((Bit16u *)&buffer[0x26]);
! Debug: eq unsigned short buffer = [S+$820-$7EC] to unsigned short nbsectors = [S+$820-$81A] (used reg = )
mov	ax,-$7EA[bp]
mov	-$818[bp],ax
!BCC_EOS
! 2417   *((Bit16u *)(&((ebda_data_t *) 0)->cdemu.sector_count)) = (nbsectors);
! Debug: eq unsigned short nbsectors = [S+$820-$81A] to unsigned short = [+$268] (used reg = )
mov	ax,-$818[bp]
mov	[$268],ax
!BCC_EOS
! 2418   lba=*((Bit32u *)&buffer[0x28]);
! Debug: eq unsigned long buffer = [S+$820-$7EA] to unsigned long lba = [S+$820-$816] (used reg = )
mov	ax,-$7E8[bp]
mov	bx,-$7E6[bp]
mov	-$814[bp],ax
mov	-$812[bp],bx
!BCC_EOS
! 2419   *((Bit32u *)(&((ebda_data_t *) 0)->cdemu.ilba)) = (lba);
! Debug: eq unsigned long lba = [S+$820-$816] to unsigned long = [+$260] (used reg = )
mov	ax,-$814[bp]
mov	bx,-$812[bp]
mov	[$260],ax
mov	[$262],bx
!BCC_EOS
! 2420   _memsetb(0,atacmd,get_SS(),12);
! Debug: list int = const $C (used reg = )
mov	ax,*$C
push	ax
! Debug: func () unsigned short = get_SS+0 (used reg = )
call	_get_SS
! Debug: list unsigned short = ax+0 (used reg = )
push	ax
! Debug: list * unsigned char atacmd = S+$824-$12 (used reg = )
lea	bx,-$10[bp]
push	bx
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: func () void = _memsetb+0 (used reg = )
call	__memsetb
add	sp,*8
!BCC_EOS
! 2421   atacmd[0]=0x28;
! Debug: eq int = const $28 to unsigned char atacmd = [S+$820-$12] (used reg = )
mov	al,*$28
mov	-$10[bp],al
!BCC_EOS
! 2422   i = 1+(nbsectors-1)/4;
! Debug: sub int = const 1 to unsigned short nbsectors = [S+$820-$81A] (used reg = )
mov	ax,-$818[bp]
! Debug: div int = const 4 to unsigned int = ax-1 (used reg = )
dec	ax
shr	ax,*1
shr	ax,*1
! Debug: add unsigned int = ax+0 to int = const 1 (used reg = )
! Debug: expression subtree swapping
! Debug: eq unsigned int = ax+1 to unsigned short i = [S+$820-$81C] (used reg = )
inc	ax
mov	-$81A[bp],ax
!BCC_EOS
! 2423   atacmd[7]=*(((Bit8u *)&i)+1);
! Debug: eq unsigned char i = [S+$820-$81B] to unsigned char atacmd = [S+$820-$B] (used reg = )
mov	al,-$819[bp]
mov	-9[bp],al
!BCC_EOS
! 2424   atacmd[8]=*((Bit8u *)&i);
! Debug: eq unsigned char i = [S+$820-$81C] to unsigned char atacmd = [S+$820-$A] (used reg = )
mov	al,-$81A[bp]
mov	-8[bp],al
!BCC_EOS
! 2425   atacmd[2]=*(((Bit8u *)&*(((Bit16u *)&lba)+1))+1);
! Debug: eq unsigned char lba = [S+$820-$813] to unsigned char atacmd = [S+$820-$10] (used reg = )
mov	al,-$811[bp]
mov	-$E[bp],al
!BCC_EOS
! 2426   atacmd[3]=*((Bit8u *)&*(((Bit16u *)&lba)+1));
! Debug: eq unsigned char lba = [S+$820-$814] to unsigned char atacmd = [S+$820-$F] (used reg = )
mov	al,-$812[bp]
mov	-$D[bp],al
!BCC_EOS
! 2427   atacmd[4]=*(((Bit8u *)&*((Bit16u *)&lba))+1);
! Debug: eq unsigned char lba = [S+$820-$815] to unsigned char atacmd = [S+$820-$E] (used reg = )
mov	al,-$813[bp]
mov	-$C[bp],al
!BCC_EOS
! 2428   atacmd[5]=*((Bit8u *)&lba);
! Debug: eq unsigned char lba = [S+$820-$816] to unsigned char atacmd = [S+$820-$D] (used reg = )
mov	al,-$814[bp]
mov	-$B[bp],al
!BCC_EOS
! 2429   if((error = ata_cmd_packet(device, 12, get_SS(), atacmd, 0, nbsectors*512L, 0x01, boot_segment,0)) != 0)
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list unsigned short boot_segment = [S+$822-$818] (used reg = )
push	-$816[bp]
! Debug: list int = const 1 (used reg = )
mov	ax,*1
push	ax
! Debug: cast unsigned long = const 0 to unsigned short nbsectors = [S+$826-$81A] (used reg = )
mov	ax,-$818[bp]
xor	bx,bx
! Debug: mul long = const $200 to unsigned long = bx+0 (used reg = )
push	bx
push	ax
mov	ax,#$200
xor	bx,bx
push	bx
push	ax
mov	ax,-$828[bp]
mov	bx,-$826[bp]
lea	di,-$82C[bp]
call	lmulul
add	sp,*8
! Debug: list unsigned long = bx+0 (used reg = )
push	bx
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list * unsigned char atacmd = S+$82C-$12 (used reg = )
lea	bx,-$10[bp]
push	bx
! Debug: func () unsigned short = get_SS+0 (used reg = )
call	_get_SS
! Debug: list unsigned short = ax+0 (used reg = )
push	ax
! Debug: list int = const $C (used reg = )
mov	ax,*$C
push	ax
! Debug: list unsigned char device = [S+$832-$81F] (used reg = )
mov	al,-$81D[bp]
xor	ah,ah
push	ax
! Debug: func () unsigned short = ata_cmd_packet+0 (used reg = )
call	_ata_cmd_packet
add	sp,*$14
! Debug: eq unsigned short = ax+0 to unsigned short error = [S+$820-$81E] (used reg = )
mov	-$81C[bp],ax
! Debug: ne int = const 0 to unsigned short = ax+0 (used reg = )
test	ax,ax
je  	.326
.327:
! 2430   {
! 2431     set_DS(old_ds);
! Debug: list unsigned short old_ds = [S+$820-6] (used reg = )
push	-4[bp]
! Debug: func () unsigned short = set_DS+0 (used reg = )
call	_set_DS
inc	sp
inc	sp
!BCC_EOS
! 2432     return 12;
mov	ax,*$C
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2433   }
! 2434   switch(*((Bit8u *)(&((ebda_data_t *) 0)->cdemu.media))) {
.326:
mov	al,[$25B]
br 	.32A
! 2435     case 0x01:
! 2436       *((Bit16u *)(&((ebda_data_t *) 0)->cdemu.vdevice.spt)) = (15);
.32B:
! Debug: eq int = const $F to unsigned short = [+$26E] (used reg = )
mov	ax,*$F
mov	[$26E],ax
!BCC_EOS
! 2437       *((Bit16u *)(&((ebda_data_t *) 0)->cdemu.vdevice.cylinders)) = (80);
! Debug: eq int = const $50 to unsigned short = [+$26C] (used reg = )
mov	ax,*$50
mov	[$26C],ax
!BCC_EOS
! 2438       *((Bit16u *)(&((ebda_data_t *) 0)->cdemu.vdevice.heads)) = (2);
! Debug: eq int = const 2 to unsigned short = [+$26A] (used reg = )
mov	ax,*2
mov	[$26A],ax
!BCC_EOS
! 2439       break;
br 	.328
!BCC_EOS
! 2440     case 0x02:
! 2441       *((Bit16u *)(&((ebda_data_t *) 0)->cdemu.vdevice.spt)) = (18);
.32C:
! Debug: eq int = const $12 to unsigned short = [+$26E] (used reg = )
mov	ax,*$12
mov	[$26E],ax
!BCC_EOS
! 2442       *((Bit16u *)(&((ebda_data_t *) 0)->cdemu.vdevice.cylinders)) = (80);
! Debug: eq int = const $50 to unsigned short = [+$26C] (used reg = )
mov	ax,*$50
mov	[$26C],ax
!BCC_EOS
! 2443       *((Bit16u *)(&((ebda_data_t *) 0)->cdemu.vdevice.heads)) = (2);
! Debug: eq int = const 2 to unsigned short = [+$26A] (used reg = )
mov	ax,*2
mov	[$26A],ax
!BCC_EOS
! 2444       break;
br 	.328
!BCC_EOS
! 2445     case 0x03:
! 2446       *((Bit16u *)(&((ebda_data_t *) 0)->cdemu.vdevice.spt)) = (36);
.32D:
! Debug: eq int = const $24 to unsigned short = [+$26E] (used reg = )
mov	ax,*$24
mov	[$26E],ax
!BCC_EOS
! 2447       *((Bit16u *)(&((ebda_data_t *) 0)->cdemu.vdevice.cylinders)) = (80);
! Debug: eq int = const $50 to unsigned short = [+$26C] (used reg = )
mov	ax,*$50
mov	[$26C],ax
!BCC_EOS
! 2448       *((Bit16u *)(&((ebda_data_t *) 0)->cdemu.vdevice.heads)) = (2);
! Debug: eq int = const 2 to unsigned short = [+$26A] (used reg = )
mov	ax,*2
mov	[$26A],ax
!BCC_EOS
! 2449       break;
jmp .328
!BCC_EOS
! 2450     case 0x04:
! 2451       *((Bit16u *)(&((ebda_data_t *) 0)->cdemu.vdevice.spt)) = (_read_byte(446+6, boot_segment)&0x3f);
.32E:
! Debug: list unsigned short boot_segment = [S+$820-$818] (used reg = )
push	-$816[bp]
! Debug: list int = const $1C4 (used reg = )
mov	ax,#$1C4
push	ax
! Debug: func () unsigned char = _read_byte+0 (used reg = )
call	__read_byte
add	sp,*4
! Debug: and int = const $3F to unsigned char = al+0 (used reg = )
and	al,*$3F
! Debug: eq unsigned char = al+0 to unsigned short = [+$26E] (used reg = )
xor	ah,ah
mov	[$26E],ax
!BCC_EOS
! 2452       *((Bit16u *)(&((ebda_data_t *) 0)->cdemu.vdevice.cylinders)) = ((_read_byte(446+6, boot_segment)<<2) + _read_byte(446+7, boot_segment) + 1);
! Debug: list unsigned short boot_segment = [S+$820-$818] (used reg = )
push	-$816[bp]
! Debug: list int = const $1C5 (used reg = )
mov	ax,#$1C5
push	ax
! Debug: func () unsigned char = _read_byte+0 (used reg = )
call	__read_byte
add	sp,*4
push	ax
! Debug: list unsigned short boot_segment = [S+$822-$818] (used reg = )
push	-$816[bp]
! Debug: list int = const $1C4 (used reg = )
mov	ax,#$1C4
push	ax
! Debug: func () unsigned char = _read_byte+0 (used reg = )
call	__read_byte
add	sp,*4
! Debug: sl int = const 2 to unsigned char = al+0 (used reg = )
xor	ah,ah
shl	ax,*1
shl	ax,*1
! Debug: add unsigned char (temp) = [S+$822-$822] to unsigned int = ax+0 (used reg = )
add	al,0+..FFF9[bp]
adc	ah,*0
inc	sp
inc	sp
! Debug: add int = const 1 to unsigned int = ax+0 (used reg = )
! Debug: eq unsigned int = ax+1 to unsigned short = [+$26C] (used reg = )
inc	ax
mov	[$26C],ax
!BCC_EOS
! 2453       *((Bit16u *)(&((ebda_data_t *) 0)->cdemu.vdevice.heads)) = (_read_byte(44
! 2453 6+5, boot_segment) + 1);
! Debug: list unsigned short boot_segment = [S+$820-$818] (used reg = )
push	-$816[bp]
! Debug: list int = const $1C3 (used reg = )
mov	ax,#$1C3
push	ax
! Debug: func () unsigned char = _read_byte+0 (used reg = )
call	__read_byte
add	sp,*4
! Debug: add int = const 1 to unsigned char = al+0 (used reg = )
xor	ah,ah
! Debug: eq unsigned int = ax+1 to unsigned short = [+$26A] (used reg = )
inc	ax
mov	[$26A],ax
!BCC_EOS
! 2454       break;
jmp .328
!BCC_EOS
! 2455    }
! 2456   if(*((Bit8u *)(&((ebda_data_t *) 0)->cdemu.media))!=0) {
jmp .328
.32A:
sub	al,*1
beq 	.32B
sub	al,*1
beq 	.32C
sub	al,*1
beq 	.32D
sub	al,*1
je 	.32E
.328:
..FFF9	=	-$820
! Debug: ne int = const 0 to unsigned char = [+$25B] (used reg = )
mov	al,[$25B]
test	al,al
je  	.32F
.330:
! 2457     if(*((Bit8u *)(&((ebda_data_t *) 0)->cdemu.emulated_drive))==0x00)
! Debug: logeq int = const 0 to unsigned char = [+$25C] (used reg = )
mov	al,[$25C]
test	al,al
jne 	.331
.332:
! 2458       _write_byte(_read_byte(0x10, 0x40)|0x41, 0x10, 0x40);
! Debug: list int = const $40 (used reg = )
mov	ax,*$40
push	ax
! Debug: list int = const $10 (used reg = )
mov	ax,*$10
push	ax
! Debug: list int = const $40 (used reg = )
mov	ax,*$40
push	ax
! Debug: list int = const $10 (used reg = )
mov	ax,*$10
push	ax
! Debug: func () unsigned char = _read_byte+0 (used reg = )
call	__read_byte
add	sp,*4
! Debug: or int = const $41 to unsigned char = al+0 (used reg = )
or	al,*$41
! Debug: list unsigned char = al+0 (used reg = )
xor	ah,ah
push	ax
! Debug: func () void = _write_byte+0 (used reg = )
call	__write_byte
add	sp,*6
!BCC_EOS
! 2459     else
! 2460       *((Bit8u *)(&((ebda_data_t *) 0)->ata.hdcount)) = (*((Bit8u *)(&((ebda_data_t *) 0)->ata.hdcount)) + 1);
jmp .333
.331:
! Debug: add int = const 1 to unsigned char = [+$232] (used reg = )
mov	al,[$232]
xor	ah,ah
! Debug: eq unsigned int = ax+1 to unsigned char = [+$232] (used reg = )
inc	ax
mov	[$232],al
!BCC_EOS
! 2461   }
.333:
! 2462   if(*((Bit8u *)(&((ebda_data_t *) 0)->cdemu.media))!=0)
.32F:
! Debug: ne int = const 0 to unsigned char = [+$25B] (used reg = )
mov	al,[$25B]
test	al,al
je  	.334
.335:
! 2463     *((Bit8u *)(&((ebda_data_t *) 0)->cdemu.active)) = (0x01);
! Debug: eq int = const 1 to unsigned char = [+$25A] (used reg = )
mov	al,*1
mov	[$25A],al
!BCC_EOS
! 2464   i = (*((Bit8u *)(&((ebda_data_t *) 0)->cdemu.emulated_drive))*0x100)+0;
.334:
! Debug: mul int = const $100 to unsigned char = [+$25C] (used reg = )
mov	al,[$25C]
xor	ah,ah
mov	cx,#$100
imul	cx
! Debug: add int = const 0 to unsigned int = ax+0 (used reg = )
! Debug: eq unsigned int = ax+0 to unsigned short i = [S+$820-$81C] (used reg = )
mov	-$81A[bp],ax
!BCC_EOS
! 2465   set_DS(old_ds);
! Debug: list unsigned short old_ds = [S+$820-6] (used reg = )
push	-4[bp]
! Debug: func () unsigned short = set_DS+0 (used reg = )
call	_set_DS
inc	sp
inc	sp
!BCC_EOS
! 2466   return i;
mov	ax,-$81A[bp]
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2467 }
! 2468 void int14_function(regs, ds, iret_addr)
! Register BX used in function cdrom_boot
! 2469   pusha_regs_t regs;
export	_int14_function
_int14_function:
!BCC_EOS
! 2470   Bit16u ds;
!BCC_EOS
! 2471   iret_addr_t iret_addr;
!BCC_EOS
! 2472 {
! 2473   Bit16u addr,timer,val16;
!BCC_EOS
! 2474   Bit8u counter;
!BCC_EOS
! 2475 #asm
push	bp
mov	bp,sp
add	sp,*-8
!BCC_EOS
!BCC_ASM
_int14_function.ds	set	$1C
.int14_function.ds	set	$14
_int14_function.counter	set	1
.int14_function.counter	set	-7
_int14_function.timer	set	4
.int14_function.timer	set	-4
_int14_function.iret_addr	set	$1E
.int14_function.iret_addr	set	$16
_int14_function.addr	set	6
.int14_function.addr	set	-2
_int14_function.val16	set	2
.int14_function.val16	set	-6
_int14_function.regs	set	$C
.int14_function.regs	set	4
  sti
! 2477 endasm
!BCC_ENDASM
!BCC_EOS
! 2478   addr = *((Bit16u *)(0x400 + (regs.u.r16.dx << 1)));
! Debug: sl int = const 1 to unsigned short regs = [S+$A+$C] (used reg = )
mov	ax,$E[bp]
shl	ax,*1
! Debug: add unsigned int = ax+0 to int = const $400 (used reg = )
! Debug: expression subtree swapping
! Debug: cast * unsigned short = const 0 to unsigned int = ax+$400 (used reg = )
mov	bx,ax
! Debug: eq unsigned short = [bx+$400] to unsigned short addr = [S+$A-4] (used reg = )
mov	bx,$400[bx]
mov	-2[bp],bx
!BCC_EOS
! 2479   counter = *((Bit8u *)(0x047C + regs.u.r16.dx));
! Debug: add unsigned short regs = [S+$A+$C] to int = const $47C (used reg = )
! Debug: expression subtree swapping
mov	ax,$E[bp]
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$47C (used reg = )
mov	bx,ax
! Debug: eq unsigned char = [bx+$47C] to unsigned char counter = [S+$A-9] (used reg = )
mov	al,$47C[bx]
mov	-7[bp],al
!BCC_EOS
! 2480   if ((regs.u.r16.dx < 4) && (addr > 0)) {
! Debug: lt int = const 4 to unsigned short regs = [S+$A+$C] (used reg = )
mov	ax,$E[bp]
cmp	ax,*4
bhis	.336
.338:
! Debug: gt int = const 0 to unsigned short addr = [S+$A-4] (used reg = )
mov	ax,-2[bp]
test	ax,ax
beq 	.336
.337:
! 2481     switch (regs.u.r8.ah) {
mov	al,$13[bp]
br 	.33B
! 2482       case 0:
! 2483         outb(addr+3, inb(addr+3) | 0x80);
.33C:
! Debug: add int = const 3 to unsigned short addr = [S+$A-4] (used reg = )
mov	ax,-2[bp]
! Debug: list unsigned int = ax+3 (used reg = )
add	ax,*3
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: or int = const $80 to unsigned char = al+0 (used reg = )
or	al,#$80
! Debug: list unsigned char = al+0 (used reg = )
xor	ah,ah
push	ax
! Debug: add int = const 3 to unsigned short addr = [S+$C-4] (used reg = )
mov	ax,-2[bp]
! Debug: list unsigned int = ax+3 (used reg = )
add	ax,*3
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 2484         if (regs.u.r8.al & 0xE0 == 0) {
! Debug: and int = const 0 to unsigned char regs = [S+$A+$10] (used reg = )
mov	al,$12[bp]
xor	al,al
test	al,al
je  	.33D
.33E:
! 2485           outb(addr, 0x17);
! Debug: list int = const $17 (used reg = )
mov	ax,*$17
push	ax
! Debug: list unsigned short addr = [S+$C-4] (used reg = )
push	-2[bp]
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 2486           outb(addr+1, 0x04);
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: add int = const 1 to unsigned short addr = [S+$C-4] (used reg = )
mov	ax,-2[bp]
! Debug: list unsigned int = ax+1 (used reg = )
inc	ax
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 2487         } else {
jmp .33F
.33D:
! 2488           val16 = 0x600 >> ((regs.u.r8.al & 0xE0) >> 5);
! Debug: and int = const $E0 to unsigned char regs = [S+$A+$10] (used reg = )
mov	al,$12[bp]
and	al,#$E0
! Debug: sr int = const 5 to unsigned char = al+0 (used reg = )
xor	ah,ah
mov	cl,*5
shr	ax,cl
! Debug: sr unsigned int = ax+0 to int = const $600 (used reg = )
mov	bx,ax
mov	ax,#$600
mov	cx,bx
sar	ax,cl
! Debug: eq int = ax+0 to unsigned short val16 = [S+$A-8] (used reg = )
mov	-6[bp],ax
!BCC_EOS
! 2489           outb(addr, val16 & 0xFF);
! Debug: and int = const $FF to unsigned short val16 = [S+$A-8] (used reg = )
mov	al,-6[bp]
! Debug: list unsigned char = al+0 (used reg = )
xor	ah,ah
push	ax
! Debug: list unsigned short addr = [S+$C-4] (used reg = )
push	-2[bp]
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 2490           outb(addr+1, *(((Bit8u *)&val16)+1));
! Debug: list unsigned char val16 = [S+$A-7] (used reg = )
mov	al,-5[bp]
xor	ah,ah
push	ax
! Debug: add int = const 1 to unsigned short addr = [S+$C-4] (used reg = )
mov	ax,-2[bp]
! Debug: list unsigned int = ax+1 (used reg = )
inc	ax
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 2491         }
! 2492         outb(addr+3, regs.u.r8.al & 0x1F);
.33F:
! Debug: and int = const $1F to unsigned char regs = [S+$A+$10] (used reg = )
mov	al,$12[bp]
and	al,*$1F
! Debug: list unsigned char = al+0 (used reg = )
xor	ah,ah
push	ax
! Debug: add int = const 3 to unsigned short addr = [S+$C-4] (used reg = )
mov	ax,-2[bp]
! Debug: list unsigned int = ax+3 (used reg = )
add	ax,*3
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 2493         regs.u.r8.ah = inb(addr+5);
! Debug: add int = const 5 to unsigned short addr = [S+$A-4] (used reg = )
mov	ax,-2[bp]
! Debug: list unsigned int = ax+5 (used reg = )
add	ax,*5
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char regs = [S+$A+$11] (used reg = )
mov	$13[bp],al
!BCC_EOS
! 2494         regs.u.r8.al = inb(addr+6);
! Debug: add int = const 6 to unsigned short addr = [S+$A-4] (used reg = )
mov	ax,-2[bp]
! Debug: list unsigned int = ax+6 (used reg = )
add	ax,*6
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char regs = [S+$A+$10] (used reg = )
mov	$12[bp],al
!BCC_EOS
! 2495         iret_addr.flags.u.r8.flagsl &= 0xfe;
! Debug: andab int = const $FE to unsigned char iret_addr = [S+$A+$18] (used reg = )
mov	al,$1A[bp]
and	al,#$FE
mov	$1A[bp],al
!BCC_EOS
! 2496         break;
br 	.339
!BCC_EOS
! 2497       case 1:
! 2498         timer = *((Bit16u *)(0x046C));
.340:
! Debug: eq unsigned short = [+$46C] to unsigned short timer = [S+$A-6] (used reg = )
mov	ax,[$46C]
mov	-4[bp],ax
!BCC_EOS
! 2499         while (((inb(addr+5) & 0x60) != 0x60) && (counter)) {
jmp .342
.343:
! 2500           val16 = *((Bit16u *)(0x046C));
! Debug: eq unsigned short = [+$46C] to unsigned short val16 = [S+$A-8] (used reg = )
mov	ax,[$46C]
mov	-6[bp],ax
!BCC_EOS
! 2501           if (val16 != timer) {
! Debug: ne unsigned short timer = [S+$A-6] to unsigned short val16 = [S+$A-8] (used reg = )
mov	ax,-6[bp]
cmp	ax,-4[bp]
je  	.344
.345:
! 2502             timer = val16;
! Debug: eq unsigned short val16 = [S+$A-8] to unsigned short timer = [S+$A-6] (used reg = )
mov	ax,-6[bp]
mov	-4[bp],ax
!BCC_EOS
! 2503             counter--;
! Debug: postdec unsigned char counter = [S+$A-9] (used reg = )
mov	al,-7[bp]
dec	ax
mov	-7[bp],al
!BCC_EOS
! 2504           }
! 2505         }
.344:
! 2506         if (counter > 0) {
.342:
! Debug: add int = const 5 to unsigned short addr = [S+$A-4] (used reg = )
mov	ax,-2[bp]
! Debug: list unsigned int = ax+5 (used reg = )
add	ax,*5
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: and int = const $60 to unsigned char = al+0 (used reg = )
and	al,*$60
! Debug: ne int = const $60 to unsigned char = al+0 (used reg = )
cmp	al,*$60
je  	.346
.347:
mov	al,-7[bp]
test	al,al
jne	.343
.346:
.341:
! Debug: gt int = const 0 to unsigned char counter = [S+$A-9] (used reg = )
mov	al,-7[bp]
test	al,al
je  	.348
.349:
! 2507           outb(addr, regs.u.r8.al);
! Debug: list unsigned char regs = [S+$A+$10] (used reg = )
mov	al,$12[bp]
xor	ah,ah
push	ax
! Debug: list unsigned short addr = [S+$C-4] (used reg = )
push	-2[bp]
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 2508           regs.u.r8.ah = inb(addr+5);
! Debug: add int = const 5 to unsigned short addr = [S+$A-4] (used reg = )
mov	ax,-2[bp]
! Debug: list unsigned int = ax+5 (used reg = )
add	ax,*5
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char regs = [S+$A+$11] (used reg = )
mov	$13[bp],al
!BCC_EOS
! 2509         } else {
jmp .34A
.348:
! 2510           regs.u.r8.ah = 0x80;
! Debug: eq int = const $80 to unsigned char regs = [S+$A+$11] (used reg = )
mov	al,#$80
mov	$13[bp],al
!BCC_EOS
! 2511         }
! 2512         iret_addr.flags.u.r8.flagsl &= 0xfe;
.34A:
! Debug: andab int = const $FE to unsigned char iret_addr = [S+$A+$18] (used reg = )
mov	al,$1A[bp]
and	al,#$FE
mov	$1A[bp],al
!BCC_EOS
! 2513         break;
br 	.339
!BCC_EOS
! 2514       case 2:
! 2515         timer = *((Bit16u *)(0x046C));
.34B:
! Debug: eq unsigned short = [+$46C] to unsigned short timer = [S+$A-6] (used reg = )
mov	ax,[$46C]
mov	-4[bp],ax
!BCC_EOS
! 2516         while (((inb(addr+5) & 0x01) == 0) && (counter)) {
jmp .34D
.34E:
! 2517           val16 = *((Bit16u *)(0x046C
! 2517 ));
! Debug: eq unsigned short = [+$46C] to unsigned short val16 = [S+$A-8] (used reg = )
mov	ax,[$46C]
mov	-6[bp],ax
!BCC_EOS
! 2518           if (val16 != timer) {
! Debug: ne unsigned short timer = [S+$A-6] to unsigned short val16 = [S+$A-8] (used reg = )
mov	ax,-6[bp]
cmp	ax,-4[bp]
je  	.34F
.350:
! 2519             timer = val16;
! Debug: eq unsigned short val16 = [S+$A-8] to unsigned short timer = [S+$A-6] (used reg = )
mov	ax,-6[bp]
mov	-4[bp],ax
!BCC_EOS
! 2520             counter--;
! Debug: postdec unsigned char counter = [S+$A-9] (used reg = )
mov	al,-7[bp]
dec	ax
mov	-7[bp],al
!BCC_EOS
! 2521           }
! 2522         }
.34F:
! 2523         if (counter > 0) {
.34D:
! Debug: add int = const 5 to unsigned short addr = [S+$A-4] (used reg = )
mov	ax,-2[bp]
! Debug: list unsigned int = ax+5 (used reg = )
add	ax,*5
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: and int = const 1 to unsigned char = al+0 (used reg = )
and	al,*1
! Debug: logeq int = const 0 to unsigned char = al+0 (used reg = )
test	al,al
jne 	.351
.352:
mov	al,-7[bp]
test	al,al
jne	.34E
.351:
.34C:
! Debug: gt int = const 0 to unsigned char counter = [S+$A-9] (used reg = )
mov	al,-7[bp]
test	al,al
je  	.353
.354:
! 2524           regs.u.r8.ah = inb(addr+5);
! Debug: add int = const 5 to unsigned short addr = [S+$A-4] (used reg = )
mov	ax,-2[bp]
! Debug: list unsigned int = ax+5 (used reg = )
add	ax,*5
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char regs = [S+$A+$11] (used reg = )
mov	$13[bp],al
!BCC_EOS
! 2525           regs.u.r8.al = inb(addr);
! Debug: list unsigned short addr = [S+$A-4] (used reg = )
push	-2[bp]
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char regs = [S+$A+$10] (used reg = )
mov	$12[bp],al
!BCC_EOS
! 2526         } else {
jmp .355
.353:
! 2527           regs.u.r8.ah = 0x80;
! Debug: eq int = const $80 to unsigned char regs = [S+$A+$11] (used reg = )
mov	al,#$80
mov	$13[bp],al
!BCC_EOS
! 2528         }
! 2529         iret_addr.flags.u.r8.flagsl &= 0xfe;
.355:
! Debug: andab int = const $FE to unsigned char iret_addr = [S+$A+$18] (used reg = )
mov	al,$1A[bp]
and	al,#$FE
mov	$1A[bp],al
!BCC_EOS
! 2530         break;
jmp .339
!BCC_EOS
! 2531       case 3:
! 2532         regs.u.r8.ah = inb(addr+5);
.356:
! Debug: add int = const 5 to unsigned short addr = [S+$A-4] (used reg = )
mov	ax,-2[bp]
! Debug: list unsigned int = ax+5 (used reg = )
add	ax,*5
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char regs = [S+$A+$11] (used reg = )
mov	$13[bp],al
!BCC_EOS
! 2533         regs.u.r8.al = inb(addr+6);
! Debug: add int = const 6 to unsigned short addr = [S+$A-4] (used reg = )
mov	ax,-2[bp]
! Debug: list unsigned int = ax+6 (used reg = )
add	ax,*6
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char regs = [S+$A+$10] (used reg = )
mov	$12[bp],al
!BCC_EOS
! 2534         iret_addr.flags.u.r8.flagsl &= 0xfe;
! Debug: andab int = const $FE to unsigned char iret_addr = [S+$A+$18] (used reg = )
mov	al,$1A[bp]
and	al,#$FE
mov	$1A[bp],al
!BCC_EOS
! 2535         break;
jmp .339
!BCC_EOS
! 2536       default:
! 2537         iret_addr.flags.u.r8.flagsl |= 0x01;
.357:
! Debug: orab int = const 1 to unsigned char iret_addr = [S+$A+$18] (used reg = )
mov	al,$1A[bp]
or	al,*1
mov	$1A[bp],al
!BCC_EOS
! 2538       }
! 2539   } else {
jmp .339
.33B:
sub	al,*0
beq 	.33C
sub	al,*1
beq 	.340
sub	al,*1
beq 	.34B
sub	al,*1
je 	.356
jmp	.357
.339:
..FFF8	=	-$A
jmp .358
.336:
! 2540     iret_addr.flags.u.r8.flagsl |= 0x01;
! Debug: orab int = const 1 to unsigned char iret_addr = [S+$A+$18] (used reg = )
mov	al,$1A[bp]
or	al,*1
mov	$1A[bp],al
!BCC_EOS
! 2541   }
! 2542 }
.358:
mov	sp,bp
pop	bp
ret
! 2543   void
! Register BX used in function int14_function
! 2544 int15_function(regs, ES, DS, FLAGS)
! 2545   pusha_regs_t regs;
export	_int15_function
_int15_function:
!BCC_EOS
! 2546   Bit16u ES, DS, FLAGS;
!BCC_EOS
! 2547 {
! 2548   Bit16u ebda_seg=get_ebda_seg();
push	bp
mov	bp,sp
dec	sp
dec	sp
! Debug: func () unsigned short = get_ebda_seg+0 (used reg = )
call	_get_ebda_seg
! Debug: eq unsigned short = ax+0 to unsigned short ebda_seg = [S+4-4] (used reg = )
mov	-2[bp],ax
!BCC_EOS
! 2549   bx_bool prev_a20_enable;
!BCC_EOS
! 2550   Bit16u base15_00;
!BCC_EOS
! 2551   Bit8u base23_16;
!BCC_EOS
! 2552   Bit16u ss;
!BCC_EOS
! 2553   Bit16u BX,CX,DX;
!BCC_EOS
! 2554   Bit16u bRegister;
!BCC_EOS
! 2555   Bit8u irqDisable;
!BCC_EOS
! 2556 ;
add	sp,*-$12
!BCC_EOS
! 2557   switch (regs.u.r8.ah) {
mov	al,$13[bp]
br 	.35B
! 2558     case 0x24:
! 2559       switch (regs.u.r8.al) {
.35C:
mov	al,$12[bp]
jmp .35F
! 2560         case 0x00:
! 2561         case 0x01:
.360:
! 2562           set_enable_a20(regs.u.r8.al);
.361:
! Debug: list unsigned char regs = [S+$16+$10] (used reg = )
mov	al,$12[bp]
xor	ah,ah
push	ax
! Debug: func () unsigned short = set_enable_a20+0 (used reg = )
call	_set_enable_a20
inc	sp
inc	sp
!BCC_EOS
! 2563           FLAGS &= 0xfffe;
! Debug: andab unsigned int = const $FFFE to unsigned short FLAGS = [S+$16+$16] (used reg = )
mov	ax,$18[bp]
and	al,#$FE
mov	$18[bp],ax
!BCC_EOS
! 2564           regs.u.r8.ah = 0;
! Debug: eq int = const 0 to unsigned char regs = [S+$16+$11] (used reg = )
xor	al,al
mov	$13[bp],al
!BCC_EOS
! 2565           break;
jmp .35D
!BCC_EOS
! 2566         case 0x02:
! 2567           regs.u.r8.al = (inb(0x0092) >> 1) & 0x01;
.362:
! Debug: list int = const $92 (used reg = )
mov	ax,#$92
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: sr int = const 1 to unsigned char = al+0 (used reg = )
xor	ah,ah
shr	ax,*1
! Debug: and int = const 1 to unsigned int = ax+0 (used reg = )
and	al,*1
! Debug: eq unsigned char = al+0 to unsigned char regs = [S+$16+$10] (used reg = )
mov	$12[bp],al
!BCC_EOS
! 2568           FLAGS &= 0xfffe;
! Debug: andab unsigned int = const $FFFE to unsigned short FLAGS = [S+$16+$16] (used reg = )
mov	ax,$18[bp]
and	al,#$FE
mov	$18[bp],ax
!BCC_EOS
! 2569           regs.u.r8.ah = 0;
! Debug: eq int = const 0 to unsigned char regs = [S+$16+$11] (used reg = )
xor	al,al
mov	$13[bp],al
!BCC_EOS
! 2570           break;
jmp .35D
!BCC_EOS
! 2571         case 0x03:
! 2572           FLAGS &= 0xfffe;
.363:
! Debug: andab unsigned int = const $FFFE to unsigned short FLAGS = [S+$16+$16] (used reg = )
mov	ax,$18[bp]
and	al,#$FE
mov	$18[bp],ax
!BCC_EOS
! 2573           regs.u.r8.ah = 0;
! Debug: eq int = const 0 to unsigned char regs = [S+$16+$11] (used reg = )
xor	al,al
mov	$13[bp],al
!BCC_EOS
! 2574           regs.u.r16.bx = 3;
! Debug: eq int = const 3 to unsigned short regs = [S+$16+$A] (used reg = )
mov	ax,*3
mov	$C[bp],ax
!BCC_EOS
! 2575           break;
jmp .35D
!BCC_EOS
! 2576         default:
! 2577           bios_printf(4, "int15: Func 24h, subfunc %02xh, A20 gate control not supported\n", (unsigned) regs.u.r8.al);
.364:
! Debug: list unsigned char regs = [S+$16+$10] (used reg = )
mov	al,$12[bp]
xor	ah,ah
push	ax
! Debug: list * char = .365+0 (used reg = )
mov	bx,#.365
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*6
!BCC_EOS
! 2578           FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$16+$16] (used reg = )
mov	ax,$18[bp]
or	al,*1
mov	$18[bp],ax
!BCC_EOS
! 2579           regs.u.r8.ah = 0x86;
! Debug: eq int = const $86 to unsigned char regs = [S+$16+$11] (used reg = )
mov	al,#$86
mov	$13[bp],al
!BCC_EOS
! 2580       }
! 2581       break;
jmp .35D
.35F:
sub	al,*0
je 	.360
sub	al,*1
je 	.361
sub	al,*1
je 	.362
sub	al,*1
je 	.363
jmp	.364
.35D:
br 	.359
!BCC_EOS
! 2582     case 0x41:
! 2583       FLAGS |= 0x0001;
.366:
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$16+$16] (used reg = )
mov	ax,$18[bp]
or	al,*1
mov	$18[bp],ax
!BCC_EOS
! 2584       regs.u.r8.ah = 0x86;
! Debug: eq int = const $86 to unsigned char regs = [S+$16+$11] (used reg = )
mov	al,#$86
mov	$13[bp],al
!BCC_EOS
! 2585       break;
br 	.359
!BCC_EOS
! 2586     case 0x4f:
! 2587       FLAGS |= 0x0001;
.367:
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$16+$16] (used reg = )
mov	ax,$18[bp]
or	al,*1
mov	$18[bp],ax
!BCC_EOS
! 2588       break;
br 	.359
!BCC_EOS
! 2589     case 0x52:
! 2590       FLAGS &= 0xfffe;
.368:
! Debug: andab unsigned int = const $FFFE to unsigned short FLAGS = [S+$16+$16] (used reg = )
mov	ax,$18[bp]
and	al,#$FE
mov	$18[bp],ax
!BCC_EOS
! 2591       regs.u.r8.ah = 0;
! Debug: eq int = const 0 to unsigned char regs = [S+$16+$11] (used reg = )
xor	al,al
mov	$13[bp],al
!BCC_EOS
! 2592       break;
br 	.359
!BCC_EOS
! 2593     case 0x83: {
.369:
! 2594       set_DS(0x40);
! Debug: list int = const $40 (used reg = )
mov	ax,*$40
push	ax
! Debug: func () unsigned short = set_DS+0 (used reg = )
call	_set_DS
inc	sp
inc	sp
!BCC_EOS
! 2595       if( regs.u.r8.al == 0 ) {
! Debug: logeq int = const 0 to unsigned char regs = [S+$16+$10] (used reg = )
mov	al,$12[bp]
test	al,al
jne 	.36A
.36B:
! 2596         if( ( *((Bit8u *)(0xA0)) & 1 ) == 0 ) {
! Debug: and int = const 1 to unsigned char = [+$A0] (used reg = )
mov	al,[$A0]
and	al,*1
! Debug: logeq int = const 0 to unsigned char = al+0 (used reg = )
test	al,al
jne 	.36C
.36D:
! 2597           *((Bit8u *)(0xA0)) = (1);
! Debug: eq int = const 1 to unsigned char = [+$A0] (used reg = )
mov	al,*1
mov	[$A0],al
!BCC_EOS
! 2598           *((Bit16u *)(0x98)) = (ES);
! Debug: eq unsigned short ES = [S+$16+$12] to unsigned short = [+$98] (used reg = )
mov	ax,$14[bp]
mov	[$98],ax
!BCC_EOS
! 2599           *((Bit16u *)(0x9A)) = (regs.u.r16.bx);
! Debug: eq unsigned short regs = [S+$16+$A] to unsigned short = [+$9A] (used reg = )
mov	ax,$C[bp]
mov	[$9A],ax
!BCC_EOS
! 2600           *((Bit16u *)(0x9C)) = (regs.u.r1
! 2600 6.dx);
! Debug: eq unsigned short regs = [S+$16+$C] to unsigned short = [+$9C] (used reg = )
mov	ax,$E[bp]
mov	[$9C],ax
!BCC_EOS
! 2601           *((Bit16u *)(0x9E)) = (regs.u.r16.cx);
! Debug: eq unsigned short regs = [S+$16+$E] to unsigned short = [+$9E] (used reg = )
mov	ax,$10[bp]
mov	[$9E],ax
!BCC_EOS
! 2602           FLAGS &= 0xfffe;
! Debug: andab unsigned int = const $FFFE to unsigned short FLAGS = [S+$16+$16] (used reg = )
mov	ax,$18[bp]
and	al,#$FE
mov	$18[bp],ax
!BCC_EOS
! 2603           irqDisable = inb( 0x00a1 );
! Debug: list int = const $A1 (used reg = )
mov	ax,#$A1
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char irqDisable = [S+$16-$15] (used reg = )
mov	-$13[bp],al
!BCC_EOS
! 2604           outb( 0x00a1, irqDisable & 0xFE );
! Debug: and int = const $FE to unsigned char irqDisable = [S+$16-$15] (used reg = )
mov	al,-$13[bp]
and	al,#$FE
! Debug: list unsigned char = al+0 (used reg = )
xor	ah,ah
push	ax
! Debug: list int = const $A1 (used reg = )
mov	ax,#$A1
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 2605           bRegister = inb_cmos( 0xB );
! Debug: list int = const $B (used reg = )
mov	ax,*$B
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned short bRegister = [S+$16-$14] (used reg = )
xor	ah,ah
mov	-$12[bp],ax
!BCC_EOS
! 2606           outb_cmos( 0xB, bRegister | 0x40 );
! Debug: or int = const $40 to unsigned short bRegister = [S+$16-$14] (used reg = )
mov	ax,-$12[bp]
or	al,*$40
! Debug: list unsigned int = ax+0 (used reg = )
push	ax
! Debug: list int = const $B (used reg = )
mov	ax,*$B
push	ax
! Debug: func () void = outb_cmos+0 (used reg = )
call	_outb_cmos
add	sp,*4
!BCC_EOS
! 2607         } else {
jmp .36E
.36C:
! 2608           ;
!BCC_EOS
! 2609           FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$16+$16] (used reg = )
mov	ax,$18[bp]
or	al,*1
mov	$18[bp],ax
!BCC_EOS
! 2610           regs.u.r8.ah = 0x86;
! Debug: eq int = const $86 to unsigned char regs = [S+$16+$11] (used reg = )
mov	al,#$86
mov	$13[bp],al
!BCC_EOS
! 2611         }
! 2612       } else if( regs.u.r8.al == 1 ) {
.36E:
jmp .36F
.36A:
! Debug: logeq int = const 1 to unsigned char regs = [S+$16+$10] (used reg = )
mov	al,$12[bp]
cmp	al,*1
jne 	.370
.371:
! 2613         *((Bit8u *)(0xA0)) = (0);
! Debug: eq int = const 0 to unsigned char = [+$A0] (used reg = )
xor	al,al
mov	[$A0],al
!BCC_EOS
! 2614         FLAGS &= 0xfffe;
! Debug: andab unsigned int = const $FFFE to unsigned short FLAGS = [S+$16+$16] (used reg = )
mov	ax,$18[bp]
and	al,#$FE
mov	$18[bp],ax
!BCC_EOS
! 2615         bRegister = inb_cmos( 0xB );
! Debug: list int = const $B (used reg = )
mov	ax,*$B
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned short bRegister = [S+$16-$14] (used reg = )
xor	ah,ah
mov	-$12[bp],ax
!BCC_EOS
! 2616         outb_cmos( 0xB, bRegister & ~0x40 );
! Debug: and int = const -$41 to unsigned short bRegister = [S+$16-$14] (used reg = )
mov	ax,-$12[bp]
and	al,#$BF
! Debug: list unsigned int = ax+0 (used reg = )
push	ax
! Debug: list int = const $B (used reg = )
mov	ax,*$B
push	ax
! Debug: func () void = outb_cmos+0 (used reg = )
call	_outb_cmos
add	sp,*4
!BCC_EOS
! 2617       } else {
jmp .372
.370:
! 2618         ;
!BCC_EOS
! 2619         FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$16+$16] (used reg = )
mov	ax,$18[bp]
or	al,*1
mov	$18[bp],ax
!BCC_EOS
! 2620         regs.u.r8.ah = 0x86;
! Debug: eq int = const $86 to unsigned char regs = [S+$16+$11] (used reg = )
mov	al,#$86
mov	$13[bp],al
!BCC_EOS
! 2621         regs.u.r8.al--;
! Debug: postdec unsigned char regs = [S+$16+$10] (used reg = )
mov	al,$12[bp]
dec	ax
mov	$12[bp],al
!BCC_EOS
! 2622       }
! 2623       break;
.372:
.36F:
br 	.359
!BCC_EOS
! 2624     }
! 2625     case 0x87:
! 2626 #asm
.373:
!BCC_EOS
!BCC_ASM
_int15_function.CX	set	6
.int15_function.CX	set	-$E
_int15_function.FLAGS	set	$2C
.int15_function.FLAGS	set	$18
_int15_function.irqDisable	set	1
.int15_function.irqDisable	set	-$13
_int15_function.DS	set	$2A
.int15_function.DS	set	$16
_int15_function.DX	set	4
.int15_function.DX	set	-$10
_int15_function.base23_16	set	$D
.int15_function.base23_16	set	-7
_int15_function.bRegister	set	2
.int15_function.bRegister	set	-$12
_int15_function.ES	set	$28
.int15_function.ES	set	$14
_int15_function.ebda_seg	set	$12
.int15_function.ebda_seg	set	-2
_int15_function.base15_00	set	$E
.int15_function.base15_00	set	-6
_int15_function.ss	set	$A
.int15_function.ss	set	-$A
_int15_function.BX	set	8
.int15_function.BX	set	-$C
_int15_function.regs	set	$18
.int15_function.regs	set	4
_int15_function.prev_a20_enable	set	$10
.int15_function.prev_a20_enable	set	-4
  cli
! 2628 endasm
!BCC_ENDASM
!BCC_EOS
! 2629       prev_a20_enable = set_enable_a20(1);
! Debug: list int = const 1 (used reg = )
mov	ax,*1
push	ax
! Debug: func () unsigned short = set_enable_a20+0 (used reg = )
call	_set_enable_a20
inc	sp
inc	sp
! Debug: eq unsigned short = ax+0 to unsigned short prev_a20_enable = [S+$16-6] (used reg = )
mov	-4[bp],ax
!BCC_EOS
! 2630       base15_00 = (ES << 4) + regs.u.r16.si;
! Debug: sl int = const 4 to unsigned short ES = [S+$16+$12] (used reg = )
mov	ax,$14[bp]
mov	cl,*4
shl	ax,cl
! Debug: add unsigned short regs = [S+$16+4] to unsigned int = ax+0 (used reg = )
add	ax,6[bp]
! Debug: eq unsigned int = ax+0 to unsigned short base15_00 = [S+$16-8] (used reg = )
mov	-6[bp],ax
!BCC_EOS
! 2631       base23_16 = ES >> 12;
! Debug: sr int = const $C to unsigned short ES = [S+$16+$12] (used reg = )
mov	ax,$14[bp]
mov	al,ah
xor	ah,ah
mov	cl,*4
shr	ax,cl
! Debug: eq unsigned int = ax+0 to unsigned char base23_16 = [S+$16-9] (used reg = )
mov	-7[bp],al
!BCC_EOS
! 2632       if (base15_00 < (ES<<4))
! Debug: sl int = const 4 to unsigned short ES = [S+$16+$12] (used reg = )
mov	ax,$14[bp]
mov	cl,*4
shl	ax,cl
! Debug: lt unsigned int = ax+0 to unsigned short base15_00 = [S+$16-8] (used reg = )
cmp	ax,-6[bp]
jbe 	.374
.375:
! 2633         base23_16++;
! Debug: postinc unsigned char base23_16 = [S+$16-9] (used reg = )
mov	al,-7[bp]
inc	ax
mov	-7[bp],al
!BCC_EOS
! 2634       set_DS(ES);
.374:
! Debug: list unsigned short ES = [S+$16+$12] (used reg = )
push	$14[bp]
! Debug: func () unsigned short = set_DS+0 (used reg = )
call	_set_DS
inc	sp
inc	sp
!BCC_EOS
! 2635       *((Bit16u *)(regs.u.r16.si+0x08+0)) = (47);
! Debug: add int = const 8 to unsigned short regs = [S+$16+4] (used reg = )
mov	ax,6[bp]
! Debug: add int = const 0 to unsigned int = ax+8 (used reg = )
! Debug: cast * unsigned short = const 0 to unsigned int = ax+8 (used reg = )
mov	bx,ax
! Debug: eq int = const $2F to unsigned short = [bx+8] (used reg = )
mov	ax,*$2F
mov	8[bx],ax
!BCC_EOS
! 2636       *((Bit16u *)(regs.u.r16.si+0x08+2)) = (base15_00);
! Debug: add int = const 8 to unsigned short regs = [S+$16+4] (used reg = )
mov	ax,6[bp]
! Debug: add int = const 2 to unsigned int = ax+8 (used reg = )
! Debug: cast * unsigned short = const 0 to unsigned int = ax+$A (used reg = )
mov	bx,ax
! Debug: eq unsigned short base15_00 = [S+$16-8] to unsigned short = [bx+$A] (used reg = )
mov	ax,-6[bp]
mov	$A[bx],ax
!BCC_EOS
! 2637       *((Bit8u *)(regs.u.r16.si+0x08+4)) = (base23_16);
! Debug: add int = const 8 to unsigned short regs = [S+$16+4] (used reg = )
mov	ax,6[bp]
! Debug: add int = const 4 to unsigned int = ax+8 (used reg = )
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$C (used reg = )
mov	bx,ax
! Debug: eq unsigned char base23_16 = [S+$16-9] to unsigned char = [bx+$C] (used reg = )
mov	al,-7[bp]
mov	$C[bx],al
!BCC_EOS
! 2638       *((Bit8u *)(regs.u.r16.si+0x08+5)) = (0x93);
! Debug: add int = const 8 to unsigned short regs = [S+$16+4] (used reg = )
mov	ax,6[bp]
! Debug: add int = const 5 to unsigned int = ax+8 (used reg = )
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$D (used reg = )
mov	bx,ax
! Debug: eq int = const $93 to unsigned char = [bx+$D] (used reg = )
mov	al,#$93
mov	$D[bx],al
!BCC_EOS
! 2639       *((Bit16u *)(regs.u.r16.si+0x08+6)) = (0x0000);
! Debug: add int = const 8 to unsigned short regs = [S+$16+4] (used reg = )
mov	ax,6[bp]
! Debug: add int = const 6 to unsigned int = ax+8 (used reg = )
! Debug: cast * unsigned short = const 0 to unsigned int = ax+$E (used reg = )
mov	bx,ax
! Debug: eq int = const 0 to unsigned short = [bx+$E] (used reg = )
xor	ax,ax
mov	$E[bx],ax
!BCC_EOS
! 2640       *((Bit16u *)(regs.u.r16.si+0x20+0)) = (0xffff);
! Debug: add int = const $20 to unsigned short regs = [S+$16+4] (used reg = )
mov	ax,6[bp]
! Debug: add int = const 0 to unsigned int = ax+$20 (used reg = )
! Debug: cast * unsigned short = const 0 to unsigned int = ax+$20 (used reg = )
mov	bx,ax
! Debug: eq unsigned int = const $FFFF to unsigned short = [bx+$20] (used reg = )
mov	ax,#$FFFF
mov	$20[bx],ax
!BCC_EOS
! 2641       *((Bit16u *)(regs.u.r16.si+0x20+2)) = (0x0000);
! Debug: add int = const $20 to unsigned short regs = [S+$16+4] (used reg = )
mov	ax,6[bp]
! Debug: add int = const 2 to unsigned int = ax+$20 (used reg = )
! Debug: cast * unsigned short = const 0 to unsigned int = ax+$22 (used reg = )
mov	bx,ax
! Debug: eq int = const 0 to unsigned short = [bx+$22] (used reg = )
xor	ax,ax
mov	$22[bx],ax
!BCC_EOS
! 2642       *((Bit8u *)(regs.u.r16.si+0x20+4)) = (0x000f);
! Debug: add int = const $20 to unsigned short regs = [S+$16+4] (used reg = )
mov	ax,6[bp]
! Debug: add int = const 4 to unsigned int = ax+$20 (used reg = )
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$24 (used reg = )
mov	bx,ax
! Debug: eq int = const $F to unsigned char = [bx+$24] (used reg = )
mov	al,*$F
mov	$24[bx],al
!BCC_EOS
! 2643       *((Bit8u *)(regs.u.r16.si+0x20+5)) = (0x9b);
! Debug: add int = const $20 to unsigned short regs = [S+$16+4] (used reg = )
mov	ax,6[bp]
! Debug: add int = const 5 to unsigned int = ax+$20 (used reg = )
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$25 (used reg = )
mov	bx,ax
! Debug: eq int = const $9B to unsigned char = [bx+$25] (used reg = )
mov	al,#$9B
mov	$25[bx],al
!BCC_EOS
! 2644       *((Bit16u *)(regs.u.r16.si+0x20+6)) = (0x0000);
! Debug: add int = const $20 to unsigned short regs = [S+$16+4] (used reg = )
mov	ax,6[bp]
! Debug: add int = const 6 to unsigned int = ax+$20 (used reg = )
! Debug: cast * unsigned short = const 0 to unsigned int = ax+$26 (used reg = )
mov	bx,ax
! Debug: eq int = const 0 to unsigned short = [bx+$26] (used reg = )
xor	ax,ax
mov	$26[bx],ax
!BCC_EOS
! 2645       ss = get_SS();
! Debug: func () unsigned short = get_SS+0 (used reg = )
call	_get_SS
! Debug: eq unsigned short = ax+0 to unsigned short ss = [S+$16-$C] (used reg = )
mov	-$A[bp],ax
!BCC_EOS
! 2646       base15_00 = ss << 4;
! Debug: sl int = const 4 to unsigned short ss = [S+$16-$C] (used reg = )
mov	ax,-$A[bp]
mov	cl,*4
shl	ax,cl
! Debug: eq unsigned int = ax+0 to unsigned short base15_00 = [S+$16-8] (used reg = )
mov	-6[bp],ax
!BCC_EOS
! 2647       base23_16 = ss >> 12;
! Debug: sr int = const $C to unsigned short ss = [S+$16-$C] (used reg = )
mov	ax,-$A[bp]
mov	al,ah
xor	ah,ah
mov	cl,*4
shr	ax,cl
! Debug: eq unsigned int = ax+0 to unsigned char base23_16 = [S+$16-9] (used reg = )
mov	-7[bp],al
!BCC_EOS
! 2648       *((Bit16u *)(regs.u.r16.si+0x28+0)) = (0xffff);
! Debug: add int = const $28 to unsigned short regs = [S+$16+4] (used reg = )
mov	ax,6[bp]
! Debug: add int = const 0 to unsigned int = ax+$28 (used reg = )
! Debug: cast * unsigned short = const 0 to unsigned int = ax+$28 (used reg = )
mov	bx,ax
! Debug: eq unsigned int = const $FFFF to unsigned short = [bx+$28] (used reg = )
mov	ax,#$FFFF
mov	$28[bx],ax
!BCC_EOS
! 2649       *((Bit16u *)(regs.u.r16.si+0x28+2)) = (base15_00);
! Debug: add int = const $28 to unsigned short regs = [S+$16+4] (used reg = )
mov	ax,6[bp]
! Debug: add int = const 2 to unsigned int = ax+$28 (used reg = )
! Debug: cast * unsigned short = const 0 to unsigned int = ax+$2A (used reg = )
mov	bx,ax
! Debug: eq unsigned short base15_00 = [S+$16-8] to unsigned short = [bx+$2A] (used reg = )
mov	ax,-6[bp]
mov	$2A[bx],ax
!BCC_EOS
! 2650       *((Bit8u *)(regs.u.r16.si+0x28+4)) = (base23_16);
! Debug: add int = const $28 to unsigned short regs = [S+$16+4] (used reg = )
mov	ax,6[bp]
! Debug: add int = const 4 to unsigned int = ax+$28 (used reg = )
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$2C (used reg = )
mov	bx,ax
! Debug: eq unsigned char base23_16 = [S+$16-9] to unsigned char = [bx+$2C] (used reg = )
mov	al,-7[bp]
mov	$2C[bx],al
!BCC_EOS
! 2651       *((Bit8u *)(regs.u.r16.si+0x28+5)) = (0x93);
! Debug: add int = const $28 to unsigned short regs = [S+$16+4] (used reg = )
mov	ax,6[bp]
! Debug: add int = const 5 to unsigned int = ax+$28 (used reg = )
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$2D (used reg = )
mov	bx,ax
! Debug: eq int = const $93 to unsigned char = [bx+$2D] (used reg = )
mov	al,#$93
mov	$2D[bx],al
!BCC_EOS
! 2652       *((Bit16u *)(regs.u.r16.si+0x28+6)) = (0x0000);
! Debug: add int = const $28 to unsigned short regs = [S+$16+4] (used reg = )
mov	ax,6[bp]
! Debug: add int = const 6 to unsigned int = ax+$28 (used reg = )
! Debug: cast * unsigned short = const 0 to unsigned int = ax+$2E (used reg = )
mov	bx,ax
! Debug: eq int = const 0 to unsigned short = [bx+$2E] (used reg = )
xor	ax,ax
mov	$2E[bx],ax
!BCC_EOS
! 2653       CX = regs.u.r16.cx;
! Debug: eq unsigned short regs = [S+$16+$E] to unsigned short CX = [S+$16-$10] (used reg = )
mov	ax,$10[bp]
mov	-$E[bp],ax
!BCC_EOS
! 2654 #asm
!BCC_EOS
!BCC_ASM
_int15_function.CX	set	6
.int15_function.CX	set	-$E
_int15_function.FLAGS	set	$2C
.int15_function.FLAGS	set	$18
_int15_function.irqDisable	set	1
.int15_function.irqDisable	set	-$13
_int15_function.DS	set	$2A
.int15_function.DS	set	$16
_int15_function.DX	set	4
.int15_function.DX	set	-$10
_int15_function.base23_16	set	$D
.int15_function.base23_16	set	-7
_int15_function.bRegister	set	2
.int15_function.bRegister	set	-$12
_int15_function.ES	set	$28
.int15_function.ES	set	$14
_int15_function.ebda_seg	set	$12
.int15_function.ebda_seg	set	-2
_int15_function.base15_00	set	$E
.int15_function.base15_00	set	-6
_int15_function.ss	set	$A
.int15_function.ss	set	-$A
_int15_function.BX	set	8
.int15_function.BX	set	-$C
_int15_function.regs	set	$18
.int15_function.regs	set	4
_int15_function.prev_a20_enable	set	$10
.int15_function.prev_a20_enable	set	-4
      mov bx, sp
      SEG SS
        mov cx, _int15_function.CX [bx]
      push eax
      xor eax, eax
      mov ds, ax
      mov 0x0469, ss
      mov 0x0467, sp
      SEG ES
        lgdt [si + 0x08]
      SEG CS
        lidt [pmode_IDT_info]
      ;; perhaps do something with IDT here
      ;; set PE bit in CR0
      mov eax, cr0
      or al, #0x01
      mov cr0, eax
      ;; far jump to flush CPU queue after transition to protected mode
      JMP_AP(0x0020, protected_mode)
protected_mode:
      ;; GDT points to valid descriptor table, now load SS, DS, ES
      mov ax, #0x28 ;; 101 000 = 5th descriptor in table, TI=GDT, RPL=00
      mov ss, ax
      mov ax, #0x10 ;; 010 000 = 2nd descriptor in table, TI=GDT, RPL=00
      mov ds, ax
      mov ax, #0x18 ;; 011 000 = 3rd descriptor in table, TI=GDT, RPL=00
      mov es, ax
      xor si, si
      xor di, di
      cld
      rep
        movsw ;; move CX words from DS:SI to ES:DI
      ;; make sure DS and ES limits are 64KB
      mov ax, #0x28
      mov ds, ax
      mov es, ax
      ;; reset PG bit in CR0 ???
      mov eax, cr0
      and al, #0xFE
      mov cr0, eax
      ;; far jump to flush CPU queue after transition to real mode
      JMP_AP(0xf000, real_mode)
real_mode:
      ;; restore IDT to normal real-mode defaults
      SEG CS
        lidt [rmode_IDT_info]
      xor ax, ax
      mov ds, ax
      mov ss, 0x0469
      mov sp, 0x0467
      pop eax
! 2706 endasm
!BCC_ENDASM
!BCC_EOS
! 2707       set_enable_a20(prev_a20_enable);
! Debug: list unsigned short prev_a20_enable = [S+$16-6] (used reg = )
push	-4[bp]
! Debug: func () unsigned short = set_enable_a20+0 (used reg = )
call	_set_enable_a20
inc	sp
inc	sp
!BCC_EOS
! 2708 #asm
!BCC_EOS
!BCC_ASM
_int15_function.CX	set	6
.int15_function.CX	set	-$E
_int15_function.FLAGS	set	$2C
.int15_function.FLAGS	set	$18
_int15_function.irqDisable	set	1
.int15_function.irqDisable	set	-$13
_int15_function.DS	set	$2A
.int15_function.DS	set	$16
_int15_function.DX	set	4
.int15_function.DX	set	-$10
_int15_function.base23_16	set	$D
.int15_function.base23_16	set	-7
_int15_function.bRegister	set	2
.int15_function.bRegister	set	-$12
_int15_function.ES	set	$28
.int15_function.ES	set	$14
_int15_function.ebda_seg	set	$12
.int15_function.ebda_seg	set	-2
_int15_function.base15_00	set	$E
.int15_function.base15_00	set	-6
_int15_function.ss	set	$A
.int15_function.ss	set	-$A
_int15_function.BX	set	8
.int15_function.BX	set	-$C
_int15_function.regs	set	$18
.int15_function.regs	set	4
_int15_function.prev_a20_enable	set	$10
.int15_function.prev_a20_enable	set	-4
  sti
! 2710 endasm
!BCC_ENDASM
!BCC_EOS
! 2711       regs.u.r8.ah = 0;
! Debug: eq int = const 0 to unsigned char regs = [S+$16+$11] (used reg = )
xor	al,al
mov	$13[bp],al
!BCC_EOS
! 2712       FLAGS &= 0xfffe;
! Debug: andab unsigned int = const $FFFE to unsigned short FLAGS = [S+$16+$16] (used reg = )
mov	ax,$18[bp]
and	al,#$FE
mov	$18[bp],ax
!BCC_EOS
! 2713       break;
br 	.359
!BCC_EOS
! 2714     case 0x88:
! 2715       regs.u.r8.al = inb_cmos(0x30);
.376:
! Debug: list int = const $30 (used reg = )
mov	ax,*$30
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char regs = [S+$16+$10] (used reg = )
mov	$12[bp],al
!BCC_EOS
! 2716       regs.u.r8.ah = inb_cmos(0x31);
! Debug: list int = const $31 (used reg = )
mov	ax,*$31
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char regs = [S+$16+$11] (used reg = )
mov	$13[bp],al
!BCC_EOS
! 2717       if(regs.u.r16.ax > 0xffc0)
! Debug: gt unsigned int = const $FFC0 to unsigned short regs = [S+$16+$10] (used reg = )
mov	ax,$12[bp]
cmp	ax,#$FFC0
jbe 	.377
.378:
! 2718         regs.u.r16.ax = 0xffc0;
! Debug: eq unsigned int = const $FFC0 to unsigned short regs = [S+$16+$10] (used reg = )
mov	ax,#$FFC0
mov	$12[bp],ax
!BCC_EOS
! 2719       FLAGS &= 0xfffe;
.377:
! Debug: andab unsigned int = const $FFFE to unsigned short FLAGS = [S+$16+$16] (used reg = )
mov	ax,$18[bp]
and	al,#$FE
mov	$18[bp],ax
!BCC_EOS
! 2720       break;
br 	.359
!BCC_EOS
! 2721   case 0x89:
! 2722 #asm
.379:
!BCC_EOS
!BCC_ASM
_int15_function.CX	set	6
.int15_function.CX	set	-$E
_int15_function.FLAGS	set	$2C
.int15_function.FLAGS	set	$18
_int15_function.irqDisable	set	1
.int15_function.irqDisable	set	-$13
_int15_function.DS	set	$2A
.int15_function.DS	set	$16
_int15_function.DX	set	4
.int15_function.DX	set	-$10
_int15_function.base23_16	set	$D
.int15_function.base23_16	set	-7
_int15_function.bRegister	set	2
.int15_function.bRegister	set	-$12
_int15_function.ES	set	$28
.int15_function.ES	set	$14
_int15_function.ebda_seg	set	$12
.int15_function.ebda_seg	set	-2
_int15_function.base15_00	set	$E
.int15_function.base15_00	set	-6
_int15_function.ss	set	$A
.int15_function.ss	set	-$A
_int15_function.BX	set	8
.int15_function.BX	set	-$C
_int15_function.regs	set	$18
.int15_function.regs	set	4
_int15_function.prev_a20_enable	set	$10
.int15_function.prev_a20_enable	set	-4
  cli
! 2724 endasm
!BCC_ENDASM
!BCC_EOS
! 2725       set_enable_a20(1);
! Debug: list int = const 1 (used reg = )
mov	ax,*1
push	ax
! Debug: func () unsigned short = set_enable_a20+0 (used reg = )
call	_set_enable_a20
inc	sp
inc	sp
!BCC_EOS
! 2726       set_DS(ES);
! Debug: list unsigned short ES = [S+$16+$12] (used reg = )
push	$14[bp]
! Debug: func () unsigned short = set_DS+0 (used reg = )
call	_set_DS
inc	sp
inc	sp
!BCC_EOS
! 2727       *((Bit16u *)(regs.u.r16.si+0x38+0)) = (0xffff);
! Debug: add int = const $38 to unsigned short regs = [S+$16+4] (used reg = )
mov	ax,6[bp]
! Debug: add int = const 0 to unsigned int = ax+$38 (used reg = )
! Debug: cast * unsigned short = const 0 to unsigned int = ax+$38 (used reg = )
mov	bx,ax
! Debug: eq unsigned int = const $FFFF to unsigned short = [bx+$38] (used reg = )
mov	ax,#$FFFF
mov	$38[bx],ax
!BCC_EOS
! 2728       *((Bit16u *)(regs.u.r16.si+0x38+2)) = (0x0000);
! Debug: add int = const $38 to unsigned short regs = [S+$16+4] (used reg = )
mov	ax,6[bp]
! Debug: add int = const 2 to unsigned int = ax+$38 (used reg = )
! Debug: cast * unsigned short = const 0 to unsigned int = ax+$3A (used reg = )
mov	bx,ax
! Debug: eq int = const 0 to unsigned short = [bx+$3A] (used reg = )
xor	ax,ax
mov	$3A[bx],ax
!BCC_EOS
! 2729       *((Bit8u *)(regs.u.r16.si+0x38+4)) = (0x000f);
! Debug: add int = const $38 to unsigned short regs = [S+$16+4] (used reg = )
mov	ax,6[bp]
! Debug: add int = const 4 to unsigned int = ax+$38 (used reg = )
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$3C (used reg = )
mov	bx,ax
! Debug: eq int = const $F to unsigned char = [bx+$3C] (used reg = )
mov	al,*$F
mov	$3C[bx],al
!BCC_EOS
! 2730       *((Bit8u *)(regs.u.r16.si+0x38+5)) = (0x9b);
! Debug: add int = const $38 to unsigned short regs = [S+$16+4] (used reg = )
mov	ax,6[bp]
! Debug: add int = const 5 to unsigned int = ax+$38 (used reg = )
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$3D (used reg = )
mov	bx,ax
! Debug: eq int = const $9B to unsigned char = [bx+$3D] (used reg = )
mov	al,#$9B
mov	$3D[bx],al
!BCC_EOS
! 2731       *((Bit16u *)(regs.u.r16.si+0x38+6)) = (0x0000);
! Debug: add int = const $38 to unsigned short regs = [S+$16+4] (used reg = )
mov	ax,6[bp]
! Debug: add int = const 6 to unsigned int = ax+$38 (used reg = )
! Debug: cast * unsigned short = const 0 to unsigned int = ax+$3E (used reg = )
mov	bx,ax
! Debug: eq int = const 0 to unsigned short = [bx+$3E] (used reg = )
xor	ax,ax
mov	$3E[bx],ax
!BCC_EOS
! 2732       BX = regs.u.r16.bx;
! Debug: eq unsigned short regs = [S+$16+$A] to unsigned short BX = [S+$16-$E] (used reg = )
mov	ax,$C[bp]
mov	-$C[bp],ax
!BCC_EOS
! 2733 #asm
!BCC_EOS
!BCC_ASM
_int15_function.CX	set	6
.int15_function.CX	set	-$E
_int15_function.FLAGS	set	$2C
.int15_function.FLAGS	set	$18
_int15_function.irqDisable	set	1
.int15_function.irqDisable	set	-$13
_int15_function.DS	set	$2A
.int15_function.DS	set	$16
_int15_function.DX	set	4
.int15_function.DX	set	-$10
_int15_function.base23_16	set	$D
.int15_function.base23_16	set	-7
_int15_function.bRegister	set	2
.int15_function.bRegister	set	-$12
_int15_function.ES	set	$28
.int15_function.ES	set	$14
_int15_function.ebda_seg	set	$12
.int15_function.ebda_seg	set	-2
_int15_function.base15_00	set	$E
.int15_function.base15_00	set	-6
_int15_function.ss	set	$A
.int15_function.ss	set	-$A
_int15_function.BX	set	8
.int15_function.BX	set	-$C
_int15_function.regs	set	$18
.int15_function.regs	set	4
_int15_function.prev_a20_enable	set	$10
.int15_function.prev_a20_enable	set	-4
      mov bx, sp
      SEG SS
        mov bx, _int15_function.BX [bx]
      mov al, #0x11 ; send initialisation commands
      out 0x0020, al
      out 0x00a0, al
      mov al, bh
      out 0x0021, al
      mov al, bl
      out 0x00a1, al
      mov al, #0x04
      out 0x0021, al
      mov al, #0x02
      out 0x00a1, al
      mov al, #0x01
      out 0x0021, al
      out 0x00a1, al
      mov al, #0xff ; mask all IRQs, user must re-enable
      out 0x0021, al
      out 0x00a1, al
      SEG ES
        lgdt [si + 0x08]
      SEG ES
        lidt [si + 0x10]
      mov eax, cr0
      or al, #0x01
      mov cr0, eax
      JMP_AP(0x0038, protmode_switch)
protmode_switch:
      ;; GDT points to valid descriptor table, now load SS, DS, ES
      mov ax, #0x28
      mov ss, ax
      mov ax, #0x18
      mov ds, ax
      mov ax, #0x20
      mov es, ax
      mov sp,bp
      add sp,#4 ; skip return address
      popa ; restore regs
      pop ax ; skip saved es
      pop ax ; skip saved ds
      pop ax ; skip saved flags
      pop cx ; get return offset
      pop ax ; skip return segment
      pop ax ; skip flags
      mov ax, #0x30 ; ah must be 0 on successful exit
      push ax
      push cx ; re-create modified ret address on stack
      retf
! 2783 endasm
!BCC_ENDASM
!BCC_EOS
! 2784       break;
br 	.359
!BCC_EOS
! 2785     case 0xbf:
! 2786       bios_printf(4, "*** int 15h function AH=bf not yet supported!\n");
.37A:
! Debug: list * char = .37B+0 (used reg = )
mov	bx,#.37B
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*4
!BCC_EOS
! 2787       FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$16+$16] (used reg = )
mov	ax,$18[bp]
or	al,*1
mov	$18[bp],ax
!BCC_EOS
! 2788       regs.u.r8.ah = 0x86;
! Debug: eq int = const $86 to unsigned char regs = [S+$16+$11] (used reg = )
mov	al,#$86
mov	$13[bp],al
!BCC_EOS
! 2789       break;
br 	.359
!BCC_EOS
! 2790     case 0xC0:
! 2791       FLAGS &= 0xfffe;
.37C:
! Debug: andab unsigned int = const $FFFE to unsigned short FLAGS = [S+$16+$16] (used reg = )
mov	ax,$18[bp]
and	al,#$FE
mov	$18[bp],ax
!BCC_EOS
! 2792       regs.u.r8.ah = 0;
! Debug: eq int = const 0 to unsigned char regs = [S+$16+$11] (used reg = )
xor	al,al
mov	$13[bp],al
!BCC_EOS
! 2793       regs.u.r16.bx = 0xe6f5;
! Debug: eq unsigned int = const $E6F5 to unsigned short regs = [S+$16+$A] (used reg = )
mov	ax,#$E6F5
mov	$C[bp],ax
!BCC_EOS
! 2794       ES = 0xF000;
! Debug: eq unsigned int = const $F000 to unsigned short ES = [S+$16+$12] (used reg = )
mov	ax,#$F000
mov	$14[bp],ax
!BCC_EOS
! 2795       break;
br 	.359
!BCC_EOS
! 2796     case 0xc1:
! 2797       ES = ebda_seg;
.37D:
! Debug: eq unsigned short ebda_seg = [S+$16-4] to unsigned short ES = [S+$16+$12] (used reg = )
mov	ax,-2[bp]
mov	$14[bp],ax
!BCC_EOS
! 2798       FLAGS &= 0xfffe;
! Debug: andab unsigned int = const $FFFE to unsigned short FLAGS = [S+$16+$16] (used reg = )
mov	ax,$18[bp]
and	al,#$FE
mov	$18[bp],ax
!BCC_EOS
! 2799       break;
br 	.359
!BCC_EOS
! 2800     case 0xd8:
! 2801       bios_printf(8, "EISA BIOS not present\n");
.37E:
! Debug: list * char = .37F+0 (used reg = )
mov	bx,#.37F
push	bx
! Debug: list int = const 8 (used reg = )
mov	ax,*8
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*4
!BCC_EOS
! 2802       FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$16+$16] (used reg = )
mov	ax,$18[bp]
or	al,*1
mov	$18[bp],ax
!BCC_EOS
! 2803       regs.u.r8.ah = 0x86;
! Debug: eq int = const $86 to unsigned char regs = [S+$16+$11] (used reg = )
mov	al,#$86
mov	$13[bp],al
!BCC_EOS
! 2804       break;
jmp .359
!BCC_EOS
! 2805     default:
! 2806       bios_printf(4, "*** int 15h function AX=%04x, BX=%04x not yet supported!\n", (unsigned) regs.u.r16.ax, (unsigned) regs.u.r16.bx);
.380:
! Debug: list unsigned short regs = [S+$16+$A] (used reg = )
push	$C[bp]
! Debug: list unsigned short regs = [S+$18+$10] (used reg = )
push	$12[bp]
! Debug: list * char = .381+0 (used reg = )
mov	bx,#.381
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*8
!BCC_EOS
! 2807       FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$16+$16] (used reg = )
mov	ax,$18[bp]
or	al,*1
mov	$18[bp],ax
!BCC_EOS
! 2808       regs.u.r8.ah = 0x86;
! Debug: eq int = const $86 to unsigned char regs = [S+$16+$11] (used reg = )
mov	al,#$86
mov	$13[bp],al
!BCC_EOS
! 2809       break;
jmp .359
!BCC_EOS
! 2810     }
! 2811 }
jmp .359
.35B:
sub	al,*$24
beq 	.35C
sub	al,*$1D
beq 	.366
sub	al,*$E
beq 	.367
sub	al,*3
beq 	.368
sub	al,*$31
beq 	.369
sub	al,*4
beq 	.373
sub	al,*1
beq 	.376
sub	al,*1
beq 	.379
sub	al,*$36
beq 	.37A
sub	al,*1
beq 	.37C
sub	al,*1
beq 	.37D
sub	al,*$17
beq 	.37E
jmp	.380
.359:
..FFF7	=	-$16
mov	sp,bp
pop	bp
ret
! 2812   void
! Register BX used in function int15_function
! 2813 int15_function_mouse(regs, ES, DS, FLAGS)
! 2814   pusha_regs_t regs;
export	_int15_function_mouse
_int15_function_mouse:
!BCC_EOS
! 2815   Bit16u ES, DS, FLAGS;
!BCC_EOS
! 2816 {
! 2817   Bit16u ebda_seg=get_ebda_seg();
push	bp
mov	bp,sp
dec	sp
dec	sp
! Debug: func () unsigned short = get_ebda_seg+0 (used reg = )
call	_get_ebda_seg
! Debug: eq unsigned short = ax+0 to unsigned short ebda_seg = [S+4-4] (used reg = )
mov	-2[bp],ax
!BCC_EOS
! 2818   Bit8u mouse_flags_1, mouse_flags_2;
!BCC_EOS
! 2819   Bit16u mouse_driver_seg;
!BCC_EOS
! 2820   Bit16u mouse_driver_offset;
!BCC_EOS
! 2821   Bit8u comm_byte, prev_command_byte;
!BCC_EOS
! 2822   Bit8u ret, mouse
! 2822 _data1, mouse_data2, mouse_data3;
!BCC_EOS
! 2823 ;
add	sp,*-$C
!BCC_EOS
! 2824   switch (regs.u.r8.ah) {
mov	al,$13[bp]
br 	.384
! 2825     case 0xC2:
! 2826       switch (regs.u.r8.al) {
.385:
mov	al,$12[bp]
br 	.388
! 2827         case 0:
! 2828 ;
.389:
!BCC_EOS
! 2829           switch (regs.u.r8.bh) {
mov	al,$D[bp]
br 	.38C
! 2830             case 0:
! 2831 ;
.38D:
!BCC_EOS
! 2832               inhibit_mouse_int_and_events();
! Debug: func () unsigned char = inhibit_mouse_int_and_events+0 (used reg = )
call	_inhibit_mouse_int_and_events
!BCC_EOS
! 2833               ret = send_to_mouse_ctrl(0xF5);
! Debug: list int = const $F5 (used reg = )
mov	ax,#$F5
push	ax
! Debug: func () unsigned char = send_to_mouse_ctrl+0 (used reg = )
call	_send_to_mouse_ctrl
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	-$B[bp],al
!BCC_EOS
! 2834               if (ret == 0) {
! Debug: logeq int = const 0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	al,-$B[bp]
test	al,al
jne 	.38E
.38F:
! 2835                 ret = get_mouse_data(&mouse_data1);
! Debug: list * unsigned char mouse_data1 = S+$10-$E (used reg = )
lea	bx,-$C[bp]
push	bx
! Debug: func () unsigned char = get_mouse_data+0 (used reg = )
call	_get_mouse_data
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	-$B[bp],al
!BCC_EOS
! 2836                 if ( (ret == 0) || (mouse_data1 == 0xFA) ) {
! Debug: logeq int = const 0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	al,-$B[bp]
test	al,al
je  	.391
.392:
! Debug: logeq int = const $FA to unsigned char mouse_data1 = [S+$10-$E] (used reg = )
mov	al,-$C[bp]
cmp	al,#$FA
jne 	.390
.391:
! 2837                   FLAGS &= 0xfffe;
! Debug: andab unsigned int = const $FFFE to unsigned short FLAGS = [S+$10+$16] (used reg = )
mov	ax,$18[bp]
and	al,#$FE
mov	$18[bp],ax
!BCC_EOS
! 2838                   regs.u.r8.ah = 0;
! Debug: eq int = const 0 to unsigned char regs = [S+$10+$11] (used reg = )
xor	al,al
mov	$13[bp],al
!BCC_EOS
! 2839                   return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2840                 }
! 2841               }
.390:
! 2842               FLAGS |= 0x0001;
.38E:
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$10+$16] (used reg = )
mov	ax,$18[bp]
or	al,*1
mov	$18[bp],ax
!BCC_EOS
! 2843               regs.u.r8.ah = ret;
! Debug: eq unsigned char ret = [S+$10-$D] to unsigned char regs = [S+$10+$11] (used reg = )
mov	al,-$B[bp]
mov	$13[bp],al
!BCC_EOS
! 2844               return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2845               break;
br 	.38A
!BCC_EOS
! 2846             case 1:
! 2847 ;
.393:
!BCC_EOS
! 2848               mouse_flags_2 = _read_byte(&((ebda_data_t *) 0)->mouse_flag2, ebda_seg);
! Debug: list unsigned short ebda_seg = [S+$10-4] (used reg = )
push	-2[bp]
! Debug: list * unsigned char = const $27 (used reg = )
mov	ax,*$27
push	ax
! Debug: func () unsigned char = _read_byte+0 (used reg = )
call	__read_byte
add	sp,*4
! Debug: eq unsigned char = al+0 to unsigned char mouse_flags_2 = [S+$10-6] (used reg = )
mov	-4[bp],al
!BCC_EOS
! 2849               if ( (mouse_flags_2 & 0x80) == 0 ) {
! Debug: and int = const $80 to unsigned char mouse_flags_2 = [S+$10-6] (used reg = )
mov	al,-4[bp]
and	al,#$80
! Debug: logeq int = const 0 to unsigned char = al+0 (used reg = )
test	al,al
jne 	.394
.395:
! 2850                 ;
!BCC_EOS
! 2851                 FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$10+$16] (used reg = )
mov	ax,$18[bp]
or	al,*1
mov	$18[bp],ax
!BCC_EOS
! 2852                 regs.u.r8.ah = 5;
! Debug: eq int = const 5 to unsigned char regs = [S+$10+$11] (used reg = )
mov	al,*5
mov	$13[bp],al
!BCC_EOS
! 2853                 return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2854               }
! 2855               inhibit_mouse_int_and_events();
.394:
! Debug: func () unsigned char = inhibit_mouse_int_and_events+0 (used reg = )
call	_inhibit_mouse_int_and_events
!BCC_EOS
! 2856               ret = send_to_mouse_ctrl(0xF4);
! Debug: list int = const $F4 (used reg = )
mov	ax,#$F4
push	ax
! Debug: func () unsigned char = send_to_mouse_ctrl+0 (used reg = )
call	_send_to_mouse_ctrl
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	-$B[bp],al
!BCC_EOS
! 2857               if (ret == 0) {
! Debug: logeq int = const 0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	al,-$B[bp]
test	al,al
jne 	.396
.397:
! 2858                 ret = get_mouse_data(&mouse_data1);
! Debug: list * unsigned char mouse_data1 = S+$10-$E (used reg = )
lea	bx,-$C[bp]
push	bx
! Debug: func () unsigned char = get_mouse_data+0 (used reg = )
call	_get_mouse_data
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	-$B[bp],al
!BCC_EOS
! 2859                 if ( (ret == 0) && (mouse_data1 == 0xFA) ) {
! Debug: logeq int = const 0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	al,-$B[bp]
test	al,al
jne 	.398
.39A:
! Debug: logeq int = const $FA to unsigned char mouse_data1 = [S+$10-$E] (used reg = )
mov	al,-$C[bp]
cmp	al,#$FA
jne 	.398
.399:
! 2860                   enable_mouse_int_and_events();
! Debug: func () void = enable_mouse_int_and_events+0 (used reg = )
call	_enable_mouse_int_and_events
!BCC_EOS
! 2861                   FLAGS &= 0xfffe;
! Debug: andab unsigned int = const $FFFE to unsigned short FLAGS = [S+$10+$16] (used reg = )
mov	ax,$18[bp]
and	al,#$FE
mov	$18[bp],ax
!BCC_EOS
! 2862                   regs.u.r8.ah = 0;
! Debug: eq int = const 0 to unsigned char regs = [S+$10+$11] (used reg = )
xor	al,al
mov	$13[bp],al
!BCC_EOS
! 2863                   return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2864                 }
! 2865               }
.398:
! 2866               FLAGS |= 0x0001;
.396:
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$10+$16] (used reg = )
mov	ax,$18[bp]
or	al,*1
mov	$18[bp],ax
!BCC_EOS
! 2867               regs.u.r8.ah = ret;
! Debug: eq unsigned char ret = [S+$10-$D] to unsigned char regs = [S+$10+$11] (used reg = )
mov	al,-$B[bp]
mov	$13[bp],al
!BCC_EOS
! 2868               return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2869             default:
! 2870               ;
.39B:
!BCC_EOS
! 2871               FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$10+$16] (used reg = )
mov	ax,$18[bp]
or	al,*1
mov	$18[bp],ax
!BCC_EOS
! 2872               regs.u.r8.ah = 1;
! Debug: eq int = const 1 to unsigned char regs = [S+$10+$11] (used reg = )
mov	al,*1
mov	$13[bp],al
!BCC_EOS
! 2873               return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2874           }
! 2875           break;
jmp .38A
.38C:
sub	al,*0
beq 	.38D
sub	al,*1
beq 	.393
jmp	.39B
.38A:
br 	.386
!BCC_EOS
! 2876         case 1:
! 2877         case 5:
.39C:
! 2878 ;
.39D:
!BCC_EOS
! 2879           if (regs.u.r8.al == 5) {
! Debug: logeq int = const 5 to unsigned char regs = [S+$10+$10] (used reg = )
mov	al,$12[bp]
cmp	al,*5
jne 	.39E
.39F:
! 2880             if ((regs.u.r8.bh != 3) && (regs.u.r8.bh != 4)) {
! Debug: ne int = const 3 to unsigned char regs = [S+$10+$B] (used reg = )
mov	al,$D[bp]
cmp	al,*3
je  	.3A0
.3A2:
! Debug: ne int = const 4 to unsigned char regs = [S+$10+$B] (used reg = )
mov	al,$D[bp]
cmp	al,*4
je  	.3A0
.3A1:
! 2881               FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$10+$16] (used reg = )
mov	ax,$18[bp]
or	al,*1
mov	$18[bp],ax
!BCC_EOS
! 2882               regs.u.r8.ah = 0x02;
! Debug: eq int = const 2 to unsigned char regs = [S+$10+$11] (used reg = )
mov	al,*2
mov	$13[bp],al
!BCC_EOS
! 2883               return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2884             }
! 2885             mouse_flags_2 = _read_byte(&((ebda_data_t *) 0)->mouse_flag2, ebda_seg);
.3A0:
! Debug: list unsigned short ebda_seg = [S+$10-4] (used reg = )
push	-2[bp]
! Debug: list * unsigned char = const $27 (used reg = )
mov	ax,*$27
push	ax
! Debug: func () unsigned char = _read_byte+0 (used reg = )
call	__read_byte
add	sp,*4
! Debug: eq unsigned char = al+0 to unsigned char mouse_flags_2 = [S+$10-6] (used reg = )
mov	-4[bp],al
!BCC_EOS
! 2886             mouse_flags_2 = (mouse_flags_2 & 0xF8) | regs.u.r8.bh - 1;
! Debug: sub int = const 1 to unsigned char regs = [S+$10+$B] (used reg = )
mov	al,$D[bp]
xor	ah,ah
dec	ax
push	ax
! Debug: and int = const $F8 to unsigned char mouse_flags_2 = [S+$12-6] (used reg = )
mov	al,-4[bp]
and	al,#$F8
! Debug: or unsigned int (temp) = [S+$12-$12] to unsigned char = al+0 (used reg = )
xor	ah,ah
or	ax,0+..FFF6[bp]
inc	sp
inc	sp
! Debug: eq unsigned int = ax+0 to unsigned char mouse_flags_2 = [S+$10-6] (used reg = )
mov	-4[bp],al
!BCC_EOS
! 2887             mouse_flags_1 = 0x00;
! Debug: eq int = const 0 to unsigned char mouse_flags_1 = [S+$10-5] (used reg = )
xor	al,al
mov	-3[bp],al
!BCC_EOS
! 2888             _write_byte(mouse_fl
! 2888 ags_1, &((ebda_data_t *) 0)->mouse_flag1, ebda_seg);
! Debug: list unsigned short ebda_seg = [S+$10-4] (used reg = )
push	-2[bp]
! Debug: list * unsigned char = const $26 (used reg = )
mov	ax,*$26
push	ax
! Debug: list unsigned char mouse_flags_1 = [S+$14-5] (used reg = )
mov	al,-3[bp]
xor	ah,ah
push	ax
! Debug: func () void = _write_byte+0 (used reg = )
call	__write_byte
add	sp,*6
!BCC_EOS
! 2889             _write_byte(mouse_flags_2, &((ebda_data_t *) 0)->mouse_flag2, ebda_seg);
! Debug: list unsigned short ebda_seg = [S+$10-4] (used reg = )
push	-2[bp]
! Debug: list * unsigned char = const $27 (used reg = )
mov	ax,*$27
push	ax
! Debug: list unsigned char mouse_flags_2 = [S+$14-6] (used reg = )
mov	al,-4[bp]
xor	ah,ah
push	ax
! Debug: func () void = _write_byte+0 (used reg = )
call	__write_byte
add	sp,*6
!BCC_EOS
! 2890           }
! 2891           inhibit_mouse_int_and_events();
.39E:
! Debug: func () unsigned char = inhibit_mouse_int_and_events+0 (used reg = )
call	_inhibit_mouse_int_and_events
!BCC_EOS
! 2892           ret = send_to_mouse_ctrl(0xFF);
! Debug: list int = const $FF (used reg = )
mov	ax,#$FF
push	ax
! Debug: func () unsigned char = send_to_mouse_ctrl+0 (used reg = )
call	_send_to_mouse_ctrl
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	-$B[bp],al
!BCC_EOS
! 2893           if (ret == 0) {
! Debug: logeq int = const 0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	al,-$B[bp]
test	al,al
bne 	.3A3
.3A4:
! 2894             ret = get_mouse_data(&mouse_data3);
! Debug: list * unsigned char mouse_data3 = S+$10-$10 (used reg = )
lea	bx,-$E[bp]
push	bx
! Debug: func () unsigned char = get_mouse_data+0 (used reg = )
call	_get_mouse_data
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	-$B[bp],al
!BCC_EOS
! 2895             if (mouse_data3 == 0xfe) {
! Debug: logeq int = const $FE to unsigned char mouse_data3 = [S+$10-$10] (used reg = )
mov	al,-$E[bp]
cmp	al,#$FE
jne 	.3A5
.3A6:
! 2896               FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$10+$16] (used reg = )
mov	ax,$18[bp]
or	al,*1
mov	$18[bp],ax
!BCC_EOS
! 2897               return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2898             }
! 2899             if (mouse_data3 != 0xfa)
.3A5:
! Debug: ne int = const $FA to unsigned char mouse_data3 = [S+$10-$10] (used reg = )
mov	al,-$E[bp]
cmp	al,#$FA
je  	.3A7
.3A8:
! 2900               bios_printf((2 | 4 | 1), "Mouse reset returned %02x (should be ack)\n", (unsigned)mouse_data3);
! Debug: list unsigned char mouse_data3 = [S+$10-$10] (used reg = )
mov	al,-$E[bp]
xor	ah,ah
push	ax
! Debug: list * char = .3A9+0 (used reg = )
mov	bx,#.3A9
push	bx
! Debug: list int = const 7 (used reg = )
mov	ax,*7
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*6
!BCC_EOS
! 2901             if ( ret == 0 ) {
.3A7:
! Debug: logeq int = const 0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	al,-$B[bp]
test	al,al
jne 	.3AA
.3AB:
! 2902               ret = get_mouse_data(&mouse_data1);
! Debug: list * unsigned char mouse_data1 = S+$10-$E (used reg = )
lea	bx,-$C[bp]
push	bx
! Debug: func () unsigned char = get_mouse_data+0 (used reg = )
call	_get_mouse_data
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	-$B[bp],al
!BCC_EOS
! 2903               if ( ret == 0 ) {
! Debug: logeq int = const 0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	al,-$B[bp]
test	al,al
jne 	.3AC
.3AD:
! 2904                 ret = get_mouse_data(&mouse_data2);
! Debug: list * unsigned char mouse_data2 = S+$10-$F (used reg = )
lea	bx,-$D[bp]
push	bx
! Debug: func () unsigned char = get_mouse_data+0 (used reg = )
call	_get_mouse_data
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	-$B[bp],al
!BCC_EOS
! 2905                 if ( ret == 0 ) {
! Debug: logeq int = const 0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	al,-$B[bp]
test	al,al
jne 	.3AE
.3AF:
! 2906                   enable_mouse_int_and_events();
! Debug: func () void = enable_mouse_int_and_events+0 (used reg = )
call	_enable_mouse_int_and_events
!BCC_EOS
! 2907                   FLAGS &= 0xfffe;
! Debug: andab unsigned int = const $FFFE to unsigned short FLAGS = [S+$10+$16] (used reg = )
mov	ax,$18[bp]
and	al,#$FE
mov	$18[bp],ax
!BCC_EOS
! 2908                   regs.u.r8.ah = 0;
! Debug: eq int = const 0 to unsigned char regs = [S+$10+$11] (used reg = )
xor	al,al
mov	$13[bp],al
!BCC_EOS
! 2909                   regs.u.r8.bl = mouse_data1;
! Debug: eq unsigned char mouse_data1 = [S+$10-$E] to unsigned char regs = [S+$10+$A] (used reg = )
mov	al,-$C[bp]
mov	$C[bp],al
!BCC_EOS
! 2910                   regs.u.r8.bh = mouse_data2;
! Debug: eq unsigned char mouse_data2 = [S+$10-$F] to unsigned char regs = [S+$10+$B] (used reg = )
mov	al,-$D[bp]
mov	$D[bp],al
!BCC_EOS
! 2911                   return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2912                 }
! 2913               }
.3AE:
! 2914             }
.3AC:
! 2915           }
.3AA:
! 2916           FLAGS |= 0x0001;
.3A3:
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$10+$16] (used reg = )
mov	ax,$18[bp]
or	al,*1
mov	$18[bp],ax
!BCC_EOS
! 2917           regs.u.r8.ah = ret;
! Debug: eq unsigned char ret = [S+$10-$D] to unsigned char regs = [S+$10+$11] (used reg = )
mov	al,-$B[bp]
mov	$13[bp],al
!BCC_EOS
! 2918           return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 2919         case 2:
! 2920 ;
.3B0:
!BCC_EOS
! 2921           switch (regs.u.r8.bh) {
mov	al,$D[bp]
jmp .3B3
! 2922             case 0: mouse_data1 = 10; break;
.3B4:
! Debug: eq int = const $A to unsigned char mouse_data1 = [S+$10-$E] (used reg = )
mov	al,*$A
mov	-$C[bp],al
!BCC_EOS
jmp .3B1
!BCC_EOS
! 2923             case 1: mouse_data1 = 20; break;
.3B5:
! Debug: eq int = const $14 to unsigned char mouse_data1 = [S+$10-$E] (used reg = )
mov	al,*$14
mov	-$C[bp],al
!BCC_EOS
jmp .3B1
!BCC_EOS
! 2924             case 2: mouse_data1 = 40; break;
.3B6:
! Debug: eq int = const $28 to unsigned char mouse_data1 = [S+$10-$E] (used reg = )
mov	al,*$28
mov	-$C[bp],al
!BCC_EOS
jmp .3B1
!BCC_EOS
! 2925             case 3: mouse_data1 = 60; break;
.3B7:
! Debug: eq int = const $3C to unsigned char mouse_data1 = [S+$10-$E] (used reg = )
mov	al,*$3C
mov	-$C[bp],al
!BCC_EOS
jmp .3B1
!BCC_EOS
! 2926             case 4: mouse_data1 = 80; break;
.3B8:
! Debug: eq int = const $50 to unsigned char mouse_data1 = [S+$10-$E] (used reg = )
mov	al,*$50
mov	-$C[bp],al
!BCC_EOS
jmp .3B1
!BCC_EOS
! 2927             case 5: mouse_data1 = 100; break;
.3B9:
! Debug: eq int = const $64 to unsigned char mouse_data1 = [S+$10-$E] (used reg = )
mov	al,*$64
mov	-$C[bp],al
!BCC_EOS
jmp .3B1
!BCC_EOS
! 2928             case 6: mouse_data1 = 200; break;
.3BA:
! Debug: eq int = const $C8 to unsigned char mouse_data1 = [S+$10-$E] (used reg = )
mov	al,#$C8
mov	-$C[bp],al
!BCC_EOS
jmp .3B1
!BCC_EOS
! 2929             default: mouse_data1 = 0;
.3BB:
! Debug: eq int = const 0 to unsigned char mouse_data1 = [S+$10-$E] (used reg = )
xor	al,al
mov	-$C[bp],al
!BCC_EOS
! 2930           }
! 2931           if (mouse_data1 > 0) {
jmp .3B1
.3B3:
sub	al,*0
jb 	.3BB
cmp	al,*6
ja  	.3BC
xor	ah,ah
shl	ax,*1
mov	bx,ax
seg	cs
br	.3BD[bx]
.3BD:
.word	.3B4
.word	.3B5
.word	.3B6
.word	.3B7
.word	.3B8
.word	.3B9
.word	.3BA
.3BC:
jmp	.3BB
.3B1:
! Debug: gt int = const 0 to unsigned char mouse_data1 = [S+$10-$E] (used reg = )
mov	al,-$C[bp]
test	al,al
beq 	.3BE
.3BF:
! 2932             ret = send_to_mouse_ctrl(0xF3);
! Debug: list int = const $F3 (used reg = )
mov	ax,#$F3
push	ax
! Debug: func () unsigned char = send_to_mouse_ctrl+0 (used reg = )
call	_send_to_mouse_ctrl
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	-$B[bp],al
!BCC_EOS
! 2933             if (ret == 0) {
! Debug: logeq int = const 0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	al,-$B[bp]
test	al,al
jne 	.3C0
.3C1:
! 2934               ret = get_mouse_data(&mouse_data2);
! Debug: list * unsigned char mouse_data2 = S+$10-$F (used reg = )
lea	bx,-$D[bp]
push	bx
! Debug: func () unsigned char = get_mouse_data+0 (used reg = )
call	_get_mouse_data
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	-$B[bp],al
!BCC_EOS
! 2935               ret = send_to_mouse_ctrl(mouse_data1);
! Debug: list unsigned char mouse_data1 = [S+$10-$E] (used reg = )
mov	al,-$C[bp]
xor	ah,ah
push	ax
! Debug: func () unsigned char = send_to_mouse_ctrl+0 (used reg = )
call	_send_to_mouse_ctrl
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	-$B[bp],al
!BCC_EOS
! 2936               ret = get_mouse_data(&mouse_data2);
! Debug: list * unsigned char mouse_data2 = S+$10-$F (used reg = )
lea	bx,-$D[bp]
push	bx
! Debug: func () unsigned char = get_mouse_data+0 (used reg = )
call	_get_mouse_data
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	-$B[bp],al
!BCC_EOS
! 2937               FLAGS &= 0xfffe;
! Debug: andab unsigned int = const $FFFE to unsigned short FLAGS = [S+$10+$16] (used reg = )
mov	ax,$18[bp]
and	al,#$FE
mov	$18[bp],ax
!BCC_EOS
! 2938               regs.u.r8.ah = 0;
! Debug: eq int = const 0 to unsigned char regs = [S+$10+$11] (used reg = )
xor	al,al
mov	$13[bp],al
!BCC_EOS
! 2939             } else {
jmp .3C2
.3C0:
! 2940               FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$10+$16] (used reg = )
mov	ax,$18[bp]
or	al,*1
mov	$18[bp],ax
!BCC_EOS
! 2941               regs.u.r8.ah = 0x86;
! Debug: eq int = const $86 to unsigned char regs = [S+$10+$11] (used reg = )
mov	al,#$86
mov	$13[bp],al
!BCC_EOS
! 2942             }
! 2943           } else {
.3C2:
jmp .3C3
.3BE:
! 2944             FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$10+$16] (used reg = )
mov	ax,$18[bp]
or	al,*1
mov	$18[bp],ax
!BCC_EOS
! 2945             regs.u.r8.ah = 
! 2945 0x86;
! Debug: eq int = const $86 to unsigned char regs = [S+$10+$11] (used reg = )
mov	al,#$86
mov	$13[bp],al
!BCC_EOS
! 2946           }
! 2947           break;
.3C3:
br 	.386
!BCC_EOS
! 2948         case 3:
! 2949 ;
.3C4:
!BCC_EOS
! 2950           comm_byte = inhibit_mouse_int_and_events();
! Debug: func () unsigned char = inhibit_mouse_int_and_events+0 (used reg = )
call	_inhibit_mouse_int_and_events
! Debug: eq unsigned char = al+0 to unsigned char comm_byte = [S+$10-$B] (used reg = )
mov	-9[bp],al
!BCC_EOS
! 2951           if (regs.u.r8.bh < 4) {
! Debug: lt int = const 4 to unsigned char regs = [S+$10+$B] (used reg = )
mov	al,$D[bp]
cmp	al,*4
bhis	.3C5
.3C6:
! 2952             ret = send_to_mouse_ctrl(0xE8);
! Debug: list int = const $E8 (used reg = )
mov	ax,#$E8
push	ax
! Debug: func () unsigned char = send_to_mouse_ctrl+0 (used reg = )
call	_send_to_mouse_ctrl
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	-$B[bp],al
!BCC_EOS
! 2953             if (ret == 0) {
! Debug: logeq int = const 0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	al,-$B[bp]
test	al,al
bne 	.3C7
.3C8:
! 2954               ret = get_mouse_data(&mouse_data1);
! Debug: list * unsigned char mouse_data1 = S+$10-$E (used reg = )
lea	bx,-$C[bp]
push	bx
! Debug: func () unsigned char = get_mouse_data+0 (used reg = )
call	_get_mouse_data
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	-$B[bp],al
!BCC_EOS
! 2955               if (mouse_data1 != 0xfa)
! Debug: ne int = const $FA to unsigned char mouse_data1 = [S+$10-$E] (used reg = )
mov	al,-$C[bp]
cmp	al,#$FA
je  	.3C9
.3CA:
! 2956                 bios_printf((2 | 4 | 1), "Mouse status returned %02x (should be ack)\n", (unsigned)mouse_data1);
! Debug: list unsigned char mouse_data1 = [S+$10-$E] (used reg = )
mov	al,-$C[bp]
xor	ah,ah
push	ax
! Debug: list * char = .3CB+0 (used reg = )
mov	bx,#.3CB
push	bx
! Debug: list int = const 7 (used reg = )
mov	ax,*7
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*6
!BCC_EOS
! 2957               ret = send_to_mouse_ctrl(regs.u.r8.bh);
.3C9:
! Debug: list unsigned char regs = [S+$10+$B] (used reg = )
mov	al,$D[bp]
xor	ah,ah
push	ax
! Debug: func () unsigned char = send_to_mouse_ctrl+0 (used reg = )
call	_send_to_mouse_ctrl
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	-$B[bp],al
!BCC_EOS
! 2958               ret = get_mouse_data(&mouse_data1);
! Debug: list * unsigned char mouse_data1 = S+$10-$E (used reg = )
lea	bx,-$C[bp]
push	bx
! Debug: func () unsigned char = get_mouse_data+0 (used reg = )
call	_get_mouse_data
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	-$B[bp],al
!BCC_EOS
! 2959               if (mouse_data1 != 0xfa)
! Debug: ne int = const $FA to unsigned char mouse_data1 = [S+$10-$E] (used reg = )
mov	al,-$C[bp]
cmp	al,#$FA
je  	.3CC
.3CD:
! 2960                 bios_printf((2 | 4 | 1), "Mouse status returned %02x (should be ack)\n", (unsigned)mouse_data1);
! Debug: list unsigned char mouse_data1 = [S+$10-$E] (used reg = )
mov	al,-$C[bp]
xor	ah,ah
push	ax
! Debug: list * char = .3CE+0 (used reg = )
mov	bx,#.3CE
push	bx
! Debug: list int = const 7 (used reg = )
mov	ax,*7
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*6
!BCC_EOS
! 2961               FLAGS &= 0xfffe;
.3CC:
! Debug: andab unsigned int = const $FFFE to unsigned short FLAGS = [S+$10+$16] (used reg = )
mov	ax,$18[bp]
and	al,#$FE
mov	$18[bp],ax
!BCC_EOS
! 2962               regs.u.r8.ah = 0;
! Debug: eq int = const 0 to unsigned char regs = [S+$10+$11] (used reg = )
xor	al,al
mov	$13[bp],al
!BCC_EOS
! 2963             } else {
jmp .3CF
.3C7:
! 2964               FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$10+$16] (used reg = )
mov	ax,$18[bp]
or	al,*1
mov	$18[bp],ax
!BCC_EOS
! 2965               regs.u.r8.ah = 0x86;
! Debug: eq int = const $86 to unsigned char regs = [S+$10+$11] (used reg = )
mov	al,#$86
mov	$13[bp],al
!BCC_EOS
! 2966             }
! 2967           } else {
.3CF:
jmp .3D0
.3C5:
! 2968             FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$10+$16] (used reg = )
mov	ax,$18[bp]
or	al,*1
mov	$18[bp],ax
!BCC_EOS
! 2969             regs.u.r8.ah = 0x86;
! Debug: eq int = const $86 to unsigned char regs = [S+$10+$11] (used reg = )
mov	al,#$86
mov	$13[bp],al
!BCC_EOS
! 2970           }
! 2971           set_kbd_command_byte(comm_byte);
.3D0:
! Debug: list unsigned char comm_byte = [S+$10-$B] (used reg = )
mov	al,-9[bp]
xor	ah,ah
push	ax
! Debug: func () void = set_kbd_command_byte+0 (used reg = )
call	_set_kbd_command_byte
inc	sp
inc	sp
!BCC_EOS
! 2972           break;
br 	.386
!BCC_EOS
! 2973         case 4:
! 2974 ;
.3D1:
!BCC_EOS
! 2975           inhibit_mouse_int_and_events();
! Debug: func () unsigned char = inhibit_mouse_int_and_events+0 (used reg = )
call	_inhibit_mouse_int_and_events
!BCC_EOS
! 2976           ret = send_to_mouse_ctrl(0xF2);
! Debug: list int = const $F2 (used reg = )
mov	ax,#$F2
push	ax
! Debug: func () unsigned char = send_to_mouse_ctrl+0 (used reg = )
call	_send_to_mouse_ctrl
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	-$B[bp],al
!BCC_EOS
! 2977           if (ret == 0) {
! Debug: logeq int = const 0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	al,-$B[bp]
test	al,al
jne 	.3D2
.3D3:
! 2978             ret = get_mouse_data(&mouse_data1);
! Debug: list * unsigned char mouse_data1 = S+$10-$E (used reg = )
lea	bx,-$C[bp]
push	bx
! Debug: func () unsigned char = get_mouse_data+0 (used reg = )
call	_get_mouse_data
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	-$B[bp],al
!BCC_EOS
! 2979             ret = get_mouse_data(&mouse_data2);
! Debug: list * unsigned char mouse_data2 = S+$10-$F (used reg = )
lea	bx,-$D[bp]
push	bx
! Debug: func () unsigned char = get_mouse_data+0 (used reg = )
call	_get_mouse_data
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	-$B[bp],al
!BCC_EOS
! 2980             FLAGS &= 0xfffe;
! Debug: andab unsigned int = const $FFFE to unsigned short FLAGS = [S+$10+$16] (used reg = )
mov	ax,$18[bp]
and	al,#$FE
mov	$18[bp],ax
!BCC_EOS
! 2981             regs.u.r8.ah = 0;
! Debug: eq int = const 0 to unsigned char regs = [S+$10+$11] (used reg = )
xor	al,al
mov	$13[bp],al
!BCC_EOS
! 2982             regs.u.r8.bh = mouse_data2;
! Debug: eq unsigned char mouse_data2 = [S+$10-$F] to unsigned char regs = [S+$10+$B] (used reg = )
mov	al,-$D[bp]
mov	$D[bp],al
!BCC_EOS
! 2983           } else {
jmp .3D4
.3D2:
! 2984             FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$10+$16] (used reg = )
mov	ax,$18[bp]
or	al,*1
mov	$18[bp],ax
!BCC_EOS
! 2985             regs.u.r8.ah = 0x86;
! Debug: eq int = const $86 to unsigned char regs = [S+$10+$11] (used reg = )
mov	al,#$86
mov	$13[bp],al
!BCC_EOS
! 2986           }
! 2987           break;
.3D4:
br 	.386
!BCC_EOS
! 2988         case 6:
! 2989 ;
.3D5:
!BCC_EOS
! 2990           switch (regs.u.r8.bh) {
mov	al,$D[bp]
br 	.3D8
! 2991             case 0:
! 2992               comm_byte = inhibit_mouse_int_and_events();
.3D9:
! Debug: func () unsigned char = inhibit_mouse_int_and_events+0 (used reg = )
call	_inhibit_mouse_int_and_events
! Debug: eq unsigned char = al+0 to unsigned char comm_byte = [S+$10-$B] (used reg = )
mov	-9[bp],al
!BCC_EOS
! 2993               ret = send_to_mouse_ctrl(0xE9);
! Debug: list int = const $E9 (used reg = )
mov	ax,#$E9
push	ax
! Debug: func () unsigned char = send_to_mouse_ctrl+0 (used reg = )
call	_send_to_mouse_ctrl
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	-$B[bp],al
!BCC_EOS
! 2994               if (ret == 0) {
! Debug: logeq int = const 0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	al,-$B[bp]
test	al,al
bne 	.3DA
.3DB:
! 2995                 ret = get_mouse_data(&mouse_data1);
! Debug: list * unsigned char mouse_data1 = S+$10-$E (used reg = )
lea	bx,-$C[bp]
push	bx
! Debug: func () unsigned char = get_mouse_data+0 (used reg = )
call	_get_mouse_data
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	-$B[bp],al
!BCC_EOS
! 2996                 if (mouse_data1 != 0xfa)
! Debug: ne int = const $FA to unsigned char mouse_data1 = [S+$10-$E] (used reg = )
mov	al,-$C[bp]
cmp	al,#$FA
je  	.3DC
.3DD:
! 2997                   bios_printf((2 | 4 | 1), "Mouse status returned %02x (should be ack)\n", (unsigned)mouse_data1);
! Debug: list unsigned char mouse_data1 = [S+$10-$E] (used reg = )
mov	al,-$C[bp]
xor	ah,ah
push	ax
! Debug: list * char = .3DE+0 (used reg = )
mov	bx,#.3DE
push	bx
! Debug: list int = const 7 (used reg = )
mov	ax,*7
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*6
!BCC_EOS
! 2998                 if (ret == 0) {
.3DC:
! Debug: logeq int = const 0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	al,-$B[bp]
test	al,al
bne 	.3DF
.3E0:
! 2999                   ret = get_mouse_data(&mouse_data1);
! Debug: list * unsigned char mouse_data1 = S+$10-$E (used reg = )
lea	bx,-$C[bp]
push	bx
! Debug: func () unsigned char = get_mouse_data+0 (used reg = )
call	_get_mouse_data
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	-$B[bp],al
!BCC_EOS
! 3000                   if (ret == 0) {
! Debug: logeq int = const 0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	al,-$B[bp]
test	al,al
bne 	.3E1
.3E2:
! 3001                     ret = get_mouse_data(&mouse_data2);
! Debug: list * unsigned char mouse_data2 = S+$10-$F (used reg = )
lea	bx,-$D[bp]
push	bx
! Debug: func () unsigned char = get_mouse_data+0 (used reg = )
call	_get_mouse_data
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	-$B[bp],al
!BCC_EOS
! 3002                     if (ret == 0) {
! Debug: logeq int = const 0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	al,-$B[bp]
test	al,al
jne 	.3E3
.3E4:
! 3003  
! 3003                      ret = get_mouse_data(&mouse_data3);
! Debug: list * unsigned char mouse_data3 = S+$10-$10 (used reg = )
lea	bx,-$E[bp]
push	bx
! Debug: func () unsigned char = get_mouse_data+0 (used reg = )
call	_get_mouse_data
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	-$B[bp],al
!BCC_EOS
! 3004                       if (ret == 0) {
! Debug: logeq int = const 0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	al,-$B[bp]
test	al,al
jne 	.3E5
.3E6:
! 3005                         FLAGS &= 0xfffe;
! Debug: andab unsigned int = const $FFFE to unsigned short FLAGS = [S+$10+$16] (used reg = )
mov	ax,$18[bp]
and	al,#$FE
mov	$18[bp],ax
!BCC_EOS
! 3006                         regs.u.r8.ah = 0;
! Debug: eq int = const 0 to unsigned char regs = [S+$10+$11] (used reg = )
xor	al,al
mov	$13[bp],al
!BCC_EOS
! 3007                         regs.u.r8.bl = mouse_data1;
! Debug: eq unsigned char mouse_data1 = [S+$10-$E] to unsigned char regs = [S+$10+$A] (used reg = )
mov	al,-$C[bp]
mov	$C[bp],al
!BCC_EOS
! 3008                         regs.u.r8.cl = mouse_data2;
! Debug: eq unsigned char mouse_data2 = [S+$10-$F] to unsigned char regs = [S+$10+$E] (used reg = )
mov	al,-$D[bp]
mov	$10[bp],al
!BCC_EOS
! 3009                         regs.u.r8.dl = mouse_data3;
! Debug: eq unsigned char mouse_data3 = [S+$10-$10] to unsigned char regs = [S+$10+$C] (used reg = )
mov	al,-$E[bp]
mov	$E[bp],al
!BCC_EOS
! 3010                         set_kbd_command_byte(comm_byte);
! Debug: list unsigned char comm_byte = [S+$10-$B] (used reg = )
mov	al,-9[bp]
xor	ah,ah
push	ax
! Debug: func () void = set_kbd_command_byte+0 (used reg = )
call	_set_kbd_command_byte
inc	sp
inc	sp
!BCC_EOS
! 3011                         return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 3012                       }
! 3013                     }
.3E5:
! 3014                   }
.3E3:
! 3015                 }
.3E1:
! 3016               }
.3DF:
! 3017               FLAGS |= 0x0001;
.3DA:
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$10+$16] (used reg = )
mov	ax,$18[bp]
or	al,*1
mov	$18[bp],ax
!BCC_EOS
! 3018               regs.u.r8.ah = ret;
! Debug: eq unsigned char ret = [S+$10-$D] to unsigned char regs = [S+$10+$11] (used reg = )
mov	al,-$B[bp]
mov	$13[bp],al
!BCC_EOS
! 3019               set_kbd_command_byte(comm_byte);
! Debug: list unsigned char comm_byte = [S+$10-$B] (used reg = )
mov	al,-9[bp]
xor	ah,ah
push	ax
! Debug: func () void = set_kbd_command_byte+0 (used reg = )
call	_set_kbd_command_byte
inc	sp
inc	sp
!BCC_EOS
! 3020               return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 3021             case 1:
! 3022             case 2:
.3E7:
! 3023               comm_byte = inhibit_mouse_int_and_events();
.3E8:
! Debug: func () unsigned char = inhibit_mouse_int_and_events+0 (used reg = )
call	_inhibit_mouse_int_and_events
! Debug: eq unsigned char = al+0 to unsigned char comm_byte = [S+$10-$B] (used reg = )
mov	-9[bp],al
!BCC_EOS
! 3024               if (regs.u.r8.bh == 1) {
! Debug: logeq int = const 1 to unsigned char regs = [S+$10+$B] (used reg = )
mov	al,$D[bp]
cmp	al,*1
jne 	.3E9
.3EA:
! 3025                 ret = send_to_mouse_ctrl(0xE6);
! Debug: list int = const $E6 (used reg = )
mov	ax,#$E6
push	ax
! Debug: func () unsigned char = send_to_mouse_ctrl+0 (used reg = )
call	_send_to_mouse_ctrl
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	-$B[bp],al
!BCC_EOS
! 3026               } else {
jmp .3EB
.3E9:
! 3027                 ret = send_to_mouse_ctrl(0xE7);
! Debug: list int = const $E7 (used reg = )
mov	ax,#$E7
push	ax
! Debug: func () unsigned char = send_to_mouse_ctrl+0 (used reg = )
call	_send_to_mouse_ctrl
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	-$B[bp],al
!BCC_EOS
! 3028               }
! 3029               if (ret == 0) {
.3EB:
! Debug: logeq int = const 0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	al,-$B[bp]
test	al,al
jne 	.3EC
.3ED:
! 3030                 get_mouse_data(&mouse_data1);
! Debug: list * unsigned char mouse_data1 = S+$10-$E (used reg = )
lea	bx,-$C[bp]
push	bx
! Debug: func () unsigned char = get_mouse_data+0 (used reg = )
call	_get_mouse_data
inc	sp
inc	sp
!BCC_EOS
! 3031                 ret = (mouse_data1 != 0xFA);
! Debug: ne int = const $FA to unsigned char mouse_data1 = [S+$10-$E] (used reg = )
mov	al,-$C[bp]
cmp	al,#$FA
je 	.3EE
mov	al,*1
jmp	.3EF
.3EE:
xor	al,al
.3EF:
! Debug: eq char = al+0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	-$B[bp],al
!BCC_EOS
! 3032               }
! 3033               if (ret == 0) {
.3EC:
! Debug: logeq int = const 0 to unsigned char ret = [S+$10-$D] (used reg = )
mov	al,-$B[bp]
test	al,al
jne 	.3F0
.3F1:
! 3034                 FLAGS &= 0xfffe;
! Debug: andab unsigned int = const $FFFE to unsigned short FLAGS = [S+$10+$16] (used reg = )
mov	ax,$18[bp]
and	al,#$FE
mov	$18[bp],ax
!BCC_EOS
! 3035                 regs.u.r8.ah = 0;
! Debug: eq int = const 0 to unsigned char regs = [S+$10+$11] (used reg = )
xor	al,al
mov	$13[bp],al
!BCC_EOS
! 3036               } else {
jmp .3F2
.3F0:
! 3037                 FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$10+$16] (used reg = )
mov	ax,$18[bp]
or	al,*1
mov	$18[bp],ax
!BCC_EOS
! 3038                 regs.u.r8.ah = 0x86;
! Debug: eq int = const $86 to unsigned char regs = [S+$10+$11] (used reg = )
mov	al,#$86
mov	$13[bp],al
!BCC_EOS
! 3039               }
! 3040               set_kbd_command_byte(comm_byte);
.3F2:
! Debug: list unsigned char comm_byte = [S+$10-$B] (used reg = )
mov	al,-9[bp]
xor	ah,ah
push	ax
! Debug: func () void = set_kbd_command_byte+0 (used reg = )
call	_set_kbd_command_byte
inc	sp
inc	sp
!BCC_EOS
! 3041               break;
jmp .3D6
!BCC_EOS
! 3042             default:
! 3043               bios_printf((2 | 4 | 1), "INT 15h C2 AL=6, BH=%02x\n", (unsigned) regs.u.r8.bh);
.3F3:
! Debug: list unsigned char regs = [S+$10+$B] (used reg = )
mov	al,$D[bp]
xor	ah,ah
push	ax
! Debug: list * char = .3F4+0 (used reg = )
mov	bx,#.3F4
push	bx
! Debug: list int = const 7 (used reg = )
mov	ax,*7
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*6
!BCC_EOS
! 3044           }
! 3045           break;
jmp .3D6
.3D8:
sub	al,*0
beq 	.3D9
sub	al,*1
beq 	.3E7
sub	al,*1
beq 	.3E8
jmp	.3F3
.3D6:
br 	.386
!BCC_EOS
! 3046         case 7:
! 3047 ;
.3F5:
!BCC_EOS
! 3048           mouse_driver_seg = ES;
! Debug: eq unsigned short ES = [S+$10+$12] to unsigned short mouse_driver_seg = [S+$10-8] (used reg = )
mov	ax,$14[bp]
mov	-6[bp],ax
!BCC_EOS
! 3049           mouse_driver_offset = regs.u.r16.bx;
! Debug: eq unsigned short regs = [S+$10+$A] to unsigned short mouse_driver_offset = [S+$10-$A] (used reg = )
mov	ax,$C[bp]
mov	-8[bp],ax
!BCC_EOS
! 3050           _write_word(mouse_driver_offset, &((ebda_data_t *) 0)->mouse_driver_offset, ebda_seg);
! Debug: list unsigned short ebda_seg = [S+$10-4] (used reg = )
push	-2[bp]
! Debug: list * unsigned short = const $22 (used reg = )
mov	ax,*$22
push	ax
! Debug: list unsigned short mouse_driver_offset = [S+$14-$A] (used reg = )
push	-8[bp]
! Debug: func () void = _write_word+0 (used reg = )
call	__write_word
add	sp,*6
!BCC_EOS
! 3051           _write_word(mouse_driver_seg, &((ebda_data_t *) 0)->mouse_driver_seg, ebda_seg);
! Debug: list unsigned short ebda_seg = [S+$10-4] (used reg = )
push	-2[bp]
! Debug: list * unsigned short = const $24 (used reg = )
mov	ax,*$24
push	ax
! Debug: list unsigned short mouse_driver_seg = [S+$14-8] (used reg = )
push	-6[bp]
! Debug: func () void = _write_word+0 (used reg = )
call	__write_word
add	sp,*6
!BCC_EOS
! 3052           mouse_flags_2 = _read_byte(&((ebda_data_t *) 0)->mouse_flag2, ebda_seg);
! Debug: list unsigned short ebda_seg = [S+$10-4] (used reg = )
push	-2[bp]
! Debug: list * unsigned char = const $27 (used reg = )
mov	ax,*$27
push	ax
! Debug: func () unsigned char = _read_byte+0 (used reg = )
call	__read_byte
add	sp,*4
! Debug: eq unsigned char = al+0 to unsigned char mouse_flags_2 = [S+$10-6] (used reg = )
mov	-4[bp],al
!BCC_EOS
! 3053           if (mouse_driver_offset == 0 && mouse_driver_seg == 0) {
! Debug: logeq int = const 0 to unsigned short mouse_driver_offset = [S+$10-$A] (used reg = )
mov	ax,-8[bp]
test	ax,ax
jne 	.3F6
.3F8:
! Debug: logeq int = const 0 to unsigned short mouse_driver_seg = [S+$10-8] (used reg = )
mov	ax,-6[bp]
test	ax,ax
jne 	.3F6
.3F7:
! 3054             if ( (mouse_flags_2 & 0x80) != 0 ) {
! Debug: and int = const $80 to unsigned char mouse_flags_2 = [S+$10-6] (used reg = )
mov	al,-4[bp]
and	al,#$80
! Debug: ne int = const 0 to unsigned char = al+0 (used reg = )
test	al,al
je  	.3F9
.3FA:
! 3055               mouse_flags_2 &= ~0x80;
! Debug: andab int = const -$81 to unsigned char mouse_flags_2 = [S+$10-6] (used reg = )
mov	al,-4[bp]
and	al,*$7F
mov	-4[bp],al
!BCC_EOS
! 3056               inhibit_mouse_int_and_even
! 3056 ts();
! Debug: func () unsigned char = inhibit_mouse_int_and_events+0 (used reg = )
call	_inhibit_mouse_int_and_events
!BCC_EOS
! 3057             }
! 3058           }
.3F9:
! 3059           else {
jmp .3FB
.3F6:
! 3060             mouse_flags_2 |= 0x80;
! Debug: orab int = const $80 to unsigned char mouse_flags_2 = [S+$10-6] (used reg = )
mov	al,-4[bp]
or	al,#$80
mov	-4[bp],al
!BCC_EOS
! 3061           }
! 3062           _write_byte(mouse_flags_2, &((ebda_data_t *) 0)->mouse_flag2, ebda_seg);
.3FB:
! Debug: list unsigned short ebda_seg = [S+$10-4] (used reg = )
push	-2[bp]
! Debug: list * unsigned char = const $27 (used reg = )
mov	ax,*$27
push	ax
! Debug: list unsigned char mouse_flags_2 = [S+$14-6] (used reg = )
mov	al,-4[bp]
xor	ah,ah
push	ax
! Debug: func () void = _write_byte+0 (used reg = )
call	__write_byte
add	sp,*6
!BCC_EOS
! 3063           FLAGS &= 0xfffe;
! Debug: andab unsigned int = const $FFFE to unsigned short FLAGS = [S+$10+$16] (used reg = )
mov	ax,$18[bp]
and	al,#$FE
mov	$18[bp],ax
!BCC_EOS
! 3064           regs.u.r8.ah = 0;
! Debug: eq int = const 0 to unsigned char regs = [S+$10+$11] (used reg = )
xor	al,al
mov	$13[bp],al
!BCC_EOS
! 3065           break;
jmp .386
!BCC_EOS
! 3066         default:
! 3067 ;
.3FC:
!BCC_EOS
! 3068           regs.u.r8.ah = 1;
! Debug: eq int = const 1 to unsigned char regs = [S+$10+$11] (used reg = )
mov	al,*1
mov	$13[bp],al
!BCC_EOS
! 3069           FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$10+$16] (used reg = )
mov	ax,$18[bp]
or	al,*1
mov	$18[bp],ax
!BCC_EOS
! 3070       }
! 3071       break;
jmp .386
.388:
sub	al,*0
jb 	.3FC
cmp	al,*7
ja  	.3FD
xor	ah,ah
shl	ax,*1
mov	bx,ax
seg	cs
br	.3FE[bx]
.3FE:
.word	.389
.word	.39C
.word	.3B0
.word	.3C4
.word	.3D1
.word	.39D
.word	.3D5
.word	.3F5
.3FD:
jmp	.3FC
.386:
jmp .382
!BCC_EOS
! 3072     default:
! 3073       bios_printf(4, "*** int 15h function AX=%04x, BX=%04x not yet supported!\n", (unsigned) regs.u.r16.ax, (unsigned) regs.u.r16.bx);
.3FF:
! Debug: list unsigned short regs = [S+$10+$A] (used reg = )
push	$C[bp]
! Debug: list unsigned short regs = [S+$12+$10] (used reg = )
push	$12[bp]
! Debug: list * char = .400+0 (used reg = )
mov	bx,#.400
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*8
!BCC_EOS
! 3074       FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$10+$16] (used reg = )
mov	ax,$18[bp]
or	al,*1
mov	$18[bp],ax
!BCC_EOS
! 3075       regs.u.r8.ah = 0x86;
! Debug: eq int = const $86 to unsigned char regs = [S+$10+$11] (used reg = )
mov	al,#$86
mov	$13[bp],al
!BCC_EOS
! 3076       break;
jmp .382
!BCC_EOS
! 3077   }
! 3078 }
jmp .382
.384:
sub	al,#$C2
beq 	.385
jmp	.3FF
.382:
..FFF6	=	-$10
mov	sp,bp
pop	bp
ret
! 3079 void set_e820_range(ES, DI, start, end, extra_start, extra_end, type)
! Register BX used in function int15_function_mouse
! 3080      Bit16u ES;
export	_set_e820_range
_set_e820_range:
!BCC_EOS
! 3081      Bit16u DI;
!BCC_EOS
! 3082      Bit32u start;
!BCC_EOS
! 3083      Bit32u end;
!BCC_EOS
! 3084      Bit8u extra_start;
!BCC_EOS
! 3085      Bit8u extra_end;
!BCC_EOS
! 3086      Bit16u type;
!BCC_EOS
! 3087 {
! 3088     Bit16u old_ds = set_DS(ES);
push	bp
mov	bp,sp
dec	sp
dec	sp
! Debug: list unsigned short ES = [S+4+2] (used reg = )
push	4[bp]
! Debug: func () unsigned short = set_DS+0 (used reg = )
call	_set_DS
inc	sp
inc	sp
! Debug: eq unsigned short = ax+0 to unsigned short old_ds = [S+4-4] (used reg = )
mov	-2[bp],ax
!BCC_EOS
! 3089     *((Bit32u *)(DI)) = (start);
mov	bx,6[bp]
! Debug: eq unsigned long start = [S+4+6] to unsigned long = [bx+0] (used reg = )
mov	ax,8[bp]
mov	si,$A[bp]
mov	[bx],ax
mov	2[bx],si
!BCC_EOS
! 3090     *((Bit16u *)(DI+4)) = (extra_start);
! Debug: add int = const 4 to unsigned short DI = [S+4+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned short = const 0 to unsigned int = ax+4 (used reg = )
mov	bx,ax
! Debug: eq unsigned char extra_start = [S+4+$E] to unsigned short = [bx+4] (used reg = )
mov	al,$10[bp]
xor	ah,ah
mov	4[bx],ax
!BCC_EOS
! 3091     *((Bit16u *)(DI+6)) = (0x00);
! Debug: add int = const 6 to unsigned short DI = [S+4+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned short = const 0 to unsigned int = ax+6 (used reg = )
mov	bx,ax
! Debug: eq int = const 0 to unsigned short = [bx+6] (used reg = )
xor	ax,ax
mov	6[bx],ax
!BCC_EOS
! 3092     end -= start;
! Debug: subab unsigned long start = [S+4+6] to unsigned long end = [S+4+$A] (used reg = )
mov	ax,$C[bp]
mov	bx,$E[bp]
lea	di,8[bp]
call	lsubul
mov	$C[bp],ax
mov	$E[bp],bx
!BCC_EOS
! 3093     extra_end -= extra_start;
! Debug: subab unsigned char extra_start = [S+4+$E] to unsigned char extra_end = [S+4+$10] (used reg = )
mov	al,$12[bp]
xor	ah,ah
sub	al,$10[bp]
sbb	ah,*0
mov	$12[bp],al
!BCC_EOS
! 3094     *((Bit32u *)(DI+8)) = (end);
! Debug: add int = const 8 to unsigned short DI = [S+4+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned long = const 0 to unsigned int = ax+8 (used reg = )
mov	bx,ax
! Debug: eq unsigned long end = [S+4+$A] to unsigned long = [bx+8] (used reg = )
mov	ax,$C[bp]
mov	si,$E[bp]
mov	8[bx],ax
mov	$A[bx],si
!BCC_EOS
! 3095     *((Bit16u *)(DI+12)) = (extra_end);
! Debug: add int = const $C to unsigned short DI = [S+4+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned short = const 0 to unsigned int = ax+$C (used reg = )
mov	bx,ax
! Debug: eq unsigned char extra_end = [S+4+$10] to unsigned short = [bx+$C] (used reg = )
mov	al,$12[bp]
xor	ah,ah
mov	$C[bx],ax
!BCC_EOS
! 3096     *((Bit16u *)(DI+14)) = (0x0000);
! Debug: add int = const $E to unsigned short DI = [S+4+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned short = const 0 to unsigned int = ax+$E (used reg = )
mov	bx,ax
! Debug: eq int = const 0 to unsigned short = [bx+$E] (used reg = )
xor	ax,ax
mov	$E[bx],ax
!BCC_EOS
! 3097     *((Bit16u *)(DI+16)) = (type);
! Debug: add int = const $10 to unsigned short DI = [S+4+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned short = const 0 to unsigned int = ax+$10 (used reg = )
mov	bx,ax
! Debug: eq unsigned short type = [S+4+$12] to unsigned short = [bx+$10] (used reg = )
mov	ax,$14[bp]
mov	$10[bx],ax
!BCC_EOS
! 3098     *((Bit16u *)(DI+18)) = (0x0);
! Debug: add int = const $12 to unsigned short DI = [S+4+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned short = const 0 to unsigned int = ax+$12 (used reg = )
mov	bx,ax
! Debug: eq int = const 0 to unsigned short = [bx+$12] (used reg = )
xor	ax,ax
mov	$12[bx],ax
!BCC_EOS
! 3099     set_DS(old_ds);
! Debug: list unsigned short old_ds = [S+4-4] (used reg = )
push	-2[bp]
! Debug: func () unsigned short = set_DS+0 (used reg = )
call	_set_DS
inc	sp
inc	sp
!BCC_EOS
! 3100 }
mov	sp,bp
pop	bp
ret
! 3101   void
! Register BX used in function set_e820_range
! 3102 int15_function32(regs, ES, DS, FLAGS)
! 3103   pushad_regs_t regs;
export	_int15_function32
_int15_function32:
!BCC_EOS
! 3104   Bit16u ES, DS, FLAGS;
!BCC_EOS
! 3105 {
! 3106   Bit32u extended_memory_size=0;
push	bp
mov	bp,sp
add	sp,*-4
! Debug: eq int = const 0 to unsigned long extended_memory_size = [S+6-6] (used reg = )
xor	ax,ax
xor	bx,bx
mov	-4[bp],ax
mov	-2[bp],bx
!BCC_EOS
! 3107   Bit32u extra_lowbits_memory_size=0;
add	sp,*-4
! Debug: eq int = const 0 to unsigned long extra_lowbits_memory_size = [S+$A-$A] (used reg = )
xor	ax,ax
xor	bx,bx
mov	-8[bp],ax
mov	-6[bp],bx
!BCC_EOS
! 3108   Bit16u CX,DX;
!BCC_EOS
! 3109   Bit8u extra_highbits_memory_size=0;
add	sp,*-5
! Debug: eq int = const 0 to unsigned char extra_highbits_memory_size = [S+$F-$F] (used reg = )
xor	al,al
mov	-$D[bp],al
!BCC_EOS
! 3110 ;
dec	sp
!BCC_EOS
! 3111   switch (regs.u.r8.ah) {
mov	al,$21[bp]
br 	.403
! 3112     case 0x86:
! 3113       CX = regs.u.r16.cx;
.404:
! Debug: eq unsigned short regs = [S+$10+$1A] to unsigned short CX = [S+$10-$C] (used reg = )
mov	ax,$1C[bp]
mov	-$A[bp],ax
!BCC_EOS
! 3114       DX = regs.u.r16.dx;
! Debug: eq unsigned short regs = [S+$10+$16] to unsigned short DX = [S+$10-$E] (used reg = )
mov	ax,$18[bp]
mov	-$C[bp],ax
!BCC_EOS
! 3115 #asm
!BCC_EOS
!BCC_ASM
_int15_function32.CX	set	4
.int15_function32.CX	set	-$A
_int15_function32.extra_highbits_memory_size	set	1
.int15_function32.extra_highbits_memory_size	set	-$D
_int15_function32.extra_lowbits_memory_size	set	6
.int15_function32.extra_lowbits_memory_size	set	-8
_int15_function32.extended_memory_size	set	$A
.int15_function32.extended_memory_size	set	-4
_int15_function32.FLAGS	set	$36
.int15_function32.FLAGS	set	$28
_int15_function32.DS	set	$34
.int15_function32.DS	set	$26
_int15_function32.DX	set	2
.int15_function32.DX	set	-$C
_int15_function32.ES	set	$32
.int15_function32.ES	set	$24
_int15_function32.regs	set	$12
.int15_function32.regs	set	4
      sti
      ;; Get the count in eax
      mov bx, sp
      SEG SS
        mov ax, _int15_function32.CX [bx]
      shl eax, #16
      SEG SS
        mov ax, _int15_function32.DX [bx]
      ;; convert to numbers of 15usec ticks
      mov ebx, #15
      xor edx, edx
      div eax, ebx
      mov ecx, eax
      ;; wait for ecx number of refresh requests
      in al, 0x0061
      and al,#0x10
      mov ah, al
      or ecx, ecx
      je int1586_tick_end
int1586_tick:
      in al, 0x0061
      and al,#0x10
      cmp al, ah
      je int1586_tick
      mov ah, al
      dec ecx
      jnz int1586_tick
int1586_tick_end:
! 3144 endasm
!BCC_ENDASM
!BCC_EOS
! 3145       break;
br 	.401
!BCC_EOS
! 3146     case 0xe8:
! 3147         switch(regs.u.r8.al) {
.405:
mov	al,$20[bp]
br 	.408
! 3148          case 0x20:
! 3149             if (regs.u.r32.edx == 0x534D4150) {
.409:
! Debug: logeq long = const $534D4150 to unsigned long regs = [S+$10+$16] (used reg = )
! Debug: expression subtree swapping
mov	ax,#$4150
mov	bx,#$534D
push	bx
push	ax
mov	ax,$18[bp]
mov	bx,$1A[bp]
lea	di,-2+..FFF5[bp]
call	lcmpul
lea	sp,2+..FFF5[bp]
bne 	.40A
.40B:
! 3150                 *((Bit8u *)&extended_memory_size) = inb_cmos(0x34);
! Debug: list int = const $34 (used reg = )
mov	ax,*$34
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char extended_memory_size = [S+$10-6] (used reg = )
mov	-4[bp],al
!BCC_EOS
! 3151                 *(((Bit8u *)&*((Bit16u *)&extended_memory_size))+1) = inb_cmos(0x35);
! Debug: list int = const $35 (used reg = )
mov	ax,*$35
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char extended_memory_size = [S+$10-5] (used reg = )
mov	-3[bp],al
!BCC_EOS
! 3152                 extended_memory_size *= 64;
! Debug: mulab unsigned long = const $40 to unsigned long extended_memory_size = [S+$10-6] (used reg = )
mov	ax,*$40
xor	bx,bx
push	bx
push	ax
mov	ax,-4[bp]
mov	bx,-2[bp]
lea	di,-2+..FFF5[bp]
call	lmulul
mov	-4[bp],ax
mov	-2[bp],bx
add	sp,*4
!BCC_EOS
! 3153                 if (extended_memory_size > 0x2fc000) {
! Debug: gt long = const $2FC000 to unsigned long extended_memory_size = [S+$10-6] (used reg = )
mov	ax,#$C000
mov	bx,*$2F
lea	di,-4[bp]
call	lcmpul
bhis	.40C
.40D:
! 3154                     extended_memory_size = 0x2fc000;
! Debug: eq long = const $2FC000 to unsigned long extended_memory_size = [S+$10-6] (used reg = )
mov	ax,#$C000
mov	bx,*$2F
mov	-4[bp],ax
mov	-2[bp],bx
!BCC_EOS
! 3155                 }
! 3156                 extended_memory_size *= 1024;
.40C:
! Debug: mulab unsigned long = const $400 to unsigned long extended_memory_size = [S+$10-6] (used reg = )
mov	ax,#$400
xor	bx,bx
push	bx
push	ax
mov	ax,-4[bp]
mov	bx,-2[bp]
lea	di,-2+..FFF5[bp]
call	lmulul
mov	-4[bp],ax
mov	-2[bp],bx
add	sp,*4
!BCC_EOS
! 3157                 extended_memory_size += (16L * 1024 * 1024);
! Debug: addab long = const $1000000 to unsigned long extended_memory_size = [S+$10-6] (used reg = )
xor	ax,ax
mov	bx,#$100
push	bx
push	ax
mov	ax,-4[bp]
mov	bx,-2[bp]
lea	di,-2+..FFF5[bp]
call	laddul
mov	-4[bp],ax
mov	-2[bp],bx
add	sp,*4
!BCC_EOS
! 3158                 if (extended_memory_size <= (16L * 1024 * 1024)) {
! Debug: le long = const $1000000 to unsigned long extended_memory_size = [S+$10-6] (used reg = )
xor	ax,ax
mov	bx,#$100
lea	di,-4[bp]
call	lcmpul
jb  	.40E
.40F:
! 3159                     *((Bit8u *)&extended_memory_size) = inb_cmos(0x30);
! Debug: list int = const $30 (used reg = )
mov	ax,*$30
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char extended_memory_size = [S+$10-6] (used reg = )
mov	-4[bp],al
!BCC_EOS
! 3160                     *(((Bit8u *)&*((Bit16u *)&extended_memory_size))+1) = inb_cmos(0x31);
! Debug: list int = const $31 (used reg = )
mov	ax,*$31
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char extended_memory_size = [S+$10-5] (used reg = )
mov	-3[bp],al
!BCC_EOS
! 3161                     extended_memory_size *= 1024;
! Debug: mulab unsigned long = const $400 to unsigned long extended_memory_size = [S+$10-6] (used reg = )
mov	ax,#$400
xor	bx,bx
push	bx
push	ax
mov	ax,-4[bp]
mov	bx,-2[bp]
lea	di,-2+..FFF5[bp]
call	lmulul
mov	-4[bp],ax
mov	-2[bp],bx
add	sp,*4
!BCC_EOS
! 3162                     extended_memory_size += (1L * 1024 * 1024);
! Debug: addab long = const $100000 to unsigned long extended_memory_size = [S+$10-6] (used reg = )
xor	ax,ax
mov	bx,*$10
push	bx
push	ax
mov	ax,-4[bp]
mov	bx,-2[bp]
lea	di,-2+..FFF5[bp]
call	laddul
mov	-4[bp],ax
mov	-2[bp],bx
add	sp,*4
!BCC_EOS
! 3163                 }
! 3164                 *((Bit8u *)&*(((Bit16u *)&extra_lowbits_memory_size)+1)) = inb_cmos(0x5b);
.40E:
! Debug: list int = const $5B (used reg = )
mov	ax,*$5B
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char extra_lowbits_memory_size = [S+$10-8] (used reg = )
mov	-6[bp],al
!BCC_EOS
! 3165                 *(((Bit8u *)&*(((Bit16u *)&extra_lowbits_memory_size)+1))+1) = inb_cmos(0x5c);
! Debug: list int = const $5C (used reg = )
mov	ax,*$5C
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char extra_lowbits_memory_size = [S+$10-7] (used reg = )
mov	-5[bp],al
!BCC_EOS
! 3166                 *((Bit16u *)&extra_lowbits_memory_size) = 0;
! Debug: eq int = const 0 to unsigned short extra_lowbits_memory_size = [S+$10-$A] (used reg = )
xor	ax,ax
mov	-8[bp],ax
!BCC_EOS
! 3167                 extra_highbits_memory_size = inb_cmos(0x5d);
! Debug: list int = const $5D (used reg = )
mov	ax,*$5D
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char extra_highbits_memory_size = [S+$10-$F] (used reg = )
mov	-$D[bp],al
!BCC_EOS
! 3168                 switch(regs.u.r16.bx)
mov	ax,$14[bp]
! 3169                 {
br 	.412
! 3170                     case 0:
! 3171                         set_e820_range(ES, regs.u.r16.di,
.413:
! 3172                                        0x0000000L, 0x0009f000L, 0, 0, 1);
! Debug: list int = const 1 (used reg = )
mov	ax,*1
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list long = const $9F000 (used reg = )
mov	ax,#$F000
mov	bx,*9
push	bx
push	ax
! Debug: list long = const 0 (used reg = )
xor	ax,ax
xor	bx,bx
push	bx
push	ax
! Debug: list unsigned short regs = [S+$1E+2] (used reg = )
push	4[bp]
! Debug: list unsigned short ES = [S+$20+$22] (used reg = )
push	$24[bp]
! Debug: func () void = set_e820_range+0 (used reg = )
call	_set_e820_range
add	sp,*$12
!BCC_EOS
! 3173                         regs.u.r32.ebx = 1;
! Debug: eq int = const 1 to unsigned long regs = [S+$10+$12] (used reg = )
mov	ax,*1
xor	bx,bx
mov	$14[bp],ax
mov	$16[bp],bx
!BCC_EOS
! 3174                         break;
br 	.410
!BCC_EOS
! 3175                     case 1:
! 3176                         set_e820_range(ES, regs.u.r16.di,
.414:
! 3177                                        0x0009f000L, 0x000a0000L, 0, 0, 2);
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list long = const $A0000 (used reg = )
xor	ax,ax
mov	bx,*$A
push	bx
push	ax
! Debug: list long = const $9F000 (used reg = )
mov	ax,#$F000
mov	bx,*9
push	bx
push	ax
! Debug: list unsigned short regs = [S+$1E+2] (used reg = )
push	4[bp]
! Debug: list unsigned short ES = [S+$20+$22] (used reg = )
push	$24[bp]
! Debug: func () void = set_e820_range+0 (used reg = )
call	_set_e820_range
add	sp,*$12
!BCC_EOS
! 3178                         regs.u.r32.ebx = 2;
! Debug: eq int = const 2 to unsigned long regs = [S+$10+$12] (used reg = )
mov	ax,*2
xor	bx,bx
mov	$14[bp],ax
mov	$16[bp],bx
!BCC_EOS
! 3179                         break;
br 	.410
!BCC_EOS
! 3180                     case 2:
! 3181                         set_e820_range(ES, regs.u.r16.di,
.415:
! 3182                                        0x000e8000L, 0x00100000L, 0, 0, 2);
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list long = const $100000 (used reg = )
xor	ax,ax
mov	bx,*$10
push	bx
push	ax
! Debug: list long = const $E8000 (used reg = )
mov	ax,#$8000
mov	bx,*$E
push	bx
push	ax
! Debug: list unsigned short regs = [S+$1E+2] (used reg = )
push	4[bp]
! Debug: list unsigned short ES = [S+$20+$22] (used reg = )
push	$24[bp]
! Debug: func () void = set_e820_range+0 (used reg = )
call	_set_e820_range
add	sp,*$12
!BCC_EOS
! 3183                         if (extended_memory_size <= 0x100000)
! Debug: le long = const $100000 to unsigned long extended_memory_size = [S+$10-6] (used reg = )
xor	ax,ax
mov	bx,*$10
lea	di,-4[bp]
call	lcmpul
jb  	.416
.417:
! 3184                  
! 3184            regs.u.r32.ebx = 6;
! Debug: eq int = const 6 to unsigned long regs = [S+$10+$12] (used reg = )
mov	ax,*6
xor	bx,bx
mov	$14[bp],ax
mov	$16[bp],bx
!BCC_EOS
! 3185                         else
! 3186                             regs.u.r32.ebx = 3;
jmp .418
.416:
! Debug: eq int = const 3 to unsigned long regs = [S+$10+$12] (used reg = )
mov	ax,*3
xor	bx,bx
mov	$14[bp],ax
mov	$16[bp],bx
!BCC_EOS
! 3187                         break;
.418:
br 	.410
!BCC_EOS
! 3188                     case 3:
! 3189                         set_e820_range(ES, regs.u.r16.di,
.419:
! 3190                                        0x00100000L,
! 3191                                        extended_memory_size, 0, 0, 1);
! Debug: list int = const 1 (used reg = )
mov	ax,*1
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list unsigned long extended_memory_size = [S+$16-6] (used reg = )
push	-2[bp]
push	-4[bp]
! Debug: list long = const $100000 (used reg = )
xor	ax,ax
mov	bx,*$10
push	bx
push	ax
! Debug: list unsigned short regs = [S+$1E+2] (used reg = )
push	4[bp]
! Debug: list unsigned short ES = [S+$20+$22] (used reg = )
push	$24[bp]
! Debug: func () void = set_e820_range+0 (used reg = )
call	_set_e820_range
add	sp,*$12
!BCC_EOS
! 3192                         regs.u.r32.ebx = 6;
! Debug: eq int = const 6 to unsigned long regs = [S+$10+$12] (used reg = )
mov	ax,*6
xor	bx,bx
mov	$14[bp],ax
mov	$16[bp],bx
!BCC_EOS
! 3193                         break;
br 	.410
!BCC_EOS
! 3194                     case 4:
! 3195                         set_e820_range(ES, regs.u.r16.di,
.41A:
! 3196                                        extended_memory_size - 0x00010000L - 0x00002000,
! 3197                                        extended_memory_size - 0x00010000L, 0, 0, 2);
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: sub long = const $10000 to unsigned long extended_memory_size = [S+$16-6] (used reg = )
xor	ax,ax
mov	bx,*1
push	bx
push	ax
mov	ax,-4[bp]
mov	bx,-2[bp]
lea	di,-8+..FFF5[bp]
call	lsubul
add	sp,*4
! Debug: list unsigned long = bx+0 (used reg = )
push	bx
push	ax
! Debug: sub long = const $10000 to unsigned long extended_memory_size = [S+$1A-6] (used reg = )
xor	ax,ax
mov	bx,*1
push	bx
push	ax
mov	ax,-4[bp]
mov	bx,-2[bp]
lea	di,-$C+..FFF5[bp]
call	lsubul
add	sp,*4
! Debug: sub unsigned long = const $2000 to unsigned long = bx+0 (used reg = )
push	bx
push	ax
mov	ax,#$2000
xor	bx,bx
push	bx
push	ax
mov	ax,-$C+..FFF5[bp]
mov	bx,-$A+..FFF5[bp]
lea	di,-$10+..FFF5[bp]
call	lsubul
add	sp,*8
! Debug: list unsigned long = bx+0 (used reg = )
push	bx
push	ax
! Debug: list unsigned short regs = [S+$1E+2] (used reg = )
push	4[bp]
! Debug: list unsigned short ES = [S+$20+$22] (used reg = )
push	$24[bp]
! Debug: func () void = set_e820_range+0 (used reg = )
call	_set_e820_range
add	sp,*$12
!BCC_EOS
! 3198                         regs.u.r32.ebx = 5;
! Debug: eq int = const 5 to unsigned long regs = [S+$10+$12] (used reg = )
mov	ax,*5
xor	bx,bx
mov	$14[bp],ax
mov	$16[bp],bx
!BCC_EOS
! 3199                         break;
br 	.410
!BCC_EOS
! 3200                     case 5:
! 3201                         set_e820_range(ES, regs.u.r16.di,
.41B:
! 3202                                        extended_memory_size - 0x00010000L,
! 3203                                        extended_memory_size, 0, 0, 3);
! Debug: list int = const 3 (used reg = )
mov	ax,*3
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list unsigned long extended_memory_size = [S+$16-6] (used reg = )
push	-2[bp]
push	-4[bp]
! Debug: sub long = const $10000 to unsigned long extended_memory_size = [S+$1A-6] (used reg = )
xor	ax,ax
mov	bx,*1
push	bx
push	ax
mov	ax,-4[bp]
mov	bx,-2[bp]
lea	di,-$C+..FFF5[bp]
call	lsubul
add	sp,*4
! Debug: list unsigned long = bx+0 (used reg = )
push	bx
push	ax
! Debug: list unsigned short regs = [S+$1E+2] (used reg = )
push	4[bp]
! Debug: list unsigned short ES = [S+$20+$22] (used reg = )
push	$24[bp]
! Debug: func () void = set_e820_range+0 (used reg = )
call	_set_e820_range
add	sp,*$12
!BCC_EOS
! 3204                         regs.u.r32.ebx = 6;
! Debug: eq int = const 6 to unsigned long regs = [S+$10+$12] (used reg = )
mov	ax,*6
xor	bx,bx
mov	$14[bp],ax
mov	$16[bp],bx
!BCC_EOS
! 3205                         break;
br 	.410
!BCC_EOS
! 3206                     case 6:
! 3207                         set_e820_range(ES, regs.u.r16.di,
.41C:
! 3208                                        0xfffc0000L, 0x00000000L, 0, 0, 2);
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list long = const 0 (used reg = )
xor	ax,ax
xor	bx,bx
push	bx
push	ax
! Debug: list unsigned long = const $FFFC0000 (used reg = )
xor	ax,ax
mov	bx,#$FFFC
push	bx
push	ax
! Debug: list unsigned short regs = [S+$1E+2] (used reg = )
push	4[bp]
! Debug: list unsigned short ES = [S+$20+$22] (used reg = )
push	$24[bp]
! Debug: func () void = set_e820_range+0 (used reg = )
call	_set_e820_range
add	sp,*$12
!BCC_EOS
! 3209                         if (extra_highbits_memory_size || extra_lowbits_memory_size)
! Debug: cast unsigned long = const 0 to unsigned char extra_highbits_memory_size = [S+$10-$F] (used reg = )
mov	al,-$D[bp]
xor	ah,ah
xor	bx,bx
call	ltstl
jne 	.41E
.41F:
mov	ax,-8[bp]
mov	bx,-6[bp]
call	ltstl
je  	.41D
.41E:
! 3210                             regs.u.r32.ebx = 7;
! Debug: eq int = const 7 to unsigned long regs = [S+$10+$12] (used reg = )
mov	ax,*7
xor	bx,bx
mov	$14[bp],ax
mov	$16[bp],bx
!BCC_EOS
! 3211                         else
! 3212                             regs.u.r32.ebx = 0;
jmp .420
.41D:
! Debug: eq int = const 0 to unsigned long regs = [S+$10+$12] (used reg = )
xor	ax,ax
xor	bx,bx
mov	$14[bp],ax
mov	$16[bp],bx
!BCC_EOS
! 3213                         break;
.420:
jmp .410
!BCC_EOS
! 3214                     case 7:
! 3215                         set_e820_range(ES, regs.u.r16.di, 0x00000000L,
.421:
! 3216                             extra_lowbits_memory_size, 1, extra_highbits_memory_size
! 3217                                        + 1, 1);
! Debug: list int = const 1 (used reg = )
mov	ax,*1
push	ax
! Debug: add int = const 1 to unsigned char extra_highbits_memory_size = [S+$12-$F] (used reg = )
mov	al,-$D[bp]
xor	ah,ah
! Debug: list unsigned int = ax+1 (used reg = )
inc	ax
push	ax
! Debug: list int = const 1 (used reg = )
mov	ax,*1
push	ax
! Debug: list unsigned long extra_lowbits_memory_size = [S+$16-$A] (used reg = )
push	-6[bp]
push	-8[bp]
! Debug: list long = const 0 (used reg = )
xor	ax,ax
xor	bx,bx
push	bx
push	ax
! Debug: list unsigned short regs = [S+$1E+2] (used reg = )
push	4[bp]
! Debug: list unsigned short ES = [S+$20+$22] (used reg = )
push	$24[bp]
! Debug: func () void = set_e820_range+0 (used reg = )
call	_set_e820_range
add	sp,*$12
!BCC_EOS
! 3218                         regs.u.r32.ebx = 0;
! Debug: eq int = const 0 to unsigned long regs = [S+$10+$12] (used reg = )
xor	ax,ax
xor	bx,bx
mov	$14[bp],ax
mov	$16[bp],bx
!BCC_EOS
! 3219                         break;
jmp .410
!BCC_EOS
! 3220                     default:
! 3221                         goto int15_unimplemented;
.422:
add	sp,#..FFF4-..FFF5
br 	.FFF4
!BCC_EOS
! 3222                         break;
jmp .410
!BCC_EOS
! 3223                 }
! 3224                 regs.u.r32.eax = 0x534D4150;
jmp .410
.412:
sub	ax,*0
jl 	.422
cmp	ax,*7
ja  	.423
shl	ax,*1
mov	bx,ax
seg	cs
br	.424[bx]
.424:
.word	.413
.word	.414
.word	.415
.word	.419
.word	.41A
.word	.41B
.word	.41C
.word	.421
.423:
jmp	.422
.410:
! Debug: eq long = const $534D4150 to unsigned long regs = [S+$10+$1E] (used reg = )
mov	ax,#$4150
mov	bx,#$534D
mov	$20[bp],ax
mov	$22[bp],bx
!BCC_EOS
! 3225                 regs.u.r32.ecx = 0x14;
! Debug: eq int = const $14 to unsigned long regs = [S+$10+$1A] (used reg = )
mov	ax,*$14
xor	bx,bx
mov	$1C[bp],ax
mov	$1E[bp],bx
!BCC_EOS
! 3226                 FLAGS &= 0xfffe;
! Debug: andab unsigned int = const $FFFE to unsigned short FLAGS = [S+$10+$26] (used reg = )
mov	ax,$28[bp]
and	al,#$FE
mov	$28[bp],ax
!BCC_EOS
! 3227             } else {
jmp .425
.40A:
! 3228          
! 3228      goto int15_unimplemented;
add	sp,#..FFF4-..FFF5
jmp .FFF4
!BCC_EOS
! 3229             }
! 3230             break;
.425:
jmp .406
!BCC_EOS
! 3231         case 0x01:
! 3232           FLAGS &= 0xfffe;
.426:
! Debug: andab unsigned int = const $FFFE to unsigned short FLAGS = [S+$10+$26] (used reg = )
mov	ax,$28[bp]
and	al,#$FE
mov	$28[bp],ax
!BCC_EOS
! 3233           regs.u.r8.cl = inb_cmos(0x30);
! Debug: list int = const $30 (used reg = )
mov	ax,*$30
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char regs = [S+$10+$1A] (used reg = )
mov	$1C[bp],al
!BCC_EOS
! 3234           regs.u.r8.ch = inb_cmos(0x31);
! Debug: list int = const $31 (used reg = )
mov	ax,*$31
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char regs = [S+$10+$1B] (used reg = )
mov	$1D[bp],al
!BCC_EOS
! 3235           if(regs.u.r16.cx > 0x3c00)
! Debug: gt int = const $3C00 to unsigned short regs = [S+$10+$1A] (used reg = )
mov	ax,$1C[bp]
cmp	ax,#$3C00
jbe 	.427
.428:
! 3236           {
! 3237             regs.u.r16.cx = 0x3c00;
! Debug: eq int = const $3C00 to unsigned short regs = [S+$10+$1A] (used reg = )
mov	ax,#$3C00
mov	$1C[bp],ax
!BCC_EOS
! 3238           }
! 3239           regs.u.r8.dl = inb_cmos(0x34);
.427:
! Debug: list int = const $34 (used reg = )
mov	ax,*$34
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char regs = [S+$10+$16] (used reg = )
mov	$18[bp],al
!BCC_EOS
! 3240           regs.u.r8.dh = inb_cmos(0x35);
! Debug: list int = const $35 (used reg = )
mov	ax,*$35
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char regs = [S+$10+$17] (used reg = )
mov	$19[bp],al
!BCC_EOS
! 3241           regs.u.r16.ax = regs.u.r16.cx;
! Debug: eq unsigned short regs = [S+$10+$1A] to unsigned short regs = [S+$10+$1E] (used reg = )
mov	ax,$1C[bp]
mov	$20[bp],ax
!BCC_EOS
! 3242           regs.u.r16.bx = regs.u.r16.dx;
! Debug: eq unsigned short regs = [S+$10+$16] to unsigned short regs = [S+$10+$12] (used reg = )
mov	ax,$18[bp]
mov	$14[bp],ax
!BCC_EOS
! 3243           break;
jmp .406
!BCC_EOS
! 3244         default:
! 3245           goto int15_unimplemented;
.429:
add	sp,#..FFF4-..FFF5
jmp .FFF4
!BCC_EOS
! 3246        }
! 3247        break;
jmp .406
.408:
sub	al,*1
je 	.426
sub	al,*$1F
beq 	.409
jmp	.429
.406:
jmp .401
!BCC_EOS
! 3248     int15_unimplemented:
.FFF4:
! 3249     default:
! 3250       bios_printf(4, "*** int 15h function AX=%04x, BX=%04x not yet supported!\n", (unsigned) regs.u.r16.ax, (unsigned) regs.u.r16.bx);
.42A:
! Debug: list unsigned short regs = [S+$10+$12] (used reg = )
push	$14[bp]
! Debug: list unsigned short regs = [S+$12+$1E] (used reg = )
push	$20[bp]
! Debug: list * char = .42B+0 (used reg = )
mov	bx,#.42B
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*8
!BCC_EOS
! 3251       FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$10+$26] (used reg = )
mov	ax,$28[bp]
or	al,*1
mov	$28[bp],ax
!BCC_EOS
! 3252       regs.u.r8.ah = 0x86;
! Debug: eq int = const $86 to unsigned char regs = [S+$10+$1F] (used reg = )
mov	al,#$86
mov	$21[bp],al
!BCC_EOS
! 3253       break;
jmp .401
!BCC_EOS
! 3254     }
! 3255 }
jmp .401
.403:
sub	al,#$86
beq 	.404
sub	al,*$62
beq 	.405
jmp	.42A
.401:
..FFF5	=	-$10
..FFF4	=	-$10
mov	sp,bp
pop	bp
ret
! 3256   void
! Register BX used in function int15_function32
! 3257 int16_function(DI, SI, BP, SP, BX, DX, CX, AX, FLAGS)
! 3258   Bit16u DI, SI, BP, SP, BX, DX, CX, AX, FLAGS;
export	_int16_function
_int16_function:
!BCC_EOS
! 3259 {
! 3260   Bit8u scan_code, ascii_code, shift_flags, led_flags, count;
!BCC_EOS
! 3261   Bit16u kbd_code, max;
!BCC_EOS
! 3262   ;
push	bp
mov	bp,sp
add	sp,*-$A
!BCC_EOS
! 3263   shift_flags = *((Bit8u *)(0x17));
! Debug: eq unsigned char = [+$17] to unsigned char shift_flags = [S+$C-5] (used reg = )
mov	al,[$17]
mov	-3[bp],al
!BCC_EOS
! 3264   led_flags = *((Bit8u *)(0x97));
! Debug: eq unsigned char = [+$97] to unsigned char led_flags = [S+$C-6] (used reg = )
mov	al,[$97]
mov	-4[bp],al
!BCC_EOS
! 3265   if ((((shift_flags >> 4) & 0x07) ^ (led_flags & 0x07)) != 0) {
! Debug: and int = const 7 to unsigned char led_flags = [S+$C-6] (used reg = )
mov	al,-4[bp]
and	al,*7
push	ax
! Debug: sr int = const 4 to unsigned char shift_flags = [S+$E-5] (used reg = )
mov	al,-3[bp]
xor	ah,ah
mov	cl,*4
shr	ax,cl
! Debug: and int = const 7 to unsigned int = ax+0 (used reg = )
and	al,*7
! Debug: eor unsigned char (temp) = [S+$E-$E] to unsigned char = al+0 (used reg = )
xor	al,-$C[bp]
inc	sp
inc	sp
! Debug: ne int = const 0 to unsigned char = al+0 (used reg = )
test	al,al
beq 	.42C
.42D:
! 3266 #asm
!BCC_EOS
!BCC_ASM
_int16_function.BP	set	$12
.int16_function.BP	set	8
_int16_function.count	set	5
.int16_function.count	set	-5
_int16_function.CX	set	$1A
.int16_function.CX	set	$10
_int16_function.ascii_code	set	8
.int16_function.ascii_code	set	-2
_int16_function.DI	set	$E
.int16_function.DI	set	4
_int16_function.FLAGS	set	$1E
.int16_function.FLAGS	set	$14
_int16_function.kbd_code	set	2
.int16_function.kbd_code	set	-8
_int16_function.scan_code	set	9
.int16_function.scan_code	set	-1
_int16_function.DX	set	$18
.int16_function.DX	set	$E
_int16_function.led_flags	set	6
.int16_function.led_flags	set	-4
_int16_function.SI	set	$10
.int16_function.SI	set	6
_int16_function.AX	set	$1C
.int16_function.AX	set	$12
_int16_function.SP	set	$14
.int16_function.SP	set	$A
_int16_function.BX	set	$16
.int16_function.BX	set	$C
_int16_function.shift_flags	set	7
.int16_function.shift_flags	set	-3
_int16_function.max	set	0
.int16_function.max	set	-$A
    cli
! 3268 endasm
!BCC_ENDASM
!BCC_EOS
! 3269     outb(0x0060, 0xed);
! Debug: list int = const $ED (used reg = )
mov	ax,#$ED
push	ax
! Debug: list int = const $60 (used reg = )
mov	ax,*$60
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 3270     while ((inb(0x0064) & 0x01) == 0) outb(0x0080, 0x21);
jmp .42F
.430:
! Debug: list int = const $21 (used reg = )
mov	ax,*$21
push	ax
! Debug: list int = const $80 (used reg = )
mov	ax,#$80
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 3271     if ((inb(0x0060) == 0xfa)) {
.42F:
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: and int = const 1 to unsigned char = al+0 (used reg = )
and	al,*1
! Debug: logeq int = const 0 to unsigned char = al+0 (used reg = )
test	al,al
je 	.430
.431:
.42E:
! Debug: list int = const $60 (used reg = )
mov	ax,*$60
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: logeq int = const $FA to unsigned char = al+0 (used reg = )
cmp	al,#$FA
jne 	.432
.433:
! 3272       led_flags &= 0xf8;
! Debug: andab int = const $F8 to unsigned char led_flags = [S+$C-6] (used reg = )
mov	al,-4[bp]
and	al,#$F8
mov	-4[bp],al
!BCC_EOS
! 3273       led_flags |= ((shift_flags >> 4) & 0x07);
! Debug: sr int = const 4 to unsigned char shift_flags = [S+$C-5] (used reg = )
mov	al,-3[bp]
xor	ah,ah
mov	cl,*4
shr	ax,cl
! Debug: and int = const 7 to unsigned int = ax+0 (used reg = )
and	al,*7
! Debug: orab unsigned char = al+0 to unsigned char led_flags = [S+$C-6] (used reg = )
or	al,-4[bp]
mov	-4[bp],al
!BCC_EOS
! 3274       outb(0x0060, led_flags & 0x07);
! Debug: and int = const 7 to unsigned char led_flags = [S+$C-6] (used reg = )
mov	al,-4[bp]
and	al,*7
! Debug: list unsigned char = al+0 (used reg = )
xor	ah,ah
push	ax
! Debug: list int = const $60 (used reg = )
mov	ax,*$60
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 3275       while ((inb(0x0064) & 0x01) == 0) outb(0x0080, 0x21);
jmp .435
.436:
! Debug: list int = const $21 (used reg = )
mov	ax,*$21
push	ax
! Debug: list int = const $80 (used reg = )
mov	ax,#$80
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 3276       inb(0x0060);
.435:
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: and int = const 1 to unsigned char = al+0 (used reg = )
and	al,*1
! Debug: logeq int = const 0 to unsigned char = al+0 (used reg = )
test	al,al
je 	.436
.437:
.434:
! Debug: list int = const $60 (used reg = )
mov	ax,*$60
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
!BCC_EOS
! 3277       *((Bit8u *)(0x97)) = (led_flags);
! Debug: eq unsigned char led_flags = [S+$C-6] to unsigned char = [+$97] (used reg = )
mov	al,-4[bp]
mov	[$97],al
!BCC_EOS
! 3278     }
! 3279 #asm
.432:
!BCC_EOS
!BCC_ASM
_int16_function.BP	set	$12
.int16_function.BP	set	8
_int16_function.count	set	5
.int16_function.count	set	-5
_int16_function.CX	set	$1A
.int16_function.CX	set	$10
_int16_function.ascii_code	set	8
.int16_function.ascii_code	set	-2
_int16_function.DI	set	$E
.int16_function.DI	set	4
_int16_function.FLAGS	set	$1E
.int16_function.FLAGS	set	$14
_int16_function.kbd_code	set	2
.int16_function.kbd_code	set	-8
_int16_function.scan_code	set	9
.int16_function.scan_code	set	-1
_int16_function.DX	set	$18
.int16_function.DX	set	$E
_int16_function.led_flags	set	6
.int16_function.led_flags	set	-4
_int16_function.SI	set	$10
.int16_function.SI	set	6
_int16_function.AX	set	$1C
.int16_function.AX	set	$12
_int16_function.SP	set	$14
.int16_function.SP	set	$A
_int16_function.BX	set	$16
.int16_function.BX	set	$C
_int16_function.shift_flags	set	7
.int16_function.shift_flags	set	-3
_int16_function.max	set	0
.int16_function.max	set	-$A
    sti
! 3281 endasm
!BCC_ENDASM
!BCC_EOS
! 3282   }
! 3283   switch (*(((Bit8u *)&AX)+1)) {
.42C:
mov	al,$13[bp]
br 	.43A
! 3284     case 0x00:
! 3285       if ( !dequeue_key(&scan_code, &ascii_code, 1) ) {
.43B:
! Debug: list int = const 1 (used reg = )
mov	ax,*1
push	ax
! Debug: list * unsigned char ascii_code = S+$E-4 (used reg = )
lea	bx,-2[bp]
push	bx
! Debug: list * unsigned char scan_code = S+$10-3 (used reg = )
lea	bx,-1[bp]
push	bx
! Debug: func () unsigned int = dequeue_key+0 (used reg = )
call	_dequeue_key
add	sp,*6
test	ax,ax
jne 	.43C
.43D:
! 3286         bios_printf((2 | 4 | 1), "KBD: int16h: out of keyboard input\n");
! Debug: list * char = .43E+0 (used reg = )
mov	bx,#.43E
push	bx
! Debug: list int = const 7 (used reg = )
mov	ax,*7
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*4
!BCC_EOS
! 3287       }
! 3288       if (scan_code !=0 && ascii_code == 0xF0) ascii_code = 0;
.43C:
! Debug: ne int = const 0 to unsigned char scan_code = [S+$C-3] (used reg = )
mov	al,-1[bp]
test	al,al
je  	.43F
.441:
! Debug: logeq int = const $F0 to unsigned char ascii_code = [S+$C-4] (used reg = )
mov	al,-2[bp]
cmp	al,#$F0
jne 	.43F
.440:
! Debug: eq int = const 0 to unsigned char ascii_code = [S+$C-4] (used reg = )
xor	al,al
mov	-2[bp],al
!BCC_EOS
! 3289       else if (ascii_code == 0xE0) ascii_code = 0;
jmp .442
.43F:
! Debug: logeq int = const $E0 to unsigned char ascii_code = [S+$C-4] (used reg = )
mov	al,-2[bp]
cmp	al,#$E0
jne 	.443
.444:
! Debug: eq int = const 0 to unsigned char ascii_code = [S+$C-4] (used reg = )
xor	al,al
mov	-2[bp],al
!BCC_EOS
! 3290       AX = (scan_code << 8) | ascii_code;
.443:
.442:
! Debug: sl int = const 8 to unsigned char scan_code = [S+$C-3] (used reg = )
mov	al,-1[bp]
xor	ah,ah
mov	ah,al
xor	al,al
! Debug: or unsigned char ascii_code = [S+$C-4] to unsigned int = ax+0 (used reg = )
or	al,-2[bp]
! Debug: eq unsigned int = ax+0 to unsigned short AX = [S+$C+$10] (used reg = )
mov	$12[bp],ax
!BCC_EOS
! 3291       break;
br 	.438
!BCC_EOS
! 3292     case 0x01:
! 3293       if ( !dequeue_key(&scan_code, &ascii_code, 0) ) {
.445:
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list * unsigned char ascii_code = S+$E-4 (used reg = )
lea	bx,-2[bp]
push	bx
! Debug: list * unsigned char scan_code = S+$10-3 (used reg = )
lea	bx,-1[bp]
push	bx
! Debug: func () unsigned int = dequeue_key+0 (used reg = )
call	_dequeue_key
add	sp,*6
test	ax,ax
jne 	.446
.447:
! 3294         FLAGS |= 0x0040;
! Debug: orab int = const $40 to unsigned short FLAGS = [S+$C+$12] (used reg = )
mov	ax,$14[bp]
or	al,*$40
mov	$14[bp],ax
!BCC_EOS
! 3295         return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 3296       }
! 3297       if (scan_code !=0 && ascii_code == 0xF0) as
.446:
! Debug: ne int = const 0 to unsigned char scan_code = [S+$C-3] (used reg = )
mov	al,-1[bp]
test	al,al
je  	.448
.44A:
! Debug: logeq int = const $F0 to unsigned char ascii_code = [S+$C-4] (used reg = )
mov	al,-2[bp]
cmp	al,#$F0
jne 	.448
.449:
! 3297 cii_code = 0;
! Debug: eq int = const 0 to unsigned char ascii_code = [S+$C-4] (used reg = )
xor	al,al
mov	-2[bp],al
!BCC_EOS
! 3298       else if (ascii_code == 0xE0) ascii_code = 0;
jmp .44B
.448:
! Debug: logeq int = const $E0 to unsigned char ascii_code = [S+$C-4] (used reg = )
mov	al,-2[bp]
cmp	al,#$E0
jne 	.44C
.44D:
! Debug: eq int = const 0 to unsigned char ascii_code = [S+$C-4] (used reg = )
xor	al,al
mov	-2[bp],al
!BCC_EOS
! 3299       AX = (scan_code << 8) | ascii_code;
.44C:
.44B:
! Debug: sl int = const 8 to unsigned char scan_code = [S+$C-3] (used reg = )
mov	al,-1[bp]
xor	ah,ah
mov	ah,al
xor	al,al
! Debug: or unsigned char ascii_code = [S+$C-4] to unsigned int = ax+0 (used reg = )
or	al,-2[bp]
! Debug: eq unsigned int = ax+0 to unsigned short AX = [S+$C+$10] (used reg = )
mov	$12[bp],ax
!BCC_EOS
! 3300       FLAGS &= 0xffbf;
! Debug: andab unsigned int = const $FFBF to unsigned short FLAGS = [S+$C+$12] (used reg = )
mov	ax,$14[bp]
and	al,#$BF
mov	$14[bp],ax
!BCC_EOS
! 3301       break;
br 	.438
!BCC_EOS
! 3302     case 0x02:
! 3303       shift_flags = *((Bit8u *)(0x17));
.44E:
! Debug: eq unsigned char = [+$17] to unsigned char shift_flags = [S+$C-5] (used reg = )
mov	al,[$17]
mov	-3[bp],al
!BCC_EOS
! 3304       *((Bit8u *)&AX) = (shift_flags);
! Debug: eq unsigned char shift_flags = [S+$C-5] to unsigned char AX = [S+$C+$10] (used reg = )
mov	al,-3[bp]
mov	$12[bp],al
!BCC_EOS
! 3305       break;
br 	.438
!BCC_EOS
! 3306     case 0x05:
! 3307       if ( !enqueue_key(*(((Bit8u *)&CX)+1), ( CX & 0x00ff )) ) {
.44F:
! Debug: and int = const $FF to unsigned short CX = [S+$C+$E] (used reg = )
mov	al,$10[bp]
! Debug: list unsigned char = al+0 (used reg = )
xor	ah,ah
push	ax
! Debug: list unsigned char CX = [S+$E+$F] (used reg = )
mov	al,$11[bp]
xor	ah,ah
push	ax
! Debug: func () unsigned int = enqueue_key+0 (used reg = )
call	_enqueue_key
add	sp,*4
test	ax,ax
jne 	.450
.451:
! 3308         *((Bit8u *)&AX) = (1);
! Debug: eq int = const 1 to unsigned char AX = [S+$C+$10] (used reg = )
mov	al,*1
mov	$12[bp],al
!BCC_EOS
! 3309       }
! 3310       else {
jmp .452
.450:
! 3311         *((Bit8u *)&AX) = (0);
! Debug: eq int = const 0 to unsigned char AX = [S+$C+$10] (used reg = )
xor	al,al
mov	$12[bp],al
!BCC_EOS
! 3312       }
! 3313       break;
.452:
br 	.438
!BCC_EOS
! 3314     case 0x09:
! 3315       *((Bit8u *)&AX) = (0x30);
.453:
! Debug: eq int = const $30 to unsigned char AX = [S+$C+$10] (used reg = )
mov	al,*$30
mov	$12[bp],al
!BCC_EOS
! 3316       break;
br 	.438
!BCC_EOS
! 3317     case 0x0A:
! 3318       count = 2;
.454:
! Debug: eq int = const 2 to unsigned char count = [S+$C-7] (used reg = )
mov	al,*2
mov	-5[bp],al
!BCC_EOS
! 3319       kbd_code = 0x0;
! Debug: eq int = const 0 to unsigned short kbd_code = [S+$C-$A] (used reg = )
xor	ax,ax
mov	-8[bp],ax
!BCC_EOS
! 3320       outb(0x0060, 0xf2);
! Debug: list int = const $F2 (used reg = )
mov	ax,#$F2
push	ax
! Debug: list int = const $60 (used reg = )
mov	ax,*$60
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 3321       max=0xffff;
! Debug: eq unsigned int = const $FFFF to unsigned short max = [S+$C-$C] (used reg = )
mov	ax,#$FFFF
mov	-$A[bp],ax
!BCC_EOS
! 3322       while ( ((inb(0x0064) & 0x01) == 0) && (--max>0) ) outb(0x0080, 0x00);
jmp .456
.457:
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const $80 (used reg = )
mov	ax,#$80
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 3323       if (max>0x0) {
.456:
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: and int = const 1 to unsigned char = al+0 (used reg = )
and	al,*1
! Debug: logeq int = const 0 to unsigned char = al+0 (used reg = )
test	al,al
jne 	.458
.459:
! Debug: predec unsigned short max = [S+$C-$C] (used reg = )
mov	ax,-$A[bp]
dec	ax
mov	-$A[bp],ax
! Debug: gt int = const 0 to unsigned short = ax+0 (used reg = )
test	ax,ax
jne	.457
.458:
.455:
! Debug: gt int = const 0 to unsigned short max = [S+$C-$C] (used reg = )
mov	ax,-$A[bp]
test	ax,ax
beq 	.45A
.45B:
! 3324         if ((inb(0x0060) == 0xfa)) {
! Debug: list int = const $60 (used reg = )
mov	ax,*$60
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: logeq int = const $FA to unsigned char = al+0 (used reg = )
cmp	al,#$FA
jne 	.45C
.45D:
! 3325           do {
.460:
! 3326             max=0xffff;
! Debug: eq unsigned int = const $FFFF to unsigned short max = [S+$C-$C] (used reg = )
mov	ax,#$FFFF
mov	-$A[bp],ax
!BCC_EOS
! 3327             while ( ((inb(0x0064) & 0x01) == 0) && (--max>0) ) outb(0x0080, 0x00);
jmp .462
.463:
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const $80 (used reg = )
mov	ax,#$80
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 3328             if (max>0x0) {
.462:
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: and int = const 1 to unsigned char = al+0 (used reg = )
and	al,*1
! Debug: logeq int = const 0 to unsigned char = al+0 (used reg = )
test	al,al
jne 	.464
.465:
! Debug: predec unsigned short max = [S+$C-$C] (used reg = )
mov	ax,-$A[bp]
dec	ax
mov	-$A[bp],ax
! Debug: gt int = const 0 to unsigned short = ax+0 (used reg = )
test	ax,ax
jne	.463
.464:
.461:
! Debug: gt int = const 0 to unsigned short max = [S+$C-$C] (used reg = )
mov	ax,-$A[bp]
test	ax,ax
je  	.466
.467:
! 3329               kbd_code >>= 8;
! Debug: srab int = const 8 to unsigned short kbd_code = [S+$C-$A] (used reg = )
mov	ax,-8[bp]
mov	al,ah
xor	ah,ah
mov	-8[bp],ax
!BCC_EOS
! 3330               kbd_code |= (inb(0x0060) << 8);
! Debug: list int = const $60 (used reg = )
mov	ax,*$60
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: sl int = const 8 to unsigned char = al+0 (used reg = )
xor	ah,ah
mov	ah,al
xor	al,al
! Debug: orab unsigned int = ax+0 to unsigned short kbd_code = [S+$C-$A] (used reg = )
or	ax,-8[bp]
mov	-8[bp],ax
!BCC_EOS
! 3331             }
! 3332           } while (--count>0);
.466:
.45F:
! Debug: predec unsigned char count = [S+$C-7] (used reg = )
mov	al,-5[bp]
dec	ax
mov	-5[bp],al
! Debug: gt int = const 0 to unsigned char = al+0 (used reg = )
test	al,al
jne	.460
.468:
!BCC_EOS
! 3333         }
.45E:
! 3334       }
.45C:
! 3335       BX=kbd_code;
.45A:
! Debug: eq unsigned short kbd_code = [S+$C-$A] to unsigned short BX = [S+$C+$A] (used reg = )
mov	ax,-8[bp]
mov	$C[bp],ax
!BCC_EOS
! 3336       break;
br 	.438
!BCC_EOS
! 3337     case 0x10:
! 3338       if ( !dequeue_key(&scan_code, &ascii_code, 1) ) {
.469:
! Debug: list int = const 1 (used reg = )
mov	ax,*1
push	ax
! Debug: list * unsigned char ascii_code = S+$E-4 (used reg = )
lea	bx,-2[bp]
push	bx
! Debug: list * unsigned char scan_code = S+$10-3 (used reg = )
lea	bx,-1[bp]
push	bx
! Debug: func () unsigned int = dequeue_key+0 (used reg = )
call	_dequeue_key
add	sp,*6
test	ax,ax
jne 	.46A
.46B:
! 3339         bios_printf((2 | 4 | 1), "KBD: int16h: out of keyboard input\n");
! Debug: list * char = .46C+0 (used reg = )
mov	bx,#.46C
push	bx
! Debug: list int = const 7 (used reg = )
mov	ax,*7
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*4
!BCC_EOS
! 3340       }
! 3341       if (scan_code !=0 && ascii_code == 0xF0) ascii_code = 0;
.46A:
! Debug: ne int = const 0 to unsigned char scan_code = [S+$C-3] (used reg = )
mov	al,-1[bp]
test	al,al
je  	.46D
.46F:
! Debug: logeq int = const $F0 to unsigned char ascii_code = [S+$C-4] (used reg = )
mov	al,-2[bp]
cmp	al,#$F0
jne 	.46D
.46E:
! Debug: eq int = const 0 to unsigned char ascii_code = [S+$C-4] (used reg = )
xor	al,al
mov	-2[bp],al
!BCC_EOS
! 3342       AX = (scan_code << 8) | ascii_code;
.46D:
! Debug: sl int = const 8 to unsigned char scan_code = [S+$C-3] (used reg = )
mov	al,-1[bp]
xor	ah,ah
mov	ah,al
xor	al,al
! Debug: or unsigned char ascii_code = [S+$C-4] to unsigned int = ax+0 (used reg = )
or	al,-2[bp]
! Debug: eq unsigned int = ax+0 to unsigned short AX = [S+$C+$10] (used reg = )
mov	$12[bp],ax
!BCC_EOS
! 3343       break;
br 	.438
!BCC_EOS
! 3344     case 0x11:
! 3345       if ( !dequeue_key(&scan_code, &ascii_code, 0) ) {
.470:
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list * unsigned char ascii_code = S+$E-4 (used reg = )
lea	bx,-2[bp]
push	bx
! Debug: list * unsigned char scan_code = S+$10-3 (used reg = )
lea	bx,-1[bp]
push	bx
! Debug: func () unsigned int = dequeue_key+0 (used reg = )
call	_dequeue_key
add	sp,*6
test	ax,ax
jne 	.471
.472:
! 3346         FLAGS |= 0x0040;
! Debug: orab int = const $40 to unsigned short FLAGS = [S+$C+$12] (used reg = )
mov	ax,$14[bp]
or	al,*$40
mov	$14[bp],ax
!BCC_EOS
! 3347         return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 3348       }
! 3349       if (scan_code !=0 && ascii_code == 0xF0) ascii_code = 0;
.471:
! Debug: ne int = const 0 to unsigned char scan_code = [S+$C-3] (used reg = )
mov	al,-1[bp]
test	al,al
je  	.473
.475:
! Debug: logeq int = const $F0 to unsigned char ascii_code = [S+$C-4] (used reg = )
mov	al,-2[bp]
cmp	al,#$F0
jne 	.473
.474:
! Debug: eq int = const 0 to unsigned char ascii_code = [S+$C-4] (used reg = )
xor	al,al
mov	-2[bp],al
!BCC_EOS
! 3350       AX = (scan_code << 8) | ascii_code;
.473:
! Debug: sl int = const 8 to unsigned char scan_code = [S+$C-3] (used reg = )
mov	al,-1[bp]
xor	ah,ah
mov	ah,al
xor	al,al
! Debug: or unsigned char ascii_code = [S+$C-4] to unsigned int = ax+0 (used reg = )
or	al,-2[bp]
! Debug: eq unsigned int = ax+0 to unsigned short AX = [S+$C+$10] (used reg = )
mov	$12[bp],ax
!BCC_EOS
! 3351       FLAGS &= 0xffbf;
! Debug: andab unsigned int = const $FFBF to unsigned short FLAGS = [S+$C+$12] (used reg = )
mov	ax,$14[bp]
and	al,#$BF
mov	$14[bp],ax
!BCC_EOS
! 3352       break;
br 	.438
!BCC_EOS
! 3353     case 0x12:
! 3354       shift_flags = *((Bit8u *)(0x17));
.476:
! Debug: eq unsigned char = [+$17] to unsigned char shift_flags = [S+$C-5] (used reg = )
mov	al,[$17]
mov	-3[bp],al
!BCC_EOS
! 3355       *((Bit8u *)&AX) = (shift_flags);
! Debug: eq unsigned char shift_flags = [S+$C-5] to unsigned char AX = [S+$C+$10] (used reg = )
mov	al,-3[bp]
mov	$12[bp],al
!BCC_EOS
! 3356       shift_flags = *((Bit8u *)(0x18)) & 0x73;
! Debug: and int = const $73 to unsigned char = [+$18] (used reg = )
mov	al,[$18]
and	al,*$73
! Debug: eq unsigned char = al+0 to unsigned char shift_flags = [S+$C-5] (used reg = )
mov	-3[bp],al
!BCC_EOS
! 3357       shift_flags |= *((Bit8u *)(0x96)) & 0x0c;
! Debug: and int = const $C to unsigned char = [+$96] (used reg = )
mov	al,[$96]
and	al,*$C
! Debug: orab unsigned char = al+0 to unsigned char shift_flags = [S+$C-5] (used reg = )
or	al,-3[bp]
mov	-3[bp],al
!BCC_EOS
! 3358       *(((Bit8u *)&AX)+1) = (shift_flags);
! Debug: eq unsigned char shift_flags = [S+$C-5] to unsigned char AX = [S+$C+$11] (used reg = )
mov	al,-3[bp]
mov	$13[bp],al
!BCC_EOS
! 3359       ;
!BCC_EOS
! 3360       break;
jmp .438
!BCC_EOS
! 3361     case 0x92:
! 3362       *(((Bit8u *)&AX)+1) = (0x80);
.477:
! Debug: eq int = const $80 to unsigned char AX = [S+$C+$11] (used reg = )
mov	al,#$80
mov	$13[bp],al
!BCC_EOS
! 3363       break;
jmp .438
!BCC_EOS
! 3364     case 0xA2:
! 3365       break;
.478:
jmp .438
!BCC_EOS
! 3366     case 0x6F:
! 3367       if (( AX & 0x00ff ) == 0x08)
.479:
! Debug: and int = const $FF to unsigned short AX = [S+$C+$10] (used reg = )
mov	al,$12[bp]
! Debug: logeq int = const 8 to unsigned char = al+0 (used reg = )
cmp	al,*8
jne 	.47A
.47B:
! 3368         *(((Bit8u *)&AX)+1) = (0x02);
! Debug: eq int = const 2 to unsigned char AX = [S+$C+$11] (used reg = )
mov	al,*2
mov	$13[bp],al
!BCC_EOS
! 3369     default:
.47A:
! 3370       bios_printf(4, "
.47C:
! 3370 KBD: unsupported int 16h function %02x\n", *(((Bit8u *)&AX)+1));
! Debug: list unsigned char AX = [S+$C+$11] (used reg = )
mov	al,$13[bp]
xor	ah,ah
push	ax
! Debug: list * char = .47D+0 (used reg = )
mov	bx,#.47D
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*6
!BCC_EOS
! 3371   }
! 3372 }
jmp .438
.43A:
sub	al,*0
jb 	.47C
cmp	al,*$12
ja  	.47E
xor	ah,ah
shl	ax,*1
mov	bx,ax
seg	cs
br	.47F[bx]
.47F:
.word	.43B
.word	.445
.word	.44E
.word	.47C
.word	.47C
.word	.44F
.word	.47C
.word	.47C
.word	.47C
.word	.453
.word	.454
.word	.47C
.word	.47C
.word	.47C
.word	.47C
.word	.47C
.word	.469
.word	.470
.word	.476
.47E:
sub	al,*$6F
je 	.479
sub	al,*$23
je 	.477
sub	al,*$10
je 	.478
jmp	.47C
.438:
..FFF3	=	-$C
mov	sp,bp
pop	bp
ret
! 3373   unsigned int
! Register BX used in function int16_function
! 3374 dequeue_key(scan_code, ascii_code, incr)
! 3375   Bit8u *scan_code;
export	_dequeue_key
_dequeue_key:
!BCC_EOS
! 3376   Bit8u *ascii_code;
!BCC_EOS
! 3377   unsigned int incr;
!BCC_EOS
! 3378 {
! 3379   Bit16u buffer_start, buffer_end, buffer_head, buffer_tail;
!BCC_EOS
! 3380   Bit8u acode, scode;
!BCC_EOS
! 3381   buffer_start = *((Bit16u *)(0x0080));
push	bp
mov	bp,sp
add	sp,*-$A
! Debug: eq unsigned short = [+$80] to unsigned short buffer_start = [S+$C-4] (used reg = )
mov	ax,[$80]
mov	-2[bp],ax
!BCC_EOS
! 3382   buffer_end = *((Bit16u *)(0x0082));
! Debug: eq unsigned short = [+$82] to unsigned short buffer_end = [S+$C-6] (used reg = )
mov	ax,[$82]
mov	-4[bp],ax
!BCC_EOS
! 3383   buffer_head = *((Bit16u *)(0x001a));
! Debug: eq unsigned short = [+$1A] to unsigned short buffer_head = [S+$C-8] (used reg = )
mov	ax,[$1A]
mov	-6[bp],ax
!BCC_EOS
! 3384   buffer_tail = *((Bit16u *)(0x001c));
! Debug: eq unsigned short = [+$1C] to unsigned short buffer_tail = [S+$C-$A] (used reg = )
mov	ax,[$1C]
mov	-8[bp],ax
!BCC_EOS
! 3385   if (buffer_head != buffer_tail) {
! Debug: ne unsigned short buffer_tail = [S+$C-$A] to unsigned short buffer_head = [S+$C-8] (used reg = )
mov	ax,-6[bp]
cmp	ax,-8[bp]
je  	.480
.481:
! 3386     acode = *((Bit8u *)(buffer_head));
mov	bx,-6[bp]
! Debug: eq unsigned char = [bx+0] to unsigned char acode = [S+$C-$B] (used reg = )
mov	al,[bx]
mov	-9[bp],al
!BCC_EOS
! 3387     scode = *((Bit8u *)(buffer_head+1));
! Debug: add int = const 1 to unsigned short buffer_head = [S+$C-8] (used reg = )
mov	ax,-6[bp]
! Debug: cast * unsigned char = const 0 to unsigned int = ax+1 (used reg = )
mov	bx,ax
! Debug: eq unsigned char = [bx+1] to unsigned char scode = [S+$C-$C] (used reg = )
mov	al,1[bx]
mov	-$A[bp],al
!BCC_EOS
! 3388     _write_byte_SS(acode, ascii_code);
! Debug: list * unsigned char ascii_code = [S+$C+4] (used reg = )
push	6[bp]
! Debug: list unsigned char acode = [S+$E-$B] (used reg = )
mov	al,-9[bp]
xor	ah,ah
push	ax
! Debug: func () void = _write_byte_SS+0 (used reg = )
call	__write_byte_SS
add	sp,*4
!BCC_EOS
! 3389     _write_byte_SS(scode, scan_code);
! Debug: list * unsigned char scan_code = [S+$C+2] (used reg = )
push	4[bp]
! Debug: list unsigned char scode = [S+$E-$C] (used reg = )
mov	al,-$A[bp]
xor	ah,ah
push	ax
! Debug: func () void = _write_byte_SS+0 (used reg = )
call	__write_byte_SS
add	sp,*4
!BCC_EOS
! 3390     if (incr) {
mov	ax,8[bp]
test	ax,ax
je  	.482
.483:
! 3391       buffer_head += 2;
! Debug: addab int = const 2 to unsigned short buffer_head = [S+$C-8] (used reg = )
mov	ax,-6[bp]
inc	ax
inc	ax
mov	-6[bp],ax
!BCC_EOS
! 3392       if (buffer_head >= buffer_end)
! Debug: ge unsigned short buffer_end = [S+$C-6] to unsigned short buffer_head = [S+$C-8] (used reg = )
mov	ax,-6[bp]
cmp	ax,-4[bp]
jb  	.484
.485:
! 3393         buffer_head = buffer_start;
! Debug: eq unsigned short buffer_start = [S+$C-4] to unsigned short buffer_head = [S+$C-8] (used reg = )
mov	ax,-2[bp]
mov	-6[bp],ax
!BCC_EOS
! 3394       *((Bit16u *)(0x001a)) = (buffer_head);
.484:
! Debug: eq unsigned short buffer_head = [S+$C-8] to unsigned short = [+$1A] (used reg = )
mov	ax,-6[bp]
mov	[$1A],ax
!BCC_EOS
! 3395     }
! 3396     return(1);
.482:
mov	ax,*1
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 3397   }
! 3398   else {
jmp .486
.480:
! 3399     return(0);
xor	ax,ax
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 3400   }
! 3401 }
.486:
mov	sp,bp
pop	bp
ret
! 3402 static char panic_msg_keyb_buffer_full[] = "%s: keyboard input buffer full\n";
! Register BX used in function dequeue_key
.data
_panic_msg_keyb_buffer_full:
.487:
.ascii	"%s: keyboard input buffer full"
.byte	$A
.byte	0
!BCC_EOS
! 3403   Bit8u
! 3404 inhibit_mouse_int_and_events()
! 3405 {
.text
export	_inhibit_mouse_int_and_events
_inhibit_mouse_int_and_events:
! 3406   Bit8u command_byte, prev_command_byte;
!BCC_EOS
! 3407   if ( inb(0x0064) & 0x02 )
push	bp
mov	bp,sp
dec	sp
dec	sp
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: and int = const 2 to unsigned char = al+0 (used reg = )
and	al,*2
test	al,al
je  	.488
.489:
! 3408     bios_printf((2 | 4 | 1), panic_msg_keyb_buffer_full,"inhibmouse");
! Debug: list * char = .48A+0 (used reg = )
mov	bx,#.48A
push	bx
! Debug: list * char = panic_msg_keyb_buffer_full+0 (used reg = )
mov	bx,#_panic_msg_keyb_buffer_full
push	bx
! Debug: list int = const 7 (used reg = )
mov	ax,*7
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*6
!BCC_EOS
! 3409   outb(0x0064, 0x20);
.488:
! Debug: list int = const $20 (used reg = )
mov	ax,*$20
push	ax
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 3410   while ( (inb(0x0064) & 0x01) != 0x01 );
jmp .48C
.48D:
!BCC_EOS
! 3411   prev_command_byte = inb(0x0060);
.48C:
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: and int = const 1 to unsigned char = al+0 (used reg = )
and	al,*1
! Debug: ne int = const 1 to unsigned char = al+0 (used reg = )
cmp	al,*1
jne	.48D
.48E:
.48B:
! Debug: list int = const $60 (used reg = )
mov	ax,*$60
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char prev_command_byte = [S+4-4] (used reg = )
mov	-2[bp],al
!BCC_EOS
! 3412   command_byte = prev_command_byte;
! Debug: eq unsigned char prev_command_byte = [S+4-4] to unsigned char command_byte = [S+4-3] (used reg = )
mov	al,-2[bp]
mov	-1[bp],al
!BCC_EOS
! 3413   if ( inb(0x0064) & 0x02 )
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: and int = const 2 to unsigned char = al+0 (used reg = )
and	al,*2
test	al,al
je  	.48F
.490:
! 3414     bios_printf((2 | 4 | 1), panic_msg_keyb_buffer_full,"inhibmouse");
! Debug: list * char = .491+0 (used reg = )
mov	bx,#.491
push	bx
! Debug: list * char = panic_msg_keyb_buffer_full+0 (used reg = )
mov	bx,#_panic_msg_keyb_buffer_full
push	bx
! Debug: list int = const 7 (used reg = )
mov	ax,*7
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*6
!BCC_EOS
! 3415   command_byte &= 0xfd;
.48F:
! Debug: andab int = const $FD to unsigned char command_byte = [S+4-3] (used reg = )
mov	al,-1[bp]
and	al,#$FD
mov	-1[bp],al
!BCC_EOS
! 3416   command_byte |= 0x20;
! Debug: orab int = const $20 to unsigned char command_byte = [S+4-3] (used reg = )
mov	al,-1[bp]
or	al,*$20
mov	-1[bp],al
!BCC_EOS
! 3417   outb(0x0064, 0x60);
! Debug: list int = const $60 (used reg = )
mov	ax,*$60
push	ax
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 3418   outb(0x0060, command_byte);
! Debug: list unsigned char command_byte = [S+4-3] (used reg = )
mov	al,-1[bp]
xor	ah,ah
push	ax
! Debug: list int = const $60 (used reg = )
mov	ax,*$60
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 3419   return(prev_command_byte);
mov	al,-2[bp]
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 3420 }
! 3421   void
! Register BX used in function inhibit_mouse_int_and_events
! 3422 enable_mouse_int_and_events()
! 3423 {
export	_enable_mouse_int_and_events
_enable_mouse_int_and_events:
! 3424   Bit8u command_byte;
!BCC_EOS
! 3425   if ( inb(0x0064) & 0x02 )
push	bp
mov	bp,sp
dec	sp
dec	sp
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: and int = const 2 to unsigned char = al+0 (used reg = )
and	al,*2
test	al,al
je  	.492
.493:
! 3426     bios_printf((2 | 4 | 1), panic_msg_keyb_buffer_full,"enabmouse");
! Debug: list * char = .494+0 (used reg = )
mov	bx,#.494
push	bx
! Debug: list * char = panic_msg_keyb_buffer_full+0 (used reg = )
mov	bx,#_panic_msg_keyb_buffer_full
push	bx
! Debug: list int = const 7 (used reg = )
mov	ax,*7
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*6
!BCC_EOS
! 3427   outb(0x0064, 0x20);
.492:
! Debug: list int = const $20 (used reg = )
mov	ax,*$20
push	ax
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 3428   while ( (inb(0x0064) & 0x01) != 0x01 );
jmp .496
.497:
!BCC_EOS
! 3429   command_byte = inb(0x0060);
.496:
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: and int = const 1 to unsigned char = al+0 (used reg = )
and	al,*1
! Debug: ne int = const 1 to unsigned char = al+0 (used reg = )
cmp	al,*1
jne	.497
.498:
.495:
! Debug: list int = const $60 (used reg = )
mov	ax,*$60
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char command_byte = [S+4-3] (used reg = )
mov	-1[bp],al
!BCC_EOS
! 3430   if ( inb(0x0064) & 0x02 )
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: and int = const 2 to unsigned char = al+0 (used reg = )
and	al,*2
test	al,al
je  	.499
.49A:
! 3431     bios_printf((2 | 4 | 1), panic_msg_keyb_buffer_full,"enabmouse");
! Debug: list * char = .49B+0 (used reg = )
mov	bx,#.49B
push	bx
! Debug: list * char = panic_msg_keyb_buffer_full+0 (used reg = )
mov	bx,#_panic_msg_keyb_buffer_full
push	bx
! Debug: list int = const 7 (used reg = )
mov	ax,*7
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*6
!BCC_EOS
! 3432   command_byte |= 0x02;
.499:
! Debug: orab int = const 2 to unsigned char command_byte = [S+4-3] (used reg = )
mov	al,-1[bp]
or	al,*2
mov	-1[bp],al
!BCC_EOS
! 3433   command_byte &= 0xdf;
! Debug: andab int = const $DF to unsigned char command_byte = [S+4-3] (used reg = )
mov	al,-1[bp]
and	al,#$DF
mov	-1[bp],al
!BCC_EOS
! 3434   outb(0x0064, 0x60);
! Debug: list int = const $60 (used reg = )
mov	ax,*$60
push	ax
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 3435   outb(0x0060, command_byte);
! Debug: list unsigned char command_byte = [S+4-3] (used reg = )
mov	al,-1[bp]
xor	ah,ah
push	ax
! Debug: list int = const $60 (used reg = )
mov	ax,*$60
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 3436 }
mov	sp,bp
pop	bp
ret
! 3437   Bit8u
! Register BX used in function enable_mouse_int_and_events
! 3438 send_to_mouse_ctrl(sendbyte)
! 3439   Bit8u sendbyte;
export	_send_to_mouse_ctrl
_send_to_mouse_ctrl:
!BCC_EOS
! 3440 {
! 3441   Bit8u response;
!BCC_EOS
! 3442   if ( inb(0x0064) & 0x02 )
push	bp
mov	bp,sp
dec	sp
dec	sp
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: and int = const 2 to unsigned char = al+0 (used reg = )
and	al,*2
test	al,al
je  	.49C
.49D:
! 3443     bios_printf((2 | 4 | 1), pa
! 3443 nic_msg_keyb_buffer_full,"sendmouse");
! Debug: list * char = .49E+0 (used reg = )
mov	bx,#.49E
push	bx
! Debug: list * char = panic_msg_keyb_buffer_full+0 (used reg = )
mov	bx,#_panic_msg_keyb_buffer_full
push	bx
! Debug: list int = const 7 (used reg = )
mov	ax,*7
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*6
!BCC_EOS
! 3444   outb(0x0064, 0xD4);
.49C:
! Debug: list int = const $D4 (used reg = )
mov	ax,#$D4
push	ax
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 3445   outb(0x0060, sendbyte);
! Debug: list unsigned char sendbyte = [S+4+2] (used reg = )
mov	al,4[bp]
xor	ah,ah
push	ax
! Debug: list int = const $60 (used reg = )
mov	ax,*$60
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 3446   return(0);
xor	al,al
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 3447 }
! 3448   Bit8u
! Register BX used in function send_to_mouse_ctrl
! 3449 get_mouse_data(data)
! 3450   Bit8u *data;
export	_get_mouse_data
_get_mouse_data:
!BCC_EOS
! 3451 {
! 3452   Bit8u response;
!BCC_EOS
! 3453   while ((inb(0x0064) & 0x21) != 0x21) { }
push	bp
mov	bp,sp
dec	sp
dec	sp
jmp .4A0
.4A1:
! 3454   response = inb(0x0060);
.4A0:
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: and int = const $21 to unsigned char = al+0 (used reg = )
and	al,*$21
! Debug: ne int = const $21 to unsigned char = al+0 (used reg = )
cmp	al,*$21
jne	.4A1
.4A2:
.49F:
! Debug: list int = const $60 (used reg = )
mov	ax,*$60
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char response = [S+4-3] (used reg = )
mov	-1[bp],al
!BCC_EOS
! 3455   _write_byte_SS(response, data);
! Debug: list * unsigned char data = [S+4+2] (used reg = )
push	4[bp]
! Debug: list unsigned char response = [S+6-3] (used reg = )
mov	al,-1[bp]
xor	ah,ah
push	ax
! Debug: func () void = _write_byte_SS+0 (used reg = )
call	__write_byte_SS
add	sp,*4
!BCC_EOS
! 3456   return(0);
xor	al,al
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 3457 }
! 3458   void
! 3459 set_kbd_command_byte(command_byte)
! 3460   Bit8u command_byte;
export	_set_kbd_command_byte
_set_kbd_command_byte:
!BCC_EOS
! 3461 {
! 3462   if ( inb(0x0064) & 0x02 )
push	bp
mov	bp,sp
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
mov	sp,bp
! Debug: and int = const 2 to unsigned char = al+0 (used reg = )
and	al,*2
test	al,al
je  	.4A3
.4A4:
! 3463     bios_printf((2 | 4 | 1), panic_msg_keyb_buffer_full,"setkbdcomm");
! Debug: list * char = .4A5+0 (used reg = )
mov	bx,#.4A5
push	bx
! Debug: list * char = panic_msg_keyb_buffer_full+0 (used reg = )
mov	bx,#_panic_msg_keyb_buffer_full
push	bx
! Debug: list int = const 7 (used reg = )
mov	ax,*7
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
mov	sp,bp
!BCC_EOS
! 3464   outb(0x0064, 0xD4);
.4A3:
! Debug: list int = const $D4 (used reg = )
mov	ax,#$D4
push	ax
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
mov	sp,bp
!BCC_EOS
! 3465   outb(0x0064, 0x60);
! Debug: list int = const $60 (used reg = )
mov	ax,*$60
push	ax
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
mov	sp,bp
!BCC_EOS
! 3466   outb(0x0060, command_byte);
! Debug: list unsigned char command_byte = [S+2+2] (used reg = )
mov	al,4[bp]
xor	ah,ah
push	ax
! Debug: list int = const $60 (used reg = )
mov	ax,*$60
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
mov	sp,bp
!BCC_EOS
! 3467 }
pop	bp
ret
! 3468   void
! Register BX used in function set_kbd_command_byte
! 3469 int09_function(DI, SI, BP, SP, BX, DX, CX, AX)
! 3470   Bit16u DI, SI, BP, SP, BX, DX, CX, AX;
export	_int09_function
_int09_function:
!BCC_EOS
! 3471 {
! 3472   Bit8u scancode, asciicode, shift_flags;
!BCC_EOS
! 3473   Bit8u mf2_flags, mf2_state;
!BCC_EOS
! 3474   scancode = ( AX & 0x00ff );
push	bp
mov	bp,sp
add	sp,*-6
! Debug: and int = const $FF to unsigned short AX = [S+8+$10] (used reg = )
mov	al,$12[bp]
! Debug: eq unsigned char = al+0 to unsigned char scancode = [S+8-3] (used reg = )
mov	-1[bp],al
!BCC_EOS
! 3475   if (scancode == 0) {
! Debug: logeq int = const 0 to unsigned char scancode = [S+8-3] (used reg = )
mov	al,-1[bp]
test	al,al
jne 	.4A6
.4A7:
! 3476     bios_printf(4, "KBD: int09 handler: AL=0\n");
! Debug: list * char = .4A8+0 (used reg = )
mov	bx,#.4A8
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*4
!BCC_EOS
! 3477     return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 3478   }
! 3479   shift_flags = *((Bit8u *)(0x17));
.4A6:
! Debug: eq unsigned char = [+$17] to unsigned char shift_flags = [S+8-5] (used reg = )
mov	al,[$17]
mov	-3[bp],al
!BCC_EOS
! 3480   mf2_flags = *((Bit8u *)(0x18));
! Debug: eq unsigned char = [+$18] to unsigned char mf2_flags = [S+8-6] (used reg = )
mov	al,[$18]
mov	-4[bp],al
!BCC_EOS
! 3481   mf2_state = *((Bit8u *)(0x96));
! Debug: eq unsigned char = [+$96] to unsigned char mf2_state = [S+8-7] (used reg = )
mov	al,[$96]
mov	-5[bp],al
!BCC_EOS
! 3482   asciicode = 0;
! Debug: eq int = const 0 to unsigned char asciicode = [S+8-4] (used reg = )
xor	al,al
mov	-2[bp],al
!BCC_EOS
! 3483   switch (scancode) {
mov	al,-1[bp]
br 	.4AB
! 3484     case 0x3a:
! 3485       shift_flags ^= 0x40;
.4AC:
! Debug: eorab int = const $40 to unsigned char shift_flags = [S+8-5] (used reg = )
mov	al,-3[bp]
xor	al,*$40
mov	-3[bp],al
!BCC_EOS
! 3486       *((Bit8u *)(0x17)) = (shift_flags);
! Debug: eq unsigned char shift_flags = [S+8-5] to unsigned char = [+$17] (used reg = )
mov	al,-3[bp]
mov	[$17],al
!BCC_EOS
! 3487       mf2_flags |= 0x40;
! Debug: orab int = const $40 to unsigned char mf2_flags = [S+8-6] (used reg = )
mov	al,-4[bp]
or	al,*$40
mov	-4[bp],al
!BCC_EOS
! 3488       *((Bit8u *)(0x18)) = (mf2_flags);
! Debug: eq unsigned char mf2_flags = [S+8-6] to unsigned char = [+$18] (used reg = )
mov	al,-4[bp]
mov	[$18],al
!BCC_EOS
! 3489       break;
br 	.4A9
!BCC_EOS
! 3490     case 0xba:
! 3491       mf2_flags &= ~0x40;
.4AD:
! Debug: andab int = const -$41 to unsigned char mf2_flags = [S+8-6] (used reg = )
mov	al,-4[bp]
and	al,#$BF
mov	-4[bp],al
!BCC_EOS
! 3492       *((Bit8u *)(0x18)) = (mf2_flags);
! Debug: eq unsigned char mf2_flags = [S+8-6] to unsigned char = [+$18] (used reg = )
mov	al,-4[bp]
mov	[$18],al
!BCC_EOS
! 3493       break;
br 	.4A9
!BCC_EOS
! 3494     case 0x2a:
! 3495       shift_flags |= 0x02;
.4AE:
! Debug: orab int = const 2 to unsigned char shift_flags = [S+8-5] (used reg = )
mov	al,-3[bp]
or	al,*2
mov	-3[bp],al
!BCC_EOS
! 3496       *((Bit8u *)(0x17)) = (shift_flags);
! Debug: eq unsigned char shift_flags = [S+8-5] to unsigned char = [+$17] (used reg = )
mov	al,-3[bp]
mov	[$17],al
!BCC_EOS
! 3497       break;
br 	.4A9
!BCC_EOS
! 3498     case 0xaa:
! 3499       shift_flags &= ~0x02;
.4AF:
! Debug: andab int = const -3 to unsigned char shift_flags = [S+8-5] (used reg = )
mov	al,-3[bp]
and	al,#$FD
mov	-3[bp],al
!BCC_EOS
! 3500       *((Bit8u *)(0x17)) = (shift_flags);
! Debug: eq unsigned char shift_flags = [S+8-5] to unsigned char = [+$17] (used reg = )
mov	al,-3[bp]
mov	[$17],al
!BCC_EOS
! 3501       break;
br 	.4A9
!BCC_EOS
! 3502     case 0x36:
! 3503       shift_flags |= 0x01;
.4B0:
! Debug: orab int = const 1 to unsigned char shift_flags = [S+8-5] (used reg = )
mov	al,-3[bp]
or	al,*1
mov	-3[bp],al
!BCC_EOS
! 3504       *((Bit8u *)(0x17)) = (shift_flags);
! Debug: eq unsigned char shift_flags = [S+8-5] to unsigned char = [+$17] (used reg = )
mov	al,-3[bp]
mov	[$17],al
!BCC_EOS
! 3505       break;
br 	.4A9
!BCC_EOS
! 3506     case 0xb6:
! 3507       shift_flags &= ~0x01;
.4B1:
! Debug: andab int = const -2 to unsigned char shift_flags = [S+8-5] (used reg = )
mov	al,-3[bp]
and	al,#$FE
mov	-3[bp],al
!BCC_EOS
! 3508       *((Bit8u *)(0x17)) = (shift_flags);
! Debug: eq unsigned char shift_flags = [S+8-5] to unsigned char = [+$17] (used reg = )
mov	al,-3[bp]
mov	[$17],al
!BCC_EOS
! 3509       break;
br 	.4A9
!BCC_EOS
! 3510     case 0x1d:
! 3511       if ((mf2_state & 0x01) == 0) {
.4B2:
! Debug: and int = const 1 to unsigned char mf2_state = [S+8-7] (used reg = )
mov	al,-5[bp]
and	al,*1
! Debug: logeq int = const 0 to unsigned char = al+0 (used reg = )
test	al,al
jne 	.4B3
.4B4:
! 3512         shift_flags |= 0x04;
! Debug: orab int = const 4 to unsigned char shift_flags = [S+8-5] (used reg = )
mov	al,-3[bp]
or	al,*4
mov	-3[bp],al
!BCC_EOS
! 3513         *((Bit8u *)(0x17)) = (shift_flags);
! Debug: eq unsigned char shift_flags = [S+8-5] to unsigned char = [+$17] (used reg = )
mov	al,-3[bp]
mov	[$17],al
!BCC_EOS
! 3514         if (mf2_state & 0x02) {
! Debug: and int = const 2 to unsigned char mf2_state = [S+8-7] (used reg = )
mov	al,-5[bp]
and	al,*2
test	al,al
je  	.4B5
.4B6:
! 3515           mf2_state |= 0x04;
! Debug: orab int = const 4 to unsigned char mf2_state = [S+8-7] (used reg = )
mov	al,-5[bp]
or	al,*4
mov	-5[bp],al
!BCC_EOS
! 3516           *((Bit8u *)(0x96)) = (mf2_state);
! Debug: eq unsigned char mf2_state = [S+8-7] to unsigned char = [+$96] (used reg = )
mov	al,-5[bp]
mov	[$96],al
!BCC_EOS
! 3517         } else {
jmp .4B7
.4B5:
! 3518           mf2_flags |= 0x01;
! Debug: orab int = const 1 to unsigned char mf2_flags = [S+8-6] (used reg = )
mov	al,-4[bp]
or	al,*1
mov	-4[bp],al
!BCC_EOS
! 3519           *((Bit8u *)(0x18)) = (mf2_flags);
! Debug: eq unsigned char mf2_flags = [S+8-6] to unsigned char = [+$18] (used reg = )
mov	al,-4[bp]
mov	[$18],al
!BCC_EOS
! 3520         }
! 3521       }
.4B7:
! 3522       break;
.4B3:
br 	.4A9
!BCC_EOS
! 3523     case 0x9d:
! 3524       if ((mf2_state & 0x01) == 0) {
.4B8:
! Debug: and int = const 1 to unsigned char mf2_state = [S+8-7] (used reg = )
mov	al,-5[bp]
and	al,*1
! Debug: logeq int = const 0 to unsigned char = al+0 (used reg = )
test	al,al
jne 	.4B9
.4BA:
! 3525         shift_flags &= ~0x04;
! Debug: andab int = const -5 to unsigned char shift_flags = [S+8-5] (used reg = )
mov	al,-3[bp]
and	al,#$FB
mov	-3[bp],al
!BCC_EOS
! 3526         *((Bi
! 3526 t8u *)(0x17)) = (shift_flags);
! Debug: eq unsigned char shift_flags = [S+8-5] to unsigned char = [+$17] (used reg = )
mov	al,-3[bp]
mov	[$17],al
!BCC_EOS
! 3527         if (mf2_state & 0x02) {
! Debug: and int = const 2 to unsigned char mf2_state = [S+8-7] (used reg = )
mov	al,-5[bp]
and	al,*2
test	al,al
je  	.4BB
.4BC:
! 3528           mf2_state &= ~0x04;
! Debug: andab int = const -5 to unsigned char mf2_state = [S+8-7] (used reg = )
mov	al,-5[bp]
and	al,#$FB
mov	-5[bp],al
!BCC_EOS
! 3529           *((Bit8u *)(0x96)) = (mf2_state);
! Debug: eq unsigned char mf2_state = [S+8-7] to unsigned char = [+$96] (used reg = )
mov	al,-5[bp]
mov	[$96],al
!BCC_EOS
! 3530         } else {
jmp .4BD
.4BB:
! 3531           mf2_flags &= ~0x01;
! Debug: andab int = const -2 to unsigned char mf2_flags = [S+8-6] (used reg = )
mov	al,-4[bp]
and	al,#$FE
mov	-4[bp],al
!BCC_EOS
! 3532           *((Bit8u *)(0x18)) = (mf2_flags);
! Debug: eq unsigned char mf2_flags = [S+8-6] to unsigned char = [+$18] (used reg = )
mov	al,-4[bp]
mov	[$18],al
!BCC_EOS
! 3533         }
! 3534       }
.4BD:
! 3535       break;
.4B9:
br 	.4A9
!BCC_EOS
! 3536     case 0x38:
! 3537       shift_flags |= 0x08;
.4BE:
! Debug: orab int = const 8 to unsigned char shift_flags = [S+8-5] (used reg = )
mov	al,-3[bp]
or	al,*8
mov	-3[bp],al
!BCC_EOS
! 3538       *((Bit8u *)(0x17)) = (shift_flags);
! Debug: eq unsigned char shift_flags = [S+8-5] to unsigned char = [+$17] (used reg = )
mov	al,-3[bp]
mov	[$17],al
!BCC_EOS
! 3539       if (mf2_state & 0x02) {
! Debug: and int = const 2 to unsigned char mf2_state = [S+8-7] (used reg = )
mov	al,-5[bp]
and	al,*2
test	al,al
je  	.4BF
.4C0:
! 3540         mf2_state |= 0x08;
! Debug: orab int = const 8 to unsigned char mf2_state = [S+8-7] (used reg = )
mov	al,-5[bp]
or	al,*8
mov	-5[bp],al
!BCC_EOS
! 3541         *((Bit8u *)(0x96)) = (mf2_state);
! Debug: eq unsigned char mf2_state = [S+8-7] to unsigned char = [+$96] (used reg = )
mov	al,-5[bp]
mov	[$96],al
!BCC_EOS
! 3542       } else {
jmp .4C1
.4BF:
! 3543         mf2_flags |= 0x02;
! Debug: orab int = const 2 to unsigned char mf2_flags = [S+8-6] (used reg = )
mov	al,-4[bp]
or	al,*2
mov	-4[bp],al
!BCC_EOS
! 3544         *((Bit8u *)(0x18)) = (mf2_flags);
! Debug: eq unsigned char mf2_flags = [S+8-6] to unsigned char = [+$18] (used reg = )
mov	al,-4[bp]
mov	[$18],al
!BCC_EOS
! 3545       }
! 3546       break;
.4C1:
br 	.4A9
!BCC_EOS
! 3547     case 0xb8:
! 3548       shift_flags &= ~0x08;
.4C2:
! Debug: andab int = const -9 to unsigned char shift_flags = [S+8-5] (used reg = )
mov	al,-3[bp]
and	al,#$F7
mov	-3[bp],al
!BCC_EOS
! 3549       *((Bit8u *)(0x17)) = (shift_flags);
! Debug: eq unsigned char shift_flags = [S+8-5] to unsigned char = [+$17] (used reg = )
mov	al,-3[bp]
mov	[$17],al
!BCC_EOS
! 3550       if (mf2_state & 0x02) {
! Debug: and int = const 2 to unsigned char mf2_state = [S+8-7] (used reg = )
mov	al,-5[bp]
and	al,*2
test	al,al
je  	.4C3
.4C4:
! 3551         mf2_state &= ~0x08;
! Debug: andab int = const -9 to unsigned char mf2_state = [S+8-7] (used reg = )
mov	al,-5[bp]
and	al,#$F7
mov	-5[bp],al
!BCC_EOS
! 3552         *((Bit8u *)(0x96)) = (mf2_state);
! Debug: eq unsigned char mf2_state = [S+8-7] to unsigned char = [+$96] (used reg = )
mov	al,-5[bp]
mov	[$96],al
!BCC_EOS
! 3553       } else {
jmp .4C5
.4C3:
! 3554         mf2_flags &= ~0x02;
! Debug: andab int = const -3 to unsigned char mf2_flags = [S+8-6] (used reg = )
mov	al,-4[bp]
and	al,#$FD
mov	-4[bp],al
!BCC_EOS
! 3555         *((Bit8u *)(0x18)) = (mf2_flags);
! Debug: eq unsigned char mf2_flags = [S+8-6] to unsigned char = [+$18] (used reg = )
mov	al,-4[bp]
mov	[$18],al
!BCC_EOS
! 3556       }
! 3557       break;
.4C5:
br 	.4A9
!BCC_EOS
! 3558     case 0x45:
! 3559       if ((mf2_state & 0x03) == 0) {
.4C6:
! Debug: and int = const 3 to unsigned char mf2_state = [S+8-7] (used reg = )
mov	al,-5[bp]
and	al,*3
! Debug: logeq int = const 0 to unsigned char = al+0 (used reg = )
test	al,al
jne 	.4C7
.4C8:
! 3560         mf2_flags |= 0x20;
! Debug: orab int = const $20 to unsigned char mf2_flags = [S+8-6] (used reg = )
mov	al,-4[bp]
or	al,*$20
mov	-4[bp],al
!BCC_EOS
! 3561         *((Bit8u *)(0x18)) = (mf2_flags);
! Debug: eq unsigned char mf2_flags = [S+8-6] to unsigned char = [+$18] (used reg = )
mov	al,-4[bp]
mov	[$18],al
!BCC_EOS
! 3562         shift_flags ^= 0x20;
! Debug: eorab int = const $20 to unsigned char shift_flags = [S+8-5] (used reg = )
mov	al,-3[bp]
xor	al,*$20
mov	-3[bp],al
!BCC_EOS
! 3563         *((Bit8u *)(0x17)) = (shift_flags);
! Debug: eq unsigned char shift_flags = [S+8-5] to unsigned char = [+$17] (used reg = )
mov	al,-3[bp]
mov	[$17],al
!BCC_EOS
! 3564       }
! 3565       break;
.4C7:
br 	.4A9
!BCC_EOS
! 3566     case 0xc5:
! 3567       if ((mf2_state & 0x03) == 0) {
.4C9:
! Debug: and int = const 3 to unsigned char mf2_state = [S+8-7] (used reg = )
mov	al,-5[bp]
and	al,*3
! Debug: logeq int = const 0 to unsigned char = al+0 (used reg = )
test	al,al
jne 	.4CA
.4CB:
! 3568         mf2_flags &= ~0x20;
! Debug: andab int = const -$21 to unsigned char mf2_flags = [S+8-6] (used reg = )
mov	al,-4[bp]
and	al,#$DF
mov	-4[bp],al
!BCC_EOS
! 3569         *((Bit8u *)(0x18)) = (mf2_flags);
! Debug: eq unsigned char mf2_flags = [S+8-6] to unsigned char = [+$18] (used reg = )
mov	al,-4[bp]
mov	[$18],al
!BCC_EOS
! 3570       }
! 3571       break;
.4CA:
br 	.4A9
!BCC_EOS
! 3572     case 0x46:
! 3573       if ((mf2_state & 0x02) || (!(mf2_state & 0x10) && (shift_flags & 0x04))) {
.4CC:
! Debug: and int = const 2 to unsigned char mf2_state = [S+8-7] (used reg = )
mov	al,-5[bp]
and	al,*2
test	al,al
jne 	.4CE
.4CF:
! Debug: and int = const $10 to unsigned char mf2_state = [S+8-7] (used reg = )
mov	al,-5[bp]
and	al,*$10
test	al,al
jne 	.4CD
.4D0:
! Debug: and int = const 4 to unsigned char shift_flags = [S+8-5] (used reg = )
mov	al,-3[bp]
and	al,*4
test	al,al
je  	.4CD
.4CE:
! 3574         mf2_state &= ~0x02;
! Debug: andab int = const -3 to unsigned char mf2_state = [S+8-7] (used reg = )
mov	al,-5[bp]
and	al,#$FD
mov	-5[bp],al
!BCC_EOS
! 3575         *((Bit8u *)(0x96)) = (mf2_state);
! Debug: eq unsigned char mf2_state = [S+8-7] to unsigned char = [+$96] (used reg = )
mov	al,-5[bp]
mov	[$96],al
!BCC_EOS
! 3576         *((Bit8u *)(0x71)) = (0x80);
! Debug: eq int = const $80 to unsigned char = [+$71] (used reg = )
mov	al,#$80
mov	[$71],al
!BCC_EOS
! 3577         *((Bit16u *)(0x001C)) = (*((Bit16u *)(0x001A)));
! Debug: eq unsigned short = [+$1A] to unsigned short = [+$1C] (used reg = )
mov	ax,[$1A]
mov	[$1C],ax
!BCC_EOS
! 3578 #asm
!BCC_EOS
!BCC_ASM
_int09_function.BP	set	$E
.int09_function.BP	set	8
_int09_function.CX	set	$16
.int09_function.CX	set	$10
_int09_function.DI	set	$A
.int09_function.DI	set	4
_int09_function.DX	set	$14
.int09_function.DX	set	$E
_int09_function.mf2_flags	set	2
.int09_function.mf2_flags	set	-4
_int09_function.SI	set	$C
.int09_function.SI	set	6
_int09_function.mf2_state	set	1
.int09_function.mf2_state	set	-5
_int09_function.AX	set	$18
.int09_function.AX	set	$12
_int09_function.asciicode	set	4
.int09_function.asciicode	set	-2
_int09_function.scancode	set	5
.int09_function.scancode	set	-1
_int09_function.SP	set	$10
.int09_function.SP	set	$A
_int09_function.BX	set	$12
.int09_function.BX	set	$C
_int09_function.shift_flags	set	3
.int09_function.shift_flags	set	-3
        int #0x1B
! 3580 endasm
!BCC_ENDASM
!BCC_EOS
! 3581         enqueue_key(0, 0);
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: func () unsigned int = enqueue_key+0 (used reg = )
call	_enqueue_key
add	sp,*4
!BCC_EOS
! 3582       } else {
jmp .4D1
.4CD:
! 3583         mf2_flags |= 0x10;
! Debug: orab int = const $10 to unsigned char mf2_flags = [S+8-6] (used reg = )
mov	al,-4[bp]
or	al,*$10
mov	-4[bp],al
!BCC_EOS
! 3584         *((Bit8u *)(0x18)) = (mf2_flags);
! Debug: eq unsigned char mf2_flags = [S+8-6] to unsigned char = [+$18] (used reg = )
mov	al,-4[bp]
mov	[$18],al
!BCC_EOS
! 3585         shift_flags ^= 0x10;
! Debug: eorab int = const $10 to unsigned char shift_flags = [S+8-5] (used reg = )
mov	al,-3[bp]
xor	al,*$10
mov	-3[bp],al
!BCC_EOS
! 3586         *((Bit8u *)(0x17)) = (shift_flags);
! Debug: eq unsigned char shift_flags = [S+8-5] to unsigned char = [+$17] (used reg = )
mov	al,-3[bp]
mov	[$17],al
!BCC_EOS
! 3587       }
! 3588       break;
.4D1:
br 	.4A9
!BCC_EOS
! 3589     case 0xc6:
! 3590       if ((mf2_state & 0x02) || (!(mf2_state & 0x10) && (shift_flags & 0x04))) {
.4D2:
! Debug: and int = const 2 to unsigned char mf2_state = [S+8-7] (used reg = )
mov	al,-5[bp]
and	al,*2
test	al,al
jne 	.4D4
.4D5:
! Debug: and int = const $10 to unsigned char mf2_state = [S+8-7] (used reg = )
mov	al,-5[bp]
and	al,*$10
test	al,al
jne 	.4D3
.4D6:
! Debug: and int = const 4 to unsigned char shift_flags = [S+8-5] (used reg = )
mov	al,-3[bp]
and	al,*4
test	al,al
je  	.4D3
.4D4:
! 3591       } else {
jmp .4D7
.4D3:
! 3592         mf2_flags &= ~0x10;
! Debug: andab int = const -$11 to unsigned char mf2_flags = [S+8-6] (used reg = )
mov	al,-4[bp]
and	al,#$EF
mov	-4[bp],al
!BCC_EOS
! 3593         *((Bit8u *)(0x18)) = (mf2_flags);
! Debug: eq unsigned char mf2_flags = [S+8-6] to unsigned char = [+$18] (used reg = )
mov	al,-4[bp]
mov	[$18],al
!BCC_EOS
! 3594       }
! 3595       break;
.4D7:
br 	.4A9
!BCC_EOS
! 3596     default:
! 3597       if (scancode & 0x80) {
.4D8:
! Debug: and int = const $80 to unsigned char scancode = [S+8-3] (used reg = )
mov	al,-1[bp]
and	al,#$80
test	al,al
je  	.4D9
.4DA:
! 3598         break;
br 	.4A9
!BCC_EOS
! 3599       }
! 3600       if (scancode > 0x58) {
.4D9:
! Debug: gt int = const $58 to unsigned char scancode = [S+8-3] (used reg = )
mov	al,-1[bp]
cmp	al,*$58
jbe 	.4DB
.4DC:
! 3601         bios_printf(4, "KBD: int09h_handler(): unknown scanc
! 3601 ode read: 0x%02x!\n", scancode);
! Debug: list unsigned char scancode = [S+8-3] (used reg = )
mov	al,-1[bp]
xor	ah,ah
push	ax
! Debug: list * char = .4DD+0 (used reg = )
mov	bx,#.4DD
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*6
!BCC_EOS
! 3602         return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 3603       }
! 3604       if (scancode == 0x53) {
.4DB:
! Debug: logeq int = const $53 to unsigned char scancode = [S+8-3] (used reg = )
mov	al,-1[bp]
cmp	al,*$53
jne 	.4DE
.4DF:
! 3605         if ((shift_flags & 0x0f) == 0x0c) {
! Debug: and int = const $F to unsigned char shift_flags = [S+8-5] (used reg = )
mov	al,-3[bp]
and	al,*$F
! Debug: logeq int = const $C to unsigned char = al+0 (used reg = )
cmp	al,*$C
jne 	.4E0
.4E1:
! 3606           *((Bit16u *)(0x0072)) = (0x1234);
! Debug: eq int = const $1234 to unsigned short = [+$72] (used reg = )
mov	ax,#$1234
mov	[$72],ax
!BCC_EOS
! 3607 #asm
!BCC_EOS
!BCC_ASM
_int09_function.BP	set	$E
.int09_function.BP	set	8
_int09_function.CX	set	$16
.int09_function.CX	set	$10
_int09_function.DI	set	$A
.int09_function.DI	set	4
_int09_function.DX	set	$14
.int09_function.DX	set	$E
_int09_function.mf2_flags	set	2
.int09_function.mf2_flags	set	-4
_int09_function.SI	set	$C
.int09_function.SI	set	6
_int09_function.mf2_state	set	1
.int09_function.mf2_state	set	-5
_int09_function.AX	set	$18
.int09_function.AX	set	$12
_int09_function.asciicode	set	4
.int09_function.asciicode	set	-2
_int09_function.scancode	set	5
.int09_function.scancode	set	-1
_int09_function.SP	set	$10
.int09_function.SP	set	$A
_int09_function.BX	set	$12
.int09_function.BX	set	$C
_int09_function.shift_flags	set	3
.int09_function.shift_flags	set	-3
          jmp 0xf000:post;
! 3609 endasm
!BCC_ENDASM
!BCC_EOS
! 3610         }
! 3611       }
.4E0:
! 3612       set_DS(get_CS());
.4DE:
! Debug: func () unsigned short = get_CS+0 (used reg = )
call	_get_CS
! Debug: list unsigned short = ax+0 (used reg = )
push	ax
! Debug: func () unsigned short = set_DS+0 (used reg = )
call	_set_DS
inc	sp
inc	sp
!BCC_EOS
! 3613       if (shift_flags & 0x08) {
! Debug: and int = const 8 to unsigned char shift_flags = [S+8-5] (used reg = )
mov	al,-3[bp]
and	al,*8
test	al,al
je  	.4E2
.4E3:
! 3614         asciicode = scan_to_scanascii[scancode].alt;
! Debug: ptradd unsigned char scancode = [S+8-3] to [$59] struct  = scan_to_scanascii+0 (used reg = )
mov	al,-1[bp]
xor	ah,ah
mov	dx,ax
shl	ax,*1
shl	ax,*1
add	ax,dx
shl	ax,*1
mov	bx,ax
add	bx,#_scan_to_scanascii
! Debug: eq unsigned short = [bx+6] to unsigned char asciicode = [S+8-4] (used reg = )
mov	al,6[bx]
mov	-2[bp],al
!BCC_EOS
! 3615         scancode = scan_to_scanascii[scancode].alt >> 8;
! Debug: ptradd unsigned char scancode = [S+8-3] to [$59] struct  = scan_to_scanascii+0 (used reg = )
mov	al,-1[bp]
xor	ah,ah
mov	dx,ax
shl	ax,*1
shl	ax,*1
add	ax,dx
shl	ax,*1
mov	bx,ax
add	bx,#_scan_to_scanascii
! Debug: sr int = const 8 to unsigned short = [bx+6] (used reg = )
mov	ax,6[bx]
mov	al,ah
xor	ah,ah
! Debug: eq unsigned int = ax+0 to unsigned char scancode = [S+8-3] (used reg = )
mov	-1[bp],al
!BCC_EOS
! 3616       } else if (shift_flags & 0x04) {
br 	.4E4
.4E2:
! Debug: and int = const 4 to unsigned char shift_flags = [S+8-5] (used reg = )
mov	al,-3[bp]
and	al,*4
test	al,al
je  	.4E5
.4E6:
! 3617         asciicode = scan_to_scanascii[scancode].control;
! Debug: ptradd unsigned char scancode = [S+8-3] to [$59] struct  = scan_to_scanascii+0 (used reg = )
mov	al,-1[bp]
xor	ah,ah
mov	dx,ax
shl	ax,*1
shl	ax,*1
add	ax,dx
shl	ax,*1
mov	bx,ax
add	bx,#_scan_to_scanascii
! Debug: eq unsigned short = [bx+4] to unsigned char asciicode = [S+8-4] (used reg = )
mov	al,4[bx]
mov	-2[bp],al
!BCC_EOS
! 3618         scancode = scan_to_scanascii[scancode].control >> 8;
! Debug: ptradd unsigned char scancode = [S+8-3] to [$59] struct  = scan_to_scanascii+0 (used reg = )
mov	al,-1[bp]
xor	ah,ah
mov	dx,ax
shl	ax,*1
shl	ax,*1
add	ax,dx
shl	ax,*1
mov	bx,ax
add	bx,#_scan_to_scanascii
! Debug: sr int = const 8 to unsigned short = [bx+4] (used reg = )
mov	ax,4[bx]
mov	al,ah
xor	ah,ah
! Debug: eq unsigned int = ax+0 to unsigned char scancode = [S+8-3] (used reg = )
mov	-1[bp],al
!BCC_EOS
! 3619       } else if (((mf2_state & 0x02) > 0) && ((scancode >= 0x47) && (scancode <= 0x53))) {
br 	.4E7
.4E5:
! Debug: and int = const 2 to unsigned char mf2_state = [S+8-7] (used reg = )
mov	al,-5[bp]
and	al,*2
! Debug: gt int = const 0 to unsigned char = al+0 (used reg = )
test	al,al
je  	.4E8
.4EA:
! Debug: ge int = const $47 to unsigned char scancode = [S+8-3] (used reg = )
mov	al,-1[bp]
cmp	al,*$47
jb  	.4E8
.4EB:
! Debug: le int = const $53 to unsigned char scancode = [S+8-3] (used reg = )
mov	al,-1[bp]
cmp	al,*$53
ja  	.4E8
.4E9:
! 3620         asciicode = 0xe0;
! Debug: eq int = const $E0 to unsigned char asciicode = [S+8-4] (used reg = )
mov	al,#$E0
mov	-2[bp],al
!BCC_EOS
! 3621         scancode = scan_to_scanascii[scancode].normal >> 8;
! Debug: ptradd unsigned char scancode = [S+8-3] to [$59] struct  = scan_to_scanascii+0 (used reg = )
mov	al,-1[bp]
xor	ah,ah
mov	dx,ax
shl	ax,*1
shl	ax,*1
add	ax,dx
shl	ax,*1
mov	bx,ax
! Debug: sr int = const 8 to unsigned short = [bx+_scan_to_scanascii+0] (used reg = )
mov	ax,_scan_to_scanascii[bx]
mov	al,ah
xor	ah,ah
! Debug: eq unsigned int = ax+0 to unsigned char scancode = [S+8-3] (used reg = )
mov	-1[bp],al
!BCC_EOS
! 3622       } else if (shift_flags & 0x03) {
br 	.4EC
.4E8:
! Debug: and int = const 3 to unsigned char shift_flags = [S+8-5] (used reg = )
mov	al,-3[bp]
and	al,*3
test	al,al
beq 	.4ED
.4EE:
! 3623         if (shift_flags & scan_to_scanascii[scancode].lock_flags) {
! Debug: ptradd unsigned char scancode = [S+8-3] to [$59] struct  = scan_to_scanascii+0 (used reg = )
mov	al,-1[bp]
xor	ah,ah
mov	dx,ax
shl	ax,*1
shl	ax,*1
add	ax,dx
shl	ax,*1
mov	bx,ax
add	bx,#_scan_to_scanascii
! Debug: and unsigned char = [bx+8] to unsigned char shift_flags = [S+8-5] (used reg = )
mov	al,-3[bp]
and	al,8[bx]
test	al,al
je  	.4EF
.4F0:
! 3624           asciicode = scan_to_scanascii[scancode].normal;
! Debug: ptradd unsigned char scancode = [S+8-3] to [$59] struct  = scan_to_scanascii+0 (used reg = )
mov	al,-1[bp]
xor	ah,ah
mov	dx,ax
shl	ax,*1
shl	ax,*1
add	ax,dx
shl	ax,*1
mov	bx,ax
! Debug: eq unsigned short = [bx+_scan_to_scanascii+0] to unsigned char asciicode = [S+8-4] (used reg = )
mov	al,_scan_to_scanascii[bx]
mov	-2[bp],al
!BCC_EOS
! 3625           scancode = scan_to_scanascii[scancode].normal >> 8;
! Debug: ptradd unsigned char scancode = [S+8-3] to [$59] struct  = scan_to_scanascii+0 (used reg = )
mov	al,-1[bp]
xor	ah,ah
mov	dx,ax
shl	ax,*1
shl	ax,*1
add	ax,dx
shl	ax,*1
mov	bx,ax
! Debug: sr int = const 8 to unsigned short = [bx+_scan_to_scanascii+0] (used reg = )
mov	ax,_scan_to_scanascii[bx]
mov	al,ah
xor	ah,ah
! Debug: eq unsigned int = ax+0 to unsigned char scancode = [S+8-3] (used reg = )
mov	-1[bp],al
!BCC_EOS
! 3626         } else {
jmp .4F1
.4EF:
! 3627           asciicode = scan_to_scanascii[scancode].shift;
! Debug: ptradd unsigned char scancode = [S+8-3] to [$59] struct  = scan_to_scanascii+0 (used reg = )
mov	al,-1[bp]
xor	ah,ah
mov	dx,ax
shl	ax,*1
shl	ax,*1
add	ax,dx
shl	ax,*1
mov	bx,ax
add	bx,#_scan_to_scanascii
! Debug: eq unsigned short = [bx+2] to unsigned char asciicode = [S+8-4] (used reg = )
mov	al,2[bx]
mov	-2[bp],al
!BCC_EOS
! 3628           scancode = scan_to_scanascii[scancode].shift >> 8;
! Debug: ptradd unsigned char scancode = [S+8-3] to [$59] struct  = scan_to_scanascii+0 (used reg = )
mov	al,-1[bp]
xor	ah,ah
mov	dx,ax
shl	ax,*1
shl	ax,*1
add	ax,dx
shl	ax,*1
mov	bx,ax
add	bx,#_scan_to_scanascii
! Debug: sr int = const 8 to unsigned short = [bx+2] (used reg = )
mov	ax,2[bx]
mov	al,ah
xor	ah,ah
! Debug: eq unsigned int = ax+0 to unsigned char scancode = [S+8-3] (used reg = )
mov	-1[bp],al
!BCC_EOS
! 3629         }
! 3630       } else {
.4F1:
br 	.4F2
.4ED:
! 3631         if (shift_flags & scan_to_scanascii[scancode].lock_flags) {
! Debug: ptradd unsigned char scancode = [S+8-3] to [$59] struct  = scan_to_scanascii+0 (used reg = )
mov	al,-1[bp]
xor	ah,ah
mov	dx,ax
shl	ax,*1
shl	ax,*1
add	ax,dx
shl	ax,*1
mov	bx,ax
add	bx,#_scan_to_scanascii
! Debug: and unsigned char = [bx+8] to unsigned char shift_flags = [S+8-5] (used reg = )
mov	al,-3[bp]
and	al,8[bx]
test	al,al
je  	.4F3
.4F4:
! 3632           asciicode = scan_to_scanascii[scancode].shift;
! Debug: ptradd unsigned char scancode = [S+8-3] to [$59] struct  = scan_to_scanascii+0 (used reg = )
mov	al,-1[bp]
xor	ah,ah
mov	dx,ax
shl	ax,*1
shl	ax,*1
add	ax,dx
shl	ax,*1
mov	bx,ax
add	bx,#_scan_to_scanascii
! Debug: eq unsigned short = [bx+2] to unsigned char asciicode = [S+8-4] (used reg = )
mov	al,2[bx]
mov	-2[bp],al
!BCC_EOS
! 3633           scancode = scan_to_scanascii[scancode].shift >> 8;
! Debug: ptradd unsigned char scancode = [S+8-3] to [$59] struct  = scan_to_scanascii+0 (used reg = )
mov	al,-1[bp]
xor	ah,ah
mov	dx,ax
shl	ax,*1
shl	ax,*1
add	ax,dx
shl	ax,*1
mov	bx,ax
add	bx,#_scan_to_scanascii
! Debug: sr int = const 8 to unsigned short = [bx+2] (used reg = )
mov	ax,2[bx]
mov	al,ah
xor	ah,ah
! Debug: eq unsigned int = ax+0 to unsigned char scancode = [S+8-3] (used reg = )
mov	-1[bp],al
!BCC_EOS
! 3634         } else {
jmp .4F5
.4F3:
! 3635           asciicode = scan_to_scanascii[scancode].normal;
! Debug: ptradd unsigned char scancode = [S+8-3] to [$59] struct  = scan_to_scanascii+0 (used reg = )
mov	al,-1[bp]
xor	ah,ah
mov	dx,ax
shl	ax,*1
shl	ax,*1
add	ax,dx
shl	ax,*1
mov	bx,ax
! Debug: eq unsigned short = [bx+_scan_to_scanascii+0] to unsigned char asciicode = [S+8-4] (used reg = )
mov	al,_scan_to_scanascii[bx]
mov	-2[bp],al
!BCC_EOS
! 3636           scancode = scan_to_scanascii[scancode].normal >> 8;
! Debug: ptradd unsigned char scancode = [S+8-3] to [$59] struct  = scan_to_scanascii+0 (used reg = )
mov	al,-1[bp]
xor	ah,ah
mov	dx,ax
shl	ax,*1
shl	ax,*1
add	ax,dx
shl	ax,*1
mov	bx,ax
! Debug: sr int = const 8 to unsigned short = [bx+_scan_to_scanascii+0] (used reg = )
mov	ax,_scan_to_scanascii[bx]
mov	al,ah
xor	ah,ah
! Debug: eq unsigned int = ax+0 to unsigned char scancode = [S+8-3] (used reg = )
mov	-1[bp],al
!BCC_EOS
! 3637         }
! 3638       }
.4F5:
! 3639       set_DS(0x40);
.4F2:
.4EC:
.4E7:
.4E4:
! Debug: list int = const $40 (used reg = )
mov	ax,*$40
push	ax
! Debug: func () unsigned short = set_DS+0 (used reg = )
call	_set_DS
inc	sp
inc	sp
!BCC_EOS
! 3640       if (scancode==0 && asciicode==0) {
! Debug: logeq int = const 0 to unsigned char scancode = [S+8-3] (used reg = )
mov	al,-1[bp]
test	al,al
jne 	.4F6
.4F8:
! Debug: logeq int = const 0 to unsigned char asciicode = [S+8-4] (used reg = )
mov	al,-2[bp]
test	al,al
jne 	.4F6
.4F7:
! 3641         bios_printf(4, "KBD: int09h_handler(): scancode & asciicode are zero?\n");
! Debug: list * char = .4F9+0 (used reg = )
mov	bx,#.4F9
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*4
!BCC_EOS
! 3642       }
! 3643       enqueue_key(scancode, asciicode);
.4F6:
! Debug: list unsigned char asciicode = [S+8-4] (used reg = )
mov	al,-2[bp]
xor	ah,ah
push	ax
! Debug: list unsigned char scancode = [S+$A-3] (used reg = )
mov	al,-1[bp]
xor	ah,ah
push	ax
! Debug: func () unsigned int = enqueue_key+0 (used reg = )
call	_enqueue_key
add	sp,*4
!BCC_EOS
! 3644       break;
jmp .4A9
!BCC_EOS
! 3645   }
! 3646   if ((scancode & 0x7f) != 0x1d) {
jmp .4A9
.4AB:
sub	al,*$1D
beq 	.4B2
sub	al,*$D
beq 	.4AE
sub	al,*$C
beq 	.4B0
sub	al,*2
beq 	.4BE
sub	al,*2
beq 	.4AC
sub	al,*$B
beq 	.4C6
sub	al,*1
beq 	.4CC
sub	al,*$57
beq 	.4B8
sub	al,*$D
beq 	.4AF
sub	al,*$C
beq 	.4B1
sub	al,*2
beq 	.4C2
sub	al,*2
beq 	.4AD
sub	al,*$B
beq 	.4C9
sub	al,*1
beq 	.4D2
br 	.4D8
.4A9:
..FFF2	=	-8
! Debug: and int = const $7F to unsigned char scancode = [S+8-3] (used reg = )
mov	al,-1[bp]
and	al,*$7F
! Debug: ne int = const $1D to unsigned char = al+0 (used reg = )
cmp	al,*$1D
je  	.4FA
.4FB:
! 3647     mf2_state &= ~0x01;
! Debug: andab int = const -2 to unsigned char mf2_state = [S+8-7] (used reg = )
mov	al,-5[bp]
and	al,#$FE
mov	-5[bp],al
!BCC_EOS
! 3648   }
! 3649   mf2_state &= ~0x02;
.4FA:
! Debug: andab int = const -3 to unsigned char mf2_state = [S+8-7] (used reg = )
mov	al,-5[bp]
and	al,#$FD
mov	-5[bp],al
!BCC_EOS
! 3650   *((Bit8u *)(0x96)) = (mf2_state);
! Debug: eq unsigned char mf2_state = [S+8-7] to unsigned char = [+$96] (used reg = )
mov	al,-5[bp]
mov	[$96],al
!BCC_EOS
! 3651 }
mov	sp,bp
pop	bp
ret
! 3652   unsigned int
! Register BX used in function int09_function
! 3653 enqueue_key(scan_code, ascii_code)
! 3654   Bit8u scan_code, ascii_code;
export	_enqueue_key
_enqueue_key:
!BCC_EOS
! 3655 {
! 3656   Bit16u buffer_start, buffer_end, buffer_head, buffer_tail, temp_tail, old_ds;
!BCC_EOS
! 3657   old_ds = set_DS(0x40);
push	bp
mov	bp,sp
add	sp,*-$C
! Debug: list int = const $40 (used reg = )
mov	ax,*$40
push	ax
! Debug: func () unsigned short = set_DS+0 (used reg = )
call	_set_DS
inc	sp
inc	sp
! Debug: eq unsigned short = ax+0 to unsigned short old_ds = [S+$E-$E] (used reg = )
mov	-$C[bp],ax
!BCC_EOS
! 3658   buffer_start = *((Bit16u *)(0x0080));
! Debug: eq unsigned short = [+$80] to unsigned short buffer_start = [S+$E-4] (used reg = )
mov	ax,[$80]
mov	-2[bp],ax
!BCC_EOS
! 3659   buffer_end = *((Bit16u *)
! 3659 (0x0082));
! Debug: eq unsigned short = [+$82] to unsigned short buffer_end = [S+$E-6] (used reg = )
mov	ax,[$82]
mov	-4[bp],ax
!BCC_EOS
! 3660   buffer_head = *((Bit16u *)(0x001A));
! Debug: eq unsigned short = [+$1A] to unsigned short buffer_head = [S+$E-8] (used reg = )
mov	ax,[$1A]
mov	-6[bp],ax
!BCC_EOS
! 3661   buffer_tail = *((Bit16u *)(0x001C));
! Debug: eq unsigned short = [+$1C] to unsigned short buffer_tail = [S+$E-$A] (used reg = )
mov	ax,[$1C]
mov	-8[bp],ax
!BCC_EOS
! 3662   temp_tail = buffer_tail;
! Debug: eq unsigned short buffer_tail = [S+$E-$A] to unsigned short temp_tail = [S+$E-$C] (used reg = )
mov	ax,-8[bp]
mov	-$A[bp],ax
!BCC_EOS
! 3663   buffer_tail += 2;
! Debug: addab int = const 2 to unsigned short buffer_tail = [S+$E-$A] (used reg = )
mov	ax,-8[bp]
inc	ax
inc	ax
mov	-8[bp],ax
!BCC_EOS
! 3664   if (buffer_tail >= buffer_end)
! Debug: ge unsigned short buffer_end = [S+$E-6] to unsigned short buffer_tail = [S+$E-$A] (used reg = )
mov	ax,-8[bp]
cmp	ax,-4[bp]
jb  	.4FC
.4FD:
! 3665     buffer_tail = buffer_start;
! Debug: eq unsigned short buffer_start = [S+$E-4] to unsigned short buffer_tail = [S+$E-$A] (used reg = )
mov	ax,-2[bp]
mov	-8[bp],ax
!BCC_EOS
! 3666   if (buffer_tail == buffer_head) {
.4FC:
! Debug: logeq unsigned short buffer_head = [S+$E-8] to unsigned short buffer_tail = [S+$E-$A] (used reg = )
mov	ax,-8[bp]
cmp	ax,-6[bp]
jne 	.4FE
.4FF:
! 3667     set_DS(old_ds);
! Debug: list unsigned short old_ds = [S+$E-$E] (used reg = )
push	-$C[bp]
! Debug: func () unsigned short = set_DS+0 (used reg = )
call	_set_DS
inc	sp
inc	sp
!BCC_EOS
! 3668     return(0);
xor	ax,ax
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 3669   }
! 3670   *((Bit8u *)(temp_tail)) = (ascii_code);
.4FE:
mov	bx,-$A[bp]
! Debug: eq unsigned char ascii_code = [S+$E+4] to unsigned char = [bx+0] (used reg = )
mov	al,6[bp]
mov	[bx],al
!BCC_EOS
! 3671   *((Bit8u *)(temp_tail+1)) = (scan_code);
! Debug: add int = const 1 to unsigned short temp_tail = [S+$E-$C] (used reg = )
mov	ax,-$A[bp]
! Debug: cast * unsigned char = const 0 to unsigned int = ax+1 (used reg = )
mov	bx,ax
! Debug: eq unsigned char scan_code = [S+$E+2] to unsigned char = [bx+1] (used reg = )
mov	al,4[bp]
mov	1[bx],al
!BCC_EOS
! 3672   *((Bit16u *)(0x001C)) = (buffer_tail);
! Debug: eq unsigned short buffer_tail = [S+$E-$A] to unsigned short = [+$1C] (used reg = )
mov	ax,-8[bp]
mov	[$1C],ax
!BCC_EOS
! 3673   set_DS(old_ds);
! Debug: list unsigned short old_ds = [S+$E-$E] (used reg = )
push	-$C[bp]
! Debug: func () unsigned short = set_DS+0 (used reg = )
call	_set_DS
inc	sp
inc	sp
!BCC_EOS
! 3674   return(1);
mov	ax,*1
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 3675 }
! 3676   void
! Register BX used in function enqueue_key
! 3677 int74_function(make_farcall, Z, Y, X, status)
! 3678   Bit16u make_farcall, Z, Y, X, status;
export	_int74_function
_int74_function:
!BCC_EOS
! 3679 {
! 3680   Bit8u in_byte, index, package_count;
!BCC_EOS
! 3681   Bit8u mouse_flags_1, mouse_flags_2;
!BCC_EOS
! 3682 ;
push	bp
mov	bp,sp
add	sp,*-6
!BCC_EOS
! 3683   make_farcall = 0;
! Debug: eq int = const 0 to unsigned short make_farcall = [S+8+2] (used reg = )
xor	ax,ax
mov	4[bp],ax
!BCC_EOS
! 3684   in_byte = inb(0x0064);
! Debug: list int = const $64 (used reg = )
mov	ax,*$64
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char in_byte = [S+8-3] (used reg = )
mov	-1[bp],al
!BCC_EOS
! 3685   if ((in_byte & 0x21) != 0x21) {
! Debug: and int = const $21 to unsigned char in_byte = [S+8-3] (used reg = )
mov	al,-1[bp]
and	al,*$21
! Debug: ne int = const $21 to unsigned char = al+0 (used reg = )
cmp	al,*$21
je  	.500
.501:
! 3686     return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 3687   }
! 3688   in_byte = inb(0x0060);
.500:
! Debug: list int = const $60 (used reg = )
mov	ax,*$60
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char in_byte = [S+8-3] (used reg = )
mov	-1[bp],al
!BCC_EOS
! 3689 ;
!BCC_EOS
! 3690   mouse_flags_1 = *((Bit8u *)(&((ebda_data_t *) 0)->mouse_flag1));
! Debug: eq unsigned char = [+$26] to unsigned char mouse_flags_1 = [S+8-6] (used reg = )
mov	al,[$26]
mov	-4[bp],al
!BCC_EOS
! 3691   mouse_flags_2 = *((Bit8u *)(&((ebda_data_t *) 0)->mouse_flag2));
! Debug: eq unsigned char = [+$27] to unsigned char mouse_flags_2 = [S+8-7] (used reg = )
mov	al,[$27]
mov	-5[bp],al
!BCC_EOS
! 3692   if ((mouse_flags_2 & 0x80) != 0x80) {
! Debug: and int = const $80 to unsigned char mouse_flags_2 = [S+8-7] (used reg = )
mov	al,-5[bp]
and	al,#$80
! Debug: ne int = const $80 to unsigned char = al+0 (used reg = )
cmp	al,#$80
je  	.502
.503:
! 3693       return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 3694   }
! 3695   package_count = mouse_flags_2 & 0x07;
.502:
! Debug: and int = const 7 to unsigned char mouse_flags_2 = [S+8-7] (used reg = )
mov	al,-5[bp]
and	al,*7
! Debug: eq unsigned char = al+0 to unsigned char package_count = [S+8-5] (used reg = )
mov	-3[bp],al
!BCC_EOS
! 3696   index = mouse_flags_1 & 0x07;
! Debug: and int = const 7 to unsigned char mouse_flags_1 = [S+8-6] (used reg = )
mov	al,-4[bp]
and	al,*7
! Debug: eq unsigned char = al+0 to unsigned char index = [S+8-4] (used reg = )
mov	-2[bp],al
!BCC_EOS
! 3697   *((Bit8u *)(&((ebda_data_t *) 0)->mouse_data[index])) = (in_byte);
! Debug: ptradd unsigned char index = [S+8-4] to [8] unsigned char = const $28 (used reg = )
mov	al,-2[bp]
xor	ah,ah
mov	bx,ax
! Debug: address unsigned char = [bx+$28] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$28 (used reg = )
! Debug: eq unsigned char in_byte = [S+8-3] to unsigned char = [bx+$28] (used reg = )
mov	al,-1[bp]
mov	$28[bx],al
!BCC_EOS
! 3698   if (index >= package_count) {
! Debug: ge unsigned char package_count = [S+8-5] to unsigned char index = [S+8-4] (used reg = )
mov	al,-2[bp]
cmp	al,-3[bp]
jb  	.504
.505:
! 3699 ;
!BCC_EOS
! 3700     if (package_count == 3) {
! Debug: logeq int = const 3 to unsigned char package_count = [S+8-5] (used reg = )
mov	al,-3[bp]
cmp	al,*3
jne 	.506
.507:
! 3701       status = *((Bit8u *)(&((ebda_data_t *) 0)->mouse_data[0]));
! Debug: eq unsigned char = [+$28] to unsigned short status = [S+8+$A] (used reg = )
mov	al,[$28]
xor	ah,ah
mov	$C[bp],ax
!BCC_EOS
! 3702       *(((Bit8u *)&status)+1) = *((Bit8u *)(&((ebda_data_t *) 0)->mouse_data[1]));
! Debug: eq unsigned char = [+$29] to unsigned char status = [S+8+$B] (used reg = )
mov	al,[$29]
mov	$D[bp],al
!BCC_EOS
! 3703       X = *((Bit8u *)(&((ebda_data_t *) 0)->mouse_data[2]));
! Debug: eq unsigned char = [+$2A] to unsigned short X = [S+8+8] (used reg = )
mov	al,[$2A]
xor	ah,ah
mov	$A[bp],ax
!BCC_EOS
! 3704       Y = *((Bit8u *)(&((ebda_data_t *) 0)->mouse_data[3]));
! Debug: eq unsigned char = [+$2B] to unsigned short Y = [S+8+6] (used reg = )
mov	al,[$2B]
xor	ah,ah
mov	8[bp],ax
!BCC_EOS
! 3705     } else {
jmp .508
.506:
! 3706       status = *((Bit8u *)(&((ebda_data_t *) 0)->mouse_data[0]));
! Debug: eq unsigned char = [+$28] to unsigned short status = [S+8+$A] (used reg = )
mov	al,[$28]
xor	ah,ah
mov	$C[bp],ax
!BCC_EOS
! 3707       X = *((Bit8u *)(&((ebda_data_t *) 0)->mouse_data[1]));
! Debug: eq unsigned char = [+$29] to unsigned short X = [S+8+8] (used reg = )
mov	al,[$29]
xor	ah,ah
mov	$A[bp],ax
!BCC_EOS
! 3708       Y = *((Bit8u *)(&((ebda_data_t *) 0)->mouse_data[2]));
! Debug: eq unsigned char = [+$2A] to unsigned short Y = [S+8+6] (used reg = )
mov	al,[$2A]
xor	ah,ah
mov	8[bp],ax
!BCC_EOS
! 3709     }
! 3710     Z = 0;
.508:
! Debug: eq int = const 0 to unsigned short Z = [S+8+4] (used reg = )
xor	ax,ax
mov	6[bp],ax
!BCC_EOS
! 3711     mouse_flags_1 = 0;
! Debug: eq int = const 0 to unsigned char mouse_flags_1 = [S+8-6] (used reg = )
xor	al,al
mov	-4[bp],al
!BCC_EOS
! 3712     if (mouse_flags_2 & 0x80)
! Debug: and int = const $80 to unsigned char mouse_flags_2 = [S+8-7] (used reg = )
mov	al,-5[bp]
and	al,#$80
test	al,al
je  	.509
.50A:
! 3713       make_farcall = 1;
! Debug: eq int = const 1 to unsigned short make_farcall = [S+8+2] (used reg = )
mov	ax,*1
mov	4[bp],ax
!BCC_EOS
! 3714   } else {
.509:
jmp .50B
.504:
! 3715     mouse_flags_1++;
! Debug: postinc unsigned char mouse_flags_1 = [S+8-6] (used reg = )
mov	al,-4[bp]
inc	ax
mov	-4[bp],al
!BCC_EOS
! 3716   }
! 3717   *((Bit8u *)(&((ebda_data_t *) 0)->mouse_flag1)) = (mouse_flags_1);
.50B:
! Debug: eq unsigned char mouse_flags_1 = [S+8-6] to unsigned char = [+$26] (used reg = )
mov	al,-4[bp]
mov	[$26],al
!BCC_EOS
! 3718 }
mov	sp,bp
pop	bp
ret
! 3719   int
! Register BX used in function int74_function
! 3720 int13_edd(DS, SI, device)
! 3721   Bit16u DS, SI;
export	_int13_edd
_int13_edd:
!BCC_EOS
! 3722   Bit8u device;
!BCC_EOS
! 3723 {
! 3724   Bit32u lba_low, lba_high;
!BCC_EOS
! 3725   Bit16u npc, nph, npspt, size, t13;
!BCC_EOS
! 3726   Bit16u ebda_seg=get_ebda_seg();
push	bp
mov	bp,sp
add	sp,*-$14
! Debug: func () unsigned short = get_ebda_seg+0 (used reg = )
call	_get_ebda_seg
! Debug: eq unsigned short = ax+0 to unsigned short ebda_seg = [S+$16-$16] (used reg = )
mov	-$14[bp],ax
!BCC_EOS
! 3727   Bit8u type=*((Bit8u *)(&((ebda_data_t *) 0)->ata.devices[device].type));
dec	sp
! Debug: ptradd unsigned char device = [S+$17+6] to [8] struct  = const $142 (used reg = )
mov	al,8[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned char = [bx+$142] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$142 (used reg = )
! Debug: eq unsigned char = [bx+$142] to unsigned char type = [S+$17-$17] (used reg = )
mov	al,$142[bx]
mov	-$15[bp],al
!BCC_EOS
! 3728   size
! 3728 =_read_word(SI+(Bit16u)&((dpt_t *) 0)->size, DS);
dec	sp
! Debug: list unsigned short DS = [S+$18+2] (used reg = )
push	4[bp]
! Debug: add unsigned short = const 0 to unsigned short SI = [S+$1A+4] (used reg = )
mov	ax,6[bp]
! Debug: list unsigned int = ax+0 (used reg = )
push	ax
! Debug: func () unsigned short = _read_word+0 (used reg = )
call	__read_word
add	sp,*4
! Debug: eq unsigned short = ax+0 to unsigned short size = [S+$18-$12] (used reg = )
mov	-$10[bp],ax
!BCC_EOS
! 3729   t13 = size == 74;
! Debug: logeq int = const $4A to unsigned short size = [S+$18-$12] (used reg = )
mov	ax,-$10[bp]
cmp	ax,*$4A
jne	.50C
mov	al,*1
jmp	.50D
.50C:
xor	al,al
.50D:
! Debug: eq char = al+0 to unsigned short t13 = [S+$18-$14] (used reg = )
xor	ah,ah
mov	-$12[bp],ax
!BCC_EOS
! 3730   if(size < 26)
! Debug: lt int = const $1A to unsigned short size = [S+$18-$12] (used reg = )
mov	ax,-$10[bp]
cmp	ax,*$1A
jae 	.50E
.50F:
! 3731     return 1;
mov	ax,*1
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 3732   if(size >= 26) {
.50E:
! Debug: ge int = const $1A to unsigned short size = [S+$18-$12] (used reg = )
mov	ax,-$10[bp]
cmp	ax,*$1A
blo 	.510
.511:
! 3733     Bit16u blksize, infos;
!BCC_EOS
! 3734     _write_word(26, SI+(Bit16u)&((dpt_t *) 0)->size, DS);
add	sp,*-4
! Debug: list unsigned short DS = [S+$1C+2] (used reg = )
push	4[bp]
! Debug: add unsigned short = const 0 to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: list unsigned int = ax+0 (used reg = )
push	ax
! Debug: list int = const $1A (used reg = )
mov	ax,*$1A
push	ax
! Debug: func () void = _write_word+0 (used reg = )
call	__write_word
add	sp,*6
!BCC_EOS
! 3735     blksize = *((Bit16u *)(&((ebda_data_t *) 0)->ata.devices[device].blksize));
! Debug: ptradd unsigned char device = [S+$1C+6] to [8] struct  = const $142 (used reg = )
mov	al,8[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned short = [bx+$148] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$148 (used reg = )
! Debug: eq unsigned short = [bx+$148] to unsigned short blksize = [S+$1C-$1A] (used reg = )
mov	bx,$148[bx]
mov	-$18[bp],bx
!BCC_EOS
! 3736     if (type == 0x02)
! Debug: logeq int = const 2 to unsigned char type = [S+$1C-$17] (used reg = )
mov	al,-$15[bp]
cmp	al,*2
bne 	.512
.513:
! 3737     {
! 3738       npc = *((Bit16u *)(&((ebda_data_t *) 0)->ata.devices[device].pchs.cylinders));
! Debug: ptradd unsigned char device = [S+$1C+6] to [8] struct  = const $142 (used reg = )
mov	al,8[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned short = [bx+$154] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$154 (used reg = )
! Debug: eq unsigned short = [bx+$154] to unsigned short npc = [S+$1C-$C] (used reg = )
mov	bx,$154[bx]
mov	-$A[bp],bx
!BCC_EOS
! 3739       nph = *((Bit16u *)(&((ebda_data_t *) 0)->ata.devices[device].pchs.heads));
! Debug: ptradd unsigned char device = [S+$1C+6] to [8] struct  = const $142 (used reg = )
mov	al,8[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned short = [bx+$152] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$152 (used reg = )
! Debug: eq unsigned short = [bx+$152] to unsigned short nph = [S+$1C-$E] (used reg = )
mov	bx,$152[bx]
mov	-$C[bp],bx
!BCC_EOS
! 3740       npspt = *((Bit16u *)(&((ebda_data_t *) 0)->ata.devices[device].pchs.spt));
! Debug: ptradd unsigned char device = [S+$1C+6] to [8] struct  = const $142 (used reg = )
mov	al,8[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned short = [bx+$156] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$156 (used reg = )
! Debug: eq unsigned short = [bx+$156] to unsigned short npspt = [S+$1C-$10] (used reg = )
mov	bx,$156[bx]
mov	-$E[bp],bx
!BCC_EOS
! 3741       lba_low = *((Bit32u *)(&((ebda_data_t *) 0)->ata.devices[device].sectors_low));
! Debug: ptradd unsigned char device = [S+$1C+6] to [8] struct  = const $142 (used reg = )
mov	al,8[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned long = [bx+$158] (used reg = )
! Debug: cast * unsigned long = const 0 to * unsigned long = bx+$158 (used reg = )
! Debug: eq unsigned long = [bx+$158] to unsigned long lba_low = [S+$1C-6] (used reg = )
mov	ax,$158[bx]
mov	bx,$15A[bx]
mov	-4[bp],ax
mov	-2[bp],bx
!BCC_EOS
! 3742       lba_high = *((Bit32u *)(&((ebda_data_t *) 0)->ata.devices[device].sectors_high));
! Debug: ptradd unsigned char device = [S+$1C+6] to [8] struct  = const $142 (used reg = )
mov	al,8[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned long = [bx+$15C] (used reg = )
! Debug: cast * unsigned long = const 0 to * unsigned long = bx+$15C (used reg = )
! Debug: eq unsigned long = [bx+$15C] to unsigned long lba_high = [S+$1C-$A] (used reg = )
mov	ax,$15C[bx]
mov	bx,$15E[bx]
mov	-8[bp],ax
mov	-6[bp],bx
!BCC_EOS
! 3743       if (lba_high || (lba_low/npspt)/nph > 0x3fff)
mov	ax,-8[bp]
mov	bx,-6[bp]
call	ltstl
jne 	.515
.516:
! Debug: cast unsigned long = const 0 to unsigned short nph = [S+$1C-$E] (used reg = )
mov	ax,-$C[bp]
xor	bx,bx
push	bx
push	ax
! Debug: cast unsigned long = const 0 to unsigned short npspt = [S+$20-$10] (used reg = )
mov	ax,-$E[bp]
xor	bx,bx
! Debug: div unsigned long = bx+0 to unsigned long lba_low = [S+$20-6] (used reg = )
push	bx
push	ax
mov	ax,-4[bp]
mov	bx,-2[bp]
lea	di,-$22[bp]
call	ldivul
add	sp,*4
! Debug: div unsigned long (temp) = [S+$20-$20] to unsigned long = bx+0 (used reg = )
lea	di,-$1E[bp]
call	ldivul
add	sp,*4
! Debug: gt unsigned long = const $3FFF to unsigned long = bx+0 (used reg = )
push	bx
push	ax
mov	ax,#$3FFF
xor	bx,bx
push	bx
push	ax
mov	ax,-$1E[bp]
mov	bx,-$1C[bp]
lea	di,-$22[bp]
call	lcmpul
jbe	.517
mov	al,*1
jmp	.518
.517:
xor	al,al
.518:
add	sp,*8
! Debug: cast unsigned long = const 0 to char = al+0 (used reg = )
xor	ah,ah
cwd
mov	bx,dx
call	ltstl
je  	.514
.515:
! 3744       {
! 3745         infos = 0 << 1;
! Debug: eq int = const 0 to unsigned short infos = [S+$1C-$1C] (used reg = )
xor	ax,ax
mov	-$1A[bp],ax
!BCC_EOS
! 3746         npc = 0x3fff;
! Debug: eq int = const $3FFF to unsigned short npc = [S+$1C-$C] (used reg = )
mov	ax,#$3FFF
mov	-$A[bp],ax
!BCC_EOS
! 3747       }
! 3748       else
! 3749       {
jmp .51A
.514:
! 3750         infos = 1 << 1;
! Debug: eq int = const 2 to unsigned short infos = [S+$1C-$1C] (used reg = )
mov	ax,*2
mov	-$1A[bp],ax
!BCC_EOS
! 3751       }
! 3752     }
.51A:
! 3753     if (type == 0x03)
.512:
! Debug: logeq int = const 3 to unsigned char type = [S+$1C-$17] (used reg = )
mov	al,-$15[bp]
cmp	al,*3
jne 	.51B
.51C:
! 3754     {
! 3755       npc = 0xffffffff;
! Debug: eq unsigned long = const $FFFFFFFF to unsigned short npc = [S+$1C-$C] (used reg = )
mov	ax,#$FFFF
mov	-$A[bp],ax
!BCC_EOS
! 3756       nph = 0xffffffff;
! Debug: eq unsigned long = const $FFFFFFFF to unsigned short nph = [S+$1C-$E] (used reg = )
mov	ax,#$FFFF
mov	-$C[bp],ax
!BCC_EOS
! 3757       npspt = 0xffffffff;
! Debug: eq unsigned long = const $FFFFFFFF to unsigned short npspt = [S+$1C-$10] (used reg = )
mov	ax,#$FFFF
mov	-$E[bp],ax
!BCC_EOS
! 3758       lba_low = 0xffffffff;
! Debug: eq unsigned long = const $FFFFFFFF to unsigned long lba_low = [S+$1C-6] (used reg = )
mov	ax,#$FFFF
mov	bx,#$FFFF
mov	-4[bp],ax
mov	-2[bp],bx
!BCC_EOS
! 3759       lba_high = 0xffffffff;
! Debug: eq unsigned long = const $FFFFFFFF to unsigned long lba_high = [S+$1C-$A] (used reg = )
mov	ax,#$FFFF
mov	bx,#$FFFF
mov	-8[bp],ax
mov	-6[bp],bx
!BCC_EOS
! 3760       infos = 1 << 2 | 1 << 4 |
! 3761                1 << 5 | 1 << 6;
! Debug: eq int = const $74 to unsigned short infos = [S+$1C-$1C] (used reg = )
mov	ax,*$74
mov	-$1A[bp],ax
!BCC_EOS
! 3762     }
! 3763     _write_word(infos, SI+(Bit16u)&((dpt_t *) 0)->infos, DS);
.51B:
! Debug: list unsigned short DS = [S+$1C+2] (used reg = )
push	4[bp]
! Debug: add unsigned short = const 2 to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: list unsigned int = ax+2 (used reg = )
inc	ax
inc	ax
push	ax
! Debug: list unsigned short infos = [S+$20-$1C] (used reg = )
push	-$1A[bp]
! Debug: func () void = _write_word+0 (used reg = )
call	__write_word
add	sp,*6
!BCC_EOS
! 3764     _write_dword((Bit32u)npc, SI+(Bit16u)&((dpt_t *) 0)->cylinders, DS);
! Debug: list unsigned short DS = [S+$1C+2] (used reg = )
push	4[bp]
! Debug: add unsigned short = const 4 to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: list unsigned int = ax+4 (used reg = )
add	ax,*4
push	ax
! Debug: cast unsigned long = const 0 to unsigned short npc = [S+$20-$C] (used reg = )
mov	ax,-$A[bp]
xor	bx,bx
! Debug: list unsigned long = bx+0 (used reg = )
push	bx
push	ax
! Debug: func () void = _write_dword+0 (used reg = )
call	__write_dword
add	sp,*8
!BCC_EOS
! 3765     _write_dword((Bit32u)nph, SI+(Bit16u)&((dpt_t *) 0)->heads, DS);
! Debug: list unsigned short DS = [S+$1C+2] (used reg = )
push	4[bp]
! Debug: add unsigned short = const 8 to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: list unsigned int = ax+8 (used reg = )
add	ax,*8
push	ax
! Debug: cast unsigned long = const 0 to unsigned short nph = [S+$20-$E] (used reg = )
mov	ax,-$C[bp]
xor	bx,bx
! Debug: list unsigned long = bx+0 (used reg = )
push	bx
push	ax
! Debug: func () void = _write_dword+0 (used reg = )
call	__write_dword
add	sp,*8
!BCC_EOS
! 3766     _write_dword((Bit32u)npspt, SI+(Bit16u)&((dpt_t *) 0)->spt, DS);
! Debug: list unsigned short DS = [S+$1C+2] (used reg = )
push	4[bp]
! Debug: add unsigned short = const $C to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: list unsigned int = ax+$C (used reg = )
add	ax,*$C
push	ax
! Debug: cast unsigned long = const 0 to unsigned short npspt = [S+$20-$10] (used reg = )
mov	ax,-$E[bp]
xor	bx,bx
! Debug: list unsigned long = bx+0 (used reg = )
push	bx
push	ax
! Debug: func () void = _write_dword+0 (used reg = )
call	__write_dword
add	sp,*8
!BCC_EOS
! 3767     _write_dword(lba_low, SI+(Bit16u)&((dpt_t *) 0)->sector_count1, DS);
! Debug: list unsigned short DS = [S+$1C+2] (used reg = )
push	4[bp]
! Debug: add unsigned short = const $10 to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: list unsigned int = ax+$10 (used reg = )
add	ax,*$10
push	ax
! Debug: list unsigned long lba_low = [S+$20-6] (used reg = )
push	-2[bp]
push	-4[bp]
! Debug: func () void = _write_dword+0 (used reg = )
call	__write_dword
add	sp,*8
!BCC_EOS
! 3768     _write_dword(lba_high, SI+(Bit16u)&((dpt_t *) 0)->sector_count2, DS);
! Debug: list unsigned short DS = [S+$1C+2] (used reg = )
push	4[bp]
! Debug: add unsigned short = const $14 to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: list unsigned int = ax+$14 (used reg = )
add	ax,*$14
push	ax
! Debug: list unsigned long lba_high = [S+$20-$A] (used reg = )
push	-6[bp]
push	-8[bp]
! Debug: func () void = _write_dword+0 (used reg = )
call	__write_dword
add	sp,*8
!BCC_EOS
! 3769     _write_word(blksize, SI+(Bit16u)&((dpt_t *) 0)->blksize, DS);
! Debug: list unsigned short DS = [S+$1C+2] (used reg = )
push	4[bp]
! Debug: add unsigned short = const $18 to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: list unsigned int = ax+$18 (used reg = )
add	ax,*$18
push	ax
! Debug: list unsigned short blksize = [S+$20-$1A] (used reg = )
push	-$18[bp]
! Debug: func () void = _write_word+0 (used reg = )
call	__write_word
add	sp,*6
!BCC_EOS
! 3770   }
add	sp,*4
! 3771   if(size >= 30) {
.510:
! Debug: ge int = const $1E to unsigned short size = [S+$18-$12] (used reg = )
mov	ax,-$10[bp]
cmp	ax,*$1E
blo 	.51D
.51E:
! 3772     Bit8u channel, dev, irq, mode, checksum, i, translation;
!BCC_EOS
! 3773     Bit16u iobase1, iobase2, options;
!BCC_EOS
! 3774     _write_word(30, SI+(Bit16u)&((dpt_t *) 0)->size, DS);
add	sp,*-$E
! Debug: list unsigned short DS = [S+$26+2] (used reg = )
push	4[bp]
! Debug: add unsigned short = const 0 to unsigned short SI = [S+$28+4] (used reg = )
mov	ax,6[bp]
! Debug: list unsigned int = ax+0 (used reg = )
push	ax
! Debug: list int = const $1E (used reg = )
mov	ax,*$1E
push	ax
! Debug: func () void = _write_word+0 (used reg = )
call	__write_word
add	sp,*6
!BCC_EOS
! 3775     _write_word(ebda_seg, SI+(Bit16u)&((dpt_t *) 0)->dpte_segment, DS);
! Debug: list unsigned short DS = [S+$26+2] (used reg = )
push	4[bp]
! Debug: add unsigned short = const $1C to unsigned short SI = [S+$28+4] (used reg = )
mov	ax,6[bp]
! Debug: list unsigned int = ax+$1C (used reg = )
add	ax,*$1C
push	ax
! Debug: list unsigned short ebda_seg = [S+$2A-$16] (used reg = )
push	-$14[bp]
! Debug: func () void = _write_word+0 (used reg = )
call	__write_word
add	sp,*6
!BCC_EOS
! 3776     _write_word(&((ebda_data_t *) 0)->ata.dpte, SI+(Bit16u)&((dpt_t *) 0)->dpte_offset, DS);
! Debug: list unsigned short DS = [S+$26+2] (used reg = )
push	4[bp]
! Debug: add unsigned short = const $1A to unsigned short SI = [S+$28+4] (used reg = )
mov	ax,6[bp]
! Debug: list unsigned int = ax+$1A (used reg = )
add	ax,*$1A
push	ax
! Debug: list * struct  = const $244 (used reg = )
mov	ax,#$244
push	ax
! Debug: func () void = _write_word+0 (used reg = )
call	__write_word
add	sp,*6
!BCC_EOS
! 3777     channel = device / 2;
! Debug: div int = const 2 to unsigned char device = [S+$26+6] (used reg = )
mov	al,8[bp]
xor	ah,ah
shr	ax,*1
! Debug: eq unsigned int = ax+0 to unsigned char channel = [S+$26-$19] (used reg = )
mov	-$17[bp],al
!BCC_EOS
! 3778     iobase1 = *((Bit16u *)(&((ebda_data_t *) 0)->ata.chann
! 3778 els[channel].iobase1));
! Debug: ptradd unsigned char channel = [S+$26-$19] to [4] struct  = const $122 (used reg = )
mov	al,-$17[bp]
xor	ah,ah
mov	cl,*3
shl	ax,cl
mov	bx,ax
! Debug: address unsigned short = [bx+$124] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$124 (used reg = )
! Debug: eq unsigned short = [bx+$124] to unsigned short iobase1 = [S+$26-$22] (used reg = )
mov	bx,$124[bx]
mov	-$20[bp],bx
!BCC_EOS
! 3779     iobase2 = *((Bit16u *)(&((ebda_data_t *) 0)->ata.channels[channel].iobase2));
! Debug: ptradd unsigned char channel = [S+$26-$19] to [4] struct  = const $122 (used reg = )
mov	al,-$17[bp]
xor	ah,ah
mov	cl,*3
shl	ax,cl
mov	bx,ax
! Debug: address unsigned short = [bx+$126] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$126 (used reg = )
! Debug: eq unsigned short = [bx+$126] to unsigned short iobase2 = [S+$26-$24] (used reg = )
mov	bx,$126[bx]
mov	-$22[bp],bx
!BCC_EOS
! 3780     irq = *((Bit8u *)(&((ebda_data_t *) 0)->ata.channels[channel].irq));
! Debug: ptradd unsigned char channel = [S+$26-$19] to [4] struct  = const $122 (used reg = )
mov	al,-$17[bp]
xor	ah,ah
mov	cl,*3
shl	ax,cl
mov	bx,ax
! Debug: address unsigned char = [bx+$128] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$128 (used reg = )
! Debug: eq unsigned char = [bx+$128] to unsigned char irq = [S+$26-$1B] (used reg = )
mov	al,$128[bx]
mov	-$19[bp],al
!BCC_EOS
! 3781     mode = *((Bit8u *)(&((ebda_data_t *) 0)->ata.devices[device].mode));
! Debug: ptradd unsigned char device = [S+$26+6] to [8] struct  = const $142 (used reg = )
mov	al,8[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned char = [bx+$146] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$146 (used reg = )
! Debug: eq unsigned char = [bx+$146] to unsigned char mode = [S+$26-$1C] (used reg = )
mov	al,$146[bx]
mov	-$1A[bp],al
!BCC_EOS
! 3782     translation = *((Bit8u *)(&((ebda_data_t *) 0)->ata.devices[device].translation));
! Debug: ptradd unsigned char device = [S+$26+6] to [8] struct  = const $142 (used reg = )
mov	al,8[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned char = [bx+$14A] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$14A (used reg = )
! Debug: eq unsigned char = [bx+$14A] to unsigned char translation = [S+$26-$1F] (used reg = )
mov	al,$14A[bx]
mov	-$1D[bp],al
!BCC_EOS
! 3783     options = (1<<4);
! Debug: eq int = const $10 to unsigned short options = [S+$26-$26] (used reg = )
mov	ax,*$10
mov	-$24[bp],ax
!BCC_EOS
! 3784     options |= (mode==0x01?1:0)<<7;
! Debug: logeq int = const 1 to unsigned char mode = [S+$26-$1C] (used reg = )
mov	al,-$1A[bp]
cmp	al,*1
jne 	.51F
.520:
mov	al,*1
jmp .521
.51F:
xor	al,al
.521:
! Debug: sl int = const 7 to char = al+0 (used reg = )
xor	ah,ah
mov	cl,*7
shl	ax,cl
! Debug: orab int = ax+0 to unsigned short options = [S+$26-$26] (used reg = )
or	ax,-$24[bp]
mov	-$24[bp],ax
!BCC_EOS
! 3785     if (type == 0x02)
! Debug: logeq int = const 2 to unsigned char type = [S+$26-$17] (used reg = )
mov	al,-$15[bp]
cmp	al,*2
jne 	.522
.523:
! 3786     {
! 3787       options |= (translation==0?0:1)<<3;
! Debug: logeq int = const 0 to unsigned char translation = [S+$26-$1F] (used reg = )
mov	al,-$1D[bp]
test	al,al
jne 	.524
.525:
xor	al,al
jmp .526
.524:
mov	al,*1
.526:
! Debug: sl int = const 3 to char = al+0 (used reg = )
xor	ah,ah
mov	cl,*3
shl	ax,cl
! Debug: orab int = ax+0 to unsigned short options = [S+$26-$26] (used reg = )
or	ax,-$24[bp]
mov	-$24[bp],ax
!BCC_EOS
! 3788       options |= (translation==1?1:0)<<9;
! Debug: logeq int = const 1 to unsigned char translation = [S+$26-$1F] (used reg = )
mov	al,-$1D[bp]
cmp	al,*1
jne 	.527
.528:
mov	al,*1
jmp .529
.527:
xor	al,al
.529:
! Debug: sl int = const 9 to char = al+0 (used reg = )
xor	ah,ah
mov	ah,al
xor	al,al
shl	ax,*1
! Debug: orab int = ax+0 to unsigned short options = [S+$26-$26] (used reg = )
or	ax,-$24[bp]
mov	-$24[bp],ax
!BCC_EOS
! 3789       options |= (translation==3?3:0)<<9;
! Debug: logeq int = const 3 to unsigned char translation = [S+$26-$1F] (used reg = )
mov	al,-$1D[bp]
cmp	al,*3
jne 	.52A
.52B:
mov	al,*3
jmp .52C
.52A:
xor	al,al
.52C:
! Debug: sl int = const 9 to char = al+0 (used reg = )
xor	ah,ah
mov	ah,al
xor	al,al
shl	ax,*1
! Debug: orab int = ax+0 to unsigned short options = [S+$26-$26] (used reg = )
or	ax,-$24[bp]
mov	-$24[bp],ax
!BCC_EOS
! 3790     }
! 3791     if (type == 0x03)
.522:
! Debug: logeq int = const 3 to unsigned char type = [S+$26-$17] (used reg = )
mov	al,-$15[bp]
cmp	al,*3
jne 	.52D
.52E:
! 3792     {
! 3793       options |= (1<<5);
! Debug: orab int = const $20 to unsigned short options = [S+$26-$26] (used reg = )
mov	ax,-$24[bp]
or	al,*$20
mov	-$24[bp],ax
!BCC_EOS
! 3794       options |= (1<<6);
! Debug: orab int = const $40 to unsigned short options = [S+$26-$26] (used reg = )
mov	ax,-$24[bp]
or	al,*$40
mov	-$24[bp],ax
!BCC_EOS
! 3795     }
! 3796     *((Bit16u *)(&((ebda_data_t *) 0)->ata.dpte.iobase1)) = (iobase1);
.52D:
! Debug: eq unsigned short iobase1 = [S+$26-$22] to unsigned short = [+$244] (used reg = )
mov	ax,-$20[bp]
mov	[$244],ax
!BCC_EOS
! 3797     *((Bit16u *)(&((ebda_data_t *) 0)->ata.dpte.iobase2)) = (iobase2 + 6);
! Debug: add int = const 6 to unsigned short iobase2 = [S+$26-$24] (used reg = )
mov	ax,-$22[bp]
! Debug: eq unsigned int = ax+6 to unsigned short = [+$246] (used reg = )
add	ax,*6
mov	[$246],ax
!BCC_EOS
! 3798     *((Bit8u *)(&((ebda_data_t *) 0)->ata.dpte.prefix)) = ((0xe | (device % 2))<<4);
! Debug: mod int = const 2 to unsigned char device = [S+$26+6] (used reg = )
mov	al,8[bp]
xor	ah,ah
and	al,*1
! Debug: or unsigned char = al+0 to int = const $E (used reg = )
! Debug: expression subtree swapping
or	al,*$E
! Debug: sl int = const 4 to unsigned char = al+0 (used reg = )
xor	ah,ah
mov	cl,*4
shl	ax,cl
! Debug: eq unsigned int = ax+0 to unsigned char = [+$248] (used reg = )
mov	[$248],al
!BCC_EOS
! 3799     *((Bit8u *)(&((ebda_data_t *) 0)->ata.dpte.unused)) = (0xcb);
! Debug: eq int = const $CB to unsigned char = [+$249] (used reg = )
mov	al,#$CB
mov	[$249],al
!BCC_EOS
! 3800     *((Bit8u *)(&((ebda_data_t *) 0)->ata.dpte.irq)) = (irq);
! Debug: eq unsigned char irq = [S+$26-$1B] to unsigned char = [+$24A] (used reg = )
mov	al,-$19[bp]
mov	[$24A],al
!BCC_EOS
! 3801     *((Bit8u *)(&((ebda_data_t *) 0)->ata.dpte.blkcount)) = (1);
! Debug: eq int = const 1 to unsigned char = [+$24B] (used reg = )
mov	al,*1
mov	[$24B],al
!BCC_EOS
! 3802     *((Bit8u *)(&((ebda_data_t *) 0)->ata.dpte.dma)) = (0);
! Debug: eq int = const 0 to unsigned char = [+$24C] (used reg = )
xor	al,al
mov	[$24C],al
!BCC_EOS
! 3803     *((Bit8u *)(&((ebda_data_t *) 0)->ata.dpte.pio)) = (0);
! Debug: eq int = const 0 to unsigned char = [+$24D] (used reg = )
xor	al,al
mov	[$24D],al
!BCC_EOS
! 3804     *((Bit16u *)(&((ebda_data_t *) 0)->ata.dpte.options)) = (options);
! Debug: eq unsigned short options = [S+$26-$26] to unsigned short = [+$24E] (used reg = )
mov	ax,-$24[bp]
mov	[$24E],ax
!BCC_EOS
! 3805     *((Bit16u *)(&((ebda_data_t *) 0)->ata.dpte.reserved)) = (0);
! Debug: eq int = const 0 to unsigned short = [+$250] (used reg = )
xor	ax,ax
mov	[$250],ax
!BCC_EOS
! 3806     *((Bit8u *)(&((ebda_data_t *) 0)->ata.dpte.revision)) = (0x11);
! Debug: eq int = const $11 to unsigned char = [+$252] (used reg = )
mov	al,*$11
mov	[$252],al
!BCC_EOS
! 3807     checksum=0;
! Debug: eq int = const 0 to unsigned char checksum = [S+$26-$1D] (used reg = )
xor	al,al
mov	-$1B[bp],al
!BCC_EOS
! 3808     for (i=0; i<15; i++) checksum+=*((Bit8u *)(((Bit8u*)(&((ebda_data_t *) 0)->ata.dpte)) + i));
! Debug: eq int = const 0 to unsigned char i = [S+$26-$1E] (used reg = )
xor	al,al
mov	-$1C[bp],al
!BCC_EOS
!BCC_EOS
jmp .531
.532:
! Debug: ptradd unsigned char i = [S+$26-$1E] to * unsigned char = const $244 (used reg = )
mov	al,-$1C[bp]
xor	ah,ah
! Debug: cast * unsigned char = const 0 to * unsigned char = ax+$244 (used reg = )
mov	bx,ax
! Debug: addab unsigned char = [bx+$244] to unsigned char checksum = [S+$26-$1D] (used reg = )
mov	al,-$1B[bp]
xor	ah,ah
add	al,$244[bx]
adc	ah,*0
mov	-$1B[bp],al
!BCC_EOS
! 3809     checksum = -checksum;
.530:
! Debug: postinc unsigned char i = [S+$26-$1E] (used reg = )
mov	al,-$1C[bp]
inc	ax
mov	-$1C[bp],al
.531:
! Debug: lt int = const $F to unsigned char i = [S+$26-$1E] (used reg = )
mov	al,-$1C[bp]
cmp	al,*$F
jb 	.532
.533:
.52F:
! Debug: neg unsigned char checksum = [S+$26-$1D] (used reg = )
xor	ax,ax
sub	al,-$1B[bp]
sbb	ah,*0
! Debug: eq unsigned int = ax+0 to unsigned char checksum = [S+$26-$1D] (used reg = )
mov	-$1B[bp],al
!BCC_EOS
! 3810     *((Bit8u *)(&((ebda_data_t *) 0)->ata.dpte.checksum)) = (checksum);
! Debug: eq unsigned char checksum = [S+$26-$1D] to unsigned char = [+$253] (used reg = )
mov	al,-$1B[bp]
mov	[$253],al
!BCC_EOS
! 3811   }
add	sp,*$E
! 3812   if(size >= 66) {
.51D:
! Debug: ge int = const $42 to unsigned short size = [S+$18-$12] (used reg = )
mov	ax,-$10[bp]
cmp	ax,*$42
blo 	.534
.535:
! 3813     Bit8u channel, iface, checksum, i;
!BCC_EOS
! 3814     Bit16u iobase1;
!BCC_EOS
! 3815     channel = device / 2;
add	sp,*-6
! Debug: div int = const 2 to unsigned char device = [S+$1E+6] (used reg = )
mov	al,8[bp]
xor	ah,ah
shr	ax,*1
! Debug: eq unsigned int = ax+0 to unsigned char channel = [S+$1E-$19] (used reg = )
mov	-$17[bp],al
!BCC_EOS
! 3816     iface = *((Bit8u *)(&((ebda_data_t *) 0)->ata.channels[channel].iface));
! Debug: ptradd unsigned char channel = [S+$1E-$19] to [4] struct  = const $122 (used reg = )
mov	al,-$17[bp]
xor	ah,ah
mov	cl,*3
shl	ax,cl
mov	bx,ax
! Debug: address unsigned char = [bx+$122] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$122 (used reg = )
! Debug: eq unsigned char = [bx+$122] to unsigned char iface = [S+$1E-$1A] (used reg = )
mov	al,$122[bx]
mov	-$18[bp],al
!BCC_EOS
! 3817     iobase1 = *((Bit16u *)(&((ebda_data_t *) 0)->ata.channels[channel].iobase1));
! Debug: ptradd unsigned char channel = [S+$1E-$19] to [4] struct  = const $122 (used reg = )
mov	al,-$17[bp]
xor	ah,ah
mov	cl,*3
shl	ax,cl
mov	bx,ax
! Debug: address unsigned short = [bx+$124] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$124 (used reg = )
! Debug: eq unsigned short = [bx+$124] to unsigned short iobase1 = [S+$1E-$1E] (used reg = )
mov	bx,$124[bx]
mov	-$1C[bp],bx
!BCC_EOS
! 3818     set_DS(DS);
! Debug: list unsigned short DS = [S+$1E+2] (used reg = )
push	4[bp]
! Debug: func () unsigned short = set_DS+0 (used reg = )
call	_set_DS
inc	sp
inc	sp
!BCC_EOS
! 3819     *((Bit16u *)(SI+(Bit16u)&((dpt_t *) 0)->dpi.t13.key)) = (0xbedd);
! Debug: add unsigned short = const $1E to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned short = const 0 to unsigned int = ax+$1E (used reg = )
mov	bx,ax
! Debug: eq unsigned int = const $BEDD to unsigned short = [bx+$1E] (used reg = )
mov	ax,#$BEDD
mov	$1E[bx],ax
!BCC_EOS
! 3820     *((Bit8u *)(SI+(Bit16u)&((dpt_t *) 0)->dpi.t13.dpi_length)) = (t13 ? 44 : 36);
mov	ax,-$12[bp]
test	ax,ax
je  	.536
.537:
mov	al,*$2C
jmp .538
.536:
mov	al,*$24
.538:
push	ax
! Debug: add unsigned short = const $20 to unsigned short SI = [S+$20+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$20 (used reg = )
mov	bx,ax
! Debug: eq char (temp) = [S+$20-$20] to unsigned char = [bx+$20] (used reg = )
mov	al,-$1E[bp]
mov	$20[bx],al
inc	sp
inc	sp
!BCC_EOS
! 3821     *((Bit8
! 3821 u *)(SI+(Bit16u)&((dpt_t *) 0)->dpi.t13.reserved1)) = (0);
! Debug: add unsigned short = const $21 to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$21 (used reg = )
mov	bx,ax
! Debug: eq int = const 0 to unsigned char = [bx+$21] (used reg = )
xor	al,al
mov	$21[bx],al
!BCC_EOS
! 3822     *((Bit16u *)(SI+(Bit16u)&((dpt_t *) 0)->dpi.t13.reserved2)) = (0);
! Debug: add unsigned short = const $22 to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned short = const 0 to unsigned int = ax+$22 (used reg = )
mov	bx,ax
! Debug: eq int = const 0 to unsigned short = [bx+$22] (used reg = )
xor	ax,ax
mov	$22[bx],ax
!BCC_EOS
! 3823     if (iface==0x00) {
! Debug: logeq int = const 0 to unsigned char iface = [S+$1E-$1A] (used reg = )
mov	al,-$18[bp]
test	al,al
jne 	.539
.53A:
! 3824       *((Bit8u *)(SI+(Bit16u)&((dpt_t *) 0)->dpi.t13.host_bus[0])) = ('I');
! Debug: add unsigned short = const $24 to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$24 (used reg = )
mov	bx,ax
! Debug: eq int = const $49 to unsigned char = [bx+$24] (used reg = )
mov	al,*$49
mov	$24[bx],al
!BCC_EOS
! 3825       *((Bit8u *)(SI+(Bit16u)&((dpt_t *) 0)->dpi.t13.host_bus[1])) = ('S');
! Debug: add unsigned short = const $25 to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$25 (used reg = )
mov	bx,ax
! Debug: eq int = const $53 to unsigned char = [bx+$25] (used reg = )
mov	al,*$53
mov	$25[bx],al
!BCC_EOS
! 3826       *((Bit8u *)(SI+(Bit16u)&((dpt_t *) 0)->dpi.t13.host_bus[2])) = ('A');
! Debug: add unsigned short = const $26 to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$26 (used reg = )
mov	bx,ax
! Debug: eq int = const $41 to unsigned char = [bx+$26] (used reg = )
mov	al,*$41
mov	$26[bx],al
!BCC_EOS
! 3827       *((Bit8u *)(SI+(Bit16u)&((dpt_t *) 0)->dpi.t13.host_bus[3])) = (' ');
! Debug: add unsigned short = const $27 to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$27 (used reg = )
mov	bx,ax
! Debug: eq int = const $20 to unsigned char = [bx+$27] (used reg = )
mov	al,*$20
mov	$27[bx],al
!BCC_EOS
! 3828     }
! 3829     else {
jmp .53B
.539:
! 3830     }
! 3831     if (type == 0x02) {
.53B:
! Debug: logeq int = const 2 to unsigned char type = [S+$1E-$17] (used reg = )
mov	al,-$15[bp]
cmp	al,*2
jne 	.53C
.53D:
! 3832         *((Bit8u *)(SI+(Bit16u)&((dpt_t *) 0)->dpi.t13.iface_type[0])) = ('A');
! Debug: add unsigned short = const $28 to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$28 (used reg = )
mov	bx,ax
! Debug: eq int = const $41 to unsigned char = [bx+$28] (used reg = )
mov	al,*$41
mov	$28[bx],al
!BCC_EOS
! 3833         *((Bit8u *)(SI+(Bit16u)&((dpt_t *) 0)->dpi.t13.iface_type[1])) = ('T');
! Debug: add unsigned short = const $29 to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$29 (used reg = )
mov	bx,ax
! Debug: eq int = const $54 to unsigned char = [bx+$29] (used reg = )
mov	al,*$54
mov	$29[bx],al
!BCC_EOS
! 3834         *((Bit8u *)(SI+(Bit16u)&((dpt_t *) 0)->dpi.t13.iface_type[2])) = ('A');
! Debug: add unsigned short = const $2A to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$2A (used reg = )
mov	bx,ax
! Debug: eq int = const $41 to unsigned char = [bx+$2A] (used reg = )
mov	al,*$41
mov	$2A[bx],al
!BCC_EOS
! 3835         *((Bit8u *)(SI+(Bit16u)&((dpt_t *) 0)->dpi.t13.iface_type[3])) = (' ');
! Debug: add unsigned short = const $2B to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$2B (used reg = )
mov	bx,ax
! Debug: eq int = const $20 to unsigned char = [bx+$2B] (used reg = )
mov	al,*$20
mov	$2B[bx],al
!BCC_EOS
! 3836         *((Bit8u *)(SI+(Bit16u)&((dpt_t *) 0)->dpi.t13.iface_type[4])) = (' ');
! Debug: add unsigned short = const $2C to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$2C (used reg = )
mov	bx,ax
! Debug: eq int = const $20 to unsigned char = [bx+$2C] (used reg = )
mov	al,*$20
mov	$2C[bx],al
!BCC_EOS
! 3837         *((Bit8u *)(SI+(Bit16u)&((dpt_t *) 0)->dpi.t13.iface_type[5])) = (' ');
! Debug: add unsigned short = const $2D to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$2D (used reg = )
mov	bx,ax
! Debug: eq int = const $20 to unsigned char = [bx+$2D] (used reg = )
mov	al,*$20
mov	$2D[bx],al
!BCC_EOS
! 3838         *((Bit8u *)(SI+(Bit16u)&((dpt_t *) 0)->dpi.t13.iface_type[6])) = (' ');
! Debug: add unsigned short = const $2E to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$2E (used reg = )
mov	bx,ax
! Debug: eq int = const $20 to unsigned char = [bx+$2E] (used reg = )
mov	al,*$20
mov	$2E[bx],al
!BCC_EOS
! 3839         *((Bit8u *)(SI+(Bit16u)&((dpt_t *) 0)->dpi.t13.iface_type[7])) = (' ');
! Debug: add unsigned short = const $2F to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$2F (used reg = )
mov	bx,ax
! Debug: eq int = const $20 to unsigned char = [bx+$2F] (used reg = )
mov	al,*$20
mov	$2F[bx],al
!BCC_EOS
! 3840     } else if (type == 0x03) {
br 	.53E
.53C:
! Debug: logeq int = const 3 to unsigned char type = [S+$1E-$17] (used reg = )
mov	al,-$15[bp]
cmp	al,*3
bne 	.53F
.540:
! 3841         *((Bit8u *)(SI+(Bit16u)&((dpt_t *) 0)->dpi.t13.iface_type[0])) = ('A');
! Debug: add unsigned short = const $28 to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$28 (used reg = )
mov	bx,ax
! Debug: eq int = const $41 to unsigned char = [bx+$28] (used reg = )
mov	al,*$41
mov	$28[bx],al
!BCC_EOS
! 3842         *((Bit8u *)(SI+(Bit16u)&((dpt_t *) 0)->dpi.t13.iface_type[1])) = ('T');
! Debug: add unsigned short = const $29 to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$29 (used reg = )
mov	bx,ax
! Debug: eq int = const $54 to unsigned char = [bx+$29] (used reg = )
mov	al,*$54
mov	$29[bx],al
!BCC_EOS
! 3843         *((Bit8u *)(SI+(Bit16u)&((dpt_t *) 0)->dpi.t13.iface_type[2])) = ('A');
! Debug: add unsigned short = const $2A to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$2A (used reg = )
mov	bx,ax
! Debug: eq int = const $41 to unsigned char = [bx+$2A] (used reg = )
mov	al,*$41
mov	$2A[bx],al
!BCC_EOS
! 3844         *((Bit8u *)(SI+(Bit16u)&((dpt_t *) 0)->dpi.t13.iface_type[3])) = ('P');
! Debug: add unsigned short = const $2B to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$2B (used reg = )
mov	bx,ax
! Debug: eq int = const $50 to unsigned char = [bx+$2B] (used reg = )
mov	al,*$50
mov	$2B[bx],al
!BCC_EOS
! 3845         *((Bit8u *)(SI+(Bit16u)&((dpt_t *) 0)->dpi.t13.iface_type[4])) = ('I');
! Debug: add unsigned short = const $2C to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$2C (used reg = )
mov	bx,ax
! Debug: eq int = const $49 to unsigned char = [bx+$2C] (used reg = )
mov	al,*$49
mov	$2C[bx],al
!BCC_EOS
! 3846         *((Bit8u *)(SI+(Bit16u)&((dpt_t *) 0)->dpi.t13.iface_type[5])) = (' ');
! Debug: add unsigned short = const $2D to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$2D (used reg = )
mov	bx,ax
! Debug: eq int = const $20 to unsigned char = [bx+$2D] (used reg = )
mov	al,*$20
mov	$2D[bx],al
!BCC_EOS
! 3847         *((Bit8u *)(SI+(Bit16u)&((dpt_t *) 0)->dpi.t13.iface_type[6])) = (' ');
! Debug: add unsigned short = const $2E to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$2E (used reg = )
mov	bx,ax
! Debug: eq int = const $20 to unsigned char = [bx+$2E] (used reg = )
mov	al,*$20
mov	$2E[bx],al
!BCC_EOS
! 3848         *((Bit8u *)(SI+(Bit16u)&((dpt_t *) 0)->dpi.t13.iface_type[7])) = (' ');
! Debug: add unsigned short = const $2F to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$2F (used reg = )
mov	bx,ax
! Debug: eq int = const $20 to unsigned char = [bx+$2F] (used reg = )
mov	al,*$20
mov	$2F[bx],al
!BCC_EOS
! 3849     }
! 3850     if (iface==0x00) {
.53F:
.53E:
! Debug: logeq int = const 0 to unsigned char iface = [S+$1E-$1A] (used reg = )
mov	al,-$18[bp]
test	al,al
jne 	.541
.542:
! 3851       *((Bit16u *)(SI+(Bit16u)&((dpt_t *) 0)->dpi.t13.iface_path[0])) = (iobase1);
! Debug: add unsigned short = const $30 to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned short = const 0 to unsigned int = ax+$30 (used reg = )
mov	bx,ax
! Debug: eq unsigned short iobase1 = [S+$1E-$1E] to unsigned short = [bx+$30] (used reg = )
mov	ax,-$1C[bp]
mov	$30[bx],ax
!BCC_EOS
! 3852       *((Bit16u *)(SI+(Bit16u)&((dpt_t *) 0)->dpi.t13.iface_path[2])) = (0);
! Debug: add unsigned short = const $32 to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned short = const 0 to unsigned int = ax+$32 (used reg = )
mov	bx,ax
! Debug: eq int = const 0 to unsigned short = [bx+$32] (used reg = )
xor	ax,ax
mov	$32[bx],ax
!BCC_EOS
! 3853       *((Bit32u *)(SI+(Bit16u)&((dpt_t *) 0)
! 3853 ->dpi.t13.iface_path[4])) = (0L);
! Debug: add unsigned short = const $34 to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned long = const 0 to unsigned int = ax+$34 (used reg = )
mov	bx,ax
! Debug: eq long = const 0 to unsigned long = [bx+$34] (used reg = )
xor	ax,ax
xor	si,si
mov	$34[bx],ax
mov	$36[bx],si
!BCC_EOS
! 3854     }
! 3855     else {
jmp .543
.541:
! 3856     }
! 3857     *((Bit8u *)(SI+(Bit16u)&((dpt_t *) 0)->dpi.t13.device_path[0])) = (device%2);
.543:
! Debug: mod int = const 2 to unsigned char device = [S+$1E+6] (used reg = )
mov	al,8[bp]
xor	ah,ah
and	al,*1
push	ax
! Debug: add unsigned short = const $38 to unsigned short SI = [S+$20+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$38 (used reg = )
mov	bx,ax
! Debug: eq unsigned char (temp) = [S+$20-$20] to unsigned char = [bx+$38] (used reg = )
mov	al,-$1E[bp]
mov	$38[bx],al
inc	sp
inc	sp
!BCC_EOS
! 3858     *((Bit8u *)(SI+(Bit16u)&((dpt_t *) 0)->dpi.t13.device_path[1])) = (0);
! Debug: add unsigned short = const $39 to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$39 (used reg = )
mov	bx,ax
! Debug: eq int = const 0 to unsigned char = [bx+$39] (used reg = )
xor	al,al
mov	$39[bx],al
!BCC_EOS
! 3859     *((Bit16u *)(SI+(Bit16u)&((dpt_t *) 0)->dpi.t13.device_path[2])) = (0);
! Debug: add unsigned short = const $3A to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned short = const 0 to unsigned int = ax+$3A (used reg = )
mov	bx,ax
! Debug: eq int = const 0 to unsigned short = [bx+$3A] (used reg = )
xor	ax,ax
mov	$3A[bx],ax
!BCC_EOS
! 3860     *((Bit32u *)(SI+(Bit16u)&((dpt_t *) 0)->dpi.t13.device_path[4])) = (0L);
! Debug: add unsigned short = const $3C to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned long = const 0 to unsigned int = ax+$3C (used reg = )
mov	bx,ax
! Debug: eq long = const 0 to unsigned long = [bx+$3C] (used reg = )
xor	ax,ax
xor	si,si
mov	$3C[bx],ax
mov	$3E[bx],si
!BCC_EOS
! 3861     if (t13) {
mov	ax,-$12[bp]
test	ax,ax
je  	.544
.545:
! 3862       *((Bit32u *)(SI+(Bit16u)&((dpt_t *) 0)->dpi.t13.device_path[8])) = (0L);
! Debug: add unsigned short = const $40 to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned long = const 0 to unsigned int = ax+$40 (used reg = )
mov	bx,ax
! Debug: eq long = const 0 to unsigned long = [bx+$40] (used reg = )
xor	ax,ax
xor	si,si
mov	$40[bx],ax
mov	$42[bx],si
!BCC_EOS
! 3863       *((Bit32u *)(SI+(Bit16u)&((dpt_t *) 0)->dpi.t13.device_path[12])) = (0L);
! Debug: add unsigned short = const $44 to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned long = const 0 to unsigned int = ax+$44 (used reg = )
mov	bx,ax
! Debug: eq long = const 0 to unsigned long = [bx+$44] (used reg = )
xor	ax,ax
xor	si,si
mov	$44[bx],ax
mov	$46[bx],si
!BCC_EOS
! 3864     }
! 3865     if (t13)
.544:
mov	ax,-$12[bp]
test	ax,ax
je  	.546
.547:
! 3866       *((Bit8u *)(SI+(Bit16u)&((dpt_t *) 0)->dpi.t13.reserved3)) = (0);
! Debug: add unsigned short = const $48 to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$48 (used reg = )
mov	bx,ax
! Debug: eq int = const 0 to unsigned char = [bx+$48] (used reg = )
xor	al,al
mov	$48[bx],al
!BCC_EOS
! 3867     else
! 3868       *((Bit8u *)(SI+(Bit16u)&((dpt_t *) 0)->dpi.phoenix.reserved3)) = (0);
jmp .548
.546:
! Debug: add unsigned short = const $40 to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$40 (used reg = )
mov	bx,ax
! Debug: eq int = const 0 to unsigned char = [bx+$40] (used reg = )
xor	al,al
mov	$40[bx],al
!BCC_EOS
! 3869     checksum = 0;
.548:
! Debug: eq int = const 0 to unsigned char checksum = [S+$1E-$1B] (used reg = )
xor	al,al
mov	-$19[bp],al
!BCC_EOS
! 3870     for (i = 30; i < (t13 ? 73 : 65); i++) checksum += *((Bit8u *)(SI + i));
! Debug: eq int = const $1E to unsigned char i = [S+$1E-$1C] (used reg = )
mov	al,*$1E
mov	-$1A[bp],al
!BCC_EOS
!BCC_EOS
jmp .54B
.54C:
! Debug: add unsigned char i = [S+$1E-$1C] to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
add	al,-$1A[bp]
adc	ah,*0
! Debug: cast * unsigned char = const 0 to unsigned int = ax+0 (used reg = )
mov	bx,ax
! Debug: addab unsigned char = [bx+0] to unsigned char checksum = [S+$1E-$1B] (used reg = )
mov	al,-$19[bp]
xor	ah,ah
add	al,[bx]
adc	ah,*0
mov	-$19[bp],al
!BCC_EOS
! 3871     checksum = -checksum;
.54A:
! Debug: postinc unsigned char i = [S+$1E-$1C] (used reg = )
mov	al,-$1A[bp]
inc	ax
mov	-$1A[bp],al
.54B:
mov	ax,-$12[bp]
test	ax,ax
je  	.54E
.54F:
mov	al,*$49
jmp .550
.54E:
mov	al,*$41
.550:
! Debug: lt char = al+0 to unsigned char i = [S+$1E-$1C] (used reg = )
cmp	al,-$1A[bp]
ja 	.54C
.54D:
.549:
! Debug: neg unsigned char checksum = [S+$1E-$1B] (used reg = )
xor	ax,ax
sub	al,-$19[bp]
sbb	ah,*0
! Debug: eq unsigned int = ax+0 to unsigned char checksum = [S+$1E-$1B] (used reg = )
mov	-$19[bp],al
!BCC_EOS
! 3872     if (t13)
mov	ax,-$12[bp]
test	ax,ax
je  	.551
.552:
! 3873       *((Bit8u *)(SI+(Bit16u)&((dpt_t *) 0)->dpi.t13.checksum)) = (checksum);
! Debug: add unsigned short = const $49 to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$49 (used reg = )
mov	bx,ax
! Debug: eq unsigned char checksum = [S+$1E-$1B] to unsigned char = [bx+$49] (used reg = )
mov	al,-$19[bp]
mov	$49[bx],al
!BCC_EOS
! 3874     else
! 3875       *((Bit8u *)(SI+(Bit16u)&((dpt_t *) 0)->dpi.phoenix.checksum)) = (checksum);
jmp .553
.551:
! Debug: add unsigned short = const $41 to unsigned short SI = [S+$1E+4] (used reg = )
mov	ax,6[bp]
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$41 (used reg = )
mov	bx,ax
! Debug: eq unsigned char checksum = [S+$1E-$1B] to unsigned char = [bx+$41] (used reg = )
mov	al,-$19[bp]
mov	$41[bx],al
!BCC_EOS
! 3876   }
.553:
add	sp,*6
! 3877   return 0;
.534:
xor	ax,ax
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 3878 }
! 3879   void
! Register BX used in function int13_edd
! 3880 int13_harddisk(EHAX, DS, ES, DI, SI, BP, ELDX, BX, DX, CX, AX, IP, CS, FLAGS)
! 3881   Bit16u EHAX, DS, ES, DI, SI, BP, ELDX, BX, DX, CX, AX, IP, CS, FLAGS;
export	_int13_harddisk
_int13_harddisk:
!BCC_EOS
! 3882 {
! 3883   Bit32u lba_low, lba_high;
!BCC_EOS
! 3884   Bit16u cylinder, head, sector;
!BCC_EOS
! 3885   Bit16u segment, offset;
!BCC_EOS
! 3886   Bit16u npc, nph, npspt, nlc, nlh, nlspt;
!BCC_EOS
! 3887   Bit16u size, count;
!BCC_EOS
! 3888   Bit8u device, status;
!BCC_EOS
! 3889   ;
push	bp
mov	bp,sp
add	sp,*-$24
!BCC_EOS
! 3890   _write_byte(0, 0x008e, 0x0040);
! Debug: list int = const $40 (used reg = )
mov	ax,*$40
push	ax
! Debug: list int = const $8E (used reg = )
mov	ax,#$8E
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: func () void = _write_byte+0 (used reg = )
call	__write_byte
add	sp,*6
!BCC_EOS
! 3891   if ( (( ELDX & 0x00ff ) < 0x80) || (( ELDX & 0x00ff ) >= 0x80 + (4*2)) ) {
! Debug: and int = const $FF to unsigned short ELDX = [S+$26+$E] (used reg = )
mov	al,$10[bp]
! Debug: lt int = const $80 to unsigned char = al+0 (used reg = )
cmp	al,#$80
jb  	.555
.556:
! Debug: and int = const $FF to unsigned short ELDX = [S+$26+$E] (used reg = )
mov	al,$10[bp]
! Debug: ge int = const $88 to unsigned char = al+0 (used reg = )
cmp	al,#$88
jb  	.554
.555:
! 3892     bios_printf(4, "int13_harddisk: function %02x, ELDL out of range %02x\n", *(((Bit8u *)&AX)+1), ( ELDX & 0x00ff ));
! Debug: and int = const $FF to unsigned short ELDX = [S+$26+$E] (used reg = )
mov	al,$10[bp]
! Debug: list unsigned char = al+0 (used reg = )
xor	ah,ah
push	ax
! Debug: list unsigned char AX = [S+$28+$17] (used reg = )
mov	al,$19[bp]
xor	ah,ah
push	ax
! Debug: list * char = .557+0 (used reg = )
mov	bx,#.557
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*8
!BCC_EOS
! 3893     goto int13_fail;
add	sp,#..FFF1+$26
br 	.FFF1
!BCC_EOS
! 3894   }
! 3895   device=*((Bit8u *)(&((ebda_data_t *) 0)->ata.hdidmap[( ELDX & 0x00ff )-0x80]));
.554:
! Debug: and int = const $FF to unsigned short ELDX = [S+$26+$E] (used reg = )
mov	al,$10[bp]
! Debug: sub int = const $80 to unsigned char = al+0 (used reg = )
xor	ah,ah
! Debug: ptradd unsigned int = ax-$80 to [8] unsigned char = const $233 (used reg = )
add	ax,*-$80
mov	bx,ax
! Debug: address unsigned char = [bx+$233] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$233 (used reg = )
! Debug: eq unsigned char = [bx+$233] to unsigned char device = [S+$26-$25] (used reg = )
mov	al,$233[bx]
mov	-$23[bp],al
!BCC_EOS
! 3896   if (device >= (4*2)) {
! Debug: ge int = const 8 to unsigned char device = [S+$26-$25] (used reg = )
mov	al,-$23[bp]
cmp	al,*8
jb  	.558
.559:
! 3897     bios_printf(4, "int13_harddisk: function %02x, unmapped device for ELDL=%02x\n", *(((Bit8u *)&AX)+1), ( ELDX & 0x00ff ));
! Debug: and int = const $FF to unsigned short ELDX = [S+$26+$E] (used reg = )
mov	al,$10[bp]
! Debug: list unsigned char = al+0 (used reg = )
xor	ah,ah
push	ax
! Debug: list unsigned char AX = [S+$28+$17] (used reg = )
mov	al,$19[bp]
xor	ah,ah
push	ax
! Debug: list * char = .55A+0 (used reg = )
mov	bx,#.55A
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*8
!BCC_EOS
! 3898     goto int13_fail;
add	sp,#..FFF1+$26
br 	.FFF1
!BCC_EOS
! 3899   }
! 3900   switch (*(((Bit8u *)&AX)+1)) {
.558:
mov	al,$19[bp]
br 	.55D
! 3901     case 0x00:
! 3902       ata_reset (device);
.55E:
! Debug: list unsigned char device = [S+$26-$25] (used reg = )
mov	al,-$23[bp]
xor	ah,ah
push	ax
! Debug: func () void = ata_reset+0 (used reg = )
call	_ata_reset
inc	sp
inc	sp
!BCC_EOS
! 3903       goto int13_success;
add	sp,#..FFEF-..FFF0
br 	.FFEF
!BCC_EOS
! 3904       break;
br 	.55B
!BCC_EOS
! 3905     case 0x01:
! 3906       status = _read_byte(0x00
.55F:
! 3906 74, 0x0040);
! Debug: list int = const $40 (used reg = )
mov	ax,*$40
push	ax
! Debug: list int = const $74 (used reg = )
mov	ax,*$74
push	ax
! Debug: func () unsigned char = _read_byte+0 (used reg = )
call	__read_byte
add	sp,*4
! Debug: eq unsigned char = al+0 to unsigned char status = [S+$26-$26] (used reg = )
mov	-$24[bp],al
!BCC_EOS
! 3907       *(((Bit8u *)&AX)+1) = (status);
! Debug: eq unsigned char status = [S+$26-$26] to unsigned char AX = [S+$26+$17] (used reg = )
mov	al,-$24[bp]
mov	$19[bp],al
!BCC_EOS
! 3908       _write_byte(0, 0x0074, 0x0040);
! Debug: list int = const $40 (used reg = )
mov	ax,*$40
push	ax
! Debug: list int = const $74 (used reg = )
mov	ax,*$74
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: func () void = _write_byte+0 (used reg = )
call	__write_byte
add	sp,*6
!BCC_EOS
! 3909       if (status) goto int13_fail_nostatus;
mov	al,-$24[bp]
test	al,al
je  	.560
.561:
add	sp,#..FFEE-..FFF0
br 	.FFEE
!BCC_EOS
! 3910       else goto int13_success_noah;
jmp .562
.560:
add	sp,#..FFED-..FFF0
br 	.FFED
!BCC_EOS
! 3911       break;
.562:
br 	.55B
!BCC_EOS
! 3912     case 0x02:
! 3913     case 0x03:
.563:
! 3914     case 0x04:
.564:
! 3915       count = ( AX & 0x00ff );
.565:
! Debug: and int = const $FF to unsigned short AX = [S+$26+$16] (used reg = )
mov	al,$18[bp]
! Debug: eq unsigned char = al+0 to unsigned short count = [S+$26-$24] (used reg = )
xor	ah,ah
mov	-$22[bp],ax
!BCC_EOS
! 3916       cylinder = *(((Bit8u *)&CX)+1);
! Debug: eq unsigned char CX = [S+$26+$15] to unsigned short cylinder = [S+$26-$C] (used reg = )
mov	al,$17[bp]
xor	ah,ah
mov	-$A[bp],ax
!BCC_EOS
! 3917       cylinder |= ( ((Bit16u) ( CX & 0x00ff )) << 2) & 0x300;
! Debug: and int = const $FF to unsigned short CX = [S+$26+$14] (used reg = )
mov	al,$16[bp]
! Debug: cast unsigned short = const 0 to unsigned char = al+0 (used reg = )
xor	ah,ah
! Debug: sl int = const 2 to unsigned short = ax+0 (used reg = )
shl	ax,*1
shl	ax,*1
! Debug: and int = const $300 to unsigned int = ax+0 (used reg = )
and	ax,#$300
! Debug: orab unsigned int = ax+0 to unsigned short cylinder = [S+$26-$C] (used reg = )
or	ax,-$A[bp]
mov	-$A[bp],ax
!BCC_EOS
! 3918       sector = (( CX & 0x00ff ) & 0x3f);
! Debug: and int = const $FF to unsigned short CX = [S+$26+$14] (used reg = )
mov	al,$16[bp]
! Debug: and int = const $3F to unsigned char = al+0 (used reg = )
and	al,*$3F
! Debug: eq unsigned char = al+0 to unsigned short sector = [S+$26-$10] (used reg = )
xor	ah,ah
mov	-$E[bp],ax
!BCC_EOS
! 3919       head = *(((Bit8u *)&DX)+1);
! Debug: eq unsigned char DX = [S+$26+$13] to unsigned short head = [S+$26-$E] (used reg = )
mov	al,$15[bp]
xor	ah,ah
mov	-$C[bp],ax
!BCC_EOS
! 3920       segment = ES;
! Debug: eq unsigned short ES = [S+$26+6] to unsigned short segment = [S+$26-$12] (used reg = )
mov	ax,8[bp]
mov	-$10[bp],ax
!BCC_EOS
! 3921       offset = BX;
! Debug: eq unsigned short BX = [S+$26+$10] to unsigned short offset = [S+$26-$14] (used reg = )
mov	ax,$12[bp]
mov	-$12[bp],ax
!BCC_EOS
! 3922       if ((count > 128) || (count == 0) || (sector == 0)) {
! Debug: gt int = const $80 to unsigned short count = [S+$26-$24] (used reg = )
mov	ax,-$22[bp]
cmp	ax,#$80
ja  	.567
.569:
! Debug: logeq int = const 0 to unsigned short count = [S+$26-$24] (used reg = )
mov	ax,-$22[bp]
test	ax,ax
je  	.567
.568:
! Debug: logeq int = const 0 to unsigned short sector = [S+$26-$10] (used reg = )
mov	ax,-$E[bp]
test	ax,ax
jne 	.566
.567:
! 3923         bios_printf(4, "int13_harddisk: function %02x, parameter out of range!\n",*(((Bit8u *)&AX)+1));
! Debug: list unsigned char AX = [S+$26+$17] (used reg = )
mov	al,$19[bp]
xor	ah,ah
push	ax
! Debug: list * char = .56A+0 (used reg = )
mov	bx,#.56A
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*6
!BCC_EOS
! 3924         goto int13_fail;
add	sp,#..FFF1-..FFF0
br 	.FFF1
!BCC_EOS
! 3925       }
! 3926       nlc = *((Bit16u *)(&((ebda_data_t *) 0)->ata.devices[device].lchs.cylinders));
.566:
! Debug: ptradd unsigned char device = [S+$26-$25] to [8] struct  = const $142 (used reg = )
mov	al,-$23[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned short = [bx+$14E] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$14E (used reg = )
! Debug: eq unsigned short = [bx+$14E] to unsigned short nlc = [S+$26-$1C] (used reg = )
mov	bx,$14E[bx]
mov	-$1A[bp],bx
!BCC_EOS
! 3927       nlh = *((Bit16u *)(&((ebda_data_t *) 0)->ata.devices[device].lchs.heads));
! Debug: ptradd unsigned char device = [S+$26-$25] to [8] struct  = const $142 (used reg = )
mov	al,-$23[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned short = [bx+$14C] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$14C (used reg = )
! Debug: eq unsigned short = [bx+$14C] to unsigned short nlh = [S+$26-$1E] (used reg = )
mov	bx,$14C[bx]
mov	-$1C[bp],bx
!BCC_EOS
! 3928       nlspt = *((Bit16u *)(&((ebda_data_t *) 0)->ata.devices[device].lchs.spt));
! Debug: ptradd unsigned char device = [S+$26-$25] to [8] struct  = const $142 (used reg = )
mov	al,-$23[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned short = [bx+$150] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$150 (used reg = )
! Debug: eq unsigned short = [bx+$150] to unsigned short nlspt = [S+$26-$20] (used reg = )
mov	bx,$150[bx]
mov	-$1E[bp],bx
!BCC_EOS
! 3929       if( (cylinder >= nlc) || (head >= nlh) || (sector > nlspt) ) {
! Debug: ge unsigned short nlc = [S+$26-$1C] to unsigned short cylinder = [S+$26-$C] (used reg = )
mov	ax,-$A[bp]
cmp	ax,-$1A[bp]
jae 	.56C
.56E:
! Debug: ge unsigned short nlh = [S+$26-$1E] to unsigned short head = [S+$26-$E] (used reg = )
mov	ax,-$C[bp]
cmp	ax,-$1C[bp]
jae 	.56C
.56D:
! Debug: gt unsigned short nlspt = [S+$26-$20] to unsigned short sector = [S+$26-$10] (used reg = )
mov	ax,-$E[bp]
cmp	ax,-$1E[bp]
jbe 	.56B
.56C:
! 3930         bios_printf(4, "int13_harddisk: function %02x, parameters out of range %04x/%04x/%04x!\n", *(((Bit8u *)&AX)+1), cylinder, head, sector);
! Debug: list unsigned short sector = [S+$26-$10] (used reg = )
push	-$E[bp]
! Debug: list unsigned short head = [S+$28-$E] (used reg = )
push	-$C[bp]
! Debug: list unsigned short cylinder = [S+$2A-$C] (used reg = )
push	-$A[bp]
! Debug: list unsigned char AX = [S+$2C+$17] (used reg = )
mov	al,$19[bp]
xor	ah,ah
push	ax
! Debug: list * char = .56F+0 (used reg = )
mov	bx,#.56F
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*$C
!BCC_EOS
! 3931         goto int13_fail;
add	sp,#..FFF1-..FFF0
br 	.FFF1
!BCC_EOS
! 3932       }
! 3933       if (*(((Bit8u *)&AX)+1) == 0x04) goto int13_success;
.56B:
! Debug: logeq int = const 4 to unsigned char AX = [S+$26+$17] (used reg = )
mov	al,$19[bp]
cmp	al,*4
jne 	.570
.571:
add	sp,#..FFEF-..FFF0
br 	.FFEF
!BCC_EOS
! 3934       nph = *((Bit16u *)(&((ebda_data_t *) 0)->ata.devices[device].pchs.heads));
.570:
! Debug: ptradd unsigned char device = [S+$26-$25] to [8] struct  = const $142 (used reg = )
mov	al,-$23[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned short = [bx+$152] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$152 (used reg = )
! Debug: eq unsigned short = [bx+$152] to unsigned short nph = [S+$26-$18] (used reg = )
mov	bx,$152[bx]
mov	-$16[bp],bx
!BCC_EOS
! 3935       npspt = *((Bit16u *)(&((ebda_data_t *) 0)->ata.devices[device].pchs.spt));
! Debug: ptradd unsigned char device = [S+$26-$25] to [8] struct  = const $142 (used reg = )
mov	al,-$23[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned short = [bx+$156] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$156 (used reg = )
! Debug: eq unsigned short = [bx+$156] to unsigned short npspt = [S+$26-$1A] (used reg = )
mov	bx,$156[bx]
mov	-$18[bp],bx
!BCC_EOS
! 3936       if ( (nph != nlh) || (npspt != nlspt)) {
! Debug: ne unsigned short nlh = [S+$26-$1E] to unsigned short nph = [S+$26-$18] (used reg = )
mov	ax,-$16[bp]
cmp	ax,-$1C[bp]
jne 	.573
.574:
! Debug: ne unsigned short nlspt = [S+$26-$20] to unsigned short npspt = [S+$26-$1A] (used reg = )
mov	ax,-$18[bp]
cmp	ax,-$1E[bp]
je  	.572
.573:
! 3937         lba_low = ((((Bit32u)cylinder * (Bit32u)nlh) + (Bit32u)head) * (Bit32u)nlspt) + (Bit32u)sector - 1;
! Debug: cast unsigned long = const 0 to unsigned short sector = [S+$26-$10] (used reg = )
mov	ax,-$E[bp]
xor	bx,bx
push	bx
push	ax
! Debug: cast unsigned long = const 0 to unsigned short nlspt = [S+$2A-$20] (used reg = )
mov	ax,-$1E[bp]
xor	bx,bx
push	bx
push	ax
! Debug: cast unsigned long = const 0 to unsigned short head = [S+$2E-$E] (used reg = )
mov	ax,-$C[bp]
xor	bx,bx
push	bx
push	ax
! Debug: cast unsigned long = const 0 to unsigned short nlh = [S+$32-$1E] (used reg = )
mov	ax,-$1C[bp]
xor	bx,bx
push	bx
push	ax
! Debug: cast unsigned long = const 0 to unsigned short cylinder = [S+$36-$C] (used reg = )
mov	ax,-$A[bp]
xor	bx,bx
! Debug: mul unsigned long (temp) = [S+$36-$36] to unsigned long = bx+0 (used reg = )
lea	di,-$E+..FFF0[bp]
call	lmulul
add	sp,*4
! Debug: add unsigned long (temp) = [S+$32-$32] to unsigned long = bx+0 (used reg = )
lea	di,-$A+..FFF0[bp]
call	laddul
add	sp,*4
! Debug: mul unsigned long (temp) = [S+$2E-$2E] to unsigned long = bx+0 (used reg = )
lea	di,-6+..FFF0[bp]
call	lmulul
add	sp,*4
! Debug: add unsigned long (temp) = [S+$2A-$2A] to unsigned long = bx+0 (used reg = )
lea	di,-2+..FFF0[bp]
call	laddul
add	sp,*4
! Debug: sub unsigned long = const 1 to unsigned long = bx+0 (used reg = )
push	bx
push	ax
mov	ax,*1
xor	bx,bx
push	bx
push	ax
mov	ax,-2+..FFF0[bp]
mov	bx,0+..FFF0[bp]
lea	di,-6+..FFF0[bp]
call	lsubul
add	sp,*8
! Debug: eq unsigned long = bx+0 to unsigned long lba_low = [S+$26-6] (used reg = )
mov	-4[bp],ax
mov	-2[bp],bx
!BCC_EOS
! 3938         lba_high = 0;
! Debug: eq int = const 0 to unsigned long lba_high = [S+$26-$A] (used reg = )
xor	ax,ax
xor	bx,bx
mov	-8[bp],ax
mov	-6[bp],bx
!BCC_EOS
! 3939         sector = 0;
! Debug: eq int = const 0 to unsigned short sector = [S+$26-$10] (used reg = )
xor	ax,ax
mov	-$E[bp],ax
!BCC_EOS
! 3940       }
! 3941       if (*(((Bit8u *)&AX)+1) == 0x02)
.572:
! Debug: logeq int = const 2 to unsigned char AX = [S+$26+$17] (used reg = )
mov	al,$19[bp]
cmp	al,*2
jne 	.575
.576:
! 3942         status=ata_cmd_data_io(0, device, 0x20, count, cylinder, head, sector, lba_low, lba_high, segment, offset);
! Debug: list unsigned short offset = [S+$26-$14] (used reg = )
push	-$12[bp]
! Debug: list unsigned short segment = [S+$28-$12] (used reg = )
push	-$10[bp]
! Debug: list unsigned long lba_high = [S+$2A-$A] (used reg = )
push	-6[bp]
push	-8[bp]
! Debug: list unsigned long lba_low = [S+$2E-6] (used reg = )
push	-2[bp]
push	-4[bp]
! Debug: list unsigned short sector = [S+$32-$10] (used reg = )
push	-$E[bp]
! Debug: list unsigned short head = [S+$34-$E] (used reg = )
push	-$C[bp]
! Debug: list unsigned short cylinder = [S+$36-$C] (used reg = )
push	-$A[bp]
! Debug: list unsigned short count = [S+$38-$24] (used reg = )
push	-$22[bp]
! Debug: list int = const $20 (used reg = )
mov	ax,*$20
push	ax
! Debug: list unsigned char device = [S+$3C-$25] (used reg = )
mov	al,-$23[bp]
xor	ah,ah
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: func () unsigned short = ata_cmd_data_io+0 (used reg = )
call	_ata_cmd_data_io
add	sp,*$1A
! Debug: eq unsigned short = ax+0 to unsigned char status = [S+$26-$26] (used reg = )
mov	-$24[bp],al
!BCC_EOS
! 3943       else
! 3944         status=ata_cmd_data_io(1, device, 0x30, count, cylinder, head, sector, lba_low, lba_high, segment, offset);
jmp .577
.575:
! Debug: list unsigned short offset = [S+$26-$14] (used reg = )
push	-$12[bp]
! Debug: list unsigned short segment = [S+$28-$12] (used reg = )
push	-$10[bp]
! Debug: list unsigned long lba_high = [S+$2A-$A] (used reg = )
push	-6[bp]
push	-8[bp]
! Debug: list unsigned long lba_low = [S+$2E-6] (used reg = )
push	-2[bp]
push	-4[bp]
! Debug: list unsigned short sector = [S+$32-$10] (used reg = )
push	-$E[bp]
! Debug: list unsigned short head = [S+$34-$E] (used reg = )
push	-$C[bp]
! Debug: list unsigned short cylinder = [S+$36-$C] (used reg = )
push	-$A[bp]
! Debug: list unsigned short count = [S+$38-$24] (used reg = )
push	-$22[bp]
! Debug: list int = const $30 (used reg = )
mov	ax,*$30
push	ax
! Debug: list unsigned char device = [S+$3C-$25] (used reg = )
mov	al,-$23[bp]
xor	ah,ah
push	ax
! Debug: list int = const 1 (used reg = )
mov	ax,*1
push	ax
! Debug: func () unsigned short = ata_cmd_data_io+0 (used reg = )
call	_ata_cmd_data_io
add	sp,*$1A
! Debug: eq unsigned short = ax+0 to unsigned char status = [S+$26-$26] (used reg = )
mov	-$24[bp],al
!BCC_EOS
! 3945       *((Bit8u *)&AX) = (*((Bit16u *)(&((ebda_data_t *) 0)->ata.trsfsectors)));
.577:
! Debug: eq unsigned short = [+$254] to unsigned char AX = [S+$26+$16] (used reg = )
mov	al,[$254]
mov	$18[bp],al
!BCC_EOS
! 3946       if (status != 0) {
! Debug: ne int = const 0 to unsigned char status = [S+$26-$26] (used reg = )
mov	al,-$24[bp]
test	al,al
je  	.578
.579:
! 3947         bios_printf(4, "int13_harddisk: function %02x, error %02x !\n",*
! 3947 (((Bit8u *)&AX)+1),status);
! Debug: list unsigned char status = [S+$26-$26] (used reg = )
mov	al,-$24[bp]
xor	ah,ah
push	ax
! Debug: list unsigned char AX = [S+$28+$17] (used reg = )
mov	al,$19[bp]
xor	ah,ah
push	ax
! Debug: list * char = .57A+0 (used reg = )
mov	bx,#.57A
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*8
!BCC_EOS
! 3948         *(((Bit8u *)&AX)+1) = (0x0c);
! Debug: eq int = const $C to unsigned char AX = [S+$26+$17] (used reg = )
mov	al,*$C
mov	$19[bp],al
!BCC_EOS
! 3949         goto int13_fail_noah;
add	sp,#..FFEC-..FFF0
br 	.FFEC
!BCC_EOS
! 3950       }
! 3951       goto int13_success;
.578:
add	sp,#..FFEF-..FFF0
br 	.FFEF
!BCC_EOS
! 3952       break;
br 	.55B
!BCC_EOS
! 3953     case 0x05:
! 3954       bios_printf(4, "format disk track called\n");
.57B:
! Debug: list * char = .57C+0 (used reg = )
mov	bx,#.57C
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*4
!BCC_EOS
! 3955       goto int13_success;
add	sp,#..FFEF-..FFF0
br 	.FFEF
!BCC_EOS
! 3956       return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 3957       break;
br 	.55B
!BCC_EOS
! 3958     case 0x08:
! 3959       nlc = *((Bit16u *)(&((ebda_data_t *) 0)->ata.devices[device].lchs.cylinders));
.57D:
! Debug: ptradd unsigned char device = [S+$26-$25] to [8] struct  = const $142 (used reg = )
mov	al,-$23[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned short = [bx+$14E] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$14E (used reg = )
! Debug: eq unsigned short = [bx+$14E] to unsigned short nlc = [S+$26-$1C] (used reg = )
mov	bx,$14E[bx]
mov	-$1A[bp],bx
!BCC_EOS
! 3960       nlh = *((Bit16u *)(&((ebda_data_t *) 0)->ata.devices[device].lchs.heads));
! Debug: ptradd unsigned char device = [S+$26-$25] to [8] struct  = const $142 (used reg = )
mov	al,-$23[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned short = [bx+$14C] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$14C (used reg = )
! Debug: eq unsigned short = [bx+$14C] to unsigned short nlh = [S+$26-$1E] (used reg = )
mov	bx,$14C[bx]
mov	-$1C[bp],bx
!BCC_EOS
! 3961       nlspt = *((Bit16u *)(&((ebda_data_t *) 0)->ata.devices[device].lchs.spt));
! Debug: ptradd unsigned char device = [S+$26-$25] to [8] struct  = const $142 (used reg = )
mov	al,-$23[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned short = [bx+$150] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$150 (used reg = )
! Debug: eq unsigned short = [bx+$150] to unsigned short nlspt = [S+$26-$20] (used reg = )
mov	bx,$150[bx]
mov	-$1E[bp],bx
!BCC_EOS
! 3962       count = *((Bit8u *)(&((ebda_data_t *) 0)->ata.hdcount));
! Debug: eq unsigned char = [+$232] to unsigned short count = [S+$26-$24] (used reg = )
mov	al,[$232]
xor	ah,ah
mov	-$22[bp],ax
!BCC_EOS
! 3963       nlc = nlc - 1;
! Debug: sub int = const 1 to unsigned short nlc = [S+$26-$1C] (used reg = )
mov	ax,-$1A[bp]
! Debug: eq unsigned int = ax-1 to unsigned short nlc = [S+$26-$1C] (used reg = )
dec	ax
mov	-$1A[bp],ax
!BCC_EOS
! 3964       *((Bit8u *)&AX) = (0);
! Debug: eq int = const 0 to unsigned char AX = [S+$26+$16] (used reg = )
xor	al,al
mov	$18[bp],al
!BCC_EOS
! 3965       *(((Bit8u *)&CX)+1) = (nlc & 0xff);
! Debug: and int = const $FF to unsigned short nlc = [S+$26-$1C] (used reg = )
mov	al,-$1A[bp]
! Debug: eq unsigned char = al+0 to unsigned char CX = [S+$26+$15] (used reg = )
mov	$17[bp],al
!BCC_EOS
! 3966       *((Bit8u *)&CX) = (((nlc >> 2) & 0xc0) | (nlspt & 0x3f));
! Debug: and int = const $3F to unsigned short nlspt = [S+$26-$20] (used reg = )
mov	al,-$1E[bp]
and	al,*$3F
push	ax
! Debug: sr int = const 2 to unsigned short nlc = [S+$28-$1C] (used reg = )
mov	ax,-$1A[bp]
shr	ax,*1
shr	ax,*1
! Debug: and int = const $C0 to unsigned int = ax+0 (used reg = )
and	al,#$C0
! Debug: or unsigned char (temp) = [S+$28-$28] to unsigned char = al+0 (used reg = )
or	al,0+..FFF0[bp]
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char CX = [S+$26+$14] (used reg = )
mov	$16[bp],al
!BCC_EOS
! 3967       *(((Bit8u *)&DX)+1) = (nlh - 1);
! Debug: sub int = const 1 to unsigned short nlh = [S+$26-$1E] (used reg = )
mov	ax,-$1C[bp]
! Debug: eq unsigned int = ax-1 to unsigned char DX = [S+$26+$13] (used reg = )
dec	ax
mov	$15[bp],al
!BCC_EOS
! 3968       *((Bit8u *)&DX) = (count);
! Debug: eq unsigned short count = [S+$26-$24] to unsigned char DX = [S+$26+$12] (used reg = )
mov	al,-$22[bp]
mov	$14[bp],al
!BCC_EOS
! 3969       goto int13_success;
add	sp,#..FFEF-..FFF0
br 	.FFEF
!BCC_EOS
! 3970       break;
br 	.55B
!BCC_EOS
! 3971     case 0x10:
! 3972       status = inb(*((Bit16u *)(&((ebda_data_t *) 0)->ata.channels[device/2].iobase1)) + 7);
.57E:
! Debug: div int = const 2 to unsigned char device = [S+$26-$25] (used reg = )
mov	al,-$23[bp]
xor	ah,ah
shr	ax,*1
! Debug: ptradd unsigned int = ax+0 to [4] struct  = const $122 (used reg = )
mov	cl,*3
shl	ax,cl
mov	bx,ax
! Debug: address unsigned short = [bx+$124] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$124 (used reg = )
! Debug: add int = const 7 to unsigned short = [bx+$124] (used reg = )
mov	bx,$124[bx]
! Debug: list unsigned int = bx+7 (used reg = )
add	bx,*7
push	bx
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char status = [S+$26-$26] (used reg = )
mov	-$24[bp],al
!BCC_EOS
! 3973       if ( (status & (0x80 | 0x40)) == 0x40 ) {
! Debug: and int = const $C0 to unsigned char status = [S+$26-$26] (used reg = )
mov	al,-$24[bp]
and	al,#$C0
! Debug: logeq int = const $40 to unsigned char = al+0 (used reg = )
cmp	al,*$40
jne 	.57F
.580:
! 3974         goto int13_success;
add	sp,#..FFEF-..FFF0
br 	.FFEF
!BCC_EOS
! 3975       }
! 3976       else {
jmp .581
.57F:
! 3977         *(((Bit8u *)&AX)+1) = (0xAA);
! Debug: eq int = const $AA to unsigned char AX = [S+$26+$17] (used reg = )
mov	al,#$AA
mov	$19[bp],al
!BCC_EOS
! 3978         goto int13_fail_noah;
add	sp,#..FFEC-..FFF0
br 	.FFEC
!BCC_EOS
! 3979       }
! 3980       break;
.581:
br 	.55B
!BCC_EOS
! 3981     case 0x15:
! 3982       nlc = *((Bit16u *)(&((ebda_data_t *) 0)->ata.devices[device].lchs.cylinders));
.582:
! Debug: ptradd unsigned char device = [S+$26-$25] to [8] struct  = const $142 (used reg = )
mov	al,-$23[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned short = [bx+$14E] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$14E (used reg = )
! Debug: eq unsigned short = [bx+$14E] to unsigned short nlc = [S+$26-$1C] (used reg = )
mov	bx,$14E[bx]
mov	-$1A[bp],bx
!BCC_EOS
! 3983       nlh = *((Bit16u *)(&((ebda_data_t *) 0)->ata.devices[device].lchs.heads));
! Debug: ptradd unsigned char device = [S+$26-$25] to [8] struct  = const $142 (used reg = )
mov	al,-$23[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned short = [bx+$14C] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$14C (used reg = )
! Debug: eq unsigned short = [bx+$14C] to unsigned short nlh = [S+$26-$1E] (used reg = )
mov	bx,$14C[bx]
mov	-$1C[bp],bx
!BCC_EOS
! 3984       nlspt = *((Bit16u *)(&((ebda_data_t *) 0)->ata.devices[device].lchs.spt));
! Debug: ptradd unsigned char device = [S+$26-$25] to [8] struct  = const $142 (used reg = )
mov	al,-$23[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned short = [bx+$150] (used reg = )
! Debug: cast * unsigned short = const 0 to * unsigned short = bx+$150 (used reg = )
! Debug: eq unsigned short = [bx+$150] to unsigned short nlspt = [S+$26-$20] (used reg = )
mov	bx,$150[bx]
mov	-$1E[bp],bx
!BCC_EOS
! 3985       lba_low = (Bit32u)(nlc - 1) * (Bit32u)nlh * (Bit32u)nlspt;
! Debug: cast unsigned long = const 0 to unsigned short nlspt = [S+$26-$20] (used reg = )
mov	ax,-$1E[bp]
xor	bx,bx
push	bx
push	ax
! Debug: cast unsigned long = const 0 to unsigned short nlh = [S+$2A-$1E] (used reg = )
mov	ax,-$1C[bp]
xor	bx,bx
push	bx
push	ax
! Debug: sub int = const 1 to unsigned short nlc = [S+$2E-$1C] (used reg = )
mov	ax,-$1A[bp]
! Debug: cast unsigned long = const 0 to unsigned int = ax-1 (used reg = )
dec	ax
xor	bx,bx
! Debug: mul unsigned long (temp) = [S+$2E-$2E] to unsigned long = bx+0 (used reg = )
lea	di,-6+..FFF0[bp]
call	lmulul
add	sp,*4
! Debug: mul unsigned long (temp) = [S+$2A-$2A] to unsigned long = bx+0 (used reg = )
lea	di,-2+..FFF0[bp]
call	lmulul
add	sp,*4
! Debug: eq unsigned long = bx+0 to unsigned long lba_low = [S+$26-6] (used reg = )
mov	-4[bp],ax
mov	-2[bp],bx
!BCC_EOS
! 3986       CX = *(((Bit16u *)&lba_low)+1);
! Debug: eq unsigned short lba_low = [S+$26-4] to unsigned short CX = [S+$26+$14] (used reg = )
mov	ax,-2[bp]
mov	$16[bp],ax
!BCC_EOS
! 3987       DX = *((Bit16u *)&lba_low);
! Debug: eq unsigned short lba_low = [S+$26-6] to unsigned short DX = [S+$26+$12] (used reg = )
mov	ax,-4[bp]
mov	$14[bp],ax
!BCC_EOS
! 3988       *(((Bit8u *)&AX)+1) = (3);
! Debug: eq int = const 3 to unsigned char AX = [S+$26+$17] (used reg = )
mov	al,*3
mov	$19[bp],al
!BCC_EOS
! 3989       goto int13_success_noah;
add	sp,#..FFED-..FFF0
br 	.FFED
!BCC_EOS
! 3990       break;
br 	.55B
!BCC_EOS
! 3991     case 0x41:
! 3992       BX=0xaa55;
.583:
! Debug: eq unsigned int = const $AA55 to unsigned short BX = [S+$26+$10] (used reg = )
mov	ax,#$AA55
mov	$12[bp],ax
!BCC_EOS
! 3993       *(((Bit8u *)&AX)+1) = (0x30);
! Debug: eq int = const $30 to unsigned char AX = [S+$26+$17] (used reg = )
mov	al,*$30
mov	$19[bp],al
!BCC_EOS
! 3994       CX=0x0007;
! Debug: eq int = const 7 to unsigned short CX = [S+$26+$14] (used reg = )
mov	ax,*7
mov	$16[bp],ax
!BCC_EOS
! 3995       goto int13_success_noah;
add	sp,#..FFED-..FFF0
br 	.FFED
!BCC_EOS
! 3996       break;
br 	.55B
!BCC_EOS
! 3997     case 0x42:
! 3998     case 0x43:
.584:
! 3999     case 0x44:
.585:
! 4000     case 0x47:
.586:
! 4001       count=_read_word(SI+(Bit16u)&((int13ext_t *) 0)->count, DS);
.587:
! Debug: list unsigned short DS = [S+$26+4] (used reg = )
push	6[bp]
! Debug: add unsigned short = const 2 to unsigned short SI = [S+$28+$A] (used reg = )
mov	ax,$C[bp]
! Debug: list unsigned int = ax+2 (used reg = )
inc	ax
inc	ax
push	ax
! Debug: func () unsigned short = _read_word+0 (used reg = )
call	__read_word
add	sp,*4
! Debug: eq unsigned short = ax+0 to unsigned short count = [S+$26-$24] (used reg = )
mov	-$22[bp],ax
!BCC_EOS
! 4002       segment=_read_word(SI+(Bit16u)&((int13ext_t *) 0)->segment, DS);
! Debug: list unsigned short DS = [S+$26+4] (used reg = )
push	6[bp]
! Debug: add unsigned short = const 6 to unsigned short SI = [S+$28+$A] (used reg = )
mov	ax,$C[bp]
! Debug: list unsigned int = ax+6 (used reg = )
add	ax,*6
push	ax
! Debug: func () unsigned short = _read_word+0 (used reg = )
call	__read_word
add	sp,*4
! Debug: eq unsigned short = ax+0 to unsigned short segment = [S+$26-$12] (used reg = )
mov	-$10[bp],ax
!BCC_EOS
! 4003       offset=_read_word(SI+(Bit16u)&((int13ext_t *) 0)->offset, DS);
! Debug: list unsigned short DS = [S+$26+4] (used reg = )
push	6[bp]
! Debug: add unsigned short = const 4 to unsigned short SI = [S+$28+$A] (used reg = )
mov	ax,$C[bp]
! Debug: list unsigned int = ax+4 (used reg = )
add	ax,*4
push	ax
! Debug: func () unsigned short = _read_word+0 (used reg = )
call	__read_word
add	sp,*4
! Debug: eq unsigned short = ax+0 to unsigned short offset = [S+$26-$14] (used reg = )
mov	-$12[bp],ax
!BCC_EOS
! 4004       lba_high=_read_dword(
! 4004 SI+(Bit16u)&((int13ext_t *) 0)->lba2, DS);
! Debug: list unsigned short DS = [S+$26+4] (used reg = )
push	6[bp]
! Debug: add unsigned short = const $C to unsigned short SI = [S+$28+$A] (used reg = )
mov	ax,$C[bp]
! Debug: list unsigned int = ax+$C (used reg = )
add	ax,*$C
push	ax
! Debug: func () unsigned long = _read_dword+0 (used reg = )
call	__read_dword
mov	bx,dx
add	sp,*4
! Debug: eq unsigned long = bx+0 to unsigned long lba_high = [S+$26-$A] (used reg = )
mov	-8[bp],ax
mov	-6[bp],bx
!BCC_EOS
! 4005       if (lba_high > *((Bit32u *)(&((ebda_data_t *) 0)->ata.devices[device].sectors_high)) ) {
! Debug: ptradd unsigned char device = [S+$26-$25] to [8] struct  = const $142 (used reg = )
mov	al,-$23[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned long = [bx+$15C] (used reg = )
! Debug: cast * unsigned long = const 0 to * unsigned long = bx+$15C (used reg = )
! Debug: gt unsigned long = [bx+$15C] to unsigned long lba_high = [S+$26-$A] (used reg = )
mov	ax,$15C[bx]
mov	bx,$15E[bx]
lea	di,-8[bp]
call	lcmpul
jae 	.588
.589:
! 4006         bios_printf(4, "int13_harddisk: function %02x. LBA out of range\n",*(((Bit8u *)&AX)+1));
! Debug: list unsigned char AX = [S+$26+$17] (used reg = )
mov	al,$19[bp]
xor	ah,ah
push	ax
! Debug: list * char = .58A+0 (used reg = )
mov	bx,#.58A
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*6
!BCC_EOS
! 4007         goto int13_fail;
add	sp,#..FFF1-..FFF0
br 	.FFF1
!BCC_EOS
! 4008       }
! 4009       lba_low=_read_dword(SI+(Bit16u)&((int13ext_t *) 0)->lba1, DS);
.588:
! Debug: list unsigned short DS = [S+$26+4] (used reg = )
push	6[bp]
! Debug: add unsigned short = const 8 to unsigned short SI = [S+$28+$A] (used reg = )
mov	ax,$C[bp]
! Debug: list unsigned int = ax+8 (used reg = )
add	ax,*8
push	ax
! Debug: func () unsigned long = _read_dword+0 (used reg = )
call	__read_dword
mov	bx,dx
add	sp,*4
! Debug: eq unsigned long = bx+0 to unsigned long lba_low = [S+$26-6] (used reg = )
mov	-4[bp],ax
mov	-2[bp],bx
!BCC_EOS
! 4010       if (lba_high == *((Bit32u *)(&((ebda_data_t *) 0)->ata.devices[device].sectors_high))
! 4011           && lba_low >= *((Bit32u *)(&((ebda_data_t *) 0)->ata.devices[device].sectors_low)) ) {
! Debug: ptradd unsigned char device = [S+$26-$25] to [8] struct  = const $142 (used reg = )
mov	al,-$23[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned long = [bx+$15C] (used reg = )
! Debug: cast * unsigned long = const 0 to * unsigned long = bx+$15C (used reg = )
! Debug: logeq unsigned long = [bx+$15C] to unsigned long lba_high = [S+$26-$A] (used reg = )
mov	ax,$15C[bx]
mov	bx,$15E[bx]
lea	di,-8[bp]
call	lcmpul
jne 	.58B
.58D:
! Debug: ptradd unsigned char device = [S+$26-$25] to [8] struct  = const $142 (used reg = )
mov	al,-$23[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned long = [bx+$158] (used reg = )
! Debug: cast * unsigned long = const 0 to * unsigned long = bx+$158 (used reg = )
! Debug: ge unsigned long = [bx+$158] to unsigned long lba_low = [S+$26-6] (used reg = )
mov	ax,$158[bx]
mov	bx,$15A[bx]
lea	di,-4[bp]
call	lcmpul
ja  	.58B
.58C:
! 4012         bios_printf(4, "int13_harddisk: function %02x. LBA out of range\n",*(((Bit8u *)&AX)+1));
! Debug: list unsigned char AX = [S+$26+$17] (used reg = )
mov	al,$19[bp]
xor	ah,ah
push	ax
! Debug: list * char = .58E+0 (used reg = )
mov	bx,#.58E
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*6
!BCC_EOS
! 4013         goto int13_fail;
add	sp,#..FFF1-..FFF0
br 	.FFF1
!BCC_EOS
! 4014       }
! 4015       if (( *(((Bit8u *)&AX)+1) == 0x44 ) || ( *(((Bit8u *)&AX)+1) == 0x47 ))
.58B:
! Debug: logeq int = const $44 to unsigned char AX = [S+$26+$17] (used reg = )
mov	al,$19[bp]
cmp	al,*$44
je  	.590
.591:
! Debug: logeq int = const $47 to unsigned char AX = [S+$26+$17] (used reg = )
mov	al,$19[bp]
cmp	al,*$47
jne 	.58F
.590:
! 4016         goto int13_success;
add	sp,#..FFEF-..FFF0
br 	.FFEF
!BCC_EOS
! 4017       if (*(((Bit8u *)&AX)+1) == 0x42)
.58F:
! Debug: logeq int = const $42 to unsigned char AX = [S+$26+$17] (used reg = )
mov	al,$19[bp]
cmp	al,*$42
jne 	.592
.593:
! 4018         status=ata_cmd_data_io(0, device, 0x20, count, 0, 0, 0, lba_low, lba_high, segment, offset);
! Debug: list unsigned short offset = [S+$26-$14] (used reg = )
push	-$12[bp]
! Debug: list unsigned short segment = [S+$28-$12] (used reg = )
push	-$10[bp]
! Debug: list unsigned long lba_high = [S+$2A-$A] (used reg = )
push	-6[bp]
push	-8[bp]
! Debug: list unsigned long lba_low = [S+$2E-6] (used reg = )
push	-2[bp]
push	-4[bp]
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list unsigned short count = [S+$38-$24] (used reg = )
push	-$22[bp]
! Debug: list int = const $20 (used reg = )
mov	ax,*$20
push	ax
! Debug: list unsigned char device = [S+$3C-$25] (used reg = )
mov	al,-$23[bp]
xor	ah,ah
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: func () unsigned short = ata_cmd_data_io+0 (used reg = )
call	_ata_cmd_data_io
add	sp,*$1A
! Debug: eq unsigned short = ax+0 to unsigned char status = [S+$26-$26] (used reg = )
mov	-$24[bp],al
!BCC_EOS
! 4019       else
! 4020         status=ata_cmd_data_io(1, device, 0x30, count, 0, 0, 0, lba_low, lba_high, segment, offset);
jmp .594
.592:
! Debug: list unsigned short offset = [S+$26-$14] (used reg = )
push	-$12[bp]
! Debug: list unsigned short segment = [S+$28-$12] (used reg = )
push	-$10[bp]
! Debug: list unsigned long lba_high = [S+$2A-$A] (used reg = )
push	-6[bp]
push	-8[bp]
! Debug: list unsigned long lba_low = [S+$2E-6] (used reg = )
push	-2[bp]
push	-4[bp]
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list unsigned short count = [S+$38-$24] (used reg = )
push	-$22[bp]
! Debug: list int = const $30 (used reg = )
mov	ax,*$30
push	ax
! Debug: list unsigned char device = [S+$3C-$25] (used reg = )
mov	al,-$23[bp]
xor	ah,ah
push	ax
! Debug: list int = const 1 (used reg = )
mov	ax,*1
push	ax
! Debug: func () unsigned short = ata_cmd_data_io+0 (used reg = )
call	_ata_cmd_data_io
add	sp,*$1A
! Debug: eq unsigned short = ax+0 to unsigned char status = [S+$26-$26] (used reg = )
mov	-$24[bp],al
!BCC_EOS
! 4021       count=*((Bit16u *)(&((ebda_data_t *) 0)->ata.trsfsectors));
.594:
! Debug: eq unsigned short = [+$254] to unsigned short count = [S+$26-$24] (used reg = )
mov	ax,[$254]
mov	-$22[bp],ax
!BCC_EOS
! 4022       _write_word(count, SI+(Bit16u)&((int13ext_t *) 0)->count, DS);
! Debug: list unsigned short DS = [S+$26+4] (used reg = )
push	6[bp]
! Debug: add unsigned short = const 2 to unsigned short SI = [S+$28+$A] (used reg = )
mov	ax,$C[bp]
! Debug: list unsigned int = ax+2 (used reg = )
inc	ax
inc	ax
push	ax
! Debug: list unsigned short count = [S+$2A-$24] (used reg = )
push	-$22[bp]
! Debug: func () void = _write_word+0 (used reg = )
call	__write_word
add	sp,*6
!BCC_EOS
! 4023       if (status != 0) {
! Debug: ne int = const 0 to unsigned char status = [S+$26-$26] (used reg = )
mov	al,-$24[bp]
test	al,al
je  	.595
.596:
! 4024         bios_printf(4, "int13_harddisk: function %02x, error %02x !\n",*(((Bit8u *)&AX)+1),status);
! Debug: list unsigned char status = [S+$26-$26] (used reg = )
mov	al,-$24[bp]
xor	ah,ah
push	ax
! Debug: list unsigned char AX = [S+$28+$17] (used reg = )
mov	al,$19[bp]
xor	ah,ah
push	ax
! Debug: list * char = .597+0 (used reg = )
mov	bx,#.597
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*8
!BCC_EOS
! 4025         *(((Bit8u *)&AX)+1) = (0x0c);
! Debug: eq int = const $C to unsigned char AX = [S+$26+$17] (used reg = )
mov	al,*$C
mov	$19[bp],al
!BCC_EOS
! 4026         goto int13_fail_noah;
add	sp,#..FFEC-..FFF0
br 	.FFEC
!BCC_EOS
! 4027       }
! 4028       goto int13_success;
.595:
add	sp,#..FFEF-..FFF0
br 	.FFEF
!BCC_EOS
! 4029       break;
br 	.55B
!BCC_EOS
! 4030     case 0x45:
! 4031     case 0x49:
.598:
! 4032       goto int13_success;
.599:
add	sp,#..FFEF-..FFF0
br 	.FFEF
!BCC_EOS
! 4033       break;
br 	.55B
!BCC_EOS
! 4034     case 0x46:
! 4035       *(((Bit8u *)&AX)+1) = (0xb2);
.59A:
! Debug: eq int = const $B2 to unsigned char AX = [S+$26+$17] (used reg = )
mov	al,#$B2
mov	$19[bp],al
!BCC_EOS
! 4036       goto int13_fail_noah;
add	sp,#..FFEC-..FFF0
br 	.FFEC
!BCC_EOS
! 4037       break;
br 	.55B
!BCC_EOS
! 4038     case 0x48:
! 4039       if (int13_edd(DS, SI, device))
.59B:
! Debug: list unsigned char device = [S+$26-$25] (used reg = )
mov	al,-$23[bp]
xor	ah,ah
push	ax
! Debug: list unsigned short SI = [S+$28+$A] (used reg = )
push	$C[bp]
! Debug: list unsigned short DS = [S+$2A+4] (used reg = )
push	6[bp]
! Debug: func () int = int13_edd+0 (used reg = )
call	_int13_edd
add	sp,*6
test	ax,ax
je  	.59C
.59D:
! 4040         goto int13_fail;
add	sp,#..FFF1-..FFF0
br 	.FFF1
!BCC_EOS
! 4041       goto int13_success;
.59C:
add	sp,#..FFEF-..FFF0
br 	.FFEF
!BCC_EOS
! 4042       break;
br 	.55B
!BCC_EOS
! 4043     case 0x4e:
! 4044       switch (( AX & 0x00ff )) {
.59E:
! Debug: and int = const $FF to unsigned short AX = [S+$26+$16] (used reg = )
mov	al,$18[bp]
jmp .5A1
! 4045         case 0x01:
! 4046         case 0x03:
.5A2:
! 4047         case 0x04:
.5A3:
! 4048         case 0x06:
.5A4:
! 4049           goto int13_success;
.5A5:
add	sp,#..FFEF-..FFF0
br 	.FFEF
!BCC_EOS
! 4050           break;
jmp .59F
!BCC_EOS
! 4051         default:
! 4052           goto int13_fail;
.5A6:
add	sp,#..FFF1-..FFF0
br 	.FFF1
!BCC_EOS
! 4053       }
! 4054       break;
jmp .59F
.5A1:
sub	al,*1
je 	.5A2
sub	al,*2
je 	.5A3
sub	al,*1
je 	.5A4
sub	al,*2
je 	.5A5
jmp	.5A6
.59F:
br 	.55B
!BCC_EOS
! 4055     case 0x09:
! 4056     case 0x0c:
.5A7:
! 4057     case 0x0d:
.5A8:
! 4058     case 0x11:
.5A9:
! 4059     case 0x14:
.5AA:
! 4060       bios_printf(4, "int13_harddisk: function %02xh unimplemented, ret
.5AB:
! 4060 urns success\n", *(((Bit8u *)&AX)+1));
! Debug: list unsigned char AX = [S+$26+$17] (used reg = )
mov	al,$19[bp]
xor	ah,ah
push	ax
! Debug: list * char = .5AC+0 (used reg = )
mov	bx,#.5AC
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*6
!BCC_EOS
! 4061       goto int13_success;
add	sp,#..FFEF-..FFF0
br 	.FFEF
!BCC_EOS
! 4062       break;
br 	.55B
!BCC_EOS
! 4063     case 0x0a:
! 4064     case 0x0b:
.5AD:
! 4065     case 0x18:
.5AE:
! 4066     case 0x50:
.5AF:
! 4067     default:
.5B0:
! 4068       bios_printf(4, "int13_harddisk: function %02xh unsupported, returns fail\n", *(((Bit8u *)&AX)+1));
.5B1:
! Debug: list unsigned char AX = [S+$26+$17] (used reg = )
mov	al,$19[bp]
xor	ah,ah
push	ax
! Debug: list * char = .5B2+0 (used reg = )
mov	bx,#.5B2
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*6
!BCC_EOS
! 4069       goto int13_fail;
add	sp,#..FFF1-..FFF0
jmp .FFF1
!BCC_EOS
! 4070       break;
jmp .55B
!BCC_EOS
! 4071   }
! 4072 int13_fail:
jmp .55B
.55D:
sub	al,*0
jb 	.5B1
cmp	al,*$18
ja  	.5B3
xor	ah,ah
shl	ax,*1
mov	bx,ax
seg	cs
br	.5B4[bx]
.5B4:
.word	.55E
.word	.55F
.word	.563
.word	.564
.word	.565
.word	.57B
.word	.5B1
.word	.5B1
.word	.57D
.word	.5A7
.word	.5AD
.word	.5AE
.word	.5A8
.word	.5A9
.word	.5B1
.word	.5B1
.word	.57E
.word	.5AA
.word	.5B1
.word	.5B1
.word	.5AB
.word	.582
.word	.5B1
.word	.5B1
.word	.5AF
.5B3:
sub	al,*$41
jb 	.5B1
cmp	al,*$F
ja  	.5B5
xor	ah,ah
shl	ax,*1
mov	bx,ax
seg	cs
br	.5B6[bx]
.5B6:
.word	.583
.word	.584
.word	.585
.word	.586
.word	.598
.word	.59A
.word	.587
.word	.59B
.word	.599
.word	.5B1
.word	.5B1
.word	.5B1
.word	.5B1
.word	.59E
.word	.5B1
.word	.5B0
.5B5:
br 	.5B1
.55B:
..FFF0	=	-$26
.FFF1:
..FFF1	=	-$26
! 4073   *(((Bit8u *)&AX)+1) = (0x01);
! Debug: eq int = const 1 to unsigned char AX = [S+$26+$17] (used reg = )
mov	al,*1
mov	$19[bp],al
!BCC_EOS
! 4074 int13_fail_noah:
.FFEC:
..FFEC	=	-$26
! 4075   _write_byte(*(((Bit8u *)&AX)+1), 0x0074, 0x0040);
! Debug: list int = const $40 (used reg = )
mov	ax,*$40
push	ax
! Debug: list int = const $74 (used reg = )
mov	ax,*$74
push	ax
! Debug: list unsigned char AX = [S+$2A+$17] (used reg = )
mov	al,$19[bp]
xor	ah,ah
push	ax
! Debug: func () void = _write_byte+0 (used reg = )
call	__write_byte
add	sp,*6
!BCC_EOS
! 4076 int13_fail_nostatus:
.FFEE:
..FFEE	=	-$26
! 4077   FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$26+$1C] (used reg = )
mov	ax,$1E[bp]
or	al,*1
mov	$1E[bp],ax
!BCC_EOS
! 4078   return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 4079 int13_success:
.FFEF:
..FFEF	=	-$26
! 4080   *(((Bit8u *)&AX)+1) = (0x00);
! Debug: eq int = const 0 to unsigned char AX = [S+$26+$17] (used reg = )
xor	al,al
mov	$19[bp],al
!BCC_EOS
! 4081 int13_success_noah:
.FFED:
..FFED	=	-$26
! 4082   _write_byte(0x00, 0x0074, 0x0040);
! Debug: list int = const $40 (used reg = )
mov	ax,*$40
push	ax
! Debug: list int = const $74 (used reg = )
mov	ax,*$74
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: func () void = _write_byte+0 (used reg = )
call	__write_byte
add	sp,*6
!BCC_EOS
! 4083   FLAGS &= 0xfffe;
! Debug: andab unsigned int = const $FFFE to unsigned short FLAGS = [S+$26+$1C] (used reg = )
mov	ax,$1E[bp]
and	al,#$FE
mov	$1E[bp],ax
!BCC_EOS
! 4084 }
mov	sp,bp
pop	bp
ret
! 4085   void
! Register BX used in function int13_harddisk
! 4086 int13_cdrom(EHBX, DS, ES, DI, SI, BP, ELDX, BX, DX, CX, AX, IP, CS, FLAGS)
! 4087   Bit16u EHBX, DS, ES, DI, SI, BP, ELDX, BX, DX, CX, AX, IP, CS, FLAGS;
export	_int13_cdrom
_int13_cdrom:
!BCC_EOS
! 4088 {
! 4089   Bit8u device, status, locks;
!BCC_EOS
! 4090   Bit8u atacmd[12];
!BCC_EOS
! 4091   Bit32u lba;
!BCC_EOS
! 4092   Bit16u count, segment, offset, i, size;
!BCC_EOS
! 4093   ;
push	bp
mov	bp,sp
add	sp,*-$1E
!BCC_EOS
! 4094   _write_byte(0x00, 0x0074, 0x0040);
! Debug: list int = const $40 (used reg = )
mov	ax,*$40
push	ax
! Debug: list int = const $74 (used reg = )
mov	ax,*$74
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: func () void = _write_byte+0 (used reg = )
call	__write_byte
add	sp,*6
!BCC_EOS
! 4095   if( (( ELDX & 0x00ff ) < 0xE0) || (( ELDX & 0x00ff ) >= 0xE0+(4*2)) ) {
! Debug: and int = const $FF to unsigned short ELDX = [S+$20+$E] (used reg = )
mov	al,$10[bp]
! Debug: lt int = const $E0 to unsigned char = al+0 (used reg = )
cmp	al,#$E0
jb  	.5B8
.5B9:
! Debug: and int = const $FF to unsigned short ELDX = [S+$20+$E] (used reg = )
mov	al,$10[bp]
! Debug: ge int = const $E8 to unsigned char = al+0 (used reg = )
cmp	al,#$E8
jb  	.5B7
.5B8:
! 4096     bios_printf(4, "int13_cdrom: function %02x, ELDL out of range %02x\n", *(((Bit8u *)&AX)+1), ( ELDX & 0x00ff ));
! Debug: and int = const $FF to unsigned short ELDX = [S+$20+$E] (used reg = )
mov	al,$10[bp]
! Debug: list unsigned char = al+0 (used reg = )
xor	ah,ah
push	ax
! Debug: list unsigned char AX = [S+$22+$17] (used reg = )
mov	al,$19[bp]
xor	ah,ah
push	ax
! Debug: list * char = .5BA+0 (used reg = )
mov	bx,#.5BA
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*8
!BCC_EOS
! 4097     goto int13_fail;
add	sp,#..FFEB+$20
br 	.FFEB
!BCC_EOS
! 4098   }
! 4099   device=*((Bit8u *)(&((ebda_data_t *) 0)->ata.cdidmap[( ELDX & 0x00ff )-0xE0]));
.5B7:
! Debug: and int = const $FF to unsigned short ELDX = [S+$20+$E] (used reg = )
mov	al,$10[bp]
! Debug: sub int = const $E0 to unsigned char = al+0 (used reg = )
xor	ah,ah
! Debug: ptradd unsigned int = ax-$E0 to [8] unsigned char = const $23C (used reg = )
add	ax,#-$E0
mov	bx,ax
! Debug: address unsigned char = [bx+$23C] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$23C (used reg = )
! Debug: eq unsigned char = [bx+$23C] to unsigned char device = [S+$20-3] (used reg = )
mov	al,$23C[bx]
mov	-1[bp],al
!BCC_EOS
! 4100   if (device >= (4*2)) {
! Debug: ge int = const 8 to unsigned char device = [S+$20-3] (used reg = )
mov	al,-1[bp]
cmp	al,*8
jb  	.5BB
.5BC:
! 4101     bios_printf(4, "int13_cdrom: function %02x, unmapped device for ELDL=%02x\n", *(((Bit8u *)&AX)+1), ( ELDX & 0x00ff ));
! Debug: and int = const $FF to unsigned short ELDX = [S+$20+$E] (used reg = )
mov	al,$10[bp]
! Debug: list unsigned char = al+0 (used reg = )
xor	ah,ah
push	ax
! Debug: list unsigned char AX = [S+$22+$17] (used reg = )
mov	al,$19[bp]
xor	ah,ah
push	ax
! Debug: list * char = .5BD+0 (used reg = )
mov	bx,#.5BD
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*8
!BCC_EOS
! 4102     goto int13_fail;
add	sp,#..FFEB+$20
br 	.FFEB
!BCC_EOS
! 4103   }
! 4104   switch (*(((Bit8u *)&AX)+1)) {
.5BB:
mov	al,$19[bp]
br 	.5C0
! 4105     case 0x00:
! 4106     case 0x09:
.5C1:
! 4107     case 0x0c:
.5C2:
! 4108     case 0x0d:
.5C3:
! 4109     case 0x10:
.5C4:
! 4110     case 0x11:
.5C5:
! 4111     case 0x14:
.5C6:
! 4112     case 0x16:
.5C7:
! 4113       goto int13_success;
.5C8:
add	sp,#..FFE9-..FFEA
br 	.FFE9
!BCC_EOS
! 4114       break;
br 	.5BE
!BCC_EOS
! 4115     case 0x03:
! 4116     case 0x05:
.5C9:
! 4117     case 0x43:
.5CA:
! 4118       *(((Bit8u *)&AX)+1) = (0x03);
.5CB:
! Debug: eq int = const 3 to unsigned char AX = [S+$20+$17] (used reg = )
mov	al,*3
mov	$19[bp],al
!BCC_EOS
! 4119       goto int13_fail_noah;
add	sp,#..FFE8-..FFEA
br 	.FFE8
!BCC_EOS
! 4120       break;
br 	.5BE
!BCC_EOS
! 4121     case 0x01:
! 4122       status = _read_byte(0x0074, 0x0040);
.5CC:
! Debug: list int = const $40 (used reg = )
mov	ax,*$40
push	ax
! Debug: list int = const $74 (used reg = )
mov	ax,*$74
push	ax
! Debug: func () unsigned char = _read_byte+0 (used reg = )
call	__read_byte
add	sp,*4
! Debug: eq unsigned char = al+0 to unsigned char status = [S+$20-4] (used reg = )
mov	-2[bp],al
!BCC_EOS
! 4123       *(((Bit8u *)&AX)+1) = (status);
! Debug: eq unsigned char status = [S+$20-4] to unsigned char AX = [S+$20+$17] (used reg = )
mov	al,-2[bp]
mov	$19[bp],al
!BCC_EOS
! 4124       _write_byte(0, 0x0074, 0x0040);
! Debug: list int = const $40 (used reg = )
mov	ax,*$40
push	ax
! Debug: list int = const $74 (used reg = )
mov	ax,*$74
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: func () void = _write_byte+0 (used reg = )
call	__write_byte
add	sp,*6
!BCC_EOS
! 4125       if (status) goto int13_fail_nostatus;
mov	al,-2[bp]
test	al,al
je  	.5CD
.5CE:
add	sp,#..FFE7-..FFEA
br 	.FFE7
!BCC_EOS
! 4126       else goto int13_success_noah;
jmp .5CF
.5CD:
add	sp,#..FFE6-..FFEA
br 	.FFE6
!BCC_EOS
! 4127       break;
.5CF:
br 	.5BE
!BCC_EOS
! 4128     case 0x15:
! 4129       *(((Bit8u *)&AX)+1) = (0x02);
.5D0:
! Debug: eq int = const 2 to unsigned char AX = [S+$20+$17] (used reg = )
mov	al,*2
mov	$19[bp],al
!BCC_EOS
! 4130       goto int13_fail_noah;
add	sp,#..FFE8-..FFEA
br 	.FFE8
!BCC_EOS
! 4131       break;
br 	.5BE
!BCC_EOS
! 4132     case 0x41:
! 4133       BX=0xaa55;
.5D1:
! Debug: eq unsigned int = const $AA55 to unsigned short BX = [S+$20+$10] (used reg = )
mov	ax,#$AA55
mov	$12[bp],ax
!BCC_EOS
! 4134       *(((Bit8u *)&AX)+1)
! 4134  = (0x30);
! Debug: eq int = const $30 to unsigned char AX = [S+$20+$17] (used reg = )
mov	al,*$30
mov	$19[bp],al
!BCC_EOS
! 4135       CX=0x0007;
! Debug: eq int = const 7 to unsigned short CX = [S+$20+$14] (used reg = )
mov	ax,*7
mov	$16[bp],ax
!BCC_EOS
! 4136       goto int13_success_noah;
add	sp,#..FFE6-..FFEA
br 	.FFE6
!BCC_EOS
! 4137       break;
br 	.5BE
!BCC_EOS
! 4138     case 0x42:
! 4139     case 0x44:
.5D2:
! 4140     case 0x47:
.5D3:
! 4141       count=_read_word(SI+(Bit16u)&((int13ext_t *) 0)->count, DS);
.5D4:
! Debug: list unsigned short DS = [S+$20+4] (used reg = )
push	6[bp]
! Debug: add unsigned short = const 2 to unsigned short SI = [S+$22+$A] (used reg = )
mov	ax,$C[bp]
! Debug: list unsigned int = ax+2 (used reg = )
inc	ax
inc	ax
push	ax
! Debug: func () unsigned short = _read_word+0 (used reg = )
call	__read_word
add	sp,*4
! Debug: eq unsigned short = ax+0 to unsigned short count = [S+$20-$18] (used reg = )
mov	-$16[bp],ax
!BCC_EOS
! 4142       segment=_read_word(SI+(Bit16u)&((int13ext_t *) 0)->segment, DS);
! Debug: list unsigned short DS = [S+$20+4] (used reg = )
push	6[bp]
! Debug: add unsigned short = const 6 to unsigned short SI = [S+$22+$A] (used reg = )
mov	ax,$C[bp]
! Debug: list unsigned int = ax+6 (used reg = )
add	ax,*6
push	ax
! Debug: func () unsigned short = _read_word+0 (used reg = )
call	__read_word
add	sp,*4
! Debug: eq unsigned short = ax+0 to unsigned short segment = [S+$20-$1A] (used reg = )
mov	-$18[bp],ax
!BCC_EOS
! 4143       offset=_read_word(SI+(Bit16u)&((int13ext_t *) 0)->offset, DS);
! Debug: list unsigned short DS = [S+$20+4] (used reg = )
push	6[bp]
! Debug: add unsigned short = const 4 to unsigned short SI = [S+$22+$A] (used reg = )
mov	ax,$C[bp]
! Debug: list unsigned int = ax+4 (used reg = )
add	ax,*4
push	ax
! Debug: func () unsigned short = _read_word+0 (used reg = )
call	__read_word
add	sp,*4
! Debug: eq unsigned short = ax+0 to unsigned short offset = [S+$20-$1C] (used reg = )
mov	-$1A[bp],ax
!BCC_EOS
! 4144       lba=_read_dword(SI+(Bit16u)&((int13ext_t *) 0)->lba2, DS);
! Debug: list unsigned short DS = [S+$20+4] (used reg = )
push	6[bp]
! Debug: add unsigned short = const $C to unsigned short SI = [S+$22+$A] (used reg = )
mov	ax,$C[bp]
! Debug: list unsigned int = ax+$C (used reg = )
add	ax,*$C
push	ax
! Debug: func () unsigned long = _read_dword+0 (used reg = )
call	__read_dword
mov	bx,dx
add	sp,*4
! Debug: eq unsigned long = bx+0 to unsigned long lba = [S+$20-$16] (used reg = )
mov	-$14[bp],ax
mov	-$12[bp],bx
!BCC_EOS
! 4145       if (lba != 0L) {
! Debug: ne long = const 0 to unsigned long lba = [S+$20-$16] (used reg = )
! Debug: expression subtree swapping
xor	ax,ax
xor	bx,bx
push	bx
push	ax
mov	ax,-$14[bp]
mov	bx,-$12[bp]
lea	di,-2+..FFEA[bp]
call	lcmpul
lea	sp,2+..FFEA[bp]
je  	.5D5
.5D6:
! 4146         bios_printf((2 | 4 | 1), "int13_cdrom: function %02x. Can't use 64bits lba\n",*(((Bit8u *)&AX)+1));
! Debug: list unsigned char AX = [S+$20+$17] (used reg = )
mov	al,$19[bp]
xor	ah,ah
push	ax
! Debug: list * char = .5D7+0 (used reg = )
mov	bx,#.5D7
push	bx
! Debug: list int = const 7 (used reg = )
mov	ax,*7
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*6
!BCC_EOS
! 4147         goto int13_fail;
add	sp,#..FFEB-..FFEA
br 	.FFEB
!BCC_EOS
! 4148       }
! 4149       lba=_read_dword(SI+(Bit16u)&((int13ext_t *) 0)->lba1, DS);
.5D5:
! Debug: list unsigned short DS = [S+$20+4] (used reg = )
push	6[bp]
! Debug: add unsigned short = const 8 to unsigned short SI = [S+$22+$A] (used reg = )
mov	ax,$C[bp]
! Debug: list unsigned int = ax+8 (used reg = )
add	ax,*8
push	ax
! Debug: func () unsigned long = _read_dword+0 (used reg = )
call	__read_dword
mov	bx,dx
add	sp,*4
! Debug: eq unsigned long = bx+0 to unsigned long lba = [S+$20-$16] (used reg = )
mov	-$14[bp],ax
mov	-$12[bp],bx
!BCC_EOS
! 4150       if ((*(((Bit8u *)&AX)+1) == 0x44) || (*(((Bit8u *)&AX)+1) == 0x47))
! Debug: logeq int = const $44 to unsigned char AX = [S+$20+$17] (used reg = )
mov	al,$19[bp]
cmp	al,*$44
je  	.5D9
.5DA:
! Debug: logeq int = const $47 to unsigned char AX = [S+$20+$17] (used reg = )
mov	al,$19[bp]
cmp	al,*$47
jne 	.5D8
.5D9:
! 4151         goto int13_success;
add	sp,#..FFE9-..FFEA
br 	.FFE9
!BCC_EOS
! 4152       _memsetb(0,atacmd,get_SS(),12);
.5D8:
! Debug: list int = const $C (used reg = )
mov	ax,*$C
push	ax
! Debug: func () unsigned short = get_SS+0 (used reg = )
call	_get_SS
! Debug: list unsigned short = ax+0 (used reg = )
push	ax
! Debug: list * unsigned char atacmd = S+$24-$11 (used reg = )
lea	bx,-$F[bp]
push	bx
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: func () void = _memsetb+0 (used reg = )
call	__memsetb
add	sp,*8
!BCC_EOS
! 4153       atacmd[0]=0x28;
! Debug: eq int = const $28 to unsigned char atacmd = [S+$20-$11] (used reg = )
mov	al,*$28
mov	-$F[bp],al
!BCC_EOS
! 4154       atacmd[7]=*(((Bit8u *)&count)+1);
! Debug: eq unsigned char count = [S+$20-$17] to unsigned char atacmd = [S+$20-$A] (used reg = )
mov	al,-$15[bp]
mov	-8[bp],al
!BCC_EOS
! 4155       atacmd[8]=*((Bit8u *)&count);
! Debug: eq unsigned char count = [S+$20-$18] to unsigned char atacmd = [S+$20-9] (used reg = )
mov	al,-$16[bp]
mov	-7[bp],al
!BCC_EOS
! 4156       atacmd[2]=*(((Bit8u *)&*(((Bit16u *)&lba)+1))+1);
! Debug: eq unsigned char lba = [S+$20-$13] to unsigned char atacmd = [S+$20-$F] (used reg = )
mov	al,-$11[bp]
mov	-$D[bp],al
!BCC_EOS
! 4157       atacmd[3]=*((Bit8u *)&*(((Bit16u *)&lba)+1));
! Debug: eq unsigned char lba = [S+$20-$14] to unsigned char atacmd = [S+$20-$E] (used reg = )
mov	al,-$12[bp]
mov	-$C[bp],al
!BCC_EOS
! 4158       atacmd[4]=*(((Bit8u *)&*((Bit16u *)&lba))+1);
! Debug: eq unsigned char lba = [S+$20-$15] to unsigned char atacmd = [S+$20-$D] (used reg = )
mov	al,-$13[bp]
mov	-$B[bp],al
!BCC_EOS
! 4159       atacmd[5]=*((Bit8u *)&lba);
! Debug: eq unsigned char lba = [S+$20-$16] to unsigned char atacmd = [S+$20-$C] (used reg = )
mov	al,-$14[bp]
mov	-$A[bp],al
!BCC_EOS
! 4160       status = ata_cmd_packet(device, 12, get_SS(), atacmd, 0, count*2048L, 0x01, segment,offset);
! Debug: list unsigned short offset = [S+$20-$1C] (used reg = )
push	-$1A[bp]
! Debug: list unsigned short segment = [S+$22-$1A] (used reg = )
push	-$18[bp]
! Debug: list int = const 1 (used reg = )
mov	ax,*1
push	ax
! Debug: cast unsigned long = const 0 to unsigned short count = [S+$26-$18] (used reg = )
mov	ax,-$16[bp]
xor	bx,bx
! Debug: mul long = const $800 to unsigned long = bx+0 (used reg = )
push	bx
push	ax
mov	ax,#$800
xor	bx,bx
push	bx
push	ax
mov	ax,-8+..FFEA[bp]
mov	bx,-6+..FFEA[bp]
lea	di,-$C+..FFEA[bp]
call	lmulul
add	sp,*8
! Debug: list unsigned long = bx+0 (used reg = )
push	bx
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list * unsigned char atacmd = S+$2C-$11 (used reg = )
lea	bx,-$F[bp]
push	bx
! Debug: func () unsigned short = get_SS+0 (used reg = )
call	_get_SS
! Debug: list unsigned short = ax+0 (used reg = )
push	ax
! Debug: list int = const $C (used reg = )
mov	ax,*$C
push	ax
! Debug: list unsigned char device = [S+$32-3] (used reg = )
mov	al,-1[bp]
xor	ah,ah
push	ax
! Debug: func () unsigned short = ata_cmd_packet+0 (used reg = )
call	_ata_cmd_packet
add	sp,*$14
! Debug: eq unsigned short = ax+0 to unsigned char status = [S+$20-4] (used reg = )
mov	-2[bp],al
!BCC_EOS
! 4161       count = (Bit16u)(*((Bit32u *)(&((ebda_data_t *) 0)->ata.trsfbytes)) >> 11);
! Debug: sr int = const $B to unsigned long = [+$256] (used reg = )
mov	ax,[$256]
mov	bx,[$258]
mov	al,ah
mov	ah,bl
mov	bl,bh
sub	bh,bh
mov	di,*3
call	lsrul
! Debug: cast unsigned short = const 0 to unsigned long = bx+0 (used reg = )
! Debug: eq unsigned short = ax+0 to unsigned short count = [S+$20-$18] (used reg = )
mov	-$16[bp],ax
!BCC_EOS
! 4162       _write_word(count, SI+(Bit16u)&((int13ext_t *) 0)->count, DS);
! Debug: list unsigned short DS = [S+$20+4] (used reg = )
push	6[bp]
! Debug: add unsigned short = const 2 to unsigned short SI = [S+$22+$A] (used reg = )
mov	ax,$C[bp]
! Debug: list unsigned int = ax+2 (used reg = )
inc	ax
inc	ax
push	ax
! Debug: list unsigned short count = [S+$24-$18] (used reg = )
push	-$16[bp]
! Debug: func () void = _write_word+0 (used reg = )
call	__write_word
add	sp,*6
!BCC_EOS
! 4163       if (status != 0) {
! Debug: ne int = const 0 to unsigned char status = [S+$20-4] (used reg = )
mov	al,-2[bp]
test	al,al
je  	.5DB
.5DC:
! 4164         bios_printf(4, "int13_cdrom: function %02x, status %02x !\n",*(((Bit8u *)&AX)+1),status);
! Debug: list unsigned char status = [S+$20-4] (used reg = )
mov	al,-2[bp]
xor	ah,ah
push	ax
! Debug: list unsigned char AX = [S+$22+$17] (used reg = )
mov	al,$19[bp]
xor	ah,ah
push	ax
! Debug: list * char = .5DD+0 (used reg = )
mov	bx,#.5DD
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*8
!BCC_EOS
! 4165         *(((Bit8u *)&AX)+1) = (0x0c);
! Debug: eq int = const $C to unsigned char AX = [S+$20+$17] (used reg = )
mov	al,*$C
mov	$19[bp],al
!BCC_EOS
! 4166         goto int13_fail_noah;
add	sp,#..FFE8-..FFEA
br 	.FFE8
!BCC_EOS
! 4167       }
! 4168       goto int13_success;
.5DB:
add	sp,#..FFE9-..FFEA
br 	.FFE9
!BCC_EOS
! 4169       break;
br 	.5BE
!BCC_EOS
! 4170     case 0x45:
! 4171       if (( AX & 0x00ff ) > 2) goto int13_fail;
.5DE:
! Debug: and int = const $FF to unsigned short AX = [S+$20+$16] (used reg = )
mov	al,$18[bp]
! Debug: gt int = const 2 to unsigned char = al+0 (used reg = )
cmp	al,*2
jbe 	.5DF
.5E0:
add	sp,#..FFEB-..FFEA
br 	.FFEB
!BCC_EOS
! 4172       locks = *((Bit8u *)(&((ebda_data_t *) 0)->ata.devices[device].lock));
.5DF:
! Debug: ptradd unsigned char device = [S+$20-3] to [8] struct  = const $142 (used reg = )
mov	al,-1[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned char = [bx+$145] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$145 (used reg = )
! Debug: eq unsigned char = [bx+$145] to unsigned char locks = [S+$20-5] (used reg = )
mov	al,$145[bx]
mov	-3[bp],al
!BCC_EOS
! 4173       switch (( AX & 0x00ff )) {
! Debug: and int = const $FF to unsigned short AX = [S+$20+$16] (used reg = )
mov	al,$18[bp]
br 	.5E3
! 4174         case 0 :
! 4175           if (locks == 0xff) {
.5E4:
! Debug: logeq int = const $FF to unsigned char locks = [S+$20-5] (used reg = )
mov	al,-3[bp]
cmp	al,#$FF
jne 	.5E5
.5E6:
! 4176             *(((Bit8u *)&AX)+1) = (0xb4);
! Debug: eq int = const $B4 to unsigned char AX = [S+$20+$17] (used reg = )
mov	al,#$B4
mov	$19[bp],al
!BCC_EOS
! 4177             *((Bit8u *)&AX) = (1);
! Debug: eq int = const 1 to unsigned char AX = [S+$20+$16] (used reg = )
mov	al,*1
mov	$18[bp],al
!BCC_EOS
! 4178             goto int13_fail_noah;
add	sp,#..FFE8-..FFEA
br 	.FFE8
!BCC_EOS
! 4179           }
! 4180           *((Bit8u *)(&((ebda_data_t *) 0)->ata.devices[device].lock)) = (++locks);
.5E5:
! Debug: preinc unsigned char locks = [S+$20-5] (used reg = )
mov	al,-3[bp]
inc	ax
mov	-3[bp],al
push	ax
! Debug: ptradd unsigned char device = [S+$22-3] to [8] struct  = const $142 (used reg = )
mov	al,-1[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned char = [bx+$145] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$145 (used reg = )
! Debug: eq unsigned char (temp) = [S+$22-$22] to unsigned char = [bx+$145] (used reg = )
mov	al,0+..FFEA[bp]
mov	$145[bx],al
inc	sp
inc	sp
!BCC_EOS
! 4181           *((Bit8u *)&AX) = (1);
! Debug: eq int = const 1 to unsigned char AX = [S+$20+$16] (used reg = )
mov	al,*1
mov	$18[bp],al
!BCC_EOS
! 4182           break;
jmp .5E1
!BCC_EOS
! 4183         case 1 :
! 4184           if (lo
.5E7:
! 4184 cks == 0x00) {
! Debug: logeq int = const 0 to unsigned char locks = [S+$20-5] (used reg = )
mov	al,-3[bp]
test	al,al
jne 	.5E8
.5E9:
! 4185             *(((Bit8u *)&AX)+1) = (0xb0);
! Debug: eq int = const $B0 to unsigned char AX = [S+$20+$17] (used reg = )
mov	al,#$B0
mov	$19[bp],al
!BCC_EOS
! 4186             *((Bit8u *)&AX) = (0);
! Debug: eq int = const 0 to unsigned char AX = [S+$20+$16] (used reg = )
xor	al,al
mov	$18[bp],al
!BCC_EOS
! 4187             goto int13_fail_noah;
add	sp,#..FFE8-..FFEA
br 	.FFE8
!BCC_EOS
! 4188           }
! 4189           *((Bit8u *)(&((ebda_data_t *) 0)->ata.devices[device].lock)) = (--locks);
.5E8:
! Debug: predec unsigned char locks = [S+$20-5] (used reg = )
mov	al,-3[bp]
dec	ax
mov	-3[bp],al
push	ax
! Debug: ptradd unsigned char device = [S+$22-3] to [8] struct  = const $142 (used reg = )
mov	al,-1[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned char = [bx+$145] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$145 (used reg = )
! Debug: eq unsigned char (temp) = [S+$22-$22] to unsigned char = [bx+$145] (used reg = )
mov	al,0+..FFEA[bp]
mov	$145[bx],al
inc	sp
inc	sp
!BCC_EOS
! 4190           *((Bit8u *)&AX) = (locks==0?0:1);
! Debug: logeq int = const 0 to unsigned char locks = [S+$20-5] (used reg = )
mov	al,-3[bp]
test	al,al
jne 	.5EA
.5EB:
xor	al,al
jmp .5EC
.5EA:
mov	al,*1
.5EC:
! Debug: eq char = al+0 to unsigned char AX = [S+$20+$16] (used reg = )
mov	$18[bp],al
!BCC_EOS
! 4191           break;
jmp .5E1
!BCC_EOS
! 4192         case 2 :
! 4193           *((Bit8u *)&AX) = (locks==0?0:1);
.5ED:
! Debug: logeq int = const 0 to unsigned char locks = [S+$20-5] (used reg = )
mov	al,-3[bp]
test	al,al
jne 	.5EE
.5EF:
xor	al,al
jmp .5F0
.5EE:
mov	al,*1
.5F0:
! Debug: eq char = al+0 to unsigned char AX = [S+$20+$16] (used reg = )
mov	$18[bp],al
!BCC_EOS
! 4194           break;
jmp .5E1
!BCC_EOS
! 4195       }
! 4196       goto int13_success;
jmp .5E1
.5E3:
sub	al,*0
beq 	.5E4
sub	al,*1
je 	.5E7
sub	al,*1
je 	.5ED
.5E1:
add	sp,#..FFE9-..FFEA
br 	.FFE9
!BCC_EOS
! 4197       break;
br 	.5BE
!BCC_EOS
! 4198     case 0x46:
! 4199       locks = *((Bit8u *)(&((ebda_data_t *) 0)->ata.devices[device].lock));
.5F1:
! Debug: ptradd unsigned char device = [S+$20-3] to [8] struct  = const $142 (used reg = )
mov	al,-1[bp]
xor	ah,ah
mov	cx,*$1E
imul	cx
mov	bx,ax
! Debug: address unsigned char = [bx+$145] (used reg = )
! Debug: cast * unsigned char = const 0 to * unsigned char = bx+$145 (used reg = )
! Debug: eq unsigned char = [bx+$145] to unsigned char locks = [S+$20-5] (used reg = )
mov	al,$145[bx]
mov	-3[bp],al
!BCC_EOS
! 4200       if (locks != 0) {
! Debug: ne int = const 0 to unsigned char locks = [S+$20-5] (used reg = )
mov	al,-3[bp]
test	al,al
je  	.5F2
.5F3:
! 4201         *(((Bit8u *)&AX)+1) = (0xb1);
! Debug: eq int = const $B1 to unsigned char AX = [S+$20+$17] (used reg = )
mov	al,#$B1
mov	$19[bp],al
!BCC_EOS
! 4202         goto int13_fail_noah;
add	sp,#..FFE8-..FFEA
br 	.FFE8
!BCC_EOS
! 4203       }
! 4204 #asm
.5F2:
!BCC_EOS
!BCC_ASM
_int13_cdrom.BP	set	$2C
.int13_cdrom.BP	set	$E
_int13_cdrom.EHBX	set	$22
.int13_cdrom.EHBX	set	4
_int13_cdrom.CS	set	$3A
.int13_cdrom.CS	set	$1C
_int13_cdrom.count	set	8
.int13_cdrom.count	set	-$16
_int13_cdrom.CX	set	$34
.int13_cdrom.CX	set	$16
_int13_cdrom.segment	set	6
.int13_cdrom.segment	set	-$18
_int13_cdrom.DI	set	$28
.int13_cdrom.DI	set	$A
_int13_cdrom.FLAGS	set	$3C
.int13_cdrom.FLAGS	set	$1E
_int13_cdrom.DS	set	$24
.int13_cdrom.DS	set	6
_int13_cdrom.ELDX	set	$2E
.int13_cdrom.ELDX	set	$10
_int13_cdrom.DX	set	$32
.int13_cdrom.DX	set	$14
_int13_cdrom.size	set	0
.int13_cdrom.size	set	-$1E
_int13_cdrom.i	set	2
.int13_cdrom.i	set	-$1C
_int13_cdrom.device	set	$1D
.int13_cdrom.device	set	-1
_int13_cdrom.ES	set	$26
.int13_cdrom.ES	set	8
_int13_cdrom.SI	set	$2A
.int13_cdrom.SI	set	$C
_int13_cdrom.IP	set	$38
.int13_cdrom.IP	set	$1A
_int13_cdrom.lba	set	$A
.int13_cdrom.lba	set	-$14
_int13_cdrom.status	set	$1C
.int13_cdrom.status	set	-2
_int13_cdrom.atacmd	set	$F
.int13_cdrom.atacmd	set	-$F
_int13_cdrom.AX	set	$36
.int13_cdrom.AX	set	$18
_int13_cdrom.offset	set	4
.int13_cdrom.offset	set	-$1A
_int13_cdrom.BX	set	$30
.int13_cdrom.BX	set	$12
_int13_cdrom.locks	set	$1B
.int13_cdrom.locks	set	-3
        push bp
        mov bp, sp
        mov ah, #0x52
        int #0x15
        mov _int13_cdrom.status + 2[bp], ah
        jnc int13_cdrom_rme_end
        mov _int13_cdrom.status, #1
int13_cdrom_rme_end:
        pop bp
! 4214 endasm
!BCC_ENDASM
!BCC_EOS
! 4215       if (status != 0) {
! Debug: ne int = const 0 to unsigned char status = [S+$20-4] (used reg = )
mov	al,-2[bp]
test	al,al
je  	.5F4
.5F5:
! 4216         *(((Bit8u *)&AX)+1) = (0xb1);
! Debug: eq int = const $B1 to unsigned char AX = [S+$20+$17] (used reg = )
mov	al,#$B1
mov	$19[bp],al
!BCC_EOS
! 4217         goto int13_fail_noah;
add	sp,#..FFE8-..FFEA
br 	.FFE8
!BCC_EOS
! 4218       }
! 4219       goto int13_success;
.5F4:
add	sp,#..FFE9-..FFEA
br 	.FFE9
!BCC_EOS
! 4220       break;
br 	.5BE
!BCC_EOS
! 4221     case 0x48:
! 4222       if (int13_edd(DS, SI, device))
.5F6:
! Debug: list unsigned char device = [S+$20-3] (used reg = )
mov	al,-1[bp]
xor	ah,ah
push	ax
! Debug: list unsigned short SI = [S+$22+$A] (used reg = )
push	$C[bp]
! Debug: list unsigned short DS = [S+$24+4] (used reg = )
push	6[bp]
! Debug: func () int = int13_edd+0 (used reg = )
call	_int13_edd
add	sp,*6
test	ax,ax
je  	.5F7
.5F8:
! 4223         goto int13_fail;
add	sp,#..FFEB-..FFEA
br 	.FFEB
!BCC_EOS
! 4224       goto int13_success;
.5F7:
add	sp,#..FFE9-..FFEA
br 	.FFE9
!BCC_EOS
! 4225       break;
br 	.5BE
!BCC_EOS
! 4226     case 0x49:
! 4227       *(((Bit8u *)&AX)+1) = (06);
.5F9:
! Debug: eq int = const 6 to unsigned char AX = [S+$20+$17] (used reg = )
mov	al,*6
mov	$19[bp],al
!BCC_EOS
! 4228       goto int13_fail_nostatus;
add	sp,#..FFE7-..FFEA
br 	.FFE7
!BCC_EOS
! 4229       break;
br 	.5BE
!BCC_EOS
! 4230     case 0x4e:
! 4231       switch (( AX & 0x00ff )) {
.5FA:
! Debug: and int = const $FF to unsigned short AX = [S+$20+$16] (used reg = )
mov	al,$18[bp]
jmp .5FD
! 4232         case 0x01:
! 4233         case 0x03:
.5FE:
! 4234         case 0x04:
.5FF:
! 4235         case 0x06:
.600:
! 4236           goto int13_success;
.601:
add	sp,#..FFE9-..FFEA
br 	.FFE9
!BCC_EOS
! 4237           break;
jmp .5FB
!BCC_EOS
! 4238         default:
! 4239           goto int13_fail;
.602:
add	sp,#..FFEB-..FFEA
br 	.FFEB
!BCC_EOS
! 4240       }
! 4241       break;
jmp .5FB
.5FD:
sub	al,*1
je 	.5FE
sub	al,*2
je 	.5FF
sub	al,*1
je 	.600
sub	al,*2
je 	.601
jmp	.602
.5FB:
br 	.5BE
!BCC_EOS
! 4242     case 0x02:
! 4243     case 0x04:
.603:
! 4244     case 0x08:
.604:
! 4245     case 0x0a:
.605:
! 4246     case 0x0b:
.606:
! 4247     case 0x18:
.607:
! 4248     case 0x50:
.608:
! 4249     default:
.609:
! 4250       bios_printf(4, "int13_cdrom: unsupported AH=%02x\n", *(((Bit8u *)&AX)+1));
.60A:
! Debug: list unsigned char AX = [S+$20+$17] (used reg = )
mov	al,$19[bp]
xor	ah,ah
push	ax
! Debug: list * char = .60B+0 (used reg = )
mov	bx,#.60B
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*6
!BCC_EOS
! 4251       goto int13_fail;
add	sp,#..FFEB-..FFEA
jmp .FFEB
!BCC_EOS
! 4252       break;
jmp .5BE
!BCC_EOS
! 4253   }
! 4254 int13_fail:
jmp .5BE
.5C0:
sub	al,*0
jb 	.60A
cmp	al,*$18
ja  	.60C
xor	ah,ah
shl	ax,*1
mov	bx,ax
seg	cs
br	.60D[bx]
.60D:
.word	.5C1
.word	.5CC
.word	.603
.word	.5C9
.word	.604
.word	.5CA
.word	.60A
.word	.60A
.word	.605
.word	.5C2
.word	.606
.word	.607
.word	.5C3
.word	.5C4
.word	.60A
.word	.60A
.word	.5C5
.word	.5C6
.word	.60A
.word	.60A
.word	.5C7
.word	.5D0
.word	.5C8
.word	.60A
.word	.608
.60C:
sub	al,*$41
jb 	.60A
cmp	al,*$F
ja  	.60E
xor	ah,ah
shl	ax,*1
mov	bx,ax
seg	cs
br	.60F[bx]
.60F:
.word	.5D1
.word	.5D2
.word	.5CB
.word	.5D3
.word	.5DE
.word	.5F1
.word	.5D4
.word	.5F6
.word	.5F9
.word	.60A
.word	.60A
.word	.60A
.word	.60A
.word	.5FA
.word	.60A
.word	.609
.60E:
br 	.60A
.5BE:
..FFEA	=	-$20
.FFEB:
..FFEB	=	-$20
! 4255   *(((Bit8u *)&AX)+1) = (0x01);
! Debug: eq int = const 1 to unsigned char AX = [S+$20+$17] (used reg = )
mov	al,*1
mov	$19[bp],al
!BCC_EOS
! 4256 int13_fail_noah:
.FFE8:
..FFE8	=	-$20
! 4257   _write_byte(*(((Bit8u *)&AX)+1), 0x0074, 0x0040);
! Debug: list int = const $40 (used reg = )
mov	ax,*$40
push	ax
! Debug: list int = const $74 (used reg = )
mov	ax,*$74
push	ax
! Debug: list unsigned char AX = [S+$24+$17] (used reg = )
mov	al,$19[bp]
xor	ah,ah
push	ax
! Debug: func () void = _write_byte+0 (used reg = )
call	__write_byte
add	sp,*6
!BCC_EOS
! 4258 int13_fail_nostatus:
.FFE7:
..FFE7	=	-$20
! 4259   FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$20+$1C] (used reg = )
mov	ax,$1E[bp]
or	al,*1
mov	$1E[bp],ax
!BCC_EOS
! 4260   return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 4261 int13_success:
.FFE9:
..FFE9	=	-$20
! 4262   *(((Bit8u *)&AX)+1) = (0x00);
! Debug: eq int = const 0 to unsigned char AX = [S+$20+$17] (used reg = )
xor	al,al
mov	$19[bp],al
!BCC_EOS
! 4263 int13_success_noah:
.FFE6:
..FFE6	=	-$20
! 4264   _write_byte(0x00, 0x0074, 0x0040);
! Debug: list int = const $40 (used reg = )
mov	ax,*$40
push	ax
! Debug: list int = const $74 (used reg = )
mov	ax,*$74
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: func () void = _write_byte+0 (used reg = )
call	__write_byte
add	sp,*6
!BCC_EOS
! 4265   FLAGS &= 0xfffe;
! Debug: andab unsigned int = const $FFFE to unsigned short FLAGS = [S+$20+$1C] (used reg = )
mov	ax,$1E[bp]
and	al,#$FE
mov	$1E[bp],ax
!BCC_EOS
! 4266 }
mov	sp,bp
pop	bp
ret
! 4267   void
! Register BX used in function int13_cdrom
! 4268 int13_eltorito(DS, ES, DI, SI, BP, SP, BX, DX, CX, AX, IP, CS, FLAGS)
! 4269   Bit16u DS, ES, DI, SI
export	_int13_eltorito
_int13_eltorito:
! 4269 , BP, SP, BX, DX, CX, AX, IP, CS, FLAGS;
!BCC_EOS
! 4270 {
! 4271   Bit16u ebda_seg=get_ebda_seg();
push	bp
mov	bp,sp
dec	sp
dec	sp
! Debug: func () unsigned short = get_ebda_seg+0 (used reg = )
call	_get_ebda_seg
! Debug: eq unsigned short = ax+0 to unsigned short ebda_seg = [S+4-4] (used reg = )
mov	-2[bp],ax
!BCC_EOS
! 4272   ;
!BCC_EOS
! 4273   switch (*(((Bit8u *)&AX)+1)) {
mov	al,$17[bp]
br 	.612
! 4274     case 0x4a:
! 4275     case 0x4c:
.613:
! 4276     case 0x4d:
.614:
! 4277       bios_printf((2 | 4 | 1), "Int13 eltorito call with AX=%04x. Please report\n",AX);
.615:
! Debug: list unsigned short AX = [S+4+$14] (used reg = )
push	$16[bp]
! Debug: list * char = .616+0 (used reg = )
mov	bx,#.616
push	bx
! Debug: list int = const 7 (used reg = )
mov	ax,*7
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*6
!BCC_EOS
! 4278       goto int13_fail;
add	sp,#..FFE4-..FFE5
br 	.FFE4
!BCC_EOS
! 4279       break;
br 	.610
!BCC_EOS
! 4280     case 0x4b:
! 4281       *((Bit8u *)(SI+0x00)) = (0x13);
.617:
! Debug: add int = const 0 to unsigned short SI = [S+4+8] (used reg = )
mov	ax,$A[bp]
! Debug: cast * unsigned char = const 0 to unsigned int = ax+0 (used reg = )
mov	bx,ax
! Debug: eq int = const $13 to unsigned char = [bx+0] (used reg = )
mov	al,*$13
mov	[bx],al
!BCC_EOS
! 4282       *((Bit8u *)(SI+0x01)) = (_read_byte(&((ebda_data_t *) 0)->cdemu.media, ebda_seg));
! Debug: list unsigned short ebda_seg = [S+4-4] (used reg = )
push	-2[bp]
! Debug: list * unsigned char = const $25B (used reg = )
mov	ax,#$25B
push	ax
! Debug: func () unsigned char = _read_byte+0 (used reg = )
call	__read_byte
add	sp,*4
push	ax
! Debug: add int = const 1 to unsigned short SI = [S+6+8] (used reg = )
mov	ax,$A[bp]
! Debug: cast * unsigned char = const 0 to unsigned int = ax+1 (used reg = )
mov	bx,ax
! Debug: eq unsigned char (temp) = [S+6-6] to unsigned char = [bx+1] (used reg = )
mov	al,0+..FFE5[bp]
mov	1[bx],al
inc	sp
inc	sp
!BCC_EOS
! 4283       *((Bit8u *)(SI+0x02)) = (_read_byte(&((ebda_data_t *) 0)->cdemu.emulated_drive, ebda_seg));
! Debug: list unsigned short ebda_seg = [S+4-4] (used reg = )
push	-2[bp]
! Debug: list * unsigned char = const $25C (used reg = )
mov	ax,#$25C
push	ax
! Debug: func () unsigned char = _read_byte+0 (used reg = )
call	__read_byte
add	sp,*4
push	ax
! Debug: add int = const 2 to unsigned short SI = [S+6+8] (used reg = )
mov	ax,$A[bp]
! Debug: cast * unsigned char = const 0 to unsigned int = ax+2 (used reg = )
mov	bx,ax
! Debug: eq unsigned char (temp) = [S+6-6] to unsigned char = [bx+2] (used reg = )
mov	al,0+..FFE5[bp]
mov	2[bx],al
inc	sp
inc	sp
!BCC_EOS
! 4284       *((Bit8u *)(SI+0x03)) = (_read_byte(&((ebda_data_t *) 0)->cdemu.controller_index, ebda_seg));
! Debug: list unsigned short ebda_seg = [S+4-4] (used reg = )
push	-2[bp]
! Debug: list * unsigned char = const $25D (used reg = )
mov	ax,#$25D
push	ax
! Debug: func () unsigned char = _read_byte+0 (used reg = )
call	__read_byte
add	sp,*4
push	ax
! Debug: add int = const 3 to unsigned short SI = [S+6+8] (used reg = )
mov	ax,$A[bp]
! Debug: cast * unsigned char = const 0 to unsigned int = ax+3 (used reg = )
mov	bx,ax
! Debug: eq unsigned char (temp) = [S+6-6] to unsigned char = [bx+3] (used reg = )
mov	al,0+..FFE5[bp]
mov	3[bx],al
inc	sp
inc	sp
!BCC_EOS
! 4285       *((Bit32u *)(SI+0x04)) = (_read_dword(&((ebda_data_t *) 0)->cdemu.ilba, ebda_seg));
! Debug: list unsigned short ebda_seg = [S+4-4] (used reg = )
push	-2[bp]
! Debug: list * unsigned long = const $260 (used reg = )
mov	ax,#$260
push	ax
! Debug: func () unsigned long = _read_dword+0 (used reg = )
call	__read_dword
mov	bx,dx
add	sp,*4
push	bx
push	ax
! Debug: add int = const 4 to unsigned short SI = [S+8+8] (used reg = )
mov	ax,$A[bp]
! Debug: cast * unsigned long = const 0 to unsigned int = ax+4 (used reg = )
mov	bx,ax
! Debug: eq unsigned long (temp) = [S+8-8] to unsigned long = [bx+4] (used reg = )
mov	ax,-2+..FFE5[bp]
mov	si,0+..FFE5[bp]
mov	4[bx],ax
mov	6[bx],si
add	sp,*4
!BCC_EOS
! 4286       *((Bit16u *)(SI+0x08)) = (_read_word(&((ebda_data_t *) 0)->cdemu.device_spec, ebda_seg));
! Debug: list unsigned short ebda_seg = [S+4-4] (used reg = )
push	-2[bp]
! Debug: list * unsigned short = const $25E (used reg = )
mov	ax,#$25E
push	ax
! Debug: func () unsigned short = _read_word+0 (used reg = )
call	__read_word
add	sp,*4
push	ax
! Debug: add int = const 8 to unsigned short SI = [S+6+8] (used reg = )
mov	ax,$A[bp]
! Debug: cast * unsigned short = const 0 to unsigned int = ax+8 (used reg = )
mov	bx,ax
! Debug: eq unsigned short (temp) = [S+6-6] to unsigned short = [bx+8] (used reg = )
mov	ax,0+..FFE5[bp]
mov	8[bx],ax
inc	sp
inc	sp
!BCC_EOS
! 4287       *((Bit16u *)(SI+0x0a)) = (_read_word(&((ebda_data_t *) 0)->cdemu.buffer_segment, ebda_seg));
! Debug: list unsigned short ebda_seg = [S+4-4] (used reg = )
push	-2[bp]
! Debug: list * unsigned short = const $264 (used reg = )
mov	ax,#$264
push	ax
! Debug: func () unsigned short = _read_word+0 (used reg = )
call	__read_word
add	sp,*4
push	ax
! Debug: add int = const $A to unsigned short SI = [S+6+8] (used reg = )
mov	ax,$A[bp]
! Debug: cast * unsigned short = const 0 to unsigned int = ax+$A (used reg = )
mov	bx,ax
! Debug: eq unsigned short (temp) = [S+6-6] to unsigned short = [bx+$A] (used reg = )
mov	ax,0+..FFE5[bp]
mov	$A[bx],ax
inc	sp
inc	sp
!BCC_EOS
! 4288       *((Bit16u *)(SI+0x0c)) = (_read_word(&((ebda_data_t *) 0)->cdemu.load_segment, ebda_seg));
! Debug: list unsigned short ebda_seg = [S+4-4] (used reg = )
push	-2[bp]
! Debug: list * unsigned short = const $266 (used reg = )
mov	ax,#$266
push	ax
! Debug: func () unsigned short = _read_word+0 (used reg = )
call	__read_word
add	sp,*4
push	ax
! Debug: add int = const $C to unsigned short SI = [S+6+8] (used reg = )
mov	ax,$A[bp]
! Debug: cast * unsigned short = const 0 to unsigned int = ax+$C (used reg = )
mov	bx,ax
! Debug: eq unsigned short (temp) = [S+6-6] to unsigned short = [bx+$C] (used reg = )
mov	ax,0+..FFE5[bp]
mov	$C[bx],ax
inc	sp
inc	sp
!BCC_EOS
! 4289       *((Bit16u *)(SI+0x0e)) = (_read_word(&((ebda_data_t *) 0)->cdemu.sector_count, ebda_seg));
! Debug: list unsigned short ebda_seg = [S+4-4] (used reg = )
push	-2[bp]
! Debug: list * unsigned short = const $268 (used reg = )
mov	ax,#$268
push	ax
! Debug: func () unsigned short = _read_word+0 (used reg = )
call	__read_word
add	sp,*4
push	ax
! Debug: add int = const $E to unsigned short SI = [S+6+8] (used reg = )
mov	ax,$A[bp]
! Debug: cast * unsigned short = const 0 to unsigned int = ax+$E (used reg = )
mov	bx,ax
! Debug: eq unsigned short (temp) = [S+6-6] to unsigned short = [bx+$E] (used reg = )
mov	ax,0+..FFE5[bp]
mov	$E[bx],ax
inc	sp
inc	sp
!BCC_EOS
! 4290       *((Bit8u *)(SI+0x10)) = (_read_byte(&((ebda_data_t *) 0)->cdemu.vdevice.cylinders, ebda_seg));
! Debug: list unsigned short ebda_seg = [S+4-4] (used reg = )
push	-2[bp]
! Debug: list * unsigned short = const $26C (used reg = )
mov	ax,#$26C
push	ax
! Debug: func () unsigned char = _read_byte+0 (used reg = )
call	__read_byte
add	sp,*4
push	ax
! Debug: add int = const $10 to unsigned short SI = [S+6+8] (used reg = )
mov	ax,$A[bp]
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$10 (used reg = )
mov	bx,ax
! Debug: eq unsigned char (temp) = [S+6-6] to unsigned char = [bx+$10] (used reg = )
mov	al,0+..FFE5[bp]
mov	$10[bx],al
inc	sp
inc	sp
!BCC_EOS
! 4291       *((Bit8u *)(SI+0x11)) = (_read_byte(&((ebda_data_t *) 0)->cdemu.vdevice.spt, ebda_seg));
! Debug: list unsigned short ebda_seg = [S+4-4] (used reg = )
push	-2[bp]
! Debug: list * unsigned short = const $26E (used reg = )
mov	ax,#$26E
push	ax
! Debug: func () unsigned char = _read_byte+0 (used reg = )
call	__read_byte
add	sp,*4
push	ax
! Debug: add int = const $11 to unsigned short SI = [S+6+8] (used reg = )
mov	ax,$A[bp]
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$11 (used reg = )
mov	bx,ax
! Debug: eq unsigned char (temp) = [S+6-6] to unsigned char = [bx+$11] (used reg = )
mov	al,0+..FFE5[bp]
mov	$11[bx],al
inc	sp
inc	sp
!BCC_EOS
! 4292       *((Bit8u *)(SI+0x12)) = (_read_byte(&((ebda_data_t *) 0)->cdemu.vdevice.heads, ebda_seg));
! Debug: list unsigned short ebda_seg = [S+4-4] (used reg = )
push	-2[bp]
! Debug: list * unsigned short = const $26A (used reg = )
mov	ax,#$26A
push	ax
! Debug: func () unsigned char = _read_byte+0 (used reg = )
call	__read_byte
add	sp,*4
push	ax
! Debug: add int = const $12 to unsigned short SI = [S+6+8] (used reg = )
mov	ax,$A[bp]
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$12 (used reg = )
mov	bx,ax
! Debug: eq unsigned char (temp) = [S+6-6] to unsigned char = [bx+$12] (used reg = )
mov	al,0+..FFE5[bp]
mov	$12[bx],al
inc	sp
inc	sp
!BCC_EOS
! 4293       if(( AX & 0x00ff ) == 0x00) {
! Debug: and int = const $FF to unsigned short AX = [S+4+$14] (used reg = )
mov	al,$16[bp]
! Debug: logeq int = const 0 to unsigned char = al+0 (used reg = )
test	al,al
jne 	.618
.619:
! 4294         _write_byte(0x00, &((ebda_data_t *) 0)->cdemu.active, ebda_seg);
! Debug: list unsigned short ebda_seg = [S+4-4] (used reg = )
push	-2[bp]
! Debug: list * unsigned char = const $25A (used reg = )
mov	ax,#$25A
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: func () void = _write_byte+0 (used reg = )
call	__write_byte
add	sp,*6
!BCC_EOS
! 4295       }
! 4296       goto int13_success;
.618:
add	sp,#..FFE3-..FFE5
jmp .FFE3
!BCC_EOS
! 4297       break;
jmp .610
!BCC_EOS
! 4298     default:
! 4299       bios_printf(4, "int13_eltorito: unsupported AH=%02x\n", *(((Bit8u *)&AX)+1));
.61A:
! Debug: list unsigned char AX = [S+4+$15] (used reg = )
mov	al,$17[bp]
xor	ah,ah
push	ax
! Debug: list * char = .61B+0 (used reg = )
mov	bx,#.61B
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*6
!BCC_EOS
! 4300       goto int13_fail;
add	sp,#..FFE4-..FFE5
jmp .FFE4
!BCC_EOS
! 4301       break;
jmp .610
!BCC_EOS
! 4302   }
! 4303 int13_fail:
jmp .610
.612:
sub	al,*$4A
beq 	.613
sub	al,*1
beq 	.617
sub	al,*1
beq 	.614
sub	al,*1
beq 	.615
jmp	.61A
.610:
..FFE5	=	-4
.FFE4:
..FFE4	=	-4
! 4304   *(((Bit8u *)&AX)+1) = (0x01);
! Debug: eq int = const 1 to unsigned char AX = [S+4+$15] (used reg = )
mov	al,*1
mov	$17[bp],al
!BCC_EOS
! 4305   _write_byte(*(((Bit8u *)&AX)+1), 0x0074, 0x0040);
! Debug: list int = const $40 (used reg = )
mov	ax,*$40
push	ax
! Debug: list int = const $74 (used reg = )
mov	ax,*$74
push	ax
! Debug: list unsigned char AX = [S+8+$15] (used reg = )
mov	al,$17[bp]
xor	ah,ah
push	ax
! Debug: func () void = _write_byte+0 (used reg = )
call	__write_byte
add	sp,*6
!BCC_EOS
! 4306   FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+4+$1A] (used reg = )
mov	ax,$1C[bp]
or	al,*1
mov	$1C[bp],ax
!BCC_EOS
! 4307   return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 4308 int13_success:
.FFE3:
..FFE3	=	-4
! 4309   *(((Bit8u *)&AX)+1) = (0x00);
! Debug: eq int = const 0 to unsigned char AX = [S+4+$15] (used reg = )
xor	al,al
mov	$17[bp],al
!BCC_EOS
! 4310   _write_byte(0x00, 0x0074, 0x0040);
! Debug: list int = const $40 (used reg = )
mov	ax,*$40
push	ax
! Debug: list int = const $74 (used reg = )
mov	ax,*$74
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: func () void = _write_byte+0 (used reg = )
call	__write_byte
add	sp,*6
!BCC_EOS
! 4311   FLAGS &= 0xfffe;
! Debug: andab unsigned int = const $FFFE to unsigned short FLAGS = [S+4+$1A] (used reg = )
mov	ax,$1C[bp]
and	al,#$FE
mov	$1C[bp],ax
!BCC_EOS
! 4312 }
mov	sp,bp
pop	bp
ret
! 4313   void
! Register BX used in function int13_eltorito
! 4314 int13_cdemu(DS, ES, DI, SI, BP, SP, BX, DX, CX, AX, IP, CS, FLAGS)
! 4315   Bit16u DS, ES, DI, SI, BP, SP, BX, DX, CX, AX, IP, CS,
export	_int13_cdemu
_int13_cdemu:
! 4315  FLAGS;
!BCC_EOS
! 4316 {
! 4317   Bit8u device, status;
!BCC_EOS
! 4318   Bit16u vheads, vspt, vcylinders;
!BCC_EOS
! 4319   Bit16u head, sector, cylinder, nbsectors, count;
!BCC_EOS
! 4320   Bit32u vlba, ilba, slba, elba, lba;
!BCC_EOS
! 4321   Bit16u before, segment, offset;
!BCC_EOS
! 4322   Bit8u atacmd[12];
!BCC_EOS
! 4323   ;
push	bp
mov	bp,sp
add	sp,*-$38
!BCC_EOS
! 4324   device = *((Bit8u *)(&((ebda_data_t *) 0)->cdemu.controller_index)) * 2;
! Debug: mul int = const 2 to unsigned char = [+$25D] (used reg = )
mov	al,[$25D]
xor	ah,ah
shl	ax,*1
! Debug: eq unsigned int = ax+0 to unsigned char device = [S+$3A-3] (used reg = )
mov	-1[bp],al
!BCC_EOS
! 4325   device += *((Bit8u *)(&((ebda_data_t *) 0)->cdemu.device_spec));
! Debug: addab unsigned char = [+$25E] to unsigned char device = [S+$3A-3] (used reg = )
mov	al,-1[bp]
xor	ah,ah
add	al,[$25E]
adc	ah,*0
mov	-1[bp],al
!BCC_EOS
! 4326   _write_byte(0x00, 0x0074, 0x0040);
! Debug: list int = const $40 (used reg = )
mov	ax,*$40
push	ax
! Debug: list int = const $74 (used reg = )
mov	ax,*$74
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: func () void = _write_byte+0 (used reg = )
call	__write_byte
add	sp,*6
!BCC_EOS
! 4327   if( (*((Bit8u *)(&((ebda_data_t *) 0)->cdemu.active)) ==0) ||
! 4328       (*((Bit8u *)(&((ebda_data_t *) 0)->cdemu.emulated_drive)) != ( DX & 0x00ff ))) {
! Debug: logeq int = const 0 to unsigned char = [+$25A] (used reg = )
mov	al,[$25A]
test	al,al
je  	.61D
.61E:
! Debug: and int = const $FF to unsigned short DX = [S+$3A+$10] (used reg = )
mov	al,$12[bp]
! Debug: ne unsigned char = al+0 to unsigned char = [+$25C] (used reg = )
! Debug: expression subtree swapping
cmp	al,[$25C]
je  	.61C
.61D:
! 4329     bios_printf(4, "int13_cdemu: function %02x, emulation not active for DL= %02x\n", *(((Bit8u *)&AX)+1), ( DX & 0x00ff ));
! Debug: and int = const $FF to unsigned short DX = [S+$3A+$10] (used reg = )
mov	al,$12[bp]
! Debug: list unsigned char = al+0 (used reg = )
xor	ah,ah
push	ax
! Debug: list unsigned char AX = [S+$3C+$15] (used reg = )
mov	al,$17[bp]
xor	ah,ah
push	ax
! Debug: list * char = .61F+0 (used reg = )
mov	bx,#.61F
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*8
!BCC_EOS
! 4330     goto int13_fail;
add	sp,#..FFE2+$3A
br 	.FFE2
!BCC_EOS
! 4331   }
! 4332   switch (*(((Bit8u *)&AX)+1)) {
.61C:
mov	al,$17[bp]
br 	.622
! 4333     case 0x00:
! 4334     case 0x09:
.623:
! 4335     case 0x0c:
.624:
! 4336     case 0x0d:
.625:
! 4337     case 0x10:
.626:
! 4338     case 0x11:
.627:
! 4339     case 0x14:
.628:
! 4340     case 0x16:
.629:
! 4341       goto int13_success;
.62A:
add	sp,#..FFE0-..FFE1
br 	.FFE0
!BCC_EOS
! 4342       break;
br 	.620
!BCC_EOS
! 4343     case 0x03:
! 4344     case 0x05:
.62B:
! 4345       *(((Bit8u *)&AX)+1) = (0x03);
.62C:
! Debug: eq int = const 3 to unsigned char AX = [S+$3A+$15] (used reg = )
mov	al,*3
mov	$17[bp],al
!BCC_EOS
! 4346       goto int13_fail_noah;
add	sp,#..FFDF-..FFE1
br 	.FFDF
!BCC_EOS
! 4347       break;
br 	.620
!BCC_EOS
! 4348     case 0x01:
! 4349       status=_read_byte(0x0074, 0x0040);
.62D:
! Debug: list int = const $40 (used reg = )
mov	ax,*$40
push	ax
! Debug: list int = const $74 (used reg = )
mov	ax,*$74
push	ax
! Debug: func () unsigned char = _read_byte+0 (used reg = )
call	__read_byte
add	sp,*4
! Debug: eq unsigned char = al+0 to unsigned char status = [S+$3A-4] (used reg = )
mov	-2[bp],al
!BCC_EOS
! 4350       *(((Bit8u *)&AX)+1) = (status);
! Debug: eq unsigned char status = [S+$3A-4] to unsigned char AX = [S+$3A+$15] (used reg = )
mov	al,-2[bp]
mov	$17[bp],al
!BCC_EOS
! 4351       _write_byte(0, 0x0074, 0x0040);
! Debug: list int = const $40 (used reg = )
mov	ax,*$40
push	ax
! Debug: list int = const $74 (used reg = )
mov	ax,*$74
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: func () void = _write_byte+0 (used reg = )
call	__write_byte
add	sp,*6
!BCC_EOS
! 4352       if (status) goto int13_fail_nostatus;
mov	al,-2[bp]
test	al,al
je  	.62E
.62F:
add	sp,#..FFDE-..FFE1
br 	.FFDE
!BCC_EOS
! 4353       else goto int13_success_noah;
jmp .630
.62E:
add	sp,#..FFDD-..FFE1
br 	.FFDD
!BCC_EOS
! 4354       break;
.630:
br 	.620
!BCC_EOS
! 4355     case 0x02:
! 4356     case 0x04:
.631:
! 4357       vspt = *((Bit16u *)(&((ebda_data_t *) 0)->cdemu.vdevice.spt));
.632:
! Debug: eq unsigned short = [+$26E] to unsigned short vspt = [S+$3A-8] (used reg = )
mov	ax,[$26E]
mov	-6[bp],ax
!BCC_EOS
! 4358       vcylinders = *((Bit16u *)(&((ebda_data_t *) 0)->cdemu.vdevice.cylinders));
! Debug: eq unsigned short = [+$26C] to unsigned short vcylinders = [S+$3A-$A] (used reg = )
mov	ax,[$26C]
mov	-8[bp],ax
!BCC_EOS
! 4359       vheads = *((Bit16u *)(&((ebda_data_t *) 0)->cdemu.vdevice.heads));
! Debug: eq unsigned short = [+$26A] to unsigned short vheads = [S+$3A-6] (used reg = )
mov	ax,[$26A]
mov	-4[bp],ax
!BCC_EOS
! 4360       ilba = *((Bit32u *)(&((ebda_data_t *) 0)->cdemu.ilba));
! Debug: eq unsigned long = [+$260] to unsigned long ilba = [S+$3A-$1C] (used reg = )
mov	ax,[$260]
mov	bx,[$262]
mov	-$1A[bp],ax
mov	-$18[bp],bx
!BCC_EOS
! 4361       sector = ( CX & 0x00ff ) & 0x003f;
! Debug: and int = const $FF to unsigned short CX = [S+$3A+$12] (used reg = )
mov	al,$14[bp]
! Debug: and int = const $3F to unsigned char = al+0 (used reg = )
and	al,*$3F
! Debug: eq unsigned char = al+0 to unsigned short sector = [S+$3A-$E] (used reg = )
xor	ah,ah
mov	-$C[bp],ax
!BCC_EOS
! 4362       cylinder = (( CX & 0x00ff ) & 0x00c0) << 2 | *(((Bit8u *)&CX)+1);
! Debug: and int = const $FF to unsigned short CX = [S+$3A+$12] (used reg = )
mov	al,$14[bp]
! Debug: and int = const $C0 to unsigned char = al+0 (used reg = )
and	al,#$C0
! Debug: sl int = const 2 to unsigned char = al+0 (used reg = )
xor	ah,ah
shl	ax,*1
shl	ax,*1
! Debug: or unsigned char CX = [S+$3A+$13] to unsigned int = ax+0 (used reg = )
or	al,$15[bp]
! Debug: eq unsigned int = ax+0 to unsigned short cylinder = [S+$3A-$10] (used reg = )
mov	-$E[bp],ax
!BCC_EOS
! 4363       head = *(((Bit8u *)&DX)+1);
! Debug: eq unsigned char DX = [S+$3A+$11] to unsigned short head = [S+$3A-$C] (used reg = )
mov	al,$13[bp]
xor	ah,ah
mov	-$A[bp],ax
!BCC_EOS
! 4364       nbsectors = ( AX & 0x00ff );
! Debug: and int = const $FF to unsigned short AX = [S+$3A+$14] (used reg = )
mov	al,$16[bp]
! Debug: eq unsigned char = al+0 to unsigned short nbsectors = [S+$3A-$12] (used reg = )
xor	ah,ah
mov	-$10[bp],ax
!BCC_EOS
! 4365       segment = ES;
! Debug: eq unsigned short ES = [S+$3A+4] to unsigned short segment = [S+$3A-$2C] (used reg = )
mov	ax,6[bp]
mov	-$2A[bp],ax
!BCC_EOS
! 4366       offset = BX;
! Debug: eq unsigned short BX = [S+$3A+$E] to unsigned short offset = [S+$3A-$2E] (used reg = )
mov	ax,$10[bp]
mov	-$2C[bp],ax
!BCC_EOS
! 4367       if(nbsectors==0) goto int13_success;
! Debug: logeq int = const 0 to unsigned short nbsectors = [S+$3A-$12] (used reg = )
mov	ax,-$10[bp]
test	ax,ax
jne 	.633
.634:
add	sp,#..FFE0-..FFE1
br 	.FFE0
!BCC_EOS
! 4368       if ((sector > vspt)
.633:
! 4369        || (cylinder >= vcylinders)
! 4370        || (head >= vheads)) {
! Debug: gt unsigned short vspt = [S+$3A-8] to unsigned short sector = [S+$3A-$E] (used reg = )
mov	ax,-$C[bp]
cmp	ax,-6[bp]
ja  	.636
.638:
! Debug: ge unsigned short vcylinders = [S+$3A-$A] to unsigned short cylinder = [S+$3A-$10] (used reg = )
mov	ax,-$E[bp]
cmp	ax,-8[bp]
jae 	.636
.637:
! Debug: ge unsigned short vheads = [S+$3A-6] to unsigned short head = [S+$3A-$C] (used reg = )
mov	ax,-$A[bp]
cmp	ax,-4[bp]
jb  	.635
.636:
! 4371         goto int13_fail;
add	sp,#..FFE2-..FFE1
br 	.FFE2
!BCC_EOS
! 4372       }
! 4373       if (*(((Bit8u *)&AX)+1) == 0x04) goto int13_success;
.635:
! Debug: logeq int = const 4 to unsigned char AX = [S+$3A+$15] (used reg = )
mov	al,$17[bp]
cmp	al,*4
jne 	.639
.63A:
add	sp,#..FFE0-..FFE1
br 	.FFE0
!BCC_EOS
! 4374       segment = ES+(BX / 16);
.639:
! Debug: div int = const $10 to unsigned short BX = [S+$3A+$E] (used reg = )
mov	ax,$10[bp]
mov	cl,*4
shr	ax,cl
! Debug: add unsigned int = ax+0 to unsigned short ES = [S+$3A+4] (used reg = )
! Debug: expression subtree swapping
add	ax,6[bp]
! Debug: eq unsigned int = ax+0 to unsigned short segment = [S+$3A-$2C] (used reg = )
mov	-$2A[bp],ax
!BCC_EOS
! 4375       offset = BX % 16;
! Debug: mod int = const $10 to unsigned short BX = [S+$3A+$E] (used reg = )
mov	ax,$10[bp]
and	al,*$F
! Debug: eq unsigned char = al+0 to unsigned short offset = [S+$3A-$2E] (used reg = )
xor	ah,ah
mov	-$2C[bp],ax
!BCC_EOS
! 4376       vlba=(
! 4376 (((Bit32u)cylinder*(Bit32u)vheads)+(Bit32u)head)*(Bit32u)vspt)+((Bit32u)(sector-1));
! Debug: sub int = const 1 to unsigned short sector = [S+$3A-$E] (used reg = )
mov	ax,-$C[bp]
! Debug: cast unsigned long = const 0 to unsigned int = ax-1 (used reg = )
dec	ax
xor	bx,bx
push	bx
push	ax
! Debug: cast unsigned long = const 0 to unsigned short vspt = [S+$3E-8] (used reg = )
mov	ax,-6[bp]
xor	bx,bx
push	bx
push	ax
! Debug: cast unsigned long = const 0 to unsigned short head = [S+$42-$C] (used reg = )
mov	ax,-$A[bp]
xor	bx,bx
push	bx
push	ax
! Debug: cast unsigned long = const 0 to unsigned short vheads = [S+$46-6] (used reg = )
mov	ax,-4[bp]
xor	bx,bx
push	bx
push	ax
! Debug: cast unsigned long = const 0 to unsigned short cylinder = [S+$4A-$10] (used reg = )
mov	ax,-$E[bp]
xor	bx,bx
! Debug: mul unsigned long (temp) = [S+$4A-$4A] to unsigned long = bx+0 (used reg = )
lea	di,-$E+..FFE1[bp]
call	lmulul
add	sp,*4
! Debug: add unsigned long (temp) = [S+$46-$46] to unsigned long = bx+0 (used reg = )
lea	di,-$A+..FFE1[bp]
call	laddul
add	sp,*4
! Debug: mul unsigned long (temp) = [S+$42-$42] to unsigned long = bx+0 (used reg = )
lea	di,-6+..FFE1[bp]
call	lmulul
add	sp,*4
! Debug: add unsigned long (temp) = [S+$3E-$3E] to unsigned long = bx+0 (used reg = )
lea	di,-2+..FFE1[bp]
call	laddul
add	sp,*4
! Debug: eq unsigned long = bx+0 to unsigned long vlba = [S+$3A-$18] (used reg = )
mov	-$16[bp],ax
mov	-$14[bp],bx
!BCC_EOS
! 4377       *((Bit8u *)&AX) = (nbsectors);
! Debug: eq unsigned short nbsectors = [S+$3A-$12] to unsigned char AX = [S+$3A+$14] (used reg = )
mov	al,-$10[bp]
mov	$16[bp],al
!BCC_EOS
! 4378       slba = (Bit32u)vlba/4;
! Debug: div unsigned long = const 4 to unsigned long vlba = [S+$3A-$18] (used reg = )
mov	ax,*4
xor	bx,bx
push	bx
push	ax
mov	ax,-$16[bp]
mov	bx,-$14[bp]
lea	di,-2+..FFE1[bp]
call	ldivul
add	sp,*4
! Debug: eq unsigned long = bx+0 to unsigned long slba = [S+$3A-$20] (used reg = )
mov	-$1E[bp],ax
mov	-$1C[bp],bx
!BCC_EOS
! 4379       before= (Bit16u)vlba%4;
! Debug: mod int = const 4 to unsigned short vlba = [S+$3A-$18] (used reg = )
mov	ax,-$16[bp]
and	al,*3
! Debug: eq unsigned char = al+0 to unsigned short before = [S+$3A-$2A] (used reg = )
xor	ah,ah
mov	-$28[bp],ax
!BCC_EOS
! 4380       elba = (Bit32u)(vlba+nbsectors-1)/4;
! Debug: cast unsigned long = const 0 to unsigned short nbsectors = [S+$3A-$12] (used reg = )
mov	ax,-$10[bp]
xor	bx,bx
! Debug: add unsigned long = bx+0 to unsigned long vlba = [S+$3A-$18] (used reg = )
! Debug: expression subtree swapping
lea	di,-$16[bp]
call	laddul
! Debug: sub unsigned long = const 1 to unsigned long = bx+0 (used reg = )
push	bx
push	ax
mov	ax,*1
xor	bx,bx
push	bx
push	ax
mov	ax,-2+..FFE1[bp]
mov	bx,0+..FFE1[bp]
lea	di,-6+..FFE1[bp]
call	lsubul
add	sp,*8
! Debug: cast unsigned long = const 0 to unsigned long = bx+0 (used reg = )
! Debug: div unsigned long = const 4 to unsigned long = bx+0 (used reg = )
push	bx
push	ax
mov	ax,*4
xor	bx,bx
push	bx
push	ax
mov	ax,-2+..FFE1[bp]
mov	bx,0+..FFE1[bp]
lea	di,-6+..FFE1[bp]
call	ldivul
add	sp,*8
! Debug: eq unsigned long = bx+0 to unsigned long elba = [S+$3A-$24] (used reg = )
mov	-$22[bp],ax
mov	-$20[bp],bx
!BCC_EOS
! 4381       _memsetb(0,atacmd,get_SS(),12);
! Debug: list int = const $C (used reg = )
mov	ax,*$C
push	ax
! Debug: func () unsigned short = get_SS+0 (used reg = )
call	_get_SS
! Debug: list unsigned short = ax+0 (used reg = )
push	ax
! Debug: list * unsigned char atacmd = S+$3E-$3A (used reg = )
lea	bx,-$38[bp]
push	bx
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: func () void = _memsetb+0 (used reg = )
call	__memsetb
add	sp,*8
!BCC_EOS
! 4382       atacmd[0]=0x28;
! Debug: eq int = const $28 to unsigned char atacmd = [S+$3A-$3A] (used reg = )
mov	al,*$28
mov	-$38[bp],al
!BCC_EOS
! 4383       count = (Bit16u)(elba-slba)+1;
! Debug: sub unsigned long slba = [S+$3A-$20] to unsigned long elba = [S+$3A-$24] (used reg = )
mov	ax,-$22[bp]
mov	bx,-$20[bp]
lea	di,-$1E[bp]
call	lsubul
! Debug: cast unsigned short = const 0 to unsigned long = bx+0 (used reg = )
! Debug: add int = const 1 to unsigned short = ax+0 (used reg = )
! Debug: eq unsigned int = ax+1 to unsigned short count = [S+$3A-$14] (used reg = )
inc	ax
mov	-$12[bp],ax
!BCC_EOS
! 4384       atacmd[7]=*(((Bit8u *)&count)+1);
! Debug: eq unsigned char count = [S+$3A-$13] to unsigned char atacmd = [S+$3A-$33] (used reg = )
mov	al,-$11[bp]
mov	-$31[bp],al
!BCC_EOS
! 4385       atacmd[8]=*((Bit8u *)&count);
! Debug: eq unsigned char count = [S+$3A-$14] to unsigned char atacmd = [S+$3A-$32] (used reg = )
mov	al,-$12[bp]
mov	-$30[bp],al
!BCC_EOS
! 4386       lba = ilba+slba;
! Debug: add unsigned long slba = [S+$3A-$20] to unsigned long ilba = [S+$3A-$1C] (used reg = )
mov	ax,-$1A[bp]
mov	bx,-$18[bp]
lea	di,-$1E[bp]
call	laddul
! Debug: eq unsigned long = bx+0 to unsigned long lba = [S+$3A-$28] (used reg = )
mov	-$26[bp],ax
mov	-$24[bp],bx
!BCC_EOS
! 4387       atacmd[2]=*(((Bit8u *)&*(((Bit16u *)&lba)+1))+1);
! Debug: eq unsigned char lba = [S+$3A-$25] to unsigned char atacmd = [S+$3A-$38] (used reg = )
mov	al,-$23[bp]
mov	-$36[bp],al
!BCC_EOS
! 4388       atacmd[3]=*((Bit8u *)&*(((Bit16u *)&lba)+1));
! Debug: eq unsigned char lba = [S+$3A-$26] to unsigned char atacmd = [S+$3A-$37] (used reg = )
mov	al,-$24[bp]
mov	-$35[bp],al
!BCC_EOS
! 4389       atacmd[4]=*(((Bit8u *)&*((Bit16u *)&lba))+1);
! Debug: eq unsigned char lba = [S+$3A-$27] to unsigned char atacmd = [S+$3A-$36] (used reg = )
mov	al,-$25[bp]
mov	-$34[bp],al
!BCC_EOS
! 4390       atacmd[5]=*((Bit8u *)&lba);
! Debug: eq unsigned char lba = [S+$3A-$28] to unsigned char atacmd = [S+$3A-$35] (used reg = )
mov	al,-$26[bp]
mov	-$33[bp],al
!BCC_EOS
! 4391       if((status = ata_cmd_packet(device, 12, get_SS(), atacmd, before*512, nbsectors*512L, 0x01, segment,offset)) != 0) {
! Debug: list unsigned short offset = [S+$3A-$2E] (used reg = )
push	-$2C[bp]
! Debug: list unsigned short segment = [S+$3C-$2C] (used reg = )
push	-$2A[bp]
! Debug: list int = const 1 (used reg = )
mov	ax,*1
push	ax
! Debug: cast unsigned long = const 0 to unsigned short nbsectors = [S+$40-$12] (used reg = )
mov	ax,-$10[bp]
xor	bx,bx
! Debug: mul long = const $200 to unsigned long = bx+0 (used reg = )
push	bx
push	ax
mov	ax,#$200
xor	bx,bx
push	bx
push	ax
mov	ax,-8+..FFE1[bp]
mov	bx,-6+..FFE1[bp]
lea	di,-$C+..FFE1[bp]
call	lmulul
add	sp,*8
! Debug: list unsigned long = bx+0 (used reg = )
push	bx
push	ax
! Debug: mul int = const $200 to unsigned short before = [S+$44-$2A] (used reg = )
mov	ax,-$28[bp]
mov	cx,#$200
imul	cx
! Debug: list unsigned int = ax+0 (used reg = )
push	ax
! Debug: list * unsigned char atacmd = S+$46-$3A (used reg = )
lea	bx,-$38[bp]
push	bx
! Debug: func () unsigned short = get_SS+0 (used reg = )
call	_get_SS
! Debug: list unsigned short = ax+0 (used reg = )
push	ax
! Debug: list int = const $C (used reg = )
mov	ax,*$C
push	ax
! Debug: list unsigned char device = [S+$4C-3] (used reg = )
mov	al,-1[bp]
xor	ah,ah
push	ax
! Debug: func () unsigned short = ata_cmd_packet+0 (used reg = )
call	_ata_cmd_packet
add	sp,*$14
! Debug: eq unsigned short = ax+0 to unsigned char status = [S+$3A-4] (used reg = )
mov	-2[bp],al
! Debug: ne int = const 0 to unsigned char = al+0 (used reg = )
test	al,al
je  	.63B
.63C:
! 4392         bios_printf(4, "int13_cdemu: function %02x, error %02x !\n",*(((Bit8u *)&AX)+1),status);
! Debug: list unsigned char status = [S+$3A-4] (used reg = )
mov	al,-2[bp]
xor	ah,ah
push	ax
! Debug: list unsigned char AX = [S+$3C+$15] (used reg = )
mov	al,$17[bp]
xor	ah,ah
push	ax
! Debug: list * char = .63D+0 (used reg = )
mov	bx,#.63D
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*8
!BCC_EOS
! 4393         *(((Bit8u *)&AX)+1) = (0x02);
! Debug: eq int = const 2 to unsigned char AX = [S+$3A+$15] (used reg = )
mov	al,*2
mov	$17[bp],al
!BCC_EOS
! 4394         *((Bit8u *)&AX) = (0);
! Debug: eq int = const 0 to unsigned char AX = [S+$3A+$14] (used reg = )
xor	al,al
mov	$16[bp],al
!BCC_EOS
! 4395         goto int13_fail_noah;
add	sp,#..FFDF-..FFE1
br 	.FFDF
!BCC_EOS
! 4396       }
! 4397       goto int13_success;
.63B:
add	sp,#..FFE0-..FFE1
br 	.FFE0
!BCC_EOS
! 4398       break;
br 	.620
!BCC_EOS
! 4399     case 0x08:
! 4400       vspt=*((Bit16u *)(&((ebda_data_t *) 0)->cdemu.vdevice.spt));
.63E:
! Debug: eq unsigned short = [+$26E] to unsigned short vspt = [S+$3A-8] (used reg = )
mov	ax,[$26E]
mov	-6[bp],ax
!BCC_EOS
! 4401       vcylinders=*((Bit16u *)(&((ebda_data_t *) 0)->cdemu.vdevice.cylinders)) - 1;
! Debug: sub int = const 1 to unsigned short = [+$26C] (used reg = )
mov	ax,[$26C]
! Debug: eq unsigned int = ax-1 to unsigned short vcylinders = [S+$3A-$A] (used reg = )
dec	ax
mov	-8[bp],ax
!BCC_EOS
! 4402       vheads=*((Bit16u *)(&((ebda_data_t *) 0)->cdemu.vdevice.heads)) - 1;
! Debug: sub int = const 1 to unsigned short = [+$26A] (used reg = )
mov	ax,[$26A]
! Debug: eq unsigned int = ax-1 to unsigned short vheads = [S+$3A-6] (used reg = )
dec	ax
mov	-4[bp],ax
!BCC_EOS
! 4403       *((Bit8u *)&AX) = (0x00);
! Debug: eq int = const 0 to unsigned char AX = [S+$3A+$14] (used reg = )
xor	al,al
mov	$16[bp],al
!BCC_EOS
! 4404       *((Bit8u *)&BX) = (0x00);
! Debug: eq int = const 0 to unsigned char BX = [S+$3A+$E] (used reg = )
xor	al,al
mov	$10[bp],al
!BCC_EOS
! 4405       *(((Bit8u *)&CX)+1) = (vcylinders & 0xff);
! Debug: and int = const $FF to unsigned short vcylinders = [S+$3A-$A] (used reg = )
mov	al,-8[bp]
! Debug: eq unsigned char = al+0 to unsigned char CX = [S+$3A+$13] (used reg = )
mov	$15[bp],al
!BCC_EOS
! 4406       *((Bit8u *)&CX) = (((vcylinders >> 2) & 0xc0) | (vspt & 0x3f));
! Debug: and int = const $3F to unsigned short vspt = [S+$3A-8] (used reg = )
mov	al,-6[bp]
and	al,*$3F
push	ax
! Debug: sr int = const 2 to unsigned short vcylinders = [S+$3C-$A] (used reg = )
mov	ax,-8[bp]
shr	ax,*1
shr	ax,*1
! Debug: and int = const $C0 to unsigned int = ax+0 (used reg = )
and	al,#$C0
! Debug: or unsigned char (temp) = [S+$3C-$3C] to unsigned char = al+0 (used reg = )
or	al,0+..FFE1[bp]
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char CX = [S+$3A+$12] (used reg = )
mov	$14[bp],al
!BCC_EOS
! 4407       *(((Bit8u *)&DX)+1) = (vheads);
! Debug: eq unsigned short vheads = [S+$3A-6] to unsigned char DX = [S+$3A+$11] (used reg = )
mov	al,-4[bp]
mov	$13[bp],al
!BCC_EOS
! 4408       *((Bit8u *)&DX) = (0x02);
! Debug: eq int = const 2 to unsigned char DX = [S+$3A+$10] (used reg = )
mov	al,*2
mov	$12[bp],al
!BCC_EOS
! 4409       switch(*((Bit8u *)(&((ebda_data_t *) 0)->cdemu.media))) {
mov	al,[$25B]
jmp .641
! 4410         case 0x01: *((Bit8u *)&BX) = (0x02); break;
.642:
! Debug: eq int = const 2 to unsigned char BX = [S+$3A+$E] (used reg = )
mov	al,*2
mov	$10[bp],al
!BCC_EOS
jmp .63F
!BCC_EOS
! 4411         case 0x02: *((Bit8u *)&BX) = (0x04); break;
.643:
! Debug: eq int = const 4 to unsigned char BX = [S+$3A+$E] (used reg = )
mov	al,*4
mov	$10[bp],al
!BCC_EOS
jmp .63F
!BCC_EOS
! 4412         case 0x03: *((Bit8u *)&BX) = (0x06); break;
.644:
! Debug: eq int = const 6 to unsigned char BX = [S+$3A+$E] (used reg = )
mov	al,*6
mov	$10[bp],al
!BCC_EOS
jmp .63F
!BCC_EOS
! 4413     }
! 4414 #asm
jmp .63F
.641:
sub	al,*1
je 	.642
sub	al,*1
je 	.643
sub	al,*1
je 	.644
.63F:
!BCC_EOS
!BCC_ASM
_int13_cdemu.BP	set	$44
.int13_cdemu.BP	set	$C
_int13_cdemu.CS	set	$52
.int13_cdemu.CS	set	$1A
_int13_cdemu.nbsectors	set	$28
.int13_cdemu.nbsectors	set	-$10
_int13_cdemu.count	set	$26
.int13_cdemu.count	set	-$12
_int13_cdemu.CX	set	$4C
.int13_cdemu.CX	set	$14
_int13_cdemu.elba	set	$16
.int13_cdemu.elba	set	-$22
_int13_cdemu.segment	set	$E
.int13_cdemu.segment	set	-$2A
_int13_cdemu.DI	set	$40
.int13_cdemu.DI	set	8
_int13_cdemu.FLAGS	set	$54
.int13_cdemu.FLAGS	set	$1C
_int13_cdemu.vcylinders	set	$30
.int13_cdemu.vcylinders	set	-8
_int13_cdemu.sector	set	$2C
.int13_cdemu.sector	set	-$C
_int13_cdemu.DS	set	$3C
.int13_cdemu.DS	set	4
_int13_cdemu.head	set	$2E
.int13_cdemu.head	set	-$A
_int13_cdemu.cylinder	set	$2A
.int13_cdemu.cylinder	set	-$E
_int13_cdemu.DX	set	$4A
.int13_cdemu.DX	set	$12
_int13_cdemu.device	set	$37
.int13_cdemu.device	set	-1
_int13_cdemu.ES	set	$3E
.int13_cdemu.ES	set	6
_int13_cdemu.vspt	set	$32
.int13_cdemu.vspt	set	-6
_int13_cdemu.vlba	set	$22
.int13_cdemu.vlba	set	-$16
_int13_cdemu.SI	set	$42
.int13_cdemu.SI	set	$A
_int13_cdemu.IP	set	$50
.int13_cdemu.IP	set	$18
_int13_cdemu.lba	set	$12
.int13_cdemu.lba	set	-$26
_int13_cdemu.status	set	$36
.int13_cdemu.status	set	-2
_int13_cdemu.atacmd	set	0
.int13_cdemu.atacmd	set	-$38
_int13_cdemu.AX	set	$4E
.int13_cdemu.AX	set	$16
_int13_cdemu.ilba	set	$1E
.int13_cdemu.ilba	set	-$1A
_int13_cdemu.before	set	$10
.int13_cdemu.before	set	-$28
_int13_cdemu.offset	set	$C
.int13_cdemu.offset	set	-$2C
_int13_cdemu.slba	set	$1A
.int13_cdemu.slba	set	-$1E
_int13_cdemu.SP	set	$46
.int13_cdemu.SP	set	$E
_int13_cdemu.vheads	set	$34
.int13_cdemu.vheads	set	-4
_int13_cdemu.BX	set	$48
.int13_cdemu.BX	set	$10
      push bp
      mov bp, sp
      mov ax, #diskette_param_table2
      mov _int13_cdemu.DI+2[bp], ax
      mov _int13_cdemu.ES+2[bp], cs
      pop bp
! 4421 endasm
!BCC_ENDASM
!BCC_EOS
! 4422       goto int13_success;
add	sp,#..FFE0-..FFE1
br 	.FFE0
!BCC_EOS
! 4423       break;
br 	.620
!BCC_EOS
! 4424     case 0x15:
! 4425       *(((Bit8u *)&AX)+1) = (0x03);
.645:
! Debug: eq int = const 3 to unsigned char AX = [S+$3A+$15] (used reg = )
mov	al,*3
mov	$17[bp],al
!BCC_EOS
! 4426       goto int13_success_noah;
add	sp,#..FFDD-..FFE1
br 	.FFDD
!BCC_EOS
! 4427       break;
br 	.620
!BCC_EOS
! 4428     case 0x0a:
! 4429     case 0x0b:
.646:
! 4430     case 0x18:
.647:
! 4431     
! 4431 case 0x41:
.648:
! 4432     case 0x42:
.649:
! 4433     case 0x43:
.64A:
! 4434     case 0x44:
.64B:
! 4435     case 0x45:
.64C:
! 4436     case 0x46:
.64D:
! 4437     case 0x47:
.64E:
! 4438     case 0x48:
.64F:
! 4439     case 0x49:
.650:
! 4440     case 0x4e:
.651:
! 4441     case 0x50:
.652:
! 4442     default:
.653:
! 4443       bios_printf(4, "int13_cdemu function AH=%02x unsupported, returns fail\n", *(((Bit8u *)&AX)+1));
.654:
! Debug: list unsigned char AX = [S+$3A+$15] (used reg = )
mov	al,$17[bp]
xor	ah,ah
push	ax
! Debug: list * char = .655+0 (used reg = )
mov	bx,#.655
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*6
!BCC_EOS
! 4444       goto int13_fail;
add	sp,#..FFE2-..FFE1
jmp .FFE2
!BCC_EOS
! 4445       break;
jmp .620
!BCC_EOS
! 4446   }
! 4447 int13_fail:
jmp .620
.622:
sub	al,*0
jb 	.654
cmp	al,*$18
ja  	.656
xor	ah,ah
shl	ax,*1
mov	bx,ax
seg	cs
br	.657[bx]
.657:
.word	.623
.word	.62D
.word	.631
.word	.62B
.word	.632
.word	.62C
.word	.654
.word	.654
.word	.63E
.word	.624
.word	.646
.word	.647
.word	.625
.word	.626
.word	.654
.word	.654
.word	.627
.word	.628
.word	.654
.word	.654
.word	.629
.word	.645
.word	.62A
.word	.654
.word	.648
.656:
sub	al,*$41
jb 	.654
cmp	al,*$F
ja  	.658
xor	ah,ah
shl	ax,*1
mov	bx,ax
seg	cs
br	.659[bx]
.659:
.word	.649
.word	.64A
.word	.64B
.word	.64C
.word	.64D
.word	.64E
.word	.64F
.word	.650
.word	.651
.word	.654
.word	.654
.word	.654
.word	.654
.word	.652
.word	.654
.word	.653
.658:
br 	.654
.620:
..FFE1	=	-$3A
.FFE2:
..FFE2	=	-$3A
! 4448   *(((Bit8u *)&AX)+1) = (0x01);
! Debug: eq int = const 1 to unsigned char AX = [S+$3A+$15] (used reg = )
mov	al,*1
mov	$17[bp],al
!BCC_EOS
! 4449 int13_fail_noah:
.FFDF:
..FFDF	=	-$3A
! 4450   _write_byte(*(((Bit8u *)&AX)+1), 0x0074, 0x0040);
! Debug: list int = const $40 (used reg = )
mov	ax,*$40
push	ax
! Debug: list int = const $74 (used reg = )
mov	ax,*$74
push	ax
! Debug: list unsigned char AX = [S+$3E+$15] (used reg = )
mov	al,$17[bp]
xor	ah,ah
push	ax
! Debug: func () void = _write_byte+0 (used reg = )
call	__write_byte
add	sp,*6
!BCC_EOS
! 4451 int13_fail_nostatus:
.FFDE:
..FFDE	=	-$3A
! 4452   FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$3A+$1A] (used reg = )
mov	ax,$1C[bp]
or	al,*1
mov	$1C[bp],ax
!BCC_EOS
! 4453   return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 4454 int13_success:
.FFE0:
..FFE0	=	-$3A
! 4455   *(((Bit8u *)&AX)+1) = (0x00);
! Debug: eq int = const 0 to unsigned char AX = [S+$3A+$15] (used reg = )
xor	al,al
mov	$17[bp],al
!BCC_EOS
! 4456 int13_success_noah:
.FFDD:
..FFDD	=	-$3A
! 4457   _write_byte(0x00, 0x0074, 0x0040);
! Debug: list int = const $40 (used reg = )
mov	ax,*$40
push	ax
! Debug: list int = const $74 (used reg = )
mov	ax,*$74
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: func () void = _write_byte+0 (used reg = )
call	__write_byte
add	sp,*6
!BCC_EOS
! 4458   FLAGS &= 0xfffe;
! Debug: andab unsigned int = const $FFFE to unsigned short FLAGS = [S+$3A+$1A] (used reg = )
mov	ax,$1C[bp]
and	al,#$FE
mov	$1C[bp],ax
!BCC_EOS
! 4459 }
mov	sp,bp
pop	bp
ret
! 4460 void floppy_reset_controller()
! Register BX used in function int13_cdemu
! 4461 {
export	_floppy_reset_controller
_floppy_reset_controller:
! 4462   Bit8u val8;
!BCC_EOS
! 4463   val8 = inb(0x03f2);
push	bp
mov	bp,sp
dec	sp
dec	sp
! Debug: list int = const $3F2 (used reg = )
mov	ax,#$3F2
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char val8 = [S+4-3] (used reg = )
mov	-1[bp],al
!BCC_EOS
! 4464   outb(0x03f2, val8 & ~0x04);
! Debug: and int = const -5 to unsigned char val8 = [S+4-3] (used reg = )
mov	al,-1[bp]
and	al,#$FB
! Debug: list unsigned char = al+0 (used reg = )
xor	ah,ah
push	ax
! Debug: list int = const $3F2 (used reg = )
mov	ax,#$3F2
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4465   outb(0x03f2, val8 | 0x04);
! Debug: or int = const 4 to unsigned char val8 = [S+4-3] (used reg = )
mov	al,-1[bp]
or	al,*4
! Debug: list unsigned char = al+0 (used reg = )
xor	ah,ah
push	ax
! Debug: list int = const $3F2 (used reg = )
mov	ax,#$3F2
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4466   do {
.65C:
! 4467     val8 = inb(0x03f4);
! Debug: list int = const $3F4 (used reg = )
mov	ax,#$3F4
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char val8 = [S+4-3] (used reg = )
mov	-1[bp],al
!BCC_EOS
! 4468   } while ((val8 & 0xc0) != 0x80);
.65B:
! Debug: and int = const $C0 to unsigned char val8 = [S+4-3] (used reg = )
mov	al,-1[bp]
and	al,#$C0
! Debug: ne int = const $80 to unsigned char = al+0 (used reg = )
cmp	al,#$80
jne	.65C
.65D:
!BCC_EOS
! 4469 }
.65A:
mov	sp,bp
pop	bp
ret
! 4470 void floppy_prepare_controller(drive)
! 4471   Bit16u drive;
export	_floppy_prepare_controller
_floppy_prepare_controller:
!BCC_EOS
! 4472 {
! 4473   Bit8u val8, dor, prev_reset;
!BCC_EOS
! 4474   val8 = *((Bit8u *)(0x003e));
push	bp
mov	bp,sp
add	sp,*-4
! Debug: eq unsigned char = [+$3E] to unsigned char val8 = [S+6-3] (used reg = )
mov	al,[$3E]
mov	-1[bp],al
!BCC_EOS
! 4475   val8 &= 0x7f;
! Debug: andab int = const $7F to unsigned char val8 = [S+6-3] (used reg = )
mov	al,-1[bp]
and	al,*$7F
mov	-1[bp],al
!BCC_EOS
! 4476   *((Bit8u *)(0x003e)) = (val8);
! Debug: eq unsigned char val8 = [S+6-3] to unsigned char = [+$3E] (used reg = )
mov	al,-1[bp]
mov	[$3E],al
!BCC_EOS
! 4477   prev_reset = inb(0x03f2) & 0x04;
! Debug: list int = const $3F2 (used reg = )
mov	ax,#$3F2
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: and int = const 4 to unsigned char = al+0 (used reg = )
and	al,*4
! Debug: eq unsigned char = al+0 to unsigned char prev_reset = [S+6-5] (used reg = )
mov	-3[bp],al
!BCC_EOS
! 4478   if (drive)
mov	ax,4[bp]
test	ax,ax
je  	.65E
.65F:
! 4479     dor = 0x20;
! Debug: eq int = const $20 to unsigned char dor = [S+6-4] (used reg = )
mov	al,*$20
mov	-2[bp],al
!BCC_EOS
! 4480   else
! 4481     dor = 0x10;
jmp .660
.65E:
! Debug: eq int = const $10 to unsigned char dor = [S+6-4] (used reg = )
mov	al,*$10
mov	-2[bp],al
!BCC_EOS
! 4482   dor |= 0x0c;
.660:
! Debug: orab int = const $C to unsigned char dor = [S+6-4] (used reg = )
mov	al,-2[bp]
or	al,*$C
mov	-2[bp],al
!BCC_EOS
! 4483   dor |= drive;
! Debug: orab unsigned short drive = [S+6+2] to unsigned char dor = [S+6-4] (used reg = )
mov	ax,4[bp]
or	al,-2[bp]
mov	-2[bp],al
!BCC_EOS
! 4484   outb(0x03f2, dor);
! Debug: list unsigned char dor = [S+6-4] (used reg = )
mov	al,-2[bp]
xor	ah,ah
push	ax
! Debug: list int = const $3F2 (used reg = )
mov	ax,#$3F2
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4485   *((Bit8u *)(0x40)) = (37);
! Debug: eq int = const $25 to unsigned char = [+$40] (used reg = )
mov	al,*$25
mov	[$40],al
!BCC_EOS
! 4486   do {
.663:
! 4487     val8 = inb(0x03f4);
! Debug: list int = const $3F4 (used reg = )
mov	ax,#$3F4
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char val8 = [S+6-3] (used reg = )
mov	-1[bp],al
!BCC_EOS
! 4488   } while ( (val8 & 0xc0) != 0x80 );
.662:
! Debug: and int = const $C0 to unsigned char val8 = [S+6-3] (used reg = )
mov	al,-1[bp]
and	al,#$C0
! Debug: ne int = const $80 to unsigned char = al+0 (used reg = )
cmp	al,#$80
jne	.663
.664:
!BCC_EOS
! 4489   if (prev_reset == 0) {
.661:
! Debug: logeq int = const 0 to unsigned char prev_reset = [S+6-5] (used reg = )
mov	al,-3[bp]
test	al,al
jne 	.665
.666:
! 4490 #asm
!BCC_EOS
!BCC_ASM
_floppy_prepare_controller.dor	set	2
.floppy_prepare_controller.dor	set	-2
_floppy_prepare_controller.prev_reset	set	1
.floppy_prepare_controller.prev_reset	set	-3
_floppy_prepare_controller.val8	set	3
.floppy_prepare_controller.val8	set	-1
_floppy_prepare_controller.drive	set	8
.floppy_prepare_controller.drive	set	4
    sti
! 4492 endasm
!BCC_ENDASM
!BCC_EOS
! 4493     do {
.669:
! 4494       val8 = *((Bit8u *)(0x003e));
! Debug: eq unsigned char = [+$3E] to unsigned char val8 = [S+6-3] (used reg = )
mov	al,[$3E]
mov	-1[bp],al
!BCC_EOS
! 4495     } while ( (val8 & 0x80) == 0 );
.668:
! Debug: and int = const $80 to unsigned char val8 = [S+6-3] (used reg = )
mov	al,-1[bp]
and	al,#$80
! Debug: logeq int = const 0 to unsigned char = al+0 (used reg = )
test	al,al
je 	.669
.66A:
!BCC_EOS
! 4496     val8 &= 0x7f;
.667:
! Debug: andab int = const $7F to unsigned char val8 = [S+6-3] (used reg = )
mov	al,-1[bp]
and	al,*$7F
mov	-1[bp],al
!BCC_EOS
! 4497 #asm
!BCC_EOS
!BCC_ASM
_floppy_prepare_controller.dor	set	2
.floppy_prepare_controller.dor	set	-2
_floppy_prepare_controller.prev_reset	set	1
.floppy_prepare_controller.prev_reset	set	-3
_floppy_prepare_controller.val8	set	3
.floppy_prepare_controller.val8	set	-1
_floppy_prepare_controller.drive	set	8
.floppy_prepare_controller.drive	set	4
    cli
! 4499 endasm
!BCC_ENDASM
!BCC_EOS
! 4500     *((Bit8u *)(0x003e)) = (val8);
! Debug: eq unsigned char val8 = [S+6-3] to unsigned char = [+$3E] (used reg = )
mov	al,-1[bp]
mov	[$3E],al
!BCC_EOS
! 4501   }
! 4502 }
.665:
mov	sp,bp
pop	bp
ret
! 4503   bx_bool
! 4504 floppy_media_known(drive)
! 4505   Bit16u drive;
export	_floppy_media_known
_floppy_media_known:
!BCC_EOS
! 4506 {
! 4507   Bit8u val8;
!BCC_EOS
! 4508   Bit16u media_state_offset;
!BCC_EOS
! 4509   val8 = *((Bit8u *)(0x003e));
push	bp
mov	bp,sp
add	sp,*-4
! Debug: eq unsigned char = [+$3E] to unsigned char val8 = [S+6-3] (used reg = )
mov	al,[$3E]
mov	-1[bp],al
!BCC_EOS
! 4510   if (drive)
mov	ax,4[bp]
test	ax,ax
je  	.66B
.66C:
! 4511     val8 >>= 1;
! Debug: srab int = const 1 to unsigned char val8 = [S+6-3] (used reg = )
mov	al,-1[bp]
xor	ah,ah
shr	ax,*1
mov	-1[bp],al
!BCC_EOS
! 4512   val8 &= 0x01;
.66B:
! Debug: andab int = const 1 to unsigned char val8 = [S+6-3] (used reg = )
mov	al,-1[bp]
and	al,*1
mov	-1[bp],al
!BCC_EOS
! 4513   if (val8 == 0)
! Debug: logeq int = const 0 to unsigned char val8 = [S+6-3] (used reg = )
mov	al,-1[bp]
test	al,al
jne 	.66D
.66E:
! 4514     return(0);
xor	ax,ax
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 4515   media_state_offset = 0x0090;
.66D:
! Debug: eq int = const $90 to unsigned short media_state_offset = [S+6-6] (used reg = )
mov	ax,#$90
mov	-4[bp],ax
!BCC_EOS
! 4516   if (drive)
mov	ax,4[bp]
test	ax,ax
je  	.66F
.670:
! 4517     media_state_offset += 1;
! Debug: addab int = const 1 to unsigned short media_state_offset = [S+6-6] (used reg = )
mov	ax,-4[bp]
inc	ax
mov	-4[bp],ax
!BCC_EOS
! 4518   val8 = *((Bit8u *)(media_state_offset));
.66F:
mov	bx,-4[bp]
! Debug: eq unsigned char = [bx+0] to unsigned char val8 = [S+6-3] (used reg = )
mov	al,[bx]
mov	-1[bp],al
!BCC_EOS
! 4519   val8 = (val8 >> 4) & 0x01;
! Debug: sr int = const 4 to unsigned char val8 = [S+6-3] (used reg = )
mov	al,-1[bp]
xor	ah,ah
mov	cl,*4
shr	ax,cl
! Debug: and int = const 1 to unsigned int = ax+0 (used reg = )
and	al,*1
! Debug: eq unsigned char = al+0 to unsigned char val8 = [S+6-3] (used reg = )
mov	-1[bp],al
!BCC_EOS
! 4520   if (val8 == 0)
! Debug: logeq int = const 0 to unsigned char val8 = [S+6-3] (used reg = )
mov	al,-1[bp]
test	al,al
jne 	.671
.672:
! 4521     return(0);
xor	ax,ax
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 4522   return(1);
.671:
mov	ax,*1
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 4523 }
! 4524   bx_bool
! Register BX used in function floppy_media_known
! 4525 floppy_media_sense(drive)
! 4526   Bit16u drive;
export	_floppy_media_sense
_floppy_media_sense:
!BCC_EOS
! 4527 {
! 4528   bx_bool retval;
!BCC_EOS
! 4529   Bit16u media_state_offset;
!BCC_EOS
! 4530   Bit8u drive_type, config_data, media_state;
!BCC_EOS
! 4531   if (floppy_drive_recal(drive) == 0) {
push	bp
mov	bp,sp
add	sp,*-8
! Debug: list unsigned short drive = [S+$A+2] (used reg = )
push	4[bp]
! Debug: func () unsigned short = floppy_drive_recal+0 (used reg = )
call	_floppy_drive_recal
inc	sp
inc	sp
! Debug: logeq int = const 0 to unsigned short = ax+0 (used reg = )
test	ax,ax
jne 	.673
.674:
! 4532     return(0);
xor	ax,ax
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 4533   }
! 4534   drive_type = inb_cmos(0x10);
.673:
! Debug: list int = const $10 (used reg = )
mov	ax,*$10
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char drive_type = [S+$A-7] (used reg = )
mov	-5[bp],al
!BCC_EOS
! 4535   if
! 4535  (drive == 0)
! Debug: logeq int = const 0 to unsigned short drive = [S+$A+2] (used reg = )
mov	ax,4[bp]
test	ax,ax
jne 	.675
.676:
! 4536     drive_type >>= 4;
! Debug: srab int = const 4 to unsigned char drive_type = [S+$A-7] (used reg = )
mov	al,-5[bp]
xor	ah,ah
mov	cl,*4
shr	ax,cl
mov	-5[bp],al
!BCC_EOS
! 4537   else
! 4538     drive_type &= 0x0f;
jmp .677
.675:
! Debug: andab int = const $F to unsigned char drive_type = [S+$A-7] (used reg = )
mov	al,-5[bp]
and	al,*$F
mov	-5[bp],al
!BCC_EOS
! 4539   switch(drive_type) {
.677:
mov	al,-5[bp]
jmp .67A
! 4540     case 1:
! 4541     case 2:
.67B:
! 4542       config_data = 0x00;
.67C:
! Debug: eq int = const 0 to unsigned char config_data = [S+$A-8] (used reg = )
xor	al,al
mov	-6[bp],al
!BCC_EOS
! 4543       media_state = 0x25;
! Debug: eq int = const $25 to unsigned char media_state = [S+$A-9] (used reg = )
mov	al,*$25
mov	-7[bp],al
!BCC_EOS
! 4544       retval = 1;
! Debug: eq int = const 1 to unsigned short retval = [S+$A-4] (used reg = )
mov	ax,*1
mov	-2[bp],ax
!BCC_EOS
! 4545       break;
jmp .678
!BCC_EOS
! 4546     case 3:
! 4547     case 4:
.67D:
! 4548       config_data = 0x00;
.67E:
! Debug: eq int = const 0 to unsigned char config_data = [S+$A-8] (used reg = )
xor	al,al
mov	-6[bp],al
!BCC_EOS
! 4549       media_state = 0x17;
! Debug: eq int = const $17 to unsigned char media_state = [S+$A-9] (used reg = )
mov	al,*$17
mov	-7[bp],al
!BCC_EOS
! 4550       retval = 1;
! Debug: eq int = const 1 to unsigned short retval = [S+$A-4] (used reg = )
mov	ax,*1
mov	-2[bp],ax
!BCC_EOS
! 4551       break;
jmp .678
!BCC_EOS
! 4552     case 5:
! 4553       config_data = 0xCC;
.67F:
! Debug: eq int = const $CC to unsigned char config_data = [S+$A-8] (used reg = )
mov	al,#$CC
mov	-6[bp],al
!BCC_EOS
! 4554       media_state = 0xD7;
! Debug: eq int = const $D7 to unsigned char media_state = [S+$A-9] (used reg = )
mov	al,#$D7
mov	-7[bp],al
!BCC_EOS
! 4555       retval = 1;
! Debug: eq int = const 1 to unsigned short retval = [S+$A-4] (used reg = )
mov	ax,*1
mov	-2[bp],ax
!BCC_EOS
! 4556       break;
jmp .678
!BCC_EOS
! 4557     case 6:
! 4558     case 7:
.680:
! 4559     case 8:
.681:
! 4560       config_data = 0x00;
.682:
! Debug: eq int = const 0 to unsigned char config_data = [S+$A-8] (used reg = )
xor	al,al
mov	-6[bp],al
!BCC_EOS
! 4561       media_state = 0x27;
! Debug: eq int = const $27 to unsigned char media_state = [S+$A-9] (used reg = )
mov	al,*$27
mov	-7[bp],al
!BCC_EOS
! 4562       retval = 1;
! Debug: eq int = const 1 to unsigned short retval = [S+$A-4] (used reg = )
mov	ax,*1
mov	-2[bp],ax
!BCC_EOS
! 4563       break;
jmp .678
!BCC_EOS
! 4564     default:
! 4565       config_data = 0x00;
.683:
! Debug: eq int = const 0 to unsigned char config_data = [S+$A-8] (used reg = )
xor	al,al
mov	-6[bp],al
!BCC_EOS
! 4566       media_state = 0x00;
! Debug: eq int = const 0 to unsigned char media_state = [S+$A-9] (used reg = )
xor	al,al
mov	-7[bp],al
!BCC_EOS
! 4567       retval = 0;
! Debug: eq int = const 0 to unsigned short retval = [S+$A-4] (used reg = )
xor	ax,ax
mov	-2[bp],ax
!BCC_EOS
! 4568       break;
jmp .678
!BCC_EOS
! 4569   }
! 4570   if (drive == 0)
jmp .678
.67A:
sub	al,*1
jb 	.683
cmp	al,*7
ja  	.684
xor	ah,ah
shl	ax,*1
mov	bx,ax
seg	cs
br	.685[bx]
.685:
.word	.67B
.word	.67C
.word	.67D
.word	.67E
.word	.67F
.word	.680
.word	.681
.word	.682
.684:
jmp	.683
.678:
..FFDC	=	-$A
! Debug: logeq int = const 0 to unsigned short drive = [S+$A+2] (used reg = )
mov	ax,4[bp]
test	ax,ax
jne 	.686
.687:
! 4571     media_state_offset = 0x90;
! Debug: eq int = const $90 to unsigned short media_state_offset = [S+$A-6] (used reg = )
mov	ax,#$90
mov	-4[bp],ax
!BCC_EOS
! 4572   else
! 4573     media_state_offset = 0x91;
jmp .688
.686:
! Debug: eq int = const $91 to unsigned short media_state_offset = [S+$A-6] (used reg = )
mov	ax,#$91
mov	-4[bp],ax
!BCC_EOS
! 4574   *((Bit8u *)(0x008B)) = (config_data);
.688:
! Debug: eq unsigned char config_data = [S+$A-8] to unsigned char = [+$8B] (used reg = )
mov	al,-6[bp]
mov	[$8B],al
!BCC_EOS
! 4575   *((Bit8u *)(media_state_offset)) = (media_state);
mov	bx,-4[bp]
! Debug: eq unsigned char media_state = [S+$A-9] to unsigned char = [bx+0] (used reg = )
mov	al,-7[bp]
mov	[bx],al
!BCC_EOS
! 4576   return(retval);
mov	ax,-2[bp]
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 4577 }
! 4578   bx_bool
! Register BX used in function floppy_media_sense
! 4579 floppy_drive_recal(drive)
! 4580   Bit16u drive;
export	_floppy_drive_recal
_floppy_drive_recal:
!BCC_EOS
! 4581 {
! 4582   Bit8u val8;
!BCC_EOS
! 4583   Bit16u curr_cyl_offset;
!BCC_EOS
! 4584   floppy_prepare_controller(drive);
push	bp
mov	bp,sp
add	sp,*-4
! Debug: list unsigned short drive = [S+6+2] (used reg = )
push	4[bp]
! Debug: func () void = floppy_prepare_controller+0 (used reg = )
call	_floppy_prepare_controller
inc	sp
inc	sp
!BCC_EOS
! 4585   outb(0x03f5, 0x07);
! Debug: list int = const 7 (used reg = )
mov	ax,*7
push	ax
! Debug: list int = const $3F5 (used reg = )
mov	ax,#$3F5
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4586   outb(0x03f5, drive);
! Debug: list unsigned short drive = [S+6+2] (used reg = )
push	4[bp]
! Debug: list int = const $3F5 (used reg = )
mov	ax,#$3F5
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4587 #asm
!BCC_EOS
!BCC_ASM
_floppy_drive_recal.curr_cyl_offset	set	0
.floppy_drive_recal.curr_cyl_offset	set	-4
_floppy_drive_recal.val8	set	3
.floppy_drive_recal.val8	set	-1
_floppy_drive_recal.drive	set	8
.floppy_drive_recal.drive	set	4
  sti
! 4589 endasm
!BCC_ENDASM
!BCC_EOS
! 4590   do {
.68B:
! 4591     val8 = (*((Bit8u *)(0x003e)) & 0x80);
! Debug: and int = const $80 to unsigned char = [+$3E] (used reg = )
mov	al,[$3E]
and	al,#$80
! Debug: eq unsigned char = al+0 to unsigned char val8 = [S+6-3] (used reg = )
mov	-1[bp],al
!BCC_EOS
! 4592   } while ( val8 == 0 );
.68A:
! Debug: logeq int = const 0 to unsigned char val8 = [S+6-3] (used reg = )
mov	al,-1[bp]
test	al,al
je 	.68B
.68C:
!BCC_EOS
! 4593   val8 = 0;
.689:
! Debug: eq int = const 0 to unsigned char val8 = [S+6-3] (used reg = )
xor	al,al
mov	-1[bp],al
!BCC_EOS
! 4594 #asm
!BCC_EOS
!BCC_ASM
_floppy_drive_recal.curr_cyl_offset	set	0
.floppy_drive_recal.curr_cyl_offset	set	-4
_floppy_drive_recal.val8	set	3
.floppy_drive_recal.val8	set	-1
_floppy_drive_recal.drive	set	8
.floppy_drive_recal.drive	set	4
  cli
! 4596 endasm
!BCC_ENDASM
!BCC_EOS
! 4597   val8 = *((Bit8u *)(0x003e));
! Debug: eq unsigned char = [+$3E] to unsigned char val8 = [S+6-3] (used reg = )
mov	al,[$3E]
mov	-1[bp],al
!BCC_EOS
! 4598   val8 &= 0x7f;
! Debug: andab int = const $7F to unsigned char val8 = [S+6-3] (used reg = )
mov	al,-1[bp]
and	al,*$7F
mov	-1[bp],al
!BCC_EOS
! 4599   if (drive) {
mov	ax,4[bp]
test	ax,ax
je  	.68D
.68E:
! 4600     val8 |= 0x02;
! Debug: orab int = const 2 to unsigned char val8 = [S+6-3] (used reg = )
mov	al,-1[bp]
or	al,*2
mov	-1[bp],al
!BCC_EOS
! 4601     curr_cyl_offset = 0x0095;
! Debug: eq int = const $95 to unsigned short curr_cyl_offset = [S+6-6] (used reg = )
mov	ax,#$95
mov	-4[bp],ax
!BCC_EOS
! 4602   } else {
jmp .68F
.68D:
! 4603     val8 |= 0x01;
! Debug: orab int = const 1 to unsigned char val8 = [S+6-3] (used reg = )
mov	al,-1[bp]
or	al,*1
mov	-1[bp],al
!BCC_EOS
! 4604     curr_cyl_offset = 0x0094;
! Debug: eq int = const $94 to unsigned short curr_cyl_offset = [S+6-6] (used reg = )
mov	ax,#$94
mov	-4[bp],ax
!BCC_EOS
! 4605   }
! 4606   *((Bit8u *)(0x003e)) = (val8);
.68F:
! Debug: eq unsigned char val8 = [S+6-3] to unsigned char = [+$3E] (used reg = )
mov	al,-1[bp]
mov	[$3E],al
!BCC_EOS
! 4607   *((Bit8u *)(curr_cyl_offset)) = (0);
mov	bx,-4[bp]
! Debug: eq int = const 0 to unsigned char = [bx+0] (used reg = )
xor	al,al
mov	[bx],al
!BCC_EOS
! 4608   return(1);
mov	ax,*1
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 4609 }
! 4610   bx_bool
! Register BX used in function floppy_drive_recal
! 4611 floppy_drive_exists(drive)
! 4612   Bit16u drive;
export	_floppy_drive_exists
_floppy_drive_exists:
!BCC_EOS
! 4613 {
! 4614   Bit8u drive_type;
!BCC_EOS
! 4615   drive_type = inb_cmos(0x10);
push	bp
mov	bp,sp
dec	sp
dec	sp
! Debug: list int = const $10 (used reg = )
mov	ax,*$10
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char drive_type = [S+4-3] (used reg = )
mov	-1[bp],al
!BCC_EOS
! 4616   if (drive == 0)
! Debug: logeq int = const 0 to unsigned short drive = [S+4+2] (used reg = )
mov	ax,4[bp]
test	ax,ax
jne 	.690
.691:
! 4617     drive_type >>= 4;
! Debug: srab int = const 4 to unsigned char drive_type = [S+4-3] (used reg = )
mov	al,-1[bp]
xor	ah,ah
mov	cl,*4
shr	ax,cl
mov	-1[bp],al
!BCC_EOS
! 4618   else
! 4619     drive_type &= 0x0f;
jmp .692
.690:
! Debug: andab int = const $F to unsigned char drive_type = [S+4-3] (used reg = )
mov	al,-1[bp]
and	al,*$F
mov	-1[bp],al
!BCC_EOS
! 4620   if ( drive_type == 0 )
.692:
! Debug: logeq int = const 0 to unsigned char drive_type = [S+4-3] (used reg = )
mov	al,-1[bp]
test	al,al
jne 	.693
.694:
! 4621     return(0);
xor	ax,ax
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 4622   else
! 4623     return(1);
jmp .695
.693:
mov	ax,*1
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 4624 }
.695:
mov	sp,bp
pop	bp
ret
! 4625   void
! 4626 int13_diskette_function(DS, ES, DI, SI, BP, ELDX, BX, DX, CX, AX, IP, CS, FLAGS)
! 4627   Bit16u DS, ES, DI, SI, BP, ELDX, BX, DX, CX, AX, IP, CS, FLAGS;
export	_int13_diskette_function
_int13_diskette_function:
!BCC_EOS
! 4628 {
! 4629   Bit8u drive, num_sectors, track, sector, head, status;
!BCC_EOS
! 4630   Bit16u base_address, base_count, base_es;
!BCC_EOS
! 4631   Bit8u page, mode_register, val8, dor;
!BCC_EOS
! 4632   Bit8u return_status[7];
!BCC_EOS
! 4633   Bit8u drive_type, num_floppies, ah, spt;
!BCC_EOS
! 4634   Bit16u es, last_addr, maxCyl;
!BCC_EOS
! 4635   ;
push	bp
mov	bp,sp
add	sp,*-$22
!BCC_EOS
! 4636   ah = *(((Bit8u *)&AX)+1);
! Debug: eq unsigned char AX = [S+$24+$15] to unsigned char ah = [S+$24-$1C] (used reg = )
mov	al,$17[bp]
mov	-$1A[bp],al
!BCC_EOS
! 4637  
! 4637  switch ( ah ) {
mov	al,-$1A[bp]
br 	.698
! 4638     case 0x00:
! 4639 ;
.699:
!BCC_EOS
! 4640       drive = ( ELDX & 0x00ff );
! Debug: and int = const $FF to unsigned short ELDX = [S+$24+$C] (used reg = )
mov	al,$E[bp]
! Debug: eq unsigned char = al+0 to unsigned char drive = [S+$24-3] (used reg = )
mov	-1[bp],al
!BCC_EOS
! 4641       if (drive > 1) {
! Debug: gt int = const 1 to unsigned char drive = [S+$24-3] (used reg = )
mov	al,-1[bp]
cmp	al,*1
jbe 	.69A
.69B:
! 4642         *(((Bit8u *)&AX)+1) = (1);
! Debug: eq int = const 1 to unsigned char AX = [S+$24+$15] (used reg = )
mov	al,*1
mov	$17[bp],al
!BCC_EOS
! 4643         set_diskette_ret_status(1);
! Debug: list int = const 1 (used reg = )
mov	ax,*1
push	ax
! Debug: func () void = set_diskette_ret_status+0 (used reg = )
call	_set_diskette_ret_status
inc	sp
inc	sp
!BCC_EOS
! 4644         FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$24+$1A] (used reg = )
mov	ax,$1C[bp]
or	al,*1
mov	$1C[bp],ax
!BCC_EOS
! 4645         return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 4646       }
! 4647       drive_type = inb_cmos(0x10);
.69A:
! Debug: list int = const $10 (used reg = )
mov	ax,*$10
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char drive_type = [S+$24-$1A] (used reg = )
mov	-$18[bp],al
!BCC_EOS
! 4648       if (drive == 0)
! Debug: logeq int = const 0 to unsigned char drive = [S+$24-3] (used reg = )
mov	al,-1[bp]
test	al,al
jne 	.69C
.69D:
! 4649         drive_type >>= 4;
! Debug: srab int = const 4 to unsigned char drive_type = [S+$24-$1A] (used reg = )
mov	al,-$18[bp]
xor	ah,ah
mov	cl,*4
shr	ax,cl
mov	-$18[bp],al
!BCC_EOS
! 4650       else
! 4651         drive_type &= 0x0f;
jmp .69E
.69C:
! Debug: andab int = const $F to unsigned char drive_type = [S+$24-$1A] (used reg = )
mov	al,-$18[bp]
and	al,*$F
mov	-$18[bp],al
!BCC_EOS
! 4652       if (drive_type == 0) {
.69E:
! Debug: logeq int = const 0 to unsigned char drive_type = [S+$24-$1A] (used reg = )
mov	al,-$18[bp]
test	al,al
jne 	.69F
.6A0:
! 4653         *(((Bit8u *)&AX)+1) = (0x80);
! Debug: eq int = const $80 to unsigned char AX = [S+$24+$15] (used reg = )
mov	al,#$80
mov	$17[bp],al
!BCC_EOS
! 4654         set_diskette_ret_status(0x80);
! Debug: list int = const $80 (used reg = )
mov	ax,#$80
push	ax
! Debug: func () void = set_diskette_ret_status+0 (used reg = )
call	_set_diskette_ret_status
inc	sp
inc	sp
!BCC_EOS
! 4655         FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$24+$1A] (used reg = )
mov	ax,$1C[bp]
or	al,*1
mov	$1C[bp],ax
!BCC_EOS
! 4656         return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 4657       }
! 4658       *(((Bit8u *)&AX)+1) = (0);
.69F:
! Debug: eq int = const 0 to unsigned char AX = [S+$24+$15] (used reg = )
xor	al,al
mov	$17[bp],al
!BCC_EOS
! 4659       set_diskette_ret_status(0);
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: func () void = set_diskette_ret_status+0 (used reg = )
call	_set_diskette_ret_status
inc	sp
inc	sp
!BCC_EOS
! 4660       FLAGS &= 0xfffe;
! Debug: andab unsigned int = const $FFFE to unsigned short FLAGS = [S+$24+$1A] (used reg = )
mov	ax,$1C[bp]
and	al,#$FE
mov	$1C[bp],ax
!BCC_EOS
! 4661       set_diskette_current_cyl(drive, 0);
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list unsigned char drive = [S+$26-3] (used reg = )
mov	al,-1[bp]
xor	ah,ah
push	ax
! Debug: func () void = set_diskette_current_cyl+0 (used reg = )
call	_set_diskette_current_cyl
add	sp,*4
!BCC_EOS
! 4662       return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 4663     case 0x01:
! 4664       FLAGS &= 0xfffe;
.6A1:
! Debug: andab unsigned int = const $FFFE to unsigned short FLAGS = [S+$24+$1A] (used reg = )
mov	ax,$1C[bp]
and	al,#$FE
mov	$1C[bp],ax
!BCC_EOS
! 4665       val8 = *((Bit8u *)(0x0041));
! Debug: eq unsigned char = [+$41] to unsigned char val8 = [S+$24-$11] (used reg = )
mov	al,[$41]
mov	-$F[bp],al
!BCC_EOS
! 4666       *(((Bit8u *)&AX)+1) = (val8);
! Debug: eq unsigned char val8 = [S+$24-$11] to unsigned char AX = [S+$24+$15] (used reg = )
mov	al,-$F[bp]
mov	$17[bp],al
!BCC_EOS
! 4667       if (val8) {
mov	al,-$F[bp]
test	al,al
je  	.6A2
.6A3:
! 4668         FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$24+$1A] (used reg = )
mov	ax,$1C[bp]
or	al,*1
mov	$1C[bp],ax
!BCC_EOS
! 4669       }
! 4670       return;
.6A2:
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 4671     case 0x02:
! 4672     case 0x03:
.6A4:
! 4673     case 0x04:
.6A5:
! 4674       num_sectors = ( AX & 0x00ff );
.6A6:
! Debug: and int = const $FF to unsigned short AX = [S+$24+$14] (used reg = )
mov	al,$16[bp]
! Debug: eq unsigned char = al+0 to unsigned char num_sectors = [S+$24-4] (used reg = )
mov	-2[bp],al
!BCC_EOS
! 4675       track = *(((Bit8u *)&CX)+1);
! Debug: eq unsigned char CX = [S+$24+$13] to unsigned char track = [S+$24-5] (used reg = )
mov	al,$15[bp]
mov	-3[bp],al
!BCC_EOS
! 4676       sector = ( CX & 0x00ff );
! Debug: and int = const $FF to unsigned short CX = [S+$24+$12] (used reg = )
mov	al,$14[bp]
! Debug: eq unsigned char = al+0 to unsigned char sector = [S+$24-6] (used reg = )
mov	-4[bp],al
!BCC_EOS
! 4677       head = *(((Bit8u *)&DX)+1);
! Debug: eq unsigned char DX = [S+$24+$11] to unsigned char head = [S+$24-7] (used reg = )
mov	al,$13[bp]
mov	-5[bp],al
!BCC_EOS
! 4678       drive = ( ELDX & 0x00ff );
! Debug: and int = const $FF to unsigned short ELDX = [S+$24+$C] (used reg = )
mov	al,$E[bp]
! Debug: eq unsigned char = al+0 to unsigned char drive = [S+$24-3] (used reg = )
mov	-1[bp],al
!BCC_EOS
! 4679       if ((drive > 1) || (head > 1) || (sector == 0) ||
! 4680           (num_sectors == 0) || (num_sectors > 72)) {
! Debug: gt int = const 1 to unsigned char drive = [S+$24-3] (used reg = )
mov	al,-1[bp]
cmp	al,*1
ja  	.6A8
.6AC:
! Debug: gt int = const 1 to unsigned char head = [S+$24-7] (used reg = )
mov	al,-5[bp]
cmp	al,*1
ja  	.6A8
.6AB:
! Debug: logeq int = const 0 to unsigned char sector = [S+$24-6] (used reg = )
mov	al,-4[bp]
test	al,al
je  	.6A8
.6AA:
! Debug: logeq int = const 0 to unsigned char num_sectors = [S+$24-4] (used reg = )
mov	al,-2[bp]
test	al,al
je  	.6A8
.6A9:
! Debug: gt int = const $48 to unsigned char num_sectors = [S+$24-4] (used reg = )
mov	al,-2[bp]
cmp	al,*$48
jbe 	.6A7
.6A8:
! 4681         bios_printf(4, "int13_diskette: read/write/verify: parameter out of range\n");
! Debug: list * char = .6AD+0 (used reg = )
mov	bx,#.6AD
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*4
!BCC_EOS
! 4682         *(((Bit8u *)&AX)+1) = (1);
! Debug: eq int = const 1 to unsigned char AX = [S+$24+$15] (used reg = )
mov	al,*1
mov	$17[bp],al
!BCC_EOS
! 4683         set_diskette_ret_status(1);
! Debug: list int = const 1 (used reg = )
mov	ax,*1
push	ax
! Debug: func () void = set_diskette_ret_status+0 (used reg = )
call	_set_diskette_ret_status
inc	sp
inc	sp
!BCC_EOS
! 4684         *((Bit8u *)&AX) = (0);
! Debug: eq int = const 0 to unsigned char AX = [S+$24+$14] (used reg = )
xor	al,al
mov	$16[bp],al
!BCC_EOS
! 4685         FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$24+$1A] (used reg = )
mov	ax,$1C[bp]
or	al,*1
mov	$1C[bp],ax
!BCC_EOS
! 4686         return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 4687       }
! 4688       if (floppy_drive_exists(drive) == 0) {
.6A7:
! Debug: list unsigned char drive = [S+$24-3] (used reg = )
mov	al,-1[bp]
xor	ah,ah
push	ax
! Debug: func () unsigned short = floppy_drive_exists+0 (used reg = )
call	_floppy_drive_exists
inc	sp
inc	sp
! Debug: logeq int = const 0 to unsigned short = ax+0 (used reg = )
test	ax,ax
jne 	.6AE
.6AF:
! 4689         *(((Bit8u *)&AX)+1) = (0x80);
! Debug: eq int = const $80 to unsigned char AX = [S+$24+$15] (used reg = )
mov	al,#$80
mov	$17[bp],al
!BCC_EOS
! 4690         set_diskette_ret_status(0x80);
! Debug: list int = const $80 (used reg = )
mov	ax,#$80
push	ax
! Debug: func () void = set_diskette_ret_status+0 (used reg = )
call	_set_diskette_ret_status
inc	sp
inc	sp
!BCC_EOS
! 4691         *((Bit8u *)&AX) = (0);
! Debug: eq int = const 0 to unsigned char AX = [S+$24+$14] (used reg = )
xor	al,al
mov	$16[bp],al
!BCC_EOS
! 4692         FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$24+$1A] (used reg = )
mov	ax,$1C[bp]
or	al,*1
mov	$1C[bp],ax
!BCC_EOS
! 4693         return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 4694       }
! 4695       if (floppy_media_known(drive) == 0) {
.6AE:
! Debug: list unsigned char drive = [S+$24-3] (used reg = )
mov	al,-1[bp]
xor	ah,ah
push	ax
! Debug: func () unsigned short = floppy_media_known+0 (used reg = )
call	_floppy_media_known
inc	sp
inc	sp
! Debug: logeq int = const 0 to unsigned short = ax+0 (used reg = )
test	ax,ax
jne 	.6B0
.6B1:
! 4696         if (floppy_media_sense(drive) == 0) {
! Debug: list unsigned char drive = [S+$24-3] (used reg = )
mov	al,-1[bp]
xor	ah,ah
push	ax
! Debug: func () unsigned short = floppy_media_sense+0 (used reg = )
call	_floppy_media_sense
inc	sp
inc	sp
! Debug: logeq int = const 0 to unsigned short = ax+0 (used reg = )
test	ax,ax
jne 	.6B2
.6B3:
! 4697           *(((Bit8u *)&AX)+1) = (0x0C);
! Debug: eq int = const $C to unsigned char AX = [S+$24+$15] (used reg = )
mov	al,*$C
mov	$17[bp],al
!BCC_EOS
! 4698           set_diskette_ret_status(0x0C);
! Debug: list int = const $C (used reg = )
mov	ax,*$C
push	ax
! Debug: func () void = set_diskette_ret_status+0 (used reg = )
call	_set_diskette_ret_status
inc	sp
inc	sp
!BCC_EOS
! 4699           *((Bit8u *)&AX) = (0);
! Debug: eq int = const 0 to unsigned char AX = [S+$24+$14] (used reg = )
xor	al,al
mov	$16[bp],al
!BCC_EOS
! 4700           FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$24+$1A] (used reg = )
mov	ax,$1C[bp]
or	al,*1
mov	$1C[bp],ax
!BCC_EOS
! 4701           return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 4702         }
! 4703       }
.6B2:
! 4704       if(ah == 0x04) {
.6B0:
! Debug: logeq int = const 4 to unsigned char ah = [S+$24-$1C] (used reg = )
mov	al,-$1A[bp]
cmp	al,*4
jne 	.6B4
.6B5:
! 4705         goto floppy_return_success;
add	sp,#..FFDA-..FFDB
br 	.FFDA
!BCC_EOS
! 4706       }
! 4707       page = (ES >> 12);
.6B4:
! Debug: sr int = const $C to unsigned short ES = [S+$24+4] (used reg = )
mov	ax,6[bp]
mov	al,ah
xor	ah,ah
mov	cl,*4
shr	ax,cl
! Debug: eq unsigned int = ax+0 to unsigned char page = [S+$24-$F] (used reg = )
mov	-$D[bp],al
!BCC_EOS
! 4708       base_es = (ES << 4);
! Debug: sl int = const 4 to unsigned short ES = [S+$24+4] (used reg = )
mov	ax,6[bp]
mov	cl,*4
shl	ax,cl
! Debug: eq unsigned int = ax+0 to unsigned short base_es = [S+$24-$E] (used reg = )
mov	-$C[bp],ax
!BCC_EOS
! 4709       base_address = base_es + BX;
! Debug: add unsigned short BX = [S+$24+$E] to unsigned short base_es = [S+$24-$E] (used reg = )
mov	ax,-$C[bp]
add	ax,$10[bp]
! Debug: eq unsigned int = ax+0 to unsigned short base_address = [S+$24-$A] (used reg = )
mov	-8[bp],ax
!BCC_EOS
! 4710       if ( base_address < base_es ) {
! Debug: lt unsigned short base_es = [S+$24-$E] to unsigned short base_address = [S+$24-$A] (used reg = )
mov	ax,-8[bp]
cmp	ax,-$C[bp]
jae 	.6B6
.6B7:
! 4711         page++;
! Debug: postinc unsigned char page = [S+$24-$F] (used reg = )
mov	al,-$D[bp]
inc	ax
mov	-$D[bp],al
!BCC_EOS
! 4712 
! 4712       }
! 4713       base_count = (num_sectors * 512) - 1;
.6B6:
! Debug: mul int = const $200 to unsigned char num_sectors = [S+$24-4] (used reg = )
mov	al,-2[bp]
xor	ah,ah
mov	cx,#$200
imul	cx
! Debug: sub int = const 1 to unsigned int = ax+0 (used reg = )
! Debug: eq unsigned int = ax-1 to unsigned short base_count = [S+$24-$C] (used reg = )
dec	ax
mov	-$A[bp],ax
!BCC_EOS
! 4714       last_addr = base_address + base_count;
! Debug: add unsigned short base_count = [S+$24-$C] to unsigned short base_address = [S+$24-$A] (used reg = )
mov	ax,-8[bp]
add	ax,-$A[bp]
! Debug: eq unsigned int = ax+0 to unsigned short last_addr = [S+$24-$22] (used reg = )
mov	-$20[bp],ax
!BCC_EOS
! 4715       if (last_addr < base_address) {
! Debug: lt unsigned short base_address = [S+$24-$A] to unsigned short last_addr = [S+$24-$22] (used reg = )
mov	ax,-$20[bp]
cmp	ax,-8[bp]
jae 	.6B8
.6B9:
! 4716         *(((Bit8u *)&AX)+1) = (0x09);
! Debug: eq int = const 9 to unsigned char AX = [S+$24+$15] (used reg = )
mov	al,*9
mov	$17[bp],al
!BCC_EOS
! 4717         set_diskette_ret_status(0x09);
! Debug: list int = const 9 (used reg = )
mov	ax,*9
push	ax
! Debug: func () void = set_diskette_ret_status+0 (used reg = )
call	_set_diskette_ret_status
inc	sp
inc	sp
!BCC_EOS
! 4718         *((Bit8u *)&AX) = (0);
! Debug: eq int = const 0 to unsigned char AX = [S+$24+$14] (used reg = )
xor	al,al
mov	$16[bp],al
!BCC_EOS
! 4719         FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$24+$1A] (used reg = )
mov	ax,$1C[bp]
or	al,*1
mov	$1C[bp],ax
!BCC_EOS
! 4720         return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 4721       }
! 4722       ;
.6B8:
!BCC_EOS
! 4723       outb(0x000a, 0x06);
! Debug: list int = const 6 (used reg = )
mov	ax,*6
push	ax
! Debug: list int = const $A (used reg = )
mov	ax,*$A
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4724   ;
!BCC_EOS
! 4725       outb(0x000c, 0x00);
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const $C (used reg = )
mov	ax,*$C
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4726       outb(0x0004, base_address);
! Debug: list unsigned short base_address = [S+$24-$A] (used reg = )
push	-8[bp]
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4727       outb(0x0004, *(((Bit8u *)&base_address)+1));
! Debug: list unsigned char base_address = [S+$24-9] (used reg = )
mov	al,-7[bp]
xor	ah,ah
push	ax
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4728   ;
!BCC_EOS
! 4729       outb(0x000c, 0x00);
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const $C (used reg = )
mov	ax,*$C
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4730       outb(0x0005, base_count);
! Debug: list unsigned short base_count = [S+$24-$C] (used reg = )
push	-$A[bp]
! Debug: list int = const 5 (used reg = )
mov	ax,*5
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4731       outb(0x0005, *(((Bit8u *)&base_count)+1));
! Debug: list unsigned char base_count = [S+$24-$B] (used reg = )
mov	al,-9[bp]
xor	ah,ah
push	ax
! Debug: list int = const 5 (used reg = )
mov	ax,*5
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4732       if (ah == 0x02) {
! Debug: logeq int = const 2 to unsigned char ah = [S+$24-$1C] (used reg = )
mov	al,-$1A[bp]
cmp	al,*2
jne 	.6BA
.6BB:
! 4733         mode_register = 0x46;
! Debug: eq int = const $46 to unsigned char mode_register = [S+$24-$10] (used reg = )
mov	al,*$46
mov	-$E[bp],al
!BCC_EOS
! 4734   ;
!BCC_EOS
! 4735         outb(0x000b, mode_register);
! Debug: list unsigned char mode_register = [S+$24-$10] (used reg = )
mov	al,-$E[bp]
xor	ah,ah
push	ax
! Debug: list int = const $B (used reg = )
mov	ax,*$B
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4736   ;
!BCC_EOS
! 4737         outb(0x0081, page);
! Debug: list unsigned char page = [S+$24-$F] (used reg = )
mov	al,-$D[bp]
xor	ah,ah
push	ax
! Debug: list int = const $81 (used reg = )
mov	ax,#$81
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4738   ;
!BCC_EOS
! 4739         outb(0x000a, 0x02);
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: list int = const $A (used reg = )
mov	ax,*$A
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4740         ;
!BCC_EOS
! 4741         outb(0x000a, 0x02);
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: list int = const $A (used reg = )
mov	ax,*$A
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4742         floppy_prepare_controller(drive);
! Debug: list unsigned char drive = [S+$24-3] (used reg = )
mov	al,-1[bp]
xor	ah,ah
push	ax
! Debug: func () void = floppy_prepare_controller+0 (used reg = )
call	_floppy_prepare_controller
inc	sp
inc	sp
!BCC_EOS
! 4743         outb(0x03f5, 0xe6);
! Debug: list int = const $E6 (used reg = )
mov	ax,#$E6
push	ax
! Debug: list int = const $3F5 (used reg = )
mov	ax,#$3F5
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4744       } else {
jmp .6BC
.6BA:
! 4745         mode_register = 0x4a;
! Debug: eq int = const $4A to unsigned char mode_register = [S+$24-$10] (used reg = )
mov	al,*$4A
mov	-$E[bp],al
!BCC_EOS
! 4746         outb(0x000b, mode_register);
! Debug: list unsigned char mode_register = [S+$24-$10] (used reg = )
mov	al,-$E[bp]
xor	ah,ah
push	ax
! Debug: list int = const $B (used reg = )
mov	ax,*$B
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4747         outb(0x0081, page);
! Debug: list unsigned char page = [S+$24-$F] (used reg = )
mov	al,-$D[bp]
xor	ah,ah
push	ax
! Debug: list int = const $81 (used reg = )
mov	ax,#$81
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4748         ;
!BCC_EOS
! 4749         outb(0x000a, 0x02);
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: list int = const $A (used reg = )
mov	ax,*$A
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4750         floppy_prepare_controller(drive);
! Debug: list unsigned char drive = [S+$24-3] (used reg = )
mov	al,-1[bp]
xor	ah,ah
push	ax
! Debug: func () void = floppy_prepare_controller+0 (used reg = )
call	_floppy_prepare_controller
inc	sp
inc	sp
!BCC_EOS
! 4751         outb(0x03f5, 0xc5);
! Debug: list int = const $C5 (used reg = )
mov	ax,#$C5
push	ax
! Debug: list int = const $3F5 (used reg = )
mov	ax,#$3F5
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4752       }
! 4753       outb(0x03f5, (head << 2) | drive);
.6BC:
! Debug: sl int = const 2 to unsigned char head = [S+$24-7] (used reg = )
mov	al,-5[bp]
xor	ah,ah
shl	ax,*1
shl	ax,*1
! Debug: or unsigned char drive = [S+$24-3] to unsigned int = ax+0 (used reg = )
or	al,-1[bp]
! Debug: list unsigned int = ax+0 (used reg = )
push	ax
! Debug: list int = const $3F5 (used reg = )
mov	ax,#$3F5
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4754       outb(0x03f5, track);
! Debug: list unsigned char track = [S+$24-5] (used reg = )
mov	al,-3[bp]
xor	ah,ah
push	ax
! Debug: list int = const $3F5 (used reg = )
mov	ax,#$3F5
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4755       outb(0x03f5, head);
! Debug: list unsigned char head = [S+$24-7] (used reg = )
mov	al,-5[bp]
xor	ah,ah
push	ax
! Debug: list int = const $3F5 (used reg = )
mov	ax,#$3F5
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4756       outb(0x03f5, sector);
! Debug: list unsigned char sector = [S+$24-6] (used reg = )
mov	al,-4[bp]
xor	ah,ah
push	ax
! Debug: list int = const $3F5 (used reg = )
mov	ax,#$3F5
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4757       outb(0x03f5, 2);
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: list int = const $3F5 (used reg = )
mov	ax,#$3F5
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4758       outb(0x03f5, sector + num_sectors - 1);
! Debug: add unsigned char num_sectors = [S+$24-4] to unsigned char sector = [S+$24-6] (used reg = )
mov	al,-4[bp]
xor	ah,ah
add	al,-2[bp]
adc	ah,*0
! Debug: sub int = const 1 to unsigned int = ax+0 (used reg = )
! Debug: list unsigned int = ax-1 (used reg = )
dec	ax
push	ax
! Debug: list int = const $3F5 (used reg = )
mov	ax,#$3F5
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4759       outb(0x03f5, 0);
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const $3F5 (used reg = )
mov	ax,#$3F5
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4760       outb(0x03f5, 0xff);
! Debug: list int = const $FF (used reg = )
mov	ax,#$FF
push	ax
! Debug: list int = const $3F5 (used reg = )
mov	ax,#$3F5
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4761 #asm
!BCC_EOS
!BCC_ASM
_int13_diskette_function.BP	set	$2E
.int13_diskette_function.BP	set	$C
_int13_diskette_function.CS	set	$3C
.int13_diskette_function.CS	set	$1A
_int13_diskette_function.CX	set	$36
.int13_diskette_function.CX	set	$14
_int13_diskette_function.base_address	set	$1A
.int13_diskette_function.base_address	set	-8
_int13_diskette_function.DI	set	$2A
.int13_diskette_function.DI	set	8
_int13_diskette_function.FLAGS	set	$3E
.int13_diskette_function.FLAGS	set	$1C
_int13_diskette_function.base_count	set	$18
.int13_diskette_function.base_count	set	-$A
_int13_diskette_function.sector	set	$1E
.int13_diskette_function.sector	set	-4
_int13_diskette_function.DS	set	$26
.int13_diskette_function.DS	set	4
_int13_diskette_function.head	set	$1D
.int13_diskette_function.head	set	-5
_int13_diskette_function.ELDX	set	$30
.int13_diskette_function.ELDX	set	$E
_int13_diskette_function.dor	set	$12
.int13_diskette_function.dor	set	-$10
_int13_diskette_function.DX	set	$34
.int13_diskette_function.DX	set	$12
_int13_diskette_function.return_status	set	$B
.int13_diskette_function.return_status	set	-$17
_int13_diskette_function.es	set	4
.int13_diskette_function.es	set	-$1E
_int13_diskette_function.mode_register	set	$14
.int13_diskette_function.mode_register	set	-$E
_int13_diskette_function.ES	set	$28
.int13_diskette_function.ES	set	6
_int13_diskette_function.base_es	set	$16
.int13_diskette_function.base_es	set	-$C
_int13_diskette_function.track	set	$1F
.int13_diskette_function.track	set	-3
_int13_diskette_function.SI	set	$2C
.int13_diskette_function.SI	set	$A
_int13_diskette_function.drive_type	set	$A
.int13_diskette_function.drive_type	set	-$18
_int13_diskette_function.num_sectors	set	$20
.int13_diskette_function.num_sectors	set	-2
_int13_diskette_function.IP	set	$3A
.int13_diskette_function.IP	set	$18
_int13_diskette_function.spt	set	7
.int13_diskette_function.spt	set	-$1B
_int13_diskette_function.status	set	$1C
.int13_diskette_function.status	set	-6
_int13_diskette_function.maxCyl	set	0
.int13_diskette_function.maxCyl	set	-$22
_int13_diskette_function.AX	set	$38
.int13_diskette_function.AX	set	$16
_int13_diskette_function.val8	set	$13
.int13_diskette_function.val8	set	-$F
_int13_diskette_function.last_addr	set	2
.int13_diskette_function.last_addr	set	-$20
_int13_diskette_function.page	set	$15
.int13_diskette_function.page	set	-$D
_int13_diskette_function.ah	set	8
.int13_diskette_function.ah	set	-$1A
_int13_diskette_function.drive	set	$21
.int13_diskette_function.drive	set	-1
_int13_diskette_function.num_floppies	set	9
.int13_diskette_function.num_floppies	set	-$19
_int13_diskette_function.BX	set	$32
.int13_diskette_function.BX	set	$10
      sti
! 4763 endasm
!BCC_ENDASM
!BCC_EOS
! 4764       do {
.6BF:
! 4765         val8 = *((Bit8u *)(0x0040));
! Debug: eq unsigned char = [+$40] to unsigned char val8 = [S+$24-$11] (used reg = )
mov	al,[$40]
mov	-$F[bp],al
!BCC_EOS
! 4766         if (val8 == 0) {
! Debug: logeq int = const 0 to unsigned char val8 = [S+$24-$11] (used reg = )
mov	al,-$F[bp]
test	al,al
jne 	.6C0
.6C1:
! 4767           floppy_reset_controller();
! Debug: func () void = floppy_reset_controller+0 (used reg = )
call	_floppy_reset_controller
!BCC_EOS
! 4768           *(((Bit8u *)&AX)+1) = (0x80);
! Debug: eq int = const $80 to unsigned char AX = [S+$24+$15] (used reg = )
mov	al,#$80
mov	$17[bp],al
!BCC_EOS
! 4769           set_diskette_ret_status(0x80);
! Debug: list int = const $80 (used reg = )
mov	ax,#$80
push	ax
! Debug: func () void = set_diskette_ret_status+0 (used reg = )
call	_set_diskette_ret_status
inc	sp
inc	sp
!BCC_EOS
! 4770           *((Bit8u *)&AX) = (0);
! Debug: eq int = const 0 to unsigned char AX = [S+$24+$14] (used reg = )
xor	al,al
mov	$16[bp],al
!BCC_EOS
! 4771           FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$24+$1A] (used reg = )
mov	ax,$1C[bp]
or	al,*1
mov	$1C[bp],ax
!BCC_EOS
! 4772           return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 4773         }
! 4774         val8 = (*((Bit8u *)(0x003e)) & 0x80);
.6C0:
! Debug: and int = const $80 to unsigned char = [+$3E] (used reg = )
mov	al,[$3E]
and	al,#$80
! Debug: eq unsigned char = al+0 to unsigned char val8 = [S+$24-$11] (used reg = )
mov	-$F[bp],al
!BCC_EOS
! 4775       } while ( val8 == 0 );
.6BE:
! Debug: logeq int = const 0 to unsigned char val8 = [S+$24-$11] (used reg = )
mov	al,-$F[bp]
test	al,al
je 	.6BF
.6C2:
!BCC_EOS
! 4776       val8 = 0;
.6BD:
! Debug: eq int = const 0 to unsigned char val8 = [S+$24-$11] (used reg = )
xor	al,al
mov	-$F[bp],al
!BCC_EOS
! 4777 #asm
!BCC_EOS
!BCC_ASM
_int13_diskette_function.BP	set	$2E
.int13_diskette_function.BP	set	$C
_int13_diskette_function.CS	set	$3C
.int13_diskette_function.CS	set	$1A
_int13_diskette_function.CX	set	$36
.int13_diskette_function.CX	set	$14
_int13_diskette_function.base_address	set	$1A
.int13_diskette_function.base_address	set	-8
_int13_diskette_function.DI	set	$2A
.int13_diskette_function.DI	set	8
_int13_diskette_function.FLAGS	set	$3E
.int13_diskette_function.FLAGS	set	$1C
_int13_diskette_function.base_count	set	$18
.int13_diskette_function.base_count	set	-$A
_int13_diskette_function.sector	set	$1E
.int13_diskette_function.sector	set	-4
_int13_diskette_function.DS	set	$26
.int13_diskette_function.DS	set	4
_int13_diskette_function.head	set	$1D
.int13_diskette_function.head	set	-5
_int13_diskette_function.ELDX	set	$30
.int13_diskette_function.ELDX	set	$E
_int13_diskette_function.dor	set	$12
.int13_diskette_function.dor	set	-$10
_int13_diskette_function.DX	set	$34
.int13_diskette_function.DX	set	$12
_int13_diskette_function.return_status	set	$B
.int13_diskette_function.return_status	set	-$17
_int13_diskette_function.es	set	4
.int13_diskette_function.es	set	-$1E
_int13_diskette_function.mode_register	set	$14
.int13_diskette_function.mode_register	set	-$E
_int13_diskette_function.ES	set	$28
.int13_diskette_function.ES	set	6
_int13_diskette_function.base_es	set	$16
.int13_diskette_function.base_es	set	-$C
_int13_diskette_function.track	set	$1F
.int13_diskette_function.track	set	-3
_int13_diskette_function.SI	set	$2C
.int13_diskette_function.SI	set	$A
_int13_diskette_function.drive_type	set	$A
.int13_diskette_function.drive_type	set	-$18
_int13_diskette_function.num_sectors	set	$20
.int13_diskette_function.num_sectors	set	-2
_int13_diskette_function.IP	set	$3A
.int13_diskette_function.IP	set	$18
_int13_diskette_function.spt	set	7
.int13_diskette_function.spt	set	-$1B
_int13_diskette_function.status	set	$1C
.int13_diskette_function.status	set	-6
_int13_diskette_function.maxCyl	set	0
.int13_diskette_function.maxCyl	set	-$22
_int13_diskette_function.AX	set	$38
.int13_diskette_function.AX	set	$16
_int13_diskette_function.val8	set	$13
.int13_diskette_function.val8	set	-$F
_int13_diskette_function.last_addr	set	2
.int13_diskette_function.last_addr	set	-$20
_int13_diskette_function.page	set	$15
.int13_diskette_function.page	set	-$D
_int13_diskette_function.ah	set	8
.int13_diskette_function.ah	set	-$1A
_int13_diskette_function.drive	set	$21
.int13_diskette_function.drive	set	-1
_int13_diskette_function.num_floppies	set	9
.int13_diskette_function.num_floppies	set	-$19
_int13_diskette_function.BX	set	$32
.int13_diskette_function.BX	set	$10
      cli
! 4779 endasm
!BCC_ENDASM
!BCC_EOS
! 4780       val8 = *((Bit8u *)(0x003e));
! Debug: eq unsigned char = [+$3E] to unsigned char val8 = [S+$24-$11] (used reg = )
mov	al,[$3E]
mov	-$F[bp],al
!BCC_EOS
! 4781       val8 &= 0x7f;
! Debug: andab int = const $7F to unsigned char val8 = [S+$24-$11] (used reg = )
mov	al,-$F[bp]
and	al,*$7F
mov	-$F[bp],al
!BCC_EOS
! 4782       *((Bit8u *)(0x003e)) = (val8);
! Debug: eq unsigned char val8 = [S+$24-$11] to unsigned char = [+$3E] (used reg = )
mov	al,-$F[bp]
mov	[$3E],al
!BCC_EOS
! 4783       val8 = inb(0x03f4);
! Debug: list int = const $3F4 (used reg = )
mov	ax,#$3F4
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char val8 = [S+$24-$11] (used reg = )
mov	-$F[bp],al
!BCC_EOS
! 4784       if ( (val8 & 0xc0) != 0xc0 )
! Debug: and int = const $C0 to unsigned char val8 = [S+$24-$11] (used reg = )
mov	al,-$F[bp]
and	al,#$C0
! Debug: ne int = const $C0 to unsigned char = al+0 (used reg = )
cmp	al,#$C0
je  	.6C3
.6C4:
! 4785         bios_printf((2 | 4 | 1), "int13_diskette: ctrl not ready\n");
! Debug: list * char = .6C5+0 (used reg = )
mov	bx,#.6C5
push	bx
! Debug: list int = const 7 (used reg = )
mov	ax,*7
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*4
!BCC_EOS
! 4786       return_status[0] = inb(0x03f5);
.6C3:
! Debug: list int = const $3F5 (used reg = )
mov	ax,#$3F5
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char return_status = [S+$24-$19] (used reg = )
mov	-$17[bp],al
!BCC_EOS
! 4787       return_status[1] = inb(0x03f5);
! Debug: list int = const $3F5 (used reg = )
mov	ax,#$3F5
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char return_status = [S+$24-$18] (used reg = )
mov	-$16[bp],al
!BCC_EOS
! 4788       return_status[2] = inb(0x03f5);
! Debug: list int = const $3F5 (used reg = )
mov	ax,#$3F5
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char return_status = [S+$24-$17] (used reg = )
mov	-$15[bp],al
!BCC_EOS
! 4789       retu
! 4789 rn_status[3] = inb(0x03f5);
! Debug: list int = const $3F5 (used reg = )
mov	ax,#$3F5
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char return_status = [S+$24-$16] (used reg = )
mov	-$14[bp],al
!BCC_EOS
! 4790       return_status[4] = inb(0x03f5);
! Debug: list int = const $3F5 (used reg = )
mov	ax,#$3F5
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char return_status = [S+$24-$15] (used reg = )
mov	-$13[bp],al
!BCC_EOS
! 4791       return_status[5] = inb(0x03f5);
! Debug: list int = const $3F5 (used reg = )
mov	ax,#$3F5
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char return_status = [S+$24-$14] (used reg = )
mov	-$12[bp],al
!BCC_EOS
! 4792       return_status[6] = inb(0x03f5);
! Debug: list int = const $3F5 (used reg = )
mov	ax,#$3F5
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char return_status = [S+$24-$13] (used reg = )
mov	-$11[bp],al
!BCC_EOS
! 4793       _memcpyb(0x0042,0x0040,return_status,get_SS(),7);
! Debug: list int = const 7 (used reg = )
mov	ax,*7
push	ax
! Debug: func () unsigned short = get_SS+0 (used reg = )
call	_get_SS
! Debug: list unsigned short = ax+0 (used reg = )
push	ax
! Debug: list * unsigned char return_status = S+$28-$19 (used reg = )
lea	bx,-$17[bp]
push	bx
! Debug: list int = const $40 (used reg = )
mov	ax,*$40
push	ax
! Debug: list int = const $42 (used reg = )
mov	ax,*$42
push	ax
! Debug: func () void = _memcpyb+0 (used reg = )
call	__memcpyb
add	sp,*$A
!BCC_EOS
! 4794       if ( (return_status[0] & 0xc0) != 0 ) {
! Debug: and int = const $C0 to unsigned char return_status = [S+$24-$19] (used reg = )
mov	al,-$17[bp]
and	al,#$C0
! Debug: ne int = const 0 to unsigned char = al+0 (used reg = )
test	al,al
je  	.6C6
.6C7:
! 4795         if (ah == 0x02) {
! Debug: logeq int = const 2 to unsigned char ah = [S+$24-$1C] (used reg = )
mov	al,-$1A[bp]
cmp	al,*2
jne 	.6C8
.6C9:
! 4796           *(((Bit8u *)&AX)+1) = (0x20);
! Debug: eq int = const $20 to unsigned char AX = [S+$24+$15] (used reg = )
mov	al,*$20
mov	$17[bp],al
!BCC_EOS
! 4797           set_diskette_ret_status(0x20);
! Debug: list int = const $20 (used reg = )
mov	ax,*$20
push	ax
! Debug: func () void = set_diskette_ret_status+0 (used reg = )
call	_set_diskette_ret_status
inc	sp
inc	sp
!BCC_EOS
! 4798           *((Bit8u *)&AX) = (0);
! Debug: eq int = const 0 to unsigned char AX = [S+$24+$14] (used reg = )
xor	al,al
mov	$16[bp],al
!BCC_EOS
! 4799           FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$24+$1A] (used reg = )
mov	ax,$1C[bp]
or	al,*1
mov	$1C[bp],ax
!BCC_EOS
! 4800           return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 4801         } else {
jmp .6CA
.6C8:
! 4802           if ( (return_status[1] & 0x02) != 0 ) {
! Debug: and int = const 2 to unsigned char return_status = [S+$24-$18] (used reg = )
mov	al,-$16[bp]
and	al,*2
! Debug: ne int = const 0 to unsigned char = al+0 (used reg = )
test	al,al
je  	.6CB
.6CC:
! 4803             AX = 0x0300;
! Debug: eq int = const $300 to unsigned short AX = [S+$24+$14] (used reg = )
mov	ax,#$300
mov	$16[bp],ax
!BCC_EOS
! 4804             FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$24+$1A] (used reg = )
mov	ax,$1C[bp]
or	al,*1
mov	$1C[bp],ax
!BCC_EOS
! 4805             return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 4806           } else {
jmp .6CD
.6CB:
! 4807             bios_printf((2 | 4 | 1), "int13_diskette_function: write error\n");
! Debug: list * char = .6CE+0 (used reg = )
mov	bx,#.6CE
push	bx
! Debug: list int = const 7 (used reg = )
mov	ax,*7
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*4
!BCC_EOS
! 4808           }
! 4809         }
.6CD:
! 4810       }
.6CA:
! 4811 floppy_return_success:
.6C6:
.FFDA:
! 4812       set_diskette_current_cyl(drive, track);
! Debug: list unsigned char track = [S+$24-5] (used reg = )
mov	al,-3[bp]
xor	ah,ah
push	ax
! Debug: list unsigned char drive = [S+$26-3] (used reg = )
mov	al,-1[bp]
xor	ah,ah
push	ax
! Debug: func () void = set_diskette_current_cyl+0 (used reg = )
call	_set_diskette_current_cyl
add	sp,*4
!BCC_EOS
! 4813       *(((Bit8u *)&AX)+1) = (0x00);
! Debug: eq int = const 0 to unsigned char AX = [S+$24+$15] (used reg = )
xor	al,al
mov	$17[bp],al
!BCC_EOS
! 4814       FLAGS &= 0xfffe;
! Debug: andab unsigned int = const $FFFE to unsigned short FLAGS = [S+$24+$1A] (used reg = )
mov	ax,$1C[bp]
and	al,#$FE
mov	$1C[bp],ax
!BCC_EOS
! 4815       break;
br 	.696
!BCC_EOS
! 4816     case 0x05:
! 4817 ;
.6CF:
!BCC_EOS
! 4818       num_sectors = ( AX & 0x00ff );
! Debug: and int = const $FF to unsigned short AX = [S+$24+$14] (used reg = )
mov	al,$16[bp]
! Debug: eq unsigned char = al+0 to unsigned char num_sectors = [S+$24-4] (used reg = )
mov	-2[bp],al
!BCC_EOS
! 4819       track = *(((Bit8u *)&CX)+1);
! Debug: eq unsigned char CX = [S+$24+$13] to unsigned char track = [S+$24-5] (used reg = )
mov	al,$15[bp]
mov	-3[bp],al
!BCC_EOS
! 4820       head = *(((Bit8u *)&DX)+1);
! Debug: eq unsigned char DX = [S+$24+$11] to unsigned char head = [S+$24-7] (used reg = )
mov	al,$13[bp]
mov	-5[bp],al
!BCC_EOS
! 4821       drive = ( ELDX & 0x00ff );
! Debug: and int = const $FF to unsigned short ELDX = [S+$24+$C] (used reg = )
mov	al,$E[bp]
! Debug: eq unsigned char = al+0 to unsigned char drive = [S+$24-3] (used reg = )
mov	-1[bp],al
!BCC_EOS
! 4822       if ((drive > 1) || (head > 1) || (track > 79) ||
! 4823           (num_sectors == 0) || (num_sectors > 18)) {
! Debug: gt int = const 1 to unsigned char drive = [S+$24-3] (used reg = )
mov	al,-1[bp]
cmp	al,*1
ja  	.6D1
.6D5:
! Debug: gt int = const 1 to unsigned char head = [S+$24-7] (used reg = )
mov	al,-5[bp]
cmp	al,*1
ja  	.6D1
.6D4:
! Debug: gt int = const $4F to unsigned char track = [S+$24-5] (used reg = )
mov	al,-3[bp]
cmp	al,*$4F
ja  	.6D1
.6D3:
! Debug: logeq int = const 0 to unsigned char num_sectors = [S+$24-4] (used reg = )
mov	al,-2[bp]
test	al,al
je  	.6D1
.6D2:
! Debug: gt int = const $12 to unsigned char num_sectors = [S+$24-4] (used reg = )
mov	al,-2[bp]
cmp	al,*$12
jbe 	.6D0
.6D1:
! 4824         *(((Bit8u *)&AX)+1) = (1);
! Debug: eq int = const 1 to unsigned char AX = [S+$24+$15] (used reg = )
mov	al,*1
mov	$17[bp],al
!BCC_EOS
! 4825         set_diskette_ret_status(1);
! Debug: list int = const 1 (used reg = )
mov	ax,*1
push	ax
! Debug: func () void = set_diskette_ret_status+0 (used reg = )
call	_set_diskette_ret_status
inc	sp
inc	sp
!BCC_EOS
! 4826         FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$24+$1A] (used reg = )
mov	ax,$1C[bp]
or	al,*1
mov	$1C[bp],ax
!BCC_EOS
! 4827       }
! 4828       if (floppy_drive_exists(drive) == 0) {
.6D0:
! Debug: list unsigned char drive = [S+$24-3] (used reg = )
mov	al,-1[bp]
xor	ah,ah
push	ax
! Debug: func () unsigned short = floppy_drive_exists+0 (used reg = )
call	_floppy_drive_exists
inc	sp
inc	sp
! Debug: logeq int = const 0 to unsigned short = ax+0 (used reg = )
test	ax,ax
jne 	.6D6
.6D7:
! 4829         *(((Bit8u *)&AX)+1) = (0x80);
! Debug: eq int = const $80 to unsigned char AX = [S+$24+$15] (used reg = )
mov	al,#$80
mov	$17[bp],al
!BCC_EOS
! 4830         set_diskette_ret_status(0x80);
! Debug: list int = const $80 (used reg = )
mov	ax,#$80
push	ax
! Debug: func () void = set_diskette_ret_status+0 (used reg = )
call	_set_diskette_ret_status
inc	sp
inc	sp
!BCC_EOS
! 4831         FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$24+$1A] (used reg = )
mov	ax,$1C[bp]
or	al,*1
mov	$1C[bp],ax
!BCC_EOS
! 4832         return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 4833       }
! 4834       if (floppy_media_known(drive) == 0) {
.6D6:
! Debug: list unsigned char drive = [S+$24-3] (used reg = )
mov	al,-1[bp]
xor	ah,ah
push	ax
! Debug: func () unsigned short = floppy_media_known+0 (used reg = )
call	_floppy_media_known
inc	sp
inc	sp
! Debug: logeq int = const 0 to unsigned short = ax+0 (used reg = )
test	ax,ax
jne 	.6D8
.6D9:
! 4835         if (floppy_media_sense(drive) == 0) {
! Debug: list unsigned char drive = [S+$24-3] (used reg = )
mov	al,-1[bp]
xor	ah,ah
push	ax
! Debug: func () unsigned short = floppy_media_sense+0 (used reg = )
call	_floppy_media_sense
inc	sp
inc	sp
! Debug: logeq int = const 0 to unsigned short = ax+0 (used reg = )
test	ax,ax
jne 	.6DA
.6DB:
! 4836           *(((Bit8u *)&AX)+1) = (0x0C);
! Debug: eq int = const $C to unsigned char AX = [S+$24+$15] (used reg = )
mov	al,*$C
mov	$17[bp],al
!BCC_EOS
! 4837           set_diskette_ret_status(0x0C);
! Debug: list int = const $C (used reg = )
mov	ax,*$C
push	ax
! Debug: func () void = set_diskette_ret_status+0 (used reg = )
call	_set_diskette_ret_status
inc	sp
inc	sp
!BCC_EOS
! 4838           *((Bit8u *)&AX) = (0);
! Debug: eq int = const 0 to unsigned char AX = [S+$24+$14] (used reg = )
xor	al,al
mov	$16[bp],al
!BCC_EOS
! 4839           FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$24+$1A] (used reg = )
mov	ax,$1C[bp]
or	al,*1
mov	$1C[bp],ax
!BCC_EOS
! 4840           return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 4841         }
! 4842       }
.6DA:
! 4843       page = (ES >> 12);
.6D8:
! Debug: sr int = const $C to unsigned short ES = [S+$24+4] (used reg = )
mov	ax,6[bp]
mov	al,ah
xor	ah,ah
mov	cl,*4
shr	ax,cl
! Debug: eq unsigned int = ax+0 to unsigned char page = [S+$24-$F] (used reg = )
mov	-$D[bp],al
!BCC_EOS
! 4844       base_es = (ES << 4);
! Debug: sl int = const 4 to unsigned short ES = [S+$24+4] (used reg = )
mov	ax,6[bp]
mov	cl,*4
shl	ax,cl
! Debug: eq unsigned int = ax+0 to unsigned short base_es = [S+$24-$E] (used reg = )
mov	-$C[bp],ax
!BCC_EOS
! 4845       base_address = base_es + BX;
! Debug: add unsigned short BX = [S+$24+$E] to unsigned short base_es = [S+$24-$E] (used reg = )
mov	ax,-$C[bp]
add	ax,$10[bp]
! Debug: eq unsigned int = ax+0 to unsigned short base_address = [S+$24-$A] (used reg = )
mov	-8[bp],ax
!BCC_EOS
! 4846       if ( base_address < base_es ) {
! Debug: lt unsigned short base_es = [S+$24-$E] to unsigned short base_address = [S+$24-$A] (used reg = )
mov	ax,-8[bp]
cmp	ax,-$C[bp]
jae 	.6DC
.6DD:
! 4847         page++;
! Debug: postinc unsigned char page = [S+$24-$F] (used reg = )
mov	al,-$D[bp]
inc	ax
mov	-$D[bp],al
!BCC_EOS
! 4848       }
! 4849       base_count = (num_sectors * 4) - 1;
.6DC:
! Debug: mul int = const 4 to unsigned char num_sectors = [S+$24-4] (used reg = )
mov	al,-2[bp]
xor	ah,ah
shl	ax,*1
shl	ax,*1
! Debug: sub int = const 1 to unsigned int = ax+0 (used reg = )
! Debug: eq unsigned int = ax-1 to unsigned short base_count = [S+$24-$C] (used reg = )
dec	ax
mov	-$A[bp],ax
!BCC_EOS
! 4850       last_addr = base_address + base_count;
! Debug: add unsigned short base_count = [S+$24-$C] to unsigned short base_address = [S+$24-$A] (used reg = )
mov	ax,-8[bp]
add	ax,-$A[bp]
! Debug: eq unsigned int = ax+0 to unsigned short last_addr = [S+$24-$22] (used reg = )
mov	-$20[bp],ax
!BCC_EOS
! 4851       if (last_addr < base_address) {
! Debug: lt unsigned short base_address = [S+$24-$A] to unsigned short last_addr = [S+$24-$22] (used reg = )
mov	ax,-$20[bp]
cmp	ax,-8[bp]
jae 	.6DE
.6DF:
! 4852         *(((Bit8u *)&AX)+1) = (0x09);
! Debug: eq int = const 9 to unsigned char AX = [S+$24+$15] (used reg = )
mov	al,*9
mov	$17[bp],al
!BCC_EOS
! 4853         set_diskette_ret_status(0x09);
! Debug: list int = const 9 (used reg = )
mov	ax,*9
push	ax
! Debug: func () void = set_diskette_ret_status+0 (used reg = )
call	_set_diskette_ret_status
inc	sp
inc	sp
!BCC_EOS
! 4854         *((Bit8u *)&AX) = (0);
! Debug: eq int = const 0 to unsigned char AX = [S+$24+$14] (used reg = )
xor	al,al
mov	$16[bp],al
!BCC_EOS
! 4855         FLAGS |= 0x
! 4855 0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$24+$1A] (used reg = )
mov	ax,$1C[bp]
or	al,*1
mov	$1C[bp],ax
!BCC_EOS
! 4856         return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 4857       }
! 4858       outb(0x000a, 0x06);
.6DE:
! Debug: list int = const 6 (used reg = )
mov	ax,*6
push	ax
! Debug: list int = const $A (used reg = )
mov	ax,*$A
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4859       outb(0x000c, 0x00);
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const $C (used reg = )
mov	ax,*$C
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4860       outb(0x0004, base_address);
! Debug: list unsigned short base_address = [S+$24-$A] (used reg = )
push	-8[bp]
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4861       outb(0x0004, *(((Bit8u *)&base_address)+1));
! Debug: list unsigned char base_address = [S+$24-9] (used reg = )
mov	al,-7[bp]
xor	ah,ah
push	ax
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4862       outb(0x000c, 0x00);
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const $C (used reg = )
mov	ax,*$C
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4863       outb(0x0005, base_count);
! Debug: list unsigned short base_count = [S+$24-$C] (used reg = )
push	-$A[bp]
! Debug: list int = const 5 (used reg = )
mov	ax,*5
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4864       outb(0x0005, *(((Bit8u *)&base_count)+1));
! Debug: list unsigned char base_count = [S+$24-$B] (used reg = )
mov	al,-9[bp]
xor	ah,ah
push	ax
! Debug: list int = const 5 (used reg = )
mov	ax,*5
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4865       mode_register = 0x4a;
! Debug: eq int = const $4A to unsigned char mode_register = [S+$24-$10] (used reg = )
mov	al,*$4A
mov	-$E[bp],al
!BCC_EOS
! 4866       outb(0x000b, mode_register);
! Debug: list unsigned char mode_register = [S+$24-$10] (used reg = )
mov	al,-$E[bp]
xor	ah,ah
push	ax
! Debug: list int = const $B (used reg = )
mov	ax,*$B
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4867       outb(0x0081, page);
! Debug: list unsigned char page = [S+$24-$F] (used reg = )
mov	al,-$D[bp]
xor	ah,ah
push	ax
! Debug: list int = const $81 (used reg = )
mov	ax,#$81
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4868       outb(0x000a, 0x02);
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: list int = const $A (used reg = )
mov	ax,*$A
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4869       floppy_prepare_controller(drive);
! Debug: list unsigned char drive = [S+$24-3] (used reg = )
mov	al,-1[bp]
xor	ah,ah
push	ax
! Debug: func () void = floppy_prepare_controller+0 (used reg = )
call	_floppy_prepare_controller
inc	sp
inc	sp
!BCC_EOS
! 4870       outb(0x03f5, 0x4d);
! Debug: list int = const $4D (used reg = )
mov	ax,*$4D
push	ax
! Debug: list int = const $3F5 (used reg = )
mov	ax,#$3F5
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4871       outb(0x03f5, (head << 2) | drive);
! Debug: sl int = const 2 to unsigned char head = [S+$24-7] (used reg = )
mov	al,-5[bp]
xor	ah,ah
shl	ax,*1
shl	ax,*1
! Debug: or unsigned char drive = [S+$24-3] to unsigned int = ax+0 (used reg = )
or	al,-1[bp]
! Debug: list unsigned int = ax+0 (used reg = )
push	ax
! Debug: list int = const $3F5 (used reg = )
mov	ax,#$3F5
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4872       outb(0x03f5, 2);
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: list int = const $3F5 (used reg = )
mov	ax,#$3F5
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4873       outb(0x03f5, num_sectors);
! Debug: list unsigned char num_sectors = [S+$24-4] (used reg = )
mov	al,-2[bp]
xor	ah,ah
push	ax
! Debug: list int = const $3F5 (used reg = )
mov	ax,#$3F5
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4874       outb(0x03f5, 0);
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const $3F5 (used reg = )
mov	ax,#$3F5
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4875       outb(0x03f5, 0xf6);
! Debug: list int = const $F6 (used reg = )
mov	ax,#$F6
push	ax
! Debug: list int = const $3F5 (used reg = )
mov	ax,#$3F5
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 4876 #asm
!BCC_EOS
!BCC_ASM
_int13_diskette_function.BP	set	$2E
.int13_diskette_function.BP	set	$C
_int13_diskette_function.CS	set	$3C
.int13_diskette_function.CS	set	$1A
_int13_diskette_function.CX	set	$36
.int13_diskette_function.CX	set	$14
_int13_diskette_function.base_address	set	$1A
.int13_diskette_function.base_address	set	-8
_int13_diskette_function.DI	set	$2A
.int13_diskette_function.DI	set	8
_int13_diskette_function.FLAGS	set	$3E
.int13_diskette_function.FLAGS	set	$1C
_int13_diskette_function.base_count	set	$18
.int13_diskette_function.base_count	set	-$A
_int13_diskette_function.sector	set	$1E
.int13_diskette_function.sector	set	-4
_int13_diskette_function.DS	set	$26
.int13_diskette_function.DS	set	4
_int13_diskette_function.head	set	$1D
.int13_diskette_function.head	set	-5
_int13_diskette_function.ELDX	set	$30
.int13_diskette_function.ELDX	set	$E
_int13_diskette_function.dor	set	$12
.int13_diskette_function.dor	set	-$10
_int13_diskette_function.DX	set	$34
.int13_diskette_function.DX	set	$12
_int13_diskette_function.return_status	set	$B
.int13_diskette_function.return_status	set	-$17
_int13_diskette_function.es	set	4
.int13_diskette_function.es	set	-$1E
_int13_diskette_function.mode_register	set	$14
.int13_diskette_function.mode_register	set	-$E
_int13_diskette_function.ES	set	$28
.int13_diskette_function.ES	set	6
_int13_diskette_function.base_es	set	$16
.int13_diskette_function.base_es	set	-$C
_int13_diskette_function.track	set	$1F
.int13_diskette_function.track	set	-3
_int13_diskette_function.SI	set	$2C
.int13_diskette_function.SI	set	$A
_int13_diskette_function.drive_type	set	$A
.int13_diskette_function.drive_type	set	-$18
_int13_diskette_function.num_sectors	set	$20
.int13_diskette_function.num_sectors	set	-2
_int13_diskette_function.IP	set	$3A
.int13_diskette_function.IP	set	$18
_int13_diskette_function.spt	set	7
.int13_diskette_function.spt	set	-$1B
_int13_diskette_function.status	set	$1C
.int13_diskette_function.status	set	-6
_int13_diskette_function.maxCyl	set	0
.int13_diskette_function.maxCyl	set	-$22
_int13_diskette_function.AX	set	$38
.int13_diskette_function.AX	set	$16
_int13_diskette_function.val8	set	$13
.int13_diskette_function.val8	set	-$F
_int13_diskette_function.last_addr	set	2
.int13_diskette_function.last_addr	set	-$20
_int13_diskette_function.page	set	$15
.int13_diskette_function.page	set	-$D
_int13_diskette_function.ah	set	8
.int13_diskette_function.ah	set	-$1A
_int13_diskette_function.drive	set	$21
.int13_diskette_function.drive	set	-1
_int13_diskette_function.num_floppies	set	9
.int13_diskette_function.num_floppies	set	-$19
_int13_diskette_function.BX	set	$32
.int13_diskette_function.BX	set	$10
      sti
! 4878 endasm
!BCC_ENDASM
!BCC_EOS
! 4879       do {
.6E2:
! 4880         val8 = *((Bit8u *)(0x0040));
! Debug: eq unsigned char = [+$40] to unsigned char val8 = [S+$24-$11] (used reg = )
mov	al,[$40]
mov	-$F[bp],al
!BCC_EOS
! 4881         if (val8 == 0) {
! Debug: logeq int = const 0 to unsigned char val8 = [S+$24-$11] (used reg = )
mov	al,-$F[bp]
test	al,al
jne 	.6E3
.6E4:
! 4882           floppy_reset_controller();
! Debug: func () void = floppy_reset_controller+0 (used reg = )
call	_floppy_reset_controller
!BCC_EOS
! 4883           *(((Bit8u *)&AX)+1) = (0x80);
! Debug: eq int = const $80 to unsigned char AX = [S+$24+$15] (used reg = )
mov	al,#$80
mov	$17[bp],al
!BCC_EOS
! 4884           set_diskette_ret_status(0x80);
! Debug: list int = const $80 (used reg = )
mov	ax,#$80
push	ax
! Debug: func () void = set_diskette_ret_status+0 (used reg = )
call	_set_diskette_ret_status
inc	sp
inc	sp
!BCC_EOS
! 4885           FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$24+$1A] (used reg = )
mov	ax,$1C[bp]
or	al,*1
mov	$1C[bp],ax
!BCC_EOS
! 4886           return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 4887         }
! 4888         val8 = (*((Bit8u *)(0x003e)) & 0x80);
.6E3:
! Debug: and int = const $80 to unsigned char = [+$3E] (used reg = )
mov	al,[$3E]
and	al,#$80
! Debug: eq unsigned char = al+0 to unsigned char val8 = [S+$24-$11] (used reg = )
mov	-$F[bp],al
!BCC_EOS
! 4889       } while ( val8 == 0 );
.6E1:
! Debug: logeq int = const 0 to unsigned char val8 = [S+$24-$11] (used reg = )
mov	al,-$F[bp]
test	al,al
je 	.6E2
.6E5:
!BCC_EOS
! 4890       val8 = 0;
.6E0:
! Debug: eq int = const 0 to unsigned char val8 = [S+$24-$11] (used reg = )
xor	al,al
mov	-$F[bp],al
!BCC_EOS
! 4891 #asm
!BCC_EOS
!BCC_ASM
_int13_diskette_function.BP	set	$2E
.int13_diskette_function.BP	set	$C
_int13_diskette_function.CS	set	$3C
.int13_diskette_function.CS	set	$1A
_int13_diskette_function.CX	set	$36
.int13_diskette_function.CX	set	$14
_int13_diskette_function.base_address	set	$1A
.int13_diskette_function.base_address	set	-8
_int13_diskette_function.DI	set	$2A
.int13_diskette_function.DI	set	8
_int13_diskette_function.FLAGS	set	$3E
.int13_diskette_function.FLAGS	set	$1C
_int13_diskette_function.base_count	set	$18
.int13_diskette_function.base_count	set	-$A
_int13_diskette_function.sector	set	$1E
.int13_diskette_function.sector	set	-4
_int13_diskette_function.DS	set	$26
.int13_diskette_function.DS	set	4
_int13_diskette_function.head	set	$1D
.int13_diskette_function.head	set	-5
_int13_diskette_function.ELDX	set	$30
.int13_diskette_function.ELDX	set	$E
_int13_diskette_function.dor	set	$12
.int13_diskette_function.dor	set	-$10
_int13_diskette_function.DX	set	$34
.int13_diskette_function.DX	set	$12
_int13_diskette_function.return_status	set	$B
.int13_diskette_function.return_status	set	-$17
_int13_diskette_function.es	set	4
.int13_diskette_function.es	set	-$1E
_int13_diskette_function.mode_register	set	$14
.int13_diskette_function.mode_register	set	-$E
_int13_diskette_function.ES	set	$28
.int13_diskette_function.ES	set	6
_int13_diskette_function.base_es	set	$16
.int13_diskette_function.base_es	set	-$C
_int13_diskette_function.track	set	$1F
.int13_diskette_function.track	set	-3
_int13_diskette_function.SI	set	$2C
.int13_diskette_function.SI	set	$A
_int13_diskette_function.drive_type	set	$A
.int13_diskette_function.drive_type	set	-$18
_int13_diskette_function.num_sectors	set	$20
.int13_diskette_function.num_sectors	set	-2
_int13_diskette_function.IP	set	$3A
.int13_diskette_function.IP	set	$18
_int13_diskette_function.spt	set	7
.int13_diskette_function.spt	set	-$1B
_int13_diskette_function.status	set	$1C
.int13_diskette_function.status	set	-6
_int13_diskette_function.maxCyl	set	0
.int13_diskette_function.maxCyl	set	-$22
_int13_diskette_function.AX	set	$38
.int13_diskette_function.AX	set	$16
_int13_diskette_function.val8	set	$13
.int13_diskette_function.val8	set	-$F
_int13_diskette_function.last_addr	set	2
.int13_diskette_function.last_addr	set	-$20
_int13_diskette_function.page	set	$15
.int13_diskette_function.page	set	-$D
_int13_diskette_function.ah	set	8
.int13_diskette_function.ah	set	-$1A
_int13_diskette_function.drive	set	$21
.int13_diskette_function.drive	set	-1
_int13_diskette_function.num_floppies	set	9
.int13_diskette_function.num_floppies	set	-$19
_int13_diskette_function.BX	set	$32
.int13_diskette_function.BX	set	$10
      cli
! 4893 endasm
!BCC_ENDASM
!BCC_EOS
! 4894       val8 = *((Bit8u *)(0x003e));
! Debug: eq unsigned char = [+$3E] to unsigned char val8 = [S+$24-$11] (used reg = )
mov	al,[$3E]
mov	-$F[bp],al
!BCC_EOS
! 4895       val8 &= 0x7f;
! Debug: andab int = const $7F to unsigned char val8 = [S+$24-$11] (used reg = )
mov	al,-$F[bp]
and	al,*$7F
mov	-$F[bp],al
!BCC_EOS
! 4896       *((Bit8u *)(0x003e)) = (val8);
! Debug: eq unsigned char val8 = [S+$24-$11] to unsigned char = [+$3E] (used reg = )
mov	al,-$F[bp]
mov	[$3E],al
!BCC_EOS
! 4897       val8 = inb(0x03f4);
! Debug: list int = const $3F4 (used reg = )
mov	ax,#$3F4
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char val8 = [S+$24-$11] (used reg = )
mov	-$F[bp],al
!BCC_EOS
! 4898       if ( (val8 & 0xc0) != 0xc0 )
! Debug: and int = const $C0 to unsigned char val8 = [S+$24-$11] (used reg = )
mov	al,-$F[bp]
and	al,#$C0
! Debug: ne int = const $C0 to unsigned char = al+0 (used reg = )
cmp	al,#$C0
je  	.6E6
.6E7:
! 4899         bios_printf((2 | 4 | 1), "int13_diskette: ctrl not ready\n");
! Debug: list * char = .6E8+0 (used reg = )
mov	bx,#.6E8
push	bx
! Debug: list int = const 7 (used reg = )
mov	ax,*7
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*4
!BCC_EOS
! 4900       return_status[0] = inb(0x03f5);
.6E6:
! Debug: list int = const $3F5 (used reg = )
mov	ax,#$3F5
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char return_status = [S+$24-$19] (used reg = )
mov	-$17[bp],al
!BCC_EOS
! 4901       return_status[1] = inb(0x03f5);
! Debug: list int = const $3F5 (used reg = )
mov	ax,#$3F5
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char return_status = [S+$24-$18] (used reg = )
mov	-$16[bp],al
!BCC_EOS
! 4902       return_status[2] = inb(0x03f5);
! Debug: list int = const $3F5 (used reg = )
mov	ax,#$3F5
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char return_status = [S+$24-$17] (used reg = )
mov	-$15[bp],al
!BCC_EOS
! 4903       return_status[3] = inb(0x03f5);
! Debug: list int = const $3F5 (used reg = )
mov	ax,#$3F5
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char return_status = [S+$24-$16] (used reg = )
mov	-$14[bp],al
!BCC_EOS
! 4904       return_status[4] = inb(0x03f5);
! Debug: list int = const $3F5 (used reg = )
mov	ax,#$3F5
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char return_status = [S+$24-$15] (used reg = )
mov	-$13[bp],al
!BCC_EOS
! 4905       return_status[5] = inb(0x03f5);
! Debug: list int = const $3F5 (used reg = )
mov	ax,#$3F5
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char return_status = [S+$24-$14] (used reg = )
mov	-$12[bp],al
!BCC_EOS
! 4906       return_status[6] = inb(0x03f5);
! Debug: list int = const $3F5 (used reg = )
mov	ax,#$3F5
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char return_status = [S+$24-$13] (used reg = )
mov	-$11[bp],al
!BCC_EOS
! 4907       _memcpyb(0x0042,0x0040,return_status,get_SS(),7);
! Debug: list int = const 7 (used reg = )
mov	ax,*7
push	ax
! Debug: func () unsigned short = get_SS+0 (used reg = )
call	_get_SS
! Debug: list unsigned short = ax+0 (used reg = )
push	ax
! Debug: list * unsigned char return_status = S+$28-$19 (used reg = )
lea	bx,-$17[bp]
push	bx
! Debug: list int = const $40 (used reg = )
mov	ax,*$40
push	ax
! Debug: list int = const $42 (used reg = )
mov	ax,*$42
push	ax
! Debug: func () void = _memcpyb+0 (used reg = )
call	__memcpyb
add	sp,*$A
!BCC_EOS
! 4908       if ( (return_status[0] & 0xc0) != 0 ) {
! Debug: and int = const $C0 to unsigned char return_status = [S+$24-$19] (used reg = )
mov	al,-$17[bp]
and	al,#$C0
! Debug: ne int = const 0 to unsigned char = al+0 (used reg = )
test	al,al
je  	.6E9
.6EA:
! 4909         if ( (return_status[1] & 0x02) != 0 ) {
! Debug: and int = const 2 to unsigned char return_status = [S+$24-$18] (used reg = )
mov	al,-$16[bp]
and	al,*2
! Debug: ne int = const 0 to unsigned char = al+0 (used reg = )
test	al,al
je  	.6EB
.6EC:
! 4910           AX = 0x0300;
! Debug: eq int = const $300 to unsigned short AX = [S+$24+$14] (used reg = )
mov	ax,#$300
mov	$16[bp],ax
!BCC_EOS
! 4911           FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$24+$1A] (used reg = )
mov	ax,$1C[bp]
or	al,*1
mov	$1C[bp],ax
!BCC_EOS
! 4912           return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 4913         } else {
jmp .6ED
.6EB:
! 4914           bios_printf((2 | 4 | 1), "int13_diskette_function: write error\n");
! Debug: list * char = .6EE+0 (used reg = )
mov	bx,#.6EE
push	bx
! Debug: list int = const 7 (used reg = )
mov	ax,*7
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*4
!BCC_EOS
! 4915         }
! 4916       }
.6ED:
! 4917       *(((Bit8u *)&AX)+1) = (0);
.6E9:
! Debug: eq int = const 0 to unsigned char AX = [S+$24+$15] (used reg = )
xor	al,al
mov	$17[bp],al
!BCC_EOS
! 4918       set_diskette_ret_status(0);
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: func () void = set_diskette_ret_status+0 (used reg = )
call	_set_diskette_ret_status
inc	sp
inc	sp
!BCC_EOS
! 4919       set_diskette_current_cyl(drive, 0);
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list unsigned char drive = [S+$26-3] (used reg = )
mov	al,-1[bp]
xor	ah,ah
push	ax
! Debug: func () void = set_diskette_current_cyl+0 (used reg = )
call	_set_diskette_current_cyl
add	sp,*4
!BCC_EOS
! 4920       FLAGS &= 0xfffe;
! Debug: andab unsigned int = const $FFFE to unsigned short FLAGS = [S+$24+$1A] (used reg = )
mov	ax,$1C[bp]
and	al,#$FE
mov	$1C[bp],ax
!BCC_EOS
! 4921       return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 4922     case 0x08:
! 4923 ;
.6EF:
!BCC_EOS
! 4924       drive = ( ELDX & 0x00ff );
! Debug: and int = const $FF to unsigned short ELDX = [S+$24+$C] (used reg = )
mov	al,$E[bp]
! Debug: eq unsigned char = al+0 to unsigned char drive = [S+$24-3] (used reg = )
mov	-1[bp],al
!BCC_EOS
! 4925       if (drive > 1) {
! Debug: gt int = const 1 to unsigned char drive = [S+$24-3] (used reg = )
mov	al,-1[bp]
cmp	al,*1
jbe 	.6F0
.6F1:
! 4926         AX = 0;
! Debug: eq int = const 0 to unsigned short AX = [S+$24+$14] (used reg = )
xor	ax,ax
mov	$16[bp],ax
!BCC_EOS
! 4927         B
! 4927 X = 0;
! Debug: eq int = const 0 to unsigned short BX = [S+$24+$E] (used reg = )
xor	ax,ax
mov	$10[bp],ax
!BCC_EOS
! 4928         CX = 0;
! Debug: eq int = const 0 to unsigned short CX = [S+$24+$12] (used reg = )
xor	ax,ax
mov	$14[bp],ax
!BCC_EOS
! 4929         DX = 0;
! Debug: eq int = const 0 to unsigned short DX = [S+$24+$10] (used reg = )
xor	ax,ax
mov	$12[bp],ax
!BCC_EOS
! 4930         ES = 0;
! Debug: eq int = const 0 to unsigned short ES = [S+$24+4] (used reg = )
xor	ax,ax
mov	6[bp],ax
!BCC_EOS
! 4931         DI = 0;
! Debug: eq int = const 0 to unsigned short DI = [S+$24+6] (used reg = )
xor	ax,ax
mov	8[bp],ax
!BCC_EOS
! 4932         *((Bit8u *)&DX) = (num_floppies);
! Debug: eq unsigned char num_floppies = [S+$24-$1B] to unsigned char DX = [S+$24+$10] (used reg = )
mov	al,-$19[bp]
mov	$12[bp],al
!BCC_EOS
! 4933         FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$24+$1A] (used reg = )
mov	ax,$1C[bp]
or	al,*1
mov	$1C[bp],ax
!BCC_EOS
! 4934         return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 4935       }
! 4936       drive_type = inb_cmos(0x10);
.6F0:
! Debug: list int = const $10 (used reg = )
mov	ax,*$10
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char drive_type = [S+$24-$1A] (used reg = )
mov	-$18[bp],al
!BCC_EOS
! 4937       num_floppies = 0;
! Debug: eq int = const 0 to unsigned char num_floppies = [S+$24-$1B] (used reg = )
xor	al,al
mov	-$19[bp],al
!BCC_EOS
! 4938       if (drive_type & 0xf0)
! Debug: and int = const $F0 to unsigned char drive_type = [S+$24-$1A] (used reg = )
mov	al,-$18[bp]
and	al,#$F0
test	al,al
je  	.6F2
.6F3:
! 4939         num_floppies++;
! Debug: postinc unsigned char num_floppies = [S+$24-$1B] (used reg = )
mov	al,-$19[bp]
inc	ax
mov	-$19[bp],al
!BCC_EOS
! 4940       if (drive_type & 0x0f)
.6F2:
! Debug: and int = const $F to unsigned char drive_type = [S+$24-$1A] (used reg = )
mov	al,-$18[bp]
and	al,*$F
test	al,al
je  	.6F4
.6F5:
! 4941         num_floppies++;
! Debug: postinc unsigned char num_floppies = [S+$24-$1B] (used reg = )
mov	al,-$19[bp]
inc	ax
mov	-$19[bp],al
!BCC_EOS
! 4942       if (drive == 0)
.6F4:
! Debug: logeq int = const 0 to unsigned char drive = [S+$24-3] (used reg = )
mov	al,-1[bp]
test	al,al
jne 	.6F6
.6F7:
! 4943         drive_type >>= 4;
! Debug: srab int = const 4 to unsigned char drive_type = [S+$24-$1A] (used reg = )
mov	al,-$18[bp]
xor	ah,ah
mov	cl,*4
shr	ax,cl
mov	-$18[bp],al
!BCC_EOS
! 4944       else
! 4945         drive_type &= 0x0f;
jmp .6F8
.6F6:
! Debug: andab int = const $F to unsigned char drive_type = [S+$24-$1A] (used reg = )
mov	al,-$18[bp]
and	al,*$F
mov	-$18[bp],al
!BCC_EOS
! 4946       *(((Bit8u *)&BX)+1) = (0);
.6F8:
! Debug: eq int = const 0 to unsigned char BX = [S+$24+$F] (used reg = )
xor	al,al
mov	$11[bp],al
!BCC_EOS
! 4947       *((Bit8u *)&BX) = (drive_type);
! Debug: eq unsigned char drive_type = [S+$24-$1A] to unsigned char BX = [S+$24+$E] (used reg = )
mov	al,-$18[bp]
mov	$10[bp],al
!BCC_EOS
! 4948       *(((Bit8u *)&AX)+1) = (0);
! Debug: eq int = const 0 to unsigned char AX = [S+$24+$15] (used reg = )
xor	al,al
mov	$17[bp],al
!BCC_EOS
! 4949       *((Bit8u *)&AX) = (0);
! Debug: eq int = const 0 to unsigned char AX = [S+$24+$14] (used reg = )
xor	al,al
mov	$16[bp],al
!BCC_EOS
! 4950       *((Bit8u *)&DX) = (num_floppies);
! Debug: eq unsigned char num_floppies = [S+$24-$1B] to unsigned char DX = [S+$24+$10] (used reg = )
mov	al,-$19[bp]
mov	$12[bp],al
!BCC_EOS
! 4951       switch (drive_type) {
mov	al,-$18[bp]
br 	.6FB
! 4952         case 0:
! 4953           CX = 0;
.6FC:
! Debug: eq int = const 0 to unsigned short CX = [S+$24+$12] (used reg = )
xor	ax,ax
mov	$14[bp],ax
!BCC_EOS
! 4954           *(((Bit8u *)&DX)+1) = (0);
! Debug: eq int = const 0 to unsigned char DX = [S+$24+$11] (used reg = )
xor	al,al
mov	$13[bp],al
!BCC_EOS
! 4955           break;
br 	.6F9
!BCC_EOS
! 4956         case 1:
! 4957           CX = 0x2709;
.6FD:
! Debug: eq int = const $2709 to unsigned short CX = [S+$24+$12] (used reg = )
mov	ax,#$2709
mov	$14[bp],ax
!BCC_EOS
! 4958           *(((Bit8u *)&DX)+1) = (1);
! Debug: eq int = const 1 to unsigned char DX = [S+$24+$11] (used reg = )
mov	al,*1
mov	$13[bp],al
!BCC_EOS
! 4959           break;
br 	.6F9
!BCC_EOS
! 4960         case 2:
! 4961           CX = 0x4f0f;
.6FE:
! Debug: eq int = const $4F0F to unsigned short CX = [S+$24+$12] (used reg = )
mov	ax,#$4F0F
mov	$14[bp],ax
!BCC_EOS
! 4962           *(((Bit8u *)&DX)+1) = (1);
! Debug: eq int = const 1 to unsigned char DX = [S+$24+$11] (used reg = )
mov	al,*1
mov	$13[bp],al
!BCC_EOS
! 4963           break;
br 	.6F9
!BCC_EOS
! 4964         case 3:
! 4965           CX = 0x4f09;
.6FF:
! Debug: eq int = const $4F09 to unsigned short CX = [S+$24+$12] (used reg = )
mov	ax,#$4F09
mov	$14[bp],ax
!BCC_EOS
! 4966           *(((Bit8u *)&DX)+1) = (1);
! Debug: eq int = const 1 to unsigned char DX = [S+$24+$11] (used reg = )
mov	al,*1
mov	$13[bp],al
!BCC_EOS
! 4967           break;
jmp .6F9
!BCC_EOS
! 4968         case 4:
! 4969           CX = 0x4f12;
.700:
! Debug: eq int = const $4F12 to unsigned short CX = [S+$24+$12] (used reg = )
mov	ax,#$4F12
mov	$14[bp],ax
!BCC_EOS
! 4970           *(((Bit8u *)&DX)+1) = (1);
! Debug: eq int = const 1 to unsigned char DX = [S+$24+$11] (used reg = )
mov	al,*1
mov	$13[bp],al
!BCC_EOS
! 4971           break;
jmp .6F9
!BCC_EOS
! 4972         case 5:
! 4973           CX = 0x4f24;
.701:
! Debug: eq int = const $4F24 to unsigned short CX = [S+$24+$12] (used reg = )
mov	ax,#$4F24
mov	$14[bp],ax
!BCC_EOS
! 4974           *(((Bit8u *)&DX)+1) = (1);
! Debug: eq int = const 1 to unsigned char DX = [S+$24+$11] (used reg = )
mov	al,*1
mov	$13[bp],al
!BCC_EOS
! 4975           break;
jmp .6F9
!BCC_EOS
! 4976         case 6:
! 4977           CX = 0x2708;
.702:
! Debug: eq int = const $2708 to unsigned short CX = [S+$24+$12] (used reg = )
mov	ax,#$2708
mov	$14[bp],ax
!BCC_EOS
! 4978           *(((Bit8u *)&DX)+1) = (0);
! Debug: eq int = const 0 to unsigned char DX = [S+$24+$11] (used reg = )
xor	al,al
mov	$13[bp],al
!BCC_EOS
! 4979           break;
jmp .6F9
!BCC_EOS
! 4980         case 7:
! 4981           CX = 0x2709;
.703:
! Debug: eq int = const $2709 to unsigned short CX = [S+$24+$12] (used reg = )
mov	ax,#$2709
mov	$14[bp],ax
!BCC_EOS
! 4982           *(((Bit8u *)&DX)+1) = (0);
! Debug: eq int = const 0 to unsigned char DX = [S+$24+$11] (used reg = )
xor	al,al
mov	$13[bp],al
!BCC_EOS
! 4983           break;
jmp .6F9
!BCC_EOS
! 4984         case 8:
! 4985           CX = 0x2708;
.704:
! Debug: eq int = const $2708 to unsigned short CX = [S+$24+$12] (used reg = )
mov	ax,#$2708
mov	$14[bp],ax
!BCC_EOS
! 4986           *(((Bit8u *)&DX)+1) = (1);
! Debug: eq int = const 1 to unsigned char DX = [S+$24+$11] (used reg = )
mov	al,*1
mov	$13[bp],al
!BCC_EOS
! 4987           break;
jmp .6F9
!BCC_EOS
! 4988         default:
! 4989           bios_printf((2 | 4 | 1), "floppy: int13: bad floppy type\n");
.705:
! Debug: list * char = .706+0 (used reg = )
mov	bx,#.706
push	bx
! Debug: list int = const 7 (used reg = )
mov	ax,*7
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*4
!BCC_EOS
! 4990         }
! 4991 #asm
jmp .6F9
.6FB:
sub	al,*0
jb 	.705
cmp	al,*8
ja  	.707
xor	ah,ah
shl	ax,*1
mov	bx,ax
seg	cs
br	.708[bx]
.708:
.word	.6FC
.word	.6FD
.word	.6FE
.word	.6FF
.word	.700
.word	.701
.word	.702
.word	.703
.word	.704
.707:
jmp	.705
.6F9:
!BCC_EOS
!BCC_ASM
_int13_diskette_function.BP	set	$2E
.int13_diskette_function.BP	set	$C
_int13_diskette_function.CS	set	$3C
.int13_diskette_function.CS	set	$1A
_int13_diskette_function.CX	set	$36
.int13_diskette_function.CX	set	$14
_int13_diskette_function.base_address	set	$1A
.int13_diskette_function.base_address	set	-8
_int13_diskette_function.DI	set	$2A
.int13_diskette_function.DI	set	8
_int13_diskette_function.FLAGS	set	$3E
.int13_diskette_function.FLAGS	set	$1C
_int13_diskette_function.base_count	set	$18
.int13_diskette_function.base_count	set	-$A
_int13_diskette_function.sector	set	$1E
.int13_diskette_function.sector	set	-4
_int13_diskette_function.DS	set	$26
.int13_diskette_function.DS	set	4
_int13_diskette_function.head	set	$1D
.int13_diskette_function.head	set	-5
_int13_diskette_function.ELDX	set	$30
.int13_diskette_function.ELDX	set	$E
_int13_diskette_function.dor	set	$12
.int13_diskette_function.dor	set	-$10
_int13_diskette_function.DX	set	$34
.int13_diskette_function.DX	set	$12
_int13_diskette_function.return_status	set	$B
.int13_diskette_function.return_status	set	-$17
_int13_diskette_function.es	set	4
.int13_diskette_function.es	set	-$1E
_int13_diskette_function.mode_register	set	$14
.int13_diskette_function.mode_register	set	-$E
_int13_diskette_function.ES	set	$28
.int13_diskette_function.ES	set	6
_int13_diskette_function.base_es	set	$16
.int13_diskette_function.base_es	set	-$C
_int13_diskette_function.track	set	$1F
.int13_diskette_function.track	set	-3
_int13_diskette_function.SI	set	$2C
.int13_diskette_function.SI	set	$A
_int13_diskette_function.drive_type	set	$A
.int13_diskette_function.drive_type	set	-$18
_int13_diskette_function.num_sectors	set	$20
.int13_diskette_function.num_sectors	set	-2
_int13_diskette_function.IP	set	$3A
.int13_diskette_function.IP	set	$18
_int13_diskette_function.spt	set	7
.int13_diskette_function.spt	set	-$1B
_int13_diskette_function.status	set	$1C
.int13_diskette_function.status	set	-6
_int13_diskette_function.maxCyl	set	0
.int13_diskette_function.maxCyl	set	-$22
_int13_diskette_function.AX	set	$38
.int13_diskette_function.AX	set	$16
_int13_diskette_function.val8	set	$13
.int13_diskette_function.val8	set	-$F
_int13_diskette_function.last_addr	set	2
.int13_diskette_function.last_addr	set	-$20
_int13_diskette_function.page	set	$15
.int13_diskette_function.page	set	-$D
_int13_diskette_function.ah	set	8
.int13_diskette_function.ah	set	-$1A
_int13_diskette_function.drive	set	$21
.int13_diskette_function.drive	set	-1
_int13_diskette_function.num_floppies	set	9
.int13_diskette_function.num_floppies	set	-$19
_int13_diskette_function.BX	set	$32
.int13_diskette_function.BX	set	$10
      push bp
      mov bp, sp
      mov ax, #diskette_param_table2
      mov _int13_diskette_function.DI+2[bp], ax
      mov _int13_diskette_function.ES+2[bp], cs
      pop bp
! 4998 endasm
!BCC_ENDASM
!BCC_EOS
! 4999       FLAGS &= 0xfffe;
! Debug: andab unsigned int = const $FFFE to unsigned short FLAGS = [S+$24+$1A] (used reg = )
mov	ax,$1C[bp]
and	al,#$FE
mov	$1C[bp],ax
!BCC_EOS
! 5000       return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 5001     case 0x15:
! 5002 ;
.709:
!BCC_EOS
! 5003       drive = ( ELDX & 0x00ff );
! Debug: and int = const $FF to unsigned short ELDX = [S+$24+$C] (used reg = )
mov	al,$E[bp]
! Debug: eq unsigned char = al+0 to unsigned char drive = [S+$24-3] (used reg = )
mov	-1[bp],al
!BCC_EOS
! 5004       if (drive > 1) {
! Debug: gt int = const 1 to unsigned char drive = [S+$24-3] (used reg = )
mov	al,-1[bp]
cmp	al,*1
jbe 	.70A
.70B:
! 5005         *(((Bit8u *)&AX)+1) = (0);
! Debug: eq int = const 0 to unsigned char AX = [S+$24+$15] (used reg = )
xor	al,al
mov	$17[bp],al
!BCC_EOS
! 5006         FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$24+$1A] (used reg = )
mov	ax,$1C[bp]
or	al,*1
mov	$1C[bp],ax
!BCC_EOS
! 5007         return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 5008       }
! 5009       drive_type = inb_cmos(0x10);
.70A:
! Debug: list int = const $10 (used reg = )
mov	ax,*$10
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char drive_type = [S+$24-$1A] (used reg = )
mov	-$18[bp],al
!BCC_EOS
! 5010       if (drive == 0)
! Debug: logeq int = const 0 to unsigned char drive = [S+$24-3] (used reg = )
mov	al,-1[bp]
test	al,al
jne 	.70C
.70D:
! 5011         drive_type >>= 4;
! Debug: srab int = const 4 to unsigned char drive_type = [S+$24-$1A] (used reg = )
mov	al,-$18[bp]
xor	ah,ah
mov	cl,*4
shr	ax,cl
mov	-$18[bp],al
!BCC_EOS
! 5012       else
! 5013         drive_type &= 0x
jmp .70E
.70C:
! 5013 0f;
! Debug: andab int = const $F to unsigned char drive_type = [S+$24-$1A] (used reg = )
mov	al,-$18[bp]
and	al,*$F
mov	-$18[bp],al
!BCC_EOS
! 5014       FLAGS &= 0xfffe;
.70E:
! Debug: andab unsigned int = const $FFFE to unsigned short FLAGS = [S+$24+$1A] (used reg = )
mov	ax,$1C[bp]
and	al,#$FE
mov	$1C[bp],ax
!BCC_EOS
! 5015       if (drive_type==0) {
! Debug: logeq int = const 0 to unsigned char drive_type = [S+$24-$1A] (used reg = )
mov	al,-$18[bp]
test	al,al
jne 	.70F
.710:
! 5016         *(((Bit8u *)&AX)+1) = (0);
! Debug: eq int = const 0 to unsigned char AX = [S+$24+$15] (used reg = )
xor	al,al
mov	$17[bp],al
!BCC_EOS
! 5017       }
! 5018       else {
jmp .711
.70F:
! 5019         *(((Bit8u *)&AX)+1) = (1);
! Debug: eq int = const 1 to unsigned char AX = [S+$24+$15] (used reg = )
mov	al,*1
mov	$17[bp],al
!BCC_EOS
! 5020       }
! 5021       return;
.711:
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 5022     case 0x16:
! 5023 ;
.712:
!BCC_EOS
! 5024       drive = ( ELDX & 0x00ff );
! Debug: and int = const $FF to unsigned short ELDX = [S+$24+$C] (used reg = )
mov	al,$E[bp]
! Debug: eq unsigned char = al+0 to unsigned char drive = [S+$24-3] (used reg = )
mov	-1[bp],al
!BCC_EOS
! 5025       if (drive > 1) {
! Debug: gt int = const 1 to unsigned char drive = [S+$24-3] (used reg = )
mov	al,-1[bp]
cmp	al,*1
jbe 	.713
.714:
! 5026         *(((Bit8u *)&AX)+1) = (0x01);
! Debug: eq int = const 1 to unsigned char AX = [S+$24+$15] (used reg = )
mov	al,*1
mov	$17[bp],al
!BCC_EOS
! 5027         set_diskette_ret_status(0x01);
! Debug: list int = const 1 (used reg = )
mov	ax,*1
push	ax
! Debug: func () void = set_diskette_ret_status+0 (used reg = )
call	_set_diskette_ret_status
inc	sp
inc	sp
!BCC_EOS
! 5028         FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$24+$1A] (used reg = )
mov	ax,$1C[bp]
or	al,*1
mov	$1C[bp],ax
!BCC_EOS
! 5029         return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 5030       }
! 5031       *(((Bit8u *)&AX)+1) = (0x06);
.713:
! Debug: eq int = const 6 to unsigned char AX = [S+$24+$15] (used reg = )
mov	al,*6
mov	$17[bp],al
!BCC_EOS
! 5032       set_diskette_ret_status(0x06);
! Debug: list int = const 6 (used reg = )
mov	ax,*6
push	ax
! Debug: func () void = set_diskette_ret_status+0 (used reg = )
call	_set_diskette_ret_status
inc	sp
inc	sp
!BCC_EOS
! 5033       FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$24+$1A] (used reg = )
mov	ax,$1C[bp]
or	al,*1
mov	$1C[bp],ax
!BCC_EOS
! 5034       return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 5035     case 0x17:
! 5036 ;
.715:
!BCC_EOS
! 5037       drive = ( ELDX & 0x00ff );
! Debug: and int = const $FF to unsigned short ELDX = [S+$24+$C] (used reg = )
mov	al,$E[bp]
! Debug: eq unsigned char = al+0 to unsigned char drive = [S+$24-3] (used reg = )
mov	-1[bp],al
!BCC_EOS
! 5038       drive_type = ( AX & 0x00ff );
! Debug: and int = const $FF to unsigned short AX = [S+$24+$14] (used reg = )
mov	al,$16[bp]
! Debug: eq unsigned char = al+0 to unsigned char drive_type = [S+$24-$1A] (used reg = )
mov	-$18[bp],al
!BCC_EOS
! 5039       if (drive > 1) {
! Debug: gt int = const 1 to unsigned char drive = [S+$24-3] (used reg = )
mov	al,-1[bp]
cmp	al,*1
jbe 	.716
.717:
! 5040         *(((Bit8u *)&AX)+1) = (0x01);
! Debug: eq int = const 1 to unsigned char AX = [S+$24+$15] (used reg = )
mov	al,*1
mov	$17[bp],al
!BCC_EOS
! 5041         set_diskette_ret_status(1);
! Debug: list int = const 1 (used reg = )
mov	ax,*1
push	ax
! Debug: func () void = set_diskette_ret_status+0 (used reg = )
call	_set_diskette_ret_status
inc	sp
inc	sp
!BCC_EOS
! 5042         FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$24+$1A] (used reg = )
mov	ax,$1C[bp]
or	al,*1
mov	$1C[bp],ax
!BCC_EOS
! 5043         return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 5044       }
! 5045       if (floppy_drive_exists(drive) == 0) {
.716:
! Debug: list unsigned char drive = [S+$24-3] (used reg = )
mov	al,-1[bp]
xor	ah,ah
push	ax
! Debug: func () unsigned short = floppy_drive_exists+0 (used reg = )
call	_floppy_drive_exists
inc	sp
inc	sp
! Debug: logeq int = const 0 to unsigned short = ax+0 (used reg = )
test	ax,ax
jne 	.718
.719:
! 5046         *(((Bit8u *)&AX)+1) = (0x80);
! Debug: eq int = const $80 to unsigned char AX = [S+$24+$15] (used reg = )
mov	al,#$80
mov	$17[bp],al
!BCC_EOS
! 5047         set_diskette_ret_status(0x80);
! Debug: list int = const $80 (used reg = )
mov	ax,#$80
push	ax
! Debug: func () void = set_diskette_ret_status+0 (used reg = )
call	_set_diskette_ret_status
inc	sp
inc	sp
!BCC_EOS
! 5048         FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$24+$1A] (used reg = )
mov	ax,$1C[bp]
or	al,*1
mov	$1C[bp],ax
!BCC_EOS
! 5049         return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 5050       }
! 5051       base_address = (drive) ? 0x0091 : 0x0090;
.718:
mov	al,-1[bp]
test	al,al
je  	.71A
.71B:
mov	al,#$91
jmp .71C
.71A:
mov	al,#$90
.71C:
! Debug: eq char = al+0 to unsigned short base_address = [S+$24-$A] (used reg = )
xor	ah,ah
mov	-8[bp],ax
!BCC_EOS
! 5052       status = *((Bit8u *)(base_address));
mov	bx,-8[bp]
! Debug: eq unsigned char = [bx+0] to unsigned char status = [S+$24-8] (used reg = )
mov	al,[bx]
mov	-6[bp],al
!BCC_EOS
! 5053       val8 = status & 0x0f;
! Debug: and int = const $F to unsigned char status = [S+$24-8] (used reg = )
mov	al,-6[bp]
and	al,*$F
! Debug: eq unsigned char = al+0 to unsigned char val8 = [S+$24-$11] (used reg = )
mov	-$F[bp],al
!BCC_EOS
! 5054       switch(drive_type) {
mov	al,-$18[bp]
jmp .71F
! 5055         case 1:
! 5056           val8 |= 0x90;
.720:
! Debug: orab int = const $90 to unsigned char val8 = [S+$24-$11] (used reg = )
mov	al,-$F[bp]
or	al,#$90
mov	-$F[bp],al
!BCC_EOS
! 5057           break;
jmp .71D
!BCC_EOS
! 5058         case 2:
! 5059           val8 |= 0x70;
.721:
! Debug: orab int = const $70 to unsigned char val8 = [S+$24-$11] (used reg = )
mov	al,-$F[bp]
or	al,*$70
mov	-$F[bp],al
!BCC_EOS
! 5060           break;
jmp .71D
!BCC_EOS
! 5061         case 3:
! 5062           val8 |= 0x10;
.722:
! Debug: orab int = const $10 to unsigned char val8 = [S+$24-$11] (used reg = )
mov	al,-$F[bp]
or	al,*$10
mov	-$F[bp],al
!BCC_EOS
! 5063           break;
jmp .71D
!BCC_EOS
! 5064         case 4:
! 5065           if (((status >> 4) & 0x01) && ((status >> 1) & 0x01))
.723:
! Debug: sr int = const 4 to unsigned char status = [S+$24-8] (used reg = )
mov	al,-6[bp]
xor	ah,ah
mov	cl,*4
shr	ax,cl
! Debug: and int = const 1 to unsigned int = ax+0 (used reg = )
and	al,*1
test	al,al
je  	.724
.726:
! Debug: sr int = const 1 to unsigned char status = [S+$24-8] (used reg = )
mov	al,-6[bp]
xor	ah,ah
shr	ax,*1
! Debug: and int = const 1 to unsigned int = ax+0 (used reg = )
and	al,*1
test	al,al
je  	.724
.725:
! 5066           {
! 5067             val8 |= 0x50;
! Debug: orab int = const $50 to unsigned char val8 = [S+$24-$11] (used reg = )
mov	al,-$F[bp]
or	al,*$50
mov	-$F[bp],al
!BCC_EOS
! 5068           }
! 5069           else
! 5070           {
jmp .727
.724:
! 5071             val8 |= 0x90;
! Debug: orab int = const $90 to unsigned char val8 = [S+$24-$11] (used reg = )
mov	al,-$F[bp]
or	al,#$90
mov	-$F[bp],al
!BCC_EOS
! 5072           }
! 5073           break;
.727:
jmp .71D
!BCC_EOS
! 5074         default:
! 5075           *(((Bit8u *)&AX)+1) = (0x01);
.728:
! Debug: eq int = const 1 to unsigned char AX = [S+$24+$15] (used reg = )
mov	al,*1
mov	$17[bp],al
!BCC_EOS
! 5076           set_diskette_ret_status(1);
! Debug: list int = const 1 (used reg = )
mov	ax,*1
push	ax
! Debug: func () void = set_diskette_ret_status+0 (used reg = )
call	_set_diskette_ret_status
inc	sp
inc	sp
!BCC_EOS
! 5077           FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$24+$1A] (used reg = )
mov	ax,$1C[bp]
or	al,*1
mov	$1C[bp],ax
!BCC_EOS
! 5078           return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 5079       }
! 5080 ;
jmp .71D
.71F:
sub	al,*1
je 	.720
sub	al,*1
je 	.721
sub	al,*1
je 	.722
sub	al,*1
je 	.723
jmp	.728
.71D:
!BCC_EOS
! 5081       *((Bit8u *)(base_address)) = (val8);
mov	bx,-8[bp]
! Debug: eq unsigned char val8 = [S+$24-$11] to unsigned char = [bx+0] (used reg = )
mov	al,-$F[bp]
mov	[bx],al
!BCC_EOS
! 5082       *(((Bit8u *)&AX)+1) = (0);
! Debug: eq int = const 0 to unsigned char AX = [S+$24+$15] (used reg = )
xor	al,al
mov	$17[bp],al
!BCC_EOS
! 5083       set_diskette_ret_status(0);
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: func () void = set_diskette_ret_status+0 (used reg = )
call	_set_diskette_ret_status
inc	sp
inc	sp
!BCC_EOS
! 5084       FLAGS &= 0xfffe;
! Debug: andab unsigned int = const $FFFE to unsigned short FLAGS = [S+$24+$1A] (used reg = )
mov	ax,$1C[bp]
and	al,#$FE
mov	$1C[bp],ax
!BCC_EOS
! 5085       return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 5086     case 0x18:
! 5087 ;
.729:
!BCC_EOS
! 5088       drive = ( ELDX & 0x00ff );
! Debug: and int = const $FF to unsigned short ELDX = [S+$24+$C] (used reg = )
mov	al,$E[bp]
! Debug: eq unsigned char = al+0 to unsigned char drive = [S+$24-3] (used reg = )
mov	-1[bp],al
!BCC_EOS
! 5089       val8 = ( CX & 0x00ff );
! Debug: and int = const $FF to unsigned short CX = [S+$24+$12] (used reg = )
mov	al,$14[bp]
! Debug: eq unsigned char = al+0 to unsigned char val8 = [S+$24-$11] (used reg = )
mov	-$F[bp],al
!BCC_EOS
! 5090       spt = val8 & 0x3f;
! Debug: and int = const $3F to unsigned char val8 = [S+$24-$11] (used reg = )
mov	al,-$F[bp]
and	al,*$3F
! Debug: eq unsigned char = al+0 to unsigned char spt = [S+$24-$1D] (used reg = )
mov	-$1B[bp],al
!BCC_EOS
! 5091       maxCyl = ((val8 >> 6) << 8) + *(((Bit8u *)&CX)+1);
! Debug: sr int = const 6 to unsigned char val8 = [S+$24-$11] (used reg = )
mov	al,-$F[bp]
xor	ah,ah
mov	cl,*6
shr	ax,cl
! Debug: sl int = const 8 to unsigned int = ax+0 (used reg = )
mov	ah,al
xor	al,al
! Debug: add unsigned char CX = [S+$24+$13] to unsigned int = ax+0 (used reg = )
add	al,$15[bp]
adc	ah,*0
! Debug: eq unsigned int = ax+0 to unsigned short maxCyl = [S+$24-$24] (used reg = )
mov	-$22[bp],ax
!BCC_EOS
! 5092 ;
!BCC_EOS
! 5093       if (drive > 1) {
! Debug: gt int = const 1 to unsigned char drive = [S+$24-3] (used reg = )
mov	al,-1[bp]
cmp	al,*1
jbe 	.72A
.72B:
! 5094         *(((Bit8u *)&AX)+1) = (0x01);
! Debug: eq int = const 1 to unsigned char AX = [S+$24+$15] (used reg = )
mov	al,*1
mov	$17[bp],al
!BCC_EOS
! 5095         set_diskette_ret_status(1);
! Debug: list int = const 1 (used reg = )
mov	ax,*1
push	ax
! Debug: func () void = set_diskette_ret_status+0 (used reg = )
call	_set_diskette_ret_status
inc	sp
inc	sp
!BCC_EOS
! 5096         FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$24+$1A] (used reg = )
mov	ax,$1C[bp]
or	al,*1
mov	$1C[bp],ax
!BCC_EOS
! 5097         return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 5098       }
! 5099       if (floppy_drive_exists(dri
.72A:
! 5099 ve) == 0) {
! Debug: list unsigned char drive = [S+$24-3] (used reg = )
mov	al,-1[bp]
xor	ah,ah
push	ax
! Debug: func () unsigned short = floppy_drive_exists+0 (used reg = )
call	_floppy_drive_exists
inc	sp
inc	sp
! Debug: logeq int = const 0 to unsigned short = ax+0 (used reg = )
test	ax,ax
jne 	.72C
.72D:
! 5100         *(((Bit8u *)&AX)+1) = (0x80);
! Debug: eq int = const $80 to unsigned char AX = [S+$24+$15] (used reg = )
mov	al,#$80
mov	$17[bp],al
!BCC_EOS
! 5101         set_diskette_ret_status(0x80);
! Debug: list int = const $80 (used reg = )
mov	ax,#$80
push	ax
! Debug: func () void = set_diskette_ret_status+0 (used reg = )
call	_set_diskette_ret_status
inc	sp
inc	sp
!BCC_EOS
! 5102         FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$24+$1A] (used reg = )
mov	ax,$1C[bp]
or	al,*1
mov	$1C[bp],ax
!BCC_EOS
! 5103         return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 5104       }
! 5105       if (floppy_media_known(drive) == 0) {
.72C:
! Debug: list unsigned char drive = [S+$24-3] (used reg = )
mov	al,-1[bp]
xor	ah,ah
push	ax
! Debug: func () unsigned short = floppy_media_known+0 (used reg = )
call	_floppy_media_known
inc	sp
inc	sp
! Debug: logeq int = const 0 to unsigned short = ax+0 (used reg = )
test	ax,ax
jne 	.72E
.72F:
! 5106         if (floppy_media_sense(drive) == 0) {
! Debug: list unsigned char drive = [S+$24-3] (used reg = )
mov	al,-1[bp]
xor	ah,ah
push	ax
! Debug: func () unsigned short = floppy_media_sense+0 (used reg = )
call	_floppy_media_sense
inc	sp
inc	sp
! Debug: logeq int = const 0 to unsigned short = ax+0 (used reg = )
test	ax,ax
jne 	.730
.731:
! 5107           *(((Bit8u *)&AX)+1) = (0x0C);
! Debug: eq int = const $C to unsigned char AX = [S+$24+$15] (used reg = )
mov	al,*$C
mov	$17[bp],al
!BCC_EOS
! 5108           set_diskette_ret_status(0x0C);
! Debug: list int = const $C (used reg = )
mov	ax,*$C
push	ax
! Debug: func () void = set_diskette_ret_status+0 (used reg = )
call	_set_diskette_ret_status
inc	sp
inc	sp
!BCC_EOS
! 5109           FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$24+$1A] (used reg = )
mov	ax,$1C[bp]
or	al,*1
mov	$1C[bp],ax
!BCC_EOS
! 5110           return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 5111         }
! 5112       }
.730:
! 5113       drive_type = inb_cmos(0x10);
.72E:
! Debug: list int = const $10 (used reg = )
mov	ax,*$10
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char drive_type = [S+$24-$1A] (used reg = )
mov	-$18[bp],al
!BCC_EOS
! 5114       if (drive == 0)
! Debug: logeq int = const 0 to unsigned char drive = [S+$24-3] (used reg = )
mov	al,-1[bp]
test	al,al
jne 	.732
.733:
! 5115         drive_type >>= 4;
! Debug: srab int = const 4 to unsigned char drive_type = [S+$24-$1A] (used reg = )
mov	al,-$18[bp]
xor	ah,ah
mov	cl,*4
shr	ax,cl
mov	-$18[bp],al
!BCC_EOS
! 5116       else
! 5117         drive_type &= 0x0f;
jmp .734
.732:
! Debug: andab int = const $F to unsigned char drive_type = [S+$24-$1A] (used reg = )
mov	al,-$18[bp]
and	al,*$F
mov	-$18[bp],al
!BCC_EOS
! 5118       base_address = (drive) ? 0x0091 : 0x0090;
.734:
mov	al,-1[bp]
test	al,al
je  	.735
.736:
mov	al,#$91
jmp .737
.735:
mov	al,#$90
.737:
! Debug: eq char = al+0 to unsigned short base_address = [S+$24-$A] (used reg = )
xor	ah,ah
mov	-8[bp],ax
!BCC_EOS
! 5119       status = *((Bit8u *)(base_address));
mov	bx,-8[bp]
! Debug: eq unsigned char = [bx+0] to unsigned char status = [S+$24-8] (used reg = )
mov	al,[bx]
mov	-6[bp],al
!BCC_EOS
! 5120       val8 = status & 0x0f;
! Debug: and int = const $F to unsigned char status = [S+$24-8] (used reg = )
mov	al,-6[bp]
and	al,*$F
! Debug: eq unsigned char = al+0 to unsigned char val8 = [S+$24-$11] (used reg = )
mov	-$F[bp],al
!BCC_EOS
! 5121       *(((Bit8u *)&AX)+1) = (0x0C);
! Debug: eq int = const $C to unsigned char AX = [S+$24+$15] (used reg = )
mov	al,*$C
mov	$17[bp],al
!BCC_EOS
! 5122       switch (drive_type) {
mov	al,-$18[bp]
br 	.73A
! 5123         case 0:
! 5124           break;
.73B:
br 	.738
!BCC_EOS
! 5125         case 1:
! 5126         case 6:
.73C:
! 5127         case 7:
.73D:
! 5128         case 8:
.73E:
! 5129           if (maxCyl == 39 && (spt == 8 || spt == 9))
.73F:
! Debug: logeq int = const $27 to unsigned short maxCyl = [S+$24-$24] (used reg = )
mov	ax,-$22[bp]
cmp	ax,*$27
jne 	.740
.742:
! Debug: logeq int = const 8 to unsigned char spt = [S+$24-$1D] (used reg = )
mov	al,-$1B[bp]
cmp	al,*8
je  	.741
.743:
! Debug: logeq int = const 9 to unsigned char spt = [S+$24-$1D] (used reg = )
mov	al,-$1B[bp]
cmp	al,*9
jne 	.740
.741:
! 5130           {
! 5131             val8 |= 0x90;
! Debug: orab int = const $90 to unsigned char val8 = [S+$24-$11] (used reg = )
mov	al,-$F[bp]
or	al,#$90
mov	-$F[bp],al
!BCC_EOS
! 5132             *(((Bit8u *)&AX)+1) = (0);
! Debug: eq int = const 0 to unsigned char AX = [S+$24+$15] (used reg = )
xor	al,al
mov	$17[bp],al
!BCC_EOS
! 5133           }
! 5134           break;
.740:
br 	.738
!BCC_EOS
! 5135         case 2:
! 5136           if (maxCyl == 39 && (spt == 8 || spt == 9))
.744:
! Debug: logeq int = const $27 to unsigned short maxCyl = [S+$24-$24] (used reg = )
mov	ax,-$22[bp]
cmp	ax,*$27
jne 	.745
.747:
! Debug: logeq int = const 8 to unsigned char spt = [S+$24-$1D] (used reg = )
mov	al,-$1B[bp]
cmp	al,*8
je  	.746
.748:
! Debug: logeq int = const 9 to unsigned char spt = [S+$24-$1D] (used reg = )
mov	al,-$1B[bp]
cmp	al,*9
jne 	.745
.746:
! 5137           {
! 5138             val8 |= 0x70;
! Debug: orab int = const $70 to unsigned char val8 = [S+$24-$11] (used reg = )
mov	al,-$F[bp]
or	al,*$70
mov	-$F[bp],al
!BCC_EOS
! 5139             *(((Bit8u *)&AX)+1) = (0);
! Debug: eq int = const 0 to unsigned char AX = [S+$24+$15] (used reg = )
xor	al,al
mov	$17[bp],al
!BCC_EOS
! 5140           }
! 5141           else if (maxCyl == 79 && spt == 15)
jmp .749
.745:
! Debug: logeq int = const $4F to unsigned short maxCyl = [S+$24-$24] (used reg = )
mov	ax,-$22[bp]
cmp	ax,*$4F
jne 	.74A
.74C:
! Debug: logeq int = const $F to unsigned char spt = [S+$24-$1D] (used reg = )
mov	al,-$1B[bp]
cmp	al,*$F
jne 	.74A
.74B:
! 5142           {
! 5143             val8 |= 0x10;
! Debug: orab int = const $10 to unsigned char val8 = [S+$24-$11] (used reg = )
mov	al,-$F[bp]
or	al,*$10
mov	-$F[bp],al
!BCC_EOS
! 5144             *(((Bit8u *)&AX)+1) = (0);
! Debug: eq int = const 0 to unsigned char AX = [S+$24+$15] (used reg = )
xor	al,al
mov	$17[bp],al
!BCC_EOS
! 5145           }
! 5146           break;
.74A:
.749:
br 	.738
!BCC_EOS
! 5147         case 3:
! 5148           if (maxCyl == 79 && spt == 9)
.74D:
! Debug: logeq int = const $4F to unsigned short maxCyl = [S+$24-$24] (used reg = )
mov	ax,-$22[bp]
cmp	ax,*$4F
jne 	.74E
.750:
! Debug: logeq int = const 9 to unsigned char spt = [S+$24-$1D] (used reg = )
mov	al,-$1B[bp]
cmp	al,*9
jne 	.74E
.74F:
! 5149           {
! 5150             val8 |= 0x90;
! Debug: orab int = const $90 to unsigned char val8 = [S+$24-$11] (used reg = )
mov	al,-$F[bp]
or	al,#$90
mov	-$F[bp],al
!BCC_EOS
! 5151             *(((Bit8u *)&AX)+1) = (0);
! Debug: eq int = const 0 to unsigned char AX = [S+$24+$15] (used reg = )
xor	al,al
mov	$17[bp],al
!BCC_EOS
! 5152           }
! 5153           break;
.74E:
br 	.738
!BCC_EOS
! 5154         case 4:
! 5155           if (maxCyl == 79)
.751:
! Debug: logeq int = const $4F to unsigned short maxCyl = [S+$24-$24] (used reg = )
mov	ax,-$22[bp]
cmp	ax,*$4F
jne 	.752
.753:
! 5156           {
! 5157             if (spt == 9)
! Debug: logeq int = const 9 to unsigned char spt = [S+$24-$1D] (used reg = )
mov	al,-$1B[bp]
cmp	al,*9
jne 	.754
.755:
! 5158             {
! 5159               val8 |= 0x90;
! Debug: orab int = const $90 to unsigned char val8 = [S+$24-$11] (used reg = )
mov	al,-$F[bp]
or	al,#$90
mov	-$F[bp],al
!BCC_EOS
! 5160               *(((Bit8u *)&AX)+1) = (0);
! Debug: eq int = const 0 to unsigned char AX = [S+$24+$15] (used reg = )
xor	al,al
mov	$17[bp],al
!BCC_EOS
! 5161             }
! 5162             else if (spt == 18)
jmp .756
.754:
! Debug: logeq int = const $12 to unsigned char spt = [S+$24-$1D] (used reg = )
mov	al,-$1B[bp]
cmp	al,*$12
jne 	.757
.758:
! 5163             {
! 5164               val8 |= 0x10;
! Debug: orab int = const $10 to unsigned char val8 = [S+$24-$11] (used reg = )
mov	al,-$F[bp]
or	al,*$10
mov	-$F[bp],al
!BCC_EOS
! 5165               *(((Bit8u *)&AX)+1) = (0);
! Debug: eq int = const 0 to unsigned char AX = [S+$24+$15] (used reg = )
xor	al,al
mov	$17[bp],al
!BCC_EOS
! 5166             }
! 5167           }
.757:
.756:
! 5168           break;
.752:
br 	.738
!BCC_EOS
! 5169         case 5:
! 5170           if (maxCyl == 79)
.759:
! Debug: logeq int = const $4F to unsigned short maxCyl = [S+$24-$24] (used reg = )
mov	ax,-$22[bp]
cmp	ax,*$4F
jne 	.75A
.75B:
! 5171           {
! 5172             if (spt == 9)
! Debug: logeq int = const 9 to unsigned char spt = [S+$24-$1D] (used reg = )
mov	al,-$1B[bp]
cmp	al,*9
jne 	.75C
.75D:
! 5173             {
! 5174               val8 |= 0x90;
! Debug: orab int = const $90 to unsigned char val8 = [S+$24-$11] (used reg = )
mov	al,-$F[bp]
or	al,#$90
mov	-$F[bp],al
!BCC_EOS
! 5175               *(((Bit8u *)&AX)+1) = (0);
! Debug: eq int = const 0 to unsigned char AX = [S+$24+$15] (used reg = )
xor	al,al
mov	$17[bp],al
!BCC_EOS
! 5176             }
! 5177             else if (spt == 18)
jmp .75E
.75C:
! Debug: logeq int = const $12 to unsigned char spt = [S+$24-$1D] (used reg = )
mov	al,-$1B[bp]
cmp	al,*$12
jne 	.75F
.760:
! 5178             {
! 5179               val8 |= 0x10;
! Debug: orab int = const $10 to unsigned char val8 = [S+$24-$11] (used reg = )
mov	al,-$F[bp]
or	al,*$10
mov	-$F[bp],al
!BCC_EOS
! 5180               *(((Bit8u *)&AX)+1) = (0);
! Debug: eq int = const 0 to unsigned char AX = [S+$24+$15] (used reg = )
xor	al,al
mov	$17[bp],al
!BCC_EOS
! 5181           
! 5181   }
! 5182             else if (spt == 36)
jmp .761
.75F:
! Debug: logeq int = const $24 to unsigned char spt = [S+$24-$1D] (used reg = )
mov	al,-$1B[bp]
cmp	al,*$24
jne 	.762
.763:
! 5183             {
! 5184               val8 |= 0xD0;
! Debug: orab int = const $D0 to unsigned char val8 = [S+$24-$11] (used reg = )
mov	al,-$F[bp]
or	al,#$D0
mov	-$F[bp],al
!BCC_EOS
! 5185               *(((Bit8u *)&AX)+1) = (0);
! Debug: eq int = const 0 to unsigned char AX = [S+$24+$15] (used reg = )
xor	al,al
mov	$17[bp],al
!BCC_EOS
! 5186             }
! 5187           }
.762:
.761:
.75E:
! 5188           break;
.75A:
jmp .738
!BCC_EOS
! 5189         default:
! 5190           break;
.764:
jmp .738
!BCC_EOS
! 5191       }
! 5192       if (0 != *(((Bit8u *)&AX)+1))
jmp .738
.73A:
sub	al,*0
jb 	.764
cmp	al,*8
ja  	.765
xor	ah,ah
shl	ax,*1
mov	bx,ax
seg	cs
br	.766[bx]
.766:
.word	.73B
.word	.73C
.word	.744
.word	.74D
.word	.751
.word	.759
.word	.73D
.word	.73E
.word	.73F
.765:
jmp	.764
.738:
! Debug: ne unsigned char AX = [S+$24+$15] to int = const 0 (used reg = )
! Debug: expression subtree swapping
mov	al,$17[bp]
test	al,al
je  	.767
.768:
! 5193       {
! 5194         set_diskette_ret_status(*(((Bit8u *)&AX)+1));
! Debug: list unsigned char AX = [S+$24+$15] (used reg = )
mov	al,$17[bp]
xor	ah,ah
push	ax
! Debug: func () void = set_diskette_ret_status+0 (used reg = )
call	_set_diskette_ret_status
inc	sp
inc	sp
!BCC_EOS
! 5195         FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$24+$1A] (used reg = )
mov	ax,$1C[bp]
or	al,*1
mov	$1C[bp],ax
!BCC_EOS
! 5196         return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 5197       }
! 5198 ;
.767:
!BCC_EOS
! 5199       *((Bit8u *)(base_address)) = (val8);
mov	bx,-8[bp]
! Debug: eq unsigned char val8 = [S+$24-$11] to unsigned char = [bx+0] (used reg = )
mov	al,-$F[bp]
mov	[bx],al
!BCC_EOS
! 5200 #asm
!BCC_EOS
!BCC_ASM
_int13_diskette_function.BP	set	$2E
.int13_diskette_function.BP	set	$C
_int13_diskette_function.CS	set	$3C
.int13_diskette_function.CS	set	$1A
_int13_diskette_function.CX	set	$36
.int13_diskette_function.CX	set	$14
_int13_diskette_function.base_address	set	$1A
.int13_diskette_function.base_address	set	-8
_int13_diskette_function.DI	set	$2A
.int13_diskette_function.DI	set	8
_int13_diskette_function.FLAGS	set	$3E
.int13_diskette_function.FLAGS	set	$1C
_int13_diskette_function.base_count	set	$18
.int13_diskette_function.base_count	set	-$A
_int13_diskette_function.sector	set	$1E
.int13_diskette_function.sector	set	-4
_int13_diskette_function.DS	set	$26
.int13_diskette_function.DS	set	4
_int13_diskette_function.head	set	$1D
.int13_diskette_function.head	set	-5
_int13_diskette_function.ELDX	set	$30
.int13_diskette_function.ELDX	set	$E
_int13_diskette_function.dor	set	$12
.int13_diskette_function.dor	set	-$10
_int13_diskette_function.DX	set	$34
.int13_diskette_function.DX	set	$12
_int13_diskette_function.return_status	set	$B
.int13_diskette_function.return_status	set	-$17
_int13_diskette_function.es	set	4
.int13_diskette_function.es	set	-$1E
_int13_diskette_function.mode_register	set	$14
.int13_diskette_function.mode_register	set	-$E
_int13_diskette_function.ES	set	$28
.int13_diskette_function.ES	set	6
_int13_diskette_function.base_es	set	$16
.int13_diskette_function.base_es	set	-$C
_int13_diskette_function.track	set	$1F
.int13_diskette_function.track	set	-3
_int13_diskette_function.SI	set	$2C
.int13_diskette_function.SI	set	$A
_int13_diskette_function.drive_type	set	$A
.int13_diskette_function.drive_type	set	-$18
_int13_diskette_function.num_sectors	set	$20
.int13_diskette_function.num_sectors	set	-2
_int13_diskette_function.IP	set	$3A
.int13_diskette_function.IP	set	$18
_int13_diskette_function.spt	set	7
.int13_diskette_function.spt	set	-$1B
_int13_diskette_function.status	set	$1C
.int13_diskette_function.status	set	-6
_int13_diskette_function.maxCyl	set	0
.int13_diskette_function.maxCyl	set	-$22
_int13_diskette_function.AX	set	$38
.int13_diskette_function.AX	set	$16
_int13_diskette_function.val8	set	$13
.int13_diskette_function.val8	set	-$F
_int13_diskette_function.last_addr	set	2
.int13_diskette_function.last_addr	set	-$20
_int13_diskette_function.page	set	$15
.int13_diskette_function.page	set	-$D
_int13_diskette_function.ah	set	8
.int13_diskette_function.ah	set	-$1A
_int13_diskette_function.drive	set	$21
.int13_diskette_function.drive	set	-1
_int13_diskette_function.num_floppies	set	9
.int13_diskette_function.num_floppies	set	-$19
_int13_diskette_function.BX	set	$32
.int13_diskette_function.BX	set	$10
      push bp
      mov bp, sp
      mov ax, #diskette_param_table2
      mov _int13_diskette_function.DI+2[bp], ax
      mov _int13_diskette_function.ES+2[bp], cs
      pop bp
! 5207 endasm
!BCC_ENDASM
!BCC_EOS
! 5208       set_diskette_ret_status(0);
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: func () void = set_diskette_ret_status+0 (used reg = )
call	_set_diskette_ret_status
inc	sp
inc	sp
!BCC_EOS
! 5209       FLAGS &= 0xfffe;
! Debug: andab unsigned int = const $FFFE to unsigned short FLAGS = [S+$24+$1A] (used reg = )
mov	ax,$1C[bp]
and	al,#$FE
mov	$1C[bp],ax
!BCC_EOS
! 5210       return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 5211     default:
! 5212         bios_printf(4, "int13_diskette: unsupported AH=%02x\n", *(((Bit8u *)&AX)+1));
.769:
! Debug: list unsigned char AX = [S+$24+$15] (used reg = )
mov	al,$17[bp]
xor	ah,ah
push	ax
! Debug: list * char = .76A+0 (used reg = )
mov	bx,#.76A
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*6
!BCC_EOS
! 5213         *(((Bit8u *)&AX)+1) = (0x01);
! Debug: eq int = const 1 to unsigned char AX = [S+$24+$15] (used reg = )
mov	al,*1
mov	$17[bp],al
!BCC_EOS
! 5214         set_diskette_ret_status(1);
! Debug: list int = const 1 (used reg = )
mov	ax,*1
push	ax
! Debug: func () void = set_diskette_ret_status+0 (used reg = )
call	_set_diskette_ret_status
inc	sp
inc	sp
!BCC_EOS
! 5215         FLAGS |= 0x0001;
! Debug: orab int = const 1 to unsigned short FLAGS = [S+$24+$1A] (used reg = )
mov	ax,$1C[bp]
or	al,*1
mov	$1C[bp],ax
!BCC_EOS
! 5216         return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 5217     }
! 5218 }
jmp .696
.698:
sub	al,*0
jb 	.769
cmp	al,*8
ja  	.76B
xor	ah,ah
shl	ax,*1
mov	bx,ax
seg	cs
br	.76C[bx]
.76C:
.word	.699
.word	.6A1
.word	.6A4
.word	.6A5
.word	.6A6
.word	.6CF
.word	.769
.word	.769
.word	.6EF
.76B:
sub	al,*$15
beq 	.709
sub	al,*1
beq 	.712
sub	al,*1
beq 	.715
sub	al,*1
beq 	.729
jmp	.769
.696:
..FFDB	=	-$24
..FFDA	=	-$24
mov	sp,bp
pop	bp
ret
! 5219  void
! Register BX used in function int13_diskette_function
! 5220 set_diskette_ret_status(value)
! 5221   Bit8u value;
export	_set_diskette_ret_status
_set_diskette_ret_status:
!BCC_EOS
! 5222 {
! 5223   _write_byte(value, 0x0041, 0x0040);
push	bp
mov	bp,sp
! Debug: list int = const $40 (used reg = )
mov	ax,*$40
push	ax
! Debug: list int = const $41 (used reg = )
mov	ax,*$41
push	ax
! Debug: list unsigned char value = [S+6+2] (used reg = )
mov	al,4[bp]
xor	ah,ah
push	ax
! Debug: func () void = _write_byte+0 (used reg = )
call	__write_byte
mov	sp,bp
!BCC_EOS
! 5224 }
pop	bp
ret
! 5225   void
! 5226 set_diskette_current_cyl(drive, cyl)
! 5227   Bit8u drive;
export	_set_diskette_current_cyl
_set_diskette_current_cyl:
!BCC_EOS
! 5228   Bit8u cyl;
!BCC_EOS
! 5229 {
! 5230   if (drive > 1)
push	bp
mov	bp,sp
! Debug: gt int = const 1 to unsigned char drive = [S+2+2] (used reg = )
mov	al,4[bp]
cmp	al,*1
jbe 	.76D
.76E:
! 5231     bios_printf((2 | 4 | 1), "set_diskette_current_cyl(): drive > 1\n");
! Debug: list * char = .76F+0 (used reg = )
mov	bx,#.76F
push	bx
! Debug: list int = const 7 (used reg = )
mov	ax,*7
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
mov	sp,bp
!BCC_EOS
! 5232   _write_byte(cyl, 0x0094+drive, 0x0040);
.76D:
! Debug: list int = const $40 (used reg = )
mov	ax,*$40
push	ax
! Debug: add unsigned char drive = [S+4+2] to int = const $94 (used reg = )
! Debug: expression subtree swapping
mov	al,4[bp]
xor	ah,ah
! Debug: list unsigned int = ax+$94 (used reg = )
add	ax,#$94
push	ax
! Debug: list unsigned char cyl = [S+6+4] (used reg = )
mov	al,6[bp]
xor	ah,ah
push	ax
! Debug: func () void = _write_byte+0 (used reg = )
call	__write_byte
mov	sp,bp
!BCC_EOS
! 5233 }
pop	bp
ret
! 5234   void
! Register BX used in function set_diskette_current_cyl
! 5235 determine_floppy_media(drive)
! 5236   Bit16u drive;
export	_determine_floppy_media
_determine_floppy_media:
!BCC_EOS
! 5237 {
! 5238 }
ret
! 5239   void
! 5240 int17_function(regs, ds, iret_addr)
! 5241   pusha_regs_t regs;
export	_int17_function
_int17_function:
!BCC_EOS
! 5242   Bit16u ds;
!BCC_EOS
! 5243   iret_addr_t iret_addr;
!BCC_EOS
! 5244 {
! 5245   Bit16u addr,timeout;
!BCC_EOS
! 5246   Bit8u val8;
!BCC_EOS
! 5247 #asm
push	bp
mov	bp,sp
add	sp,*-6
!BCC_EOS
!BCC_ASM
_int17_function.ds	set	$1A
.int17_function.ds	set	$14
_int17_function.timeout	set	2
.int17_function.timeout	set	-4
_int17_function.val8	set	1
.int17_function.val8	set	-5
_int17_function.iret_addr	set	$1C
.int17_function.iret_addr	set	$16
_int17_function.addr	set	4
.int17_function.addr	set	-2
_int17_function.regs	set	$A
.int17_function.regs	set	4
  sti
! 5249 endasm
!BCC_ENDASM
!BCC_EOS
! 5250   addr = *((Bit16u *)(0x0400 + (regs.u.r16.dx << 1) + 8));
! Debug: sl int = const 1 to unsigned short regs = [S+8+$C] (used reg = )
mov	ax,$E[bp]
shl	ax,*1
! Debug: add unsigned int = ax+0 to int = const $400 (used reg = )
! Debug: expression subtree swapping
! Debug: add int = const 8 to unsigned int = ax+$400 (used reg = )
! Debug: cast * unsigned short = const 0 to unsigned int = ax+$408 (used reg = )
mov	bx,ax
! Debug: eq unsigned short = [bx+$408] to unsigned short addr = [S+8-4] (used reg = )
mov	bx,$408[bx]
mov	-2[bp],bx
!BCC_EOS
! 5251   if ((regs.u.r8.ah < 3) && (regs.u.r16.dx < 3) && (addr > 0)) {
! Debug: lt int = const 3 to unsigned char regs = [S+8+$11] (used reg = )
mov	al,$13[bp]
cmp	al,*3
bhis	.770
.773:
! Debug: lt int = const 3 to unsigned short regs = [S+8+$C] (used reg = )
mov	ax,$E[bp]
cmp	ax,*3
bhis	.770
.772:
! Debug: gt int = const 0 to unsigned short addr = [S+8-4] (used reg = )
mov	ax,-2[bp]
test	ax,ax
beq 	.770
.771:
! 5252     *(((Bit8u *)&timeout)+1) = *((Bit8u *)(0x0478 + regs.u.r16.dx));
! Debug: add unsigned short regs = [S+8+$C] to int = const $478 (used reg = )
! Debug: expression subtree swapping
mov	ax,$E[bp]
! Debug: cast * unsigned char = const 0 to unsigned int = ax+$478 (used reg = )
mov	bx,ax
! Debug: eq unsigned char = [bx+$478] to unsigned char timeout = [S+8-5] (used reg = )
mov	al,$478[bx]
mov	-3[bp],al
!BCC_EOS
! 5253     *((Bit8u *)&timeout) = 0;
! Debug: eq int = const 0 to unsigned char timeout = [S+8-6] (used reg = )
xor	al,al
mov	-4[bp],al
!BCC_EOS
! 5254     if (regs.u.r8.ah == 0) {
! Debug: logeq int = const 0 to unsigned char regs = [S+8+$11] (used reg = )
mov	al,$13[bp]
test	al,al
bne 	.774
.775:
! 5255       outb(addr, regs.u.r8.al);
! Debug: list unsigned char regs = [S+8+$10] (used reg = )
mov	al,$12[bp]
xor	ah,ah
push	ax
! Debug: list unsigned short addr = [S+$A-4] (used reg = )
push	-2[bp]
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 5256       val8 = inb(addr+2);
! Debug: add int = const 2 to unsigned short addr = [S+8-4] (used reg = )
mov	ax,-2[bp]
! Debug: list unsigned int = ax+2 (used reg = )
inc	ax
inc	ax
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char val8 = [S+8-7] (used reg = )
mov	-5[bp],al
!BCC_EOS
! 5257       outb(addr+2, val8 | 0x01);
! Debug: or int = const 1 to unsigned char val8 = [S+8-7] (used reg = )
mov	al,-5[bp]
or	al,*1
! Debug: list unsigned char = al+0 (used reg = )
xor	ah,ah
push	ax
! Debug: add int = const 2 to unsigned short addr = [S+$A-4] (used reg = )
mov	ax,-2[bp]
! Debug: list unsigned int = ax+2 (used reg = )
inc	ax
inc	ax
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 5258 #asm
!BCC_EOS
!BCC_ASM
_int17_function.ds	set	$1A
.int17_function.ds	set	$14
_int17_function.timeout	set	2
.int17_function.timeout	set	-4
_int17_function.val8	set	1
.int17_function.val8	set	-5
_int17_function.iret_addr	set	$1C
.int17_function.iret_addr	set	$16
_int17_function.addr	set	4
.int17_function.addr	set	-2
_int17_function.regs	set	$A
.int17_function.regs	set	4
      nop
! 5260 endasm
!BCC_ENDASM
!BCC_EOS
! 5261       outb(addr+2, val8 & ~0x01);
! Debug: and int = const -2 to unsigned char val8 = [S+8-7] (used reg = )
mov	al,-5[bp]
and	al,#$FE
! Debug: list unsigned char = al+0 (used reg = )
xor	ah,ah
push	ax
! Debug: add int = const 2 to unsigned short addr = [S+$A-4] (used reg = )
mov	ax,-2[bp]
! Debug: list unsigned int = ax+2 (used reg = )
inc	ax
inc	ax
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 5262       while (((inb(addr+1) & 0x40) == 0x40) && (timeout)) {
jmp .777
.778:
! 5263         timeout--;
! Debug: postdec unsigned short timeout = [S+8-6] (used reg = )
mov	ax,-4[bp]
dec	ax
mov	-4[bp],ax
!BCC_EOS
! 5264       }
! 5265     }
.777:
! Debug: add int = const 1 to unsigned short addr = [S+8-4] (used reg = )
mov	ax,-2[bp]
! Debug: list unsigned int = ax+1 (used reg = )
inc	ax
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: and int = const $40 to unsigned char = al+0 (used reg = )
and	al,*$40
! Debug: logeq int = const $40 to unsigned char = al+0 (used reg = )
cmp	al,*$40
jne 	.779
.77A:
mov	ax,-4[bp]
test	ax,ax
jne	.778
.779:
.776:
! 5266     if (regs.u.r8.ah == 1) {
.774:
! Debug: logeq int = const 1 to unsigned char regs = [S+8+$11] (used reg = )
mov	al,$13[bp]
cmp	al,*1
jne 	.77B
.77C:
! 5267       val8 = inb(addr+2);
! Debug: add int = const 2 to unsigned short addr = [S+8-4] (used reg = )
mov	ax,-2[bp]
! Debug: list unsigned int = ax+2 (used reg = )
inc	ax
inc	ax
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char val8 = [S+8-7] (used reg = )
mov	-5[bp],al
!BCC_EOS
! 5268       outb(addr+2, val8 & ~0x04);
! Debug: and int = const -5 to unsigned char val8 = [S+8-7] (used reg = )
mov	al,-5[bp]
and	al,#$FB
! Debug: list unsigned char = al+0 (used reg = )
xor	ah,ah
push	ax
! Debug: add int = const 2 to unsigned short addr = [S+$A-4] (used reg = )
mov	ax,-2[bp]
! Debug: list unsigned int = ax+2 (used reg = )
inc	ax
inc	ax
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 5269 #asm
!BCC_EOS
!BCC_ASM
_int17_function.ds	set	$1A
.int17_function.ds	set	$14
_int17_function.timeout	set	2
.int17_function.timeout	set	-4
_int17_function.val8	set	1
.int17_function.val8	set	-5
_int17_function.iret_addr	set	$1C
.int17_function.iret_addr	set	$16
_int17_function.addr	set	4
.int17_function.addr	set	-2
_int17_function.regs	set	$A
.int17_function.regs	set	4
      nop
! 5271 endasm
!BCC_ENDASM
!BCC_EOS
! 5272       outb(addr+2, val8 | 0x04);
! Debug: or int = const 4 to unsigned char val8 = [S+8-7] (used reg = )
mov	al,-5[bp]
or	al,*4
! Debug: list unsigned char = al+0 (used reg = )
xor	ah,ah
push	ax
! Debug: add int = const 2 to unsigned short addr = [S+$A-4] (used reg = )
mov	ax,-2[bp]
! Debug: list unsigned int = ax+2 (used reg = )
inc	ax
inc	ax
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 5273     }
! 5274     va
! 5274 l8 = inb(addr+1);
.77B:
! Debug: add int = const 1 to unsigned short addr = [S+8-4] (used reg = )
mov	ax,-2[bp]
! Debug: list unsigned int = ax+1 (used reg = )
inc	ax
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char val8 = [S+8-7] (used reg = )
mov	-5[bp],al
!BCC_EOS
! 5275     regs.u.r8.ah = (val8 ^ 0x48);
! Debug: eor int = const $48 to unsigned char val8 = [S+8-7] (used reg = )
mov	al,-5[bp]
xor	al,*$48
! Debug: eq unsigned char = al+0 to unsigned char regs = [S+8+$11] (used reg = )
mov	$13[bp],al
!BCC_EOS
! 5276     if (!timeout) regs.u.r8.ah |= 0x01;
mov	ax,-4[bp]
test	ax,ax
jne 	.77D
.77E:
! Debug: orab int = const 1 to unsigned char regs = [S+8+$11] (used reg = )
mov	al,$13[bp]
or	al,*1
mov	$13[bp],al
!BCC_EOS
! 5277     iret_addr.flags.u.r8.flagsl &= 0xfe;
.77D:
! Debug: andab int = const $FE to unsigned char iret_addr = [S+8+$18] (used reg = )
mov	al,$1A[bp]
and	al,#$FE
mov	$1A[bp],al
!BCC_EOS
! 5278   } else {
jmp .77F
.770:
! 5279     iret_addr.flags.u.r8.flagsl |= 0x01;
! Debug: orab int = const 1 to unsigned char iret_addr = [S+8+$18] (used reg = )
mov	al,$1A[bp]
or	al,*1
mov	$1A[bp],al
!BCC_EOS
! 5280   }
! 5281 }
.77F:
mov	sp,bp
pop	bp
ret
! 5282 void
! Register BX used in function int17_function
! 5283 int19_function(seq_nr)
! 5284 Bit16u seq_nr;
export	_int19_function
_int19_function:
!BCC_EOS
! 5285 {
! 5286   Bit16u ebda_seg=*((Bit16u *)(0x040E));
push	bp
mov	bp,sp
dec	sp
dec	sp
! Debug: eq unsigned short = [+$40E] to unsigned short ebda_seg = [S+4-4] (used reg = )
mov	ax,[$40E]
mov	-2[bp],ax
!BCC_EOS
! 5287   Bit16u bootdev;
!BCC_EOS
! 5288   Bit8u bootdrv;
!BCC_EOS
! 5289   Bit8u bootchk;
!BCC_EOS
! 5290   Bit16u bootseg;
!BCC_EOS
! 5291   Bit16u bootip;
!BCC_EOS
! 5292   Bit16u status;
!BCC_EOS
! 5293   Bit16u bootfirst;
!BCC_EOS
! 5294   ipl_entry_t e;
!BCC_EOS
! 5295   bootdev = inb_cmos(0x3d);
add	sp,*-$1C
! Debug: list int = const $3D (used reg = )
mov	ax,*$3D
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned short bootdev = [S+$20-6] (used reg = )
xor	ah,ah
mov	-4[bp],ax
!BCC_EOS
! 5296   bootdev |= ((inb_cmos(0x38) & 0xf0) << 4);
! Debug: list int = const $38 (used reg = )
mov	ax,*$38
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: and int = const $F0 to unsigned char = al+0 (used reg = )
and	al,#$F0
! Debug: sl int = const 4 to unsigned char = al+0 (used reg = )
xor	ah,ah
mov	cl,*4
shl	ax,cl
! Debug: orab unsigned int = ax+0 to unsigned short bootdev = [S+$20-6] (used reg = )
or	ax,-4[bp]
mov	-4[bp],ax
!BCC_EOS
! 5297   bootdev >>= 4 * seq_nr;
! Debug: mul unsigned short seq_nr = [S+$20+2] to int = const 4 (used reg = )
! Debug: expression subtree swapping
mov	ax,4[bp]
shl	ax,*1
shl	ax,*1
! Debug: srab unsigned int = ax+0 to unsigned short bootdev = [S+$20-6] (used reg = )
mov	bx,ax
mov	ax,-4[bp]
mov	cx,bx
shr	ax,cl
mov	-4[bp],ax
!BCC_EOS
! 5298   bootdev &= 0xf;
! Debug: andab int = const $F to unsigned short bootdev = [S+$20-6] (used reg = )
mov	al,-4[bp]
and	al,*$F
xor	ah,ah
mov	-4[bp],ax
!BCC_EOS
! 5299   bootfirst = _read_word(0x0084, 0x9ff0);
! Debug: list unsigned int = const $9FF0 (used reg = )
mov	ax,#$9FF0
push	ax
! Debug: list int = const $84 (used reg = )
mov	ax,#$84
push	ax
! Debug: func () unsigned short = _read_word+0 (used reg = )
call	__read_word
add	sp,*4
! Debug: eq unsigned short = ax+0 to unsigned short bootfirst = [S+$20-$10] (used reg = )
mov	-$E[bp],ax
!BCC_EOS
! 5300   if (bootfirst != 0xFFFF) {
! Debug: ne unsigned int = const $FFFF to unsigned short bootfirst = [S+$20-$10] (used reg = )
mov	ax,-$E[bp]
cmp	ax,#$FFFF
je  	.780
.781:
! 5301     bootdev = bootfirst;
! Debug: eq unsigned short bootfirst = [S+$20-$10] to unsigned short bootdev = [S+$20-6] (used reg = )
mov	ax,-$E[bp]
mov	-4[bp],ax
!BCC_EOS
! 5302     _write_word(0xFFFF, 0x0084, 0x9ff0);
! Debug: list unsigned int = const $9FF0 (used reg = )
mov	ax,#$9FF0
push	ax
! Debug: list int = const $84 (used reg = )
mov	ax,#$84
push	ax
! Debug: list unsigned int = const $FFFF (used reg = )
mov	ax,#$FFFF
push	ax
! Debug: func () void = _write_word+0 (used reg = )
call	__write_word
add	sp,*6
!BCC_EOS
! 5303     _write_word(0xFFFF, 0x0082, 0x9ff0);
! Debug: list unsigned int = const $9FF0 (used reg = )
mov	ax,#$9FF0
push	ax
! Debug: list int = const $82 (used reg = )
mov	ax,#$82
push	ax
! Debug: list unsigned int = const $FFFF (used reg = )
mov	ax,#$FFFF
push	ax
! Debug: func () void = _write_word+0 (used reg = )
call	__write_word
add	sp,*6
!BCC_EOS
! 5304   } else if (bootdev == 0) bios_printf((2 | 4 | 1), "No bootable device.\n");
jmp .782
.780:
! Debug: logeq int = const 0 to unsigned short bootdev = [S+$20-6] (used reg = )
mov	ax,-4[bp]
test	ax,ax
jne 	.783
.784:
! Debug: list * char = .785+0 (used reg = )
mov	bx,#.785
push	bx
! Debug: list int = const 7 (used reg = )
mov	ax,*7
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*4
!BCC_EOS
! 5305   bootdev -= 1;
.783:
.782:
! Debug: subab int = const 1 to unsigned short bootdev = [S+$20-6] (used reg = )
mov	ax,-4[bp]
dec	ax
mov	-4[bp],ax
!BCC_EOS
! 5306   if (get_boot_vector(bootdev, &e) == 0) {
! Debug: list * struct  e = S+$20-$20 (used reg = )
lea	bx,-$1E[bp]
push	bx
! Debug: list unsigned short bootdev = [S+$22-6] (used reg = )
push	-4[bp]
! Debug: func () unsigned char = get_boot_vector+0 (used reg = )
call	_get_boot_vector
add	sp,*4
! Debug: logeq int = const 0 to unsigned char = al+0 (used reg = )
test	al,al
jne 	.786
.787:
! 5307     bios_printf(4, "Invalid boot device (0x%x)\n", bootdev);
! Debug: list unsigned short bootdev = [S+$20-6] (used reg = )
push	-4[bp]
! Debug: list * char = .788+0 (used reg = )
mov	bx,#.788
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*6
!BCC_EOS
! 5308     return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 5309   }
! 5310   print_boot_device(&e);
.786:
! Debug: list * struct  e = S+$20-$20 (used reg = )
lea	bx,-$1E[bp]
push	bx
! Debug: func () void = print_boot_device+0 (used reg = )
call	_print_boot_device
inc	sp
inc	sp
!BCC_EOS
! 5311   switch(e.type) {
mov	ax,-$1E[bp]
br 	.78B
! 5312   case 0x01:
! 5313   case 0x02:
.78C:
! 5314     bootdrv = (e.type == 0x02) ? 0x80 : 0x00;
.78D:
! Debug: logeq int = const 2 to unsigned short e = [S+$20-$20] (used reg = )
mov	ax,-$1E[bp]
cmp	ax,*2
jne 	.78E
.78F:
mov	al,#$80
jmp .790
.78E:
xor	al,al
.790:
! Debug: eq char = al+0 to unsigned char bootdrv = [S+$20-7] (used reg = )
mov	-5[bp],al
!BCC_EOS
! 5315     bootseg = 0x07c0;
! Debug: eq int = const $7C0 to unsigned short bootseg = [S+$20-$A] (used reg = )
mov	ax,#$7C0
mov	-8[bp],ax
!BCC_EOS
! 5316     status = 0;
! Debug: eq int = const 0 to unsigned short status = [S+$20-$E] (used reg = )
xor	ax,ax
mov	-$C[bp],ax
!BCC_EOS
! 5317 #asm
!BCC_EOS
!BCC_ASM
_int19_function.bootip	set	$14
.int19_function.bootip	set	-$A
_int19_function.seq_nr	set	$22
.int19_function.seq_nr	set	4
_int19_function.bootchk	set	$18
.int19_function.bootchk	set	-6
_int19_function.bootseg	set	$16
.int19_function.bootseg	set	-8
_int19_function.ebda_seg	set	$1C
.int19_function.ebda_seg	set	-2
_int19_function.status	set	$12
.int19_function.status	set	-$C
_int19_function.bootfirst	set	$10
.int19_function.bootfirst	set	-$E
_int19_function.bootdrv	set	$19
.int19_function.bootdrv	set	-5
_int19_function.bootdev	set	$1A
.int19_function.bootdev	set	-4
_int19_function.e	set	0
.int19_function.e	set	-$1E
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    mov dl, _int19_function.bootdrv + 2[bp]
    mov ax, _int19_function.bootseg + 2[bp]
    mov es, ax ;; segment
    xor bx, bx ;; offset
    mov ah, #0x02 ;; function 2, read diskette sector
    mov al, #0x01 ;; read 1 sector
    mov ch, #0x00 ;; track 0
    mov cl, #0x01 ;; sector 1
    mov dh, #0x00 ;; head 0
    int #0x13 ;; read sector
    jnc int19_load_done
    mov ax, #0x0001
    mov _int19_function.status + 2[bp], ax
int19_load_done:
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
! 5343 endasm
!BCC_ENDASM
!BCC_EOS
! 5344     if (status != 0) {
! Debug: ne int = const 0 to unsigned short status = [S+$20-$E] (used reg = )
mov	ax,-$C[bp]
test	ax,ax
je  	.791
.792:
! 5345       print_boot_failure(e.type, 1);
! Debug: list int = const 1 (used reg = )
mov	ax,*1
push	ax
! Debug: list unsigned short e = [S+$22-$20] (used reg = )
push	-$1E[bp]
! Debug: func () void = print_boot_failure+0 (used reg = )
call	_print_boot_failure
add	sp,*4
!BCC_EOS
! 5346       return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 5347     }
! 5348     if ((e.type != 0x01) || !((inb_cmos(0x38) & 0x01))) {
.791:
! Debug: ne int = const 1 to unsigned short e = [S+$20-$20] (used reg = )
mov	ax,-$1E[bp]
cmp	ax,*1
jne 	.794
.795:
! Debug: list int = const $38 (used reg = )
mov	ax,*$38
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: and int = const 1 to unsigned char = al+0 (used reg = )
and	al,*1
test	al,al
jne 	.793
.794:
! 5349       if (_read_word(0x1fe, bootseg) != 0xaa55) {
! Debug: list unsigned short bootseg = [S+$20-$A] (used reg = )
push	-8[bp]
! Debug: list int = const $1FE (used reg = )
mov	ax,#$1FE
push	ax
! Debug: func () unsigned short = _read_word+0 (used reg = )
call	__read_word
add	sp,*4
! Debug: ne unsigned int = const $AA55 to unsigned short = ax+0 (used reg = )
cmp	ax,#$AA55
je  	.796
.797:
! 5350         print_boot_failure(e.type, 0);
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list unsigned short e = [S+$22-$20] (used reg = )
push	-$1E[bp]
! Debug: func () void = print_boot_failure+0 (used reg = )
call	_print_boot_failure
add	sp,*4
!BCC_EOS
! 5351         return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 5352       }
! 5353     }
.796:
! 5354     bootip = (bootseg & 0x0fff) << 4;
.793:
! Debug: and int = const $FFF to unsigned short bootseg = [S+$20-$A] (used reg = )
mov	ax,-8[bp]
and	ax,#$FFF
! Debug: sl int = const 4 to unsigned int = ax+0 (used reg = )
mov	cl,*4
shl	ax,cl
! Debug: eq unsigned int = ax+0 to unsigned short bootip = [S+$20-$C] (used reg = )
mov	-$A[bp],ax
!BCC_EOS
! 5355     bootseg &= 0xf000;
! Debug: andab unsigned int = const $F000 to unsigned short bootseg = [S+$20-$A] (used reg = )
mov	ax,-8[bp]
and	ax,#$F000
mov	-8[bp],ax
!BCC_EOS
! 5356   break;
jmp .789
!BCC_EOS
! 5357   case 0x03:
! 5358     status = cdrom_boot();
.798:
! Debug: func () unsigned short = cdrom_boot+0 (used reg = )
call	_cdrom_boot
! Debug: eq unsigned short = ax+0 to unsigned short status = [S+$20-$E] (used reg = )
mov	-$C[bp],ax
!BCC_EOS
! 5359     if ( 
! 5359 (status & 0x00ff) !=0 ) {
! Debug: and int = const $FF to unsigned short status = [S+$20-$E] (used reg = )
mov	al,-$C[bp]
! Debug: ne int = const 0 to unsigned char = al+0 (used reg = )
test	al,al
je  	.799
.79A:
! 5360       print_cdromboot_failure(status);
! Debug: list unsigned short status = [S+$20-$E] (used reg = )
push	-$C[bp]
! Debug: func () void = print_cdromboot_failure+0 (used reg = )
call	_print_cdromboot_failure
inc	sp
inc	sp
!BCC_EOS
! 5361       print_boot_failure(e.type, 1);
! Debug: list int = const 1 (used reg = )
mov	ax,*1
push	ax
! Debug: list unsigned short e = [S+$22-$20] (used reg = )
push	-$1E[bp]
! Debug: func () void = print_boot_failure+0 (used reg = )
call	_print_boot_failure
add	sp,*4
!BCC_EOS
! 5362       return;
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 5363     }
! 5364     bootdrv = *(((Bit8u *)&status)+1);
.799:
! Debug: eq unsigned char status = [S+$20-$D] to unsigned char bootdrv = [S+$20-7] (used reg = )
mov	al,-$B[bp]
mov	-5[bp],al
!BCC_EOS
! 5365     bootseg = _read_word(&((ebda_data_t *) 0)->cdemu.load_segment, ebda_seg);
! Debug: list unsigned short ebda_seg = [S+$20-4] (used reg = )
push	-2[bp]
! Debug: list * unsigned short = const $266 (used reg = )
mov	ax,#$266
push	ax
! Debug: func () unsigned short = _read_word+0 (used reg = )
call	__read_word
add	sp,*4
! Debug: eq unsigned short = ax+0 to unsigned short bootseg = [S+$20-$A] (used reg = )
mov	-8[bp],ax
!BCC_EOS
! 5366     bootip = 0;
! Debug: eq int = const 0 to unsigned short bootip = [S+$20-$C] (used reg = )
xor	ax,ax
mov	-$A[bp],ax
!BCC_EOS
! 5367     break;
jmp .789
!BCC_EOS
! 5368   case 0x80:
! 5369     bootseg = *(((Bit16u *)&e.vector)+1);
.79B:
! Debug: eq unsigned short e = [S+$20-$1A] to unsigned short bootseg = [S+$20-$A] (used reg = )
mov	ax,-$18[bp]
mov	-8[bp],ax
!BCC_EOS
! 5370     bootip = *((Bit16u *)&e.vector);
! Debug: eq unsigned short e = [S+$20-$1C] to unsigned short bootip = [S+$20-$C] (used reg = )
mov	ax,-$1A[bp]
mov	-$A[bp],ax
!BCC_EOS
! 5371     break;
jmp .789
!BCC_EOS
! 5372   default: return;
.79C:
mov	sp,bp
pop	bp
ret
!BCC_EOS
! 5373   }
! 5374   bios_printf(4, "Booting from %x:%x\n", bootseg, bootip);
jmp .789
.78B:
sub	ax,*1
beq 	.78C
sub	ax,*1
beq 	.78D
sub	ax,*1
je 	.798
sub	ax,*$7D
je 	.79B
jmp	.79C
.789:
..FFD9	=	-$20
! Debug: list unsigned short bootip = [S+$20-$C] (used reg = )
push	-$A[bp]
! Debug: list unsigned short bootseg = [S+$22-$A] (used reg = )
push	-8[bp]
! Debug: list * char = .79D+0 (used reg = )
mov	bx,#.79D
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*8
!BCC_EOS
! 5375 #asm
!BCC_EOS
!BCC_ASM
_int19_function.bootip	set	$14
.int19_function.bootip	set	-$A
_int19_function.seq_nr	set	$22
.int19_function.seq_nr	set	4
_int19_function.bootchk	set	$18
.int19_function.bootchk	set	-6
_int19_function.bootseg	set	$16
.int19_function.bootseg	set	-8
_int19_function.ebda_seg	set	$1C
.int19_function.ebda_seg	set	-2
_int19_function.status	set	$12
.int19_function.status	set	-$C
_int19_function.bootfirst	set	$10
.int19_function.bootfirst	set	-$E
_int19_function.bootdrv	set	$19
.int19_function.bootdrv	set	-5
_int19_function.bootdev	set	$1A
.int19_function.bootdev	set	-4
_int19_function.e	set	0
.int19_function.e	set	-$1E
    mov bp, sp
    push cs
    push #int18_handler
    ;; Build an iret stack frame that will take us to the boot vector.
    ;; iret pops ip, then cs, then flags, so push them in the opposite order.
    pushf
    mov ax, _int19_function.bootseg + 0[bp]
    push ax
    mov ax, _int19_function.bootip + 0[bp]
    push ax
    ;; Set the magic number in ax and the boot drive in dl.
    mov ax, #0xaa55
    mov dl, _int19_function.bootdrv + 0[bp]
    ;; Zero some of the other registers.
    xor bx, bx
    mov ds, bx
    mov es, bx
    mov bp, bx
    ;; Go!
    iret
! 5396 endasm
!BCC_ENDASM
!BCC_EOS
! 5397 }
mov	sp,bp
pop	bp
ret
! 5398   void
! Register BX used in function int19_function
! 5399 int1a_function(regs, ds, iret_addr)
! 5400   pusha_regs_t regs;
export	_int1a_function
_int1a_function:
!BCC_EOS
! 5401   Bit16u ds;
!BCC_EOS
! 5402   iret_addr_t iret_addr;
!BCC_EOS
! 5403 {
! 5404   Bit8u val8;
!BCC_EOS
! 5405   ;
push	bp
mov	bp,sp
dec	sp
dec	sp
!BCC_EOS
! 5406 #asm
!BCC_EOS
!BCC_ASM
_int1a_function.ds	set	$16
.int1a_function.ds	set	$14
_int1a_function.val8	set	1
.int1a_function.val8	set	-1
_int1a_function.iret_addr	set	$18
.int1a_function.iret_addr	set	$16
_int1a_function.regs	set	6
.int1a_function.regs	set	4
  sti
! 5408 endasm
!BCC_ENDASM
!BCC_EOS
! 5409   switch (regs.u.r8.ah) {
mov	al,$13[bp]
br 	.7A0
! 5410     case 0:
! 5411 #asm
.7A1:
!BCC_EOS
!BCC_ASM
_int1a_function.ds	set	$16
.int1a_function.ds	set	$14
_int1a_function.val8	set	1
.int1a_function.val8	set	-1
_int1a_function.iret_addr	set	$18
.int1a_function.iret_addr	set	$16
_int1a_function.regs	set	6
.int1a_function.regs	set	4
      cli
! 5413 endasm
!BCC_ENDASM
!BCC_EOS
! 5414       regs.u.r16.cx = ((bios_data_t *) 0)->ticks_high;
! Debug: eq unsigned short = [+$46E] to unsigned short regs = [S+4+$E] (used reg = )
mov	ax,[$46E]
mov	$10[bp],ax
!BCC_EOS
! 5415       regs.u.r16.dx = ((bios_data_t *) 0)->ticks_low;
! Debug: eq unsigned short = [+$46C] to unsigned short regs = [S+4+$C] (used reg = )
mov	ax,[$46C]
mov	$E[bp],ax
!BCC_EOS
! 5416       regs.u.r8.al = ((bios_data_t *) 0)->midnight_flag;
! Debug: eq unsigned char = [+$470] to unsigned char regs = [S+4+$10] (used reg = )
mov	al,[$470]
mov	$12[bp],al
!BCC_EOS
! 5417       ((bios_data_t *) 0)->midnight_flag = 0;
! Debug: eq int = const 0 to unsigned char = [+$470] (used reg = )
xor	al,al
mov	[$470],al
!BCC_EOS
! 5418 #asm
!BCC_EOS
!BCC_ASM
_int1a_function.ds	set	$16
.int1a_function.ds	set	$14
_int1a_function.val8	set	1
.int1a_function.val8	set	-1
_int1a_function.iret_addr	set	$18
.int1a_function.iret_addr	set	$16
_int1a_function.regs	set	6
.int1a_function.regs	set	4
      sti
! 5420 endasm
!BCC_ENDASM
!BCC_EOS
! 5421       iret_addr.flags.u.r8.flagsl &= 0xfe;
! Debug: andab int = const $FE to unsigned char iret_addr = [S+4+$18] (used reg = )
mov	al,$1A[bp]
and	al,#$FE
mov	$1A[bp],al
!BCC_EOS
! 5422       break;
br 	.79E
!BCC_EOS
! 5423     case 1:
! 5424 #asm
.7A2:
!BCC_EOS
!BCC_ASM
_int1a_function.ds	set	$16
.int1a_function.ds	set	$14
_int1a_function.val8	set	1
.int1a_function.val8	set	-1
_int1a_function.iret_addr	set	$18
.int1a_function.iret_addr	set	$16
_int1a_function.regs	set	6
.int1a_function.regs	set	4
      cli
! 5426 endasm
!BCC_ENDASM
!BCC_EOS
! 5427       ((bios_data_t *) 0)->ticks_high = regs.u.r16.cx;
! Debug: eq unsigned short regs = [S+4+$E] to unsigned short = [+$46E] (used reg = )
mov	ax,$10[bp]
mov	[$46E],ax
!BCC_EOS
! 5428       ((bios_data_t *) 0)->ticks_low = regs.u.r16.dx;
! Debug: eq unsigned short regs = [S+4+$C] to unsigned short = [+$46C] (used reg = )
mov	ax,$E[bp]
mov	[$46C],ax
!BCC_EOS
! 5429       ((bios_data_t *) 0)->midnight_flag = 0;
! Debug: eq int = const 0 to unsigned char = [+$470] (used reg = )
xor	al,al
mov	[$470],al
!BCC_EOS
! 5430 #asm
!BCC_EOS
!BCC_ASM
_int1a_function.ds	set	$16
.int1a_function.ds	set	$14
_int1a_function.val8	set	1
.int1a_function.val8	set	-1
_int1a_function.iret_addr	set	$18
.int1a_function.iret_addr	set	$16
_int1a_function.regs	set	6
.int1a_function.regs	set	4
      sti
! 5432 endasm
!BCC_ENDASM
!BCC_EOS
! 5433       regs.u.r8.ah = 0;
! Debug: eq int = const 0 to unsigned char regs = [S+4+$11] (used reg = )
xor	al,al
mov	$13[bp],al
!BCC_EOS
! 5434       iret_addr.flags.u.r8.flagsl &= 0xfe;
! Debug: andab int = const $FE to unsigned char iret_addr = [S+4+$18] (used reg = )
mov	al,$1A[bp]
and	al,#$FE
mov	$1A[bp],al
!BCC_EOS
! 5435       break;
br 	.79E
!BCC_EOS
! 5436     case 2:
! 5437       if (rtc_updating()) {
.7A3:
! Debug: func () unsigned short = rtc_updating+0 (used reg = )
call	_rtc_updating
test	ax,ax
je  	.7A4
.7A5:
! 5438         iret_addr.flags.u.r8.flagsl |= 0x01;
! Debug: orab int = const 1 to unsigned char iret_addr = [S+4+$18] (used reg = )
mov	al,$1A[bp]
or	al,*1
mov	$1A[bp],al
!BCC_EOS
! 5439         break;
br 	.79E
!BCC_EOS
! 5440       }
! 5441       regs.u.r8.dh = inb_cmos(0x00);
.7A4:
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char regs = [S+4+$D] (used reg = )
mov	$F[bp],al
!BCC_EOS
! 5442       regs.u.r8.cl = inb_cmos(0x02);
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char regs = [S+4+$E] (used reg = )
mov	$10[bp],al
!BCC_EOS
! 5443       regs.u.r8.ch = inb_cmos(0x04);
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char regs = [S+4+$F] (used reg = )
mov	$11[bp],al
!BCC_EOS
! 5444       regs.
! 5444 u.r8.dl = inb_cmos(0x0b) & 0x01;
! Debug: list int = const $B (used reg = )
mov	ax,*$B
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: and int = const 1 to unsigned char = al+0 (used reg = )
and	al,*1
! Debug: eq unsigned char = al+0 to unsigned char regs = [S+4+$C] (used reg = )
mov	$E[bp],al
!BCC_EOS
! 5445       regs.u.r8.ah = 0;
! Debug: eq int = const 0 to unsigned char regs = [S+4+$11] (used reg = )
xor	al,al
mov	$13[bp],al
!BCC_EOS
! 5446       regs.u.r8.al = regs.u.r8.ch;
! Debug: eq unsigned char regs = [S+4+$F] to unsigned char regs = [S+4+$10] (used reg = )
mov	al,$11[bp]
mov	$12[bp],al
!BCC_EOS
! 5447       iret_addr.flags.u.r8.flagsl &= 0xfe;
! Debug: andab int = const $FE to unsigned char iret_addr = [S+4+$18] (used reg = )
mov	al,$1A[bp]
and	al,#$FE
mov	$1A[bp],al
!BCC_EOS
! 5448       break;
br 	.79E
!BCC_EOS
! 5449     case 3:
! 5450       if (rtc_updating()) {
.7A6:
! Debug: func () unsigned short = rtc_updating+0 (used reg = )
call	_rtc_updating
test	ax,ax
je  	.7A7
.7A8:
! 5451         init_rtc();
! Debug: func () void = init_rtc+0 (used reg = )
call	_init_rtc
!BCC_EOS
! 5452       }
! 5453       outb_cmos(0x00, regs.u.r8.dh);
.7A7:
! Debug: list unsigned char regs = [S+4+$D] (used reg = )
mov	al,$F[bp]
xor	ah,ah
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: func () void = outb_cmos+0 (used reg = )
call	_outb_cmos
add	sp,*4
!BCC_EOS
! 5454       outb_cmos(0x02, regs.u.r8.cl);
! Debug: list unsigned char regs = [S+4+$E] (used reg = )
mov	al,$10[bp]
xor	ah,ah
push	ax
! Debug: list int = const 2 (used reg = )
mov	ax,*2
push	ax
! Debug: func () void = outb_cmos+0 (used reg = )
call	_outb_cmos
add	sp,*4
!BCC_EOS
! 5455       outb_cmos(0x04, regs.u.r8.ch);
! Debug: list unsigned char regs = [S+4+$F] (used reg = )
mov	al,$11[bp]
xor	ah,ah
push	ax
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = outb_cmos+0 (used reg = )
call	_outb_cmos
add	sp,*4
!BCC_EOS
! 5456       val8 = (inb_cmos(0x0b) & 0x60) | 0x02 | (regs.u.r8.dl & 0x01);
! Debug: expression subtree swapping
! Debug: list int = const $B (used reg = )
mov	ax,*$B
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: and int = const $60 to unsigned char = al+0 (used reg = )
and	al,*$60
! Debug: or int = const 2 to unsigned char = al+0 (used reg = )
or	al,*2
push	ax
! Debug: and int = const 1 to unsigned char regs = [S+6+$C] (used reg = )
mov	al,$E[bp]
and	al,*1
! Debug: or unsigned char (temp) = [S+6-6] to unsigned char = al+0 (used reg = )
or	al,0+..FFD8[bp]
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char val8 = [S+4-3] (used reg = )
mov	-1[bp],al
!BCC_EOS
! 5457       outb_cmos(0x0b, val8);
! Debug: list unsigned char val8 = [S+4-3] (used reg = )
mov	al,-1[bp]
xor	ah,ah
push	ax
! Debug: list int = const $B (used reg = )
mov	ax,*$B
push	ax
! Debug: func () void = outb_cmos+0 (used reg = )
call	_outb_cmos
add	sp,*4
!BCC_EOS
! 5458       regs.u.r8.ah = 0;
! Debug: eq int = const 0 to unsigned char regs = [S+4+$11] (used reg = )
xor	al,al
mov	$13[bp],al
!BCC_EOS
! 5459       regs.u.r8.al = val8;
! Debug: eq unsigned char val8 = [S+4-3] to unsigned char regs = [S+4+$10] (used reg = )
mov	al,-1[bp]
mov	$12[bp],al
!BCC_EOS
! 5460       iret_addr.flags.u.r8.flagsl &= 0xfe;
! Debug: andab int = const $FE to unsigned char iret_addr = [S+4+$18] (used reg = )
mov	al,$1A[bp]
and	al,#$FE
mov	$1A[bp],al
!BCC_EOS
! 5461       break;
br 	.79E
!BCC_EOS
! 5462     case 4:
! 5463       regs.u.r8.ah = 0;
.7A9:
! Debug: eq int = const 0 to unsigned char regs = [S+4+$11] (used reg = )
xor	al,al
mov	$13[bp],al
!BCC_EOS
! 5464       if (rtc_updating()) {
! Debug: func () unsigned short = rtc_updating+0 (used reg = )
call	_rtc_updating
test	ax,ax
je  	.7AA
.7AB:
! 5465         iret_addr.flags.u.r8.flagsl |= 0x01;
! Debug: orab int = const 1 to unsigned char iret_addr = [S+4+$18] (used reg = )
mov	al,$1A[bp]
or	al,*1
mov	$1A[bp],al
!BCC_EOS
! 5466         break;
br 	.79E
!BCC_EOS
! 5467       }
! 5468       regs.u.r8.cl = inb_cmos(0x09);
.7AA:
! Debug: list int = const 9 (used reg = )
mov	ax,*9
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char regs = [S+4+$E] (used reg = )
mov	$10[bp],al
!BCC_EOS
! 5469       regs.u.r8.dh = inb_cmos(0x08);
! Debug: list int = const 8 (used reg = )
mov	ax,*8
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char regs = [S+4+$D] (used reg = )
mov	$F[bp],al
!BCC_EOS
! 5470       regs.u.r8.dl = inb_cmos(0x07);
! Debug: list int = const 7 (used reg = )
mov	ax,*7
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char regs = [S+4+$C] (used reg = )
mov	$E[bp],al
!BCC_EOS
! 5471       regs.u.r8.ch = inb_cmos(0x32);
! Debug: list int = const $32 (used reg = )
mov	ax,*$32
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char regs = [S+4+$F] (used reg = )
mov	$11[bp],al
!BCC_EOS
! 5472       regs.u.r8.al = regs.u.r8.ch;
! Debug: eq unsigned char regs = [S+4+$F] to unsigned char regs = [S+4+$10] (used reg = )
mov	al,$11[bp]
mov	$12[bp],al
!BCC_EOS
! 5473       iret_addr.flags.u.r8.flagsl &= 0xfe;
! Debug: andab int = const $FE to unsigned char iret_addr = [S+4+$18] (used reg = )
mov	al,$1A[bp]
and	al,#$FE
mov	$1A[bp],al
!BCC_EOS
! 5474       break;
br 	.79E
!BCC_EOS
! 5475     case 5:
! 5476       if (rtc_updating()) {
.7AC:
! Debug: func () unsigned short = rtc_updating+0 (used reg = )
call	_rtc_updating
test	ax,ax
je  	.7AD
.7AE:
! 5477         init_rtc();
! Debug: func () void = init_rtc+0 (used reg = )
call	_init_rtc
!BCC_EOS
! 5478         iret_addr.flags.u.r8.flagsl |= 0x01;
! Debug: orab int = const 1 to unsigned char iret_addr = [S+4+$18] (used reg = )
mov	al,$1A[bp]
or	al,*1
mov	$1A[bp],al
!BCC_EOS
! 5479         break;
br 	.79E
!BCC_EOS
! 5480         }
! 5481       outb_cmos(0x09, regs.u.r8.cl);
.7AD:
! Debug: list unsigned char regs = [S+4+$E] (used reg = )
mov	al,$10[bp]
xor	ah,ah
push	ax
! Debug: list int = const 9 (used reg = )
mov	ax,*9
push	ax
! Debug: func () void = outb_cmos+0 (used reg = )
call	_outb_cmos
add	sp,*4
!BCC_EOS
! 5482       outb_cmos(0x08, regs.u.r8.dh);
! Debug: list unsigned char regs = [S+4+$D] (used reg = )
mov	al,$F[bp]
xor	ah,ah
push	ax
! Debug: list int = const 8 (used reg = )
mov	ax,*8
push	ax
! Debug: func () void = outb_cmos+0 (used reg = )
call	_outb_cmos
add	sp,*4
!BCC_EOS
! 5483       outb_cmos(0x07, regs.u.r8.dl);
! Debug: list unsigned char regs = [S+4+$C] (used reg = )
mov	al,$E[bp]
xor	ah,ah
push	ax
! Debug: list int = const 7 (used reg = )
mov	ax,*7
push	ax
! Debug: func () void = outb_cmos+0 (used reg = )
call	_outb_cmos
add	sp,*4
!BCC_EOS
! 5484       outb_cmos(0x32, regs.u.r8.ch);
! Debug: list unsigned char regs = [S+4+$F] (used reg = )
mov	al,$11[bp]
xor	ah,ah
push	ax
! Debug: list int = const $32 (used reg = )
mov	ax,*$32
push	ax
! Debug: func () void = outb_cmos+0 (used reg = )
call	_outb_cmos
add	sp,*4
!BCC_EOS
! 5485       val8 = inb_cmos(0x0b) & 0x7f;
! Debug: list int = const $B (used reg = )
mov	ax,*$B
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: and int = const $7F to unsigned char = al+0 (used reg = )
and	al,*$7F
! Debug: eq unsigned char = al+0 to unsigned char val8 = [S+4-3] (used reg = )
mov	-1[bp],al
!BCC_EOS
! 5486       outb_cmos(0x0b, val8);
! Debug: list unsigned char val8 = [S+4-3] (used reg = )
mov	al,-1[bp]
xor	ah,ah
push	ax
! Debug: list int = const $B (used reg = )
mov	ax,*$B
push	ax
! Debug: func () void = outb_cmos+0 (used reg = )
call	_outb_cmos
add	sp,*4
!BCC_EOS
! 5487       regs.u.r8.ah = 0;
! Debug: eq int = const 0 to unsigned char regs = [S+4+$11] (used reg = )
xor	al,al
mov	$13[bp],al
!BCC_EOS
! 5488       regs.u.r8.al = val8;
! Debug: eq unsigned char val8 = [S+4-3] to unsigned char regs = [S+4+$10] (used reg = )
mov	al,-1[bp]
mov	$12[bp],al
!BCC_EOS
! 5489       iret_addr.flags.u.r8.flagsl &= 0xfe;
! Debug: andab int = const $FE to unsigned char iret_addr = [S+4+$18] (used reg = )
mov	al,$1A[bp]
and	al,#$FE
mov	$1A[bp],al
!BCC_EOS
! 5490       break;
br 	.79E
!BCC_EOS
! 5491     case 6:
! 5492       val8 = inb_cmos(0x0b);
.7AF:
! Debug: list int = const $B (used reg = )
mov	ax,*$B
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char val8 = [S+4-3] (used reg = )
mov	-1[bp],al
!BCC_EOS
! 5493       regs.u.r16.ax = 0;
! Debug: eq int = const 0 to unsigned short regs = [S+4+$10] (used reg = )
xor	ax,ax
mov	$12[bp],ax
!BCC_EOS
! 5494       if (val8 & 0x20) {
! Debug: and int = const $20 to unsigned char val8 = [S+4-3] (used reg = )
mov	al,-1[bp]
and	al,*$20
test	al,al
je  	.7B0
.7B1:
! 5495         iret_addr.flags.u.r8.flagsl |= 0x01;
! Debug: orab int = const 1 to unsigned char iret_addr = [S+4+$18] (used reg = )
mov	al,$1A[bp]
or	al,*1
mov	$1A[bp],al
!BCC_EOS
! 5496         break;
br 	.79E
!BCC_EOS
! 5497       }
! 5498       if (rtc_updating()) {
.7B0:
! Debug: func () unsigned short = rtc_updating+0 (used reg = )
call	_rtc_updating
test	ax,ax
je  	.7B2
.7B3:
! 5499         init_rtc();
! Debug: func () void = init_rtc+0 (used reg = )
call	_init_rtc
!BCC_EOS
! 5500       }
! 5501       outb_cmos(0x01, regs.u.r8.dh);
.7B2:
! Debug: list unsigned char regs = [S+4+$D] (used reg = )
mov	al,$F[bp]
xor	ah,ah
push	ax
! Debug: list int = const 1 (used reg = )
mov	ax,*1
push	ax
! Debug: func () void = outb_cmos+0 (used reg = )
call	_outb_cmos
add	sp,*4
!BCC_EOS
! 5502       outb_cmos(0x03, regs.u.r8.cl);
! Debug: list unsigned char regs = [S+4+$E] (used reg = )
mov	al,$10[bp]
xor	ah,ah
push	ax
! Debug: list int = const 3 (used reg = )
mov	ax,*3
push	ax
! Debug: func () void = outb_cmos+0 (used reg = )
call	_outb_cmos
add	sp,*4
!BCC_EOS
! 5503       outb_cmos(0x05, regs.u.r8.ch);
! Debug: list unsigned char regs = [S+4+$F] (used reg = )
mov	al,$11[bp]
xor	ah,ah
push	ax
! Debug: list int = const 5 (used reg = )
mov	ax,*5
push	ax
! Debug: func () void = outb_cmos+0 (used reg = )
call	_outb_cmos
add	sp,*4
!BCC_EOS
! 5504       outb(0x00a1, inb(0x00a1) & 0xfe);
! Debug: list int = const $A1 (used reg = )
mov	ax,#$A1
push	ax
! Debug: func () unsigned char = inb+0 (used reg = )
call	_inb
inc	sp
inc	sp
! Debug: and int = const $FE to unsigned char = al+0 (used reg = )
and	al,#$FE
! Debug: list unsigned char = al+0 (used reg = )
xor	ah,ah
push	ax
! Debug: list int = const $A1 (used reg = )
mov	ax,#$A1
push	ax
! Debug: func () void = outb+0 (used reg = )
call	_outb
add	sp,*4
!BCC_EOS
! 5505       outb_cmos(0x0b, (val8 & 0x7f) | 0x20);
! Debug: and int = const $7F to unsigned char val8 = [S+4-3] (used reg = )
mov	al,-1[bp]
and	al,*$7F
! Debug: or int = const $20 to unsigned char = al+0 (used reg = )
or	al,*$20
! Debug: list unsigned char = al+0 (used reg = )
xor	ah,ah
push	ax
! Debug: list int = const $B (used reg = )
mov	ax,*$B
push	ax
! Debug: func () void = outb_cmos+0 (used reg = )
call	_outb_cmos
add	sp,*4
!BCC_EOS
! 5506       iret_addr.flags.u.r8.flagsl &= 0xfe;
! Debug: andab int = const $FE to unsigned char iret_addr = [S+4+$18] (used reg = )
mov	al,$1A[bp]
and	al,#$FE
mov	$1A[bp],al
!BCC_EOS
! 5507       break;
br 	.79E
!BCC_EOS
! 5508     case 7:
! 5509       val8 = inb_cmos(0x0b);
.7B4:
! Debug: list int = const $B (used reg = )
mov	ax,*$B
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char val8 = [S+4-3] (used reg = )
mov	-1[bp],al
!BCC_EOS
! 5510       outb_cmos(0x0b, val8 & 0x57);
! Debug: and int = const $57 to unsigned char val8 = [S+4-3] (used reg = )
mov	al,-1[bp]
and	al,*$57
! Debug: list unsigned char = al+0 (used reg = )
xor	ah,ah
push	ax
! Debug: list int = const $B (used reg = )
mov	ax,*$B
push	ax
! Debug: func () void = outb_cmos+0 (used reg = )
call	_outb_cmos
add	sp,*4
!BCC_EOS
! 5511       regs.u.r8.ah = 0;
! Debug: eq int = const 0 to unsigned char regs = [S+4+$11] (used reg = )
xor	al,al
mov	$13[bp],al
!BCC_EOS
! 5512       regs.u.r8.al = val8;
! Debug: eq unsigned char val8 = [S+4-3] to unsigned char regs = [S+4+$10] (used reg = )
mov	al,-1[bp]
mov	$12[bp],al
!BCC_EOS
! 5513       iret_addr.flags.u.r8.flagsl &= 0xfe;
! Debug: andab int = const $FE to unsigned char iret_addr = [S+4+$18] (used reg = )
mov	al,$1A[bp]
and	al,#$FE
mov	$1A[bp],al
!BCC_EOS
! 5514       break;
br 	.79E
!BCC_EOS
! 5515     case 0xb1:
! 5516       if (regs.u.r8.bl == 0xf
.7B5:
! 5516 f) {
! Debug: logeq int = const $FF to unsigned char regs = [S+4+$A] (used reg = )
mov	al,$C[bp]
cmp	al,#$FF
jne 	.7B6
.7B7:
! 5517         bios_printf(4, "PCI BIOS: PCI not present\n");
! Debug: list * char = .7B8+0 (used reg = )
mov	bx,#.7B8
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*4
!BCC_EOS
! 5518       } else if (regs.u.r8.bl == 0x81) {
jmp .7B9
.7B6:
! Debug: logeq int = const $81 to unsigned char regs = [S+4+$A] (used reg = )
mov	al,$C[bp]
cmp	al,#$81
jne 	.7BA
.7BB:
! 5519         bios_printf(4, "unsupported PCI BIOS function 0x%02x\n", regs.u.r8.al);
! Debug: list unsigned char regs = [S+4+$10] (used reg = )
mov	al,$12[bp]
xor	ah,ah
push	ax
! Debug: list * char = .7BC+0 (used reg = )
mov	bx,#.7BC
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*6
!BCC_EOS
! 5520       } else if (regs.u.r8.bl == 0x83) {
jmp .7BD
.7BA:
! Debug: logeq int = const $83 to unsigned char regs = [S+4+$A] (used reg = )
mov	al,$C[bp]
cmp	al,#$83
jne 	.7BE
.7BF:
! 5521         bios_printf(4, "bad PCI vendor ID %04x\n", regs.u.r16.dx);
! Debug: list unsigned short regs = [S+4+$C] (used reg = )
push	$E[bp]
! Debug: list * char = .7C0+0 (used reg = )
mov	bx,#.7C0
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*6
!BCC_EOS
! 5522       } else if (regs.u.r8.bl == 0x86) {
jmp .7C1
.7BE:
! Debug: logeq int = const $86 to unsigned char regs = [S+4+$A] (used reg = )
mov	al,$C[bp]
cmp	al,#$86
jne 	.7C2
.7C3:
! 5523         if (regs.u.r8.al == 0x02) {
! Debug: logeq int = const 2 to unsigned char regs = [S+4+$10] (used reg = )
mov	al,$12[bp]
cmp	al,*2
jne 	.7C4
.7C5:
! 5524           bios_printf(4, "PCI device %04x:%04x not found at index %d\n", regs.u.r16.dx, regs.u.r16.cx, regs.u.r16.si);
! Debug: list unsigned short regs = [S+4+4] (used reg = )
push	6[bp]
! Debug: list unsigned short regs = [S+6+$E] (used reg = )
push	$10[bp]
! Debug: list unsigned short regs = [S+8+$C] (used reg = )
push	$E[bp]
! Debug: list * char = .7C6+0 (used reg = )
mov	bx,#.7C6
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*$A
!BCC_EOS
! 5525         } else {
jmp .7C7
.7C4:
! 5526           bios_printf(4, "no PCI device with class code 0x%02x%04x found at index %d\n", regs.u.r8.cl, regs.u.r16.dx, regs.u.r16.si);
! Debug: list unsigned short regs = [S+4+4] (used reg = )
push	6[bp]
! Debug: list unsigned short regs = [S+6+$C] (used reg = )
push	$E[bp]
! Debug: list unsigned char regs = [S+8+$E] (used reg = )
mov	al,$10[bp]
xor	ah,ah
push	ax
! Debug: list * char = .7C8+0 (used reg = )
mov	bx,#.7C8
push	bx
! Debug: list int = const 4 (used reg = )
mov	ax,*4
push	ax
! Debug: func () void = bios_printf+0 (used reg = )
call	_bios_printf
add	sp,*$A
!BCC_EOS
! 5527         }
! 5528       }
.7C7:
! 5529       regs.u.r8.ah = regs.u.r8.bl;
.7C2:
.7C1:
.7BD:
.7B9:
! Debug: eq unsigned char regs = [S+4+$A] to unsigned char regs = [S+4+$11] (used reg = )
mov	al,$C[bp]
mov	$13[bp],al
!BCC_EOS
! 5530       iret_addr.flags.u.r8.flagsl |= 0x01;
! Debug: orab int = const 1 to unsigned char iret_addr = [S+4+$18] (used reg = )
mov	al,$1A[bp]
or	al,*1
mov	$1A[bp],al
!BCC_EOS
! 5531       break;
jmp .79E
!BCC_EOS
! 5532     default:
! 5533       iret_addr.flags.u.r8.flagsl |= 0x01;
.7C9:
! Debug: orab int = const 1 to unsigned char iret_addr = [S+4+$18] (used reg = )
mov	al,$1A[bp]
or	al,*1
mov	$1A[bp],al
!BCC_EOS
! 5534   }
! 5535 }
jmp .79E
.7A0:
sub	al,*0
jb 	.7C9
cmp	al,*7
ja  	.7CA
xor	ah,ah
shl	ax,*1
mov	bx,ax
seg	cs
br	.7CB[bx]
.7CB:
.word	.7A1
.word	.7A2
.word	.7A3
.word	.7A6
.word	.7A9
.word	.7AC
.word	.7AF
.word	.7B4
.7CA:
sub	al,#$B1
beq 	.7B5
jmp	.7C9
.79E:
..FFD8	=	-4
mov	sp,bp
pop	bp
ret
! 5536   void
! Register BX used in function int1a_function
! 5537 int70_function(regs, ds, iret_addr)
! 5538   pusha_regs_t regs;
export	_int70_function
_int70_function:
!BCC_EOS
! 5539   Bit16u ds;
!BCC_EOS
! 5540   iret_addr_t iret_addr;
!BCC_EOS
! 5541 {
! 5542   Bit8u registerB = 0, registerC = 0;
push	bp
mov	bp,sp
dec	sp
! Debug: eq int = const 0 to unsigned char registerB = [S+3-3] (used reg = )
xor	al,al
mov	-1[bp],al
dec	sp
! Debug: eq int = const 0 to unsigned char registerC = [S+4-4] (used reg = )
xor	al,al
mov	-2[bp],al
!BCC_EOS
! 5543   registerB = inb_cmos( 0xB );
! Debug: list int = const $B (used reg = )
mov	ax,*$B
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char registerB = [S+4-3] (used reg = )
mov	-1[bp],al
!BCC_EOS
! 5544   registerC = inb_cmos( 0xC );
! Debug: list int = const $C (used reg = )
mov	ax,*$C
push	ax
! Debug: func () unsigned char = inb_cmos+0 (used reg = )
call	_inb_cmos
inc	sp
inc	sp
! Debug: eq unsigned char = al+0 to unsigned char registerC = [S+4-4] (used reg = )
mov	-2[bp],al
!BCC_EOS
! 5545   if( ( registerB & 0x60 ) != 0 ) {
! Debug: and int = const $60 to unsigned char registerB = [S+4-3] (used reg = )
mov	al,-1[bp]
and	al,*$60
! Debug: ne int = const 0 to unsigned char = al+0 (used reg = )
test	al,al
beq 	.7CC
.7CD:
! 5546     if( ( registerC & 0x20 ) != 0 ) {
! Debug: and int = const $20 to unsigned char registerC = [S+4-4] (used reg = )
mov	al,-2[bp]
and	al,*$20
! Debug: ne int = const 0 to unsigned char = al+0 (used reg = )
test	al,al
je  	.7CE
.7CF:
! 5547 #asm
!BCC_EOS
!BCC_ASM
_int70_function.registerC	set	0
.int70_function.registerC	set	-2
_int70_function.ds	set	$16
.int70_function.ds	set	$14
_int70_function.registerB	set	1
.int70_function.registerB	set	-1
_int70_function.iret_addr	set	$18
.int70_function.iret_addr	set	$16
_int70_function.regs	set	6
.int70_function.regs	set	4
      sti
      int #0x4a
      cli
! 5551 endasm
!BCC_ENDASM
!BCC_EOS
! 5552     }
! 5553     if( ( registerC & 0x40 ) != 0 ) {
.7CE:
! Debug: and int = const $40 to unsigned char registerC = [S+4-4] (used reg = )
mov	al,-2[bp]
and	al,*$40
! Debug: ne int = const 0 to unsigned char = al+0 (used reg = )
test	al,al
beq 	.7D0
.7D1:
! 5554       if( *((Bit8u *)(0x4A0)) != 0 ) {
! Debug: ne int = const 0 to unsigned char = [+$4A0] (used reg = )
mov	al,[$4A0]
test	al,al
beq 	.7D2
.7D3:
! 5555         Bit32u time, toggle;
!BCC_EOS
! 5556         time = *((Bit32u *)(0x49C));
add	sp,*-8
! Debug: eq unsigned long = [+$49C] to unsigned long time = [S+$C-8] (used reg = )
mov	ax,[$49C]
mov	bx,[$49E]
mov	-6[bp],ax
mov	-4[bp],bx
!BCC_EOS
! 5557         if( time < 0x3D1 ) {
! Debug: lt unsigned long = const $3D1 to unsigned long time = [S+$C-8] (used reg = )
mov	ax,#$3D1
xor	bx,bx
lea	di,-6[bp]
call	lcmpul
jbe 	.7D4
.7D5:
! 5558           Bit16u segment, offset;
!BCC_EOS
! 5559           segment = *((Bit16u *)(0x498));
add	sp,*-4
! Debug: eq unsigned short = [+$498] to unsigned short segment = [S+$10-$E] (used reg = )
mov	ax,[$498]
mov	-$C[bp],ax
!BCC_EOS
! 5560           offset = *((Bit16u *)(0x49A));
! Debug: eq unsigned short = [+$49A] to unsigned short offset = [S+$10-$10] (used reg = )
mov	ax,[$49A]
mov	-$E[bp],ax
!BCC_EOS
! 5561           *((Bit8u *)(0x4A0)) = (0);
! Debug: eq int = const 0 to unsigned char = [+$4A0] (used reg = )
xor	al,al
mov	[$4A0],al
!BCC_EOS
! 5562           outb_cmos( 0xB, registerB & 0x37 );
! Debug: and int = const $37 to unsigned char registerB = [S+$10-3] (used reg = )
mov	al,-1[bp]
and	al,*$37
! Debug: list unsigned char = al+0 (used reg = )
xor	ah,ah
push	ax
! Debug: list int = const $B (used reg = )
mov	ax,*$B
push	ax
! Debug: func () void = outb_cmos+0 (used reg = )
call	_outb_cmos
add	sp,*4
!BCC_EOS
! 5563           _write_byte(_read_byte(offset, segment) | 0x80, offset, segment);
! Debug: list unsigned short segment = [S+$10-$E] (used reg = )
push	-$C[bp]
! Debug: list unsigned short offset = [S+$12-$10] (used reg = )
push	-$E[bp]
! Debug: list unsigned short segment = [S+$14-$E] (used reg = )
push	-$C[bp]
! Debug: list unsigned short offset = [S+$16-$10] (used reg = )
push	-$E[bp]
! Debug: func () unsigned char = _read_byte+0 (used reg = )
call	__read_byte
add	sp,*4
! Debug: or int = const $80 to unsigned char = al+0 (used reg = )
or	al,#$80
! Debug: list unsigned char = al+0 (used reg = )
xor	ah,ah
push	ax
! Debug: func () void = _write_byte+0 (used reg = )
call	__write_byte
add	sp,*6
!BCC_EOS
! 5564         } else {
add	sp,*4
jmp .7D6
.7D4:
! 5565           time -= 0x3D1;
! Debug: subab unsigned long = const $3D1 to unsigned long time = [S+$C-8] (used reg = )
mov	ax,#$3D1
xor	bx,bx
push	bx
push	ax
mov	ax,-6[bp]
mov	bx,-4[bp]
lea	di,-$E[bp]
call	lsubul
mov	-6[bp],ax
mov	-4[bp],bx
add	sp,*4
!BCC_EOS
! 5566           *((Bit32u *)(0x49C)) = (time);
! Debug: eq unsigned long time = [S+$C-8] to unsigned long = [+$49C] (used reg = )
mov	ax,-6[bp]
mov	bx,-4[bp]
mov	[$49C],ax
mov	[$49E],bx
!BCC_EOS
! 5567         }
! 5568       }
.7D6:
add	sp,*8
! 5569     }
.7D2:
! 5570   }
.7D0:
! 5571 #asm
.7CC:
!BCC_EOS
!BCC_ASM
_int70_function.registerC	set	0
.int70_function.registerC	set	-2
_int70_function.ds	set	$16
.int70_function.ds	set	$14
_int70_function.registerB	set	1
.int70_function.registerB	set	-1
_int70_function.iret_addr	set	$18
.int70_function.iret_addr	set	$16
_int70_function.regs	set	6
.int70_function.regs	set	4
  call eoi_both_pics
! 5573 endasm
!BCC_ENDASM
!BCC_EOS
! 5574 }
mov	sp,bp
pop	bp
ret
! 5575 #asm
!BCC_ASM
_int70_function.ds	set	$12
_int70_function.iret_addr	set	$14
_int70_function.regs	set	2
;------------------------------------------
;- INT74h : PS/2 mouse hardware interrupt -
;------------------------------------------
int74_handler:
  sti
  pusha
  push ds ;; save DS
  push #0x00
  pop ds
  push 0x040E ;; push 0000:040E (opcodes 0xff, 0x36, 0x0E, 0x04)
  pop ds
  push #0x00 ;; placeholder for status
  push #0x00 ;; placeholder for X
  push #0x00 ;; placeholder for Y
  push #0x00 ;; placeholder for Z
  push #0x00 ;; placeholder for make_far_call boolean
  call _int74_function
  pop cx ;; remove make_far_call from stack
  jcxz int74_done
  ;; make far call to EBDA:0022
  call far ptr[0x22]
int74_done:
  cli
  call eoi_both_pics
  add sp, #8 ;; pop status, x, y, z
  pop ds ;; restore DS
  popa
  iret
;; This will perform an IRET, but will retain value of current CF
;; by altering flags on stack. Better than RETF #02.
iret_modify_cf:
  jc carry_set
  push bp
  mov bp, sp
  and BYTE [bp + 0x06], #0xfe
  pop bp
  iret
carry_set:
  push bp
  mov bp, sp
  or BYTE [bp + 0x06], #0x01
  pop bp
  iret
;----------------------
;- INT13h (relocated) -
;----------------------
;
; int13_relocated is a little bit messed up since I played with it
; I have to rewrite it:
; - call a function that detect which function to call
; - make all called C function get the same parameters list
;
int13_relocated:
  ;; check for an eltorito function
  cmp ah,#0x4a
  jb int13_not_eltorito
  cmp ah,#0x4d
  ja int13_not_eltorito
  pusha
  push es
  push ds
  push #int13_out
  jmp _int13_eltorito ;; ELDX not used
int13_not_eltorito:
  push ax
  push bx
  push cx
  push dx
  ;; check if emulation active
  call _cdemu_isactive
  cmp al,#0x00
  je int13_cdemu_inactive
  ;; check if access to the emulated drive
  call _cdemu_emulated_drive
  pop dx
  push dx
  cmp al,dl ;; int13 on emulated drive
  jne int13_nocdemu
  pop dx
  pop cx
  pop bx
  pop ax
  pusha
  push es
  push ds
  push #0x40
  pop ds
  push 0x000E
  pop ds ;; Set DS to EBDA segment
  push #int13_out
  jmp _int13_cdemu ;; ELDX not used
int13_nocdemu:
  and dl,#0xE0 ;; mask to get device class, including cdroms
  cmp al,dl ;; al is 0x00 or 0x80
  jne int13_cdemu_inactive ;; inactive for device class
  pop dx
  pop cx
  pop bx
  pop ax
  push ax
  push cx
  push dx
  push bx
  dec dl ;; real drive is dl - 1
  jmp int13_legacy
int13_cdemu_inactive:
  pop dx
  pop cx
  pop bx
  pop ax
int13_noeltorito:
  push ax
  push cx
  push dx
  push bx
int13_legacy:
  push dx ;; push eltorito value of dx instead of sp
  push bp
  push si
  push di
  push es
  push ds
  push #0x40
  pop ds ;; Set DS to 0x40
  ;; now the 16-bit registers can be restored with:
  ;; pop ds; pop es; popa; iret
  ;; arguments passed to functions should be
  ;; DS, ES, DI, SI, BP, ELDX, BX, DX, CX, AX, IP, CS, FLAGS
  test dl, #0x80
  jnz int13_notfloppy
  push #int13_out
  jmp _int13_diskette_function
int13_notfloppy:
  push 0x000E
  pop ds ;; Set DS to EBDA segment
  cmp dl, #0xE0
  jb int13_notcdrom
  shr ebx, #16
  push bx
  call _int13_cdrom
  pop bx
  shl ebx, #16
  jmp int13_out
int13_notcdrom:
int13_disk:
  ;; int13_harddisk modifies high word of EAX
  shr eax, #16
  push ax
  call _int13_harddisk
  pop ax
  shl eax, #16
int13_out:
  pop ds
  pop es
  popa
  iret
;----------
;- INT18h -
;----------
int18_handler: ;; Boot Failure recovery: try the next device.
  ;; Reset SP and SS
  mov ax, #0xfffe
  mov sp, ax
  xor ax, ax
  mov ss, ax
  ;; Get the boot sequence number out of the IPL memory
  mov bx, #0x9ff0
  mov ds, bx ;; Set segment
  mov bx, 0x0082 ;; BX is now the sequence number
  inc bx ;; ++
  mov 0x0082, bx ;; Write it back
  mov ds, ax ;; and reset the segment to zero.
  ;; Carry on in the INT 19h handler, using the new sequence number
  push bx
  jmp int19_next_boot
;----------
;- INT19h -
;----------
int19_relocated: ;; Boot function, relocated
  ;; int19 was beginning to be really complex, so now it
  ;; just calls a C function that does the work
  push bp
  mov bp, sp
  ;; Reset SS and SP
  mov ax, #0xfffe
  mov sp, ax
  xor ax, ax
  mov ss, ax
  ;; Start from the first boot device (0, in AX)
  mov bx, #0x9ff0
  mov ds, bx ;; Set segment to write to the IPL memory
  mov 0x0082, ax ;; Save the sequence number
  mov ds, ax ;; and reset the segment.
  push ax
int19_next_boot:
  ;; Call the C code for the next boot device
  call _int19_function
  ;; Boot failed: invoke the boot recovery function
  int #0x18
;----------------------
;- POST: Floppy Drive -
;----------------------
floppy_drive_post:
  xor ax, ax
  mov ds, ax
  mov al, #0x00
  mov 0x043e, al ;; drive 0 & 1 uncalibrated, no interrupt has occurred
  mov 0x043f, al ;; diskette motor status: read op, drive0, motors off
  mov 0x0440, al ;; diskette motor timeout counter: not active
  mov 0x0441, al ;; diskette controller status return code
  mov 0x0442, al ;; disk & diskette controller status register 0
  mov 0x0443, al ;; diskette controller status register 1
  mov 0x0444, al ;; diskette controller status register 2
  mov 0x0445, al ;; diskette controller cylinder number
  mov 0x0446, al ;; diskette controller head number
  mov 0x0447, al ;; diskette controller sector number
  mov 0x0448, al ;; diskette controller bytes written
  mov 0x048b, al ;; diskette configuration data
  ;; -----------------------------------------------------------------
  ;; (048F) diskette controller information
  ;;
  mov al, #0x10 ;; get CMOS diskette drive type
  out 0x0070, AL
  in AL, 0x0071
  mov ah, al ;; save byte to AH
look_drive0:
  shr al, #4 ;; look at top 4 bits for drive 0
  jz f0_missing ;; jump if no drive0
  mov bl, #0x07 ;; drive0 determined, multi-rate, has changed line
  jmp look_drive1
f0_missing:
  mov bl, #0x00 ;; no drive0
look_drive1:
  mov al, ah ;; restore from AH
  and al, #0x0f ;; look at bottom 4 bits for drive 1
  jz f1_missing ;; jump if no drive1
  or bl, #0x70 ;; drive1 determined, multi-rate, has changed line
f1_missing:
                   ;; leave high bits in BL zerod
  mov 0x048f, bl ;; put new val in BDA (diskette controller information)
  ;; -----------------------------------------------------------------
  mov al, #0x00
  mov 0x0490, al ;; diskette 0 media state
  mov 0x0491, al ;; diskette 1 media state
                   ;; diskette 0,1 operational starting state
                   ;; drive type has not been determined,
                   ;; has no changed detection line
  mov 0x0492, al
  mov 0x0493, al
  mov 0x0494, al ;; diskette 0 current cylinder
  mov 0x0495, al ;; diskette 1 current cylinder
  mov al, #0x02
  out 0x000a, al ;; clear DMA-1 channel 2 mask bit
  SET_INT_VECTOR(0x1E, #0xF000, #diskette_param_table2)
  SET_INT_VECTOR(0x40, #0xF000, #int13_diskette)
  SET_INT_VECTOR(0x0E, #0xF000, #int0e_handler) ;; IRQ 6
  ret
;--------------------
;- POST: HARD DRIVE -
;--------------------
; relocated here because the primary POST area isnt big enough.
hard_drive_post:
  mov al, #0x0a ; 0000 1010 = reserved, disable IRQ 14
  mov dx, #0x03f6
  out dx, al
  xor ax, ax
  mov ds, ax
  mov 0x0474, al
  mov 0x0477, al
  mov 0x048c, al
  mov 0x048d, al
  mov 0x048e, al
  mov al, #0x01
  mov 0x0475, al
  mov al, #0xc0
  mov 0x0476, al
  SET_INT_VECTOR(0x13, #0xF000, #int13_handler)
  SET_INT_VECTOR(0x76, #0xF000, #int76_handler)
  ;; INT 41h: hard disk 0 configuration pointer
  ;; INT 46h: hard disk 1 configuration pointer
  SET_INT_VECTOR(0x41, #0x9FC0, #0x003D)
  SET_INT_VECTOR(0x46, #0x9FC0, #0x004D)
  ;; move disk geometry data from CMOS to EBDA disk parameter table(s)
  mov al, #0x12
  out 0x0070, al
  in al, 0x0071
  and al, #0xf0
  cmp al, #0xf0
  je post_d0_extended
  jmp check_for_hd1
post_d0_extended:
  mov al, #0x19
  out 0x0070, al
  in al, 0x0071
  cmp al, #47 ;; decimal 47 - user definable
  je post_d0_type47
  HALT(9099)
post_d0_type47:
  ;; CMOS purpose param table offset
  ;; 1b cylinders low 0
  ;; 1c cylinders high 1
  ;; 1d heads 2
  ;; 1e write pre-comp low 5
  ;; 1f write pre-comp high 6
  ;; 20 retries/bad map/heads>8 8
  ;; 21 landing zone low C
  ;; 22 landing zone high D
  ;; 23 sectors/track E
  mov ax, #0x9FC0
  mov ds, ax
  ;;; Filling EBDA table for hard disk 0.
  mov al, #0x1f
  out 0x0070, al
  in al, 0x0071
  mov ah, al
  mov al, #0x1e
  out 0x0070, al
  in al, 0x0071
  mov (0x003d + 0x05), ax ;; write precomp word
  mov al, #0x20
  out 0x0070, al
  in al, 0x0071
  mov (0x003d + 0x08), al ;; drive control byte
  mov al, #0x22
  out 0x0070, al
  in al, 0x0071
  mov ah, al
  mov al, #0x21
  out 0x0070, al
  in al, 0x0071
  mov (0x003d + 0x0C), ax ;; landing zone word
  mov al, #0x1c ;; get cylinders word in AX
  out 0x0070, al
  in al, 0x0071 ;; high byte
  mov ah, al
  mov al, #0x1b
  out 0x0070, al
  in al, 0x0071 ;; low byte
  mov bx, ax ;; BX = cylinders
  mov al, #0x1d
  out 0x0070, al
  in al, 0x0071
  mov cl, al ;; CL = heads
  mov al, #0x23
  out 0x0070, al
  in al, 0x0071
  mov dl, al ;; DL = sectors
  cmp bx, #1024
  jnbe hd0_post_logical_chs ;; if cylinders > 1024, use translated style CHS
hd0_post_physical_chs:
  ;; no logical CHS mapping used, just physical CHS
  ;; use Standard Fixed Disk Parameter Table (FDPT)
  mov (0x003d + 0x00), bx ;; number of physical cylinders
  mov (0x003d + 0x02), cl ;; number of physical heads
  mov (0x003d + 0x0E), dl ;; number of physical sectors
  jmp check_for_hd1
hd0_post_logical_chs:
  ;; complies with Phoenix style Translated Fixed Disk Parameter Table (FDPT)
  mov (0x003d + 0x09), bx ;; number of physical cylinders
  mov (0x003d + 0x0b), cl ;; number of physical heads
  mov (0x003d + 0x04), dl ;; number of physical sectors
  mov (0x003d + 0x0e), dl ;; number of logical sectors (same)
  mov al, #0xa0
  mov (0x003d + 0x03), al ;; A0h signature, indicates translated table
  cmp bx, #2048
  jnbe hd0_post_above_2048
  ;; 1024 < c <= 2048 cylinders
  shr bx, #0x01
  shl cl, #0x01
  jmp hd0_post_store_logical
hd0_post_above_2048:
  cmp bx, #4096
  jnbe hd0_post_above_4096
  ;; 2048 < c <= 4096 cylinders
  shr bx, #0x02
  shl cl, #0x02
  jmp hd0_post_store_logical
hd0_post_above_4096:
  cmp bx, #8192
  jnbe hd0_post_above_8192
  ;; 4096 < c <= 8192 cylinders
  shr bx, #0x03
  shl cl, #0x03
  jmp hd0_post_store_logical
hd0_post_above_8192:
  ;; 8192 < c <= 16384 cylinders
  shr bx, #0x04
  shl cl, #0x04
hd0_post_store_logical:
  mov (0x003d + 0x00), bx ;; number of physical cylinders
  mov (0x003d + 0x02), cl ;; number of physical heads
  ;; checksum
  mov cl, #0x0f ;; repeat count
  mov si, #0x003d ;; offset to disk0 FDPT
  mov al, #0x00 ;; sum
hd0_post_checksum_loop:
  add al, [si]
  inc si
  dec cl
  jnz hd0_post_checksum_loop
  not al ;; now take 2s complement
  inc al
  mov [si], al
;;; Done filling EBDA table for hard disk 0.
check_for_hd1:
  ;; is there really a second hard disk? if not, return now
  mov al, #0x12
  out 0x0070, al
  in al, 0x0071
  and al, #0x0f
  jnz post_d1_exists
  ret
post_d1_exists:
  ;; check that the hd type is really 0x0f.
  cmp al, #0x0f
  jz post_d1_extended
  HALT(9236)
post_d1_extended:
  ;; check that the extended type is 47 - user definable
  mov al, #0x1a
  out 0x0070, al
  in al, 0x0071
  cmp al, #47 ;; decimal 47 - user definable
  je post_d1_type47
  HALT(9244)
post_d1_type47:
  ;; Table for disk1.
  ;; CMOS purpose param table offset
  ;; 0x24 cylinders low 0
  ;; 0x25 cylinders high 1
  ;; 0x26 heads 2
  ;; 0x27 write pre-comp low 5
  ;; 0x28 write pre-comp high 6
  ;; 0x29 heads>8 8
  ;; 0x2a landing zone low C
  ;; 0x2b landing zone high D
  ;; 0x2c sectors/track E
;;; Fill EBDA table for hard disk 1.
  mov ax, #0x9FC0
  mov ds, ax
  mov al, #0x28
  out 0x0070, al
  in al, 0x0071
  mov ah, al
  mov al, #0x27
  out 0x0070, al
  in al, 0x0071
  mov (0x004d + 0x05), ax ;; write precomp word
  mov al, #0x29
  out 0x0070, al
  in al, 0x0071
  mov (0x004d + 0x08), al ;; drive control byte
  mov al, #0x2b
  out 0x0070, al
  in al, 0x0071
  mov ah, al
  mov al, #0x2a
  out 0x0070, al
  in al, 0x0071
  mov (0x004d + 0x0C), ax ;; landing zone word
  mov al, #0x25 ;; get cylinders word in AX
  out 0x0070, al
  in al, 0x0071 ;; high byte
  mov ah, al
  mov al, #0x24
  out 0x0070, al
  in al, 0x0071 ;; low byte
  mov bx, ax ;; BX = cylinders
  mov al, #0x26
  out 0x0070, al
  in al, 0x0071
  mov cl, al ;; CL = heads
  mov al, #0x2c
  out 0x0070, al
  in al, 0x0071
  mov dl, al ;; DL = sectors
  cmp bx, #1024
  jnbe hd1_post_logical_chs ;; if cylinders > 1024, use translated style CHS
hd1_post_physical_chs:
  ;; no logical CHS mapping used, just physical CHS
  ;; use Standard Fixed Disk Parameter Table (FDPT)
  mov (0x004d + 0x00), bx ;; number of physical cylinders
  mov (0x004d + 0x02), cl ;; number of physical heads
  mov (0x004d + 0x0E), dl ;; number of physical sectors
  ret
hd1_post_logical_chs:
  ;; complies with Phoenix style Translated Fixed Disk Parameter Table (FDPT)
  mov (0x004d + 0x09), bx ;; number of physical cylinders
  mov (0x004d + 0x0b), cl ;; number of physical heads
  mov (0x004d + 0x04), dl ;; number of physical sectors
  mov (0x004d + 0x0e), dl ;; number of logical sectors (same)
  mov al, #0xa0
  mov (0x004d + 0x03), al ;; A0h signature, indicates translated table
  cmp bx, #2048
  jnbe hd1_post_above_2048
  ;; 1024 < c <= 2048 cylinders
  shr bx, #0x01
  shl cl, #0x01
  jmp hd1_post_store_logical
hd1_post_above_2048:
  cmp bx, #4096
  jnbe hd1_post_above_4096
  ;; 2048 < c <= 4096 cylinders
  shr bx, #0x02
  shl cl, #0x02
  jmp hd1_post_store_logical
hd1_post_above_4096:
  cmp bx, #8192
  jnbe hd1_post_above_8192
  ;; 4096 < c <= 8192 cylinders
  shr bx, #0x03
  shl cl, #0x03
  jmp hd1_post_store_logical
hd1_post_above_8192:
  ;; 8192 < c <= 16384 cylinders
  shr bx, #0x04
  shl cl, #0x04
hd1_post_store_logical:
  mov (0x004d + 0x00), bx ;; number of physical cylinders
  mov (0x004d + 0x02), cl ;; number of physical heads
  ;; checksum
  mov cl, #0x0f ;; repeat count
  mov si, #0x004d ;; offset to disk0 FDPT
  mov al, #0x00 ;; sum
hd1_post_checksum_loop:
  add al, [si]
  inc si
  dec cl
  jnz hd1_post_checksum_loop
  not al ;; now take 2s complement
  inc al
  mov [si], al
;;; Done filling EBDA table for hard disk 1.
  ret
;--------------------
;- POST: EBDA segment
;--------------------
; relocated here because the primary POST area isnt big enough.
ebda_post:
  mov ax, #0x9FC0
  mov ds, ax
  mov byte ptr [0x0], #1
  xor ax, ax ; mov EBDA seg into 0x40E
  mov ds, ax
  mov word ptr [0x40E], #0x9FC0
  ret;;
;--------------------
;- POST: EOI + jmp via [0x40:67)
;--------------------
; relocated here because the primary POST area isnt big enough.
eoi_jmp_post:
  mov al, #0x11 ; send initialisation commands
  out 0x0020, al
  out 0x00a0, al
  mov al, #0x08
  out 0x0021, al
  mov al, #0x70
  out 0x00a1, al
  mov al, #0x04
  out 0x0021, al
  mov al, #0x02
  out 0x00a1, al
  mov al, #0x01
  out 0x0021, al
  out 0x00a1, al
  mov al, #0xb8
  out 0x0021, AL ;master pic: unmask IRQ 0, 1, 2, 6
  mov al, #0x8f
  out 0x00a1, AL ;slave pic: unmask IRQ 12, 13, 14
  mov al, #0x20
  out 0x00a0, al ;; slave PIC EOI
  mov al, #0x20
  out 0x0020, al ;; master PIC EOI
jmp_post_0x467:
  xor ax, ax
  mov ds, ax
  jmp far ptr [0x467]
iret_post_0x467:
  xor ax, ax
  mov ds, ax
  mov sp, [0x467]
  mov ss, [0x469]
  iret
retf_post_0x467:
  xor ax, ax
  mov ds, ax
  mov sp, [0x467]
  mov ss, [0x469]
  retf
s3_post:
  mov sp, #0xffe
  call _s3_resume
  mov bl, #0x00
  and ax, ax
  jz normal_post
  call _s3_resume_panic
;--------------------
eoi_both_pics:
  mov al, #0x20
  out 0x00a0, al ;; slave PIC EOI
eoi_master_pic:
  mov al, #0x20
  out 0x0020, al ;; master PIC EOI
  ret
;--------------------
BcdToBin:
  ;; in: AL in BCD format
  ;; out: AL in binary format, AH will always be 0
  ;; trashes BX
  mov bl, al
  and bl, #0x0f ;; bl has low digit
  shr al, #4 ;; al has high digit
  mov bh, #10
  mul al, bh ;; multiply high digit by 10 (result in AX)
  add al, bl ;; then add low digit
  ret
;--------------------
timer_tick_post:
  ;; Setup the Timer Ticks Count (0x46C:dword) and
  ;; Timer Ticks Roller Flag (0x470:byte)
  ;; The Timer Ticks Count needs to be set according to
  ;; the current CMOS time, as if ticks have been occurring
  ;; at 18.2hz since midnight up to this point. Calculating
  ;; this is a little complicated. Here are the factors I gather
  ;; regarding this. 14,318,180 hz was the original clock speed,
  ;; chosen so it could be divided by either 3 to drive the 5Mhz CPU
  ;; at the time, or 4 to drive the CGA video adapter. The div3
  ;; source was divided again by 4 to feed a 1.193Mhz signal to
  ;; the timer. With a maximum 16bit timer count, this is again
  ;; divided down by 65536 to 18.2hz.
  ;;
  ;; 14,318,180 Hz clock
  ;; /3 = 4,772,726 Hz fed to original 5Mhz CPU
  ;; /4 = 1,193,181 Hz fed to timer
  ;; /65536 (maximum timer count) = 18.20650736 ticks/second
  ;; 1 second = 18.20650736 ticks
  ;; 1 minute = 1092.390442 ticks
  ;; 1 hour = 65543.42651 ticks
  ;;
  ;; Given the values in the CMOS clock, one could calculate
  ;; the number of ticks by the following:
  ;; ticks = (BcdToBin(seconds) * 18.206507) +
  ;; (BcdToBin(minutes) * 1092.3904)
  ;; (BcdToBin(hours) * 65543.427)
  ;; To get a little more accuracy, since Im using integer
  ;; arithmetic, I use:
  ;; ticks = (((BcdToBin(hours) * 60 + BcdToBin(minutes)) * 60 + BcdToBin(seconds)) * (18 * 4294967296 + 886942379)) / 4294967296
  ;; assuming DS=0000
  ;; get CMOS hours
  xor eax, eax ;; clear EAX
  mov al, #0x04
  out 0x0070, al
  in al, 0x0071 ;; AL has CMOS hours in BCD
  call BcdToBin ;; EAX now has hours in binary
  imul eax, #60
  mov edx, eax
  ;; get CMOS minutes
  xor eax, eax ;; clear EAX
  mov al, #0x02
  out 0x0070, al
  in al, 0x0071 ;; AL has CMOS minutes in BCD
  call BcdToBin ;; EAX now has minutes in binary
  add eax, edx
  imul eax, #60
  mov edx, eax
  ;; get CMOS seconds
  xor eax, eax ;; clear EAX
  mov al, #0x00
  out 0x0070, al
  in al, 0x0071 ;; AL has CMOS seconds in BCD
  call BcdToBin ;; EAX now has seconds in binary
  add eax, edx
  ;; multiplying 18.2065073649
  mov ecx, eax
  imul ecx, #18
  mov edx, #886942379
  mul edx
  add ecx, edx
  mov 0x46C, ecx ;; Timer Ticks Count
  xor al, al
  mov 0x470, al ;; Timer Ticks Rollover Flag
  ret
;--------------------
int76_handler:
  ;; record completion in BIOS task complete flag
  push ax
  push ds
  mov ax, #0x0040
  mov ds, ax
  mov BYTE 0x008E, #0xff
  call eoi_both_pics
  ;; Notify fixed disk interrupt complete w/ int 15h, function AX=9100
  mov ax, #0x9100
  int 0x15
  pop ds
  pop ax
  iret
;--------------------
use32 386
apm32_out_str:
  push eax
  push ebx
  mov ebx, eax
apm32_out_str1:
  SEG CS
  mov al, byte ptr [bx]
  cmp al, #0
  je apm32_out_str2
  outb dx, al
  inc ebx
  jmp apm32_out_str1
apm32_out_str2:
  pop ebx
  pop eax
  ret
apm32_07_poweroff_str:
  .ascii "Shutdown"
  db 0
apm32_07_suspend_str:
  .ascii "Suspend"
  db 0
apm32_07_standby_str:
  .ascii "Standby"
  db 0
_apm32_entry:
  pushf
;-----------------
; APM interface disconnect
apm32_04:
  cmp al, #0x04
  jne apm32_05
  jmp apm32_ok
;-----------------
; APM cpu idle
apm32_05:
  cmp al, #0x05
  jne apm32_07
  sti
  hlt
  jmp apm32_ok
;-----------------
; APM Set Power State
apm32_07:
  cmp al, #0x07
  jne apm32_08
  cmp bx, #1
  jne apm32_ok
  cmp cx, #3
  je apm32_07_poweroff
  cmp cx, #2
  je apm32_07_suspend
  cmp cx, #1
  je apm32_07_standby
  jne apm32_ok
apm32_07_poweroff:
  cli
  mov dx, #0x8900
  mov ax, #apm32_07_poweroff_str
  call apm32_out_str
apm32_07_1:
  hlt
  jmp apm32_07_1
apm32_07_suspend:
  push edx
  mov dx, #0x8900
  mov ax, #apm32_07_suspend_str
  call apm32_out_str
  pop edx
  jmp apm32_ok
apm32_07_standby:
  push edx
  mov dx, #0x8900
  mov ax, #apm32_07_standby_str
  call apm32_out_str
  pop edx
  jmp apm32_ok
;-----------------
; APM Enable / Disable
apm32_08:
  cmp al, #0x08
  jne apm32_0a
  jmp apm32_ok
;-----------------
; Get Power Status
apm32_0a:
  cmp al, #0x0a
  jne apm32_0b
  mov bh, #0x01
  mov bl, #0xff
  mov ch, #0x80
  mov cl, #0xff
  mov dx, #0xffff
  mov si, #0
  jmp apm32_ok
;-----------------
; Get PM Event
apm32_0b:
  cmp al, #0x0b
  jne apm32_0e
  mov ah, #0x80
  jmp apm32_error
;-----------------
; APM Driver Version
apm32_0e:
  cmp al, #0x0e
  jne apm32_0f
  mov ah, #1
  mov al, #2
  jmp apm32_ok
;-----------------
; APM Engage / Disengage
apm32_0f:
  cmp al, #0x0f
  jne apm32_10
  jmp apm32_ok
;-----------------
; APM Get Capabilities
apm32_10:
  cmp al, #0x10
  jne apm32_unimplemented
  mov bl, #0
  mov cx, #0
  jmp apm32_ok
;-----------------
apm32_ok:
  popf
  clc
  retf
apm32_unimplemented:
apm32_error:
  popf
  stc
  retf
use16 386
apm16_out_str:
  push eax
  push ebx
  mov ebx, eax
apm16_out_str1:
  SEG CS
  mov al, byte ptr [bx]
  cmp al, #0
  je apm16_out_str2
  outb dx, al
  inc ebx
  jmp apm16_out_str1
apm16_out_str2:
  pop ebx
  pop eax
  ret
apm16_07_poweroff_str:
  .ascii "Shutdown"
  db 0
apm16_07_suspend_str:
  .ascii "Suspend"
  db 0
apm16_07_standby_str:
  .ascii "Standby"
  db 0
_apm16_entry:
  pushf
;-----------------
; APM interface disconnect
apm16_04:
  cmp al, #0x04
  jne apm16_05
  jmp apm16_ok
;-----------------
; APM cpu idle
apm16_05:
  cmp al, #0x05
  jne apm16_07
  sti
  hlt
  jmp apm16_ok
;-----------------
; APM Set Power State
apm16_07:
  cmp al, #0x07
  jne apm16_08
  cmp bx, #1
  jne apm16_ok
  cmp cx, #3
  je apm16_07_poweroff
  cmp cx, #2
  je apm16_07_suspend
  cmp cx, #1
  je apm16_07_standby
  jne apm16_ok
apm16_07_poweroff:
  cli
  mov dx, #0x8900
  mov ax, #apm16_07_poweroff_str
  call apm16_out_str
apm16_07_1:
  hlt
  jmp apm16_07_1
apm16_07_suspend:
  push edx
  mov dx, #0x8900
  mov ax, #apm16_07_suspend_str
  call apm16_out_str
  pop edx
  jmp apm16_ok
apm16_07_standby:
  push edx
  mov dx, #0x8900
  mov ax, #apm16_07_standby_str
  call apm16_out_str
  pop edx
  jmp apm16_ok
;-----------------
; APM Enable / Disable
apm16_08:
  cmp al, #0x08
  jne apm16_0a
  jmp apm16_ok
;-----------------
; Get Power Status
apm16_0a:
  cmp al, #0x0a
  jne apm16_0b
  mov bh, #0x01
  mov bl, #0xff
  mov ch, #0x80
  mov cl, #0xff
  mov dx, #0xffff
  mov si, #0
  jmp apm16_ok
;-----------------
; Get PM Event
apm16_0b:
  cmp al, #0x0b
  jne apm16_0e
  mov ah, #0x80
  jmp apm16_error
;-----------------
; APM Driver Version
apm16_0e:
  cmp al, #0x0e
  jne apm16_0f
  mov ah, #1
  mov al, #2
  jmp apm16_ok
;-----------------
; APM Engage / Disengage
apm16_0f:
  cmp al, #0x0f
  jne apm16_10
  jmp apm16_ok
;-----------------
; APM Get Capabilities
apm16_10:
  cmp al, #0x10
  jne apm16_unimplemented
  mov bl, #0
  mov cx, #0
  jmp apm16_ok
;-----------------
apm16_ok:
  popf
  clc
  retf
apm16_unimplemented:
apm16_error:
  popf
  stc
  retf
apmreal_out_str:
  push eax
  push ebx
  mov ebx, eax
apmreal_out_str1:
  SEG CS
  mov al, byte ptr [bx]
  cmp al, #0
  je apmreal_out_str2
  outb dx, al
  inc ebx
  jmp apmreal_out_str1
apmreal_out_str2:
  pop ebx
  pop eax
  ret
apmreal_07_poweroff_str:
  .ascii "Shutdown"
  db 0
apmreal_07_suspend_str:
  .ascii "Suspend"
  db 0
apmreal_07_standby_str:
  .ascii "Standby"
  db 0
  pushf
_apmreal_entry:
;-----------------
; APM installation check
apmreal_00:
  cmp al, #0x00
  jne apmreal_01
  mov ah, #1
  mov al, #2
  mov bh, #0x50
  mov bl, #0x4d
  mov cx, #0x3
  jmp apmreal_ok
;-----------------
; APM real mode interface connect
apmreal_01:
  cmp al, #0x01
  jne apmreal_02
  jmp apmreal_ok
;-----------------
; APM 16 bit protected mode interface connect
apmreal_02:
  cmp al, #0x02
  jne apmreal_03
  mov bx, #_apm16_entry
  mov ax, #0xf000
  mov si, #0xfff0
  mov cx, #0xf000
  mov di, #0xfff0
  jmp apmreal_ok
;-----------------
; APM 32 bit protected mode interface connect
apmreal_03:
  cmp al, #0x03
  jne apmreal_04
  mov ax, #0xf000
  mov ebx, #_apm32_entry
  mov cx, #0xf000
  mov esi, #0xfff0fff0
  mov dx, #0xf000
  mov di, #0xfff0
  jmp apmreal_ok
;-----------------
; APM interface disconnect
apmreal_04:
  cmp al, #0x04
  jne apmreal_05
  jmp apmreal_ok
;-----------------
; APM cpu idle
apmreal_05:
  cmp al, #0x05
  jne apmreal_07
  sti
  hlt
  jmp apmreal_ok
;-----------------
; APM Set Power State
apmreal_07:
  cmp al, #0x07
  jne apmreal_08
  cmp bx, #1
  jne apmreal_ok
  cmp cx, #3
  je apmreal_07_poweroff
  cmp cx, #2
  je apmreal_07_suspend
  cmp cx, #1
  je apmreal_07_standby
  jne apmreal_ok
apmreal_07_poweroff:
  cli
  mov dx, #0x8900
  mov ax, #apmreal_07_poweroff_str
  call apmreal_out_str
apmreal_07_1:
  hlt
  jmp apmreal_07_1
apmreal_07_suspend:
  push edx
  mov dx, #0x8900
  mov ax, #apmreal_07_suspend_str
  call apmreal_out_str
  pop edx
  jmp apmreal_ok
apmreal_07_standby:
  push edx
  mov dx, #0x8900
  mov ax, #apmreal_07_standby_str
  call apmreal_out_str
  pop edx
  jmp apmreal_ok
;-----------------
; APM Enable / Disable
apmreal_08:
  cmp al, #0x08
  jne apmreal_0a
  jmp apmreal_ok
;-----------------
; Get Power Status
apmreal_0a:
  cmp al, #0x0a
  jne apmreal_0b
  mov bh, #0x01
  mov bl, #0xff
  mov ch, #0x80
  mov cl, #0xff
  mov dx, #0xffff
  mov si, #0
  jmp apmreal_ok
;-----------------
; Get PM Event
apmreal_0b:
  cmp al, #0x0b
  jne apmreal_0e
  mov ah, #0x80
  jmp apmreal_error
;-----------------
; APM Driver Version
apmreal_0e:
  cmp al, #0x0e
  jne apmreal_0f
  mov ah, #1
  mov al, #2
  jmp apmreal_ok
;-----------------
; APM Engage / Disengage
apmreal_0f:
  cmp al, #0x0f
  jne apmreal_10
  jmp apmreal_ok
;-----------------
; APM Get Capabilities
apmreal_10:
  cmp al, #0x10
  jne apmreal_unimplemented
  mov bl, #0
  mov cx, #0
  jmp apmreal_ok
;-----------------
apmreal_ok:
  popf
  clc
  jmp iret_modify_cf
apmreal_unimplemented:
apmreal_error:
  popf
  stc
  jmp iret_modify_cf
;--------------------
use32 386
.align 16
bios32_structure:
  db 0x5f, 0x33, 0x32, 0x5f ;; "_32_" signature
  dw bios32_entry_point, 0xf ;; 32 bit physical address
  db 0 ;; revision level
  ;; length in paragraphs and checksum stored in a word to prevent errors
  dw (~(((bios32_entry_point >> 8) + (bios32_entry_point & 0xff) + 0x32) & 0xff) << 8) + 0x01
  db 0,0,0,0,0 ;; reserved
.align 16
bios32_entry_point:
  pushfd
  cmp eax, #0x49435024 ;; "$PCI"
  jne unknown_service
  mov eax, #0x80000000
  mov dx, #0x0cf8
  out dx, eax
  mov dx, #0x0cfc
  in eax, dx
  cmp eax, #0x12378086 ;; i440FX PCI bridge
  je pci_found
  cmp eax, #0x01228086 ;; i430FX PCI bridge
  je pci_found
  cmp eax, #0x71908086 ;; i440BX PCI bridge
  je pci_found
  ;; say ok if a device is present
  cmp eax, #0xffffffff
  je unknown_service
pci_found:
  mov ebx, #0x000f0000
  mov ecx, #0x10000
  mov edx, #pcibios_protected
  xor al, al
  jmp bios32_end
unknown_service:
  mov al, #0x80
bios32_end:
  popfd
  retf
.align 16
pcibios_protected:
  pushfd
  cli
  push esi
  push edi
  cmp al, #0x01 ;; installation check
  jne pci_pro_f02
  mov bx, #0x0210
  call pci_pro_get_max_bus ;; sets CX
  mov edx, #0x20494350 ;; "PCI "
  mov al, #0x01
  jmp pci_pro_ok
pci_pro_f02: ;; find pci device
  cmp al, #0x02
  jne pci_pro_f03
  shl ecx, #16
  mov cx, dx
  xor bx, bx
  mov di, #0x00
pci_pro_devloop:
  call pci_pro_select_reg
  mov dx, #0x0cfc
  in eax, dx
  cmp eax, ecx
  jne pci_pro_nextdev
  cmp si, #0
  je pci_pro_ok
  dec si
pci_pro_nextdev:
  inc bx
  cmp bx, #0x0200
  jne pci_pro_devloop
  mov ah, #0x86
  jmp pci_pro_fail
pci_pro_f03: ;; find class code
  cmp al, #0x03
  jne pci_pro_f08
  xor bx, bx
  mov di, #0x08
pci_pro_devloop2:
  call pci_pro_select_reg
  mov dx, #0x0cfc
  in eax, dx
  shr eax, #8
  cmp eax, ecx
  jne pci_pro_nextdev2
  cmp si, #0
  je pci_pro_ok
  dec si
pci_pro_nextdev2:
  inc bx
  cmp bx, #0x0200
  jne pci_pro_devloop2
  mov ah, #0x86
  jmp pci_pro_fail
pci_pro_f08: ;; read configuration byte
  cmp al, #0x08
  jne pci_pro_f09
  call pci_pro_select_reg
  push edx
  mov dx, di
  and dx, #0x03
  add dx, #0x0cfc
  in al, dx
  pop edx
  mov cl, al
  jmp pci_pro_ok
pci_pro_f09: ;; read configuration word
  cmp al, #0x09
  jne pci_pro_f0a
  call pci_pro_select_reg
  push edx
  mov dx, di
  and dx, #0x02
  add dx, #0x0cfc
  in ax, dx
  pop edx
  mov cx, ax
  jmp pci_pro_ok
pci_pro_f0a: ;; read configuration dword
  cmp al, #0x0a
  jne pci_pro_f0b
  call pci_pro_select_reg
  push edx
  mov dx, #0x0cfc
  in eax, dx
  pop edx
  mov ecx, eax
  jmp pci_pro_ok
pci_pro_f0b: ;; write configuration byte
  cmp al, #0x0b
  jne pci_pro_f0c
  call pci_pro_select_reg
  push edx
  mov dx, di
  and dx, #0x03
  add dx, #0x0cfc
  mov al, cl
  out dx, al
  pop edx
  jmp pci_pro_ok
pci_pro_f0c: ;; write configuration word
  cmp al, #0x0c
  jne pci_pro_f0d
  call pci_pro_select_reg
  push edx
  mov dx, di
  and dx, #0x02
  add dx, #0x0cfc
  mov ax, cx
  out dx, ax
  pop edx
  jmp pci_pro_ok
pci_pro_f0d: ;; write configuration dword
  cmp al, #0x0d
  jne pci_pro_unknown
  call pci_pro_select_reg
  push edx
  mov dx, #0x0cfc
  mov eax, ecx
  out dx, eax
  pop edx
  jmp pci_pro_ok
pci_pro_unknown:
  mov ah, #0x81
pci_pro_fail:
  pop edi
  pop esi
  popfd
  stc
  retf
pci_pro_ok:
  xor ah, ah
  pop edi
  pop esi
  popfd
  clc
  retf
pci_pro_get_max_bus:
  push eax
  mov eax, #0x80000000
  mov dx, #0x0cf8
  out dx, eax
  mov dx, #0x0cfc
  in eax, dx
  mov cx, #0
  cmp eax, #0x71908086 ;; i440BX PCI bridge
  jne pci_pro_no_i440bx
  mov cx, #0x0001
pci_pro_no_i440bx:
  pop eax
  ret
pci_pro_select_reg:
  push edx
  mov eax, #0x800000
  mov ax, bx
  shl eax, #8
  and di, #0xff
  or ax, di
  and al, #0xfc
  mov dx, #0x0cf8
  out dx, eax
  pop edx
  ret
use16 386
pcibios_real:
  push eax
  push dx
  mov eax, #0x80000000
  mov dx, #0x0cf8
  out dx, eax
  mov dx, #0x0cfc
  in eax, dx
  cmp eax, #0x12378086 ;; i440FX PCI bridge
  je pci_present
  cmp eax, #0x01228086 ;; i430FX PCI bridge
  je pci_present
  cmp eax, #0x71908086 ;; i440BX PCI bridge
  je pci_present
  ;; say ok if a device is present
  cmp eax, #0xffffffff
  jne pci_present
  pop dx
  pop eax
  mov ah, #0xff
  stc
  ret
pci_present:
  pop dx
  pop eax
  cmp al, #0x01 ;; installation check
  jne pci_real_f02
  mov ax, #0x0001
  mov bx, #0x0210
  call pci_real_get_max_bus ;; sets CX
  mov edx, #0x20494350 ;; "PCI "
  mov edi, #0xf0000
  mov di, #pcibios_protected
  clc
  ret
pci_real_f02: ;; find pci device
  push esi
  push edi
  cmp al, #0x02
  jne pci_real_f03
  shl ecx, #16
  mov cx, dx
  xor bx, bx
  mov di, #0x00
pci_real_devloop:
  call pci_real_select_reg
  mov dx, #0x0cfc
  in eax, dx
  cmp eax, ecx
  jne pci_real_nextdev
  cmp si, #0
  je pci_real_ok
  dec si
pci_real_nextdev:
  inc bx
  cmp bx, #0x0200
  jne pci_real_devloop
  mov dx, cx
  shr ecx, #16
  mov ax, #0x8602
  jmp pci_real_fail
pci_real_f03: ;; find class code
  cmp al, #0x03
  jne pci_real_f08
  xor bx, bx
  mov di, #0x08
pci_real_devloop2:
  call pci_real_select_reg
  mov dx, #0x0cfc
  in eax, dx
  shr eax, #8
  cmp eax, ecx
  jne pci_real_nextdev2
  cmp si, #0
  je pci_real_ok
  dec si
pci_real_nextdev2:
  inc bx
  cmp bx, #0x0200
  jne pci_real_devloop2
  mov dx, cx
  shr ecx, #16
  mov ax, #0x8603
  jmp pci_real_fail
pci_real_f08: ;; read configuration byte
  cmp al, #0x08
  jne pci_real_f09
  call pci_real_select_reg
  push dx
  mov dx, di
  and dx, #0x03
  add dx, #0x0cfc
  in al, dx
  pop dx
  mov cl, al
  jmp pci_real_ok
pci_real_f09: ;; read configuration word
  cmp al, #0x09
  jne pci_real_f0a
  call pci_real_select_reg
  push dx
  mov dx, di
  and dx, #0x02
  add dx, #0x0cfc
  in ax, dx
  pop dx
  mov cx, ax
  jmp pci_real_ok
pci_real_f0a: ;; read configuration dword
  cmp al, #0x0a
  jne pci_real_f0b
  call pci_real_select_reg
  push dx
  mov dx, #0x0cfc
  in eax, dx
  pop dx
  mov ecx, eax
  jmp pci_real_ok
pci_real_f0b: ;; write configuration byte
  cmp al, #0x0b
  jne pci_real_f0c
  call pci_real_select_reg
  push dx
  mov dx, di
  and dx, #0x03
  add dx, #0x0cfc
  mov al, cl
  out dx, al
  pop dx
  jmp pci_real_ok
pci_real_f0c: ;; write configuration word
  cmp al, #0x0c
  jne pci_real_f0d
  call pci_real_select_reg
  push dx
  mov dx, di
  and dx, #0x02
  add dx, #0x0cfc
  mov ax, cx
  out dx, ax
  pop dx
  jmp pci_real_ok
pci_real_f0d: ;; write configuration dword
  cmp al, #0x0d
  jne pci_real_f0e
  call pci_real_select_reg
  push dx
  mov dx, #0x0cfc
  mov eax, ecx
  out dx, eax
  pop dx
  jmp pci_real_ok
pci_real_f0e: ;; get irq routing options
  cmp al, #0x0e
  jne pci_real_unknown
  push ax
  mov ax, #pci_routing_table_structure_end - pci_routing_table_structure_start
  SEG ES
  cmp word ptr [di], ax
  jb pci_real_too_small
  stosw
  pushf
  push es
  push cx
  cld
  mov si, #pci_routing_table_structure_start
  push cs
  pop ds
  SEG ES
  les di, [di+2]
  mov cx, ax
  rep
      movsb
  pop cx
  pop es
  popf
  pop ax
  mov bx, #(1 << 9) | (1 << 11) ;; irq 9 and 11 are used
  jmp pci_real_ok
pci_real_too_small:
  stosw
  pop ax
  mov ah, #0x89
  jmp pci_real_fail
pci_real_unknown:
  mov ah, #0x81
pci_real_fail:
  pop edi
  pop esi
  stc
  ret
pci_real_ok:
  xor ah, ah
  pop edi
  pop esi
  clc
  ret
pci_real_get_max_bus:
  push eax
  mov eax, #0x80000000
  mov dx, #0x0cf8
  out dx, eax
  mov dx, #0x0cfc
  in eax, dx
  mov cx, #0
  cmp eax, #0x71908086 ;; i440BX PCI bridge
  jne pci_real_no_i440bx
  mov cx, #0x0001
pci_real_no_i440bx:
  pop eax
  ret
pci_real_select_reg:
  push dx
  mov eax, #0x800000
  mov ax, bx
  shl eax, #8
  and di, #0xff
  or ax, di
  and al, #0xfc
  mov dx, #0x0cf8
  out dx, eax
  pop dx
  ret
.align 16
pci_routing_table_structure:
  db 0x24, 0x50, 0x49, 0x52 ;; "$PIR" signature
  db 0, 1 ;; version
  dw 32 + (6 * 16) ;; table size
  db 0 ;; PCI interrupt router bus
  db 0x08 ;; PCI interrupt router DevFunc
  dw 0x0000 ;; PCI exclusive IRQs
  dw 0x8086 ;; compatible PCI interrupt router vendor ID
  dw 0x122e ;; compatible PCI interrupt router device ID
  dw 0,0 ;; Miniport data
  db 0,0,0,0,0,0,0,0,0,0,0 ;; reserved
  db 0x37 ;; checksum
pci_routing_table_structure_start:
  ;; first slot entry PCI-to-ISA (embedded)
  db 0 ;; pci bus number
  db 0x08 ;; pci device number (bit 7-3)
  db 0x60 ;; link value INTA#: pointer into PCI2ISA config space
  dw 0xdef8 ;; IRQ bitmap INTA#
  db 0x61 ;; link value INTB#
  dw 0xdef8 ;; IRQ bitmap INTB#
  db 0x62 ;; link value INTC#
  dw 0xdef8 ;; IRQ bitmap INTC#
  db 0x63 ;; link value INTD#
  dw 0xdef8 ;; IRQ bitmap INTD#
  db 0 ;; physical slot (0 = embedded)
  db 0 ;; reserved
  ;; second slot entry: 1st PCI slot
  db 0 ;; pci bus number
  db 0x10 ;; pci device number (bit 7-3)
  db 0x61 ;; link value INTA#
  dw 0xdef8 ;; IRQ bitmap INTA#
  db 0x62 ;; link value INTB#
  dw 0xdef8 ;; IRQ bitmap INTB#
  db 0x63 ;; link value INTC#
  dw 0xdef8 ;; IRQ bitmap INTC#
  db 0x60 ;; link value INTD#
  dw 0xdef8 ;; IRQ bitmap INTD#
  db 1 ;; physical slot (0 = embedded)
  db 0 ;; reserved
  ;; third slot entry: 2nd PCI slot
  db 0 ;; pci bus number
  db 0x18 ;; pci device number (bit 7-3)
  db 0x62 ;; link value INTA#
  dw 0xdef8 ;; IRQ bitmap INTA#
  db 0x63 ;; link value INTB#
  dw 0xdef8 ;; IRQ bitmap INTB#
  db 0x60 ;; link value INTC#
  dw 0xdef8 ;; IRQ bitmap INTC#
  db 0x61 ;; link value INTD#
  dw 0xdef8 ;; IRQ bitmap INTD#
  db 2 ;; physical slot (0 = embedded)
  db 0 ;; reserved
  ;; 4th slot entry: 3rd PCI slot
  db 0 ;; pci bus number
  db 0x20 ;; pci device number (bit 7-3)
  db 0x63 ;; link value INTA#
  dw 0xdef8 ;; IRQ bitmap INTA#
  db 0x60 ;; link value INTB#
  dw 0xdef8 ;; IRQ bitmap INTB#
  db 0x61 ;; link value INTC#
  dw 0xdef8 ;; IRQ bitmap INTC#
  db 0x62 ;; link value INTD#
  dw 0xdef8 ;; IRQ bitmap INTD#
  db 3 ;; physical slot (0 = embedded)
  db 0 ;; reserved
  ;; 5th slot entry: 4th PCI slot
  db 0 ;; pci bus number
  db 0x28 ;; pci device number (bit 7-3)
  db 0x60 ;; link value INTA#
  dw 0xdef8 ;; IRQ bitmap INTA#
  db 0x61 ;; link value INTB#
  dw 0xdef8 ;; IRQ bitmap INTB#
  db 0x62 ;; link value INTC#
  dw 0xdef8 ;; IRQ bitmap INTC#
  db 0x63 ;; link value INTD#
  dw 0xdef8 ;; IRQ bitmap INTD#
  db 4 ;; physical slot (0 = embedded)
  db 0 ;; reserved
  ;; 6th slot entry: 5th PCI slot
  db 0 ;; pci bus number
  db 0x30 ;; pci device number (bit 7-3)
  db 0x61 ;; link value INTA#
  dw 0xdef8 ;; IRQ bitmap INTA#
  db 0x62 ;; link value INTB#
  dw 0xdef8 ;; IRQ bitmap INTB#
  db 0x63 ;; link value INTC#
  dw 0xdef8 ;; IRQ bitmap INTC#
  db 0x60 ;; link value INTD#
  dw 0xdef8 ;; IRQ bitmap INTD#
  db 5 ;; physical slot (0 = embedded)
  db 0 ;; reserved
pci_routing_table_structure_end:
pci_irq_list:
  db 11, 10, 9, 5;
pcibios_init_sel_reg:
  push eax
  mov eax, #0x800000
  mov ax, bx
  shl eax, #8
  and dl, #0xfc
  or al, dl
  mov dx, #0x0cf8
  out dx, eax
  pop eax
  ret
pcibios_init_iomem_bases:
  push bp
  mov bp, sp
  mov eax, #0xc0000000 ;; base for memory init
  push eax
  mov ax, #0xc000 ;; base for i/o init
  push ax
  mov ax, #0x0010 ;; start at base address #0
  push ax
  mov bx, #0x0008
pci_init_io_loop1:
  mov dl, #0x00
  call pcibios_init_sel_reg
  mov dx, #0x0cfc
  in ax, dx
  cmp ax, #0xffff
  jz next_pci_dev
  mov dl, #0x04 ;; disable i/o and memory space access
  call pcibios_init_sel_reg
  mov dx, #0x0cfc
  in al, dx
  and al, #0xfc
  out dx, al
pci_init_io_loop2:
  mov dl, [bp-8]
  call pcibios_init_sel_reg
  mov dx, #0x0cfc
  in eax, dx
  test al, #0x01
  jnz init_io_base
  mov ecx, eax
  mov eax, #0xffffffff
  out dx, eax
  in eax, dx
  cmp eax, ecx
  je next_pci_base
  not eax
  mov ecx, eax
  mov eax, [bp-4]
  out dx, eax
  add eax, ecx ;; calculate next free mem base
  add eax, #0x01000000
  and eax, #0xff000000
  mov [bp-4], eax
  jmp next_pci_base
init_io_base:
  mov cx, ax
  mov ax, #0xffff
  out dx, ax
  in ax, dx
  cmp ax, cx
  je next_pci_base
  xor ax, #0xfffe
  mov cx, ax
  mov ax, [bp-6]
  out dx, ax
  add ax, cx ;; calculate next free i/o base
  add ax, #0x0100
  and ax, #0xff00
  mov [bp-6], ax
next_pci_base:
  mov al, [bp-8]
  add al, #0x04
  cmp al, #0x28
  je enable_iomem_space
  mov byte ptr[bp-8], al
  jmp pci_init_io_loop2
enable_iomem_space:
  mov dl, #0x04 ;; enable i/o and memory space access if available
  call pcibios_init_sel_reg
  mov dx, #0x0cfc
  in al, dx
  or al, #0x03
  out dx, al
next_pci_dev:
  mov byte ptr[bp-8], #0x10
  inc bx
  cmp bx, #0x0100
  jne pci_init_io_loop1
  leave
  ret
pcibios_init_set_elcr:
  push ax
  push cx
  mov dx, #0x04d0
  test al, #0x08
  jz is_master_pic
  inc dx
  and al, #0x07
is_master_pic:
  mov cl, al
  mov bl, #0x01
  shl bl, cl
  in al, dx
  or al, bl
  out dx, al
  pop cx
  pop ax
  ret
pcibios_init_irqs:
  push ds
  push bp
  push cs
  pop ds
  mov dx, #0x04d0 ;; reset ELCR1 + ELCR2
  mov al, #0x00
  out dx, al
  inc dx
  out dx, al
  mov si, #pci_routing_table_structure
  mov bh, [si+8]
  mov bl, [si+9]
  mov dl, #0x00
  call pcibios_init_sel_reg
  mov dx, #0x0cfc
  in ax, dx
  cmp ax, [si+12] ;; check irq router
  jne pci_init_end
  mov dl, [si+34]
  call pcibios_init_sel_reg
  push bx ;; save irq router bus + devfunc
  mov dx, #0x0cfc
  mov ax, #0x8080
  out dx, ax ;; reset PIRQ route control
  add dx, #2
  out dx, ax
  mov ax, [si+6]
  sub ax, #0x20
  shr ax, #4
  mov cx, ax
  add si, #0x20 ;; set pointer to 1st entry
  mov bp, sp
  push #pci_irq_list
  push #0x00
pci_init_irq_loop1:
  mov bh, [si]
  mov bl, [si+1]
pci_init_irq_loop2:
  mov dl, #0x00
  call pcibios_init_sel_reg
  mov dx, #0x0cfc
  in ax, dx
  cmp ax, #0xffff
  jnz pci_test_int_pin
  test bl, #0x07
  jz next_pir_entry
  jmp next_pci_func
pci_test_int_pin:
  mov dl, #0x3c
  call pcibios_init_sel_reg
  mov dx, #0x0cfd
  in al, dx
  and al, #0x07
  jz next_pci_func
  dec al ;; determine pirq reg
  mov dl, #0x03
  mul al, dl
  add al, #0x02
  xor ah, ah
  mov bx, ax
  mov al, [si+bx]
  mov dl, al
  mov bx, [bp]
  call pcibios_init_sel_reg
  mov dx, #0x0cfc
  and al, #0x03
  add dl, al
  in al, dx
  cmp al, #0x80
  jb pirq_found
  mov bx, [bp-2] ;; pci irq list pointer
  mov al, [bx]
  out dx, al
  inc bx
  mov [bp-2], bx
  call pcibios_init_set_elcr
pirq_found:
  mov bh, [si]
  mov bl, [si+1]
  add bl, [bp-3] ;; pci function number
  mov dl, #0x3c
  call pcibios_init_sel_reg
  mov dx, #0x0cfc
  out dx, al
next_pci_func:
  inc byte ptr[bp-3]
  inc bl
  test bl, #0x07
  jnz pci_init_irq_loop2
next_pir_entry:
  add si, #0x10
  mov byte ptr[bp-3], #0x00
  loop pci_init_irq_loop1
  mov sp, bp
  pop bx
pci_init_end:
  pop bp
  pop ds
  ret
; parallel port detection: base address in DX, index in BX, timeout in CL
detect_parport:
  push dx
  add dx, #2
  in al, dx
  and al, #0xdf ; clear input mode
  out dx, al
  pop dx
  mov al, #0xaa
  out dx, al
  in al, dx
  cmp al, #0xaa
  jne no_parport
  push bx
  shl bx, #1
  mov [bx+0x408], dx ; Parallel I/O address
  pop bx
  mov [bx+0x478], cl ; Parallel printer timeout
  inc bx
no_parport:
  ret
; serial port detection: base address in DX, index in BX, timeout in CL
detect_serial:
  push dx
  inc dx
  mov al, #0x02
  out dx, al
  in al, dx
  cmp al, #0x02
  jne no_serial
  inc dx
  in al, dx
  cmp al, #0x02
  jne no_serial
  dec dx
  xor al, al
  out dx, al
  pop dx
  push bx
  shl bx, #1
  mov [bx+0x400], dx ; Serial I/O address
  pop bx
  mov [bx+0x47c], cl ; Serial timeout
  inc bx
  ret
no_serial:
  pop dx
  ret
rom_checksum:
  pusha
  push ds
  xor ax, ax
  xor bx, bx
  xor cx, cx
  xor dx, dx
  mov ch, [2]
  shl cx, #1
  jnc checksum_loop
  jz checksum_loop
  xchg dx, cx
  dec cx
checksum_loop:
  add al, [bx]
  inc bx
  loop checksum_loop
  test dx, dx
  je checksum_out
  add al, [bx]
  mov cx, dx
  mov dx, ds
  add dh, #0x10
  mov ds, dx
  xor dx, dx
  xor bx, bx
  jmp checksum_loop
checksum_out:
  and al, #0xff
  pop ds
  popa
  ret
.align 16
pnpbios_structure:
  .ascii "$PnP"
  db 0x10 ;; version
  db 0x21 ;; length
  dw 0x0 ;; control field
  db 0xd1 ;; checksum
  dd 0xf0000 ;; event notification flag address
  dw pnpbios_real ;; real mode 16 bit offset
  dw 0xf000 ;; real mode 16 bit segment
  dw pnpbios_prot ;; 16 bit protected mode offset
  dd 0xf0000 ;; 16 bit protected mode segment base
  dd 0x0 ;; OEM device identifier
  dw 0xf000 ;; real mode 16 bit data segment
  dd 0xf0000 ;; 16 bit protected mode segment base
pnpbios_prot:
  push ebp
  mov ebp, esp
  jmp pnpbios_code
pnpbios_real:
  push ebp
  movzx ebp, sp
pnpbios_code:
  mov ax, 8[ebp]
  cmp ax, #0x60 ;; Get Version and Installation Check
  jnz pnpbios_00
  push es
  push di
  les di, 10[ebp]
  mov ax, #0x0101
  stosw
  pop di
  pop es
  xor ax, ax ;; SUCCESS
  jmp pnpbios_exit
pnpbios_00:
  cmp ax, #0x00 ;; Get Number of System Device Nodes
  jnz pnpbios_fail
  push es
  push di
  les di, 10[ebp]
  mov al, #0x00
  stosb
  les di, 14[ebp]
  mov ax, #0x0000
  stosw
  pop di
  pop es
  xor ax, ax ;; SUCCESS
  jmp pnpbios_exit
pnpbios_fail:
  mov ax, #0x82 ;; FUNCTION_NOT_SUPPORTED
pnpbios_exit:
  pop ebp
  retf
rom_scan:
  ;; Scan for existence of valid expansion ROMS.
  ;; Video ROM: from 0xC0000..0xC7FFF in 2k increments
  ;; General ROM: from 0xC8000..0xDFFFF in 2k increments
  ;; System ROM: only 0xE0000
  ;;
  ;; Header:
  ;; Offset Value
  ;; 0 0x55
  ;; 1 0xAA
  ;; 2 ROM length in 512-byte blocks
  ;; 3 ROM initialization entry point (FAR CALL)
rom_scan_loop:
  push ax ;; Save AX
  mov ds, cx
  mov ax, #0x0004 ;; start with increment of 4 (512-byte) blocks = 2k
  cmp [0], #0xAA55 ;; look for signature
  jne rom_scan_increment
  call rom_checksum
  jnz rom_scan_increment
  mov al, [2] ;; change increment to ROM length in 512-byte blocks
  ;; We want our increment in 512-byte quantities, rounded to
  ;; the nearest 2k quantity, since we only scan at 2k intervals.
  test al, #0x03
  jz block_count_rounded
  and al, #0xfc ;; needs rounding up
  add al, #0x04
block_count_rounded:
  xor bx, bx ;; Restore DS back to 0000:
  mov ds, bx
  push ax ;; Save AX
  push di ;; Save DI
  ;; Push addr of ROM entry point
  push cx ;; Push seg
  push #0x0003 ;; Push offset
  ;; Point ES:DI at "$PnP", which tells the ROM that we are a PnP BIOS.
  ;; That should stop it grabbing INT 19h; we will use its BEV instead.
  mov ax, #0xf000
  mov es, ax
  lea di, pnpbios_structure
  mov bp, sp ;; Call ROM init routine using seg:off on stack
  db 0xff ;; call_far ss:[bp+0]
  db 0x5e
  db 0
  cli ;; In case expansion ROM BIOS turns IF on
  add sp, #2 ;; Pop offset value
  pop cx ;; Pop seg value (restore CX)
  ;; Look at the ROM's PnP Expansion header.  Properly, we're supposed
  ;; to init all the ROMs and then go back and build an IPL table of
  ;; all the bootable devices, but we can get away with one pass.
  mov ds, cx ;; ROM base
  mov bx, 0x001a ;; 0x1A is the offset into ROM header that contains...
  mov ax, [bx] ;; the offset of PnP expansion header, where...
  cmp ax, #0x5024 ;; we look for signature "$PnP"
  jne no_bev
  mov ax, 2[bx]
  cmp ax, #0x506e
  jne no_bev
  mov ax, 0x16[bx] ;; 0x16 is the offset of Boot Connection Vector
  cmp ax, #0x0000
  je no_bcv
  ;; Option ROM has BCV. Run it now.
  push cx ;; Push seg
  push ax ;; Push offset
  ;; Point ES:DI at "$PnP", which tells the ROM that we are a PnP BIOS.
  mov bx, #0xf000
  mov es, bx
  lea di, pnpbios_structure
  mov bp, sp ;; Call ROM BCV routine using seg:off on stack
  db 0xff ;; call_far ss:[bp+0]
  db 0x5e
  db 0
  cli ;; In case expansion ROM BIOS turns IF on
  add sp, #2 ;; Pop offset value
  pop cx ;; Pop seg value (restore CX)
  jmp no_bev
no_bcv:
  mov ax, 0x1a[bx] ;; 0x1A is also the offset into the expansion header of...
  cmp ax, #0x0000 ;; the Bootstrap Entry Vector, or zero if there is 0 .
  je no_bev
  ;; Found a device that thinks it can boot the system. Record its BEV and product name string.
  mov di, 0x10[bx] ;; Pointer to the product name string or zero if 0
  mov bx, #0x9ff0 ;; Go to the segment where the IPL table lives
  mov ds, bx
  mov bx, 0x0080 ;; Read the number of entries so far
  cmp bx, #8
  je no_bev ;; Get out if the table is full
  shl bx, #0x4 ;; Turn count into offset (entries are 16 bytes)
  mov 0[bx], #0x80 ;; This entry is a BEV device
  mov 6[bx], cx ;; Build a far pointer from the segment...
  mov 4[bx], ax ;; and the offset
  cmp di, #0x0000
  je no_prod_str
  mov 0xA[bx], cx ;; Build a far pointer from the segment...
  mov 8[bx], di ;; and the offset
no_prod_str:
  shr bx, #0x4 ;; Turn the offset back into a count
  inc bx ;; We have one more entry now
  mov 0x0080, bx ;; Remember that.
no_bev:
  pop di ;; Restore DI
  pop ax ;; Restore AX
rom_scan_increment:
  shl ax, #5 ;; convert 512-bytes blocks to 16-byte increments
                ;; because the segment selector is shifted left 4 bits.
  add cx, ax
  pop ax ;; Restore AX
  cmp cx, ax
  jbe rom_scan_loop
  xor ax, ax ;; Restore DS back to 0000:
  mov ds, ax
  ret
post_init_pic:
  mov al, #0x11 ; send initialisation commands
  out 0x0020, al
  out 0x00a0, al
  mov al, #0x08
  out 0x0021, al
  mov al, #0x70
  out 0x00a1, al
  mov al, #0x04
  out 0x0021, al
  mov al, #0x02
  out 0x00a1, al
  mov al, #0x01
  out 0x0021, al
  out 0x00a1, al
  mov al, #0xb8
  out 0x0021, AL ;master pic: unmask IRQ 0, 1, 2, 6
  mov al, #0x8f
  out 0x00a1, AL ;slave pic: unmask IRQ 12, 13, 14
  ret
post_init_ivt:
  ;; set first 120 interrupts to default handler
  xor di, di ;; offset index
  mov cx, #0x0078 ;; counter (120 interrupts)
  mov ax, #0xF000
  shl eax, #16
  mov ax, #dummy_iret_handler
  cld
  rep
    stosd
  ;; Master PIC vector
  mov bx, #0x0020
  mov cl, #0x08
  mov ax, #dummy_master_pic_irq_handler
post_default_master_pic_ints:
  mov [bx], ax
  add bx, #4
  loop post_default_master_pic_ints
  ;; Slave PIC vector
  add bx, #0x0180
  mov cl, #0x08
  mov ax, #dummy_slave_pic_irq_handler
post_default_slave_pic_ints:
  mov [bx], ax
  add bx, #4
  loop post_default_slave_pic_ints
  ;; Printer Services vector
  SET_INT_VECTOR(0x17, #0xF000, #int17_handler)
  ;; Bootstrap failure vector
  SET_INT_VECTOR(0x18, #0xF000, #int18_handler)
  ;; Bootstrap Loader vector
  SET_INT_VECTOR(0x19, #0xF000, #int19_handler)
  ;; Memory Size Check vector
  SET_INT_VECTOR(0x12, #0xF000, #int12_handler)
  ;; Equipment Configuration Check vector
  SET_INT_VECTOR(0x11, #0xF000, #int11_handler)
  ;; System Services
  SET_INT_VECTOR(0x15, #0xF000, #int15_handler)
  ;; MDA/CGA Video Parameter Table is not available
  SET_INT_VECTOR(0x1D, #0, #0)
  ;; Character Font for upper 128 characters is not available
  SET_INT_VECTOR(0x1F, #0, #0)
  ;; set vectors 0x60 - 0x67h to zero (0:180..0:19f)
  xor ax, ax
  mov cx, #0x0010 ;; 16 words
  mov di, #0x0180
  cld
  rep
    stosw
  ;; set vector 0x78 and above to zero
  xor eax, eax
  mov cl, #0x88 ;; 136 dwords
  mov di, #0x1e0
  rep
    stosd
  ret
;; the following area can be used to write dynamically generated tables
  .align 16
bios_table_area_start:
  dd 0xaafb4442
  dd bios_table_area_end - bios_table_area_start - 8;
;--------
;- POST -
;--------
.org 0xe05b ; POST Entry Point
post:
  xor ax, ax
  ;; first reset the DMA controllers
  out 0x000d,al
  out 0x00da,al
  ;; then initialize the DMA controllers
  mov al, #0xC0
  out 0x00d6, al ; cascade mode of channel 4 enabled
  mov al, #0x00
  out 0x00d4, al ; unmask channel 4
  ;; Examine CMOS shutdown status.
  mov AL, #0x0f
  out 0x0070, AL
  in AL, 0x0071
  ;; backup status
  mov bl, al
  ;; Reset CMOS shutdown status.
  mov AL, #0x0f
  out 0x0070, AL ; select CMOS register Fh
  mov AL, #0x00
  out 0x0071, AL ; set shutdown action to normal
  ;; Examine CMOS shutdown status.
  mov al, bl
  ;; 0x00, 0x0D+ = normal startup
  cmp AL, #0x00
  jz normal_post
  cmp AL, #0x0d
  jae normal_post
  ;; 0x05 = eoi + jmp via [0x40:0x67] jump
  cmp al, #0x05
  je eoi_jmp_post
  ;; 0x0A = jmp via [0x40:0x67] jump
  cmp al, #0x0a
  je jmp_post_0x467
  ;; 0x0B = iret via [0x40:0x67]
  cmp al, #0x0b
  je iret_post_0x467
  ;; 0x0C = retf via [0x40:0x67]
  cmp al, #0x0c
  je retf_post_0x467
  ;; Examine CMOS shutdown status.
  ;; 0x01,0x02,0x03,0x04,0x06,0x07,0x08,0x09 = Unimplemented shutdown status.
  push bx
  call _shutdown_status_panic
normal_post:
  ; case 0: normal startup
  cli
  mov ax, #0xfffe
  mov sp, ax
  xor ax, ax
  mov ds, ax
  mov ss, ax
  ;; Save shutdown status
  mov 0x04b0, bl
  cmp bl, #0xfe
  jz s3_post
  ;; zero out BIOS data area (40:00..40:ff)
  mov es, ax
  mov cx, #0x0080 ;; 128 words
  mov di, #0x0400
  cld
  rep
    stosw
  call _log_bios_start
  call post_init_ivt
  ;; base memory in K 40:13 (word)
  mov ax, #(640 - 1)
  mov 0x0413, ax
  ;; Manufacturing Test 40:12
  ;; zerod out above
  ;; Warm Boot Flag 0040:0072
  ;; value of 1234h = skip memory checks
  ;; zerod out above
  ;; EBDA setup
  call ebda_post
  ;; PIT setup
  SET_INT_VECTOR(0x08, #0xF000, #int08_handler)
  ;; int 1C already points at dummy_iret_handler (above)
  mov al, #0x34 ; timer0: binary count, 16bit count, mode 2
  out 0x0043, al
  mov al, #0x00 ; maximum count of 0000H = 18.2Hz
  out 0x0040, al
  out 0x0040, al
  ;; Keyboard
  SET_INT_VECTOR(0x09, #0xF000, #int09_handler)
  SET_INT_VECTOR(0x16, #0xF000, #int16_handler)
  xor ax, ax
  mov ds, ax
  mov 0x0417, al
  mov 0x0418, al
  mov 0x0419, al
  mov 0x0471, al
  mov 0x0497, al
  mov al, #0x10
  mov 0x0496, al
  mov bx, #0x001E
  mov 0x041A, bx
  mov 0x041C, bx
  mov bx, #0x001E
  mov 0x0480, bx
  mov bx, #0x003E
  mov 0x0482, bx
  call _keyboard_init
  ;; mov CMOS Equipment Byte to BDA Equipment Word
  mov ax, 0x0410
  mov al, #0x14
  out 0x0070, al
  in al, 0x0071
  mov 0x0410, ax
  ;; Parallel setup
  xor ax, ax
  mov ds, ax
  xor bx, bx
  mov cl, #0x14 ; timeout value
  mov dx, #0x378 ; Parallel I/O address, port 1
  call detect_parport
  mov dx, #0x278 ; Parallel I/O address, port 2
  call detect_parport
  shl bx, #0x0e
  mov ax, 0x410 ; Equipment word bits 14..15 determine # parallel ports
  and ax, #0x3fff
  or ax, bx ; set number of parallel ports
  mov 0x410, ax
  ;; Serial setup
  SET_INT_VECTOR(0x14, #0xF000, #int14_handler)
  xor bx, bx
  mov cl, #0x0a ; timeout value
  mov dx, #0x03f8 ; Serial I/O address, port 1
  call detect_serial
  mov dx, #0x02f8 ; Serial I/O address, port 2
  call detect_serial
  mov dx, #0x03e8 ; Serial I/O address, port 3
  call detect_serial
  mov dx, #0x02e8 ; Serial I/O address, port 4
  call detect_serial
  shl bx, #0x09
  mov ax, 0x410 ; Equipment word bits 9..11 determine # serial ports
  and ax, #0xf1ff
  or ax, bx ; set number of serial port
  mov 0x410, ax
  ;; CMOS RTC
  SET_INT_VECTOR(0x1A, #0xF000, #int1a_handler)
  SET_INT_VECTOR(0x4A, #0xF000, #dummy_iret_handler)
  SET_INT_VECTOR(0x70, #0xF000, #int70_handler)
  ;; BIOS DATA AREA 0x4CE ???
  call timer_tick_post
  ;; IRQ9 (IRQ2 redirect) setup
  SET_INT_VECTOR(0x71, #0xF000, #int71_handler)
  ;; PS/2 mouse setup
  SET_INT_VECTOR(0x74, #0xF000, #int74_handler)
  ;; IRQ13 (FPU exception) setup
  SET_INT_VECTOR(0x75, #0xF000, #int75_handler)
  ;; Video setup
  SET_INT_VECTOR(0x10, #0xF000, #int10_handler)
  ;; PIC
  call post_init_pic
  call pcibios_init_iomem_bases
  call pcibios_init_irqs
  mov cx, #0xc000 ;; init vga bios
  mov ax, #0xc780
  call rom_scan
  ;; Hack fix: SeaVGABIOS does not setup a video mode
  mov dx, #0x03d4
  mov al, #0x00
  out dx, al
  inc dx
  in al, dx
  test al, al
  jnz vga_init_ok
  mov ax, #0x0003
  int #0x10
vga_init_ok:
  call _print_bios_banner
  ;;
  ;; Floppy setup
  ;;
  call floppy_drive_post
  ;;
  ;; Hard Drive setup
  ;;
  call hard_drive_post
  ;;
  ;; ATA/ATAPI driver setup
  ;;
  call _ata_init
  call _ata_detect
  ;;
  ;;
  ;; eltorito floppy/harddisk emulation from cd
  ;;
  call _cdemu_init
  ;;
  call _init_boot_vectors
  mov cx, #0xc800 ;; init option roms
  mov ax, #0xe000
  call rom_scan
  call _interactive_bootkey
  sti ;; enable interrupts
  int #0x19
.org 0xe2c3 ; NMI Handler Entry Point
nmi:
  ;; FIXME the NMI handler should not panic
  ;; but iret when called from int75 (fpu exception)
  call _nmi_handler_msg
  iret
int75_handler:
  out 0xf0, al
  call eoi_both_pics
  int 2
  iret
;-------------------------------------------
;- INT 13h Fixed Disk Services Entry Point -
;-------------------------------------------
.org 0xe3fe ; INT 13h Fixed Disk Services Entry Point
int13_handler:
  jmp int13_relocated
.org 0xe401 ; Fixed Disk Parameter Table
;----------
;- INT19h -
;----------
.org 0xe6f2 ; INT 19h Boot Load Service Entry Point
int19_handler:
  jmp int19_relocated
;-------------------------------------------
;- System BIOS Configuration Data Table
;-------------------------------------------
.org 0xe6f5
db 0x08 ; Table size (bytes) -Lo
db 0x00 ; Table size (bytes) -Hi
db 0xFC
db 0x00
db 1
; Feature byte 1
; b7: 1=DMA channel 3 used by hard disk
; b6: 1=2 interrupt controllers present
; b5: 1=RTC present
; b4: 1=BIOS calls int 15h/4Fh every key
; b3: 1=wait for extern event supported (Int 15h/41h)
; b2: 1=extended BIOS data area used
; b1: 0=AT or ESDI bus, 1=MicroChannel
; b0: 1=Dual bus (MicroChannel + ISA)
db (0 << 7) | (1 << 6) | (1 << 5) | (1 << 4) | (0 << 3) | (1 << 2) | (0 << 1) | (0 << 0)
; Feature byte 2
; b7: 1=32-bit DMA supported
; b6: 1=int16h, function 9 supported
; b5: 1=int15h/C6h (get POS data) supported
; b4: 1=int15h/C7h (get mem map info) supported
; b3: 1=int15h/C8h (en/dis CPU) supported
; b2: 1=non-8042 kb controller
; b1: 1=data streaming supported
; b0: reserved
db (0 << 7) | (1 << 6) | (0 << 5) | (0 << 4) | (0 << 3) | (0 << 2) | (0 << 1) | (0 << 0)
; Feature byte 3
; b7: not used
; b6: reserved
; b5: reserved
; b4: POST supports ROM-to-RAM enable/disable
; b3: SCSI on system board
; b2: info panel installed
; b1: Initial Machine Load (IML) system - BIOS on disk
; b0: SCSI supported in IML
db 0x00
; Feature byte 4
; b7: IBM private
; b6: EEPROM present
; b5-3: ABIOS presence (011 = not supported)
; b2: private
; b1: memory split above 16Mb supported
; b0: POSTEXT directly supported by POST
db 0x00
; Feature byte 5 (IBM)
; b1: enhanced mouse
; b0: flash EPROM
db 0x00
.org 0xe729 ; Baud Rate Generator Table
;----------
;- INT14h -
;----------
.org 0xe739 ; INT 14h Serial Communications Service Entry Point
int14_handler:
  push ds
  pusha
  xor ax, ax
  mov ds, ax
  call _int14_function
  popa
  pop ds
  iret
;----------------------------------------
;- INT 16h Keyboard Service Entry Point -
;----------------------------------------
.org 0xe82e
int16_handler:
  sti
  push ds
  pushf
  pusha
  push #0x40
  pop ds
  cmp ah, #0x00
  je int16_F00
  cmp ah, #0x10
  je int16_F00
  call _int16_function
  popa
  popf
  pop ds
  jz int16_zero_set
int16_zero_clear:
  push bp
  mov bp, sp
  and BYTE [bp + 0x06], #0xbf
  pop bp
  iret
int16_zero_set:
  push bp
  mov bp, sp
  or BYTE [bp + 0x06], #0x40
  pop bp
  iret
int16_F00:
  cli
  mov ax, 0x001a
  cmp ax, 0x001c
  jne int16_key_found
  sti
  ;; no key yet, call int 15h, function AX=9002
  mov ax, #0x9002
  int #0x15
int16_wait_for_key:
  cli
  mov ax, 0x001a
  cmp ax, 0x001c
  jne int16_key_found
  sti
  jmp int16_wait_for_key
int16_key_found:
  call _int16_function
  popa
  popf
  pop ds
  iret
;-------------------------------------------------
;- INT09h : Keyboard Hardware Service Entry Point -
;-------------------------------------------------
.org 0xe987
int09_handler:
  cli
  push ax
  mov al, #0xAD ;;disable keyboard
  out 0x0064, al
  mov al, #0x0B
  out 0x0020, al
  in al, 0x0020
  and al, #0x02
  jz int09_finish
  in al, 0x0060 ;;read key from keyboard controller
  sti
  push ds
  pusha
  mov ah, #0x4f ;; allow for keyboard intercept
  stc
  int #0x15
  push bp
  mov bp, sp
  mov [bp + 0x10], al
  pop bp
  jnc int09_done
  ;; check for extended key
  push #0x40
  pop ds
  cmp al, #0xe0
  jne int09_check_pause
  mov al, BYTE [0x96] ;; mf2_state |= 0x02
  or al, #0x02
  mov BYTE [0x96], al
  jmp int09_done
int09_check_pause: ;; check for pause key
  cmp al, #0xe1
  jne int09_process_key
  mov al, BYTE [0x96] ;; mf2_state |= 0x01
  or al, #0x01
  mov BYTE [0x96], al
  jmp int09_done
int09_process_key:
  call _int09_function
int09_done:
  popa
  pop ds
  cli
  call eoi_master_pic
  ;; Notify keyboard interrupt complete w/ int 15h, function AX=9102
  mov ax, #0x9102
  int #0x15
int09_finish:
  mov al, #0xAE ;;enable keyboard
  out 0x0064, al
  pop ax
  iret
; IRQ9 handler(Redirect to IRQ2)
;--------------------
int71_handler:
  push ax
  mov al, #0x20
  out 0x00a0, al ;; slave PIC EOI
  pop ax
  int #0x0A
  iret
;--------------------
dummy_master_pic_irq_handler:
  push ax
  call eoi_master_pic
  pop ax
  iret
;--------------------
dummy_slave_pic_irq_handler:
  push ax
  call eoi_both_pics
  pop ax
  iret
;----------------------------------------
;- INT 13h Diskette Service Entry Point -
;----------------------------------------
.org 0xec59
int13_diskette:
  jmp int13_noeltorito
;---------------------------------------------
;- INT 0Eh Diskette Hardware ISR Entry Point -
;---------------------------------------------
.org 0xef57 ; INT 0Eh Diskette Hardware ISR Entry Point
int0e_handler:
  push ax
  push dx
  mov dx, #0x03f4
  in al, dx
  and al, #0xc0
  cmp al, #0xc0
  je int0e_normal
  mov dx, #0x03f5
  mov al, #0x08 ; sense interrupt status
  out dx, al
int0e_loop1:
  mov dx, #0x03f4
  in al, dx
  and al, #0xc0
  cmp al, #0xc0
  jne int0e_loop1
int0e_loop2:
  mov dx, #0x03f5
  in al, dx
  mov dx, #0x03f4
  in al, dx
  and al, #0xc0
  cmp al, #0xc0
  je int0e_loop2
int0e_normal:
  push ds
  xor ax, ax ;; segment 0000
  mov ds, ax
  call eoi_master_pic
  mov al, 0x043e
  or al, #0x80 ;; diskette interrupt has occurred
  mov 0x043e, al
  pop ds
  ;; Notify diskette interrupt complete w/ int 15h, function AX=9101
  mov ax, #0x9101
  int #0x15
  pop dx
  pop ax
  iret
.org 0xefc7 ; Diskette Controller Parameter Table
diskette_param_table:
;; Since no provisions are made for multiple drive types, most
;; values in this table are ignored. I set parameters for 1.44M
;; floppy here
db 0xAF
db 0x02 ;; head load time 0000001, DMA used
db 0x25
db 0x02
db 18
db 0x1B
db 0xFF
db 0x6C
db 0xF6
db 0x0F
db 0x08
;----------------------------------------
;- INT17h : Printer Service Entry Point -
;----------------------------------------
.org 0xefd2
int17_handler:
  push ds
  pusha
  xor ax, ax
  mov ds, ax
  call _int17_function
  popa
  pop ds
  iret
diskette_param_table2:
;; New diskette parameter table adding 3 parameters from IBM
;; Since no provisions are made for multiple drive types, most
;; values in this table are ignored. I set parameters for 1.44M
;; floppy here
db 0xAF
db 0x02 ;; head load time 0000001, DMA used
db 0x25
db 0x02
db 18
db 0x1B
db 0xFF
db 0x6C
db 0xF6
db 0x0F
db 0x08
db 79 ;; maximum track
db 0 ;; data transfer rate
db 4 ;; drive type in cmos
.org 0xf045 ; INT 10 Functions 0-Fh Entry Point
  HALT(11527)
  iret
;----------
;- INT10h -
;----------
.org 0xf065 ; INT 10h Video Support Service Entry Point
int10_handler:
  ;; dont do anything, since the VGA BIOS handles int10h requests
  iret
.org 0xf0a4 ; MDA/CGA Video Parameter Table (INT 1Dh)
;----------
;- INT12h -
;----------
.org 0xf841 ; INT 12h Memory Size Service Entry Point
; ??? different for Pentium (machine check)?
int12_handler:
  push ds
  mov ax, #0x0040
  mov ds, ax
  mov ax, 0x0013
  pop ds
  iret
;----------
;- INT11h -
;----------
.org 0xf84d ; INT 11h Equipment List Service Entry Point
int11_handler:
  push ds
  mov ax, #0x0040
  mov ds, ax
  mov ax, 0x0010
  pop ds
  iret
;----------
;- INT15h -
;----------
.org 0xf859 ; INT 15h System Services Entry Point
int15_handler:
  cmp ah, #0x80 ; Device open
  je int15_stub
  cmp ah, #0x81 ; Device close
  je int15_stub
  cmp ah, #0x82 ; Program termination
  je int15_stub
  cmp ah, #0x90 ; Device busy interrupt. Called by Int 16h when no key available
  je int15_stub
  cmp ah, #0x91 ; Interrupt complete. Called by IRQ handlers
  je int15_stub
  pushf
  cmp ah, #0x53
  je apm_call
  push ds
  push es
  cmp ah, #0x86
  je int15_handler32
  cmp ah, #0xE8
  je int15_handler32
  pusha
  cmp ah, #0xC2
  je int15_handler_mouse
  call _int15_function
int15_handler_mouse_ret:
  popa
int15_handler32_ret:
  pop es
  pop ds
  popf
  jmp iret_modify_cf
apm_call:
  jmp _apmreal_entry
int15_stub:
  xor ah, ah ; "operation success"
  clc
  jmp iret_modify_cf
int15_handler_mouse:
  call _int15_function_mouse
  jmp int15_handler_mouse_ret
int15_handler32:
  pushad
  call _int15_function32
  popad
  jmp int15_handler32_ret
;; Protected mode IDT descriptor
;;
;; I just make the limit 0, so the machine will shutdown
;; if an exception occurs during protected mode memory
;; transfers.
;;
;; Set base to f0000 to correspond to beginning of BIOS,
;; in case I actually define an IDT later
;; Set limit to 0
pmode_IDT_info:
dw 0x0000 ;; limit 15:00
dw 0x0000 ;; base 15:00
db 0x0f ;; base 23:16
db 0x00 ;; base 31:24
;; Real mode IDT descriptor
;;
;; Set to typical real-mode values.
;; base = 000000
;; limit = 03ff
rmode_IDT_info:
dw 0x03ff ;; limit 15:00
dw 0x0000 ;; base 15:00
db 0x00 ;; base 23:16
db 0x00 ;; base 31:24
;----------
;- INT1Ah -
;----------
.org 0xfe6e ; INT 1Ah Time-of-day Service Entry Point
int1a_handler:
  cmp ah, #0xb1
  jne int1a_normal
  call pcibios_real
  jc pcibios_error
  retf 2
pcibios_error:
  mov bl, ah
  mov ah, #0xb1
  push ds
  pusha
  mov ax, ss ; set readable descriptor to ds, for calling pcibios
  mov ds, ax ; on 16bit protected mode.
  jmp int1a_callfunction
int1a_normal:
  push ds
  pusha
  xor ax, ax
  mov ds, ax
int1a_callfunction:
  call _int1a_function
  popa
  pop ds
  iret
;;
;; int70h: IRQ8 - CMOS RTC
;;
int70_handler:
  push ds
  pushad
  xor ax, ax
  mov ds, ax
  call _int70_function
  popad
  pop ds
  iret
;---------
;- INT08 -
;---------
.org 0xfea5 ; INT 08h System Timer ISR Entry Point
int08_handler:
  sti
  push eax
  push ds
  xor ax, ax
  mov ds, ax
  ;; time to turn off drive(s)?
  mov al,0x0440
  or al,al
  jz int08_floppy_off
  dec al
  mov 0x0440,al
  jnz int08_floppy_off
  ;; turn motor(s) off
  push dx
  mov dx,#0x03f2
  in al,dx
  and al,#0xcf
  out dx,al
  pop dx
int08_floppy_off:
  mov eax, 0x046c ;; get ticks dword
  inc eax
  ;; compare eax to one days worth of timer ticks at 18.2 hz
  cmp eax, #0x001800B0
  jb int08_store_ticks
  ;; there has been a midnight rollover at this point
  xor eax, eax ;; zero out counter
  inc BYTE 0x0470 ;; increment rollover flag
int08_store_ticks:
  mov 0x046c, eax ;; store new ticks dword
  ;; chain to user timer tick INT #0x1c
  int #0x1c
  cli
  call eoi_master_pic
  pop ds
  pop eax
  iret
.org 0xfef3 ; Initial Interrupt Vector Offsets Loaded by POST
initial_int_vector_offset_08_1f:
  dw int08_handler
  dw int09_handler
  dw dummy_master_pic_irq_handler
  dw dummy_master_pic_irq_handler
  dw dummy_master_pic_irq_handler
  dw dummy_master_pic_irq_handler
  dw int0e_handler
  dw dummy_master_pic_irq_handler
  dw int10_handler
  dw int11_handler
  dw int12_handler
  dw int13_handler
  dw int14_handler
  dw int15_handler
  dw int16_handler
  dw int17_handler
  dw int18_handler
  dw int19_handler
  dw int1a_handler
  dw dummy_iret_handler
  dw dummy_iret_handler
  dw 0
  dw diskette_param_table2
  dw 0
;------------------------------------------------
;- IRET Instruction for Dummy Interrupt Handler -
;------------------------------------------------
.org 0xff53 ; IRET Instruction for Dummy Interrupt Handler
dummy_iret_handler:
  iret
.org 0xff54 ; INT 05h Print Screen Service Entry Point
  HALT(11782)
  iret
.org 0xfff0 ; Power-up Entry Point
  jmp 0xf000:post
.org 0xfff5 ; ASCII Date ROM was built - 8 characters in MM/DD/YY
.ascii "08/01/21"
.org 0xfffe ; System Model ID
db 0xFC
db 0x00 ; filler
.org 0xfa6e ;; Character Font for 320x200 & 640x200 Graphics (lower 128 characters)
! 8534 endasm
!BCC_ENDASM
! 8535 static Bit8u vgafont8[128*8]=
! Register BX used in function int70_function
! 8536 {
.data
_vgafont8:
! 8537  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
.byte	0
.byte	0
.byte	0
.byte	0
.byte	0
.byte	0
.byte	0
.byte	0
! 8538  0x7e, 0x81, 0xa5, 0x81, 0xbd, 0x99, 0x81, 0x7e,
.byte	$7E
.byte	$81
.byte	$A5
.byte	$81
.byte	$BD
.byte	$99
.byte	$81
.byte	$7E
! 8539  0x7e, 0xff, 0xdb, 0xff, 0xc3, 0xe7, 0xff, 0x7e,
.byte	$7E
.byte	$FF
.byte	$DB
.byte	$FF
.byte	$C3
.byte	$E7
.byte	$FF
.byte	$7E
! 8540  0x6c, 0xfe, 0xfe, 0xfe, 0x7c, 0x38, 0x10, 0x00,
.byte	$6C
.byte	$FE
.byte	$FE
.byte	$FE
.byte	$7C
.byte	$38
.byte	$10
.byte	0
! 8541  0x10, 0x38, 0x7c, 0xfe, 0x7c, 0x38, 0x10, 0x00,
.byte	$10
.byte	$38
.byte	$7C
.byte	$FE
.byte	$7C
.byte	$38
.byte	$10
.byte	0
! 8542  0x38, 0x7c, 0x38, 0xfe, 0xfe, 0x7c, 0x38, 0x7c,
.byte	$38
.byte	$7C
.byte	$38
.byte	$FE
.byte	$FE
.byte	$7C
.byte	$38
.byte	$7C
! 8543  0x10, 0x10, 0x38, 0x7c, 0xfe, 0x7c, 0x38, 0x7c,
.byte	$10
.byte	$10
.byte	$38
.byte	$7C
.byte	$FE
.byte	$7C
.byte	$38
.byte	$7C
! 8544  0x00, 0x00, 0x18, 0x3c, 0x3c, 0x18, 0x00, 0x00,
.byte	0
.byte	0
.byte	$18
.byte	$3C
.byte	$3C
.byte	$18
.byte	0
.byte	0
! 8545  0xff, 0xff, 0xe7, 0xc3, 0xc3, 0xe7, 0xff, 
.byte	$FF
.byte	$FF
.byte	$E7
.byte	$C3
.byte	$C3
.byte	$E7
.byte	$FF
! 8545 0xff,
.byte	$FF
! 8546  0x00, 0x3c, 0x66, 0x42, 0x42, 0x66, 0x3c, 0x00,
.byte	0
.byte	$3C
.byte	$66
.byte	$42
.byte	$42
.byte	$66
.byte	$3C
.byte	0
! 8547  0xff, 0xc3, 0x99, 0xbd, 0xbd, 0x99, 0xc3, 0xff,
.byte	$FF
.byte	$C3
.byte	$99
.byte	$BD
.byte	$BD
.byte	$99
.byte	$C3
.byte	$FF
! 8548  0x0f, 0x07, 0x0f, 0x7d, 0xcc, 0xcc, 0xcc, 0x78,
.byte	$F
.byte	7
.byte	$F
.byte	$7D
.byte	$CC
.byte	$CC
.byte	$CC
.byte	$78
! 8549  0x3c, 0x66, 0x66, 0x66, 0x3c, 0x18, 0x7e, 0x18,
.byte	$3C
.byte	$66
.byte	$66
.byte	$66
.byte	$3C
.byte	$18
.byte	$7E
.byte	$18
! 8550  0x3f, 0x33, 0x3f, 0x30, 0x30, 0x70, 0xf0, 0xe0,
.byte	$3F
.byte	$33
.byte	$3F
.byte	$30
.byte	$30
.byte	$70
.byte	$F0
.byte	$E0
! 8551  0x7f, 0x63, 0x7f, 0x63, 0x63, 0x67, 0xe6, 0xc0,
.byte	$7F
.byte	$63
.byte	$7F
.byte	$63
.byte	$63
.byte	$67
.byte	$E6
.byte	$C0
! 8552  0x99, 0x5a, 0x3c, 0xe7, 0xe7, 0x3c, 0x5a, 0x99,
.byte	$99
.byte	$5A
.byte	$3C
.byte	$E7
.byte	$E7
.byte	$3C
.byte	$5A
.byte	$99
! 8553  0x80, 0xe0, 0xf8, 0xfe, 0xf8, 0xe0, 0x80, 0x00,
.byte	$80
.byte	$E0
.byte	$F8
.byte	$FE
.byte	$F8
.byte	$E0
.byte	$80
.byte	0
! 8554  0x02, 0x0e, 0x3e, 0xfe, 0x3e, 0x0e, 0x02, 0x00,
.byte	2
.byte	$E
.byte	$3E
.byte	$FE
.byte	$3E
.byte	$E
.byte	2
.byte	0
! 8555  0x18, 0x3c, 0x7e, 0x18, 0x18, 0x7e, 0x3c, 0x18,
.byte	$18
.byte	$3C
.byte	$7E
.byte	$18
.byte	$18
.byte	$7E
.byte	$3C
.byte	$18
! 8556  0x66, 0x66, 0x66, 0x66, 0x66, 0x00, 0x66, 0x00,
.byte	$66
.byte	$66
.byte	$66
.byte	$66
.byte	$66
.byte	0
.byte	$66
.byte	0
! 8557  0x7f, 0xdb, 0xdb, 0x7b, 0x1b, 0x1b, 0x1b, 0x00,
.byte	$7F
.byte	$DB
.byte	$DB
.byte	$7B
.byte	$1B
.byte	$1B
.byte	$1B
.byte	0
! 8558  0x3e, 0x63, 0x38, 0x6c, 0x6c, 0x38, 0xcc, 0x78,
.byte	$3E
.byte	$63
.byte	$38
.byte	$6C
.byte	$6C
.byte	$38
.byte	$CC
.byte	$78
! 8559  0x00, 0x00, 0x00, 0x00, 0x7e, 0x7e, 0x7e, 0x00,
.byte	0
.byte	0
.byte	0
.byte	0
.byte	$7E
.byte	$7E
.byte	$7E
.byte	0
! 8560  0x18, 0x3c, 0x7e, 0x18, 0x7e, 0x3c, 0x18, 0xff,
.byte	$18
.byte	$3C
.byte	$7E
.byte	$18
.byte	$7E
.byte	$3C
.byte	$18
.byte	$FF
! 8561  0x18, 0x3c, 0x7e, 0x18, 0x18, 0x18, 0x18, 0x00,
.byte	$18
.byte	$3C
.byte	$7E
.byte	$18
.byte	$18
.byte	$18
.byte	$18
.byte	0
! 8562  0x18, 0x18, 0x18, 0x18, 0x7e, 0x3c, 0x18, 0x00,
.byte	$18
.byte	$18
.byte	$18
.byte	$18
.byte	$7E
.byte	$3C
.byte	$18
.byte	0
! 8563  0x00, 0x18, 0x0c, 0xfe, 0x0c, 0x18, 0x00, 0x00,
.byte	0
.byte	$18
.byte	$C
.byte	$FE
.byte	$C
.byte	$18
.byte	0
.byte	0
! 8564  0x00, 0x30, 0x60, 0xfe, 0x60, 0x30, 0x00, 0x00,
.byte	0
.byte	$30
.byte	$60
.byte	$FE
.byte	$60
.byte	$30
.byte	0
.byte	0
! 8565  0x00, 0x00, 0xc0, 0xc0, 0xc0, 0xfe, 0x00, 0x00,
.byte	0
.byte	0
.byte	$C0
.byte	$C0
.byte	$C0
.byte	$FE
.byte	0
.byte	0
! 8566  0x00, 0x24, 0x66, 0xff, 0x66, 0x24, 0x00, 0x00,
.byte	0
.byte	$24
.byte	$66
.byte	$FF
.byte	$66
.byte	$24
.byte	0
.byte	0
! 8567  0x00, 0x18, 0x3c, 0x7e, 0xff, 0xff, 0x00, 0x00,
.byte	0
.byte	$18
.byte	$3C
.byte	$7E
.byte	$FF
.byte	$FF
.byte	0
.byte	0
! 8568  0x00, 0xff, 0xff, 0x7e, 0x3c, 0x18, 0x00, 0x00,
.byte	0
.byte	$FF
.byte	$FF
.byte	$7E
.byte	$3C
.byte	$18
.byte	0
.byte	0
! 8569  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
.byte	0
.byte	0
.byte	0
.byte	0
.byte	0
.byte	0
.byte	0
.byte	0
! 8570  0x30, 0x78, 0x78, 0x30, 0x30, 0x00, 0x30, 0x00,
.byte	$30
.byte	$78
.byte	$78
.byte	$30
.byte	$30
.byte	0
.byte	$30
.byte	0
! 8571  0x6c, 0x6c, 0x6c, 0x00, 0x00, 0x00, 0x00, 0x00,
.byte	$6C
.byte	$6C
.byte	$6C
.byte	0
.byte	0
.byte	0
.byte	0
.byte	0
! 8572  0x6c, 0x6c, 0xfe, 0x6c, 0xfe, 0x6c, 0x6c, 0x00,
.byte	$6C
.byte	$6C
.byte	$FE
.byte	$6C
.byte	$FE
.byte	$6C
.byte	$6C
.byte	0
! 8573  0x30, 0x7c, 0xc0, 0x78, 0x0c, 0xf8, 0x30, 0x00,
.byte	$30
.byte	$7C
.byte	$C0
.byte	$78
.byte	$C
.byte	$F8
.byte	$30
.byte	0
! 8574  0x00, 0xc6, 0xcc, 0x18, 0x30, 0x66, 0xc6, 0x00,
.byte	0
.byte	$C6
.byte	$CC
.byte	$18
.byte	$30
.byte	$66
.byte	$C6
.byte	0
! 8575  0x38, 0x6c, 0x38, 0x76, 0xdc, 0xcc, 0x76, 0x00,
.byte	$38
.byte	$6C
.byte	$38
.byte	$76
.byte	$DC
.byte	$CC
.byte	$76
.byte	0
! 8576  0x60, 0x60, 0xc0, 0x00, 0x00, 0x00, 0x00, 0x00,
.byte	$60
.byte	$60
.byte	$C0
.byte	0
.byte	0
.byte	0
.byte	0
.byte	0
! 8577  0x18, 0x30, 0x60, 0x60, 0x60, 0x30, 0x18, 0x00,
.byte	$18
.byte	$30
.byte	$60
.byte	$60
.byte	$60
.byte	$30
.byte	$18
.byte	0
! 8578  0x60, 0x30, 0x18, 0x18, 0x18, 0x30, 0x60, 0x00,
.byte	$60
.byte	$30
.byte	$18
.byte	$18
.byte	$18
.byte	$30
.byte	$60
.byte	0
! 8579  0x00, 0x66, 0x3c, 0xff, 0x3c, 0x66, 0x00, 0x00,
.byte	0
.byte	$66
.byte	$3C
.byte	$FF
.byte	$3C
.byte	$66
.byte	0
.byte	0
! 8580  0x00, 0x30, 0x30, 0xfc, 0x30, 0x30, 0x00, 0x00,
.byte	0
.byte	$30
.byte	$30
.byte	$FC
.byte	$30
.byte	$30
.byte	0
.byte	0
! 8581  0x00, 0x00, 0x00, 0x00, 0x00, 0x30, 0x30, 0x60,
.byte	0
.byte	0
.byte	0
.byte	0
.byte	0
.byte	$30
.byte	$30
.byte	$60
! 8582  0x00, 0x00, 0x00, 0xfc, 0x00, 0x00, 0x00, 0x00,
.byte	0
.byte	0
.byte	0
.byte	$FC
.byte	0
.byte	0
.byte	0
.byte	0
! 8583  0x00, 0x00, 0x00, 0x00, 0x00, 0x30, 0x30, 0x00,
.byte	0
.byte	0
.byte	0
.byte	0
.byte	0
.byte	$30
.byte	$30
.byte	0
! 8584  0x06, 0x0c, 0x18, 0x30, 0x60, 0xc0, 0x80, 0x00,
.byte	6
.byte	$C
.byte	$18
.byte	$30
.byte	$60
.byte	$C0
.byte	$80
.byte	0
! 8585  0x7c, 0xc6, 0xce, 0xde, 0xf6, 0xe6, 0x7c, 0x00,
.byte	$7C
.byte	$C6
.byte	$CE
.byte	$DE
.byte	$F6
.byte	$E6
.byte	$7C
.byte	0
! 8586  0x30, 0x70, 0x30, 0x30, 0x30, 0x30, 0xfc, 0x00,
.byte	$30
.byte	$70
.byte	$30
.byte	$30
.byte	$30
.byte	$30
.byte	$FC
.byte	0
! 8587  0x78, 0xcc, 0x0c, 0x38, 0x60, 0x
.byte	$78
.byte	$CC
.byte	$C
.byte	$38
.byte	$60
! 8587 cc, 0xfc, 0x00,
.byte	$CC
.byte	$FC
.byte	0
! 8588  0x78, 0xcc, 0x0c, 0x38, 0x0c, 0xcc, 0x78, 0x00,
.byte	$78
.byte	$CC
.byte	$C
.byte	$38
.byte	$C
.byte	$CC
.byte	$78
.byte	0
! 8589  0x1c, 0x3c, 0x6c, 0xcc, 0xfe, 0x0c, 0x1e, 0x00,
.byte	$1C
.byte	$3C
.byte	$6C
.byte	$CC
.byte	$FE
.byte	$C
.byte	$1E
.byte	0
! 8590  0xfc, 0xc0, 0xf8, 0x0c, 0x0c, 0xcc, 0x78, 0x00,
.byte	$FC
.byte	$C0
.byte	$F8
.byte	$C
.byte	$C
.byte	$CC
.byte	$78
.byte	0
! 8591  0x38, 0x60, 0xc0, 0xf8, 0xcc, 0xcc, 0x78, 0x00,
.byte	$38
.byte	$60
.byte	$C0
.byte	$F8
.byte	$CC
.byte	$CC
.byte	$78
.byte	0
! 8592  0xfc, 0xcc, 0x0c, 0x18, 0x30, 0x30, 0x30, 0x00,
.byte	$FC
.byte	$CC
.byte	$C
.byte	$18
.byte	$30
.byte	$30
.byte	$30
.byte	0
! 8593  0x78, 0xcc, 0xcc, 0x78, 0xcc, 0xcc, 0x78, 0x00,
.byte	$78
.byte	$CC
.byte	$CC
.byte	$78
.byte	$CC
.byte	$CC
.byte	$78
.byte	0
! 8594  0x78, 0xcc, 0xcc, 0x7c, 0x0c, 0x18, 0x70, 0x00,
.byte	$78
.byte	$CC
.byte	$CC
.byte	$7C
.byte	$C
.byte	$18
.byte	$70
.byte	0
! 8595  0x00, 0x30, 0x30, 0x00, 0x00, 0x30, 0x30, 0x00,
.byte	0
.byte	$30
.byte	$30
.byte	0
.byte	0
.byte	$30
.byte	$30
.byte	0
! 8596  0x00, 0x30, 0x30, 0x00, 0x00, 0x30, 0x30, 0x60,
.byte	0
.byte	$30
.byte	$30
.byte	0
.byte	0
.byte	$30
.byte	$30
.byte	$60
! 8597  0x18, 0x30, 0x60, 0xc0, 0x60, 0x30, 0x18, 0x00,
.byte	$18
.byte	$30
.byte	$60
.byte	$C0
.byte	$60
.byte	$30
.byte	$18
.byte	0
! 8598  0x00, 0x00, 0xfc, 0x00, 0x00, 0xfc, 0x00, 0x00,
.byte	0
.byte	0
.byte	$FC
.byte	0
.byte	0
.byte	$FC
.byte	0
.byte	0
! 8599  0x60, 0x30, 0x18, 0x0c, 0x18, 0x30, 0x60, 0x00,
.byte	$60
.byte	$30
.byte	$18
.byte	$C
.byte	$18
.byte	$30
.byte	$60
.byte	0
! 8600  0x78, 0xcc, 0x0c, 0x18, 0x30, 0x00, 0x30, 0x00,
.byte	$78
.byte	$CC
.byte	$C
.byte	$18
.byte	$30
.byte	0
.byte	$30
.byte	0
! 8601  0x7c, 0xc6, 0xde, 0xde, 0xde, 0xc0, 0x78, 0x00,
.byte	$7C
.byte	$C6
.byte	$DE
.byte	$DE
.byte	$DE
.byte	$C0
.byte	$78
.byte	0
! 8602  0x30, 0x78, 0xcc, 0xcc, 0xfc, 0xcc, 0xcc, 0x00,
.byte	$30
.byte	$78
.byte	$CC
.byte	$CC
.byte	$FC
.byte	$CC
.byte	$CC
.byte	0
! 8603  0xfc, 0x66, 0x66, 0x7c, 0x66, 0x66, 0xfc, 0x00,
.byte	$FC
.byte	$66
.byte	$66
.byte	$7C
.byte	$66
.byte	$66
.byte	$FC
.byte	0
! 8604  0x3c, 0x66, 0xc0, 0xc0, 0xc0, 0x66, 0x3c, 0x00,
.byte	$3C
.byte	$66
.byte	$C0
.byte	$C0
.byte	$C0
.byte	$66
.byte	$3C
.byte	0
! 8605  0xf8, 0x6c, 0x66, 0x66, 0x66, 0x6c, 0xf8, 0x00,
.byte	$F8
.byte	$6C
.byte	$66
.byte	$66
.byte	$66
.byte	$6C
.byte	$F8
.byte	0
! 8606  0xfe, 0x62, 0x68, 0x78, 0x68, 0x62, 0xfe, 0x00,
.byte	$FE
.byte	$62
.byte	$68
.byte	$78
.byte	$68
.byte	$62
.byte	$FE
.byte	0
! 8607  0xfe, 0x62, 0x68, 0x78, 0x68, 0x60, 0xf0, 0x00,
.byte	$FE
.byte	$62
.byte	$68
.byte	$78
.byte	$68
.byte	$60
.byte	$F0
.byte	0
! 8608  0x3c, 0x66, 0xc0, 0xc0, 0xce, 0x66, 0x3e, 0x00,
.byte	$3C
.byte	$66
.byte	$C0
.byte	$C0
.byte	$CE
.byte	$66
.byte	$3E
.byte	0
! 8609  0xcc, 0xcc, 0xcc, 0xfc, 0xcc, 0xcc, 0xcc, 0x00,
.byte	$CC
.byte	$CC
.byte	$CC
.byte	$FC
.byte	$CC
.byte	$CC
.byte	$CC
.byte	0
! 8610  0x78, 0x30, 0x30, 0x30, 0x30, 0x30, 0x78, 0x00,
.byte	$78
.byte	$30
.byte	$30
.byte	$30
.byte	$30
.byte	$30
.byte	$78
.byte	0
! 8611  0x1e, 0x0c, 0x0c, 0x0c, 0xcc, 0xcc, 0x78, 0x00,
.byte	$1E
.byte	$C
.byte	$C
.byte	$C
.byte	$CC
.byte	$CC
.byte	$78
.byte	0
! 8612  0xe6, 0x66, 0x6c, 0x78, 0x6c, 0x66, 0xe6, 0x00,
.byte	$E6
.byte	$66
.byte	$6C
.byte	$78
.byte	$6C
.byte	$66
.byte	$E6
.byte	0
! 8613  0xf0, 0x60, 0x60, 0x60, 0x62, 0x66, 0xfe, 0x00,
.byte	$F0
.byte	$60
.byte	$60
.byte	$60
.byte	$62
.byte	$66
.byte	$FE
.byte	0
! 8614  0xc6, 0xee, 0xfe, 0xfe, 0xd6, 0xc6, 0xc6, 0x00,
.byte	$C6
.byte	$EE
.byte	$FE
.byte	$FE
.byte	$D6
.byte	$C6
.byte	$C6
.byte	0
! 8615  0xc6, 0xe6, 0xf6, 0xde, 0xce, 0xc6, 0xc6, 0x00,
.byte	$C6
.byte	$E6
.byte	$F6
.byte	$DE
.byte	$CE
.byte	$C6
.byte	$C6
.byte	0
! 8616  0x38, 0x6c, 0xc6, 0xc6, 0xc6, 0x6c, 0x38, 0x00,
.byte	$38
.byte	$6C
.byte	$C6
.byte	$C6
.byte	$C6
.byte	$6C
.byte	$38
.byte	0
! 8617  0xfc, 0x66, 0x66, 0x7c, 0x60, 0x60, 0xf0, 0x00,
.byte	$FC
.byte	$66
.byte	$66
.byte	$7C
.byte	$60
.byte	$60
.byte	$F0
.byte	0
! 8618  0x78, 0xcc, 0xcc, 0xcc, 0xdc, 0x78, 0x1c, 0x00,
.byte	$78
.byte	$CC
.byte	$CC
.byte	$CC
.byte	$DC
.byte	$78
.byte	$1C
.byte	0
! 8619  0xfc, 0x66, 0x66, 0x7c, 0x6c, 0x66, 0xe6, 0x00,
.byte	$FC
.byte	$66
.byte	$66
.byte	$7C
.byte	$6C
.byte	$66
.byte	$E6
.byte	0
! 8620  0x78, 0xcc, 0xe0, 0x70, 0x1c, 0xcc, 0x78, 0x00,
.byte	$78
.byte	$CC
.byte	$E0
.byte	$70
.byte	$1C
.byte	$CC
.byte	$78
.byte	0
! 8621  0xfc, 0xb4, 0x30, 0x30, 0x30, 0x30, 0x78, 0x00,
.byte	$FC
.byte	$B4
.byte	$30
.byte	$30
.byte	$30
.byte	$30
.byte	$78
.byte	0
! 8622  0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xfc, 0x00,
.byte	$CC
.byte	$CC
.byte	$CC
.byte	$CC
.byte	$CC
.byte	$CC
.byte	$FC
.byte	0
! 8623  0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0x78, 0x30, 0x00,
.byte	$CC
.byte	$CC
.byte	$CC
.byte	$CC
.byte	$CC
.byte	$78
.byte	$30
.byte	0
! 8624  0xc6, 0xc6, 0xc6, 0xd6, 0xfe, 0xee, 0xc6, 0x00,
.byte	$C6
.byte	$C6
.byte	$C6
.byte	$D6
.byte	$FE
.byte	$EE
.byte	$C6
.byte	0
! 8625  0xc6, 0xc6, 0x6c, 0x38, 0x38, 0x6c, 0xc6, 0x00,
.byte	$C6
.byte	$C6
.byte	$6C
.byte	$38
.byte	$38
.byte	$6C
.byte	$C6
.byte	0
! 8626  0xcc, 0xcc, 0xcc, 0x78, 0x30, 0x30, 0x78, 0x00,
.byte	$CC
.byte	$CC
.byte	$CC
.byte	$78
.byte	$30
.byte	$30
.byte	$78
.byte	0
! 8627  0xfe, 0xc6, 0x8c, 0x18, 0x32, 0x66, 0xfe, 0x00,
.byte	$FE
.byte	$C6
.byte	$8C
.byte	$18
.byte	$32
.byte	$66
.byte	$FE
.byte	0
! 8628  0x78, 0x60, 0x60, 0x60, 0x60, 0x60, 0x78, 0x00,
.byte	$78
.byte	$60
.byte	$60
.byte	$60
.byte	$60
.byte	$60
.byte	$78
.byte	0
! 8629  0xc0, 0x60, 0x30, 0x18
.byte	$C0
.byte	$60
.byte	$30
! 8629 , 0x0c, 0x06, 0x02, 0x00,
.byte	$18
.byte	$C
.byte	6
.byte	2
.byte	0
! 8630  0x78, 0x18, 0x18, 0x18, 0x18, 0x18, 0x78, 0x00,
.byte	$78
.byte	$18
.byte	$18
.byte	$18
.byte	$18
.byte	$18
.byte	$78
.byte	0
! 8631  0x10, 0x38, 0x6c, 0xc6, 0x00, 0x00, 0x00, 0x00,
.byte	$10
.byte	$38
.byte	$6C
.byte	$C6
.byte	0
.byte	0
.byte	0
.byte	0
! 8632  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff,
.byte	0
.byte	0
.byte	0
.byte	0
.byte	0
.byte	0
.byte	0
.byte	$FF
! 8633  0x30, 0x30, 0x18, 0x00, 0x00, 0x00, 0x00, 0x00,
.byte	$30
.byte	$30
.byte	$18
.byte	0
.byte	0
.byte	0
.byte	0
.byte	0
! 8634  0x00, 0x00, 0x78, 0x0c, 0x7c, 0xcc, 0x76, 0x00,
.byte	0
.byte	0
.byte	$78
.byte	$C
.byte	$7C
.byte	$CC
.byte	$76
.byte	0
! 8635  0xe0, 0x60, 0x60, 0x7c, 0x66, 0x66, 0xdc, 0x00,
.byte	$E0
.byte	$60
.byte	$60
.byte	$7C
.byte	$66
.byte	$66
.byte	$DC
.byte	0
! 8636  0x00, 0x00, 0x78, 0xcc, 0xc0, 0xcc, 0x78, 0x00,
.byte	0
.byte	0
.byte	$78
.byte	$CC
.byte	$C0
.byte	$CC
.byte	$78
.byte	0
! 8637  0x1c, 0x0c, 0x0c, 0x7c, 0xcc, 0xcc, 0x76, 0x00,
.byte	$1C
.byte	$C
.byte	$C
.byte	$7C
.byte	$CC
.byte	$CC
.byte	$76
.byte	0
! 8638  0x00, 0x00, 0x78, 0xcc, 0xfc, 0xc0, 0x78, 0x00,
.byte	0
.byte	0
.byte	$78
.byte	$CC
.byte	$FC
.byte	$C0
.byte	$78
.byte	0
! 8639  0x38, 0x6c, 0x60, 0xf0, 0x60, 0x60, 0xf0, 0x00,
.byte	$38
.byte	$6C
.byte	$60
.byte	$F0
.byte	$60
.byte	$60
.byte	$F0
.byte	0
! 8640  0x00, 0x00, 0x76, 0xcc, 0xcc, 0x7c, 0x0c, 0xf8,
.byte	0
.byte	0
.byte	$76
.byte	$CC
.byte	$CC
.byte	$7C
.byte	$C
.byte	$F8
! 8641  0xe0, 0x60, 0x6c, 0x76, 0x66, 0x66, 0xe6, 0x00,
.byte	$E0
.byte	$60
.byte	$6C
.byte	$76
.byte	$66
.byte	$66
.byte	$E6
.byte	0
! 8642  0x30, 0x00, 0x70, 0x30, 0x30, 0x30, 0x78, 0x00,
.byte	$30
.byte	0
.byte	$70
.byte	$30
.byte	$30
.byte	$30
.byte	$78
.byte	0
! 8643  0x0c, 0x00, 0x0c, 0x0c, 0x0c, 0xcc, 0xcc, 0x78,
.byte	$C
.byte	0
.byte	$C
.byte	$C
.byte	$C
.byte	$CC
.byte	$CC
.byte	$78
! 8644  0xe0, 0x60, 0x66, 0x6c, 0x78, 0x6c, 0xe6, 0x00,
.byte	$E0
.byte	$60
.byte	$66
.byte	$6C
.byte	$78
.byte	$6C
.byte	$E6
.byte	0
! 8645  0x70, 0x30, 0x30, 0x30, 0x30, 0x30, 0x78, 0x00,
.byte	$70
.byte	$30
.byte	$30
.byte	$30
.byte	$30
.byte	$30
.byte	$78
.byte	0
! 8646  0x00, 0x00, 0xcc, 0xfe, 0xfe, 0xd6, 0xc6, 0x00,
.byte	0
.byte	0
.byte	$CC
.byte	$FE
.byte	$FE
.byte	$D6
.byte	$C6
.byte	0
! 8647  0x00, 0x00, 0xf8, 0xcc, 0xcc, 0xcc, 0xcc, 0x00,
.byte	0
.byte	0
.byte	$F8
.byte	$CC
.byte	$CC
.byte	$CC
.byte	$CC
.byte	0
! 8648  0x00, 0x00, 0x78, 0xcc, 0xcc, 0xcc, 0x78, 0x00,
.byte	0
.byte	0
.byte	$78
.byte	$CC
.byte	$CC
.byte	$CC
.byte	$78
.byte	0
! 8649  0x00, 0x00, 0xdc, 0x66, 0x66, 0x7c, 0x60, 0xf0,
.byte	0
.byte	0
.byte	$DC
.byte	$66
.byte	$66
.byte	$7C
.byte	$60
.byte	$F0
! 8650  0x00, 0x00, 0x76, 0xcc, 0xcc, 0x7c, 0x0c, 0x1e,
.byte	0
.byte	0
.byte	$76
.byte	$CC
.byte	$CC
.byte	$7C
.byte	$C
.byte	$1E
! 8651  0x00, 0x00, 0xdc, 0x76, 0x66, 0x60, 0xf0, 0x00,
.byte	0
.byte	0
.byte	$DC
.byte	$76
.byte	$66
.byte	$60
.byte	$F0
.byte	0
! 8652  0x00, 0x00, 0x7c, 0xc0, 0x78, 0x0c, 0xf8, 0x00,
.byte	0
.byte	0
.byte	$7C
.byte	$C0
.byte	$78
.byte	$C
.byte	$F8
.byte	0
! 8653  0x10, 0x30, 0x7c, 0x30, 0x30, 0x34, 0x18, 0x00,
.byte	$10
.byte	$30
.byte	$7C
.byte	$30
.byte	$30
.byte	$34
.byte	$18
.byte	0
! 8654  0x00, 0x00, 0xcc, 0xcc, 0xcc, 0xcc, 0x76, 0x00,
.byte	0
.byte	0
.byte	$CC
.byte	$CC
.byte	$CC
.byte	$CC
.byte	$76
.byte	0
! 8655  0x00, 0x00, 0xcc, 0xcc, 0xcc, 0x78, 0x30, 0x00,
.byte	0
.byte	0
.byte	$CC
.byte	$CC
.byte	$CC
.byte	$78
.byte	$30
.byte	0
! 8656  0x00, 0x00, 0xc6, 0xd6, 0xfe, 0xfe, 0x6c, 0x00,
.byte	0
.byte	0
.byte	$C6
.byte	$D6
.byte	$FE
.byte	$FE
.byte	$6C
.byte	0
! 8657  0x00, 0x00, 0xc6, 0x6c, 0x38, 0x6c, 0xc6, 0x00,
.byte	0
.byte	0
.byte	$C6
.byte	$6C
.byte	$38
.byte	$6C
.byte	$C6
.byte	0
! 8658  0x00, 0x00, 0xcc, 0xcc, 0xcc, 0x7c, 0x0c, 0xf8,
.byte	0
.byte	0
.byte	$CC
.byte	$CC
.byte	$CC
.byte	$7C
.byte	$C
.byte	$F8
! 8659  0x00, 0x00, 0xfc, 0x98, 0x30, 0x64, 0xfc, 0x00,
.byte	0
.byte	0
.byte	$FC
.byte	$98
.byte	$30
.byte	$64
.byte	$FC
.byte	0
! 8660  0x1c, 0x30, 0x30, 0xe0, 0x30, 0x30, 0x1c, 0x00,
.byte	$1C
.byte	$30
.byte	$30
.byte	$E0
.byte	$30
.byte	$30
.byte	$1C
.byte	0
! 8661  0x18, 0x18, 0x18, 0x00, 0x18, 0x18, 0x18, 0x00,
.byte	$18
.byte	$18
.byte	$18
.byte	0
.byte	$18
.byte	$18
.byte	$18
.byte	0
! 8662  0xe0, 0x30, 0x30, 0x1c, 0x30, 0x30, 0xe0, 0x00,
.byte	$E0
.byte	$30
.byte	$30
.byte	$1C
.byte	$30
.byte	$30
.byte	$E0
.byte	0
! 8663  0x76, 0xdc, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
.byte	$76
.byte	$DC
.byte	0
.byte	0
.byte	0
.byte	0
.byte	0
.byte	0
! 8664  0x00, 0x10, 0x38, 0x6c, 0xc6, 0xc6, 0xfe, 0x00,
.byte	0
.byte	$10
.byte	$38
.byte	$6C
.byte	$C6
.byte	$C6
.byte	$FE
.byte	0
! 8665 };
!BCC_EOS
! 8666 #asm
!BCC_ASM
.org 0xcc00
bios_table_area_end:
.ascii "(c) 2001-2021  The Bochs Project"
! 8670 endasm
!BCC_ENDASM
! 8671 
.7C8:
.7D7:
.ascii	"no PCI device with class code 0x%02x%04x"
.ascii	" found at index %d"
.byte	$A
.byte	0
.7C6:
.7D8:
.ascii	"PCI device %04x:%04x not found at index "
.ascii	"%d"
.byte	$A
.byte	0
.7C0:
.7D9:
.ascii	"bad PCI vendor ID %04x"
.byte	$A
.byte	0
.7BC:
.7DA:
.ascii	"unsupported PCI BIOS function 0x%02x"
.byte	$A
.byte	0
.7B8:
.7DB:
.ascii	"PCI BIOS: PCI not present"
.byte	$A
.byte	0
.79D:
.7DC:
.ascii	"Booting from %x:%x"
.byte	$A
.byte	0
.788:
.7DD:
.ascii	"Invalid boot device (0x%x)"
.byte	$A
.byte	0
.785:
.7DE:
.ascii	"No bootable device."
.byte	$A
.byte	0
.76F:
.7DF:
.ascii	"set_diskette_current_cyl(): drive > 1"
.byte	$A
.byte	0
.76A:
.7E0:
.ascii	"int13_diskette: unsupported AH=%02x"
.byte	$A
.byte	0
.706:
.7E1:
.ascii	"floppy: int13: bad floppy type"
.byte	$A
.byte	0
.6EE:
.7E2:
.ascii	"int13_diskette_function: write error"
.byte	$A
.byte	0
.6E8:
.7E3:
.ascii	"int13_diskette: ctrl not ready"
.byte	$A
.byte	0
.6CE:
.7E4:
.ascii	"int13_diskette_function: write error"
.byte	$A
.byte	0
.6C5:
.7E5:
.ascii	"int13_diskette: ctrl not ready"
.byte	$A
.byte	0
.6AD:
.7E6:
.ascii	"int13_diskette: read/write/verify: param"
.ascii	"eter out of range"
.byte	$A
.byte	0
.655:
.7E7:
.ascii	"int13_cdemu function AH=%02x unsupported"
.ascii	", returns fail"
.byte	$A
.byte	0
.63D:
.7E8:
.ascii	"int13_cdemu: function %02x, error %02x !"
.byte	$A
.byte	0
.61F:
.7E9:
.ascii	"int13_cdemu: function %02x, emulation no"
.ascii	"t active for DL= %02x"
.byte	$A
.byte	0
.61B:
.7EA:
.ascii	"int13_eltorito: unsupported AH=%02x"
.byte	$A
.byte	0
.616:
.7EB:
.ascii	"Int13 eltorito call with AX=%04x. Please"
.ascii	" report"
.byte	$A
.byte	0
.60B:
.7EC:
.ascii	"int13_cdrom: unsupported AH=%02x"
.byte	$A
.byte	0
.5DD:
.7ED:
.ascii	"int13_cdrom: function %02x, status %02x "
.ascii	"!"
.byte	$A
.byte	0
.5D7:
.7EE:
.ascii	"int13_cdrom: function %02x. Can't use 64"
.ascii	"bits lba"
.byte	$A
.byte	0
.5BD:
.7EF:
.ascii	"int13_cdrom: function %02x, unmapped dev"
.ascii	"ice for ELDL=%02x"
.byte	$A
.byte	0
.5BA:
.7F0:
.ascii	"int13_cdrom: function %02x, ELDL out of "
.ascii	"range %02x"
.byte	$A
.byte	0
.5B2:
.7F1:
.ascii	"int13_harddisk: function %02xh unsupport"
.ascii	"ed, returns fail"
.byte	$A
.byte	0
.5AC:
.7F2:
.ascii	"int13_harddisk: function %02xh unimpleme"
.ascii	"nted, returns success"
.byte	$A
.byte	0
.597:
.7F3:
.ascii	"int13_harddisk: function %02x, error %02"
.ascii	"x !"
.byte	$A
.byte	0
.58E:
.7F4:
.ascii	"int13_harddisk: function %02x. LBA out o"
.ascii	"f range"
.byte	$A
.byte	0
.58A:
.7F5:
.ascii	"int13_harddisk: function %02x. LBA out o"
.ascii	"f range"
.byte	$A
.byte	0
.57C:
.7F6:
.ascii	"format disk track called"
.byte	$A
.byte	0
.57A:
.7F7:
.ascii	"int13_harddisk: function %02x, error %02"
.ascii	"x !"
.byte	$A
.byte	0
.56F:
.7F8:
.ascii	"int13_harddisk: function %02x, parameter"
.ascii	"s out of range %04x/%04x/%04x!"
.byte	$A
.byte	0
.56A:
.7F9:
.ascii	"int13_harddisk: function %02x, parameter"
.ascii	" out of range!"
.byte	$A
.byte	0
.55A:
.7FA:
.ascii	"int13_harddisk: function %02x, unmapped "
.ascii	"device for ELDL=%02x"
.byte	$A
.byte	0
.557:
.7FB:
.ascii	"int13_harddisk: function %02x, ELDL out "
.ascii	"of range %02x"
.byte	$A
.byte	0
.4F9:
.7FC:
.ascii	"KBD: int09h_handler(): scancode & asciic"
.ascii	"ode are zero?"
.byte	$A
.byte	0
.4DD:
.7FD:
.ascii	"KBD: int09h_handler(): unknown scancode "
.ascii	"read: 0x%02x!"
.byte	$A
.byte	0
.4A8:
.7FE:
.ascii	"KBD: int09 handler: AL=0"
.byte	$A
.byte	0
.4A5:
.7FF:
.ascii	"setkbdcomm"
.byte	0
.49E:
.800:
.ascii	"sendmouse"
.byte	0
.49B:
.801:
.ascii	"enabmouse"
.byte	0
.494:
.802:
.ascii	"enabmouse"
.byte	0
.491:
.803:
.ascii	"inhibmouse"
.byte	0
.48A:
.804:
.ascii	"inhibmouse"
.byte	0
.47D:
.805:
.ascii	"KBD: unsupported int 16h function %02x"
.byte	$A
.byte	0
.46C:
.806:
.ascii	"KBD: int16h: out of keyboard input"
.byte	$A
.byte	0
.43E:
.807:
.ascii	"KBD: int16h: out of keyboard input"
.byte	$A
.byte	0
.42B:
.808:
.ascii	"*** int 15h function AX=%04x, BX=%04x no"
.ascii	"t yet supported!"
.byte	$A
.byte	0
.400:
.809:
.ascii	"*** int 15h function AX=%04x, BX=%04x no"
.ascii	"t yet supported!"
.byte	$A
.byte	0
.3F4:
.80A:
.ascii	"INT 15h C2 AL=6, BH=%02x"
.byte	$A
.byte	0
.3DE:
.80B:
.ascii	"Mouse status returned %02x (should be ac"
.ascii	"k)"
.byte	$A
.byte	0
.3CE:
.80C:
.ascii	"Mouse status returned %02x (should be ac"
.ascii	"k)"
.byte	$A
.byte	0
.3CB:
.80D:
.ascii	"Mouse status returned %02x (should be ac"
.ascii	"k)"
.byte	$A
.byte	0
.3A9:
.80E:
.ascii	"Mouse reset returned %02x (should be ack"
.ascii	")"
.byte	$A
.byte	0
.381:
.80F:
.ascii	"*** int 15h function AX=%04x, BX=%04x no"
.ascii	"t yet supported!"
.byte	$A
.byte	0
.37F:
.810:
.ascii	"EISA BIOS not present"
.byte	$A
.byte	0
.37B:
.811:
.ascii	"*** int 15h function AH=bf not yet suppo"
.ascii	"rted!"
.byte	$A
.byte	0
.365:
.812:
.ascii	"int15: Func 24h, subfunc %02xh, A20 gate"
.ascii	" control not supported"
.byte	$A
.byte	0
.2FF:
.813:
.ascii	"ata_is_ready returned %d"
.byte	$A
.byte	0
.2E9:
.814:
.ascii	"%dMB medium detected"
.byte	$A
.byte	0
.2E4:
.815:
.ascii	"Unsupported sector size %u"
.byte	$A
.byte	0
.2DF:
.816:
.ascii	"Waiting for device to detect medium... "
.byte	0
.2D1:
.817:
.ascii	"not implemented for non-ATAPI device"
.byte	$A
.byte	0
.297:
.818:
.ascii	"ata_cmd_packet: DATA_OUT not supported y"
.ascii	"et"
.byte	$A
.byte	0
.255:
.819:
.byte	$A
.byte	0
.250:
.81A:
.ascii	"master"
.byte	0
.24F:
.81B:
.ascii	" slave"
.byte	0
.24E:
.81C:
.ascii	"ata%d %s: Unknown device"
.byte	$A
.byte	0
.24C:
.81D:
.ascii	" ATAPI-%d Device"
.byte	$A
.byte	0
.24A:
.81E:
.ascii	" ATAPI-%d CD-Rom/DVD-Rom"
.byte	$A
.byte	0
.246:
.81F:
.ascii	"%c"
.byte	0
.23F:
.820:
.ascii	"master"
.byte	0
.23E:
.821:
.ascii	" slave"
.byte	0
.23D:
.822:
.ascii	"ata%d %s: "
.byte	0
.23B:
.823:
.ascii	" ATA-%d Hard-Disk (%4u GBytes)"
.byte	$A
.byte	0
.239:
.824:
.ascii	" ATA-%d Hard-Disk (%4u MBytes)"
.byte	$A
.byte	0
.235:
.825:
.ascii	"%c"
.byte	0
.22E:
.826:
.ascii	"master"
.byte	0
.22D:
.827:
.ascii	" slave"
.byte	0
.22C:
.828:
.ascii	"ata%d %s: "
.byte	0
.1FB:
.829:
.ascii	"ata-detect: Failed to detect ATAPI devic"
.ascii	"e"
.byte	$A
.byte	0
.1F6:
.82A:
.ascii	" LCHS=%d/%d/%d"
.byte	$A
.byte	0
.1D6:
.82B:
.ascii	"r-echs"
.byte	0
.1D4:
.82C:
.ascii	"large"
.byte	0
.1D2:
.82D:
.ascii	"lba"
.byte	0
.1D0:
.82E:
.ascii	"none"
.byte	0
.1C6:
.82F:
.ascii	"ata%d-%d: PCHS=%u/%d/%d translation="
.byte	0
.1BF:
.830:
.ascii	"ata-detect: Failed to detect ATA device"
.byte	$A
.byte	0
.19E:
.831:
.ascii	"IDE time out"
.byte	$A
.byte	0
.162:
.832:
.ascii	"S3 resume jump to %x:%x"
.byte	$A
.byte	0
.15E:
.833:
.ascii	"S3 resume called %x 0x%lx"
.byte	$A
.byte	0
.158:
.834:
.ascii	"%s"
.byte	$A
.byte	0
.157:
.835:
.ascii	"INT18: BOOT FAILURE"
.byte	$A
.byte	0
.156:
.836:
.ascii	"NMI Handler called"
.byte	$A
.byte	0
.155:
.837:
.ascii	"CDROM boot failure code : %04x"
.byte	$A
.byte	0
.154:
.838:
.byte	$A,$A
.byte	0
.153:
.839:
.ascii	": could not read the boot disk"
.byte	0
.151:
.83A:
.ascii	": not a bootable disk"
.byte	0
.14C:
.83B:
.ascii	"Boot failed"
.byte	0
.14B:
.83C:
.ascii	"Bad drive type"
.byte	$A
.byte	0
.147:
.83D:
.ascii	"..."
.byte	$A
.byte	0
.146:
.83E:
.ascii	" [%S]"
.byte	0
.142:
.83F:
.ascii	"Booting from %s"
.byte	0
.141:
.840:
.ascii	"Bad drive type"
.byte	$A
.byte	0
.13B:
.841:
.byte	$A
.byte	0
.12F:
.842:
.byte	$A
.byte	0
.12E:
.843:
.ascii	" [%S]"
.byte	0
.12B:
.844:
.ascii	"%s"
.byte	0
.129:
.845:
.ascii	"%s"
.byte	$A
.byte	0
.122:
.846:
.ascii	"%d. "
.byte	0
.11D:
.847:
.ascii	"Select boot device:"
.byte	$A,$A
.byte	0
.114:
.848:
.ascii	"Press F12 for boot menu."
.byte	$A,$A
.byte	0
.106:
.849:
.ascii	"apmbios pcibios pnpbios eltorito "
.byte	$A,$A
.byte	0
.105:
.84A:
.ascii	"08/01/21"
.byte	0
.104:
.84B:
.ascii	"Bochs 2.7 BIOS - build: %s"
.byte	$A
.ascii	"%s"
.byte	$A
.ascii	"Options: "
.byte	0
.103:
.84C:
.ascii	"Returned from s3_resume."
.byte	$A
.byte	0
.102:
.84D:
.ascii	"Unimplemented shutdown status: %02x"
.byte	$A
.byte	0
.101:
.84E:
.ascii	"Keyboard error:%u"
.byte	$A
.byte	0
.7C:
.84F:
.ascii	"bios_printf: unknown format"
.byte	$A
.byte	0
.38:
.850:
.ascii	"FATAL: "
.byte	0
.bss

! 0 errors detected
