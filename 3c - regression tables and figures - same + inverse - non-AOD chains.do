/*----------------------------------------------------------------------------*/

* This do-file implements a robustness check where a placebo test is conducted, using franchise chains that did not enter into an AOD (Figures 2A-2C)

/*----------------------------------------------------------------------------*/
*STEPS:
	*0. Set directories.
	*1. Implement the empirical specification to conduct a placebo test and generate Figures 2A-2C.
/*-----------------------------------------------------------------------------*/


*------------------------------------------------------------------------------*
* 0) Set directories
*------------------------------------------------------------------------------*
clear  all
global master_path 		 "[INSERT USER'S RELEVANT PATH]"
global data_bgt_c 		 "${master_path}/data/bgt/cln"
global data_mat_c 		 "${master_path}/data/matched_bgt_contract/cln"
global data_waag_c 		 "${master_path}/data/wa_ag/cln"
global data_defl_c 		 "${master_path}/data/deflator/pce fred/cln"
global data_cwalk_usda_c "${master_path}/data/crosswalk/usda/cln"
global figures 			 "${master_path}/output/figures"
*
global dep_var	  	     "log_salary_r"
global unique_unit_id    "employer_number"
global calendar_period   "yq"
global unit_treat_date1  "settlement_date_yq_aod"

global fixed_effects 	 "yq##cz_code_2000 yq##soc_4d soc_4d##employer_number"
global se_cluster	   	 "employer_number"
global other_specs_did   "autosample pretrends(5) maxit(10000)"
global other_specs_es    "autosample pretrends(5) allhorizons maxit(10000)"

global key_vars			 "${dep_var} ${unique_unit_id} ${calendar_period} ${unit_treat_date1} ${se_cluster} cz_code_2000 soc_4d treated never_treated* placebo_treated"

local  decimals		  	 "3"
local  fmt_pic		  	 "png"
local  vertical_lab	  	 "Coefficient estimate"
local  label_min		 "-0.15"
local  label_max 		 "0.25"
local  label_att_v		 "-0.11"
local  label_att_h		 "10"
local  first_year	  	 "2015"
local  deflator_pce 	 "2017"

set scheme cleanplots



*------------------------------------------------------------------------------*
* 1) Merge + generate regressions tables and figures
*------------------------------------------------------------------------------*
use "${data_bgt_c}/all_`first_year'_2021 - version to merge with matched.dta", clear

* a) Merge: file with the matched data from 2015-2021
merge 1:1 bgtjobid using "${data_mat_c}/BGT tagged with franchises + merged with contract data - `first_year'-2021 - version to match with BGT.dta", keepusing(franchise franchise_id)
drop 	_merge 



* b) Generate: numberical variable for employer names
// initial numeric conversion
gegen 	 employer_number = group(employer)
drop 	 employer

// fixing the numeric conversion for the 614 franchise chains
replace  employer_number = . if franchise_id != . 
replace  employer_number = franchise_id * 10000000 if franchise_id != . 

// Encode string variables + Generate soc_4d
gen 	  soc_4d = substr(soc_6d, 1, 5)

foreach var in soc_4d {
encode `var', gen(`var'_2)
drop   `var'
rename `var'_2 `var'
}



* c) Generate: yq variable
gen    yq = yq(year(date),quarter(date))
format yq %tq



* d) Generate: more date variables + Merge: with deflator
gen    ym = ym(year(date),month(date))
format ym %tm
order  date yq ym
sort   yq franchise_id bgtjobid 

// Merge: with deflator file 
merge m:1 ym using "${data_defl_c}/Deflator_`deflator_pce'.dta"
tab		  yq if _merge == 1, miss
keep if   _merge == 3 
drop 	  _merge ym

// generate real salary
gen 	  salary_r = salary / deflator * 100
gen 	  log_salary_r = ln(salary_r)
label var log_salary_r "Ln(real pay)" 
drop 	  salary salary_r



* e) Generate: variables for diff-in-diff estimation for no-poaching

// Identify the chains who agreed to stop including no poaching clauses (treated chains)
merge m:1 franchise using "${data_waag_c}/Chain settlement dates", keepusing(settlement_date)
tab		  franchise    _merge, miss												
drop if   _merge == 2

// Treated: assign status if chain entered into AOD
gen 	  treated = 1 if _merge  == 3
replace   treated = 0 if treated == . 	
tab 	  treated, miss	
drop	  _merge

// Binary variable: never-treated group -- all
gen 	never_treated = (treated == 0)
tab 	never_treated treated, miss



* f) Merge: with county-to-CZ crosswalk 
destring  fips_code, replace
merge m:1 fips_code using "${data_cwalk_usda_c}/County-CZ crosswalk 2000"	
keep if   _merge == 3	
drop 	  _merge fips_code county_name
compress



