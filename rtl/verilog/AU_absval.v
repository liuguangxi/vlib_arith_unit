//==============================================================================
// AU_absval.v
//
// Computes the absolute value using a parallel-prefix 2's complementer.
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module AU_absval #(
    parameter integer WIDTH = 8,  // word length of input (>= 1)
    parameter integer ARCH  = 0   // architecture (0 to 2)
) (
    // Data interface
    input  [WIDTH-1:0] a,  // input data
    output [WIDTH-1:0] z   // absolute value
);


    // Structural model
    generate
        wire neg;
        wire [WIDTH:0] ai;
        wire [WIDTH:0] po;

        if (WIDTH == 1) begin : g_z_1
            // Calculate result bit
            assign z = a;
        end else begin : g_z_2
            // Negation enable is sign (MSB) of a
            assign neg = a[WIDTH - 1];

            // Invert a for complement and attach carry-in
            assign ai = {a ^ {WIDTH{neg}}, neg};

            // Calculate prefix output propagate signal
            AU_prefix_and #(
                .WIDTH(WIDTH + 1),
                .ARCH (ARCH)
            ) u_AU_prefix_and (
                .pi(ai),
                .po(po)
            );

            // Calculate result bits
            assign z = ai[WIDTH : 1] ^ po[WIDTH - 1 : 0];
        end
    endgenerate


endmodule
