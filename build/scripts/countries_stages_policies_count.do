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

use "$db_out/pol_countries_stages", clear

/*************************************************/
 /* Homecleaning                    */
 /*************************************************/

 keep ccode stage polgen* polext* polextgen*
 reshape long polgen polext polextgen, i(ccode stage) j(policy_str) string
 
/* New variables  */

 g pol_none = 0
 replace pol_none = 1 if polgen==0

 g pol_base = 0
 replace pol_base = 1 if polgen==1 & polext==0

 /*************************************************/
  /* Collapse country aggregates                    */
  /*************************************************/

  #delimit ;
  collapse (max)
  polgen polext polextgen pol_none pol_base
  , by (ccode stage policy_str);
  sort policy_str;
  encode policy_str, gen(policy);

/*************************************************/
 /* Generate log and relative variables       */
 /*************************************************/

g pol_int = polext ;

g policy_cat = .;
	replace policy_cat = 4 if policy==8 | policy==9 | policy==6;
	replace policy_cat = 1 if policy==2 |  policy==10;
	replace policy_cat=2 if policy==7 |  policy==12 | policy==5  | policy==4;
	replace policy_cat=3 if policy==1 |  policy==2 | policy==11 ;

foreach var in polgen polext polextgen pol_none pol_base pol_int {;
	bysort stage policy: egen  stage_`var'_count=total(`var'); };

/*************************************************/
 /* Labeling                    */
 /*************************************************/

 #delimit cr
 lab var pol_none "Not implemented"
 lab var pol_base "Implemented moderately"
 lab var pol_int "Implemented intensively"
 lab var stage_polgen_count "Countries that have applied the policy"
 lab var stage_polext_count "Countries that have applied the policy strictly"
 lab var stage_polextgen_count "Countries that have applied the policy strictly for the general public"
 lab var stage_pol_none_count "Countries that have not implemented it"
 lab var stage_pol_base_count "Countries that have implemented it moderately"
 lab var stage_pol_int_count "Countries that have implemented it intensely"

 lab define pol_lab 7 "School closing", replace
 lab define pol_lab 12 "Workplace closing", add
 lab define pol_lab 5 "Cancel public events", add
 lab define pol_lab 10 "Cancel public transport", add
 lab define pol_lab 6 "Public info campaigns", add
 lab define pol_lab 4 "Restrictions on internal movement", add
 lab define pol_lab 3 "International travel controls", add
 lab define pol_lab 1 "Fiscal stimulus", add
 lab define pol_lab 2 "Emergency health investment", add
 lab define pol_lab 11 "Vaccine development investment", add
 lab define pol_lab 8 "Testing policy", add
 lab define pol_lab 9 "Contact tracing", add
 lab val policy pol_lab

 lab define polcat_lab 4 "Information", replace
 lab define polcat_lab 2 "Social distancing", add
 lab define polcat_lab 1 "Mobiliy", add
 lab define polcat_lab 3 "Emergency investments", add
 lab val policy_cat polcat_lab

 lab var policy_cat "Policy category"
 lab var policy_str "Policy"
 lab var policy "Policy"
 lab var polgen "Policy applied with any intensity and scope"
 lab var polext "Policy strictly applied"
 lab var polextgen "Policy strictly applied to general public"

  /* Order and save */
  sort ccode stage policy
  order ccode stage policy
  save "$db_out/pol_countries_stages_policies", replace


/* End of do file */
