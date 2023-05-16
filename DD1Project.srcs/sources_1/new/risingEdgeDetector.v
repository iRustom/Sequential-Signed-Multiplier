// Detects a positive edge from an input

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

// Credit goes to Digital Design 1 Lab at AUC

module risingEdgeDetector(clk, level, tick);
    input wire clk;
    input wire level;
    output wire tick;

    reg [1:0] state, nextState;
    reg nextOut;
    localparam [1:0] zero=2'b00, positiveEdge=2'b01, one=2'b10;//localparam is not supported by vivado
    
    always @ (level or state)
    case (state)
        zero: if (level==0) nextState = zero;
            else nextState = positiveEdge;
        positiveEdge: if (level==0) nextState = zero;
            else nextState = one;
        one: if (level==0) nextState = zero;
            else nextState = one;
        default: nextState = zero;
    endcase
    
    always @ (posedge clk ) begin
        state <= nextState;
    end
    assign tick = (state==positiveEdge);
endmodule