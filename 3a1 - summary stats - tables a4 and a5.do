/*----------------------------------------------------------------------------*/

* This do-file generates the BGT columns for tables A4 and A5

/*----------------------------------------------------------------------------*/
*STEPS:
	*0. Set directories.
	*1. Implemente the empirical specification (baseline, same + inverse samples) and generate Table 1 and Figures 1A-1C.
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
global tables 	  		 "${master_path}/output/tables"
*
global dep_var	  	     "log_salary_r"
global unique_unit_id    "employer_number"
global calendar_period   "yq"
global unit_treat_date1  "settlement_date_yq_aod"

global fixed_effects	 "yq##cz_code_2000 yq##soc_4d soc_4d##employer_number"
global se_cluster		 "employer_number"
global other_specs_did   "autosample pretrends(5) maxit(10000)"
global other_specs_es    "autosample pretrends(5) allhorizons maxit(10000)"

global key_vars			 "${dep_var} ${unique_unit_id} ${calendar_period} ${unit_treat_date1} ${se_cluster} cz_code_2000 soc_4d treated salary_r payfrequency"

local  first_year	  	 "2015"
local  deflator_pce   	 "2017"
local  fmt_tab		  	 "xls"

set scheme cleanplots


*------------------------------------------------------------------------------*
* 1) Summary stats Tables A4-A5, part 1: same-industry BGT data
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
label var log_salary_r "Log(real salary)" 
drop 	  salary 



* e) Generate: variables for diff-in-diff estimation for no-poaching

// Identify the chains who agreed to stop including no poaching clauses (treated chains)
merge m:1 franchise using "${data_waag_c}/Chain settlement dates", keepusing(settlement_date)
tab		  franchise    _merge, miss									
tab 	  franchise if _merge == 2, miss
drop if   _merge == 2

// Treated: assign status if chain entered into AOD
gen 	  treated = 1 if _merge  == 3
replace   treated = 0 if treated == . 
tab 	  treated, miss	
drop	  _merge



* f) Generate: quarter-based settlement date 
gen 	settlement_date_yq_aod = yq(year(settlement_date), quarter(settlement_date))
format 	settlement_date_yq_aod %tq
tab 	settlement_date_yq_aod, miss 
drop 	franchise settlement_date bgtjobid
compress



* g) Merge: with county-to-CZ crosswalk 
destring  fips_code, replace
merge m:1 fips_code using "${data_cwalk_usda_c}/County-CZ crosswalk 2000"
keep if   _merge == 3	
drop 	  _merge fips_code county_name
compress



* h) Restrict: BGT sample to ads from industries with at least 1 treated chain
// Merge
merge m:1 naics4 using "${data_mat_c}/BGT - list of treated industries - 2007-2021"
tab 	treated treated_industry, miss
replace treated_industry = 0 if treated_industry == . & naics4 != .	
drop 	_merge 

// Keep treated industries -- same-industry sample
preserve
keep if  treated_industry == 1 | treated == 1
drop 	 naics4 treated_industry

// Relative time period -- treatment time-based
foreach var in aod {
gen yq_relative_`var' = yq - settlement_date_yq_`var'
tab yq_relative_`var', miss
tab yq_relative_`var' if treated == 1 , miss
}

keep if yq 				>= 228	
keep if yq_relative_aod >=  -6	
drop 	yq_relative_* 

keep	$key_vars
compress



* i) Generate: regression sample
// Drop missing observations for soc_4d
drop if soc_4d == .	

// Drop observations that are not part of the regression sample
capture noisily did_imputation $dep_var $unique_unit_id $calendar_period $unit_treat_date1 , fe($fixed_effects) $other_specs_did nose
drop if cannot_impute == 1



* j) Generate: variables for summary statistics table
// Number of employers
gegen  unique_employer = tag(employer_number)
gegen  number_chains   = sum(unique_employer), by(treated)

// Number of obs + obs per employers
gegen  number_obs = count(employer_number), by(treated)
gen    obs_by_chain = number_obs / number_chains
format obs_by_chain %15.0f

