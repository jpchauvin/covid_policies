/***********************************************************************
* Government Policies along the COVID infection wave
* Juan Pablo Chauvin

* Purpose: Excecute the build stage of the project
* Created by: Juan Pablo Chauvin
* Created on: 4/18/2020
* Last modified on: 4/21/2020
* Last modified by: JPC
* Edits history:

* Notes:
   - The dropbox folder points to the root directory of any dropbox. We recommend
   to set the path in your profile.do to run smothly the code in any computer.
   - Stata 16 version

  **************************************************************************/

/*************************************************/
 /* Settings                                    */
 /*************************************************/

global dropbox "/nfs/home/J/jchauvin/shared_space/data_urb/covid_projects/"

/* Set the folder structure and install packages*/
do "$dropbox/covid_policies/build/scripts/settings.do"

/*************************************************/
 /* Working datasets generation                    */
 /*************************************************/

/* Country variables and identifiers */
do "$db_scr/countries_variables.do"

/* Build policies variables from Oxford dataset  */
do "$db_scr/policies_variables.do"

/* Build COVID variables from Our World in Data dataset  */
do "$db_scr/covid_variables.do"

/* Build Country-level  aggregates  */
do "$db_scr/countries_count.do"

/* Build Country-stage-level  aggregates  */
do "$db_scr/countries_stages_count.do"

/* Build Country-stage-policies-level  aggregates  */
do "$db_scr/countries_stages_policies_count.do"
/* End of do file */
