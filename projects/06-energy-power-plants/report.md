# Global Power Plants: Where the Energy Transition Actually Stands

**Author:** Michael Udousoro, Data Analyst
**Dataset:** World Resources Institute, Global Power Plant Database
**Scope:** 28,664 power plants, 164 countries, roughly 80% of world generation capacity

## Executive summary

This report uses a global database of power plants to answer three questions about the world's shift away from fossil fuel electricity. Which countries are furthest along, and furthest behind. What the age of the existing fossil fleet implies about how much infrastructure needs replacing to meet climate targets. And how much we can actually trust the public data behind these questions, since large parts of it are missing.

The data shows a transition that is real but far from complete. Renewable power plants already outnumber every other type combined, but because they tend to be small and distributed, they still make up only a quarter of total generation capacity. The countries furthest ahead are mostly blessed with hydropower geography rather than uniquely ambitious policy, and the countries furthest behind are almost entirely oil and gas producing states. Fossil fuel has added more new generation capacity than renewables in every decade since the 1950s, including the most recent one in this dataset, though renewable's share of new capacity has grown steadily. And crucially, the newer and more distributed a technology is, the worse it is documented, which means some of the more optimistic readings of "the fossil fleet is aging out" need to be treated with real caution.

## 1. Introduction

An affordable, reliable, and environmentally sustainable power sector sits at the centre of almost every other policy goal a country has, from economic growth to public health to climate commitments. Every new power plant that gets built locks in decades of emissions, water use, and air quality impact, and every plant that gets retired removes them. Understanding the current shape of the global power fleet, not just the announcements and targets around it, is the starting point for any serious energy or climate analysis.

This report works directly from plant-level data rather than aggregated national statistics, because plant-level data lets you see things that country totals hide: how big individual projects are, how old specific technologies are, and where the gaps in reporting actually sit. Three research questions guide the analysis:

1. Which countries are furthest along the renewable transition, and which are furthest behind?
2. What does the age profile of the fossil fleet imply about the scale of infrastructure replacement needed to meet climate targets?
3. How reliable is public reporting on power plant data, and does that reliability vary by fuel type or region?

Each question was chosen because it is answerable with the columns available in this dataset (capacity, location, fuel type, commissioning year), because it connects directly to a real decision someone in energy policy or utility planning would need to make, and because, as the findings show, each one turns out to have a genuine limitation worth stating plainly rather than glossing over.

## 2. Data and method

The dataset covers 28,664 individual power plants across 164 countries, with capacity, location, fuel type, ownership, and (where available) commissioning year and generation output. It was compiled by the World Resources Institute from national and regional sources including the U.S. Energy Information Administration, the UK's Department for Business, Energy and Industrial Strategy, Brazil's national electricity regulator, and dozens of other official statistical agencies, which gives it strong provenance even where individual fields are incomplete.

Three cleaning steps were applied, each documented rather than done silently. First, 17 rows, all located in China, had a latitude or longitude outside the physically possible range, several of them looking like a dropped decimal point (a value of 1,075,744 is almost certainly meant to read 107.5744). Rather than guess at the correct value, these coordinates were set to missing, which removes those plants from map-based analysis only; every other column for those rows remains usable. Second, no missing values were filled in. Roughly 48% of plants have no recorded commissioning year, and around 37% have no recorded owner. These gaps are treated as real facts about what is and is not publicly documented, not as noise to be smoothed over, and are excluded from each specific analysis that needs them rather than guessed at. Third, a fuel category was derived from the primary fuel type: Renewable (hydro, solar, wind, geothermal, wave and tidal), Fossil (coal, gas, oil, petcoke, cogeneration), Nuclear, and Other (biomass, waste, storage). Biomass and waste were deliberately kept out of the renewable category, since their actual climate impact depends heavily on the feedstock and combustion technology used, and lumping them in with hydro, solar, and wind would overstate how much of the world's capacity is genuinely clean.

All analysis was carried out in Python using pandas for data manipulation, matplotlib and seaborn for static charts, and Plotly for the world map, which needed to plot 28,000-plus individual coordinates on a real map projection.

## 3. Research question 1: which countries are furthest along the transition?

To avoid a ranking dominated by a single small country running on one hydro dam, this question was restricted to the 73 countries with at least 5 gigawatts of total installed capacity, then ranked by the share of that capacity coming from renewable sources.

The countries furthest ahead are Paraguay (100% renewable, built almost entirely on the Itaipu hydroelectric dam it shares with Brazil), Norway (96%), Tajikistan (88%), New Zealand (83%), and Austria (82%). Every one of these is a country with substantial hydropower resources. Brazil (74%) and Switzerland (74%) also lean heavily on hydro. This is an important nuance: the leaderboard for renewable capacity share is, to a large extent, a leaderboard for hydropower geography, not a pure measure of climate policy ambition.

The bottom of the table is dominated by oil and gas producing states: the United Arab Emirates (0.4%), Algeria (0.2%), and then Saudi Arabia, Kuwait, Bahrain, Qatar, and Libya, all essentially at 0%. Two non-Gulf states, Hungary and Belarus, also appear at the bottom, reflecting a fossil-and-nuclear-heavy grid inherited from a different energy era rather than resource geography specifically.

One important caveat applies here. This dataset's vintage is roughly 2017 to 2018. Several Gulf states shown at the bottom of this ranking have since announced or completed large solar projects, so this snapshot reflects the starting point of the transition in those countries, not necessarily where they stand today. Any policy conclusion drawn from this chart should be checked against more recent capacity data before being acted on.

