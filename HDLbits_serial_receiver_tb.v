`timescale 1ns/10ps


module serial_receiver_tb;
  
  reg clk, reset, in;
  wire done;
  
  // Instance name is receiver1
  serial_receiver receiver1(.*);
  
  always #5 clk = ~clk;
  
  initial begin
    $dumpfile("serial_receiver.vcd");
    $dumpvars(1, receiver1);
  	clk=1; reset=1; in=1;
    #10 reset=0;
    #11 in=0;
    #90 in=1;
    #10 in=0;
    #30 $finish;
   
  end
  
endmodule
