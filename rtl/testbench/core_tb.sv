//***********************************************************
// ECE 3058: Architecture, Concurrency, and Energy in Computation
//
// RISC-V Processor SystemVerilog Behavioral Model
//
// School of Electrical & Computer Engineering
// Georgia Institute of Technology
// Atlanta, GA 30332
//
//  Engineer:   Crombie, Ian; Cochran, Jack
//  Module:     core_tb
//  Functionality:
//      This is the testbench for a 5 stage pipelined RISC-V processor
//
//***********************************************************
`timescale 1ns / 1ns
import CORE_PKG::*;

module Core_tb;

 // clock and reset signals
 logic clk = 1;
 logic reset;

 // Loop variable for loading instructions
 integer i;



 // https://www.cs.sfu.ca/%7Eashriram/Courses/CS295/assets/notebooks/RISCV/RISCV_CARD.pdf
 // https://luplab.gitlab.io/rvcodecjs/
 // http://www.eg.bucknell.edu/~csci206/riscv-converter/


 // Use the links above to add RISC-V instructions to the provided array in hex format.
 // Remember, these resources are may be incorrect for some instruction types, so make sure to verify them with your RISC-V greencard
 bit [31:0] test_instructions [] = {
       32'h00000000, // NOP (keep as first instruction for simulation to work)
       32'h00500093,
32'h00500113,
32'hfe208ce3
   };



 
 initial
 begin
   // dump waveform signals into a vcd waveform file
   $dumpfile("Core_Simulation.vcd");
   $dumpvars(0, Core_tb);
	
	reset = 1'b1;
	
	#1
   // Loop over the array of instructions
   for (i = 0; i < $size(test_instructions); i++)
   begin
	
	  // Now load each byte in to memory manually
     rv32_core.InstructionFetch_Module.InstructionMemory.instr_RAM[i * 4 + 0] = test_instructions[i][31:24];
     rv32_core.InstructionFetch_Module.InstructionMemory.instr_RAM[i * 4 + 1] = test_instructions[i][23:16];
     rv32_core.InstructionFetch_Module.InstructionMemory.instr_RAM[i * 4 + 2] = test_instructions[i][15:8];
     rv32_core.InstructionFetch_Module.InstructionMemory.instr_RAM[i * 4 + 3] = test_instructions[i][7:0];
   end
	
	#3 reset = 1'b0;
	
	
   // end simulation after (# of instructions * 4ns(clk period))
   #($size(test_instructions) * 20) $finish;
 end


always
	#2 clk <= ~clk;



 // instantiate the RISC-V core
 Core rv32_core (
        .clock(clk),
        .reset(reset),
        .mem_en(1'b1)
      );

endmodule
