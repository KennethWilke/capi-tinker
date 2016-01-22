echo Watching Response interface waveforms

# PSL to AFU signals
add wave -position insertpoint sim:/top/a0/ha_rvalid
add wave -position insertpoint -radix hexadecimal sim:/top/a0/ha_rtag
add wave -position insertpoint sim:/top/a0/ha_rtagpar
add wave -position insertpoint -radix hexadecimal sim:/top/a0/ha_response
add wave -position insertpoint -radix decimal sim:/top/a0/ha_rcredits
add wave -position insertpoint sim:/top/a0/ha_rcachestate
add wave -position insertpoint -radix decimal sim:/top/a0/ha_rcachepos
