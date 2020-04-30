/***********************************************************************
 * Government Policies along the COVID infection wave
 * Juan Pablo Chauvin

 * Purpose: Generate some results for Puerto Rico
 * Created by: Juan Pablo Chauvin
 * Created on: 04/30/2020
 * Last modified on: 04/30/2020
 * Last modified by: JPCR
 * Edits history:

  **************************************************************************/

  #delimit ;

  use "$db_out/policies_int_working_dataset.dta", clear;

/*************************************************/
 /* Homecleaning                    */
 /*************************************************/

  /* Drop small countries and countries without data */
  drop if stage=="";
  keep if ccode=="PRI";
 
/*************************************************/
 /* Collapse covid variables only dataset       */
 /*************************************************/


 collapse (mean) stage_duration stringency=stringencyindexfordisplay
 (max) cum_case cum_deaths
 , by (ccode stage);

 /* Merging to outside datasets */

 merge m:1 ccode using $db_out/current_stage.dta;
 drop if _merge==2;
 drop _merge;

 merge m:1 ccode using $db_out/countries_regions.dta;
 drop if _merge==2; drop _merge;

/* Generate log and relative variables */

  /* Labeling and saving */
  lab var region "Region";
  lab var stage_duration "Duration of stage in country";
  lab var cum_case "Cumulative confirmed cases in stage";
  lab var cum_deaths "Cumulative confirmed deaths in stage";

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

 set scheme burd;
 * plottigblind  plotplainblind cleanplots burd

 use "$db_out/covid_countries_stages", clear;

/* Prepare country-stage data for analysis */
do "$da_scr/analysis_preparation_country_stage.do";

/* Local for total countries / stages */
bysort ccode stage: egen aux=seq();
/* Local for total countries  */
bysort ccode : egen aux2=seq();
/* Local for current date */
local today: di "`c(current_date)'";

/* Figure 4 */
 #delimit ;
 local today: di "`c(current_date)'";
 graph hbar (sum) stage_dur_A stage_dur_B stage_dur_C stage_dur_D stage_dur_E
 	if aux2==1  & subregioncode==419, over(name) stack
 	legend(label(1 "A") label(2 "B") label(3 "C") label(4 "D") label(5 "E") r(1)) bar(3, color(green))
 	xsize(11) ysize(16)
 	note("Note: All countries are assumed to start stage A in 31 Dec 2019." "Data from: Our World in Data (ourworldindata.org/coronavirus)." "Last updated on `today'.", span);
 graph export "$da_out/PRI_stage_duration.png", as(png) replace;

 
 
