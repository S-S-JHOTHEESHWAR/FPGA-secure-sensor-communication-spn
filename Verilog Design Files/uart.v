// ============================================================
// UART Transmitter (ZedBoard 100 MHz → 115200 bps)
// 8N1 Format: 1 Start, 8 Data, 1 Stop
// ============================================================

module uart_tx_top (
    input  wire clk,        // 100 MHz system clock
    input  wire rst,        // synchronous reset
    input  wire [7:0] data,
    input  wire start,
    output wire uart_tx,
    output reg  busy
);

    // ---------- Parameters ----------
    localparam CLK_FREQ = 100_000_000;
    localparam BAUD     = 115200;
    localparam DIVISOR  = CLK_FREQ / BAUD;   // ≈ 868

    // ---------- Registers ----------
    reg [31:0] clk_cnt = 0;
    reg [3:0]  bit_cnt = 0;
    reg [9:0]  shifter = 10'b1111111111;

    assign uart_tx = shifter[0];

    // ---------- UART FSM ----------
    always @(posedge clk) begin
        if (rst) begin
            busy    <= 0;
            clk_cnt <= 0;
            bit_cnt <= 0;
            shifter <= 10'b1111111111;
        end
        else begin

            // Start transmission
            if (!busy && start) begin
                shifter <= {1'b1, data, 1'b0}; // stop + data + start
                busy    <= 1;
                clk_cnt <= 0;
                bit_cnt <= 0;
            end

            // Transmitting bits
            else if (busy) begin
                if (clk_cnt == DIVISOR - 1) begin
                    clk_cnt <= 0;
                    shifter <= {1'b1, shifter[9:1]};
                    bit_cnt <= bit_cnt + 1;

                    // Transmission complete after 10 bits
                    if (bit_cnt == 9)
                        busy <= 0;
                end
                else
                    clk_cnt <= clk_cnt + 1;
            end
        end
    end

endmodule
