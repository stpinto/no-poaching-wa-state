/*----------------------------------------------------------------------------*/

* This do-file creates a file with monthly tightness indicator faced by each chain + the quartile assignment.

/*----------------------------------------------------------------------------*/
*STEPS:
	*0. Set directories.
	*1. Create a file with average tightness faced by each chain and the tightness quartile they are assigned to.
/*-----------------------------------------------------------------------------*/


*------------------------------------------------------------------------------*
* 0) Set directories
*------------------------------------------------------------------------------*
clear  all

global master_path 	"[INSERT USER'S RELEVANT PATH]"
global data_mat_c  	"${master_path}/data/matched_bgt_contract/cln"
global data_laus_c 	"${master_path}/data/laus/cln"
*
global key_vars		"bgtjobid franchise_id date cz_code_2000"

local  first_year	"2007"
local  last_year	"2021"




*------------------------------------------------------------------------------*
* 1) Generate file with average tightness faced by chain + quartiles
*------------------------------------------------------------------------------*
use "${data_mat_c}/BGT tagged with franchises + merged with contract data - `first_year'-`last_year'.dta", clear


* a) Keep: key variables 
keep ${key_vars}



* b) Generate: ym variable + Drop: year before 2017 + after 2021
gen 	year  = year(date)
gen 	month = month(date)

drop if year  < 2017
drop if year  > 2021

gen 	ym = ym(year,month)
format 	ym %tm

drop 	year month date



* c) Merge: with labor market tightness file
merge m:1 ym cz_code_2000 using "${data_laus_c}/LAUS + BGT - ym - cz - 2017m1-2021m12 - labor market tightness"
keep if  _merge == 3
drop 	 _merge
codebook franchise_id
format 	 lm_tightness %9.3f



* d) Collapse: into mean labor market tightness by chain + Generate quantiles
collapse (mean) lm_tightness, by(franchise_id)
xtile 			lm_tightness_quart = lm_tightness, nq(4)
sort 			lm_tightness



* e) Save: file with labor market tightness by chain
compress
save "${data_mat_c}/BGT - labor market tightness by chain - average 2017m1-2021m12.dta", replace
