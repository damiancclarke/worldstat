* worldstat 1.00                 dh:2012-10-22                  Damian C. Clarke
*---|----1----|----2----|----3----|----4----|----5----|----6----|----7----|----8

capture program drop worldstat
program define worldstat
	vers 10.0
	
	//syntax is: worldstat place, stat(string) 
	// COMMAND SYNTAX
	syntax name(id="Region name" name=place), Stat(string)


	local year 2010
	local region Africa


	//Call to server which hosts shape files
	webuse set "http://users.ox.ac.uk/~ball3491/"
	
	//Opening map data
	if "`place'"==`"`world'"' {
		dis in yellow "Accessing shape file for the world to create geographical visualisation"
	}
	else if "`place'"!=`"`world'"' {
		dis in yellow "Accessing shape file for `place' to create geographical visualisation"
	}
	webuse `place'_data, clear
	qui save temp_map_data
	webuse `place'_coords, clear
	qui save temp_map_coordinates

	//Opening WB Indicator Data
	if "`stat'"=="GDP" {
		local indic gdppckd
		local indicator GDP p.c.
	}
	dis "Importing `stat' from World Bank database"
	wbopendata, indicator(gdppckd) clear




	dis "Visualising data"
	rename countryname country
	merge m:m country using temp_map_data
	spmap yr`year' using temp_map_coordinates, fcolor(Blues) id(_ID) ///
	legend(title("`indicator', `year'", size(*0.5))) ///
	saving(worldstat_map, replace)

	preserve
	keep if _merge==3
	collapse yr1960-yr2014
	gen country="Africa"
	reshape long yr, i(country) j(year)
	rename yr `stat'
	twoway line `stat' year, ytitle("`indicator'") ///
	saving(worldstat_trend, replace)

	restore


	graph combine worldstat_map.gph worldstat_trend.gph, cols(2) ///
	title("`indicator' for `region': Cross-section and Time-Series") ///
	note("`indicator' in graphical form is from `year'.  Time series is 1960-2014.", size(*0.8)) 

	preserve
	keep if _merge==3
	tab country
	restore

	rm temp_map_data.dta
	rm temp_map_coordinates.dta


	
end
