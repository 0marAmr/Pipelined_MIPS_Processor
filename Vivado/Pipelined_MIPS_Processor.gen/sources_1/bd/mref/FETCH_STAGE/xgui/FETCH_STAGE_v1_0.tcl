# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "ADDRESS_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "INSTR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PROGRAM" -parent ${Page_0}


}

proc update_PARAM_VALUE.ADDRESS_WIDTH { PARAM_VALUE.ADDRESS_WIDTH } {
	# Procedure called to update ADDRESS_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADDRESS_WIDTH { PARAM_VALUE.ADDRESS_WIDTH } {
	# Procedure called to validate ADDRESS_WIDTH
	return true
}

proc update_PARAM_VALUE.INSTR_WIDTH { PARAM_VALUE.INSTR_WIDTH } {
	# Procedure called to update INSTR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.INSTR_WIDTH { PARAM_VALUE.INSTR_WIDTH } {
	# Procedure called to validate INSTR_WIDTH
	return true
}

proc update_PARAM_VALUE.PROGRAM { PARAM_VALUE.PROGRAM } {
	# Procedure called to update PROGRAM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PROGRAM { PARAM_VALUE.PROGRAM } {
	# Procedure called to validate PROGRAM
	return true
}


proc update_MODELPARAM_VALUE.ADDRESS_WIDTH { MODELPARAM_VALUE.ADDRESS_WIDTH PARAM_VALUE.ADDRESS_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADDRESS_WIDTH}] ${MODELPARAM_VALUE.ADDRESS_WIDTH}
}

proc update_MODELPARAM_VALUE.INSTR_WIDTH { MODELPARAM_VALUE.INSTR_WIDTH PARAM_VALUE.INSTR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INSTR_WIDTH}] ${MODELPARAM_VALUE.INSTR_WIDTH}
}

proc update_MODELPARAM_VALUE.PROGRAM { MODELPARAM_VALUE.PROGRAM PARAM_VALUE.PROGRAM } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PROGRAM}] ${MODELPARAM_VALUE.PROGRAM}
}

