`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:54:24 06/02/2018
// Design Name:   DAC
// Module Name:   D:/MACIBAS/DIP-m/Sintizators/DACTest.v
// Project Name:  fpga_synth
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: DAC
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module DACTest;
	// Inputs
	reg inClk;
	reg [11:0] inSample;
	reg inSampleReady;

	// Outputs
	wire outChipSelect;
	wire outDataA;
	wire outDataB;
	wire outSerialClk;

	// Instantiate the Unit Under Test (UUT)
	DAC uut (
		.inClk(inClk), 
		.inSample(inSample),
		.inSampleReady(inSampleReady),
		.outChipSelect(outChipSelect), 
		.outDataA(outDataA), 
		.outDataB(outDataB), 
		.outSerialClk(outSerialClk)
	);

	initial begin
		// Initialize Inputs
		inClk = 0;
		inSampleReady = 1;
        
		// Add stimulus here

	end
	always begin
		#1 inClk = !inClk;
	end
	
	always begin
		#1 inSampleReady = !inSampleReady;
		#200 inSampleReady = !inSampleReady;
	end
endmodule

