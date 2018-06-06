`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Guntars, Artûrs
// 
// Create Date:    11:40:23 06/02/2018 
// Design Name: 
// Module Name:    DAC 
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
module DAC(
	input inClk,
	input [11:0]inSample,
	input inSampleReady,
	output outChipSelect,
	output outDataA,
	output outDataB,
	output outSerialClk
);
	reg chipSelect = 1;
	reg dataA = 0;

	
	reg [15:0] state = 16'b0011111111111111;
    reg serialClk = 0;
    reg write;
    integer i = 16;
    reg writeDone = 0;
	 
	 
	 
	 reg [11:0] sine [62:0];
	initial begin
		sine[0] = 2000;
		sine[1] = 2100;
		sine[2] = 2200;
		sine[3] = 2299;
		sine[4] = 2397;
		sine[5] = 2495;
		sine[6] = 2591;
		sine[7] = 2686;
		sine[8] = 2779;
		sine[9] = 2870;
		sine[10] = 2959;
		sine[11] = 3045;
		sine[12] = 3129;
		sine[13] = 3210;
		sine[14] = 3288;
		sine[15] = 3363;
		sine[16] = 3435;
		sine[17] = 3503;
		sine[18] = 3567;
		sine[19] = 3627;
		sine[20] = 3683;
		sine[21] = 3735;
		sine[22] = 3782;
		sine[23] = 3826;
		sine[24] = 3864;
		sine[25] = 3898;
		sine[26] = 3927;
		sine[27] = 3951;
		sine[28] = 3971;
		sine[29] = 3985;
		sine[30] = 3995;
		sine[31] = 4000;
		sine[32] = 3999;
		sine[33] = 3994;
		sine[34] = 3983;
		sine[35] = 3968;
		sine[36] = 3948;
		sine[37] = 3923;
		sine[38] = 3893;
		sine[39] = 3858;
		sine[40] = 3819;
		sine[41] = 3775;
		sine[42] = 3726;
		sine[43] = 3674;
		sine[44] = 3617;
		sine[45] = 3556;
		sine[46] = 3491;
		sine[47] = 3423;
		sine[48] = 3351;
		sine[49] = 3276;
		sine[50] = 3197;
		sine[51] = 3115;
		sine[52] = 3031;
		sine[53] = 2944;
		sine[54] = 2855;
		sine[55] = 2763;
		sine[56] = 2670;
		sine[57] = 2575;
		sine[58] = 2478;
		sine[59] = 2381;
		sine[60] = 2282;
		sine[61] = 2183;
		sine[62] = 2083;
	end
	integer iterator = 0;
	
	
	 always @(posedge inClk) begin
		  serialClk <= ~serialClk;
	 end
	 
	 always @(posedge inSampleReady or negedge serialClk) begin
		if(inSampleReady == 1) begin
			state[11:0] = sine[iterator];
			iterator = iterator + 1;
			if(iterator == 63) begin
				iterator = 0;
			end
			chipSelect = 0;
		end
		if(chipSelect == 1) begin
			dataA = 0;
		end
		if(serialClk == 0) begin
			if(chipSelect == 0) begin
				
				if (i == 0) begin
					i = 16;
					chipSelect = 1;
					
				end
				else begin
					dataA = state[i - 1];
					i = i - 1;
				end
				
			end
		end
	 end
	 
	
	/*always @(posedge inSampleReady) begin
		
		
		state[11:0] = sine[iterator];
		iterator = iterator + 1;
		if(iterator == 63) begin
			iterator = 0;
		end
		if(iterator == 0) begin
			state[11:0] = 12'b000000000000;
		end
		else begin
			state[11:0] = 12'b111111111111;
		end
		iterator = (iterator + 1) % 2;
	end*/

	assign outChipSelect = chipSelect;
	assign outDataA = dataA;
	assign outDataB = dataA;
	assign outSerialClk = serialClk;

endmodule
