* Covid policies blog analysis
* JP Chauvin
* April 17, 2020

***************


* Import CSV files into Stata

cd "/nfs/home/J/jchauvin/shared_space/data_urb/covid_projects/policies_blog/"

/*
insheet using "WDI_2018_pop_gdp.csv", comma clear

drop if ccode==""
drop cty_name

save "WDI_2018_pop_gdp", replace

insheet using "countries_regions.csv", comma clear
keep ccode region subregion regioncode subregioncode
drop if region==""

save "countries_regions", replace


insheet using "countries_regions.csv", comma clear
keep ccode name
drop if name==""

save "countries_names", replace

insheet using "/nfs/home/J/jchauvin/Desktop/shared_space/data_urb/covid_projects/policies_blog/new-covid-deaths-per-million.csv", comma clear


/* Homecleaning */
rename date date2
gen date=date(date2, "MDY")
format date %td
drop entity
rename daily deaths_new_1M
label var deaths_new_1M "Daily new confirmed deaths per million"
rename code ccode
drop date2
drop if ccode==""
order ccode date
encode ccode, gen(country)

/* Stages */
tsset country date
tsfill,full
replace deaths = 0 if deaths==.  //may be very consequential but keep it for now

by country: g cum_deaths = sum(deaths_new_1M)
lab var cum_deaths "Cumulative deaths per 1 million population"

decode country, g(ccode2)
replace ccode=ccode2
drop ccode2 country

save "covid_deaths", replace


*/

insheet using "OxCGRT.csv", comma clear

/* Homecleaning */

drop v40
rename date date2
tostring date2, replace
gen date=date(date2, "YMD")
format date %td
drop date2
drop *_notes countryname
rename countrycode ccode
order ccode date 


/* Generating relative variables */


merge m:1 ccode using WDI_2018_pop_gdp.dta
drop _merge

merge m:1 ccode using countries_regions.dta, keepusing(regioncode subregioncode)
drop _merge
sort ccode
by ccode: egen unique_country = seq()


g fiscal = (s8_fiscalmeasures / gdp)*100
lab var fiscal "Fiscal measures as percentage of 2018 GDP"

g health = (s10_emergencyinvestmentinhealthc / gdp)*100
lab var health "Emergency health investments as percentage of 2018 GDP"

g vacc = (s11_investmentinvaccines / gdp)*100
lab var vacc "Investment in vaccines as percentage of 2018 GDP"

foreach i in fiscal health vacc {
	sum `i' if unique_country==1 & `i'>0 & `i'!=., d
	g `i'_ext = (`i'>r(p50) & `i'!=.)
	}

lab var fiscal_ext "Fiscal measures above the median"
lab var health_ext "Emergency health investments above the median"
lab var vacc_ext "Investment in vaccines above the median"


/* Generating computation variables */

g polgensch_close = (s1_s==1 | s1_s==2)
g polextsch_close = (s1_s==2)
g polextgensch_close = (s1_s==2 | s1_i==1)
g polgenwrk_close = (s2_w==1 | s2_w==2)
g polextwrk_close = (s2_w==2)
g polextgenwrk_close = (s2_w==2 | s2_i==1)
g polgenpub_close = (s3_c==1 | s3_c==2)
g polextpub_close = (s3_c==2)
g polextgenpub_close = (s3_c==2 | s3_i==1)
g polgentsp_close = (s4_c==1 | s4_c==2)
g polexttsp_close = (s4_c==2)
g polextgentsp_close = (s4_c==2 | s4_i==1)
g polgenpub_info = (s5_p==1)
g polextpub_info = (s5_p==1)
g polextgenpub_info = (s5_p==1 | s5_i==1)
g polgenmov_rst = (s6_r==1 | s6_r==2)
g polextmov_rst = (s6_r==2)
g polextgenmov_rst = (s6_r==2 | s6_i==1)
g polgenint_rst = (s7==1 | s7==2 | s7==3)
g polextint_rst = (s7==3)
g polextgenint_rst = (s7==3)
g polgenfiscal = (s8>0 & s8!=.)
g polextfiscal = (fiscal_ext==1)
g polextgenfiscal = (fiscal_ext==1)
g polgenhealth = (s10>0 & s10!=.)
g polexthealth = (health_ext==1)
g polextgenhealth = (health_ext==1)
g polgenvacc = (s11>0 & s11!=.)
g polextvacc = (vacc_ext==1)
g polextgenvacc = (vacc_ext==1)
g polgentest = (s12==1 | s12==2 | s12==3)
g polexttest = (s12==3)
g polextgentest = (s12==3)
g polgentracing = (s13==1 | s13==2)
g polexttracing = (s13==2)
g polextgentracing = (s13==2)

