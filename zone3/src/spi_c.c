/* Copyright(C) 2018 Hex Five Security, Inc. - All Rights Reserved */

#include <stdint.h>
#include <stdbool.h>

#include <platform.h>

#define SPI_TDI 11 	// in
#define SPI_TCK 10	// out (master)
#define SPI_TDO  9  // out
#define SPI_SYN  8  // out - not used

static uint8_t CRC8(uint8_t bytes[]){

    const uint8_t generator = 0x1D;
    uint8_t crc = 0;

    for(int b=0; b<3; b++) {

        crc ^= bytes[b]; /* XOR-in the next input byte */

        for (int i = 0; i < 8; i++)
            if ((crc & 0x80) != 0)
                crc = (uint8_t)((crc << 1) ^ generator);
            else
                crc <<= 1;
    }

    return crc;
}

uint32_t spi_rw(uint8_t cmd[]){

	uint32_t rx_data = 0;

	const uint32_t tx_data = ((uint8_t)cmd[0] << 24) |  ((uint8_t)cmd[1] << 16) | ((uint8_t)cmd[2] << 8) | CRC8(cmd);

	for (int i=32-1, bit; i>=0; i--){

		bit = (tx_data >> i) & 1U;
		GPIO_REG(GPIO_OUTPUT_VAL) = (bit==1 ? GPIO_REG(GPIO_OUTPUT_VAL) | (0x1 << SPI_TDO) :
											  GPIO_REG(GPIO_OUTPUT_VAL) & ~(0x1 << SPI_TDO)  );

		GPIO_REG(GPIO_OUTPUT_VAL) |= (0x1 << SPI_TCK); volatile int w1=0; while(w1<5) w1++;
		GPIO_REG(GPIO_OUTPUT_VAL) ^= (0x1 << SPI_TCK); volatile int w2=0; while(w2<5) w2++;
		bit = ( GPIO_REG(GPIO_INPUT_VAL) >> SPI_TDI) & 1U;
		rx_data = ( bit==1 ? rx_data |  (0x1 << i) : rx_data & ~(0x1 << i) );

	}

	return rx_data;
}

void spi_init(void){
	GPIO_REG(GPIO_INPUT_EN)  |= (0x1 << SPI_TDI);
	GPIO_REG(GPIO_PULLUP_EN) |= (0x1 << SPI_TDI);
	GPIO_REG(GPIO_OUTPUT_EN) |= ((0x1 << SPI_TCK) | (0x1<< SPI_TDO) | LED_RED | LED_GREEN | LED_BLUE);
    GPIO_REG(GPIO_DRIVE)     |= ((0x1 << SPI_TCK) | (0x1<< SPI_TDO)) ;
}
