/*----------------------------------------------------------------------------*/

* This do-file creates the base files to be used when implementing the empirical specification

/*----------------------------------------------------------------------------*/
*STEPS:
	*0. Set directories.
	*1. Drop observations with missing salary + restrict to 2015-2021 period for the matched BGT-franchise data.
	*2. Drop observations with missing salary + restrict to 2015-2021 period for the full BGT-franchise data.
/*-----------------------------------------------------------------------------*/


*------------------------------------------------------------------------------*
* 0) Set directories
*------------------------------------------------------------------------------*
clear  all
global master_path 		"[INSERT USER'S RELEVANT PATH]"
global data_bgt_c 		"${master_path}/data/bgt/cln"
global data_mat_c 		"${master_path}/data/matched_bgt_contract/cln"
*
global key_vars_matched "bgtjobid franchise franchise_id salary yq payfrequency naics4_job_ads"
global key_vars_bgt 	"date bgtjobid employer naics4 fips soc salary payfrequency"

local  first_year		"2015"
local  last_year		"2021"

set matsize 11000
set scheme cleanplots
*------------------------------------------------------------------------------*



*------------------------------------------------------------------------------*
* 1) Generate files for matched data (2015-2021) that can then be merged with the full BGT data
*------------------------------------------------------------------------------*
use "${data_mat_c}/BGT tagged with franchises + merged with contract data - 2007-2021.dta", clear

* a) Keep: key variables + observations with a salary
keep ${key_vars_matched}
keep if salary != . 
drop 	salary


* b) Keep: only data from 2010q1 / 2015q1 onward + Encode: payfrequency
gen 	year = yofd(dofq(yq))
keep if year > `first_year'	
drop 	yq year

encode 	payfrequency, gen(payfrequency_2)
drop 	payfrequency
rename 	payfrequency_2 payfrequency
tab 	payfrequency, miss

	
* c) Save: temp file
compress
save "${data_mat_c}/BGT tagged with franchises + merged with contract data - `first_year'-`last_year' - version to match with BGT.dta", replace




*------------------------------------------------------------------------------*
* 2) Generate file for full BGT data with all job ads (2015-2021)
*------------------------------------------------------------------------------*
use "${data_bgt_c}/all_2007_`last_year'.dta", clear
set matsize 11000
set more off 

* a) Keep: only key variables + drop/destring/trim + Encode: payfrequency
keep 	${key_vars_bgt}
replace employer = strtrim(employer)		
drop if employer == "na"	
replace soc 	 =  "" if soc == "na"		
drop if bgtjobid == .						
drop if date 	 == .	

foreach var in payfrequency {
replace `var' = "" if `var' == "na"
encode 	`var', gen(`var'_2)
drop 	`var'
rename 	`var'_2 `var'
}



* b) Rename + fix + generate variables
// rename
rename fips fips_code 
rename soc  soc_6d

// generate year
gen year = year(date)



* c) Keep: only data from `first_year' onward
keep if year >= `first_year'
drop 	year 
compress



* d) Drop: observations with missing salary
drop if salary == .		


* e) Save: BGT file for `first_year'-`last_year' (with salary info)
compress
save "${data_bgt_c}/all_`first_year'_`last_year' - version to merge with matched.dta", replace
