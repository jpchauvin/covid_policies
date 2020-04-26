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

  /* Blog version, all regions */
 #delimit ;
 local today: di "`c(current_date)'";
 graph bar  a_tot_lac a_tot_usa a_tot_afr a_tot_asi a_tot_eur a_tot_oce if stage==stage_current,
 	over(stage) stack xsize(11) ysize(8)
	 legend(label(1 "LAC") label(2 "USA and Canada") label(3 "Africa") label(4 "Asia") label(5 "Europe") label(6 "Oceania") r(2) )
 	title("Figure 2. Current spread stage around the world")
 	note("Note: Sample restricted to 134 countries with population 250k or larger. Last updated `today'.");
 graph export "$dd_blog/countries_today.png", as(png) replace;

   /* Paper version, all regions */
 #delimit ;
 local today: di "`c(current_date)'";
 graph bar  a_tot_lac a_tot_usa a_tot_afr a_tot_asi a_tot_eur a_tot_oce if stage==stage_current,
 	over(stage) stack xsize(11) ysize(8)
	 legend(label(1 "LAC") label(2 "USA and Canada") label(3 "Africa") label(4 "Asia") label(5 "Europe") label(6 "Oceania") r(2) );
 graph export "$dd_fig/countries_today.png", as(png) replace;


/* General version, LAC highlighted */
 #delimit ;
 local today: di "`c(current_date)'";
 graph bar  a_tot_lac a_tot_nlac if stage==stage_current,
 	over(stage_current) stack xsize(11) ysize(8)
 	legend(label(1 "Latin-America and Caribbean") label(2 "Rest of the world"))
 	title("What stage of infection are countries in today (`today')?")
 	note("Note: Sample restricted to 134 countries with population 250k or larger.");
 graph export "$da_grs/countries_today_lac_`c(current_date)'.png", as(png) replace;


  /*************************************************/
  /* How long have stages lasted around the world?         */
  /*************************************************/

/* Blog version */
 #delimit ;
 local today: di "`c(current_date)'";
 graph bar  a_duration_afr a_duration_lac a_duration_eur  a_duration_oce  a_duration_asi a_duration_usa  if aux==1,
 	over(stage) xsize(11) ysize(8) nofill 
	 legend(label(1 "Africa")  label(2 "Europe") label(3 "LAC") label(4 "Oceania") label(5 "Asia") label(6 "USA and Canada")   r(2) )
 	title("Figure 4. Stage duration around the world")
 	note("Note: Sample restricted to 134 countries with population 250k or larger." "Data from: Our World in Data (ourworldindata.org/coronavirus). Last updated on `today'.");
 graph export "$dd_blog/regions_stage_duration.png", as(png) replace;

/* Paper version */
 #delimit ;
 local today: di "`c(current_date)'";
 graph bar  a_duration_afr a_duration_lac a_duration_eur  a_duration_oce  a_duration_asi a_duration_usa  if aux==1,
 	over(stage) xsize(11) ysize(8) nofill 
	 legend(label(1 "Africa")  label(2 "Europe") label(3 "LAC") label(4 "Oceania") label(5 "Asia") label(6 "USA and Canada")   r(2) );
 graph export "$dd_fig/regions_stage_duration.png", as(png) replace;


 /*************************************************/
  /* How long has each stage lasted in LAC?       */
  /*************************************************/

/* Blog version */
 #delimit ;
 local today: di "`c(current_date)'";
 graph hbar (sum) stage_dur_A stage_dur_B stage_dur_C stage_dur_D stage_dur_E
 	if aux2==1  & subregioncode==419, over(name) stack
 	legend(label(1 "A") label(2 "B") label(3 "C") label(4 "D") label(5 "E") r(1)) bar(3, color(green))
 	xsize(11) ysize(16)
 	title("Figure 3. Duration of COVID-19 spread stages" "in Latin America and the Caribbean", span size(medlarge))
 	note("Note: All countries are assumed to start stage A in 31 Dec 2019." "Data from: Our World in Data (ourworldindata.org/coronavirus)." "Last updated on `today'.", span);
 graph export "$dd_blog/lac_stage_duration.png", as(png) replace;

