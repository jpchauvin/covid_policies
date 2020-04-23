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

 /*************************************************/
  /* Where in the waves are countries now?         */
  /*************************************************/

 #delimit ;
 local today: di "`c(current_date)'";
 graph bar (count) a_duration_lac a_duration_nlac if stage==stage_current,
 	over(stage_current) stack
 	legend(label(1 "Latin-America and Caribbean") label(2 "Rest of the world"))
 	title("What stage of infection are countries in today (`today')?")
 	note("Note: Sample restricted to 162 countries with population 250k or larger.");
 graph export "$da_grs/countries_today_`c(current_date)'", as(png) replace;

 /*************************************************/
  /* How long has each stage lasted?       */
  /*************************************************/

 #delimit ;
 local today: di "`c(current_date)'";
 graph hbar (sum) stage_dur_A stage_dur_B stage_dur_C stage_dur_D stage_dur_E
 	if stage==stage_current & subregioncode==419, over(name) stack
 	legend(label(1 "A") label(2 "B") label(3 "C") label(4 "D") label(5 "E") r(1)) bar(3, color(green))
 	xsize(10) ysize(16)
 	title("Duration of COVID-19 infection stages in LAC", span size(medlarge))
 	note("Note: All countries are assumed to start stage A in 31 Dec 2019." "Last day registered is `today'.", span);
 graph export "$da_grs/lac_stage_duration_`c(current_date)'", as(png) replace;


/* End of do file */
