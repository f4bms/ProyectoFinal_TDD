transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+D:/Proyecto_Final/ProyectoFinal_TDD/ProyectoTDD {D:/Proyecto_Final/ProyectoFinal_TDD/ProyectoTDD/sum_N.sv}
vlog -sv -work work +incdir+D:/Proyecto_Final/ProyectoFinal_TDD/ProyectoTDD {D:/Proyecto_Final/ProyectoFinal_TDD/ProyectoTDD/Proyecto2.sv}
vlog -sv -work work +incdir+D:/Proyecto_Final/ProyectoFinal_TDD/ProyectoTDD {D:/Proyecto_Final/ProyectoFinal_TDD/ProyectoTDD/nBitsSubstractor.sv}
vlog -sv -work work +incdir+D:/Proyecto_Final/ProyectoFinal_TDD/ProyectoTDD {D:/Proyecto_Final/ProyectoFinal_TDD/ProyectoTDD/mux2to1.sv}
vlog -sv -work work +incdir+D:/Proyecto_Final/ProyectoFinal_TDD/ProyectoTDD {D:/Proyecto_Final/ProyectoFinal_TDD/ProyectoTDD/fullAdder.sv}
vlog -sv -work work +incdir+D:/Proyecto_Final/ProyectoFinal_TDD/ProyectoTDD {D:/Proyecto_Final/ProyectoFinal_TDD/ProyectoTDD/extend.sv}
vlog -sv -work work +incdir+D:/Proyecto_Final/ProyectoFinal_TDD/ProyectoTDD {D:/Proyecto_Final/ProyectoFinal_TDD/ProyectoTDD/alu.sv}
vlog -sv -work work +incdir+D:/Proyecto_Final/ProyectoFinal_TDD/ProyectoTDD {D:/Proyecto_Final/ProyectoFinal_TDD/ProyectoTDD/InstMemory.sv}
vlog -sv -work work +incdir+D:/Proyecto_Final/ProyectoFinal_TDD/ProyectoTDD {D:/Proyecto_Final/ProyectoFinal_TDD/ProyectoTDD/ControlUnit.sv}
vlog -sv -work work +incdir+D:/Proyecto_Final/ProyectoFinal_TDD/ProyectoTDD {D:/Proyecto_Final/ProyectoFinal_TDD/ProyectoTDD/RegisterFile.sv}
vlog -sv -work work +incdir+D:/Proyecto_Final/ProyectoFinal_TDD/ProyectoTDD {D:/Proyecto_Final/ProyectoFinal_TDD/ProyectoTDD/ConditionalLogic.sv}
vlog -sv -work work +incdir+D:/Proyecto_Final/ProyectoFinal_TDD/ProyectoTDD {D:/Proyecto_Final/ProyectoFinal_TDD/ProyectoTDD/Decoder.sv}
vlog -sv -work work +incdir+D:/Proyecto_Final/ProyectoFinal_TDD/ProyectoTDD {D:/Proyecto_Final/ProyectoFinal_TDD/ProyectoTDD/MainDecoder.sv}
vlog -sv -work work +incdir+D:/Proyecto_Final/ProyectoFinal_TDD/ProyectoTDD {D:/Proyecto_Final/ProyectoFinal_TDD/ProyectoTDD/ALUDecoder.sv}
vlog -sv -work work +incdir+D:/Proyecto_Final/ProyectoFinal_TDD/ProyectoTDD {D:/Proyecto_Final/ProyectoFinal_TDD/ProyectoTDD/PCLogic.sv}
vlog -sv -work work +incdir+D:/Proyecto_Final/ProyectoFinal_TDD/ProyectoTDD {D:/Proyecto_Final/ProyectoFinal_TDD/ProyectoTDD/ConditionCheck.sv}
vlog -sv -work work +incdir+D:/Proyecto_Final/ProyectoFinal_TDD/ProyectoTDD {D:/Proyecto_Final/ProyectoFinal_TDD/ProyectoTDD/ProcesadorARMv4.sv}

vlog -sv -work work +incdir+D:/Proyecto_Final/ProyectoFinal_TDD/ProyectoTDD {D:/Proyecto_Final/ProyectoFinal_TDD/ProyectoTDD/test_Proyecto2.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  test_Proyecto2

add wave *
view structure
view signals
run -all
