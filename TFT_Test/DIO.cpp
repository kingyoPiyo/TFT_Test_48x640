/*****************************************************
Title   :   DIO Driver
Author  :   kingyo
File    :   DIO.cpp
DATE    :   2021/01/05
******************************************************/
#include "DIO.h"
#include <avr/io.h>

void DIO_Init(void)
{
    DDRD |= 0b11111100; // D0...5
    DDRB |= 0b00111111; // D6, D7, CS#, WR#, D/C#, RD#
}

void DIO_Write(const uint8_t data)
{
    PORTD = (data << 2) | (PORTD & 0x03);
    PORTB = (data >> 6) | (PORTB & 0xFC);
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
