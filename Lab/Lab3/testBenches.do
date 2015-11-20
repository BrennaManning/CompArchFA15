vlog -reportprogress 500 -work work datamemory.t.v datamemory.v allModules.t.v
vsim -voptargs="+acc" allTestBenchesHarness

add wave -position insertpoint  \
sim:/allTestBenchesHarness/startTests \
sim:/allTestBenchesHarness/dataMemoryDUT \
sim:/allTestBenchesHarness/dataMemoryDone 

run -all

wave zoom full