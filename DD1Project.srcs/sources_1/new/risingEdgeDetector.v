// Detects a positive edge from an input

// Copyright (C) 2023  OmarElfouly, iRustom, BavlyRemon, omaranwar1

// Credit to Digital Design 1 Lab at The American University in Cairo for the following code

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