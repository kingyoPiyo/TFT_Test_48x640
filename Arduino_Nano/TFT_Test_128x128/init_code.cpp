
// 128x128 LCD
// ST7735？

// Sleep Out
send_CMD(0x11, 0);

// Frame Rate Control (In normal mode/ Full colors)
send_CMD(0xB1, 0);
send_CMD(0x05, 1);
send_CMD(0x3A, 1);
send_CMD(0x3A, 1);

// Frame Rate Control (In Idle mode/ 8-colors) 
send_CMD(0xB2, 0);
send_CMD(0x05, 1);
send_CMD(0x3A, 1);
send_CMD(0x3A, 1);

// Frame Rate Control (In Partial mode/ full colors) 
send_CMD(0xB3, 0);
send_CMD(0x05, 1);
send_CMD(0x3A, 1);
send_CMD(0x3A, 1);
send_CMD(0x05, 1);
send_CMD(0x3A, 1);
send_CMD(0x3A, 1);

// Display Inversion Control 
send_CMD(0xB4, 0);
send_CMD(0x03, 1);

// Power Control 1 ※パラメータ数不一致
send_CMD(0xC0, 0);
send_CMD(0x62, 1);
send_CMD(0x02, 1);
send_CMD(0x04, 1);

// Power Control 2
send_CMD(0xC1, 0);
send_CMD(0xC0, 1);

// Power Control 3 (in Normal mode/ Full colors)
send_CMD(0xC2, 0);
send_CMD(0x0D, 1);
send_CMD(0x00, 1);

// Power Control 4 (in Idle mode/ 8-colors) 
send_CMD(0xC3, 0);
send_CMD(0x8D, 1);
send_CMD(0xEA, 1);

// Power Control 5 (in Partial mode/ full-colors)
send_CMD(0xC4, 0);
send_CMD(0x8D, 1);
send_CMD(0xEE, 1);

// VCOM Control 1 ※パラメータ数不一致
send_CMD(0xC5, 0);
send_CMD(0x0D, 1);

// Memory Data Access Control
send_CMD(0x36, 0);
send_CMD(0x08, 1);

// Interface Pixel Format 
send_CMD(0x3A, 0);
send_CMD(0x55, 1);

// Partial Area 
send_CMD(0x30, 0);
send_CMD(0x00, 1);
send_CMD(0x00, 1);
send_CMD(0x00, 1);
send_CMD(0x7F, 1);

// Gamma (‘+’polarity) Correction Characteristics Setting
send_CMD(0xE0, 0);
send_CMD(0x0A, 1);
send_CMD(0x1F, 1);
send_CMD(0x0E, 1);
send_CMD(0x17, 1);
send_CMD(0x37, 1);
send_CMD(0x31, 1);
send_CMD(0x2B, 1);
send_CMD(0x2E, 1);
send_CMD(0x2C, 1);
send_CMD(0x29, 1);
send_CMD(0x31, 1);
send_CMD(0x3C, 1);
send_CMD(0x00, 1);
send_CMD(0x05, 1);
send_CMD(0x03, 1);
send_CMD(0x0D, 1);

// Gamma ‘-’polarity Correction Characteristics Setting 
send_CMD(0xE1, 0);
send_CMD(0x0B, 1);
send_CMD(0x1F, 1);
send_CMD(0x0E, 1);
send_CMD(0x12, 1);
send_CMD(0x28, 1);
send_CMD(0x24, 1);
send_CMD(0x1F, 1);
send_CMD(0x25, 1);
send_CMD(0x25, 1);
send_CMD(0x26, 1);
send_CMD(0x30, 1);
send_CMD(0x3C, 1);
send_CMD(0x00, 1);
send_CMD(0x05, 1);
send_CMD(0x03, 1);
send_CMD(0x0D, 1);

// Display On
send_CMD(0x29, 0);

// Column Address Set 
send_CMD(0x2A, 0);
send_CMD(0x00, 1);
send_CMD(0x02, 1);
send_CMD(0x00, 1);
send_CMD(0x81, 1);

// Row Address Set 
send_CMD(0x2B, 0);
send_CMD(0x00, 1);
send_CMD(0x01, 1);
send_CMD(0x00, 1);
send_CMD(0x80, 1);

// Memory Write
send_CMD(0x2C, 0);

