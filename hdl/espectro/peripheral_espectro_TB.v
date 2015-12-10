
// ============================================================================
// TESTBENCH FOR ESPECTRO
// ============================================================================

module peripheral_espectro_TB;

   reg clk;
   reg rst;
   reg [15:0]d_in;
   reg cs;
   reg [3:0]addr;
   reg rd;
   reg wr;
   wire [15:0]d_out;

  wire sound;
   reg  reset;
   reg  start;
  

peripheral_espectro uut (.clk(clk) , .rst(rst) , .d_in(d_in) , .cs(cs) , .addr(addr) , .rd(rd) , .wr(wr), .d_out(d_out), .sound(sound) );


   parameter PERIOD          = 20;
   parameter real DUTY_CYCLE = 0.5;
   parameter OFFSET          = 0;
   reg [20:0] i;
   event reset_trigger;




   initial begin  // Initialize Inputs
      clk = 0; reset = 1; start = 0; d_in = 16'd0035; addr = 16'h0000; cs=1; rd=0; wr=1;
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


				// stimulus here

       for(i=0; i<4; i=i+1) begin
         @ (posedge clk);
       end

	d_in = 16'd000;	//envio FRh
	addr = 16'h7002;
	cs=1; rd=0; wr=1;

       for(i=0; i<4; i=i+1) begin
         @ (posedge clk);
       end

	d_in = 16'd0100;	//envio fRl
	addr = 16'h7004;
	cs=1; rd=0; wr=1;

       for(i=0; i<4; i=i+1) begin
         @ (posedge clk);
       end
       #500000

	d_in = 16'd000;	//envio FRh
	addr = 16'h7002;
	cs=1; rd=0; wr=1;

       for(i=0; i<4; i=i+1) begin
         @ (posedge clk);
       end

	d_in = 16'd0500;	//envio fRl
	addr = 16'h7004;
	cs=1; rd=0; wr=1;

       for(i=0; i<4; i=i+1) begin
         @ (posedge clk);
       end


      end
   end
	 

   initial begin: TEST_CASE
     $dumpfile("peripheral_espectro_TB.vcd");
     $dumpvars(-1, uut);
	
     #10 -> reset_trigger;
     #((PERIOD*DUTY_CYCLE)*1000000) $finish;
   end

endmodule

