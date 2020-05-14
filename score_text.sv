/* Set the addresses from the font_rom for "SCORE:" on the screen
	Calculate the current score and use the tens and hundreds places to determine which number should be
	printed to the screen.
*/
module score(  input Clk, Reset,
					input [2:0] curr_state,
					//input point, pointb, pointc,
					input [6:0] row, rowb, rowc,
					input [9:0] fire_count,
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
		
               output logic[10:0] score_address           // Whether current pixel belongs to Rect or background
);

//logic begin_calc;
//always_comb
//begin
//	begin_calc = pointb || pointc || point;
//end

logic [3:0] hundreds, ten_out;
//score_calculation value(.Clk, .Reset, .begin_calc, .point, .pointb, .pointc, .hundreds, .ten_out , .fire_count);
score_calculation value(.Clk, .Reset, .row, .rowb, .rowc, .hundreds, .ten_out , .fire_count);

always_comb
begin
//S
	score_address = 0;
if(DrawX >= 10'd0 && DrawX < 10'd8)
	score_address = DrawY + 16*'h017;
//C
else if(DrawX >= 10'd8 && DrawX < 10'd16)
	score_address = DrawY + 16*'h00d;
//O
else if(DrawX >= 10'd16 && DrawX < 10'd24)
	score_address = DrawY + 16*'h014;
//R
else if(DrawX >= 10'd24 && DrawX < 10'd32)
	score_address = DrawY + 16*'h016;
//E
else if(DrawX >= 10'd32 && DrawX < 10'd40)
	score_address = DrawY + 16*'h00e;	
//:
else if(DrawX >= 10'd40 && DrawX < 10'd48)
	score_address = DrawY + 16*'h00b;
	
// hundreds place
else if(DrawX >= 10'd52 && DrawX < 10'd60)
	score_address = DrawY + 16*hundreds;
// tens place
else if(DrawX >= 10'd60 && DrawX < 10'd68)
	score_address = DrawY + 16*ten_out;
// ones place
else if(DrawX >= 10'd68 && DrawX < 10'd76)
	score_address = DrawY + 16*'h000;
end



endmodule

// Calculate and set the address from the font_rom to draw the score value
// This will be instantiated in the score module above to follow the text
//Alien points: Green - 20, Pink-10, Turquoise - 30
module score_calculation(input Clk, Reset, begin_calc,
								 input [2:0] curr_state,
								// input logic point, pointb, pointc,
								 input [6:0] row, rowb, rowc,
								 input [9:0] fire_count,	 		// for accuracy points
								 output logic [3:0] hundreds, ten_out	// [7:4] - hundredths, [3:0] - tens
);

logic [6:0] tens;			
always_comb
begin
	// add up all the existing aliens and multiply by respective weights
	tens = (rowb[0] + rowb[1] + rowb[2] + rowb[3] + rowb[4] + rowb[5] + rowb[6])*3 + (row[0] + row[1] + row[2] + row[3] + row[4] + row[5] + row[6])*2 +(rowc[0] + rowc[1] + rowc[2] + rowc[3] + rowc[4] + rowc[5] + rowc[6])*1;
	// subtract the total number of available points from the score and take the 2's complement
	tens = tens - 7'd42;
	tens = (~tens + 1'b1);
	
	// manage any overflow from the tens place to the hundreds
	if(tens >= 7'd40)
	begin
		ten_out = tens - 7'd40;
		hundreds = 4'd4;
	end
	else if(tens >= 7'd30)
	begin
		ten_out = tens - 7'd30;
		hundreds = 4'd3;
	end
	else if(tens >= 7'd20)
	begin
		ten_out = tens - 7'd20;
		hundreds = 4'd2;
	end
	else if(tens >= 7'd10)
	begin
		ten_out = tens - 7'd10;
		hundreds = 4'd1;
	end
	else
	begin
		ten_out = tens;
		hundreds = 4'd0;
	end

end									
//logic [9:0] extra, a_pt;
//logic [3:0] hundreds_in, tens, tens_in;
//// If the player took fewer than 10 extra shots, bonus points are awarded
////always_comb
////begin
////	extra = fire_count - 10'd21;
////	
////	unique case(extra)
////	10'd0: a_pt = 10'd100;
////	10'd1: a_pt = 10'd90;
////	10'd2: a_pt = 10'd80;
////	10'd3: a_pt = 10'd70;
////	10'd4: a_pt = 10'd60;
////	10'd5: a_pt = 10'd50;
////	10'd6: a_pt = 10'd40;
////	10'd7: a_pt = 10'd30;
////	10'd8: a_pt = 10'd20;
////	10'd9: a_pt = 10'd10;
////	default: a_pt = 10'd0;
////	endcase
////end
//
//logic [9:0] bonus; // accuracy bonus
//always_ff @ (posedge begin_calc)
//begin 
//	
//	if(Reset || curr_state == 3'd0 || curr_state == 3'd6)
//	begin
//		hundreds <= 4'd0;
//		tens <= 4'd0;
////		bonus <= 10'd0;
//	end
//	else if(point)
//	begin
//		tens <= tens + 4'd2;
////		bonus <= a_pt;
//		if(tens > 4'd9)
//		begin
//			tens <= tens - 4'd10;
//			hundreds <= hundreds + 4'd1;
//		end
//	end
//	else if(pointb)
//	begin
//		tens <= tens + 4'd3;
////		bonus <= a_pt;
//		if(tens > 4'd9)
//		begin
//			tens <= tens - 4'd10;
//			hundreds <= hundreds + 4'd1;
//		end
//
//	end
//	else if(pointc)
//	begin
//		tens<= tens + 7'd1;
////		bonus <= a_pt;
//		if(tens > 4'd9)
//		begin
//			tens <= tens - 4'd10;
//			hundreds <= hundreds + 4'd1;
//		end
//	end
//	else 
//		begin
//		tens <= tens;
//		hundreds <= hundreds;// + hundreds_in;
////		bonus <= a_pt;
////		if(curr_state == 3'd4 && bonus > 10'd0) 	// if the player has won, add the bonus points
////		begin
////			tens <= tens + bonus;
////			bonus <= 10'd0;
//		end
//		
//	
//end
////always_comb
////	begin
////	tens_in = 4'd0;
////	hundreds_in = 4'd0;
////	ten_out = tens;
////	
////	if (tens > 4'd9)
////	begin
////		ten_out = tens - 4'd10;
////		hundreds_in = hundreds + 4'b1;
////	end
////	
////	end

endmodule
