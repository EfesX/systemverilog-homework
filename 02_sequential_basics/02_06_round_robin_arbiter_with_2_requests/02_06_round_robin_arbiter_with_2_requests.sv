//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module round_robin_arbiter_with_2_requests
(
    input        clk,
    input        rst,
    input  [1:0] requests,
    output [1:0] grants
);
    // Task:
    // Implement a "arbiter" module that accepts up to two requests
    // and grants one of them to operate in a round-robin manner.
    //
    // The module should maintain an internal register
    // to keep track of which requester is next in line for a grant.
    //
    // Note:
    // Check the waveform diagram in the README for better understanding.
    //
    // Example:
    // requests -> 01 00 10 11 11 00 11 00 11 11
    // grants   -> 01 00 10 01 10 00 01 00 10 01

    logic [1:0] prev_grants;
    
    logic [1:0] mask;
    assign mask = { prev_grants[0], prev_grants[1] };
    assign grants = requests & (requests & mask ? mask : ~mask);

        always_ff @( posedge clk ) begin
        if(rst) begin
            prev_grants <= 2'b00;
        end else begin
            prev_grants <= grants;
        end
    end

endmodule
