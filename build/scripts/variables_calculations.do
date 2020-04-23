* Covid policies blog analysis
* JP Chauvin
* April 17, 2020

***************



/*



*/


/* Collapses */



#delimit ;
















*reshape long polgen polext polextgen, i(ccode) j(sch_close)


/*

foreach i in A B C D E {

	sort country stage date
	by country stage: egen firstdate = min(date) if stage!=""
	by country stage: egen lastdate = max(date) if stage!=""
	sort country date
	replace stage="`i'" if date>=firstdate & date<=lastdate
	drop firstdate lastdate
}


* Correct for false Ds;
if stage=="" & stage[_n-1]=="D" & increasing==1 & increasing[_n+1]==1 & high==1 {;
	qui replace stage="C";
	local j = 1;
	while stage[_n-`j']=="D" {;
		replace stage[_n-`j']="C";
		local i = `i'+1;};};

/*
