/*---------------------------------------------------------------*
	Regional Pandemia
* Purpose: Script store paths and settings to run scripts.
* Created by: Nicolas Herrera L.
* Created on: 4/6/2020
* Last modified on: 4/6/2020
* Last modified by: NHL
* Edits history:

---------------------------------------------------------------*/

/*---------------------------------------------------------------
  Globals to paths
---------------------------------------------------------------*/

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
global census_br "$db_inp/individual_level_data/brazil"
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

/*---------------------------------------------------------------
  General settings
---------------------------------------------------------------*/

/* Set the scheme of colors for the figures */
set scheme plotplainblind

/* Execute a code with a set of programs coded for this project */
include $db_scr/programs.do

/* The following global stores the names of the packages used in the project
to check their existance and installe them if they are not */
global packages "blindschemes gtools parallel ineqdeco"

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
