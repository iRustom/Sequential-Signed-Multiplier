// program to produce a clock with a different frequency

// Copyright (C) 2023  omarelfouly

// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

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