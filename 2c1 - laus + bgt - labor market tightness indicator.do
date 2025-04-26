/*----------------------------------------------------------------------------*/

* This do-file converts and appends the monthly LAUS files and creates a labor market tightness indicator for 2017m1-2021m12, at the CZ level.

/*----------------------------------------------------------------------------*/
*STEPS:
	*0. Set directories.
	*1. Convert and append monthly LAUS data for 2017-2021.
	*2. Create file with monthly tightness indicator, at the CZ level, from 2017-2021.
/*-----------------------------------------------------------------------------*/


*------------------------------------------------------------------------------*
* 0) Set directories
*------------------------------------------------------------------------------*
clear  all

global master_path 		 "[INSERT USER'S RELEVANT PATH]"
global data_laus_r		 "${master_path}/data/laus/raw"
global data_laus_c 		 "${master_path}/data/laus/cln"
global data_bgt_c   	 "${master_path}/data/bgt/cln"
global data_cwalk_usda_c "${master_path}/data/crosswalk/usda/cln"




*------------------------------------------------------------------------------*
* 1) Import and clean: LAUS data -- monthly, county-level + CZ-level
*------------------------------------------------------------------------------*
import delimited "${data_laus_r}/la.data.64.County.txt"

* a) Drop: annual averages + year before 2017
drop if period == "M13"
drop if year 	< 2017
drop if year 	> 2021


* b) Fix: month variable + Generate: year-month
gen 	 month = substr(period,2,2)
destring month , replace
gen 	 ym = ym(year,month)
format 	 ym %tm
drop 	 year month period footnote


* c) Find + Fix: non-numeric values
tab 	 value if real(value) == ., miss
replace  value = strtrim(value)
replace  value = "" if value == "-"	
destring value, replace


* d) Generate: new series variable + FIPS code
replace series_id = strtrim(series_id)
gen 	series 	  = substr(series_id,-1,.)
gen 	fips_code = substr(series_id,6,5)


* e) Reshape: long to wide + Rename: variables
drop series_id
order fips_code ym series
destring 	 series, replace
reshape wide value, i(fips_code ym) j(series)

rename (value3 value4 value5 value6) (unemp_rate unemployed employed labor_force)
replace unemp_rate = unemployed / labor_force * 100
format 	unemp_rate %9.1f


* f) Save: base file for monthly unemployment, county level
save "${data_laus_c}/LAUS - ym - county - 2017m1-2021m12", replace


* g) Merge: with CZ crosswalk
destring fips_code, replace
merge m:1 fips_code using "${data_cwalk_usda_c}/County-CZ crosswalk 2000", keepusing(cz_code_2000)
keep if _merge == 3
drop 	_merge


* h) Generate: totals at the CZ level
collapse (sum) unemployed employed labor_force, by(cz_code_2000 ym)
gen 	unemp_rate = unemployed / labor_force * 100
format 	unemp_rate %9.1f


* i) Save: base file for monthly unemployment, cz level
save "${data_laus_c}/LAUS - ym - cz - 2017m1-2021m12", replace




*------------------------------------------------------------------------------*
* 2) BGT data -- count of postings (monthly, CZ-level) + Tightness indicator/ratio
*------------------------------------------------------------------------------*
use "${data_bgt_c}/all_2007_2021", clear


* a) Keep: key variables
keep bgtjobid date fips


* b) Drop: year before 2017 + after 2021
gen 	year  = year(date)
gen 	month = month(date)

drop if year 	< 2017
drop if year 	> 2021

gen 	ym = ym(year,month)
format 	ym %tm

drop 	year month


* c) Drop: non-defined fips_code
rename  fips fips_code
drop if fips_code == .


* d) Generate: totals at the county level + Merge: with cz crosswalk + Generate: total at the cz level
gen 	posting = 1
collapse (sum) posting, by(ym fips_code)

merge m:1 fips_code using "${data_cwalk_usda_c}/County-CZ crosswalk 2000", keepusing(cz_code_2000)
keep if _merge == 3
drop 	_merge

collapse (sum) posting, by(ym cz_code_2000)


* e) Merge: with BLS LAUS data
merge 1:1 ym cz_code_2000 using "${data_laus_c}/LAUS - ym - cz - 2017m1-2021m12", keepusing(unemployed)
keep if _merge == 3
drop 	_merge 


* f) Generate: tightness ratio + Keep: key variables
gen 	  lm_tightness = posting / unemployed 
codebook  lm_tightness
keep	  ym cz_code_2000 lm_tightness
label var lm_tightness "Labor market tightness (Postings / Unemployed)"


* g) Save: base file for labor market tightness, cz level
save "${data_laus_c}/LAUS + BGT - ym - cz - 2017m1-2021m12 - labor market tightness", replace
