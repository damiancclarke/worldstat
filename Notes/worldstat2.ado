* worldstat 1.00                 dh:2012-10-22                  Damian C. Clarke
*---|----1----|----2----|----3----|----4----|----5----|----6----|----7----|----8


**NOTE THAT THIS IS A WORK IN PROGRESS.  VARIOUS THINGS MUST STILL BE ADDED AND
**CLEANED UP.

capture program drop worldstat
program define worldstat
	vers 10.0
	
	//syntax is: worldstat place, stat(string) 
	// COMMAND SYNTAX
	syntax name(id="Region name" name=place), stat(string)


	local year 2010

	//Create appropriate temporary files for maps
	webuse set "http://users.ox.ac.uk/~ball3491/"

	
	//Opening map data
	if "`place'"==`"`world'"' {
		dis in yellow "Accessing shape file for the world to create geographical visualisation"
	}
	else if "`place'"!=`"`world'"' {
		dis in yellow "Accessing shape file for `place' to create geographical visualisation"
	}
	webuse `place'_data, clear
	qui save temp_map_data, replace
	webuse `place'_coords, clear
	qui save temp_map_coordinates, replace

	
	
	
	//Inbuilt variables	
	//Opening WB Indicator Data
	if "`stat'"=="GDP" {
		local indic gdppckd
		local indicator GDP p.c.
	}
	else if "`stat'"=="MMR" {
		local indic SH.STA.MMRT
		local indicator Maternal Mortality
	}	
	else if "`stat'"=="EDUP" {
		local indic SE.PRM.NENR
		local indicator Primary Education Enrollment
	}	
	else if "`stat'"=="EDUS" {
		local indic SE.SEC.NENR
		local indicator Secondary Education Enrollment
	}	
	else if "`stat'"=="CO2" {
		local indic EN.ATM.CO2E.PC
		local indicator CO2 Emissions p. c.
	}	
	else if "`stat'"=="MORT" {
		local indic SH.DYN.MORT
		local indicator Under 5 Mortality
	}	
	else if "`stat'"=="LIFE" {
		local indic SP.DYN.LE00.FE.IN
		local indicator Life Expectancy at Birth
	}	
	else if "`stat'"=="CAB" {
		local indic BN.CAB.XOKA.GD.ZS
		local indicator Current Account Balance
	}	
	else if "`stat'"=="FDI" {
		local indic BX.KLT.DINV.CD.WD
		local indicator Foreign Direct Investment
	}	
	else if "`stat'"=="GDP2" {
		local indic NY.GDP.PCAP.KD
		local indicator GDP p.c.
	}		
	else if "`stat'"=="INF" {
		local indic FP.CPI.TOTL.ZG
		local indicator Inflation
	}		
	else if "`stat'"=="ODA" {
		local indic DT.ODA.ODAT.PC.ZS
		local indicator Overseas Development Assistance
	}		
	else if "`stat'"=="HIV" {
		local indic SH.DYN.AIDS.ZN
		local indicator Prevalence of HIV
	}		
	else if "`stat'"=="ENER" {
		local indic EG.GDP.PUSE.KO.PP
		local indicator GDP per unit of Energy
	}		
	else if "`stat'"=="SLR" {
		local indic IC.LGL.CRED.XQ
		local indicator Strength of Legal Rights
	}		
	else if "`stat'"=="AGE" {
		local indic SP.POP.DPND.YG
		local indicator Age Dependency Ratio
	}		
	else if "`stat'"=="BIRTH" {
		local indic SP.DYN.CBRT.IN
		local indicator Birth Rate
	}		
	else if "`stat'"=="FERT" {
		local indic SP.DYN.TFRT.IN
		local indicator Fertility per Woman
	}		
	else if "`stat'"=="IMM" {
		local indic SH.IMM.IDPT
		local indicator Immunization Rate (DPT)
	}		
	else {
		local indic `stat'
		local indicator `stat'
	}
	
	

	
	
	
	dis "Importing `stat' from World Bank database"
	wbopendata, indicator(`indic') clear




	dis "Visualising data"
	rename countryname country
	qui merge m:m country using temp_map_data
	spmap yr`year' using temp_map_coordinates, fcolor(Blues) id(_ID) ///
	legend(title("`indicator', `year'", size(*0.5))) ///
	saving(worldstat_map, replace)

	
	if "`place'"=="world"|"`place'"=="CAmerica" {	
		preserve
		keep if _merge==3
		collapse yr1960-yr2011
		gen region="`place'"
		qui reshape long yr, i(region) j(year)
		rename yr `stat'
		twoway line `stat' year, ytitle("`indicator'") ///
		saving(worldstat_trend, replace)	
		restore
			
			if "`place'"=="world" {
			preserve
			keep if _merge==3
			collapse yr1960-yr2011, by(region)
			qui reshape long yr, i(region) j(year)
			rename yr `stat'
			encode region, gen(region1)
			twoway line `stat' year if region1==1 || line `stat' year if region1==2 || ///
			line `stat' year if region1==3|| line `stat' year if region1==4|| ///
			line `stat' year if region1==5|| line `stat' year if region1==6|| ///
			line `stat' year if region1==7, ytitle("`indicator'") ylabel(#2) ///
			legend(lab(1 "East Asia") lab(2 "Europe") lab(3 "LAC") lab(4 "MENA") lab(5 "NA") lab(6 "Sth Asia") ///
			lab(7 "SSA") rowgap(1)) ///
			saving(worldstat_trend_region, replace)	
			restore
			}
		
		graph combine worldstat_trend.gph worldstat_trend_region.gph, cols(2) ///
		saving(worldstat_trend_combine, replace) ///
		
		graph combine worldstat_trend_combine.gph worldstat_map.gph, cols(1) ///
		title("`indicator' for `place'") subtitle("Cross-section and Time-Series") ///
		note("`indicator' in graphical form is from `year'.  Time series is 1960-2014.", size(*0.5)) 
		
	}

	else if "`place'"=="Africa"|"`place'"=="NAmerica"|"`place'"=="SAmerica" {
		preserve
		keep if _merge==3
		collapse yr1960-yr2011
		gen region="`place'"
		qui reshape long yr, i(region) j(year)
		rename yr `stat'
		twoway line `stat' year, ytitle("`indicator'") ///
		saving(worldstat_trend, replace)	
		restore

		graph combine worldstat_map.gph worldstat_trend.gph, cols(2) ///
		title("`indicator' for `place'") subtitle("Cross-section and Time-Series") ///
		note("`indicator' in graphical form is from `year'.  Time series is 1960-2014.", size(*0.5)) 	
	}
	
	
	
	preserve
	keep if _merge==3
	tab country
	restore

	cap rm temp_map_data.dta
	cap rm temp_map_coordinates.dta
	cap rm worldstat_trend_region.gph
	cap rm worldstat_trend_combine.gph
	cap rm worldstat_trend.gph
	cap rm worldstat_map.gph
	
	webuse set
	
	
end
