#  How government policies change as COVID moves stages

As COVID-19 has progressed, governments around the word have responded with a series of government responses.

## Five "observable" stages

The folder structure following the notation of (Asher & Novosad, 2018), which is described on the `RA_manual.pdf` file. This is the same folder structure of the Dropbox shared folder.

The main advantage of git repositories is that they're  useful to control the version of the codes. For example, if a new code causes a bug, it is possible to roll back to the previous version.

The main difference between this repository and the Dropbox shared folder is that in git repositories we don't store large files. For instance, GitHub will warn you for any file larger than 50MB and will deny any push larger than 100MB.

## Where are countries?

At the time of writing, most countries in the world are still in the stage of accelerating community spread.  This includes most countries in Latin America with the exception of Chile and Ecuador, whom appear to have entered a decelerating stage.


![Countries today](https://github.com/jpchauvin/covid_policies/analysis/outputs/graphs/countries_today_24-Apr-2020.png)

## Running R scripts

To run R scripts, one must first have [R installed on the computer](https://cran.r-project.org/). The `R` files will be stored inside `build/scripts/R` subfolder. It'll have a `rundirectory.R` file to run all the data munging scripts to generate the output files.
