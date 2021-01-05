/*****************************************************
Title   :   DIO Driver
Author  :   kingyo
File    :   DIO.c
DATE    :   2021/01/05
******************************************************/
#include "DIO.h"
#include <avr/io.h>

void DIO_Init(void)
{
    DDRD |= 0b11111100; // D0...5
    DDRB |= 0b00111111; // D6, D7, CS#, WR#, D/C#, RD#
}


// https://twitter.com/s_osafune/status/1346171487422541825
void DIO_Write(const uint8_t data)
{
    register uint8_t td = PORTD;
    register uint8_t tb = PORTB;

    td = (data << 2) | (td & 0x03);
    tb = (data >> 6) | (tb & 0xFC);

    // PORTDとPORTB間のタイミング差を小さくするため一旦レジスタを介在させて出力
    PORTD = td;
    PORTB = tb;
}

void DIO_CS_L(void)
{
    PORTB &= ~(1 << 2);
}

void DIO_CS_H(void)
{
    PORTB |= (1 << 2);
}

void DIO_CLK_L(void)
{
    PORTB &= ~(1 << 3);
}

void DIO_CLK_H(void)
{
    PORTB |= (1 << 3);
}

void DIO_DC_L(void)
{
    PORTB &= ~(1 << 4);
}

void DIO_DC_H(void)
{
    PORTB |= (1 << 4);
}

void DIO_PIN2_L(void)
{
    PORTB &= ~(1 << 5);
}

void DIO_PIN2_H(void)
{
    PORTB |= (1 << 5);
}