lab var polgensch_close "School closing"
lab var polextsch_close "School closing, required"
lab var polextgensch_close "School closing, required for all"
lab var polgenwrk_close "Workplace closing"
lab var polextwrk_close "Workplace closing, required"
lab var polextgenwrk_close "Workplace closing, required for all"
lab var polgenpub_close "Cancel public events"
lab var polextpub_close "Cancel public events, required"
lab var polextgenpub_close "Cancel public events, required for all"
lab var polgentsp_close "Cancel public transport"
lab var polexttsp_close "Cancel public transport, required"
lab var polextgentsp_close "Cancel public transport, required for all"
lab var polgenpub_info "Public info campaigns"
lab var polextpub_info "Public info campaigns"
lab var polextgenpub_info "Public info campaigns, directed at all"
lab var polgenmov_rst "Restrictions on internal movement"
lab var polextmov_rst "Restrictions on internal movement, required"
lab var polextgenmov_rst "Restrictions on internal movement, required for all"
lab var polgenint_rst "International travel controls"
lab var polextint_rst "International travel controls, required"
lab var polextgenint_rst "International travel controls, required for all"
lab var polgenfiscal "Fiscal stimuli"
lab var polextfiscal "Fiscal stimuli, above the median"
lab var polextgenfiscal "Fiscal stimuli, above the median"
lab var polgenhealth "Emergency health investment"
lab var polexthealth "Emergency health investment, above the median"
lab var polextgenhealth "Emergency health investment, above the median"
lab var polgenvacc "Vaccine development investment"
lab var polextvacc "Vaccine development investment, above the median"
lab var polextgenvacc "Vaccine development investment, above the median"
lab var polgentest "Testing policy"
lab var polexttest "Testing policy, open public"
lab var polextgentest "Testing policy, open public"
lab var polgentracing "Contact tracing"
lab var polexttracing "Contact tracing, limited"
lab var polextgentracing "Contact tracing, comprehensive"


save "oxford_policies.dta", replace



insheet using "/nfs/home/J/jchauvin/Desktop/shared_space/data_urb/covid_projects/policies_blog/new-covid-cases-per-million.csv", comma clear

/* Homecleaning */
rename date date2
gen date=date(date2, "MDY")
format date %td
drop entity
rename daily cases_new_1M
label var cases_new_1M "Daily new confirmed cases per million"
rename code ccode
drop date2
drop if ccode==""
order ccode date

encode ccode, gen(country)

/* Stages */
tsset country date

tsfill,full

replace cases = 0 if cases==.  //may be very consequential but keep it for now


* Is it at least one per million?

g high = 0
replace high = 1 if cases >=1
lab var high "Daily new cases above 1 per 1 million people"

/* Growth variables */
sort country date
tssmooth ma l5_cases = cases_new_1M , window (4 1 0)
lab var l5_cases "Five-days rolling average of daily cases"

g day_increase=l5_cases-l5_cases[_n-1] if country==country[_n-1]
lab var day_increase "Current rolling average minus yesterday's rolling average"

*g decrease_span = 0
*replace decrease_span = decrease_span[_n-1]+1 if country==country[_n-1] & day_increase<0  

*g increase_span = 0
*replace increase_span = increase_span[_n-1]+1 if country==country[_n-1] & day_increase>=0


tssmooth ma ra_increase = day_increase if country==country[_n-1], window (4 1 0)
lab var ra_increase "Five-days rolling average of daily increases"