/* Paper version */
 #delimit ;
 local today: di "`c(current_date)'";
 graph hbar (sum) stage_dur_A stage_dur_B stage_dur_C stage_dur_D stage_dur_E
  if aux2==1  & subregioncode==419, over(name) stack
  legend(label(1 "A") label(2 "B") label(3 "C") label(4 "D") label(5 "E") r(1)) bar(3, color(green))
  xsize(11) ysize(16);
 graph export "$da_grs/lac_stage_duration.png", as(png) replace;


 /*************************************************/
  /* How stringent have policies been at each stage?   */
  /*************************************************/

/* Blog version */
#delimit ;
 local today: di "`c(current_date)'";
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
, xsize(11) ysize(8) xtitle("Stringecy Index (OxCGRT)" ) title("Figure 7. Distribution of stringency of policies in each stage", size(medlarge)) ytitle("")
legend(label(1 "A") label(2 "B") label(3 "C") label(4 "D") label(5 "E") r(1))
note("Note: Sample restricted to 134 countries with population 250k or larger." "Data from: The Oxford COVID-19 Government Response Tracker (bsg.ox.ac.uk/covidtracker)." "Last updated on `today'.");
 graph export "$dd_blog/stringency_by_stage.png", as(png) replace;

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
, xsize(11) ysize(8) xtitle("Stringecy Index (OxCGRT)" ) ytitle("")
legend(label(1 "A") label(2 "B") label(3 "C") label(4 "D") label(5 "E") r(1));
 graph export "$dd_fig/stringency_by_stage.png", as(png) replace;


 /*************************************************/
  /* How the durations of different stages relate?   */
  /*************************************************/

/* Correlation A and B */
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
title("Stages A and B", size(medium))
note("Duration B = `r_cons' (`r_cons_se') `r_coeff' (`r_coeff_se') Duration A." "Sample restricted to countries currently in stages C, D or E (N=`r_N').", size(vsmall) span);
qui graph save $da_tmp/correlation_A_B, replace;

/* Correlation A and B, paper version */
twoway (scatter stage_dur_B stage_dur_A if aux==1 & (stage_current=="C" | stage_current=="D" | stage_current=="D"))
(lfit stage_dur_B stage_dur_A if aux==1 & (stage_current=="C" | stage_current=="D" | stage_current=="D")) ,
ytitle("Stage B duration") xtitle("Stage A duration") xsize(12) ysize(7) legend(off)
note("Regression: Duration B = `r_cons' (`r_cons_se') `r_coeff' (`r_coeff_se') Duration A.", span);
graph export "$dd_fig/correlation_A_B.png", as(png) replace;

/* Correlation B and C */
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
title("Stages B and C", size(medium))
note("Duration C = `r_cons' (`r_cons_se') `r_coeff' (`r_coeff_se') Duration B." "Sample restricted to countries currently in stages D or E (N=`r_N').", size(vsmall) span);
qui graph save $da_tmp/correlation_B_C, replace;

/* Correlation B and C, paper version */
twoway (scatter stage_dur_C stage_dur_B if aux==1 & (stage_current=="D" | stage_current=="E"))
(lfit stage_dur_C stage_dur_B if aux==1 & (stage_current=="D" | stage_current=="E")) ,
ytitle("Stage C duration") xtitle("Stage B duration") xsize(12) ysize(7) legend(off)
note("Regression: Duration C = `r_cons' (`r_cons_se') `r_coeff' (`r_coeff_se') Duration B.", span);
graph export "$dd_fig/correlation_B_C.png", as(png) replace;

/* Combined correlations for blog */
qui gr combine $da_tmp/correlation_A_B.gph $da_tmp/correlation_B_C.gph, iscale(1) col(2) graphr(margin(zero))  xsize(11) ysize(6)
title("Figure 5. Correlations of stage durations")
note("Data from: Our World in Data (ourworldindata.org/coronavirus)", span);
graph export "$dd_blog/correlation_A_B_C.png", as(png) replace;


/* End of do file */
