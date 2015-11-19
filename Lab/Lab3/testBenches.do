vlog -reportprogress 500 -work work datamemory.t.v datamemory.v
vsim -voptargs="+acc" datamemorytestbenchharness

add wave -position insertpoint  \
sim:/datamemorytestbenchharness/dataOut \
sim:/datamemorytestbenchharness/address \
sim:/datamemorytestbenchharness/dataIn \
sim:/datamemorytestbenchharness/writeEnable \
sim:/datamemorytestbenchharness/clk \
sim:/datamemorytestbenchharness/begintest \
sim:/datamemorytestbenchharness/endtest \
sim:/datamemorytestbenchharness/dutpassed
run -all

wave zoom full