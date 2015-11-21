vlog -reportprogress 500 -work work sign_extend.t.v sign_extend.v
vsim -voptargs="+acc" sign_extend_test_bench_harness

add wave -position insertpoint  \
sim:/sign_extend_test_bench_harness/instruction \
sim:/sign_extend_test_bench_harness/immediate \
sim:/sign_extend_test_bench_harness/sign_ext_out \
sim:/sign_extend_test_bench_harness/begintest \
sim:/sign_extend_test_bench_harness/endtest \
sim:/sign_extend_test_bench_harness/dutpassed
run -all

wave zoom full