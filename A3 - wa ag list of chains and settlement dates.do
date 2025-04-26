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
global master_path "[INSERT USER'S RELEVANT PATH]"
global data_waag_r "${master_path}/data/wa_ag/raw"
global data_waag_c "${master_path}/data/wa_ag/cln"
global tables 	   "${master_path}/output/tables"



*------------------------------------------------------------------------------*
* 1) Generate base file for WA AG settlement chains
*------------------------------------------------------------------------------*
import excel "${data_waag_r}/WA AG settlement dates.xlsx", sheet("Chains and dates") cellrange(A1:H242) firstrow case(lower)


* a) Rename + Keep: key variables
rename investigationopeningdate	 investigation_date
rename settlementdatenew 		 settlement_date
rename internaldecision	 		 internal_decision_date
rename occupationspecificnopoach occ_specific_np

keep   franchise investigation_date settlement_date internal_decision_date occ_specific_np
format settlement_date %td



* b) Replace: chains that are present in the contracts data, but under a different name
replace franchise = "ckFranchising" 		   if franchise == "ComfortKeepers"
replace franchise = "synergisticInterNational" if franchise == "GlassDoctor"
replace franchise = "macTools" 				   if franchise == "MacTools"
replace franchise = "image360" 				   if franchise == "SignsbyTomorrow"
replace franchise = "maidsInterNational" 	   if franchise == "TheMaids"
replace franchise = "villaPizza" 			   if franchise == "VillaItalianKitchen"
replace franchise = "forFranchising" 		   if franchise == "WindowGenie"
replace franchise = "worldInspection" 		   if franchise == "WorldInspectionNetwork"

// Change "ChoiceHotels" name (it acquired Woodspring, which is the name that "trueValue" from the FDD file later took)
replace franchise = "trueValue" 		   	   if franchise == "ChoiceHotels"

// Keep unique chains
gegen 	unique_franchise = tag(franchise)
keep if unique_franchise == 1
drop 	unique_franchise 



* c) Remove: specific chains that either are duplicated or should not be present
// Mrs Fields/TCBY: Keep Mrs. Fields the parent company that is coded in the FDD file
drop if franchise == "TCBY"
replace franchise = "tcbyMrsFields" if franchise == "Mrs. Fields"



* d) Fix: Internal decision dates that are not specific
replace internal_decision_date = "15-Mar-17" if internal_decision_date == "Mar-17"
replace internal_decision_date = "15-Apr-17" if internal_decision_date == "Apr-17"
replace internal_decision_date = "15-Nov-17" if internal_decision_date == "Nov-17"
replace internal_decision_date = "15-Mar-18" if internal_decision_date == "Mar-18"
replace internal_decision_date = "15-Apr-18" if internal_decision_date == "Apr-18"
replace internal_decision_date = "15-May-18" if internal_decision_date == "May-18"
replace internal_decision_date = "15-Jul-18" if internal_decision_date == "Jul-18"
replace internal_decision_date = "15-Aug-18" if internal_decision_date == "Aug-18"
replace internal_decision_date = "15-Sep-18" if internal_decision_date == "Sep-18"
replace internal_decision_date = "15-Jan-19" if internal_decision_date == "Jan-19"
replace internal_decision_date = "15-Mar-19" if internal_decision_date == "Mar-19"
replace internal_decision_date = "15-Apr-19" if internal_decision_date == "Apr-19"
replace internal_decision_date = "15-Jun-19" if internal_decision_date == "Jun-19"
replace internal_decision_date = "15-Feb-18" if internal_decision_date == "Q1-2018"
replace internal_decision_date = "15-Feb-19" if internal_decision_date == "Q1-2019"
replace internal_decision_date = "01-Jan-00" if internal_decision_date == "Unknown" 	| internal_decision_date == "Pre Jun-2019" | ///
												internal_decision_date == "Early 2019" 	| internal_decision_date == "Before Mar-2019" | ///
												internal_decision_date == "Pre-2019"	| internal_decision_date == "2017" | ///
												internal_decision_date == "2019" 

gen    internal_decision_date_2 = date(internal_decision_date, "DM20Y")
format internal_decision_date_2 %td
drop   internal_decision_date
rename internal_decision_date_2 internal_decision_date

order  franchise investigation_date settlement_date internal_decision_date



* e) Fix: investigation dates --> set imprecise to missing and harmonize daily to monthly
// Set missing dates
replace investigation_date = . if investigation_date == -19898

