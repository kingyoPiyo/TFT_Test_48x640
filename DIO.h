/*****************************************************
Title   :   DIO Driver
Author  :   kingyo
File    :   DIO.h
DATE    :   2021/01/05
******************************************************/
#ifndef __DIO_H__
#define __DIO_H__

/*********************************
 * Include
 *********************************/
#include <stdint.h>

/*********************************
 * Prptotype
 *********************************/
void DIO_Init(void);
void DIO_Write(uint8_t data);

void DIO_CS_L(void);
void DIO_CS_H(void);

void DIO_CLK_L(void);
void DIO_CLK_H(void);

void DIO_DC_L(void);
void DIO_DC_H(void);

void DIO_PIN2_L(void);
void DIO_PIN2_H(void);

#endif /* __DIO_H__ */
