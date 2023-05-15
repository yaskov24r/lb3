SetActiveLib -work
# compile KBOX files
comp -include "$dsn\src\bf4_conc_CA.vhd"
# compile module with SSMC behavioral
comp -include "$dsn\src\KBOX_SSMC_BEHAV.vhd"
# compile module with SSMC structural and components
comp -include "$dsn\src\SUM_N.vhd"
comp -include "$dsn\src\SUB_N.vhd"
comp -include "$dsn\src\MUL_N.vhd"
comp -include "$dsn\src\CMP_N.vhd"
comp -include "$dsn\src\MUX_N.vhd"
comp -include "$dsn\src\SSMC_STRUCT.vhd"
comp -include "$dsn\src\KBOX_SSMC_STRUCT.vhd"
# compile testbench
comp -include "$dsn\src\KBOX_SSMC_TB\KBOX_SSMC_TB.vhd"
# begin simulation
asim +access +r kbox_ssmc_tb
wave 
wave -noreg -decimal -notation 2compl TEST_A
wave -noreg -decimal -notation 2compl TEST_B
wave -noreg -decimal -color 128,0,0 TEST_CMD
#wave -noreg -decimal RES_beh
wave -noreg -decimal -notation 2compl -vbus "RES_behav_HIGH" RES_beh(7) RES_beh(6) RES_beh(5) RES_beh(4)
wave -noreg -decimal -notation 2compl -vbus "RES_behav_LOW" RES_beh(3) RES_beh(2) RES_beh(1) RES_beh(0)
wave -noreg FLC_beh
wave -noreg AGB_beh
wave -noreg AEB_beh
wave -noreg ALB_beh
#wave -noreg -decimal RES_struct
wave -noreg -decimal -notation 2compl -vbus "RES_struct_HIGH" RES_struct(7) RES_struct(6) RES_struct(5) RES_struct(4)
wave -noreg -decimal -notation 2compl -vbus "RES_struct_LOW" RES_struct(3) RES_struct(2) RES_struct(1) RES_struct(0)
wave -noreg FLC_struct
wave -noreg AGB_struct
wave -noreg AEB_struct
wave -noreg ALB_struct
wave -divider "KBOX_SSMC_BEHAV:"
wave -noreg -decimal -notation 2compl -color purple UUT1/OP1
wave -noreg -decimal -notation 2compl -color green UUT1/OP2
wave -divider "KBOX_SSMC_STRUCT:"
wave -noreg -decimal -notation 2compl -color 128,0,128 UUT2/OP1
wave -noreg -decimal -notation 2compl -color 0,128,0 UUT2/OP2
run 320 ns