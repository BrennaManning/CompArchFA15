vlog -reportprogress 500 -work work instruction_memory.t.v instruction_memory.v
vsim -voptargs="+acc" instruction_memory_test_bench_harness

add wave -position insertpoint  \
sim:/instruction_memory_test_bench_harness/address \
sim:/instruction_memory_test_bench_harness/instr_mem_out \
sim:/instruction_memory_test_bench_harness/begintest \
sim:/instruction_memory_test_bench_harness/endtest \
sim:/instruction_memory_test_bench_harness/dutpassed
run -all

wave zoom full