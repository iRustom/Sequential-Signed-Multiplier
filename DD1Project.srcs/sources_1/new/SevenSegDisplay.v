// displays 3 digits and a sign, according to its inputs, on a basys 3 7segment display

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

module SevenSegDisplay(inclk,segBCD3,segBCD2,segBCD1,product,negativeProductFlag,anode_active,segments);
    input wire inclk;
    input wire [3:0] segBCD3;
    input wire [3:0] segBCD2;
    input wire [3:0] segBCD1;
    input wire [13:0] product;
    input wire negativeProductFlag;
    output reg [3:0] anode_active;
    output reg [6:0] segments;
    
    wire [1:0] toggle;
    wire TOGClk;
    clockDivider #(250000) TOGClkDiv(.clk(inclk),.rst(reset) ,.clk_out(TOGClk));
    
    wire enOn = 1'b1;
    counterModN #(2,4) binCounter2 (.clk(TOGClk),.reset(rst),.en(enOn), .count(toggle));
    
    reg [3:0] numToDisplay;
    
    localparam [3:0]  nothing = 4'b1101, negative =4'b1110, underscore = 4'b1111;
    
    always @(*)
    begin
      case(toggle)
        0: numToDisplay <= segBCD1;
        1: numToDisplay <= segBCD2;
        2: numToDisplay <= segBCD3;
        3:begin
            if(product==0)numToDisplay <=nothing;// to prevent -0
            else numToDisplay <= negativeProductFlag? negative : nothing;
        end
      endcase 
    end
    always @(*) begin
        case(toggle)
            2'b00: anode_active = 4'b1110;
            2'b01: anode_active = 4'b1101;
            2'b10: anode_active = 4'b1011;
            2'b11: anode_active = 4'b0111;
        endcase
    end
    always @(*) begin
            
      case(numToDisplay )
        0: segments = 7'b0000001;
        1: segments = 7'b1001111;
        2: segments = 7'b0010010;
        3: segments = 7'b0000110;
        4: segments = 7'b1001100;
        5: segments = 7'b0100100;
        6: segments = 7'b0100000;
        7: segments = 7'b0001111;
        8: segments = 7'b0000000;
        9: segments = 7'b0000100;
        nothing: segments =7'b1111111;
        negative: segments =7'b1111110;
        underscore: segments =7'b1110111;
        default: segments=7'b1110111;
      endcase
      
    end
endmodule 