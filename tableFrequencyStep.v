`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: LU DF (DIP-m)
// Engineer: Tomass Lacis
// 
// Create Date:    19:35:00 06/14/2018 
// Design Name: 
// Module Name:    tableFrequencyStep 
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
module tableFrequencyStep(idx, frequency_step);

// Frequency step formula:
// (2^N * FREQ_HZ) / SAMPLE_RATE_HZ, where:
// N - phase bit width
// FREQ_HZ - note frequency (may be multiplied by additional 1000 to preserve fractions)
// SAMPLE_RATE_HZ - sampling rate frequency (may need to be multiplied by 1000 if FREQ_HZ was multiplied by 1000)
input [6:0] idx;
output reg [23:0] frequency_step = 0;
always @(idx) begin

	case (idx)
	7'd0  : frequency_step = 3110;
	7'd1  : frequency_step = 3294;
	7'd2  : frequency_step = 3491;
	7'd3  : frequency_step = 3698;
	7'd4  : frequency_step = 3918;
	7'd5  : frequency_step = 4151;
	7'd6  : frequency_step = 4398;
	7'd7  : frequency_step = 4659;
	7'd8  : frequency_step = 4937;
	7'd9  : frequency_step = 5230;
	7'd10 : frequency_step = 5541;
	7'd11 : frequency_step = 5871;
	7'd12 : frequency_step = 6220;
	7'd13 : frequency_step = 6590;
	7'd14 : frequency_step = 6982;
	7'd15 : frequency_step = 7397;
	7'd16 : frequency_step = 7837;
	7'd17 : frequency_step = 8303;
	7'd18 : frequency_step = 8797;
	7'd19 : frequency_step = 9320;
	7'd20 : frequency_step = 9874;
	7'd21 : frequency_step = 10461;
	7'd22 : frequency_step = 11083;
	7'd23 : frequency_step = 11742;
	7'd24 : frequency_step = 12441;
	7'd25 : frequency_step = 13180;
	7'd26 : frequency_step = 13965;
	7'd27 : frequency_step = 14795;
	7'd28 : frequency_step = 15675;
	7'd29 : frequency_step = 16607;
	7'd30 : frequency_step = 17594;
	7'd31 : frequency_step = 18640;
	7'd32 : frequency_step = 19749;
	7'd33 : frequency_step = 20923;
	7'd34 : frequency_step = 22167;
	7'd35 : frequency_step = 23486;
	7'd36 : frequency_step = 24882;
	7'd37 : frequency_step = 26362;
	7'd38 : frequency_step = 27930;
	7'd39 : frequency_step = 29590;
	7'd40 : frequency_step = 31350;
	7'd41 : frequency_step = 33214;
	7'd42 : frequency_step = 35189;
	7'd43 : frequency_step = 37281;
	7'd44 : frequency_step = 39499;
	7'd45 : frequency_step = 41847;
	7'd46 : frequency_step = 44335;
	7'd47 : frequency_step = 46972;
	7'd48 : frequency_step = 49765;
	7'd49 : frequency_step = 52724;
	7'd50 : frequency_step = 55860;
	7'd51 : frequency_step = 59181;
	7'd52 : frequency_step = 62700;
	7'd53 : frequency_step = 66429;
	7'd54 : frequency_step = 70379;
	7'd55 : frequency_step = 74564;
	7'd56 : frequency_step = 78998;
	7'd57 : frequency_step = 83695;
	7'd58 : frequency_step = 88672;
	7'd59 : frequency_step = 93945;
	7'd60 : frequency_step = 99531;
	7'd61 : frequency_step = 105449;
	7'd62 : frequency_step = 111720;
	7'd63 : frequency_step = 118363;
	7'd64 : frequency_step = 125401;
	7'd65 : frequency_step = 132858;
	7'd66 : frequency_step = 140758;
	7'd67 : frequency_step = 149128;
	7'd68 : frequency_step = 157996;
	7'd69 : frequency_step = 167391;
	7'd70 : frequency_step = 177345;
	7'd71 : frequency_step = 187890;
	7'd72 : frequency_step = 199063;
	7'd73 : frequency_step = 210900;
	7'd74 : frequency_step = 223440;
	7'd75 : frequency_step = 236727;
	7'd76 : frequency_step = 250804;
	7'd77 : frequency_step = 265717;
	7'd78 : frequency_step = 281517;
	7'd79 : frequency_step = 298257;
	7'd80 : frequency_step = 315993;
	7'd81 : frequency_step = 334783;
	7'd82 : frequency_step = 354690;
	7'd83 : frequency_step = 375781;
	7'd84 : frequency_step = 398126;
	7'd85 : frequency_step = 421800;
	7'd86 : frequency_step = 446882;
	7'd87 : frequency_step = 473454;
	7'd88 : frequency_step = 501608;
	7'd89 : frequency_step = 531435;
	7'd90 : frequency_step = 563036;
	7'd91 : frequency_step = 596516;
	7'd92 : frequency_step = 631986;
	7'd93 : frequency_step = 669566;
	7'd94 : frequency_step = 709381;
	7'd95 : frequency_step = 751563;
	7'd96 : frequency_step = 796253;
	7'd97 : frequency_step = 843601;
	7'd98 : frequency_step = 893764;
	7'd99 : frequency_step = 946910;
	7'd100: frequency_step = 1003216;
	7'd101: frequency_step = 1062870;
	7'd102: frequency_step = 1126072;
	7'd103: frequency_step = 1193032;
	7'd104: frequency_step = 1263973;
	7'd105: frequency_step = 1339133;
	7'd106: frequency_step = 1418762;
	7'd107: frequency_step = 1503126;
	7'd108: frequency_step = 1592507;
	7'd109: frequency_step = 1687202;
	7'd110: frequency_step = 1787529;
	7'd111: frequency_step = 1893820;
	7'd112: frequency_step = 2006433;
	7'd113: frequency_step = 2125742;
	7'd114: frequency_step = 2252145;
	7'd115: frequency_step = 2386064;
	7'd116: frequency_step = 2527947;
	7'd117: frequency_step = 2678267;
	7'd118: frequency_step = 2837525;
	7'd119: frequency_step = 3006253;
	7'd120: frequency_step = 3185014;
	7'd121: frequency_step = 3374405;
	7'd122: frequency_step = 3575058;
	7'd123: frequency_step = 3787642;
	7'd124: frequency_step = 4012866;
	7'd125: frequency_step = 4251484;
	7'd126: frequency_step = 4504291;
	7'd127: frequency_step = 4772129;
	endcase

end

endmodule
