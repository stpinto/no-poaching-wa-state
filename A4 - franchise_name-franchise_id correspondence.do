/*----------------------------------------------------------------------------*/

* This do-file provides a crosswalk between the franchise name and a numeric identifier

/*----------------------------------------------------------------------------*/
*STEPS:
	*0. Set directories.
	*1. Fix franchise names.
/*-----------------------------------------------------------------------------*/


*------------------------------------------------------------------------------*
* 0) Set directories
*------------------------------------------------------------------------------*
clear  all
global master_path 	"[INSERT USER'S RELEVANT PATH]"
global data_con_r 	"${master_path}/data/contract/raw"
global data_con_c 	"${master_path}/data/contract/cln"



*------------------------------------------------------------------------------*
* 1) Fix no-poach variable on the contract data
*------------------------------------------------------------------------------*
use "${data_con_r}/franchise_contracts_clean", clear
set more off


* a) Replace: name for "jiffyLube"
replace franchise = "jiffyLube" if franchise == "jiffyLubeNonProductSupplyFix This"



* b) Add: franchises that settled with the WA AG and were not in the initial list
// Add rows to the dataset, so we can have the new chains
insobs 84																		// inserts 84 blank rows at the end of the dataset (after the initial 530 chains)

// Extend the franchise_id
replace franchise_id = franchise_id[_n-1] + 1 if franchise_id == . 

// Edit the "franchise" variable and the "franchise_id" values
replace franchise = "MerryMaids" 			  if franchise_id == 531 
label define franchise_id 531 "MerryMaids", modify
replace franchise = "JackInTheBox" 			  if franchise_id == 532 
label define franchise_id 532 "JackInTheBox", modify
replace franchise = "TheOriginalPancakeHouse" if franchise_id == 533 
label define franchise_id 533 "TheOriginalPancakeHouse", modify
replace franchise = "BonefishGrill" 		  if franchise_id == 534 
label define franchise_id 534 "BonefishGrill", modify
replace franchise = "CarrabbasItalianGrill"   if franchise_id == 535 
label define franchise_id 535 "CarrabbasItalianGrill", modify
replace franchise = "OutbackSteakhouse" 	  if franchise_id == 536
label define franchise_id 536 "OutbackSteakhouse", modify
replace franchise = "LandLFranchising" 		  if franchise_id == 537
label define franchise_id 537 "LandLFranchising", modify
replace franchise = "WestsidePizza" 		  if franchise_id == 538
label define franchise_id 538 "WestsidePizza", modify
replace franchise = "ZeeksPizza" 			  if franchise_id == 539
label define franchise_id 539 "ZeeksPizza", modify
replace franchise = "MioSushi" 				  if franchise_id == 540
label define franchise_id 540 "MioSushi", modify

replace franchise = "FigarosPizza" 			  if franchise_id == 541
label define franchise_id 541 "FigarosPizza", modify
replace franchise = "TheHabitBurgerGrill" 	  if franchise_id == 542
label define franchise_id 542 "TheHabitBurgerGrill", modify
replace franchise = "ITEXCorporation" 		  if franchise_id == 543
label define franchise_id 543 "ITEXCorporation", modify
replace franchise = "Frugals" 				  if franchise_id == 544
label define franchise_id 544 "Frugals", modify
replace franchise = "KungFuTea" 			  if franchise_id == 545
label define franchise_id 545 "KungFuTea", modify
replace franchise = "MattressDepot" 		  if franchise_id == 546
label define franchise_id 546 "MattressDepot", modify
replace franchise = "TanRepublic" 			  if franchise_id == 547
label define franchise_id 547 "TanRepublic", modify
replace franchise = "ChuckECheeses" 		  if franchise_id == 548
label define franchise_id 548 "ChuckECheeses", modify
replace franchise = "CruiseShipCenters" 	  if franchise_id == 549
label define franchise_id 549 "CruiseShipCenters", modify
replace franchise = "EngelandVolkers" 		  if franchise_id == 550
label define franchise_id 550 "EngelandVolkers", modify

