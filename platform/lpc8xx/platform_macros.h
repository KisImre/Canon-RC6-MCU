/* Copyright 2019 Kis Imre */

#ifndef PLATFORM_LPC8XX_PLATFORM_MACROS_H_
#define PLATFORM_LPC8XX_PLATFORM_MACROS_H_

#define NANOSEC_TO_COUNTER(ns) ((ns) * 12 / 1000)

#define Timer_IRQHandler SCT_IRQHandler

#endif /* PLATFORM_LPC8XX_PLATFORM_MACROS_H_ */
