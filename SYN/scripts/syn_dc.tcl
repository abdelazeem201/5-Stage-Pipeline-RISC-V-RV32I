#*****************************************************************************
# This script is used to synthesize the RISC -V
#*****************************************************************************
set design RISCV
#to preserve rtl names in the netlist for power consumption estimation .
set power_preserve_rtl_hier_names true
# analyze all possible file contained in the work folder
analyze -library WORK -format vhdl {/home/abdelazeem/RISCV/RTL/my_package.vhd}
analyze -library WORK -format vhdl {/home/abdelazeem/RISCV/RTL/ALU_package.vhd}
analyze -library WORK -format vhdl {/home/abdelazeem/RISCV/RTL/FU_package.vhd}
analyze -library WORK -format vhdl {/home/abdelazeem/RISCV/RTL/HDU_package.vhd}
analyze -library WORK -format vhdl {/home/abdelazeem/RISCV/RTL/RISCV_package.vhd}
analyze -library WORK -format vhdl {/home/abdelazeem/RISCV/RTL/CU_package.vhd}
analyze -library WORK -format vhdl {/home/abdelazeem/RISCV/RTL/FA.vhd}
analyze -library WORK -format vhdl {/home/abdelazeem/RISCV/RTL/MUX_2to1.vhd}
analyze -library WORK -format vhdl {/home/abdelazeem/RISCV/RTL/RCA.vhd}
analyze -library WORK -format vhdl {/home/abdelazeem/RISCV/RTL/MUX_4to1.vhd}
analyze -library WORK -format vhdl {/home/abdelazeem/RISCV/RTL/G_block.vhd}
analyze -library WORK -format vhdl {/home/abdelazeem/RISCV/RTL/PG_block.vhd}
analyze -library WORK -format vhdl {/home/abdelazeem/RISCV/RTL/PG_network.vhd}
analyze -library WORK -format vhdl {/home/abdelazeem/RISCV/RTL/carry_select_block.vhd}
analyze -library WORK -format vhdl {/home/abdelazeem/RISCV/RTL/MUX_8to1.vhd}
analyze -library WORK -format vhdl {/home/abdelazeem/RISCV/RTL/barrel_shifter.vhd}
analyze -library WORK -format vhdl {/home/abdelazeem/RISCV/RTL/HDU.vhd}
analyze -library WORK -format vhdl {/home/abdelazeem/RISCV/RTL/FU.vhd}
analyze -library WORK -format vhdl {/home/abdelazeem/RISCV/RTL/RF.vhd}
analyze -library WORK -format vhdl {/home/abdelazeem/RISCV/RTL/BPU.vhd}
analyze -library WORK -format vhdl {/home/abdelazeem/RISCV/RTL/adder_subtractor.vhd}
analyze -library WORK -format vhdl {/home/abdelazeem/RISCV/RTL/carry_generator.vhd}
analyze -library WORK -format vhdl {/home/abdelazeem/RISCV/RTL/sum_generator.vhd}
analyze -library WORK -format vhdl {/home/abdelazeem/RISCV/RTL/PC.vhd}
analyze -library WORK -format vhdl {/home/abdelazeem/RISCV/RTL/reg.vhd}
analyze -library WORK -format vhdl {/home/abdelazeem/RISCV/RTL/branch_comp.vhd}
analyze -library WORK -format vhdl {/home/abdelazeem/RISCV/RTL/IR.vhd}
analyze -library WORK -format vhdl {/home/abdelazeem/RISCV/RTL/CU.vhd}
analyze -library WORK -format vhdl {/home/abdelazeem/RISCV/RTL/comparator.vhd}
analyze -library WORK -format vhdl {/home/abdelazeem/RISCV/RTL/logic_block.vhd}
analyze -library WORK -format vhdl {/home/abdelazeem/RISCV/RTL/ALU.vhd}
analyze -library WORK -format vhdl {/home/abdelazeem/RISCV/RTL/datapath.vhd}
analyze -library WORK -format vhdl {/home/abdelazeem/RISCV/RTL/RISCV.vhd}
# elaborate top entity , set the variables
elaborate RISCV -architecture structural -library WORK -parameters " BPU_TAG_FIELD_SIZE = 8 , BPU_SET_FIELD_SIZE = 3, BPU_LINES_PER_SET = 4"
# verify the correct creation of the clock
report_clock > clock_test.rpt

current_design 

check_design
source ./CONS/cons.tcl
link
uniquify

# compile ultra command , in order to perform an advanced synthesis
compile_ultra
# perform retiming on the compiled netlist
optimize_register
ungroup -all -flatten
change_names -hierarchy -rules verilog

check_design
report_constraint -all_violators


report_area > ./report/synth_area.rpt
report_cell > ./report/synth_cells.rpt
report_qor  > ./report/synth_qor.rpt
report_power > ./report/power.rpt
report_resources > ./report/synth_resources.rpt
report_timing -path full -delay max -max_paths 10 -nworst 1 > ./report/synth_timing.rpt 

# input / output constraints
write_sdc  output/${design}.sdc 
# write verilog netlist
define_name_rules  no_case -case_insensitive
change_names -rule no_case -hierarchy
change_names -rule verilog -hierarchy
set verilogout_no_tri	 true
set verilogout_equation  false

write -hierarchy -format verilog -output output/${design}.v 
write -f ddc -hierarchy -output output/${design}.ddc 

# delay description
write_sdf output/${design}.sdf 

exit
