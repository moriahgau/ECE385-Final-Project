/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */
/*
	These modules read the values of text files to create ram for the sprites.
	The alienRAM module exports the values at each pixel in the sprite. This value
	is exported to the palette module, which uses the value as an index to select
	the color to be used.
*/
 ////////////// Alien sprite data //////////////////////////////////////
module  alienRAM
(
		input [8:0] read_address,
		input Clk,

		output logic [3:0] data_Out
);

// mem has width of 1 bits and a total of 336 addresses
logic [3:0] mem [0:671];

initial
begin
	 $readmemh("alien.txt", mem);
end


always_ff @ (posedge Clk) begin

	data_Out<= mem[read_address];
end

endmodule
////////////////////////////////////////////////////////////////////////
//
///////////// Palette data /////////////////////////////////////////////
module  palette
(
		input [3:0] read_address,
		input Clk,

		output logic [23:0] data_Out
);

// mem has width of 24 bits and a total of 5 addresses
logic [23:0] mem [0:5];

initial
begin
	 $readmemh("palette.txt", mem);
end


always_ff @ (posedge Clk) begin

	data_Out<= mem[read_address];
end


endmodule
////////////////////////////////////////////////////////////////////////
////////////// Ship sprite data //////////////////////////////////////
//module  shipRAM
//(
//		input [8:0] read_address,
//		input Clk,
//
//		output logic [3:0] data_Out
//);
//
//// mem has width of 1 bits and a total of 672 addresses
//logic [3:0] mem [0:671];
//
//initial
//begin
//	 $readmemh("ship.txt", mem);
//end
//
//
//always_ff @ (posedge Clk) begin
//
//	data_Out<= mem[read_address];
//end
//
//endmodule
//////////////////////////////////////////////////////////////////////////