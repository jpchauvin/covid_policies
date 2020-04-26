/***********************************************************************
 * Government Policies along the COVID infection wave
 * Juan Pablo Chauvin

 * Purpose: Prepare country-stage data for analysis
 * Created by: Juan Pablo Chauvin
 * Created on: 04/21/2020
 * Last modified on: 04/22/2020
 * Last modified by: JPCR
 * Edits history:

  **************************************************************************/


/*************************************************/
 /* Homecleaning                    */
 /*************************************************/

/* Bring in countries names */
  merge m:1 ccode using "$db_out/countries_names.dta"
  drop if _merge==2
  drop _merge

/* Shorter name */
  replace name="Bolivia" if ccode=="BOL"

/* Current dummy  */

g curr_dum = 0
replace curr= 1 if stage_current==stage

/*************************************************/
 /* Calculating additional variables                    */
 /*************************************************/

  bysort stage: egen a_duration=mean(stage_duration)
  	lab var a_duration "Mean duration of stage across countries"

 /* Create modified regions */
g region2 = region
replace region2="LAC" if subregion=="Latin America and the Caribbean"
replace region2="US and Canada" if subregion=="Northern America"

  bysort stage: egen a_duration_lac=mean(stage_duration) if region2=="LAC"
  bysort stage: egen a_tot_lac=total(curr) if region2=="LAC"
	sort stage a_duration_lac
	replace a_duration_lac=a_duration_lac[_n-1] if a_duration_lac==.  & stage==stage[_n-1]
	sort stage a_tot_lac
	replace a_tot_lac=a_tot_lac[_n-1] if a_tot_lac==.  & stage==stage[_n-1]
  	lab var a_duration_lac "LAC"

  bysort stage: egen a_duration_nlac=mean(stage_duration) if region2!="LAC"
   bysort stage: egen a_tot_nlac=total(curr) if region2!="LAC"
	sort stage a_duration_nlac
	replace a_duration_nlac=a_duration_nlac[_n-1] if a_duration_nlac==. &  stage==stage[_n-1]
	sort stage a_tot_nlac
	replace a_tot_nlac=a_tot_nlac[_n-1] if a_tot_nlac==.  & stage==stage[_n-1]
  	lab var a_duration_nlac "Outside of LAC"

  bysort stage: egen a_duration_usa=mean(stage_duration) if region2=="US and Canada"
   bysort stage: egen a_tot_usa=total(curr) if region2=="US and Canada"
	sort stage a_duration_usa
  	replace a_duration_usa=a_duration_usa[_n-1] if a_duration_usa==. &  stage==stage[_n-1]
	sort stage a_tot_usa
  	replace a_tot_usa=a_tot_usa[_n-1] if a_tot_usa==. &  stage==stage[_n-1]
  	lab var a_duration_usa "US and Canada"

  bysort stage: egen a_duration_afr=mean(stage_duration) if region2=="Africa"
    bysort stage: egen a_tot_afr=total(curr) if region2=="Africa"
	sort stage a_duration_afr
    	replace a_duration_afr=a_duration_afr[_n-1] if a_duration_afr==. &  stage==stage[_n-1]
	sort stage a_tot_afr
    	replace a_tot_afr=a_tot_afr[_n-1] if a_tot_afr==. &  stage==stage[_n-1]
  	lab var a_duration_afr "Africa"

  bysort stage: egen a_duration_asi=mean(stage_duration) if region2=="Asia"
    bysort stage: egen a_tot_asi=total(curr) if region2=="Asia"
	sort stage a_duration_asi
    	replace a_duration_asi=a_duration_asi[_n-1] if a_duration_asi==.  & stage==stage[_n-1]
	sort stage a_tot_asi
    	replace a_tot_asi=a_tot_asi[_n-1] if a_tot_asi==.  & stage==stage[_n-1]
  	lab var a_duration_asi "Asia"

  bysort stage: egen a_duration_eur=mean(stage_duration) if region2=="Europe"
    bysort stage: egen a_tot_eur=total(curr) if region2=="Europe"
	sort stage a_duration_eur
    	replace a_duration_eur=a_duration_eur[_n-1] if a_duration_eur==.  & stage==stage[_n-1]
	sort stage a_tot_eur
    	replace a_tot_eur=a_tot_eur[_n-1] if a_tot_eur==.  & stage==stage[_n-1]
  	lab var a_duration_eur "Europe"

  bysort stage: egen a_duration_oce=mean(stage_duration) if region2=="Oceania"
   bysort stage: egen a_tot_oce=total(curr) if region2=="Oceania"
	sort stage a_duration_oce
    	replace a_duration_oce=a_duration_oce[_n-1] if a_duration_oce==.  & stage==stage[_n-1]
	sort stage a_tot_oce
    	replace a_tot_oce=a_tot_oce[_n-1] if a_tot_oce==.  & stage==stage[_n-1]
  	lab var a_duration_oce "Oceania"

foreach st in A B C D E {
	g stage_dur_`st' = .
	replace stage_dur_`st' = stage_duration if stage=="`st'"
	sort ccode stage_dur_`st'
	replace stage_dur_`st'=stage_dur_`st'[_n-1] if stage_dur_`st'==. & ccode==ccode[_n-1]
}

/* Identifiers of whether a country has gone through a specific stage */

foreach st in E D C B A {
	g was_`st'=0
	replace was_`st'=1 if stage_current=="`st'"
	}
	replace was_D =1 if was_E==1
	replace was_C =1 if was_D==1
	replace was_B =1 if was_C==1
	replace was_A =1 if was_B==1
/* Total number of countries that has gone through each stage */
foreach st in E D C B A {
	bysort stage: egen tot_`st'=total(was_`st')
	}

/* Average duration of stages across countries */
/* for cross-country average we need to choose the denominator carefully */
foreach st in A B C D E {
	egen cstage_dur_`st' = total(stage_dur_`st'*(stage=="`st'")) if stage=="`st'"
	replace cstage_dur_`st' = cstage_dur_`st' / tot_`st'
	sort cstage_dur_`st'
	replace cstage_dur_`st'=cstage_dur_`st'[_n-1] if cstage_dur_`st'==.
	}


/* End of do file */
