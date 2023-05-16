// Program to debounce and synchronize an asynchronus signal

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

//Credit to Digital Design 1 Lab

module debouncer(clk,rst,in,out);
    input wire clk; 
    input wire rst; 
    input wire in;
    output wire out;

    reg q1,q2,q3;
    always@(posedge clk, posedge rst) begin
        if(rst == 1'b1) begin
            q1 <= 0;
            q2 <= 0;
            q3 <= 0;
        end
        else begin
            q1 <= in;
            q2 <= q1;
            q3 <= q2;
        end
    end
    assign out = (rst) ? 0 : q1&q2&q3;
    
endmodule