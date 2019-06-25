/* Copyright 2019 Kis Imre */

#include "LPC8xx.h"
#include "../platform.h"

void init_gpio(void) {
    LPC_SWM->PINASSIGN6 &= 0x00ffffff;
    LPC_IOCON->PIO0_0 = 0x00000080;
    LPC_IOCON->PIO0_1 = 0x00000090;
}

void init_timer(unsigned int counter) {
    /* Enable SCT clock */
    LPC_SYSCON->SYSAHBCLKCTRL |= (1 << 8);

    /* Reset SCT */
    LPC_SYSCON->PRESETCTRL &= ~(1 << 8);
    LPC_SYSCON->PRESETCTRL |= (1 << 8);

    /* SCT 32 bit mode */
    LPC_SCT->CONFIG |= (1 << 0) | (1 << 17);

    /* Event 0 - reload */
    LPC_SCT->MATCH[0].U = counter;
    LPC_SCT->MATCHREL[0].U = counter;
    LPC_SCT->EVENT[0].CTRL = (0 << 0) | (1 << 12);
    LPC_SCT->EVENT[0].STATE = 0xffffffff;

    /* Event 1 - start of active state */
    LPC_SCT->MATCHREL[1].U = 0;
    LPC_SCT->EVENT[1].CTRL = (1 << 0) | (1 << 12);
    LPC_SCT->EVENT[1].STATE = 0xffffffff;

    /* Event 2 - end of active state */
    LPC_SCT->MATCHREL[2].U = 0;
    LPC_SCT->EVENT[2].CTRL = (2 << 0) | (1 << 12);
    LPC_SCT->EVENT[2].STATE = 0xffffffff;

    /* Event 1 sets and event 2 clears the output */
    LPC_SCT->OUT[0].SET = (1 << 1);
    LPC_SCT->OUT[0].CLR = (1 << 2);

    /* Interrupt on end of active state */
    LPC_SCT->EVEN |= (1 << 2);

    /* On conflict turn off output */
    LPC_SCT->RES |= 2;

    /* Start SCT */
    LPC_SCT->CTRL_U &= ~(1 << 2);
}

void init_interrupt(void) {
    static const IRQn_Type irqChannel = SCT_IRQn;

    NVIC_SetPriority(irqChannel, 0);
    NVIC_EnableIRQ(irqChannel);
}

unsigned int is_instant_mode(void) {
    return 0; /* TODO: implement lpc8xx is_instant_mode: LPC_GPIO_PORT->B0[1]; */
}

void set_active_count(unsigned int counter) {
    LPC_SCT->MATCHREL[2].U = counter;
}

void clear_timer_interrupt(void) {
    LPC_SCT->EVFLAG = (1 << 2);
}

void power_down(void) {
    LPC_SYSCON->SYSAHBCLKCTRL &= ~(1 << 8);
    LPC_SWM->PINASSIGN6 |= 0xff000000;
    LPC_PMU->PCON |= 0x03;
}
