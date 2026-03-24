module sub_bytes #(
    parameter DATA_S  = 128,
              NUM_BYTE = (DATA_S/8))
(
    input  wire [DATA_S-1:0] state_in,
    output wire [DATA_S-1:0] state_out
);
genvar i;
generate
    for (i = 0; i < NUM_BYTE; i = i + 1)
    begin : sbox_gen
        sbox si(
            .in (state_in[((NUM_BYTE-i)*8 - 1) -: 8]),
            .out(state_out[((NUM_BYTE-i)*8 - 1) -: 8])
        );
    end
endgenerate
endmodule
