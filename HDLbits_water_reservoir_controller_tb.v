// Code your testbench here


// 1. $dumpfile("dump.vcd");
// This defines the name and format of the output file.
// - "dump.vcd": This is the filename. .vcd stands for Variable Change Dump.
// - It is a standard text-based format that records every time a signal changes its value. You then open this specific file in your waveform viewer to see the "plots."

// 2. $dumpvars(...)
// This tells the simulator which levels of the hierarchy to record. The first number in the parentheses is the "level" or "depth."

// Option 1: $dumpvars(1, uut);
// - The 1: This means "dump only the signals inside this specific level."
// - The uut: This is the instance name of your module.
// - Result: It will record all the ports (input/output) and internal registers of uut, but it will not record any signals inside sub-modules if uut had smaller modules inside it.

// Option 2: $dumpvars(0, uut.currentState, uut.nextState);
// - The 0: In $dumpvars, a 0 is a special "wildcard." It means "dump this signal and everything inside/below it," regardless of how deep the hierarchy goes.
// - Result: This is a surgical way to tell the simulator: "I don't want every single wire in the chip; just give me these two specific internal signals (currentState and nextState) so I can debug my state machine."


`timescale 1ns/10ps


module water_reservoir_controller_tb;
  
  reg clk, reset;
  reg [3:1] s;
  wire fr3, fr2, fr1, dfr;
  
  // Instance name is controller1
  water_reservoir_controller controller1(.*);
  
  always #5 clk = ~clk;
  
  initial begin
    $dumpfile("waterReservoirController.vcd");
    $dumpvars(1, controller1);
  	clk=0; reset=0; s=0;
    #111 s=1;
    #10 s=3;
    #10 s=7;
    #20 s=3;
    #20 s=1;
    #20 s=0;
  	#14 $finish;
  end
  
endmodule
