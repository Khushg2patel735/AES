module sbox(
    input  wire [7:0] in,
    output wire [7:0] out
);

reg [7:0] sbox_mem [0:255];

initial begin
    $readmemh("sbox.mem", sbox_mem);
end

assign out = sbox_mem[in];

endmodule
