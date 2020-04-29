/***********************************************************************
 * Government Policies along the COVID infection wave
 * Juan Pablo Chauvin

 * Purpose: Produce updated versions of the blog-post figures
 * Created by: Juan Pablo Chauvin
 * Created on: 04/28/2020
 * Last modified on: 04/28/2020
 * Last modified by: JPCR
 * Edits history:

  **************************************************************************/

/*************************************************/
 /* Homecleaning                    */
 /*************************************************/

 set scheme burd
 * plottigblind  plotplainblind cleanplots burd

 use "$db_out/covid_countries_stages", clear

/* Prepare country-stage data for analysis */
do "$da_scr/analysis_preparation_country_stage.do"

/* Local for total countries / stages */
bysort ccode stage: egen aux=seq()
/* Local for total countries  */
bysort ccode : egen aux2=seq()
/* Local for current date */
local today: di "`c(current_date)'"

 /********************************************************************/
  /* Where is Latin America and the Caribbean on the COVID-19 Curve?  */
  /********************************************************************/

  /* Figure 2 */
 #delimit ;
 graph bar  a_tot_lac a_tot_usa a_tot_afr a_tot_asi a_tot_eur a_tot_oce if stage==stage_current,
 	over(stage) stack xsize(11) ysize(8)
	 legend(label(1 "Latin America and Caribbean") label(2 "USA and Canada") label(3 "Africa") label(4 "Asia") label(5 "Europe") label(6 "Oceania") r(2) )
 	note("Note: Sample restricted to 134 countries with population 250,000 or larger." "Data from: Our World in Data (ourworldindata.org/coronavirus). Last updated `today'.");
 graph export "$dd_upd/countries_today.png", as(png) replace;

/* Figure 3 */
 #delimit ;
 local today: di "`c(current_date)'";
 graph bar  a_duration_afr a_duration_lac a_duration_eur  a_duration_oce  a_duration_asi a_duration_usa  if aux==1,
 	over(stage) xsize(11) ysize(8) nofill
	 legend(label(1 "Africa")  label(2 "Europe") label(3 "Latin America and the Caribbean") label(4 "Oceania") label(5 "Asia") label(6 "USA and Canada")   r(2) )
 	note("Note: Unweighted averages across countries in each region-stage cell. Sample restricted to 134 countries" "with population 250,000 or larger. Data from: Our World in Data (ourworldindata.org/coronavirus)." "Last updated `today'.");
 graph export "$dd_upd/regions_stage_duration.png", as(png) replace;

/* Figure 4 */
 #delimit ;
 local today: di "`c(current_date)'";
 graph hbar (sum) stage_dur_A stage_dur_B stage_dur_C stage_dur_D stage_dur_E
 	if aux2==1  & subregioncode==419, over(name) stack
 	legend(label(1 "A") label(2 "B") label(3 "C") label(4 "D") label(5 "E") r(1)) bar(3, color(green))
 	xsize(11) ysize(16)
 	note("Note: All countries are assumed to start stage A in 31 Dec 2019." "Data from: Our World in Data (ourworldindata.org/coronavirus)." "Last updated `today'.", span);
 graph export "$dd_upd/lac_stage_duration.png", as(png) replace;

/* Figure 5 */

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
note("Duration B = `r_cons' (`r_cons_se') `r_coeff' (`r_coeff_se') Duration A." "Sample restricted to countries currently in stages C, D or E (N=`r_N').", size(small) span);
qui graph save $da_tmp/correlation_A_B, replace;

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
note("Duration C = `r_cons' (`r_cons_se') `r_coeff' (`r_coeff_se') Duration B." "Sample restricted to countries currently in stages D or E (N=`r_N').", size(small) span);
qui graph save $da_tmp/correlation_B_C, replace;

/* Combined correlations for blog */
qui gr combine $da_tmp/correlation_A_B.gph $da_tmp/correlation_B_C.gph, iscale(1) col(2) graphr(margin(zero))  xsize(11) ysize(6)
note("Data from: Our World in Data (ourworldindata.org/coronavirus). Last updated `today'.", span);
graph export "$dd_upd/correlation_A_B_C.png", as(png) replace;

/* End of do file */
