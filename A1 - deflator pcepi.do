/*----------------------------------------------------------------------------*/

* This do-file imports and converts the St Louis' FRED's PCE deflator (extracted in Dec-2023) data into dta format.

/*----------------------------------------------------------------------------*/
*STEPS:
	*0. Set directories.
	*1. Import and convert FRED's PCE deflator (extracted in Dec-2023) data into dta format.
/*-----------------------------------------------------------------------------*/


*------------------------------------------------------------------------------*
* 0) Set directories
*------------------------------------------------------------------------------*
clear  all
global master_path "[INSERT USER'S RELEVANT PATH]"
global data_defl_r "${master_path}/data/deflator/pce fred/raw"
global data_defl_c "${master_path}/data/deflator/pce fred/cln"



*------------------------------------------------------------------------------*
* 1) Generate file for deflator - PCE with 2017 base
*------------------------------------------------------------------------------*

* a) Import: PCE data
import delimited "${data_defl_r}/PCEPI.csv", clear


* b) Generate: date variable in correct format
// YMD
gen    date2 = date(date, "YMD")
format date2 %td
drop   date
rename date2 date

// YM
gen 	 ym = ym(year(date), month(date))
format 	 ym %tm
codebook ym 


* c) Rename
rename pcepi deflator
format deflator %15.1f


* d) Save: monthly deflator for 2017 prices
save 	"${data_defl_c}/Deflator_2017.dta", replace
