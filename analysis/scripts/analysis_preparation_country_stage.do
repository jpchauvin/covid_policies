/***********************************************************************
 * Government Policies along the COVID infection wave
 * Juan Pablo Chauvin

 * Purpose: Prepare country-stage data for analysis
 * Created by: Juan Pablo Chauvin
 * Created on: 04/21/2020
 * Last modified on: 02/21/2020
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

/*************************************************/
 /* Calculating additional variables                    */
 /*************************************************/

  bysort stage: egen a_duration=mean(stage_duration)
  	lab var a_duration "Mean duration of stage across countries"

  gen a_duration_lac = a_duration if subregioncode==419
  	lab var a_duration_lac "Mean duration of stage in LAC"

  gen a_duration_nlac = a_duration if subregioncode!=419
  	lab var a_duration_nlac "Mean duration of stage outside LAC"

foreach st in A B C D E {
	g stage_dur_`st' = .
	replace stage_dur_`st' = stage_duration if stage=="`st'"
	sort ccode stage_dur_`st'
	replace stage_dur_`st'=stage_dur_`st'[_n-1] if stage_dur_`st'==. & ccode==ccode[_n-1]
}


/* End of do file */
