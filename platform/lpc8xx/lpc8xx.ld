/* Copyright 2019 Kis Imre */

ENTRY(Reset_Handler)

/* Stack is placed in the 64KB CCM memory */
/* NB. CCM memory cannot be accessed by peripherals or DMA! */
/* Always use static/global variables with peripherals/DMA. */
_estack = 0x10000200;

MEMORY
{
	FLASH (rx)      : ORIGIN = 0x00000000, LENGTH = 4K
	RAM (xrw)       : ORIGIN = 0x10000000, LENGTH = 1K
}

SECTIONS
{
	/* Reset Vector */
	.isr_vector :
	{
		. = ALIGN(4);
		KEEP(*(.isr_vector))
		. = ALIGN(4);
	} >FLASH

	.text :
	{
		. = ALIGN(4);
		*(.text)
		*(.text*)
		*(.rodata)
		*(.rodata*)

		. = ALIGN(4);
		_etext = .;
		_exit = .;
	} >FLASH

	.ARM.extab : { *(.ARM.extab* .gnu.linkonce.armextab.*) } >FLASH
	.ARM : {
		__exidx_start = .;
		*(.ARM.exidx*)
		__exidx_end = .;
	} >FLASH

	_sidata = .;

	.data : AT ( _sidata )
	{
		. = ALIGN(4);
		_sdata = .;
		*(.data)
		*(.data*)
		. = ALIGN(4);
		_edata = .;
	} >RAM

	. = ALIGN(4);
	.bss :
	{
		_sbss = .;
		__bss_start__ = _sbss;
		*(.bss)
		*(.bss*)
		*(COMMON)
		. = ALIGN(4);
		_ebss = .;
		__bss_end__ = _ebss;
	} >RAM

	/* Remove information from the standard libraries */
	/DISCARD/ :
	{
		libc.a ( * )
		libm.a ( * )
		libgcc.a ( * )
	}

	.ARM.attributes 0 : { *(.ARM.attributes) }
}