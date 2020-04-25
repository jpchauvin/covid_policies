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

use "$db_out/pol_countries_stages", clear

/*************************************************/
 /* Homecleaning                    */
 /*************************************************/

 set scheme burd
 * plottigblind  plotplainblind cleanplots burd

 /* Prepare country-stage data for analysis */
 do "$da_scr/analysis_preparation_country_stage.do"
 
 /* Local for total countries / stages */
bysort ccode stage: egen aux=seq()
 /* Local for total countries  */
bysort ccode : egen aux2=seq()


 /*************************************************/
  /* Where in the waves are countries now?         */
  /*************************************************/
** FIX THIS -GIVE SYMMETRIC WHEN IT SHOULD NOT
  /* General version, all regions */
 #delimit ;
 local today: di "`c(current_date)'";
 graph bar  a_tot_lac a_tot_usa a_tot_afr a_tot_asi a_tot_eur a_tot_oce if stage==stage_current,
 	over(stage) stack
	 legend(label(1 "LAC") label(2 "USA and Canada") label(3 "Africa") label(4 "Asia") label(5 "Europe") label(6 "Oceania") r(2) )
 	title("What stage of infection are countries in today (`today')?")
 	note("Note: Sample restricted to 162 countries with population 250k or larger.");
 graph export "$da_grs/countries_today_`c(current_date)'.png", as(png) replace;

   /* General version, all regions */
 #delimit ;
 local today: di "`c(current_date)'";
 graph bar  a_tot_lac a_tot_usa a_tot_afr a_tot_asi a_tot_eur a_tot_oce if stage==stage_current,
 	over(stage) stack
	 legend(label(1 "LAC") label(2 "USA and Canada") label(3 "Africa") label(4 "Asia") label(5 "Europe") label(6 "Oceania") r(2) );
 graph export "$da_grs/countries_today.png", as(png) replace;
  
  
/* General version, LAC highlighted */
 #delimit ;
 local today: di "`c(current_date)'";
 graph bar  a_tot_lac a_tot_nlac if stage==stage_current,
 	over(stage_current) stack
 	legend(label(1 "Latin-America and Caribbean") label(2 "Rest of the world"))
 	title("What stage of infection are countries in today (`today')?")
 	note("Note: Sample restricted to 162 countries with population 250k or larger.");
 graph export "$da_grs/countries_today_lac_`c(current_date)'.png", as(png) replace;

/* Paper version, LAC highlighted */
  #delimit ;
  local today: di "`c(current_date)'";
  graph bar  a_tot_lac a_tot_nlac if stage==stage_current,
  	over(stage_current) stack
  	legend(label(1 "Latin-America and Caribbean") label(2 "Rest of the world"));
  graph export "$dd_fig/countries_today_lac.png", as(png) replace;

 
  /*************************************************/
  /* How long have stages lasted around the world?         */
  /*************************************************/

/* General version */
 #delimit ;
 local today: di "`c(current_date)'";
 graph bar  a_duration_lac a_duration_usa a_duration_afr a_duration_asi a_duration_eur a_duration_oce if aux==1,
 	over(stage)
	 legend(label(1 "LAC") label(2 "USA and Canada") label(3 "Africa") label(4 "Asia") label(5 "Europe") label(6 "Oceania") r(2) )
 	title("How long has each stage lasted around the world?")
 	note("Note: Sample restricted to 162 countries with population 250k or larger." "The latest data available at the time of writing is of `today'.");
 graph export "$da_grs/regions_stage_duration_`c(current_date)'.png", as(png) replace;

/* Paper version */
 #delimit ;
 local today: di "`c(current_date)'";
 graph bar  a_duration_lac a_duration_usa a_duration_afr a_duration_asi a_duration_eur a_duration_oce if aux==1,
 	over(stage)
	 legend(label(1 "LAC") label(2 "USA and Canada") label(3 "Africa") label(4 "Asia") label(5 "Europe") label(6 "Oceania") r(2) );
 graph export "$dd_fig/regions_stage_duration.png", as(png) replace;

  

 /*************************************************/
  /* How long has each stage lasted in LAC?       */
  /*************************************************/

/* General version */
 #delimit ;
 local today: di "`c(current_date)'";
 graph hbar (sum) stage_dur_A stage_dur_B stage_dur_C stage_dur_D stage_dur_E
 	if aux2==1  & subregioncode==419, over(name) stack
 	legend(label(1 "A") label(2 "B") label(3 "C") label(4 "D") label(5 "E") r(1)) bar(3, color(green))
 	xsize(10) ysize(16)
 	title("Duration of COVID-19 infection stages in LAC", span size(medlarge))
 	note("Note: All countries are assumed to start stage A in 31 Dec 2019." "Last day registered is `today'.", span);
 graph export "$da_grs/lac_stage_duration_`c(current_date)'.png", as(png) replace;

/* Paper version */
 #delimit ;
 local today: di "`c(current_date)'";
 graph hbar (sum) stage_dur_A stage_dur_B stage_dur_C stage_dur_D stage_dur_E
  if aux2==1  & subregioncode==419, over(name) stack
  legend(label(1 "A") label(2 "B") label(3 "C") label(4 "D") label(5 "E") r(1)) bar(3, color(green))
  xsize(10) ysize(16);
 graph export "$dd_fig/lac_stage_duration.png", as(png) replace;
 
 
 /*************************************************/
  /* How stringent have policies been at each stage?   */
  /*************************************************/

/* General version */
#delimit ;
twoway (kdensity stringency if stage =="A" &  aux==1 , 
	lcolor(maroon) lw(medthick) lp(dash) legend(label(1 "A"))) 
