module peripheral_espectro(clk , rst , d_in , cs , addr , rd , wr, d_out,  sound );
  
  input clk;
  input rst;
  input [15:0]d_in;
  input cs;
  input [3:0]addr; // 4 LSB from j1_io_addr
  input rd;
  input wr;
  output reg [15:0]d_out;

  output sound;

//------------------------------------ regs and wires-------------------------------

reg [4:0] s; 	

reg enable;

//reg rst;

reg init;

reg [31:0]fr;


//------------------------------------ regs and wires-------------------------------
always@(posedge clk)
begin
	if(rst == 1)
	begin 
		//init = 1;
		//enable = 0;
		//fr <= 32'hFFFFFFFF;	
	end
end

always @(*) begin//----address_decoder------------------
case (addr)

4'h0:begin s = (cs && wr) ? 5'b00001 : 5'b00000;end // enable
4'h2:begin s = (cs && wr) ? 5'b00010 : 5'b00000;end // frh
4'h4:begin s = (cs && wr) ? 5'b00100 : 5'b00000;end // frl
4'h6:begin s = (cs && wr) ? 5'b01000 : 5'b00000;end // init
4'h8:begin s = (cs && wr) ? 5'b10000 : 5'b00000;end //rst
default:begin s=5'b00000 ; end
endcase
end//-----------------address_decoder--------------------





always @(negedge clk) begin//-------------------- escritura de registros

enable= (s[0]) ? d_in[0]: enable; // enable
fr[31:16] = (s[1]) ? d_in : fr[31:16];	// frh
fr[15:0] = (s[2]) ? d_in : fr[15:0];	// frl
init = (s[3]) ? d_in[0] : init; //init
//rst = (s[4]) ? d_in[0] : rst;   //rst

end//------------------------------------------- escritura de registros	



espectro espectro(.clk50(clk), .rst(rst), .enable(enable), .fr(fr), .sound(sound), .init(init)); 


endmodule
