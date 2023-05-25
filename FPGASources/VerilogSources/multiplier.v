// Unsigned 8 bit sequential multiplier

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


module multiplier( clk, inMC, inMP, load_Initial, zeroFlag, product);
    input wire clk;
    input wire [7:0] inMC;
    input wire [7:0] inMP;
    input wire load_Initial;
    output wire zeroFlag;
    output reg [15:0] product;
    
    reg [15:0] SHLReg;
    reg [7:0] SHRReg;
    reg [15:0] nextp;
    wire LSB_SHRReg;

    initial 
    begin
        SHLReg = 16'b0;
        SHRReg = 8'b1;
        product = 16'b0;
    end
    
    always @(posedge clk)
    begin
    
        if(load_Initial)
        begin
        
        SHRReg <=inMP;
        SHLReg[15:0] <={8'b0,inMC};
        product <= 16'b0;
        
        end else
        begin
            
            SHLReg <= SHLReg <<1;
            SHRReg <= SHRReg >>1;
            
            if(LSB_SHRReg)
            begin
                product<= SHLReg+product; 
            end
        
        end
    end
    
    assign LSB_SHRReg = SHRReg[0];
    assign zeroFlag = ~|SHRReg;

endmodule