
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name ALU_desigin -dir "E:/ALU_desigin/planAhead_run_1" -part xc3s1200efg320-4
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "E:/ALU_desigin/ALU_desigin.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {E:/ALU_desigin} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "ALU_desigin.ucf" [current_fileset -constrset]
add_files [list {ALU_desigin.ucf}] -fileset [get_property constrset [current_run]]
link_design
