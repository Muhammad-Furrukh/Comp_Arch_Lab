OUTPUT_ARCH( "riscv" )
ENTRY( reset_handler )

MEMORY
{ 
  FLASH (rx)  : ORIGIN = 0x00000000, LENGTH = 1K
  RAM   (rwx) : ORIGIN = 0x80000000, LENGTH = 256
}


SECTIONS
{
  __stack_size = DEFINED(__stack_size) ? __stack_size : 200;

  .vector_table :
  {
    KEEP (*(SORT_NONE(.vector_table)))
  } >FLASH

  .text :
  {
    *(.rodata .rodata.*)  
    *(.srodata .srodata.*)
    *(.text .text.*)
  } >FLASH

  . = ALIGN(4);

  _sidata = .;
  .data : AT( _sidata )
  {
    *(.rdata) 
    *(.data .data.*)
    *(.sdata .sdata.*)
    . = ALIGN(4);
  } >RAM

  PROVIDE( _edata = . );
  PROVIDE( edata = . );
  PROVIDE( _fbss = . );
  PROVIDE( __bss_start = . );

  .bss :
  {
    *(.sbss*)
    *(.bss .bss.*)
    *(COMMON)
    . = ALIGN(4);
  } >RAM

  . = ALIGN(8);
  

  .stack ORIGIN(RAM) + LENGTH(RAM) - __stack_size :
  {
    PROVIDE( _heap_end = . ); 
    . = __stack_size;  
    PROVIDE( _sp = . ); 
  } >RAM
}