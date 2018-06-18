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
	0  : frequency_step = 877783;
	1  : frequency_step = 929967;
	2  : frequency_step = 985372;
	3  : frequency_step = 1043891;
	4  : frequency_step = 1105954;
	5  : frequency_step = 1171774;
	6  : frequency_step = 1241460;
	7  : frequency_step = 1315226;
	8  : frequency_step = 1393502;
	9  : frequency_step = 1476395;
	10 : frequency_step = 1564119;
	11 : frequency_step = 1657105;
	12 : frequency_step = 1755675;
	13 : frequency_step = 1860042;
	14 : frequency_step = 1970745;
	15 : frequency_step = 2087890;
	16 : frequency_step = 2212015;
	17 : frequency_step = 2343548;
	18 : frequency_step = 2482920;
	19 : frequency_step = 2630560;
	20 : frequency_step = 2787004;
	21 : frequency_step = 2952790;
	22 : frequency_step = 3128346;
	23 : frequency_step = 3314318;
	24 : frequency_step = 3511457;
	25 : frequency_step = 3720193;
	26 : frequency_step = 3941491;
	27 : frequency_step = 4175781;
	28 : frequency_step = 4424138;
	29 : frequency_step = 4687205;
	30 : frequency_step = 4965948;
	31 : frequency_step = 5261227;
	32 : frequency_step = 5574115;
	33 : frequency_step = 5905580;
	34 : frequency_step = 6256693;
	35 : frequency_step = 6628745;
	36 : frequency_step = 7022915;
	37 : frequency_step = 7440493;
	38 : frequency_step = 7882982;
	39 : frequency_step = 8351671;
	40 : frequency_step = 8848276;
	41 : frequency_step = 9374517;
	42 : frequency_step = 9931897;
	43 : frequency_step = 10522455;
	44 : frequency_step = 11148231;
	45 : frequency_step = 11811160;
	46 : frequency_step = 12513387;
	47 : frequency_step = 13257490;
	48 : frequency_step = 14045831;
	49 : frequency_step = 14881095;
	50 : frequency_step = 15765965;
	51 : frequency_step = 16703449;
	52 : frequency_step = 17696661;
	53 : frequency_step = 18749035;
	54 : frequency_step = 19863901;
	55 : frequency_step = 21045017;
	56 : frequency_step = 22296463;
	57 : frequency_step = 23622320;
	58 : frequency_step = 25026881;
	59 : frequency_step = 26515087;
	60 : frequency_step = 28091770;
	61 : frequency_step = 29762190;
	62 : frequency_step = 31531931;
	63 : frequency_step = 33406899;
	64 : frequency_step = 35393429;
	65 : frequency_step = 37498070;
	66 : frequency_step = 39727803;
	67 : frequency_step = 42090142;
	68 : frequency_step = 44592927;
	69 : frequency_step = 47244640;
	70 : frequency_step = 50053870;
	71 : frequency_step = 53030283;
	72 : frequency_step = 56183648;
	73 : frequency_step = 59524488;
	74 : frequency_step = 63063971;
	75 : frequency_step = 66813907;
	76 : frequency_step = 70786966;
	77 : frequency_step = 74996141;
	78 : frequency_step = 79455606;
	79 : frequency_step = 84180285;
	80 : frequency_step = 89185962;
	81 : frequency_step = 94489280;
	82 : frequency_step = 100107849;
	83 : frequency_step = 106060566;
	84 : frequency_step = 112367296;
	85 : frequency_step = 119048977;
	86 : frequency_step = 126128049;
	87 : frequency_step = 133627921;
	88 : frequency_step = 141573933;
	89 : frequency_step = 149992283;
	90 : frequency_step = 158911320;
	91 : frequency_step = 168360677;
	92 : frequency_step = 178371924;
	93 : frequency_step = 188978561;
	94 : frequency_step = 200215806;
	95 : frequency_step = 212121240;
	96 : frequency_step = 224734593;
	97 : frequency_step = 238098061;
	98 : frequency_step = 252256099;
	99 : frequency_step = 267255950;
	100: frequency_step = 283147866;
	101: frequency_step = 299984675;
	102: frequency_step = 317822748;
	103: frequency_step = 336721463;
	104: frequency_step = 356743956;
	105: frequency_step = 377957122;
	106: frequency_step = 400431612;
	107: frequency_step = 424242481;
	108: frequency_step = 449469293;
	109: frequency_step = 476196123;
	110: frequency_step = 504512198;
	111: frequency_step = 534512008;
	112: frequency_step = 566295732;
	113: frequency_step = 599969457;
	114: frequency_step = 635645496;
	115: frequency_step = 673442926;
	116: frequency_step = 713488020;
	117: frequency_step = 755914244;
	118: frequency_step = 800863224;
	119: frequency_step = 848484962;
	120: frequency_step = 898938587;
	121: frequency_step = 952392247;
	122: frequency_step = 1009024397;
	123: frequency_step = 1069024124;
	124: frequency_step = 1132591573;
	125: frequency_step = 1199939022;
	126: frequency_step = 1271291099;
	127: frequency_step = 1346885960;
	endcase

end

endmodule
