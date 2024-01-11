//==============================================================================
// AU_dec.v
//
// Decrementer using parallel-prefix propagate-lookahead logic.
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module AU_dec #(
    parameter integer WIDTH = 8,  // word length of input (>= 1)
    parameter integer ARCH  = 0   // architecture (0 to 2)
) (
    // Data interface
    input  [WIDTH-1:0] a,  // input data
    output [WIDTH-1:0] z   // decrement
);


    // Structural model
    generate
        wire [WIDTH-1:0] ai;
        wire [WIDTH-1:0] po;

        if (WIDTH == 1) begin : g_z_1
            // Calculate result bit
            assign z = ~a;
        end else begin : g_z_2
            // Invert a for decrement
            assign ai = ~a;

            // Calculate prefix output propagate signal
            AU_prefix_and #(
                .WIDTH(WIDTH),
                .ARCH (ARCH)
            ) u_AU_prefix_and (
                .pi(ai),
                .po(po)
            );

            // Calculate result bits
            assign z = a ^ {po[WIDTH - 2 : 0], 1'b1};
        end
    endgenerate


endmodule
