// file: RISCV_tb.v
// author: @cherifsalama
// Testbench for RISCV

`timescale 1ns/1ns

module RISCV_tb;

	//Inputs
	reg clk;
	reg rst;
	//Instantiation of Unit Under Test
	RISCV uut (
		.clk(clk),
		.rst(rst),
		.ledSel(ledSel),
		.ssdSel(ssdSel),
		.leds(leds),
		.ssd(ssd)
	);

    always #50 clk = ~clk;

	initial begin
	clk = 0;
	rst = 0;
	#1
	rst = 1;
	#60
	rst = 0;
	end

endmodule
