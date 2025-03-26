#include <stdint.h>

// UART Register Definitions
#define UART_BASE 0x80000200

#define UART_DATA_REG      (*(volatile uint32_t *)(UART_BASE + 0x00))
#define UART_CONTROL_REG   (*(volatile uint32_t *)(UART_BASE + 0x04))
#define UART_STATUS_REG    (*(volatile uint32_t *)(UART_BASE + 0x08))
#define UART_BAUD_REG      (*(volatile uint32_t *)(UART_BASE + 0x0C))
#define UART_BITCOUNT_REG  (*(volatile uint32_t *)(UART_BASE + 0x14))

// Control Register Bits
#define TX_EN_BIT    (1 << 0)
#define TWO_STOP_BIT (1 << 1)
#define ODD_PARITY   (1 << 2)

void uart_init(uint32_t baud_divisor) {
    // Configure Baud Rate
    UART_BAUD_REG = baud_divisor;

    // Enable TX, Two stop bits, Odd parity
    UART_CONTROL_REG = TX_EN_BIT | TWO_STOP_BIT | ODD_PARITY;

    while ((UART_STATUS_REG & 0x1) == 0);
}

void uart_send_char(char c) {
    UART_DATA_REG = (uint32_t)c;

    for (volatile int i = 0; i < 100; i++);
}

void uart_send_string(const char *str) {
    while (*str) {
        uart_send_char(*str++);
        
        for (volatile int i = 0; i < 5000; i++);
    }
}

int main() {
    uint32_t baud_divisor = 868;
    
    uart_init(baud_divisor);
    uart_send_string("Hello from RISC-V!\n");

    // Optional: Echo test (if loopback implemented)
    while (1) {
        
    }

    return 0;
}