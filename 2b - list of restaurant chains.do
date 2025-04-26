/*----------------------------------------------------------------------------*/

* This do-file creates a file with the list of restaurant franchise chains that were treated.

/*----------------------------------------------------------------------------*/
*STEPS:
	*0. Set directories.
	*1. Generate file with list of restaurant franchise chains.
/*-----------------------------------------------------------------------------*/


*------------------------------------------------------------------------------*
* 0) Set directories
*------------------------------------------------------------------------------*
clear  all

global master_path 	"[INSERT USER'S RELEVANT PATH]"
global data_mat_c  	"${master_path}/data/matched_bgt_contract/cln"
global data_waag_c 	"${master_path}/data/wa_ag/cln"
*
global key_vars		"bgtjobid franchise franchise_id yq naics4_job_ads naics4d_ag naics4_contracts"

local  first_year	"2007"
local  last_year	"2021"

set matsize 11000
set scheme cleanplots

********************************************************************************
*** 1) Generate file with list of treated restaurant chains - that can then be merged with the full BGT data
********************************************************************************
use "${data_mat_c}/BGT tagged with franchises + merged with contract data - `first_year'-`last_year'.dta", clear


* a) Keep: key variables
keep ${key_vars}
rename naics4_job_ads naics4



* b) Merge: with list of chains that settled with WA AG

// Identify the chains who agreed to stop including no poaching clauses (treated chains)
merge m:1 franchise using "${data_waag_c}/Chain settlement dates", keepusing(settlement_date)
tab 	  franchise if _merge == 2, miss
drop if   _merge == 2

// Treated: assign status if chain entered into AOD
gen 	  treated = 1 if _merge  == 3
replace   treated = 0 if treated == . 	
tab 	  treated, miss	
codebook  franchise_id if treated == 1 	
drop	  _merge



* c) Identify + Keep: restaurant industry chains
keep if treated == 1	
gen		naics4d = naics4_contracts 
replace naics4d = naics4d_ag if naics4d == .
keep if naics4d == 7225



* d) Keep: only one obs per chain
gegen 	 unique_franchise = tag(franchise_id)
keep if  unique_franchise == 1
keep 	 franchise_id franchise
sort 	 franchise_id 



* e) Save: file with list of treated restaurant chains
compress
save "${data_mat_c}/BGT - list of treated chains in restaurant industry.dta", replace
