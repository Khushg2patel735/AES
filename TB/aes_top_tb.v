`timescale 1ns/1ps

module aes_top_tb #(
    parameter KEY_S   = 128,
              NK      = (KEY_S/32),
              NR      = NK+6,
              NRK     = NR+1,
              T_NW    = 4*(NRK),
              DATA_S  = 128,
              NUM_BYTE = (DATA_S/8),
              W_S     = 32)
();

reg clk;
reg rst;
reg start;
wire done;

reg  [DATA_S-1:0] plain_text;
reg  [KEY_S-1:0]  cipher_key;
//reg  [`DATA_S-1:0] expected_cipher_text;

wire [DATA_S-1:0] cipher_text;



//DUT Instantiation

aes_top DUT(
    .clk(clk),
    .rst(rst),
    .start(start),
    .plain_text(plain_text),
    .cipher_key(cipher_key),
    .cipher_text(cipher_text),
    .done(done)
);

//Clock Generation
//10ns clock period

initial begin 
    clk = 0;
    forever
    #5 clk = ~clk;
end

always @(posedge clk) begin
    if(DUT.round != 0)
        $display("Round=%0d State=%h", DUT.round, DUT.state_reg_out);
end

//====================================================
//reset
//====================================================

task reset;
    begin 
        rst = 1;
        start = 0;
        @(posedge clk);
        rst = 0;
        //@(posedge clk);
end
endtask

//====================================================
//Encrypt_task 
//====================================================

task encrypt(input [DATA_S-1:0] pt,
             input [KEY_S-1:0] ck,
             input [DATA_S-1:0] ex_ct);

         begin 
            plain_text = pt;
            cipher_key = ck;
            
           //@(posedge clk);
            start = 1'b1;
            @(posedge clk);
            start = 1'b0;

            wait(done);
            @(posedge clk);
            //Monitoring
    $display("\n***********************************************");
    $display("Plaintext  = %h", plain_text);
    $display("Cipherkey  = %h", cipher_key);
    $display("Ciphertext = %h", cipher_text);
    $display("***********************************************");

            if(cipher_text == ex_ct)begin
                $display("\n***********************************************");
                $display("AES PASS");
                $display("***********************************************");
            end
            else
            begin
                $display("\n***********************************************");
                $display("AES FAIL\n");
                $display("Expected: %h",ex_ct);
                $display("Cipertext: %h",cipher_text);
                $display("***********************************************");
            end
        end
endtask
initial begin 
    $display("\n***********************************************");
    $display("Encryption Test initiate");
    $display("***********************************************\n");

    reset;
    //Sanity Test
    $display("::Sanity Test::\n");
    encrypt(
        128'h00112233445566778899aabbccddeeff,
        128'h000102030405060708090a0b0c0d0e0f,
        128'h69c4e0d86a7b0430d8cdb78070b4c55a
           );
 reset;

    //Courner Case
    $display("::Courner Test:LOWER Boundary::\n");
    encrypt(
        128'h00000000000000000000000000000000,
        128'h00000000000000000000000000000000,
        128'h66E94BD4EF8A2C3B884CFA59CA342B2E
           );
 reset;

    $display("::Courner Test:HIGHER Boundary::\n");
    encrypt(
        128'hffffffffffffffffffffffffffffffff,
        128'hffffffffffffffffffffffffffffffff,
        128'hBCBF217CB280CF30B2517052193AB979
           );
 reset;
   rst = 1'b1;
    $display("\n***********************************************");
    $display("All Case are Done.");    
    $display("***********************************************\n");
    #300; 
    $finish;
end
endmodule

