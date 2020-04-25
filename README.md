# Government Policies along the COVID infection wave
# Need to write more, this file corresponds to something else

This is the git repository for the Covid-19 expansion in LATAM cities task force.

## Folder structure

The folder structure following the notation of (Asher & Novosad, 2018), which is described on the `RA_manual.pdf` file. This is the same folder structure of the Dropbox shared folder.

The main advantage of git repositories is that they're  useful to control the version of the codes. For example, if a new code causes a bug, it is possible to roll back to the previous version.

The main difference between this repository and the Dropbox shared folder is that in git repositories we don't store large files. For instance, GitHub will warn you for any file larger than 50MB and will deny any push larger than 100MB.

## Warning

Do not sync the github repository with Dropbox, because the internal files inside `.git` repository confuses Dropbox sync algorithm, which could cause sync problems to the team.

## Running R scripts

To run R scripts, one must first have [R installed on the computer](https://cran.r-project.org/). The `R` files will be stored inside `build/scripts/R` subfolder. It'll have a `rundirectory.R` file to run all the data munging scripts to generate the output files.