g increasing = 0
replace increasing = 1 if ra_increase>=0 & country==country[_n-1]
lab var increasing "Number of cases is not decreasing"

g decreasing = 0
replace decreasing = 1 if ra_increase<0 & country==country[_n-1]
lab var decreasing "Number of cases is decreasing"

by country: g cum_case = sum(cases_new_1M)

g stage = ""

#delimit ;

levelsof country, local(cty);

foreach i of local cty {;

qui replace stage="A" if cum_case==0 & country ==`i';

qui replace stage="B" if 
	cum_case>0 
	& (high==0 
	| (high==1 & high[_n-1==0] & high[_n+1]==0)
	| (high==1 & high[_n-2==0] & high[_n+2]==0)
	| (high==1 & high[_n-2==3] & high[_n+3]==0))	
	& (  ((stage[_n-1]=="A" | stage[_n-1]=="B") & high==0)
	  | ((stage[_n-2]=="A" | stage[_n-2]=="B") & high==0)
	  | ((stage[_n-3]=="A" | stage[_n-3]=="B") & high==0)
	  | date==21914)  
	& stage==""
	& country ==`i';
	
* Filling in;
qui replace stage="B" if stage=="" 
	& ((stage[_n-1]=="B" & stage [_n+1]=="B")
	| (stage[_n-2]=="B" & stage [_n+2]=="B"));

* Note that I have allowed for bridges between three missing dates.;

qui replace stage="C" if 
	 (high==1 
	| (high==0 & high[_n-1==1] & high[_n+1]==1)
	| (high==0 & high[_n-2==1] & high[_n+2]==1)
	| (high==0 & high[_n-3==1] & high[_n+3]==1))	   
	& (increasing==1 | (increasing==0 & decreasing==0) 
		| (increasing[_n-1]==1 & increasing[_n+1]==1) 
		| (increasing[_n-2]==1 & increasing[_n+2]==1)
		| (increasing[_n-3]==1 & increasing[_n+3]==1)) 
	& stage==""
	& country ==`i';
	
* Filling in;
qui replace stage="C" if stage=="" 
	& ((stage[_n-1]=="C" & stage [_n+1]=="C")
	| (stage[_n-2]=="C" & stage [_n+2]=="C"));

qui replace stage="D" if 
	 (high==1 
	| (high==0 & high[_n-1==1] & high[_n+1]==1)
	| (high==0 & high[_n-2==1] & high[_n+2]==1)
	| (high==0 & high[_n-3==1] & high[_n+3]==1)
	| (high==0 & stage[_n-1]=="C"))
	& (stage[_n-1]=="C" | stage[_n-1]=="D")
	& (decreasing==1 | (decreasing[_n-1]==1 & decreasing[_n+1]==1) 
	| (decreasing[_n-2]==1 & decreasing[_n+2]==1)
	| (decreasing[_n-3]==1 & decreasing[_n+3]==1)) 
	& stage==""
	& country ==`i';

	* Filling in;
qui replace stage="D" if stage=="" 
	& ((stage[_n-1]=="D" & stage [_n+1]=="D")
	| (stage[_n-2]=="D" & stage [_n+2]=="D"));
	


* Note that I introduce "bridges" for when one "sandwich" day does not meet the stage's criteria;
qui replace stage="E" if 
	(high==0 
	| (high==1 & high[_n-1==0] & high[_n+1]==0)
	| (high==1 & high[_n-2==0] & high[_n+2]==0))
	& (stage[_n-1]=="D" | stage[_n-1]=="E") 
	& stage==""
	& country ==`i';
	
	* Filling in;
qui replace stage="E" if stage=="" 
	& ((stage[_n-1]=="E" & stage [_n+1]=="E")
	| (stage[_n-2]=="E" & stage [_n+2]=="E"));


* Correct for false Ds;
if stage=="" & stage[_n-1]=="D" & increasing==1 & increasing[_n+1]==1 & high==1 {;
	qui replace stage="C";
	local j = 1;
	while stage[_n-`j']=="D" {;
		replace stage[_n-`j']="C";
		local i = `i'+1;};};
	
	
	};

decode country, g(ccode2);
replace ccode=ccode2;

	merge 1:1 ccode date using "oxford_policies.dta";


* Smooth temporary transitions to a different stage;
sort country stage date;
by country stage: egen firstdate = min(date) if stage!="";
by country stage: egen lastdate = max(date) if stage!="" ;
sort country date ;
	
foreach i in A B C D E {;
	foreach k in firstdate lastdate {;
	g `k'_`i'= `k' if stage=="`i'";
	replace `k'_`i' = `k'_`i'[_n-1] if country==country[_n-1] & missing(`k'_`i');};
	
	replace stage ="`i'" if date >= firstdate_`i' & date<=lastdate_`i' & stage!="`i'" ;
};

