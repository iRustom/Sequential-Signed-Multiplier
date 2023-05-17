# Digital Design I - Project II - Sequential Signed Multiplier
## Project members:
- Ahmed Ali
- Omar Elfouly
- Bavly Remon
- Omar Anwar

## Demo 1
Dr. Shalan's unisgned multiplier, found in "Lectures 19-21: RTL & ASM Charts" slide 5, was used while designing our circuit.
The bassic concept of a binary to bcd converter was taken from the double_dabbble article on wikipedia https://en.wikipedia.org/wiki/Double_dabble.

### Control Signals:
- LI => Loads the negative register and shift registers with their values simultaniously. It loads a zero to P register when it is High, else it gives the value of P + SHL_Register to register P.
- EShift => Enables shift registers (i.e. causes them to shift a single bit L/R).
- LP => a load signal that determines whether or not a value is loaded to register P.
- DS => display signal that determines which digits are displayed on the 7 seg. It choses between 4 states: Display only underscores, display rightmost digits, display center digits, display leftmost digits.

### Black boxes:
- Double dabble => it's a function that converts a binary value into its BCD equivlant. In our case it converts 16 bits into 5x4bit BCD thats then passed on to the display function. It has been implmented using combinational logic.
- Display => function that chooses which BCD digits to display based on the control signal DS. In our case it chooses 3x4bit BCD from the total 5x4bit BCD provided from the double dabble. It will output 12'b1 if ds is in dash state else it will output the BCD values to be displayed. 
- 7 segment function => takes the BCD digits provided by the Display and displays them on the three rightmost 7 segment displays on the FPGA, and takes the output of the Neg Reg, which contains information about whether or not the product is negative or not, and displays a negative sign on the leftmost 7 segment display if it is negative, nothing if not.

## Demo 2
Link to the signed multiplier Verilog code: https://cloudv.io/a/dd1_project (To be made public before we present).
Double dabbler's sequential implmentation was used to produce the binary to BCD verilog code since the function was not on blackboard yet.

## Demo 3
This inolved minor changes to the names and syntax of certain parts of our program. We also added license information.

The following is our Report on our project.

# Report on Sequential Signed Multiplier

## Magnitude Finder

