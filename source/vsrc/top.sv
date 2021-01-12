module top (
    input           CLK,
    input           rst,
    input           scan_in_enable,
    input           scan_in_data,

    input           scan_out_enable, 
    output logic    scan_out_data
    );

logic [127:0] aes_input = 128'h0;
logic [127:0] aes_output;
logic [127:0] out_buf = 128'h0;


always_ff @(posedge CLK) begin
    //would normally reset aes_input + out_buf here!
    if (scan_in_enable) begin
        aes_input = { aes_input[126:0], scan_in_data};
    end

    if (scan_out_enable) begin
        out_buf <= { 1'h0, out_buf[127:1]};
        scan_out_data <= out_buf[0];
    end else begin
        out_buf  <= aes_output;
        scan_out_data <= 1'h0; 
    end 
end

aes_128 aes128 (
    .clk(CLK), 
    .state(aes_input),
    .key(128'hffffffffffffffffffffffffffffffff),
    .AES_output(aes_output)
    );
 
endmodule
