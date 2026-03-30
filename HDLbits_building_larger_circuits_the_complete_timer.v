module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack );
    
    reg [3:0] state, next_state;
    reg [99:0] iteration;
    reg [99:0] cycle;
    wire [3:0] delay;
    
    parameter IDLE=0, S1=1, S11=2, S110=3, S1101=4, SHIFT1=5, SHIFT2=6, SHIFT3=7, COUNT=8, DONE=9;
    
    always@(posedge clk) begin
        if(reset)
            state <= IDLE;
        else
            state <= next_state;
    end    
    
    // NEXT State Logic
    always@(*) begin
        case(state)
            IDLE: next_state = data? S1:IDLE;
    		S1  : next_state = data? S11:IDLE;
            S11 : next_state = data? S11:S110;
            S110: next_state = data? S1101:IDLE;
            S1101: next_state = SHIFT1;
            SHIFT1: next_state = SHIFT2;
            SHIFT2: next_state = SHIFT3;
            SHIFT3: next_state = COUNT;
            COUNT: next_state = (cycle==(((delay+1)*1000)-1 ))? DONE: COUNT;
            DONE: next_state = ack? IDLE: DONE;
            default: next_state = IDLE;
        endcase        
    end    

    
    // OUTPUT Logic
    assign counting = (state==COUNT);
    assign done = (state==DONE);
    
    
    always@(posedge clk) begin
        if(state == S1101) begin
            count[3] <= data;
        	delay[3] <= data;
        end
        else if(state == SHIFT1) begin
            count[2] <= data;
        	delay[2] <= data;
        end
        else if(state == SHIFT2) begin
            count[1] <= data;
        	delay[1] <= data;
        end
        else if(state == SHIFT3) begin
            count[0] <= data;
        	delay[0] <= data;
        end
        else if(state == COUNT) begin
            if(cycle < (((delay+1)*1000)-1)) begin
                if(iteration==999)begin
                	count <= count-1;
                    iteration <= 0;
                    cycle <= cycle+1;
                end    
                else begin
                    iteration <= iteration+1;
                    cycle <= cycle+1;
                end    
            end   
            else begin
               iteration <= 0;
               cycle <= 0;
            end    
        end
        
        else begin
            iteration <= 0;
            cycle <= 0;
        end
    end    
    
endmodule
