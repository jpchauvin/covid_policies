/***********************************************************************
 * Government Policies along the COVID infection wave
 * Juan Pablo Chauvin

 * Purpose: Pre-process COVID variables from Our World in Data dataset
 * Created by: Juan Pablo Chauvin
 * Created on: 04/18/2020
 * Last modified on: 02/21/2020
 * Last modified by: JPCR
 * Edits history:

  **************************************************************************/

/*************************************************/
 /* COVID deaths dataset                        */
 /*************************************************/

 insheet using "$db_inp/new-covid-deaths-per-million.csv", comma clear

 /* Homecleaning */
 rename date date2
 gen date=date(date2, "MDY")
 format date %td
 drop entity
 rename daily deaths_new_1M
 label var deaths_new_1M "Daily new confirmed deaths per million"
 rename code ccode
 drop date2
 drop if ccode==""
 order ccode date
 encode ccode, gen(country)

 /* Set up time series */
 tsset country date
 tsfill,full
 replace deaths = 0 if deaths==.  // check in the end if this makes sense

/* Calculate cummulative dates */
 by country: g cum_deaths = sum(deaths_new_1M)
 lab var cum_deaths "Cumulative deaths per 1 million population"

/* Organize and save */
 decode country, g(ccode2)
 replace ccode=ccode2
 drop ccode2 country

 save "$db_out/covid_deaths", replace


/*************************************************/
 /* COVID cases and stages dataset              */
 /*************************************************/

 insheet using "$db_inp/new-covid-cases-per-million.csv", comma clear


/* Homecleaning                    */
 /**********************************/

 rename date date2
 gen date=date(date2, "MDY")
 format date %td
 drop entity
 rename daily cases_new_1M
 label var cases_new_1M "Daily new confirmed cases per million"
 rename code ccode
 drop date2
 drop if ccode==""
 order ccode date
 encode ccode, gen(country)

  /* Set up time series */
 tsset country date
 tsfill,full
 replace cases = 0 if cases==.  //may be very consequential but keep it for now

/* High daily cases (at least one per million) */
 g high = 0
 replace high = 1 if cases >=1
 lab var high "Daily new cases above 1 per 1 million people"


/* Growth variables                    */
 /***************************************/

 sort country date
 tssmooth ma l5_cases = cases_new_1M , window (4 1 0)
 lab var l5_cases "Five-days rolling average of daily cases"

 g day_increase=l5_cases-l5_cases[_n-1] if country==country[_n-1]
 lab var day_increase "Current rolling average minus yesterday's rolling average"

 tssmooth ma ra_increase = day_increase if country==country[_n-1], window (4 1 0)
 lab var ra_increase "Five-days rolling average of daily increases"

 g increasing = 0
 replace increasing = 1 if ra_increase>=0 & country==country[_n-1]
 lab var increasing "Number of cases is not decreasing"

 g decreasing = 0
 replace decreasing = 1 if ra_increase<0 & country==country[_n-1]
 lab var decreasing "Number of cases is decreasing"

/* Accumulated number of cases */
 by country: g cum_case = sum(cases_new_1M)


/* Stage computations                    */
 /****************************************/

 g stage = ""

 #delimit ;

/* Loop over each country */
levelsof country, local(cty);

foreach i of local cty {;
  * Stage A;
  qui replace stage="A" if cum_case==0 & country ==`i';

  * Stage B;
  qui replace stage="B" if
   	cum_case>0
   	& (high==0
   	| (high==1 & high[_n-1==0] & high[_n+1]==0)
   	| (high==1 & high[_n-2==0] & high[_n+2]==0)
   	| (high==1 & high[_n-2==3] & high[_n+3]==0))
   	& (  ((stage[_n-1]=="A" | stage[_n-1]=="B") & high==0)
   	  | ((stage[_n-2]=="A" | stage[_n-2]=="B") & high==0)
   	  | ((stage[_n-3]=="A" | stage[_n-3]=="B") & high==0)
   	  | date==21914)
   	& stage==""
   	& country ==`i';
   * Stage B filling in;
   qui replace stage="B" if stage==""
   	& ((stage[_n-1]=="B" & stage [_n+1]=="B")
   	| (stage[_n-2]=="B" & stage [_n+2]=="B"));

   * Stage C;
   qui replace stage="C" if
   	 (high==1
   	| (high==0 & high[_n-1==1] & high[_n+1]==1)
   	| (high==0 & high[_n-2==1] & high[_n+2]==1)
   	| (high==0 & high[_n-3==1] & high[_n+3]==1))
   	& (increasing==1 | (increasing==0 & decreasing==0)
   		| (increasing[_n-1]==1 & increasing[_n+1]==1)
   		| (increasing[_n-2]==1 & increasing[_n+2]==1)
   		| (increasing[_n-3]==1 & increasing[_n+3]==1))
   	& stage==""
   	& country ==`i';
   * Stage C filling in;
   qui replace stage="C" if stage==""
   	& ((stage[_n-1]=="C" & stage [_n+1]=="C")
   	| (stage[_n-2]=="C" & stage [_n+2]=="C"));

   * Stage D;
   qui replace stage="D" if
   	 (high==1
   	| (high==0 & high[_n-1==1] & high[_n+1]==1)
   	| (high==0 & high[_n-2==1] & high[_n+2]==1)
   	| (high==0 & high[_n-3==1] & high[_n+3]==1)
   	| (high==0 & stage[_n-1]=="C"))
   	& (stage[_n-1]=="C" | stage[_n-1]=="D")
   	& (decreasing==1 | (decreasing[_n-1]==1 & decreasing[_n+1]==1)
   	| (decreasing[_n-2]==1 & decreasing[_n+2]==1)
   	| (decreasing[_n-3]==1 & decreasing[_n+3]==1))
   	& stage==""
   	& country ==`i';
   	* Stage D filling in;
   qui replace stage="D" if stage==""
   	& ((stage[_n-1]=="D" & stage [_n+1]=="D")
   	| (stage[_n-2]=="D" & stage [_n+2]=="D"));

    * Stage E;
   qui replace stage="E" if
   	(high==0
   	| (high==1 & high[_n-1==0] & high[_n+1]==0)
   	| (high==1 & high[_n-2==0] & high[_n+2]==0))
   	& (stage[_n-1]=="D" | stage[_n-1]=="E")
   	& stage==""
   	& country ==`i';
   	* Stage E Filling in;
   qui replace stage="E" if stage==""
   	& ((stage[_n-1]=="E" & stage [_n+1]=="E")
   	| (stage[_n-2]=="E" & stage [_n+2]=="E"));

   * Correct for false Ds;
   if stage=="" & stage[_n-1]=="D" & increasing==1 & increasing[_n+1]==1 & high==1 {;
   	 qui replace stage="C";
   	 local j = 1;
   	 while stage[_n-`j']=="D" {;
   		replace stage[_n-`j']="C";
   		local i = `i'+1;};
      };
 	  };

