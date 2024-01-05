//==============================================================================
// AU_lead_zero_det_ref.v
//
// Behavioral model of AU_lead_zero_det.
// Detection of leading zeroes. Output vector indicates position of the first
// '1' (starting at MSB).
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module AU_lead_zero_det_ref #(
    parameter integer WIDTH = 8,  // word length of input (>= 1)
    parameter integer ARCH  = 0   // architecture (0 to 2)
) (
    // Data interface
    input  [WIDTH-1:0] a,      // input data
    output [WIDTH-1:0] z,      // one-hot decoded output data
    output             no_det  // result of search for leading '1', 0:'1' found, 1:'1' not found
);


    // Behavioral model
    reg [WIDTH-1:0] zv;
    reg done;
    integer i;

    always @(*) begin
        zv = 'b0;
        done = 1'b0;
        for (i = WIDTH - 1; (done == 1'b0) && (i >= 0); i = i - 1) begin
            if (a[i] == 1'b1) begin
                zv[i] = 1'b1;
                done = 1'b1;
            end
        end
    end

    assign z = zv;
    assign no_det = ~(|a);


    // Parameter legality check
    initial begin : parameter_check
        integer param_err_flg;

        param_err_flg = 0;

        if (WIDTH < 1) begin
            param_err_flg = 1;
            $display("ERROR: %m :\n  Invalid value (%0d) for parameter WIDTH (lower bound: 1)", WIDTH);
        end

        if ((ARCH < 0) || (ARCH > 2)) begin
            param_err_flg = 1;
            $display("ERROR: %m :\n  Invalid value (%0d) for parameter ARCH (legal range: 0 to 2)", ARCH);
        end

        if (param_err_flg == 1) begin
            $display("%m :\n  Simulation aborted due to invalid parameter value(s)");
            $finish;
        end
    end


endmodule
