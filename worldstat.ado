*! worldstat: Visualising the state of world development
*! Version 2.4.0: 2021/10/07
*! Author: Damian Clarke 
*! Department of Economics
*! The University of Chile
*! dclarke@fen.uchile.cl

capture program drop worldstat
program define worldstat
vers 10.0
set more off
********************************************************************************
*** SYNTAX AND PRESERVE (IF NECESSARY)
********************************************************************************	
syntax name(id="Region name" name=place), ///
stat(string)		 	          ///
[                                         ///
 year(numlist) 	                          ///
 PREServe		                  ///
 SName(string)	                          ///
 CName			                  ///
 MAPonly			          ///
 fcolor(string)                           ///
 condition(string)                        ///
 *                                        ///
]

if length("`preserve'") != 0 {
    tempfile init
    cap save `init', replace
}

clear

********************************************************************************
*** TIME DATA
********************************************************************************	
// Timing variables
if length(`"`year'"') != 0 local year `year'
else local year 2010

if length(`"`fcolor'"') == 0 local fcolor Blues2

********************************************************************************
*** CHECK FOR ado's
********************************************************************************
di in green "worldstat is built using the functionality of the module wbopendata." 
di in green "checking {cmd:wbopendata} consistency and verifying not already installed..."
foreach req in spmap wbopendata {
    cap findfile `req'.ado
    if _rc != 0 {
        qui ssc install `req', replace all
    }
}