/* Fill in empty observations at transition points */
#delimit ;

	replace stage = "B" if stage[_n-1]=="B" & stage[_n+1]=="C" & high==0 & stage=="";
	replace stage = "C" if stage[_n-1]=="B" & stage[_n+1]=="C" & high==1 & stage=="";
	replace stage = "C" if stage[_n-1]=="C" & stage[_n+1]=="D" & increasing==1 & stage=="";
	replace stage = "D" if stage[_n-1]=="C" & stage[_n+1]=="D" & decreasing==1 & stage=="";
	replace stage = "D" if stage[_n-1]=="D" & stage[_n+1]=="E" & high==1 & stage=="";
	replace stage = "E" if stage[_n-1]=="D" & stage[_n+1]=="E" & high==0 & stage=="";

#delimit cr
drop _merge
merge 1:1 ccode date using  covid_deaths.dta
drop if _merge==2
drop _merge

/* Stage durations */
sort country stage 
by country stage: egen stage_duration = count(date)
lab var stage_duration "Duration of stage (in days)"

/* Additional labels */
lab var stage "Stage of Covid wave"
tab  stage, gen(s_)
rename s_1 stage_A
rename s_2 stage_B
rename s_3 stage_C
rename s_4 stage_D
rename s_5 stage_E
lab var stage_A "Stage A: No detected cases"
lab var stage_B "Stage B: Outbreak"
lab var stage_C "Stage C: Community spread accelerating"
lab var stage_D "Stage D: Community spread decelerating"
lab var stage_E "Stage E: Wave aftermath"


sort country date


drop if cum_case==.



save "policies_int_working_dataset.dta", replace

sort ccode
by ccode: egen lastdate2 = max(date) if stage!="" 
keep if date==lastdate2
g stage_current = stage 
g cum_cases_current = cum_case
g cum_deaths_current = cum_deaths
g days_current = stage_duration

lab var stage_current "Current stage"
lab var cum_cases_current "Current cumulative cases"
lab var cum_deaths_current "Current cumulative deaths"
lab var days_current "Number of days in current stage"

keep ccode stage_current cum_cases_current cum_deaths_current

save "current_stage.dta", replace


/* Collapses */


use "policies_int_working_dataset.dta", clear

/* Drop small countries and countries without data */
drop if pop==. | gdp==.
drop if pop<250000
drop if s1_s==. & s2_w==. & s3_c==. & s4_c==. & s5_p==. & s6_r==. & s7==. & s8==. & s9==. & s10==. & s11==. & s12==. & s13==. 

#delimit ;
drop if stage=="";
/* Countries */

collapse (sum) fiscal health vacc 
(mean) stringency=stringencyindexfordisplay
(max)
fiscal_ext health_ext vacc_ext 
polgensch_close polextsch_close polextgensch_close 
polgenwrk_close polextwrk_close polextgenwrk_close 
polgenpub_close polextpub_close polextgenpub_close 
polgentsp_close polexttsp_close polextgentsp_close 
polgenpub_info polextpub_info polextgenpub_info 
polgenmov_rst polextmov_rst polextgenmov_rst 
polgenint_rst polextint_rst polextgenint_rst 
polgenfiscal polextfiscal polextgenfiscal 
polgenhealth polexthealth polextgenhealth 
polgenvacc polextvacc polextgenvacc
polgentest polexttest polextgentest 
polgentracing polexttracing polextgentracing
, by (ccode);

