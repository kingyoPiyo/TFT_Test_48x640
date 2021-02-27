# TFT_Test_48x640

某魔法ステッキに内蔵されている48x640ピクセルLCDをArduino NanoとTang-Nano FPGAで動かしてみたサンプルです。実機動作を元に初期化コードなどを記述しているつもりですが、誤り等あるかもです。予めご了承ください。  
詳細は[wiki](https://github.com/htlabnet/inside_magimajopures/wiki)参照。  

## Arduino Nano版
Arduino NanoのI/O電圧は5Vですが、本LCDの信号レベルは3.3V系です。実験ではArduinoの電源電圧を3.3Vに下げて動作させてます。  
<img src="doc/top_arduino.png">  

## Tang Nano版
Arduino Nanoで🍣を流そうとしたところ、処理速度が足りずに残念な感じになったので、Tang-Nano FPGAに移植してみました。  
<img src="doc/top_tang_nano.png">  

### LCDピンと信号名の対応
| LCDピン番号 | ピン名 | I/O | RTL信号名 | 説明 |
|----|----|----|----|----|
| 1 | GND | - | - | |
| 2 | RST | I | lcd_rst | Low Active |
| 3 | GND | - | - | |
| 4 | D0 | I | lcd_data[0] | |
| 5 | D1 | I | lcd_data[1] | |
| 6 | D2 | I | lcd_data[2] | |
| 7 | D3 | I | lcd_data[3] | |
| 8 | D4 | I | lcd_data[4] | |
| 9 | D5 | I | lcd_data[5] | |
|10 | D6 | I | lcd_data[6] | |
|11 | D7 | I | lcd_data[7] | |
|12 | CS | I | - (Low) | 先端側CS MCUとLCDが1:1対応で他にSlaveを切り替えない場合はLow固定で可 |
|13 | RD | I | - (High) | LCDからデータをReadしない場合はHigh固定で可 |
|14 | WR | I | lcd_wr | 立ち上がりエッジでデータラッチ |
|15 | CS | I | - (Low) | 根元側CS MCUとLCDが1:1対応で他にSlaveを切り替えない場合はLow固定で可 |
|16 | DC | I | lcd_dc | Low:CMD / High:Data |
|17 | TE | O | - | 未接続 |
|18 | VDD | - | - | +3.3V |
|19 | VDDIO | - | - | +3.3V |
|20 | LED+ | - | - | 20mA程度流れるように電流制限する |
|21 | LED- | - | - | |
|22 | GND | - | - | |