// Change daily to monthly
replace investigation_date = 21397 if investigation_date == 21402
replace investigation_date = 21397 if investigation_date == 21425
replace investigation_date = 21762 if investigation_date == 21777
replace investigation_date = 21762 if investigation_date == 21791
replace investigation_date = 21793 if investigation_date == 21805
replace investigation_date = 21762 if investigation_date == 21770

tab 	 investigation_date, miss
codebook investigation_date



* e) Save: clean file for chains that settled with WA AG + settlement date
save "${data_waag_c}/Chain settlement dates", replace




*------------------------------------------------------------------------------*
* 2) Generate xlsx file with all the proper chain names
*------------------------------------------------------------------------------*
use "${data_waag_c}/Chain settlement dates", clear


* a) Change franchise chain names 
keep franchise settlement_date

replace franchise = "Arby's" if franchise == "arbys"
replace franchise = "Auntie Anne's" if franchise == "auntieAnnes"
replace franchise = "Buffalo Wild Wings" if franchise == "buffaloWildWings"
replace franchise = "Carl's Jr." if franchise == "carlsJr"
replace franchise = "Cinnabon" if franchise == "cinnabon"
replace franchise = "Jimmy John's" if franchise == "jimmyJohns"
replace franchise = "McDonald's" if franchise == "mcd"
replace franchise = "Applebee's" if franchise == "applebees"
replace franchise = "Church's Texas Chicken" if franchise == "churchsChicken"
replace franchise = "Five Guys" if franchise == "fiveGuys"
replace franchise = "IHOP" if franchise == "ihop"
replace franchise = "Jamba Juice" if franchise == "jambaJuice"
replace franchise = "Little Caesars" if franchise == "littleCaesars"
replace franchise = "Panera" if franchise == "panera"
replace franchise = "Sonic" if franchise == "sonic"
replace franchise = "A&W Restaurants" if franchise == "AandW"
replace franchise = "Burger King" if franchise == "burgerKing"
replace franchise = "Denny's" if franchise == "dennys"
replace franchise = "Pap John's" if franchise == "papaJohns"
replace franchise = "Pizza Hut" if franchise == "pizzaHutRedRoofDineIn"
replace franchise = "Popeye's" if franchise == "popeyes"
replace franchise = "Tim Hortons" if franchise == "timHortons"
replace franchise = "Wingstop" if franchise == "wingStop"
replace franchise = "Anytime Fitness" if franchise == "anytTimeFitness"
replace franchise = "Baskin-Robbins" if franchise == "baskinRobbins"
replace franchise = "Circle K" if franchise == "circleK"
replace franchise = "Domino's Pizza" if franchise == "dominos"
replace franchise = "Firehouse Subs" if franchise == "firehouseSubs"
replace franchise = "Planet Fitness" if franchise == "planetFitness"
replace franchise = "Valvoline" if franchise == "valvoline"
replace franchise = "Quiznos" if franchise == "quiznos"
replace franchise = "Massage Envy" if franchise == "massageEnvy"
replace franchise = "Frontier Adjusters" if franchise == "frontierAdjusters"
replace franchise = "Sport Clips" if franchise == "sportClips"
replace franchise = "Batteries Plus" if franchise == "batteriesPlus"
replace franchise = "CK Franchising" if franchise == "ckFranchising"
replace franchise = "Edible Arrangements" if franchise == "edibleArrangements"
replace franchise = "Lq Quinta" if franchise == "laQuinta"
replace franchise = "Merry Maids" if franchise == "MerryMaids"
replace franchise = "Budget Blinds" if franchise == "budgetBlinds"
replace franchise = "GNC" if franchise == "gnc"
replace franchise = "Jack in the Box" if franchise == "JackInTheBox"
replace franchise = "Jackson Hewitt" if franchise == "jacksonHewitt"
replace franchise = "Jiffy Lube" if franchise == "jiffyLube"
replace franchise = "Menchie's Frozen Yogurt" if franchise == "menchies"
replace franchise = "The Original Pancake House" if franchise == "TheOriginalPancakeHouse"
replace franchise = "Bonefish Grill" if franchise == "BonefishGrill"
replace franchise = "Carrabba's Italian Grill" if franchise == "CarrabbasItalianGrill"
replace franchise = "Management Recruiters International" if franchise == "managementRecruiters"
replace franchise = "Outback Steakhouse" if franchise == "OutbackSteakhouse"
replace franchise = "Einstein Bros. Bagels" if franchise == "einsteinBros"
replace franchise = "Express Employment Professionals" if franchise == "expressServices"
replace franchise = "Fastsigns International " if franchise == "fastSigns"
replace franchise = "L&L Franchise" if franchise == "LandLFranchising"
replace franchise = "The Maids International" if franchise == "maidsInterNational"
replace franchise = "Westside Pizza" if franchise == "WestsidePizza"
replace franchise = "Zeek's Restaurants" if franchise == "ZeeksPizza"
replace franchise = "AAMCO" if franchise == "aamco"
replace franchise = "Famous Dave's" if franchise == "famousDavesFullService"
replace franchise = "Meineke" if franchise == "meineke"
replace franchise = "Qdoba" if franchise == "qdoba"
replace franchise = "Villa Pizza" if franchise == "villaPizza"
replace franchise = "Aaron's" if franchise == "aarons"
replace franchise = "H&R Block" if franchise == "HandRBlock"
replace franchise = "Mio Sushi" if franchise == "MioSushi"
replace franchise = "UPS" if franchise == "upsStore"
replace franchise = "Jersey Mike's" if franchise == "jerseyMikes"
replace franchise = "Curves" if franchise == "curves"
replace franchise = "European Wax Center" if franchise == "europeanWaxCenter"
replace franchise = "Figaro's Pizza" if franchise == "FigarosPizza"
replace franchise = "The Habit Burger Grill" if franchise == "TheHabitBurgerGrill"
replace franchise = "Home Instead" if franchise == "homeInstead"
replace franchise = "ITEX Corporation" if franchise == "ITEXCorporation"
replace franchise = "The Melting Pot" if franchise == "meltingPot"
replace franchise = "Wetzel's Pretzels" if franchise == "wetzelsPretzels"
replace franchise = "Charleys Philly Steaks" if franchise == "charleys"
replace franchise = "Gold's Gym" if franchise == "goldsGym"
replace franchise = "Mrs. Fields" if franchise == "tcbyMrsFields"
replace franchise = "Kung Fu Tea" if franchise == "KungFuTea"
replace franchise = "Abbey Carpet" if franchise == "abbeyCarpet"
replace franchise = "Floors To Go" if franchise == "floorsToGo"
replace franchise = "Frugals" if franchise == "Frugals"
replace franchise = "Mattress Depot" if franchise == "MattressDepot"
replace franchise = "Tan Republic" if franchise == "TanRepublic"
replace franchise = "Any Lab Test Now" if franchise == "anyTest"
replace franchise = "Chuck E. Cheese" if franchise == "ChuckECheeses"
replace franchise = "Expedia CruiseShipCenters" if franchise == "CruiseShipCenters"
replace franchise = "Engel & Völkers" if franchise == "EngelandVolkers"
replace franchise = "Krispy Kreme" if franchise == "krispyKremeFreshShop"
replace franchise = "Mora Iced Creamery Shop" if franchise == "MoraIcedCreamery"
replace franchise = "Sizzler" if franchise == "Sizller"
replace franchise = "Starcycle" if franchise == "Starcycle"
replace franchise = "Aire Serv" if franchise == "aireServ"
replace franchise = "PostalAnnex" if franchise == "postalAnnex"
replace franchise = "Pak Mail" if franchise == "pakMailCenters"
replace franchise = "Drama Kids" if franchise == "DramaKids"
replace franchise = "Five Star Painting" if franchise == "fiveStarPainting"
replace franchise = "Hand and Stone" if franchise == "handAndStone"
replace franchise = "InXpress" if franchise == "InXPress"
replace franchise = "MaidPro" if franchise == "maidPro"
replace franchise = "My Place Hotels" if franchise == "MyPlaceHotels"
replace franchise = "Pump It Up" if franchise == "pumpItUp"
replace franchise = "AlphaGraphics" if franchise == "alphaGraphics"
replace franchise = "Ben & Jerry's" if franchise == "benAndJerrys"
replace franchise = "Elmer's" if franchise == "Elmers"
replace franchise = "F45 Training" if franchise == "F45Training"
replace franchise = "Fit Body Boot Camp" if franchise == "fitBodyBootCamp"
replace franchise = "Global Recruiters Network" if franchise == "globalRecruiters"
replace franchise = "HomeTeam" if franchise == "homeTeamInspections"
replace franchise = "Huntington Learning Centers" if franchise == "huntingtonLearningCenter"
replace franchise = "Johnny Rockets" if franchise == "johnnyRockets"
replace franchise = "Kona Ice" if franchise == "konaIce"
replace franchise = "Novus Franchising" if franchise == "novusLeasedLocationStandAlone"
replace franchise = "Pillar To Post" if franchise == "PillarToPost"
replace franchise = "Pirtek" if franchise == "Pirtek"
replace franchise = "Best In Class" if franchise == "BestinClass"
replace franchise = "C.T. Franchising Systems" if franchise == "caringTransitions"
replace franchise = "Costa Vida" if franchise == "CostaVida"
replace franchise = "Dickey's" if franchise == "dickeys"
replace franchise = "Fujisan" if franchise == "FujiSan"
replace franchise = "HealthSource Chiropractic" if franchise == "healthSource"
replace franchise = "Molly Maid" if franchise == "mollyMaid"
replace franchise = "Mr. Appliance" if franchise == "MrAppliance"
replace franchise = "Mr. Electric" if franchise == "MrElectric"
replace franchise = "Mr. Handyman" if franchise == "mrHandyman"
replace franchise = "Mr. Rooter" if franchise == "mrRooter"
replace franchise = "Palm Beach Tan" if franchise == "palmBeachTan"
replace franchise = "Rainbow International" if franchise == "rainbow"
replace franchise = "Real Property Management" if franchise == "RealPropertyManagement"
replace franchise = "Restoration 1" if franchise == "Restoration1"
replace franchise = "Window Genie" if franchise == "forFranchising"
replace franchise = "World Inspection Network" if franchise == "worldInspection"
replace franchise = "1-800 Radiator" if franchise == "one800Radiator"
replace franchise = "Allegra Network" if franchise == "allegraNetworkMatchMakerCenters"
replace franchise = "BAM Franchising" if franchise == "BricksandMinifigs"
replace franchise = "CARSTAR" if franchise == "carStar"
replace franchise = "Club Z!" if franchise == "clubZ"
replace franchise = "Dutch Bros" if franchise == "DutchBros"
replace franchise = "Emerald City Smoothie" if franchise == "EmeraldCitySmoothie"
replace franchise = "FYZICAL" if franchise == "fyzical"
replace franchise = "Glass Doctor" if franchise == "synergisticInterNational"
replace franchise = "Image360" if franchise == "image360"
replace franchise = "Kiddie Academy" if franchise == "kiddieAcademyLeased"
replace franchise = "MAACO" if franchise == "maaco"
replace franchise = "Mac Tools" if franchise == "macTools"
replace franchise = "Pelindaba Franchising" if franchise == "PelindabaLavender"
replace franchise = "Property Damage Appraisers" if franchise == "propertyDamageAppraisers"
replace franchise = "PuroClean" if franchise == "PuroClean"
replace franchise = "Remedy Intelligent Staffing" if franchise == "RemedyIntelligentStaffing"
replace franchise = "Signs Now" if franchise == "signsNow"
replace franchise = "Soccer Shots" if franchise == "SoccerShots"
replace franchise = "The Joint Corp." if franchise == "jointCorp"
replace franchise = "Urban Float Opportunities" if franchise == "UrbanFloat"
replace franchise = "Waxing the City" if franchise == "WaxingtheCity"
replace franchise = "AdvantaClean" if franchise == "advantaCleanStandard"
replace franchise = "Arthur Murray" if franchise == "arthurMurray"
replace franchise = "Bambu" if franchise == "Bambu"
replace franchise = "CHHJ Franchising" if franchise == "CHHJ"
replace franchise = "Concrete Craft" if franchise == "ConcreteCraft"
replace franchise = "Great Harvest Bread" if franchise == "greatHarvest"
replace franchise = "NPM Franchising" if franchise == "NPMFranchising"
replace franchise = "Paul Davis Restoration" if franchise == "paulDavisRestoration"
replace franchise = "Taco John's" if franchise == "tacoJohn"
replace franchise = "Tailored Living" if franchise == "tailoredLiving"
replace franchise = "Ezell's Famous Chicken" if franchise == "DelightedGuests"
replace franchise = "Dollar Rent A Car" if franchise == "dollarRentACarNonAirport"
replace franchise = "Hertz" if franchise == "hertzNonAirport"
replace franchise = "Real Deals" if franchise == "RealDeals"
replace franchise = "Thrifty Rent A Cat" if franchise == "thriftyRentACar"
replace franchise = "Advanced Fresh Concepts" if franchise == "advancedFreshConcepts"
replace franchise = "Body and Brain Center" if franchise == "bodyAndBrain"
replace franchise = "School of Rock" if franchise == "schoolOfRock"
replace franchise = "Servpro" if franchise == "servpro"
replace franchise = "Spring-Green Lawn Care" if franchise == "springGreen"
replace franchise = "Supporting Strategies" if franchise == "SupportStrategies"
replace franchise = "The Barbers Source" if franchise == "TheBarbersSource"
replace franchise = "The Bar Method" if franchise == "theBarMethod"
replace franchise = "Phenix Salon" if franchise == "phenixSalon"
replace franchise = "Senior Helpers" if franchise == "seniorHelpers"
replace franchise = "Singers Company" if franchise == "Singers"
replace franchise = "Critter Control" if franchise == "critterControl"
replace franchise = "Good Feet" if franchise == "goodFeet"
replace franchise = "Hobby Town" if franchise == "hobbyTownCoreConcept"
replace franchise = "JDog" if franchise == "JDog"
replace franchise = "NextHome" if franchise == "NextHome"
replace franchise = "Signarama" if franchise == "signarama"
replace franchise = "Thrive Community Fitness" if franchise == "ThriveCommunityFitness"
replace franchise = "Transworld Business advisors" if franchise == "transWorld"
replace franchise = "UBuildlt" if franchise == "UBuildIt"
replace franchise = "Abra Automotive Systems" if franchise == "AbraAutomotive"
replace franchise = "AR Workshop" if franchise == "ARWorkshop"
replace franchise = "CarePatrol" if franchise == "carePatrol"
replace franchise = "Fibrenew" if franchise == "fibrenew"
replace franchise = "Freshii" if franchise == "freshii"
replace franchise = "NMC Franchising" if franchise == "NMCFranchising"
replace franchise = "Cost Cutters" if franchise == "CostCutters"
replace franchise = "Smartstyle" if franchise == "Smartstyle"
replace franchise = "Fix Auto" if franchise == "FixAuto"
replace franchise = "John L. Scott Real Estate Affiliates" if franchise == "JohnLScottRealEstate"
replace franchise = "Pro Image" if franchise == "proImage"
replace franchise = "Red Lion Hotels" if franchise == "GuestHouse"
replace franchise = "Velofix" if franchise == "Velofix"
replace franchise = "Weichert Real Estate Affiliates" if franchise == "weichertRealEstate"
replace franchise = "Orangetheory Fitness" if franchise == "ultimateFitness"
replace franchise = "OsteoStrong" if franchise == "OsteoStrong"
replace franchise = "Padgett Business Services" if franchise == "PadgettBusinessServices"
replace franchise = "SYNERGY" if franchise == "synergyHomeCare"
replace franchise = "Board and Brush" if franchise == "BoardAndBrush"
replace franchise = "Poke Bar Dice and Mix" if franchise == "PokeBarDiceMix"
replace franchise = "Two Men and a Truck" if franchise == "twoMen"
replace franchise = "Baja Fresh" if franchise == "bajaFresh"
replace franchise = "Sharetea" if franchise == "Sharetea"
replace franchise = "Manchu Wok" if franchise == "ManchuWok"
replace franchise = "Pizza Factory" if franchise == "PizzaFactory"
replace franchise = "Realty One Group Affiliates" if franchise == "RealtyOne"
replace franchise = "The Little Gym" if franchise == "littleGym"
replace franchise = "Tutor Doctor Systems" if franchise == "tutorDoctor"
replace franchise = "Club Pilates" if franchise == "ClubPilates"
replace franchise = "Elements Massage" if franchise == "elementsMassage"
replace franchise = "Fitness Together" if franchise == "fitnessTogether"
replace franchise = "HomeSmart" if franchise == "homeSmart"
replace franchise = "I love kickboxing" if franchise == "ilkb"
replace franchise = "ServiceMaster" if franchise == "ServiceMaster"
replace franchise = "Toro Tax Franchising" if franchise == "ToroTax"
replace franchise = "Panda Express" if franchise == "pandaExpress"
replace franchise = "Grease Monkey" if franchise == "greaseMonkey"
replace franchise = "Nothing Bundt Cakes" if franchise == "nothingBundt"
replace franchise = "CMIT Solutions" if franchise == "cmitSolutions"
replace franchise = "Golden Corral" if franchise == "goldenCorral"
replace franchise = "Tropical Smoothie Cafe" if franchise == "tropicalSmoothie"
replace franchise = "Canteen" if franchise == "Canteen"
replace franchise = "Right at Home" if franchise == "rightAtHome"
replace franchise = "Fit4Mom" if franchise == "strollerStridesClassic"
replace franchise = "Inchin's Bamboo Garden" if franchise == "InchinsBambooGardenPlayLiveNation"
replace franchise = "PLAYlive Nation" if franchise == "PlayLiveNation"
replace franchise = "Port of Subs" if franchise == "PortOfSubs"
replace franchise = "uBreakiFix" if franchise == "ubif"



* b) Define: variable labels
label var franchise 	  "Franchise name"
label var settlement_date "Settlement date"



* c) Export: clean file for chains that settled with WA AG + settlement date
export excel using "${tables}/Table A.1 - List of AODs.xlsx", firstrow(varlabels) replace
