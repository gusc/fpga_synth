`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: LU DF (DIP-m)
// Engineer: Tomass Lacis
// 
// Create Date:    16:14:10 05/19/2018 
// Design Name: 
// Module Name:    SampleGenerator 
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
module SampleGenerator(
	inCLK_50MHZ,
	inWaveMode,
	inMidiFrequencyIndex,	
	outSample,
	outSampleReady
);
	// SOURCES USED: 
	// 1. http://zipcpu.com/dsp/2017/07/11/simplest-sinewave-generator.html
	
	// === PARAMETERS ===
	parameter USE_UNSIGNED_TABLES = 0; // Use unsigned versions of wavetables
	localparam N = 32; // Phase bit width
	localparam M = 12; // Sample output bit width
	// 50 MHz / 1250 => 40 000 Hz
	localparam SMPL_CLK_DIV = 1250; // Division for 50 MHz clock, used to make sample clock
	
	// === I/O ===
	input inCLK_50MHZ;
	input [1:0] inWaveMode;
	input [6:0] inMidiFrequencyIndex;
	wire [M-1:0] sample_sinewave;
	wire [M-1:0] sample_squarewave;
	wire [N-1:0] freq_step;
	wire phase_top_bit;
	wire [9:0] sampling_phase;
	output reg [M-1:0] outSample = 0;
	output reg outSampleReady = 0;
	
	// === REGISTERS ===
	reg [N-1:0] phase = 0;
	reg [15:0] sampleClockCounter = SMPL_CLK_DIV;
	reg sampleClock = 0;
	
	// === SAMPLE CLOCKER ===
	always @(posedge inCLK_50MHZ) begin
		sampleClockCounter <= !sampleClockCounter ? (SMPL_CLK_DIV - 1) : (sampleClockCounter - 1);
		sampleClock <= !sampleClockCounter; // Will be true when counter hits 0, otherwise false
	end
	
	// === SAMPLER ===
	always @(posedge inCLK_50MHZ) begin
		// Perform phase and sample update only when sample clock is high
		if (sampleClock) begin
			phase <= phase + freq_step;
			
			// Switch on sample wave mode
			case(inWaveMode)				
				// 0 - Sinewave: signed/unsigned 12 bit Sinewave lookup table from 10 phase bits (1024 unique sinewave samples)
				0: outSample <= sample_sinewave;
				// 1 - Squarewave: signed/unsigned 12 bit maximums and minimums of sample values
				1: outSample <= sample_squarewave; 
				// default - Sinewave
				default: outSample <= sample_sinewave;
			endcase
			
			// Toggle sample ready on
			outSampleReady <= 1;
		end
		else begin
			// While sample clock is low, keep sample-ready flag off
			outSampleReady <= 0;
		end
	end
	
	// === ASSIGNMENTS ===
	assign phase_top_bit = phase[N-1];
	assign sampling_phase = phase[N-1:N-10];
	
	// === TABLE MODULES ===
	tableFrequencyStep tableFrequencyStepInst(
		.idx(inMidiFrequencyIndex), 
		.frequency_step(freq_step)
	);
	
	// Create signed or unsigned sinewave table
	tableSinewave 
	#(USE_UNSIGNED_TABLES)
	tableSinewaveInst(
		.idx(sampling_phase), 
		.sinewave(sample_sinewave)
	);
	
	// Create signed or unsigned squarewave
	tableSquarewave
	#(USE_UNSIGNED_TABLES)
	tableSquarewaveInst(
		.phaseTopBit(phase_top_bit),
		.squarewave(sample_squarewave)
	);

endmodule
