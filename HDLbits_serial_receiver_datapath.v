module SerialReceiverDatapath(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output reg [7:0] out_byte,
    output reg done

); 

    
    reg [2:0] state, next_state;
    parameter [2:0] IDLE=0, COUNT=1, DONE=2, STOP=3, WAIT=4;
  	reg [3:0] count;
    reg [7:0] data;

    // Next state logic (combinational circuit)
    always@(*) begin
        case(state)
            IDLE : next_state = (!in)? COUNT: IDLE;
            COUNT: next_state = (count==3'd7)? DONE: COUNT;
            DONE : next_state = (in)? STOP: WAIT;
            WAIT : next_state = (in)? IDLE: WAIT;
            STOP : next_state = (!in)? COUNT: IDLE;
          	default: next_state = IDLE;
        endcase    
    end    

    // State transition logic (sequential circuit)
    always@(posedge clk) begin
        if(reset)
            state <= IDLE;
        else
            state <= next_state;
    end    

    // Moore FSMD Output logic (sequential circuit)
    always@(posedge clk) begin
        case(state)
            IDLE : count <= 0;
            COUNT: count <= count+1;
            DONE : count <= 0;
            WAIT : count <= 0;
            STOP : count <= 0;
        endcase
    end

    // Moore FSMD Output logic (combinational circuit)
    assign done = (state==STOP);
    
    
    // Moore FSMD Output logic (combinational circuit)
    always@(*)begin
        case(state)
            STOP: out_byte = data;
            default: out_byte = 8'b0000_0000;
        endcase        
    end   
	
    // Moore FSMD Output logic (sequential circuit)
	always @(posedge clk) begin
    	if (reset)
        	data <= 0;
    	else if (state == COUNT)
        	data[count] <= in;
	end   
	
endmodule



//-------------------------//
// Testbench
//-------------------------//
`timescale 1ns/10ps

module SerialReceiverDatapath_tb();
  reg clk, in, reset;
  wire [7:0] out_byte;
  wire done;
  
  SerialReceiverDatapath sr_datapath1 (.*);
  
  
  always #5 clk = ~clk;
  
  initial begin
    $dumpfile("serial_receiver_datapath.vcd");
    $dumpvars(1, sr_datapath1);
  	clk=1; reset=1; in=1;
    #11 reset=0;
    #10 in=0;
    #10 in=1;
    #20 in=0;
    #10 in=1;
    #10 in=0;
    #20 in=1;
    #10 in=0;
    #10 in=1;
    #10 in=0;
    #30 $finish;    
  end  
  
  
endmodule
