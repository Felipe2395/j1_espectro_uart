module espectro(input clk50,input rst, input enable, input [31:0]fr, input init,
		output sound);

reg clk;
reg [19:0]counter1;
reg [5:0]counter2;
reg [48:0]salida = 49'b0101101111111111111101101010010000000000000100010;
reg sound;

initial begin
	clk <= 0;
	//counter1 <=1;
	counter2 <= 48;
	end
	


////////////////////////////////// ENABLE //////////////////////////
//always@(posedge enable)
initial
begin
	counter1 <= 20'b0;

end



//----------------------contador-------------------------//
always@(posedge clk)
	begin
		if(counter2 == 0)
			counter2 = 48;
		else		
			counter2 = counter2 - 1;
	end

always@(posedge clk)
	begin
		if(enable == 1)	begin 	
			sound = salida[counter2];
			end
		else 	begin
			sound = 0;
			end
	end 
//----------------------contador-------------------------//


//--------------------divisor de frecuencia----------------//
always@(posedge clk50)
	begin
		if(rst == 1)
		begin
			counter1 = 20'b0;
			//fr = 32'hFFFFFFFF;
			
		end
		else
		begin
			if(enable == 1)
			begin
				if(counter1 == fr)
					begin
					clk <= ~clk;
					counter1 = 0;
					end
				else
					begin
					counter1 = counter1 + 1;
					end
			end
		end        
	end
//----------------divisor de frecuencia-------------------//



endmodule
