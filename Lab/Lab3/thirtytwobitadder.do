vdel - lib work - all
vlib work

vlog -reportprogress 300 -work work thirtytwobitadder.t.v
vsim -voptargs="+acc" addertestharness


add wave -position insertpoint/  \
sim:/addertestharness/a\
sim:/addertestharness/b \
sim:/addertestharness/sum \
sim:/addertestharness/begintest \
sim:/addertestharness/dutpassed \

run -all

wave zoom full
