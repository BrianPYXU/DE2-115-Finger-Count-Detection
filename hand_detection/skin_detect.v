module skin_detect (
    input  wire [11:0] iRed,
    input  wire [11:0] iGreen,
    input  wire [11:0] iBlue,
    input  wire        iDVAL,

    output wire        oSkin
);

    wire [12:0] rg_diff;
    wire [12:0] rb_diff;
    wire [12:0] gb_diff;

    assign rg_diff = {1'b0, iRed}   - {1'b0, iGreen};
    assign rb_diff = {1'b0, iRed}   - {1'b0, iBlue};
    assign gb_diff = {1'b0, iGreen} - {1'b0, iBlue};

	 assign oSkin = iDVAL && 
						 ({1'b0,iRed}>{1'b0,iGreen}+13'd100)&&
						 (iRed>12'd300);


endmodule
