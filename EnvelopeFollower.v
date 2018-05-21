`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Arturs Valenieks
// 
// Create Date:    16:23:52 05/19/2018 
// Design Name: 
// Module Name:    EnvelopeFollower 
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
module EnvelopeFollower(
	input [11:0] inSample,
	input inSampleReady,
	input inIsPlaying,
	input [6:0] inVelocity,
	
	output [11:0] outSample
);
	// Not implemented
	assign outSample = 0;
endmodule
