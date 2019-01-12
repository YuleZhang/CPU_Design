
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name SRAM -dir "E:/ISEProject/SRAM/planAhead_run_2" -part xc3s1200efg320-4
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "E:/ISEProject/SRAM/SRAM.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {E:/ISEProject/SRAM} }
set_property target_constrs_file "SRAM.ucf" [current_fileset -constrset]
add_files [list {SRAM.ucf}] -fileset [get_property constrset [current_run]]
link_design
