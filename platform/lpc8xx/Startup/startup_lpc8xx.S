/* Copyright 2019 Kis Imre */

    .syntax unified
    .cpu cortex-m0
    .fpu softvfp
    .thumb

    .word  _sbss
    .word  _ebss

    .section  .text.Reset_Handler
    .weak  Reset_Handler
    .type  Reset_Handler, %function

Reset_Handler:
    movs  r1, #0
    ldr  r2, =_sbss
    b  LoopFillZerobss

FillZerobss:
    movs  r3, #0
    adds  r2, r2, #4
    str  r3, [r2]

LoopFillZerobss:
    ldr  r3, = _ebss
    cmp  r2, r3
    bcc  FillZerobss
    bl  main
    bx  lr

    .size  Reset_Handler, .-Reset_Handler

    .section  .text.Default_Handler,"ax",%progbits
Default_Handler:
    b  Default_Handler
    .size  Default_Handler, .-Default_Handler

    .section  .isr_vector,"a",%progbits
    .type  Vectors, %object
    .size  Vectors, .-Vectors


Vectors:
    .word _estack
    .word Reset_Handler
    .word NMI_Handler
    .word HardFault_Handler
    .word 0
    .word 0
    .word 0
    .word 0xeffefced
    .word 0
    .word 0
    .word 0
    .word SVC_Handler
    .word 0
    .word 0
    .word PendSV_Handler
    .word SysTick_Handler

    /* External Interrupts */
    .word SPI0_IRQHandler       /* SPI0 controller */
    .word SPI1_IRQHandler       /* SPI1 controller */
    .word 0                     /* Reserved */
    .word UART0_IRQHandler      /* UART0 */
    .word UART1_IRQHandler      /* UART1 */
    .word UART2_IRQHandler      /* UART2 */
    .word 0                     /* Reserved */
    .word 0                     /* Reserved */
    .word I2C_IRQHandler        /* I2C controller */
    .word SCT_IRQHandler        /* Smart Counter Timer */
    .word MRT_IRQHandler        /* Multi-Rate Timer */
    .word CMP_IRQHandler        /* Comparator */
    .word WDT_IRQHandler        /* PIO1 (0:11) */
    .word BOD_IRQHandler        /* Brown Out Detect */
    .word 0                     /* Reserved */
    .word WKT_IRQHandler        /* Wakeup timer */
    .word 0                     /* Reserved */
    .word 0                     /* Reserved */
    .word 0                     /* Reserved */
    .word 0                     /* Reserved */
    .word 0                     /* Reserved */
    .word 0                     /* Reserved */
    .word 0                     /* Reserved */
    .word 0                     /* Reserved */
    .word PININT0_IRQHandler    /* PIO INT0 */
    .word PININT1_IRQHandler    /* PIO INT1 */
    .word PININT2_IRQHandler    /* PIO INT2 */
    .word PININT3_IRQHandler    /* PIO INT3 */
    .word PININT4_IRQHandler    /* PIO INT4 */
    .word PININT5_IRQHandler    /* PIO INT5 */
    .word PININT6_IRQHandler    /* PIO INT6 */
    .word PININT7_IRQHandler    /* PIO INT7 */

    .weak      NMI_Handler
    .thumb_set NMI_Handler,Default_Handler

    .weak      HardFault_Handler
    .thumb_set HardFault_Handler,Default_Handler

    .weak      SVC_Handler
    .thumb_set SVC_Handler,Default_Handler

    .weak      PendSV_Handler
    .thumb_set PendSV_Handler,Default_Handler

    .weak      SysTick_Handler
    .thumb_set SysTick_Handler,Default_Handler

    .weak      SPI0_IRQHandler
    .thumb_set SPI0_IRQHandler,Default_Handler

    .weak      SPI1_IRQHandler
    .thumb_set SPI1_IRQHandler,Default_Handler

    .weak      UART0_IRQHandler
    .thumb_set UART0_IRQHandler,Default_Handler

    .weak      UART1_IRQHandler
    .thumb_set UART1_IRQHandler,Default_Handler

    .weak      UART2_IRQHandler
    .thumb_set UART2_IRQHandler,Default_Handler

    .weak      I2C_IRQHandler
    .thumb_set I2C_IRQHandler,Default_Handler

    .weak      SCT_IRQHandler
    .thumb_set SCT_IRQHandler,Default_Handler

    .weak      MRT_IRQHandler
    .thumb_set MRT_IRQHandler,Default_Handler

    .weak      CMP_IRQHandler
    .thumb_set CMP_IRQHandler,Default_Handler

    .weak      WDT_IRQHandler
    .thumb_set WDT_IRQHandler,Default_Handler

    .weak      BOD_IRQHandler
    .thumb_set BOD_IRQHandler,Default_Handler

    .weak      WKT_IRQHandler
    .thumb_set WKT_IRQHandler,Default_Handler

    .weak      PININT0_IRQHandler
    .thumb_set PININT0_IRQHandler,Default_Handler

    .weak      PININT1_IRQHandler
    .thumb_set PININT1_IRQHandler,Default_Handler

    .weak      PININT2_IRQHandler
    .thumb_set PININT2_IRQHandler,Default_Handler

    .weak      PININT3_IRQHandler
    .thumb_set PININT3_IRQHandler,Default_Handler

    .weak      PININT4_IRQHandler
    .thumb_set PININT4_IRQHandler,Default_Handler

    .weak      PININT5_IRQHandler
    .thumb_set PININT5_IRQHandler,Default_Handler

    .weak      PININT6_IRQHandler
    .thumb_set PININT6_IRQHandler,Default_Handler

    .weak      PININT7_IRQHandler
    .thumb_set PININT7_IRQHandler,Default_Handler
