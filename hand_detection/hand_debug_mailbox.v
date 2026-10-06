// Results are sent analysis->camera using a second acknowledged mailbox.
// If camera clock stops, a pending snapshot is held and later results wait.
module hand_debug_mailbox(
    input wire source_clk,source_rst_n,update,
    input wire [39:0] source_data,
    input wire dest_clk,dest_rst_n,
    output reg [39:0] dest_data
);
    reg [39:0] held;
    reg req,ack;
    (* altera_attribute="-name SYNCHRONIZER_IDENTIFICATION FORCED" *) reg [1:0] ack_sync,req_sync;
    always @(posedge source_clk or negedge source_rst_n) begin
        if(!source_rst_n) begin held<=0;req<=0;ack_sync<=0;end
        else begin
            ack_sync<={ack_sync[0],ack};
            if(update&&(req==ack_sync[1])) begin held<=source_data;req<=~req;end
        end
    end
    always @(posedge dest_clk or negedge dest_rst_n) begin
        if(!dest_rst_n) begin dest_data<=0;ack<=0;req_sync<=0;end
        else begin
            req_sync<={req_sync[0],req};
            if(req_sync[1]!=ack) begin dest_data<=held;ack<=req_sync[1];end
        end
    end
endmodule
