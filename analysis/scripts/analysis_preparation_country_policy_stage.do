/***********************************************************************
 * Government Policies along the COVID infection wave
 * Juan Pablo Chauvin

 * Purpose: Prepare country-policy-stage data for analysis
 * Created by: Juan Pablo Chauvin
 * Created on: 04/25/2020
 * Last modified on: 04/25/2020
 * Last modified by: JPCR
 * Edits history:

  **************************************************************************/

  /*************************************************/
   /* Homecleaning                    */
   /*************************************************/
#delimit ;


  /* Calculate rank of policies by stage */
  preserve;
  keep stage policy stage_polgen_count stage_polext_count;
  * For testing, take the most extreme values;
  replace stage_polgen_count=stage_polext_count if policy==8 ;
  drop stage_polext_count; duplicates drop;
  bysort stage: egen stage_pol_rank = rank(stage_polgen_count), field;
  lab var stage_pol_rank "Rank of policy by stage";
  drop stage_polgen_count;
  save $da_tmp/polrank.dta, replace;
  restore;

  /* Bring in other data */
  merge m:1 ccode using $db_out/current_stage.dta;
  drop if _merge==2; drop _merge;

  merge m:1 stage policy using $da_tmp/polrank.dta;
  drop if _merge==2; drop _merge;
  
   /* Local for total countries */
 bysort ccode: egen aux=seq();
 sum pol_none if aux==1;
 local tot_cty = r(N); dis "Total countries are `tot_cty'";

 /* Local for unique policy-stage observation */
 bysort stage policy: egen aux2=seq();

/*************************************************/
 /* New auxiliary variables creation                    */
 /*************************************************/

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




/* End of do file */
