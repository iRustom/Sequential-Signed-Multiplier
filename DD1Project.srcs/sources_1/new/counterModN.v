// Program that counts up to N with the ability to take an enable signal

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

module counterModN (clk,reset,en,count);
    input clk;
    input reset;
    input en;
    output reg [x-1:0] count;

    //input clk, reset, en;
    //output reg [x-1:0] count; 
    parameter x=4, n=3;

    always @(posedge clk or posedge reset) 
    begin
        if (reset)
        begin 
            count <= 0;
        end else if(en) 
        begin
            if(count == n-1)
            begin
                count <= 0;
            end else
            begin 
                count <= count + 1;
            end
        end
    end
    
endmodule