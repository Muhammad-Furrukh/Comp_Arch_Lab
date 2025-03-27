
// UART Register Definitions (32-bit aligned)
#define UART_BASE 0x80000200

#define UART_DATA_REG       (*(volatile int *)(UART_BASE + 0x00))
#define UART_CONTROL_REG    (*(volatile int *)(UART_BASE + 0x04))
#define UART_STATUS_REG     (*(volatile int *)(UART_BASE + 0x08))
#define UART_BAUD_REG       (*(volatile int *)(UART_BASE + 0x0C))
#define UART_BITCOUNT_REG   (*(volatile int *)(UART_BASE + 0x14))

int main() {
    int baud_divisor = 3;
    
    // Configure Baud Rate (14-bit value)
    UART_BAUD_REG = baud_divisor;

    // Enable TX with 2 stop bits and odd parity
    UART_CONTROL_REG = 0x07;

    // Wait until configuration is validated by hardware
    while (UART_STATUS_REG == 0);

    UART_DATA_REG = 'U';

    UART_DATA_REG = 'A';

    UART_DATA_REG = 'R';

    UART_DATA_REG = 'T';

    UART_DATA_REG = '\r';

    UART_DATA_REG = '\n';

    UART_DATA_REG = 'H';

    UART_DATA_REG = 'E';

    UART_DATA_REG = 'L';

    UART_DATA_REG = 'L';

    UART_DATA_REG = 'O';

    UART_DATA_REG = '\r';

    UART_DATA_REG = '\n';
    return 0;
}