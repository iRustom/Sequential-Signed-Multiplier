// Control unit for the circuit

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

module controlUnit(clk,zeroFlag, buttonRight, buttonCenter, buttonLeft, load_Initial, displayControlSignal, calculatingFlag);
    input wire clk;
    input wire zeroFlag;
    input wire buttonRight; 
    input wire buttonCenter; 
    input wire buttonLeft;
    output reg load_Initial;
    output wire [1:0] displayControlSignal;
    output reg calculatingFlag;


    reg [1:0] displayNextState;
    reg [1:0] displayState;
    
    initial 
    begin
        displayState = 2'b01;
        calculatingFlag =0;
    end
    
    localparam [1:0] right = 2'b01, middle = 2'b10, left = 2'b11;
    
    always @(*)
    begin
        case(displayState)
            right: if(buttonLeft) displayNextState = middle;
                   else displayNextState = right;

            middle: if(buttonLeft) displayNextState = left;
                    else if(buttonRight) displayNextState = right;
                    else displayNextState = middle;

            left: if(buttonRight) displayNextState = middle;
                  else displayNextState = left;
                  
            default: displayNextState = right;
        endcase
    end
    
    always @(posedge clk)
    begin
        if(load_Initial)
            displayState <= right;
        else
            displayState <= displayNextState;
    end
    
    always @(posedge clk)
    begin
        load_Initial <= buttonCenter;
    end
    
    always @(posedge clk)
    begin
            if(buttonCenter)
            begin
                calculatingFlag <= 1; 
            end
    end
    
    assign displayControlSignal = (calculatingFlag&zeroFlag & ~buttonCenter) ? displayState : 2'b00;
    
endmodule