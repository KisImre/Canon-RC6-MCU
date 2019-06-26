/* Copyright 2019 Kis Imre */

#include "platform/platform.h"

#define IR_PERIOD_NS        (29300)     // 34.1kHz -> 29.3us
#define STARTUP_NS          (10000000)  // 10ms
#define INSTANT_SHUTTER_NS  (7100000)   // 7.1ms
#define DELAYED_SHUTTER_NS  (5300000)   // 5.3ms

#define NS_TO_IR_PERIOD(ns) ((ns) / IR_PERIOD_NS)

struct Pattern {
    unsigned int active_count;
    unsigned int repeat_count;
};

static const struct Pattern pulses = {.active_count = NANOSEC_TO_COUNTER(9300), .repeat_count = 18};
static const struct Pattern startup_pause = {.active_count = 0, .repeat_count = NS_TO_IR_PERIOD(INSTANT_SHUTTER_NS)};
static const struct Pattern instant_pause = {.active_count = 0, .repeat_count = NS_TO_IR_PERIOD(INSTANT_SHUTTER_NS)};
static const struct Pattern delayed_pause = {.active_count = 0, .repeat_count = NS_TO_IR_PERIOD(DELAYED_SHUTTER_NS)};

static const struct Pattern* const instant_shutter[] = {&startup_pause, &pulses, &instant_pause, &pulses, 0};
static const struct Pattern* const delayed_shutter[] = {&startup_pause, &pulses, &delayed_pause, &pulses, 0};

static const struct Pattern* const * pattern = 0;
static unsigned int repeat_count = 0;

int main() {
    init_gpio();

    pattern = (is_instant_mode()) ? instant_shutter : delayed_shutter;

    init_timer(NANOSEC_TO_COUNTER(IR_PERIOD_NS));
    init_interrupt();

    while (1) {
    }
}

void Timer_IRQHandler(void) {
    clear_timer_interrupt();

    if (repeat_count == 0) {
        if (*pattern == 0) {
            set_active_count(0);
            power_down();
            return;
        }

        set_active_count((*pattern)->active_count);
        repeat_count = (*pattern)->repeat_count - 1;

        pattern++;
    } else if (repeat_count > 0) {
        --repeat_count;
    }

}
