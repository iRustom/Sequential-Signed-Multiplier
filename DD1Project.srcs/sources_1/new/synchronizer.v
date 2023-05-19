// synchronizer for asynchronus signals

// Credit to Digital design 1 lab at the Amrican University in Cairo for the following code


module synchronizer( clk, sig, sig1);
    input wire clk;
    input wire sig;
    output reg sig1;

    reg meta;
    always @(posedge clk)begin
        meta <= sig;
        sig1 <= meta;
    end
endmodule 