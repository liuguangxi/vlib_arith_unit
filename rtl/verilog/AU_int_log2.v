//==============================================================================
// AU_int_log2.v
//
// Computes integer logarithm to base 2 (z = floor(log2(a))).
// Example: a = "00010110" -> z = "100".
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module AU_int_log2 #(
    parameter integer WIDTH = 8,  // word length of input (>= 1)
    parameter integer ARCH  = 0   // architecture (0 to 2)
) (
    // Data interface
    input  [        WIDTH-1:0] a,  // input data
    output [clogb2(WIDTH)-1:0] z   // encoded output data
);


    // Calculate max(ceil(log2(x)), 1)
    function integer clogb2(input integer value);
        begin
            value = value - 1;
            for (clogb2 = 0; value > 0; clogb2 = clogb2 + 1) value = value >> 1;
            if (clogb2 < 1) clogb2 = 1;
        end
    endfunction


    // Structural model
    wire [WIDTH-1:0] zt;

    // Leading zero detection (i.e. most significant '1')
    AU_lead_zero_det #(
        .WIDTH(WIDTH),
        .ARCH (ARCH)
    ) u_AU_lead_zero_det (
        .a     (a),
        .z     (zt),
        .no_det()
    );

    // Binary encode
    AU_encode #(
        .WIDTH(WIDTH)
    ) u_AU_encode (
        .a(zt),
        .z(z)
    );


endmodule
