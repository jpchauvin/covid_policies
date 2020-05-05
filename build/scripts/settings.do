/***********************************************************************
* Government Policies along the COVID infection wave
* Juan Pablo Chauvin

* Purpose: Script to define paths and settings for the project
* Created by: Juan Pablo Chauvin
* Created on: 4/18/2020
* Last modified on: 4/21/2020
* Last modified by: JPC
* Edits history:

* Notes:
   - The dropbox folder points to the root directory of any dropbox. We recommend
   to set the path in your profile.do to run smothly the code in any computer.
   - Stata 16 version
   - rd_root refers to the R disk. A large hard drive we have access at the IADB where
   we store large files. Available files upon request.

  **************************************************************************/

/* Root directory */
global dir "$dropbox/covid_policies"

/* Build folder */
global dbuild "$dir/build"
global db_inp "$dbuild/inputs"
global db_out "$dbuild/outputs"
global db_scr "$dbuild/scripts"
global db_tmp "$dbuild/temp"
global db_log "$dbuild/logs"
global mappings_br "$db_inp/municipality_level_data/brazil/mappings"
global census_br "$rd_root/data/brazil/ibge/census/datazoom"
global covid_br "$db_inp/municipality_level_data/brazil/covid"

/* Analysis folder */
global danalysis "$dir/analysis"
global dbuild "$dir/build"
global da_inp "$danalysis/inputs"
global da_out "$danalysis/outputs"
global da_scr "$danalysis/scripts"
global da_tmp "$danalysis/temp"
global da_log "$danalysis/logs"
global da_grs "$danalysis/outputs/graphs"
global da_tab "$danalysis/outputs/tables"

/* Paper and blogs folder */
global dd_fig "$dir/drafts/figures"
global dd_tab "$dir/drafts/tables"
global dd_blog "$dir/drafts/blog_posts/assets"
global dd_upd "$dir/updates/assets"

/*---------------------------------------------------------------
  General settings
---------------------------------------------------------------*/

/* Set the scheme of colors for the figures */
set scheme plotplainblind

/* The following global stores the names of the packages used in the project
to check their existance and installe them if they are not */
global packages "blindschemes gtools parallel ineqdeco catplot tabplot grc1leg"

/* Start a loop over the  */
foreach pack of global packages {

  /* Check if the package is already installed */
  cap which "`pack'"

  /* If the package is not found */
  if _rc == 111 {
    /* Install the package */
    ssc install "`pack'" , replace all
  }
}
