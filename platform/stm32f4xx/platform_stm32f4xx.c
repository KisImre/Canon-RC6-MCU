/* Copyright 2019 Kis Imre */

#include "stm32f4xx.h"
#include "../platform.h"

void init_gpio(void) {
    static const uint16_t pinpos = 12;
    static const uint32_t af = 2; /* TIM4 AF */

    RCC->AHB1ENR |= (0x08 | 0x01); /* GPIOD and GPIOA */

    GPIOD->AFR[pinpos >> 0x03] |= ((uint32_t) (af) << ((uint32_t) (pinpos & 0x07) * 4));
    GPIOD->MODER |= GPIO_MODER_MODER0_1 << (pinpos * 2); /* Alternate function */
}

void init_timer(unsigned int counter) {
    RCC->APB1ENR |= 0x4; /* TIM4 */

    TIM4->DIER |= TIM_DIER_CC1IE; /* Capture-compare 1 interrupt enable */
    TIM4->CCMR1 |= TIM_CCMR1_OC1M | TIM_CCMR1_OC1PE; /* Output, PWM2 mode, Preload enable */
    TIM4->CCER |= TIM_CCER_CC1P | TIM_CCER_CC1E; /* Polarity and output state */
    TIM4->ARR = counter; /* Autoreload value */
    TIM4->CR1 |= TIM_CR1_CEN; /* Enable timer */
}

void init_interrupt(void) {
    static const IRQn_Type irqChannel = TIM4_IRQn;

    NVIC_SetPriority(irqChannel, NVIC_EncodePriority(NVIC_GetPriorityGrouping(), 0, 0));
    NVIC_EnableIRQ(irqChannel);
}

unsigned int is_instant_mode(void) {
    return (GPIOA->IDR & 0x0001) == 0;
}

void set_active_count(unsigned int counter) {
    TIM4->CCR1 = counter;
}

void clear_timer_interrupt(void) {
    TIM4->SR = (uint16_t) ~TIM_SR_CC1IF;
}

void power_down(void) {
    RCC->AHB1ENR &= ~(0x08 | 0x01);
    RCC->APB1ENR &= ~0x4;
}
