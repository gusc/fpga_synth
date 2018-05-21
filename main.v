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
		output DBG_LED
    );

	wire[7:0] midi_byte;   // 8-bit MIDI byte
	wire midi_ready;       // MIDI byte successfully received
	wire[23:0] midi_freq;  // 24bit frequency * 1000
	wire[6:0] midi_vel;    // 0-127
	wire midi_play;        // Is MIDI playback active?
	MIDIIn midi(CLK_50MHZ, MIDI_IN, midi_byte, midi_ready);
	MIDIParse parser(midi_byte, midi_ready, midi_freq, midi_vel, midi_play);

	
	
	// SAMPLE GENERATOR
	wire sampleReady;
	wire [11:0] filterSample;
	SampleGenerator sampleGen(
		.inMidiFrequency(midi_freq),
		.outSample(filterSample),
		.outSampleReady(sampleReady)
	);
	
	// CONVOLUTIONAL FILTER
	wire [11:0] envelopeSample;
	ConvolutionFilter filter(
		.inSample(filterSample),
		.inSampleReady(sampleReady),
		.outSample(envelopeSample)
	);
	
	// ENVELOPE FOLLOWER
	wire [11:0] dacSample;
	EnvelopeFollower envelope(
		.inSample(envelopeSample),
		.inSampleReady(sampleReady),
		.inIsPlaying(midi_play),
		.inVelocity(midi_vel),
		.outSample(dacSample)
	);
	
endmodule
