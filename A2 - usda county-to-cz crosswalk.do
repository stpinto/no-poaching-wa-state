/*----------------------------------------------------------------------------*/

* This do-file imports and converts USDA's county-to-CZ crosswalk into dta format.

/*----------------------------------------------------------------------------*/
*STEPS:
	*0. Set directories.
	*1. Import and convert crosswalk into dta format.
/*-----------------------------------------------------------------------------*/


*------------------------------------------------------------------------------*
* 0) Set directories
*------------------------------------------------------------------------------*
clear  all
global master_path 		 "[INSERT USER'S RELEVANT PATH]"
global data_cwalk_usda_r "${master_path}/data/crosswalk/usda/raw"
global data_cwalk_usda_c "${master_path}/data/crosswalk/usda/cln"




*------------------------------------------------------------------------------*
* 1) Generate county-to-CZ crosswalk
*------------------------------------------------------------------------------*

import excel "${data_cwalk_usda_r}/cz00_eqv_v1.xls", sheet("CZ00_Equiv") firstrow case(lower) clear


* a) Rename + keep: key variables for 2010 geographic identifiers
rename fips				   fips_code
rename commutingzoneid2000 cz_code_2000
rename countyname 		   county_name 

label var fips_code	   "FIPS code (5 digits)"
label var county_name  "County name"
label var cz_code_2000 "CBSA name"

keep  fips_code county_name cz_code_2000
order fips_code county_name cz_code_2000
destring fips_code, replace



* b) Save: county-to-cz crosswalk
save "${data_cwalk_usda_c}/County-CZ crosswalk 2000", replace
