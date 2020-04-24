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

/* General version */
 #delimit ;
 local today: di "`c(current_date)'";
 graph bar (count) a_duration_lac a_duration_nlac if stage==stage_current,
 	over(stage_current) stack
 	legend(label(1 "Latin-America and Caribbean") label(2 "Rest of the world"))
 	title("What stage of infection are countries in today (`today')?")
 	note("Note: Sample restricted to 162 countries with population 250k or larger.");
 graph export "$da_grs/countries_today_`c(current_date)'.png", as(png) replace;

/* Paper version */
  #delimit ;
  local today: di "`c(current_date)'";
  graph bar (count) a_duration_lac a_duration_nlac if stage==stage_current,
  	over(stage_current) stack
  	legend(label(1 "Latin-America and Caribbean") label(2 "Rest of the world"));
  graph export "$dd_fig/countries_today.png", as(png) replace;


 /*************************************************/
  /* How long has each stage lasted?       */
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
	lcolor(maroon) legend(label(1 "A"))) 
(kdensity stringency  if stage =="B" &  aux==1  , 
	lcolor(edkblue) legend(label(2 "B"))) 
(kdensity stringency  if stage =="C" &  aux==1  , 
	legend(label(3 "C")) lcolor(green*1.2) ) 
(kdensity stringency  if stage =="D" & aux==1  , 
	legend(label(4 "D"))) 
(kdensity stringency  if stage =="E" &  aux==1  , 
	legend(label(5 "E"))) 
, xtitle("Stringecy Index (OxCGRT)" ) title("Stringency of government policies by stage") ytitle("")
legend(label(1 "A") label(2 "B") label(3 "C") label(4 "D") label(5 "E") r(1));
 graph export "$da_grs/stringency_by_stage_`c(current_date)'.png", as(png) replace;

 /* Paper version */
#delimit ;
twoway (kdensity stringency if stage =="A" &  aux==1 , 
	lcolor(maroon) legend(label(1 "A"))) 
(kdensity stringency  if stage =="B" &  aux==1  , 
	lcolor(edkblue) legend(label(2 "B"))) 
(kdensity stringency  if stage =="C" &  aux==1  , 
	legend(label(3 "C")) lcolor(green*1.2) ) 
(kdensity stringency  if stage =="D" & aux==1  , 
	legend(label(4 "D"))) 
(kdensity stringency  if stage =="E" &  aux==1  , 
	legend(label(5 "E"))) 
, xtitle("Stringecy Index (OxCGRT)" ) ytitle("")
legend(label(1 "A") label(2 "B") label(3 "C") label(4 "D") label(5 "E") r(1));
 graph export "$dd_fig/stringency_by_stage.png", as(png) replace;


/* End of do file */
