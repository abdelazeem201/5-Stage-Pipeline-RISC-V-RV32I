create_clock -name "CLK" -period 2 CLK
# forces a combinational max delay from any input to any output
set_max_delay 2 -from [ all_inputs ] -to [ all_outputs ]
# clock uncertainty ( jitter )
set_clock_uncertainty 0.07 [ get_clocks CLK]
#max input delay
set_input_delay 0.5 -max -clock CLK [ remove_from_collection [ all_inputs ] CLK]
#max output delay
set_output_delay 0.5 -max -clock CLK [ all_outputs ]
# output load equal to the buffer input capacitance of the library
set OUT_LOAD [ load_of NangateOpenCellLibrary / BUF_X4 /A]
set_load $OUT_LOAD [ all_outputs ]
