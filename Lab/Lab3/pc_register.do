vlog -reportprogress 500 -work work pc_register.t.v pc_register.v
vsim -voptargs="+acc" pc_register_test_bench_harness

add wave -position insertpoint  \
sim:/pc_register_test_bench_harness/pc_reg_in \
sim:/pc_register_test_bench_harness/pc_reg_out \
sim:/pc_register_test_bench_harness/begintest \
sim:/pc_register_test_bench_harness/endtest \
sim:/pc_register_test_bench_harness/dutpassed
run -all

wave zoom full