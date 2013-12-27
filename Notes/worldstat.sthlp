{smcl}
{* 07 August 2012}{...}
{hline}
help for {hi:worldstat}
{hline}

{title:Title}

{p 8 20 2}
    {hi:worldstat} {hline 2} A visualisation of the state of world development



{title:Syntax}

{p 8 20 2}
{cmdab:worldstat} {it:place_name} {cmd:,}
stat({it:statistic_name}) [{it:options}]


{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Options}
{synopt :{opth s:tat(namelist)}}lists the statistic which the user wishes to visualise.
{p_end}
{...}
{synopt :{cmdab:inop:tion(}{help insheet##syntax:options}{cmd:)}}allows for {help insheet} options to be specified when importing data.  Any
{help insheet##syntax:options} which are available in {help insheet} can be used.  This option should only be used when importing via {cmdab:imp:ort(}{it:file type}{cmd:)}
{p_end}
{...}
{synoptline}
{p2colreset}


{title:Description}
{p 6 6 2}
{hi:worldstat} is a module which allows for the current state of world development to be visualised in a computationally simple way.  {hi:worldstat} presents both the geographic and
temporal variation in a wide range of statistics which represent the state of national development.  While {hi:worldstat} includes a number of "in-built" statistics such as GDP,
maternal mortality and years of schooling, it is extremely flexible, and can (thanks to the World Bank's module {help wbopendata}) easily incorporate over 5,000 other indicators 
housed in World Bank Open Databases.
 
{p 6 6 2}





{marker statistics}{...}
{title:Statistics}
           Statistic    WB Code				Description
           {hline 80}
              {cmd:GDP}       {it:gdppckd}             Gross Domestic Product (per capita)
              {cmd:MMR}       {it:SH.STA.MMRT}         Maternal mortality ratio (modeled estimate, 
					     per 100,000 live births)
              {cmd:EDUP}      {it:SE.PRM.NENR}         School enrollment, primary (% net)
              {cmd:EDUS}      {it:SE.SEC.NENR}         School enrollment, secondary (% net)
              {cmd:CO2}       {it:EN.ATM.CO2E.PC}      Carbon dioxide emissions p.c. (metric tons)
              {cmd:MORT}      {it:SH.DYN.MORT}         Mortality rate, under-5 (per 1,000 live births)
              {cmd:LIFE}      {it:SP.DYN.LE00.FE.IN}   Life expectancy at birth, female (years)
              {cmd:CAB}       {it:BN.CAB.XOKA.GD.ZS}   Current account balance (% of GDP)
              {cmd:FDI}       {it:BX.KLT.DINV.CD.WD}   Foreign direct investment, net inflows (BoP, 
					     current US$)
              {cmd:GDP2}      {it:NY.GDP.PCAP.KD}      GDP per capita (constant 2000 US$)
              {cmd:INF}       {it:FP.CPI.TOTL.ZG}      Inflation, consumer prices (annual %)
              {cmd:ODA}       {it:DT.ODA.ODAT.PC.ZS}   Net ODA received per capita (current US$) 
              {cmd:HIV}       {it:SH.DYN.AIDS.ZS}      Prevalence of HIV, total (% of population ages 
					     15-49)   
              {cmd:ENER}       {it:EG.GDP.PUSE.KO.PP}  GDP per unit of energy use (PPP $) 	  
              {cmd:SLR}        {it:IC.LGL.CRED.XQ}     Strength of legal rights index (0=weak to 
				             10=strong)
              {cmd:AGE}        {it:SP.POP.DPND.YG}     Age dependency ratio, young (% of working age 
				             population)
              {cmd:BIRTH}      {it:SP.DYN.CBRT.IN}     Birth rate, crude (per 1,000 people)
              {cmd:FERT}       {it:SP.DYN.TFRT.IN}     Fertility rate, total (births per woman)			  
              {cmd:IMM}        {it:SH.IMM.IDPT}        Immunization DPT, (% children aged 12-23 months)			  
           {hline 80}
			note:

{pmore}


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Visualise GDP per capita in African countries {p_end}

{phang2}{cmd:. worldstat Africa, stat(GDP)}{p_end}

    {hline}


{title:References}

    {p 4 4 2} Azevedo, J.P. (2011) "wbopendata: Stata module to access World Bank databases," Statistical Software Components S457234, Boston College Department of 
Economics.{browse "http://ideas.repec.org/c/boc/bocode/s457234.html"}{p_end} 

{title:Acknowledgements}

    {p 4 4 2} I thank J.P. Azevedo and the LAC Team for Statistical Development, from the 
    Latin American and Caribbean Poverty Reduction and Economic Managment Group from the World Bank,
	who developed the {helpb wbopendata} module which allows simple access to The World Bank's data
	from Stata.  I also acknowledge Maurizio Pisati who developed the {helpb spmap} module for
	the visualisation of spatial data.  I thank the Comision Nacional de Investigacion Cientifica
	y Tecnologica of the Government of Chile who supported my research during the writing of this
	program. 


{title:Also see}

{psee}
Online:  {manhelp graph D}, {manhelp wbopendata D}, {manhelp spmap D},


{title:Author}

{pstd}
Damian C. Clarke, The University of Oxford. {browse "mailto:damian.clarke@economics.ox.ac.uk"}
{p_end}


