vlog -reportprogress 500 -work work register_file.t.v register_file.v
vsim -voptargs="+acc" registerfiletestbenchharness

add wave -position insertpoint  \
sim:/registerfiletestbenchharness/WrEn \
sim:/registerfiletestbenchharness/Dw \
sim:/registerfiletestbenchharness/Aw \
sim:/registerfiletestbenchharness/Aa \
sim:/registerfiletestbenchharness/Ab \
sim:/registerfiletestbenchharness/Da \
sim:/registerfiletestbenchharness/Db \
sim:/registerfiletestbenchharness/clk \
sim:/registerfiletestbenchharness/begintest \
sim:/registerfiletestbenchharness/endtest \
sim:/registerfiletestbenchharness/dutpassed
run -all

wave zoom full