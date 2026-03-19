// Code your design here
module water_reservoir_controller (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
  	
); 
	// Can we plot 'nextState' and 'currentState' signal to see?
    
    // A = water level max
    // B_fall = current water level is lower than that of previous water level
    // B_rise = current water level is higher than that of previous water level
    // C_fall = current water level is lower than that of previous water level
    // C_rise = current water level is higher than that of previous water level
    // D = water level lowest
    
    reg [2:0] currentState, nextState;
    parameter [2:0] A=0, B_fall=1, B_rise=2, C_fall=3, C_rise=4, D=5;
    
    // State transition logic
    always@(*)begin
        case(currentState)
            A	  : nextState = (s[3])? A	  : B_fall;
            D	  : nextState = (s[1])? C_rise: D;
            B_fall: nextState = (s[3])? A	  : (s[2]? B_fall: C_fall);
            B_rise: nextState = (s[3])? A	  : (s[2]? B_rise: C_fall);
            C_fall: nextState = (s[2])? B_rise: (s[1]? C_fall: D);
            C_rise: nextState = (s[2])? B_rise: (s[1]? C_rise: D);
        	default: nextState = D;
        endcase
    end
    
    
    // State register
    always@(posedge clk) begin
        if(reset)
            currentState <= D;
        else
            currentState <= nextState;
    end
    
    // Output logic
    always@(*)begin
        case(currentState) 
            A	   : {fr3, fr2, fr1, dfr} = 4'b0000;
            B_fall : {fr3, fr2, fr1, dfr} = 4'b0011;   
            B_rise : {fr3, fr2, fr1, dfr} = 4'b0010;
            C_fall : {fr3, fr2, fr1, dfr} = 4'b0111;
            C_rise : {fr3, fr2, fr1, dfr} = 4'b0110;
            D	   : {fr3, fr2, fr1, dfr} = 4'b1111;
            default: {fr3, fr2, fr1, dfr} = 4'b1111;
        endcase
    end
    
    
endmodule
