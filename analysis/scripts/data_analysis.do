
* Covid policies blog analysis
* JP Chauvin
* April 20, 2020

***************


cd "/nfs/home/J/jchauvin/shared_space/data_urb/covid_projects/policies_blog/"

use "pol_countries_stages", clear


merge m:1 ccode using "countries_names.dta"
drop if _merge==2
drop _merge

set scheme cleanplots
* plottigblind  plotplainblind cleanplots burd
drop if pop==. | gdp==.
drop if pop<250000

replace name="Bolivia" if ccode=="BOL"

g polgen = ""
g polext = ""
g polextgen = ""
replace polgen ="School closing" if polgensch_close ==1
replace polext = "School closing" if polextsch_close ==1
replace polextgen = "School closing" if polextgensch_close ==1
replace polgen ="Workplace closing" if polgenwrk_close ==1
replace polext = "Workplace closing" if polextwrk_close ==1
replace polextgen = "Workplace closing" if polextgenwrk_close ==1
replace polgen ="Cancel public events" if polgenpub_close ==1
replace polext = "Cancel public events" if polextpub_close ==1
replace polextgen = "Cancel public events" if polextgenpub_close ==1
replace polgen ="Cancel public transport" if polgentsp_close ==1
replace polext = "Cancel public transport" if polexttsp_close ==1
replace polextgen = "Cancel public transport" if polextgentsp_close ==1
replace polgen ="Public info campaigns" if polgenpub_info ==1
replace polext = "Public info campaigns" if polextpub_info ==1
replace polextgen = "Public info campaigns" if polextgenpub_info ==1
replace polgen ="Restrictions on internal movement" if polgenmov_rst ==1
replace polext = "Restrictions on internal movement" if polextmov_rst ==1
replace polextgen = "Restrictions on internal movement" if polextgenmov_rst ==1
replace polgen ="International travel controls" if polgenint_rst ==1
replace polext = "International travel controls" if polextint_rst ==1
replace polextgen = "International travel controls" if polextgenint_rst ==1
replace polgen ="Fiscal stimuli" if polgenfiscal ==1
replace polext = "Fiscal stimuli" if polextfiscal ==1
replace polextgen = "Fiscal stimuli" if polextgenfiscal ==1
replace polgen ="Emergency health investment" if polgenhealth ==1
replace polext = "Emergency health investment" if polexthealth ==1
replace polextgen = "Emergency health investment" if polextgenhealth ==1
replace polgen ="Vaccine development investment" if polgenvacc ==1
replace polext = "Vaccine development investment" if polextvacc ==1
replace polextgen = "Vaccine development investment" if polextgenvacc ==1
replace polgen ="Testing policy" if polexttest ==1
replace polext = "Testing policy" if polexttest ==1
replace polextgen = "Testing policy" if polextgentest ==1
replace polgen ="Contact tracing" if polexttracing ==1
replace polext = "Contact tracing" if polexttracing ==1
replace polextgen = "Contact tracing" if polextgentracing ==1

foreach var in  polgen polext polextgen {
	encode `var', gen(`var'_num)
}


levelsof polgen 

* Note that for testing and tracing I am taking only the strict policies in place

lab var polgen "Policy applied with any intensity and scope"
lab var polext "Policy strictly applied"
lab var polextgen "Policy strictly applied to general public"

/* Preparing variables */

bysort stage: egen a_duration=mean(stage_duration)
	lab var a_duration "Mean duration of stage across countries"
	
gen a_duration_lac = a_duration if subregioncode==419
	lab var a_duration_lac "Mean duration of stage in LAC"

gen a_duration_nlac = a_duration if subregioncode!=419
	lab var a_duration_nlac "Mean duration of stage outside LAC"

/* Summary statistics */

foreach st in A B C D E {
	sum stage_duration if stage=="`st'"
	sum stage_duration if stage=="`st'" & subregioncode==419
	g stage_dur_`st' = .
	replace stage_dur_`st' = stage_duration if stage=="`st'"
	sort ccode stage_dur_`st'
	replace stage_dur_`st'=stage_dur_`st'[_n-1] if stage_dur_`st'==. & ccode==ccode[_n-1]
}




/* Where countries are */


#delimit ;
local today: di "`c(current_date)'";
graph bar (count) a_duration_lac a_duration_nlac if stage==stage_current, 
	over(stage_current) stack 
	legend(label(1 "Latin-America and Caribbean") label(2 "Rest of the world"))
	title("What stage of infection are countries in today (`today')?")
	note("Note: Sample restricted to 162 countries with population 250k or larger.");
graph export "figures/countries_today_`c(current_date)'", as(png) replace;	
	

#delimit ;
local today: di "`c(current_date)'";
graph hbar (sum) stage_dur_A stage_dur_B stage_dur_C stage_dur_D stage_dur_E 
	if stage==stage_current & subregioncode==419, over(name) stack
	legend(label(1 "A") label(2 "B") label(3 "C") label(4 "D") label(5 "E") r(1)) bar(3, color(green))
	xsize(10) ysize(16)
	title("Duration of COVID-19 infection stages in LAC", span size(medlarge))
	note("Note: All countries are assumed to start stage A in 31 Dec 2019." "Last day registered is `today'.", span);
graph export "figures/lac_stage_duration_`c(current_date)'", as(png) replace;
	

	
#delimit ;

use "pol_countries_stages_policies", clear;


merge m:1 ccode using current_stage.dta;
drop _merge;

bysort ccode: egen aux=seq();
sum pol_none if aux==1;
local tot_cty = r(N); dis "Total countries are `tot_cty'";

g stage_pol_base_sh = (stage_pol_base_count / `tot_cty')*100;
g stage_pol_int_sh = (stage_pol_int_count / `tot_cty')*100;
g stage_pol_none_sh = 100 - stage_pol_base_sh - stage_pol_int_sh;


lab var stage_pol_none_sh "Not implemented";
lab var stage_pol_base_sh "Implemented moderately";
lab var stage_pol_int_sh "Implemented intensively";

#delimit ;
local today: di "`c(current_date)'";
foreach st in A B C D E {;
	qui sum pol_none if stage_current=="`st'" & aux==1;
	local in_`st' = r(N); };
	
tabplot policy stage [fw=polgen] if stage==stage_current, horizontal scale(*.65)
	title("What policies are more frequent at each stage?",  size(medlarge)) subtitle("")
	xsize(12) ysize(16) 
	note("Note: The plot considers all policies implemented between 31 Dec 2019 and `today'." "The current number of countries by stage are: A=`in_A', B=`in_B', C=`in_C', D=`in_D', and E=`in_D'.", span);
graph export "figures/policies_by_stage_`c(current_date)'", as(png) replace;

	
	/*
	


bysort subregion stage: egen a_duration_sub=mean(stage_duration)
	lab var a_duration_sub "Mean duration of stage across countries by subregion"
	
	graph bar a_duration a_duration_sub if subregioncode==419, over(stage)
	graph bar a_duration a_duration_sub if subregioncode==419 & stage_current=="C", over(stage)

	
	
	
	
	
	
graph bar polgensch_close polextsch_close  , over(stage)





polgenint_rst	polgensch_close polgenwrk_close polgenpub_close polgentsp_close polgenpub_info polgenmov_rst polgenfiscal polgenhealth polgenvacc polgentest polgentracing stringency stringency fiscal health vacc
	
