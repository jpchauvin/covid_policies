/***********************************************************************
* Government Policies along the COVID infection wave
* Juan Pablo Chauvin

* Purpose: Excecute the analysis stage of the project
* Created by: Juan Pablo Chauvin
* Created on: 4/20/2020
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
 /* Analysis                 */
 /*************************************************/

/* Produce country-stage figures */
do "$da_scr/country_stage_figures.do"

/* Produce country-policy figures */
do "$da_scr/country_policy_figures.do"

/*************************************************/
 /* Updated figures for blogs posts              */
 /*************************************************/

 /* Produce updated figures for blog posts */
 do "$da_scr/blog_posts_updates.do"

/* End of do file */
