// Converts 15 bit binary input into 20 bit BCD output
// Copyright (C) 2023  OmarElfouly, iRustom, BavlyRemon, omaranwar1

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

// Since the Verilog code for a binary to BCD converter has yet to be uploaded we used an online version to inspire our code
// Credit to https://en.wikipedia.org/wiki/Double_dabble

module binaryToBCD (binary, BCD);
  input wire [15:0] binary; 
  output reg [20:0] BCD;

  integer i,j;
  always @(binary) begin
      BCD = 21'b0;
      BCD[15:0] = binary;
      for(i = 0; i <= 12; i = i+1)
        for(j = 0; j <= i/3; j = j+1)
          if (BCD[16-i+4*j -: 4] > 4)
            BCD[16-i+4*j -: 4] = BCD[16-i+4*j -: 4] + 4'd3;
  end

endmodule