merge 1:1 ccode using current_stage.dta;
drop _merge;
save "pol_countries", replace;

#delimit ;

use "policies_int_working_dataset.dta", clear;
drop if stage=="";
/* Drop small countries and countries without data */;
drop if pop==. | gdp==.;
drop if pop<250000;
drop if s1_s==. & s2_w==. & s3_c==. & s4_c==. & s5_p==. & s6_r==. & s7==. & s8==. & s9==. & s10==. & s11==. & s12==. & s13==. ;


collapse (sum) fiscal health vacc 
(mean) stage_duration stringency=stringencyindexfordisplay
(max)
fiscal_ext health_ext vacc_ext 
polgensch_close polextsch_close polextgensch_close 
polgenwrk_close polextwrk_close polextgenwrk_close 
polgenpub_close polextpub_close polextgenpub_close 
polgentsp_close polexttsp_close polextgentsp_close 
polgenpub_info polextpub_info polextgenpub_info 
polgenmov_rst polextmov_rst polextgenmov_rst 
polgenint_rst polextint_rst polextgenint_rst 
polgenfiscal polextfiscal polextgenfiscal 
polgenhealth polexthealth polextgenhealth 
polgenvacc polextvacc polextgenvacc
polgentest polexttest polextgentest 
polgentracing polexttracing polextgentracing
cum_case cum_deaths
, by (ccode stage);

merge m:1 ccode using current_stage.dta;
drop _merge;

#delimit cr


merge m:1 ccode using WDI_2018_pop_gdp.dta
drop if _merge==2
drop _merge

merge m:1 ccode using countries_regions.dta
drop if _merge==2
drop _merge

drop if stage==""

g l_pop = ln(pop)
 lab var l_pop "Log of Population"
 lab var pop "Population" 
g gdppc = gdp/pop
 lab var gdppc "GDP per capita"
 lab var gdp "GDP"

g l_gdppc = ln(gdppc)
 lab var l_gdppc "Log of GDP per capita"
 
lab var polgensch_close "School closing"
lab var polextsch_close "School closing, required"
lab var polextgensch_close "School closing, required for all"
lab var polgenwrk_close "Workplace closing"
lab var polextwrk_close "Workplace closing, required"
lab var polextgenwrk_close "Workplace closing, required for all"
lab var polgenpub_close "Cancel public events"
lab var polextpub_close "Cancel public events, required"
lab var polextgenpub_close "Cancel public events, required for all"
lab var polgentsp_close "Cancel public transport"
lab var polexttsp_close "Cancel public transport, required"
lab var polextgentsp_close "Cancel public transport, required for all"
lab var polgenpub_info "Public info campaigns"
lab var polextpub_info "Public info campaigns"
lab var polextgenpub_info "Public info campaigns, directed at all"
lab var polgenmov_rst "Restrictions on internal movement"
lab var polextmov_rst "Restrictions on internal movement, required"
lab var polextgenmov_rst "Restrictions on internal movement, required for all"
lab var polgenint_rst "International travel controls"
lab var polextint_rst "International travel controls, required"
lab var polextgenint_rst "International travel controls, required for all"
lab var polgenfiscal "Fiscal stimuli"
lab var polextfiscal "Fiscal stimuli, above the median"
lab var polextgenfiscal "Fiscal stimuli, above the median"
lab var polgenhealth "Emergency health investment"
lab var polexthealth "Emergency health investment, above the median"
lab var polextgenhealth "Emergency health investment, above the median"
lab var polgenvacc "Vaccine development investment"
lab var polextvacc "Vaccine development investment, above the median"
lab var polextgenvacc "Vaccine development investment, above the median"
lab var polgentest "Testing policy"
lab var polexttest "Testing policy, open public"
lab var polextgentest "Testing policy, open public"
lab var polgentracing "Contact tracing"
lab var polexttracing "Contact tracing, limited"
lab var polextgentracing "Contact tracing, comprehensive"
lab var region "Region"
lab var fiscal "Fiscal stimulus (% of GDP)"
lab var health "Emergency health investment (% of GDP)" 
lab var vacc "Vaccine development investment (% of GDP)" 
lab var stage_duration "Duration of stage in country" 
lab var stringency "Average Oxford stringency index in stage" 
lab var cum_case "Cumulative confirmed cases in stage"
lab var cum_deaths "Cumulative confirmed deaths in stage"
drop   fiscal_ext health_ext vacc_ext

