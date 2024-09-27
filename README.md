# College-Park-Factors
 
# **Project Overview**

### **Motivation**

In baseball, not all playing fields are created equally. Literally. Although there are a standard set of rules to define the playing surface, every park has uniqueness found in their outfield wall dimensions, wall heights, and foul ball territories. Additionally, due to geographical factors such as air quality and wind tendencies, a ball hit in the same way can travel two different distances depending on which ballpark it’s in. In order to better compare player performance for players across the country, the Amateur Scouting Department uses adjustments like Park Factors (PFs) to better account for different playing environments.

### Objective

The department had traditionally outsourced the calculations to a third party vendor. The objective of the project was to create an improved Park Factor metric in order improve player evaluation with other internal metrics and to cut an unneeded expense for the department.

# **The Approach and Process**

### **Methodology**

The first step in the process was to define how Park Factors were to function. The metric needed to be both interpretable and easily able to be applied multiplicatively to other statistics. Therefore, it was to be defined as “the expected run value percentage gained or lost per At Bat for an event within a given venue”. Park Factors were to be scaled so that 100 was average across all venues, and each point above or below 100 represented a 1% change in  [run value](https://library.fangraphs.com/principles/linear-weights/) (a metric used to quantify the impact of a specific event on a team’s scoring potential) gained or lost for an event at a given venue. That way, the metric was easily digestible and can be divided by 100 to be used as a scalar adjustment for other statistics.

The primary focus was how parks allowed for more or fewer hits, so I began by looking at the hit rates for each venue by year and conference (SEC, ACC, Big 10, etc.) where viable. Subsetting by conference allowed for quality of competition to generally be accounted for in cases where venues are shared by multiple teams throughout the year. In rare cases, sampling issues for a venue required the rates to be derived by division (D1, D2, JuCo, etc.) instead of conference in order to get sufficiently sized samples.

I then compared the rates for different hit types at each venue to the overall rates for that division in that year. The difference in these rates reflects the estimated impact a park has for an event. Multiplying these difference **with **a matrix of event run values yields Park Factors for a venue. 

### Challenges and Solutions

There may be confounding factors such as fluctuations in team performance and defensive strength that may exist beyond what’s accounted for. However, quality of competition is a separate adjustment used called Strength of Schedule, a separate model which ultimately holds Park Factors constant in order to determine the quality of opponent being faced. In order to avoid collinearity with another adjustment, I decided to generalize quality of competition by looking at events within each conference to provide context to the quality of play at the venue without getting too granular in team or even player-specific events.

### **Key Findings**

- It was found that Park Factors from the vendor fitted the values to pseudo-normal distribution. However, both internal data and subject matter expertise suggested that Park Factors more closely resemble a short-tailed distribution where the most extreme parks were those who benefitted hitters the most 

- The new Park Factors yielded a higher spread, allowing for a more nuanced adjustment for player performance. When applied to other player performance metrics, the metrics were shown to be more powerful predictors of future performance compared to using the old adjustments.
- Equally as important, the new Park Factors showed a higher year-over-year correlation within each venue. Despite collinearity with the number of at bats the venue saw each year, it was important Park Factors remain relatively stable since the dimensions of venues don’t often change.

# **End Results and Recommendations**

### **Conclusion**

- Park Factors are a flexible way to account for the variation that playing environments have on player performance.

### **Future Considerations**

- Moving forward, Park Factors can be improved through a couple different routes. One of the most obvious would be to incorporate wall heights and outfield dimensions into the analysis. This would further refine the metric to better account for how different parts of the park play for different event times, and would be much quicker to stabilize when a park changes. Unfortunately, that information was not accessible through any of our vendors and was not found publicly aggregated, so it was unable to be pursued within the project’s timetable. Additionally, there may be better ways to hold quality of competition constant during the analysis without yielding significant collinearity with other adjustments, like deriving the expected rate of hits based on batted ball data, removing that variance from current Park Factor calculations. However, that data is not available at every venues and Park Factors need to be applied to all players.
