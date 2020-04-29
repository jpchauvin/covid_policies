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

 /* Prepare country-stage data for analysis */
 do "$da_scr/analysis_preparation_country_policy_stage.do";

/*************************************************/
 /* What policies are more frequent at each stage?  */
 /*************************************************/

/* General version */
 #delimit ;
tabplot policy stage [fw=polgen] if stage==stage_current, horizontal scale(*.65)
	title("What policies are more frequent at each stage?",  size(medlarge)) subtitle("")
	xsize(11) ysize(16)
	note("Note: The plot considers all policies implemented between 31 Dec 2019 and `today'." "The current number of countries by stage are: A=${in_A}, B=${in_B}, C=${in_C}, D=${in_D}, and E=${in_E}.", span);
graph export "$da_grs/policies_by_stage_`c(current_date)'.png", as(png) replace;

/* Paper version */
#delimit ;
tabplot policy stage [fw=polgen] if stage==stage_current, horizontal scale(*.65)
	xsize(11) ysize(16) subtitle("") note("");
graph export "$dd_fig/policies_by_stage.png", as(png) replace;

/*************************************************/
 /* 3 Most frequent policies                    */
 /*************************************************/

#delimit ;
local today: di "`c(current_date)'";
 preserve;
 keep stage policy stage_polgen_count stage_pol_rank; duplicates drop;
 keep if stage_pol_rank<4; drop stage_pol_rank;
 reshape wide stage_polgen_count, i(stage) j(policy);

	 /* Blog version */
	   #delimit ;
	local today: di "`c(current_date)'";
	graph bar stage_polgen_count6 stage_polgen_count3 stage_polgen_count4  stage_polgen_count5  stage_polgen_count7  stage_polgen_count9 ,
 	over(stage, sort(#))  xsize(11) ysize(8) nofill
 	legend(label(1 "Public info campaigns") label(2 "International travel restrictions") label(3 "Internal movement restrictions") label(4 "Cancel public events") label(5 "School closing") label(6 "Contact tracing")r(3) )
 	title("Figure 6. What are the most used policies at each stage?", size(medlarge) span)
	note("Note: Sample restricted to 134 countries with population 250k or larger. Only policies ranked first through" "third within each stage are shown. Data from: The Oxford COVID-19 Government Response Tracker" "(bsg.ox.ac.uk/covidtracker). Last updated on April 24, 2020.");
	  graph export "$dd_blog/top_policies_by_stage.png", as(png) replace;

	/* Paper version */
	 #delimit ;
	local today: di "`c(current_date)'";
	graph bar stage_polgen_count6 stage_polgen_count3 stage_polgen_count4  stage_polgen_count5  stage_polgen_count7  stage_polgen_count9 ,
 	over(stage, sort(#))  xsize(11) ysize(8) nofill
 	legend(label(1 "Public info campaigns") label(2 "International travel restrictions") label(3 "Internal movement restrictions") label(4 "Cancel public events") label(5 "School closing") label(6 "Contact tracing")r(3) );
	 graph export "$dd_fig/top_policies_by_stage.png", as(png) replace;
   restore;

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
