// This program is equivlant to 4 multplexers with displayControlSignal being our selection line

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




module display( displayControlSignal, bcdProduct, segBCD3, segBCD2, segBCD1);
  input wire [1:0]displayControlSignal;
  input wire [19:0]bcdProduct;
  output reg [3:0] segBCD3;
  output reg [3:0] segBCD2;
  output reg [3:0] segBCD1;
  
  localparam [1:0] start=2'b00, right=2'b01,middle=2'b10,left=2'b11;
  localparam [3:0] underScore = 4'b1111;
  
  always @(*)
  begin
    case(displayControlSignal)
      start: begin
        segBCD1 = underScore;
        segBCD2 = underScore;
        segBCD3 = underScore;
      end
      right: begin
        segBCD1 = bcdProduct[3:0];
        segBCD2 = bcdProduct[7:4];
        segBCD3 = bcdProduct[11:8];
      end
      middle: begin
        segBCD1 = bcdProduct[7:4];
        segBCD2 = bcdProduct[11:8];
        segBCD3 = bcdProduct[15:12];
      end
      left: begin
        segBCD1 = bcdProduct[11:8];
        segBCD2 = bcdProduct[15:12];
        segBCD3 = bcdProduct[19:16];
      end
    endcase
  end
endmodule