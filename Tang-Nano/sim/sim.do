vlib work
vmap work work

vlog \
    -L work \
    -l vlog.log \
    -work work \
    -timescale "1ns / 100ps"  \
    -f filelist.txt 

vsim tb_top -wlf vsim.wlf -wlfcachesize 512

#add wave -r -radix hexadecimal sim:/tb_top/*

############################ WAVE ############################
configure wave -namecolwidth 300

# TOP
add wave -group top_tb /tb_top/*

# DUT
add wave -group DUT /tb_top/dut/*

# lcd_ctrl
add wave -group lcd_ctrl /tb_top/dut/lcd_ctrl/*

# lcd_init
add wave -group lcd_init /tb_top/dut/lcd_ctrl/lcd_init/*

# lcd_sushi
add wave -group lcd_sushi /tb_top/dut/lcd_ctrl/lcd_sushi/*
##############################################################

#run -all
run 150ms
WaveRestoreZoom {0 ns} {150 ms}