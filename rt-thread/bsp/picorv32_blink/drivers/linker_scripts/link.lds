/*
This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.
*/

/* starting address needs to be > 0 due to known bug in RISCV/GNU linker */
MEMORY
{
  rom(rx)  : ORIGIN = 0x00000000, LENGTH = 32k
  ram(rwx) : ORIGIN = 0x40000000, LENGTH = 16k
}

ENTRY(_pvstart);

SECTIONS
{
  .init 0x0:
  {
    . = ALIGN(4);
    *(.text.entry);
  } > rom

  .interrupt 0x400:
  {
    . = ALIGN(4);
    KEEP(*(.text.interrupt));
  } > rom

  .data :
  {
    _data_lma = LOADADDR(.data);
    _data = .;
    __global_pointer$ = . ;
    *(.data .data.* )
    *(.sdata .sdata.*)
    *(COMMON)
      . = ALIGN(4);
    _edata = .;
  } >ram AT > rom

  .bss :
  {
    _bss_start = .;
    *(.bss .bss.*)
    *(.sbss .sbss.*)
      . = ALIGN(4);
    _bss_end = .;
    _end = .;
  } > ram

  .rom :
  {
    . = ALIGN(4);
    *(.text);

    /* section information for finsh shell */
    . = ALIGN(4);
    __fsymtab_start = .;
    KEEP(*(FSymTab))
    __fsymtab_end = .;
    . = ALIGN(4);
    __vsymtab_start = .;
    KEEP(*(VSymTab))
    __vsymtab_end = .;
    . = ALIGN(4);
    *(.stub .text.* .gnu.linkonce.t.*);
    *(.rodata  .rodata.*);
    *(.*);
  } > rom

  .stack ORIGIN(ram) + LENGTH(ram) :
  {
    _riscv_sp = . ;
  } > ram
}


