/* Copyright 2019 Kis Imre */

#ifndef PLATFORM_PLATFORM_H_
#define PLATFORM_PLATFORM_H_

/* platform_macros.h: NANOSEC_TO_COUNTER(ns), Timer_IRQHandler */
#include "platform_macros.h"

void init_gpio(void);
void init_timer(unsigned int counter);
void init_interrupt(void);

unsigned int is_instant_mode(void);

void set_active_count(unsigned int counter);
void clear_timer_interrupt(void);

void power_down(void);

#endif /* PLATFORM_PLATFORM_H_ */
