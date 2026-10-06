# Existing board clocks and PLL.
create_clock -name CLOCK_50 -period 20.000 [get_ports CLOCK_50]
create_clock -name CLOCK2_50 -period 20.000 [get_ports CLOCK2_50]
create_clock -name CLOCK3_50 -period 20.000 [get_ports CLOCK3_50]
# Conservative sensor-clock bound from D5M maximum 96 MHz.
# Measure/check actual sensor PIXCLK and input timing before hardware sign-off.
create_clock -name D5M_PIXLCLK -period 10.416667 [get_ports D5M_PIXLCLK]
derive_pll_clocks
derive_clock_uncertainty
# Only first-stage toggle synchronizers are asynchronous crossings.
set_false_path -to [get_registers {*|u_buffer|ack_sync[0] *|u_buffer|request_sync[0] *u_hand_debug|ack_sync[0] *u_hand_debug|req_sync[0]}]
# Bundled payload stays stable until ack; limit transfer to one receiving clock.
set_max_delay 20.000 -from [get_registers {*|u_buffer|published_bank *|u_buffer|published_error[*]}] -to [get_registers {*|u_buffer|read_bank *|u_buffer|capture_error[*]}]
set_max_delay 10.416667 -from [get_registers {*u_hand_debug|held[*]}] -to [get_registers {*u_hand_debug|dest_data[*]}]
# Reset assertion is asynchronous, release is synchronized locally.
set_false_path -from [get_registers {*u2|oRST_1 *u2|oRST_2}] -to [get_registers {*|u_cam_reset|sync_ff[*] *|u_analysis_reset|sync_ff[*] *u_capture_reset|sync_ff[*] *u_vga_reset|sync_ff[*]}]
set_false_path -from [get_ports {KEY[0]}] -to [get_registers {*|u_cam_reset|sync_ff[*] *|u_analysis_reset|sync_ff[*] *u_capture_reset|sync_ff[*] *u_vga_reset|sync_ff[*]}]


# Actual source-divider counter is 0..2500, toggled every 2501 clocks.
create_generated_clock -name I2C_CTRL -source [get_ports CLOCK2_50] -divide_by 5002 [get_registers {*u8|mI2C_CTRL_CLK}]

# The automatic start request is synchronized in the capture clock domain.
set_false_path -to [get_registers {*auto_start_sync[0]}]

# FIFO write/read asynchronous clear is now released through the vendor's
# internal synchronization pipes (read_aclr_synch/write_aclr_synch="ON").
# Only the FIRST stages may see an asynchronous release. Later stages remain timed.
set_false_path -from [get_registers {*u2|oRST_0}] -to [get_registers {*|wraclr|dffe*a[0] *|rdaclr|dffe*a[0]}]
