/***********************************************************************
 * Government Policies along the COVID infection wave
 * Juan Pablo Chauvin

 * Purpose: Pre-process WDI and other country variables along without
 * country identifiers.
 * Created by: Juan Pablo Chauvin
 * Created on: 04/17/2020
 * Last modified on: 02/21/2020
 * Last modified by: JPCR
 * Edits history:

  **************************************************************************/

  insheet using "$db_inp/OxCGRT.csv", comma clear

  /*************************************************/
   /* Homecleaning                    */
   /*************************************************/

  drop v40
  rename date date2
  tostring date2, replace
  gen date=date(date2, "YMD")
  format date %td
  drop date2
  drop *_notes countryname
  rename countrycode ccode
  order ccode date

/*************************************************/
 /* Generating relative variables                    */
 /*************************************************/

/* Merging supplementary datasets */
  merge m:1 ccode using $db_out/WDI_2018_pop_gdp.dta
  drop _merge

  merge m:1 ccode using $db_out/countries_regions.dta, keepusing(regioncode subregioncode)
  drop _merge
  sort ccode
  by ccode: egen unique_country = seq()

/* Calculating variables  */

  g fiscal = (s8_fiscalmeasures / gdp)*100
  lab var fiscal "Fiscal measures as percentage of 2018 GDP"

  g health = (s10_emergencyinvestmentinhealthc / gdp)*100
  lab var health "Emergency health investments as percentage of 2018 GDP"

  g vacc = (s11_investmentinvaccines / gdp)*100
  lab var vacc "Investment in vaccines as percentage of 2018 GDP"

/* Observations above the median in emergency investments */
  foreach i in fiscal health vacc {
  	sum `i' if unique_country==1 & `i'>0 & `i'!=., d
  	g `i'_ext = (`i'>r(p50) & `i'!=.)
  	}

  lab var fiscal_ext "Fiscal measures above the median"
  lab var health_ext "Emergency health investments above the median"
  lab var vacc_ext "Investment in vaccines above the median"


  /* Generating policy variables */

  g polgensch_close = (s1_s==1 | s1_s==2)
  g polextsch_close = (s1_s==2)
  g polextgensch_close = (s1_s==2 | s1_i==1)
  g polgenwrk_close = (s2_w==1 | s2_w==2)
  g polextwrk_close = (s2_w==2)
  g polextgenwrk_close = (s2_w==2 | s2_i==1)
  g polgenpub_close = (s3_c==1 | s3_c==2)
  g polextpub_close = (s3_c==2)
  g polextgenpub_close = (s3_c==2 | s3_i==1)
  g polgentsp_close = (s4_c==1 | s4_c==2)
  g polexttsp_close = (s4_c==2)
  g polextgentsp_close = (s4_c==2 | s4_i==1)
  g polgenpub_info = (s5_p==1)
  g polextpub_info = (s5_p==1)
  g polextgenpub_info = (s5_p==1 | s5_i==1)
  g polgenmov_rst = (s6_r==1 | s6_r==2)
  g polextmov_rst = (s6_r==2)
  g polextgenmov_rst = (s6_r==2 | s6_i==1)
  g polgenint_rst = (s7==1 | s7==2 | s7==3)
  g polextint_rst = (s7==3)
  g polextgenint_rst = (s7==3)
  g polgenfiscal = (s8>0 & s8!=.)
  g polextfiscal = (fiscal_ext==1)
  g polextgenfiscal = (fiscal_ext==1)
  g polgenhealth = (s10>0 & s10!=.)
  g polexthealth = (health_ext==1)
  g polextgenhealth = (health_ext==1)
  g polgenvacc = (s11>0 & s11!=.)
  g polextvacc = (vacc_ext==1)
  g polextgenvacc = (vacc_ext==1)
  g polgentest = (s12==1 | s12==2 | s12==3)
  g polexttest = (s12==3)
  g polextgentest = (s12==3)
  g polgentracing = (s13==1 | s13==2)
  g polexttracing = (s13==2)
  g polextgentracing = (s13==2)

/* Labeling */

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


  save "$db_out/oxford_policies.dta", replace

/* End of do file */
