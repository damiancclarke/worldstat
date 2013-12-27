local region Africa
local indicator GDP p.c.
local year 2010


cd "~/computacion/StataPrograms/worldstat/Shapefiles/Africa"

wbopendata, indicator(gdppckd) clear
rename countryname country
merge m:m country using Africa_data
spmap yr`year' using Africa_coordinates, fcolor(Blues) id(_ID) ///
legend(title("`indicator', `year'", size(*0.5))) ///
saving(worldstat_map, replace)

preserve
keep if _merge==3
collapse yr1960-yr2014
gen country="Africa"
reshape long yr, i(country) j(year)
rename yr GDP
twoway line GDP year, ytitle("`indicator'") ///
saving(worldstat_trend, replace)

restore


graph combine worldstat_map.gph worldstat_trend.gph, cols(2) ///
title("`indicator' for `region': Cross-section and Time-Series") ///
note("`indicator' in graphical form is from `year'.  Time series is 1960-2014.", size(*0.8)) 

preserve
keep if _merge==3
tab country
restore

/*
WHAT I HAVE TO DO:
- Import maps for each continent
- Link to maps on line (figure out https thing!!)
- Make sure that maps and WB data are named identically
- Make world option
- Make a list of possible stats
- Create appropriate output
- Write help file


///
plotr(fcolor(white))

shp2dta using world, data("world_data")  coor("world_coordinates")


*/
