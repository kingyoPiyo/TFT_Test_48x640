/*****************************************************
Title   :   マジョカアイリス TFT-LCD Test(48x640)
            For Arduino Nano
Author  :   kingyo
File    :   TFT_Test.ino
DATE    :   2021/01/05
******************************************************/
#include "DIO.h"
#include "ROM.h"

#define DEF_LCD_WIDTH   (640)
#define DEF_LCD_HEIGHT  (48)
#define DEF_LCD_SIZE    (DEF_LCD_WIDTH * DEF_LCD_HEIGHT)

void send_CMD(uint8_t cmd, uint8_t dc)
{
    if (dc) {
        // data
        DIO_DC_H();
    } else {
        // command
        DIO_DC_L();
    }
    DIO_Write(cmd);
    DIO_CLK_H();
    DIO_CLK_L();
}

void setup()
{
    uint16_t i, x;
    uint8_t r, g, b;

    DIO_Init();

    DIO_PIN2_H();
    DIO_CS_H();
    DIO_DC_H();
    delay(100);
    DIO_PIN2_L();
    delay(100);
    DIO_PIN2_H();
    delay(100);
    DIO_CS_L();

    // TFT Driver 初期化（ロジアナDump値そのまま）
    // Driver IC:ILI9342C

    // Set EXTC
    send_CMD(0xC8, 0);
    send_CMD(0xFF, 1);
    send_CMD(0x93, 1);
    send_CMD(0x42, 1);

    // Column Address Set
    send_CMD(0x2A, 0);
    send_CMD(0x00, 1);
    send_CMD(0x00, 1);
    send_CMD(0x01, 1);
    send_CMD(0x3F, 1);

    // Page Address Set
    send_CMD(0x2B, 0);
    send_CMD(0x00, 1);
    send_CMD(0x00, 1);
    send_CMD(0x00, 1);
    send_CMD(0x5F, 1);

    // Memory Access Control
    send_CMD(0x36, 0);
    send_CMD(0xC8, 1);

    // Power Control 1
    send_CMD(0xC0, 0);
    send_CMD(0x0E, 1);
    send_CMD(0x0E, 1);

    // Power Control 2
    send_CMD(0xC1, 0);
    send_CMD(0x10, 1);

    //VCOM Control 1 
    send_CMD(0xC5, 0);
    send_CMD(0xFA, 1);

    // Pixel Format Set
    send_CMD(0x3A, 0);
    send_CMD(0x55, 1);

    // Display Waveform Cycle 1 (In Normal Mode)
    send_CMD(0xB1, 0);
    send_CMD(0x00, 1);
    send_CMD(0x18, 1);

    // Positive Gamma Correction
    send_CMD(0xE0, 0);
    send_CMD(0x00, 1);
    send_CMD(0x1C, 1);
    send_CMD(0x21, 1);
    send_CMD(0x02, 1);
    send_CMD(0x11, 1);
    send_CMD(0x07, 1);
    send_CMD(0x3D, 1);
    send_CMD(0x79, 1);
    send_CMD(0x4B, 1);
    send_CMD(0x07, 1);
    send_CMD(0x0F, 1);
    send_CMD(0x0C, 1);
    send_CMD(0x1B, 1);
    send_CMD(0x1F, 1);
    send_CMD(0x0F, 1);

    // Negative Gamma Correction
    send_CMD(0xE1, 0);
    send_CMD(0x00, 1);
    send_CMD(0x1C, 1);
    send_CMD(0x20, 1);
    send_CMD(0x04, 1);
    send_CMD(0x0F, 1);
    send_CMD(0x04, 1);
    send_CMD(0x33, 1);
    send_CMD(0x45, 1);
    send_CMD(0x42, 1);
    send_CMD(0x04, 1);
    send_CMD(0x0C, 1);
    send_CMD(0x0A, 1);
    send_CMD(0x22, 1);
    send_CMD(0x29, 1);
    send_CMD(0x0F, 1);

    // Sleep OUT
    send_CMD(0x11, 0);
    delay(130);

    // Display ON
    send_CMD(0x29, 0);
    delay(10);

    // RAMクリア
    send_CMD(0x2C, 0);
    for (i = 0; i < DEF_LCD_SIZE; i++)
    {
        send_CMD(0x00, 1);
        send_CMD(0x00, 1);
    }

    // テストパターン表示
    send_CMD(0x2A, 0);
    send_CMD(0x00, 1);
    send_CMD(0x00, 1);
    send_CMD(0x01, 1);
    send_CMD(0x3F, 1);
    send_CMD(0x2B, 0);
    send_CMD(0x00, 1);
    send_CMD(0x00, 1);
    send_CMD(0x00, 1);
    send_CMD(0x5F, 1);
    send_CMD(0x2C, 0);
    for (i = 0, x = 0; i < DEF_LCD_SIZE; i++)
    {
        if (x < DEF_LCD_WIDTH / 3)
        {
            r = 31;
            g = 0;
            b = 0;
        }
        else if (x < DEF_LCD_WIDTH * 2 / 3)
        {
            r = 0;
            g = 63;
            b = 0;
        }
        else
        {
            r = 0;
            g = 0;
            b = 31;
        }

        if (x >= DEF_LCD_WIDTH - 1)
        {
            x = 0;
        }
        else
        {
            x++;
        }
        
        // RGB565 format
        send_CMD((r << 3) + (g >> 3), 1);
        send_CMD((uint8_t)(g << 5) + b, 1);
    }
    delay(3000);
}

// main loop
void loop()
{
    uint16_t lp;
    uint8_t tmp;

    send_CMD(0x2A, 0);
    send_CMD(0x00, 1);
    send_CMD(0x00, 1);
    send_CMD(0x01, 1);
    send_CMD(0x3F, 1);
    send_CMD(0x2B, 0);
    send_CMD(0x00, 1);
    send_CMD(0x00, 1);
    send_CMD(0x00, 1);
    send_CMD(0x5F, 1);
    send_CMD(0x2C, 0);
    for (lp = 0; lp < (DEF_LCD_SIZE / 8); lp++)
    {
        // ROMデータ取り出し
        tmp = ROM_Read(lp);

        // データ展開
        for (uint8_t i = 0; i < 8; i++)
        {
            if ((tmp >> (7 - i)) & 0x01)
            {
                send_CMD(0x00, 1);
                send_CMD(0x00, 1);
            }
            else
            {
                send_CMD(0xFF, 1);
                send_CMD(0xFF, 1);
            }
        }
    }
    delay(1000);

    /* ループさせる必要はないが */
}
