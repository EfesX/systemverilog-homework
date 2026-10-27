//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module serial_to_parallel
# (
    parameter width = 8
)
(
    input                      clk,
    input                      rst,

    input                      serial_valid,
    input                      serial_data,

    output logic               parallel_valid,
    output logic [width - 1:0] parallel_data
);
    // Task:
    // Implement a module that converts single-bit serial data to the multi-bit parallel value.
    //
    // The module should accept one-bit values with valid interface in a serial manner.
    // After accumulating 'width' bits and receiving last 'serial_valid' input,
    // the module should assert the 'parallel_valid' at the same clock cycle
    // and output 'parallel_data' value.
    //
    // Note:
    // Check the waveform diagram in the README for better understanding.

    logic [width-1:0] shreg;
    logic [$clog2(width)-1:0] cnt;

    assign parallel_data = { serial_data, shreg[width-1:1] };
    assign parallel_valid = serial_valid & (cnt == width - 1);


    always_ff @( posedge clk ) begin
    if(rst) begin
        cnt <= '0;
    end else begin
        if(serial_valid) begin
        shreg <= parallel_data;

        if(cnt == width - 1) cnt <= '0;
        else cnt <= cnt + 1'b1;
        end
    end
    end

endmodule
