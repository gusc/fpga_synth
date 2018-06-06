`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: LU
// Engineer: Arturs, Guntars, Gusts, Tomass 
// 
// Create Date:    13:41:59 05/16/2018 
// Design Name:    fpga_synth
// Module Name:    main 
// Project Name: 
// Target Devices: Spartan 3E Starter Kit + FX2-BB
// Tool versions: 
// Description: MIDI to audio synthesizer
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module main(
		input CLK_50MHZ,
		input MIDI_IN,
		output [7:0] DBG_LED
    );

	// MIDI INPUT
	wire[7:0] midiByte;   			// 8-bit MIDI byte
	wire midiReady;       			// MIDI byte successfully received
	MIDIIn midi(
		.clock(CLK_50MHZ),
		.uartStream(MIDI_IN),
		.byteOutput(midiByte),
		.byteOutputReady(midiReady)
	);
		
	// MIDI PARSER
	wire[6:0] midiFrequencyIndex; // table index for frequency_step of 24bit frequency * 1000
	wire[6:0] sampleVelocity;    	// 0-127
	wire samplePlaying;        		// Is MIDI playback active?
	wire[6:0] envAttack;
	wire[6:0] envRelease;
	wire[6:0] filterFreq;
	MIDIParse parser(
		.midiByte(midiByte),
		.midiReady(midiReady),
		.outFrequencyIndex(midiFrequencyIndex),
		.outVelocity(sampleVelocity),
		.outPlaying(samplePlaying),
		.outEnvAttack(envAttack),
		.outEnvRelease(envRelease),
		.outFilterFreq(filterFreq)
	);
	
	// MIDI Debug
	reg[7:0] dbgData;
	always @(posedge CLK_50MHZ) begin
		if (samplePlaying == 1) begin
			dbgData = filterFreq;
		end
		else begin
			dbgData = 8'h0;
		end
	end
	assign DBG_LED = dbgData;
	
	// SAMPLE GENERATOR
	wire sampleClockCE; // Sampling Clock Enable flag
	wire [11:0] filterSample;
	SampleGenerator sampleGen(
		.inCLK(CLK_50MHZ),
		.inSampleClockCE(sampleClockCE),
		.inMidiFrequencyIndex(midiFrequencyIndex),
		.outSample(filterSample)
	);
	
	// CONVOLUTIONAL FILTER
	wire [11:0] envelopeSample;
	ConvolutionFilter filter(
		.inSample(filterSample),
		.inSampleReady(sampleClockCE),
		.outSample(envelopeSample)
	);
	
	// ENVELOPE FOLLOWER
	wire [11:0] dacSample;
	EnvelopeFollower envelope(
		.inSample(envelopeSample),
		.inSampleReady(sampleClockCE),
		.inIsPlaying(samplePlaying),
		.inVelocity(sampleVelocity),
		.outSample(dacSample)
	);
	
	// Sampling is always enabled (sampling happens at every main clock's cycle)
	// TODO: May want to change this later to toggle at lower frequencies for DAC
	assign sampleClockCE = 1; 
	
endmodule
