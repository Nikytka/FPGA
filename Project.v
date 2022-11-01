module Project(

    input CLK,
    output DS_EN1, DS_EN2, DS_EN3, DS_EN4,
    output DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G
	 
);

wire [15:0]d;
wire [3:0]anodes;
assign {DS_EN1, DS_EN2, DS_EN3, DS_EN4} = ~anodes;
wire [6:0]segments;
assign {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = segments;
clk_div clk_div(.clk_in(CLK), .clk_out(clk2)); 
clk_div #(.X(26)) clk_div2(.clk_in(CLK), .clk_out(clk3)); 
hex_display hd(.clk(clk2), .data(d), .anodes(anodes), .segments(segments));
counter counter(.clk(clk3), .q(d)); 

endmodule

module counter(
     input clk,
     output reg [15:0]q
);


always @(posedge clk) begin

    q <= q + 4'h1;
	 
    
end

endmodule

module clk_div #(parameter X = 13)(

    input clk_in,
    output clk_out
	 
);

reg [X-1:0]cnt = 0;

assign clk_out = cnt[X-1];

always @(posedge clk_in) begin

    cnt <= cnt + 1;
	 
end

endmodule

module hex_display (

    input clk,
    input [15:0]data,
    output [3:0]anodes,
    output [6:0]segments
	 
);

reg [1:0]i = 0;
assign anodes = (4'b1 << i);

always @(posedge clk) begin

    i <= i + 2'b1;
	 
end

wire [3:0]b = data[i * 4 +: 4];
hex_to_seg hex_to_seg(.data(b), .segments(segments));

endmodule

module hex_to_seg (

    input [3:0]data,
    output reg [6:0]segments
	 
);

always @(*) begin

    case (data)
	 
        4'h0: segments = 7'b1111110;
        4'h1: segments = 7'b0110000;
        4'h2: segments = 7'b1101101;
        4'h3: segments = 7'b1111001;
        4'h4: segments = 7'b0110011;
        4'h5: segments = 7'b1011011;
        4'h6: segments = 7'b1011111;
        4'h7: segments = 7'b1110000;
        4'h8: segments = 7'b1111111;
        4'h9: segments = 7'b1111011;
        4'hA: segments = 7'b1110111;
        4'hB: segments = 7'b0011111;
        4'hC: segments = 7'b1001110;
        4'hD: segments = 7'b0111101;
        4'hE: segments = 7'b1101111;
        4'hF: segments = 7'b1000111;
		  
    endcase
	 
end

endmodule
