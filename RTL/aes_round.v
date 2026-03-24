module aes_round #(
    parameter DATA_S = 128,
              KEY_S = 128,
              NUM_BYTE = (DATA_S/8))
(
    input wire [DATA_S-1:0] state_in,
    input wire [KEY_S-1:0] round_key,
    output wire [DATA_S-1:0] state_out);
    wire [DATA_S-1:0]sb_out;
    wire [DATA_S-1:0]sr_out;
    wire [DATA_S-1:0]mc_out;
//Sub_Byte Operation
sub_bytes o1(
             .state_in(state_in),
             .state_out(sb_out)
            );
//Shift_Rows Operation 
shift_rows o2(
              .state_in(sb_out),
              .state_out(sr_out)
             );
//Mix Columns Operation
mix_columns o3(
               .state_in(sr_out),
               .state_out(mc_out)
              );
//Add Round Key Operation
add_round_key o4(
                .state_in(mc_out),
                .round_key(round_key),
                .state_out(state_out)
                );
endmodule