********************************************************************************
*** PLACE DATA
********************************************************************************
// Places
if "`place'"=="Europe"|"`place'"=="europe" {
    if length("`condition'") != 0 local cond `condition'&REGION==150
    else local cond if REGION==150
    local pname Europe
    local coords europe_coords
    local csize 2
}
else if "`place'"=="Asia"|"`place'"=="asia" {
    if length("`condition'") != 0 local cond `condition'&REGION==142
    else local cond if REGION==142
    local pname Asia
    local coords world_coords
    local csize 1.5
}
else if "`place'"=="America"|"`place'"=="america" {
    if length("`condition'") != 0 {
        local cond `condition'&(SUBREGION==5 | SUBREGION==29| SUBREGION==13)
    }
    else local cond if SUBREGION==5 | SUBREGION==29| SUBREGION==13
    local pname Latin America
    local coords world_coords
    local csize 2
}
else if "`place'"=="SAmerica"|"`place'"=="samerica"|"`place'"=="Samerica" {
    if length("`condition'") != 0 local cond `condition'&SUBREGION==5
    else local cond if SUBREGION==5
    local pname South America
    local coords world_coords
    local csize 2.5
}
else if "`place'"=="Oceania"|"`place'"=="oceania" {
    if length("`condition'") != 0 local cond `condition'&REGION==9
    else local cond if REGION==9
    local pname Oceania
    local coords oceania_coords
    local csize 3
}
else if "`place'"=="Africa"|"`place'"=="africa" {
    if length("`condition'") != 0 local cond `condition'&REGION==2
    else local cond if REGION==2
    local pname Africa
    local coords world_coords
    local csize 2
}
else if "`place'"=="World"|"`place'"=="world" {
    if length("`condition'") != 0 local cond `condition'
    else local cond
    local pname the world
    local coords world_coords
    local csize 1
}
else if "`place'"=="NSAmerica"|"`place'"=="nsamerica" {
    if length("`condition'") != 0 local cond `condition'&REGION==19
    else local cond if REGION==19
    local pname North/ South America
    local coords world_coords
    local csize 2
}

********************************************************************************
*** OPEN MAP DATA (Checks if shape files installed on user's system, or if not
*** installs from net.  From v2.1 onwards shape file should be on user's system)
********************************************************************************
dis in yellow "Accessing shape file for `place' to create geographical visualisation"
dis "Accessing shape files for map output remotely"
webuse set "http://damianclarke.net/stata/worldstat/"
webuse world_data, clear
qui save temp_map_data, replace
webuse `coords', clear
qui save temp_map_coordinates, replace	


********************************************************************************
*** INDICATOR DATA
********************************************************************************
//Opening WB Indicator Data
if "`stat'"=="GDP" {
    local indic NY.GDP.PCAP.KD
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
    local indicator CO2 Emissions p.c.
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
else if "`stat'"=="INF" {
    local indic FP.CPI.TOTL.ZG
    local indicator Inflation
}		
else if "`stat'"=="ODA" {
    local indic DT.ODA.ODAT.PC.ZS
    local indicator Overseas Development Assistance
}		
else if "`stat'"=="HIV" {
    local indic SH.DYN.AIDS.ZS
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
    if length(`"`sname'"') == 0 {
        local indic `stat'
        local indicator `stat'
        local other yes
    }
    else if length(`"`sname'"') != 0 {
        local indic `stat'
        local indicator `sname'
        local other yes
    }
}


dis "Importing `stat' from World Bank database"
wbopendata, indicator(`indic') clear

// Determining first and last year
local minyr 1960
cap sum yr1960
while _rc!=0 {
    local ++minyr
    cap sum yr`minyr'
}

local maxyr 2030
cap sum yr2030
while _rc!=0 {
    local --maxyr
    cap sum yr`maxyr'
}

********************************************************************************
*** OUTPUT
********************************************************************************
**(A) MAP
if length(`"`cname'"') == 0 {
    dis "Visualising data"
    local res "Respecify using an earlier year via the year option."
    rename countrycode ISO3
    qui merge 1:1 ISO3 using temp_map_data
    
    if "`place'"=="SAmerica"|"`place'"=="samerica"|"`place'"=="Samerica"|"`place'"=="South America" {
        #delimit ;
        cap qui spmap yr`year' using temp_map_coordinates `cond', id(_ID)
        legend(title("`indicator', `year'", size(*0.5)) position(5)) fcolor(`fcolor') 
        saving(worldstat_map, replace) nodraw `options';
        #delimit cr
        if _rc!=0 dis as error "No observations for this indicator in this year.  `res'"
    }
    else if "`place'"=="Europe"|"`place'"=="europe" {
        #delimit ;
        cap qui spmap yr`year' using temp_map_coordinates `cond', id(_ID)
        legend(title("`indicator', `year'", size(*0.5)) position(6)) fcolor(`fcolor') 
        saving(worldstat_map, replace) nodraw `options';
        #delimit cr
        if _rc!=0 dis as error "No observations for this indicator in this year.  `res'"
    }
    else {
        #delimit ;
        cap qui spmap yr`year' using temp_map_coordinates `cond', id(_ID) 
        legend(title("`indicator', `year'", size(*0.5))) fcolor(`fcolor') 
        saving(worldstat_map, replace) nodraw `options';
        #delimit cr
        if _rc!=0 dis as error "No observations for this indicator in this year.  `res'"
    }
}
else if length(`"`cname'"') != 0 {
    dis "Visualising data"
    local res "Respecify using an earlier year via the year option."
    rename countrycode ISO3
    qui merge 1:1 ISO3 using temp_map_data
    
    if "`place'"=="SAmerica"|"`place'"=="samerica"|"`place'"=="Samerica" {
        #delimit ;
        cap qui spmap yr`year' using temp_map_coordinates `cond', fcolor(`fcolor') id(_ID) 
        legend(title("`indicator', `year'", size(*0.5)) position(5)) 
        label(data(temp_map_data) select(keep `cond') y(LAT) x(LON) label(NAME)
              size(`csize')) saving(worldstat_map, replace) nodraw `options';
        #delimit cr
        if _rc!=0 dis as error "No observations for this indicator in this year.  `res'"
    }
    else if "`place'"=="Europe"|"`place'"=="europe" {
        #delimit ;
        cap qui spmap yr`year' using temp_map_coordinates `cond', fcolor(`fcolor') id(_ID) 
        legend(title("`indicator', `year'", size(*0.5)) position(6)) 
        label(data(temp_map_data) select(keep `cond') y(LAT) x(LON) label(NAME)
              size(`csize')) saving(worldstat_map, replace) nodraw `options';
        #delimit cr
        if _rc!=0 dis as error "No observations for this indicator in this year.  `res'"
    }
    else {
        #delimit ;
        cap qui spmap yr`year' using temp_map_coordinates `cond',
        fcolor(`fcolor') id(_ID) legend(title("`indicator', `year'", size(*0.5)))
        label(data(temp_map_data) select(cap keep `cond') y(LAT) x(LON)
              label(NAME) size(`csize')) saving(worldstat_map, replace) nodraw `options';
        #delimit cr
        if _rc!=0 dis as error "No observations for this indicator in this year. `res'"
    }
}


**(B) TIME SERIES AND COMBINE
if length(`"`maponly'"') == 0 {
    if "`place'"=="world"|"`place'"=="World" |"`place'"=="Europe"|"`place'"=="europe" |"`place'"=="nsamerica"|"`place'"=="NSAmerica"{	
        preserve
        cap keep `cond'
        collapse yr`minyr'-yr`maxyr'
        gen region="`place'"
        qui reshape long yr, i(region) j(year)
        if "`other'"=="yes"{
            local stat Indicator
        }
        rename yr `stat'
        if "`place'"=="world"|"`place'"=="World" {
            qui twoway line `stat' year, ytitle("`indicator'") ///
            saving(worldstat_trend, replace) nodraw		
        }
        else {
            qui twoway line `stat' year, ytitle("`indicator'") ///
            saving(worldstat_trend_combine, replace) nodraw			
        }
        restore	
        
        if "`place'"=="world"|"`place'"=="World" {
            preserve
            cap keep `cond'
            collapse yr`minyr'-yr`maxyr', by(region)
            qui reshape long yr, i(region) j(year)
            if "`other'"=="yes"{
                local stat Indicator
            }
            rename yr `stat'
            encode region, gen(region1)
            #delimit ;
            qui twoway line `stat' year if region1==1 || line `stat' year if region1==2 ||
                       line `stat' year if region1==3 || line `stat' year if region1==4 ||
                       line `stat' year if region1==5 || line `stat' year if region1==6 ||
                       line `stat' year if region1==7, ytitle("`indicator'") ylabel(#2) 
            legend(lab(1 "East Asia") lab(2 "Europe") lab(3 "LAC") lab(4 "MENA") 
                   lab(5 "NA") lab(6 "Sth Asia") lab(7 "SSA") rowgap(1)) 
            saving(worldstat_trend_region, replace) nodraw;
            #delimit cr
            restore

            qui graph combine worldstat_trend.gph worldstat_trend_region.gph, cols(2) ///
            saving(worldstat_trend_combine, replace) nodraw  // take this out to make an empty one for Eur
        }
	graph combine worldstat_trend_combine.gph worldstat_map.gph, cols(1) ///
        title("`indicator' for `pname'") subtitle("Cross-section and Time-Series") ///
        note("`indicator' in graphical form is from `year'.  Time series is `minyr'-`maxyr'.", size(*0.5)) 
    }
    else  {
        preserve
        cap keep `cond'
        collapse yr`minyr'-yr`maxyr'
        gen region="`place'"
        qui reshape long yr, i(region) j(year)
        if "`other'"=="yes"{
            local stat Indicator
        }
        rename yr `stat'
        qui twoway line `stat' year, ytitle("`indicator'") ///
        saving(worldstat_trend, replace) nodraw
        restore
        
        graph combine worldstat_map.gph worldstat_trend.gph, cols(2) ///
        title("`indicator' for `pname'") subtitle("Cross-section and Time-Series") ///
        note("`indicator' in graphical form is from `year'.  Time series is `minyr'-`maxyr'.", size(*0.5)) 	
    }
}
else if length(`"`maponly'"') != 0 {	
    graph combine worldstat_map.gph, title("`indicator' for `pname'") ///
    note("`indicator' in graphical form is from `year'.", size(*0.5)) 	
}
********************************************************************************
*** CLEAN UP
********************************************************************************
cap rm temp_map_data.dta
cap rm temp_map_coordinates.dta
cap rm worldstat_trend_region.gph
cap rm worldstat_trend_combine.gph
cap rm worldstat_trend.gph
cap rm worldstat_map.gph

di ""
di ""
di ""
di in smcl `"For a full list of indicators, see {browse "http://worldbank.270a.info/classification/indicator.html"}."'
                                                            
qui {
    webuse set
}

if length("`preserve'") != 0 {
    clear
    cap use `init'
}

end
