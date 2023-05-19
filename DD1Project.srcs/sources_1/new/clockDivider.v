// program to produce a clock with a different frequency

// Credit to Digital Design 1 Lab at The American University in Cairo for the following code

module clockDivider #(parameter n = 5000000)(clk,rst,clk_out);
  input wire clk;
  input wire rst;
  output reg clk_out;

  reg [31:0] count;
  always @ (posedge clk, posedge rst) begin
    if (rst == 1'b1) // Asynchronous Reset
      count <= 32'b0;
    else if (count == n-1)
      count <= 32'b0;
    else
      count <= count + 1;
  end
  always @ (posedge clk, posedge rst) begin
    if (rst) // Asynchronous Reset
      clk_out <= 0;
    else if (count == n-1)
      clk_out <= ~ clk_out;
    end
endmodule
