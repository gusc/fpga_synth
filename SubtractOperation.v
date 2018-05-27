`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Arturs Valenieks
// 
// Create Date:    07:22:56 05/27/2018 
// Design Name: 
// Module Name:    SubtractOperation 
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
// Always check for overflow.
// Dividion is only valid when lhs > rhs.
//////////////////////////////////////////////////////////////////////////////////
module SubtractOperation(
    input [11:0] lhs,
    input [11:0] rhs,
    output [11:0] result,
    output overflow
    );
	
	assign overflow = lhs < rhs;
	assign result = lhs - rhs;
endmodule
