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
The 2’s complementors take the two binary inputs, and convert them into their magnitude. The MUX chooses whether we take the 8 bits as they are, which is in the case the sign bit is 0, indicating the input is positive, or whether we take the 8 bits 2’s complement, which is in the case the sign bit is 1, indicating that it is negative, so complementing the negative value gives us its magnitude. The selection line is, therefore, the sign bit, if 1, we complement, if 0, we take the input as is.
### Logisim

### Verilog

## Unsigned Sequential Multiplier

### Block Diagram
The shift left register is of size 16 bits and takes the multiplicand. If shifting is enabled then on each positive edge of the clock, it shifts 1-bit to the left. The register’s first 8 bits are loaded with the input from the magnitude fixer and the last 8 bits are grounded , such that when the load initial signal is high the register is loaded with its initial values. These control signals are provided by the control unit which guarantees that shifting only occurs after input has been loaded.

The shift right register is of size 8 bits and takes the multiplier. If shifting is enabled then on each positive edge of the clock, it shifts 1-bit to the right. The register’s 8 bits are loaded with the input from the magnitude fixer, such that when the load initial signal is high the register is loaded with its initial values. These control signals are provided by the control unit which guarantees that shifting only occurs after input has been loaded.

Register P can be considered an accumulator that either keeps its value or keeps its value plus the value of the shift left register. The mux chooses whether the input into the product register is 0, or is the accumulated adder which adds the left shift register along with the product. The decision to load is then controlled by b[0] (Which is the least significant bit of the shift right register), such that when b[0] is 1, we load the input into the product register, and when it is 0 we do not load anything. The control signals Li (bar) and LP are such that when the button is pressed, we load 0 into the product, if it is not pressed, then we load only when b[0] == 1.

The control unit takes the buttons and b[0] and the z-flag of the left shift register as inputs. It produces the Li, which is dependent on the BTNC being clicked, and produces LP, which is dependent on BTNC and b[0] to determine whether we load the Register P or not. It also produces the display select, which uses a finite state machine that alternates between three states, and state changes are dependent on BTNR and BTNL, determining which digits are to be displayed (rightmost, middle, leftmost), hence, scrolling through the output product. 
### Logisim

### Verilog

## Negative Register

### Block Diagram
The Neg Reg register loads the value of the sign, positive (0) or negative (1), into it, by XORing the sign bit of both inputs. This is necessary because we only want a 1 when exactly one of the inputs is negative and the other is positive, and a 0 if the signs are both the same, which implies an XOR gate. We used a register to store the value of the sign so that when the user is changing their inputs, it does not affect the sign bit on the 7-segment display, and this is done by disabling the load once the initial load of the inputs is complete, and only enabling it on a center button press.

### Logisim

### Verilog

## Binary to BCD

### Block Diagram
The double dabble function takes in the 16-bit binary product produced by the multiplier and uses combinational logic to convert that input into its 5x4-bit BCD equivalent, which is 20 bits, as each digit occupies 4-bits, and we have a total of 5 digits.
### Logisim

### Verilog

## Display

### Block Diagram
The display function takes in the 20 BCD bits, and takes in the display select provided by the control unit, which decides which 3 digits to display on the 7 segment display.

### Logisim

### Verilog

## 7 Segment function

## Block Diagram
The 7-segment function takes the 3 BCD digits, and negative bool then decodes them into their corresponding 7-segment binary bits, which then drive the display on the board, and also produces the negative or positive sign on the board. The function also alternates between the displays on the board at a high enough frequency such that all 4 segments are apparent at the same time to the naked eye. The function also displays “_” in place of the digits before a multiplication takes place.

### Logisim

### Verilog
