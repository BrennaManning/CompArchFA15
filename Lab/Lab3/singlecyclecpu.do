vdel - lib work - all
vlib work

vlog -reportprogress 300 -work work singlecyclecpu.t.v singlecyclecpu.v
vsim -voptargs="+acc" singlecyclecpu_test_bench_harness

run -all