## 4. Research question 2: what does fleet age imply about the pace of replacement needed?

Restricted to the 14,952 plants with a known commissioning year (52% of the dataset), the renewable fleet has a median age of 10 years against the fossil fleet's median of 18 years, with nuclear the oldest category by far at a median of 34 years. On the surface this looks like a clean story: renewables are new, fossil is aging out.

The full picture is more interesting than the medians alone suggest. The renewable category's age distribution is far wider than any other category, spanning from a handful of years up to plants nearly a century old, because "renewable" mixes brand-new solar and wind installations with hydroelectric dams that were built decades ago and are still running. Mean age for renewables (24.5 years) is actually close to fossil's mean (23.0 years), even though the median is much lower, which is the signature of a distribution with two distinct clusters rather than one smooth trend.

Looking at capacity added by decade tells a related but distinct story. Fossil fuel has added more new generation capacity than renewables in every single decade since the 1950s, including the 2010s (a partial decade in this data, running only through 2018). What has changed is the share: renewable capacity was 15% of new additions in the 2000s and rose to 28% in the 2010s. The transition in new-build capacity is real and it is accelerating, but as of this dataset it had not yet overtaken fossil fuel, and framing it as already having done so would overstate the current pace of change.

For infrastructure planning, this matters directly. A fossil fleet with a median age of 18 years is not yet at the point of mass retirement (most fossil generation technologies run for 30 to 40 years or more), which means the "replacement wave" that climate policy is counting on to bring emissions down is still mostly ahead, not behind, us.

## 5. Research question 3: how reliable is the underlying data?

This question exists because research question 2 cannot be trusted at face value without checking it. Solar, biomass, and wind plants are missing a commissioning year for 60 to 64% of records. Nuclear is missing it for just over half. Hydro, despite being the oldest and most established renewable technology, is still missing it for 48%. By contrast, coal, oil, and cogeneration, generally larger, older, more heavily regulated utility-scale technologies, are missing a commissioning year for only 25 to 37% of records.

The direct implication is that the age comparison in research question 2 is drawn from the better-documented half of each fuel category, and that better-documented half likely skews toward larger, more formally regulated, and probably older individual plants within each category, since those are the ones most likely to appear in official national statistics in the first place. This does not invalidate the finding that renewables have a younger median age. It does mean the finding should be read as "among the renewable plants we have good records for," not as an unconditional statement about every renewable plant on earth.

This pattern also has a standalone policy implication, separate from research question 2. As electricity generation becomes more distributed, with more small solar and wind installations built by a wider range of private developers rather than a handful of large utilities, the public data available for grid planning, reliability analysis, and emissions accounting is at real risk of getting less complete over time, not more, unless reporting requirements are extended to match how the generation mix is actually changing.

## 6. Discussion

Put together, these three questions tell a coherent story. The renewable transition is well underway by plant count (62% of all plants in this dataset are renewable) but still a minority by capacity (25%), because the technologies driving that plant count, mostly small-scale solar and wind, add capacity in far smaller individual increments than the coal, gas, and nuclear plants they are gradually displacing. The transition is proceeding fastest in countries with strong hydropower resources rather than uniformly across all committed nations, and slowest in fossil fuel producing states, which is exactly what an economically rational transition path would look like even before accounting for policy differences. And the transition's real pace of change, while genuinely accelerating, is being observed through a reporting system that is systematically thinner for the very technologies driving that change, which argues for caution in how confidently any single number from this analysis, or any similar one, should be treated as the final word.

## 7. Limitations

Four limitations apply across this whole analysis. First, the dataset's vintage is roughly 2017 to 2018, and renewable buildout has continued at pace since then, particularly in the Gulf states and in China, so current-day figures would likely show a materially different picture at the country level. Second, almost half of all plants have no recorded commissioning year, and that gap is not evenly spread across fuel types, which limits how far any age-based conclusion can be generalised. Third, this analysis works from installed capacity, not actual electricity generated, cost of generation, or emissions; a plant's capacity is a ceiling on its output, not a measure of it, and a full assessment of the transition would need generation and emissions data alongside capacity data. Fourth, the renewable, fossil, and other groupings used here are reasonable but not the only valid classification; treating biomass or cogeneration differently would shift some of the percentages reported, though not the overall direction of the findings.

## 8. Conclusion

The global energy transition, as seen through this dataset, is genuine, measurable, and still incomplete. Renewables dominate by plant count and are growing their share of new capacity every decade, but fossil fuel still adds more new capacity than renewables do, the leaders in renewable share owe much of their position to hydropower geography rather than policy alone, and the data needed to track all of this closely is weakest in exactly the technologies that matter most going forward. Any organisation using data like this to plan investment, set targets, or benchmark progress should treat the headline percentages as a genuine signal, and the gaps behind them as an equally important part of the story.

## References

1. World Resources Institute, "Global Power Plant Database," 2018. [Online]. Available: https://datasets.wri.org/dataset/globalpowerplantdatabase
2. U.S. Energy Information Administration, "International Energy Statistics." [Online]. Available: https://www.eia.gov
3. International Energy Agency, *World Energy Outlook 2023*. Paris: IEA, 2023.
4. International Renewable Energy Agency, *Renewable Capacity Statistics 2023*. Abu Dhabi: IRENA, 2023.
5. C. McGlade and P. Ekins, "The geographical distribution of fossil fuels unused when limiting global warming to 2 degrees C," *Nature*, vol. 517, pp. 187 to 190, 2015.