replace franchise = "MoraIcedCreamery" 		  if franchise_id == 551
label define franchise_id 551 "MoraIcedCreamery", modify
replace franchise = "Sizller" 		 		  if franchise_id == 552
label define franchise_id 552 "Sizller", modify
replace franchise = "Starcycle" 			  if franchise_id == 553
label define franchise_id 553 "Starcycle", modify
replace franchise = "DramaKids" 			  if franchise_id == 554
label define franchise_id 554 "DramaKids", modify
replace franchise = "InXPress" 				  if franchise_id == 555
label define franchise_id 555 "InXPress", modify
replace franchise = "MyPlaceHotels" 		  if franchise_id == 556
label define franchise_id 556 "MyPlaceHotels", modify
replace franchise = "BestinClass" 			  if franchise_id == 557
label define franchise_id 557 "BestinClass", modify
replace franchise = "BricksandMinifigs" 	  if franchise_id == 558
label define franchise_id 558 "BricksandMinifigs", modify
replace franchise = "CostaVida" 			  if franchise_id == 559
label define franchise_id 559 "CostaVida", modify
replace franchise = "DutchBros" 			  if franchise_id == 560
label define franchise_id 560 "DutchBros", modify

replace franchise = "Elmers" 				  if franchise_id == 561
label define franchise_id 561 "Elmers", modify
replace franchise = "EmeraldCitySmoothie" 	  if franchise_id == 562
label define franchise_id 562 "EmeraldCitySmoothie", modify
replace franchise = "F45Training" 			  if franchise_id == 563
label define franchise_id 563 "F45Training", modify
replace franchise = "FujiSan" 				  if franchise_id == 564
label define franchise_id 564 "FujiSan", modify
replace franchise = "MrAppliance" 			  if franchise_id == 565
label define franchise_id 565 "MrAppliance", modify
replace franchise = "MrElectric" 			  if franchise_id == 566
label define franchise_id 566 "MrElectric", modify
replace franchise = "PelindabaLavender" 	  if franchise_id == 567
label define franchise_id 567 "PelindabaLavender", modify
replace franchise = "PillarToPost" 			  if franchise_id == 568
label define franchise_id 568 "PillarToPost", modify
replace franchise = "Pirtek" 			  	  if franchise_id == 569
label define franchise_id 569 "Pirtek", modify
replace franchise = "PuroClean" 			  if franchise_id == 570
label define franchise_id 570 "PuroClean", modify

replace franchise = "RealPropertyManagement" 	if franchise_id == 571
label define franchise_id 571 "RealPropertyManagement", modify
replace franchise = "RemedyIntelligentStaffing" if franchise_id == 572
label define franchise_id 572 "RemedyIntelligentStaffing", modify
replace franchise = "Restoration1" 				if franchise_id == 573
label define franchise_id 573 "Restoration1", modify
replace franchise = "SoccerShots" 				if franchise_id == 574
label define franchise_id 574 "SoccerShots", modify
replace franchise = "UrbanFloat" 				if franchise_id == 575
label define franchise_id 575 "UrbanFloat", modify
replace franchise = "WaxingtheCity" 			if franchise_id == 576
label define franchise_id 576 "WaxingtheCity", modify
replace franchise = "Bambu" 					if franchise_id == 577
label define franchise_id 577 "Bambu", modify
replace franchise = "CHHJ" 						if franchise_id == 578
label define franchise_id 578 "CHHJ", modify
replace franchise = "ConcreteCraft" 			if franchise_id == 579
label define franchise_id 579 "ConcreteCraft", modify
replace franchise = "NPMFranchising" 			if franchise_id == 580
label define franchise_id 580 "NPMFranchising", modify

