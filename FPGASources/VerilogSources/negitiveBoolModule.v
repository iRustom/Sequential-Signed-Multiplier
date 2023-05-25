// Takes in sign bits and outputs a negative product flag if the product is negative

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