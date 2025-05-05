capture ssc install tolower		, replace
capture ssc install carryforward, replace 
capture ssc install egenmore	, replace 
capture ssc install insob		, replace
capture ssc install ivreg2, replace 
capture ssc install ranktest, replace
capture ssc install ftools, replace
capture ssc install gtools, replace
capture ssc install reghdfe, replace
capture ssc install ftools, replace
capture ssc install ivreghdfe, replace
capture ssc install outreg		, replace
capture ssc install outreg2		, replace
capture ssc install estout 		, replace 
capture ssc install tabout 		, replace 
capture ssc install dataout		, replace
capture net install cleanplots , replace from("https://tdmize.github.io/data/cleanplots")
capture net install palettes   , replace from("https://raw.githubusercontent.com/benjann/palettes/master/")
capture net install colrspace  , replace from("https://raw.githubusercontent.com/benjann/colrspace/master/")
capture ssc install heatplot   , replace
capture ssc install binscatter , replace
capture net install binscatter2, replace from("https://raw.githubusercontent.com/mdroste/stata-binscatter2/master/")
capture ssc install coefplot   , replace 
capture ssc install did_imputation, replace
capture ssc install event_plot, replace
capture net install dm79, replace from ("http://www.stata.com/stb/stb56")
capture ssc install matsort, replace
