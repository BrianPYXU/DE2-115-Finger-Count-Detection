// Four registered stages. x/y are the adapter's registered product quotient
// corresponding to the previous clock's RGB. v1/rgb1 align with that quotient.
module hand_overlay #(parameter MIN_EXTENSION_EIGHTHS=15)(
    input wire clk,rst_n,input wire [11:0] red,green,blue,
    input wire rgb_valid,skin,binary_mode,debug_mode,
    input wire [7:0] scaled_x,scaled_y,
    input wire [39:0] debug_data,
    output reg [11:0] out_red,out_green,out_blue,output reg out_valid
);
    reg [11:0] r1,g1,b1,r2,g2,b2,r3,g3,b3;
    reg v1,v2,v3,s1,s2,s3,binary1,binary2,binary3,debug1,debug2,debug3;
    reg [8:0] dx,dy,radius,outer_radius;
    reg mark_valid;
    reg [17:0] d2,lo,hi,outer_lo,outer_hi;
    reg center3,mark3;
    wire [7:0] cx=debug_data[15:8],cy=debug_data[23:16];
    wire [8:0] radius_next=({1'b0,debug_data[31:24]}*MIN_EXTENSION_EIGHTHS)>>3;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            r1<=0;g1<=0;b1<=0;r2<=0;g2<=0;b2<=0;r3<=0;g3<=0;b3<=0;
            v1<=0;v2<=0;v3<=0;s1<=0;s2<=0;s3<=0;
            binary1<=0;binary2<=0;binary3<=0;debug1<=0;debug2<=0;debug3<=0;
            dx<=0;dy<=0;radius<=0;outer_radius<=0;mark_valid<=0;
            d2<=0;lo<=0;hi<=0;outer_lo<=0;outer_hi<=0;center3<=0;mark3<=0;
            out_red<=0;out_green<=0;out_blue<=0;out_valid<=0;
        end else begin
            r1<=red;g1<=green;b1<=blue;v1<=rgb_valid;s1<=skin;
            binary1<=binary_mode;debug1<=debug_mode;
            r2<=r1;g2<=g1;b2<=b1;v2<=v1;s2<=s1;binary2<=binary1;debug2<=debug1;
            dx<=(scaled_x>cx)?scaled_x-cx:cx-scaled_x;
            dy<=(scaled_y>cy)?scaled_y-cy:cy-scaled_y;
            radius<=radius_next;mark_valid<=debug_data[39]&&debug_data[38];
            outer_radius<={1'b0,debug_data[31:24]}<<1;
            r3<=r2;g3<=g2;b3<=b2;v3<=v2;s3<=s2;binary3<=binary2;debug3<=debug2;
            d2<=dx*dx+dy*dy;
            lo<=(radius>1)?(radius-9'd1)*(radius-9'd1):0;
            hi<=(radius+9'd1)*(radius+9'd1);
            outer_lo<=(outer_radius>1)?(outer_radius-9'd1)*(outer_radius-9'd1):0;
            outer_hi<=(outer_radius+9'd1)*(outer_radius+9'd1);
            center3<=((dx<=1)&&(dy<=4))||((dx<=4)&&(dy<=1));mark3<=mark_valid;
            out_valid<=v3;
            if(!binary3) begin out_red<=r3;out_green<=g3;out_blue<=b3;end
            else if(debug3&&mark3&&center3) begin out_red<=0;out_green<=12'hfff;out_blue<=12'hfff;end
            else if(debug3&&mark3&&d2>=lo&&d2<=hi) begin out_red<=12'hfff;out_green<=0;out_blue<=12'hfff;end
            else if(debug3&&mark3&&d2>=outer_lo&&d2<=outer_hi) begin out_red<=12'hfff;out_green<=12'hfff;out_blue<=0;end
            else begin out_red<=s3?12'hfff:0;out_green<=s3?12'hfff:0;out_blue<=s3?12'hfff:0;end
        end
    end
endmodule
