/********************************************************
* Title    : LCD Driver Initialize
* Date     : 2021/01/11
* Design   : kingyo
********************************************************/
module lcd_init (
    input   wire            i_clk,
    input   wire            i_res_n,

    output  wire    [7:0]   o_lcd_data,
    output  wire            o_lcd_wr,
    output  wire            o_lcd_dc,
    output  wire            o_lcd_rst,

    output  wire            o_lcd_init_fin
);

    reg     [5:0]   r_init_state;

    // LCDリセット信号生成(5ms Active)
    reg             r_lcd_rst_out;  // 出力されるReset信号
    reg             r_lcd_rst_int;  // 内部シーケンス用Reset信号
    reg     [15:0]  r_cnt_lcd_rst;  // リセットタイミング生成用カウンタ
    always @(posedge i_clk or negedge i_res_n) begin
        if (~i_res_n) begin
            r_lcd_rst_out <= 1'b0;
            r_lcd_rst_int <= 1'b0;
            r_cnt_lcd_rst <= 16'd0;
        end else begin
            if (~&r_cnt_lcd_rst) begin
                r_cnt_lcd_rst <= r_cnt_lcd_rst + 16'd1;
            end
            // LCDのリセットを先に解除させてから、初期化シーケンスを実行
            if (r_cnt_lcd_rst == 16'd45000) begin
                r_lcd_rst_out <= 1'b1;
            end
            if (r_cnt_lcd_rst == 16'd50000) begin
                r_lcd_rst_int <= 1'b1;
            end
        end
    end

    // 130ms Delay生成
    reg     [20:0]  r_cnt_delay_130ms;
    reg             r_delay_130ms_fin;
    always @(posedge i_clk or negedge i_res_n) begin
        if (~i_res_n) begin
            r_cnt_delay_130ms <= 21'd0;
            r_delay_130ms_fin <= 1'd0;
        end else if (~r_delay_130ms_fin) begin
            if (r_init_state == 6'd61) begin
                r_cnt_delay_130ms <= r_cnt_delay_130ms + 21'd1;
                if (r_cnt_delay_130ms == 21'd1560000) begin // 130ms:1560000@24MHz
                    r_delay_130ms_fin <= 1'b1;
                end
            end
        end
    end

    // LCD制御クロック生成
    reg     r_lcd_clk;
    always @(posedge i_clk or negedge i_res_n) begin
        if (~i_res_n) begin
            r_lcd_clk <= 1'b0;
        end else if (r_lcd_rst_int && (r_init_state != 6'd61 || r_delay_130ms_fin)) begin
            r_lcd_clk <= ~r_lcd_clk;
        end
    end

    // 初期化コマンドシーケンス処理
    reg             r_init_busy;
    always @(posedge i_clk or negedge i_res_n) begin
        if (~i_res_n) begin
            r_init_busy <= 1'b1;
            r_init_state <= 6'd0;
        end else if (r_lcd_rst_int) begin
            // ステート更新
            if (r_init_busy) begin
                if (~r_lcd_clk) begin
                    r_init_state <= r_init_state + 6'd1;
                    
                    // 初期化完了
                    if (r_init_state == 6'd62) begin
                        r_init_busy <= 1'b0;
                    end
                end
            end
        end
    end

    // 初期化コマンド
    reg     [8:0]   r_init_data;    // {cd, data[7:0]}
    always @(posedge i_clk or negedge i_res_n) begin
        if (~i_res_n) begin
            r_init_data <= 9'd0;
        end else begin
            case (r_init_state[5:0])
                // Set EXTC
                6'd0: r_init_data <= {1'b0, 8'hC8};
                6'd1: r_init_data <= {1'b1, 8'hFF};
                6'd2: r_init_data <= {1'b1, 8'h93};
                6'd3: r_init_data <= {1'b1, 8'h42};

                // Column Address Set
                6'd4: r_init_data <= {1'b0, 8'h2A};
                6'd5: r_init_data <= {1'b1, 8'h00};
                6'd6: r_init_data <= {1'b1, 8'h00};
                6'd7: r_init_data <= {1'b1, 8'h01};
                6'd8: r_init_data <= {1'b1, 8'h3F};

                // Page Address Set
                6'd9: r_init_data <= {1'b0, 8'h2B};
                6'd10: r_init_data <= {1'b1, 8'h00};
                6'd11: r_init_data <= {1'b1, 8'h00};
                6'd12: r_init_data <= {1'b1, 8'h00};
                6'd13: r_init_data <= {1'b1, 8'h5F};

                // Memory Access Control
                6'd14: r_init_data <= {1'b0, 8'h36};
                6'd15: r_init_data <= {1'b1, 8'hC8};

                // Power Control 1
                6'd16: r_init_data <= {1'b0, 8'hC0};
                6'd17: r_init_data <= {1'b1, 8'h0E};
                6'd18: r_init_data <= {1'b1, 8'h0E};

                // Power Control 2
                6'd19: r_init_data <= {1'b0, 8'hC1};
                6'd20: r_init_data <= {1'b1, 8'h10};

                // VCOM Control 1
                6'd21: r_init_data <= {1'b0, 8'hC5};
                6'd22: r_init_data <= {1'b1, 8'hFA};

                // Pixel Format Set
                6'd23: r_init_data <= {1'b0, 8'h3A};
                6'd24: r_init_data <= {1'b1, 8'h55};

                // Display Waveform Cycle 1 (In Normal Mode)
                6'd25: r_init_data <= {1'b0, 8'h81};
                6'd26: r_init_data <= {1'b1, 8'h00};
                6'd27: r_init_data <= {1'b1, 8'h18};

                // Positive Gamma Correction
                6'd28: r_init_data <= {1'b0, 8'hE0};
                6'd29: r_init_data <= {1'b1, 8'h00};
                6'd30: r_init_data <= {1'b1, 8'h1C};
                6'd31: r_init_data <= {1'b1, 8'h21};
                6'd32: r_init_data <= {1'b1, 8'h02};
                6'd33: r_init_data <= {1'b1, 8'h11};
                6'd34: r_init_data <= {1'b1, 8'h07};
                6'd35: r_init_data <= {1'b1, 8'h3D};
                6'd36: r_init_data <= {1'b1, 8'h79};
                6'd37: r_init_data <= {1'b1, 8'h4B};
                6'd38: r_init_data <= {1'b1, 8'h07};
                6'd39: r_init_data <= {1'b1, 8'h0F};
                6'd40: r_init_data <= {1'b1, 8'h0C};
                6'd41: r_init_data <= {1'b1, 8'h1B};
                6'd42: r_init_data <= {1'b1, 8'h1F};
                6'd43: r_init_data <= {1'b1, 8'h0F};

                // Negative Gamma Correction
                6'd44: r_init_data <= {1'b0, 8'hE1};
                6'd45: r_init_data <= {1'b1, 8'h00};
                6'd46: r_init_data <= {1'b1, 8'h1C};
                6'd47: r_init_data <= {1'b1, 8'h20};
                6'd48: r_init_data <= {1'b1, 8'h04};
                6'd49: r_init_data <= {1'b1, 8'h0F};
                6'd50: r_init_data <= {1'b1, 8'h04};
                6'd51: r_init_data <= {1'b1, 8'h33};
                6'd52: r_init_data <= {1'b1, 8'h45};
                6'd53: r_init_data <= {1'b1, 8'h42};
                6'd54: r_init_data <= {1'b1, 8'h04};
                6'd55: r_init_data <= {1'b1, 8'h0C};
                6'd56: r_init_data <= {1'b1, 8'h0A};
                6'd57: r_init_data <= {1'b1, 8'h22};
                6'd58: r_init_data <= {1'b1, 8'h29};
                6'd59: r_init_data <= {1'b1, 8'h0F};

                // Sleep OUT
                6'd60: r_init_data <= {1'b0, 8'h11};
                
                /* Delay 130ms */

                // Display ON
                6'd61: r_init_data <= {1'b0, 8'h29};

                default: /* Do Nothing */ ;
            endcase
        end
    end

    // 出力信号
    assign o_lcd_data       = r_init_data[7:0];
    assign o_lcd_dc         = r_init_data[8];
    assign o_lcd_wr         = r_lcd_clk;
    assign o_lcd_rst        = r_lcd_rst_out;
    assign o_lcd_init_fin   = ~r_init_busy;

endmodule
