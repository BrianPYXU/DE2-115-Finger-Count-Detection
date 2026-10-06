// Current project: 800x600 RAW2RGB with two-clock DVAL latency.
// Sparse downsampling is coordinate-based; DVAL edges are NOT row edges.
module hand_stream_adapter #(
    parameter SOURCE_WIDTH=800, SOURCE_HEIGHT=600,
    parameter SCALE=5, RGB_LATENCY=2
)(
    input wire clk, rst_n, input wire [15:0] raw_x, raw_y,
    input wire [31:0] frame_id, input wire rgb_valid, skin,
    output wire sample_valid, sample_skin,
    output wire [7:0] sample_x, sample_y,
    output wire frame_start,
    output wire [15:0] rgb_x, rgb_y
);
    reg [15:0] xp [0:RGB_LATENCY-1];
    reg [15:0] yp [0:RGB_LATENCY-1];
    reg [31:0] last_frame;
    reg [RGB_LATENCY-1:0] start_pipe;
    integer k;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            last_frame<=0; start_pipe<=0;
            for(k=0;k<RGB_LATENCY;k=k+1) begin xp[k]<=0; yp[k]<=0; end
        end else begin
            last_frame<=frame_id;
            start_pipe[0]<=(frame_id!=last_frame);
            xp[0]<=raw_x; yp[0]<=raw_y;
            for(k=1;k<RGB_LATENCY;k=k+1) begin
                xp[k]<=xp[k-1]; yp[k]<=yp[k-1]; start_pipe[k]<=start_pipe[k-1];
            end
        end
    end
    assign rgb_x=xp[RGB_LATENCY-1];
    assign rgb_y=yp[RGB_LATENCY-1];
    // For SCALE=5 and ten-bit coordinates, floor(x/5) is exactly
    // (x*205)>>10 for 0..1023. Register the product before remainder tests.
    // This replaces the long 16/32-bit constant-division circuit.
    reg [17:0] x_product,y_product;
    reg [9:0] held_x,held_y;
    reg held_valid,held_skin,held_start;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            x_product<=0;y_product<=0;held_x<=0;held_y<=0;
            held_valid<=0;held_skin<=0;held_start<=0;
        end else begin
            x_product<=rgb_x[9:0]*8'd205;y_product<=rgb_y[9:0]*8'd205;
            held_x<=rgb_x[9:0];held_y<=rgb_y[9:0];
            held_valid<=rgb_valid&&(rgb_x<SOURCE_WIDTH)&&(rgb_y<SOURCE_HEIGHT);
            held_skin<=skin;held_start<=start_pipe[RGB_LATENCY-1];
        end
    end
    assign frame_start=held_start;
    assign sample_x=x_product[17:10];
    assign sample_y=y_product[17:10];
    wire [9:0] back_x=({2'd0,sample_x}<<2)+sample_x;
    wire [9:0] back_y=({2'd0,sample_y}<<2)+sample_y;
    assign sample_valid=held_valid&&(held_x==back_x)&&(held_y==back_y);
    assign sample_skin=held_skin;
endmodule