save "pol_countries_stages", replace


use "pol_countries_stages", clear
keep ccode stage polgen* polext* polextgen*

reshape long polgen polext polextgen, i(ccode stage) j(policy_str) string

g pol_none = 0
replace pol_none = 1 if polgen==0
	
g pol_base = 0
replace pol_base = 1 if polgen==1 & polext==0
	

#delimit ;
collapse (max)
polgen polext polextgen pol_none pol_base
, by (ccode stage policy_str);
sort policy_str;
encode policy_str, gen(policy);

g pol_int = polext ;

g policy_cat = .;
	replace policy_cat = 4 if policy==8 | policy==9 | policy==6;
	replace policy_cat = 1 if policy==2 |  policy==10;
	replace policy_cat=2 if policy==7 |  policy==12 | policy==5  | policy==4;
	replace policy_cat=3 if policy==1 |  policy==2 | policy==11 ;
	
	
	
foreach var in polgen polext polextgen pol_none pol_base pol_int {;
	bysort stage policy: egen  stage_`var'_count=total(`var'); };

#delimit cr
lab var pol_none "Not implemented"
lab var pol_base "Implemented moderately"
lab var pol_int "Implemented intensively"
lab var stage_polgen_count "Countries that have applied the policy"
lab var stage_polext_count "Countries that have applied the policy strictly"
lab var stage_polextgen_count "Countries that have applied the policy strictly for the general public"
lab var stage_pol_none_count "Countries that have not implemented it"
lab var stage_pol_base_count "Countries that have implemented it moderately"
lab var stage_pol_int_count "Countries that have implemented it intensely"	

lab define pol_lab 7 "School closing", replace
lab define pol_lab 12 "Workplace closing", add
lab define pol_lab 5 "Cancel public events", add
lab define pol_lab 10 "Cancel public transport", add
lab define pol_lab 6 "Public info campaigns", add
lab define pol_lab 4 "Restrictions on internal movement", add
lab define pol_lab 3 "International travel controls", add
lab define pol_lab 1 "Fiscal stimulus", add
lab define pol_lab 2 "Emergency health investment", add
lab define pol_lab 11 "Vaccine development investment", add
lab define pol_lab 8 "Testing policy", add
lab define pol_lab 9 "Contact tracing", add
lab val policy pol_lab

lab define polcat_lab 4 "Information", replace
lab define polcat_lab 2 "Social distancing", add
lab define polcat_lab 1 "Mobiliy", add
lab define polcat_lab 3 "Emergency investments", add
lab val policy_cat polcat_lab

lab var policy_cat "Policy category"
lab var policy_str "Policy"
lab var policy "Policy"
lab var polgen "Policy applied with any intensity and scope"
lab var polext "Policy strictly applied"
lab var polextgen "Policy strictly applied to general public"

sort ccode stage policy 
order ccode stage policy
save "pol_countries_stages_policies", replace

*reshape long polgen polext polextgen, i(ccode) j(sch_close)


/*

foreach i in A B C D E {

	sort country stage date
	by country stage: egen firstdate = min(date) if stage!=""
	by country stage: egen lastdate = max(date) if stage!="" 
	sort country date 
	replace stage="`i'" if date>=firstdate & date<=lastdate 
	drop firstdate lastdate
}


* Correct for false Ds;
if stage=="" & stage[_n-1]=="D" & increasing==1 & increasing[_n+1]==1 & high==1 {;
	qui replace stage="C";
	local j = 1;
	while stage[_n-`j']=="D" {;
		replace stage[_n-`j']="C";
		local i = `i'+1;};};
		
/*


