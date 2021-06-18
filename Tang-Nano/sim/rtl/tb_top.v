`timescale 1ns / 100ps

module tb_top ();
    parameter MCO_HZ = 24000000;

    reg             mco = 1'b0;
    reg             res_n = 1'b1;

    // LCD
    wire    [7:0]   lcd_data;
    wire            lcd_wr;
    wire            lcd_dc;
    wire            lcd_rst;

    // Clock
    always #(500000000 / MCO_HZ) mco <= ~mco;

    // Reset
    initial begin
        res_n = 1'b1;
        #1000;
        res_n = 1'b0;
        #1000;
        res_n = 1'b1;
    end

    // DUT
    lcd_top dut (
        .mco ( mco ),
        .res_n ( res_n ),
        .btn_b ( 1'b1 ),
        .lcd_data ( lcd_data ),
        .lcd_wr ( lcd_wr ),
        .lcd_dc ( lcd_dc ),
        .lcd_rst ( lcd_rst )
    );

endmodule
