module washing_mechanie(input clk, rest, start, cloath_in, output reg cloath_out, wash_done, 
drain_done,
 input[3:0] wash_timer, input[3:0] drain_timer
    );
    
    parameter IDLE = 3'b000;
    parameter FILL = 3'b001;
    parameter WASH = 3'b010;
    parameter DRAIN = 3'b011;
    parameter DONE = 3'b100;
     reg[3:0] wash_counter;
     reg[3:0] drain_counter;
   
    reg[3:0] ps, ns;
    // Reset and state updates occur on the rising clock edge.
    always@(posedge clk) begin
     if(rest) begin
      ps <= IDLE;
      wash_counter <= 0;
      drain_counter <= 0;
      cloath_out <= 0;
      wash_done <= 0;
      drain_done <= 0;
      end
      else begin
      ps <= ns;
   
      
      end
 end
 
 always@(posedge clk)
  begin
  case(ps)
 // Pause the wash timer until clothes are detected.
 WASH: begin 
 if(cloath_in)  begin
  if(wash_timer == wash_counter) begin
   wash_done <= 1'b1;
   wash_counter <= 0;
  end
  else
   wash_counter <= wash_counter + 1'b1;
  end
  end
 
 // Start draining only after washing is complete.
 DRAIN: begin
 if(wash_done)
   begin
   if(drain_timer == drain_counter) begin
    drain_done <= 1'b1;
    drain_counter <= 0;
    end
    else
    drain_counter <= drain_counter + 1'b1;
   end
end
  
  DONE: begin
  cloath_out <= 1'b1;
  
  end
  endcase
  end
   
  // Select the next FSM state from the current state and inputs.
  always@(*)
    begin
     case(ps) 
    IDLE: begin
      if(start)
       ns <= FILL;
       else
       ns <= IDLE;
      end
      
   
   FILL:  begin
     if(cloath_in)
    ns <= WASH;
    else
    ns <= FILL;
   
   end
   
   WASH: begin
    if(wash_done)
    ns <= DRAIN;
    else
    ns <= WASH;
   end
   
   DRAIN: begin
   if(drain_done)
   ns <= DONE;
   else
   ns <= DRAIN;
   end
   
   DONE: begin
    ns <= IDLE;
   end
      endcase
    
    
    end
endmodule
