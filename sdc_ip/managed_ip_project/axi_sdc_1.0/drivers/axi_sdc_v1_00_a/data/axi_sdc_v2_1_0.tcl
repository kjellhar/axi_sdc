

proc generate {drv_handle} {
	xdefine_include_file $drv_handle "xparameters.h" "axi_sdc" "NUM_INSTANCES" "DEVICE_ID"  "C_S00_AXI_Ctrl_BASEADDR" "C_S00_AXI_Ctrl_HIGHADDR"
}
