//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module parallel_to_serial
# (
    parameter width = 8
)
(
    input                      clk,
    input                      rst,

    input                      parallel_valid,
    input        [width - 1:0] parallel_data,

    output                     busy,
    output logic               serial_valid,
    output logic               serial_data
);
    // Task:
    // Implement a module that converts multi-bit parallel value to the single-bit serial data.
    //
    // The module should accept 'width' bit input parallel data when 'parallel_valid' input is asserted.
    // At the same clock cycle as 'parallel_valid' is asserted, the module should output
    // the least significant bit of the input data. In the following clock cycles the module
    // should output all the remaining bits of the parallel_data.
    // Together with providing correct 'serial_data' value, module should also assert the 'serial_valid' output.
    //
    // Note:
    // Check the waveform diagram in the README for better understanding.

    logic [width-1:0] shreg, p_shreg;
    logic [$clog2(width)-1:0] cnt;

    assign busy = serial_valid && cnt < 7;
    assign shreg = parallel_valid ? parallel_data : { 1'b0, p_shreg[width-1:1] };

    always_comb begin
        serial_valid = parallel_valid | (cnt < 7);
        serial_data = shreg[0];
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            cnt <= width - 1;
            p_shreg <= '0;
        end else begin
            p_shreg <= shreg;

            if(cnt == 0) cnt <= 7;
            else if(cnt == 7) cnt <= parallel_valid ? cnt - 1'b1 : cnt;
            else cnt <= cnt - 1;
        end
    end


endmodule
