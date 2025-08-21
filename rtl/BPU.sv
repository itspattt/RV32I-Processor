/* Branch predictor unit (2-bit to start)
*  by pat
* 
*/

import CORE_PKG::*;

module Branch_Predictor(
    input logic [31:0] if_pc,
    input logic [31:0] ex_pc,
    input logic clk,
    input taken_ip,
    
    output logic prediction_op
);

    bht_state hist_table [0:15]; // We will use 4 bits to index into the table. This requires 16 entries
    bht_state [3:0] if_index;
    bht_state [3:0] ex_index;

    assign if_index = if_pc[5:2];
    assign ex_index = ex_pc[5:2];

    // State machine
    always_ff @(posedge clk) begin
        case (hist_table[ex_index])
            nntaken: taken_ip ? hist_table[ex_index] <= ntaken : hist_table[ex_index] <= nntaken;
            ntaken: taken_ip ? hist_table[_exindex] <= taken : hist_table[ex_index] <= nntaken;
            taken: taken_ip ? hist_table[ex_index] <= ttaken : hist_table[ex_index] <= ntaken;
            ttaken: taken_ip ? hist_table[ex_index] <= ttaken : hist_table[ex_index] <= taken;
        endcase
    end

    always_comb begin
       case (hist_table[if_index])
        nntaken, ntaken: prediction = 1'b0;
        taken, ttaken: prediction = 1'b1;
       endcase
    end


endmodule