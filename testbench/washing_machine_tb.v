`timescale 1ns/1ps

module tb(

    );
    reg clk, rest, start, cloath_in;
    reg[3:0] wash_timer, drain_timer;
    wire cloath_out, wash_done, drain_done;
    
    washing_mechanie utt(clk, rest, start, cloath_in,
     cloath_out, wash_done, drain_done, wash_timer, drain_timer);
     
     initial begin 
     {clk, rest, start, cloath_in, wash_timer, drain_timer} = 1'b0;
     end
     always#5 clk = ~clk;

    initial begin
    $dumpfile("washing_machine.vcd");
    $dumpvars(0, tb);
    end
     
     initial begin
     rest = 1'b1;
     #15
     rest = 0;
     #5
    
     start = 1'b1;
     #5
      cloath_in  = 1'b1;
      wash_timer = 10;
    #10
    drain_timer = 15;
    
      
   #5 rest = 1;
   #10
   rest =  0;
     #5
    
     start = 1'b1;
     #5
      cloath_in  = 1'b1;
      wash_timer = 15;
    #10
    drain_timer = 10;
    #10 $finish;
     end
endmodule
