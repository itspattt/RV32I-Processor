/*  Comparator
*   By pat
*
*/

import CORE_PKG::*;

module comparator (
    // General Inputs
    input logic reset,

    // Inputs from decode
    input logic comp_enable_ip,
    input comparator_func_code comp_func_ip,
    input logic [31:0] comp_operand_a_ip,
    input logic [31:0] comp_operand_b_ip,

    // Outputs to LSU, MEM, and Fetch
    output logic comp_result_op,
    output logic comp_valid_op
);

    always_comb begin
        if (!comp_enable_ip) begin
            comp_result_op = 1'bz;
            comp_valid_op = 0;
        end else begin
            case (comp_func_ip)
                COMP_BEQ: begin
                    comp_result_op = $signed(comp_operand_a_ip) == $signed(comp_operand_b_ip);
                    comp_valid_op = 1;
                end
                COMP_BNE: begin
                    comp_result_op = $signed(comp_operand_a_ip) != $signed(comp_operand_b_ip);
                    comp_valid_op = 1;
                end
                COMP_BLT: begin
                    comp_result_op = $signed(comp_operand_a_ip) < $signed(comp_operand_b_ip);
                    comp_valid_op = 1;
                end
                COMP_BGE: begin
                    comp_result_op = $signed(comp_operand_a_ip) >= $signed(comp_operand_b_ip);
                    comp_valid_op = 1;
                end
                COMP_BLT_U: begin
                    comp_result_op = comp_operand_a_ip < comp_operand_b_ip;
                    comp_valid_op = 1;
                end
                COMP_BGE_U: begin
                    comp_result_op = comp_operand_a_ip >= comp_operand_b_ip;
                    comp_valid_op = 1;
                end
                default: begin
                    comp_result_op = 1'bz;
                    comp_valid_op = 0;
                end
            endcase
        end
    end

endmodule