********************************************************************************
*** 1) SAME-INDUSTRY SAMPLE

* g) Restrict: BGT sample to ads from industries with at least 1 treated chain + Create: placebo treatment group
// Merge
merge m:1 naics4 using "${data_mat_c}/BGT - list of treated industries - 2007-2021"
tab 	treated treated_industry, miss
replace treated_industry = 0 if treated_industry == . & naics4 != .	
drop 	_merge 

// Keep: treated industries (same-industry sample) + non-treated chains
preserve
keep if  treated_industry == 1 | (treated == 0 & franchise_id != .)	
drop 	 naics4 treated_industry
tab 	 treated, miss	

// Create: placebo treatment group
drop if treated == 1	
gen 	placebo_treated = (franchise_id != .)
tab 	placebo_treated, miss	
tab 	placebo_treated never_treated, miss

gen		settlement_date_yq_aod = 234 if placebo_treated == 1
tab 	settlement_date_yq_aod never_treated, miss

// Keep: only from 2017q1
keep if yq 				>= 228	
drop if yq 				>= 248	

keep	$key_vars
compress



********************************************************************************
*** ALL NON-AOD CHAINS AS PLACEBO TREATED
********************************************************************************

* h) Drop: observation to allow interaction FEs to run
// Drop missing observations for soc_4d
drop if soc_4d == .	



* i1) DiD Regression
local var_lab: 	  var label $dep_var

did_imputation $dep_var $unique_unit_id $calendar_period $unit_treat_date1, fe($fixed_effects) cluster($se_cluster) $other_specs_did
local att : display %4.3f _b[tau]
local ste : display %4.3f _se[tau]


* i2) Event study regression and plot
did_imputation $dep_var $unique_unit_id $calendar_period $unit_treat_date1, fe($fixed_effects) cluster($se_cluster) $other_specs_es

event_plot, default_look ///
	graph_opt(xtitle("Quarters relative to treatment") xlabel(-6(1)13) ///
	ytitle("`vertical_lab'") ylabel(`label_min'(0.05)`label_max', angle(horizontal) format(%9.2f)) ///
	legend(label(1 "Pre-trend coefficients") label(2 "Treatment effects") rows(1) size(small) position(6)) ///
	text(`label_att_v' `label_att_h' "ATT = `att' (`ste')", placement(c) justification(center) size(medsmall) box fcolor(none) lcolor(gray) lwidth(medium) margin(medsmall))) 
graph export "$figures/Figure 2A.`fmt_pic'", replace

restore



********************************************************************************
*** 2) INVERSE SAMPLE

* j) Restrict: BGT sample to ads from industries with no treated chains + Create: placebo treatment group
// Create: placebo treatment group
preserve
drop if treated == 1	
gen 	placebo_treated = (franchise_id != .)
tab 	placebo_treated, miss	
tab 	placebo_treated never_treated, miss

gen		settlement_date_yq_aod = 234 if placebo_treated == 1
tab 	settlement_date_yq_aod never_treated, miss

// Keep (placebo-)treated chains + untreated industries
keep if  treated_industry == 0 | placebo_treated == 1	
tab 	 treated placebo_treated, miss 
drop 	 naics4 treated_industry

// Keep: only from 2017q1
keep if yq 				>= 228	
drop if yq 				>= 248	

keep	$key_vars
compress

// Drop missing observations for soc_4d
drop if soc_4d == .							// 217,473 observations dropped



********************************************************************************
*** ALL NON-AOD CHAINS AS PLACEBO TREATED
********************************************************************************

* k1) DiD Regression
local var_lab: 	  var label $dep_var

did_imputation $dep_var $unique_unit_id $calendar_period $unit_treat_date1, fe($fixed_effects) cluster($se_cluster) $other_specs_did
local att : display %4.3f _b[tau]
local ste : display %4.3f _se[tau]


* k2) Event study regression and plot
did_imputation $dep_var $unique_unit_id $calendar_period $unit_treat_date1, fe($fixed_effects) cluster($se_cluster) $other_specs_es

event_plot, default_look ///
	graph_opt(xtitle("Quarters relative to treatment") xlabel(-6(1)13) ///
	ytitle("`vertical_lab'") ylabel(`label_min'(0.05)`label_max', angle(horizontal) format(%9.2f)) ///
	legend(label(1 "Pre-trend coefficients") label(2 "Treatment effects") rows(1) size(small) position(6)) ///
	text(`label_att_v' `label_att_h' "ATT = `att' (`ste')", placement(c) justification(center) size(medsmall) box fcolor(none) lcolor(gray) lwidth(medium) margin(medsmall))) 
graph export "$figures/Figure 2C.`fmt_pic'", replace
