// Top module for sequential multiplier circuit

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


module circ(inclk,inputButtonRight,inputButtonCenter,inputButtonLeft,inputMultiplier,inputMultiplicand,segments,anode_active,doneFlag);
    input wire inclk; 
    input wire inputButtonRight;
    input wire inputButtonCenter;
    input wire inputButtonLeft;
    input wire [7:0] inputMultiplier; 
    input wire [7:0] inputMultiplicand;
    output wire [6:0] segments;
    output wire [3:0] anode_active;
    output wire doneFlag;
    
    //outputs of pushButtonDetector
    wire buttonRight;
    wire buttonLeft;
    wire buttonCenter;
    wire clk; // clk from clkDivider
    
    wire constZero;
    assign constZero = 1'b0;
    clockDivider #(5000) newclkDiv(.clk(inclk), .rst(constZero), .clk_out(clk));
    
    pushButtonDetector RDetector(.clk(inclk), .rst(constZero), .uncleanInput(inputButtonRight), .cleanOutput(buttonRight));
    pushButtonDetector LDetector(.clk(inclk), .rst(constZero), .uncleanInput(inputButtonLeft), .cleanOutput(buttonLeft));
    pushButtonDetector CDetector(.clk(inclk), .rst(constZero), .uncleanInput(inputButtonCenter), .cleanOutput(buttonCenter));
    
    //Multiplier will only take the magnitude of the MP and MC
    wire [7:0] magnitudeMP;
    wire [7:0] magnitudeMC;
    
    magnitudeFinder MPMagnitudeFinder(.circuitInput(inputMultiplier),.magnitude(magnitudeMP));
    magnitudeFinder MCMagnitudeFinder(.circuitInput(inputMultiplicand),.magnitude(magnitudeMC));
    
    //Sign of the product is stored in the negative bool flag
    wire negativeProductFlag;
    negativeBoolModule SignFlagModule(.clk(clk),.signBit0(inputMultiplier[7]),.signBit1(inputMultiplicand[7]), .load_Initial(load_Initial), .negativeProductFlag(negativeProductFlag));
    
    wire load_Initial;
    wire zeroFlag; 
    wire LSB_SHRReg;
    wire [1:0] displayControlSignal; // Display is a control signal
    
    //product stores the magnitude of product in binary produced by multiplier
    wire [15:0] product;
    multiplier mult(.clk(clk),.inMP(magnitudeMP),.inMC(magnitudeMC),.load_Initial(load_Initial),.zeroFlag(zeroFlag),.LSB_SHRReg(LSB_SHRReg),.product(product));
    
    //produces control signals
    wire calculatingFlag;
    controlUnit CU(.clk(clk),.zeroFlag(zeroFlag),.LSB_SHRReg(LSB_SHRReg),.buttonRight(buttonRight),.buttonCenter(buttonCenter),.buttonLeft(buttonLeft),.load_Initial(load_Initial),.displayControlSignal(displayControlSignal),.calculatingFlag(calculatingFlag));
    
    // tells us when we are done
    assign doneFlag = calculatingFlag & zeroFlag;
    
    //converts binary product to BCD
    
    wire [19:0] bcdProduct;
    binaryToBCD binaryToBCDCirc(.binary(product),.BCD(bcdProduct));
    
    //Contols what digit is displayed on each segment using displayControlSignal
    wire [3:0] segBCD3,segBCD2,segBCD1;
    display disp(.displayControlSignal(displayControlSignal),.bcdProduct(bcdProduct), .segBCD3(segBCD3), .segBCD2(segBCD2), .segBCD1(segBCD1));
    
    SevenSegDisplay BCDtoDisplay(.inclk(inclk),.segBCD3(segBCD3),.segBCD2(segBCD2),.segBCD1(segBCD1),.product(product),.negativeProductFlag(negativeProductFlag),.anode_active(anode_active),.segments(segments));
    
    
endmodule