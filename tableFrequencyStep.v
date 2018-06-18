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
output reg [31:0] frequency_step = 0;
always @(idx) begin

	case (idx)
	0  : frequency_step = 796175;
	1  : frequency_step = 843508;
	2  : frequency_step = 893762;
	3  : frequency_step = 946840;
	4  : frequency_step = 1003132;
	5  : frequency_step = 1062833;
	6  : frequency_step = 1126041;
	7  : frequency_step = 1192949;
	8  : frequency_step = 1263947;
	9  : frequency_step = 1339133;
	10 : frequency_step = 1418702;
	11 : frequency_step = 1503043;
	12 : frequency_step = 1592449;
	13 : frequency_step = 1687113;
	14 : frequency_step = 1787524;
	15 : frequency_step = 1893778;
	16 : frequency_step = 2006363;
	17 : frequency_step = 2125667;
	18 : frequency_step = 2252082;
	19 : frequency_step = 2385995;
	20 : frequency_step = 2527895;
	21 : frequency_step = 2678267;
	22 : frequency_step = 2837502;
	23 : frequency_step = 3006184;
	24 : frequency_step = 3184995;
	25 : frequency_step = 3374324;
	26 : frequency_step = 3575048;
	27 : frequency_step = 3787557;
	28 : frequency_step = 4012823;
	29 : frequency_step = 4251433;
	30 : frequency_step = 4504261;
	31 : frequency_step = 4772088;
	32 : frequency_step = 5055887;
	33 : frequency_step = 5356535;
	34 : frequency_step = 5675005;
	35 : frequency_step = 6012467;
	36 : frequency_step = 6369991;
	37 : frequency_step = 6748747;
	38 : frequency_step = 7150097;
	39 : frequency_step = 7575212;
	40 : frequency_step = 8025647;
	41 : frequency_step = 8502963;
	42 : frequency_step = 9008523;
	43 : frequency_step = 9544176;
	44 : frequency_step = 10111774;
	45 : frequency_step = 10713070;
	46 : frequency_step = 11350011;
	47 : frequency_step = 12024934;
	48 : frequency_step = 12739983;
	49 : frequency_step = 13497592;
	50 : frequency_step = 14300195;
	51 : frequency_step = 15150521;
	52 : frequency_step = 16051393;
	53 : frequency_step = 17005927;
	54 : frequency_step = 18017144;
	55 : frequency_step = 19088451;
	56 : frequency_step = 20223549;
	57 : frequency_step = 21426140;
	58 : frequency_step = 22700119;
	59 : frequency_step = 24049966;
	60 : frequency_step = 25480063;
	61 : frequency_step = 26995184;
	62 : frequency_step = 28600391;
	63 : frequency_step = 30301042;
	64 : frequency_step = 32102884;
	65 : frequency_step = 34011855;
	66 : frequency_step = 36034288;
	67 : frequency_step = 38177000;
	68 : frequency_step = 40447099;
	69 : frequency_step = 42852281;
	70 : frequency_step = 45400336;
	71 : frequency_step = 48100030;
	72 : frequency_step = 50960225;
	73 : frequency_step = 53990465;
	74 : frequency_step = 57200880;
	75 : frequency_step = 60602183;
	76 : frequency_step = 64205865;
	77 : frequency_step = 68023711;
	78 : frequency_step = 72068577;
	79 : frequency_step = 76354000;
	80 : frequency_step = 80894296;
	81 : frequency_step = 85704562;
	82 : frequency_step = 90800770;
	83 : frequency_step = 96200060;
	84 : frequency_step = 101920450;
	85 : frequency_step = 107980931;
	86 : frequency_step = 114401859;
	87 : frequency_step = 121204464;
	88 : frequency_step = 128411730;
	89 : frequency_step = 136047423;
	90 : frequency_step = 144137252;
	91 : frequency_step = 152708097;
	92 : frequency_step = 161788593;
	93 : frequency_step = 171409125;
	94 : frequency_step = 181601638;
	95 : frequency_step = 192400218;
	96 : frequency_step = 203840900;
	97 : frequency_step = 215961960;
	98 : frequency_step = 228803718;
	99 : frequency_step = 242409025;
	100: frequency_step = 256823461;
	101: frequency_step = 272094943;
	102: frequency_step = 288274601;
	103: frequency_step = 305416293;
	104: frequency_step = 323577284;
	105: frequency_step = 342818251;
	106: frequency_step = 363203276;
	107: frequency_step = 384800436;
	108: frequency_step = 407681899;
	109: frequency_step = 431923921;
	110: frequency_step = 457607436;
	111: frequency_step = 484818148;
	112: frequency_step = 513646923;
	113: frequency_step = 544189984;
	114: frequency_step = 576549202;
	115: frequency_step = 610832586;
	116: frequency_step = 647154666;
	117: frequency_step = 685636502;
	118: frequency_step = 726406552;
	119: frequency_step = 769600873;
	120: frequency_step = 815363798;
	121: frequency_step = 863847843;
	122: frequency_step = 915214873;
	123: frequency_step = 969636394;
	124: frequency_step = 1027293944;
	125: frequency_step = 1088380065;
	126: frequency_step = 1153098503;
	127: frequency_step = 1221665269;
	endcase

end

endmodule
