`timescale 1ns / 1ps

`define SIMULATION

// ============================================================================
// TESTBENCH FOR TINYCPU
// ============================================================================

module j1soc_TB ();

reg sys_clk_i, sys_rst_i;
wire  uart_tx; 
wire  uart_rx; 

j1soc uut (
	 uart_tx,  uart_tx, sys_clk_i, sys_rst_i, sound
);

initial begin //Inicializacion
  sys_clk_i   = 1;
  sys_rst_i = 1;
  #05 sys_rst_i = 0;

end

always sys_clk_i = #1 ~sys_clk_i; //clock



initial begin: TEST_CASE
  $dumpfile("j1soc_TB.vcd");
  $dumpvars(-1, uut);
  #80000 $finish;
end

endmodule
