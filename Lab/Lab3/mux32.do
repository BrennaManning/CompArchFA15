vlog -reportprogress 500 -work work mux32.t.v 
vsim -voptargs="+acc" mux32testharness

add wave -position insertpoint  \
sim:/mux32testharness/muxin1 \
sim:/mux32testharness/muxin2 \
sim:/mux32testharness/muxcontrol \
sim:/mux32testharness/muxout \
sim:/mux32testharness/begintest \
sim:/mux32testharness/endtest \
sim:/mux32testharness/dutpassed 
run -all

wave zoom full