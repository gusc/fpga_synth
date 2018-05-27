`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Arturs Valenieks
// 
// Create Date:    05:52:16 05/27/2018 
// Design Name: 
// Module Name:    AddOperation 
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
// Calculates sum of 12 bit arrays (unsigned).
// if sum larger than 12 bits can contain then carry bit is 1 (13th bit).
// See simulation for more details.
//////////////////////////////////////////////////////////////////////////////////
module AddOperation(
    input [11:0] lhs,
    input [11:0] rhs,
    output [11:0] result,
    output overflow
    );

	assign {overflow, result} = lhs + rhs;
endmodule
