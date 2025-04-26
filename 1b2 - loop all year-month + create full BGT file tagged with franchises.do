/*----------------------------------------------------------------------------*/

* This do-file identifies the contract chains + the chains that settled but are not in the contract data

/*----------------------------------------------------------------------------*/
*STEPS:
	*0. Set directories.
	*1. Generate each monthly matched BGT-contract file.
	*2. Append all monthly matched files (from 2007_01 to `last_year'_12)
/*-----------------------------------------------------------------------------*/


*------------------------------------------------------------------------------*
* 0) Set directories
*------------------------------------------------------------------------------*
clear  all
global master_path 	"[INSERT USER'S RELEVANT PATH]"
global data_bgt_c   "${master_path}/data/bgt/cln"
global data_mat_c 	"${master_path}/data/matched_bgt_contract/cln"
global data_con_c 	"${master_path}/data/contract/cln"
global do_file_path "${master_path}/do files"
*
local last_year 	"2022"
*------------------------------------------------------------------------------*



*------------------------------------------------------------------------------*
* 1) Generate the monthly merged (BGT-contract) file, from 2007 to `last_year'
*------------------------------------------------------------------------------*

// Part 1: 2007-`last_year'
foreach year  of numlist 2007 2010/`last_year' {
foreach month in 		 01 02 03 04 05 06 07 08 09 10 11 12 {

use "${data_bgt_c}/monthly/`year'_`month'", clear

* a) Execute do file for matching, looped over each month
do "${do_file_path}/1b1 - Tag franchises in BGT + merge with CZ"


* b) Merge: with contract data + Keep: key variables
merge m:1 franchise_id using "${data_con_c}/franchise_contracts_clean", keepusing(franchise naics4_contracts)
drop  if  _merge == 2
drop 	  _merge


* c) Save: file with BGT data tagged with franchises
compress
save "${data_mat_c}/monthly/`year'_`month' - BGT tagged with franchises", replace


* d) Save: file with merged BGT-contract data
drop if franchise_id == .
save 	"${data_mat_c}/monthly/`year'_`month' - BGT tagged with franchises + merged with contract data", replace
}
}




*------------------------------------------------------------------------------*
* 2) Append 2007_01 to `last_year'_12
*------------------------------------------------------------------------------*
use "${data_mat_c}/monthly/2007_01 - BGT tagged with franchises + merged with contract data", clear


* a) Append: rest of 2007
foreach year  of numlist 2007 {
foreach month in 		 02 03 04 05 06 07 08 09 10 11 12 {
append  using "${data_mat_c}/monthly/`year'_`month' - BGT tagged with franchises + merged with contract data"
}
}



* b) Append: 2010-`last_year'
foreach year  of numlist 2010/`last_year' {
foreach month in 		 01 02 03 04 05 06 07 08 09 10 11 12 {
append  using "${data_mat_c}/monthly/`year'_`month' - BGT tagged with franchises + merged with contract data"
}
}


* c) Keep: 2007-2021
keep if yq <= 247


* d) Save: full matched file
compress
save "${data_mat_c}/BGT tagged with franchises + merged with contract data - 2007-2021", replace
