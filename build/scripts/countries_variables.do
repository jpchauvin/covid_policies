/***********************************************************************
 * Government Policies along the COVID infection wave
 * Juan Pablo Chauvin

 * Purpose: Pre-process international government responses Oxford dataset
 * Created by: Juan Pablo Chauvin
 * Created on: 04/17/2020
 * Last modified on: 02/21/2020
 * Last modified by: JPCR
 * Edits history:

  **************************************************************************/

/*************************************************/
 /* WDI variables                    */
 /*************************************************/

 insheet using "$db_inp/WDI_2018_pop_gdp.csv", comma clear

 drop if ccode==""
 drop cty_name

 save "$db_out/WDI_2018_pop_gdp", replace

/*************************************************/
 /* Mapping of countries to regions               */
 /*************************************************/

 insheet using "$db_inp/countries_regions.csv", comma clear
 keep ccode region subregion regioncode subregioncode
 drop if region==""

 save "$db_out/countries_regions", replace

/*************************************************/
 /* Mapping country codes - country names         */
 /*************************************************/

 insheet using "$db_inp/countries_regions.csv", comma clear
 keep ccode name
 drop if name==""

 save "$db_out/countries_names", replace

/* End of do file */
