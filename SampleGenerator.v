`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
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
	inCLK,
	inSampleClockCE,
	inMidiFrequencyIndex,	
	outSample
);
	// SOURCES USED: 
	// 1. http://zipcpu.com/dsp/2017/07/11/simplest-sinewave-generator.html
	
	// === PARAMETERS ===
	parameter SAMPLE_CLOCK_RATE_HZ = 441000;
	parameter N = 24;
	parameter N_SQUARED = N * N;
	
	// === I/O ===
	input inCLK;
	input inSampleClockCE;
	input [6:0] inMidiFrequencyIndex;
	output reg [11:0] outSample;
	
	// === REGISTERS ===
	reg [N-1:0] phase = 0; // 24bit phase
	
	// === FREQUENCY STEP TABLE ==
	reg [N-1:0] frequency_step [127:0];
	initial begin
		// FREQ_HZ = 24bit frequency * 1000
		//                    N^2          FREQ_HZ    SAMPLE_CLOCK_RATE_HZ
		frequency_step[0]   = N_SQUARED * (8175     / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[1]   = N_SQUARED * (8661     / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[2]   = N_SQUARED * (9177     / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[3]   = N_SQUARED * (9722     / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[4]   = N_SQUARED * (10300    / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[5]   = N_SQUARED * (10913    / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[6]   = N_SQUARED * (11562    / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[7]   = N_SQUARED * (12249    / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[8]   = N_SQUARED * (12978    / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[9]   = N_SQUARED * (13750    / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[10]  = N_SQUARED * (14567    / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[11]  = N_SQUARED * (15433    / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[12]  = N_SQUARED * (16351    / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[13]  = N_SQUARED * (17323    / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[14]  = N_SQUARED * (18354    / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[15]  = N_SQUARED * (19445    / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[16]  = N_SQUARED * (20601    / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[17]  = N_SQUARED * (21826    / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[18]  = N_SQUARED * (23124    / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[19]  = N_SQUARED * (24499    / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[20]  = N_SQUARED * (25956    / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[21]  = N_SQUARED * (27500    / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[22]  = N_SQUARED * (29135    / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[23]  = N_SQUARED * (30867    / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[24]  = N_SQUARED * (32703    / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[25]  = N_SQUARED * (34647    / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[26]  = N_SQUARED * (36708    / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[27]  = N_SQUARED * (38890    / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[28]  = N_SQUARED * (41203    / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[29]  = N_SQUARED * (43653    / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[30]  = N_SQUARED * (46249    / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[31]  = N_SQUARED * (48999    / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[32]  = N_SQUARED * (51913    / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[33]  = N_SQUARED * (55000    / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[34]  = N_SQUARED * (58270    / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[35]  = N_SQUARED * (61735    / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[36]  = N_SQUARED * (65406    / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[37]  = N_SQUARED * (69295    / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[38]  = N_SQUARED * (73416    / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[39]  = N_SQUARED * (77781    / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[40]  = N_SQUARED * (82406    / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[41]  = N_SQUARED * (87307    / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[42]  = N_SQUARED * (92498    / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[43]  = N_SQUARED * (97998    / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[44]  = N_SQUARED * (103826   / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[45]  = N_SQUARED * (110000   / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[46]  = N_SQUARED * (116540   / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[47]  = N_SQUARED * (123470   / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[48]  = N_SQUARED * (130812   / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[49]  = N_SQUARED * (138591   / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[50]  = N_SQUARED * (146832   / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[51]  = N_SQUARED * (155563   / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[52]  = N_SQUARED * (164813   / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[53]  = N_SQUARED * (174614   / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[54]  = N_SQUARED * (184997   / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[55]  = N_SQUARED * (195997   / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[56]  = N_SQUARED * (207652   / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[57]  = N_SQUARED * (220000   / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[58]  = N_SQUARED * (233081   / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[59]  = N_SQUARED * (246941   / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[60]  = N_SQUARED * (261625   / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[61]  = N_SQUARED * (277182   / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[62]  = N_SQUARED * (293664   / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[63]  = N_SQUARED * (311126   / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[64]  = N_SQUARED * (329627   / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[65]  = N_SQUARED * (349228   / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[66]  = N_SQUARED * (369994   / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[67]  = N_SQUARED * (391995   / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[68]  = N_SQUARED * (415304   / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[69]  = N_SQUARED * (440000   / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[70]  = N_SQUARED * (466163   / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[71]  = N_SQUARED * (493883   / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[72]  = N_SQUARED * (523251   / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[73]  = N_SQUARED * (554365   / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[74]  = N_SQUARED * (587329   / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[75]  = N_SQUARED * (622253   / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[76]  = N_SQUARED * (659255   / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[77]  = N_SQUARED * (698456   / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[78]  = N_SQUARED * (739988   / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[79]  = N_SQUARED * (783990   / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[80]  = N_SQUARED * (830609   / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[81]  = N_SQUARED * (880000   / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[82]  = N_SQUARED * (932327   / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[83]  = N_SQUARED * (987766   / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[84]  = N_SQUARED * (1046502  / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[85]  = N_SQUARED * (1108730  / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[86]  = N_SQUARED * (1174659  / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[87]  = N_SQUARED * (1244507  / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[88]  = N_SQUARED * (1318510  / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[89]  = N_SQUARED * (1396912  / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[90]  = N_SQUARED * (1479977  / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[91]  = N_SQUARED * (1567981  / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[92]  = N_SQUARED * (1661218  / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[93]  = N_SQUARED * (1760000  / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[94]  = N_SQUARED * (1864655  / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[95]  = N_SQUARED * (1975533  / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[96]  = N_SQUARED * (2093004  / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[97]  = N_SQUARED * (2217461  / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[98]  = N_SQUARED * (2349318  / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[99]  = N_SQUARED * (2489015  / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[100] = N_SQUARED * (2637020  / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[101] = N_SQUARED * (2793825  / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[102] = N_SQUARED * (2959955  / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[103] = N_SQUARED * (3135963  / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[104] = N_SQUARED * (3322437  / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[105] = N_SQUARED * (3520000  / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[106] = N_SQUARED * (3729310  / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[107] = N_SQUARED * (3951066  / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[108] = N_SQUARED * (4186009  / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[109] = N_SQUARED * (4434922  / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[110] = N_SQUARED * (4698636  / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[111] = N_SQUARED * (4978031  / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[112] = N_SQUARED * (5274040  / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[113] = N_SQUARED * (5587651  / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[114] = N_SQUARED * (5919910  / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[115] = N_SQUARED * (6271926  / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[116] = N_SQUARED * (6644875  / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[117] = N_SQUARED * (7040000  / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[118] = N_SQUARED * (7458620  / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[119] = N_SQUARED * (7902132  / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[120] = N_SQUARED * (8372018  / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[121] = N_SQUARED * (8869844  / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[122] = N_SQUARED * (9397272  / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[123] = N_SQUARED * (9956063  / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[124] = N_SQUARED * (10548081 / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[125] = N_SQUARED * (11175303 / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[126] = N_SQUARED * (11839821 / SAMPLE_CLOCK_RATE_HZ);
		frequency_step[127] = N_SQUARED * (12543853 / SAMPLE_CLOCK_RATE_HZ);
	end
	
	// === SAMPLER ===
	always @(posedge inCLK) begin
		// Perform phase update and sample output shift only when sampling is clock-enabled
		if (inSampleClockCE) begin
			phase <= phase + frequency_step[inMidiFrequencyIndex];
			outSample <= (outSample << 1) | phase[N-1];
		end
	end
endmodule
