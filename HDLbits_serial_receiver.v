module serial_receiver(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output done
); 

    reg [2:0] state, next_state;
    parameter [2:0] IDLE=0, COUNT=1, DONE=2, STOP=3, WAIT=4;
    reg [3:0] count;
    
    always@(*) begin
        case(state)
            IDLE : next_state = (!in)? COUNT: IDLE;
            COUNT: next_state = (count==3'd7)? DONE: COUNT;
            DONE : next_state = (in)? STOP: WAIT;
            WAIT : next_state = (in)? IDLE: WAIT;
            STOP : next_state = (!in)? COUNT: IDLE;
        endcase    
    end    
    
    always@(posedge clk) begin
        if(reset)
            state <= IDLE;
        else
            state <= next_state;
    end    
    
    always@(posedge clk) begin
        case(state)
            IDLE : count <= 0;
            COUNT: count <= count+1;
            DONE : count <= 0;
            WAIT : count <= 0;
            STOP : count <= 0;
        endcase
    end
    
    assign done = (state==STOP);
    
endmodule
