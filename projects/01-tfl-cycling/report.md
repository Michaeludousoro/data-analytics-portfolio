# Santander Cycles: Demand and Rebalancing Analysis

**Prepared for:** TfL Network Planning and Rebalancing Operations
**Prepared by:** Michael Udousoro, Data Analyst
**Period covered:** 1 April to 31 May 2026

## Executive summary

This report analyses 1.67 million real trips on Santander Cycles, London's public bike share scheme, to answer the question a rebalancing team asks every day: where does demand pile up, where does it drain away, and how should bikes actually be moved between stations to keep the network usable.

The short version: demand follows a clear, predictable weekday commute pattern with morning and evening peaks, and a different, broader weekend leisure pattern. Station imbalance is not random. Stations in the City of London financial district reliably fill up with bikes through the working day, while major rail termini and park areas reliably drain. The busiest stations on the network are also disproportionately among the most imbalanced ones, which means the absolute number of bikes that need moving each day at those specific locations is large. E-bikes, now a fifth of all trips, are being used differently from classic bikes in a way that has direct implications for where to place them.

## 1. Introduction

A bike share network only works if bikes are where riders need them, and docking space is available where riders are going. Left alone, a network like this drifts toward the opposite of what riders want: stations that people ride to end up full, and stations that people ride from end up empty. A rebalancing team's job is to counteract that drift, and doing it well depends on knowing exactly which stations drift the most, and when.

This report uses TfL's own published trip data to answer four questions. When does demand actually happen, by hour and day. Which stations are chronically out of balance and need bikes physically moved in or out. Which stations carry the most overall network traffic. And whether the newer e-bike fleet is being used differently from the classic pedal bikes, since that affects where e-bikes should be prioritised.

## 2. Data and method

The analysis uses TfL's public cycle hire trip data for the two most recent months available at the time of this analysis, 1 April to 31 May 2026, roughly 1.67 million individual trips across 803 stations and over 12,000 bikes. TfL's full public archive runs back to 2012, but downloading and processing several years of data was not necessary to answer the questions in this report, and would have added tens of gigabytes for little extra insight into the current operating pattern. Two months is enough to see a full, repeating weekly cycle multiple times over, which is what the demand and imbalance questions actually need.

The data was loaded into a local DuckDB file directly from the raw CSVs, with no separate database server required, and queried in SQL. Every query used is saved in the project's `sql` folder in the order it was written, so the analysis can be rerun by anyone with the same source files.

One data quality step is worth noting. A small number of trips have implausible durations, either extremely short (likely a docking error rather than a real ride) or unrealistically long (likely a bike that was never properly returned). Where trip duration itself was the metric being analysed, these were filtered to a plausible range of 1 to 180 minutes; every other analysis in this report uses the full trip count, since station-level departures and arrivals are legitimate regardless of how long the bike was out.

## 3. When does demand actually happen?

Grouping every trip by the hour it started and the day of the week it fell on produces a clear, repeating pattern. On weekdays, Monday through Friday, trips spike sharply around 8am and again, more strongly, between 5 and 6pm, the two windows when Londoners are travelling to and from work. Outside those windows, weekday demand drops off substantially, though it never falls to zero even overnight. Weekends look structurally different: instead of two sharp peaks, there is one broad period of elevated demand spanning roughly late morning through late afternoon, consistent with leisure riding rather than commuting, with no sharp single peak hour.

This matters directly for rebalancing operations. A single average schedule applied every day would be wrong on both weekdays and weekends: it would be too thin during the two weekday rush hours and poorly timed for the single broad weekend peak. Any operational schedule built from this analysis should explicitly treat weekdays and weekends as two different patterns, not one blended average.

## 4. Which stations are chronically out of balance?

For every station, the number of arrivals was compared to the number of departures over the full two-month window, then divided by the number of days in that window to give an average net flow per day. A station that is strongly negative (more departures than arrivals) is one that riders keep draining bikes from faster than they return them, and will tend toward empty without intervention. A station that is strongly positive is one where bikes accumulate faster than they leave, and will tend toward full.

