//==============================================================================
// tb_AU_bin2gray.sv
//
// Testbench of module AU_bin2gray.
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


`timescale 1ns / 1ps


module tb_AU_bin2gray;


    //------------------------------------------------------------------------------
    // Parameters
    parameter real Cycle = 10.0;  // unit cycle
    parameter integer Width = 8;  // word length of input
    parameter integer Nrandom = 10000;  // number of random tests


    // Global variables
    int num_test;
    int num_fail;


    // Signals
    logic [Width-1:0] b;  // binary input data
    logic [Width-1:0] g;  // Gray output data
    logic [Width-1:0] g_ref;  // reference Gray output data
    //------------------------------------------------------------------------------


    //------------------------------------------------------------------------------
    // Instances
    AU_bin2gray #(
        .WIDTH(Width)
    ) dut (
        .b(b),
        .g(g)
    );

    AU_bin2gray_ref #(
        .WIDTH(Width)
    ) dut_ref (
        .b(b),
        .g(g_ref)
    );
    //------------------------------------------------------------------------------


    //------------------------------------------------------------------------------
    // Test single case
    task automatic test_single(logic [Width-1:0] b_in);
        #(Cycle);
        b = b_in;

        #(Cycle);
        num_test++;
        if (g !== g_ref) begin
            $display("Fail    b(h_%0h)  g(h_%0h)  g_ref(h_%0h)", b, g, g_ref);
            num_fail++;
        end
    endtask


    // Test exhaustive cases
    task automatic test_exhaustive;
        logic [Width-1:0] b_in;
        int i;

        // Exhaustive tests
        for (i = 0; i <= 2 ** Width - 1; i++) begin
            b_in = i;
            test_single(b_in);
        end
    endtask


    // Test random cases
    task automatic test_random;
        logic [Width-1:0] b_in;
        int i;

        // Special tests
        test_single({Width{1'b0}});
        test_single({Width{1'b1}});

        // Random tests
        for (i = 1; i <= Nrandom; i++) begin
            assert(std::randomize(b_in));
            test_single(b_in);
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

        b = 'b0;

        #(Cycle * 10);
        if (Width <= 16) begin
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
