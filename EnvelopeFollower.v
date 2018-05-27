`timescale 1ns / 1ps
`include "AddOperation.v"
`include "SubtractOperation.v"
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
//////////////////////////////////////////////////////////////////////////////////
module EnvelopeFollower(
	input [11:0] inSample,
	input inSampleReady,
	input inIsPlaying,
	input [11:0] inVelocity,
	output [11:0] outSample
);
	// flag for enabling next sample
	reg isStartSampling;
	
	// state of current output
	reg [11:0] currentSample;
	
	// what will be next sample if we are starting to play
	wire [11:0] nextStartSample;
	// flag to show that next sample is in allowed uint12 range
	wire nextStartOverflow;
	
	// what will be next sample if we are stopping to play
	wire [11:0] nextEndSample;
	// flag to show that next sample is larger than zero
	wire nextEndOverflow;
	
	initial begin
		currentSample <= 0;
		isStartSampling <= 1;
	end
	
	AddOperation calcNextStartSample (
		.lhs(currentSample), 
		.rhs(inVelocity), 
		.result(nextStartSample), 
		.overflow(nextStartOverflow)
	);
	
	SubtractOperation calcNextEndSample (
		.lhs(currentSample), 
		.rhs(inVelocity), 
		.result(nextEndSample), 
		.overflow(nextEndOverflow)
	);
	
	always @(posedge inSampleReady) begin
	    if (!inIsPlaying) begin
			if (nextEndSample > 0 && !nextEndOverflow) begin
				currentSample <= nextEndSample;
			end else begin
				currentSample <= 0;
				isStartSampling <= 1;
			end
		end 
		
		if (inIsPlaying) begin
			if (nextStartSample <= inSample && !nextStartOverflow && isStartSampling) begin
				currentSample <= nextStartSample;
			end else begin
				isStartSampling <= 0;
				currentSample <= inSample;
			end
		end 
	end
	
	assign outSample = currentSample;
endmodule
