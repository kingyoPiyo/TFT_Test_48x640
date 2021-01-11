/********************************************************
* Title    : 🍣
* Date     : 2021/01/11
* Design   : kingyo
********************************************************/
module lcd_sushi (
    input   wire            i_clk,
    input   wire            i_res_n,
    output  reg     [7:0]   o_lcd_data,
    output  reg             o_lcd_wr,
    output  reg             o_lcd_dc
);

    // LCD制御クロック生成
    always @(posedge i_clk or negedge i_res_n) begin
        if (~i_res_n) begin
            o_lcd_wr <= 1'b0;
        end else begin
            o_lcd_wr <= ~o_lcd_wr;
        end
    end

    // データ生成用カウンタ
    reg     [15:0]  r_state_data_gen;
    always @(posedge i_clk or negedge i_res_n) begin
        if (~i_res_n) begin
            r_state_data_gen <= 16'd0;
        end else begin
            if (~o_lcd_wr) begin
                if (r_state_data_gen != 16'd61450) begin   // 61440 + 11 - 1
                    r_state_data_gen <= r_state_data_gen + 16'd1;
                end else begin
                    r_state_data_gen <= 16'd0;
                end
            end
        end
    end

    // X,Y座標計算
    reg     [9:0]   r_lcd_pos_x;
    reg     [5:0]   r_lcd_pos_y;
    reg     [9:0]   r_lcd_pos_x_offset;
    always @(posedge i_clk or negedge i_res_n) begin
        if (~i_res_n) begin
            r_lcd_pos_x <= 10'd0;
            r_lcd_pos_y <= 6'd0;
            r_lcd_pos_x_offset <= 10'd0;
        end else begin
            if (o_lcd_wr) begin
                if (r_state_data_gen == 16'd0) begin
                    r_lcd_pos_x <= 10'd0;
                    r_lcd_pos_y <= 6'd0;

                    // 🍣を左に移動させる
                    if (r_lcd_pos_x_offset == 10'd79) begin
                        r_lcd_pos_x_offset <= 10'd0;
                    end else begin
                        r_lcd_pos_x_offset <= r_lcd_pos_x_offset + 10'd1;
                    end

                end else if (r_state_data_gen >= 16'd11 && r_state_data_gen[0]) begin
                    if (r_lcd_pos_x == 10'd639) begin
                        r_lcd_pos_x <= 10'd0;
                        r_lcd_pos_y <= r_lcd_pos_y + 6'd1;
                    end else begin
                        r_lcd_pos_x <= r_lcd_pos_x + 10'd1;
                    end
                end
            end
        end
    end

    // 🍣出現位置制御
    reg     [11:0]  r_rom_raddr;
    reg     [9:0]   r_pos_x_fixed;
    always @(posedge i_clk or negedge i_res_n) begin
        if (~i_res_n) begin
            r_rom_raddr <= 12'd0;
            r_pos_x_fixed <= 10'd0;
        end else if (o_lcd_wr) begin
            r_pos_x_fixed <= r_lcd_pos_x + r_lcd_pos_x_offset;
            
            if (r_pos_x_fixed >= 10'd0 && r_pos_x_fixed <= 10'd48) begin
                r_rom_raddr <= r_pos_x_fixed + (r_lcd_pos_y * 6'd48);
            end

            if (r_pos_x_fixed >= 10'd80 && r_pos_x_fixed <= 10'd128) begin
                r_rom_raddr <= (r_pos_x_fixed - 10'd80) + (r_lcd_pos_y * 6'd48);
            end

            if (r_pos_x_fixed >= 10'd160 && r_pos_x_fixed <= 10'd208) begin
                r_rom_raddr <= (r_pos_x_fixed - 10'd160) + (r_lcd_pos_y * 6'd48);
            end

            if (r_pos_x_fixed >= 10'd240 && r_pos_x_fixed <= 10'd288) begin
                r_rom_raddr <= (r_pos_x_fixed - 10'd240) + (r_lcd_pos_y * 6'd48);
            end

            if (r_pos_x_fixed >= 10'd320 && r_pos_x_fixed <= 10'd368) begin
                r_rom_raddr <= (r_pos_x_fixed - 10'd320) + (r_lcd_pos_y * 6'd48);
            end

            if (r_pos_x_fixed >= 10'd400 && r_pos_x_fixed <= 10'd448) begin
                r_rom_raddr <= (r_pos_x_fixed - 10'd400) + (r_lcd_pos_y * 6'd48);
            end

            if (r_pos_x_fixed >= 10'd480 && r_pos_x_fixed <= 10'd528) begin
                r_rom_raddr <= (r_pos_x_fixed - 10'd480) + (r_lcd_pos_y * 6'd48);
            end

            if (r_pos_x_fixed >= 10'd560 && r_pos_x_fixed <= 10'd608) begin
                r_rom_raddr <= (r_pos_x_fixed - 10'd560) + (r_lcd_pos_y * 6'd48);
            end

            if (r_pos_x_fixed >= 10'd640 && r_pos_x_fixed <= 10'd688) begin
                r_rom_raddr <= (r_pos_x_fixed - 10'd640) + (r_lcd_pos_y * 6'd48);
            end

            if (r_pos_x_fixed >= 10'd720 && r_pos_x_fixed <= 10'd768) begin
                r_rom_raddr <= (r_pos_x_fixed - 10'd720) + (r_lcd_pos_y * 6'd48);
            end
        end
    end

    // 🍣ROM
    wire    [15:0]  w_lcd_rgb565;
    sushi_rom sushi (
        .i_clk ( i_clk ),
        .i_addr ( r_rom_raddr ),
        .o_data ( w_lcd_rgb565 )
    );

    // 🍣転送制御
    always @(posedge i_clk or negedge i_res_n) begin
        if (~i_res_n) begin
            o_lcd_data <= 8'h2A;
            o_lcd_dc <= 1'b0;
        end else begin
            // データ設定
            o_lcd_data <= (r_state_data_gen == 16'd0) ? 8'h2A :
                          (r_state_data_gen == 16'd1) ? 8'h00 :
                          (r_state_data_gen == 16'd2) ? 8'h00 :
                          (r_state_data_gen == 16'd3) ? 8'h01 :
                          (r_state_data_gen == 16'd4) ? 8'h3F :
                          (r_state_data_gen == 16'd5) ? 8'h2B :
                          (r_state_data_gen == 16'd6) ? 8'h00 :
                          (r_state_data_gen == 16'd7) ? 8'h00 :
                          (r_state_data_gen == 16'd8) ? 8'h00 :
                          (r_state_data_gen == 16'd9) ? 8'h5F :
                          (r_state_data_gen == 16'd10) ? 8'h2C : 
                          (r_state_data_gen[0]) ? w_lcd_rgb565[15:8] : w_lcd_rgb565[7:0];
            // DC制御
            o_lcd_dc <= (r_state_data_gen == 16'd0 || r_state_data_gen == 16'd5 || r_state_data_gen == 16'd10) ? 1'b0 : 1'b1;
        end
    end

endmodule
