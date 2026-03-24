module key_expansion #(
    parameter KEY_S   = 128,
              NK      = (KEY_S/32),
              NR      = NK+6,
              NRK     = NR+1,
              T_NW    = 4*(NRK),
              DATA_S  = 128,
              NUM_BYTE = (DATA_S/8),
              W_S     = 32)
(
    input wire [KEY_S-1:0]round_key_in,
    input wire [3:0]round, //max round is 14 for AES-256 so i take 0-3 = 16
    output wire [KEY_S-1:0]round_key_out
    );
    wire [32-1:0] W[0:NK-1];
   
    //Round key split in to words
    genvar j;
    
    generate
    for (j=0;j<NK;j=j+1) begin : SPLIT
       assign W[j] = round_key_in[((NK-j)*32 -1) -:32];
    end
endgenerate
    
    //Rotate_word
    wire [32-1:0]rot_w;
    assign rot_w = {W[NK-1][23:0],W[NK-1][31:24]};
    //Sub_word
    wire [7:0] sb0,sb1,sb2,sb3;
        sbox s0(.in(rot_w[31:24]), .out(sb0));
        sbox s1(.in(rot_w[23:16]), .out(sb1));
        sbox s2(.in(rot_w[15:8]),  .out(sb2));
        sbox s3(.in(rot_w[7:0]),   .out(sb3));
    wire [32-1:0] sub_w;
    assign sub_w = {sb0,sb1,sb2,sb3};
   
    wire [7:0] sb4,sb5,sb6,sb7;
        sbox s4(.in(W[NK-1][31:24]),.out(sb4));
        sbox s5(.in(W[NK-1][23:16]),.out(sb5));
        sbox s6(.in(W[NK-1][15:8]), .out(sb6));
        sbox s7(.in(W[NK-1][7:0]),  .out(sb7));
    wire [32-1:0] sub_w_256;
    assign sub_w_256 = {sb4,sb5,sb6,sb7};
    //Round constant
    reg[32-1:0] rcon;
    always@(*)begin 
        case (round)
        1: rcon = 32'h01000000;
        2: rcon = 32'h02000000;
        3: rcon = 32'h04000000;
        4: rcon = 32'h08000000;
        5: rcon = 32'h10000000;
        6: rcon = 32'h20000000;
        7: rcon = 32'h40000000;
        8: rcon = 32'h80000000;
        9: rcon = 32'h1b000000;
        10: rcon = 32'h36000000;
        default: rcon = 32'h00000000;
        endcase
    end
    //operation g()
    wire [32-1:0]g;
    assign g = sub_w ^ rcon;
    wire [32-1:0] newW[0:NK-1];
    
    //word when i = 0
    assign newW[0] = W[0] ^ g;
    //word for i 1 to NK-1
    genvar i;
    generate
    for (i=1;i<NK;i=i+1) 
    begin :NEXT_WORD
        if(NK>6 && (i%NK==4))
            assign newW[i] = W[i] ^ sub_w_256; //active when AES_256
        else
            assign newW[i] = W[i] ^ newW[i-1]; 
    end
endgenerate
    //word i = 0 to NK-1 combine
    genvar k;
    
    generate
    for(k=0;k<NK;k=k+1)
    
    begin :Round_key_out
        assign round_key_out[((NK-k)*32 -1) -:32] = newW[k];
    end
    endgenerate
endmodule
