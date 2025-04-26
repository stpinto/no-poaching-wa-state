/*----------------------------------------------------------------------------*/

* This do-file creates table A3

/*----------------------------------------------------------------------------*/
*STEPS:
	*0. Set directories.
	*1. Computes the number of observations by 4-digit NAICS, for both the same-industry sample and the inverse control group.
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
global data_uscb_c 		 "${master_path}/data/uscb/cln"
global tables 	  		 "${master_path}/output/tables"
*
global dep_var	  	    "log_salary_r"
global unique_unit_id   "employer_number"
global calendar_period  "yq"
global unit_treat_date1 "settlement_date_yq_aod"

global fixed_effects 	"yq##cz_code_2000 yq##soc_4d soc_4d##employer_number"
global se_cluster	   	"employer_number"
global other_specs_did  "autosample pretrends(5) maxit(10000)"
global other_specs_es   "autosample pretrends(5) allhorizons maxit(10000)"

global key_vars			"${dep_var} ${unique_unit_id} ${calendar_period} ${unit_treat_date1} ${se_cluster} cz_code_2000 soc_4d treated naics4"

local  first_year	  	"2015"
local  deflator_pce   	"2017"




*------------------------------------------------------------------------------*
* 1) Generate summary table with top 40 industries (same-industry + inverse samples)
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



********************************************************************************
*** 1) SAME INDUSTRY SAMPLE

* h) Restrict: BGT sample to ads from industries with at least 1 treated chain
// Merge
merge m:1 naics4 using "${data_mat_c}/BGT - list of treated industries - 2007-2021"
tab 	treated treated_industry, miss
replace treated_industry = 0 if treated_industry == . & naics4 != .	
drop 	_merge 

// Keep treated industries -- same-industry sample
preserve
keep if  treated_industry == 1 | treated == 1

// Relative time period -- treatment time-based
foreach var in aod {
gen yq_relative_`var' = yq - settlement_date_yq_`var'
tab yq_relative_`var', miss
tab yq_relative_`var' if treated == 1 , miss
}

keep if yq 				>= 228	
keep if yq_relative_aod >=  -6	
drop 	yq_relative_* 

keep	$key_vars treated_industry
compress



* i) Generate: regression sample
// Drop missing observations for soc_4d
drop if soc_4d == .	

// Drop observations that are not part of the regression sample
capture noisily did_imputation $dep_var $unique_unit_id $calendar_period $unit_treat_date1 , fe($fixed_effects) $other_specs_did nose
drop if cannot_impute == 1	



* j) Collapse: count of observations by NAICS-4d + Merge: with file with NAICS-4d names
// Collapse
gen 	obs = 1 
collapse (sum) obs, by(naics4)
rename 	obs full_sample

// Merge
rename 	  naics4 naics4_code
merge 1:1 naics4_code using "${data_uscb_c}/naics4_2017"
drop if   _merge == 2
drop if   naics4_code == .
drop 	  _merge

egen rank = rank(full_sample), field
sort  rank
order rank naics4_code naics4_name
keep in 1/40

label var naics4_code "NAICS-4d code"
label var naics4_name "BGT full-sample industries"

replace   naics4_name = "Other General Merchandise Stores" if naics4_name == "" & naics4_code == 4529



* k) Save: excel  file for same industry sample
export excel using "${tables}/Table A3 - same industry sample", firstrow(variables) replace
restore



********************************************************************************
*** 2) INVERSE SAMPLE

* l) Restrict: BGT sample to ads from industries with no treated chains + generate: relative time period
// Keep non-treated industries -- inverse sample
preserve
keep if  treated_industry == 0 | treated == 1

// Relative time period -- treatment time-based
foreach var in aod {
gen yq_relative_`var' = yq - settlement_date_yq_`var'
tab yq_relative_`var', miss
tab yq_relative_`var' if treated == 1 , miss
}

keep if yq 				>= 228	
keep if yq_relative_aod >=  -6	
drop 	yq_relative_* 

keep	$key_vars treated_industry
compress



* m) Generate: regression sample
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

tab 	treated treated_industry, miss
drop if treated == 1



* n) Collapse: count of observations by NAICS-4d + Merge: with file with NAICS-4d names
// Collapse
gen 	obs = 1 
collapse (sum) obs, by(naics4 treated)
rename 	obs inverse_sample

// Merge
rename 	  naics4 naics4_code
merge 1:1 naics4_code using "${data_uscb_c}/naics4_2017"
drop if   _merge == 2
drop if   treated == 1 
drop 	  _merge treated

egen rank = rank(inverse_sample), field
sort  rank
order rank naics4_code naics4_name
keep in 1/40

label var naics4_code "NAICS-4d code"
label var naics4_name "BGT inverse-sample control industries"

replace   naics4_name = "Department Stores" 		if naics4_name == "" & naics4_code == 4521
replace   naics4_name = "Wireless Telecom Carriers" if naics4_name == "" & naics4_code == 5172



* o) Save: excel  file
export excel using "${tables}/Table A3 - inverse sample", firstrow(variables) replace