(kdensity stringency  if stage =="B" &  aux==1  , 
	lcolor(edkblue) lw(medthick) lp(shortdash)  legend(label(2 "B"))) 
(kdensity stringency  if stage =="C" &  aux==1  , 
	legend(label(3 "C")) lcolor(green*1.2) lw(medthick) lp(dash_dot)  ) 
(kdensity stringency  if stage =="D" & aux==1  , 
	 lcolor(black)  lw(medthick) legend(label(4 "D"))) 
(kdensity stringency  if stage =="E" &  aux==1  , 
	lw(medthick) lcolor(red) lp(longdash) legend(label(5 "E"))) 
, xtitle("Stringecy Index (OxCGRT)" ) title("Stage distributions of stringency of government policies") ytitle("")
legend(label(1 "A") label(2 "B") label(3 "C") label(4 "D") label(5 "E") r(1));
 graph export "$da_grs/stringency_by_stage_`c(current_date)'.png", as(png) replace;

 /* Paper version */
#delimit ;
twoway (kdensity stringency if stage =="A" &  aux==1 , 
	lcolor(maroon) lw(medthick) lp(dash) legend(label(1 "A"))) 
(kdensity stringency  if stage =="B" &  aux==1  , 
	lcolor(edkblue) lw(medthick) lp(shortdash)  legend(label(2 "B"))) 
(kdensity stringency  if stage =="C" &  aux==1  , 
	legend(label(3 "C")) lcolor(green*1.2) lw(medthick) lp(dash_dot)  ) 
(kdensity stringency  if stage =="D" & aux==1  , 
	 lcolor(black)  lw(medthick) legend(label(4 "D"))) 
(kdensity stringency  if stage =="E" &  aux==1  , 
	lw(medthick) lcolor(red) lp(longdash) legend(label(5 "E"))) 
, xtitle("Stringecy Index (OxCGRT)" ) ytitle("")
legend(label(1 "A") label(2 "B") label(3 "C") label(4 "D") label(5 "E") r(1));
 graph export "$dd_fig/stringency_by_stage.png", as(png) replace;

 
 /*************************************************/
  /* How the durations of different stages relate?   */
  /*************************************************/
 
 /* Correlation A and B, general version */
#delimit ;
qui reg stage_dur_B stage_dur_A if aux2==1 & (stage_current=="C" | stage_current=="D" | stage_current=="D");
local r_cons: display %5.2f _b[_cons] ;
local r_cons_se: display %5.2f _se[_cons]; 
local r_coeff: display %5.2f _b[stage_dur_A] ;
local r_coeff_se: display %5.2f _se[stage_dur_A]; 
local r_N "`e(N)'"; 

twoway (scatter stage_dur_B stage_dur_A if aux==1 & (stage_current=="C" | stage_current=="D" | stage_current=="D")) 
(lfit stage_dur_B stage_dur_A if aux==1 & (stage_current=="C" | stage_current=="D" | stage_current=="D")) ,
ytitle("Stage B duration") xtitle("Stage A duration") xsize(12) ysize(7) legend(off)
title(Correlation of duration of stages A and B)
note("Regression: Duration B = `r_cons' (`r_cons_se') `r_coeff' (`r_coeff_se') Duration A. Sample restricted to countries currently in stages C, D or E (N=`r_N').", span);
 graph export "$da_grs/correlation_A_B_`c(current_date)'.png", as(png) replace;

 /* Correlation A and B, paper version */
 twoway (scatter stage_dur_B stage_dur_A if aux==1 & (stage_current=="C" | stage_current=="D" | stage_current=="D")) 
(lfit stage_dur_B stage_dur_A if aux==1 & (stage_current=="C" | stage_current=="D" | stage_current=="D")) ,
ytitle("Stage B duration") xtitle("Stage A duration") xsize(12) ysize(7) legend(off)
note("Regression: Duration B = `r_cons' (`r_cons_se') `r_coeff' (`r_coeff_se') Duration A.", span);
 graph export "$dd_fig/correlation_A_B.png", as(png) replace;

  /* Correlation B and C, general version */
#delimit ;
qui reg stage_dur_C stage_dur_B if aux2==1 & (stage_current=="D" | stage_current=="E");
local r_cons: display %5.2f _b[_cons] ;
local r_cons_se: display %5.2f _se[_cons]; 
local r_coeff: display %5.2f _b[stage_dur_B] ;
local r_coeff_se: display %5.2f _se[stage_dur_B]; 
local r_N "`e(N)'"; 

twoway (scatter stage_dur_C stage_dur_B if aux==1 & (stage_current=="D" | stage_current=="E")) 
(lfit stage_dur_C stage_dur_B if aux==1 & (stage_current=="D" | stage_current=="E")) ,
ytitle("Stage C duration") xtitle("Stage B duration") xsize(12) ysize(7) legend(off)
title(Correlation of duration of stages B and C)
note("Regression: Duration C = `r_cons' (`r_cons_se') `r_coeff' (`r_coeff_se') Duration B. Sample restricted to countries currently in stages D or E (N=`r_N').", span);
 graph export "$da_grs/correlation_B_C_`c(current_date)'.png", as(png) replace;
 
  /* Correlation B and C, paper version */
twoway (scatter stage_dur_C stage_dur_B if aux==1 & (stage_current=="D" | stage_current=="E")) 
(lfit stage_dur_C stage_dur_B if aux==1 & (stage_current=="D" | stage_current=="E")) ,
ytitle("Stage C duration") xtitle("Stage B duration") xsize(12) ysize(7) legend(off)
note("Regression: Duration C = `r_cons' (`r_cons_se') `r_coeff' (`r_coeff_se') Duration B.", span);
 graph export "$dd_fig/correlation_B_C.png", as(png) replace;

 

/* End of do file */
