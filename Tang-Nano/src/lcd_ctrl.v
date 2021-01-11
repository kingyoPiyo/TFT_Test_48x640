/********************************************************
* Title    : LCD Controller
* Date     : 2021/01/11
* Design   : kingyo
********************************************************/
module lcd_ctrl (
    input   wire            i_clk,
    input   wire            i_res_n,

    output  reg     [7:0]   o_lcd_data,
    output  reg             o_lcd_wr,
    output  reg             o_lcd_dc,
    output  reg             o_lcd_rst
);

    //==================================================================
    // LCD Driver初期化
    //==================================================================
    wire    [7:0]   w_lcd_data_init;
    wire            w_lcd_wr_init;
    wire            w_lcd_dc_init;
    wire            w_lcd_rst_init;
    wire            w_lcd_init_fin;
    lcd_init lcd_init (
        .i_clk ( i_clk ),
        .i_res_n ( i_res_n ),
        .o_lcd_data ( w_lcd_data_init ),
        .o_lcd_wr ( w_lcd_wr_init ),
        .o_lcd_dc ( w_lcd_dc_init ),
        .o_lcd_rst ( w_lcd_rst_init ),
        .o_lcd_init_fin ( w_lcd_init_fin )
    );

    //==================================================================
    // 🍣🍣～～
    //==================================================================
    wire    [7:0]   w_lcd_data_sushi;
    wire            w_lcd_wr_sushi;
    wire            w_lcd_dc_sushi;
    lcd_sushi lcd_sushi (
        .i_clk ( i_clk ),
        .i_res_n ( w_lcd_init_fin ),
        .o_lcd_data ( w_lcd_data_sushi ),
        .o_lcd_wr ( w_lcd_wr_sushi ),
        .o_lcd_dc ( w_lcd_dc_sushi )
    );
    
    //==================================================================
    // 出力信号セレクタ&レジスタ
    // LCD Driverの初期化完了後、🍣に切り替える
    //==================================================================
    always @(posedge i_clk or negedge i_res_n) begin
        if (~i_res_n) begin
            o_lcd_data <= 8'd0;
            o_lcd_wr <= 1'b0;
            o_lcd_dc <= 1'b0;
            o_lcd_rst <= 1'b0;
        end else begin
            o_lcd_data  <= ~w_lcd_init_fin ? w_lcd_data_init : 
                                             w_lcd_data_sushi;
            o_lcd_wr    <= ~w_lcd_init_fin ? w_lcd_wr_init :
                                             w_lcd_wr_sushi;
            o_lcd_dc    <= ~w_lcd_init_fin ? w_lcd_dc_init :
                                             w_lcd_dc_sushi;
            o_lcd_rst   <= ~w_lcd_init_fin ? w_lcd_rst_init : 
                                             1'b1;
        end
    end

endmodule
