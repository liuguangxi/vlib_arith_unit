//==============================================================================
// tb_AU_sum_zero_det.sv
//
// Testbench of module AU_sum_zero_det.
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


`timescale 1ns / 1ps


module tb_AU_sum_zero_det;


    //------------------------------------------------------------------------------
    // Parameters
    parameter real Cycle = 10.0;  // unit cycle
    parameter integer Width = 8;  // word length of input
    parameter integer Nrandom = 10000;  // number of random tests


    // Global variables
    int num_test;
    int num_fail;


    // Signals
    logic [Width-1:0] a;  // input data
    logic [Width-1:0] b;  // input data
    logic ci;  // carry-in
    logic z;  // all-zeros sum flag
    logic z_ref;  // reference all-zeros sum flag
    //------------------------------------------------------------------------------


    //------------------------------------------------------------------------------
    // Instances
    AU_sum_zero_det #(
        .WIDTH(Width)
    ) dut (
        .a (a),
        .b (b),
        .ci(ci),
        .z (z)
    );

    AU_sum_zero_det_ref #(
        .WIDTH(Width)
    ) dut_ref (
        .a (a),
        .b (b),
        .ci(ci),
        .z (z_ref)
    );
    //------------------------------------------------------------------------------


    //------------------------------------------------------------------------------
    // Test single case
    task automatic test_single(logic [Width-1:0] a_in, logic [Width-1:0] b_in, logic ci_in);
        #(Cycle);
        a = a_in;
        b = b_in;
        ci = ci_in;

        #(Cycle);
        num_test++;
        if (z !== z_ref) begin
            $display("Fail    a(h_%0h)  b(h_%0h)  ci(b_%0b)  z(h_%0h)  z_ref(h_%0h)", a, b, ci, z, z_ref);
            num_fail++;
        end
    endtask


    // Test exhaustive cases
    task automatic test_exhaustive;
        logic [Width-1:0] a_in;
        logic [Width-1:0] b_in;
        int i, j;

        // Exhaustive tests
        for (i = 0; i <= 2 ** Width - 1; i++) begin
            for (j = 0; j <= 2 ** Width - 1; j++) begin
                a_in = i;
                b_in = j;
                test_single(a_in, b_in, 1'b0);
                test_single(a_in, b_in, 1'b1);
            end
        end
    endtask


    // Test random cases
    task automatic test_random;
        logic [Width-1:0] a_in;
        logic [Width-1:0] b_in;
        logic ci_in;
        int i;

        // Special tests
        test_single({Width{1'b0}}, {Width{1'b0}}, 1'b0);
        test_single({Width{1'b0}}, {Width{1'b0}}, 1'b1);
        test_single({Width{1'b0}}, {Width{1'b1}}, 1'b0);
        test_single({Width{1'b0}}, {Width{1'b1}}, 1'b1);
        test_single({Width{1'b1}}, {Width{1'b0}}, 1'b0);
        test_single({Width{1'b1}}, {Width{1'b0}}, 1'b1);
        test_single({Width{1'b1}}, {Width{1'b1}}, 1'b0);
        test_single({Width{1'b1}}, {Width{1'b1}}, 1'b1);

        // Random tests
        for (i = 1; i <= Nrandom; i++) begin
            assert (std::randomize(a_in));
            assert (std::randomize(b_in));
            assert (std::randomize(ci_in));
            test_single(a_in, b_in, ci_in);
        end
    endtask


    // Run simulation
    task automatic run_sim;
        localparam string StrPass = {
            "                   \n",
            "               #   \n",
            "              #    \n",
            "             #     \n",
            "     #      #      \n",
            "      #    #       \n",
            "       #  #        \n",
            "        ##         \n",
            "                   \n"
        };
        localparam string StrFail = {
            "                   \n",
            "    #           #  \n",
            "      #       #    \n",
            "        #   #      \n",
            "          #        \n",
            "        #   #      \n",
            "      #       #    \n",
            "    #           #  \n",
            "                   \n"
        };

        num_test = 0;
        num_fail = 0;

        a = 'b0;
        b = 'b0;
        ci = 1'b0;

        #(Cycle * 10);
        if (Width <= 8) begin
            test_exhaustive;
        end else begin
            test_random;
        end

        $display("[INFO]  Simulation complete.");
        if (num_fail == 0) begin
            $display("%s", StrPass);
            $display("PASS  (Total %0d)", num_test);
        end else begin
            $display("%s", StrFail);
            $display("FAIL  (Total %0d / Fail %0d)", num_test, num_fail);
        end
    endtask
    //------------------------------------------------------------------------------


    //------------------------------------------------------------------------------
    // Main process
    initial begin
        $display("[INFO]  Simulation parameters: Width = %0d, Nrandom = %0d", Width, Nrandom);

        run_sim;

        $finish;
    end
    //------------------------------------------------------------------------------


endmodule