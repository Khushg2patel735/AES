module mix_columns #(
    parameter DATA_S  = 128,
              NUM_BYTE = (DATA_S/8))
(
        input wire [DATA_S-1:0] state_in,
        output wire [DATA_S-1:0] state_out
                );
function [7:0]mul2(input [7:0]a);
    begin 
        if(a[7])
            mul2 = (a << 1) ^ 8'h1b;
        else
            mul2 = a << 1;
    end
endfunction
function [7:0]mul3(input [7:0]a);
    begin 
        mul3 = mul2(a) ^ a;
end
endfunction
wire [7:0] s0  = state_in[127:120];
wire [7:0] s1  = state_in[119:112];
wire [7:0] s2  = state_in[111:104];
wire [7:0] s3  = state_in[103:96];
wire [7:0] s4  = state_in[95:88];
wire [7:0] s5  = state_in[87:80];
wire [7:0] s6  = state_in[79:72];
wire [7:0] s7  = state_in[71:64];
wire [7:0] s8  = state_in[63:56];
wire [7:0] s9  = state_in[55:48];
wire [7:0] s10 = state_in[47:40];
wire [7:0] s11 = state_in[39:32];
wire [7:0] s12 = state_in[31:24];
wire [7:0] s13 = state_in[23:16];
wire [7:0] s14 = state_in[15:8];
wire [7:0] s15 = state_in[7:0];
//coloumn 0
wire [7:0] m0 = mul2(s0) ^ mul3(s1) ^ s2 ^ s3;
wire [7:0] m1 = s0 ^ mul2(s1) ^ mul3(s2) ^ s3;
wire [7:0] m2 = s0 ^ s1 ^ mul2(s2) ^ mul3(s3);
wire [7:0] m3 = mul3(s0) ^ s1 ^ s2 ^ mul2(s3);
//coloumn 1
wire [7:0] m4 = mul2(s4) ^ mul3(s5) ^ s6 ^ s7;
wire [7:0] m5 = s4 ^ mul2(s5) ^ mul3(s6) ^ s7;
wire [7:0] m6 = s4 ^ s5 ^ mul2(s6) ^ mul3(s7);
wire [7:0] m7 = mul3(s4) ^ s5 ^ s6 ^ mul2(s7);
//coloumn 2
wire [7:0] m8 = mul2(s8) ^ mul3(s9) ^ s10 ^ s11;
wire [7:0] m9 = s8 ^ mul2(s9) ^ mul3(s10) ^ s11;
wire [7:0] m10 = s8 ^ s9 ^ mul2(s10) ^ mul3(s11);
wire [7:0] m11 = mul3(s8) ^ s9 ^ s10 ^ mul2(s11);
//coloumn 3
wire [7:0] m12 = mul2(s12) ^ mul3(s13) ^ s14 ^ s15;
wire [7:0] m13 = s12 ^ mul2(s13) ^ mul3(s14) ^ s15;
wire [7:0] m14 = s12 ^ s13 ^ mul2(s14) ^ mul3(s15);
wire [7:0] m15 = mul3(s12) ^ s13 ^ s14 ^ mul2(s15);
//state output define
assign state_out = {
    m0, m1, m2, m3,
    m4, m5, m6, m7,
    m8, m9, m10, m11,
    m12, m13, m14, m15
};
endmodule
