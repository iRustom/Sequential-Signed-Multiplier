module negativeBoolModule(clk,signBit0,signBit1, load_Initial, negativeProductFlag);
    input wire clk;
    input wire signBit0;
    input wire signBit1;
    input wire load_Initial;
    output reg negativeProductFlag;
    
    
    always @(posedge clk) begin
      if(load_Initial)
        negativeProductFlag <= signBit0  ^ signBit1 ;
    end

endmodule 