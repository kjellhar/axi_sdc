# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
	set Page0 [ipgui::add_page $IPINST -name "Page 0" -layout vertical]
	set Component_Name [ipgui::add_param $IPINST -parent $Page0 -name Component_Name]
	set C_S00_AXIS_DataOut_TDATA_WIDTH [ipgui::add_param $IPINST -parent $Page0 -name C_S00_AXIS_DataOut_TDATA_WIDTH]
	set C_M00_AXIS_DataIn_START_COUNT [ipgui::add_param $IPINST -parent $Page0 -name C_M00_AXIS_DataIn_START_COUNT]
	set C_M00_AXIS_DataIn_TDATA_WIDTH [ipgui::add_param $IPINST -parent $Page0 -name C_M00_AXIS_DataIn_TDATA_WIDTH]
	set C_S00_AXI_Ctrl_ADDR_WIDTH [ipgui::add_param $IPINST -parent $Page0 -name C_S00_AXI_Ctrl_ADDR_WIDTH]
	set C_S00_AXI_Ctrl_DATA_WIDTH [ipgui::add_param $IPINST -parent $Page0 -name C_S00_AXI_Ctrl_DATA_WIDTH]
}

proc update_PARAM_VALUE.C_S00_AXIS_DataOut_TDATA_WIDTH { PARAM_VALUE.C_S00_AXIS_DataOut_TDATA_WIDTH } {
	# Procedure called to update C_S00_AXIS_DataOut_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXIS_DataOut_TDATA_WIDTH { PARAM_VALUE.C_S00_AXIS_DataOut_TDATA_WIDTH } {
	# Procedure called to validate C_S00_AXIS_DataOut_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M00_AXIS_DataIn_START_COUNT { PARAM_VALUE.C_M00_AXIS_DataIn_START_COUNT } {
	# Procedure called to update C_M00_AXIS_DataIn_START_COUNT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M00_AXIS_DataIn_START_COUNT { PARAM_VALUE.C_M00_AXIS_DataIn_START_COUNT } {
	# Procedure called to validate C_M00_AXIS_DataIn_START_COUNT
	return true
}

proc update_PARAM_VALUE.C_M00_AXIS_DataIn_TDATA_WIDTH { PARAM_VALUE.C_M00_AXIS_DataIn_TDATA_WIDTH } {
	# Procedure called to update C_M00_AXIS_DataIn_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M00_AXIS_DataIn_TDATA_WIDTH { PARAM_VALUE.C_M00_AXIS_DataIn_TDATA_WIDTH } {
	# Procedure called to validate C_M00_AXIS_DataIn_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_Ctrl_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_Ctrl_ADDR_WIDTH } {
	# Procedure called to update C_S00_AXI_Ctrl_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_Ctrl_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_Ctrl_ADDR_WIDTH } {
	# Procedure called to validate C_S00_AXI_Ctrl_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_Ctrl_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_Ctrl_DATA_WIDTH } {
	# Procedure called to update C_S00_AXI_Ctrl_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_Ctrl_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_Ctrl_DATA_WIDTH } {
	# Procedure called to validate C_S00_AXI_Ctrl_DATA_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.C_S00_AXI_Ctrl_DATA_WIDTH { MODELPARAM_VALUE.C_S00_AXI_Ctrl_DATA_WIDTH PARAM_VALUE.C_S00_AXI_Ctrl_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_Ctrl_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_Ctrl_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_Ctrl_ADDR_WIDTH { MODELPARAM_VALUE.C_S00_AXI_Ctrl_ADDR_WIDTH PARAM_VALUE.C_S00_AXI_Ctrl_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_Ctrl_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_Ctrl_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M00_AXIS_DataIn_TDATA_WIDTH { MODELPARAM_VALUE.C_M00_AXIS_DataIn_TDATA_WIDTH PARAM_VALUE.C_M00_AXIS_DataIn_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M00_AXIS_DataIn_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_M00_AXIS_DataIn_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M00_AXIS_DataIn_START_COUNT { MODELPARAM_VALUE.C_M00_AXIS_DataIn_START_COUNT PARAM_VALUE.C_M00_AXIS_DataIn_START_COUNT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M00_AXIS_DataIn_START_COUNT}] ${MODELPARAM_VALUE.C_M00_AXIS_DataIn_START_COUNT}
}

proc update_MODELPARAM_VALUE.C_S00_AXIS_DataOut_TDATA_WIDTH { MODELPARAM_VALUE.C_S00_AXIS_DataOut_TDATA_WIDTH PARAM_VALUE.C_S00_AXIS_DataOut_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXIS_DataOut_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXIS_DataOut_TDATA_WIDTH}
}

