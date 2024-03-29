/* Copyright 2019 Kis Imre */

#ifndef PLATFORM_STM32F4XX_PLATFORM_MACROS_H_
#define PLATFORM_STM32F4XX_PLATFORM_MACROS_H_

#define NANOSEC_TO_COUNTER(ns) ((ns) * 84 / 1000)

#define Timer_IRQHandler TIM4_IRQHandler

#endif /* PLATFORM_STM32F4XX_PLATFORM_MACROS_H_ */
