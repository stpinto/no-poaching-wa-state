/*----------------------------------------------------------------------------*/

* This do-file identifies the contract chains + the chains that settled but are not in the contract data (and it is run as a loop inside a separate do-file)

/*----------------------------------------------------------------------------*/
*STEPS:
	*0. Set directories.
	*1. Tag the BGT data with each of the 530 chains.
	*2. Tag the BGT data with the additional 84 chains in the WA AG settlement but not in this list.
	*3. Merge with county-to-CZ crosswalk.
/*-----------------------------------------------------------------------------*/


*------------------------------------------------------------------------------*
* 0) Set directories
*------------------------------------------------------------------------------*
global master_path 			"[INSERT USER'S RELEVANT PATH]"
global data_cwalk_usda_c	"${master_path}/data/crosswalk/usda/cln"

global key_vars_1			"bgtjobid employer soc naics4 fips salary date year month day payfrequency"
global key_vars_2			"bgtjobid employer soc naics4_job_ads fips_code salary date yq naics4d_ag franchise_id* payfrequency"
*------------------------------------------------------------------------------*



*------------------------------------------------------------------------------*
* 1) Tag the BGT data with each of the franchise chains 
*------------------------------------------------------------------------------*

* a) Eliminate leading and trailing blanks
replace employer = strtrim(employer)



* b) Drop/destring/replace
keep $key_vars_1

drop if employer   == "na"
replace soc 	   =  "" if soc 	   == "na"



* c) Generate "franchise_id" variables and fill in one-by-one --> For each of the 530 chains
gen 	franchise_id  = .
gen 	franchise_id2 = .
gen 	franchise_id3 = .
gen 	naics4d_ag 	  = .

gen 	Handyman_Matters = strpos(lower(employer), "handyman") & strpos(lower(employer), "matter")
replace franchise_id  = 1 if Handyman_Matters >= 1 & franchise_id == .
replace franchise_id2 = 1 if Handyman_Matters >= 1 & franchise_id != .
replace franchise_id3 = 1 if Handyman_Matters >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		  if Handyman_Matters >= 1
drop 	Handyman_Matters 

gen 	Kitchen_Tune_Up = 	   strpos(lower(employer), "kitchen") & strpos(lower(employer), "tune")
replace Kitchen_Tune_Up = 0 if strpos(employer, "Neptune Kitchen And Bath")		
replace franchise_id  = 2 if Kitchen_Tune_Up >= 1 & franchise_id == .
replace franchise_id2 = 2 if Kitchen_Tune_Up >= 1 & franchise_id != .
replace franchise_id3 = 2 if Kitchen_Tune_Up >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		  if Kitchen_Tune_Up >= 1
drop 	Kitchen_Tune_Up 

gen 	Mr_Handyman  = 		strpos(lower(employer), "mr") & strpos(lower(employer), "handyman")
replace Mr_Handyman  = 0 if strpos(employer, "Mr O's Handyman Service")
replace Mr_Handyman  = 0 if strpos(employer, "Mr 512 Handyman & Hauling Llc")	
replace Mr_Handyman  = 0 if strpos(employer, "Mr Everything Handyman Llc")		
replace Mr_Handyman  = 0 if strpos(employer, "Mr Everythinghandyman Services")				
replace Mr_Handyman  = 0 if strpos(employer, "Mr Fix It Professional Handyman Services")	
replace Mr_Handyman  = 0 if strpos(employer, "Mr Handy Handyman Services")					
replace franchise_id  = 3 if Mr_Handyman >= 1 & franchise_id == .
replace franchise_id2 = 3 if Mr_Handyman >= 1 & franchise_id != .
replace franchise_id3 = 3 if Mr_Handyman >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		  if Mr_Handyman >= 1
drop 	Mr_Handyman 

gen 	Mr_Sandless  = strpos(lower(employer), "mr") & strpos(lower(employer), "sandless")
replace franchise_id  = 4 if Mr_Sandless >= 1 & franchise_id == .
replace franchise_id2 = 4 if Mr_Sandless >= 1 & franchise_id != .
replace franchise_id3 = 4 if Mr_Sandless >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		  if Mr_Sandless >= 1
drop 	Mr_Sandless 

gen 	Pistor = 	  strpos(lower(employer), "pistor") | (strpos(lower(employer), "miracle") & strpos(lower(employer), "method"))
replace Pistor = 0 if strpos(employer, "Pistorius Machine Company")
replace Pistor = 0 if strpos(employer, "Pistorino & Alam")
replace Pistor = 0 if strpos(employer, "Jpistorius")
replace Pistor = 0 if strpos(employer, "Pistorino")								
replace Pistor = 0 if strpos(employer, "Nello Pistoresi Son")					
replace Pistor = 0 if strpos(employer, "Pistoresi Ambulance Service")			
replace Pistor = 0 if strpos(employer, "Pistorius")								
replace Pistor = 0 if strpos(employer, "Pistores")								
replace Pistor = 0 if strpos(employer, "Zappistore")							
replace Pistor = 0 if strpos(employer, "Small Miracles")						
replace franchise_id  = 5 if Pistor >= 1
replace franchise_id2 = 5 if Pistor >= 1 & franchise_id != .
replace franchise_id3 = 5 if Pistor >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		  if Pistor >= 1
drop 	Pistor 

gen 	Synergistic  = strpos(lower(employer), "glass doctor")
replace franchise_id  = 6 if Synergistic >= 1 & franchise_id == .
replace franchise_id2 = 6 if Synergistic >= 1 & franchise_id != .
replace franchise_id3 = 6 if Synergistic >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		  if Synergistic >= 1
drop 	Synergistic 

gen 	Window_World = strpos(lower(employer), "window world")
replace franchise_id  = 7 if Window_World >= 1 & franchise_id == .
replace franchise_id2 = 7 if Window_World >= 1 & franchise_id != .
replace franchise_id3 = 7 if Window_World >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		  if Window_World >= 1
drop 	Window_World 

gen 	Mr_Sparky = strpos(lower(employer), "mister sparky") | strpos(lower(employer), "mr sparky")
replace franchise_id  = 8 if Mr_Sparky >= 1 & franchise_id == .
replace franchise_id2 = 8 if Mr_Sparky >= 1 & franchise_id != .
replace franchise_id3 = 8 if Mr_Sparky >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		  if Mr_Sparky >= 1
drop 	Mr_Sparky 

gen		Advantaclean = strpos(lower(employer), "advanta clean") | strpos(lower(employer), "advantaclean")
replace franchise_id  = 9 if Advantaclean >= 1 & franchise_id == .
replace franchise_id2 = 9 if Advantaclean >= 1 & franchise_id != .
replace franchise_id3 = 9 if Advantaclean >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		  if Advantaclean >= 1
drop 	Advantaclean 

gen 	ABM = 	   strpos(lower(employer), "abm ")			
replace ABM = 0 if strpos(lower(employer), "abm consulting")
replace ABM = 0 if strpos(lower(employer), "abm fashion")
replace ABM = 0 if strpos(lower(employer), "abm fashion")
replace ABM = 0 if strpos(lower(employer), "allen business")
replace ABM = 0 if strpos(lower(employer), "wabm tv")
replace ABM = 0 if strpos(lower(employer), "wireless dba")
replace ABM = 0 if strpos(employer, "965 Abm Dry Cleaners")						
replace ABM = 0 if strpos(employer, "Abm Beach House Hotel")					
replace ABM = 0 if strpos(employer, "Abm Catering")								
replace ABM = 0 if strpos(employer, "Abm Commercial Flooring Incorporated") 	
replace ABM = 0 if strpos(employer, "Abm Double Tree Hotel")					
replace ABM = 0 if strpos(employer, "Abm Equipment")							
replace ABM = 0 if strpos(employer, "Abm Fabrication Machining")				
replace ABM = 0 if strpos(employer, "Abm Federal Sales")						
replace ABM = 0 if strpos(employer, "Abm Financial Management Corp")			
replace ABM = 0 if strpos(employer, "Abm Marciano Museum")						
replace ABM = 0 if strpos(employer, "Abm Media")								
replace ABM = 0 if strpos(employer, "Abm Medical")								
replace ABM = 0 if strpos(employer, "Abm Property Management")					
replace ABM = 0 if strpos(employer, "Abm Publishing")							
replace franchise_id  = 10 if ABM >= 1 & franchise_id == .
replace franchise_id2 = 10 if ABM >= 1 & franchise_id != .
replace franchise_id3 = 10 if ABM >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if ABM >= 1
drop 	ABM 

gen 	Aire_Serv = 	 strpos(lower(employer), "aireserv") | strpos(lower(employer), "aire serv")
replace Aire_Serv = 0 if strpos(employer, "Devonaire Service Tire")				
replace Aire_Serv = 0 if strpos(employer, "Excelaire Service")					
replace Aire_Serv = 0 if strpos(employer, "Luminaire")							
replace Aire_Serv = 0 if strpos(employer, "Flo Aire Service Incorporated")		
replace Aire_Serv = 0 if strpos(employer, "Grande Aire Services Incorporated")				
replace Aire_Serv = 0 if strpos(employer, "Proaire Services")					
replace Aire_Serv = 0 if strpos(employer, "Pulmonaire Service")					
replace Aire_Serv = 0 if strpos(employer, "Questionnaire Service Company")		
replace Aire_Serv = 0 if strpos(employer, "Robin Aire Service Company")			
replace Aire_Serv = 0 if strpos(employer, "Rome Aire Services")					
replace franchise_id  = 11 if Aire_Serv >= 1 & franchise_id == .
replace franchise_id2 = 11 if Aire_Serv >= 1 & franchise_id != .
replace franchise_id3 = 11 if Aire_Serv >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Aire_Serv >= 1
drop 	Aire_Serv 

gen 	American_Leak = 	 strpos(lower(employer), "american leak")
replace American_Leak = 0 if strpos(employer, "American Leakless Company, Llc")	
replace American_Leak = 0 if strpos(employer, "American Leakless Llc")			
replace franchise_id  = 12 if American_Leak >= 1 & franchise_id == .
replace franchise_id2 = 12 if American_Leak >= 1 & franchise_id != .
replace franchise_id3 = 12 if American_Leak >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if American_Leak >= 1
drop 	American_Leak 

gen 	Ben_Franklin_Plumbing = strpos(lower(employer), "ben franklin plumb") | strpos(lower(employer), "benjamin franklin plumb")
replace franchise_id  = 13 if Ben_Franklin_Plumbing >= 1 & franchise_id == .
replace franchise_id2 = 13 if Ben_Franklin_Plumbing >= 1 & franchise_id != .
replace franchise_id3 = 13 if Ben_Franklin_Plumbing >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Ben_Franklin_Plumbing >= 1
drop 	Ben_Franklin_Plumbing 

gen 	Ductz = strpos(lower(employer), "ductz")
replace franchise_id  = 14 if Ductz >= 1 & franchise_id == .
replace franchise_id2 = 14 if Ductz >= 1 & franchise_id != .
replace franchise_id3 = 14 if Ductz >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Ductz >= 1
drop 	Ductz 

gen 	Mr_Rooter = strpos(lower(employer), "mr rooter") | strpos(lower(employer), "mr. rooter")
replace franchise_id  = 15 if Mr_Rooter >= 1 & franchise_id == .
replace franchise_id2 = 15 if Mr_Rooter >= 1 & franchise_id != .
replace franchise_id3 = 15 if Mr_Rooter >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Mr_Rooter >= 1
drop 	Mr_Rooter  

gen 	One_Hour_Air = strpos(lower(employer), "one hour air")
replace franchise_id  = 16 if One_Hour_Air >= 1 & franchise_id == .
replace franchise_id2 = 16 if One_Hour_Air >= 1 & franchise_id != .
replace franchise_id3 = 16 if One_Hour_Air >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if One_Hour_Air >= 1
drop 	One_Hour_Air 

gen 	Rooter_Man = strpos(lower(employer), "rooter man") | strpos(lower(employer), "rooterman")
replace franchise_id  = 17 if Rooter_Man >= 1 & franchise_id == .
replace franchise_id2 = 17 if Rooter_Man >= 1 & franchise_id != .
replace franchise_id3 = 17 if Rooter_Man >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Rooter_Man >= 1
drop 	Rooter_Man   

gen 	Roto_Rooter = strpos(lower(employer), "roto rooter") | strpos(lower(employer), "rotorooter")
replace franchise_id  = 18 if Roto_Rooter >= 1 & franchise_id == .
replace franchise_id2 = 18 if Roto_Rooter >= 1 & franchise_id != .
replace franchise_id3 = 18 if Roto_Rooter >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Roto_Rooter >= 1
drop 	Roto_Rooter  

gen 	Sears_Air = strpos(lower(employer), "sears air")
replace franchise_id  = 19 if Sears_Air >= 1 & franchise_id == .
replace franchise_id2 = 19 if Sears_Air >= 1 & franchise_id != .
replace franchise_id3 = 19 if Sears_Air >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Sears_Air >= 1
drop 	Sears_Air

gen 	ACFN = strpos(lower(employer), "acfn")
replace franchise_id  = 20 if ACFN >= 1 & franchise_id == .
replace franchise_id2 = 20 if ACFN >= 1 & franchise_id != .
replace franchise_id3 = 20 if ACFN >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if ACFN >= 1
drop 	ACFN  

gen 	Culligan = strpos(lower(employer), "culligan")
replace franchise_id  = 21 if Culligan >= 1 & franchise_id == .
replace franchise_id2 = 21 if Culligan >= 1 & franchise_id != .
replace franchise_id3 = 21 if Culligan >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Culligan >= 1
drop 	Culligan

gen 	Filta = 	 strpos(lower(employer), "filta")
replace Filta = 0 if strpos(employer, "Filta Kleen")							
replace Filta = 0 if strpos(employer, "Filta Clean Company")					
replace franchise_id  = 22 if Filta >= 1 & franchise_id == .
replace franchise_id2 = 22 if Filta >= 1 & franchise_id != .
replace franchise_id3 = 22 if Filta >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Filta >= 1
drop 	Filta

gen 	One01_Mobility = strpos(lower(employer), "101 mobility")
replace franchise_id  = 23 if One01_Mobility >= 1 & franchise_id == .
replace franchise_id2 = 23 if One01_Mobility >= 1 & franchise_id != .
replace franchise_id3 = 23 if One01_Mobility >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if One01_Mobility >= 1
drop 	One01_Mobility  

gen 	Watermill_Express = strpos(lower(employer), "watermill express") | strpos(lower(employer), "watermillexpress")
replace franchise_id  = 24 if Watermill_Express >= 1 & franchise_id == .
replace franchise_id2 = 24 if Watermill_Express >= 1 & franchise_id != .
replace franchise_id3 = 24 if Watermill_Express >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Watermill_Express >= 1
drop 	Watermill_Express  

gen 	CertaPro = strpos(lower(employer), "certapro") | strpos(lower(employer), "certa pro")
replace franchise_id  = 25 if CertaPro >= 1 & franchise_id == .
replace franchise_id2 = 25 if CertaPro >= 1 & franchise_id != .
replace franchise_id3 = 25 if CertaPro >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if CertaPro >= 1
drop 	CertaPro

gen 	College_Pro_Paint = strpos(lower(employer), "college pro paint") | strpos(lower(employer), "collegepro paint") 
replace franchise_id  = 26 if College_Pro_Paint >= 1 & franchise_id == .
replace franchise_id2 = 26 if College_Pro_Paint >= 1 & franchise_id != .
replace franchise_id3 = 26 if College_Pro_Paint >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if College_Pro_Paint >= 1
drop 	College_Pro_Paint  

gen 	Five_Star_Paint = strpos(lower(employer), "five star paint") | strpos(lower(employer), "fivestar paint")
replace franchise_id  = 27 if Five_Star_Paint >= 1 & franchise_id == .
replace franchise_id2 = 27 if Five_Star_Paint >= 1 & franchise_id != .
replace franchise_id3 = 27 if Five_Star_Paint >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Five_Star_Paint >= 1
drop 	Five_Star_Paint

gen 	Fresh_Coat_Paint = 		strpos(lower(employer), "fresh coat") | strpos(lower(employer), "freshcoat") 
replace Fresh_Coat_Paint = 0 if strpos(employer, "Fresh Coat Paint & Stain")	
replace Fresh_Coat_Paint = 0 if strpos(employer, "Fresh Coat Paint And Stain")	
replace Fresh_Coat_Paint = 0 if strpos(employer, "Freshcoat Renovations Llc")	
replace Fresh_Coat_Paint = 0 if strpos(employer, "Freshcoat Nail Salon")		
replace Fresh_Coat_Paint = 0 if strpos(employer, "Freshcoat Sealcoat")			
replace franchise_id  = 28 if Fresh_Coat_Paint >= 1 & franchise_id == .
replace franchise_id2 = 28 if Fresh_Coat_Paint >= 1 & franchise_id != .
replace franchise_id3 = 28 if Fresh_Coat_Paint >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Fresh_Coat_Paint >= 1
drop 	Fresh_Coat_Paint

gen 	ScreenMobile = 		strpos(lower(employer), "screenmobile") | strpos(lower(employer), "screen mobile") 
replace ScreenMobile = 0 if strpos(employer, "Bubble Screen Mobile Repair Center")		
replace franchise_id  = 29 if ScreenMobile >= 1 & franchise_id == .
replace franchise_id2 = 29 if ScreenMobile >= 1 & franchise_id != .
replace franchise_id3 = 29 if ScreenMobile >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if ScreenMobile >= 1
drop 	ScreenMobile  

gen 	Sears_Handy = strpos(lower(employer), "sears han") | strpos(lower(employer), "sears home")
replace franchise_id  = 30 if Sears_Handy >= 1 & franchise_id == .
replace franchise_id2 = 30 if Sears_Handy >= 1 & franchise_id != .
replace franchise_id3 = 30 if Sears_Handy >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Sears_Handy >= 1
drop 	Sears_Handy  

gen 	Shelfgenie = strpos(lower(employer), "shelfg") | strpos(lower(employer), "shelf g")
replace franchise_id  = 31 if Shelfgenie >= 1 & franchise_id == .
replace franchise_id2 = 31 if Shelfgenie >= 1 & franchise_id != .
replace franchise_id3 = 31 if Shelfgenie >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Shelfgenie >= 1
drop 	Shelfgenie

gen 	Budget_Blinds = strpos(lower(employer), "budget blin")
replace franchise_id  = 32 if Budget_Blinds >= 1 & franchise_id == .
replace franchise_id2 = 32 if Budget_Blinds >= 1 & franchise_id != .
replace franchise_id3 = 32 if Budget_Blinds >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Budget_Blinds >= 1
drop 	Budget_Blinds

gen 	California_Closets = strpos(lower(employer), "california closets")
replace franchise_id  = 33 if California_Closets >= 1 & franchise_id == .
replace franchise_id2 = 33 if California_Closets >= 1 & franchise_id != .
replace franchise_id3 = 33 if California_Closets >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if California_Closets >= 1
drop 	California_Closets

gen 	Jet_Black = 	 strpos(lower(employer), "jet black") | strpos(lower(employer), "jet-black") | strpos(lower(employer), "black dawg")
replace Jet_Black = 0 if strpos(employer, "Jet Black Tint")						
replace Jet_Black = 0 if strpos(employer, "Jet Black Public Relations")			
replace franchise_id  = 34 if Jet_Black >= 1 & franchise_id == .
replace franchise_id2 = 34 if Jet_Black >= 1 & franchise_id != .
replace franchise_id3 = 34 if Jet_Black >= 1 & franchise_id != . & franchise_id2 != .
* ?
tab 	employer 		   if Jet_Black >= 1
drop 	Jet_Black

gen 	Dealer_Spec = strpos(lower(employer), "dealer spec")
replace franchise_id  = 35 if Dealer_Spec >= 1 & franchise_id == .
replace franchise_id2 = 35 if Dealer_Spec >= 1 & franchise_id != .
replace franchise_id3 = 35 if Dealer_Spec >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Dealer_Spec >= 1
drop 	Dealer_Spec

gen 	Embroid_Me = strpos(lower(employer), "embroid me") | strpos(lower(employer), "embroidme")
replace franchise_id  = 36 if Embroid_Me >= 1 & franchise_id == .
replace franchise_id2 = 36 if Embroid_Me >= 1 & franchise_id != .
replace franchise_id3 = 36 if Embroid_Me >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Embroid_Me >= 1
drop 	Embroid_Me

gen 	Natural_Awakenings = strpos(lower(employer), "natural awak")
replace franchise_id  = 37 if Natural_Awakenings >= 1 & franchise_id == .
replace franchise_id2 = 37 if Natural_Awakenings >= 1 & franchise_id != .
replace franchise_id3 = 37 if Natural_Awakenings >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Natural_Awakenings >= 1
drop 	Natural_Awakenings

gen 	Allegra_Network = strpos(lower(employer), "allegra net")
replace franchise_id  = 38 if Allegra_Network >= 1 & franchise_id == .
replace franchise_id2 = 38 if Allegra_Network >= 1 & franchise_id != .
replace franchise_id3 = 38 if Allegra_Network >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Allegra_Network >= 1
drop 	Allegra_Network 

gen 	Alpha_Graphics = strpos(lower(employer), "alpha graph") | strpos(lower(employer), "alphagraph") 
replace franchise_id  = 39 if Alpha_Graphics >= 1 & franchise_id == .
replace franchise_id2 = 39 if Alpha_Graphics >= 1 & franchise_id != .
replace franchise_id3 = 39 if Alpha_Graphics >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Alpha_Graphics >= 1
drop 	Alpha_Graphics

gen 	Image360 = 		strpos(lower(employer), "image 360") | strpos(lower(employer), "image360") | strpos(lower(employer), "signs by tomorrow")
replace Image360 = 0 if strpos(employer, "Auto Image 360")						
replace Image360 = 0 if strpos(employer, "Autoimage 360")						
replace franchise_id  = 40 if Image360 >= 1 & franchise_id == .
replace franchise_id2 = 40 if Image360 >= 1 & franchise_id != .
replace franchise_id3 = 40 if Image360 >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Image360 >= 1
drop 	Image360 

gen 	Minuteman_Press = strpos(lower(employer), "minuteman pr") | strpos(lower(employer), "minutemanpr")
replace franchise_id  = 41 if Minuteman_Press >= 1 & franchise_id == .
replace franchise_id2 = 41 if Minuteman_Press >= 1 & franchise_id != .
replace franchise_id3 = 41 if Minuteman_Press >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Minuteman_Press >= 1
drop 	Minuteman_Press

gen 	Speedpro = 		strpos(lower(employer), "speedpro") | strpos(lower(employer), "speed pro")
replace Speedpro = 0 if strpos(employer, "Diamond Speed Products")				
replace Speedpro = 0 if strpos(employer, "Godspeed Projects")					
replace Speedpro = 0 if strpos(employer, "Logospeed Promotional Products")		
replace Speedpro = 0 if strpos(employer, "Speed Props And Pylons")				
replace franchise_id  = 42 if Speedpro >= 1 & franchise_id == .
replace franchise_id2 = 42 if Speedpro >= 1 & franchise_id != .
replace franchise_id3 = 42 if Speedpro >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Speedpro >= 1
drop 	Speedpro 

gen 	Fastsigns = strpos(lower(employer), "fastsigns") | strpos(lower(employer), "fast signs")
replace franchise_id  = 43 if Fastsigns >= 1 & franchise_id == .
replace franchise_id2 = 43 if Fastsigns >= 1 & franchise_id != .
replace franchise_id3 = 43 if Fastsigns >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Fastsigns >= 1
drop 	Fastsigns 

gen 	Signarama = strpos(lower(employer), "signarama") | strpos(lower(employer), "sign a rama") 
replace franchise_id  = 44 if Signarama >= 1 & franchise_id == .
replace franchise_id2 = 44 if Signarama >= 1 & franchise_id != .
replace franchise_id3 = 44 if Signarama >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Signarama >= 1
drop 	Signarama 

gen 	Signs_Now = strpos(lower(employer), "signs now")
replace franchise_id  = 45 if Signs_Now >= 1 & franchise_id == .
replace franchise_id2 = 45 if Signs_Now >= 1 & franchise_id != .
replace franchise_id3 = 45 if Signs_Now >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Signs_Now >= 1
drop 	Signs_Now 

gen 	One800_Radiator = strpos(lower(employer), "1800 rad") | strpos(lower(employer), "1800rad")
replace franchise_id  = 46 if One800_Radiator >= 1 & franchise_id == .
replace franchise_id2 = 46 if One800_Radiator >= 1 & franchise_id != .
replace franchise_id3 = 46 if One800_Radiator >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if One800_Radiator >= 1
drop 	One800_Radiator 

gen 	Leading_Edge_Marketing = strpos(lower(employer), "prosource wholesale") | strpos(lower(employer), "leading edge mark") 
replace franchise_id  = 47 if Leading_Edge_Marketing >= 1 & franchise_id == .
replace franchise_id2 = 47 if Leading_Edge_Marketing >= 1 & franchise_id != .
replace franchise_id3 = 47 if Leading_Edge_Marketing >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Leading_Edge_Marketing >= 1
drop 	Leading_Edge_Marketing  

gen 	Aunt_Millies = 		strpos(lower(employer), "aunt mil")
replace Aunt_Millies = 0 if strpos(employer, "Aunt Millie's Thrift Store")		
replace franchise_id  = 48 if Aunt_Millies >= 1 & franchise_id == .
replace franchise_id2 = 48 if Aunt_Millies >= 1 & franchise_id != .
replace franchise_id3 = 48 if Aunt_Millies >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Aunt_Millies >= 1
drop 	Aunt_Millies

gen 	Bimbo_Foods = strpos(lower(employer), "bimbo bak") | strpos(lower(employer), "bimbo food") | strpos(lower(employer), "bimbo usa")
replace franchise_id  = 49 if Bimbo_Foods >= 1 & franchise_id == .
replace franchise_id2 = 49 if Bimbo_Foods >= 1 & franchise_id != .
replace franchise_id3 = 49 if Bimbo_Foods >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Bimbo_Foods >= 1
drop 	Bimbo_Foods

gen 	Earth_Grains = strpos(lower(employer), "earth grain") | strpos(lower(employer), "earthgrain") | strpos(lower(employer), "campbell taggart") | ///
																strpos(lower(employer), "rainbo") 	  | strpos(lower(employer), "grant's farm") 	| ///
					   strpos(lower(employer), "grants farm") | strpos(lower(employer), "old home")   | strpos(lower(employer), "break cake")  		| ///
					   strpos(lower(employer), "ironkids")    | strpos(lower(employer), "iron kids")  | strpos(lower(employer), "San Luis Sourdough") | ///
					   strpos(lower(employer), "holsum") 	  | strpos(lower(employer), "roman meal") | strpos(lower(employer), "sunbeam") 	  		| ///
					   strpos(lower(employer), "sun beam")    | strpos(lower(employer), "taystee") 	  | strpos(lower(employer), "country hearth")
replace Earth_Grains = 0 if strpos(lower(employer), "rainbow") 		| strpos(lower(employer), "gold home") 	 | strpos(lower(employer), "old home improvement") | ///
							strpos(lower(employer), "leibold home") | strpos(lower(employer), "behold home") | strpos(lower(employer), "brainbox") 			   | ///
							strpos(lower(employer), "harold home")  | strpos(lower(employer), "bold home") 	 | strpos(lower(employer), "brainboost") 		   | ///
							strpos(lower(employer), "griswold") 	| strpos(lower(employer), "country hearth inn") | strpos(lower(employer), "dippold home")  | ///
							strpos(lower(employer), "drainbo") 		| strpos(lower(employer), "griwold home") | strpos(lower(employer), "hold home") 		   | /// 
							strpos(lower(employer), "old homeowner") | strpos(lower(employer), "old home rescue") | strpos(lower(employer), "old homestead")   | /// 
							strpos(lower(employer), "rainbo records") | strpos(lower(employer), "rainbo service") | strpos(lower(employer), "rainbolt") 	   | /// 
							strpos(lower(employer), "rainbox") 		| strpos(lower(employer), "sunbeams") 	 | strpos(lower(employer), "sevenfold home") 	   | /// 
							strpos(lower(employer), "sold home") 	| strpos(lower(employer), "northeast sunbeam") | strpos(lower(employer), "sunbeam auto")   | ///
							strpos(lower(employer), "sunbeam candles") | strpos(lower(employer), "sunbeam clinical") | strpos(lower(employer), "sunbeam community development") | ///
							strpos(lower(employer), "sunbeam consulting") | strpos(lower(employer), "sunbeam corporate cleaning") | strpos(lower(employer), "sunbeam family") | ///
							strpos(lower(employer), "sunbeam home and family") | strpos(lower(employer), "sunbeam installations") | strpos(lower(employer), "sunbeam laboratories") | ///
							strpos(lower(employer), "sunbeam marketing") | strpos(lower(employer), "sunbeam properties") | strpos(lower(employer), "sunbeam property") | ///
							strpos(lower(employer), "sunbeam service experts") | strpos(lower(employer), "sunbeam television") | strpos(lower(employer), "sunbeam vintage") | ///
							strpos(lower(employer), "taystees burgers") 
replace franchise_id  = 50 if Earth_Grains >= 1 & franchise_id == .
replace franchise_id2 = 50 if Earth_Grains >= 1 & franchise_id != .
replace franchise_id3 = 50 if Earth_Grains >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Earth_Grains >= 1
drop 	Earth_Grains  

gen 	J_D_Byrider = strpos(lower(employer), "byrider")
replace franchise_id  = 51 if J_D_Byrider >= 1 & franchise_id == .
replace franchise_id2 = 51 if J_D_Byrider >= 1 & franchise_id != .
replace franchise_id3 = 51 if J_D_Byrider >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if J_D_Byrider >= 1
drop 	J_D_Byrider

gen 	Big_O_Tires = strpos(lower(employer), "big o tires") | strpos(lower(employer), "bigotires") | strpos(lower(employer), "bigo tires") | strpos(lower(employer), "big otires")
replace franchise_id  = 52 if Big_O_Tires >= 1 & franchise_id == .
replace franchise_id2 = 52 if Big_O_Tires >= 1 & franchise_id != .
replace franchise_id3 = 52 if Big_O_Tires >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Big_O_Tires >= 1
drop 	Big_O_Tires

gen 	Bridgestone = 	   strpos(lower(employer), "bridgestone") | strpos(lower(employer), "bandag")
replace Bridgestone = 0 if strpos(employer, "Levy Restaurants At Bridgestone Arena") 
replace Bridgestone = 0 if strpos(employer, "Bandago Van Rental") 				
replace Bridgestone = 0 if strpos(employer, "Bandages") 						
replace Bridgestone = 0 if strpos(employer, "Bandagroupintl") 					
replace Bridgestone = 0 if strpos(employer, "Bandago") 							
replace Bridgestone = 0 if strpos(employer, "The Bandage Room Entertainmment")  
replace Bridgestone = 0 if strpos(employer, "Custom Bandag Incorporated") 
replace Bridgestone = 0 if strpos(employer, "Premier Bandag") 					
replace franchise_id  = 53 if Bridgestone >= 1 & franchise_id == .
replace franchise_id2 = 53 if Bridgestone >= 1 & franchise_id != .
replace franchise_id3 = 53 if Bridgestone >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Bridgestone >= 1
drop 	Bridgestone

gen 	Tire_Pros = strpos(lower(employer), "tirepro") | strpos(lower(employer), "tire pros") | strpos(lower(employer), "tire pro's")
replace franchise_id  = 54 if Tire_Pros >= 1 & franchise_id == .
replace franchise_id2 = 54 if Tire_Pros >= 1 & franchise_id != .
replace franchise_id3 = 54 if Tire_Pros >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Tire_Pros >= 1
drop 	Tire_Pros

gen 	Winzer = strpos(lower(employer), "winzer")
replace Winzer = 0 if strpos(employer, "Winzer Stube Restaurant") 				
replace Winzer = 0 if strpos(employer, "Bauern Und Winzerverband Rheinland Pfalz E V") 
replace Winzer = 0 if strpos(employer, "Roland Winzer") 						
replace franchise_id  = 55 if Winzer >= 1 & franchise_id == .
replace franchise_id2 = 55 if Winzer >= 1 & franchise_id != .
replace franchise_id3 = 55 if Winzer >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Winzer >= 1
drop 	Winzer 

gen 	Relax_The_Back = strpos(lower(employer), "relax back") | strpos(lower(employer), "relax the back")
replace franchise_id  = 56 if Relax_The_Back >= 1 & franchise_id == .
replace franchise_id2 = 56 if Relax_The_Back >= 1 & franchise_id != .
replace franchise_id3 = 56 if Relax_The_Back >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Relax_The_Back >= 1
drop 	Relax_The_Back 

gen 	Aarons = 	  strpos(lower(employer), "aarons") | strpos(lower(employer), "aaron's")
replace Aarons = 0 if strpos(employer, "Aaron's Affordable Auto Repair")		
replace Aarons = 0 if strpos(employer, "Aaron's Catering International & Gourmet") 
replace Aarons = 0 if strpos(employer, "Aaron's Creative Welding Inc")			
replace Aarons = 0 if strpos(employer, "Aaron's Fabrication")					
replace Aarons = 0 if strpos(employer, "Aarons Fabrication")					
replace Aarons = 0 if strpos(employer, "Aaron's Fabrication Of Steel Tube & Welding, Inc") 
replace Aarons = 0 if strpos(employer, "Aaron's Green Cleaning Service, Inc")	
replace Aarons = 0 if strpos(employer, "Aaron's Elite Auto Service")			
replace Aarons = 0 if strpos(employer, "Aaron's Elite Pool Service")			
replace Aarons = 0 if strpos(employer, "Aaron's Estate Sales Llc")				
replace Aarons = 0 if strpos(employer, "Aaron's Landscaping & Snow Plowing")	
replace Aarons = 0 if strpos(employer, "Aaron's Lawn Care And Landscaping, Llc")   
replace Aarons = 0 if strpos(employer, "Aaron's Low Cost Cremation & Funeral Llc") 
replace Aarons = 0 if strpos(employer, "Aaron's Photo Tours")					
replace Aarons = 0 if strpos(employer, "Aaron's Rolling Fork")					
replace Aarons = 0 if strpos(employer, "Aaron's Roto Rooter")					
replace Aarons = 0 if strpos(employer, "Aaron's Semi Repair Inc")				
replace Aarons = 0 if strpos(employer, "Aaron's Semi Repair, Inc")				
replace Aarons = 0 if strpos(employer, "Aaron's Towing Llc")					
replace Aarons = 0 if strpos(employer, "Aaron's Tree Service Llc")				
replace Aarons = 0 if strpos(employer, "Aarons Tree Service")					
replace Aarons = 0 if strpos(employer, "Aarons Academy Beauty")					
replace Aarons = 0 if strpos(employer, "Aarons Auto Center")					
replace Aarons = 0 if strpos(employer, "Aarons Auto Pro")						
replace Aarons = 0 if strpos(employer, "Aarons Bicycle Repair")					
replace Aarons = 0 if strpos(employer, "Aarons Biosweep Restoration , Construction/Remodel Fire Water Mold Remediators") 
replace Aarons = 0 if strpos(employer, "Aarons Body Shop")						
replace Aarons = 0 if strpos(employer, "Aarons Car Care")						
replace Aarons = 0 if strpos(employer, "Aarons Catering")						
replace Aarons = 0 if strpos(employer, "Aarons Cleaning Company")				
replace Aarons = 0 if strpos(employer, "Aarons Concrete Pumping Incorporated")	
replace Aarons = 0 if strpos(employer, "Aarons Garage Door Company")			
replace Aarons = 0 if strpos(employer, "Aarons Greenscape")						
replace Aarons = 0 if strpos(employer, "Aarons Greenscape Incorporated")		
replace Aarons = 0 if strpos(employer, "Aarons Landscaping")					
replace Aarons = 0 if strpos(employer, "Aarons Lawn Care")						
replace Aarons = 0 if strpos(employer, "Aarons Lawn Care & Landscaping, Inc")	
replace Aarons = 0 if strpos(employer, "Aarons Lawn Care & Lanscaping")			
replace Aarons = 0 if strpos(employer, "Aarons Lawn Care And Lanscaping")		
replace Aarons = 0 if strpos(employer, "Aarons Lawn Care Services")				
replace Aarons = 0 if strpos(employer, "Aarons Lock Safe Incorporated")			
replace Aarons = 0 if strpos(employer, "Aarons Locksmith Llc")					
replace Aarons = 0 if strpos(employer, "Aarons Locksmith Service")				
replace Aarons = 0 if strpos(employer, "Aarons Marine Service")					
replace Aarons = 0 if strpos(employer, "Aarons Moving")							
replace Aarons = 0 if strpos(employer, "Aarons Pest Control Llc")				
replace Aarons = 0 if strpos(employer, "Aarons Plumbing")						
replace Aarons = 0 if strpos(employer, "Aarons Plumbing Incorporated")			
replace Aarons = 0 if strpos(employer, "Aarons Plumbing Llc")					
replace Aarons = 0 if strpos(employer, "Aarons Reliable Movers Incorporated")	
replace Aarons = 0 if strpos(employer, "Aarons Taco Cartel")					
replace Aarons = 0 if strpos(employer, "Aarons Towing")							
replace Aarons = 0 if strpos(employer, "Aarons Water Service Incorporated")		
replace Aarons = 0 if strpos(employer, "Aarons/Hawpond Partners")				
replace Aarons = 0 if strpos(employer, "Aaronscutting At Gmail Com")			
replace Aarons = 0 if strpos(employer, "Aaronsen Group") | strpos(employer, "Aaronson") 
replace Aarons = 0 if strpos(employer, "Crazy Aarons Puttyworld")				
replace Aarons = 0 if strpos(employer, "Vaarons Maintenance")					
replace Aarons = 0 if strpos(employer, "Aaron's Best One Tire")					
replace Aarons = 0 if strpos(employer, "Aaron's Electricalworks")				
replace Aarons = 0 if strpos(employer, "Aaron's Electrical Works")				
replace Aarons = 0 if strpos(employer, "Aaron's Heating & Air Conditioning")	
replace Aarons = 0 if strpos(employer, "Aaron's Locksmith & Security")			
replace Aarons = 0 if strpos(employer, "Aaron's Painting And Remodeling")		
replace Aarons = 0 if strpos(employer, "Aaron's Restoration & Carpet Cleaning, Llc")   
replace Aarons = 0 if strpos(employer, "Aaron's Restoration Amp Carpet Cleaning, Llc") 
replace Aarons = 0 if strpos(employer, "Aaron's Restoration And Carpet Cleaning, Llc") 
replace Aarons = 0 if strpos(employer, "Aaron's Restoration & Home Improvement")	   
replace Aarons = 0 if strpos(employer, "Aaron's Systems Integrators Inc")		
replace Aarons = 0 if strpos(employer, "Aarons Doors Llc")						
replace Aarons = 0 if strpos(employer, "Aarons Affordable Carpet Care Llc")		
replace Aarons = 0 if strpos(employer, "Aarons Cabinetry")						
replace Aarons = 0 if strpos(employer, "Aarons Estate Sales")					
replace Aarons = 0 if strpos(employer, "Aarons Family Fun Center Incorporated")	
replace Aarons = 0 if strpos(employer, "Aarons Home Care")						
replace Aarons = 0 if strpos(employer, "Aarons Hope")							
replace Aarons = 0 if strpos(employer, "Aarons Painting")						
replace franchise_id  = 57 if Aarons >= 1 & franchise_id == .
replace franchise_id2 = 57 if Aarons >= 1 & franchise_id != .
replace franchise_id3 = 57 if Aarons >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Aarons >= 1
drop 	Aarons 

gen 	Slumberland = strpos(lower(employer), "slumber land") | strpos(lower(employer), "slumberland")
replace franchise_id  = 58 if Slumberland >= 1 & franchise_id == .
replace franchise_id2 = 58 if Slumberland >= 1 & franchise_id != .
replace franchise_id3 = 58 if Slumberland >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Slumberland >= 1
drop 	Slumberland  

gen 	Abbey_Carpet = strpos(lower(employer), "abbey carp")
replace franchise_id  = 59 if Abbey_Carpet >= 1 & franchise_id == .
replace franchise_id2 = 59 if Abbey_Carpet >= 1 & franchise_id != .
replace franchise_id3 = 59 if Abbey_Carpet >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Abbey_Carpet >= 1
drop 	Abbey_Carpet 

gen 	Floor_Coverings = 	   strpos(lower(employer), "floor coverings int") | strpos(lower(employer), "floorcoverings int") 
replace franchise_id  = 60 if Floor_Coverings >= 1 & franchise_id == .
replace franchise_id2 = 60 if Floor_Coverings >= 1 & franchise_id != .
replace franchise_id3 = 60 if Floor_Coverings >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Floor_Coverings >= 1
drop 	Floor_Coverings 

gen 	Floors_To_Go = 		strpos(lower(employer), "floors to go")
replace Floors_To_Go = 0 if strpos(employer, "Beneficial Floors To Go, Llc")	
replace franchise_id  = 61 if Floors_To_Go >= 1 & franchise_id == .
replace franchise_id2 = 61 if Floors_To_Go >= 1 & franchise_id != .
replace franchise_id3 = 61 if Floors_To_Go >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Floors_To_Go >= 1
drop 	Floors_To_Go 

gen 	Fast_Frame = strpos(lower(employer), "fastframe") | strpos(lower(employer), "fast frame")
replace franchise_id  = 62 if Fast_Frame >= 1 & franchise_id == .
replace franchise_id2 = 62 if Fast_Frame >= 1 & franchise_id != .
replace franchise_id3 = 62 if Fast_Frame >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Fast_Frame >= 1
drop 	Fast_Frame

gen 	Franchise_Concepts = strpos(lower(employer), "franchise concepts") | strpos(lower(employer), "great frame") | strpos(lower(employer), "the great frame") | ///
							 strpos(lower(employer), "deck the walls")	   | strpos(lower(employer), "framing art centre") 
replace Franchise_Concepts = 0 if strpos(employer, "Home Franchise Concepts")
replace franchise_id  = 63 if Franchise_Concepts >= 1 & franchise_id == .
replace franchise_id2 = 63 if Franchise_Concepts >= 1 & franchise_id != .
replace franchise_id3 = 63 if Franchise_Concepts >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Franchise_Concepts >= 1
drop 	Franchise_Concepts 

gen 	Aerus = 	 strpos(lower(employer), "aerus")
replace Aerus = 0 if strpos(lower(employer), "kaerus")
replace Aerus = 0 if strpos(lower(employer), "caerus")
replace Aerus = 0 if strpos(lower(employer), "novaerus")
replace franchise_id  = 64 if Aerus >= 1 & franchise_id == .
replace franchise_id2 = 64 if Aerus >= 1 & franchise_id != .
replace franchise_id3 = 64 if Aerus >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Aerus >= 1
drop 	Aerus 

gen 	Batteries_Plus = strpos(lower(employer), "batteries plus") | strpos(lower(employer), "batteriesplus")
replace franchise_id  = 65 if Batteries_Plus >= 1 & franchise_id == .
replace franchise_id2 = 65 if Batteries_Plus >= 1 & franchise_id != .
replace franchise_id3 = 65 if Batteries_Plus >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Batteries_Plus >= 1
drop 	Batteries_Plus

gen 	Interstate_Batteries = strpos(lower(employer), "interstate batter") | strpos(lower(employer), "interstate all batter")
replace franchise_id  = 66 if Interstate_Batteries >= 1 & franchise_id == .
replace franchise_id2 = 66 if Interstate_Batteries >= 1 & franchise_id != .
replace franchise_id3 = 66 if Interstate_Batteries >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Interstate_Batteries >= 1
drop 	Interstate_Batteries

gen 	Wireless_Zone = strpos(lower(employer), "wireless zone") | strpos(lower(employer), "wirelesszone")
replace franchise_id  = 67 if Wireless_Zone >= 1 & franchise_id == .
replace franchise_id2 = 67 if Wireless_Zone >= 1 & franchise_id != .
replace franchise_id3 = 67 if Wireless_Zone >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Wireless_Zone >= 1
drop 	Wireless_Zone

gen 	Zagg = 		strpos(lower(employer), "zagg")
replace Zagg = 0 if strpos(employer, "Madzagg Llc")								
replace franchise_id  = 68 if Zagg >= 1 & franchise_id == .
replace franchise_id2 = 68 if Zagg >= 1 & franchise_id != .
replace franchise_id3 = 68 if Zagg >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Zagg >= 1
drop 	Zagg 

gen 	Re_Bath = 	   strpos(lower(employer), "rebath") | strpos(lower(employer), "re bath")
replace Re_Bath = 0 if strpos(employer, "Atmosphere Bath & Kitchen")			
replace Re_Bath = 0 if strpos(employer, "Bird Decorative Hardware Bath")		
replace Re_Bath = 0 if strpos(employer, "Cobell Home 'baltimore Bathroom Experts'")	
replace Re_Bath = 0 if strpos(employer, "Fiber Care Baths")						
replace Re_Bath = 0 if strpos(employer, "Fiber Care Baths Incorporated")		
replace Re_Bath = 0 if strpos(employer, "Premier Care Bathing")					
replace Re_Bath = 0 if strpos(employer, "Sapphire Bath")						
replace franchise_id  = 69 if Re_Bath >= 1 & franchise_id == .
replace franchise_id2 = 69 if Re_Bath >= 1 & franchise_id != .
replace franchise_id3 = 69 if Re_Bath >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Re_Bath >= 1
drop 	Re_Bath 

gen 	Rocky_Mtn_Chocolate = strpos(lower(employer), "rocky mountain chocolate")
replace franchise_id  = 70 if Rocky_Mtn_Chocolate >= 1 & franchise_id == .
replace franchise_id2 = 70 if Rocky_Mtn_Chocolate >= 1 & franchise_id != .
replace franchise_id3 = 70 if Rocky_Mtn_Chocolate >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Rocky_Mtn_Chocolate >= 1
drop 	Rocky_Mtn_Chocolate 

gen 	Dream_Dinners = strpos(lower(employer), "dream dinners")
replace franchise_id  = 71 if Dream_Dinners >= 1 & franchise_id == .
replace franchise_id2 = 71 if Dream_Dinners >= 1 & franchise_id != .
replace franchise_id3 = 71 if Dream_Dinners >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Dream_Dinners >= 1
drop 	Dream_Dinners 

gen 	Amerisource_Bergen = 	  strpos(lower(employer), "amerisource") | strpos(lower(employer), "amensource") | strpos(lower(employer), "good neighbor pharm")
replace Amerisource_Bergen = 0 if strpos(employer, "Amerisource Funding Incorporated") 
replace Amerisource_Bergen = 0 if strpos(employer, "Amerisource Health Services Llc")  
replace Amerisource_Bergen = 0 if strpos(employer, "Amerisource Hr Consulting Group")  
replace Amerisource_Bergen = 0 if strpos(employer, "Amerisource Industrial Su")		   
replace Amerisource_Bergen = 0 if strpos(employer, "Amerisource Industrial Supply")	   
replace Amerisource_Bergen = 0 if strpos(employer, "Amerisource Technologies, Inc")	   
replace Amerisource_Bergen = 0 if strpos(employer, "Amerisource Transport Inc")		   
replace franchise_id  = 72 if Amerisource_Bergen >= 1 & franchise_id == .
replace franchise_id2 = 72 if Amerisource_Bergen >= 1 & franchise_id != .
replace franchise_id3 = 72 if Amerisource_Bergen >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Amerisource_Bergen >= 1
drop 	Amerisource_Bergen 

gen 	Health_Mart = 	   strpos(lower(employer), "health mart") | strpos(lower(employer), "healthmart")
replace Health_Mart = 0 if strpos(employer, "Encompass Health Martin, Tn 38237") 
replace Health_Mart = 0 if strpos(employer, "Scp Health Martin, Ky 41649")		 
replace Health_Mart = 0 if strpos(employer, "Sovah Health Martinsville")		 
replace franchise_id  = 73 if Health_Mart >= 1 & franchise_id == .
replace franchise_id2 = 73 if Health_Mart >= 1 & franchise_id != .
replace franchise_id3 = 73 if Health_Mart >= 1 & franchise_id != . & franchise_id2 != .
* ?
tab 	employer 		   if Health_Mart >= 1
drop 	Health_Mart

gen 	Medicap = 	   strpos(lower(employer), "medicap") | strpos(lower(employer), "medi cap") 
replace Medicap = 0 if strpos(employer, "Medicapital Rent") 					
replace Medicap = 0 if strpos(employer, "Medicapital Usa") 						
replace franchise_id  = 74 if Medicap >= 1 & franchise_id == .
replace franchise_id2 = 74 if Medicap >= 1 & franchise_id != .
replace franchise_id3 = 74 if Medicap >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Medicap >= 1
drop 	Medicap 

gen 	Merle_Norman = strpos(lower(employer), "merle norman")
replace franchise_id  = 75 if Merle_Norman >= 1 & franchise_id == .
replace franchise_id2 = 75 if Merle_Norman >= 1 & franchise_id != .
replace franchise_id3 = 75 if Merle_Norman >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Merle_Norman >= 1
drop 	Merle_Norman 

gen 	Complete_Nutrition = strpos(lower(employer), "complete nutrition")
replace franchise_id  = 76 if Complete_Nutrition >= 1 & franchise_id == .
replace franchise_id2 = 76 if Complete_Nutrition >= 1 & franchise_id != .
replace franchise_id3 = 76 if Complete_Nutrition >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Complete_Nutrition >= 1
drop 	Complete_Nutrition 

gen 	GNC = strpos(lower(employer), "general nutrition") | strpos(employer, "GNC")
replace franchise_id  = 77 if GNC >= 1 & franchise_id == .
replace franchise_id2 = 77 if GNC >= 1 & franchise_id != .
replace franchise_id3 = 77 if GNC >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if GNC >= 1
drop 	GNC

gen 	Max_Muscle = strpos(lower(employer), "max muscle") | strpos(lower(employer), "maxmuscle") | strpos(lower(employer), "peak franchising") 
replace franchise_id  = 78 if Max_Muscle >= 1 & franchise_id == .
replace franchise_id2 = 78 if Max_Muscle >= 1 & franchise_id != .
replace franchise_id3 = 78 if Max_Muscle >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Max_Muscle >= 1
drop 	Max_Muscle 

gen 	Miracle_Ear = 	   strpos(lower(employer), "miracle ear")
replace Miracle_Ear = 0 if strpos(employer, "Miracle Earnings Com") 			
replace franchise_id  = 79 if Miracle_Ear >= 1 & franchise_id == .
replace franchise_id2 = 79 if Miracle_Ear >= 1 & franchise_id != .
replace franchise_id3 = 79 if Miracle_Ear >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Miracle_Ear >= 1
drop 	Miracle_Ear

gen 	Zounds = 	  strpos(lower(employer), "zounds")
replace Zounds = 0 if strpos(employer, "Zzounds") 								
replace franchise_id  = 80 if Zounds >= 1 & franchise_id == .
replace franchise_id2 = 80 if Zounds >= 1 & franchise_id != .
replace franchise_id3 = 80 if Zounds >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Zounds >= 1
drop 	Zounds

gen 	Seven_Eleven = 		strpos(lower(employer), "7-elev")  | strpos(lower(employer), "7elev") 		 | strpos(lower(employer), "7 elev") | ///
							strpos(lower(employer), "711 inc") | strpos(lower(employer), "seven eleven") | strpos(lower(employer), "7-11") 	 | ///
							strpos(lower(employer), "7 11") 	
replace Seven_Eleven = 0 if strpos(employer, "2018 07 11Mh Construction") 		
replace Seven_Eleven = 0 if strpos(employer, "2018 07 11Urban Land") 			
replace Seven_Eleven = 0 if strpos(employer, "2019 07 11Idaho Tree") 			
replace Seven_Eleven = 0 if strpos(employer, "7 11 Cold") 						
replace Seven_Eleven = 0 if strpos(employer, "7 11 Bira") 						
replace Seven_Eleven = 0 if strpos(employer, "7 11 Plumbing Contractors Inc") 	
replace Seven_Eleven = 0 if strpos(employer, "Ahepa 127 11 Apartments") 		
replace Seven_Eleven = 0 if strpos(employer, "Cook Illinois Corp Company") 		
replace Seven_Eleven = 0 if strpos(employer, "Michael's Cafe And Catering 1 805 517 1100") 
replace franchise_id  = 81 if Seven_Eleven >= 1 & franchise_id == .
replace franchise_id2 = 81 if Seven_Eleven >= 1 & franchise_id != .
replace franchise_id3 = 81 if Seven_Eleven >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Seven_Eleven >= 1
drop 	Seven_Eleven 

gen 	Circle_K = 		strpos(lower(employer), "circle k") | strpos(lower(employer), "circlek")
replace Circle_K = 0 if strpos(employer, "Circle Kennel Club") 					
replace Circle_K = 0 if strpos(employer, "Circle Kids") 						
replace Circle_K = 0 if strpos(employer, "Cropcircle Kitchen") 					
replace Circle_K = 0 if strpos(employer, "The Learning Circle Kinderschool") 	
replace Circle_K = 0 if strpos(employer, "Winners Circle Kustom Autobody") 		
replace franchise_id  = 82 if Circle_K >= 1 & franchise_id == .
replace franchise_id2 = 82 if Circle_K >= 1 & franchise_id != .
replace franchise_id3 = 82 if Circle_K >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Circle_K >= 1
drop 	Circle_K 

gen 	Super_America = 	 strpos(lower(employer), "super america") | strpos(lower(employer), "superamerica")
replace Super_America = 0 if strpos(employer, "Super America Electric Incorporated") 
replace Super_America = 0 if strpos(employer, "Super America Pizza & Food Shop") 	 
replace franchise_id  = 83 if Super_America >= 1 & franchise_id == .
replace franchise_id2 = 83 if Super_America >= 1 & franchise_id != .
replace franchise_id3 = 83 if Super_America >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Super_America >= 1
drop 	Super_America 

gen 	Flip_Flop = 	 strpos(lower(employer), "flipflop") | strpos(lower(employer), "flip flop")
replace Flip_Flop = 0 if strpos(employer, "Ahhsoles Flip Flops Llc") 			
replace Flip_Flop = 0 if strpos(employer, "Blazer And Flip Flops, Inc") 		
replace Flip_Flop = 0 if strpos(employer, "Blazers And Flip Flops, Inc") 		
replace Flip_Flop = 0 if strpos(employer, "Flip Flop A New Musical") 			
replace Flip_Flop = 0 if strpos(employer, "Flip Flop Cafe") 					
replace Flip_Flop = 0 if strpos(employer, "Flip Flop Fitness") 					
replace Flip_Flop = 0 if strpos(employer, "Flip Flop Gymnastics") 				
replace Flip_Flop = 0 if strpos(employer, "Flip Flop Stop") 					
replace Flip_Flop = 0 if strpos(employer, "Flip Flops & What Nots") 			
replace Flip_Flop = 0 if strpos(employer, "Flipflops & Whatnots") 				
replace Flip_Flop = 0 if strpos(employer, "Flip Flopz") 						
replace Flip_Flop = 0 if strpos(employer, "Maywood Fine Arts Association Flip Flop And Fly Tumbling Studio") 
replace Flip_Flop = 0 if strpos(employer, "The Gift Card Flip Flop") 			
replace Flip_Flop = 0 if strpos(employer, "Flip Flop Lab") 						
replace Flip_Flop = 0 if strpos(employer, "Flipflop Of The Lakeshore") 			
replace franchise_id  = 84 if Flip_Flop >= 1 & franchise_id == .
replace franchise_id2 = 84 if Flip_Flop >= 1 & franchise_id != .
replace franchise_id3 = 84 if Flip_Flop >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Flip_Flop >= 1
drop 	Flip_Flop 

gen 	Good_Feet = strpos(lower(employer), "good feet")
replace franchise_id  = 85 if Good_Feet >= 1 & franchise_id == .
replace franchise_id2 = 85 if Good_Feet >= 1 & franchise_id != .
replace franchise_id3 = 85 if Good_Feet >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Good_Feet >= 1
drop 	Good_Feet 

gen 	Pandora = 	   strpos(lower(employer), "pandora")
replace Pandora = 0 if strpos(employer, "Pandora Box Of Creativity") 			
replace Pandora = 0 if strpos(employer, "Pandora Internet Radio") 				
replace Pandora = 0 if strpos(employer, "Pandora Gilboa School") 				
replace Pandora = 0 if strpos(employer, "Pandora Karaoke & Bar") 				
replace Pandora = 0 if strpos(employer, "Pandora Missionary Church") 			
replace Pandora = 0 if strpos(employer, "Pandora Radio") 						
replace Pandora = 0 if strpos(employer, "Pandora Security") 					
replace Pandora = 0 if strpos(employer, "Pandora Security Labs") 				
replace Pandora = 0 if strpos(employer, "Pandora's Pantry Natural Food Store") 	
replace Pandora = 0 if strpos(employer, "Pandora's Pies") 						
replace Pandora = 0 if strpos(employer, "Pandoras Lunchbox") 					
replace Pandora = 0 if strpos(employer, "Pandoras Mens Club") 					
replace Pandora = 0 if strpos(employer, "Pandora Marketing") 					
replace Pandora = 0 if strpos(employer, "Pandora The Largest Internet Radio") 	
replace Pandora = 0 if strpos(employer, "Pandora Fitness") 						
replace Pandora = 0 if strpos(employer, "Pandora Media") 						
replace Pandora = 0 if strpos(employer, "Phone Pandora") 						
replace Pandora = 0 if strpos(employer, "First National Bank") 					
replace franchise_id  = 86 if Pandora >= 1 & franchise_id == .
replace franchise_id2 = 86 if Pandora >= 1 & franchise_id != .
replace franchise_id3 = 86 if Pandora >= 1 & franchise_id != . & franchise_id2 != .
* ?
tab 	employer 		   if Pandora >= 1
drop 	Pandora

gen 	Fleet_Feet = strpos(lower(employer), "fleet feet") | strpos(lower(employer), "fleetfeet")
replace franchise_id  = 87 if Fleet_Feet >= 1 & franchise_id == .
replace franchise_id2 = 87 if Fleet_Feet >= 1 & franchise_id != .
replace franchise_id3 = 87 if Fleet_Feet >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Fleet_Feet >= 1
drop 	Fleet_Feet

gen 	Pro_Image = 	 strpos(lower(employer), "pro image") | strpos(lower(employer), "proimage")
replace Pro_Image = 0 if strpos(employer, "Pro Image Auto Spa") 				
replace Pro_Image = 0 if strpos(employer, "Pro Image Barbershop") 				
replace Pro_Image = 0 if strpos(employer, "Pro Image Barbershop, Llc") 			
replace Pro_Image = 0 if strpos(employer, "Pro Image Salon") 					
replace Pro_Image = 0 if strpos(employer, "Proimagez School Photography") 		
replace Pro_Image = 0 if strpos(employer, "Proimagez") 							
replace Pro_Image = 0 if strpos(employer, "Proimagez School Photography") 		
replace Pro_Image = 0 if strpos(employer, "Pro Image Painting Llc") 			
replace Pro_Image = 0 if strpos(employer, "Pro Image Soluti") 					
replace Pro_Image = 0 if strpos(employer, "Pro Image Solutions Incorporated") 	
replace Pro_Image = 0 if strpos(employer, "Pro Images Llc") 					
replace Pro_Image = 0 if strpos(employer, "Pro Image Design") 					
replace Pro_Image = 0 if strpos(employer, "Pro Image Facility Services") 		
replace Pro_Image = 0 if strpos(employer, "Proimage Facility Services") 		
replace Pro_Image = 0 if strpos(employer, "Proimage Apparel, Llc") 				
replace Pro_Image = 0 if strpos(employer, "Proimage Wholesale Signs") 			
replace franchise_id  = 88 if Pro_Image >= 1 & franchise_id == .
replace franchise_id2 = 88 if Pro_Image >= 1 & franchise_id != .
replace franchise_id3 = 88 if Pro_Image >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Pro_Image >= 1
drop 	Pro_Image

gen 	Hobbytown_Core_Concept = strpos(lower(employer), "hobbytown") | strpos(lower(employer), "hobby town")
replace franchise_id  = 89 if Hobbytown_Core_Concept >= 1 & franchise_id == .
replace franchise_id2 = 89 if Hobbytown_Core_Concept >= 1 & franchise_id != .
replace franchise_id3 = 89 if Hobbytown_Core_Concept >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Hobbytown_Core_Concept >= 1
drop 	Hobbytown_Core_Concept
	
gen 	Learning_Express = 		strpos(lower(employer), "learningexpress") | strpos(lower(employer), "learning express")
replace Learning_Express = 0 if strpos(employer, "Carbo's Learning Express Preschool") 	
replace Learning_Express = 0 if strpos(employer, "Childrens Learning Express") 			
replace Learning_Express = 0 if strpos(employer, "Kidzone Learning Express") 			
replace Learning_Express = 0 if strpos(employer, "Learning Express Child Development Center") 
replace Learning_Express = 0 if strpos(employer, "Learning Express Child Care") 		
replace Learning_Express = 0 if strpos(employer, "Learning Express Preschool") 			
replace Learning_Express = 0 if strpos(employer, "Learning Express Preschool Center")	
replace Learning_Express = 0 if strpos(employer, "The Learning Express Learning Center") 
replace Learning_Express = 0 if strpos(employer, "The Learning Express Llc") 			
replace Learning_Express = 0 if strpos(employer, "Carbo's Learning Express") 			
replace Learning_Express = 0 if strpos(employer, "Carbos Learning Express") 			
replace Learning_Express = 0 if strpos(employer, "Carbo& X2019 S Learning Express") 	
replace Learning_Express = 0 if strpos(employer, "Learning Express Childcare") 			
replace franchise_id  = 90 if Learning_Express >= 1 & franchise_id == .
replace franchise_id2 = 90 if Learning_Express >= 1 & franchise_id != .
replace franchise_id3 = 90 if Learning_Express >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Learning_Express >= 1
drop 	Learning_Express 

gen 	One800_Flowers = strpos(lower(employer), "1800 flowers") | strpos(lower(employer), "1800flowers") | strpos(lower(employer), "1 800 flowers") 
replace franchise_id  = 91 if One800_Flowers >= 1 & franchise_id == .
replace franchise_id2 = 91 if One800_Flowers >= 1 & franchise_id != .
replace franchise_id3 = 91 if One800_Flowers >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if One800_Flowers >= 1
drop 	One800_Flowers

gen 	Flowerama = strpos(lower(employer), "flowerama")
replace franchise_id  = 92 if Flowerama >= 1 & franchise_id == .
replace franchise_id2 = 92 if Flowerama >= 1 & franchise_id != .
replace franchise_id3 = 92 if Flowerama >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Flowerama >= 1
drop 	Flowerama

gen 	Halloween_Exp = strpos(lower(employer), "halloween exp") | strpos(lower(employer), "halloween costume")
replace franchise_id  = 93 if Halloween_Exp >= 1 & franchise_id == .
replace franchise_id2 = 93 if Halloween_Exp >= 1 & franchise_id != .
replace franchise_id3 = 93 if Halloween_Exp >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Halloween_Exp >= 1
drop 	Halloween_Exp 

gen 	Clothes_Mentor = strpos(lower(employer), "clothes ment")
replace franchise_id  = 94 if Clothes_Mentor >= 1 & franchise_id == .
replace franchise_id2 = 94 if Clothes_Mentor >= 1 & franchise_id != .
replace franchise_id3 = 94 if Clothes_Mentor >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Clothes_Mentor >= 1
drop 	Clothes_Mentor

gen 	Just_Between_Friends = strpos(lower(employer), "just between")
replace franchise_id  = 95 if Just_Between_Friends >= 1 & franchise_id == .
replace franchise_id2 = 95 if Just_Between_Friends >= 1 & franchise_id != .
replace franchise_id3 = 95 if Just_Between_Friends >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Just_Between_Friends >= 1
drop 	Just_Between_Friends

gen 	Kid_To_Kid = 	  strpos(lower(employer), "kid to kid")
replace Kid_To_Kid = 0 if strpos(employer, "Kid To Kid Child Development Center") 
replace franchise_id  = 96 if Kid_To_Kid >= 1 & franchise_id == .
replace franchise_id2 = 96 if Kid_To_Kid >= 1 & franchise_id != .
replace franchise_id3 = 96 if Kid_To_Kid >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Kid_To_Kid >= 1
drop 	Kid_To_Kid 

gen 	Once_Upon_A_Child = 	 strpos(lower(employer), "once upon a child")
replace Once_Upon_A_Child = 0 if strpos(employer, "Once Upon A Childcare") 		
replace Once_Upon_A_Child = 0 if strpos(employer, "Once Upon A Childcare Llc")	
replace franchise_id  = 97 if Once_Upon_A_Child >= 1 & franchise_id == .
replace franchise_id2 = 97 if Once_Upon_A_Child >= 1 & franchise_id != .
replace franchise_id3 = 97 if Once_Upon_A_Child >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Once_Upon_A_Child >= 1
drop 	Once_Upon_A_Child

gen 	Platos_Closet = strpos(lower(employer), "platos closet") | strpos(lower(employer), "plato's closet")
replace franchise_id  = 98 if Platos_Closet >= 1 & franchise_id == .
replace franchise_id2 = 98 if Platos_Closet >= 1 & franchise_id != .
replace franchise_id3 = 98 if Platos_Closet >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Platos_Closet >= 1
drop 	Platos_Closet 

gen 	Play_It_Again = strpos(lower(employer), "play it again")
replace franchise_id  = 99 if Play_It_Again >= 1 & franchise_id == .
replace franchise_id2 = 99 if Play_It_Again >= 1 & franchise_id != .
replace franchise_id3 = 99 if Play_It_Again >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		   if Play_It_Again >= 1
drop 	Play_It_Again

gen 	Pet_Supplies_Plus = strpos(lower(employer), "pet supplies plus") | strpos(lower(employer), "psp franchising") 
replace franchise_id  = 100 if Pet_Supplies_Plus >= 1 & franchise_id == .
replace franchise_id2 = 100 if Pet_Supplies_Plus >= 1 & franchise_id != .
replace franchise_id3 = 100 if Pet_Supplies_Plus >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		    if Pet_Supplies_Plus >= 1
drop 	Pet_Supplies_Plus

gen 	Wild_Birds = strpos(lower(employer), "wild birds") | strpos(lower(employer), "wildbirds")
replace franchise_id  = 101 if Wild_Birds >= 1 & franchise_id == .
replace franchise_id2 = 101 if Wild_Birds >= 1 & franchise_id != .
replace franchise_id3 = 101 if Wild_Birds >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		    if Wild_Birds >= 1
drop 	Wild_Birds

gen 	Crown_Trophy = strpos(lower(employer), "crown trophy")
replace franchise_id  = 102 if Crown_Trophy >= 1 & franchise_id == .
replace franchise_id2 = 102 if Crown_Trophy >= 1 & franchise_id != .
replace franchise_id3 = 102 if Crown_Trophy >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		    if Crown_Trophy >= 1
drop 	Crown_Trophy

gen 	Fresh_Healthy_Vending = strpos(lower(employer), "fresh healthy vending") | strpos(lower(employer), "fresh!")
replace franchise_id  = 103 if Fresh_Healthy_Vending >= 1 & franchise_id == .
replace franchise_id2 = 103 if Fresh_Healthy_Vending >= 1 & franchise_id != .
replace franchise_id3 = 103 if Fresh_Healthy_Vending >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		    if Fresh_Healthy_Vending >= 1
drop 	Fresh_Healthy_Vending 

gen 	Dental_Fix = strpos(lower(employer), "dental fix") | strpos(lower(employer), "dentalfix") 
replace franchise_id  = 104 if Dental_Fix >= 1 & franchise_id == .
replace franchise_id2 = 104 if Dental_Fix >= 1 & franchise_id != .
replace franchise_id3 = 104 if Dental_Fix >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		    if Dental_Fix >= 1
drop 	Dental_Fix

gen 	Mac_Tools = 	 strpos(lower(employer), "mactools") | strpos(lower(employer), "mac tools") 
replace Mac_Tools = 0 if strpos(employer, "Jmac Tools, Inc")					
replace franchise_id  = 105 if Mac_Tools >= 1 & franchise_id == .
replace franchise_id2 = 105 if Mac_Tools >= 1 & franchise_id != .
replace franchise_id3 = 105 if Mac_Tools >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		    if Mac_Tools >= 1
drop 	Mac_Tools

gen 	Snap_On_Tools = 	 strpos(lower(employer), "snap on") 
replace Snap_On_Tools = 0 if strpos(employer, "Snap On Optics")					
replace Snap_On_Tools = 0 if strpos(employer, "Snap On Smile")					
replace franchise_id  = 106 if Snap_On_Tools >= 1 & franchise_id == .
replace franchise_id2 = 106 if Snap_On_Tools >= 1 & franchise_id != .
replace franchise_id3 = 106 if Snap_On_Tools >= 1 & franchise_id != . & franchise_id2 != .
* ?
tab 	employer 		    if Snap_On_Tools >= 1
drop 	Snap_On_Tools

gen 	Two_Men = 	   strpos(lower(employer), "two men")
replace Two_Men = 0 if strpos(employer, "Two Men & A Vacuum")					
replace Two_Men = 0 if strpos(employer, "Two Men And A Moving Van")				
replace Two_Men = 0 if strpos(employer, "Two Men And A Moving Van Llc")			
replace Two_Men = 0 if strpos(employer, "Two Men And A Snake")					
replace Two_Men = 0 if strpos(employer, "Two Men Spa Dolly Llc")				
replace Two_Men = 0 if strpos(employer, "Two Men Mower")						
replace Two_Men = 0 if strpos(employer, "Two Men Some Tools")					
replace franchise_id  = 107 if Two_Men >= 1 & franchise_id == .
replace franchise_id2 = 107 if Two_Men >= 1 & franchise_id != .
replace franchise_id3 = 107 if Two_Men >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		    if Two_Men >= 1
drop 	Two_Men

gen 	Coffee_News = 	   strpos(lower(employer), "coffee news")
replace Coffee_News = 0 if strpos(employer, "Scooters Coffee Newsellers Llc")	
replace franchise_id  = 108 if Coffee_News >= 1 & franchise_id == .
replace franchise_id2 = 108 if Coffee_News >= 1 & franchise_id != .
replace franchise_id3 = 108 if Coffee_News >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		    if Coffee_News >= 1
drop 	Coffee_News

gen 	Ameriprise = strpos(lower(employer), "ameriprise")
replace franchise_id  = 109 if Ameriprise >= 1 & franchise_id == .
replace franchise_id2 = 109 if Ameriprise >= 1 & franchise_id != .
replace franchise_id3 = 109 if Ameriprise >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		    if Ameriprise >= 1
drop 	Ameriprise

gen 	Charles_Schwab = strpos(lower(employer), "charles schwab") | strpos(lower(employer), "charlesschwab")
replace franchise_id  = 110 if Charles_Schwab >= 1 & franchise_id == .
replace franchise_id2 = 110 if Charles_Schwab >= 1 & franchise_id != .
replace franchise_id3 = 110 if Charles_Schwab >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		    if Charles_Schwab >= 1
drop 	Charles_Schwab

gen 	Brightway = 	 strpos(lower(employer), "brightway")
replace Brightway = 0 if strpos(employer, "Brightway Adult Daycare")
replace Brightway = 0 if strpos(employer, "Brightway Auto Sales")				
replace Brightway = 0 if strpos(employer, "Brightway Carpet Cleaning")			
replace Brightway = 0 if strpos(employer, "Brightway Commercial Cleaning")		
replace Brightway = 0 if strpos(employer, "Brightway Mental Health Clinic, Llc") 
replace Brightway = 0 if strpos(employer, "Brightway Mental Health Llc")		
replace Brightway = 0 if strpos(employer, "Brightway Mobility")					
replace Brightway = 0 if strpos(employer, "Brightway Personal Care Home")		
replace Brightway = 0 if strpos(employer, "Brightway Properties Llc")			
replace Brightway = 0 if strpos(employer, "Brightways Counseling Group")		
replace franchise_id  = 111 if Brightway >= 1 & franchise_id == .
replace franchise_id2 = 111 if Brightway >= 1 & franchise_id != .
replace franchise_id3 = 111 if Brightway >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		    if Brightway >= 1
drop 	Brightway

gen 	Fiesta_Insurance = strpos(lower(employer), "fiesta ins") | strpos(lower(employer), "fiesta auto ins")
replace franchise_id  = 112 if Fiesta_Insurance >= 1 & franchise_id == .
replace franchise_id2 = 112 if Fiesta_Insurance >= 1 & franchise_id != .
replace franchise_id3 = 112 if Fiesta_Insurance >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		    if Fiesta_Insurance >= 1
drop 	Fiesta_Insurance

gen 	Frontier_Adjusters = strpos(lower(employer), "frontier adj")
replace franchise_id  = 113 if Frontier_Adjusters >= 1 & franchise_id == .
replace franchise_id2 = 113 if Frontier_Adjusters >= 1 & franchise_id != .
replace franchise_id3 = 113 if Frontier_Adjusters >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		    if Frontier_Adjusters >= 1
drop 	Frontier_Adjusters 

gen 	Go_Minis = 		strpos(lower(employer), "go minis") | strpos(lower(employer), "go mini's")
replace Go_Minis = 0 if strpos(employer, "Rewigo Ministries")					
replace franchise_id  = 114 if Go_Minis >= 1 & franchise_id == .
replace franchise_id2 = 114 if Go_Minis >= 1 & franchise_id != .
replace franchise_id3 = 114 if Go_Minis >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		    if Go_Minis >= 1
drop 	Go_Minis

gen 	Better_Homes = 		strpos(lower(employer), "better homes")
replace Better_Homes = 0 if strpos(employer, "Better Homes 4U Llc")				
replace Better_Homes = 0 if strpos(employer, "Better Homes Cabinets")			
replace Better_Homes = 0 if strpos(employer, "Better Homes Cabinets & Granite, Llc")			 
replace Better_Homes = 0 if strpos(employer, "Better Homes Of American Heritage Federal Realty") 
replace Better_Homes = 0 if strpos(employer, "Better Homes Property Management") 				 
replace Better_Homes = 0 if strpos(employer, "Better Homes Team")				
replace Better_Homes = 0 if strpos(employer, "West Coast Better Homes")			
replace Better_Homes = 0 if strpos(employer, "Better Homes Sale Inc")			
replace franchise_id  = 115 if Better_Homes >= 1 & franchise_id == .
replace franchise_id2 = 115 if Better_Homes >= 1 & franchise_id != .
replace franchise_id3 = 115 if Better_Homes >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Better_Homes >= 1
drop 	Better_Homes

gen 	BH_Home_Services = strpos(lower(employer), "berkshire hathaway home services")
replace franchise_id  = 116 if BH_Home_Services >= 1 & franchise_id == . 
replace franchise_id2 = 116 if BH_Home_Services >= 1 & franchise_id != .
replace franchise_id3 = 116 if BH_Home_Services >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if BH_Home_Services >= 1
drop 	BH_Home_Services

gen 	Century_21 = strpos(lower(employer), "century 21")
replace franchise_id  = 117 if Century_21 >= 1 & franchise_id == .
replace franchise_id2 = 117 if Century_21 >= 1 & franchise_id != .
replace franchise_id3 = 117 if Century_21 >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Century_21 >= 1
drop 	Century_21

gen 	Coldwell_Banker = strpos(lower(employer), "coldwell banker")
replace franchise_id  = 118 if Coldwell_Banker >= 1 & franchise_id == .
replace franchise_id2 = 118 if Coldwell_Banker >= 1 & franchise_id != .
replace franchise_id3 = 118 if Coldwell_Banker >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Coldwell_Banker >= 1
drop 	Coldwell_Banker

gen 	Era_Franchise = 	 strpos(lower(employer), "era franchise") | strpos(lower(employer), "era real estate")
replace Era_Franchise = 0 if strpos(employer, "Valera")
replace Era_Franchise = 0 if strpos(employer, "Aguilera Real Estate Team")		
replace Era_Franchise = 0 if strpos(employer, "Cervera Real Estate")			
replace Era_Franchise = 0 if strpos(employer, "Herrera Real Estate Group/Windermere") 
replace Era_Franchise = 0 if strpos(employer, "New Era Real Estate Investments") 
replace franchise_id  = 119 if Era_Franchise >= 1 & franchise_id == .
replace franchise_id2 = 119 if Era_Franchise >= 1 & franchise_id != .
replace franchise_id3 = 119 if Era_Franchise >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Era_Franchise >= 1
drop 	Era_Franchise 

gen 	Home_Smart = 	  strpos(lower(employer), "homesmart") | strpos(lower(employer), "home smart")
replace Home_Smart = 0 if strpos(employer, "Home Smart Tutoring")				
replace Home_Smart = 0 if strpos(employer, "Strotek Your Home Smarter Home Automation Solutions") 
replace Home_Smart = 0 if strpos(employer, "Home Smart Industries")				
replace Home_Smart = 0 if strpos(employer, "Homesmart Industries")				
replace Home_Smart = 0 if strpos(employer, "Homesmart Technologies Inc")		
replace franchise_id  = 120 if Home_Smart >= 1 & franchise_id == .
replace franchise_id2 = 120 if Home_Smart >= 1 & franchise_id != .
replace franchise_id3 = 120 if Home_Smart >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Home_Smart >= 1
drop 	Home_Smart

gen 	Homevestors = strpos(lower(employer), "homevestors") | strpos(lower(employer), "home vestors")
replace franchise_id  = 121 if Homevestors >= 1 & franchise_id == .
replace franchise_id2 = 121 if Homevestors >= 1 & franchise_id != .
replace franchise_id3 = 121 if Homevestors >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Homevestors >= 1
drop 	Homevestors

gen 	New_Point = 	 strpos(lower(employer), "newpoint") | strpos(lower(employer), "new point") | strpos(lower(employer), "homes & land") | strpos(lower(employer), "homes and land")
replace New_Point = 0 if strpos(employer, "New Point Behavioral Healthcare")	
replace New_Point = 0 if strpos(employer, "New Pointe Church")					
replace New_Point = 0 if strpos(employer, "New Pointroll")						
replace New_Point = 0 if strpos(employer, "Newpoint Advisors Corporation")		
replace New_Point = 0 if strpos(employer, "Newpoint Behavioral Health Care")	
replace New_Point = 0 if strpos(employer, "Newpoint Behavioral Heatlh Care")	
replace New_Point = 0 if strpos(employer, "Newpoint Gas Service")				
replace New_Point = 0 if strpos(employer, "Newpoint Healthcare Advisors")		
replace New_Point = 0 if strpos(employer, "Newpoint Lae Group, Llp")			
replace New_Point = 0 if strpos(employer, "Newpoint Law Group, Llp")			
replace New_Point = 0 if strpos(employer, "Newpoint Of View Counseling Pllc")	
replace New_Point = 0 if strpos(employer, "Newpoint Parking")					
replace New_Point = 0 if strpos(employer, "Newpoint Schools Panama City & Pensacola") 
replace New_Point = 0 if strpos(employer, "Newpoint Technologies Incorporated")	
replace New_Point = 0 if strpos(employer, "Newpointe Church")					
replace New_Point = 0 if strpos(employer, "Newpointe Community Church")			
replace New_Point = 0 if strpos(employer, "Newpoint Advisors")					
replace New_Point = 0 if strpos(employer, "Newpoint Management")				
replace New_Point = 0 if strpos(employer, "Newpoint Services")					
replace New_Point = 0 if strpos(employer, "Newpointdigital")					
replace New_Point = 0 if strpos(employer, "Newpointdigital")					
replace New_Point = 0 if strpos(employer, "Newpointdigital")					
replace New_Point = 0 if strpos(employer, "Newpointdigital")					
replace franchise_id  = 122 if New_Point >= 1 & franchise_id == .
replace franchise_id2 = 122 if New_Point >= 1 & franchise_id != .
replace franchise_id3 = 122 if New_Point >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if New_Point >= 1
drop 	New_Point 

gen 	Real_Living = strpos(lower(employer), "real living") | strpos(lower(employer), "realliving")
replace franchise_id  = 123 if Real_Living >= 1 & franchise_id == .
replace franchise_id2 = 123 if Real_Living >= 1 & franchise_id != .
replace franchise_id3 = 123 if Real_Living >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Real_Living >= 1
drop 	Real_Living

gen 	Realty_Executives = strpos(lower(employer), "realty exec")
replace franchise_id  = 124 if Realty_Executives >= 1 & franchise_id == .
replace franchise_id2 = 124 if Realty_Executives >= 1 & franchise_id != .
replace franchise_id3 = 124 if Realty_Executives >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Realty_Executives >= 1
drop 	Realty_Executives

gen 	Remax = 	 strpos(lower(employer), "remax") | strpos(lower(employer), "re/max") 
replace Remax = 0 if strpos(lower(employer), "caremax") | strpos(lower(employer), "coremax") | strpos(lower(employer), "waremax") | strpos(lower(employer), "insuremax") | strpos(lower(employer), "libremax") | strpos(lower(employer), "tiremax")
replace Remax = 0 if strpos(employer, "Biopuremax")								
replace Remax = 0 if strpos(employer, "Efurnituremax")							
replace Remax = 0 if strpos(employer, "Efurnituremax Com")						
replace Remax = 0 if strpos(employer, "Fixturemax")								
replace Remax = 0 if strpos(employer, "Furnituremaxx")							
replace Remax = 0 if strpos(employer, "Premax")									
replace Remax = 0 if strpos(employer, "Premax Llc")								
replace Remax = 0 if strpos(employer, "Storemaxx Inc")							
replace Remax = 0 if strpos(employer, "Venturemax, Llc")						
replace Remax = 0 if strpos(employer, "Xtremax Pte Ltd")						
replace franchise_id  = 125 if Remax >= 1 & franchise_id == .
replace franchise_id2 = 125 if Remax >= 1 & franchise_id != .
replace franchise_id3 = 125 if Remax >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Remax >= 1
drop 	Remax

gen 	Sothebys = strpos(lower(employer), "sotheb")
replace franchise_id  = 126 if Sothebys >= 1 & franchise_id == .
replace franchise_id2 = 126 if Sothebys >= 1 & franchise_id != .
replace franchise_id3 = 126 if Sothebys >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Sothebys >= 1
drop 	Sothebys

gen 	Sperry_Van_Ness = strpos(lower(employer), "sperry van")
replace franchise_id  = 127 if Sperry_Van_Ness >= 1 & franchise_id == .
replace franchise_id2 = 127 if Sperry_Van_Ness >= 1 & franchise_id != .
replace franchise_id3 = 127 if Sperry_Van_Ness >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Sperry_Van_Ness >= 1
drop 	Sperry_Van_Ness   

gen 	United_Country = strpos(lower(employer), "united country")
replace franchise_id  = 128 if United_Country >= 1 & franchise_id == .
replace franchise_id2 = 128 if United_Country >= 1 & franchise_id != .
replace franchise_id3 = 128 if United_Country >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if United_Country >= 1
drop 	United_Country

gen 	Weichert = strpos(lower(employer), "weichert")
replace franchise_id  = 129 if Weichert >= 1 & franchise_id == .
replace franchise_id2 = 129 if Weichert >= 1 & franchise_id != .
replace franchise_id3 = 129 if Weichert >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Weichert >= 1
drop 	Weichert

gen 	Property_Damage_App = strpos(lower(employer), "property damage app") | strpos(lower(employer), "property damageapp")
replace franchise_id  = 130 if Property_Damage_App >= 1 & franchise_id == .
replace franchise_id2 = 130 if Property_Damage_App >= 1 & franchise_id != .
replace franchise_id3 = 130 if Property_Damage_App >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Property_Damage_App >= 1
drop 	Property_Damage_App

gen 	Avis_Car = 		strpos(lower(employer), "avis") & (strpos(lower(employer), "rent") | strpos(lower(employer), "car"))
replace Avis_Car = 0 if strpos(employer, "Davis Car Care And Tire Center")		
replace Avis_Car = 0 if strpos(employer, "Davis Carpentry")						
replace Avis_Car = 0 if strpos(employer, "Davis Cartage Company")				
replace Avis_Car = 0 if strpos(employer, "Davis Carter")						
replace Avis_Car = 0 if strpos(employer, "Austin Travis County")				
replace Avis_Car = 0 if strpos(employer, "Austintravis County")					
replace Avis_Car = 0 if strpos(employer, "Care Altavista")						
replace Avis_Car = 0 if strpos(employer, "Avista")								
replace Avis_Car = 0 if strpos(employer, "Brent Davis")							
replace Avis_Car = 0 if strpos(employer, "Buenavista Care")						
replace Avis_Car = 0 if strpos(employer, "Davis")								
replace Avis_Car = 0 if strpos(employer, "Avista")								
replace Avis_Car = 0 if strpos(employer, "Bellavista")							
replace Avis_Car = 0 if strpos(employer, "Katy Lavish")							
replace Avis_Car = 0 if strpos(employer, "Lake Travis Eye Care")				
replace Avis_Car = 0 if strpos(employer, "Lavish Event Rentals")				
replace Avis_Car = 0 if strpos(employer, "Letavis Enterprises/Fast Eddie's Car Wash") 
replace Avis_Car = 0 if strpos(employer, "Mavis Home Care")						
replace Avis_Car = 0 if strpos(employer, "Reavis Parent")						
replace Avis_Car = 0 if strpos(employer, "Rentavision")							
replace Avis_Car = 0 if strpos(employer, "Travis County Healthcare")			
replace Avis_Car = 0 if strpos(employer, "Travis Curry's Lawn Care Service")	
replace Avis_Car = 0 if strpos(employer, "Travis' Care Team")					
replace franchise_id  = 131 if Avis_Car >= 1 & franchise_id == .
replace franchise_id2 = 131 if Avis_Car >= 1 & franchise_id != .
replace franchise_id3 = 131 if Avis_Car >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Avis_Car >= 1
drop 	Avis_Car

gen 	Budget_Car_Rental = 	 strpos(lower(employer), "budget car") | strpos(lower(employer), "budget rent") 
replace Budget_Car_Rental = 0 if strpos(employer, "Budget Carmart")				
replace Budget_Car_Rental = 0 if strpos(employer, "Budget Carpet Cleaners")		
replace Budget_Car_Rental = 0 if strpos(employer, "Budget Carpet Flooring")		
replace Budget_Car_Rental = 0 if strpos(employer, "Budget Car Mart") 			
replace Budget_Car_Rental = 0 if strpos(employer, "Can Doo Budget Rentals") 	
replace Budget_Car_Rental = 0 if strpos(employer, "M O A L Llc For Budget Rentals") 
replace franchise_id  = 132 if Budget_Car_Rental >= 1 & franchise_id == .
replace franchise_id2 = 132 if Budget_Car_Rental >= 1 & franchise_id != .
replace franchise_id3 = 132 if Budget_Car_Rental >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Budget_Car_Rental >= 1 & franchise_id == .
drop 	Budget_Car_Rental  

gen 	Dollar_Rent = 	   strpos(lower(employer), "dollar rent")
replace Dollar_Rent = 0 if strpos(employer, "Sand Dollar Rentals, Llp")			
replace franchise_id  = 133 if Dollar_Rent >= 1 & franchise_id == .
replace franchise_id2 = 133 if Dollar_Rent >= 1 & franchise_id != .
replace franchise_id3 = 133 if Dollar_Rent >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 		    if Dollar_Rent >= 1
drop 	Dollar_Rent

gen 	Hertz = 	 strpos(lower(employer), "hertz") 
replace Hertz = 0 if strpos(employer, "Schertz")								
replace Hertz = 0 if strpos(employer, "Hertzberg")								
replace Hertz = 0 if strpos(employer, "Employerschertz")						
replace Hertz = 0 if strpos(employer, "Doug Hertzog Insurance")					
replace Hertz = 0 if strpos(employer, "Frischhertz")							
replace Hertz = 0 if strpos(employer, "Hertzbach")								
replace Hertz = 0 if strpos(employer, "Hertzberg")								
replace Hertz = 0 if strpos(employer, "Hertzcor29")								
replace Hertz = 0 if strpos(employer, "Hertzenberg And Sons Painting")			
replace Hertz = 0 if strpos(employer, "Hertzfeld")								
replace Hertz = 0 if strpos(employer, "Hertzler")								
replace Hertz = 0 if strpos(employer, "Hertzman")								
replace Hertz = 0 if strpos(employer, "Hertzmn")								
replace Hertz = 0 if strpos(employer, "Hertzog")								
replace Hertz = 0 if strpos(employer, "Hertzberg")								
replace Hertz = 0 if strpos(employer, "Hertzsager")								
replace Hertz = 0 if strpos(employer, "Kennyhertz Perry, Llc")					
replace Hertz = 0 if strpos(employer, "Hertzmark")								
replace Hertz = 0 if strpos(employer, "Leewayhertz")							
replace Hertz = 0 if strpos(employer, "Megahertz Avionics")						
replace Hertz = 0 if strpos(employer, "Nethertz")								
replace Hertz = 0 if strpos(employer, "Hertzel")								
replace Hertz = 0 if strpos(employer, "Hertz Investment Group")					
replace Hertz = 0 if strpos(employer, "Terahertz")								
replace franchise_id  = 134 if Hertz >= 1 & franchise_id == .
replace franchise_id2 = 134 if Hertz >= 1 & franchise_id != .
replace franchise_id3 = 134 if Hertz >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Hertz >= 1
drop 	Hertz

gen 	Paccar = strpos(lower(employer), "paccar") | strpos(lower(employer), "paclease") | strpos(lower(employer), "pac lease")
replace Paccar = 0 if strpos(employer, "Nicholas Spaccarelli") 					
replace franchise_id  = 135 if Paccar >= 1 & franchise_id == .
replace franchise_id2 = 135 if Paccar >= 1 & franchise_id != .
replace franchise_id3 = 135 if Paccar >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Paccar >= 1
drop 	Paccar

gen 	Payless_Car_Rental = strpos(lower(employer), "payless car")	
replace franchise_id  = 136 if Payless_Car_Rental >= 1 & franchise_id == .
replace franchise_id2 = 136 if Payless_Car_Rental >= 1 & franchise_id != .
replace franchise_id3 = 136 if Payless_Car_Rental >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Payless_Car_Rental >= 1 & franchise_id == .
drop 	Payless_Car_Rental   

gen 	Rent_Wreck = strpos(lower(employer), "rent wreck") | strpos(lower(employer), "rent a wreck") | 	strpos(lower(employer), "bundy american")
replace franchise_id  = 137 if Rent_Wreck >= 1 & franchise_id == .
replace franchise_id2 = 137 if Rent_Wreck >= 1 & franchise_id != .
replace franchise_id3 = 137 if Rent_Wreck >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Rent_Wreck >= 1
drop 	Rent_Wreck 

gen 	Thrifty_Rent = strpos(lower(employer), "thrifty rent") | strpos(lower(employer), "thrifty car rent")
replace franchise_id  = 138 if Thrifty_Rent >= 1 & franchise_id == .
replace franchise_id2 = 138 if Thrifty_Rent >= 1 & franchise_id != .
replace franchise_id3 = 138 if Thrifty_Rent >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer			if Thrifty_Rent >= 1
drop 	Thrifty_Rent

gen 	True_Value = strpos(lower(employer), "true value") 
replace True_Value = 0 if strpos(lower(employer), "solutions") | strpos(lower(employer), "appraisal")
replace franchise_id  = 139 if True_Value >= 1 & franchise_id == .
replace franchise_id2 = 139 if True_Value >= 1 & franchise_id != .
replace franchise_id3 = 139 if True_Value >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if True_Value >= 1
drop 	True_Value 

gen 	HandR_Block = strpos(lower(employer), "hr block") | strpos(lower(employer), "h&r block") | strpos(lower(employer), "handr block") | ///
					  strpos(lower(employer), "h and r block") | strpos(lower(employer), "h & r block") 
replace franchise_id  = 140 if HandR_Block >= 1 & franchise_id == .
replace franchise_id2 = 140 if HandR_Block >= 1 & franchise_id != .
replace franchise_id3 = 140 if HandR_Block >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if HandR_Block >= 1
drop 	HandR_Block  

gen 	Jackson_Hewitt = strpos(lower(employer), "jacksonhew") | strpos(lower(employer), "jackson hew")
replace franchise_id  = 141 if Jackson_Hewitt >= 1 & franchise_id == .
replace franchise_id2 = 141 if Jackson_Hewitt >= 1 & franchise_id != .
replace franchise_id3 = 141 if Jackson_Hewitt >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Jackson_Hewitt >= 1
drop 	Jackson_Hewitt

gen 	Liberty_Tax = 	   strpos(lower(employer), "libertytax") | strpos(lower(employer), "liberty tax")
replace Liberty_Tax = 0 if strpos(employer, "Liberty Taxi")						
replace franchise_id  = 142 if Liberty_Tax >= 1 & franchise_id == .
replace franchise_id2 = 142 if Liberty_Tax >= 1 & franchise_id != .
replace franchise_id3 = 142 if Liberty_Tax >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Liberty_Tax >= 1
drop 	Liberty_Tax 

gen 	Siempre_Tax = strpos(lower(employer), "siempre tax") | strpos(lower(employer), "siempretax")
replace franchise_id  = 143 if Siempre_Tax >= 1 & franchise_id == .
replace franchise_id2 = 143 if Siempre_Tax >= 1 & franchise_id != .
replace franchise_id3 = 143 if Siempre_Tax >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Siempre_Tax >= 1
drop 	Siempre_Tax

gen 	Amerispec = strpos(lower(employer), "amerispec")
replace franchise_id  = 144 if Amerispec >= 1 & franchise_id == .
replace franchise_id2 = 144 if Amerispec >= 1 & franchise_id != .
replace franchise_id3 = 144 if Amerispec >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Amerispec >= 1
drop 	Amerispec 

gen 	Hometeam_Inspection = strpos(lower(employer), "hometeam inspec") | strpos(lower(employer), "home team inspec")
replace franchise_id  = 145 if Hometeam_Inspection >= 1 & franchise_id == .
replace franchise_id2 = 145 if Hometeam_Inspection >= 1 & franchise_id != .
replace franchise_id3 = 145 if Hometeam_Inspection >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Hometeam_Inspection >= 1
drop 	Hometeam_Inspection

gen 	Housemaster = 	   strpos(lower(employer), "housemaster") | strpos(lower(employer), "house master")
replace Housemaster = 0 if strpos(employer, "House Masters Property Services Llc") 
replace Housemaster = 0 if strpos(employer, "Marketing Powerhouse Mastermind") 	   
replace franchise_id  = 146 if Housemaster >= 1 & franchise_id == .
replace franchise_id2 = 146 if Housemaster >= 1 & franchise_id != .
replace franchise_id3 = 146 if Housemaster >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Housemaster >= 1
drop 	Housemaster

gen 	Inspect_It_1st = strpos(lower(employer), "inspect it 1st")
replace franchise_id  = 147 if Inspect_It_1st >= 1 & franchise_id == .
replace franchise_id2 = 147 if Inspect_It_1st >= 1 & franchise_id != .
replace franchise_id3 = 147 if Inspect_It_1st >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Inspect_It_1st >= 1
drop 	Inspect_It_1st 

gen 	National_Property_Inspectors = strpos(lower(employer), "national property inspect")
replace franchise_id  = 148 if National_Property_Inspectors >= 1 & franchise_id == .
replace franchise_id2 = 148 if National_Property_Inspectors >= 1 & franchise_id != .
replace franchise_id3 = 148 if National_Property_Inspectors >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if National_Property_Inspectors >= 1
drop 	National_Property_Inspectors 

gen 	World_Inspection = strpos(lower(employer), "world inspection")
replace franchise_id  = 149 if World_Inspection >= 1 & franchise_id == .
replace franchise_id2 = 149 if World_Inspection >= 1 & franchise_id != .
replace franchise_id3 = 149 if World_Inspection >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if World_Inspection >= 1
drop 	World_Inspection

gen 	Decorating_Den = strpos(lower(employer), "decorating den")
replace franchise_id  = 150 if Decorating_Den >= 1 & franchise_id == .
replace franchise_id2 = 150 if Decorating_Den >= 1 & franchise_id != .
replace franchise_id3 = 150 if Decorating_Den >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Decorating_Den >= 1
drop 	Decorating_Den

gen 	Cmit_Solutions = strpos(lower(employer), "cmit sol")
replace franchise_id  = 151 if Cmit_Solutions >= 1 & franchise_id == .
replace franchise_id2 = 151 if Cmit_Solutions >= 1 & franchise_id != .
replace franchise_id3 = 151 if Cmit_Solutions >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Cmit_Solutions >= 1
drop 	Cmit_Solutions

gen 	Computer_Troubleshooters = 		strpos(lower(employer), "computer troub")
replace Computer_Troubleshooters = 0 if strpos(employer, "Computer Trouble Solutions") 
replace franchise_id  = 152 if Computer_Troubleshooters >= 1 & franchise_id == .
replace franchise_id2 = 152 if Computer_Troubleshooters >= 1 & franchise_id != .
replace franchise_id3 = 152 if Computer_Troubleshooters >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Computer_Troubleshooters >= 1
drop 	Computer_Troubleshooters 

gen 	Actioncoach = strpos(lower(employer), "actioncoach") | strpos(lower(employer), "action coach") 
replace franchise_id  = 153 if Actioncoach >= 1 & franchise_id == .
replace franchise_id2 = 153 if Actioncoach >= 1 & franchise_id != .
replace franchise_id3 = 153 if Actioncoach >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Actioncoach >= 1
drop 	Actioncoach

gen 	BNI = lower(employer)=="bni"
replace franchise_id  = 154 if BNI >= 1 & franchise_id == .
replace franchise_id2 = 154 if BNI >= 1 & franchise_id != .
replace franchise_id3 = 154 if BNI >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if BNI >= 1
drop 	BNI

gen 	Dale_Carnegie = strpos(lower(employer), "dale carneg") | strpos(lower(employer), "dalecarneg")
replace franchise_id  = 155 if Dale_Carnegie >= 1 & franchise_id == .
replace franchise_id2 = 155 if Dale_Carnegie >= 1 & franchise_id != .
replace franchise_id3 = 155 if Dale_Carnegie >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Dale_Carnegie >= 1
drop 	Dale_Carnegie

gen 	Entrepreneurs_Source = strpos(lower(employer), "entrepreneurs source") | strpos(lower(employer), "entrepreneur source") | strpos(lower(employer), "entrepreneur's source")
replace franchise_id  = 156 if Entrepreneurs_Source >= 1 & franchise_id == .
replace franchise_id2 = 156 if Entrepreneurs_Source >= 1 & franchise_id != .
replace franchise_id3 = 156 if Entrepreneurs_Source >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Entrepreneurs_Source >= 1
drop 	Entrepreneurs_Source 

gen 	Expense_Reduction = 	 strpos(lower(employer), "expense reduction")	
replace Expense_Reduction = 0 if strpos(employer, "Expense Reduction Service") 	
replace Expense_Reduction = 0 if strpos(employer, "Utility Expense Reduction Llc") 
replace franchise_id  = 157 if Expense_Reduction >= 1 & franchise_id == .
replace franchise_id2 = 157 if Expense_Reduction >= 1 & franchise_id != .
replace franchise_id3 = 157 if Expense_Reduction >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Expense_Reduction >= 1
drop 	Expense_Reduction 

gen 	Focalpoint = strpos(lower(employer), "focalpoint business coach") | strpos(lower(employer), "focal point business coach") | strpos(lower(employer), "focalpoint coach") | strpos(lower(employer), "focal point coach")
replace franchise_id  = 158 if Focalpoint >= 1 & franchise_id == .
replace franchise_id2 = 158 if Focalpoint >= 1 & franchise_id != .
replace franchise_id3 = 158 if Focalpoint >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Focalpoint >= 1
drop 	Focalpoint 

gen 	Leadership_Management = 	 strpos(lower(employer), "leadership management")
replace Leadership_Management = 0 if strpos(employer, "American Israel Leadership Management Director") 
replace franchise_id  = 159 if Leadership_Management >= 1 & franchise_id == .
replace franchise_id2 = 159 if Leadership_Management >= 1 & franchise_id != .
replace franchise_id3 = 159 if Leadership_Management >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Leadership_Management >= 1
drop 	Leadership_Management 

gen 	Tab_Boards = strpos(lower(employer), "tab board") | strpos(lower(employer), "the alternative board")
replace franchise_id  = 160 if Tab_Boards >= 1 & franchise_id == .
replace franchise_id2 = 160 if Tab_Boards >= 1 & franchise_id != .
replace franchise_id3 = 160 if Tab_Boards >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Tab_Boards >= 1
drop 	Tab_Boards

gen 	Transworld_Business_Advisors = strpos(lower(employer), "transworld business adv") | strpos(lower(employer), "transworldbusinessadv")
replace franchise_id  = 161 if Transworld_Business_Advisors >= 1 & franchise_id == .
replace franchise_id2 = 161 if Transworld_Business_Advisors >= 1 & franchise_id != .
replace franchise_id3 = 161 if Transworld_Business_Advisors >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Transworld_Business_Advisors >= 1
drop 	Transworld_Business_Advisors

gen 	Murphy_Financial = strpos(lower(employer), "murphy financial") | strpos(lower(employer), "murphy business")
replace franchise_id  = 162 if Murphy_Financial >= 1 & franchise_id == .
replace franchise_id2 = 162 if Murphy_Financial >= 1 & franchise_id != .
replace franchise_id3 = 162 if Murphy_Financial >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Murphy_Financial >= 1
drop 	Murphy_Financial

gen 	Adventures_In_Advertising = strpos(lower(employer), "adventures in adv") 
replace franchise_id  = 163 if Adventures_In_Advertising >= 1 & franchise_id == .
replace franchise_id2 = 163 if Adventures_In_Advertising >= 1 & franchise_id != .
replace franchise_id3 = 163 if Adventures_In_Advertising >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Adventures_In_Advertising >= 1
drop 	Adventures_In_Advertising

gen 	WSI_digital_marketing = strpos(lower(employer), "wsi digital") | strpos(employer, "WSI")
replace franchise_id  = 164 if WSI_digital_marketing >= 1 & franchise_id == .
replace franchise_id2 = 164 if WSI_digital_marketing >= 1 & franchise_id != .
replace franchise_id3 = 164 if WSI_digital_marketing >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if WSI_digital_marketing >= 1
drop 	WSI_digital_marketing

gen 	Discovery_Map = strpos(lower(employer), "discovery map") | strpos(lower(employer), "discoverymap")
replace franchise_id  = 165 if Discovery_Map >= 1 & franchise_id == .
replace franchise_id2 = 165 if Discovery_Map >= 1 & franchise_id != .
replace franchise_id3 = 165 if Discovery_Map >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Discovery_Map >= 1
drop 	Discovery_Map

gen 	Money_Mailer = strpos(lower(employer), "money mailer")
replace franchise_id  = 166 if Money_Mailer >= 1 & franchise_id == .
replace franchise_id2 = 166 if Money_Mailer >= 1 & franchise_id != .
replace franchise_id3 = 166 if Money_Mailer >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Money_Mailer >= 1
drop 	Money_Mailer

gen 	Tap_Snap = strpos(lower(employer), "tap snap") | strpos(lower(employer), "tapsnap")
replace franchise_id  = 167 if Tap_Snap >= 1 & franchise_id == .
replace franchise_id2 = 167 if Tap_Snap >= 1 & franchise_id != .
replace franchise_id3 = 167 if Tap_Snap >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Tap_Snap >= 1
drop 	Tap_Snap

gen 	TSS_Photography = strpos(lower(employer), "tss photo") | strpos(lower(employer), "tssphoto") 
replace franchise_id  = 168 if TSS_Photography >= 1 & franchise_id == .
replace franchise_id2 = 168 if TSS_Photography >= 1 & franchise_id != .
replace franchise_id3 = 168 if TSS_Photography >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if TSS_Photography >= 1
drop 	TSS_Photography 

gen 	SCA_Appraisal = strpos(lower(employer), "sca appraisal") | strpos(lower(employer), "scaappraisal") | strpos(lower(employer), "sca franch") 
replace franchise_id  = 169 if SCA_Appraisal >= 1 & franchise_id == .
replace franchise_id2 = 169 if SCA_Appraisal >= 1 & franchise_id != .
replace franchise_id3 = 169 if SCA_Appraisal >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if SCA_Appraisal >= 1
drop 	SCA_Appraisal

gen 	Global_Recruiters = 	 strpos(lower(employer), "global recruiter") | strpos(lower(employer), "globalrecruiter") | strpos(lower(employer), "grn ")
replace Global_Recruiters = 0 if strpos(employer, "Grn Enterprises Incorporated") 
replace franchise_id  = 170 if Global_Recruiters >= 1 & franchise_id == .
replace franchise_id2 = 170 if Global_Recruiters >= 1 & franchise_id != .
replace franchise_id3 = 170 if Global_Recruiters >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Global_Recruiters >= 1
drop 	Global_Recruiters

gen 	Management_Recruiters = 	 strpos(lower(employer), "management recruit") | strpos(employer, "Mri ") | strpos(employer, "MRI ")
replace Management_Recruiters = 0 if strpos(lower(employer), "diagnostic") | strpos(lower(employer), "radiation") | strpos(lower(employer), "radiology") 
replace Management_Recruiters = 0 if strpos(lower(employer), "imaging")    | strpos(lower(employer), "oncology")  | strpos(lower(employer), "medical") 	 
replace Management_Recruiters = 0 if strpos(lower(employer), "neurology")  | strpos(lower(employer), "animal")    | strpos(lower(employer), "doctor") 	 
replace Management_Recruiters = 0 if strpos(lower(employer), "pet")  	   | strpos(lower(employer), "physician") | strpos(lower(employer), "trucking")  
replace Management_Recruiters = 0 if strpos(employer, "Upright Mri") 			
replace Management_Recruiters = 0 if strpos(employer, "Stand Up Mri") 			
replace Management_Recruiters = 0 if strpos(employer, "Opensided Mri") 			
replace Management_Recruiters = 0 if strpos(employer, "Open Mri") 				
replace Management_Recruiters = 0 if strpos(employer, "Mri Tech") 				
replace Management_Recruiters = 0 if strpos(employer, "A1 Mri Of Tulsa") 		
replace Management_Recruiters = 0 if strpos(employer, "Alliance Mri") 			
replace Management_Recruiters = 0 if strpos(employer, "Beaches Mri") 			
replace Management_Recruiters = 0 if strpos(employer, "Bensonhurst Mri") 		
replace Management_Recruiters = 0 if strpos(employer, "Busy Mri Office") 		
replace Management_Recruiters = 0 if strpos(employer, "Comprehensive Mri") 		
replace Management_Recruiters = 0 if strpos(employer, "Delray Mri Associates") 	
replace Management_Recruiters = 0 if strpos(employer, "Elite Mri Of Laurens") 	
replace Management_Recruiters = 0 if strpos(employer, "Mri Center") 			
replace Management_Recruiters = 0 if strpos(employer, "Foot Ankle And Knee") 	
replace Management_Recruiters = 0 if strpos(employer, "Franklin Mri Llc") 		
replace Management_Recruiters = 0 if strpos(employer, "Glendale Mri Institute") 
replace Management_Recruiters = 0 if strpos(employer, "Hd Mri Of Orlando") 		
replace Management_Recruiters = 0 if strpos(employer, "Mri Consulting Group") 	
replace Management_Recruiters = 0 if strpos(employer, "Mri Consultants") 		
replace Management_Recruiters = 0 if strpos(employer, "Mri Columbus Group") 	
replace Management_Recruiters = 0 if strpos(employer, "Mri Flexible") 			
replace Management_Recruiters = 0 if strpos(employer, "Mri Hotels") 			
replace Management_Recruiters = 0 if strpos(employer, "Mri Institute") 			
replace Management_Recruiters = 0 if strpos(employer, "Mri Management") 		
replace Management_Recruiters = 0 if strpos(employer, "Mri Manufacturing Research") 		   
replace Management_Recruiters = 0 if strpos(employer, "Mri Mobile") 			
replace Management_Recruiters = 0 if strpos(employer, "Mri Associates") 		
replace Management_Recruiters = 0 if strpos(employer, "Manufacturing Resources International") 
replace Management_Recruiters = 0 if strpos(employer, "Mri Optimize Consultants") 			   
replace Management_Recruiters = 0 if strpos(employer, "Mri Express Llc") 		
replace Management_Recruiters = 0 if strpos(employer, "Mri Edison") 			
replace Management_Recruiters = 0 if strpos(employer, "Mri Arizona") 			
replace Management_Recruiters = 0 if strpos(employer, "Mri Arkansas") 			
replace Management_Recruiters = 0 if strpos(employer, "Mri Atlanta Downtown") 	
replace Management_Recruiters = 0 if strpos(employer, "Mri Chantilly") 			
replace Management_Recruiters = 0 if strpos(employer, "Mri Clearwater") 		
replace Management_Recruiters = 0 if strpos(employer, "Mri Colorado") 			
replace Management_Recruiters = 0 if strpos(employer, "Mri Corporation") 		
replace Management_Recruiters = 0 if strpos(employer, "Mri Corporate") 			
replace Management_Recruiters = 0 if strpos(employer, "Mri Cromwell Group") 	
replace Management_Recruiters = 0 if strpos(employer, "Mri Dallas Parkway") 	
replace Management_Recruiters = 0 if strpos(employer, "Mri Delta") 				
replace Management_Recruiters = 0 if strpos(employer, "Mri Eagle Mountain") 	
replace Management_Recruiters = 0 if strpos(employer, "Mri East Hempfield") 	
replace Management_Recruiters = 0 if strpos(employer, "Mri Jackson") 			
replace Management_Recruiters = 0 if strpos(employer, "Mri Lake Forest") 		
replace Management_Recruiters = 0 if strpos(employer, "Mri Las Vegas") 			
replace Management_Recruiters = 0 if strpos(employer, "Mri Melbourne Ic") 		
replace Management_Recruiters = 0 if strpos(employer, "Mri Motorsports Llc") 	
replace Management_Recruiters = 0 if strpos(employer, "Mri Mri Of Fayetteville") 
replace Management_Recruiters = 0 if strpos(employer, "Mri Mr Of Madeira") 		
replace Management_Recruiters = 0 if strpos(employer, "Mri New Orleans") 		
replace Management_Recruiters = 0 if strpos(employer, "Mri Of Camdenton") 		
replace Management_Recruiters = 0 if strpos(employer, "Mri Of Chico") 			
replace Management_Recruiters = 0 if strpos(employer, "Mri Of Colorado") 		
replace Management_Recruiters = 0 if strpos(employer, "Mri Of Dallas Parkway") 	
replace Management_Recruiters = 0 if strpos(employer, "Mri Of Fort Worth") 		
replace Management_Recruiters = 0 if strpos(employer, "Mri Of Indianapolis") 	
replace Management_Recruiters = 0 if strpos(employer, "Mri Of Las Vegas") 		
replace Management_Recruiters = 0 if strpos(employer, "Mri Of Melbourne") 		
replace Management_Recruiters = 0 if strpos(employer, "Mri Of New Orleans") 	
replace Management_Recruiters = 0 if strpos(employer, "Mri Of Ocean") 			
replace Management_Recruiters = 0 if strpos(employer, "Mri Of Providence") 		
replace Management_Recruiters = 0 if strpos(employer, "Mri Of River North") 	
replace Management_Recruiters = 0 if strpos(employer, "Mri Of Rover North") 	
replace Management_Recruiters = 0 if strpos(employer, "Mri Of Sacramento") 		
replace Management_Recruiters = 0 if strpos(employer, "Mri Of Salt Lake City") 	
replace Management_Recruiters = 0 if strpos(employer, "Mri Of Sioux Falls") 	
replace Management_Recruiters = 0 if strpos(employer, "Mri Of Utah County") 	
replace Management_Recruiters = 0 if strpos(employer, "Mri Of West Morris") 	
replace Management_Recruiters = 0 if strpos(employer, "Mri Of Winona") 			
replace Management_Recruiters = 0 if strpos(employer, "Mri Orange County Ny") 	
replace Management_Recruiters = 0 if strpos(employer, "Mri Online") 			
replace Management_Recruiters = 0 if strpos(employer, "Mri Paso") 				
replace Management_Recruiters = 0 if strpos(employer, "Mri Pluss Inc") 			
replace Management_Recruiters = 0 if strpos(employer, "Mri Portland") 			
replace Management_Recruiters = 0 if strpos(employer, "Mri Power") 				
replace Management_Recruiters = 0 if strpos(employer, "Mri Racine") 			
replace Management_Recruiters = 0 if strpos(employer, "Mri Rancho Santa Margarita") 
replace Management_Recruiters = 0 if strpos(employer, "Mri Receptionist") 		
replace Management_Recruiters = 0 if strpos(employer, "Mri Research") 			
replace Management_Recruiters = 0 if strpos(employer, "Mri Reston") 			
replace Management_Recruiters = 0 if strpos(employer, "Mri Rtp") 				
replace Management_Recruiters = 0 if strpos(employer, "Mri Sales Consultant") 	
replace Management_Recruiters = 0 if strpos(employer, "Mri Sc Phx N") 			
replace Management_Recruiters = 0 if strpos(employer, "Mri Scan Center") 		
replace Management_Recruiters = 0 if strpos(employer, "Mri Scsa") 				
replace Management_Recruiters = 0 if strpos(employer, "Mri Software") 			
replace Management_Recruiters = 0 if strpos(employer, "Mri St Charles") 		
replace Management_Recruiters = 0 if strpos(employer, "Mri Steel Framing Llc") 	
replace Management_Recruiters = 0 if strpos(employer, "Mri Sussex") 			
replace Management_Recruiters = 0 if strpos(employer, "Mri Tallahassee") 		
replace Management_Recruiters = 0 if strpos(employer, "Mri Tian's Company") 	
replace Management_Recruiters = 0 if strpos(employer, "Mri Ultimate Placements, Llc") 
replace Management_Recruiters = 0 if strpos(employer, "Mri Global") 			
replace Management_Recruiters = 0 if strpos(employer, "Mri Ventures") 			
replace Management_Recruiters = 0 if strpos(employer, "Mri Winston Salem") 		
replace Management_Recruiters = 0 if strpos(employer, "Mri Woodbridge") 		
replace Management_Recruiters = 0 if strpos(employer, "Mri Woodbury") 			
replace Management_Recruiters = 0 if strpos(employer, "Mric The Mri Group") 	
replace Management_Recruiters = 0 if strpos(employer, "Mri Portland") 			
replace Management_Recruiters = 0 if strpos(employer, "Mri Portland") 			
replace Management_Recruiters = 0 if strpos(employer, "Open Advanced Mri") 		
replace Management_Recruiters = 0 if strpos(employer, "Open Air Mri") 			
replace Management_Recruiters = 0 if strpos(employer, "Open Advanced Mri") 		
replace Management_Recruiters = 0 if strpos(employer, "Opensided") 				
replace Management_Recruiters = 0 if strpos(employer, "Precise Mri Corp") 		
replace Management_Recruiters = 0 if strpos(employer, "Preferred Mri") 			
replace Management_Recruiters = 0 if strpos(employer, "Premier Mri") 			
replace Management_Recruiters = 0 if strpos(employer, "Pro Mri Llc") 			
replace Management_Recruiters = 0 if strpos(employer, "San Juan Mri & Ct") 		
replace Management_Recruiters = 0 if strpos(employer, "Signature Mri Sales") 	
replace Management_Recruiters = 0 if strpos(employer, "Sina Mri") 				
replace Management_Recruiters = 0 if strpos(employer, "Smart Choice Mri Llc") 	
replace Management_Recruiters = 0 if strpos(employer, "Star Mri Of Wayne") 		
replace Management_Recruiters = 0 if strpos(employer, "Smart Choice Mri Llc") 	
replace Management_Recruiters = 0 if strpos(employer, "Staten Partners Mri") 	
replace Management_Recruiters = 0 if strpos(employer, "Texas Mri Of Houston") 	
replace Management_Recruiters = 0 if strpos(employer, "Vertical Plus Mri") 		
replace Management_Recruiters = 0 if strpos(employer, "Western New York Mri Llp") 
replace franchise_id  = 171 if Management_Recruiters >= 1 & franchise_id == .
replace franchise_id2 = 171 if Management_Recruiters >= 1 & franchise_id != .
replace franchise_id3 = 171 if Management_Recruiters >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer			if Management_Recruiters >= 1
drop 	Management_Recruiters

gen 	College_Nannies = strpos(lower(employer), "college nanni") | strpos(lower(employer), "collegen nanni")
replace franchise_id  = 172 if College_Nannies >= 1 & franchise_id == .
replace franchise_id2 = 172 if College_Nannies >= 1 & franchise_id != .
replace franchise_id3 = 172 if College_Nannies >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if College_Nannies >= 1
drop 	College_Nannies


gen 	Express_Services = 		strpos(lower(employer), "express services") | strpos(lower(employer), "express pros") | strpos(lower(employer), "express employment professionals")
replace Express_Services = 0 if strpos(employer, "24 Hr Express Services")		 
replace Express_Services = 0 if strpos(employer, "Amazing Courier Express Services") 
replace Express_Services = 0 if strpos(employer, "Az Express Services")		 	
replace Express_Services = 0 if strpos(employer, "Beaver Express Services")		
replace Express_Services = 0 if strpos(employer, "Benefit Express Services")	
replace Express_Services = 0 if strpos(employer, "Boost Mobile By Express Services") 
replace Express_Services = 0 if strpos(employer, "Certified Express Services, Llc")	 
replace Express_Services = 0 if strpos(employer, "D & G Express Services")		
replace Express_Services = 0 if strpos(employer, "Elaine Nichele Express")		
replace Express_Services = 0 if strpos(employer, "Es Express Services")			
replace Express_Services = 0 if strpos(employer, "Express Pros Heating Cooling")	 
replace Express_Services = 0 if strpos(employer, "Globe Express")				
replace Express_Services = 0 if strpos(employer, "Harbor Express Services")		
replace Express_Services = 0 if strpos(employer, "It Express Services")			
replace Express_Services = 0 if strpos(employer, "Jackson Express Services")	
replace Express_Services = 0 if strpos(employer, "Kernz Group")					
replace Express_Services = 0 if strpos(employer, "L&L Express Services")		
replace Express_Services = 0 if strpos(employer, "M & M Express Services")		
replace Express_Services = 0 if strpos(employer, "Med Line Express Services")	
replace Express_Services = 0 if strpos(employer, "Med Line Express Services")	
replace Express_Services = 0 if strpos(employer, "Metroexpress Services")		
replace Express_Services = 0 if strpos(employer, "Meza's Express")				
replace Express_Services = 0 if strpos(employer, "Morris Express")				
replace Express_Services = 0 if strpos(employer, "Orient Express")				
replace Express_Services = 0 if strpos(employer, "Roadside Express")			
replace Express_Services = 0 if strpos(employer, "Star Express")				
replace Express_Services = 0 if strpos(employer, "Supreme Express")				
replace Express_Services = 0 if strpos(employer, "Title Express")				
replace Express_Services = 0 if strpos(employer, "Total Express")				
replace franchise_id  = 173 if Express_Services >= 1 & franchise_id == .
replace franchise_id2 = 173 if Express_Services >= 1 & franchise_id != .
replace franchise_id3 = 173 if Express_Services >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Express_Services >= 1
drop 	Express_Services 

gen 	Interim_Health = strpos(lower(employer), "interim health")
replace franchise_id  = 174 if Interim_Health >= 1 & franchise_id == .
replace franchise_id2 = 174 if Interim_Health >= 1 & franchise_id != .
replace franchise_id3 = 174 if Interim_Health >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Interim_Health >= 1
drop 	Interim_Health 

gen 	Labor_Finders = strpos(lower(employer), "laborfinders") | strpos(lower(employer), "labor finders")
replace franchise_id  = 175 if Labor_Finders >= 1 & franchise_id == .
replace franchise_id2 = 175 if Labor_Finders >= 1 & franchise_id != .
replace franchise_id3 = 175 if Labor_Finders >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Labor_Finders >= 1
drop 	Labor_Finders 

gen 	Spherion = strpos(lower(employer), "spherion")
replace franchise_id  = 176 if Spherion >= 1 & franchise_id == .
replace franchise_id2 = 176 if Spherion >= 1 & franchise_id != .
replace franchise_id3 = 176 if Spherion >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Spherion >= 1
drop 	Spherion

gen 	Pak_Mail = 		strpos(lower(employer), "pack mail") | strpos(lower(employer), "pak mail") | strpos(lower(employer), "pakmail")
replace Pak_Mail = 0 if strpos(employer, "Red Aero Pack Mail Ship")				
replace franchise_id  = 177 if Pak_Mail >= 1 & franchise_id == .
replace franchise_id2 = 177 if Pak_Mail >= 1 & franchise_id != .
replace franchise_id3 = 177 if Pak_Mail >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Pak_Mail >= 1
drop 	Pak_Mail

gen 	Postal_Annex = strpos(lower(employer), "postal annex") | strpos(lower(employer), "postalannex")
replace franchise_id  = 178 if Postal_Annex >= 1 & franchise_id == .
replace franchise_id2 = 178 if Postal_Annex >= 1 & franchise_id != .
replace franchise_id3 = 178 if Postal_Annex >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Postal_Annex >= 1
drop 	Postal_Annex 

gen 	Postnet = strpos(lower(employer), "postnet")
replace franchise_id  = 179 if Postnet >= 1 & franchise_id == .
replace franchise_id2 = 179 if Postnet >= 1 & franchise_id != .
replace franchise_id3 = 179 if Postnet >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Postnet >= 1
drop 	Postnet 

gen 	Unishippers = strpos(lower(employer), "uniship")
replace franchise_id  = 180 if Unishippers >= 1 & franchise_id == .
replace franchise_id2 = 180 if Unishippers >= 1 & franchise_id != .
replace franchise_id3 = 180 if Unishippers >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Unishippers >= 1
drop 	Unishippers 

gen 	UPS_Store = strpos(lower(employer), "ups store") | (strpos(lower(employer), "ups") & strpos(lower(employer), "store"))
replace franchise_id  = 181 if UPS_Store >= 1 & franchise_id == .
replace franchise_id2 = 181 if UPS_Store >= 1 & franchise_id != .
replace franchise_id3 = 181 if UPS_Store >= 1 & franchise_id != . & franchise_id2 != .
* ?
tab 	employer 			if UPS_Store >= 1
drop 	UPS_Store

gen 	Worldwide_Express = 	 strpos(lower(employer), "worldwide expr")
replace Worldwide_Express = 0 if strpos(employer, "American West")				
replace Worldwide_Express = 0 if strpos(employer, "Amwrican West")				
replace Worldwide_Express = 0 if strpos(employer, "Skynet Worldwide Express")	
replace Worldwide_Express = 0 if strpos(employer, "Nex Worldwide Express")		
replace Worldwide_Express = 0 if strpos(employer, "Afc Worldwide Express")		
replace Worldwide_Express = 0 if strpos(employer, "Ahf Transportation/Awest")	
replace franchise_id  = 182 if Worldwide_Express >= 1 & franchise_id == .
replace franchise_id2 = 182 if Worldwide_Express >= 1 & franchise_id != .
replace franchise_id3 = 182 if Worldwide_Express >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Worldwide_Express >= 1
drop 	Worldwide_Express 

gen 	Caring_Transitions = strpos(lower(employer), "caring transitions")
replace franchise_id  = 183 if Caring_Transitions >= 1 & franchise_id == .
replace franchise_id2 = 183 if Caring_Transitions >= 1 & franchise_id != .
replace franchise_id3 = 183 if Caring_Transitions >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Caring_Transitions >= 1
drop 	Caring_Transitions 

gen 	American_Express = 		strpos(lower(employer), "americanexpress") | strpos(lower(employer), "american express")
replace American_Express = 0 if strpos(employer, "American Expressions Hair Salon") 
replace franchise_id  = 184 if American_Express >= 1 & franchise_id == .
replace franchise_id2 = 184 if American_Express >= 1 & franchise_id != .
replace franchise_id3 = 184 if American_Express >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if American_Express >= 1
drop 	American_Express 

gen 	Cruise_One = 	  strpos(lower(employer), "cruiseone") | strpos(lower(employer), "cruise one")
replace Cruise_One = 0 if strpos(employer, "Cruiseone Nanny/Babysitter Service") 
replace franchise_id  = 185 if Cruise_One >= 1 & franchise_id == .
replace franchise_id2 = 185 if Cruise_One >= 1 & franchise_id != .
replace franchise_id3 = 185 if Cruise_One >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Cruise_One >= 1
drop 	Cruise_One  

gen 	Cruise_Planners = strpos(lower(employer), "cruise plan")
replace franchise_id  = 186 if Cruise_Planners >= 1 & franchise_id == .
replace franchise_id2 = 186 if Cruise_Planners >= 1 & franchise_id != .
replace franchise_id3 = 186 if Cruise_Planners >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Cruise_Planners >= 1
drop 	Cruise_Planners

gen 	Results_Travel = strpos(lower(employer), "results travel") | strpos(lower(employer), "resultstravel")
replace franchise_id  = 187 if Results_Travel >= 1 & franchise_id == .
replace franchise_id2 = 187 if Results_Travel >= 1 & franchise_id != .
replace franchise_id3 = 187 if Results_Travel >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Results_Travel >= 1
drop 	Results_Travel

gen 	Travel_Leaders = 	  strpos(lower(employer), "travel leader") | strpos(lower(employer), "travelleader") | strpos(lower(employer), "results travel") | strpos(lower(employer), "resultstravel")
replace Travel_Leaders = 0 if strpos(employer, "Wilcox Travel Leader")			
replace franchise_id  = 188 if Travel_Leaders >= 1 & franchise_id == .
replace franchise_id2 = 188 if Travel_Leaders >= 1 & franchise_id != .
replace franchise_id3 = 188 if Travel_Leaders >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Travel_Leaders >= 1
drop 	Travel_Leaders

gen 	Signal_88 = strpos(lower(employer), "signal 88") | strpos(lower(employer), "signal88")
replace franchise_id  = 189 if Signal_88 >= 1 & franchise_id == .
replace franchise_id2 = 189 if Signal_88 >= 1 & franchise_id != .
replace franchise_id3 = 189 if Signal_88 >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Signal_88 >= 1
drop 	Signal_88

gen 	Pop_A_Lock = strpos(lower(employer), "popalock") | strpos(lower(employer), "pop a lock")
replace franchise_id  = 190 if Pop_A_Lock >= 1 & franchise_id == .
replace franchise_id2 = 190 if Pop_A_Lock >= 1 & franchise_id != .
replace franchise_id3 = 190 if Pop_A_Lock >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Pop_A_Lock >= 1
drop 	Pop_A_Lock

gen 	Critter_Control = strpos(lower(employer), "critter control") | strpos(lower(employer), "crittercontrol")
replace franchise_id  = 191 if Critter_Control >= 1 & franchise_id == .
replace franchise_id2 = 191 if Critter_Control >= 1 & franchise_id != .
replace franchise_id3 = 191 if Critter_Control >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Critter_Control >= 1
drop 	Critter_Control

gen 	Mosquito_Joe = strpos(lower(employer), "mosquito joe")
replace franchise_id  = 192 if Mosquito_Joe >= 1 & franchise_id == .
replace franchise_id2 = 192 if Mosquito_Joe >= 1 & franchise_id != .
replace franchise_id3 = 192 if Mosquito_Joe >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Mosquito_Joe >= 1
drop 	Mosquito_Joe 

gen 	Mosquito_Squad = strpos(lower(employer), "mosquito squad")
replace franchise_id  = 193 if Mosquito_Squad >= 1 & franchise_id == .
replace franchise_id2 = 193 if Mosquito_Squad >= 1 & franchise_id != .
replace franchise_id3 = 193 if Mosquito_Squad >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Mosquito_Squad >= 1
drop 	Mosquito_Squad

gen 	Coverall = 		strpos(lower(employer), "coverall") | strpos(lower(employer), "cover all")
replace Coverall = 0 if strpos(employer, "Recover All Ministies Church") 		
replace Coverall = 0 if strpos(employer, "Recover All Ministries") 				
replace Coverall = 0 if strpos(employer, "Cover All Insurance") 				
replace Coverall = 0 if strpos(employer, "Cover All Metal Roofing") 			
replace Coverall = 0 if strpos(employer, "Cover All Painting") 					
replace Coverall = 0 if strpos(employer, "Cover All Solutions") 				
replace Coverall = 0 if strpos(employer, "Cover All Systems Incorporated") 		
replace Coverall = 0 if strpos(employer, "Cover All Technologies Incorporated") 
replace Coverall = 0 if strpos(employer, "Coverall Aluminum Incorporated") 		
replace Coverall = 0 if strpos(employer, "Coverall Electric") 					
replace Coverall = 0 if strpos(employer, "Coverall Floors") 					
replace Coverall = 0 if strpos(employer, "Coverall Insurance") 					
replace Coverall = 0 if strpos(employer, "Coverall Interiors") 					
replace Coverall = 0 if strpos(employer, "Coverall Landscaping") 				
replace Coverall = 0 if strpos(employer, "Coverall Management Group") 			
replace Coverall = 0 if strpos(employer, "Coverall Painting & Repair") 			
replace Coverall = 0 if strpos(employer, "Coverall Pests") 						
replace Coverall = 0 if strpos(employer, "Coverall Stone Inc") 					
replace Coverall = 0 if strpos(employer, "Coverall Transport") 					
replace Coverall = 0 if strpos(employer, "Model Coverall Service") 				
replace franchise_id  = 194 if Coverall >= 1 & franchise_id == .
replace franchise_id2 = 194 if Coverall >= 1 & franchise_id != .
replace franchise_id3 = 194 if Coverall >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Coverall >= 1
drop 	Coverall 

gen 	Duraclean = strpos(lower(employer), "duraclean") | strpos(lower(employer), "dura clean")
replace franchise_id  = 195 if Duraclean >= 1 & franchise_id == .
replace franchise_id2 = 195 if Duraclean >= 1 & franchise_id != .
replace franchise_id3 = 195 if Duraclean >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Duraclean >= 1
drop 	Duraclean

gen 	Jani_King = strpos(lower(employer), "janiking") | strpos(lower(employer), "jani king")
replace franchise_id  = 196 if Jani_King >= 1 & franchise_id == .
replace franchise_id2 = 196 if Jani_King >= 1 & franchise_id != .
replace franchise_id3 = 196 if Jani_King >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Jani_King >= 1
drop 	Jani_King 

gen 	Jan_Pro = 	   strpos(lower(employer), "jan pro") | strpos(lower(employer), "janpro")
replace Jan_Pro = 0 if strpos(employer, "Barjan Products") 						
replace Jan_Pro = 0 if strpos(employer, "Trojan Professional Servi") 			
replace franchise_id  = 197 if Jan_Pro >= 1 & franchise_id == .
replace franchise_id2 = 197 if Jan_Pro >= 1 & franchise_id != .
replace franchise_id3 = 197 if Jan_Pro >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Jan_Pro >= 1
drop 	Jan_Pro 

gen 	Maid_Brigade = strpos(lower(employer), "maid brigade")
replace franchise_id  = 198 if Maid_Brigade >= 1 & franchise_id == .
replace franchise_id2 = 198 if Maid_Brigade >= 1 & franchise_id != .
replace franchise_id3 = 198 if Maid_Brigade >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Maid_Brigade >= 1
drop 	Maid_Brigade 

gen 	Maidpro = 	   strpos(lower(employer), "maidpro") | strpos(lower(employer), "maid pro")
replace Maidpro = 0 if strpos(employer, "Maid Products")
replace Maidpro = 0 if strpos(employer, "Homemaid Pro Services") 				
replace Maidpro = 0 if strpos(employer, "Merry Maid Professional Services") 	
replace Maidpro = 0 if strpos(employer, "Precisely Maid Professional Services") 
replace Maidpro = 0 if strpos(employer, "Tailormaid Professional Cleaning") 	
replace Maidpro = 0 if strpos(employer, "Wiremaid Products Corp") 				
replace franchise_id  = 199 if Maidpro >= 1 & franchise_id == .
replace franchise_id2 = 199 if Maidpro >= 1 & franchise_id != .
replace franchise_id3 = 199 if Maidpro >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Maidpro >= 1
drop 	Maidpro 

gen 	Maids_International = strpos(lower(employer), "maids international") | strpos(lower(employer), "the maids")
replace franchise_id  = 200 if Maids_International >= 1 & franchise_id == .
replace franchise_id2 = 200 if Maids_International >= 1 & franchise_id != .
replace franchise_id3 = 200 if Maids_International >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Maids_International >= 1
drop 	Maids_International 

gen 	Mint_Condition = 	  strpos(lower(employer), "mint condition") | strpos(lower(employer), "mintcondition") 
replace Mint_Condition = 0 if strpos(employer, "Mint Condition Dental") 		
replace Mint_Condition = 0 if strpos(employer, "Mint Condition Fitness") 		
replace Mint_Condition = 0 if strpos(employer, "Mint Condition Tattoo") 		
replace Mint_Condition = 0 if strpos(employer, "Mint Condition Mobile Detailing") 
replace franchise_id  = 201 if Mint_Condition >= 1 & franchise_id == .
replace franchise_id2 = 201 if Mint_Condition >= 1 & franchise_id != .
replace franchise_id3 = 201 if Mint_Condition >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Mint_Condition >= 1
drop 	Mint_Condition

gen 	Molly_Maid = strpos(lower(employer), "molly maid")
replace franchise_id  = 202 if Molly_Maid >= 1 & franchise_id == .
replace franchise_id2 = 202 if Molly_Maid >= 1 & franchise_id != .
replace franchise_id3 = 202 if Molly_Maid >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Molly_Maid >= 1
drop 	Molly_Maid

gen 	Office_Pride = strpos(lower(employer), "office pride")
replace franchise_id  = 203 if Office_Pride >= 1 & franchise_id == .
replace franchise_id2 = 203 if Office_Pride >= 1 & franchise_id != .
replace franchise_id3 = 203 if Office_Pride >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Office_Pride >= 1
drop 	Office_Pride 

gen 	Pro_One = 	   strpos(lower(employer), "pro one")
replace Pro_One = 0 if strpos(employer, "Pro One Auto Specialist") 				
replace Pro_One = 0 if strpos(employer, "Pro One Builders Group") 				
replace Pro_One = 0 if strpos(employer, "Pro One Insurance Services, Inc") 		
replace Pro_One = 0 if strpos(employer, "Pro One Security") 					
replace franchise_id  = 204 if Pro_One >= 1 & franchise_id == .
replace franchise_id2 = 204 if Pro_One >= 1 & franchise_id != .
replace franchise_id3 = 204 if Pro_One >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Pro_One >= 1
drop 	Pro_One 

gen 	Servpro = 	   strpos(lower(employer), "servpro") | strpos(lower(employer), "serv pro")
replace Servpro = 0 if strpos(employer, "Natl Reg Of Hlth Serv Providers In Psychol") 
replace Servpro = 0 if strpos(employer, "Docuservpro, Llc") 					
replace Servpro = 0 if strpos(employer, "All Serv Properties") 					
replace Servpro = 0 if strpos(employer, "A Serv Property Maintenance") 			
replace franchise_id  = 205 if Servpro >= 1 & franchise_id == .
replace franchise_id2 = 205 if Servpro >= 1 & franchise_id != .
replace franchise_id3 = 205 if Servpro >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Servpro >= 1
drop 	Servpro

gen 	Cleaning_Authority = 	  strpos(lower(employer), "cleaning auth") | strpos(lower(employer), "clean auth")
replace Cleaning_Authority = 0 if strpos(employer, "Michigan Maid Cleaning Authority") 
replace franchise_id  = 206 if Cleaning_Authority >= 1 & franchise_id == .
replace franchise_id2 = 206 if Cleaning_Authority >= 1 & franchise_id != .
replace franchise_id3 = 206 if Cleaning_Authority >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Cleaning_Authority >= 1
drop 	Cleaning_Authority

gen 	Fish_Window = strpos(lower(employer), "fish window") | strpos(lower(employer), "fishwindow") 
replace franchise_id  = 207 if Fish_Window >= 1 & franchise_id == .
replace franchise_id2 = 207 if Fish_Window >= 1 & franchise_id != .
replace franchise_id3 = 207 if Fish_Window >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Fish_Window >= 1
drop 	Fish_Window

gen 	For_Franchising = 	   strpos(lower(employer), "for franchis") | strpos(lower(employer), "forfranchis") | strpos(lower(employer), "window genie")
replace For_Franchising = 0 if strpos(employer, "Belfor Franchise Group") 		
replace franchise_id  = 208 if For_Franchising >= 1 & franchise_id == .
replace franchise_id2 = 208 if For_Franchising >= 1 & franchise_id != .
replace franchise_id3 = 208 if For_Franchising >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if For_Franchising >= 1
drop 	For_Franchising  

gen 	Grounds_Guys = strpos(lower(employer), "grounds guys")
replace franchise_id  = 209 if Grounds_Guys >= 1 & franchise_id == .
replace franchise_id2 = 209 if Grounds_Guys >= 1 & franchise_id != .
replace franchise_id3 = 209 if Grounds_Guys >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Grounds_Guys >= 1
drop 	Grounds_Guys

gen 	Lawn_Doctor = 	   strpos(lower(employer), "lawn doctor") | strpos(lower(employer), "lawndoctor")
replace Lawn_Doctor = 0 if strpos(employer, "Pest And Lawn Doctors") 			
replace franchise_id  = 210 if Lawn_Doctor >= 1 & franchise_id == .
replace franchise_id2 = 210 if Lawn_Doctor >= 1 & franchise_id != .
replace franchise_id3 = 210 if Lawn_Doctor >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Lawn_Doctor >= 1
drop 	Lawn_Doctor

gen 	Scotts_Lawn = strpos(lower(employer), "scottslawn") | strpos(lower(employer), "scotts lawn")
replace franchise_id  = 211 if Scotts_Lawn >= 1 & franchise_id == .
replace franchise_id2 = 211 if Scotts_Lawn >= 1 & franchise_id != .
replace franchise_id3 = 211 if Scotts_Lawn >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Scotts_Lawn >= 1
drop 	Scotts_Lawn 

gen 	Spring_Green = 		strpos(lower(employer), "springgreen") | strpos(lower(employer), "spring green")
replace Spring_Green = 0 if strpos(employer, "Culver's Of Spring Green") 		
replace Spring_Green = 0 if strpos(employer, "Meadows Spring Green") 			
replace Spring_Green = 0 if strpos(employer, "Spring Green Community Library") 	
replace Spring_Green = 0 if strpos(employer, "Spring Green Films") 				
replace Spring_Green = 0 if strpos(employer, "Spring Green Floral") 			
replace franchise_id  = 212 if Spring_Green >= 1 & franchise_id == .
replace franchise_id2 = 212 if Spring_Green >= 1 & franchise_id != .
replace franchise_id3 = 212 if Spring_Green >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Spring_Green >= 1
drop 	Spring_Green 

gen 	US_Lawns = 		strpos(lower(employer), "us lawns") | strpos(lower(employer), "u.s. lawns") | strpos(lower(employer), "uslawn") 
replace US_Lawns = 0 if strpos(employer, "Ladage's Luxurious Lawns") 			
replace US_Lawns = 0 if strpos(employer, "Liekhus Lawns Limited") 				
replace US_Lawns = 0 if strpos(employer, "Lotus Lawnscapes, Inc") 				
replace franchise_id  = 213 if US_Lawns >= 1 & franchise_id == .
replace franchise_id2 = 213 if US_Lawns >= 1 & franchise_id != .
replace franchise_id3 = 213 if US_Lawns >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if US_Lawns >= 1
drop 	US_Lawns 

gen 	Chem_Dry = strpos(lower(employer), "chemdry") | strpos(lower(employer), "chem dry")
replace franchise_id  = 214 if Chem_Dry >= 1 & franchise_id == .
replace franchise_id2 = 214 if Chem_Dry >= 1 & franchise_id != .
replace franchise_id3 = 214 if Chem_Dry >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Chem_Dry >= 1
drop 	Chem_Dry

gen 	Oxi_Fresh = strpos(lower(employer), "oxifresh") | strpos(lower(employer), "oxi fresh")
replace franchise_id  = 215 if Oxi_Fresh >= 1 & franchise_id == .
replace franchise_id2 = 215 if Oxi_Fresh >= 1 & franchise_id != .
replace franchise_id3 = 215 if Oxi_Fresh >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Oxi_Fresh >= 1
drop 	Oxi_Fresh 

gen 	Sears_Clean = strpos(lower(employer), "sears clean") | strpos(lower(employer), "sears carpet")
replace franchise_id  = 216 if Sears_Clean >= 1 & franchise_id == .
replace franchise_id2 = 216 if Sears_Clean >= 1 & franchise_id != .
replace franchise_id3 = 216 if Sears_Clean >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Sears_Clean >= 1
drop 	Sears_Clean  

gen 	Stanley_Steemer = strpos(lower(employer), "stanley steemer")
replace franchise_id  = 217 if Stanley_Steemer >= 1 & franchise_id == .
replace franchise_id2 = 217 if Stanley_Steemer >= 1 & franchise_id != .
replace franchise_id3 = 217 if Stanley_Steemer >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Stanley_Steemer >= 1
drop 	Stanley_Steemer

gen 	Nhance = 	  strpos(lower(employer), "nhance") | strpos(lower(employer), "n hance")
replace Nhance = 0 if strpos(lower(employer), "enhance") 						
replace Nhance = 0 if strpos(employer, "Inhance") 								
replace Nhance = 0 if strpos(employer, "Nhanced Semiconductors") 				
replace franchise_id  = 218 if Nhance >= 1 & franchise_id == .
replace franchise_id2 = 218 if Nhance >= 1 & franchise_id != .
replace franchise_id3 = 218 if Nhance >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Nhance >= 1
drop 	Nhance 

gen 	Decor_Group = 	   strpos(lower(employer), "decor group") |  strpos(lower(employer), "christmas decor")
replace Decor_Group = 0 if strpos(employer, "B & R Christmas Decorators") 		
replace Decor_Group = 0 if strpos(employer, "Home Decor Group") 				
replace Decor_Group = 0 if strpos(employer, "Rave Decor Group") 				
replace franchise_id  = 219 if Decor_Group >= 1 & franchise_id == .
replace franchise_id2 = 219 if Decor_Group >= 1 & franchise_id != .
replace franchise_id3 = 219 if Decor_Group >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Decor_Group >= 1
drop 	Decor_Group

gen 	One800_Got_Junk = strpos(lower(employer), "got junk") | strpos(lower(employer), "got-junk")
replace franchise_id  = 220 if One800_Got_Junk >= 1 & franchise_id == .
replace franchise_id2 = 220 if One800_Got_Junk >= 1 & franchise_id != .
replace franchise_id3 = 220 if One800_Got_Junk >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if One800_Got_Junk >= 1
drop 	One800_Got_Junk 

gen 	Disaster_Kleenup = strpos(lower(employer), "disaster kleen") 
replace franchise_id  = 221 if Disaster_Kleenup >= 1 & franchise_id == .
replace franchise_id2 = 221 if Disaster_Kleenup >= 1 & franchise_id != .
replace franchise_id3 = 221 if Disaster_Kleenup >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Disaster_Kleenup >= 1
drop 	Disaster_Kleenup

gen 	Green_Home = strpos(lower(employer), "green home solution") 
replace Green_Home = 0 if strpos(employer, "Point Green Home Solutions") 		
replace franchise_id  = 222 if Green_Home >= 1 & franchise_id == .
replace franchise_id2 = 222 if Green_Home >= 1 & franchise_id != .
replace franchise_id3 = 222 if Green_Home >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Green_Home >= 1
drop 	Green_Home

gen 	Paul_Davis = 	  strpos(lower(employer), "paul davis") | strpos(lower(employer), "pauldavis")
replace Paul_Davis = 0 if strpos(employer, "Paul Davis Architects") 			
replace franchise_id  = 223 if Paul_Davis >= 1 & franchise_id == .
replace franchise_id2 = 223 if Paul_Davis >= 1 & franchise_id != .
replace franchise_id3 = 223 if Paul_Davis >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Paul_Davis >= 1
drop 	Paul_Davis 

gen 	Rainbow_International = 	 strpos(lower(employer), "rainbow restoration") | strpos(lower(employer), "rainbow international")
replace Rainbow_International = 0 if strpos(employer, "Rainbow International Airlines") 
replace franchise_id  = 224 if Rainbow_International >= 1 & franchise_id == .
replace franchise_id2 = 224 if Rainbow_International >= 1 & franchise_id != .
replace franchise_id3 = 224 if Rainbow_International >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Rainbow_International >= 1
drop 	Rainbow_International 

gen 	Eye_Level = 	 strpos(lower(employer), "eye level") | strpos(lower(employer), "eyelevel")
replace Eye_Level = 0 if strpos(employer, "Eyelevelproductions") 				
replace franchise_id  = 225 if Eye_Level >= 1 & franchise_id == .
replace franchise_id2 = 225 if Eye_Level >= 1 & franchise_id != .
replace franchise_id3 = 225 if Eye_Level >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Eye_Level >= 1
drop 	Eye_Level 

gen 	Arthur_Murray = strpos(lower(employer), "arthur murray")
replace franchise_id  = 226 if Arthur_Murray >= 1 & franchise_id == .
replace franchise_id2 = 226 if Arthur_Murray >= 1 & franchise_id != .
replace franchise_id3 = 226 if Arthur_Murray >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Arthur_Murray >= 1
drop 	Arthur_Murray

gen 	Danceworks = 	  strpos(lower(employer), "danceworks") | strpos(lower(employer), "dance works") 
replace Danceworks = 0 if strpos(employer, "American Theater Dance Workshop") 	
replace Danceworks = 0 if strpos(employer, "Dance Workshop Deer Park") 			
replace Danceworks = 0 if strpos(employer, "Pamela Trokanski Dance Workshop") 	
replace franchise_id  = 227 if Danceworks >= 1 & franchise_id == .
replace franchise_id2 = 227 if Danceworks >= 1 & franchise_id != .
replace franchise_id3 = 227 if Danceworks >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Danceworks >= 1
drop 	Danceworks

gen 	Pinots_Palette = strpos(lower(employer), "pinot's palette") | strpos(lower(employer), "pinots palette") 
replace franchise_id  = 228 if Pinots_Palette >= 1 & franchise_id == .
replace franchise_id2 = 228 if Pinots_Palette >= 1 & franchise_id != .
replace franchise_id3 = 228 if Pinots_Palette >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Pinots_Palette >= 1
drop 	Pinots_Palette 

gen 	Club_Z = 	  strpos(lower(employer), "club z") | strpos(lower(employer), "clubz")
replace Club_Z = 0 if strpos(employer, "After Skool Clubz, Llc") 				
replace Club_Z = 0 if strpos(employer, "Boys Girls Club Zionsville") 			
replace Club_Z = 0 if strpos(employer, "Maxx Fitness Clubzz") 					
replace franchise_id  = 229 if Club_Z >= 1 & franchise_id == .
replace franchise_id2 = 229 if Club_Z >= 1 & franchise_id != .
replace franchise_id3 = 229 if Club_Z >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Club_Z >= 1
drop 	Club_Z 

gen 	Huntington_Learning = strpos(lower(employer), "huntington learn")
replace franchise_id  = 230 if Huntington_Learning >= 1 & franchise_id == .
replace franchise_id2 = 230 if Huntington_Learning >= 1 & franchise_id != .
replace franchise_id3 = 230 if Huntington_Learning >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Huntington_Learning >= 1
drop 	Huntington_Learning

gen 	Kumon = 	 strpos(lower(employer), "kumon")
replace Kumon = 0 if strpos(lower(employer), "kumonoak")
replace franchise_id  = 231 if Kumon >= 1 & franchise_id == .
replace franchise_id2 = 231 if Kumon >= 1 & franchise_id != .
replace franchise_id3 = 231 if Kumon >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Kumon >= 1
drop 	Kumon 

gen 	Mathnasium = strpos(lower(employer), "mathnasium")
replace franchise_id  = 232 if Mathnasium >= 1 & franchise_id == .
replace franchise_id2 = 232 if Mathnasium >= 1 & franchise_id != .
replace franchise_id3 = 232 if Mathnasium >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Mathnasium >= 1
drop 	Mathnasium 

gen 	Sylvan_Ed = strpos(lower(employer), "sylvan learning") | strpos(lower(employer), "sylvan national learning") 
replace Sylvan_Ed = 1 if employer == "Sylvan" | employer == "Sylvan of Rhode Island"
replace franchise_id  = 233 if Sylvan_Ed >= 1 & franchise_id == .
replace franchise_id2 = 233 if Sylvan_Ed >= 1 & franchise_id != .
replace franchise_id3 = 233 if Sylvan_Ed >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Sylvan_Ed >= 1
drop 	Sylvan_Ed 

gen 	Tutor_Doctor = strpos(lower(employer), "tutor doc")
replace franchise_id  = 234 if Tutor_Doctor >= 1 & franchise_id == .
replace franchise_id2 = 234 if Tutor_Doctor >= 1 & franchise_id != .
replace franchise_id3 = 234 if Tutor_Doctor >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Tutor_Doctor >= 1
drop 	Tutor_Doctor 

gen 	Engineering_For_Kids = strpos(lower(employer), "engineering for kids")
replace franchise_id  = 235 if Engineering_For_Kids >= 1 & franchise_id == .
replace franchise_id2 = 235 if Engineering_For_Kids >= 1 & franchise_id != .
replace franchise_id3 = 235 if Engineering_For_Kids >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Engineering_For_Kids >= 1
drop 	Engineering_For_Kids 

gen 	Painting_With_A_Twist = 	 strpos(lower(employer), "painting with")
replace Painting_With_A_Twist = 0 if strpos(employer, "Painting With Pride") 	
replace franchise_id  = 236 if Painting_With_A_Twist >= 1 & franchise_id == .
replace franchise_id2 = 236 if Painting_With_A_Twist >= 1 & franchise_id != .
replace franchise_id3 = 236 if Painting_With_A_Twist >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Painting_With_A_Twist >= 1
drop 	Painting_With_A_Twist

gen 	School_Of_Rock = 	  strpos(lower(employer), "school of rock")
replace School_Of_Rock = 0 if strpos(employer, "Ccb School Of Rockville") 		
replace School_Of_Rock = 0 if strpos(employer, "School Of Rockland") 			
replace School_Of_Rock = 0 if strpos(employer, "Primrose School Of Rockwall") 	
replace franchise_id  = 237 if School_Of_Rock >= 1 & franchise_id == .
replace franchise_id2 = 237 if School_Of_Rock >= 1 & franchise_id != .
replace franchise_id3 = 237 if School_Of_Rock >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if School_Of_Rock >= 1
drop 	School_Of_Rock 

gen 	Young_Rembrandts = strpos(lower(employer), "young rembra")
replace franchise_id  = 238 if Young_Rembrandts >= 1 & franchise_id == .
replace franchise_id2 = 238 if Young_Rembrandts >= 1 & franchise_id != .
replace franchise_id3 = 238 if Young_Rembrandts >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Young_Rembrandts >= 1
drop 	Young_Rembrandts 

gen 	My_Gym = 	  strpos(lower(employer), "my gym") | strpos(lower(employer), "mygym")
replace My_Gym = 0 if strpos(lower(employer), "emy gymnast")
replace franchise_id  = 239 if My_Gym >= 1 & franchise_id == .
replace franchise_id2 = 239 if My_Gym >= 1 & franchise_id != .
replace franchise_id3 = 239 if My_Gym >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if My_Gym >= 1
drop 	My_Gym 

gen 	Stroller_Strides = strpos(lower(employer), "stroller strides") | strpos(lower(employer), "fit 4 mom")  | strpos(lower(employer), "fit4mom") 
replace franchise_id  = 240 if Stroller_Strides >= 1 & franchise_id == .
replace franchise_id2 = 240 if Stroller_Strides >= 1 & franchise_id != .
replace franchise_id3 = 240 if Stroller_Strides >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Stroller_Strides >= 1
drop 	Stroller_Strides 

gen 	Mad_Science = strpos(lower(employer), "mad science") | strpos(lower(employer), "madscience")
replace franchise_id  = 241 if Mad_Science >= 1 & franchise_id == .
replace franchise_id2 = 241 if Mad_Science >= 1 & franchise_id != .
replace franchise_id3 = 241 if Mad_Science >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Mad_Science >= 1
drop 	Mad_Science

gen 	Smile_Source = strpos(lower(employer), "smile source") | strpos(lower(employer), "smilesource")
replace franchise_id  = 242 if Smile_Source >= 1 & franchise_id == .
replace franchise_id2 = 242 if Smile_Source >= 1 & franchise_id != .
replace franchise_id3 = 242 if Smile_Source >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Smile_Source >= 1
drop 	Smile_Source 

gen 	Healthsource = 	   (strpos(lower(employer), "health source") 	| strpos(lower(employer), "healthsource")) & (strpos(lower(employer), "chiro")) | ///
							strpos(lower(employer), "health source of") | strpos(lower(employer), "healthsource of")
replace Healthsource = 0 if strpos(lower(employer), "unihealth")
replace Healthsource = 0 if strpos(employer, "Eastgate Pediatrics Healthsource Of") 
replace franchise_id  = 243 if Healthsource >= 1 & franchise_id == .
replace franchise_id2 = 243 if Healthsource >= 1 & franchise_id != .
replace franchise_id3 = 243 if Healthsource >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Healthsource >= 1
drop 	Healthsource 

gen 	Joint_Corp = 	  strpos(lower(employer), "the joint ch") | strpos(lower(employer), "joint chiropr")
replace Joint_Corp = 0 if strpos(employer, "Organization Of The Joint Chiefs Of") 					 
replace Joint_Corp = 0 if strpos(employer, "Today Disc, Bone & Joint Chiropractic Treatment Center") 
replace franchise_id  = 244 if Joint_Corp >= 1 & franchise_id == .
replace franchise_id2 = 244 if Joint_Corp >= 1 & franchise_id != .
replace franchise_id3 = 244 if Joint_Corp >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Joint_Corp >= 1
drop 	Joint_Corp

gen 	Maximized_Living = strpos(lower(employer), "maximized living") | strpos(lower(employer), "maxliving") | strpos(lower(employer), "max living")
replace Maximized_Living = 0 if strpos(employer, "Re/Max") | strpos(employer, "Remax")  
replace franchise_id  = 245 if Maximized_Living >= 1 & franchise_id == .
replace franchise_id2 = 245 if Maximized_Living >= 1 & franchise_id != .
replace franchise_id3 = 245 if Maximized_Living >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Maximized_Living >= 1
drop 	Maximized_Living 

gen 	Pearl_Vision = strpos(lower(employer), "pearl vision") | strpos(lower(employer), "luxottica") | strpos(lower(employer), "pearle vision") | strpos(lower(employer), "lenscrafters")
replace franchise_id  = 246 if Pearl_Vision >= 1 & franchise_id == .
replace franchise_id2 = 246 if Pearl_Vision >= 1 & franchise_id != .
replace franchise_id3 = 246 if Pearl_Vision >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Pearl_Vision >= 1
drop 	Pearl_Vision 

gen 	Vision_Source = strpos(lower(employer), "vision source")
replace franchise_id  = 247 if Vision_Source >= 1 & franchise_id == .
replace franchise_id2 = 247 if Vision_Source >= 1 & franchise_id != .
replace franchise_id3 = 247 if Vision_Source >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Vision_Source >= 1
drop 	Vision_Source 

gen 	Vision_Trends = strpos(lower(employer), "vision trends") | strpos(lower(employer), "visiontrends") 
replace franchise_id  = 248 if Vision_Trends >= 1 & franchise_id == .
replace franchise_id2 = 248 if Vision_Trends >= 1 & franchise_id != .
replace franchise_id3 = 248 if Vision_Trends >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Vision_Trends >= 1
drop 	Vision_Trends 

gen 	Fyzical = strpos(lower(employer), "fyzical")
replace franchise_id  = 249 if Fyzical >= 1 & franchise_id == .
replace franchise_id2 = 249 if Fyzical >= 1 & franchise_id != .
replace franchise_id3 = 249 if Fyzical >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Fyzical >= 1
drop 	Fyzical

gen 	AFC_Health = strpos(lower(employer), "american family care") | strpos(lower(employer), "afc urgent") 
replace franchise_id  = 250 if AFC_Health >= 1 & franchise_id == .
replace franchise_id2 = 250 if AFC_Health >= 1 & franchise_id != .
replace franchise_id3 = 250 if AFC_Health >= 1 & franchise_id != . & franchise_id2 != .
* ? 
tab 	employer 			if AFC_Health >= 1
drop 	AFC_Health

gen 	Any_Lab_Test = strpos(lower(employer), "any lab test") | strpos(lower(employer), "anylabtest") 
replace franchise_id  = 251 if Any_Lab_Test >= 1 & franchise_id == .
replace franchise_id2 = 251 if Any_Lab_Test >= 1 & franchise_id != .
replace franchise_id3 = 251 if Any_Lab_Test >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Any_Lab_Test >= 1
drop 	Any_Lab_Test 

gen 	Arcpoint = 		strpos(lower(employer), "arc point") | strpos(lower(employer), "arcpoint")
replace Arcpoint = 0 if strpos(employer, "Arcpoint Studios") 					
replace franchise_id  = 252 if Arcpoint >= 1 & franchise_id == .
replace franchise_id2 = 252 if Arcpoint >= 1 & franchise_id != .
replace franchise_id3 = 252 if Arcpoint >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Arcpoint >= 1
drop 	Arcpoint

gen 	Body_And_Brain = strpos(lower(employer), "body and brain") | strpos(lower(employer), "body & brain") | strpos(lower(employer), "body&brain") | strpos(lower(employer), "body n brain") | strpos(lower(employer), "bodynbrain")
replace franchise_id  = 253 if Body_And_Brain >= 1 & franchise_id == .
replace franchise_id2 = 253 if Body_And_Brain >= 1 & franchise_id != .
replace franchise_id3 = 253 if Body_And_Brain >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Body_And_Brain >= 1
drop 	Body_And_Brain 

gen 	Acti_Kare = strpos(lower(employer), "acti kare") | strpos(lower(employer), "actikare")
replace franchise_id  = 254 if Acti_Kare >= 1 & franchise_id == .
replace franchise_id2 = 254 if Acti_Kare >= 1 & franchise_id != .
replace franchise_id3 = 254 if Acti_Kare >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Acti_Kare >= 1
drop 	Acti_Kare 

gen 	Assisting_Hands = strpos(lower(employer), "assisting hands")
replace franchise_id  = 255 if Assisting_Hands >= 1 & franchise_id == .
replace franchise_id2 = 255 if Assisting_Hands >= 1 & franchise_id != .
replace franchise_id3 = 255 if Assisting_Hands >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Assisting_Hands >= 1
drop 	Assisting_Hands 

gen 	Brightstar = 	  strpos(lower(employer), "brightstar home") | strpos(lower(employer), "brightstar health") | strpos(lower(employer), "brightstar of") 	  | ///
						  strpos(lower(employer), "brightstarcare")  | strpos(lower(employer), "brightstar s") 		| strpos(lower(employer), "brightstart care") | ///
						  strpos(lower(employer), "brightstar car")  | strpos(lower(employer), "brightstar b") 		| strpos(lower(employer), "brightstar f") 	  | ///
						  strpos(lower(employer), "brightstar g") 	 | strpos(lower(employer), "brightstar ire") 	| strpos(lower(employer), "brightstar rec")   | ///
						  strpos(lower(employer), "brightstar h")
replace Brightstar = 0 if strpos(employer, "Brightstar Financial Group") 		
replace Brightstar = 0 if strpos(employer, "Brightstar Golf Redlands Mesa") 	
replace Brightstar = 0 if strpos(employer, "The Brightstar Grill") 				
replace franchise_id  = 256 if Brightstar >= 1 & franchise_id == .
replace franchise_id2 = 256 if Brightstar >= 1 & franchise_id != .
replace franchise_id3 = 256 if Brightstar >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Brightstar >= 1
drop 	Brightstar 

gen 	Comfort_Keepers = 	   strpos(lower(employer), "ck fran") | strpos(lower(employer), "comfort keeper")
replace Comfort_Keepers = 0 if strpos(lower(employer), "back")
replace Comfort_Keepers = 0 if strpos(employer, "Rick Franklin Construction") 		  
replace Comfort_Keepers = 0 if strpos(employer, "Rick Franz Windermere Real Estate")  
replace Comfort_Keepers = 0 if strpos(employer, "South Texas Truck Franchise Dealer") 
replace Comfort_Keepers = 0 if strpos(employer, "Tiger Rock Franchising Corp") 		  
replace franchise_id  = 257 if Comfort_Keepers >= 1 & franchise_id == .
replace franchise_id2 = 257 if Comfort_Keepers >= 1 & franchise_id != .
replace franchise_id3 = 257 if Comfort_Keepers >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Comfort_Keepers >= 1
drop 	Comfort_Keepers 

gen 	Comforcare = strpos(lower(employer), "comforcare")
replace franchise_id  = 258 if Comforcare >= 1 & franchise_id == .
replace franchise_id2 = 258 if Comforcare >= 1 & franchise_id != .
replace franchise_id3 = 258 if Comforcare >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Comforcare >= 1
drop 	Comforcare

gen 	Firstlight = 	  strpos(lower(employer), "firstlight") | strpos(lower(employer), "first light")
replace Firstlight = 0 if strpos(employer, "First Light Biosciences") 			
replace Firstlight = 0 if strpos(employer, "First Light Children's Center") 	
replace Firstlight = 0 if strpos(employer, "First Light Development, Llc") 		
replace Firstlight = 0 if strpos(employer, "First Light Early Education Center")	  
replace Firstlight = 0 if strpos(employer, "First Light Energy") 				
replace Firstlight = 0 if strpos(employer, "First Light Entertainment") 		
replace Firstlight = 0 if strpos(employer, "First Light Federal Credit Union") 	
replace Firstlight = 0 if strpos(employer, "First Light Fiber") 				
replace Firstlight = 0 if strpos(employer, "First Light Foods Usa") 			
replace Firstlight = 0 if strpos(employer, "First Light Learning Center") 		
replace Firstlight = 0 if strpos(employer, "First Light Lighting Systems") 		
replace Firstlight = 0 if strpos(employer, "First Light Program Managers") 		
replace Firstlight = 0 if strpos(employer, "First Light Properties") 			
replace Firstlight = 0 if strpos(employer, "First Light Property Mana") 		
replace Firstlight = 0 if strpos(employer, "First Light Systems") 				
replace Firstlight = 0 if strpos(employer, "First Light Technologies Incorporated")   
replace Firstlight = 0 if strpos(employer, "First Light Wealth Advisors, Llc") 	
replace Firstlight = 0 if strpos(employer, "Firstlight Federal Credit Union") 	
replace Firstlight = 0 if strpos(employer, "Firstlight Fiber") 					
replace Firstlight = 0 if strpos(employer, "Firstlight Power") 					
replace Firstlight = 0 if strpos(employer, "Firstlight United Methodist Church") 	  
replace Firstlight = 0 if strpos(employer, "Firstlighth Federal Credit Union") 	
replace Firstlight = 0 if strpos(employer, "First Light Health") 				
replace Firstlight = 0 if strpos(employer, "Firstlight Health") 				
replace franchise_id  = 259 if Firstlight >= 1 & franchise_id == .
replace franchise_id2 = 259 if Firstlight >= 1 & franchise_id != .
replace franchise_id3 = 259 if Firstlight >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Firstlight >= 1
drop 	Firstlight 

gen 	Home_Care_Assistants = 		strpos(lower(employer), "home care assist")
replace Home_Care_Assistants = 0 if strpos(employer, "Home Care Assistants") 	
replace franchise_id  = 260 if Home_Care_Assistants >= 1 & franchise_id == .
replace franchise_id2 = 260 if Home_Care_Assistants >= 1 & franchise_id != .
replace franchise_id3 = 260 if Home_Care_Assistants >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Home_Care_Assistants >= 1
drop 	Home_Care_Assistants

gen 	Home_Helpers = 		strpos(lower(employer), "home helper") | strpos(lower(employer), "homehelper") | strpos(lower(employer), "h h franchising") 
replace Home_Helpers = 0 if strpos(employer, "Happy Home Helpers") 				
replace Home_Helpers = 0 if strpos(employer, "Home Helper Services") 			
replace Home_Helpers = 0 if strpos(employer, "Homehelper Consultants") 			
replace Home_Helpers = 0 if strpos(employer, "Rhonda's Home Helpers, Llc") 		
replace Home_Helpers = 0 if strpos(employer, "Rhondas Home Helpers Llc") 		
replace Home_Helpers = 0 if strpos(employer, "Companion And Home Helpers") 		
replace Home_Helpers = 0 if strpos(employer, "Companions & Home Helpers") 		
replace Home_Helpers = 0 if strpos(employer, "Companions&Home Helpers") 		
replace Home_Helpers = 0 if strpos(employer, "Companions And Home Helpers") 	
replace Home_Helpers = 0 if strpos(employer, "Tidy Home Helpers") 				
replace franchise_id  = 261 if Home_Helpers >= 1 & franchise_id == .
replace franchise_id2 = 261 if Home_Helpers >= 1 & franchise_id != .
replace franchise_id3 = 261 if Home_Helpers >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Home_Helpers >= 1
drop 	Home_Helpers 

gen 	Home_Instead = strpos(lower(employer), "home instead") | strpos(lower(employer), "homeinstead")
replace franchise_id  = 262 if Home_Instead >= 1 & franchise_id == .
replace franchise_id2 = 262 if Home_Instead >= 1 & franchise_id != .
replace franchise_id3 = 262 if Home_Instead >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Home_Instead >= 1
drop 	Home_Instead

gen 	Homewatch = 	 strpos(lower(employer), "homewatch") | strpos(lower(employer), "home watch")
replace Homewatch = 0 if strpos(employer, "Home Sweet Home Watch/Collier Comerical Cleaning") 
replace Homewatch = 0 if strpos(employer, "Homewatch Security Cameras") 		
replace Homewatch = 0 if strpos(employer, "Jumpp To It Homewatch, Inc") 		
replace Homewatch = 0 if strpos(employer, "Home Sweet Home Watch") 				
replace Homewatch = 0 if strpos(employer, "Mesquite Home Watch") 				
replace Homewatch = 0 if strpos(employer, "Padzu Home Watch") 					
replace franchise_id  = 263 if Homewatch >= 1 & franchise_id == .
replace franchise_id2 = 263 if Homewatch >= 1 & franchise_id != .
replace franchise_id3 = 263 if Homewatch >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Homewatch >= 1
drop 	Homewatch 

gen 	Living_Assistants = 	 strpos(lower(employer), "living assistance") | strpos(lower(employer), "visiting angel") 
replace Living_Assistants = 0 if strpos(employer, "Divine Living Assistance") 	
replace Living_Assistants = 0 if strpos(employer, "Easy Living Assistance") 	
replace Living_Assistants = 0 if strpos(employer, "Family Cares In Home Living Assistance Llc")  
replace Living_Assistants = 0 if strpos(employer, "Familycares In Home Living Assistance, Llc")  
replace Living_Assistants = 0 if strpos(employer, "Indecare In Home Care & Living Assistance") 	 
replace Living_Assistants = 0 if strpos(employer, "Indecare In Home Care And Living Assistance") 
replace Living_Assistants = 0 if strpos(employer, "Iola Living Assistance") 	
replace Living_Assistants = 0 if strpos(employer, "Never Alone Living Assistance") 	   
replace Living_Assistants = 0 if strpos(employer, "Planned Living Assistance Network") 
replace franchise_id  = 264 if Living_Assistants >= 1 & franchise_id == .
replace franchise_id2 = 264 if Living_Assistants >= 1 & franchise_id != .
replace franchise_id3 = 264 if Living_Assistants >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Living_Assistants >= 1
drop 	Living_Assistants 

gen 	Right_At_Home = 	 strpos(lower(employer), "right at home")
replace Right_At_Home = 0 if strpos(employer, "Wright At Home Domestic Services") 
replace franchise_id  = 265 if Right_At_Home >= 1 & franchise_id == .
replace franchise_id2 = 265 if Right_At_Home >= 1 & franchise_id != .
replace franchise_id3 = 265 if Right_At_Home >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Right_At_Home >= 1
drop 	Right_At_Home 

gen 	Senior_Helpers = 	  strpos(lower(employer), "senior help") | strpos(lower(employer), "seniorhelp")
replace Senior_Helpers = 0 if strpos(employer, "Senior Helping Seniors") 		
replace Senior_Helpers = 0 if strpos(employer, "Senior Helping Senors") 		
replace franchise_id  = 266 if Senior_Helpers >= 1 & franchise_id == .
replace franchise_id2 = 266 if Senior_Helpers >= 1 & franchise_id != .
replace franchise_id3 = 266 if Senior_Helpers >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Senior_Helpers >= 1
drop 	Senior_Helpers

gen 	Synergy_Homecare = 		strpos(lower(employer), "synergy home") | strpos(lower(employer), "synergy care")
replace Synergy_Homecare = 0 if strpos(employer, "New Synergy Homes") 			
replace Synergy_Homecare = 0 if strpos(employer, "Synergy Care") 				
replace Synergy_Homecare = 0 if strpos(employer, "Synergy Home Loans") 			
replace Synergy_Homecare = 0 if strpos(employer, "Synergy Home Mortgage") 		
replace Synergy_Homecare = 0 if strpos(employer, "Synergy Home Performance") 	
replace Synergy_Homecare = 0 if strpos(employer, "Synergy Home Systems") 		
replace Synergy_Homecare = 0 if strpos(employer, "Synergy Homes/ Fy Construction, Llc") 
replace franchise_id  = 267 if Synergy_Homecare >= 1 & franchise_id == .
replace franchise_id2 = 267 if Synergy_Homecare >= 1 & franchise_id != .
replace franchise_id3 = 267 if Synergy_Homecare >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Synergy_Homecare >= 1
drop 	Synergy_Homecare 

gen 	Carepatrol = 	  strpos(lower(employer), "carepatrol") | strpos(lower(employer), "care patrol") 
replace Carepatrol = 0 if strpos(employer, "Wisconsin Senior Medicare Patrol") 	
replace franchise_id  = 268 if Carepatrol >= 1 & franchise_id == .
replace franchise_id2 = 268 if Carepatrol >= 1 & franchise_id != .
replace franchise_id3 = 268 if Carepatrol >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Carepatrol >= 1
drop 	Carepatrol   

gen 	Goddard_School = strpos(lower(employer), "goddard school")
replace franchise_id  = 269 if Goddard_School >= 1 & franchise_id == .
replace franchise_id2 = 269 if Goddard_School >= 1 & franchise_id != .
replace franchise_id3 = 269 if Goddard_School >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Goddard_School >= 1
drop 	Goddard_School 

gen 	Kiddie_Academy = strpos(lower(employer), "kiddie academy")
replace franchise_id  = 270 if Kiddie_Academy >= 1 & franchise_id == .
replace franchise_id2 = 270 if Kiddie_Academy >= 1 & franchise_id != .
replace franchise_id3 = 270 if Kiddie_Academy >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Kiddie_Academy >= 1
drop 	Kiddie_Academy

gen 	Pump_It_Up = strpos(lower(employer), "pump it up")
replace franchise_id  = 271 if Pump_It_Up >= 1 & franchise_id == .
replace franchise_id2 = 271 if Pump_It_Up >= 1 & franchise_id != .
replace franchise_id3 = 271 if Pump_It_Up >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Pump_It_Up >= 1
drop 	Pump_It_Up

gen 	Anytime_Fitness = strpos(lower(employer), "anytime fitness") | strpos(lower(employer), "anytimefit") | strpos(lower(employer), "any time fit")
replace franchise_id  = 272 if Anytime_Fitness >= 1 & franchise_id == .
replace franchise_id2 = 272 if Anytime_Fitness >= 1 & franchise_id != .
replace franchise_id3 = 272 if Anytime_Fitness >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Anytime_Fitness >= 1
drop 	Anytime_Fitness 

gen 	Crunch_Gym = strpos(lower(employer), "crunch fit") | strpos(lower(employer), "crunch gym")
replace franchise_id  = 273 if Crunch_Gym >= 1 & franchise_id == .
replace franchise_id2 = 273 if Crunch_Gym >= 1 & franchise_id != .
replace franchise_id3 = 273 if Crunch_Gym >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Crunch_Gym >= 1
drop 	Crunch_Gym

gen 	Curves = 	  strpos(lower(employer), "curves")
replace Curves = 0 if strpos(lower(employer), "&")
replace Curves = 0 if strpos(lower(employer), "rock your")
replace Curves = 0 if strpos(lower(employer), "information")
replace Curves = 0 if strpos(lower(employer), "just the right")
replace Curves = 0 if strpos(employer, "Angel Curves") 							
replace Curves = 0 if strpos(employer, "Bell Curves") 							
replace Curves = 0 if strpos(employer, "Cali Curves Colombian Fajas") 			
replace Curves = 0 if strpos(employer, "Carolina Curves Incorporated") 			
replace Curves = 0 if strpos(employer, "Covermycurves") 						
replace Curves = 0 if strpos(employer, "Curves And Gains Fitness") 				
replace Curves = 0 if strpos(employer, "Curves And More, Llc") 					
replace Curves = 0 if strpos(employer, "Curves And Champagne") 					
replace Curves = 0 if strpos(employer, "Curves Cabaret") 						
replace Curves = 0 if strpos(employer, "Curves Gentlemen's Club") 				
replace Curves = 0 if strpos(employer, "Curves Hair Studio") 					
replace Curves = 0 if strpos(employer, "Dangerous Curves Club") 				
replace Curves = 0 if strpos(employer, "Flaunt Your Curves Boutique") 			
replace Curves = 0 if strpos(employer, "Fuego Curves") 							
replace Curves = 0 if strpos(employer, "Hilo Curves For Women") 				
replace Curves = 0 if strpos(employer, "Hips Curves") 							
replace Curves = 0 if strpos(employer, "He Loves Curves Boutique") 				
replace Curves = 0 if strpos(employer, "Learning Curves Driving School") 		
replace Curves = 0 if strpos(employer, "Luxx Curves") 							
replace Curves = 0 if strpos(employer, "New Curves Recovery") 					
replace Curves = 0 if strpos(employer, "Perfect Curves Laser Lipo Center") 		
replace Curves = 0 if strpos(employer, "Pretty Girl Curves") 					
replace Curves = 0 if strpos(employer, "Squarecurves Studio") 					
replace franchise_id  = 274 if Curves >= 1 & franchise_id == .
replace franchise_id2 = 274 if Curves >= 1 & franchise_id != .
replace franchise_id3 = 274 if Curves >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Curves >= 1
drop 	Curves

gen 	Fit_Body = 		strpos(lower(employer), "fit body")
replace Fit_Body = 0 if strpos(employer, "Fit Body Bistro") 					
replace Fit_Body = 0 if strpos(employer, "Fit Body Pod") 						
replace Fit_Body = 0 if strpos(employer, "Fit Body Weight Loss") 				
replace Fit_Body = 0 if strpos(employer, "Benefit Body") 						
replace Fit_Body = 0 if strpos(employer, "Certi Fit Body Parts") 				
replace Fit_Body = 0 if strpos(employer, "Fast Fit Body Sculpting") 			
replace Fit_Body = 0 if strpos(employer, "Fit Body Energy") 					
replace Fit_Body = 0 if strpos(employer, "Fit Body Leads") 						
replace Fit_Body = 0 if strpos(employer, "Superior Fit Body") 					
replace Fit_Body = 0 if strpos(employer, "The Fit Body Lab") 					
replace Fit_Body = 0 if strpos(employer, "Wasatch Fit Body") 					
replace Fit_Body = 0 if strpos(employer, "Superior Fit Body") 					
replace franchise_id  = 275 if Fit_Body >= 1 & franchise_id == .
replace franchise_id2 = 275 if Fit_Body >= 1 & franchise_id != .
replace franchise_id3 = 275 if Fit_Body >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Fit_Body >= 1
drop 	Fit_Body

gen 	Fitness_Together = strpos(lower(employer), "fitness together")
replace franchise_id  = 276 if Fitness_Together >= 1 & franchise_id == .
replace franchise_id2 = 276 if Fitness_Together >= 1 & franchise_id != .
replace franchise_id3 = 276 if Fitness_Together >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Fitness_Together >= 1
drop 	Fitness_Together

gen 	Golds_Gym = strpos(lower(employer), "gold's gym") | strpos(lower(employer), "golds gym")
replace franchise_id  = 277 if Golds_Gym >= 1 & franchise_id == .
replace franchise_id2 = 277 if Golds_Gym >= 1 & franchise_id != .
replace franchise_id3 = 277 if Golds_Gym >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Golds_Gym >= 1
drop 	Golds_Gym 

gen 	ILoveKickBoxing = 	   strpos(lower(employer), "i love kick") | strpos(lower(employer), "ilovekick") | strpos(lower(employer), "ilkb") 
replace ILoveKickBoxing = 0 if strpos(employer, "Big Heart Pet Brands Milkbone") 
replace ILoveKickBoxing = 0 if strpos(employer, "Jojo's Milkbar") 				
replace ILoveKickBoxing = 0 if strpos(employer, "Milkbean") 					
replace ILoveKickBoxing = 0 if strpos(employer, "Milkbox Ice Creamery") 		
replace ILoveKickBoxing = 0 if strpos(employer, "Milkboy") 						
replace franchise_id  = 278 if ILoveKickBoxing >= 1 & franchise_id == .
replace franchise_id2 = 278 if ILoveKickBoxing >= 1 & franchise_id != .
replace franchise_id3 = 278 if ILoveKickBoxing >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if ILoveKickBoxing >= 1
drop 	ILoveKickBoxing

gen 	Jazzercise = strpos(lower(employer), "jazzercise")
replace franchise_id  = 279 if Jazzercise >= 1 & franchise_id == .
replace franchise_id2 = 279 if Jazzercise >= 1 & franchise_id != .
replace franchise_id3 = 279 if Jazzercise >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Jazzercise >= 1
drop 	Jazzercise

gen 	Little_Gym = strpos(lower(employer), "little gym") | strpos(lower(employer), "littlegym")
replace franchise_id  = 280 if Little_Gym >= 1 & franchise_id == .
replace franchise_id2 = 280 if Little_Gym >= 1 & franchise_id != .
replace franchise_id3 = 280 if Little_Gym >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Little_Gym >= 1
drop 	Little_Gym

gen 	Nine_Round = strpos(lower(employer), "9 round") | strpos(lower(employer), "9round")
replace franchise_id  = 281 if Nine_Round >= 1 & franchise_id == .
replace franchise_id2 = 281 if Nine_Round >= 1 & franchise_id != .
replace franchise_id3 = 281 if Nine_Round >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Nine_Round >= 1
drop 	Nine_Round

gen 	Parisi = 	  strpos(lower(employer), "parisi ")
replace Parisi = 0 if strpos(lower(employer), "insurance")
replace Parisi = 0 if strpos(lower(employer), "rk par")
replace Parisi = 0 if strpos(lower(employer), "inc")
replace Parisi = 0 if strpos(employer, "Parisi & Bellavia Llp") 				
replace Parisi = 0 if strpos(employer, "Parisi Cafe Union Station") 			
replace Parisi = 0 if strpos(employer, "Parisi Dental") 						
replace Parisi = 0 if strpos(employer, "Parisi Family Dentistry") 				
replace Parisi = 0 if strpos(employer, "Parisi Healthcare Management") 			
replace Parisi = 0 if strpos(employer, "Parisi House On The Hill") 				
replace Parisi = 0 if strpos(employer, "Champagne And Parisi Real Estate") 		
replace Parisi = 0 if strpos(employer, "Jennifer Parisi At Ferring Com") 		
replace Parisi = 0 if strpos(employer, "Mike Parisi Tax Consultants") 			
replace Parisi = 0 if strpos(employer, "Mindy Parisi Design") 					
replace franchise_id  = 282 if Parisi >= 1 & franchise_id == .
replace franchise_id2 = 282 if Parisi >= 1 & franchise_id != .
replace franchise_id3 = 282 if Parisi >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Parisi >= 1
drop 	Parisi

gen 	Planet_Fitness = strpos(lower(employer), "planet fitness")
replace franchise_id  = 283 if Planet_Fitness >= 1 & franchise_id == .
replace franchise_id2 = 283 if Planet_Fitness >= 1 & franchise_id != .
replace franchise_id3 = 283 if Planet_Fitness >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Planet_Fitness >= 1
drop 	Planet_Fitness 

gen 	Pure_Barre = strpos(lower(employer), "pure barre")
replace franchise_id  = 284 if Pure_Barre >= 1 & franchise_id == .
replace franchise_id2 = 284 if Pure_Barre >= 1 & franchise_id != .
replace franchise_id3 = 284 if Pure_Barre >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Pure_Barre >= 1
drop 	Pure_Barre 

gen 	Retro_Fitness = strpos(lower(employer), "retro fitness") | strpos(lower(employer), "retrofitness")
replace franchise_id  = 285 if Retro_Fitness >= 1 & franchise_id == .
replace franchise_id2 = 285 if Retro_Fitness >= 1 & franchise_id != .
replace franchise_id3 = 285 if Retro_Fitness >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Retro_Fitness >= 1
drop 	Retro_Fitness

gen 	Sky_Zone = strpos(lower(employer), "sky zone") | strpos(lower(employer), "skyzone") | strpos(lower(employer), "circustrix")
replace franchise_id  = 286 if Sky_Zone >= 1 & franchise_id == .
replace franchise_id2 = 286 if Sky_Zone >= 1 & franchise_id != .
replace franchise_id3 = 286 if Sky_Zone >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Sky_Zone >= 1
drop 	Sky_Zone

gen 	Snap_Fitness = strpos(lower(employer), "snap fitness")
replace franchise_id  = 287 if Snap_Fitness >= 1 & franchise_id == .
replace franchise_id2 = 287 if Snap_Fitness >= 1 & franchise_id != .
replace franchise_id3 = 287 if Snap_Fitness >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Snap_Fitness >= 1
drop 	Snap_Fitness

gen 	Total_Body = strpos(lower(employer), "title boxing club") | strpos(lower(employer), "tbc international")
replace franchise_id  = 288 if Total_Body >= 1 & franchise_id == .
replace franchise_id2 = 288 if Total_Body >= 1 & franchise_id != .
replace franchise_id3 = 288 if Total_Body >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Total_Body >= 1
drop 	Total_Body 

gen 	Bar_Method = strpos(lower(employer), "bar method")
replace franchise_id  = 289 if Bar_Method >= 1 & franchise_id == .
replace franchise_id2 = 289 if Bar_Method >= 1 & franchise_id != .
replace franchise_id3 = 289 if Bar_Method >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Bar_Method >= 1
drop 	Bar_Method

gen 	Tiger_Martial_Arts = 	  strpos(lower(employer), "tiger martial") | strpos(lower(employer), "tiger rock") | strpos(lower(employer), "tiger-rock") 
replace Tiger_Martial_Arts = 0 if strpos(employer, "3 Tiger Martial Arts Corp") 
replace Tiger_Martial_Arts = 0 if strpos(employer, "Godlen Tiger Martial Arts") 
replace Tiger_Martial_Arts = 0 if strpos(employer, "J H Kim's White Tiger Martial Arts, Inc") 
replace Tiger_Martial_Arts = 0 if strpos(employer, "J Tiger Martial Arts") 		
replace Tiger_Martial_Arts = 0 if strpos(employer, "King Tiger Martial Arts Incorporated") 	  
replace Tiger_Martial_Arts = 0 if strpos(employer, "Korean Tiger Martial Arts") 
replace Tiger_Martial_Arts = 0 if strpos(employer, "Liberty Tiger Martial Arts Academy") 	  
replace Tiger_Martial_Arts = 0 if strpos(employer, "Master Carey's Tiger Martial Arts") 	  
replace Tiger_Martial_Arts = 0 if strpos(employer, "White Tiger Martial Arts") 	
replace Tiger_Martial_Arts = 0 if strpos(employer, "Us Tiger Martial Arts") 	
replace franchise_id  = 290 if Tiger_Martial_Arts >= 1 & franchise_id == .
replace franchise_id2 = 290 if Tiger_Martial_Arts >= 1 & franchise_id != .
replace franchise_id3 = 290 if Tiger_Martial_Arts >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Tiger_Martial_Arts >= 1
drop 	Tiger_Martial_Arts 

gen 	Ufc_Gym = strpos(lower(employer), "ufc gym")
replace franchise_id  = 291 if Ufc_Gym >= 1 & franchise_id == .
replace franchise_id2 = 291 if Ufc_Gym >= 1 & franchise_id != .
replace franchise_id3 = 291 if Ufc_Gym >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Ufc_Gym >= 1
drop 	Ufc_Gym

gen 	Ultimate_Fitness = 		strpos(lower(employer), "ultimate fit") | strpos(lower(employer), "orange theory") | strpos(lower(employer), "orangetheory")
replace Ultimate_Fitness = 0 if strpos(employer, "Ultimate Fit Shoes & Home Fitness Equipment") 
replace Ultimate_Fitness = 0 if strpos(employer, "The Punch House ' Ultimate Fitness Gym'") 	
replace Ultimate_Fitness = 0 if strpos(employer, "The Hook The Ultimate Fitness For Women") 	
replace franchise_id  = 292 if Ultimate_Fitness >= 1 & franchise_id == .
replace franchise_id2 = 292 if Ultimate_Fitness >= 1 & franchise_id != .
replace franchise_id3 = 292 if Ultimate_Fitness >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Ultimate_Fitness >= 1
drop 	Ultimate_Fitness

gen 	Workout_Anytime = strpos(lower(employer), "workout anytime")
replace franchise_id  = 293 if Workout_Anytime >= 1 & franchise_id == .
replace franchise_id2 = 293 if Workout_Anytime >= 1 & franchise_id != .
replace franchise_id3 = 293 if Workout_Anytime >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Workout_Anytime >= 1
drop 	Workout_Anytime

gen 	World_Gym = 	 strpos(lower(employer), "world gym") | strpos(lower(employer), "worldgym") 
replace World_Gym = 0 if strpos(employer, "World Gymnastics Academy Incorporated") 
replace World_Gym = 0 if strpos(employer, "Kids World Gymnastics") 				
replace franchise_id  = 294 if World_Gym >= 1 & franchise_id == .
replace franchise_id2 = 294 if World_Gym >= 1 & franchise_id != .
replace franchise_id3 = 294 if World_Gym >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if World_Gym >= 1
drop 	World_Gym 

gen 	Redline_Sports = 	  strpos(lower(employer), "koko fit") | strpos(lower(employer), "kokofit") | strpos(lower(employer), "xpress fit") | strpos(lower(employer), "xpress gym") 
replace Redline_Sports = 0 if strpos(employer, "Redline Hot Shot & Transportation Llc") 
replace Redline_Sports = 0 if strpos(employer, "Redline Motorsports") 			
replace Redline_Sports = 0 if strpos(employer, "Redline Motosports") 			
replace Redline_Sports = 0 if strpos(employer, "Redline Powersports") 			
replace Redline_Sports = 0 if strpos(employer, "Redline Sport And Marine") 		
replace Redline_Sports = 0 if strpos(employer, "Redline Watersports") 			
replace Redline_Sports = 0 if strpos(employer, "Vpx Sports/Redline") 			
replace Redline_Sports = 0 if strpos(employer, "Aerial Express Gymnastics") 	
replace franchise_id  = 295 if Redline_Sports >= 1 & franchise_id == .
replace franchise_id2 = 295 if Redline_Sports >= 1 & franchise_id != .
replace franchise_id3 = 295 if Redline_Sports >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Redline_Sports >= 1
drop 	Redline_Sports  

gen 	Amazing_Athletes = strpos(lower(employer), "amazing athletes") | strpos(lower(employer), "amazing warrior") 
replace franchise_id  = 296 if Amazing_Athletes >= 1 & franchise_id == .
replace franchise_id2 = 296 if Amazing_Athletes >= 1 & franchise_id != .
replace franchise_id3 = 296 if Amazing_Athletes >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Amazing_Athletes >= 1
drop 	Amazing_Athletes

gen 	I9_Sports = strpos(lower(employer), "i9 sports") | strpos(lower(employer), "i9sports") 
replace franchise_id  = 297 if I9_Sports >= 1 & franchise_id == .
replace franchise_id2 = 297 if I9_Sports >= 1 & franchise_id != .
replace franchise_id3 = 297 if I9_Sports >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if I9_Sports >= 1
drop 	I9_Sports

gen 	Skyhawks = 		strpos(lower(employer), "skyhawks")
replace Skyhawks = 0 if strpos(employer, "G League Skyhawks") 					
replace franchise_id  = 298 if Skyhawks >= 1 & franchise_id == .
replace franchise_id2 = 298 if Skyhawks >= 1 & franchise_id != .
replace franchise_id3 = 298 if Skyhawks >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Skyhawks >= 1
drop 	Skyhawks 

gen 	United_Soccer_Leagues = strpos(lower(employer), "united soccer lea")
replace franchise_id  = 299 if United_Soccer_Leagues >= 1 & franchise_id == .
replace franchise_id2 = 299 if United_Soccer_Leagues >= 1 & franchise_id != .
replace franchise_id3 = 299 if United_Soccer_Leagues >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if United_Soccer_Leagues >= 1
drop 	United_Soccer_Leagues

gen 	Americinn = strpos(lower(employer), "americinn") | strpos(lower(employer), "americ inn")
replace franchise_id  = 300 if Americinn >= 1 & franchise_id == .
replace franchise_id2 = 300 if Americinn >= 1 & franchise_id != .
replace franchise_id3 = 300 if Americinn >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Americinn >= 1
drop 	Americinn 

gen 	Ascend_Hotels = strpos(lower(employer), "ascend hotel")
replace franchise_id  = 301 if Ascend_Hotels >= 1 & franchise_id == .
replace franchise_id2 = 301 if Ascend_Hotels >= 1 & franchise_id != .
replace franchise_id3 = 301 if Ascend_Hotels >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Ascend_Hotels >= 1
drop 	Ascend_Hotels 

gen 	Baymont_Inn = strpos(lower(employer), "baymont inn")
replace franchise_id  = 302 if Baymont_Inn >= 1 & franchise_id == .
replace franchise_id2 = 302 if Baymont_Inn >= 1 & franchise_id != .
replace franchise_id3 = 302 if Baymont_Inn >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Baymont_Inn >= 1
drop 	Baymont_Inn 

gen 	Candlewood_Suites = strpos(lower(employer), "candlewood suites") | strpos(lower(employer), "candle wood suites")
replace franchise_id  = 303 if Candlewood_Suites >= 1 & franchise_id == .
replace franchise_id2 = 303 if Candlewood_Suites >= 1 & franchise_id != .
replace franchise_id3 = 303 if Candlewood_Suites >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Candlewood_Suites >= 1
drop 	Candlewood_Suites

gen 	Clarion_Hotel = strpos(lower(employer), "clarion hotel") | strpos(lower(employer), "clarion inn") | strpos(lower(employer), "clarioninn")
replace franchise_id  = 304 if Clarion_Hotel >= 1 & franchise_id == .
replace franchise_id2 = 304 if Clarion_Hotel >= 1 & franchise_id != .
replace franchise_id3 = 304 if Clarion_Hotel >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Clarion_Hotel >= 1
drop 	Clarion_Hotel

gen 	Comfort_Inn = strpos(lower(employer), "comfort inn") | strpos(lower(employer), "comfortinn")
replace franchise_id  = 305 if Comfort_Inn >= 1 & franchise_id == .
replace franchise_id2 = 305 if Comfort_Inn >= 1 & franchise_id != .
replace franchise_id3 = 305 if Comfort_Inn >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Comfort_Inn >= 1
drop 	Comfort_Inn

gen 	Country_Inn = strpos(lower(employer), "country inn") & strpos(lower(employer), "suites") 
replace franchise_id  = 306 if Country_Inn >= 1 & franchise_id == .
replace franchise_id2 = 306 if Country_Inn >= 1 & franchise_id != .
replace franchise_id3 = 306 if Country_Inn >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Country_Inn >= 1
drop 	Country_Inn

gen 	Days_Inn = 		strpos(lower(employer), "days inn") | strpos(lower(employer), "daysinn")
replace Days_Inn = 0 if strpos(employer, "Country Holidays Inn & Suites") 		
replace franchise_id  = 307 if Days_Inn >= 1 & franchise_id == .
replace franchise_id2 = 307 if Days_Inn >= 1 & franchise_id != .
replace franchise_id3 = 307 if Days_Inn >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Days_Inn >= 1
drop 	Days_Inn 

gen 	Double_Tree = 	   strpos(lower(employer), "double tree") | strpos(lower(employer), "doubletree")
replace Double_Tree = 0 if strpos(employer, "Double Tree Castle Incorporated") 	
replace franchise_id  = 308 if Double_Tree >= 1 & franchise_id == .
replace franchise_id2 = 308 if Double_Tree >= 1 & franchise_id != .
replace franchise_id3 = 308 if Double_Tree >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Double_Tree >= 1
drop 	Double_Tree

gen 	Econolodge 	 = strpos(lower(employer), "econolodge") | strpos(lower(employer), "econo lodge")
replace franchise_id  = 309 if Econolodge >= 1 & franchise_id == .
replace franchise_id2 = 309 if Econolodge >= 1 & franchise_id != .
replace franchise_id3 = 309 if Econolodge >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Econolodge >= 1
drop 	Econolodge

gen 	Embassy_Suites = strpos(lower(employer), "embassy suites") | strpos(lower(employer), "embassysuites")
replace franchise_id  = 310 if Embassy_Suites >= 1 & franchise_id == .
replace franchise_id2 = 310 if Embassy_Suites >= 1 & franchise_id != .
replace franchise_id3 = 310 if Embassy_Suites >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Embassy_Suites >= 1
drop 	Embassy_Suites

gen 	Four_Points = 	   strpos(lower(employer), "four points")
replace Four_Points = 0 if strpos(lower(employer), "media") | strpos(lower(employer), "communication") | ///
						   strpos(lower(employer), "tech")  | strpos(lower(employer), "auto")
replace Four_Points = 0 if strpos(employer, "Four Points Aero Services") 		
replace Four_Points = 0 if strpos(employer, "Four Points Health") 				
replace Four_Points = 0 if strpos(employer, "Four Points Handyman") 			
replace Four_Points = 0 if strpos(employer, "Four Points Federal Credi") 		
replace Four_Points = 0 if strpos(employer, "Four Points Installations, Inc") 	
replace Four_Points = 0 if strpos(employer, "Four Points Property Management, Llc") 
replace Four_Points = 0 if strpos(employer, "Four Points Real Estate") 			
replace Four_Points = 0 if strpos(employer, "Four Points Standard Inc") 		
replace Four_Points = 0 if strpos(employer, "Four Points Stonebridge Companies") 
replace Four_Points = 0 if strpos(employer, "Four Points Youth Camp Llc") 		
replace Four_Points = 0 if strpos(employer, "Apartment Homes By Tonti") 		
replace Four_Points = 0 if strpos(employer, "Four Paws At Four Points") 		
replace Four_Points = 0 if strpos(employer, "Four Points Bbq & Brewing") 		
replace Four_Points = 0 if strpos(employer, "Four Points Cable Resources") 		
replace Four_Points = 0 if strpos(employer, "Four Points Capital Partners") 	
replace Four_Points = 0 if strpos(employer, "Four Points Contractors") 			
replace Four_Points = 0 if strpos(employer, "Four Points Dental Studio") 		
replace Four_Points = 0 if strpos(employer, "Four Points Family Chiropractic") 	
replace Four_Points = 0 if strpos(employer, "Orangetheory Fitness Four Points") 
replace Four_Points = 0 if strpos(employer, "Orangetheory Fitness Lakeway") 	
replace Four_Points = 0 if strpos(employer, "Primrose School Of Four Points") 	
replace franchise_id  = 311 if Four_Points >= 1 & franchise_id == .
replace franchise_id2 = 311 if Four_Points >= 1 & franchise_id != .
replace franchise_id3 = 311 if Four_Points >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Four_Points >= 1
drop 	Four_Points

gen 	Hampton_Inn = 	   strpos(lower(employer), "hampton inn")
replace Hampton_Inn = 0 if strpos(employer, "Southampton Inn") 					
replace franchise_id  = 312 if Hampton_Inn >= 1 & franchise_id == .
replace franchise_id2 = 312 if Hampton_Inn >= 1 & franchise_id != .
replace franchise_id3 = 312 if Hampton_Inn >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Hampton_Inn >= 1
drop 	Hampton_Inn

gen 	Hawthorne_Hotel = strpos(lower(employer), "hawthorne hotel") | strpos(lower(employer), "hawthorne suite")
replace franchise_id  = 313 if Hawthorne_Hotel >= 1 & franchise_id == .
replace franchise_id2 = 313 if Hawthorne_Hotel >= 1 & franchise_id != .
replace franchise_id3 = 313 if Hawthorne_Hotel >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Hawthorne_Hotel >= 1
drop 	Hawthorne_Hotel

gen 	Hilton_Garden_Inn = 	 strpos(lower(employer), "h") & strpos(lower(employer), "garden inn") 
replace Hilton_Garden_Inn = 0 if strpos(employer, "By Wyndham") 				
replace Hilton_Garden_Inn = 0 if strpos(employer, "Wyndham Garden Inn") 		
replace Hilton_Garden_Inn = 0 if strpos(employer, "Los Gatos Garden Inn Hotel") 
replace Hilton_Garden_Inn = 0 if strpos(employer, "Wintergarden Inn Inc") 		
replace Hilton_Garden_Inn = 0 if strpos(employer, "Spanish Garden Inn") 		
replace franchise_id  = 314 if Hilton_Garden_Inn >= 1 & franchise_id == .
replace franchise_id2 = 314 if Hilton_Garden_Inn >= 1 & franchise_id != .
replace franchise_id3 = 314 if Hilton_Garden_Inn >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Hilton_Garden_Inn >= 1
drop 	Hilton_Garden_Inn

gen 	Hilton = strpos(lower(employer), "hilton") & strpos(lower(employer), "hotel")
replace franchise_id  = 315 if Hilton >= 1 & franchise_id == .
replace franchise_id2 = 315 if Hilton >= 1 & franchise_id != .
replace franchise_id3 = 315 if Hilton >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Hilton >= 1
drop 	Hilton

gen 	Holiday_Inn = strpos(lower(employer), "holidayinn") | strpos(lower(employer), "holiday inn")
replace franchise_id  = 316 if Holiday_Inn >= 1 & franchise_id == .
replace franchise_id2 = 316 if Holiday_Inn >= 1 & franchise_id != .
replace franchise_id3 = 316 if Holiday_Inn >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Holiday_Inn >= 1
drop 	Holiday_Inn

gen 	Homewood_Suites = strpos(lower(employer), "homewood suite") | strpos(lower(employer), "home wood suite") 
replace franchise_id  = 317 if Homewood_Suites >= 1 & franchise_id == .
replace franchise_id2 = 317 if Homewood_Suites >= 1 & franchise_id != .
replace franchise_id3 = 317 if Homewood_Suites >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Homewood_Suites >= 1
drop 	Homewood_Suites

gen 	Hospitality_International = strpos(lower(employer), "scottish inn") | strpos(lower(employer), "red carpet inn") | strpos(lower(employer), "hospitality international")
replace franchise_id  = 318 if Hospitality_International >= 1 & franchise_id == .
replace franchise_id2 = 318 if Hospitality_International >= 1 & franchise_id != .
replace franchise_id3 = 318 if Hospitality_International >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Hospitality_International >= 1
drop 	Hospitality_International

gen 	Howard_Johnsons = strpos(lower(employer), "howard johnson")
replace franchise_id  = 319 if Howard_Johnsons >= 1 & franchise_id == .
replace franchise_id2 = 319 if Howard_Johnsons >= 1 & franchise_id != .
replace franchise_id3 = 319 if Howard_Johnsons >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Howard_Johnsons >= 1
drop 	Howard_Johnsons

gen 	Hyatt = 	 strpos(lower(employer), "hyatt")
replace Hyatt = 0 if strpos(lower(employer), "hyattsville")
replace Hyatt = 0 if strpos(lower(employer), "hyattadultdayhomecare")			
replace Hyatt = 0 if strpos(lower(employer), "hyattward advertising")			
replace Hyatt = 0 if strpos(lower(employer), "Gilhyatt Construction")			
replace franchise_id  = 320 if Hyatt >= 1 & franchise_id == .
replace franchise_id2 = 320 if Hyatt >= 1 & franchise_id != .
replace franchise_id3 = 320 if Hyatt >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Hyatt >= 1
drop 	Hyatt

gen 	Knights_Inn = strpos(lower(employer), "knights inn") | strpos(lower(employer), "knightsinn") | strpos(lower(employer), "knights franchise system")
replace franchise_id  = 321 if Knights_Inn >= 1 & franchise_id == .
replace franchise_id2 = 321 if Knights_Inn >= 1 & franchise_id != .
replace franchise_id3 = 321 if Knights_Inn >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Knights_Inn >= 1
drop 	Knights_Inn  

gen 	La_Quinta = strpos(lower(employer), "laquinta") | strpos(lower(employer), "la quinta")
replace franchise_id  = 322 if La_Quinta >= 1 & franchise_id == .
replace franchise_id2 = 322 if La_Quinta >= 1 & franchise_id != .
replace franchise_id3 = 322 if La_Quinta >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if La_Quinta >= 1
drop 	La_Quinta

gen 	Microtel = 		strpos(lower(employer), "microtel")
replace Microtel = 0 if strpos(lower(employer), "microtelematics")
replace Microtel = 0 if strpos(employer, "Big River Inn & Suites Formerly Microtel") 
replace Microtel = 0 if strpos(employer, "Monroe Heights Hotel Formerly Microtel")	 
replace franchise_id  = 323 if Microtel >= 1 & franchise_id == .
replace franchise_id2 = 323 if Microtel >= 1 & franchise_id != .
replace franchise_id3 = 323 if Microtel >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Microtel >= 1
drop 	Microtel

gen 	Motel_6 = strpos(lower(employer), "motel 6") | strpos(lower(employer), "motel6")
replace franchise_id  = 324 if Motel_6 >= 1 & franchise_id == .
replace franchise_id2 = 324 if Motel_6 >= 1 & franchise_id != .
replace franchise_id3 = 324 if Motel_6 >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Motel_6 >= 1
drop 	Motel_6 

gen 	Quality_Inn = 	   strpos(lower(employer), "quality inn") | strpos(lower(employer), "qualityinn") 
replace Quality_Inn = 0 if strpos(employer, "Quality Innovation")				
replace Quality_Inn = 0 if strpos(employer, "Health Quality Innovators")		
replace Quality_Inn = 0 if strpos(employer, "Magnuson Hotel Formerly Quality Inn") 
replace franchise_id  = 325 if Quality_Inn >= 1 & franchise_id == .
replace franchise_id2 = 325 if Quality_Inn >= 1 & franchise_id != .
replace franchise_id3 = 325 if Quality_Inn >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Quality_Inn >= 1
drop 	Quality_Inn

gen 	Radisson = strpos(lower(employer), "radisson")
replace franchise_id  = 326 if Radisson >= 1 & franchise_id == .
replace franchise_id2 = 326 if Radisson >= 1 & franchise_id != .
replace franchise_id3 = 326 if Radisson >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Radisson >= 1
drop 	Radisson

gen 	Ramada = lower(employer) == "ramada"
replace franchise_id  = 327 if Ramada >= 1 & franchise_id == .
replace franchise_id2 = 327 if Ramada >= 1 & franchise_id != .
replace franchise_id3 = 327 if Ramada >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Ramada >= 1
drop 	Ramada

gen 	Red_Roof = 		strpos(lower(employer), "red roof")
replace Red_Roof = 0 if strpos(lower(employer), "roofing") 						
replace Red_Roof = 0 if strpos(lower(employer), "animal") 						
replace Red_Roof = 0 if strpos(lower(employer), "cleaning") 					
replace Red_Roof = 0 if strpos(lower(employer), "preferred roof") 				
replace Red_Roof = 0 if strpos(lower(employer), "roofer") 						
replace Red_Roof = 0 if strpos(employer, "American Louvered Roof") 				
replace Red_Roof = 0 if strpos(employer, "Red Roof Fast Lube") 					
replace Red_Roof = 0 if strpos(employer, "Red Roof Groceries") 					
replace franchise_id  = 328 if Red_Roof >= 1 & franchise_id == .
replace franchise_id2 = 328 if Red_Roof >= 1 & franchise_id != .
replace franchise_id3 = 328 if Red_Roof >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Red_Roof >= 1
drop 	Red_Roof  

gen		Rodeway = 	   strpos(lower(employer), "rodeway")
replace Rodeway = 0 if strpos(employer, "Rodeway Iris Garden Inn") 				
replace franchise_id  = 329 if Rodeway >= 1 & franchise_id == .
replace franchise_id2 = 329 if Rodeway >= 1 & franchise_id != .	
replace franchise_id3 = 329 if Rodeway >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Rodeway >= 1
drop 	Rodeway

gen 	Sleep_Inn = 	 strpos(lower(employer), "sleep inn") | strpos(lower(employer), "sleepinn") 
replace Sleep_Inn = 0 if strpos(lower(employer), "innovation")
replace Sleep_Inn = 0 if strpos(employer, "Rogelio's Dine And Sleep Inn") 		
replace franchise_id  = 330 if Sleep_Inn >= 1 & franchise_id == .
replace franchise_id2 = 330 if Sleep_Inn >= 1 & franchise_id != .
replace franchise_id3 = 330 if Sleep_Inn >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Sleep_Inn >= 1
drop 	Sleep_Inn

gen 	Staybridge = 	  strpos(lower(employer), "staybridge") | strpos(lower(employer), "stay bridge") 
replace Staybridge = 0 if strpos(employer, "Sleep Inn & Mainstay Bridgeton") 	
replace franchise_id  = 331 if Staybridge >= 1 & franchise_id == .
replace franchise_id2 = 331 if Staybridge >= 1 & franchise_id != .
replace franchise_id3 = 331 if Staybridge >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Staybridge >= 1
drop 	Staybridge

gen 	Studio_6 = 		strpos(lower(employer), "studio 6") | strpos(lower(employer), "studio6")
replace Studio_6 = 0 if strpos(lower(employer), "66") | strpos(lower(employer), "65") | strpos(lower(employer), "613") | strpos(lower(employer), "63") | strpos(lower(employer), "6a")
replace Studio_6 = 0 if strpos(employer, "Studio 618 Salon")					
replace Studio_6 = 0 if strpos(employer, "Studio 60 Bodybrite")					
replace Studio_6 = 0 if strpos(employer, "Studio 61 Dance Company")				
replace Studio_6 = 0 if strpos(employer, "Studio 670")							
replace Studio_6 = 0 if strpos(employer, "Studio 68 Fitness")					
replace Studio_6 = 0 if strpos(employer, "Allure Hair Studio 68")				
replace Studio_6 = 0 if strpos(employer, "Estudio 67")							
replace Studio_6 = 0 if strpos(employer, "Studio 60")							
replace Studio_6 = 0 if strpos(employer, "Studio 6Mm")							
replace Studio_6 = 0 if strpos(employer, "The Studio 605")						
replace franchise_id  = 332 if Studio_6 >= 1 & franchise_id == .
replace franchise_id2 = 332 if Studio_6 >= 1 & franchise_id != .
replace franchise_id3 = 332 if Studio_6 >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Studio_6 >= 1
drop 	Studio_6

gen 	Super_8 = strpos(lower(employer), "super 8") | strpos(lower(employer), "super eight") | strpos(lower(employer), "super8")
replace franchise_id  = 333 if Super_8 >= 1 & franchise_id == .
replace franchise_id2 = 333 if Super_8 >= 1 & franchise_id != .
replace franchise_id3 = 333 if Super_8 >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Super_8 >= 1
drop 	Super_8  

gen 	Sheraton = strpos(lower(employer), "sheraton")
replace franchise_id  = 334 if Sheraton >= 1 & franchise_id == .
replace franchise_id2 = 334 if Sheraton >= 1 & franchise_id != .
replace franchise_id3 = 334 if Sheraton >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Sheraton >= 1
drop 	Sheraton

gen 	Travelodge = 	  strpos(lower(employer), "travelodge") | strpos(lower(employer), "travel lodge")
replace Travelodge = 0 if strpos(employer, "Work And Travel Lodge")				
replace franchise_id  = 335 if Travelodge >= 1 & franchise_id == .
replace franchise_id2 = 335 if Travelodge >= 1 & franchise_id != .
replace franchise_id3 = 335 if Travelodge >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Travelodge >= 1
drop 	Travelodge

gen 	Value_Place = 	   strpos(lower(employer), "value place") | strpos(lower(employer), "valueplace") | strpos(lower(employer), "woodspring")
replace Value_Place = 0 if strpos(employer, "Kentwoodsprings")					
replace Value_Place = 0 if strpos(employer, "Woodspring Apartments")			
replace Value_Place = 0 if strpos(employer, "Woodspring Trophy Club")			
replace Value_Place = 0 if strpos(employer, "Woodsprings Animal Clinic")		
replace franchise_id  = 336 if Value_Place >= 1 & franchise_id == .
replace franchise_id2 = 336 if Value_Place >= 1 & franchise_id != .
replace franchise_id3 = 336 if Value_Place >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Value_Place >= 1
drop 	Value_Place

gen 	Westin = 	  strpos(lower(employer), "westin")
replace Westin = 0 if strpos(employer, "Westinghouse Electric Corporation")		
replace Westin = 0 if strpos(employer, "Westinis Inc")							
replace Westin = 0 if strpos(employer, "Westinn Kennels")						
replace Westin = 0 if strpos(employer, "Westinoutdoor")							
replace Westin = 0 if strpos(employer, "Westintrade Sro")						
replace Westin = 0 if strpos(employer, "Farwestinc")							
replace Westin = 0 if strpos(employer, "Midwestinsulators")						
replace Westin = 0 if strpos(employer, "Northwestinsurance")					
replace franchise_id  = 337 if Westin >= 1 & franchise_id == .
replace franchise_id2 = 337 if Westin >= 1 & franchise_id != .
replace franchise_id3 = 337 if Westin >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Westin >= 1
drop 	Westin

gen 	Wingate = strpos(lower(employer), "wingate by") | strpos(lower(employer), "wingate at") | strpos(lower(employer), "wingate inn") | (strpos(lower(employer), "wingate") & strpos(lower(employer), "hotel"))
replace franchise_id  = 338 if Wingate >= 1 & franchise_id == .
replace franchise_id2 = 338 if Wingate >= 1 & franchise_id != .
replace franchise_id3 = 338 if Wingate >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Wingate >= 1
drop 	Wingate  

gen 	Kampgrounds = 	   strpos(lower(employer), "kampground") | strpos(lower(employer), "kamp ground") | strpos(lower(employer), "koa")
replace Kampgrounds = 0 if strpos(employer, "Koala")							
replace Kampgrounds = 0 if strpos(employer, "Adkoa Pharmacy")					
replace Kampgrounds = 0 if strpos(employer, "Akoa")								
replace Kampgrounds = 0 if strpos(employer, "Alan Koa Salon Spa")				
replace Kampgrounds = 0 if strpos(employer, "Amkoa")							
replace Kampgrounds = 0 if strpos(employer, "Barbakoa Modern Latin Restaurant")	
replace Kampgrounds = 0 if strpos(employer, "Birch, Stewart, Koalsch & Birch, Llp")	
replace Kampgrounds = 0 if strpos(employer, "Blackoak")							
replace Kampgrounds = 0 if strpos(employer, "Dakoabilities")					
replace Kampgrounds = 0 if strpos(employer, "Ekoa")								
replace Kampgrounds = 0 if strpos(employer, "Ersai Koass")						
replace Kampgrounds = 0 if strpos(employer, "Gaskoa, Inc")						
replace Kampgrounds = 0 if strpos(employer, "Geckoarde")						
replace Kampgrounds = 0 if strpos(employer, "Hale Koa Hotel")					
replace Kampgrounds = 0 if strpos(employer, "Homo Koalis Humanity Evolved Llc") 
replace Kampgrounds = 0 if strpos(employer, "Karma Koaches")					
replace Kampgrounds = 0 if strpos(employer, "Kevlar Koatings Llc")				
replace Kampgrounds = 0 if strpos(employer, "Klassy Koach Transportation")		
replace Kampgrounds = 0 if strpos(employer, "Kekoa")							
replace Kampgrounds = 0 if strpos(employer, "Koa Cafe")							
replace Kampgrounds = 0 if strpos(employer, "Koa Capital Partners")				
replace Kampgrounds = 0 if strpos(employer, "Koa Cctv")							
replace Kampgrounds = 0 if strpos(employer, "Koa Eyewear")						
replace Kampgrounds = 0 if strpos(employer, "Koa Fitness")						
replace Kampgrounds = 0 if strpos(employer, "Koa International Inc")			
replace Kampgrounds = 0 if strpos(employer, "Koa International, Inc")			
replace Kampgrounds = 0 if strpos(employer, "Koa Kea Hotel")					
replace Kampgrounds = 0 if strpos(employer, "Koa Kenpo")						
replace Kampgrounds = 0 if strpos(employer, "Koa Networks")						
replace Kampgrounds = 0 if strpos(employer, "Koa Organic Beverages")			
replace Kampgrounds = 0 if strpos(employer, "Koa Pancake")						
replace Kampgrounds = 0 if strpos(employer, "Koa Partners")						
replace Kampgrounds = 0 if strpos(employer, "Koa Poke")							
replace Kampgrounds = 0 if strpos(employer, "Koa Restaurant")					
replace Kampgrounds = 0 if strpos(employer, "Koa Speer")						
replace Kampgrounds = 0 if strpos(employer, "Koa Sports")						
replace Kampgrounds = 0 if strpos(employer, "Koaa")								
replace Kampgrounds = 0 if strpos(employer, "Koa Trading")						
replace Kampgrounds = 0 if strpos(employer, "Koa Training")						
replace Kampgrounds = 0 if strpos(employer, "Koa Wood Restoration")				
replace Kampgrounds = 0 if strpos(employer, "Koach")							
replace Kampgrounds = 0 if strpos(employer, "Koad")								
replace Kampgrounds = 0 if strpos(employer, "Koahnic Broadcast Corporation")	
replace Kampgrounds = 0 if strpos(employer, "Koal")								
replace Kampgrounds = 0 if strpos(employer, "Koacctv")							
replace Kampgrounds = 0 if strpos(employer, "Koam")								
replace Kampgrounds = 0 if strpos(employer, "Koan")								
replace Kampgrounds = 0 if strpos(employer, "Koar")								
replace Kampgrounds = 0 if strpos(employer, "Koasati Construction Management, Llc")	
replace Kampgrounds = 0 if strpos(employer, "Koastal")							
replace Kampgrounds = 0 if strpos(employer, "Koat")								
replace Kampgrounds = 0 if strpos(employer, "Koax")								
replace Kampgrounds = 0 if strpos(employer, "Koolina Ocean")					
replace Kampgrounds = 0 if strpos(employer, "Nakoa")							
replace Kampgrounds = 0 if strpos(employer, "Nitto Denkoautomotive")			
replace Kampgrounds = 0 if strpos(employer, "Nukoa")							
replace Kampgrounds = 0 if strpos(employer, "Pastwowa Wysza Szkoa")				
replace Kampgrounds = 0 if strpos(employer, "Barbakoa")							
replace Kampgrounds = 0 if strpos(employer, "Skoah")							
replace Kampgrounds = 0 if strpos(employer, "Taikoarts Midwest")				
replace Kampgrounds = 0 if strpos(employer, "Tekoa")							
replace Kampgrounds = 0 if strpos(employer, "Terrakoat International")			
replace Kampgrounds = 0 if strpos(employer, "The Koa Club")						
replace Kampgrounds = 0 if strpos(employer, "West Koast Graphics")				
replace franchise_id  = 339 if Kampgrounds >= 1 & franchise_id == .
replace franchise_id2 = 339 if Kampgrounds >= 1 & franchise_id != .
replace franchise_id3 = 339 if Kampgrounds >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Kampgrounds >= 1
drop 	Kampgrounds

gen 	Applebees = 	 strpos(lower(employer), "applebee")
replace Applebees = 0 if strpos(lower(employer), "construction") | strpos(lower(employer), "aviation") | strpos(lower(employer), "church")
replace Applebees = 0 if strpos(employer, "Applebee Montessori Academy")		
replace franchise_id  = 340 if Applebees >= 1 & franchise_id == .
replace franchise_id2 = 340 if Applebees >= 1 & franchise_id != .
replace franchise_id3 = 340 if Applebees >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Applebees >= 1
drop 	Applebees

gen 	Bar_Louie = 	 strpos(lower(employer), "bar loui")
replace Bar_Louie = 0 if strpos(employer, "Drybar Louisville")					
replace Bar_Louie = 0 if strpos(employer, "Lifebar Louisville")					
replace Bar_Louie = 0 if strpos(employer, "Pizza Bar Louisville")				
replace franchise_id  = 341 if Bar_Louie >= 1 & franchise_id == .
replace franchise_id2 = 341 if Bar_Louie >= 1 & franchise_id != .
replace franchise_id3 = 341 if Bar_Louie >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Bar_Louie >= 1
drop 	Bar_Louie

gen 	Beef_O_Bradys = strpos(lower(employer), "beef obr") | strpos(lower(employer), "beefobr") 
replace franchise_id  = 342 if Beef_O_Bradys >= 1 & franchise_id == .
replace franchise_id2 = 342 if Beef_O_Bradys >= 1 & franchise_id != .
replace franchise_id3 = 342 if Beef_O_Bradys >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Beef_O_Bradys >= 1
drop 	Beef_O_Bradys

gen 	Buffalo_Wild_Wings = strpos(lower(employer), "buffalo wild")
replace franchise_id  = 343 if Buffalo_Wild_Wings >= 1 & franchise_id == .
replace franchise_id2 = 343 if Buffalo_Wild_Wings >= 1 & franchise_id != .
replace franchise_id3 = 343 if Buffalo_Wild_Wings >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Buffalo_Wild_Wings >= 1
drop 	Buffalo_Wild_Wings

gen 	Chilis = 	  strpos(lower(employer), "chilis") | strpos(lower(employer), "chili's") 
replace Chilis = 0 if strpos(lower(employer), "chilisoft")
replace franchise_id  = 344 if Chilis >= 1 & franchise_id == .
replace franchise_id2 = 344 if Chilis >= 1 & franchise_id != .
replace franchise_id3 = 344 if Chilis >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Chilis >= 1
drop 	Chilis

gen 	Dennys = 	  strpos(lower(employer), "denny's") | strpos(lower(employer), "dennys") 
replace Dennys = 0 if strpos(employer, "Dennysville School Department")			
replace franchise_id  = 345 if Dennys >= 1 & franchise_id == .
replace franchise_id2 = 345 if Dennys >= 1 & franchise_id != .
replace franchise_id3 = 345 if Dennys >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Dennys >= 1
drop 	Dennys

gen 	Famous_Daves = strpos(lower(employer), "famous dave")
replace franchise_id  = 346 if Famous_Daves >= 1 & franchise_id == .
replace franchise_id2 = 346 if Famous_Daves >= 1 & franchise_id != .
replace franchise_id3 = 346 if Famous_Daves >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Famous_Daves >= 1
drop 	Famous_Daves

gen 	Fuddruckers = strpos(lower(employer), "fuddruck") | strpos(lower(employer), "fudd ruck") 
replace franchise_id  = 347 if Fuddruckers >= 1 & franchise_id == .
replace franchise_id2 = 347 if Fuddruckers >= 1 & franchise_id != .
replace franchise_id3 = 347 if Fuddruckers >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Fuddruckers >= 1
drop 	Fuddruckers

gen 	Golden_Corral = 	 strpos(lower(employer), "golden cor")
replace Golden_Corral = 0 if strpos(employer, "Golden Corporation")				
replace franchise_id  = 348 if Golden_Corral >= 1 & franchise_id == .
replace franchise_id2 = 348 if Golden_Corral >= 1 & franchise_id != .
replace franchise_id3 = 348 if Golden_Corral >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Golden_Corral >= 1
drop 	Golden_Corral

gen 	Hooters = 	   strpos(lower(employer), "hooters") | strpos(lower(employer), "hooter's") 
replace Hooters = 0 if strpos(lower(employer), "shooters")
replace Hooters = 0 if strpos(lower(employer), "shooter's")
replace franchise_id  = 349 if Hooters >= 1 & franchise_id == .
replace franchise_id2 = 349 if Hooters >= 1 & franchise_id != .
replace franchise_id3 = 349 if Hooters >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Hooters >= 1
drop 	Hooters

gen 	Huddle_House = strpos(lower(employer), "huddle house") | strpos(lower(employer), "huddlehouse")
replace franchise_id  = 350 if Huddle_House >= 1 & franchise_id == .
replace franchise_id2 = 350 if Huddle_House >= 1 & franchise_id != .
replace franchise_id3 = 350 if Huddle_House >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Huddle_House >= 1
drop 	Huddle_House

gen 	Ihop = 	    strpos(lower(employer), "ihop") | strpos(lower(employer), "i hop")
replace Ihop = 0 if strpos(employer, "Hope")									
replace Ihop = 0 if strpos(employer, "Amerihope")								
replace Ihop = 0 if strpos(employer, "Avanti Hopsitals")						
replace Ihop = 0 if strpos(employer, "Ihope")									
replace Ihop = 0 if strpos(employer, "Kristi Hopper Designs")					
replace Ihop = 0 if strpos(employer, "Mini Hops Gymnastics")					
replace Ihop = 0 if strpos(employer, "Minihops Gymnastics")						
replace Ihop = 0 if strpos(employer, "Singpoli Hop Kin")						
replace Ihop = 0 if strpos(employer, "Naihop")									
replace franchise_id  = 351 if Ihop >= 1 & franchise_id == .
replace franchise_id2 = 351 if Ihop >= 1 & franchise_id != .
replace franchise_id3 = 351 if Ihop >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Ihop >= 1
drop 	Ihop

gen 	Johnny_Rockets = strpos(lower(employer), "johnny rocket")
replace franchise_id  = 352 if Johnny_Rockets >= 1 & franchise_id == .
replace franchise_id2 = 352 if Johnny_Rockets >= 1 & franchise_id != .
replace franchise_id3 = 352 if Johnny_Rockets >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Johnny_Rockets >= 1
drop 	Johnny_Rockets

gen 	Mellow_Mushroom = strpos(lower(employer), "mellow mush") | strpos(lower(employer), "mellowmush")
replace franchise_id  = 353 if Mellow_Mushroom >= 1 & franchise_id == .
replace franchise_id2 = 353 if Mellow_Mushroom >= 1 & franchise_id != .
replace franchise_id3 = 353 if Mellow_Mushroom >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Mellow_Mushroom >= 1
drop 	Mellow_Mushroom

gen 	Melting_Pot = 	   strpos(lower(employer), "melting pot") | strpos(lower(employer), "meltingpot") 
replace Melting_Pot = 0 if strpos(employer, "Melting Pot Ministries")			
replace Melting_Pot = 0 if strpos(employer, "Melting Pot Foundation")			
replace franchise_id  = 354 if Melting_Pot >= 1 & franchise_id == .
replace franchise_id2 = 354 if Melting_Pot >= 1 & franchise_id != .
replace franchise_id3 = 354 if Melting_Pot >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Melting_Pot >= 1
drop 	Melting_Pot

gen 	Noodles_And_Co = strpos(lower(employer), "noodles & co") | strpos(lower(employer), "noodles and co") |strpos(lower(employer), "noodles&co")
replace franchise_id  = 355 if Noodles_And_Co >= 1 & franchise_id == .
replace franchise_id2 = 355 if Noodles_And_Co >= 1 & franchise_id != .
replace franchise_id3 = 355 if Noodles_And_Co >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Noodles_And_Co >= 1
drop 	Noodles_And_Co

gen 	Old_Chicago = 	   strpos(lower(employer), "old chicago") | strpos(lower(employer), "oldchicago")
replace Old_Chicago = 0 if strpos(employer, "Modernfold Chicago, Inc")			
replace franchise_id  = 356 if Old_Chicago >= 1 & franchise_id == .
replace franchise_id2 = 356 if Old_Chicago >= 1 & franchise_id != .
replace franchise_id3 = 356 if Old_Chicago >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Old_Chicago >= 1
drop 	Old_Chicago

gen 	Perkins_Restaurant = 	  strpos(lower(employer), "perkins rest") | strpos(lower(employer), "perkins family")
replace Perkins_Restaurant = 0 if strpos(employer, "Perkins Family Clinic") 	
replace franchise_id  = 357 if Perkins_Restaurant >= 1 & franchise_id == .
replace franchise_id2 = 357 if Perkins_Restaurant >= 1 & franchise_id != .
replace franchise_id3 = 357 if Perkins_Restaurant >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Perkins_Restaurant >= 1
drop 	Perkins_Restaurant

gen 	Pizza_Hut = strpos(lower(employer), "pizza hut")
replace franchise_id  = 358 if Pizza_Hut >= 1 & franchise_id == .
replace franchise_id2 = 358 if Pizza_Hut >= 1 & franchise_id != .
replace franchise_id3 = 358 if Pizza_Hut >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Pizza_Hut >= 1
drop 	Pizza_Hut

gen 	Pizza_Ranch = 	   strpos(lower(employer), "pizza ranch")
replace Pizza_Ranch = 0 if strpos(employer, "Pizza Ranchini") 					
replace franchise_id  = 359 if Pizza_Ranch >= 1 & franchise_id == .
replace franchise_id2 = 359 if Pizza_Ranch >= 1 & franchise_id != .
replace franchise_id3 = 359 if Pizza_Ranch >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Pizza_Ranch >= 1
drop 	Pizza_Ranch

gen 	Pizzeria_Uno = strpos(lower(employer), "pizzeria uno") | strpos(lower(employer), "uno pizzeria")
replace franchise_id  = 360 if Pizzeria_Uno >= 1 & franchise_id == .
replace franchise_id2 = 360 if Pizzeria_Uno >= 1 & franchise_id != .
replace franchise_id3 = 360 if Pizzeria_Uno >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Pizzeria_Uno >= 1
drop 	Pizzeria_Uno

gen 	Ponderosa = 	 strpos(lower(employer), "ponderosa steak") | strpos(lower(employer), "ponderosa rest") | strpos(lower(employer), "ponderosa fine foods") 
replace Ponderosa = 0 if strpos(employer, "Ponderosa Fine Foods") 				
replace franchise_id  = 361 if Ponderosa >= 1 & franchise_id == .
replace franchise_id2 = 361 if Ponderosa >= 1 & franchise_id != .
replace franchise_id3 = 361 if Ponderosa >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Ponderosa >= 1
drop 	Ponderosa

gen 	Rosatis = strpos(lower(employer), "rosatis") | strpos(lower(employer), "rosati's")
replace franchise_id  = 362 if Rosatis >= 1 & franchise_id == .
replace franchise_id2 = 362 if Rosatis >= 1 & franchise_id != .
replace franchise_id3 = 362 if Rosatis >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Rosatis >= 1
drop 	Rosatis

gen 	Ruths_Chris = strpos(lower(employer), "ruths chris") | strpos(lower(employer), "ruth's chris")
replace franchise_id  = 363 if Ruths_Chris >= 1 & franchise_id == .
replace franchise_id2 = 363 if Ruths_Chris >= 1 & franchise_id != .
replace franchise_id3 = 363 if Ruths_Chris >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Ruths_Chris >= 1
drop 	Ruths_Chris

gen 	Shoneys = 	   strpos(lower(employer), "shoney")
replace Shoneys = 0 if strpos(employer, "Shoney Scientific") 					
replace Shoneys = 0 if strpos(employer, "Shoney's Pools") 						
replace franchise_id  = 364 if Shoneys >= 1 & franchise_id == .
replace franchise_id2 = 364 if Shoneys >= 1 & franchise_id != .
replace franchise_id3 = 364 if Shoneys >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Shoneys >= 1
drop 	Shoneys

gen 	Texas_Roadhouse = strpos(lower(employer), "texas road house") | strpos(lower(employer), "texas roadhouse")
replace franchise_id  = 365 if Texas_Roadhouse >= 1 & franchise_id == .
replace franchise_id2 = 365 if Texas_Roadhouse >= 1 & franchise_id != .
replace franchise_id3 = 365 if Texas_Roadhouse >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Texas_Roadhouse >= 1
drop 	Texas_Roadhouse

gen 	TGI_Fridays = 	   strpos(lower(employer), "tgi friday") | strpos(lower(employer), "tgifriday") | strpos(lower(employer), "tgif") 
replace TGI_Fridays = 0 if strpos(employer, "Bestgift") 						
replace TGI_Fridays = 0 if strpos(employer, "Gourmetgiftbaskets") 				
replace TGI_Fridays = 0 if strpos(employer, "Heartgift") 						
replace TGI_Fridays = 0 if strpos(employer, "Greatgiftsformen") 				
replace TGI_Fridays = 0 if strpos(employer, "Residentgifts") 					
replace TGI_Fridays = 0 if strpos(employer, "Shiftgifg") 						
replace TGI_Fridays = 0 if strpos(employer, "Smartgift") 						
replace TGI_Fridays = 0 if strpos(employer, "Swiftgift") 						
replace TGI_Fridays = 0 if strpos(employer, "Tgif Body Shop") 					
replace franchise_id  = 366 if TGI_Fridays >= 1 & franchise_id == .
replace franchise_id2 = 366 if TGI_Fridays >= 1 & franchise_id != .
replace franchise_id3 = 366 if TGI_Fridays >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if TGI_Fridays >= 1
drop 	TGI_Fridays

gen 	Tilted_Kilt = strpos(lower(employer), "tilted kilt") | strpos(lower(employer), "tiltedkilt") 
replace franchise_id  = 367 if Tilted_Kilt >= 1 & franchise_id == .
replace franchise_id2 = 367 if Tilted_Kilt >= 1 & franchise_id != .
replace franchise_id3 = 367 if Tilted_Kilt >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Tilted_Kilt >= 1
drop 	Tilted_Kilt

gen 	Village_Inn = 	   strpos(lower(employer), "village inn")
replace Village_Inn = 0 if strpos(employer, "Village Inn Motels") 				
replace Village_Inn = 0 if strpos(employer, "Village Inn Hotel") 				
replace Village_Inn = 0 if strpos(employer, "Village Inn Pizza") 				
replace Village_Inn = 0 if strpos(employer, "Village Inn Pizzeria") 			
replace Village_Inn = 0 if strpos(employer, "Village Inn Suites") 				
replace Village_Inn = 0 if strpos(employer, "Village Inn Tavern") 				
replace Village_Inn = 0 if strpos(employer, "Ashburn Village Inn Tap & Grill") 	
replace Village_Inn = 0 if strpos(employer, "Avila Village Inn") 				
replace Village_Inn = 0 if strpos(employer, "Bedford Village Inn") 				
replace Village_Inn = 0 if strpos(employer, "Davidson Village Inn") 			
replace Village_Inn = 0 if strpos(employer, "German Village Inn") 				
replace Village_Inn = 0 if strpos(employer, "Inn And Suite") 					
replace Village_Inn = 0 if strpos(employer, "Hamilton Village Inn") 			
replace Village_Inn = 0 if strpos(employer, "Heritage Village Inn") 			
replace Village_Inn = 0 if strpos(employer, "Marina Village Inn") 				
replace Village_Inn = 0 if strpos(employer, "Old Village Inn Restaurant & Tavern") 
replace Village_Inn = 0 if strpos(employer, "Olympic Village Inn") 				
replace Village_Inn = 0 if strpos(employer, "Osage Village Inn") 				
replace Village_Inn = 0 if strpos(employer, "Seaport Village Inn") 				
replace Village_Inn = 0 if strpos(employer, "Smoke Rise Village Inn") 			
replace Village_Inn = 0 if strpos(employer, "Snowvillage Inn") 					
replace Village_Inn = 0 if strpos(employer, "Sonic Village Inn") 				
replace Village_Inn = 0 if strpos(employer, "Steiss Village Inn") 				
replace Village_Inn = 0 if strpos(employer, "The Village Inn Kevin Early") 		
replace Village_Inn = 0 if strpos(employer, "Three Village Inn") 				
replace Village_Inn = 0 if strpos(employer, "Tillman's Village Inn") 			
replace Village_Inn = 0 if strpos(employer, "Village Inn On The Lake") 			
replace Village_Inn = 0 if strpos(employer, "Village Inn Springfield/Eugene") 	
replace Village_Inn = 0 if strpos(employer, "Western Village Inn Casino") 		
replace Village_Inn = 0 if strpos(employer, "Westlake Village Inn") 			
replace Village_Inn = 0 if strpos(employer, "White Pass Village Inn") 			
replace Village_Inn = 0 if strpos(employer, "Zellars Village Inn") 				
replace franchise_id  = 368 if Village_Inn >= 1 & franchise_id == .
replace franchise_id2 = 368 if Village_Inn >= 1 & franchise_id != .
replace franchise_id3 = 368 if Village_Inn >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Village_Inn >= 1
drop 	Village_Inn

gen 	AandW = 	 strpos(lower(employer), "a&w") | strpos(lower(employer), "aandw") | strpos(employer, "A & W") 
replace AandW = 0 if strpos(lower(employer), "health") | strpos(lower(employer), "wireline") | strpos(lower(employer), "water")
replace AandW = 0 if strpos(employer, "A&W Auto Detail") 						
replace AandW = 0 if strpos(employer, "A&W Certified Cooling") 					
replace AandW = 0 if strpos(employer, "A&W Drywall & Plaster Repair") 			
replace AandW = 0 if strpos(employer, "A&W Energy") 							
replace AandW = 0 if strpos(employer, "A&W Learning Center") 					
replace AandW = 0 if strpos(employer, "A&W Mulch Installations") 				
replace AandW = 0 if strpos(employer, "Napolita Pizzeria&Wine Bar") 			
replace AandW = 0 if strpos(employer, "A & W Express") 							
replace AandW = 0 if strpos(employer, "A & W Furniture") 						
replace AandW = 0 if strpos(employer, "A & W Janitorial Services") 				
replace AandW = 0 if strpos(employer, "A & W Maintainance") 					
replace AandW = 0 if strpos(employer, "A & W Moving") 							
replace AandW = 0 if strpos(employer, "A & W Surplus & Auction") 				
replace AandW = 0 if strpos(employer, "A & W Trim Works") 						
replace AandW = 0 if strpos(employer, "A&W X Press") 							
replace AandW = 0 if strpos(employer, "Dukes A & W Trailer Hitches") 			
replace AandW = 0 if strpos(employer, "Reladyne A & W Oil") 					
replace franchise_id  = 369 if AandW >= 1 & franchise_id == .
replace franchise_id2 = 369 if AandW >= 1 & franchise_id != .
replace franchise_id3 = 369 if AandW >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if AandW >= 1
drop 	AandW  

gen 	Arbys = 	 strpos(lower(employer), "arby's") | strpos(lower(employer), "arbys")
replace Arbys = 0 if strpos(employer, "Carbys") 								
replace Arbys = 0 if strpos(employer, "Darby's") 								
replace Arbys = 0 if strpos(employer, "Darbys") 								
replace Arbys = 0 if strpos(employer, "Gold Star Chili Fairfield On The Corner Of Route 4 And Seward Between Arbys And Carusos") 
replace Arbys = 0 if strpos(employer, "Gold Star Chili Fairfield On The Corner Of Route 4 And Seward Between Arbys And Spinning Fork") 
replace Arbys = 0 if strpos(employer, "Naarby's") 								
replace Arbys = 0 if strpos(employer, "O'darby's Fine Wine & Spirits") 			
replace franchise_id  = 370 if Arbys >= 1 & franchise_id == .
replace franchise_id2 = 370 if Arbys >= 1 & franchise_id != .
replace franchise_id3 = 370 if Arbys >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Arbys >= 1
drop 	Arbys

gen 	Baja_Fresh = strpos(lower(employer), "baja fresh")
replace franchise_id  = 371 if Baja_Fresh >= 1 & franchise_id == .
replace franchise_id2 = 371 if Baja_Fresh >= 1 & franchise_id != .
replace franchise_id3 = 371 if Baja_Fresh >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Baja_Fresh >= 1
drop 	Baja_Fresh  

gen 	Blaze_Pizza = strpos(lower(employer), "blaze pizza") | strpos(lower(employer), "blazepizza")
replace franchise_id  = 372 if Blaze_Pizza >= 1 & franchise_id == .
replace franchise_id2 = 372 if Blaze_Pizza >= 1 & franchise_id != .
replace franchise_id3 = 372 if Blaze_Pizza >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Blaze_Pizza >= 1
drop 	Blaze_Pizza

gen 	Blimpie = strpos(lower(employer), "blimpie")
replace franchise_id  = 373 if Blimpie >= 1 & franchise_id == .
replace franchise_id2 = 373 if Blimpie >= 1 & franchise_id != .
replace franchise_id3 = 373 if Blimpie >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Blimpie >= 1
drop 	Blimpie

gen 	Bojangles = strpos(lower(employer), "bojangle")
replace franchise_id  = 374 if Bojangles >= 1 & franchise_id == .
replace franchise_id2 = 374 if Bojangles >= 1 & franchise_id != .
replace franchise_id3 = 374 if Bojangles >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Bojangles >= 1
drop 	Bojangles

gen 	Burger_King = 	   strpos(lower(employer), "burger king") | strpos(lower(employer), "burgerking")
replace Burger_King = 0 if strpos(employer, "Whataburger Kingsville") 			
replace Burger_King = 0 if strpos(employer, "Hamburger King")		 			
replace franchise_id  = 375 if Burger_King >= 1 & franchise_id == .
replace franchise_id2 = 375 if Burger_King >= 1 & franchise_id != .
replace franchise_id3 = 375 if Burger_King >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Burger_King >= 1
drop 	Burger_King 

gen 	Capriottis = strpos(lower(employer), "capriottis") | strpos(lower(employer), "capriotti's") 
replace franchise_id  = 376 if Capriottis >= 1 & franchise_id == .
replace franchise_id2 = 376 if Capriottis >= 1 & franchise_id != .
replace franchise_id3 = 376 if Capriottis >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Capriottis >= 1
drop 	Capriottis

gen 	Captain_Ds = strpos(lower(employer), "captain d's") | strpos(lower(employer), "captain ds")
replace franchise_id  = 377 if Captain_Ds >= 1 & franchise_id == .
replace franchise_id2 = 377 if Captain_Ds >= 1 & franchise_id != .
replace franchise_id3 = 377 if Captain_Ds >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Captain_Ds >= 1
drop 	Captain_Ds

gen 	Carls_Jr = strpos(lower(employer), "carl's jr") | strpos(lower(employer), "carls jr") | strpos(lower(employer), "carlsjr")
replace franchise_id  = 378 if Carls_Jr >= 1 & franchise_id == .
replace franchise_id2 = 378 if Carls_Jr >= 1 & franchise_id != .
replace franchise_id3 = 378 if Carls_Jr >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Carls_Jr >= 1
drop 	Carls_Jr

gen 	Champs_Chicken = strpos(lower(employer), "champs chick") | strpos(lower(employer), "champschick")
replace franchise_id  = 379 if Champs_Chicken >= 1 & franchise_id == .
replace franchise_id2 = 379 if Champs_Chicken >= 1 & franchise_id != .
replace franchise_id3 = 379 if Champs_Chicken >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Champs_Chicken >= 1
drop 	Champs_Chicken

gen 	Charleys = 		strpos(lower(employer), "charley's") & (strpos(lower(employer), "grill") | strpos(lower(employer), "philly") | strpos(lower(employer), "restaurant"))
replace Charleys = 1 if strpos(lower(employer), "charleys")  & (strpos(lower(employer), "grill") | strpos(lower(employer), "philly") | strpos(lower(employer), "restaurant"))
replace Charleys = 1 if lower(employer) == "charleys"
replace Charleys = 1 if strpos(lower(employer),"charleys on")
replace Charleys = 0 if strpos(employer,"O'charley's")							
replace Charleys = 0 if strpos(employer,"Ocharleys")							
replace Charleys = 0 if strpos(employer,"O'charleys Restaurant And Bar")		
replace Charleys = 0 if strpos(employer,"O' Charley's Restaurant And Bar")		
replace Charleys = 0 if strpos(employer,"Charleys Pub Grill")					
replace Charleys = 0 if strpos(employer,"Charleys Ocean Grill")					
replace Charleys = 0 if strpos(employer,"Charleys Sports Grill Llc")			
replace Charleys = 0 if strpos(employer,"Grindstone Charley's Restaurant Bar")	
replace Charleys = 0 if strpos(employer,"Charley's Grille")						
replace franchise_id  = 380 if Charleys >= 1 & franchise_id == .
replace franchise_id2 = 380 if Charleys >= 1 & franchise_id != .
replace franchise_id3 = 380 if Charleys >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Charleys >= 1
drop 	Charleys

gen 	Checkers =		strpos(lower(employer), "checkers") | strpos(lower(employer), "rally's") | strpos(lower(employer), "rallys hamb") | strpos(lower(employer), "rallys rest")
replace Checkers = 0 if strpos(employer,"Charlie And Checkers")					
replace Checkers = 0 if strpos(employer,"Charlotte Checkers")					
replace Checkers = 0 if strpos(employer,"Checkers Auto Body")					
replace Checkers = 0 if strpos(employer,"Checkers Cafe")						
replace Checkers = 0 if strpos(employer,"Checkers Catering")					
replace Checkers = 0 if strpos(employer,"Checkers Discount Liquors & Wine")		
replace Checkers = 0 if strpos(employer,"Checkers Herndon Oil Corporation")		
replace Checkers = 0 if strpos(employer,"Checkers Industr")						
replace Checkers = 0 if strpos(employer,"Checkers Safety Group")				
replace Checkers = 0 if strpos(employer,"Checkers Solarstate Management, Inc")	
replace Checkers = 0 if strpos(employer,"Checkers Towing")						
replace Checkers = 0 if strpos(employer,"Checkers Truck Insurance Services")	
replace Checkers = 0 if strpos(employer,"Checkerspot")							
replace Checkers = 0 if strpos(employer,"Checkers Pizza")						
replace franchise_id  = 381 if Checkers >= 1 & franchise_id == .
replace franchise_id2 = 381 if Checkers >= 1 & franchise_id != .
replace franchise_id3 = 381 if Checkers >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Checkers >= 1
drop 	Checkers

gen 	Chesters = 		strpos(lower(employer), "chesters") | strpos(lower(employer), "chester's") 
replace Chesters = 0 if strpos(lower(employer), "parkchester") | strpos(lower(employer), "winchester") | strpos(lower(employer), "manchester") | ///
						strpos(lower(employer), "rochester")   | strpos(lower(employer), "westchester") 
replace Chesters = 0 if strpos(employer,"Barista Store 23602, Westchesters Hill") 
replace Chesters = 0 if strpos(employer,"Chester's Eagle Rock Harley Davidsonmotorcycles") 
replace Chesters = 0 if strpos(employer,"Chester's Flower Shop")  				
replace Chesters = 0 if strpos(employer,"Chesters Flower Shop")  				
replace Chesters = 0 if strpos(employer,"Chester's Iron Shoppe")  				
replace Chesters = 0 if strpos(employer,"Chester's Mansonary")  				
replace Chesters = 0 if strpos(employer,"Chesters Asia Chinese Restaurant")  	
replace Chesters = 0 if strpos(employer,"Chesters Chophouse & Wine Bar")  		
replace Chesters = 0 if strpos(employer,"Chesters Plumbing And Bathroom Centre") 
replace Chesters = 0 if strpos(employer,"Chesters Trucking Enterprises Llc")  	
replace Chesters = 0 if strpos(employer,"Wingchesters")  						
replace franchise_id  = 382 if Chesters >= 1 & franchise_id == .
replace franchise_id2 = 382 if Chesters >= 1 & franchise_id != .
replace franchise_id3 = 382 if Chesters >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Chesters >= 1
drop 	Chesters

gen 	Chick_Fil_A = strpos(lower(employer), "chick fil a") | strpos(lower(employer), "chick-fil-a")
replace franchise_id  = 383 if Chick_Fil_A >= 1 & franchise_id == .
replace franchise_id2 = 383 if Chick_Fil_A >= 1 & franchise_id != .
replace franchise_id3 = 383 if Chick_Fil_A >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Chick_Fil_A >= 1
drop 	Chick_Fil_A 

gen 	Churchs_Chicken = strpos(lower(employer), "churchs chicken") | strpos(lower(employer), "church's chicken")
replace franchise_id  = 384 if Churchs_Chicken >= 1 & franchise_id == .
replace franchise_id2 = 384 if Churchs_Chicken >= 1 & franchise_id != .
replace franchise_id3 = 384 if Churchs_Chicken >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Churchs_Chicken >= 1
drop 	Churchs_Chicken

gen 	Cicis_Pizza = strpos(lower(employer), "cicis pizza") | strpos(lower(employer), "cici's pizza") 
replace franchise_id  = 385 if Cicis_Pizza >= 1 & franchise_id == .
replace franchise_id2 = 385 if Cicis_Pizza >= 1 & franchise_id != .
replace franchise_id3 = 385 if Cicis_Pizza >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Cicis_Pizza >= 1
drop 	Cicis_Pizza

gen 	Corner_Bakery = 	 strpos(lower(employer), "corner baker")
replace Corner_Bakery = 0 if strpos(employer,"The Corner Bakery Panaderia")  	
replace franchise_id  = 386 if Corner_Bakery >= 1 & franchise_id == .
replace franchise_id2 = 386 if Corner_Bakery >= 1 & franchise_id != .
replace franchise_id3 = 386 if Corner_Bakery >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Corner_Bakery >= 1
drop 	Corner_Bakery

gen 	Cosi = 		strpos(lower(employer), "cosi")
replace Cosi = 0 if strpos(lower(employer), "productions") | strpos(lower(employer), "consult") | strpos(lower(employer), "cosine")  | strpos(lower(employer), "cosimo") | ///
					strpos(lower(employer), "cosiani") 	   | strpos(lower(employer), "cosic") 	| strpos(lower(employer), "cosidla") | strpos(lower(employer), "cosie")  | ///
					strpos(lower(employer), "cosign") 	   | strpos(lower(employer), "cosim") 	| strpos(lower(employer), "cosin") 	 | strpos(lower(employer), "cosio")  | ///
					strpos(lower(employer), "cosis") 	   | strpos(lower(employer), "cositas") 
replace Cosi = 0 if strpos(employer,"Aracosia")  								
replace Cosi = 0 if strpos(employer,"Cosi Bella Day Spa")  						
replace Cosi = 0 if strpos(employer,"Cosi Bella Nail Spa")  					
replace Cosi = 0 if strpos(employer,"Ecosia")  									
replace Cosi = 0 if strpos(employer,"Ecosikh")  								
replace Cosi = 0 if strpos(employer,"Epicosity")  								
replace Cosi = 0 if strpos(employer,"Latches Accosiates")  						
replace Cosi = 0 if strpos(employer,"Nassim & Asscosiates")  					
replace Cosi = 0 if strpos(employer,"Nicosia")  								
replace Cosi = 0 if strpos(employer,"Picosito")  								
replace Cosi = 0 if strpos(employer,"Scosi Orthopedics")  						
replace Cosi = 0 if strpos(employer,"Varicosity Partners")  					
replace Cosi = 0 if strpos(employer,"Viscosity")  								
replace Cosi = 0 if strpos(employer,"Vitaver & Accosiates")  					
replace franchise_id  = 387 if Cosi >= 1 & franchise_id == .
replace franchise_id2 = 387 if Cosi >= 1 & franchise_id != .
replace franchise_id3 = 387 if Cosi >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Cosi >= 1
drop 	Cosi

gen 	Cousins_Subs = strpos(lower(employer), "cousins subs") | strpos(lower(employer), "cousin's subs")
replace franchise_id  = 388 if Cousins_Subs >= 1 & franchise_id == .
replace franchise_id2 = 388 if Cousins_Subs >= 1 & franchise_id != .
replace franchise_id3 = 388 if Cousins_Subs >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Cousins_Subs >= 1
drop 	Cousins_Subs

gen 	Culvers = 	   strpos(lower(employer), "culver's") | strpos(lower(employer), "culvers") 
replace Culvers = 0 if strpos(employer,"Culver's Garden Center & Greenhouse")  	
replace Culvers = 0 if strpos(employer,"Culver's Painting")  					
replace Culvers = 0 if strpos(employer,"Culver's Commercial Cleaning")  		
replace franchise_id  = 389 if Culvers >= 1 & franchise_id == .
replace franchise_id2 = 389 if Culvers >= 1 & franchise_id != .
replace franchise_id3 = 389 if Culvers >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Culvers >= 1
drop 	Culvers

gen 	Dairy_Queen = strpos(lower(employer), "dq grill") | strpos(lower(employer), "dq of") | strpos(lower(employer), "dairy queen")
replace franchise_id  = 390 if Dairy_Queen >= 1 & franchise_id == .
replace franchise_id2 = 390 if Dairy_Queen >= 1 & franchise_id != .
replace franchise_id3 = 390 if Dairy_Queen >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Dairy_Queen >= 1
drop 	Dairy_Queen

gen 	Dickeys = strpos(lower(employer), "dickey's") | strpos(lower(employer), "dickeys")
replace franchise_id  = 391 if Dickeys >= 1 & franchise_id == .
replace franchise_id2 = 391 if Dickeys >= 1 & franchise_id != .
replace franchise_id3 = 391 if Dickeys >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Dickeys >= 1
drop 	Dickeys

gen 	Dominos = 	   strpos(lower(employer), "domino's") | strpos(lower(employer), "dominos") | strpos(lower(employer), "domino s ")
replace Dominos = 1 if strpos(lower(employer), "domino") & strpos(lower(employer), "pizza")
replace Dominos = 0 if strpos(employer,"Dominosugar")  							
replace franchise_id  = 392 if Dominos >= 1 & franchise_id == .
replace franchise_id2 = 392 if Dominos >= 1 & franchise_id != .
replace franchise_id3 = 392 if Dominos >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Dominos >= 1
drop 	Dominos

gen 	Donatos_Pizza = strpos(lower(employer), "donato") & (strpos(lower(employer), "pizza") | strpos(lower(employer), "pizzeria")) 
replace franchise_id  = 393 if Donatos_Pizza >= 1 & franchise_id == .
replace franchise_id2 = 393 if Donatos_Pizza >= 1 & franchise_id != .
replace franchise_id3 = 393 if Donatos_Pizza >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Donatos_Pizza >= 1
drop 	Donatos_Pizza  

gen 	Einstein_Bros = strpos(lower(employer), "einstein bro")
replace franchise_id  = 394 if Einstein_Bros >= 1 & franchise_id == .
replace franchise_id2 = 394 if Einstein_Bros >= 1 & franchise_id != .
replace franchise_id3 = 394 if Einstein_Bros >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Einstein_Bros >= 1
drop 	Einstein_Bros

gen 	Erbert_and_Gerbert = 	  strpos(lower(employer), "gerbert") | strpos(lower(employer), "erbert") 
replace Erbert_and_Gerbert = 0 if strpos(employer,"Herbert")  					
replace Erbert_and_Gerbert = 0 if strpos(employer,"Berbert")  					
replace Erbert_and_Gerbert = 0 if strpos(employer,"Erbert Lawns")  				
replace Erbert_and_Gerbert = 0 if strpos(employer,"Ferbert")  					
replace Erbert_and_Gerbert = 0 if strpos(employer,"Gerbert & Sons Landscaping & Irrigation, Inc") 
replace Erbert_and_Gerbert = 0 if strpos(employer,"Sherbert")  					
replace Erbert_and_Gerbert = 0 if strpos(employer,"Kerbertas")  				
replace franchise_id  = 395 if Erbert_and_Gerbert >= 1 & franchise_id == .
replace franchise_id2 = 395 if Erbert_and_Gerbert >= 1 & franchise_id != .
replace franchise_id3 = 395 if Erbert_and_Gerbert >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Erbert_and_Gerbert >= 1
drop 	Erbert_and_Gerbert

gen 	Fazolis = strpos(lower(employer), "fazoli")
replace franchise_id  = 396 if Fazolis >= 1 & franchise_id == .
replace franchise_id2 = 396 if Fazolis >= 1 & franchise_id != .
replace franchise_id3 = 396 if Fazolis >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Fazolis >= 1
drop 	Fazolis

gen 	Firehouse = 	 strpos(lower(employer), "firehouse") & (strpos(lower(employer), "subs") | strpos(lower(employer), "america") | strpos(lower(employer), "restaurant"))
replace Firehouse = 0 if strpos(employer,"Nickys Firehouse Italian Restaurant & Pizzeria") 
replace Firehouse = 0 if strpos(employer,"Chicago Firehouse Restaurant") 		
replace Firehouse = 0 if strpos(employer,"Pechin's/Firehouse Restaurant") 		
replace franchise_id  = 397 if Firehouse >= 1 & franchise_id == .
replace franchise_id2 = 397 if Firehouse >= 1 & franchise_id != .
replace franchise_id3 = 397 if Firehouse >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Firehouse >= 1
drop 	Firehouse

gen 	Five_Guys = 	 strpos(lower(employer), "five guys") | strpos(lower(employer), "fiveguys") | strpos(lower(employer), "5 guys") | strpos(lower(employer), "5guys")
replace Five_Guys = 0 if strpos(employer,"5 Guys Transportation") 				
replace Five_Guys = 0 if strpos(employer,"5Guystransportation") 				
replace Five_Guys = 0 if strpos(employer,"5 Guys Named Mow Inc") 				
replace franchise_id  = 398 if Five_Guys >= 1 & franchise_id == .
replace franchise_id2 = 398 if Five_Guys >= 1 & franchise_id != .
replace franchise_id3 = 398 if Five_Guys >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Five_Guys >= 1
drop 	Five_Guys

gen 	Freddys_Frozen_Custard = strpos(lower(employer), "freddys frozen") | strpos(lower(employer), "freddy's frozen")
replace Freddys_Frozen_Custard = 1 if lower(employer) == "freddys"
replace franchise_id  = 399 if Freddys_Frozen_Custard >= 1 & franchise_id == .
replace franchise_id2 = 399 if Freddys_Frozen_Custard >= 1 & franchise_id != .
replace franchise_id3 = 399 if Freddys_Frozen_Custard >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Freddys_Frozen_Custard >= 1
drop 	Freddys_Frozen_Custard

gen 	Freshii = strpos(lower(employer), "freshii")
replace franchise_id  = 400 if Freshii >= 1 & franchise_id == .
replace franchise_id2 = 400 if Freshii >= 1 & franchise_id != .
replace franchise_id3 = 400 if Freshii >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Freshii >= 1
drop 	Freshii

gen 	Fuzzys_Taco = strpos(lower(employer), "fuzzys taco") | strpos(lower(employer), "fuzzy's taco")
replace franchise_id  = 401 if Fuzzys_Taco >= 1 & franchise_id == .
replace franchise_id2 = 401 if Fuzzys_Taco >= 1 & franchise_id != .
replace franchise_id3 = 401 if Fuzzys_Taco >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Fuzzys_Taco >= 1
drop 	Fuzzys_Taco

gen 	Godfathers = 	  strpos(lower(employer), "godfather") | strpos(lower(employer), "godfather's")
replace Godfathers = 0 if strpos(lower(employer), "construction")
replace Godfathers = 0 if strpos(employer, "Godfather Bistro And Cigar Bar")	
replace Godfathers = 0 if strpos(employer, "Godfather Cigar")					
replace Godfathers = 0 if strpos(employer, "Godfather Pawn Cocoa")				
replace Godfathers = 0 if strpos(employer, "Godfather Seafood Bar Grill")		
replace Godfathers = 0 if strpos(employer, "Godfather Spy Shop")				
replace Godfathers = 0 if strpos(employer, "Godfather's Bar")					
replace Godfathers = 0 if strpos(employer, "Godfather's Burger Lounge")			
replace Godfathers = 0 if strpos(employer, "Godfathers Exterminating")			
replace Godfathers = 0 if strpos(employer, "The Godfather")						
replace franchise_id  = 402 if Godfathers >= 1 & franchise_id == .
replace franchise_id2 = 402 if Godfathers >= 1 & franchise_id != .
replace franchise_id3 = 402 if Godfathers >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Godfathers >= 1
drop 	Godfathers

gen 	Great_Harvest = strpos(lower(employer), "great harv")
replace franchise_id  = 403 if Great_Harvest >= 1 & franchise_id == .
replace franchise_id2 = 403 if Great_Harvest >= 1 & franchise_id != .
replace franchise_id3 = 403 if Great_Harvest >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Great_Harvest >= 1
drop 	Great_Harvest

gen 	Hardees = strpos(lower(employer), "hardee s") | strpos(lower(employer), "hardee's") | strpos(lower(employer), "hardees")
replace Hardees = 0 if strpos(employer, "Ao Hardee Son Incorporated")			
replace Hardees = 0 if strpos(employer, "Hardee Sales")							
replace Hardees = 0 if strpos(employer, "Nahardee's")							
replace franchise_id  = 404 if Hardees >= 1 & franchise_id == .
replace franchise_id2 = 404 if Hardees >= 1 & franchise_id != .
replace franchise_id3 = 404 if Hardees >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Hardees >= 1
drop 	Hardees

gen 	Hissho = strpos(lower(employer), "hissho")
replace franchise_id  = 405 if Hissho >= 1 & franchise_id == .
replace franchise_id2 = 405 if Hissho >= 1 & franchise_id != .
replace franchise_id3 = 405 if Hissho >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Hissho >= 1
drop 	Hissho

gen 	Honey_Baked_Ham = strpos(lower(employer), "honey baked ham") | strpos(employer, "HBH") 
replace franchise_id  = 406 if Honey_Baked_Ham >= 1 & franchise_id == .
replace franchise_id2 = 406 if Honey_Baked_Ham >= 1 & franchise_id != .
replace franchise_id3 = 406 if Honey_Baked_Ham >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Honey_Baked_Ham >= 1
drop 	Honey_Baked_Ham

gen 	Jasons_Deli = strpos(lower(employer), "jason's deli") | strpos(lower(employer), "jasons deli")
replace franchise_id  = 407 if Jasons_Deli >= 1 & franchise_id == .
replace franchise_id2 = 407 if Jasons_Deli >= 1 & franchise_id != .
replace franchise_id3 = 407 if Jasons_Deli >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Jasons_Deli >= 1
drop 	Jasons_Deli

gen 	Jersey_Mikes = strpos(lower(employer), "jersey mike") | strpos(lower(employer), "jersey mike's")
replace franchise_id  = 408 if Jersey_Mikes >= 1 & franchise_id == .
replace franchise_id2 = 408 if Jersey_Mikes >= 1 & franchise_id != .
replace franchise_id3 = 408 if Jersey_Mikes >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Jersey_Mikes >= 1
drop 	Jersey_Mikes

gen 	Jets_Pizza = strpos(lower(employer), "jets pizza") | strpos(lower(employer), "jet's pizza") 
replace franchise_id  = 409 if Jets_Pizza >= 1 & franchise_id == .
replace franchise_id2 = 409 if Jets_Pizza >= 1 & franchise_id != .
replace franchise_id3 = 409 if Jets_Pizza >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Jets_Pizza >= 1
drop 	Jets_Pizza

gen 	Jimmy_Johns = strpos(lower(employer), "jimmyjohns") | strpos(lower(employer), "jimmy john") | strpos(lower(employer), "jimmy john's")
replace franchise_id  = 410 if Jimmy_Johns >= 1 & franchise_id == .
replace franchise_id2 = 410 if Jimmy_Johns >= 1 & franchise_id != .
replace franchise_id3 = 410 if Jimmy_Johns >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Jimmy_Johns >= 1
drop 	Jimmy_Johns

gen 	KFC = 	   strpos(lower(employer), "kfc") 
replace KFC = 0 if strpos(lower(employer), "klein financial") | strpos(lower(employer), "c7x") | strpos(lower(employer), "jennifer gordon") | strpos(lower(employer), "okfcs")
replace KFC = 0 if strpos(employer, "Kfc Engineering")							
replace KFC = 0 if strpos(employer, "Kfca Llc")									
replace KFC = 0 if strpos(employer, "Kfcu")										
replace KFC = 0 if strpos(employer, "Ctkfc And Vision Of Hope Deliverance Fellowships")	
replace KFC = 0 if strpos(employer, "Floorworks Www Fkfcorp Com")				
replace KFC = 0 if strpos(employer, "Ukfcu")									
replace franchise_id  = 411 if KFC >= 1 & franchise_id == .
replace franchise_id2 = 411 if KFC >= 1 & franchise_id != .
replace franchise_id3 = 411 if KFC >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if KFC >= 1
drop 	KFC

gen 	Lees_Chicken = strpos(lower(employer), "lees chic") | strpos(lower(employer), "lee's chic") | strpos(lower(employer), "lees famous") | strpos(lower(employer), "lee's famous")
replace franchise_id  = 412 if Lees_Chicken >= 1 & franchise_id == .
replace franchise_id2 = 412 if Lees_Chicken >= 1 & franchise_id != .
replace franchise_id3 = 412 if Lees_Chicken >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Lees_Chicken >= 1
drop 	Lees_Chicken

gen		Little_Caesars = strpos(lower(employer), "little caesar") | strpos(lower(employer), "littlecaesar") | strpos(lower(employer), "little caesar's")
replace franchise_id  = 413 if Little_Caesars >= 1 & franchise_id == .
replace franchise_id2 = 413 if Little_Caesars >= 1 & franchise_id != .
replace franchise_id3 = 413 if Little_Caesars >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Little_Caesars >= 1
drop 	Little_Caesars

gen 	Long_John_Silvers = strpos(lower(employer), "long john silv") | strpos(lower(employer), "longjohnsilv")
replace franchise_id  = 414 if Long_John_Silvers >= 1 & franchise_id == .
replace franchise_id2 = 414 if Long_John_Silvers >= 1 & franchise_id != .
replace franchise_id3 = 414 if Long_John_Silvers >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Long_John_Silvers >= 1
drop 	Long_John_Silvers

gen 	Marcos_Pizza = strpos(lower(employer), "marcos pizza") | strpos(lower(employer), "marco's pizza")
replace franchise_id  = 415 if Marcos_Pizza >= 1 & franchise_id == .
replace franchise_id2 = 415 if Marcos_Pizza >= 1 & franchise_id != .
replace franchise_id3 = 415 if Marcos_Pizza >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Marcos_Pizza >= 1
drop 	Marcos_Pizza

gen 	McAlisters_Deli = strpos(lower(employer), "mcalister") & strpos(lower(employer), "deli")
replace franchise_id  = 416 if McAlisters_Deli >= 1 & franchise_id == .
replace franchise_id2 = 416 if McAlisters_Deli >= 1 & franchise_id != .
replace franchise_id3 = 416 if McAlisters_Deli >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if McAlisters_Deli >= 1
drop 	McAlisters_Deli

gen 	McDonalds = strpos(lower(employer), "mcdonald's") | strpos(lower(employer), "mcdonalds")
replace McDonalds = 1 if lower(employer) == "mcdonald family corporation" | lower(employer) == "mcdonald& 039 s" | lower(employer) == "mcdonald 039 s" | lower(employer) == "mcdonald"
replace franchise_id  = 417 if McDonalds >= 1 & franchise_id == .
replace franchise_id2 = 417 if McDonalds >= 1 & franchise_id != .
replace franchise_id3 = 417 if McDonalds >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if McDonalds >= 1
drop 	McDonalds

gen 	Moes_SW_Grill = strpos(lower(employer), "moes southw") | strpos(lower(employer), "moes sw") | strpos(lower(employer), "moe's southw") | strpos(lower(employer), "moe's sw")
replace franchise_id  = 418 if Moes_SW_Grill >= 1 & franchise_id == .
replace franchise_id2 = 418 if Moes_SW_Grill >= 1 & franchise_id != .
replace franchise_id3 = 418 if Moes_SW_Grill >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Moes_SW_Grill >= 1
drop 	Moes_SW_Grill

gen 	Nathans_Famous = strpos(lower(employer), "nathans famous") | strpos(lower(employer), "nathan's famous")
replace franchise_id  = 419 if Nathans_Famous >= 1 & franchise_id == .
replace franchise_id2 = 419 if Nathans_Famous >= 1 & franchise_id != .
replace franchise_id3 = 419 if Nathans_Famous >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Nathans_Famous >= 1
drop 	Nathans_Famous

gen 	Newks = strpos(lower(employer), "newks") | strpos(lower(employer), "newk's")
replace franchise_id  = 420 if Newks >= 1 & franchise_id == .
replace franchise_id2 = 420 if Newks >= 1 & franchise_id != .
replace franchise_id3 = 420 if Newks >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Newks >= 1
drop 	Newks

gen 	Panda_Express = strpos(lower(employer), "panda expr") | strpos(lower(employer), "pandaexpr")
replace franchise_id  = 421 if Panda_Express >= 1 & franchise_id == .
replace franchise_id2 = 421 if Panda_Express >= 1 & franchise_id != .
replace franchise_id3 = 421 if Panda_Express >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Panda_Express >= 1
drop 	Panda_Express

gen 	Panera_Bread = 		strpos(lower(employer), "panera")
replace Panera_Bread = 0 if strpos(employer, "Paneratech")						
replace Panera_Bread = 0 if strpos(employer, "Panerai")							
replace Panera_Bread = 0 if strpos(employer, "Womanshelter Companeras")			
replace franchise_id  = 422 if Panera_Bread >= 1 & franchise_id == .
replace franchise_id2 = 422 if Panera_Bread >= 1 & franchise_id != .
replace franchise_id3 = 422 if Panera_Bread >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Panera_Bread >= 1
drop 	Panera_Bread

gen 	Papa_Johns = strpos(lower(employer), "papa john") | strpos(lower(employer), "papajohn")
replace franchise_id  = 423 if Papa_Johns >= 1 & franchise_id == .
replace franchise_id2 = 423 if Papa_Johns >= 1 & franchise_id != .
replace franchise_id3 = 423 if Papa_Johns >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Papa_Johns >= 1
drop 	Papa_Johns

gen 	Papa_Murphys = strpos(lower(employer), "papamurp") | strpos(lower(employer), "papa murp")
replace franchise_id  = 424 if Papa_Murphys >= 1 & franchise_id == .
replace franchise_id2 = 424 if Papa_Murphys >= 1 & franchise_id != .
replace franchise_id3 = 424 if Papa_Murphys >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Papa_Murphys >= 1
drop 	Papa_Murphys

gen 	Penn_Station_Subs = strpos(lower(employer), "penn station") & strpos(lower(employer), "sub") 
replace franchise_id  = 425 if Penn_Station_Subs >= 1 & franchise_id == .
replace franchise_id2 = 425 if Penn_Station_Subs >= 1 & franchise_id != .
replace franchise_id3 = 425 if Penn_Station_Subs >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Penn_Station_Subs >= 1
drop 	Penn_Station_Subs

gen 	Pita_Pit = 		strpos(lower(employer), "pita pit")
replace Pita_Pit = 0 if strpos(employer, "Pita Pita")							
replace Pita_Pit = 0 if strpos(employer, "Pita Pitaki")							
replace franchise_id  = 426 if Pita_Pit >= 1 & franchise_id == .
replace franchise_id2 = 426 if Pita_Pit >= 1 & franchise_id != .
replace franchise_id3 = 426 if Pita_Pit >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Pita_Pit >= 1
drop 	Pita_Pit

gen 	Popeyes = 	   strpos(lower(employer), "popeye")
replace Popeyes = 0 if strpos(employer, "Popeye Investments")					
replace Popeyes = 0 if strpos(employer, "Popeye Moving & Storage")				
replace franchise_id  = 427 if Popeyes >= 1 & franchise_id == .
replace franchise_id2 = 427 if Popeyes >= 1 & franchise_id != .
replace franchise_id3 = 427 if Popeyes >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Popeyes >= 1
drop 	Popeyes

gen 	Potbellys = 	 strpos(lower(employer), "potbelly")
replace Potbellys = 0 if strpos(lower(employer), "films")
replace Potbellys = 0 if strpos(employer, "Potbelly's Wings And Grill")			
replace Potbellys = 0 if strpos(employer, "Potbellys Riverside Cafe")			
replace franchise_id  = 428 if Potbellys >= 1 & franchise_id == .
replace franchise_id2 = 428 if Potbellys >= 1 & franchise_id != .
replace franchise_id3 = 428 if Potbellys >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Potbellys >= 1
drop 	Potbellys

gen 	Qdoba = strpos(lower(employer), "qdoba") 
replace franchise_id  = 429 if Qdoba >= 1 & franchise_id == .
replace franchise_id2 = 429 if Qdoba >= 1 & franchise_id != .
replace franchise_id3 = 429 if Qdoba >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Qdoba >= 1
drop 	Qdoba

gen 	Quiznos = strpos(lower(employer), "quizno")
replace franchise_id  = 430 if Quiznos >= 1 & franchise_id == .
replace franchise_id2 = 430 if Quiznos >= 1 & franchise_id != .
replace franchise_id3 = 430 if Quiznos >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Quiznos >= 1
drop 	Quiznos

gen 	Saladworks = strpos(lower(employer), "saladwork") | strpos(lower(employer), "salad work")
replace franchise_id  = 431 if Saladworks >= 1 & franchise_id == .
replace franchise_id2 = 431 if Saladworks >= 1 & franchise_id != .
replace franchise_id3 = 431 if Saladworks >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Saladworks >= 1
drop 	Saladworks

gen 	Sbarro = 	  strpos(lower(employer), "sbarro") 
replace Sbarro = 0 if strpos(lower(employer), "sisbarro")
replace Sbarro = 0 if strpos(employer, "Chris Gasbarro's Fine Wine & Spirits")	
replace Sbarro = 0 if strpos(employer, "Sbarro Health Research Organization")	
replace Sbarro = 0 if strpos(employer, "Phil Gasbarro Liquors")					
replace Sbarro = 0 if strpos(employer, "Digasbarro")							
replace Sbarro = 0 if strpos(employer, "Processbarron")							
replace franchise_id  = 432 if Sbarro >= 1 & franchise_id == .
replace franchise_id2 = 432 if Sbarro >= 1 & franchise_id != .
replace franchise_id3 = 432 if Sbarro >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Sbarro >= 1
drop 	Sbarro

gen 	Schlotskys = strpos(lower(employer), "schlots") | strpos(lower(employer), "schlotz")
replace franchise_id  = 433 if Schlotskys >= 1 & franchise_id == .
replace franchise_id2 = 433 if Schlotskys >= 1 & franchise_id != .
replace franchise_id3 = 433 if Schlotskys >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Schlotskys >= 1
drop 	Schlotskys

gen 	Smashburger = strpos(lower(employer), "smash burg") | strpos(lower(employer), "smashburg")
replace franchise_id  = 434 if Smashburger >= 1 & franchise_id == .
replace franchise_id2 = 434 if Smashburger >= 1 & franchise_id != .
replace franchise_id3 = 434 if Smashburger >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Smashburger >= 1
drop 	Smashburger

gen 	Sonic = strpos(lower(employer), "sonic drive") | strpos(lower(employer), "sonic rest") | strpos(lower(employer), "sonic of")
replace franchise_id  = 435 if Sonic >= 1 & franchise_id == .
replace franchise_id2 = 435 if Sonic >= 1 & franchise_id != .
replace franchise_id3 = 435 if Sonic >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Sonic >= 1
drop 	Sonic

gen 	Steak_and_Shake = 	   strpos(lower(employer), "steak") & strpos(lower(employer), "shake")
replace Steak_and_Shake = 0 if strpos(employer, "Paganos Steaks And Shakes")	
replace franchise_id  = 436 if Steak_and_Shake >= 1 & franchise_id == .
replace franchise_id2 = 436 if Steak_and_Shake >= 1 & franchise_id != .
replace franchise_id3 = 436 if Steak_and_Shake >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Steak_and_Shake >= 1
drop 	Steak_and_Shake  

gen 	Subway = 	  strpos(lower(employer), "subway") 
replace Subway = 0 if strpos(lower(employer), "salon")
replace Subway = 0 if strpos(employer, "Subway Truck Parts Incorporated")		
replace Subway = 0 if strpos(employer, "Running Subway")						
replace Subway = 0 if strpos(employer, "Subway Realty")							
replace franchise_id  = 437 if Subway >= 1 & franchise_id == .
replace franchise_id2 = 437 if Subway >= 1 & franchise_id != .
replace franchise_id3 = 437 if Subway >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Subway >= 1
drop 	Subway

gen 	Taco_Bell = strpos(lower(employer), "taco bell") | strpos(lower(employer), "tacobell")
replace franchise_id  = 438 if Taco_Bell >= 1 & franchise_id == .
replace franchise_id2 = 438 if Taco_Bell >= 1 & franchise_id != .
replace franchise_id3 = 438 if Taco_Bell >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Taco_Bell >= 1
drop 	Taco_Bell

gen 	Taco_John = strpos(lower(employer), "taco john") | strpos(lower(employer), "tacojohn")
replace Taco_John = 0 if strpos(employer, "Twisted Taco Johns Creek")			
replace franchise_id  = 439 if Taco_John >= 1 & franchise_id == .
replace franchise_id2 = 439 if Taco_John >= 1 & franchise_id != .
replace franchise_id3 = 439 if Taco_John >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Taco_John >= 1
drop 	Taco_John

gen 	Villa_Pizza = 	   strpos(lower(employer), "villa pizza") | strpos(lower(employer), "cozzoli") | strpos(lower(employer), "fresh italian kitchen") | strpos(lower(employer), "villa italian kitchen")
replace Villa_Pizza = 0 if strpos(employer, "Cozzolino")						
replace Villa_Pizza = 0 if strpos(employer, "Cozzoli Machine Company")			
replace Villa_Pizza = 0 if strpos(employer, "La Villa Pizza & Family Restaurant") 
replace Villa_Pizza = 0 if strpos(employer, "Prosecco Fresh Italian Kitchen") 	
replace franchise_id  = 440 if Villa_Pizza >= 1 & franchise_id == .
replace franchise_id2 = 440 if Villa_Pizza >= 1 & franchise_id != .
replace franchise_id3 = 440 if Villa_Pizza >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Villa_Pizza >= 1
drop 	Villa_Pizza

gen 	Wayback_Burgers = strpos(lower(employer), "wayback burg")
replace franchise_id  = 441 if Wayback_Burgers >= 1 & franchise_id == .
replace franchise_id2 = 441 if Wayback_Burgers >= 1 & franchise_id != .
replace franchise_id3 = 441 if Wayback_Burgers >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Wayback_Burgers >= 1
drop 	Wayback_Burgers

gen 	Wendys = strpos(lower(employer), "wendy s ") | strpos(lower(employer), "wendy's ")
replace franchise_id  = 442 if Wendys >= 1 & franchise_id == .
replace franchise_id2 = 442 if Wendys >= 1 & franchise_id != .
replace franchise_id3 = 442 if Wendys >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Wendys >= 1
drop 	Wendys 

gen 	Which_Wich = strpos(lower(employer), "which wich") | strpos(lower(employer), "which which") | strpos(lower(employer), "whichwich")
replace franchise_id  = 443 if Which_Wich >= 1 & franchise_id == .
replace franchise_id2 = 443 if Which_Wich >= 1 & franchise_id != .
replace franchise_id3 = 443 if Which_Wich >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Which_Wich >= 1
drop 	Which_Wich

gen 	Wingstop = strpos(lower(employer), "wing stop") | strpos(lower(employer), "wingstop") | strpos(lower(employer), "wing-stop")
replace franchise_id  = 444 if Wingstop >= 1 & franchise_id == .
replace franchise_id2 = 444 if Wingstop >= 1 & franchise_id != .
replace franchise_id3 = 444 if Wingstop >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Wingstop >= 1
drop 	Wingstop

gen 	Zaxbys = strpos(lower(employer), "zaxby")
replace franchise_id  = 445 if Zaxbys >= 1 & franchise_id == .
replace franchise_id2 = 445 if Zaxbys >= 1 & franchise_id != .
replace franchise_id3 = 445 if Zaxbys >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Zaxbys >= 1
drop 	Zaxbys

gen 	Zoup = strpos(lower(employer), "zoup")
replace franchise_id  = 446 if Zoup >= 1 & franchise_id == .
replace franchise_id2 = 446 if Zoup >= 1 & franchise_id != .
replace franchise_id3 = 446 if Zoup >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Zoup >= 1
drop 	Zoup

gen 	Ace_Sushi = 	 strpos(lower(employer), "ace sushi")
replace Ace_Sushi = 0 if strpos(employer, "9Face Sushi In Pompano Beach")		
replace franchise_id  = 447 if Ace_Sushi >= 1 & franchise_id == .
replace franchise_id2 = 447 if Ace_Sushi >= 1 & franchise_id != .
replace franchise_id3 = 447 if Ace_Sushi >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Ace_Sushi >= 1
drop 	Ace_Sushi

gen 	Advanced_Fresh_Concepts = strpos(lower(employer), "advanced fresh")
replace franchise_id  = 448 if Advanced_Fresh_Concepts >= 1 & franchise_id == .
replace franchise_id2 = 448 if Advanced_Fresh_Concepts >= 1 & franchise_id != .
replace franchise_id3 = 448 if Advanced_Fresh_Concepts >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Advanced_Fresh_Concepts >= 1
drop 	Advanced_Fresh_Concepts 

gen 	Auntie_Annes = strpos(lower(employer), "auntie ann")
replace franchise_id  = 449 if Auntie_Annes >= 1 & franchise_id == .
replace franchise_id2 = 449 if Auntie_Annes >= 1 & franchise_id != .
replace franchise_id3 = 449 if Auntie_Annes >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Auntie_Annes >= 1
drop 	Auntie_Annes

gen 	Baskin_Robbins = strpos(lower(employer), "baskin robbin") | strpos(lower(employer), "baskinrobbin")
replace franchise_id  = 450 if Baskin_Robbins >= 1 & franchise_id == .
replace franchise_id2 = 450 if Baskin_Robbins >= 1 & franchise_id != .
replace franchise_id3 = 450 if Baskin_Robbins >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Baskin_Robbins >= 1
drop 	Baskin_Robbins

gen 	Ben_and_Jerrys = 	  strpos(lower(employer), "ben") & strpos(lower(employer), "jerry")
replace Ben_and_Jerrys = 0 if strpos(lower(employer), "jerry benson")
replace Ben_and_Jerrys = 0 if strpos(employer, "Jerry S Benzl")					
replace franchise_id  = 451 if Ben_and_Jerrys >= 1 & franchise_id == .
replace franchise_id2 = 451 if Ben_and_Jerrys >= 1 & franchise_id != .
replace franchise_id3 = 451 if Ben_and_Jerrys >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Ben_and_Jerrys >= 1
drop 	Ben_and_Jerrys

gen 	Biggby_Coffee = strpos(lower(employer), "biggby")
replace franchise_id  = 452 if Biggby_Coffee >= 1 & franchise_id == .
replace franchise_id2 = 452 if Biggby_Coffee >= 1 & franchise_id != .
replace franchise_id3 = 452 if Biggby_Coffee >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Biggby_Coffee >= 1
drop 	Biggby_Coffee

gen 	Caribou_Coffee = strpos(lower(employer), "caribou coff") | strpos(lower(employer), "cariboucoff")
replace franchise_id  = 453 if Caribou_Coffee >= 1 & franchise_id == .
replace franchise_id2 = 453 if Caribou_Coffee >= 1 & franchise_id != .
replace franchise_id3 = 453 if Caribou_Coffee >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Caribou_Coffee >= 1
drop 	Caribou_Coffee

gen 	Carvel = strpos(lower(employer), "carvel ice")	
replace franchise_id  = 454 if Carvel >= 1 & franchise_id == .
replace franchise_id2 = 454 if Carvel >= 1 & franchise_id != .
replace franchise_id3 = 454 if Carvel >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Carvel >= 1
drop 	Carvel

gen 	Cinnabon = strpos(lower(employer), "cinnabon")
replace franchise_id  = 455 if Cinnabon >= 1 & franchise_id == .
replace franchise_id2 = 455 if Cinnabon >= 1 & franchise_id != .
replace franchise_id3 = 455 if Cinnabon >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Cinnabon >= 1
drop 	Cinnabon

gen 	Cold_Stone = strpos(lower(employer), "cold stone") | strpos(lower(employer), "coldstone")
replace franchise_id  = 456 if Cold_Stone >= 1 & franchise_id == .
replace franchise_id2 = 456 if Cold_Stone >= 1 & franchise_id != .
replace franchise_id3 = 456 if Cold_Stone >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Cold_Stone >= 1
drop 	Cold_Stone 

gen 	Dippin_Dots = strpos(lower(employer), "dippin") & strpos(lower(employer), "dots")
replace franchise_id  = 457 if Dippin_Dots >= 1 & franchise_id == .
replace franchise_id2 = 457 if Dippin_Dots >= 1 & franchise_id != .
replace franchise_id3 = 457 if Dippin_Dots >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Dippin_Dots >= 1
drop 	Dippin_Dots

gen 	Doc_Popcorn = strpos(lower(employer), "doc popcorn")
replace franchise_id  = 458 if Doc_Popcorn >= 1 & franchise_id == .
replace franchise_id2 = 458 if Doc_Popcorn >= 1 & franchise_id != .
replace franchise_id3 = 458 if Doc_Popcorn >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Doc_Popcorn >= 1
drop 	Doc_Popcorn

gen 	Dunkin_Donuts = strpos(lower(employer), "dunkin do")
replace franchise_id  = 459 if Dunkin_Donuts >= 1 & franchise_id == .
replace franchise_id2 = 459 if Dunkin_Donuts >= 1 & franchise_id != .
replace franchise_id3 = 459 if Dunkin_Donuts >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Dunkin_Donuts >= 1
drop 	Dunkin_Donuts

gen 	Dunn_Bros_Coffee = strpos(lower(employer), "dunn bro")	
replace franchise_id  = 460 if Dunn_Bros_Coffee >= 1 & franchise_id == .
replace franchise_id2 = 460 if Dunn_Bros_Coffee >= 1 & franchise_id != .
replace franchise_id3 = 460 if Dunn_Bros_Coffee >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Dunn_Bros_Coffee >= 1
drop 	Dunn_Bros_Coffee

gen 	Edible_Arrangements = strpos(lower(employer), "edible arrang") | strpos(lower(employer), "edible to go")
replace franchise_id  = 461 if Edible_Arrangements >= 1 & franchise_id == .
replace franchise_id2 = 461 if Edible_Arrangements >= 1 & franchise_id != .
replace franchise_id3 = 461 if Edible_Arrangements >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Edible_Arrangements >= 1
drop 	Edible_Arrangements

gen 	Gigis_Cupcakes = strpos(lower(employer), "gigi") & strpos(lower(employer), "cupcak")
replace franchise_id  = 462 if Gigis_Cupcakes >= 1 & franchise_id == .
replace franchise_id2 = 462 if Gigis_Cupcakes >= 1 & franchise_id != .
replace franchise_id3 = 462 if Gigis_Cupcakes >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Gigis_Cupcakes >= 1
drop 	Gigis_Cupcakes

gen 	Great_American_Cookies = strpos(lower(employer), "great american cook")
replace franchise_id  = 463 if Great_American_Cookies >= 1 & franchise_id == .
replace franchise_id2 = 463 if Great_American_Cookies >= 1 & franchise_id != .
replace franchise_id3 = 463 if Great_American_Cookies >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Great_American_Cookies >= 1
drop 	Great_American_Cookies

gen 	Haagen_Dazs = strpos(lower(employer), "haagen da") | strpos(lower(employer), "hagen da")
replace franchise_id  = 464 if Haagen_Dazs >= 1 & franchise_id == .
replace franchise_id2 = 464 if Haagen_Dazs >= 1 & franchise_id != .
replace franchise_id3 = 464 if Haagen_Dazs >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Haagen_Dazs >= 1
drop 	Haagen_Dazs 

gen 	Jamba_Juice = 	   strpos(lower(employer), "jamba ju")
replace Jamba_Juice = 0 if strpos(employer, "Jamba Jumper")						
replace franchise_id  = 465 if Jamba_Juice >= 1 & franchise_id == .
replace franchise_id2 = 465 if Jamba_Juice >= 1 & franchise_id != .
replace franchise_id3 = 465 if Jamba_Juice >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Jamba_Juice >= 1
drop 	Jamba_Juice

gen 	Kilwins = strpos(lower(employer), "kilwin")
replace franchise_id  = 466 if Kilwins >= 1 & franchise_id == .
replace franchise_id2 = 466 if Kilwins >= 1 & franchise_id != .
replace franchise_id3 = 466 if Kilwins >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Kilwins >= 1
drop 	Kilwins

gen 	Kona_Ice = strpos(lower(employer), "kona ice")
replace franchise_id  = 467 if Kona_Ice >= 1 & franchise_id == .
replace franchise_id2 = 467 if Kona_Ice >= 1 & franchise_id != .
replace franchise_id3 = 467 if Kona_Ice >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Kona_Ice >= 1
drop 	Kona_Ice

gen 	Krispy_Kreme = strpos(lower(employer), "krispy kre")
replace franchise_id  = 468 if Krispy_Kreme >= 1 & franchise_id == .
replace franchise_id2 = 468 if Krispy_Kreme >= 1 & franchise_id != .
replace franchise_id3 = 468 if Krispy_Kreme >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Krispy_Kreme >= 1
drop 	Krispy_Kreme

gen 	Marble_Slab   = strpos(lower(employer), "marble slab")
replace franchise_id  = 469 if Marble_Slab >= 1 & franchise_id == .
replace franchise_id2 = 469 if Marble_Slab >= 1 & franchise_id != .
replace franchise_id3 = 469 if Marble_Slab >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Marble_Slab >= 1
drop 	Marble_Slab

gen 	Maui_Wowie = strpos(lower(employer), "maui wowi") 
replace franchise_id  = 470 if Maui_Wowie >= 1 & franchise_id == .
replace franchise_id2 = 470 if Maui_Wowie >= 1 & franchise_id != .
replace franchise_id3 = 470 if Maui_Wowie >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Maui_Wowie >= 1
drop 	Maui_Wowie

gen 	Menchies = strpos(lower(employer), "menchi")
replace franchise_id  = 471 if Menchies >= 1 & franchise_id == .
replace franchise_id2 = 471 if Menchies >= 1 & franchise_id != .
replace franchise_id3 = 471 if Menchies >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Menchies >= 1
drop 	Menchies

gen 	Nergize = strpos(lower(employer), "nrgize")	
replace franchise_id  = 472 if Nergize >= 1 & franchise_id == .
replace franchise_id2 = 472 if Nergize >= 1 & franchise_id != .
replace franchise_id3 = 472 if Nergize >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Nergize >= 1
drop 	Nergize

gen 	Nestle_Tollhouse = strpos(lower(employer), "nestle toll") | strpos(lower(employer), "nestletoll")
replace franchise_id  = 473 if Nestle_Tollhouse == 1 & franchise_id == .
replace franchise_id2 = 473 if Nestle_Tollhouse >= 1 & franchise_id != .
replace franchise_id3 = 473 if Nestle_Tollhouse >= 1 & franchise_id != . & franchise_id2 != .
* ?
tab 	employer 			if Nestle_Tollhouse >= 1
drop 	Nestle_Tollhouse

gen 	Nothing_Bundt_Cakes = strpos(lower(employer), "nothing bun") | strpos(lower(employer), "nothingbun")
replace franchise_id  = 474 if Nothing_Bundt_Cakes >= 1 & franchise_id == .
replace franchise_id2 = 474 if Nothing_Bundt_Cakes >= 1 & franchise_id != .
replace franchise_id3 = 474 if Nothing_Bundt_Cakes >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Nothing_Bundt_Cakes >= 1
drop 	Nothing_Bundt_Cakes

gen 	Orange_Leaf = strpos(lower(employer), "orange leaf")
replace franchise_id  = 475 if Orange_Leaf >= 1 & franchise_id == .
replace franchise_id2 = 475 if Orange_Leaf >= 1 & franchise_id != .
replace franchise_id3 = 475 if Orange_Leaf >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer			if Orange_Leaf >= 1
drop 	Orange_Leaf 

gen 	Pinkberry = 	 strpos(lower(employer), "pinkber") | strpos(lower(employer), "pink ber")
replace Pinkberry = 0 if strpos(employer, "The Pink Berets")					
replace franchise_id  = 476 if Pinkberry >= 1 & franchise_id == .
replace franchise_id2 = 476 if Pinkberry >= 1 & franchise_id != .
replace franchise_id3 = 476 if Pinkberry >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Pinkberry >= 1
drop 	Pinkberry 

gen 	Planet_Smoothie = strpos(lower(employer), "planet smooth")
replace franchise_id  = 477 if Planet_Smoothie >= 1 & franchise_id == .
replace franchise_id2 = 477 if Planet_Smoothie >= 1 & franchise_id != .
replace franchise_id3 = 477 if Planet_Smoothie >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Planet_Smoothie >= 1
drop 	Planet_Smoothie 

gen 	Robeks = strpos(lower(employer), "robeks")
replace franchise_id  = 478 if Robeks >= 1 & franchise_id == .
replace franchise_id2 = 478 if Robeks >= 1 & franchise_id != .
replace franchise_id3 = 478 if Robeks >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Robeks >= 1
drop 	Robeks

gen 	Scooters_Coffee = strpos(lower(employer), "scooters cof") | strpos(lower(employer), "scooter's cof")
replace franchise_id  = 479 if Scooters_Coffee >= 1 & franchise_id == .
replace franchise_id2 = 479 if Scooters_Coffee >= 1 & franchise_id != .
replace franchise_id3 = 479 if Scooters_Coffee >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Scooters_Coffee >= 1
drop 	Scooters_Coffee

gen 	Smoothie_King = strpos(lower(employer), "smoothie king") | strpos(lower(employer), "smoothieking") 
replace franchise_id  = 480 if Smoothie_King >= 1 & franchise_id == .
replace franchise_id2 = 480 if Smoothie_King >= 1 & franchise_id != .
replace franchise_id3 = 480 if Smoothie_King >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Smoothie_King >= 1
drop 	Smoothie_King

gen 	Surf_City = strpos(lower(employer), "surf city sq")	
replace franchise_id  = 481 if Surf_City >= 1 & franchise_id == .
replace franchise_id2 = 481 if Surf_City >= 1 & franchise_id != .
replace franchise_id3 = 481 if Surf_City >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Surf_City >= 1
drop 	Surf_City

gen 	Sweet_Frog = strpos(lower(employer), "sweet frog") | strpos(lower(employer), "sweetfrog")
replace franchise_id  = 482 if Sweet_Frog >= 1 & franchise_id == .
replace franchise_id2 = 482 if Sweet_Frog >= 1 & franchise_id != .
replace franchise_id3 = 482 if Sweet_Frog >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Sweet_Frog >= 1
drop 	Sweet_Frog

gen 	TCBY_Mrs_Fields = strpos(lower(employer), "tcby") | strpos(lower(employer), "mrsfields") | strpos(lower(employer), "mrs fields")
replace franchise_id  = 483 if TCBY_Mrs_Fields >= 1 & franchise_id == .
replace franchise_id2 = 483 if TCBY_Mrs_Fields >= 1 & franchise_id != .
replace franchise_id3 = 483 if TCBY_Mrs_Fields >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if TCBY_Mrs_Fields >= 1
drop 	TCBY_Mrs_Fields

gen 	Tim_Hortons = strpos(lower(employer), "tim horton")
replace franchise_id  = 484 if Tim_Hortons >= 1 & franchise_id == .
replace franchise_id2 = 484 if Tim_Hortons >= 1 & franchise_id != .
replace franchise_id3 = 484 if Tim_Hortons >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Tim_Hortons >= 1
drop 	Tim_Hortons

gen 	Tropical_Smoothie = strpos(lower(employer), "tropical smooth")
replace franchise_id  = 485 if Tropical_Smoothie >= 1 & franchise_id == .
replace franchise_id2 = 485 if Tropical_Smoothie >= 1 & franchise_id != .
replace franchise_id3 = 485 if Tropical_Smoothie >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Tropical_Smoothie >= 1
drop 	Tropical_Smoothie

gen 	Wetzels_Pretzels = strpos(lower(employer), "wetzel") & strpos(lower(employer), "pretzel")
replace franchise_id  = 486 if Wetzels_Pretzels >= 1 & franchise_id == .
replace franchise_id2 = 486 if Wetzels_Pretzels >= 1 & franchise_id != .
replace franchise_id3 = 486 if Wetzels_Pretzels >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Wetzels_Pretzels >= 1
drop 	Wetzels_Pretzels

gen 	Christian_Bros = strpos(lower(employer), "christian bros auto") | strpos(lower(employer), "christian brothers auto") 
replace franchise_id  = 487 if Christian_Bros >= 1 & franchise_id == .
replace franchise_id2 = 487 if Christian_Bros >= 1 & franchise_id != .
replace franchise_id3 = 487 if Christian_Bros >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Christian_Bros >= 1
drop 	Christian_Bros

gen 	Tuffy_Auto = strpos(lower(employer), "tuffy") & strpos(lower(employer), "auto")
replace franchise_id  = 488 if Tuffy_Auto >= 1 & franchise_id == .
replace franchise_id2 = 488 if Tuffy_Auto >= 1 & franchise_id != .
replace franchise_id3 = 488 if Tuffy_Auto >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Tuffy_Auto >= 1
drop 	Tuffy_Auto

gen 	Meineke = strpos(lower(employer), "meineke")
replace franchise_id  = 489 if Meineke >= 1 & franchise_id == .
replace franchise_id2 = 489 if Meineke >= 1 & franchise_id != .
replace franchise_id3 = 489 if Meineke >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Meineke >= 1
drop 	Meineke

gen 	Midas = 	 strpos(lower(employer), "midas")
replace Midas = 0 if strpos(employer, "637 Midas Fabric & Blinds")				
replace Midas = 0 if strpos(employer, "Armidas")								
replace Midas = 0 if strpos(employer, "Comidas")								
replace Midas = 0 if strpos(employer, "Company Midasco, Llc")					
replace Midas = 0 if strpos(employer, "Comtech/Usda Midas")						
replace Midas = 0 if strpos(employer, "Dr Midas Medical Group, Inc")			
replace Midas = 0 if strpos(employer, "Jl Midas Breathe Kleen Aire")			
replace Midas = 0 if strpos(employer, "Keramidas Law Firm")						
replace Midas = 0 if strpos(employer, "Micromidas Inc")							
replace Midas = 0 if strpos(employer, "Midas Construction Company")				
replace Midas = 0 if strpos(employer, "Midas Convention Service Inc")			
replace Midas = 0 if strpos(employer, "Midas Council Of Governments")			
replace Midas = 0 if strpos(employer, "Midas Creek Home Health")				
replace Midas = 0 if strpos(employer, "Midas Education, Llc")					
replace Midas = 0 if strpos(employer, "Midas Express")							
replace Midas = 0 if strpos(employer, "Midas Exchange")							
replace Midas = 0 if strpos(employer, "Midas Fabric & Blinds")					
replace Midas = 0 if strpos(employer, "Midas Foods International")				
replace Midas = 0 if strpos(employer, "Midas Gold")								
replace Midas = 0 if strpos(employer, "Midas Health")							
replace Midas = 0 if strpos(employer, "Midas Hospitality")						
replace Midas = 0 if strpos(employer, "Midas Management")						
replace Midas = 0 if strpos(employer, "Midas Marketing")						
replace Midas = 0 if strpos(employer, "Midas Minds")							
replace Midas = 0 if strpos(employer, "Midas Movers")							
replace Midas = 0 if strpos(employer, "Midas Operations Llc")					
replace Midas = 0 if strpos(employer, "Midas Pharma")							
replace Midas = 0 if strpos(employer, "Midas Property Management")				
replace Midas = 0 if strpos(employer, "Midas Selection")						
replace Midas = 0 if strpos(employer, "Midas Shipping")							
replace Midas = 0 if strpos(employer, "Midas Soccer Academy")					
replace Midas = 0 if strpos(employer, "Midas Solutions")						
replace Midas = 0 if strpos(employer, "Midas Technologies Ltd")					
replace Midas = 0 if strpos(employer, "Midas Touch Therapy Llc")				
replace Midas = 0 if strpos(employer, "Midas Underwriting Ltd")					
replace Midas = 0 if strpos(employer, "Midas Utilities")						
replace Midas = 0 if strpos(employer, "Midas Vision Systems, Inc")				
replace Midas = 0 if strpos(employer, "Midascare Pharmaceuticals")				
replace Midas = 0 if strpos(employer, "Midasco")								
replace Midas = 0 if strpos(employer, "Midashospitality")						
replace Midas = 0 if strpos(employer, "Midasis")								
replace Midas = 0 if strpos(employer, "Midasoft Incorporated")					
replace Midas = 0 if strpos(employer, "Music Group Midas")						
replace Midas = 0 if strpos(employer, "Nirmidas Biotech, Inc")					
replace Midas = 0 if strpos(employer, "The Midas Collaborative")				
replace Midas = 0 if strpos(employer, "The Midas Companies")					
replace franchise_id  = 490 if Midas >= 1 & franchise_id == .
replace franchise_id2 = 490 if Midas >= 1 & franchise_id != .
replace franchise_id3 = 490 if Midas >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Midas >= 1
drop 	Midas


gen 	Speedee = 	   strpos(lower(employer), "speedee")
replace Speedee = 0 if strpos(employer, "Speedee Cash")							
replace Speedee = 0 if strpos(employer, "Speedee Mart")							
replace Speedee = 0 if strpos(employer, "Speedee Delivery")						
replace Speedee = 0 if strpos(employer, "Speedee Loans")						
replace Speedee = 0 if strpos(employer, "Speedee Milwaukee")					
replace Speedee = 0 if strpos(employer, "Speedee Printing")						
replace Speedee = 0 if strpos(employer, "Speedee Movers")						
replace franchise_id  = 491 if Speedee >= 1 & franchise_id == .
replace franchise_id2 = 491 if Speedee >= 1 & franchise_id != .
replace franchise_id3 = 491 if Speedee >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Speedee >= 1
drop 	Speedee 

gen 	Aamco = 	 strpos(lower(employer), "aamco")
replace Aamco = 0 if strpos(employer, "Aamcom")									
replace Aamco = 0 if strpos(employer, "Aamcor")									
replace Aamco = 0 if strpos(employer, "Jaamco Drain")							
replace Aamco = 0 if strpos(employer, "Paamco")									
replace Aamco = 0 if strpos(employer, "Raamco")									
replace Aamco = 0 if strpos(employer, "Saamco")									
replace franchise_id  = 492 if Aamco >= 1 & franchise_id == .
replace franchise_id2 = 492 if Aamco >= 1 & franchise_id != .
replace franchise_id3 = 492 if Aamco >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Aamco >= 1
drop 	Aamco

gen 	Mr_Fix_It = (strpos(lower(employer), "milex") & strpos(lower(employer), "auto")) | (strpos(lower(employer), "mr fix it auto"))
replace franchise_id  = 493 if Mr_Fix_It >= 1 & franchise_id == .
replace franchise_id2 = 493 if Mr_Fix_It >= 1 & franchise_id != .
replace franchise_id3 = 493 if Mr_Fix_It >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Mr_Fix_It >= 1
drop 	Mr_Fix_It

gen 	Carstar = strpos(lower(employer), "carstar")
replace franchise_id  = 494 if Carstar >= 1 & franchise_id == .
replace franchise_id2 = 494 if Carstar >= 1 & franchise_id != .
replace franchise_id3 = 494 if Carstar >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Carstar >= 1
drop 	Carstar

gen 	Maaco = strpos(lower(employer), "maaco")
replace franchise_id  = 495 if Maaco >= 1 & franchise_id == .
replace franchise_id2 = 495 if Maaco >= 1 & franchise_id != .
replace franchise_id3 = 495 if Maaco >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Maaco >= 1
drop 	Maaco 

gen 	Novus_Glass = strpos(lower(employer), "novus") & strpos(lower(employer), "glass")
replace franchise_id  = 496 if Novus_Glass >= 1 & franchise_id == .
replace franchise_id2 = 496 if Novus_Glass >= 1 & franchise_id != .
replace franchise_id3 = 496 if Novus_Glass >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Novus_Glass >= 1
drop 	Novus_Glass

gen 	Grease_Monkey = 	 strpos(lower(employer), "grease monk") | strpos(lower(employer), "greasemonk")
replace Grease_Monkey = 0 if strpos(employer, "Greasemonkey Project")			
replace Grease_Monkey = 0 if strpos(employer, "Greasemonkey Production")		
replace Grease_Monkey = 0 if strpos(employer, "Grease Monkeys Sports Bar And Gril") 
replace franchise_id  = 497 if Grease_Monkey >= 1 & franchise_id == .
replace franchise_id2 = 497 if Grease_Monkey >= 1 & franchise_id != .
replace franchise_id3 = 497 if Grease_Monkey >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer			if Grease_Monkey >= 1
drop 	Grease_Monkey

gen 	Jiffy_Lube = strpos(lower(employer), "jiffy lube")
replace franchise_id  = 498 if Jiffy_Lube >= 1 & franchise_id == .
replace franchise_id2 = 498 if Jiffy_Lube >= 1 & franchise_id != .
replace franchise_id3 = 498 if Jiffy_Lube >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Jiffy_Lube >= 1
drop 	Jiffy_Lube

gen 	Valvoline = strpos(lower(employer), "valvoline")
replace franchise_id  = 499 if Valvoline >= 1 & franchise_id == .
replace franchise_id2 = 499 if Valvoline >= 1 & franchise_id != .
replace franchise_id3 = 499 if Valvoline >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Valvoline >= 1
drop 	Valvoline

gen 	Line_X = 	  strpos(lower(employer), "line x")
replace Line_X = 0 if strpos(lower(employer), "xpress")
replace Line_X = 0 if strpos(employer, "Bergenline X Ray")						
replace Line_X = 0 if strpos(employer, "Xsnonline Xtreme Sports Nutrition, Inc") 
replace franchise_id  = 500 if Line_X >= 1 & franchise_id == .
replace franchise_id2 = 500 if Line_X >= 1 & franchise_id != .
replace franchise_id3 = 500 if Line_X >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Line_X >= 1
drop 	Line_X

gen 	Michelin = 		strpos(lower(employer), "michelin")
replace Michelin = 0 if strpos(lower(employer), "michelina")
replace Michelin = 0 if strpos(employer, "Michelini")							
replace Michelin = 0 if strpos(employer, "Micheline")							
replace Michelin = 0 if strpos(employer, "Michelinos")							
replace franchise_id  = 501 if Michelin >= 1 & franchise_id == .
replace franchise_id2 = 501 if Michelin >= 1 & franchise_id != .
replace franchise_id3 = 501 if Michelin >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Michelin >= 1
drop 	Michelin

gen 	Cell_Phone_Repair = strpos(lower(employer), "cell phone repair")
replace franchise_id  = 502 if Cell_Phone_Repair >= 1 & franchise_id == .
replace franchise_id2 = 502 if Cell_Phone_Repair >= 1 & franchise_id != .
replace franchise_id3 = 502 if Cell_Phone_Repair >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Cell_Phone_Repair >= 1
drop 	Cell_Phone_Repair

gen 	UBreakIFix = strpos(lower(employer), "ubreakifix")
replace franchise_id  = 503 if UBreakIFix >= 1 & franchise_id == .
replace franchise_id2 = 503 if UBreakIFix >= 1 & franchise_id != .
replace franchise_id3 = 503 if UBreakIFix >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if UBreakIFix >= 1
drop 	UBreakIFix

gen 	Hoodz = 	 strpos(lower(employer), "hoodz")
replace Hoodz = 0 if strpos(lower(employer), "neighbor") | strpos(lower(employer), "art graph")
replace Hoodz = 0 if strpos(employer, "Elitehoodzprotection")					
replace franchise_id  = 504 if Hoodz >= 1 & franchise_id == .
replace franchise_id2 = 504 if Hoodz >= 1 & franchise_id != .
replace franchise_id3 = 504 if Hoodz >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer			if Hoodz >= 1
drop 	Hoodz

gen 	Furniture_Medic = strpos(lower(employer), "furniture medic")
replace franchise_id  = 505 if Furniture_Medic >= 1 & franchise_id == .
replace franchise_id2 = 505 if Furniture_Medic >= 1 & franchise_id != .
replace franchise_id3 = 505 if Furniture_Medic >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Furniture_Medic >= 1
drop 	Furniture_Medic

gen 	Jewelry_Repair = strpos(lower(employer), "fast fix")
replace franchise_id  = 506 if Jewelry_Repair >= 1 & franchise_id == .
replace franchise_id2 = 506 if Jewelry_Repair >= 1 & franchise_id != .
replace franchise_id3 = 506 if Jewelry_Repair >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Jewelry_Repair >= 1
drop 	Jewelry_Repair

gen 	Sports_Clips = strpos(lower(employer), "sport clip") | strpos(lower(employer), "sportsclip")
replace franchise_id  = 507 if Sports_Clips >= 1 & franchise_id == .
replace franchise_id2 = 507 if Sports_Clips >= 1 & franchise_id != .
replace franchise_id3 = 507 if Sports_Clips >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Sports_Clips >= 1
drop 	Sports_Clips

gen 	Fantastic_Sams = strpos(lower(employer), "fantastic sam") | strpos(lower(employer), "fantasticsam")
replace franchise_id  = 508 if Fantastic_Sams >= 1 & franchise_id == .
replace franchise_id2 = 508 if Fantastic_Sams >= 1 & franchise_id != .
replace franchise_id3 = 508 if Fantastic_Sams >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Fantastic_Sams >= 1
drop 	Fantastic_Sams

gen 	Great_Clips = strpos(lower(employer), "greatclips") | strpos(lower(employer), "great clip")
replace franchise_id  = 509 if Great_Clips >= 1 & franchise_id == .
replace franchise_id2 = 509 if Great_Clips >= 1 & franchise_id != .
replace franchise_id3 = 509 if Great_Clips >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Great_Clips >= 1
drop 	Great_Clips

gen 	Phenix_Salon = strpos(lower(employer), "phenix salon")
replace franchise_id  = 510 if Phenix_Salon >= 1 & franchise_id == .
replace franchise_id2 = 510 if Phenix_Salon >= 1 & franchise_id != .
replace franchise_id3 = 510 if Phenix_Salon >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Phenix_Salon >= 1
drop 	Phenix_Salon

gen 	Sola_Salon = strpos(lower(employer), "sola sal")
replace franchise_id  = 511 if Sola_Salon >= 1 & franchise_id == .
replace franchise_id2 = 511 if Sola_Salon >= 1 & franchise_id != .
replace franchise_id3 = 511 if Sola_Salon >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Sola_Salon >= 1
drop 	Sola_Salon

gen 	Supercuts = strpos(lower(employer), "super cuts") | strpos(lower(employer), "supercuts")
replace franchise_id  = 512 if Supercuts >= 1 & franchise_id == .
replace franchise_id2 = 512 if Supercuts >= 1 & franchise_id != .
replace franchise_id3 = 512 if Supercuts >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Supercuts >= 1
drop 	Supercuts

gen 	Davi_Nails = strpos(lower(employer), "davi nail")
replace franchise_id  = 513 if Davi_Nails >= 1 & franchise_id == .
replace franchise_id2 = 513 if Davi_Nails >= 1 & franchise_id != .
replace franchise_id3 = 513 if Davi_Nails >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Davi_Nails >= 1
drop 	Davi_Nails

gen 	Regal_Nails = strpos(lower(employer), "regal nail")
replace franchise_id  = 514 if Regal_Nails >= 1 & franchise_id == .
replace franchise_id2 = 514 if Regal_Nails >= 1 & franchise_id != .
replace franchise_id3 = 514 if Regal_Nails >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Regal_Nails >= 1
drop 	Regal_Nails

gen 	Elements_Massage = 		strpos(lower(employer), "element") & strpos(lower(employer), "massage")
replace Elements_Massage = 0 if strpos(employer, "Elemental Massage Therapy & Spa")					
replace Elements_Massage = 0 if strpos(employer, "The Elements Massage Skin Laser & Weight Loss")	
replace Elements_Massage = 0 if strpos(employer, "The Elements Massage, Skin, Laser & Weight Loss")	
replace Elements_Massage = 0 if strpos(employer, "Therapeutic Elements Center For Massage Therapy")	
replace franchise_id  = 515 if Elements_Massage >= 1 & franchise_id == .
replace franchise_id2 = 515 if Elements_Massage >= 1 & franchise_id != .
replace franchise_id3 = 515 if Elements_Massage >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Elements_Massage >= 1
drop 	Elements_Massage

gen 	Euro_Wax_Center = strpos(lower(employer), "european wax")
replace franchise_id  = 516 if Euro_Wax_Center >= 1 & franchise_id == .
replace franchise_id2 = 516 if Euro_Wax_Center >= 1 & franchise_id != .
replace franchise_id3 = 516 if Euro_Wax_Center >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Euro_Wax_Center >= 1
drop 	Euro_Wax_Center

gen 	Hand_and_Stone = strpos(lower(employer), "hand & stone") | strpos(lower(employer), "hand and stone") | strpos(lower(employer), "hand andstone") | strpos(lower(employer), "hand&stone")
replace franchise_id  = 517 if Hand_and_Stone >= 1 & franchise_id == .
replace franchise_id2 = 517 if Hand_and_Stone >= 1 & franchise_id != .
replace franchise_id3 = 517 if Hand_and_Stone >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Hand_and_Stone >= 1
drop 	Hand_and_Stone

gen 	Massage_Envy = strpos(lower(employer), "massage envy") | strpos(lower(employer), "massageenvy")
replace franchise_id  = 518 if Massage_Envy >= 1 & franchise_id == .
replace franchise_id2 = 518 if Massage_Envy >= 1 & franchise_id != .
replace franchise_id3 = 518 if Massage_Envy >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Massage_Envy >= 1
drop 	Massage_Envy

gen 	Massage_Green = 	 strpos(lower(employer), "massage green") | strpos(lower(employer), "massagegre")
replace Massage_Green = 0 if strpos(employer, "Elements Massage Green Hills")	
replace Massage_Green = 0 if strpos(employer, "Elements Massage Green Lake")	
replace Massage_Green = 0 if strpos(employer, "Elements Massage Green Valley")	
replace franchise_id  = 519 if Massage_Green >= 1 & franchise_id == .
replace franchise_id2 = 519 if Massage_Green >= 1 & franchise_id != .
replace franchise_id3 = 519 if Massage_Green >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Massage_Green >= 1
drop 	Massage_Green

gen 	Massage_Heights = strpos(lower(employer), "massage height")
replace franchise_id  = 520 if Massage_Heights >= 1 & franchise_id == .
replace franchise_id2 = 520 if Massage_Heights >= 1 & franchise_id != .
replace franchise_id3 = 520 if Massage_Heights >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Massage_Heights >= 1
drop 	Massage_Heights

gen 	Palm_Beach_Tan = strpos(lower(employer), "palm beach tan")
replace franchise_id  = 521 if Palm_Beach_Tan >= 1 & franchise_id == .
replace franchise_id2 = 521 if Palm_Beach_Tan >= 1 & franchise_id != .
replace franchise_id3 = 521 if Palm_Beach_Tan >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Palm_Beach_Tan >= 1
drop 	Palm_Beach_Tan

gen 	Planet_Beach = strpos(lower(employer), "planet beach")
replace franchise_id  = 522 if Planet_Beach >= 1 & franchise_id == .
replace franchise_id2 = 522 if Planet_Beach >= 1 & franchise_id != .
replace franchise_id3 = 522 if Planet_Beach >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Planet_Beach >= 1
drop 	Planet_Beach

gen 	Seva_Beauty = strpos(lower(employer), "seva beaut") | strpos(lower(employer), "sevabeaut")
replace franchise_id  = 523 if Seva_Beauty >= 1 & franchise_id == .
replace franchise_id2 = 523 if Seva_Beauty >= 1 & franchise_id != .
replace franchise_id3 = 523 if Seva_Beauty >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Seva_Beauty >= 1
drop 	Seva_Beauty 

gen 	Sun_Tan_City = strpos(lower(employer), "sun tan cit") | strpos(lower(employer), "suntancit")
replace franchise_id  = 524 if Sun_Tan_City >= 1 & franchise_id == .
replace franchise_id2 = 524 if Sun_Tan_City >= 1 & franchise_id != .
replace franchise_id3 = 524 if Sun_Tan_City >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Sun_Tan_City >= 1
drop 	Sun_Tan_City

gen 	CRDN = strpos(lower(employer), "crdn") | (strpos(lower(employer), "certified") & strpos(lower(employer), "dryclean")) 
replace franchise_id  = 525 if CRDN >= 1 & franchise_id == .
replace franchise_id2 = 525 if CRDN >= 1 & franchise_id != .
replace franchise_id3 = 525 if CRDN >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if CRDN >= 1
drop 	CRDN

gen 	Fibrenew = strpos(lower(employer), "fibrenew")
replace franchise_id  = 526 if Fibrenew >= 1 & franchise_id == .
replace franchise_id2 = 526 if Fibrenew >= 1 & franchise_id != .
replace franchise_id3 = 526 if Fibrenew >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Fibrenew >= 1
drop 	Fibrenew

gen 	Martinizing = strpos(lower(employer), "martinizing")
replace franchise_id  = 527 if Martinizing >= 1 & franchise_id == .
replace franchise_id2 = 527 if Martinizing >= 1 & franchise_id != .
replace franchise_id3 = 527 if Martinizing >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Martinizing >= 1
drop 	Martinizing

gen 	Camp_Bow_Wow = strpos(lower(employer), "camp bowwow") | strpos(lower(employer), "camp bow wow")
replace franchise_id  = 528 if Camp_Bow_Wow >= 1 & franchise_id == .
replace franchise_id2 = 528 if Camp_Bow_Wow >= 1 & franchise_id != .
replace franchise_id3 = 528 if Camp_Bow_Wow >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Camp_Bow_Wow >= 1
drop 	Camp_Bow_Wow

gen 	Fetch_Pet_Care = strpos(lower(employer), "fetch pet c")
replace franchise_id  = 529 if Fetch_Pet_Care >= 1 & franchise_id == .
replace franchise_id2 = 529 if Fetch_Pet_Care >= 1 & franchise_id != .
replace franchise_id3 = 529 if Fetch_Pet_Care >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer			if Fetch_Pet_Care >= 1
drop 	Fetch_Pet_Care

gen 	Tailored_Living = 	   strpos(lower(employer), "tailored liv")
replace Tailored_Living = 0 if strpos(employer, "Tailored Living Choices")		
replace franchise_id  = 530 if Tailored_Living >= 1 & franchise_id == .
replace franchise_id2 = 530 if Tailored_Living >= 1 & franchise_id != .
replace franchise_id3 = 530 if Tailored_Living >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Tailored_Living >= 1
drop 	Tailored_Living



* d) Fill-up "franchise_id" variables: for each of the chains in the WA AG file but not on the contract file
gen 	MerryMaids = strpos(lower(employer), "merry maid") | strpos(lower(employer), "merrymaid")
replace franchise_id  = 531 if MerryMaids >= 1 & franchise_id == .
replace franchise_id2 = 531 if MerryMaids >= 1 & franchise_id != .
replace franchise_id3 = 531 if MerryMaids >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if MerryMaids >= 1
drop 	MerryMaids
replace naics4d_ag 	  = 5617 if franchise_id == 531	

gen 	JackInTheBox = strpos(lower(employer), "jack in the box") | strpos(lower(employer), "jackinthebox")
replace franchise_id  = 532 if JackInTheBox >= 1 & franchise_id == .
replace franchise_id2 = 532 if JackInTheBox >= 1 & franchise_id != .
replace franchise_id3 = 532 if JackInTheBox >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if JackInTheBox >= 1
drop 	JackInTheBox
replace naics4d_ag 	  = 7225 if franchise_id == 532

gen 	TheOriginalPancakeHouse = strpos(lower(employer), "original pancake") | strpos(lower(employer), "originalpancake")
replace franchise_id  = 533 if TheOriginalPancakeHouse >= 1 & franchise_id == .
replace franchise_id2 = 533 if TheOriginalPancakeHouse >= 1 & franchise_id != .
replace franchise_id3 = 533 if TheOriginalPancakeHouse >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if TheOriginalPancakeHouse >= 1
drop 	TheOriginalPancakeHouse
replace naics4d_ag 	  = 7225 if franchise_id == 533

gen 	BonefishGrill = strpos(lower(employer), "bonefish grill") | strpos(lower(employer), "bonefishgrill") | strpos(lower(employer), "bone fish grill")
replace franchise_id  = 534 if BonefishGrill >= 1 & franchise_id == .
replace franchise_id2 = 534 if BonefishGrill >= 1 & franchise_id != .
replace franchise_id3 = 534 if BonefishGrill >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if BonefishGrill >= 1
drop 	BonefishGrill
replace naics4d_ag 	  = 7225 if franchise_id == 534

gen 	CarrabbasItalianGrill = strpos(lower(employer), "carrabba's") | strpos(lower(employer), "carrabbas")
replace franchise_id  = 535 if CarrabbasItalianGrill >= 1 & franchise_id == .
replace franchise_id2 = 535 if CarrabbasItalianGrill >= 1 & franchise_id != .
replace franchise_id3 = 535 if CarrabbasItalianGrill >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if CarrabbasItalianGrill >= 1
drop 	CarrabbasItalianGrill
replace naics4d_ag 	  = 7225 if franchise_id == 535

gen 	OutbackSteakhouse = strpos(lower(employer), "outback") & (strpos(lower(employer), "steak") | strpos(lower(employer), "carrabas") | strpos(lower(employer), "express") | strpos(lower(employer), "bonefish"))
replace franchise_id  = 536 if OutbackSteakhouse >= 1 & franchise_id == .
replace franchise_id2 = 536 if OutbackSteakhouse >= 1 & franchise_id != .
replace franchise_id3 = 536 if OutbackSteakhouse >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if OutbackSteakhouse >= 1
drop 	OutbackSteakhouse
replace naics4d_ag 	  = 7225 if franchise_id == 536

gen 	LandLFranchising = (strpos(lower(employer), "l&l") | strpos(lower(employer), "l & l") | strpos(lower(employer), "landl") | strpos(lower(employer), "l and l")) & ///
						   (strpos(lower(employer), "hawai") | strpos(lower(employer), "franch"))
replace franchise_id  = 537 if LandLFranchising >= 1 & franchise_id == .
replace franchise_id2 = 537 if LandLFranchising >= 1 & franchise_id != .
replace franchise_id3 = 537 if LandLFranchising >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if LandLFranchising >= 1
drop 	LandLFranchising
replace naics4d_ag 	  = 7225 if franchise_id == 537

gen 	WestsidePizza = strpos(lower(employer), "west side pizza") | strpos(lower(employer), "westside pizza") | strpos(lower(employer), "westsidepizza")
replace franchise_id  = 538 if WestsidePizza >= 1 & franchise_id == .
replace franchise_id2 = 538 if WestsidePizza >= 1 & franchise_id != .
replace franchise_id3 = 538 if WestsidePizza >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if WestsidePizza >= 1
drop 	WestsidePizza
replace naics4d_ag 	  = 7225 if franchise_id == 538

gen 	ZeeksPizza = 	  strpos(lower(employer), "zeek's pizza") | strpos(lower(employer), "zeeks pizza") | strpos(lower(employer), "zeekspizza")
replace ZeeksPizza = 0 if strpos(employer, "Zesty")								
replace franchise_id  = 539 if ZeeksPizza >= 1 & franchise_id == .
replace franchise_id2 = 539 if ZeeksPizza >= 1 & franchise_id != .
replace franchise_id3 = 539 if ZeeksPizza >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if ZeeksPizza >= 1
drop 	ZeeksPizza
replace naics4d_ag 	  = 7225 if franchise_id == 539

gen 	MioSushi = strpos(lower(employer), "mio sushi") | strpos(lower(employer), "miosushi")
replace franchise_id  = 540 if MioSushi >= 1 & franchise_id == .
replace franchise_id2 = 540 if MioSushi >= 1 & franchise_id != .
replace franchise_id3 = 540 if MioSushi >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if MioSushi >= 1
drop 	MioSushi
replace naics4d_ag 	  = 7225 if franchise_id == 540

gen 	FigarosPizza = strpos(lower(employer), "figaro's pizza") | strpos(lower(employer), "figaros pizza") | strpos(lower(employer), "figarospizza")
replace franchise_id  = 541 if FigarosPizza >= 1 & franchise_id == .
replace franchise_id2 = 541 if FigarosPizza >= 1 & franchise_id != .
replace franchise_id3 = 541 if FigarosPizza >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if FigarosPizza >= 1
drop 	FigarosPizza
replace naics4d_ag 	  = 7225 if franchise_id == 541

gen 	TheHabitBurgerGrill = strpos(lower(employer), "habit burger") | strpos(lower(employer), "habitburger")
replace franchise_id  = 542 if TheHabitBurgerGrill >= 1 & franchise_id == .
replace franchise_id2 = 542 if TheHabitBurgerGrill >= 1 & franchise_id != .
replace franchise_id3 = 542 if TheHabitBurgerGrill >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if TheHabitBurgerGrill >= 1
drop 	TheHabitBurgerGrill
replace naics4d_ag 	  = 7225 if franchise_id == 542	

gen 	ITEXCorporation = 	   strpos(employer, "Itex ") | strpos(employer, "ITEX ")
replace ITEXCorporation = 0 if strpos(employer, "Itex Enterprise Solutions")	
replace ITEXCorporation = 0 if strpos(employer, "Itex Piping Products")			
replace ITEXCorporation = 0 if strpos(employer, "Itex Property Management")		
replace franchise_id  = 543 if ITEXCorporation >= 1 & franchise_id == .
replace franchise_id2 = 543 if ITEXCorporation >= 1 & franchise_id != .
replace franchise_id3 = 543 if ITEXCorporation >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if ITEXCorporation >= 1
drop 	ITEXCorporation
replace naics4d_ag 	  = 5416 if franchise_id == 543

gen 	Frugals = strpos(lower(employer), "frugals") | strpos(lower(employer), "frugal burger") | strpos(lower(employer), "frugalburger")
replace franchise_id  = 544 if Frugals >= 1 & franchise_id == .
replace franchise_id2 = 544 if Frugals >= 1 & franchise_id != .
replace franchise_id3 = 544 if Frugals >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Frugals >= 1
drop 	Frugals
replace naics4d_ag 	  = 7225 if franchise_id == 544	

gen 	KungFuTea = strpos(lower(employer), "kung fu tea") | strpos(lower(employer), "kungfutea")
replace franchise_id  = 545 if KungFuTea >= 1 & franchise_id == .
replace franchise_id2 = 545 if KungFuTea >= 1 & franchise_id != .
replace franchise_id3 = 545 if KungFuTea >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if KungFuTea >= 1
drop 	KungFuTea
replace naics4d_ag 	  = 7225 if franchise_id == 545	

gen 	MattressDepot = strpos(lower(employer), "mattress depot") | strpos(lower(employer), "mattressdepot")
replace franchise_id  = 546 if MattressDepot >= 1 & franchise_id == .
replace franchise_id2 = 546 if MattressDepot >= 1 & franchise_id != .
replace franchise_id3 = 546 if MattressDepot >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if MattressDepot >= 1
drop 	MattressDepot
replace naics4d_ag 	  = 4421 if franchise_id == 546	

gen 	TanRepublic = strpos(lower(employer), "tan republic") | strpos(lower(employer), "tanrepublic")
replace franchise_id  = 547 if TanRepublic >= 1 & franchise_id == .
replace franchise_id2 = 547 if TanRepublic >= 1 & franchise_id != .
replace franchise_id3 = 547 if TanRepublic >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if TanRepublic >= 1
drop 	TanRepublic
replace naics4d_ag 	  = 8121 if franchise_id == 547

gen 	ChuckECheeses = strpos(lower(employer), "chuck") & strpos(lower(employer), "cheese")
replace franchise_id  = 548 if ChuckECheeses >= 1 & franchise_id == .
replace franchise_id2 = 548 if ChuckECheeses >= 1 & franchise_id != .
replace franchise_id3 = 548 if ChuckECheeses >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if ChuckECheeses >= 1
drop 	ChuckECheeses
replace naics4d_ag 	  = 7139 if franchise_id == 548

gen 	CruiseShipCenters = strpos(lower(employer), "cruise ship center") | strpos(lower(employer), "cruiseshipcenter") | strpos(lower(employer), "expedia cruise") | strpos(lower(employer), "expediacruise")
replace franchise_id  = 549 if CruiseShipCenters >= 1 & franchise_id == .
replace franchise_id2 = 549 if CruiseShipCenters >= 1 & franchise_id != .
replace franchise_id3 = 549 if CruiseShipCenters >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if CruiseShipCenters >= 1
drop 	CruiseShipCenters
replace naics4d_ag 	  = 4872 if franchise_id == 549	

gen 	EngelandVolkers = strpos(lower(employer), "engel") & strpos(lower(employer), "volker")
replace franchise_id  = 550 if EngelandVolkers >= 1 & franchise_id == .
replace franchise_id2 = 550 if EngelandVolkers >= 1 & franchise_id != .
replace franchise_id3 = 550 if EngelandVolkers >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if EngelandVolkers >= 1
drop 	EngelandVolkers
replace naics4d_ag 	  = 5312 if franchise_id == 550

gen 	MoraIcedCreamery = strpos(lower(employer), "mora ice") | strpos(lower(employer), "moraice")
replace franchise_id  = 551 if MoraIcedCreamery >= 1 & franchise_id == .
replace franchise_id2 = 551 if MoraIcedCreamery >= 1 & franchise_id != .
replace franchise_id3 = 551 if MoraIcedCreamery >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if MoraIcedCreamery >= 1
drop 	MoraIcedCreamery
replace naics4d_ag 	  = 7225 if franchise_id == 551	

gen 	Sizller = strpos(lower(employer), "sizzler")
replace franchise_id  = 552 if Sizller >= 1 & franchise_id == .
replace franchise_id2 = 552 if Sizller >= 1 & franchise_id != .
replace franchise_id3 = 552 if Sizller >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Sizller >= 1
drop 	Sizller
replace naics4d_ag 	  = 7225 if franchise_id == 552

gen 	Starcycle = strpos(lower(employer), "starcycle") | strpos(lower(employer), "star cycle")
replace franchise_id  = 553 if Starcycle >= 1 & franchise_id == .
replace franchise_id2 = 553 if Starcycle >= 1 & franchise_id != .
replace franchise_id3 = 553 if Starcycle >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Starcycle >= 1
drop 	Starcycle
replace naics4d_ag 	  = 4412 if franchise_id == 553

gen 	DramaKids = strpos(lower(employer), "drama kids") | strpos(lower(employer), "dramakids")
replace franchise_id  = 554 if DramaKids >= 1 & franchise_id == .
replace franchise_id2 = 554 if DramaKids >= 1 & franchise_id != .
replace franchise_id3 = 554 if DramaKids >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if DramaKids >= 1
drop 	DramaKids
replace naics4d_ag 	  = 6116 if franchise_id == 554	

gen 	InXPress = 		strpos(lower(employer), "inxpress") | strpos(lower(employer), "in x press")
replace InXPress = 0 if strpos(employer, "Spinxpress")							
replace franchise_id  = 555 if InXPress >= 1 & franchise_id == .
replace franchise_id2 = 555 if InXPress >= 1 & franchise_id != .
replace franchise_id3 = 555 if InXPress >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if InXPress >= 1
drop 	InXPress
replace naics4d_ag 	  = 4885 if franchise_id == 555	

gen 	MyPlaceHotels = (strpos(lower(employer), "my place") | strpos(lower(employer), "myplace")) & (strpos(lower(employer), "hotel"))
replace franchise_id  = 556 if MyPlaceHotels >= 1 & franchise_id == .
replace franchise_id2 = 556 if MyPlaceHotels >= 1 & franchise_id != .
replace franchise_id3 = 556 if MyPlaceHotels >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if MyPlaceHotels >= 1
drop 	MyPlaceHotels
replace naics4d_ag 	  = 7211 if franchise_id == 556

gen 	BestinClass = strpos(lower(employer), "best in class educ") | strpos(lower(employer), "bestinclass")
replace franchise_id  = 557 if BestinClass >= 1 & franchise_id == .
replace franchise_id2 = 557 if BestinClass >= 1 & franchise_id != .
replace franchise_id3 = 557 if BestinClass >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if BestinClass >= 1
drop 	BestinClass
replace naics4d_ag 	  = 6116 if franchise_id == 557	

gen 	BricksandMinifigs = strpos(lower(employer), "brick") & strpos(lower(employer), "minifig")
replace franchise_id  = 558 if BricksandMinifigs >= 1 & franchise_id == .
replace franchise_id2 = 558 if BricksandMinifigs >= 1 & franchise_id != .
replace franchise_id3 = 558 if BricksandMinifigs >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if BricksandMinifigs >= 1
drop 	BricksandMinifigs
replace naics4d_ag 	  = 4511 if franchise_id == 558	

gen 	CostaVida = strpos(lower(employer), "costa vida") | strpos(lower(employer), "costavida")
replace franchise_id  = 559 if CostaVida >= 1 & franchise_id == .
replace franchise_id2 = 559 if CostaVida >= 1 & franchise_id != .
replace franchise_id3 = 559 if CostaVida >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if CostaVida >= 1
drop 	CostaVida
replace naics4d_ag 	  = 7225 if franchise_id == 559	

gen 	DutchBros = 	 strpos(lower(employer), "dutch bro") | strpos(lower(employer), "dutchbro")
replace DutchBros = 0 if strpos(employer, "Dutchbrothers Car Wash")				
replace franchise_id  = 560 if DutchBros >= 1 & franchise_id == .
replace franchise_id2 = 560 if DutchBros >= 1 & franchise_id != .
replace franchise_id3 = 560 if DutchBros >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if DutchBros >= 1
drop 	DutchBros
replace naics4d_ag 	  = 7225 if franchise_id == 560	

gen 	Elmers = strpos(lower(employer), "elmers prod") | strpos(lower(employer), "elmer's prod") 
replace franchise_id  = 561 if Elmers >= 1 & franchise_id == .
replace franchise_id2 = 561 if Elmers >= 1 & franchise_id != .
replace franchise_id3 = 561 if Elmers >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Elmers >= 1
drop 	Elmers
replace naics4d_ag 	  = 3221 if franchise_id == 561	

gen 	EmeraldCitySmoothie = strpos(lower(employer), "emerald city smoothie") | strpos(lower(employer), "emeraldcitysmoothie")
replace franchise_id  = 562 if EmeraldCitySmoothie >= 1 & franchise_id == .
replace franchise_id2 = 562 if EmeraldCitySmoothie >= 1 & franchise_id != .
replace franchise_id3 = 562 if EmeraldCitySmoothie >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if EmeraldCitySmoothie >= 1
drop 	EmeraldCitySmoothie
replace naics4d_ag 	  = 7225 if franchise_id == 562	

gen 	F45Training = 	   strpos(lower(employer), "f45")
replace F45Training = 0 if strpos(employer, "Rtx141F45")						
replace F45Training = 0 if strpos(employer, "Test Account A123F45")				
replace franchise_id  = 563 if F45Training >= 1 & franchise_id == .
replace franchise_id2 = 563 if F45Training >= 1 & franchise_id != .
replace franchise_id3 = 563 if F45Training >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if F45Training >= 1
drop 	F45Training
replace naics4d_ag 	  = 7139 if franchise_id == 563

gen 	FujiSan = 	   strpos(lower(employer), "fujisan") | strpos(lower(employer), "fuji san")
replace FujiSan = 0 if strpos(employer, "Fujisan Marketing")					
replace FujiSan = 0 if strpos(employer, "Fujisankei Communications")			
replace franchise_id  = 564 if FujiSan >= 1 & franchise_id == .
replace franchise_id2 = 564 if FujiSan >= 1 & franchise_id != .
replace franchise_id3 = 564 if FujiSan >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if FujiSan >= 1
drop 	FujiSan
replace naics4d_ag 	  = 7225 if franchise_id == 564	

gen 	MrAppliance = strpos(lower(employer), "mr appliance") | strpos(lower(employer), "mrappliance") | strpos(lower(employer), "mr. appliance")
replace franchise_id  = 565 if MrAppliance >= 1 & franchise_id == .
replace franchise_id2 = 565 if MrAppliance >= 1 & franchise_id != .
replace franchise_id3 = 565 if MrAppliance >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if MrAppliance >= 1
drop 	MrAppliance
replace naics4d_ag 	  = 8114 if franchise_id == 565	

gen 	MrElectric = 	  strpos(lower(employer), "mr. electric") | strpos(lower(employer), "mr electric") | strpos(lower(employer), "mrelectric")
replace MrElectric = 0 if strpos(employer, "Amr Electrical Contracting Corp")	
replace MrElectric = 0 if strpos(employer, "Dmr Electric")						
replace MrElectric = 0 if strpos(employer, "Emr Electric Motor")				
replace MrElectric = 0 if strpos(employer, "Jmr Electric")						
replace MrElectric = 0 if strpos(employer, "Mr Electricians")					
replace MrElectric = 0 if strpos(employer, "Mr Electricomfort")					
replace MrElectric = 0 if strpos(employer, "Omr Electrical Contractors")		
replace franchise_id  = 566 if MrElectric >= 1 & franchise_id == .
replace franchise_id2 = 566 if MrElectric >= 1 & franchise_id != .
replace franchise_id3 = 566 if MrElectric >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if MrElectric >= 1
drop 	MrElectric
replace naics4d_ag 	  = 2382 if franchise_id == 566	

gen 	PelindabaLavender = strpos(lower(employer), "pelindaba") 
replace franchise_id  = 567 if PelindabaLavender >= 1 & franchise_id == .
replace franchise_id2 = 567 if PelindabaLavender >= 1 & franchise_id != .
replace franchise_id3 = 567 if PelindabaLavender >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if PelindabaLavender >= 1
drop 	PelindabaLavender
replace naics4d_ag 	  = 4532 if franchise_id == 567	

gen 	PillarToPost = strpos(lower(employer), "pillar to post") | strpos(lower(employer), "pillartopost")
replace franchise_id  = 568 if PillarToPost >= 1 & franchise_id == .
replace franchise_id2 = 568 if PillarToPost >= 1 & franchise_id != .
replace franchise_id3 = 568 if PillarToPost >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if PillarToPost >= 1
drop 	PillarToPost
replace naics4d_ag 	  = 5619 if franchise_id == 568

gen 	Pirtek = 	  strpos(lower(employer), "pirtek")
replace Pirtek = 0 if strpos(employer, "Respirtek Incorporated")				
replace franchise_id  = 569 if Pirtek >= 1 & franchise_id == .
replace franchise_id2 = 569 if Pirtek >= 1 & franchise_id != .
replace franchise_id3 = 569 if Pirtek >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Pirtek >= 1
drop 	Pirtek
replace naics4d_ag 	  = 8112 if franchise_id == 569

gen 	PuroClean = strpos(lower(employer), "puroclean") | strpos(lower(employer), "puro clean")
replace franchise_id  = 570 if PuroClean >= 1 & franchise_id == .
replace franchise_id2 = 570 if PuroClean >= 1 & franchise_id != .
replace franchise_id3 = 570 if PuroClean >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if PuroClean >= 1
drop 	PuroClean
replace naics4d_ag 	  = 5617 if franchise_id == 570	

gen 	RealPropertyManagement = 	  strpos(lower(employer), "real property management") | strpos(lower(employer), "realpropertymanagement")
replace RealPropertyManagement = 0 if strpos(employer, "Boreal Property Management") 		   
replace RealPropertyManagement = 0 if strpos(employer, "Forreal Property Management") 		   
replace RealPropertyManagement = 0 if strpos(employer, "Palmareal Property Management") 	   
replace RealPropertyManagement = 0 if strpos(employer, "Diversified Real Property Management") 
replace franchise_id  = 571 if RealPropertyManagement >= 1 & franchise_id == .
replace franchise_id2 = 571 if RealPropertyManagement >= 1 & franchise_id != .
replace franchise_id3 = 571 if RealPropertyManagement >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if RealPropertyManagement >= 1
drop 	RealPropertyManagement
replace naics4d_ag 	  = 5312 if franchise_id == 571	

gen 	RemedyIntelligentStaffing = strpos(lower(employer), "remedy") & (strpos(lower(employer), "intelligent") | strpos(lower(employer), "staffing")) 
replace franchise_id  = 572 if RemedyIntelligentStaffing >= 1 & franchise_id == .
replace franchise_id2 = 572 if RemedyIntelligentStaffing >= 1 & franchise_id != .
replace franchise_id3 = 572 if RemedyIntelligentStaffing >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if RemedyIntelligentStaffing >= 1
drop 	RemedyIntelligentStaffing
replace naics4d_ag 	  = 5613 if franchise_id == 572	

gen 	Restoration1 = 		strpos(lower(employer), "restoration1") | strpos(lower(employer), "restoration 1")
replace Restoration1 = 0 if strpos(employer, "Kings Quality Restoration 1818") 	
replace Restoration1 = 0 if strpos(employer, "Restoration 101 Llc") 			
replace franchise_id  = 573 if Restoration1 >= 1 & franchise_id == .
replace franchise_id2 = 573 if Restoration1 >= 1 & franchise_id != .
replace franchise_id3 = 573 if Restoration1 >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Restoration1 >= 1
drop 	Restoration1
replace naics4d_ag 	  = 5617 if franchise_id == 573	

gen 	SoccerShots = strpos(lower(employer), "soccer shots") | strpos(lower(employer), "soccershots")
replace franchise_id  = 574 if SoccerShots >= 1 & franchise_id == .
replace franchise_id2 = 574 if SoccerShots >= 1 & franchise_id != .
replace franchise_id3 = 574 if SoccerShots >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if SoccerShots >= 1
drop 	SoccerShots
replace naics4d_ag 	  = 7139 if franchise_id == 574	

gen 	UrbanFloat = strpos(lower(employer), "urban float") | strpos(lower(employer), "urbanfloat")
replace franchise_id  = 575 if UrbanFloat >= 1 & franchise_id == .
replace franchise_id2 = 575 if UrbanFloat >= 1 & franchise_id != .
replace franchise_id3 = 575 if UrbanFloat >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if UrbanFloat >= 1
drop 	UrbanFloat
replace naics4d_ag 	  = 8121 if franchise_id == 575	

gen 	WaxingtheCity = 	  strpos(lower(employer), "waxing the city") | strpos(lower(employer), "waxingthecity")
replace franchise_id  = 576 if WaxingtheCity >= 1 & franchise_id == .
replace franchise_id2 = 576 if WaxingtheCity >= 1 & franchise_id != .
replace franchise_id3 = 576 if WaxingtheCity >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if WaxingtheCity >= 1
drop 	WaxingtheCity
replace naics4d_ag 	  = 8121 if franchise_id == 576	

gen 	Bambu = 	 strpos(lower(employer), "bambu")
replace Bambu = 0 if strpos(employer, "Bambu Asian Cuisine")
replace Bambu = 0 if strpos(employer, "Bambu Asian Restaurant")
replace Bambu = 0 if strpos(employer, "Bambu Asian Cuisine")
replace Bambu = 0 if strpos(employer, "Bambu Organic Massage")
replace Bambu = 0 if strpos(employer, "Bambu Pan Asian")
replace Bambu = 0 if strpos(employer, "Bambu Restaurant")
replace Bambu = 0 if strpos(employer, "Bambu Salon & Spa")
replace Bambu = 0 if strpos(employer, "Bambu Spa Face & Body Massage")
replace Bambu = 0 if strpos(employer, "Bambu Spa Skin Care")
replace Bambu = 0 if strpos(employer, "Bambu Systems")
replace Bambu = 0 if strpos(employer, "Bambu Tech Inc")
replace Bambu = 0 if strpos(employer, "Bambucha Kombucha")
replace Bambu = 0 if strpos(employer, "Bambury")
replace Bambu = 0 if strpos(employer, "Bambusa Bar")
replace Bambu = 0 if strpos(employer, "Bambuser")
replace Bambu = 0 if strpos(employer, "Bambuu Asian Eatery")
replace Bambu = 0 if strpos(employer, "Bambuza")
replace Bambu = 0 if strpos(employer, "Blubambu Suites")
replace Bambu = 0 if strpos(employer, "Mybambu")
replace Bambu = 0 if strpos(employer, "Co2 Bambu")
replace Bambu = 0 if strpos(employer, "Bambu Cafe")
replace Bambu = 0 if strpos(employer, "Bambu Global")
replace Bambu = 0 if strpos(employer, "Restaurante Coco Bambu")
replace franchise_id  = 577 if Bambu >= 1 & franchise_id == .
replace franchise_id2 = 577 if Bambu >= 1 & franchise_id != .
replace franchise_id3 = 577 if Bambu >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Bambu >= 1
drop 	Bambu
replace naics4d_ag 	  = 7225 if franchise_id == 577		

gen 	CHHJ = strpos(lower(employer), "chhj") | strpos(lower(employer), "college hunk")
replace franchise_id  = 578 if CHHJ >= 1 & franchise_id == .
replace franchise_id2 = 578 if CHHJ >= 1 & franchise_id != .
replace franchise_id3 = 578 if CHHJ >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if CHHJ >= 1
drop 	CHHJ
replace naics4d_ag 	  = 5622 if franchise_id == 578	

gen 	ConcreteCraft = 	 strpos(lower(employer), "concrete craft") | strpos(lower(employer), "concretecraft") | strpos(lower(employer), "american decorative coating")
replace ConcreteCraft = 0 if strpos(employer, "Texas Concrete Craftsmen")
replace franchise_id  = 579 if ConcreteCraft >= 1 & franchise_id == .
replace franchise_id2 = 579 if ConcreteCraft >= 1 & franchise_id != .
replace franchise_id3 = 579 if ConcreteCraft >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if ConcreteCraft >= 1
drop 	ConcreteCraft
replace naics4d_ag 	  = 2381 if franchise_id == 579	

gen 	NPMFranchising = 	  strpos(lower(employer), "npm franch") | strpos(lower(employer), "earth wise pet") | strpos(lower(employer), "earthwisepet") | strpos(lower(employer), "earthwise pet") 
replace franchise_id  = 580 if NPMFranchising >= 1 & franchise_id == .
replace franchise_id2 = 580 if NPMFranchising >= 1 & franchise_id != .
replace franchise_id3 = 580 if NPMFranchising >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if NPMFranchising >= 1
drop 	NPMFranchising
replace naics4d_ag 	  = 4539 if franchise_id == 580	

gen 	DelightedGuests =	   strpos(lower(employer), "delighted guests") | strpos(lower(employer), "delightedguests") | strpos(lower(employer), "ezell's") | strpos(lower(employer), "ezells")
replace DelightedGuests = 0 if strpos(employer, "Ezell's Express")
replace DelightedGuests = 0 if strpos(employer, "Ezell's Telephone")
replace franchise_id  = 581 if DelightedGuests >= 1 & franchise_id == .
replace franchise_id2 = 581 if DelightedGuests >= 1 & franchise_id != .
replace franchise_id3 = 581 if DelightedGuests >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if DelightedGuests >= 1
drop 	DelightedGuests
replace naics4d_ag 	  = 7225 if franchise_id == 581	

gen 	RealDeals = 	 strpos(lower(employer), "real deals") | strpos(lower(employer), "realdeals")
replace RealDeals = 0 if strpos(employer, "Real Deals Dollar Store")
replace franchise_id  = 582 if RealDeals >= 1 & franchise_id == .
replace franchise_id2 = 582 if RealDeals >= 1 & franchise_id != .
replace franchise_id3 = 582 if RealDeals >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if RealDeals >= 1
drop 	RealDeals
replace naics4d_ag 	  = 5619 if franchise_id == 582	

gen 	SupportStrategies = 	  strpos(lower(employer), "supporting strategies") | strpos(lower(employer), "supportingstrategies")
replace franchise_id  = 583 if SupportStrategies >= 1 & franchise_id == .
replace franchise_id2 = 583 if SupportStrategies >= 1 & franchise_id != .
replace franchise_id3 = 583 if SupportStrategies >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if SupportStrategies >= 1
drop 	SupportStrategies
replace naics4d_ag 	  = 5412 if franchise_id == 583	

gen 	TheBarberSource = 	   strpos(lower(employer), "the barbers") 
replace TheBarberSource = 0 if strpos(employer, "The Barbershop")
replace TheBarberSource = 0 if strpos(employer, "The Barbers Club Barber Shop")
replace TheBarberSource = 0 if strpos(employer, "The Barbers At Oak Cliff")
replace TheBarberSource = 0 if strpos(employer, "The Barbers Theory")
replace TheBarberSource = 0 if strpos(employer, "The Barbers Collection")
replace franchise_id  = 584 if TheBarberSource >= 1 & franchise_id == .
replace franchise_id2 = 584 if TheBarberSource >= 1 & franchise_id != .
replace franchise_id3 = 584 if TheBarberSource >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if TheBarberSource >= 1
drop 	TheBarberSource
replace naics4d_ag 	  = 8121 if franchise_id == 584	

gen 	Singers = strpos(lower(employer), "singers company") | strpos(lower(employer), "singerscompany")
replace franchise_id  = 585 if Singers >= 1 & franchise_id == .
replace franchise_id2 = 585 if Singers >= 1 & franchise_id != .
replace franchise_id3 = 585 if Singers >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Singers >= 1
drop 	Singers
replace naics4d_ag 	  = 6116 if franchise_id == 585	

gen 	JDog = 		strpos(lower(employer), "jdog") | strpos(lower(employer), "j dog")
replace JDog = 0 if strpos(employer, "Double J Doggie Play N Stay")
replace JDog = 0 if strpos(employer, "Dj Dog Services")
replace JDog = 0 if strpos(employer, "J Dogs")
replace franchise_id  = 586 if JDog >= 1 & franchise_id == .
replace franchise_id2 = 586 if JDog >= 1 & franchise_id != .
replace franchise_id3 = 586 if JDog >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if JDog >= 1
drop 	JDog
replace naics4d_ag 	  = 5622 if franchise_id == 586	

gen 	NextHome = 		strpos(lower(employer), "nexthome") | strpos(lower(employer), "next home")
replace NextHome = 0 if strpos(employer, "The Owls' Next Home Care Services")
replace NextHome = 0 if strpos(employer, "Next Home Remodeling")
replace NextHome = 0 if strpos(employer, "Next Home Loans")
replace NextHome = 0 if strpos(employer, "Next Home Inspection Llc")
replace NextHome = 0 if strpos(employer, "Next Home Improvements")
replace franchise_id  = 587 if NextHome >= 1 & franchise_id == .
replace franchise_id2 = 587 if NextHome >= 1 & franchise_id != .
replace franchise_id3 = 587 if NextHome >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if NextHome >= 1
drop 	NextHome
replace naics4d_ag 	  = 5312 if franchise_id == 587	

gen 	ThriveCommunityFitness = strpos(lower(employer), "thrive community fitness") | strpos(lower(employer), "tcf franchising") | strpos(lower(employer), "thrive cf")
replace franchise_id  = 588 if ThriveCommunityFitness >= 1 & franchise_id == .
replace franchise_id2 = 588 if ThriveCommunityFitness >= 1 & franchise_id != .
replace franchise_id3 = 588 if ThriveCommunityFitness >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if ThriveCommunityFitness >= 1
drop 	ThriveCommunityFitness
replace naics4d_ag 	  = 7139 if franchise_id == 588	

gen 	UBuildIt = 		strpos(lower(employer), "ubuildit") | strpos(lower(employer), "u build it") | strpos(lower(employer), "ubuild it")
replace UBuildIt = 0 if strpos(employer, "Wood You Build It")
replace franchise_id  = 589 if UBuildIt >= 1 & franchise_id == .
replace franchise_id2 = 589 if UBuildIt >= 1 & franchise_id != .
replace franchise_id3 = 589 if UBuildIt >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if UBuildIt >= 1
drop 	UBuildIt
replace naics4d_ag 	  = 2361 if franchise_id == 589	

gen 	AbraAutomotive = strpos(lower(employer), "abra auto") | strpos(lower(employer), "abra glass") 
replace franchise_id  = 590 if AbraAutomotive >= 1 & franchise_id == .
replace franchise_id2 = 590 if AbraAutomotive >= 1 & franchise_id != .
replace franchise_id3 = 590 if AbraAutomotive >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if AbraAutomotive >= 1
drop 	AbraAutomotive
replace naics4d_ag 	  = 8111 if franchise_id == 590	

gen 	ARWorkshop = 	  strpos(lower(employer), "arworkshop") | strpos(lower(employer), "ar workshop")
replace ARWorkshop = 0 if strpos(employer, "Andy Bear Workshop Llc")
replace ARWorkshop = 0 if strpos(employer, "Build A Bear Workshop")
replace ARWorkshop = 0 if strpos(employer, "Build Bear Workshop")
replace ARWorkshop = 0 if strpos(employer, "Buildabear Workshop")
replace ARWorkshop = 0 if strpos(employer, "Foreign Car Workshop")
replace ARWorkshop = 0 if strpos(employer, "Sportscar Workshops")
replace franchise_id  = 591 if ARWorkshop >= 1 & franchise_id == .
replace franchise_id2 = 591 if ARWorkshop >= 1 & franchise_id != .
replace franchise_id3 = 591 if ARWorkshop >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if ARWorkshop >= 1
drop 	ARWorkshop
replace naics4d_ag 	  = 6116 if franchise_id == 591	

gen 	NMCFranchising = strpos(lower(employer), "nmc franchising") | strpos(lower(employer), "national maintenance contractors")
replace franchise_id  = 592 if NMCFranchising >= 1 & franchise_id == .
replace franchise_id2 = 592 if NMCFranchising >= 1 & franchise_id != .
replace franchise_id3 = 592 if NMCFranchising >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if NMCFranchising >= 1
drop 	NMCFranchising
replace naics4d_ag 	  = 5617 if franchise_id == 592	

gen 	CostCutters = 	   strpos(lower(employer), "costcutters") | strpos(lower(employer), "cost cutters")
replace CostCutters = 0 if strpos(employer, "Cost Cutters Lawn Care & Landscaping")
replace CostCutters = 0 if strpos(employer, "Cost Cutters Residential & Commercial Remodeling Services")
replace CostCutters = 0 if strpos(employer, "Military Cost Cutters")
replace franchise_id  = 593 if CostCutters >= 1 & franchise_id == .
replace franchise_id2 = 593 if CostCutters >= 1 & franchise_id != .
replace franchise_id3 = 593 if CostCutters >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if CostCutters >= 1
drop 	CostCutters
replace naics4d_ag 	  = 8121 if franchise_id == 593	

gen 	Smartstyle = strpos(lower(employer), "smart style") | strpos(lower(employer), "smartstyle")
replace franchise_id  = 594 if Smartstyle >= 1 & franchise_id == .
replace franchise_id2 = 594 if Smartstyle >= 1 & franchise_id != .
replace franchise_id3 = 594 if Smartstyle >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Smartstyle >= 1
drop 	Smartstyle
replace naics4d_ag 	  = 8121 if franchise_id == 594

gen 	FixAuto = 	   strpos(lower(employer), "fix auto") | strpos(lower(employer), "fixauto")
replace FixAuto = 0 if strpos(employer, "Carffix Automotive")
replace FixAuto = 0 if strpos(employer, "Cars Fix Auto Repair Llc")
replace FixAuto = 0 if strpos(employer, "Eurofix Auto Repair")
replace FixAuto = 0 if strpos(employer, "Fastfix Automotive")
replace FixAuto = 0 if strpos(employer, "Profix Auto Repair")
replace FixAuto = 0 if strpos(employer, "Quality Fix Auto Repair And Service Llc")
replace FixAuto = 0 if strpos(employer, "Quick Fix Automotive")
replace FixAuto = 0 if strpos(employer, "Tucker's Quickfix Automotive")
replace FixAuto = 0 if strpos(employer, "Winaffix Auto Glass")
replace franchise_id  = 595 if FixAuto >= 1 & franchise_id == .
replace franchise_id2 = 595 if FixAuto >= 1 & franchise_id != .
replace franchise_id3 = 595 if FixAuto >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if FixAuto >= 1
drop 	FixAuto
replace naics4d_ag 	  = 8111 if franchise_id == 595	

gen 	JohnLScottRealEstate = strpos(lower(employer), "jlsrea") | strpos(lower(employer), "john l. scott") | strpos(lower(employer), "john l scott")
replace franchise_id  = 596 if JohnLScottRealEstate >= 1 & franchise_id == .
replace franchise_id2 = 596 if JohnLScottRealEstate >= 1 & franchise_id != .
replace franchise_id3 = 596 if JohnLScottRealEstate >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if JohnLScottRealEstate >= 1
drop 	JohnLScottRealEstate
replace naics4d_ag 	  = 5312 if franchise_id == 596	

gen 	GuestHouse = strpos(lower(employer), "guesthouse extended") | strpos(lower(employer), "guest house extended")
replace franchise_id  = 597 if GuestHouse >= 1 & franchise_id == .
replace franchise_id2 = 597 if GuestHouse >= 1 & franchise_id != .
replace franchise_id3 = 597 if GuestHouse >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if GuestHouse >= 1
drop 	GuestHouse
replace naics4d_ag 	  = 7211 if franchise_id == 597	

gen 	Velofix = strpos(lower(employer), "velofix")
replace franchise_id  = 598 if Velofix >= 1 & franchise_id == .
replace franchise_id2 = 598 if Velofix >= 1 & franchise_id != .
replace franchise_id3 = 598 if Velofix >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Velofix >= 1
drop 	Velofix
replace naics4d_ag 	  = 8114 if franchise_id == 598	

gen 	OsteoStrong = strpos(lower(employer), "osteostrong") | strpos(lower(employer), "osteo strong")
replace franchise_id  = 599 if OsteoStrong >= 1 & franchise_id == .
replace franchise_id2 = 599 if OsteoStrong >= 1 & franchise_id != .
replace franchise_id3 = 599 if OsteoStrong >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if OsteoStrong >= 1
drop 	OsteoStrong
replace naics4d_ag 	  = 7139 if franchise_id == 599		

gen 	PadgettBusinessServices = strpos(lower(employer), "smallbizpros") | strpos(lower(employer), "padgett business")
replace franchise_id  = 600 if PadgettBusinessServices >= 1 & franchise_id == .
replace franchise_id2 = 600 if PadgettBusinessServices >= 1 & franchise_id != .
replace franchise_id3 = 600 if PadgettBusinessServices >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if PadgettBusinessServices >= 1
drop 	PadgettBusinessServices
replace naics4d_ag 	  = 5619 if franchise_id == 600		

gen 	BoardAndBrush = strpos(lower(employer), "boardandbrush") | strpos(lower(employer), "board and brush")
replace franchise_id  = 601 if BoardAndBrush >= 1 & franchise_id == .
replace franchise_id2 = 601 if BoardAndBrush >= 1 & franchise_id != .
replace franchise_id3 = 601 if BoardAndBrush >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if BoardAndBrush >= 1
drop 	BoardAndBrush
replace naics4d_ag 	  = 6116 if franchise_id == 601	

gen 	PokeBarDiceMix = strpos(lower(employer), "jb brothers") | strpos(lower(employer), "poke bar")
replace PokeBarDiceMix = 0 if strpos(employer, "Blue Whale Poke Bar")
replace PokeBarDiceMix = 0 if strpos(employer, "Boru Ramen Noodle And Poke Bar")
replace PokeBarDiceMix = 0 if strpos(employer, "Finbomb Sushi Burrito And Poke Bar")
replace PokeBarDiceMix = 0 if strpos(employer, "Fins Or Tails Poke Bar")
replace PokeBarDiceMix = 0 if strpos(employer, "Fish & Things Poke Bar")
replace PokeBarDiceMix = 0 if strpos(employer, "Fish And Rice Poke Bar")
replace PokeBarDiceMix = 0 if strpos(employer, "Fish Poke Bar")
replace PokeBarDiceMix = 0 if strpos(employer, "Fishface Poke Bar")
replace PokeBarDiceMix = 0 if strpos(employer, "Fishology Poke Bar")
replace PokeBarDiceMix = 0 if strpos(employer, "Go Fish Poke Bar")
replace PokeBarDiceMix = 0 if strpos(employer, "Hometown Cafe And Poke Bar")
replace PokeBarDiceMix = 0 if strpos(employer, "Honolulu Poke Bar")
replace PokeBarDiceMix = 0 if strpos(employer, "Alohaus Poke Bar")
replace PokeBarDiceMix = 0 if strpos(employer, "Kahuna Poke Bar")
replace PokeBarDiceMix = 0 if strpos(employer, "Mix Poke Bar")
replace PokeBarDiceMix = 0 if strpos(employer, "Poke Bar & Cherry On Top Yogurt")
replace PokeBarDiceMix = 0 if strpos(employer, "Poke Bar Arcadia")
replace PokeBarDiceMix = 0 if strpos(employer, "Poke Bar Chandler")
replace PokeBarDiceMix = 0 if strpos(employer, "Poke Poke Bar")
replace PokeBarDiceMix = 0 if strpos(employer, "Poke Poku")
replace PokeBarDiceMix = 0 if strpos(employer, "Ponzu Poke Bar")
replace PokeBarDiceMix = 0 if strpos(employer, "Quickfish Poke Bar")
replace PokeBarDiceMix = 0 if strpos(employer, "Redfish Poke Bar")
replace PokeBarDiceMix = 0 if strpos(employer, "Rocky Fin Poke Bar")
replace PokeBarDiceMix = 0 if strpos(employer, "Rollrritto Poke Bar")
replace PokeBarDiceMix = 0 if strpos(employer, "Spoke Bar And Grill")
replace PokeBarDiceMix = 0 if strpos(employer, "Sunfish Poke Bar")
replace PokeBarDiceMix = 0 if strpos(employer, "The Bespoke Barber")
replace PokeBarDiceMix = 0 if strpos(employer, "The Scale Poke Bar")
replace PokeBarDiceMix = 0 if strpos(employer, "Truffle Butter Poke Bar")
replace PokeBarDiceMix = 0 if strpos(employer, "Uncle Sharkii Poke Bar")
replace PokeBarDiceMix = 0 if strpos(employer, "Waiwai Poke Bar And Cafe")
replace PokeBarDiceMix = 0 if strpos(employer, "Wh Poke Bar, Inc")
replace franchise_id   = 602 if PokeBarDiceMix >= 1 & franchise_id == .
replace franchise_id2  = 602 if PokeBarDiceMix >= 1 & franchise_id != .
replace franchise_id3  = 602 if PokeBarDiceMix >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			 if PokeBarDiceMix >= 1
drop 	PokeBarDiceMix
replace naics4d_ag 	  = 7225 if franchise_id == 602		

gen 	Sharetea = strpos(lower(employer), "sharetea")
replace franchise_id  = 603 if Sharetea >= 1 & franchise_id == .
replace franchise_id2 = 603 if Sharetea >= 1 & franchise_id != .
replace franchise_id3 = 603 if Sharetea >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Sharetea >= 1
drop 	Sharetea
replace naics4d_ag 	  = 7225 if franchise_id == 603	

gen 	ManchuWok = strpos(lower(employer), "manchu wok") | strpos(lower(employer), "manchuwok")
replace franchise_id  = 604 if ManchuWok >= 1 & franchise_id == .
replace franchise_id2 = 604 if ManchuWok >= 1 & franchise_id != .
replace franchise_id3 = 604 if ManchuWok >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if ManchuWok >= 1
drop 	ManchuWok
replace naics4d_ag 	  = 7225 if franchise_id == 604		

gen 	PizzaFactory = 		strpos(lower(employer), "pizza factory") | strpos(lower(employer), "pizzafactory")
replace PizzaFactory = 0 if strpos(employer, "New York Pizza Factory")
replace PizzaFactory = 0 if strpos(employer, "Adagio's Pizza Factory")
replace PizzaFactory = 0 if strpos(employer, "Benvenuti's Pizza Factory")
replace PizzaFactory = 0 if strpos(employer, "Big Lake Pizza Factory")
replace PizzaFactory = 0 if strpos(employer, "Cals Pizza Factory")
replace PizzaFactory = 0 if strpos(employer, "Carmines Pizza Factory")
replace PizzaFactory = 0 if strpos(employer, "Dayton Pizza Factory")
replace PizzaFactory = 0 if strpos(employer, "Jammin J's Pizza Factory")
replace PizzaFactory = 0 if strpos(employer, "Ny Pizza Factory")
replace PizzaFactory = 0 if strpos(employer, "Pizza Factory Express")
replace PizzaFactory = 0 if strpos(employer, "Portsmouth Pizza Factory")
replace PizzaFactory = 0 if strpos(employer, "Rowley Pizza Factory")
replace PizzaFactory = 0 if strpos(employer, "Sal's Pizza Factory")
replace PizzaFactory = 0 if strpos(employer, "Sals Pizza Factory")
replace PizzaFactory = 0 if strpos(employer, "Soulshine Pizza Factory")
replace PizzaFactory = 0 if strpos(employer, "Zoom Pizza Factory")
replace franchise_id  = 605 if PizzaFactory >= 1 & franchise_id == .
replace franchise_id2 = 605 if PizzaFactory >= 1 & franchise_id != .
replace franchise_id3 = 605 if PizzaFactory >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if PizzaFactory >= 1
drop 	PizzaFactory
replace naics4d_ag 	  = 7225 if franchise_id == 605	

gen 	RealtyOne = strpos(lower(employer), "realtyone group") | strpos(lower(employer), "realty one group")
replace franchise_id  = 606 if RealtyOne >= 1 & franchise_id == .
replace franchise_id2 = 606 if RealtyOne >= 1 & franchise_id != .
replace franchise_id3 = 606 if RealtyOne >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if RealtyOne >= 1
drop 	RealtyOne
replace naics4d_ag 	  = 5312 if franchise_id == 606	

gen 	ClubPilates = strpos(lower(employer), "club pilates") | strpos(lower(employer), "clubpilates")
replace franchise_id  = 607 if ClubPilates >= 1 & franchise_id == .
replace franchise_id2 = 607 if ClubPilates >= 1 & franchise_id != .
replace franchise_id3 = 607 if ClubPilates >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if ClubPilates >= 1
drop 	ClubPilates
replace naics4d_ag 	  = 7139 if franchise_id == 607		

gen 	ServiceMaster = strpos(lower(employer), "service master") | strpos(lower(employer), "servicemaster")
replace franchise_id  = 608 if ServiceMaster >= 1 & franchise_id == .
replace franchise_id2 = 608 if ServiceMaster >= 1 & franchise_id != .
replace franchise_id3 = 608 if ServiceMaster >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if ServiceMaster >= 1
drop 	ServiceMaster
replace naics4d_ag 	  = 5617 if franchise_id == 608	

gen 	ToroTax = strpos(lower(employer), "toro tax") | strpos(lower(employer), "torotax")
replace franchise_id  = 609 if ToroTax >= 1 & franchise_id == .
replace franchise_id2 = 609 if ToroTax >= 1 & franchise_id != .
replace franchise_id3 = 609 if ToroTax >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if ToroTax >= 1
drop 	ToroTax
replace naics4d_ag 	  = 5412 if franchise_id == 609		

gen 	Bishops = strpos(lower(employer), "bishops cuts") | strpos(lower(employer), "bishops barber")
replace franchise_id  = 610 if Bishops >= 1 & franchise_id == .
replace franchise_id2 = 610 if Bishops >= 1 & franchise_id != .
replace franchise_id3 = 610 if Bishops >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Bishops >= 1
drop 	Bishops
replace naics4d_ag 	  = 8121 if franchise_id == 610		

gen 	Canteen = strpos(lower(employer), "canteen one") | (strpos(lower(employer), "canteen") & strpos(lower(employer), "compass"))  | ///
														   (strpos(lower(employer), "canteen") & strpos(lower(employer), "vending"))  | ///
														   (strpos(lower(employer), "canteen") & strpos(lower(employer), "dining"))   | ///
														   (strpos(lower(employer), "canteen") & strpos(lower(employer), "catering")) | ///
														   (strpos(lower(employer), "canteen") & strpos(lower(employer), "refresh")) 
replace franchise_id  = 611 if Canteen >= 1 & franchise_id == .
replace franchise_id2 = 611 if Canteen >= 1 & franchise_id != .
replace franchise_id3 = 611 if Canteen >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if Canteen >= 1
drop 	Canteen
replace naics4d_ag 	  = 4542 if franchise_id == 611		

gen 	InchinsBambooGarden = strpos(lower(employer), "inchins bamboo") | strpos(lower(employer), "inchin's bamboo") | strpos(lower(employer), "inchinsbamboo") | strpos(lower(employer), "bamboo garden")
replace InchinsBambooGarden = 0 if strpos(employer, "Bamboo Garden Learning And Care Center")
replace InchinsBambooGarden = 0 if strpos(employer, "Bamboo Garden Early Learning And Care")
replace InchinsBambooGarden = 0 if strpos(employer, "Pine Bamboo Garden")
replace InchinsBambooGarden = 0 if strpos(employer, "New Bamboo Garden Restaurant")
replace franchise_id  = 612 if InchinsBambooGarden >= 1 & franchise_id == .
replace franchise_id2 = 612 if InchinsBambooGarden >= 1 & franchise_id != .
replace franchise_id3 = 612 if InchinsBambooGarden >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if InchinsBambooGarden >= 1
drop 	InchinsBambooGarden
replace naics4d_ag 	  = 7225 if franchise_id == 612	

gen 	PlayLiveNation = 	  strpos(lower(employer), "play live nation") | strpos(lower(employer), "playlive nation")
replace franchise_id  = 613 if PlayLiveNation >= 1 & franchise_id == .
replace franchise_id2 = 613 if PlayLiveNation >= 1 & franchise_id != .
replace franchise_id3 = 613 if PlayLiveNation >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if PlayLiveNation >= 1
drop 	PlayLiveNation
replace naics4d_ag 	  = 7117 if franchise_id == 613	

gen 	PortOfSubs = 	  strpos(lower(employer), "port of subs") | strpos(lower(employer), "portofsubs") | strpos(employer, "POS")
replace franchise_id  = 614 if PortOfSubs >= 1 & franchise_id == .
replace franchise_id2 = 614 if PortOfSubs >= 1 & franchise_id != .
replace franchise_id3 = 614 if PortOfSubs >= 1 & franchise_id != . & franchise_id2 != .
tab 	employer 			if PortOfSubs >= 1
drop 	PortOfSubs
replace naics4d_ag 	  = 7225 if franchise_id == 614		




* e) Rename + fix + generate variables
// Industry
replace naics4 = . if naics4 == -999
rename 	naics4 naics4_job_ads

// FIPS
rename fips fips_code 

// Date
gen    yq 	= yq(year,quarter(date))
format yq 	%tq



* f) Keep: key variables
keep $key_vars_2



* g) Merge: with county-CZ crosswalk
merge m:1 fips using "${data_cwalk_usda_c}/County-CZ crosswalk 2000"
keep if _merge == 3
drop 	_merge
