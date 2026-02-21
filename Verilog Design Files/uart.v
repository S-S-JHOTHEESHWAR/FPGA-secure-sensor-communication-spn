module uart_tx_top (
    input  wire clk,        // 100 MHz
    input  wire [7:0] data,
    input  wire start,
    output wire uart_tx,
    output reg  busy
);

    localparam CLK_FREQ = 100_000_000;
    localparam BAUD     = 9600;
    localparam DIVISOR  = CLK_FREQ / BAUD;

    reg [31:0] clk_cnt = 0;
    reg [3:0]  bit_cnt = 0;
    reg [9:0]  shifter = 10'b1111111111;

    assign uart_tx = shifter[0];

    always @(posedge clk) begin
        if (!busy && start) begin
            shifter <= {1'b1, data, 1'b0};
            busy    <= 1;
            clk_cnt <= 0;
            bit_cnt <= 0;
        end
        else if (busy) begin
            if (clk_cnt == DIVISOR-1) begin
                clk_cnt <= 0;
                shifter <= {1'b1, shifter[9:1]};
                bit_cnt <= bit_cnt + 1;
                if (bit_cnt == 9)
                    busy <= 0;
            end else
                clk_cnt <= clk_cnt + 1;
        end
    end
endmodule