/*----------------------------------------------------------------------------*/

* This do-file creates a file with the list of treated industries.

/*----------------------------------------------------------------------------*/
*STEPS:
	*0. Set directories.
	*1. Generate file with list of treated industries.
/*-----------------------------------------------------------------------------*/


*------------------------------------------------------------------------------*
* 0) Set directories
*------------------------------------------------------------------------------*
clear  all

global master_path 	"[INSERT USER'S RELEVANT PATH]"
global data_mat_c  	"${master_path}/data/matched_bgt_contract/cln"
global data_waag_c 	"${master_path}/data/wa_ag/cln"
*
global key_vars		"bgtjobid franchise franchise_id yq naics4_job_ads"

local  first_year	"2007"
local  last_year	"2021"




*------------------------------------------------------------------------------*
* 1) Generate file with list of treated industries
*------------------------------------------------------------------------------*
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
drop	  _merge



* c) Identify: treated industries
keep if  treated == 1

gen	  	obs = 1 
gegen 	ads_by_chain 		= sum(obs) if treated == 1 & naics4 != ., by(franchise_id)
gegen 	ads_by_chain_ind 	= sum(obs) if treated == 1 & naics4 != ., by(franchise_id naics4)

gen 	ads_by_chain_ind_sh = ads_by_chain_ind / ads_by_chain * 100
gen 	treated_industry    = 1 if ads_by_chain_ind_sh >= 1 & ads_by_chain_ind_sh != .
gegen 	treated_industry_2  = min(treated_industry), by(naics4)
drop 	treated_industry 
rename	treated_industry_2 treated_industry 
replace treated_industry = 0 if treated_industry == . & naics4 != .	
tab 	treated_industry, miss



* d) Keep: only treated industries
keep if treated_industry == 1
gegen 	unique_naics = tag(naics4)
keep if unique_naics == 1
codebook naics4
keep 	naics4 treated_industry
sort 	naics4 



* e) Save: file with list of treated industries
compress
save "${data_mat_c}/BGT - list of treated industries - `first_year'-`last_year'.dta", replace
