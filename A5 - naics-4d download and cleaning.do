/*----------------------------------------------------------------------------*/

* This do-file downloads and cleans the 2017 NAICS 4-digit classification codes and names.

/*----------------------------------------------------------------------------*/
*STEPS:
	*0. Set directories.
	*1. Download 2017 NAICS data.
	*2. Clean NAICS data and generate base NAICS 4-digit code/name file.
/*-----------------------------------------------------------------------------*/


*------------------------------------------------------------------------------*
* 0) Set directories
*------------------------------------------------------------------------------*
clear  all
global master_path "[INSERT USER'S RELEVANT PATH]"
global data_uscb_r "${master_path}/data/uscb/raw"
global data_uscb_c "${master_path}/data/uscb/raw"




*------------------------------------------------------------------------------*
* 1) Download NAICS data
*------------------------------------------------------------------------------*
copy "https://www.census.gov/naics/2017NAICS/2-6%20digit_2017_Codes.xlsx"  "${data_uscb_r}/", replace




*------------------------------------------------------------------------------*
* 2) Clean NAICS data + generate base NAICS 4-digit code/name file
*------------------------------------------------------------------------------*
import excel using "${data_uscb_r}/2-6%20digit_2017_Codes.xlsx", firstrow clear


* a) Rename variables
rename NAICSUSCode  naics_code
rename NAICSUSTitle naics_name


* b) Drop: empty row + unnecessary variable
drop in 1
keep 	naics_code naics_name
drop if naics_code == ""
replace naics_name = strtrim(naics_name)


* c) Identify: NAICS codes that refer to 4-digit classification
gen 	 naics_type = strlen(naics_code)
keep if  naics_type == 4
drop 	 naics_type 
destring naics_code, replace


* d) Rename: final variable names
rename naics_code naics4_code
rename naics_name naics4_name
format naics4_name %50s


* e) Save: base file for 2017 4-digit NAICS
save "${data_uscb_c}/naics4_2017", replace
