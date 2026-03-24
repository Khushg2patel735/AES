module round_counter #(
    parameter KEY_S = 128,
              NK = (KEY_S/32),
              NR = NK+6)
(
        input wire clk,rst,
        input wire start,
        output reg [3:0]round,
        output reg done);
    always@ (posedge clk or posedge rst)
    begin :ROUND_COUNT
        if(rst)
        begin
            round <= 4'd0;
            done <= 1'b0;
        end
        
        else if(start)
        begin 
        round <= 4'd1;
        done  <= 1'b0;
        end
        else if(round !=0 && round < NR)
            begin 
            round <= round + 1;
            done <= 1'b0;
        end
        else if(round == NR)
        begin
            done <= 1'b1;
            round <= 4'd0;
        end
    end 
endmodule
