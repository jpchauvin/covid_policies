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
drop _merge;

/* Local for total countries */
bysort ccode: egen aux=seq();
sum pol_none if aux==1;
local tot_cty = r(N); dis "Total countries are `tot_cty'";

/* Shares of countries in different policy response groups */
g stage_pol_base_sh = (stage_pol_base_count / `tot_cty')*100;
g stage_pol_int_sh = (stage_pol_int_count / `tot_cty')*100;
g stage_pol_none_sh = 100 - stage_pol_base_sh - stage_pol_int_sh;
lab var stage_pol_none_sh "Not implemented";
lab var stage_pol_base_sh "Implemented moderately";
lab var stage_pol_int_sh "Implemented intensively";

/* Local for number of countries in each stage currently */
#delimit ;
local today: di "`c(current_date)'";
foreach st in A B C D E {;
	qui sum pol_none if stage_current=="`st'" & aux==1;
	local in_`st' = r(N); };

/*************************************************/
 /* What policies are more frequent at each stage?  */
 /*************************************************/

tabplot policy stage [fw=polgen] if stage==stage_current, horizontal scale(*.65)
	title("What policies are more frequent at each stage?",  size(medlarge)) subtitle("")
	xsize(12) ysize(16)
	note("Note: The plot considers all policies implemented between 31 Dec 2019 and `today'." "The current number of countries by stage are: A=`in_A', B=`in_B', C=`in_C', D=`in_D', and E=`in_D'.", span);
graph export "$da_grs/policies_by_stage_`c(current_date)'", as(png) replace;


/* End of do file */
