module aes_top #(
    parameter KEY_S   = 128,
              NK      = (KEY_S/32),
              NR      = NK+6,
              NRK     = NR+1,
              T_NW    = 4*(NRK),
              DATA_S  = 128,
              NUM_BYTE= (DATA_S/8),
              W_S     = 32)
    (
    input wire clk,rst,
    input wire start,
    input wire [DATA_S-1:0] plain_text,
    input wire [KEY_S-1:0]  cipher_key,
    output wire [DATA_S-1:0] cipher_text,
    output wire done
    );
    
    wire [3:0] round;
    wire [KEY_S-1:0]  round_key;
    wire [KEY_S-1:0] key_next;
    wire [KEY_S-1:0]  next_key;
    wire [KEY_S-1:0] key_reg_out;
    wire [DATA_S-1:0] state_reg_out;
    wire [DATA_S-1:0] state_next;
    wire [DATA_S-1:0] init_add_round_out;
    wire [DATA_S-1:0] round_out;
    wire [DATA_S-1:0] final_out;
    
    round_counter #(.KEY_S(KEY_S)) RC (
        .clk(clk),
        .rst(rst),
        .start(start),
        .round(round),
        .done(done)
        );
    
    assign key_next = (round == 4'd0) ? cipher_key: next_key;
            
    state_reg #(.DATA_S(KEY_S)) KEY_REG(
        .clk(clk),
        .rst(rst),
        .state_in(key_next),
        .state_out(key_reg_out)
        );
    
    key_expansion KE (
        .round_key_in(key_reg_out),
        .round(round),
        .round_key_out(next_key)
        );
    
    add_round_key INIT_ARK (
        .state_in(plain_text),
        .round_key(cipher_key),
        .state_out(init_add_round_out)
        );
    
    assign round_key = next_key;
    
    state_reg STATE(
        .clk(clk),
        .rst(rst),
        .state_in(state_next),
        .state_out(state_reg_out)
        );
    
    assign state_next = (round == 4'd0) ? init_add_round_out:
                        (round < NR) ? round_out:
                        (round == NR) ? final_out:
                                        state_reg_out;
    
    aes_round ROUND(
        .state_in(state_reg_out),
        .round_key(round_key),
        .state_out(round_out)
        );
    
    aes_final_round FINAL_ROUND(
        .state_in(state_reg_out),
        .round_key(round_key),
        .state_out(final_out)
        );
    
    assign cipher_text = state_reg_out;
    
endmodule
