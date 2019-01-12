
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name clock -dir "E:/clock/planAhead_run_4" -part xc3s1200efg320-4
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "E:/clock/clock.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {E:/clock} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "clock.ucf" [current_fileset -constrset]
add_files [list {clock.ucf}] -fileset [get_property constrset [current_run]]
link_design
