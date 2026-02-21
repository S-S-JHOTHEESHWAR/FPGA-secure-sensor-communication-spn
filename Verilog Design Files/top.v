module full_secure_ultrasonic_uart (
    input  wire clk,        // 100 MHz
    input  wire echo,
    output wire trig,
    output wire uart_tx
);

    // ---------------- Ultrasonic ----------------
    wire [7:0] distance;
    wire dist_valid;

    ultrasonic_core u_ultra (
        .clk(clk),
        .echo(echo),
        .trig(trig),
        .distance_cm(distance),
        .valid(dist_valid)
    );

    // ---------------- Encryption ----------------
    wire [7:0] cipher;
    wire [7:0] checksum;
    wire enc_valid;

    spn_encryptor u_enc (
        .clk(clk),
        .rst(1'b0),
        .in_valid(dist_valid),
        .data_in(distance),
        .key(8'hA5),       // encryption key
        .out_valid(enc_valid),
        .cipher_out(cipher),
        .checksum(checksum)
    );

    // ---------------- UART ----------------
    reg  [7:0] tx_data;
    reg        tx_start = 0;
    reg        phase = 0;
    wire       tx_busy;

    uart_tx_top u_uart (
        .clk(clk),
        .data(tx_data),
        .start(tx_start),
        .uart_tx(uart_tx),
        .busy(tx_busy)
    );

    always @(posedge clk) begin
        tx_start <= 0;

        if (enc_valid && !tx_busy && !phase) begin
            tx_data  <= cipher[7:0];   // low byte
            tx_start <= 1;
            phase    <= 1;
        end
        else if (!tx_busy && phase) begin
            tx_data  <= cipher[15:8];  // high byte
            tx_start <= 1;
            phase    <= 0;
        end
    end
endmodule