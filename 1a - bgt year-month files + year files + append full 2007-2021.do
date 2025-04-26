/*----------------------------------------------------------------------------*/

* This do-file creates the year-month and yearly files for the BGT data (2007-2021, all jobs, all years, all key variables)
* It also creates a file with all years appended to create the entire 2007-2021 file.

/*----------------------------------------------------------------------------*/
*STEPS:
	*0. Set directories.
	*1. Generate each year-month file of BGT data.
	*2. Generate each yearly file of BGT data.
	*3. Generate the full 2007-2021 BGT file.
/*-----------------------------------------------------------------------------*/


*------------------------------------------------------------------------------*
* 0) Set directories
*------------------------------------------------------------------------------*
clear  all

global master_path 	"[INSERT USER'S RELEVANT PATH]"
global data_bgt_r   "${master_path}/data/bgt/raw"
global data_bgt_c   "${master_path}/data/bgt/cln"

global key_vars 	"bgtjobid employer jobdate soc naics4 fips minsalary maxsalary payfrequency"

local last_year 	"2022"




*------------------------------------------------------------------------------*
* 1) Generate the base file for each year-month
*------------------------------------------------------------------------------*

// Import data for years 2007 and 2010-`last_year'
foreach year of numlist 2007 2010/`last_year' {

foreach month in 01 02 03 04 05 06 07 08 09 10 11 12 {

cd 						  "${data_bgt_r}/`year'"
capture noisily unzipfile "${data_bgt_r}/`year'/Main_`year'-`month'.zip", replace
if _rc == 0 {
import delimited 		  "${data_bgt_r}/`year'/Main_`year'-`month'.txt", clear
if _N == 0 continue 


* a) Keep: key variables + Generate: variables for year and month + date variables
keep 	 $key_vars
replace  jobdate = strtrim(jobdate)

	 if `year' <  2020 {
gen 	 year  = `year'
gen 	 month = `month'
}
else if `year' >= 2020 {
gen 	 year  = substr(jobdate,1,4)
gen 	 month = substr(jobdate,6,2)
destring year month, replace
}

gen 	 day = substr(jobdate,9,2)
destring day, replace
drop 	 jobdate

gen    	 date = mdy(month, day, year)
format 	 date %td



* b) Destring variables
capture destring minsalary, force replace
capture destring maxsalary, force replace
capture destring fips, force replace



* c) Assign missing values
foreach var in naics4 minsalary maxsalary {
replace `var' = . if `var' == -999
}



* d) Generate: midpoint salary variable
codebook minsalary maxsalary
gegen 	 salary = rowmean(minsalary maxsalary)
drop 	 minsalary maxsalary



* e) Replace: missing cases for "soc" and "canontitle"
replace soc 		= "" if soc 	   == "na"
sort 	date bgtjobid



* e) Save: each year-month file
compress
save "${data_bgt_c}/monthly/`year'_`month'.dta", replace
}
}




*------------------------------------------------------------------------------*
* 2) Generate the base file for each year
*------------------------------------------------------------------------------*

use "${data_bgt_c}/monthly/`year'_01.dta", clear

* a) Append: each set of months within each year
foreach month in 02 03 04 05 06 07 08 09 10 11 12 {
capture noisily append using "${data_bgt_c}/monthly/`year'_`month'.dta"
}


* b) Save: each yearly file
save "${data_bgt_c}/all_`year'.dta", replace
clear
}




*------------------------------------------------------------------------------*
* 3) Append all years and generate base 2007-`last_year' file
*------------------------------------------------------------------------------*

clear

* a) Append: 2010-`last_year' data
foreach year of numlist 2007 2010/`last_year' {
append using "${data_bgt_c}/all_`year'"
}


* b) Keep: 2007-2021
keep if year <= 2021


* b) Save: base 2007-`last_year' file
compress
save "${data_bgt_c}/all_2007_2021", replace