### Block Diagram
![magnitudeFinderBlock](https://github.com/iRustom/Sequential-Signed-Multiplier/assets/98827931/29846ec6-0d5d-443a-991a-48cdea03094e)

The 2’s complementors take the two binary inputs, and convert them into their magnitude. The MUX chooses whether we take the 8 bits as they are, which is in the case the sign bit is 0, indicating the input is positive, or whether we take the 8 bits 2’s complement, which is in the case the sign bit is 1, indicating that it is negative, so complementing the negative value gives us its magnitude. The selection line is, therefore, the sign bit, if 1, we complement, if 0, we take the input as is.

### Logisim
![inputFixerLog](https://github.com/iRustom/Sequential-Signed-Multiplier/assets/98827931/922c55a0-fa51-45c8-a5b5-fa96a738c43e)

### Verilog

```SystemVerilog
module magnitudeFinder( circuitInput, magnitude);
	input wire [7:0] circuitInput;
	output wire [7:0] magnitude;

	wire [7:0] twosComp;
	assign twosComp = ~circuitInput +1'b1;
	assign magnitude = (circuitInput[7]) ? twosComp : circuitInput[7:0];


endmodule
```

## Unsigned Sequential Multiplier

### Block Diagram
![unsignedSequentialMultBlock](https://github.com/iRustom/Sequential-Signed-Multiplier/assets/98827931/b9fc6cd8-45ee-4129-a2ee-1d023ada2d76)

The shift left register is of size 16 bits and takes the multiplicand. If shifting is enabled then on each positive edge of the clock, it shifts 1-bit to the left. The register’s first 8 bits are loaded with the input from the magnitude fixer and the last 8 bits are grounded , such that when the load initial signal is high the register is loaded with its initial values. These control signals are provided by the control unit which guarantees that shifting only occurs after input has been loaded.

The shift right register is of size 8 bits and takes the multiplier. If shifting is enabled then on each positive edge of the clock, it shifts 1-bit to the right. The register’s 8 bits are loaded with the input from the magnitude fixer, such that when the load initial signal is high the register is loaded with its initial values. These control signals are provided by the control unit which guarantees that shifting only occurs after input has been loaded.

Register P can be considered an accumulator that either keeps its value or keeps its value plus the value of the shift left register. The mux chooses whether the input into the product register is 0, or is the accumulated adder which adds the left shift register along with the product. The decision to load is then controlled by b[0] (Which is the least significant bit of the shift right register), such that when b[0] is 1, we load the input into the product register, and when it is 0 we do not load anything. The control signals Li (bar) and LP are such that when the button is pressed, we load 0 into the product, if it is not pressed, then we load only when b[0] == 1.

The control unit takes the buttons and b[0] and the z-flag of the left shift register as inputs. It produces the Li, which is dependent on the BTNC being clicked, and produces LP, which is dependent on BTNC and b[0] to determine whether we load the Register P or not. It also produces the display select, which uses a finite state machine that alternates between three states, and state changes are dependent on BTNR and BTNL, determining which digits are to be displayed (rightmost, middle, leftmost), hence, scrolling through the output product. 
### Logisim
![seqMultLog](https://github.com/iRustom/Sequential-Signed-Multiplier/assets/98827931/1da20a83-c998-46cc-91b7-c1635c1406be)

![image](https://github.com/iRustom/Sequential-Signed-Multiplier/assets/98827931/80c37205-2b42-4b9a-946b-1ee6ff9db0b1)

### Verilog
```SystemVerilog
module multiplier( clk, inMC, inMP, load_Initial, zeroFlag, LSB_SHRReg, product);
    input wire clk;
    input wire [7:0] inMC;
    input wire [7:0] inMP;
    input wire load_Initial;
    output wire zeroFlag;
    output wire LSB_SHRReg;
    output reg [15:0] product;
    
    reg [15:0] SHLReg;
    reg [7:0] SHRReg;
    reg [15:0] nextp;
    
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

```

## Negative Register

### Block Diagram
![negBoolBlock](https://github.com/iRustom/Sequential-Signed-Multiplier/assets/98827931/625ac498-2791-42e4-991d-1b1a5000b948)

The Neg Reg register loads the value of the sign, positive (0) or negative (1), into it, by XORing the sign bit of both inputs. This is necessary because we only want a 1 when exactly one of the inputs is negative and the other is positive, and a 0 if the signs are both the same, which implies an XOR gate. We used a register to store the value of the sign so that when the user is changing their inputs, it does not affect the sign bit on the 7-segment display, and this is done by disabling the load once the initial load of the inputs is complete, and only enabling it on a center button press.

### Logisim
![negboolLog](https://github.com/iRustom/Sequential-Signed-Multiplier/assets/98827931/ad195ee8-b729-4bd3-9aa6-0d77bc1a5572)


### Verilog
```SystemVerilog

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

```
## Binary to BCD

### Block Diagram
![doubleDabbleBlock](https://github.com/iRustom/Sequential-Signed-Multiplier/assets/98827931/7f7c71bd-e279-42df-920f-3a08eba8666a)

The double dabble function takes in the 16-bit binary product produced by the multiplier and uses combinational logic to convert that input into its 5x4-bit BCD equivalent, which is 20 bits, as each digit occupies 4-bits, and we have a total of 5 digits.

### Logisim

![binToBCDlog](https://github.com/iRustom/Sequential-Signed-Multiplier/assets/98827931/3fbc931c-e264-4df1-a490-d392596ad427)

![binaryToBCDLog](https://github.com/iRustom/Sequential-Signed-Multiplier/assets/98827931/ab309d23-c036-4009-b0aa-93ad10f2a32d)

![image](https://github.com/iRustom/Sequential-Signed-Multiplier/assets/98827931/5b978e4d-d086-4b18-9cd8-db83feff1413)


### Verilog
```SystemVerilog

module binaryToBCD (binary, BCD);
  input wire [15:0] binary; 
  output reg [20:0] BCD;

  integer i,j;
  always @(binary) begin
      BCD = 21'b0;
      BCD[15:0] = binary;
      for(i = 0; i <= 12; i = i+1)
        for(j = 0; j <= i/3; j = j+1)
          if (BCD[16-i+4*j -: 4] > 4)
            BCD[16-i+4*j -: 4] = BCD[16-i+4*j -: 4] + 4'd3;
  end

endmodule

```
## Display

### Block Diagram
![displayBlock](https://github.com/iRustom/Sequential-Signed-Multiplier/assets/98827931/e77ac8dd-595a-4e28-83aa-5fce360dd4e9)

The display function takes in the 20 BCD bits, and takes in the display select provided by the control unit, which decides which 3 digits to display on the 7 segment display.

### Logisim
![image](https://github.com/iRustom/Sequential-Signed-Multiplier/assets/98827931/e421531a-464c-4fa1-bd9b-1708dc7a038f)

### Verilog
```SystemVerilog

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

```
## 7 Segment function

## Block Diagram
![7segBlock](https://github.com/iRustom/Sequential-Signed-Multiplier/assets/98827931/cc9d9668-2f6d-40c6-bf79-c1ba071afb0d)

The 7-segment function takes the 3 BCD digits, and negative bool then decodes them into their corresponding 7-segment binary bits, which then drive the display on the board, and also produces the negative or positive sign on the board. The function also alternates between the displays on the board at a high enough frequency such that all 4 segments are apparent at the same time to the naked eye. The function also displays “_” in place of the digits before a multiplication takes place.

### Logisim
![image](https://github.com/iRustom/Sequential-Signed-Multiplier/assets/98827931/d88a81be-c5d3-4c78-b4ca-0c50832423be)


### Verilog
```SystemVerilog

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
    clockDivider #(50000) TOGClkDiv(.clk(inclk),.rst(reset) ,.clk_out(TOGClk));
    
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

```
