/***********************************************************************
 * Government Policies along the COVID infection wave
 * Juan Pablo Chauvin

 * Purpose: Computing country-stage figures
 * Created by: Juan Pablo Chauvin
 * Created on: 04/21/2020
 * Last modified on: 02/21/2020
 * Last modified by: JPCR
 * Edits history:

  **************************************************************************/
#delimit ;
use "$db_out/pol_countries_stages_policies", clear;

/*************************************************/
 /* Homecleaning                    */
 /*************************************************/

  set scheme burd;
 * plottigblind  plotplainblind cleanplots burd;

/* Bring in current stage */
merge m:1 ccode using $db_out/current_stage.dta;
drop if _merge==2;
drop _merge;

/* Local for total countries */
bysort ccode: egen aux=seq();
sum pol_none if aux==1;
local tot_cty = r(N); dis "Total countries are `tot_cty'";

/* Local for unique policy-stage observation */
bysort stage policy: egen aux2=seq();

/* Loop to obtain number of countries in each stage currently */
#delimit ;
/* Shares of countries in different policy response groups */
g stage_pol_base_sh = .;
g stage_pol_int_sh =.;
local today: di "`c(current_date)'";
foreach st in E D C B A {;
	qui sum policy_cat if stage_current=="`st'" & aux==1;
	global in_`st' = `r(N)'; };

dis "in E is $in_E";
replace stage_pol_base_sh = (stage_pol_base_count / ${in_E})*100 if stage=="E" ;
replace stage_pol_base_sh = (stage_pol_base_count / (${in_E}+${in_D}))*100 if stage=="D" ;
replace stage_pol_base_sh = (stage_pol_base_count / (${in_E}+${in_D}+${in_C}))*100 if stage=="C" ;
replace stage_pol_base_sh = (stage_pol_base_count / (${in_E}+${in_D}+${in_C}+ ${in_B}))*100 if stage=="B" ;
replace stage_pol_base_sh = (stage_pol_base_count / (${in_E}+${in_D}+${in_C}+ ${in_B}+${in_A}))*100 if stage=="A"  ;

replace stage_pol_int_sh = (stage_pol_int_count / ${in_E})*100 if stage=="E";
replace stage_pol_int_sh = (stage_pol_int_count / (${in_E}+${in_D}))*100 if  stage=="D" ;
replace stage_pol_int_sh = (stage_pol_int_count / (${in_E}+${in_D}+${in_C}))*100 if  stage=="C" ;
replace stage_pol_int_sh = (stage_pol_int_count / (${in_E}+${in_D}+${in_C}+ ${in_B}))*100 if  stage=="B" ;
replace stage_pol_int_sh = (stage_pol_int_count / (${in_E}+${in_D}+${in_C}+ ${in_B}+${in_A}))*100 if stage=="A" ;

g stage_pol_none_sh = 100 - stage_pol_base_sh - stage_pol_int_sh;
lab var stage_pol_none_sh "None";
lab var stage_pol_base_sh "Moderate";
lab var stage_pol_int_sh "Large / Stringent";

/*************************************************/
 /* What policies are more frequent at each stage?  */
 /*************************************************/

/* General version */
 #delimit ;
tabplot policy stage [fw=polgen] if stage==stage_current, horizontal scale(*.65)
	title("What policies are more frequent at each stage?",  size(medlarge)) subtitle("")
	xsize(12) ysize(16)
	note("Note: The plot considers all policies implemented between 31 Dec 2019 and `today'." "The current number of countries by stage are: A=${in_A}, B=${in_B}, C=${in_C}, D=${in_D}, and E=${in_E}.", span);
graph export "$da_grs/policies_by_stage_`c(current_date)'.png", as(png) replace;

/* Paper version */
#delimit ;
tabplot policy stage [fw=polgen] if stage==stage_current, horizontal scale(*.65)
	xsize(12) ysize(16) subtitle("") note("");
graph export "$dd_fig/policies_by_stage.png", as(png) replace;


/*************************************************/
 /* How the specific policies change along stages */
 /*************************************************/

 #delimit ;

 /* Individual policy graphs */
 forval j = 1/2 {;
	  local i: value label policy;
	  local tit: label `i' `j';
	  dis "tit is `tit'";
	  qui graph bar stage_pol_none_sh stage_pol_base_sh stage_pol_int_sh  if policy==`j' & aux2==1, over(stage) stack
	  title("`tit'",  size(med) span)
	  legend(label(1 "None") label(2 "Moderate") label(3 "Large / stringent") r(1));
	  qui graph save $da_tmp/p`j', replace;
	  qui graph export "$da_grs/p`j'.png", as(png) replace;};


  /* Policy categories graphs */

  /* Mobility restriction policies, general version */
  qui grc1leg $da_tmp/p3.gph $da_tmp/p10.gph, iscale(1) graphr(margin(zero))  xsize(14) ysize(8)
  title("Share of countries that implemented mobility restriction policies",  size(medlarge)) 
  note("Note: The plot considers all policies implemented between 31 Dec 2019 and `today'." "Shares are calculated over the total number of countries that are in or have passed through the corresponding" "stage. At the time of analysis, the corresponding numbers are: A=${in_A}, B=${in_B}, C=${in_C}, D=${in_D}, and E=${in_E}.", span);
  graph export "$da_grs/polcat1_by_stage_`c(current_date)'.png", as(png) replace;
  /* Mobility restriction policies, paper version */
  qui grc1leg $da_tmp/p3.gph $da_tmp/p10.gph, iscale(1) graphr(margin(zero))
  title("Mobility restriction policies",  size(large));
  graph export "$dd_fig/polcat1_by_stage.png", as(png) replace;
#delimit ;
  /* Social distancing policies, general version */
  qui grc1leg $da_tmp/p7.gph $da_tmp/p12.gph $da_tmp/p5.gph $da_tmp/p4.gph, iscale(1) graphr(margin(zero))
  title("Share of countries that implemented social distancing policies",  size(large)) xsize(14) ysize(10)
  note("Note: The plot considers all policies implemented between 31 Dec 2019 and `today'." "Shares are calculated over the total number of countries that are of have passed through the corresponding stage." "At the time of analysis, the corresponding numbers are: A=${in_A}, B=${in_B}, C=${in_C}, D=${in_D}, and E=${in_E}.", span);
  graph export "$da_grs/polcat2_by_stage_`c(current_date)'.png", as(png) replace;
  /* Social distancing policies, paper version */
  qui grc1leg $da_tmp/p7.gph $da_tmp/p12.gph $da_tmp/p5.gph $da_tmp/p4.gph, iscale(1) graphr(margin(zero))
  title("Social distancing policies",  size(large));
  graph export "$dd_fig/polcat2_by_stage.png", as(png) replace;

  #delimit ;
  /* Emergency investments, general version */
  qui grc1leg $da_tmp/p2.gph $da_tmp/p11.gph $da_tmp/p1.gph, iscale(1) graphr(margin(zero))
  title("Share of countries that implemented emergency investments",  size(large))
  note("Note: The plot considers all policies implemented between 31 Dec 2019 and `today'." "Shares are calculated over the total number of countries that are of have passed through the corresponding stage." "At the time of analysis, the corresponding numbers are: A=${in_A}, B=${in_B}, C=${in_C}, D=${in_D}, and E=${in_E}.", span);
  graph export "$da_grs/polcat3_by_stage_`c(current_date)'.png", as(png) replace;
  /* Emergency investments, paper version */
  qui grc1leg $da_tmp/p2.gph $da_tmp/p11.gph $da_tmp/p1.gph, iscale(1) graphr(margin(zero))
  title("Emergency investments",  size(large));
  graph export "$dd_fig/polcat3_by_stage.png", as(png) replace;
#delimit ;
  /* Information-related policies, general version */
  qui grc1leg $da_tmp/p8.gph $da_tmp/p9.gph $da_tmp/p6.gph, iscale(1) graphr(margin(zero))
  title("Share of countries that implemented information-related policies",  size(large))
  note("Note: The plot considers all policies implemented between 31 Dec 2019 and `today'." "Shares are calculated over the total number of countries that are of have passed through the corresponding stage." "At the time of analysis, the corresponding numbers are: A=${in_A}, B=${in_B}, C=${in_C}, D=${in_D}, and E=${in_E}.", span);
  graph export "$da_grs/polcat4_by_stage_`c(current_date)'.png", as(png) replace;
  /* Information-related policies, paper version */
  qui grc1leg $da_tmp/p8.gph $da_tmp/p9.gph $da_tmp/p6.gph, iscale(1) graphr(margin(zero))
  title("Information-related policies",  size(large));
  graph export "$dd_fig/polcat4_by_stage.png", as(png) replace;


/* End of do file */
