//==============================================================================
// tb_AU_add_csv.sv
//
// Testbench of module AU_add_csv.
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


`timescale 1ns / 1ps


module tb_AU_add_csv;


    //------------------------------------------------------------------------------
    // Parameters
    parameter real Cycle = 10.0;  // unit cycle
    parameter integer Width = 8;  // word length of input
    parameter integer Nrandom = 10000;  // number of random tests


    // Global variables
    int num_test;
    int num_fail;


    // Signals
    logic [Width-1:0] a1;  // input data
    logic [Width-1:0] a2;  // input data
    logic [Width-1:0] a3;  // input data
    logic [Width-1:0] s;  // sum
    logic [Width-1:0] c;  // carry
    logic [Width+1:0] s_ref;  // reference sum
    //------------------------------------------------------------------------------


    //------------------------------------------------------------------------------
    // Instances
    AU_add_csv #(
        .WIDTH(Width)
    ) dut (
        .a1(a1),
        .a2(a2),
        .a3(a3),
        .s (s),
        .c (c)
    );

    AU_add_csv_ref #(
        .WIDTH(Width)
    ) dut_ref (
        .a1(a1),
        .a2(a2),
        .a3(a3),
        .s (s_ref)
    );
    //------------------------------------------------------------------------------


    //------------------------------------------------------------------------------
    // Test single case
    task automatic test_single(logic [Width-1:0] a1_in, logic [Width-1:0] a2_in, logic [Width-1:0] a3_in);
        #(Cycle);
        a1 = a1_in;
        a2 = a2_in;
        a3 = a3_in;

        #(Cycle);
        num_test++;
        if (s + {c, 1'b0} !== s_ref) begin
            $display("Fail    a1(h_%0h)  a2(h_%0h)  a3(h_%0h)  s(h_%0h)  c(h_%0h)  s_ref(h_%0h)", a1, a2, a3, s, c, s_ref);
            num_fail++;
        end
    endtask


    // Test exhaustive cases
    task automatic test_exhaustive;
        logic [Width-1:0] a1_in;
        logic [Width-1:0] a2_in;
        logic [Width-1:0] a3_in;
        int i, j, k;

        // Exhaustive tests
        for (i = 0; i <= 2 ** Width - 1; i++) begin
            for (j = 0; j <= 2 ** Width - 1; j++) begin
                for (k = 0; k <= 2 ** Width - 1; k++) begin
                    a1_in = i;
                    a2_in = j;
                    a3_in = k;
                    test_single(a1_in, a2_in, a3_in);
                end
            end
        end
    endtask


    // Test random cases
    task automatic test_random;
        logic [Width-1:0] a1_in;
        logic [Width-1:0] a2_in;
        logic [Width-1:0] a3_in;
        int i;

        // Special tests
        test_single({Width{1'b0}}, {Width{1'b0}}, {Width{1'b0}});
        test_single({Width{1'b0}}, {Width{1'b0}}, {Width{1'b1}});
        test_single({Width{1'b0}}, {Width{1'b1}}, {Width{1'b0}});
        test_single({Width{1'b0}}, {Width{1'b1}}, {Width{1'b1}});
        test_single({Width{1'b1}}, {Width{1'b0}}, {Width{1'b0}});
        test_single({Width{1'b1}}, {Width{1'b0}}, {Width{1'b1}});
        test_single({Width{1'b1}}, {Width{1'b1}}, {Width{1'b0}});
        test_single({Width{1'b1}}, {Width{1'b1}}, {Width{1'b1}});

        // Random tests
        for (i = 1; i <= Nrandom; i++) begin
            assert (std::randomize(a1_in));
            assert (std::randomize(a2_in));
            assert (std::randomize(a3_in));
            test_single(a1_in, a2_in, a3_in);
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

        a1 = 'b0;
        a2 = 'b0;
        a3 = 'b0;

        #(Cycle * 10);
        if (Width <= 5) begin
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
