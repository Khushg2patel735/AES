module shift_rows #(
    parameter DATA_S  = 128,
              NUM_BYTE = (DATA_S/8))
(
        input wire [DATA_S-1:0] state_in,
        output wire [DATA_S-1:0] state_out
                );
//         | s0   s4   s8   s12 |      | s0    s4   s8   s12 |
//         | s1   s5   s9   s13 |   -> | s5    s9   s13  s1  |
//         | s2   s6   s10  s14 |      | s10   s14  s2   s6  |
//         | s3   s7   s11  s15 |      | s15   s3   s7   s11 |
assign state_out[127:120] = state_in[127:120]; // s0
assign state_out[119:112] = state_in[87:80];   // s5
assign state_out[111:104] = state_in[47:40];   // s10
assign state_out[103:96]  = state_in[7:0];     // s15
assign state_out[95:88]   = state_in[95:88];   // s4
assign state_out[87:80]   = state_in[55:48];   // s9
assign state_out[79:72]   = state_in[15:8];    // s14
assign state_out[71:64]   = state_in[103:96];  // s3
assign state_out[63:56]   = state_in[63:56];   // s8
assign state_out[55:48]   = state_in[23:16];   // s13
assign state_out[47:40]   = state_in[111:104]; // s2
assign state_out[39:32]   = state_in[71:64];   // s7
assign state_out[31:24]   = state_in[31:24];   // s12
assign state_out[23:16]   = state_in[119:112]; // s1
assign state_out[15:8]    = state_in[79:72];   // s6
assign state_out[7:0]     = state_in[39:32];   // s11
endmodule