replace franchise = "DelightedGuests" 			if franchise_id == 581
label define franchise_id 581 "DelightedGuests", modify
replace franchise = "RealDeals" 				if franchise_id == 582
label define franchise_id 582 "RealDeals", modify
replace franchise = "SupportStrategies"			if franchise_id == 583
label define franchise_id 583 "SupportStrategies", modify
replace franchise = "TheBarberSource" 			if franchise_id == 584
label define franchise_id 584 "TheBarberSource", modify
replace franchise = "Singers" 					if franchise_id == 585
label define franchise_id 585 "Singers", modify
replace franchise = "JDog" 						if franchise_id == 586
label define franchise_id 586 "JDog", modify
replace franchise = "NextHome" 					if franchise_id == 587
label define franchise_id 587 "NextHome", modify
replace franchise = "ThriveCommunityFitness" 	if franchise_id == 588
label define franchise_id 588 "ThriveCommunityFitness", modify
replace franchise = "UBuildIt" 					if franchise_id == 589
label define franchise_id 589 "UBuildIt", modify
replace franchise = "AbraAutomotive" 			if franchise_id == 590
label define franchise_id 590 "AbraAutomotive", modify

replace franchise = "ARWorkshop" 				if franchise_id == 591
label define franchise_id 591 "ARWorkshop", modify
replace franchise = "NMCFranchising" 			if franchise_id == 592
label define franchise_id 592 "NMCFranchising", modify
replace franchise = "CostCutters"				if franchise_id == 593
label define franchise_id 593 "CostCutters", modify
replace franchise = "Smartstyle" 				if franchise_id == 594
label define franchise_id 594 "Smartstyle", modify
replace franchise = "FixAuto" 					if franchise_id == 595
label define franchise_id 595 "FixAuto", modify
replace franchise = "JohnLScottRealEstate" 		if franchise_id == 596
label define franchise_id 596 "JohnLScottRealEstate", modify
replace franchise = "GuestHouse" 				if franchise_id == 597
label define franchise_id 597 "GuestHouse", modify
replace franchise = "Velofix" 					if franchise_id == 598
label define franchise_id 598 "Velofix", modify
replace franchise = "OsteoStrong" 				if franchise_id == 599
label define franchise_id 599 "OsteoStrong", modify
replace franchise = "PadgettBusinessServices" 	if franchise_id == 600
label define franchise_id 600 "PadgettBusinessServices", modify

replace franchise = "BoardAndBrush" 			if franchise_id == 601
label define franchise_id 601 "BoardAndBrush", modify
replace franchise = "PokeBarDiceMix" 			if franchise_id == 602
label define franchise_id 602 "PokeBarDiceMix", modify
replace franchise = "Sharetea"					if franchise_id == 603
label define franchise_id 603 "Sharetea", modify
replace franchise = "ManchuWok" 				if franchise_id == 604
label define franchise_id 604 "ManchuWok", modify
replace franchise = "PizzaFactory" 				if franchise_id == 605
label define franchise_id 605 "PizzaFactory", modify
replace franchise = "RealtyOne" 				if franchise_id == 606
label define franchise_id 606 "RealtyOne", modify
replace franchise = "ClubPilates" 				if franchise_id == 607
label define franchise_id 607 "ClubPilates", modify
replace franchise = "ServiceMaster" 			if franchise_id == 608
label define franchise_id 608 "ServiceMaster", modify
replace franchise = "ToroTax" 					if franchise_id == 609
label define franchise_id 609 "ToroTax", modify
replace franchise = "Bishops" 					if franchise_id == 610
label define franchise_id 610 "Bishops", modify

replace franchise = "Canteen" 					if franchise_id == 611
label define franchise_id 611 "Canteen", modify
replace franchise = "InchinsBambooGarden" 		if franchise_id == 612
label define franchise_id 612 "InchinsBambooGarden", modify
replace franchise = "PlayLiveNation"			if franchise_id == 613
label define franchise_id 613 "PlayLiveNation", modify
replace franchise = "PortOfSubs" 				if franchise_id == 614
label define franchise_id 614 "PortOfSubs", modify



* c) Keep: key variables
keep franchise franchise_id naics4_contracts



* d) Save: clean file for contract data
compress
save "${data_con_c}/franchise_contracts_clean", replace
