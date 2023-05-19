// Program to debounce and synchronize an asynchronus signal

// Credit to Digital Design 1 Lab at The American University in Cairo for the following code


module debouncer(clk,rst,in,out);
    input wire clk; 
    input wire rst; 
    input wire in;
    output wire out;

    reg q1,q2,q3;
    always@(posedge clk, posedge rst) begin
        if(rst == 1'b1) begin
            q1 <= 0;
            q2 <= 0;
            q3 <= 0;
        end
        else begin
            q1 <= in;
            q2 <= q1;
            q3 <= q2;
        end
    end
    assign out = (rst) ? 0 : q1&q2&q3;
    
endmodule
