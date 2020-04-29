/***********************************************************************
 * Government Policies along the COVID infection wave
 * Juan Pablo Chauvin

 * Purpose: Generate country-stage-level counts
 * Created by: Juan Pablo Chauvin
 * Created on: 04/20/2020
 * Last modified on: 02/21/2020
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
  drop if pop==. | gdp==.;
  drop if pop<250000;

/*************************************************/
 /* Collapse covid variables only dataset       */
 /*************************************************/

 /* These include all countries with COVID and WDI data */

 collapse (mean) stage_duration stringency=stringencyindexfordisplay
 (max) cum_case cum_deaths
 , by (ccode stage);

 /* Merging to outside datasets */

 merge m:1 ccode using $db_out/current_stage.dta;
 drop if _merge==2;
 drop _merge;

 merge m:1 ccode using $db_out/WDI_2018_pop_gdp.dta;
 drop if _merge==2; drop _merge;

 merge m:1 ccode using $db_out/countries_regions.dta;
 drop if _merge==2; drop _merge;

/* Generate log and relative variables */
 g l_pop = ln(pop);
  lab var l_pop "Log of Population";
  lab var pop "Population";
 g gdppc = gdp/pop;
  lab var gdppc "GDP per capita";
  lab var gdp "GDP";
 g l_gdppc = ln(gdppc);
  lab var l_gdppc "Log of GDP per capita";
  /* Labeling and saving */
  lab var region "Region";
  lab var stage_duration "Duration of stage in country";
  lab var cum_case "Cumulative confirmed cases in stage";
  lab var cum_deaths "Cumulative confirmed deaths in stage";

   /* Order and save */
  save "$db_out/covid_countries_stages", replace;


 /*************************************************/
  /* Collapse country aggregates  dataset           */
  /*************************************************/
  /* Exclude observations that don't have policies data */
 
  #delimit ;

  use "$db_out/policies_int_working_dataset.dta", clear;


  /* Drop small countries and countries without data */
  drop if stage=="";
  drop if pop==. | gdp==.;
  drop if pop<250000;

  drop if s1_s==. & s2_w==. & s3_c==. & s4_c==. & s5_p==. & s6_r==. & s7==. & s8==. & s9==. & s10==. & s11==. & s12==. & s13==. ;

  /* Collapse */
  collapse (sum) fiscal health vacc
  (mean) stage_duration stringency=stringencyindexfordisplay
  (max)
  fiscal_ext health_ext vacc_ext
  polgensch_close polextsch_close polextgensch_close
  polgenwrk_close polextwrk_close polextgenwrk_close
  polgenpub_close polextpub_close polextgenpub_close
  polgentsp_close polexttsp_close polextgentsp_close
  polgenpub_info polextpub_info polextgenpub_info
  polgenmov_rst polextmov_rst polextgenmov_rst
  polgenint_rst polextint_rst polextgenint_rst
  polgenfiscal polextfiscal polextgenfiscal
  polgenhealth polexthealth polextgenhealth
  polgenvacc polextvacc polextgenvacc
  polgentest polexttest polextgentest
  polgentracing polexttracing polextgentracing
  cum_case cum_deaths
  , by (ccode stage);


 /* Merging to outside datasets */

 merge m:1 ccode using $db_out/current_stage.dta;
 drop if _merge==2;
 drop _merge;

 merge m:1 ccode using $db_out/WDI_2018_pop_gdp.dta;
 drop if _merge==2; drop _merge;

 merge m:1 ccode using $db_out/countries_regions.dta;
 drop if _merge==2; drop _merge;

/* Generate log and relative variables */
 g l_pop = ln(pop);
  lab var l_pop "Log of Population";
  lab var pop "Population";
 g gdppc = gdp/pop;
  lab var gdppc "GDP per capita";
  lab var gdp "GDP";
 g l_gdppc = ln(gdppc);
  lab var l_gdppc "Log of GDP per capita";

 /* Labeling                    */

#delimit cr
 lab var polgensch_close "School closing"
 lab var polextsch_close "School closing, required"
 lab var polextgensch_close "School closing, required for all"
 lab var polgenwrk_close "Workplace closing"
 lab var polextwrk_close "Workplace closing, required"
 lab var polextgenwrk_close "Workplace closing, required for all"
 lab var polgenpub_close "Cancel public events"
 lab var polextpub_close "Cancel public events, required"
 lab var polextgenpub_close "Cancel public events, required for all"
 lab var polgentsp_close "Cancel public transport"
 lab var polexttsp_close "Cancel public transport, required"
 lab var polextgentsp_close "Cancel public transport, required for all"
 lab var polgenpub_info "Public info campaigns"
 lab var polextpub_info "Public info campaigns"
 lab var polextgenpub_info "Public info campaigns, directed at all"
 lab var polgenmov_rst "Restrictions on internal movement"
 lab var polextmov_rst "Restrictions on internal movement, required"
 lab var polextgenmov_rst "Restrictions on internal movement, required for all"
 lab var polgenint_rst "International travel controls"
 lab var polextint_rst "International travel controls, required"
 lab var polextgenint_rst "International travel controls, required for all"
 lab var polgenfiscal "Fiscal stimuli"
 lab var polextfiscal "Fiscal stimuli, above the median"
 lab var polextgenfiscal "Fiscal stimuli, above the median"
 lab var polgenhealth "Emergency health investment"
 lab var polexthealth "Emergency health investment, above the median"
 lab var polextgenhealth "Emergency health investment, above the median"
 lab var polgenvacc "Vaccine development investment"
 lab var polextvacc "Vaccine development investment, above the median"
 lab var polextgenvacc "Vaccine development investment, above the median"
 lab var polgentest "Testing policy"
 lab var polexttest "Testing policy, open public"
 lab var polextgentest "Testing policy, open public"
 lab var polgentracing "Contact tracing"
 lab var polexttracing "Contact tracing, limited"
 lab var polextgentracing "Contact tracing, comprehensive"
 lab var region "Region"
 lab var fiscal "Fiscal stimulus (% of GDP)"
 lab var health "Emergency health investment (% of GDP)"
 lab var vacc "Vaccine development investment (% of GDP)"
 lab var stage_duration "Duration of stage in country"
 lab var stringency "Average Oxford stringency index in stage"
 lab var cum_case "Cumulative confirmed cases in stage"
 lab var cum_deaths "Cumulative confirmed deaths in stage"

  /* Order and save */
 drop   fiscal_ext health_ext vacc_ext
 save "$db_out/pol_countries_stages", replace


/* End of do file */
