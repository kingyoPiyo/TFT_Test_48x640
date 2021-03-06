//Copyright (C)2014-2019 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//GOWIN Version: 1.9.2.02 Beta
//Created Time: 2020-09-04 22:24:03
#**************************************************************
# Time Information
#**************************************************************



#**************************************************************
# Create Clock
#**************************************************************
create_clock -name mco -period 41.667 -waveform {0.000 20.834} [get_ports {mco}]
create_generated_clock -name clk12m -source [get_ports {mco}] -master_clock mco -divide_by 2 -multiply_by 1 [get_nets {clk12m}]


#**************************************************************
# Set Input Delay
#**************************************************************


#**************************************************************
# Set Output Delay
#**************************************************************
set_output_delay -add_delay -max -clock [get_clocks {clk12m}]  3.000 [get_ports {lcd_wr}]
set_output_delay -add_delay -min -clock [get_clocks {clk12m}]  0.000 [get_ports {lcd_wr}]
set_output_delay -add_delay -max -clock [get_clocks {clk12m}]  3.000 [get_ports {lcd_dc}]
set_output_delay -add_delay -min -clock [get_clocks {clk12m}]  0.000 [get_ports {lcd_dc}]
set_output_delay -add_delay -max -clock [get_clocks {clk12m}]  3.000 [get_ports {lcd_data[0]}]
set_output_delay -add_delay -min -clock [get_clocks {clk12m}]  0.000 [get_ports {lcd_data[0]}]
set_output_delay -add_delay -max -clock [get_clocks {clk12m}]  3.000 [get_ports {lcd_data[1]}]
set_output_delay -add_delay -min -clock [get_clocks {clk12m}]  0.000 [get_ports {lcd_data[1]}]
set_output_delay -add_delay -max -clock [get_clocks {clk12m}]  3.000 [get_ports {lcd_data[2]}]
set_output_delay -add_delay -min -clock [get_clocks {clk12m}]  0.000 [get_ports {lcd_data[2]}]
set_output_delay -add_delay -max -clock [get_clocks {clk12m}]  3.000 [get_ports {lcd_data[3]}]
set_output_delay -add_delay -min -clock [get_clocks {clk12m}]  0.000 [get_ports {lcd_data[3]}]
set_output_delay -add_delay -max -clock [get_clocks {clk12m}]  3.000 [get_ports {lcd_data[4]}]
set_output_delay -add_delay -min -clock [get_clocks {clk12m}]  0.000 [get_ports {lcd_data[4]}]
set_output_delay -add_delay -max -clock [get_clocks {clk12m}]  3.000 [get_ports {lcd_data[5]}]
set_output_delay -add_delay -min -clock [get_clocks {clk12m}]  0.000 [get_ports {lcd_data[5]}]
set_output_delay -add_delay -max -clock [get_clocks {clk12m}]  3.000 [get_ports {lcd_data[6]}]
set_output_delay -add_delay -min -clock [get_clocks {clk12m}]  0.000 [get_ports {lcd_data[6]}]
set_output_delay -add_delay -max -clock [get_clocks {clk12m}]  3.000 [get_ports {lcd_data[7]}]
set_output_delay -add_delay -min -clock [get_clocks {clk12m}]  0.000 [get_ports {lcd_data[7]}]


#**************************************************************
# Set Clock Groups
#**************************************************************


#**************************************************************
# Set False Path
#**************************************************************
set_false_path -from [get_ports {res_n}]
set_false_path -from [get_ports {btn_b}]
set_false_path -to [get_ports {lcd_rst}]
