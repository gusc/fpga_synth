`timescale 1ns / 1ps
`include "AddOperation.v"
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Arturs Valenieks
//
// Create Date:   05:53:37 05/27/2018
// Design Name:   AddOperation
// Module Name:   /home/osboxes/Documents/fpga_synth/AddOperationTest.v
// Project Name:  fpga_synth
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: AddOperation
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module AddOperationTest;

	// Inputs
	reg [11:0] lhs;
	reg [11:0] rhs;

	// Outputs
	wire [11:0] result;
	wire overflow;

	// Instantiate the Unit Under Test (UUT)
	AddOperation uut (
		.lhs(lhs), 
		.rhs(rhs), 
		.result(result), 
		.overflow(overflow)
	);

	initial begin
		// Initialize Inputs
		lhs = 5;
		rhs = 5;

		#5;
		rhs = 10;
		#5;
		lhs = 10;
		#5;
		rhs = 12'hFFF;
		#5;
		lhs = 12'hFFF;
		#5;
		$finish;
	end
      
endmodule

