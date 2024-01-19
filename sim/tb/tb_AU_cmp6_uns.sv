//==============================================================================
// tb_AU_cmp6_uns.sv
//
// Testbench of module AU_cmp6_uns.
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


`timescale 1ns / 1ps


module tb_AU_cmp6_uns;


    //------------------------------------------------------------------------------
    // Parameters
    parameter real Cycle = 10.0;  // unit cycle
    parameter integer Width = 8;  // word length of input
    parameter integer Arch = 0;  // architecture
    parameter integer Nrandom = 10000;  // number of random tests


    // Global variables
    int num_test;
    int num_fail;


    // Signals
    logic [Width-1:0] a;  // input data
    logic [Width-1:0] b;  // input data
    logic [5:0] res;  // output condition
    logic [5:0] res_ref;  // reference output condition
    //------------------------------------------------------------------------------


    //------------------------------------------------------------------------------
    // Instances
    AU_cmp6_uns #(
        .WIDTH(Width),
        .ARCH (Arch)
    ) dut (
        .a (a),
        .b (b),
        .lt(res[0]),
        .gt(res[1]),
        .eq(res[2]),
        .le(res[3]),
        .ge(res[4]),
        .ne(res[5])
    );

    AU_cmp6_uns_ref #(
        .WIDTH(Width),
        .ARCH (Arch)
    ) dut_ref (
        .a (a),
        .b (b),
        .lt(res_ref[0]),
        .gt(res_ref[1]),
        .eq(res_ref[2]),
        .le(res_ref[3]),
        .ge(res_ref[4]),
        .ne(res_ref[5])
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
        if (res !== res_ref) begin
            $display("Fail    a(h_%0h)  b(h_%0h)  res(b_%06b)  res_ref(b_%06b)", a, b, res, res_ref);
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
        $display("[INFO]  Simulation parameters: Width = %0d, Arch = %0d, Nrandom = %0d", Width, Arch, Nrandom);

        run_sim;

        $finish;
    end
    //------------------------------------------------------------------------------


endmodule
