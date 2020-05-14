/*
	Transition through different values for RGB on each clock cycle
	These values will be used in the color_mapper module in the 
	Win state to create a colorful background effect.
*/
module colorful_win(input logic Clk, Reset,
						  input [2:0] curr_state,
								output logic [7:0] winR, winB, winG
);

always_ff @ (posedge Clk)
begin
	if (Reset || curr_state == 3'd3) 
	begin
		winR <= 8'h3f; 
		winG <= 8'h00;
		winB <= 8'h7f;
	end

	else
	begin
		winR <= winR + 8'd4; 
		winG <= winG + 8'd1;
		winB <= winB + 8'd3;
	end
end
endmodule
