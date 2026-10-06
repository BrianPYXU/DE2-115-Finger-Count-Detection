// Explicit dual-clock M9K, with one clock of registered read address latency.
// The owner handshake guarantees that a published bank is not written.
module hand_frame_ram #(
    parameter SIZE=19200
)(
    input wire write_clk,read_clk,write_enable,
    input wire [15:0] write_addr,read_addr,input wire write_skin,
    output wire read_skin
);
`ifdef ALTERA_RESERVED_QIS
    wire [0:0] q;
    altsyncram ram(.clock0(write_clk),.clock1(read_clk),
        .address_a(write_addr[14:0]),.address_b(read_addr[14:0]),
        .data_a(write_skin),.wren_a(write_enable),.q_b(q),
        .aclr0(1'b0),.aclr1(1'b0),.addressstall_a(1'b0),.addressstall_b(1'b0),
        .byteena_a(1'b1),.byteena_b(1'b1),
        .clocken0(1'b1),.clocken1(1'b1),.clocken2(1'b1),.clocken3(1'b1),
        .data_b(1'b0),.rden_a(1'b1),.rden_b(1'b1),.wren_b(1'b0));
    defparam ram.operation_mode="DUAL_PORT",
        ram.intended_device_family="Cyclone IV E",
        ram.width_a=1,ram.widthad_a=15,ram.numwords_a=SIZE,
        ram.width_b=1,ram.widthad_b=15,ram.numwords_b=SIZE,
        ram.width_byteena_a=1,ram.width_byteena_b=1,
        ram.address_reg_b="CLOCK1",ram.outdata_reg_b="UNREGISTERED",
        ram.outdata_aclr_b="NONE",ram.address_aclr_b="NONE",
        ram.read_during_write_mode_mixed_ports="DONT_CARE",
        ram.ram_block_type="M9K",ram.power_up_uninitialized="TRUE";
    assign read_skin=q[0];
`else
    reg memory [0:SIZE-1];reg q;
    always @(posedge write_clk) if(write_enable) memory[write_addr]<=write_skin;
    always @(posedge read_clk) q<=memory[read_addr];
    assign read_skin=q;
`endif
endmodule
