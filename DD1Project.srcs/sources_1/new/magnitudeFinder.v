// Finds the magnitude of an 8 bit signed binary input

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

module magnitudeFinder( circuitInput, magnitude);
	input wire [7:0] circuitInput;
	output wire [7:0] magnitude;

	wire [7:0] twosComp;
	assign twosComp = ~circuitInput +1'b1;
	assign magnitude = (circuitInput[7]) ? twosComp : circuitInput[7:0];


endmodule