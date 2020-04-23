/***********************************************************************
 * Government Policies along the COVID infection wave
 * Juan Pablo Chauvin

 * Purpose: Computing country-stage tables
 * Created by: Juan Pablo Chauvin
 * Created on: 04/21/2020
 * Last modified on: 02/21/2020
 * Last modified by: JPCR
 * Edits history:

  **************************************************************************/


/* Summary statistics */

foreach st in A B C D E {
	sum stage_duration if stage=="`st'"
	sum stage_duration if stage=="`st'" & subregioncode==419
	g stage_dur_`st' = .
	replace stage_dur_`st' = stage_duration if stage=="`st'"
	sort ccode stage_dur_`st'
	replace stage_dur_`st'=stage_dur_`st'[_n-1] if stage_dur_`st'==. & ccode==ccode[_n-1]
}

/* End of do file */ 
