vlog -reportprogress 500 -work work shift_left.t.v shift_left.v
vsim -voptargs="+acc" shift_left_test_bench_harness

add wave -position insertpoint  \
sim:/shift_left_test_bench_harness/sign_ext \
sim:/shift_left_test_bench_harness/shift_left_out \
sim:/shift_left_test_bench_harness/begintest \
sim:/shift_left_test_bench_harness/endtest \
sim:/shift_left_test_bench_harness/dutpassed
run -all

wave zoom full