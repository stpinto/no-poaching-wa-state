*** Date created:  Oct 11, 2021
*** Date modified: Apr 30, 2024
/*----------------------------------------------------------------------------*/

* This is the master do-file for the franchising paper + no-poach paper

*------------------------------------------------------------------------------*
* 0) Set directories
*------------------------------------------------------------------------------*
clear  all
global master_path 	"[INSERT USER'S RELEVANT PATH]"
global file_path 	"${master_path}/do files"


*------------------------------------------------------------------------------*
* 1) Execute each do-file
*------------------------------------------------------------------------------*

* a) Generate: auxiliary data sets, to be merged later with BGT data
do "${file_path}/A0 - Install Stata commands"

// i) 	Deflator, crosswalk, list of chains and dates
do "${file_path}/A1 - deflator pcepi"
do "${file_path}/A2 - usda county-to-cz crosswalk"
do "${file_path}/A3 - wa ag list of chains and settlement dates"
do "${file_path}/A4 - franchise_name-franchise_id correspondence"
do "${file_path}/A5 - naics-4d download and cleaning"


* b) Generate: baseline BGT data
// i) all year-month files and full 2007-2021 data
do "${file_path}/1a - bgt year-month files + year files + append full 2007-2021"

// ii) matched BGT-franchise tagged files
do "${file_path}/1b2 - loop all year-month + create full BGT file tagged with franchises" // do file 1b2 includes instructions to execute file 1b1

// iii) main baseline file to be used for regressions
do "${file_path}/1c - baseline file for regressions"


* c) Generate: ancillary files that are necessary for later steps + robustness checks
do "${file_path}/2a - list of full and inverse sample industries"
do "${file_path}/2b - list of restaurant chains"
do "${file_path}/2c1 - laus + bgt - labor market tightness indicator"
do "${file_path}/2c2 - chain-level tightness indicator and quartiles"


* d) Generate: outputs, part 1 -- summary statistics

// Summary statistics for no-poach paper + Job ads graph
do "${file_path}/3a1 - summary stats - tables a4 and a5"
do "${file_path}/3a2 - summary stats - top industries"
do "${file_path}/3a3 - summary stats - same-industry - obs with and without estimates"
do "${file_path}/3a4 - summary stats - inverse - obs with and without estimates"


* e) Generate: outputs, part 2 -- regression tables and figures

* i)   Baseline: Same-industry + Inverse BGT 
do "${file_path}/3b1 - regression tables and figures - same + inverse bgt - baseline"

* ii)  Robustness checks
do "${file_path}/3b2 - regression tables and figures - same + inverse - no indeed and linkedin"
do "${file_path}/3b3 - regression tables and figures - same + inverse - pre-March-2020"
do "${file_path}/3b4 - regression tables and figures - same + inverse - by lm_tightness"
do "${file_path}/3c - regression tables and figures - same + inverse - non-AOD chains"
do "${file_path}/3d1 - regression tables and figures - same - by pay frequency"
do "${file_path}/3d2 - regression tables and figures - inverse - by pay frequency"
do "${file_path}/3e - regression tables and figures - same + inverse - 6d occupations"
do "${file_path}/3f - regression tables and figures - inverse - restaurants"
