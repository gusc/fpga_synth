`timescale 1ns / 1ps
`include "AddOperation.v"
`include "SubtractOperation.v"
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Arturs Valenieks
//
// Create Date:   04:44:08 05/27/2018
// Design Name:   EnvelopeFollower
// Module Name:   /home/osboxes/Documents/fpga_synth/EnvelopeFollowerTest.v
// Project Name:  fpga_synth
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: EnvelopeFollower
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module EnvelopeFollowerTest;

	// Inputs
	reg [11:0] inSample;
	reg inSampleReady;
	reg inIsPlaying;
	reg [11:0] velocity;

	// Outputs
	wire [11:0] outSample;

	// Instantiate the Unit Under Test (UUT)
	EnvelopeFollower uut (
		.inSample(inSample), 
		.inSampleReady(inSampleReady), 
		.inIsPlaying(inIsPlaying), 
		.velocity(velocity),
		.outSample(outSample)
	);
	// Initialize Inputs
	initial velocity = 12'hFF;
	initial inSample = 12'hAFF;
	initial inSampleReady = 0;
	initial inIsPlaying = 1;
	
	initial begin
		// initial start
		repeat(100) 
		begin
			#5; inSampleReady = ~inSampleReady;
		end
		
		// sustaining playback
		repeat(100) 
		begin
			#5; 
			inSampleReady = ~inSampleReady;
			inSample = inSample + 10;
		end
		
		repeat(100) 
		begin
			#5; 
			inSampleReady = ~inSampleReady;
			inSample = inSample - 20;
		end
		
		// stopping playback
		inIsPlaying = 0;
		
		repeat(100) 
		begin
			#5; inSampleReady = ~inSampleReady;
		end
	end
endmodule