// Salaries
foreach i of num 0 1 {
summarize salary_r if treated == `i', detail
return list
gen salary_r_mean_t`i' = r(mean) 
gen salary_r_p10_t`i'  = r(p10) 
gen salary_r_p25_t`i'  = r(p25) 
gen salary_r_p50_t`i'  = r(p50) 
gen salary_r_p75_t`i'  = r(p75) 
gen salary_r_p90_t`i'  = r(p90) 
}
gen salary_r_mean = .
gen salary_r_p10  = .
gen salary_r_p25  = .
gen salary_r_p50  = .
gen salary_r_p75  = .
gen salary_r_p90  = . 

foreach var in salary_r_mean salary_r_p10 salary_r_p25 salary_r_p50 salary_r_p75 salary_r_p90 {
replace `var' = `var'_t0 if treated == 0
replace `var' = `var'_t1 if treated == 1
drop 	`var'_t0 `var'_t1
}	

// Share of hourly ads
gegen  hourly_ads   = count(employer_number) if payfrequency == 3, by(treated)
gegen  hourly_ads_2 = min(hourly_ads), by(treated)
drop   hourly_ads   
rename hourly_ads_2 hourly_ads
gen    share_hourly_ads = hourly_ads / number_obs * 100
drop   hourly_ads



* k) Collapse: by treatment level
collapse (mean) number_chains number_obs obs_by_chain salary_r_mean salary_r_p10 ///
				salary_r_p25 salary_r_p50 salary_r_p75 salary_r_p90 share_hourly_ads , by(treated)

// Transpose
sxpose, clear firstnames force

// Re-format table
rename _var1 control_bgt
rename _var2 treat_bgt
gen 	variable_name = ""
order 	variable_name treat_bgt

gen 	obs 		  = _n
replace variable_name = "Number of chains/employers"		if obs == 1
replace variable_name = "Number of job ads (total)" 		if obs == 2
replace variable_name = "Number of job ads (avg per chain/emp)" if obs == 3
replace variable_name = "Salary (2015 USD): average" 		if obs == 4
replace variable_name = "Salary (2015 USD): P10" 			if obs == 5
replace variable_name = "Salary (2015 USD): P25" 			if obs == 6
replace variable_name = "Salary (2015 USD): P50" 			if obs == 7
replace variable_name = "Salary (2015 USD): P75" 			if obs == 8
replace variable_name = "Salary (2015 USD): P90" 			if obs == 9
replace variable_name = "Share of hourly wage job ads (%)"	if obs == 10

destring treat_bgt control_bgt, replace
format 	 treat_bgt control_bgt %15.0f



* l) Save: temp file
tempfile summ_stats_t1_fullbgt
save 	`summ_stats_t1_fullbgt'

restore 




*------------------------------------------------------------------------------*
* 2) Summary stats Tables A4-A5, part 2: inverse BGT data
*------------------------------------------------------------------------------*

* m) Restrict: BGT sample to ads from industries with no treated chains + generate: relative time period
// Keep non-treated industries -- inverse sample
preserve
keep if  treated_industry == 0 | treated == 1
drop 	 naics4 treated_industry

// Relative time period -- treatment time-based
foreach var in aod {
gen yq_relative_`var' = yq - settlement_date_yq_`var'
tab yq_relative_`var', miss
tab yq_relative_`var' if treated == 1 , miss
}

keep if yq 				>= 228	
keep if yq_relative_aod >=  -6	
drop 	yq_relative_* 

keep	$key_vars
compress



* n) Generate: regression sample
// Drop missing observations for soc_4d
drop if soc_4d == .	

// Run loop and impose min cell size
gen obs  = 1
gen loop = .

foreach i of num 1/2 {
replace settlement_date_yq_aod = 1 if settlement_date_yq_aod == .
replace loop = `i'

// (yq)x(cz_code_2000)
gegen yq_cz			 = group(yq cz_code_2000 treated)
gegen obs_by_yq_cz 	 = sum(obs), by(yq_cz)
drop if obs_by_yq_cz <= `i' 
drop yq_cz obs_by_yq_cz 

// (yq)x(soc_4d)
gegen 	yq_soc		  = group(yq soc_4d treated)
gegen 	obs_by_yq_soc = sum(obs), by(yq_soc)
drop if obs_by_yq_soc <= `i' 
drop 	obs_by_yq_soc yq_soc

// (soc_4d)x(employer_number)
gegen 	 soc_franchise 		  = group(soc_4d employer_number treated)
gegen 	 obs_by_soc_franchise = sum(obs), by(soc_franchise)
drop if  obs_by_soc_franchise <= `i'
drop 	 obs_by_soc_franchise soc_franchise

replace settlement_date_yq_aod = . if settlement_date_yq_aod == 1

capture noisily did_imputation $dep_var $unique_unit_id $calendar_period $unit_treat_date1 , fe($fixed_effects) $other_specs_did nose

if loop <= 2 {
capture noisily tab 	cannot_impute, miss
capture noisily drop if cannot_impute == 1	
capture noisily drop 	cannot_impute
}
}
*
drop obs loop



