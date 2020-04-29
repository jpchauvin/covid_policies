# Government Policies along the COVID infection wave

This is the git repository for the white paper *"Global Policy Responses Along the First COVID-19 Infection wave"* and the related blog posts.

This analysis is work in progress, if you find mistakes in the code please let us know! Direct any communication to the white paper's corresponding e-mail.

## Paper and corresponding blog posts

* You can obrain the most recent version of the white paper [here](drafts/covid19_infection_wave_and_policies.pdf).
* Blog post: Where is Latin America and Caribbean on the COVID-19 Curve?
* Blog posts figures [updated with more current data](updates/cblog_posts_updates.md).

## Folders and replication

This repository contains all the necessary scripts to replicate the analysis. They are all written in Stata.

The folder "build" contains the necessary scripts to build the working datasets starting from the original data files downloaded from public sources.  To replicate the construction of these files from scratch run build/scripts/rundirectory.do

The folder "analysis" contains the necessary scripts to replicate the analysis reported in the white paper and the related blog posts. To replicate only this part, first make sure that the outputs of the built process exist in build/outputs, and run analysis/scripts/rundirectory.do
