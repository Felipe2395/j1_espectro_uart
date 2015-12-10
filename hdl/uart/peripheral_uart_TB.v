`timescale 1ns / 1ps

`define SIMULATION


module peripheral_uart_TB;

  
   reg clk;
   reg rst;
   reg start;
   reg [15:0]d_in;
   reg cs;
   reg [3:0]addr;
   reg rd;
   reg wr;
   wire [15:0]d_out;
   reg rx;
   wire tx;
	peripheral_uart uut (.clk(clk), .rst(rst), .d_in(d_in) , .cs(cs) , .addr(addr) , .rd(rd) , .wr(wr), .d_out(d_out),  .uart_tx(tx), .uart_rx(tx));   
	

   parameter PERIOD          = 20;
   parameter real DUTY_CYCLE = 0.5;
   parameter OFFSET          = 0;
   reg [20:0] i;
   event reset_trigger;


   initial begin  // Initialize Inputs; 
      rst=1; clk = 0; start = 0; d_in = 16'd0000; addr = 16'h0000; cs=1; rd=0; wr=0; 
      #300 rst=0;  
 end

   initial  begin  // Process for clk
     #OFFSET;
     forever
       begin
         clk = 1'b0;
         #(PERIOD-(PERIOD*DUTY_CYCLE)) clk = 1'b1;
         #(PERIOD*DUTY_CYCLE);
       end
   end

   initial begin // Reset the system, Start the image capture process
      forever begin 
        @ (reset_trigger);
        @ (posedge clk);
        start = 0;
        @ (posedge clk);
        start = 1;

       for(i=0; i<2; i=i+1) begin
         @ (posedge clk);
       end
          start = 0;


//////////////////////////////////////////////////////////////////////

	d_in = 16'b01001000;	//envio H
	addr = 16'h6900;
	cs=1; rd=1; wr=1;
  #150000

/////     /////     /////     /////

	d_in = 16'b01000101 ;	//envio E
	addr = 16'h6900;
	cs=1; rd=1; wr=1;
  #150000

/////     /////     /////     /////
     
	d_in = 16'b01001100;	//envio L
	addr = 16'h6900;
	cs=1; rd=1; wr=1;
  #150000

/////     /////     /////     /////

	d_in = 16'b01010000 ;	//envio P
	addr = 16'h6900;
	cs=1; rd=1; wr=1;
	#150000

/////     /////     /////     /////

	rst = 1;

      end 

 end


	 

   initial begin: TEST_CASE
     $dumpfile("peripheral_uart_TB.vcd");
     $dumpvars(-1, uut);
	
     #10 -> reset_trigger;
     #((PERIOD*DUTY_CYCLE)*70000) $finish;
   end

endmodule

