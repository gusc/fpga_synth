`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Arturs Valenieks
//
// Create Date:   07:23:58 05/27/2018
// Design Name:   SubtractOperation
// Module Name:   /home/osboxes/Documents/fpga_synth/SubtractOperationTest.v
// Project Name:  fpga_synth
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: SubtractOperation
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module SubtractOperationTest;

	// Inputs
	reg [11:0] lhs;
	reg [11:0] rhs;
	
	// Outputs
	wire [11:0] result;
	wire overflow;

	// Instantiate the Unit Under Test (UUT)
	SubtractOperation uut (
		.lhs(lhs), 
		.rhs(rhs), 
		.result(result), 
		.overflow(overflow)
	);

	initial begin
		// Initialize Inputs
		lhs = 0;
		rhs = 0;

		#5; 
		lhs = 20;
		
		#5;
		rhs = 5;
		
		#5;
		
		lhs = 10;
		#5;
		
		rhs = 30;
		#5;
		$finish;
	end
      
endmodule

