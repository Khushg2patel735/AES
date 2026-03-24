module add_round_key #(
    parameter DATA_S = 128,
              KEY_S = 128,
              NUM_BYTE = (DATA_S/8))
(
    input [DATA_S-1:0]state_in,
    input [KEY_S-1:0]round_key,
    output [DATA_S-1:0]state_out
    );
    
    assign state_out = state_in ^ round_key;
endmodule
