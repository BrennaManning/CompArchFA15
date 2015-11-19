vlog -reportprogress 500 -work work ra_register.t.v ra_register.v
vsim -voptargs="+acc" ra_register_test_bench_harness

add wave -position insertpoint  \
sim:/ra_register_test_bench_harness/ra_reg_in \
sim:/ra_register_test_bench_harness/jal \
sim:/ra_register_test_bench_harness/ra_reg_out \
sim:/ra_register_test_bench_harness/begintest \
sim:/ra_register_test_bench_harness/endtest \
sim:/ra_register_test_bench_harness/dutpassed
run -all

wave zoom full