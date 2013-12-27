replace country="Cote d'Ivoire" if country=="Cote d`Ivoire"
replace country="Gambia, The" if country=="Gambia"
replace country="Egypt, Arab Rep." if country=="Egypt"
replace country="Congo, Dem. Rep." if country=="Democratic Republic of Congo"
replace country="Tanzania, United Rep." if country=="Tanzania"


cd "~/computacion/StataPrograms/worldstat/Shapefiles/Africa"
wbopendata, indicator(gdppckd) clear
rename countryname country
merge m:m country using Africa_data
spmap yr2010 using Africa_coordinates, fcolor(Blues) id(_ID) saving(worldstat_map)

preserve
keep if _merge==3
collapse yr1960-yr2014
gen country="Africa"
reshape long yr, i(country) j(year)
rename yr GDP
line GDP year, saving(worldstat_trend)
restore

graph combine worldstat_map.gph worldstat_trend.gph, cols(2)

preserve
keep if _merge==3
tab country
restore

*preserve
*keep if _merge==3
*collapse yr2010, by(country)
*graph pie yr2010, over(country)
*restore







*use Africa_data, clear
