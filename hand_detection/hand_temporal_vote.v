// Sliding window: invalid results never vote as zero.
// Valid no-hand frames clear both history and display immediately.
module hand_temporal_vote #(
    parameter WINDOW=8, THRESHOLD=5, INVALID_LIMIT=6,
    parameter MOVE_LIMIT=20
)(
    input wire clk, rst_n, done, result_valid, present,
    input wire [3:0] raw_count, input wire [7:0] palm_x,palm_y,
    output reg [3:0] count, output reg display_valid,
    output reg [3:0] support
);
    reg [3:0] history [0:WINDOW-1];
    reg [7:0] hist [0:5];
    integer pointer, fill, invalid_frames;
    integer i;
    reg scanning;
    reg [2:0] scan_index,scan_best;
    reg [7:0] scan_votes;
    reg [7:0] old_x,old_y;
    reg tracked;
    wire [8:0] dx=(palm_x>old_x)?(palm_x-old_x):(old_x-palm_x);
    wire [8:0] dy=(palm_y>old_y)?(palm_y-old_y):(old_y-palm_y);
    wire moved=tracked&&((dx>MOVE_LIMIT)||(dy>MOVE_LIMIT));
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            count<=0;display_valid<=0;support<=0;
            pointer<=0;fill<=0;invalid_frames<=0;old_x<=0;old_y<=0;tracked<=0;
            scanning<=0;scan_index<=0;scan_best<=0;scan_votes<=0;
            for(i=0;i<6;i=i+1) hist[i]<=0;
            for(i=0;i<WINDOW;i=i+1) history[i]<=0;
        end else if(done) begin
            if(result_valid&&!present) begin
                count<=0;display_valid<=1;support<=0;
                pointer<=0;fill<=0;invalid_frames<=0;tracked<=0;scanning<=0;
                for(i=0;i<6;i=i+1) hist[i]<=0;
            end else if(result_valid&&raw_count<=5) begin
                old_x<=palm_x;old_y<=palm_y;tracked<=1;invalid_frames<=0;
                for(i=0;i<6;i=i+1)
                    hist[i]<=(moved?0:hist[i])+((raw_count==i)?8'd1:8'd0)
                            -((!moved&&fill==WINDOW&&history[pointer]==i)?8'd1:8'd0);
                if(moved) begin
                    history[0]<=raw_count;pointer<=(WINDOW==1)?0:1;fill<=1;display_valid<=0;
                end else begin
                    history[pointer]<=raw_count;pointer<=(pointer==WINDOW-1)?0:pointer+1;
                    if(fill<WINDOW) fill<=fill+1;
                end
                scanning<=1;scan_index<=0;scan_best<=0;scan_votes<=0;
            end else begin
                if(invalid_frames<INVALID_LIMIT) invalid_frames<=invalid_frames+1;
                if(invalid_frames>=INVALID_LIMIT-1) begin
                    display_valid<=0;pointer<=0;fill<=0;support<=0;tracked<=0;scanning<=0;
                    for(i=0;i<6;i=i+1) hist[i]<=0;
                end
            end
        end else if(scanning) begin
            if(scan_index<6) begin
                if(hist[scan_index]>scan_votes) begin scan_votes<=hist[scan_index];scan_best<=scan_index;end
                scan_index<=scan_index+1'b1;
            end else begin
                support<=scan_votes[3:0];scanning<=0;
                if(scan_votes>=THRESHOLD) begin count<={1'b0,scan_best};display_valid<=1;end
            end
        end
    end
endmodule
