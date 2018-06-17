`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: LU DF (DIP-m)
// Engineer: Tomass Lacis
// 
// Create Date:    15:17:50 06/17/2018 
// Design Name: 
// Module Name:    tableSquarewave 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module tableSquarewave(phaseTopBit, squarewave);
parameter USE_UNSIGNED_TABLES = 0;
input phaseTopBit;
output reg [11:0] squarewave = 0;
always @(phaseTopBit) begin

	if (USE_UNSIGNED_TABLES)
		// (phaseTopBit == 0) => 4095
		// (phaseTopBit == 1) => 0
		squarewave = (phaseTopBit) ? 12'h0 : 12'hfff; 
	else
		// (phaseTopBit == 0) => 2047
		// (phaseTopBit == 1) => -2047
		squarewave = (phaseTopBit) ? 12'h7ff : 12'h801;
		
end
endmodule
