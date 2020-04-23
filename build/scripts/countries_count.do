/***********************************************************************
 * Government Policies along the COVID infection wave
 * Juan Pablo Chauvin

 * Purpose: Generate country-level counts
 * Created by: Juan Pablo Chauvin
 * Created on: 04/20/2020
 * Last modified on: 02/21/2020
 * Last modified by: JPCR
 * Edits history:

  **************************************************************************/

  use "$db_out/policies_int_working_dataset.dta", clear

/*************************************************/
 /* Homecleaning                    */
 /*************************************************/

  /* Drop small countries and countries without data */
  drop if pop==. | gdp==.
  drop if pop<250000
  drop if s1_s==. & s2_w==. & s3_c==. & s4_c==. & s5_p==. & s6_r==. & s7==. & s8==. & s9==. & s10==. & s11==. & s12==. & s13==.
  drop if stage==""

 /*************************************************/
  /* Collapse country aggregates                    */
  /*************************************************/
  #delimit ;
  collapse (sum) fiscal health vacc
  (mean) stringency=stringencyindexfordisplay
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
  , by (ccode);

  /* Order and save */
  merge 1:1 ccode using $db_out/current_stage.dta;
  drop _merge;
  save "$db_out/pol_countries", replace;

/* End of do file */
