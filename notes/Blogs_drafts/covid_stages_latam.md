#  On the state of the curve in the data

As the first infection wave of COVID-19 advances across the globe, more data becomes available that can help us  better understand where we are, how we arrived here, and what may be on the horizon. This blog post, the first of a series, explores what widely-available data can tell us about how the "curve" of the virus has progressed in different regions, and where Latin American and Caribbean countries stand, as plans to gradually reopen their locked-down economies [start to emerge](https://www.nytimes.com/reuters/2020/04/27/world/americas/27reuters-health-coronavirus-costa-rica.html).

## Five observable stages of a wave of COVID-19 spread

Let us start by defining five stages for a COVID-19 wave in a country, illustrated in Figure 1. These are largely based on the [Pandemic Intervals Framework](https://www.cdc.gov/flu/pandemic-resources/national-strategy/intervals-framework.html) from the U.S. Centers for Disease Control and Prevention (CDC) but are constructed in terms of data from the current wave of the pandemic that is publicly available for most countries.

* **Stage A: No cases detected.** The period between the day the disease was [first reported in China](https://www.cidrap.umn.edu/news-perspective/2019/12/news-scan-dec-31-2019) (on December 31st, 2019) and the day of the first confirmed case in the country. Including this stage in the analysis is important from the policy standpoint, since multiple countries [already started implementing response policies ](https://www.devex.com/news/as-global-cases-climb-latin-america-readies-for-coronavirus-response-96620) before having any confirmed cases.
* **Stage B: Slow spread.** The period between the first recorded case, and the day the daily number of confirmed cases crosses a low-levels threshold (in this application, when it becomes larger than one per million people).
* **Stage C: Accelerating spread.** The period in which the daily confirmed cases remain high (above one per million) and consistently increasing. It ends at the peak of the infection wave, once the number of cases starts to drop.
* **Stage D: Decelerating spread.** The period in which the daily confirmed cases remain high but are consistently decreasing.
* **Stage E: Stable low levels.** The period after the daily confirmed cases goes back to low levels (below one per million) and is not consistently increasing.

**Figure 1. Observable stages of COVID-19 spread**
![](assets/covid_stages_latam-9acdb8d.png)

This is, of course, a highly-stylized representation of reality, and it fails to capture a number of special cases. Moreover, the data on daily new confirmed cases has [important measurement issues](https://ourworldindata.org/coronavirus#cases-of-covid-19-background).  There are delays between the original recording and the official counting and reporting. It is only possible to detect an infection if the person is tested, but tests are not widely available. And the severity of these concerns varies from one country to another. Hence, readers should [not think of this measure](https://www.nytimes.com/2020/02/18/opinion/coronavirus-china-numbers.html) as an accurate portrayal of the number of people actually infected with the virus on a given date.  However, it is one of the indicators most readily-available to policymakers in real-time, and a large number of policy responses to the crisis (including the [official U.S. suggested criteria](https://www.whitehouse.gov/openingamerica/#criteria) for lifting mobility restrictions after the peak of infections) have been informed, at least partially, by this measure. I provide further details on how stages are identified in the data and of the limitations of this analysis in the accompanying [white paper](https://github.com/jpchauvin/covid_policies/drafts/covid19_infection_wave_and_policies.pdf).

## What stage are countries currently in?

Equipped with this framework and using data on a sample of countries with a population of 250 thousand or larger compiled by [Our World in Data](https://ourworldindata.org/coronavirus), let us look at the state of the current COVID-19 wave around the world.

As of April 27th, most countries in the sample are at stages B and C (see Figure 2). Noticeably, most countries at the slow spread stage are from Africa, with a few exceptions coming from Asia and Oceania. While the availability of better information (relative to the first group of affected countries) could help, the African continent faces the upcoming acceleration of the spread with a dire scarcity of infrastructure, equipment, and medical personnel, and substantive international support is needed to placate the [potentially catastrophic effects of the pandemic](https://www.reuters.com/article/us-health-coronavirus-africa-un/at-least-300000-africans-expected-to-die-in-pandemic-u-n-agency-idUSKBN21Z1LW).

In Latin America and the Caribbean, the only country that appears to still be at stage B is Nicaragua. Most other countries are already in the stage of accelerating community spread, and a few appear to have passed the peak of the wave (Chile, Costa Rica, Guyana, and Peru) or even reached a stage of stable low levels of infections (Barbados and Trinidad and Tobago).  Even though movements beyond the peak of the wave are encouraging, it is still unclear if they are stable. As [recent Asian experiences](https://www.axios.com/japan-singapore-coronavirus-infections-a617efde-3e04-4baf-9a65-377f10454acf.html) show, countries that appear to have reached the end of the current wave can experience new strong surges in infections.

While most of the countries at advanced stages of the wave (D and E) are in Asia and Europe, they still represent a small fraction in their regions.  There too, the majority of nations are still experiencing accelerating spread. The U.S. and Canada were also in that group as of April 27th, but had already started seeing days of (still non-sustained) deceleration in daily confirmed cases, and seemed poised to enter stage D.

**Figure 2. Number of countries in each stage of spread**
![](assets/covid_stages_latam-237ce0e7.png)

## Stages duration across countries

 While it is too soon to be able to precisely characterize the behavior of all stages, the data available thus far suggests that COVID-19 waves can follow very different paths. Figure 4 reports the average number of days spent at each stage by countries of a given region in the world. The low average durations of stages D and E are not very informative, as they reflect the fact that most countries in those stages entered them very recently. But the duration of the first three stages, for which there is already meaningful information, reveal clear differences across regions of the world.

**Figure 3. Stages duration around the world**
![](assets/covid_stages_latam-6996dab0.png)

The U.S. and Canada reported their first confirmed cases already in late January with five days of difference, and their curves progressed at a similar pace. In both cases, stage B lasted around 50 days, and as of April 27th, they had been at stage C for just over 40 days.  In contrast, the average Asian country reported its first case in the second half of February, went through a shorter stage B, with an average of around 30 days, and so far has had an even shorter stage C, although the latter may still change.

Latin American and Caribbean countries appear to have followed yet a different path. Like in Asia, most of them experienced a short stage B after a relatively late announcement of the first confirmed case. However, most countries have seen a noticeably longer stage C (see Figure 4).  Conversely, compared to the U.S. and Canada, the first coronavirus case in the region was reported [over a month later](https://www.nbcnews.com/news/world/first-coronavirus-case-latin-america-confirmed-brazil-n1143411).  Nonetheless, most of Latin America and the Caribbean entered stage C at around the same time as the North-American countries.

**Figure 4. Stages duration in Latin America & the Caribbean**
![](assets/covid_stages_latam-0812b4f9.png)

The fact that Latin American and Caribbean countries appear to have gone from their first confirmed case to the accelerated spread stage in a very short time could indicate that the initial outbreak propagated faster than elsewhere. Analysts have pointed to structural characteristics that make the region more vulnerable than others to the pandemic, including large shares of urban populations living in crowded [informal settlements](https://blogs.iadb.org/ciudades-sostenibles/en/10-lines-of-action-and-20-measures-to-mitigate-the-spread-of-the-coronavirus-in-informal-settlements/) and working in [informal jobs](https://blogs.iadb.org/ideas-matter/en/social-distancing-informality-and-the-problem-of-inequality/) that only allow them to live hand to mouth, and make social distancing extremely difficult.

Another non-mutually exclusive explanation is that the virus has been present in the region for longer than is currently believed, and countries were late to detect it. This is certainly plausible: recent evidence from autopsies in California showed that the virus had spread in the U.S. [weeks earlier than originally thought](https://www.washingtonpost.com/nation/2020/04/22/death-coronavirus-first-california/). Even though there is no comparable evidence collected in Latin American countries at the time of writing, the relative duration of the stages of the COVID-19 spread can provide some clues. Across the world, as shown in Figure 5, countries that reported their first case relatively late (i.e. had a longer stage A) saw a shorter period of slow spread (i.e. stage B). This includes nations with different levels of structural vulnerability to the pandemic.  The correlation between the duration of stages B and C is also negative but much weaker. While this is far from conclusive evidence, it is consistent with the hypothesis that, during the first couple of months of the pandemic, many countries may have detected the virus only weeks after the spread in their territories had begun.

**Figure 5. Correlations of stage durations**
![](assets/covid_stages_latam-609a78c1.png)

In the next blog post of this series, I will explore the policy priorities adopted by countries at each stage. This can be useful to anticipate the need for financial and other resources, either for countries that are at the early stages of the first wave or in the event of new future waves.

***Note.** The data underlying this analysis are rapidly changing and may become outdated. You can find a version of the figures above using more up-to-date data [here](https://github.com/jpchauvin/covid_policies).*
