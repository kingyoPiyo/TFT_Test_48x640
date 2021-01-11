/********************************************************
* Title    : Tang-Nano 48x640 LCD Test
* Date     : 2021/01/11
* Design   : kingyo
********************************************************/
module lcd_top (
    // CLK
    input   wire            mco,    // 24MHz

    // Button
    input   wire            res_n,
    input   wire            btn_b,  // 未使用
    
    // LCD
    output  wire    [7:0]   lcd_data,
    output  wire            lcd_wr,
    output  wire            lcd_dc,
    output  wire            lcd_rst
    );

    //==================================================================
    // PLL
    //==================================================================
    wire    clk12m;
    wire    locked;
    Gowin_PLL pll (
        .reset ( 1'b0 ),
        .clkin ( mco ),
        .clkout ( clk12m ),
        .lock ( locked )
    );

    //==================================================================
    // LCD Controller
    //==================================================================
    lcd_ctrl lcd_ctrl (
        .i_clk ( clk12m ),
        .i_res_n ( res_n & locked ),
        .o_lcd_data ( lcd_data ),
        .o_lcd_wr ( lcd_wr ),
        .o_lcd_dc ( lcd_dc ),
        .o_lcd_rst ( lcd_rst )
    );

endmodule
