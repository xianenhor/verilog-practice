module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output shift_ena,
    output counting,
    input done_counting,
    output done,
    input ack );
    
    reg [2:0] state, next_state;
    parameter IDLE=0, S1=1, S11=2, S110=3, S1101=4, COUNT=5, DONE=6;
    reg [2:0] count;
    
    always@(*)begin
        case(state)    
        	IDLE: next_state = data? S1:IDLE;
            S1  : next_state = data? S11:IDLE;
            S11 : next_state = data? S11:S110;
            S110: next_state = data? S1101:IDLE;
            S1101: next_state = (count==3)? COUNT: S1101;
            COUNT: next_state = done_counting? DONE: COUNT;
            DONE : next_state = ack? IDLE: DONE;
            default: next_state = IDLE;
        endcase    
    end
    
    always@(posedge clk) begin
        if(reset)
            state <= IDLE;
        else
            state <= next_state;
    end    
    
    always@(posedge clk) begin
        if(state==S1101)
            count <= count+1;
        else
            count <= 0;
    end
    
    always@(*) begin
        case(state)
            IDLE: {shift_ena,counting,done} = 3'b000;
            S1  : {shift_ena,counting,done} = 3'b000;
            S11 : {shift_ena,counting,done} = 3'b000;
            S110: {shift_ena,counting,done} = 3'b000;
            S1101: {shift_ena,counting,done} = 3'b100;
            COUNT: {shift_ena,counting,done} = 3'b010;
            DONE : {shift_ena,counting,done} = 3'b001;
            default:{shift_ena,counting,done} = 3'b000;
        endcase
    end    

endmodule
