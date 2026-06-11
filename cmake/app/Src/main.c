#include <stdio.h>
#include "config.h"

#define LED_PERIOD_MS   500
#define MSG_PERIOD_MS   5000

int main(void)
{
    HAL_Init();
    config_gpio_init();
    config_uart_init();

    printf("Boot ok! SYSCLK = %lu Hz\r\n", SystemCoreClock);

    uint32_t led_tick = HAL_GetTick();
    uint32_t msg_tick = HAL_GetTick();

    while (1)
    {
        if ((HAL_GetTick() - led_tick) >= LED_PERIOD_MS)
        {
            led_tick = HAL_GetTick();
            HAL_GPIO_TogglePin(LED_PORT, LED_PIN);
        }

        if ((HAL_GetTick() - msg_tick) >= MSG_PERIOD_MS)
        {
            msg_tick = HAL_GetTick();
            printf("Hello from STM32F411!\r\n");
        }
    }
}