* o) Generate: variables for summary statistics table
// Number of employers
gegen  unique_employer = tag(employer_number)
gegen  number_chains   = sum(unique_employer), by(treated)

// Number of obs + obs per employers
gegen  number_obs = count(employer_number), by(treated)
gen    obs_by_chain = number_obs / number_chains
format obs_by_chain %15.0f

// Salaries
foreach i of num 0 1 {
summarize salary_r if treated == `i', detail
return list
gen salary_r_mean_t`i' = r(mean) 
gen salary_r_p10_t`i'  = r(p10) 
gen salary_r_p25_t`i'  = r(p25) 
gen salary_r_p50_t`i'  = r(p50) 
gen salary_r_p75_t`i'  = r(p75) 
gen salary_r_p90_t`i'  = r(p90) 
}
gen salary_r_mean = .
gen salary_r_p10  = .
gen salary_r_p25  = .
gen salary_r_p50  = .
gen salary_r_p75  = .
gen salary_r_p90  = . 

foreach var in salary_r_mean salary_r_p10 salary_r_p25 salary_r_p50 salary_r_p75 salary_r_p90 {
replace `var' = `var'_t0 if treated == 0
replace `var' = `var'_t1 if treated == 1
drop 	`var'_t0 `var'_t1
}	

// Share of hourly ads
gegen  hourly_ads   = count(employer_number) if payfrequency == 3, by(treated)
gegen  hourly_ads_2 = min(hourly_ads), by(treated)
drop   hourly_ads   
rename hourly_ads_2 hourly_ads
gen    share_hourly_ads = hourly_ads / number_obs * 100
drop   hourly_ads



* p) Collapse: by treatment level
collapse (mean) number_chains number_obs obs_by_chain salary_r_mean salary_r_p10 ///
				salary_r_p25 salary_r_p50 salary_r_p75 salary_r_p90 share_hourly_ads , by(treated)

// Transpose
sxpose, clear firstnames force

// Re-format table
rename _var1 control_bgt_inv
rename _var2 treat_bgt_inv
gen 	variable_name = ""
order 	variable_name treat_bgt_inv

gen 	obs 		  = _n
replace variable_name = "Number of chains/employers"		if obs == 1
replace variable_name = "Number of job ads (total)" 		if obs == 2
replace variable_name = "Number of job ads (avg per chain/emp)" if obs == 3
replace variable_name = "Salary (2015 USD): average" 		if obs == 4
replace variable_name = "Salary (2015 USD): P10" 			if obs == 5
replace variable_name = "Salary (2015 USD): P25" 			if obs == 6
replace variable_name = "Salary (2015 USD): P50" 			if obs == 7
replace variable_name = "Salary (2015 USD): P75" 			if obs == 8
replace variable_name = "Salary (2015 USD): P90" 			if obs == 9
replace variable_name = "Share of hourly wage job ads (%)"	if obs == 10

drop 	 obs 
destring treat_bgt_inv control_bgt_inv, replace
format 	 treat_bgt_inv control_bgt_inv %15.0f



* q) Merge: with temp file for matched summary stats table
merge 1:1 variable_name using `summ_stats_t1_fullbgt'
drop _merge

label var variable_name   " "
label var treat_bgt 	  "Treatment group (same-ind. BGT sample)"
label var control_bgt 	  "Control group (same-ind. BGT sample)"
label var treat_bgt_inv	  "Treatment group (inverse BGT sample)"
label var control_bgt_inv "Control group (inverse BGT sample)"
sort 	  obs
drop	  obs



* r) Save: Summary stats Table 1
export excel using "$tables/Table A4 and A5 - BGT.xlsx", firstrow(varlabels) nolabel replace
********************************************************************************