/* Merge to policy variables */
 decode country, g(ccode2);
 replace ccode=ccode2;
 	merge 1:1 ccode date using "$db_out/oxford_policies.dta";

/* Smooth temporary transitions to a different stage */
 sort country stage date;
 by country stage: egen firstdate = min(date) if stage!="";
 by country stage: egen lastdate = max(date) if stage!="" ;
 sort country date ;

/* Assign all days between first and last date of each stage */
 foreach i in A B C D E {;
 	foreach k in firstdate lastdate {;
 	g `k'_`i'= `k' if stage=="`i'";
 	replace `k'_`i' = `k'_`i'[_n-1] if country==country[_n-1] & missing(`k'_`i');};
 	replace stage ="`i'" if date >= firstdate_`i' & date<=lastdate_`i' & stage!="`i'" ;
  };

 /* Fill in empty observations at transition points */
 	replace stage = "B" if stage[_n-1]=="B" & stage[_n+1]=="C" & high==0 & stage=="";
 	replace stage = "C" if stage[_n-1]=="B" & stage[_n+1]=="C" & high==1 & stage=="";
 	replace stage = "C" if stage[_n-1]=="C" & stage[_n+1]=="D" & increasing==1 & stage=="";
 	replace stage = "D" if stage[_n-1]=="C" & stage[_n+1]=="D" & decreasing==1 & stage=="";
 	replace stage = "D" if stage[_n-1]=="D" & stage[_n+1]=="E" & high==1 & stage=="";
 	replace stage = "E" if stage[_n-1]=="D" & stage[_n+1]=="E" & high==0 & stage=="";

 #delimit cr
 /* Merge-in deaths variables */
 drop _merge
 merge 1:1 ccode date using  $db_out/covid_deaths.dta
 drop if _merge==2
 drop _merge

 /* Stage durations */
 sort country stage
 by country stage: egen stage_duration = count(date)
 lab var stage_duration "Duration of stage (in days)"

 /* Additional labels */
 lab var stage "Stage of Covid wave"
 tab  stage, gen(s_)
 rename s_1 stage_A
 rename s_2 stage_B
 rename s_3 stage_C
 rename s_4 stage_D
 rename s_5 stage_E
 lab var stage_A "Stage A: No detected cases"
 lab var stage_B "Stage B: Outbreak"
 lab var stage_C "Stage C: Community spread accelerating"
 lab var stage_D "Stage D: Community spread decelerating"
 lab var stage_E "Stage E: Wave aftermath"

/* Order and save */
 sort country date
 drop if cum_case==.
 save "$db_out/policies_int_working_dataset.dta", replace

/*************************************************/
 /* Current stage dataset                    */
 /*************************************************/

 sort ccode
 by ccode: egen lastdate2 = max(date) if stage!=""
 keep if date==lastdate2
 g stage_current = stage
 g cum_cases_current = cum_case
 g cum_deaths_current = cum_deaths
 g days_current = stage_duration

 lab var stage_current "Current stage"
 lab var cum_cases_current "Current cumulative cases"
 lab var cum_deaths_current "Current cumulative deaths"
 lab var days_current "Number of days in current stage"

 keep ccode stage_current cum_cases_current cum_deaths_current

 save "$db_out/current_stage.dta", replace

/* End of do file */
