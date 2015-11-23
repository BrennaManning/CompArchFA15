vdel - lib work - all
vlib work

vlog -reportprogress 300 -work work singlecyclecpu.t.v singlecyclecpu.v instruction_memory.t.v instruction_memory.v datamemory.t.v datamemory.v register_file.t.v register_file.v instructiondecoder.t.v instructiondecoder.v mux32.t.v mux32.v mux5.t.v mux5.v pc_register.t.v pc_register.v ra_register.t.v ra_register.v alu_lab1.t.v alu_lab1.v shift_left.t.v shift_left.v concatenate.t.v concatenate.v sign_extend.t.v sign_extend.v
vsim -voptargs="+acc" singlecyclecpu_test_bench_harness

add wave -position insertpoint \
sim:/singlecyclecpu_test_bench_harness/clk \
sim:/singlecyclecpu_test_bench_harness/dut/dw_reg

run 10000

wave zoom full