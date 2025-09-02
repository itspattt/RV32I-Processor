/* Branch predictor unit (2-bit to start)
*  by pat
* 
*/

import CORE_PKG::*;

module Branch_Predictor(
    input logic [31:0] if_pc, // PC from fetch to make the current prediction
    input logic [31:0] ex_pc, // PC from execute to update the BHT
    input logic clk,
    input taken_ip, // Actual result of the branch from execute
    
    output logic prediction_op // Prediction for the instruction in fetch
);

    bht_state hist_table [0:15]; // We will use 4 bits to index into the table. This requires 16 entries


    // Like DRAM, not synthesizable but works for simulation
    initial begin
        for (int i = 0; i < 16; i = i + 1) begin
            hist_table[i] = ntaken;
        end
    end

    logic [3:0] if_index;
    logic [3:0] ex_index;

    assign if_index = if_pc[5:2];
    assign ex_index = ex_pc[5:2];

    // State machine implementing a 2-bit branch predictor
    always_ff @(posedge clk) begin
        case (hist_table[ex_index])
            nntaken: hist_table[ex_index] <= (taken_ip ? ntaken : nntaken);
            ntaken: hist_table[ex_index] <= (taken_ip ? taken : nntaken);
            taken: hist_table[ex_index] <= (taken_ip ? ttaken : ntaken);
            ttaken: hist_table[ex_index] <= (taken_ip ? ttaken : taken);
        endcase
    end

    always_comb begin
       case (hist_table[if_index])
        nntaken, ntaken: prediction_op = 1'b0;
        taken, ttaken: prediction_op = 1'b1;
       endcase
    end


endmodule