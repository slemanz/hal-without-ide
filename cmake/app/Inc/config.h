#ifndef CONFIG_H_
#define CONFIG_H_

#include "stm32f4xx_hal.h"

/* Black Pill (STM32F411CE): LED no PC13, ativo em nivel baixo */
#define LED_PORT    GPIOC
#define LED_PIN     GPIO_PIN_13

extern UART_HandleTypeDef huart2;

void config_gpio_init(void);
void config_uart_init(void);

#endif /* CONFIG_H_ */
