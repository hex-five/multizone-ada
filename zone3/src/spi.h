/* Copyright(C) 2019 Hex Five Security, Inc. - All Rights Reserved */

#ifndef SPI_H_
#define SPI_H_

#include <stdint.h>

void spi_init(void);
uint32_t spi_rw(uint8_t cmd[]);

#endif
