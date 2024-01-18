//==============================================================================
// tb_AU_cmp_eq.sv
//
// Testbench of module AU_cmp_eq.
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


`timescale 1ns / 1ps


module tb_AU_cmp_eq;


    //------------------------------------------------------------------------------
    // Parameters
    parameter real Cycle = 10.0;  // unit cycle
    parameter integer Width = 8;  // word length of input
    parameter integer Nrandom = 10000;  // number of random tests


    // Global variables
    int num_test;
    int num_fail;


    // Signals
    logic [Width-1:0] a;  // augend
    logic [Width-1:0] b;  // addend
    logic [Width-1:0] eq;  // equal output condition
    logic [Width-1:0] eq_ref;  // reference equal output condition
    //------------------------------------------------------------------------------


    //------------------------------------------------------------------------------
    // Instances
    AU_cmp_eq #(
        .WIDTH(Width)
    ) dut (
        .a(a),
        .b(b),
        .eq(eq)
    );

    AU_cmp_eq_ref #(
        .WIDTH(Width)
    ) dut_ref (
        .a(a),
        .b(b),
        .eq(eq_ref)
    );
    //------------------------------------------------------------------------------


    //------------------------------------------------------------------------------
    // Test single case
    task automatic test_single(logic [Width-1:0] a_in, logic [Width-1:0] b_in);
        #(Cycle);
        a = a_in;
        b = b_in;

        #(Cycle);
        num_test++;
        if (eq !== eq_ref) begin
            $display("Fail    a(h_%0h)  b(h_%0h)  eq(b_%0b)  eq_ref(b_%0b)", a, b, eq, eq_ref);
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
                test_single(a_in, b_in);
            end
        end
    endtask


    // Test random cases
    task automatic test_random;
        logic [Width-1:0] a_in;
        logic [Width-1:0] b_in;
        int i;

        // Special tests
        test_single({Width{1'b0}}, {Width{1'b0}});
        test_single({Width{1'b0}}, {Width{1'b1}});
        test_single({Width{1'b1}}, {Width{1'b0}});
        test_single({Width{1'b1}}, {Width{1'b1}});

        // Random tests
        for (i = 1; i <= Nrandom; i++) begin
            assert (std::randomize(a_in));
            assert (std::randomize(b_in));
            test_single(a_in, b_in);
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
