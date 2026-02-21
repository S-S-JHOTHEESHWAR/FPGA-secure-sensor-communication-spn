// ============================================================
// 8-bit SPN Encryption Engine (Hardware RTL)
// Stages:
// 1. XOR Key Mixing
// 2. 4-bit S-Box Substitution
// 3. Bit Permutation Layer
// 4. Checksum Generation
// Fully pipelined (4-cycle latency)
// ============================================================

module spn_encryptor (
    input  wire       clk,
    input  wire       rst,
    input  wire       in_valid,
    input  wire [7:0] data_in,
    input  wire [7:0] key,
    output reg        out_valid,
    output reg  [7:0] cipher_out,
    output reg  [7:0] checksum
);

    // ---------- Pipeline Registers ----------
    reg v1, v2, v3;
    reg [7:0] s1, s2, s3;

    // ---------- 4-bit SBOX ----------
    function [3:0] sbox;
        input [3:0] x;
        begin
            case(x)
                4'h0: sbox=4'hE; 4'h1: sbox=4'h4;
                4'h2: sbox=4'hD; 4'h3: sbox=4'h1;
                4'h4: sbox=4'h2; 4'h5: sbox=4'hF;
                4'h6: sbox=4'hB; 4'h7: sbox=4'h8;
                4'h8: sbox=4'h3; 4'h9: sbox=4'hA;
                4'hA: sbox=4'h6; 4'hB: sbox=4'hC;
                4'hC: sbox=4'h5; 4'hD: sbox=4'h9;
                4'hE: sbox=4'h0; 4'hF: sbox=4'h7;
            endcase
        end
    endfunction

    // ---------- Permutation ----------
    function [7:0] permute;
        input [7:0] x;
        begin
            permute = {
                x[0], x[4], x[1], x[5],
                x[2], x[6], x[3], x[7]
            };
        end
    endfunction

    // ---------- Pipeline ----------
    always @(posedge clk) begin
        if(rst) begin
            v1<=0; v2<=0; v3<=0;
            out_valid<=0;
        end
        else begin

            // Stage 1: XOR Key Mixing
            v1 <= in_valid;
            if(in_valid)
                s1 <= data_in ^ key;

            // Stage 2: SBOX Substitution
            v2 <= v1;
            if(v1)
                s2 <= {sbox(s1[7:4]), sbox(s1[3:0])};

            // Stage 3: Permutation
            v3 <= v2;
            if(v2)
                s3 <= permute(s2);

            // Stage 4: Output + Checksum
            out_valid <= v3;
            if(v3) begin
                cipher_out <= s3;
                checksum   <= s3 ^ key;   // simple integrity check
            end
        end
    end

endmodule