The pattern here is not random, and it lines up closely with the demand pattern in section 3. The stations that fill up most (Queen Street at Bank, St. James's Square, Brushfield Street near Liverpool Street, Hop Exchange in The Borough, Holborn Circus, Soho Square, Moorfields at Moorgate) are almost all in or immediately around the City of London's financial and commercial district. These are places people ride to for work in the morning and don't ride away from again until the evening commute, so bikes pile up steadily through the working day.

The stations that drain most (both Waterloo Station docks, Hyde Park Corner, Knightsbridge, Boston Place near Marylebone, Lancaster Gate at Bayswater) are almost entirely major rail termini and large park or leisure areas. People arrive at these locations by train or on foot and take a bike onward to their final destination, or set off on a leisure ride from a park entrance, and in neither case is a bike likely to be returned to that same spot soon afterward.

The direct operational implication is a rebalancing route, not a list of isolated problem stations: moving bikes from the City cluster where they accumulate to the termini and park cluster where they drain would relieve the network's two largest, most predictable pressure points in a single coordinated route, ideally run during the late morning to early afternoon lull between the two weekday commute peaks identified in section 3, when moving a van through central London causes the least disruption to riders already using the system.

## 5. Which stations carry the most overall traffic?

Ranking stations purely by departure volume identifies Hyde Park Corner and both Waterloo Station docks as the busiest points on the network, followed by a mix of central London locations including Kings Cross, Kensington Gardens, and London Bridge. What makes this finding operationally important is its overlap with section 4: several of the busiest stations by raw volume, particularly Hyde Park Corner and the Waterloo docks, are also among the most imbalanced. High volume and high imbalance compounding at the same location means the absolute number of bikes needing to move there each day is large in real terms, not just as a percentage of that station's own traffic, which should weight these locations toward the top of any prioritised rebalancing list.

## 6. Are e-bikes used differently from classic bikes?

E-bikes already account for 19.2% of all trips in this two-month window despite being a smaller portion of the fleet, and they show a genuinely different usage pattern from classic bikes. The average e-bike trip runs about two minutes longer than the average classic bike trip (19.4 versus 17.4 minutes), and e-bike trips are far less likely to be a round trip returning to the same station, 1.9% of e-bike trips compared to 3.2% of classic bike trips.

Taken together, this points to e-bikes being used more for genuine point-to-point travel, likely commuting and errands, and less for casual leisure loops that start and end in the same place. The practical implication for fleet planning is that e-bike availability should be prioritised at the same commute-heavy, imbalance-prone stations identified in sections 3 and 4, rather than spread evenly across the network or weighted toward the leisure-heavy park stations.

## 7. Limitations

Three limitations apply to this analysis. First, the two-month window covers spring conditions only. A full year of data would be needed to confirm whether the commute pattern in section 3 and the station imbalance pattern in section 4 hold through winter weather, when cycling volumes typically drop, and through the summer tourist season, when leisure riding in central London is likely to shift the balance further toward the park and termini stations already identified as drains. Second, the imbalance figures in section 4 are averaged across the whole window rather than broken down hour by hour, so they identify which stations need daily rebalancing attention overall, not the precise time of day a van should be dispatched; a real operational schedule would need to combine this finding with the hourly pattern in section 3 directly. Third, weather and local event data, which would help explain day-to-day spikes or dips in demand beyond the regular weekly pattern, was not available for this build and is a natural next addition.

## 8. Conclusion and recommendations

1. **Build two separate rebalancing schedules, one for weekdays and one for weekends**, rather than one average schedule, since the two show structurally different demand patterns.
2. **Run a dedicated rebalancing route between the City financial district cluster (where bikes accumulate) and the termini and park cluster (where bikes drain)**, scheduled for the weekday late morning to early afternoon lull, to directly relieve the network's two largest and most predictable pressure points.
3. **Prioritise Hyde Park Corner and both Waterloo Station docks for rebalancing attention first**, since they combine high overall traffic with high imbalance, meaning the absolute bike count at stake there is largest.
4. **Weight e-bike placement toward commute-heavy stations rather than leisure-heavy ones**, based on their observed point-to-point usage pattern.
5. **Extend this analysis to a full year, and add weather and event data**, to confirm these patterns hold outside spring conditions and to explain demand spikes the weekly pattern alone doesn't account for.

## References

1. Transport for London, "Cycling data," TfL Open Data. Available: https://cycling.data.tfl.gov.uk
2. Transport for London, "Unified API," TfL API Portal. Available: https://api.tfl.gov.uk
3. R. Vogel, D. Greiser, and D. C. Mattfeld, "Understanding bike-sharing systems using data mining: Exploring activity patterns," *Procedia - Social and Behavioral Sciences*, vol. 20, pp. 514 to 523, 2011.
