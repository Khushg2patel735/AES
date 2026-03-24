module state_reg #(
    parameter DATA_S  = 128,
              NUM_BYTE = (DATA_S/8))
(
    input wire clk,rst,
    input wire [DATA_S-1:0]state_in,
    output reg [DATA_S-1:0]state_out
    );
    always@(posedge clk or posedge rst)begin 
        if(rst)
        state_out <= 128'd0;
        else
        state_out <= state_in;
    end
endmodule
