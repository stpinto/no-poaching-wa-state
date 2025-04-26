capture ssc install tolower		, replace
capture ssc install carryforward, replace 
ssc install egenmore	, replace 
ssc install insob		, replace
ssc install ivreg2, replace 
ssc install ranktest, replace
ssc install ftools, replace
ssc install gtools, replace
ssc install reghdfe, replace
ssc install ftools, replace
ssc install ivreghdfe, replace
ssc install outreg		, replace
ssc install outreg2		, replace
ssc install estout 		, replace 
ssc install tabout 		, replace 
ssc install dataout		, replace
net install cleanplots , replace from("https://tdmize.github.io/data/cleanplots")
net install palettes   , replace from("https://raw.githubusercontent.com/benjann/palettes/master/")
net install colrspace  , replace from("https://raw.githubusercontent.com/benjann/colrspace/master/")
ssc install heatplot   , replace
ssc install binscatter , replace
net install binscatter2, replace from("https://raw.githubusercontent.com/mdroste/stata-binscatter2/master/")
ssc install coefplot   , replace 
ssc install did_imputation, replace
ssc install event_plot, replace
net install dm79, replace from ("http://www.stata.com/stb/stb56")
ssc install matsort, replace