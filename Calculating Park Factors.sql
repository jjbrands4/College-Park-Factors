	--- CODE ---

drop table #XBHComp
Select c.csVenueId, sum(AB) as AB, 
cast(sum([H]) - sum([2B]) - sum([3B]) - sum([HR]) as float) as [1B], 
cast(sum([2B]) as float) as [2B], 
cast(sum([3B]) as float) as [3B], 
cast(sum([HR]) as float) as [HR]
into #XBHComp
from lagoon.cs.Am_Batter_Box_Scores_vw a
left join lagoon.base.Am_Games_vw b
	on a.LagoonGameId = b.gameID
left join lagoon.base.Am_Venues c
	on b.venueId = c.ID
left join lagoon.base.Am_Teams d
	on a.csTeamId = d.csTeamId
	and a.year = d.year
left join lagoon.base.Am_Divisions e
	on d.divisionID = e.ID
where a.year >= 2011 and e.csDivAbbr in ('D1','D2','D3','JC','NAIA','SUM') and csVenueId is not null 
	and ((b.confirmedTrueHomeGame = 1 and e.csDivAbbr = 'D1') or b.confirmedTrueHomeGame = 0)
--and divAbbr = 'D1'
group by c.csVenueId

drop table #XBHComp_ABsDivAdj
select b.homeTeamDiv, c.csVenueId, sum(AB) as AB,
cast(sum([H]) - sum([2B]) - sum([3B]) - sum([HR]) as float) as [1B], 
cast(sum([2B]) as float) as [2B], 
cast(sum([3B]) as float) as [3B], 
cast(sum([HR]) as float) as [HR]
into #XBHComp_ABsDivAdj
from lagoon.cs.Am_Batter_Box_Scores_vw a
left join lagoon.base.Am_Games_vw b
	on a.LagoonGameId = b.gameID
left join lagoon.base.Am_Venues c
	on b.venueId = c.ID
left join lagoon.base.Am_Teams d
	on a.csTeamId = d.csTeamId
	and a.year = d.year
left join lagoon.base.Am_Divisions e
	on d.divisionID = e.ID
where a.year >= 2011 and e.csDivAbbr in ('D1','D2','D3','JC','NAIA','SUM') and csVenueId is not null 
	and ((b.confirmedTrueHomeGame = 1 and e.csDivAbbr = 'D1') or b.confirmedTrueHomeGame = 0)
group by b.homeTeamDiv, c.csVenueId

drop table #XBHComp_ABsConfADj
select c.csVenueId, a.conference, e.csDivAbbr, sum(AB) as AB,
		cast(sum([H]) - sum([2B]) - sum([3B]) - sum([HR]) as float) as [1B], 
		cast(sum([2B]) as float) as [2B], 
		cast(sum([3B]) as float) as [3B], 
		cast(sum([HR]) as float) as [HR]
into #XBHComp_ABsConfADj
from lagoon.cs.Am_Batter_Box_Scores_vw a
left join lagoon.base.Am_Games_vw b
	on a.LagoonGameId = b.gameID
left join lagoon.base.Am_Venues c
	on b.venueId = c.ID
left join lagoon.base.Am_Teams d
	on a.csTeamId = d.csTeamId
	and a.year = d.year
left join lagoon.base.Am_Divisions e
	on d.divisionID = e.ID
where a.year >= 2011 and e.csDivAbbr in ('D1','D2','D3','JC','NAIA','SUM') and csVenueId is not null 
	and ((b.confirmedTrueHomeGame = 1 and e.csDivAbbr = 'D1') or b.confirmedTrueHomeGame = 0)
group by c.csVenueId, a.conference, e.csDivAbbr

---- Null less than 1000 ABs (~15 games)
--update a
--set a.[AB] = NULL, a.[1B] = NULL, a.[2B] = NULL, a.[3B] = NULL, a.[HR] = NULL
--from #XBHComp_ABsConfADj a
--where AB < 1000

-- XBH by Division/Year
drop table #XBHComp_DivTotal
Select a.divAbbr, sum(AB) as AB, 
cast(sum([H]) - sum([2B]) - sum([3B]) - sum([HR]) as float) as [1B], 
cast(sum([2B]) as float) as [2B], 
cast(sum([3B]) as float) as [3B], 
cast(sum([HR]) as float) as [HR]
into #XBHComp_DivTotal
from lagoon.cs.Am_Batter_Box_Scores_vw a
left join lagoon.base.Am_Games_vw b
	on a.LagoonGameId = b.gameID
left join lagoon.base.Am_Venues c
	on b.venueId = c.ID
left join lagoon.base.Am_Teams d
	on a.csTeamId = d.csTeamId
	and a.year = d.year
left join lagoon.base.Am_Divisions e
	on d.divisionID = e.ID
where a.year >= 2011 and e.csDivAbbr in ('D1','D2','D3','JC','NAIA','SUM') and csVenueId is not null 
	and ((b.confirmedTrueHomeGame = 1 and e.csDivAbbr = 'D1') or b.confirmedTrueHomeGame = 0)
group by a.divAbbr
order by a.divAbbr desc

-- XBH by Division/Year by State
drop table #XBHComp_DivTotalByState
Select a.divAbbr, c.state, sum(AB) as AB, 
cast(sum([H]) - sum([2B]) - sum([3B]) - sum([HR]) as float) as [1B], 
cast(sum([2B]) as float) as [2B], 
cast(sum([3B]) as float) as [3B], 
cast(sum([HR]) as float) as [HR]
into #XBHComp_DivTotalByState
from lagoon.cs.Am_Batter_Box_Scores_vw a
left join lagoon.base.Am_Games_vw b
	on a.LagoonGameId = b.gameID
left join lagoon.base.Am_Venues c
	on b.venueId = c.ID
left join lagoon.base.Am_Teams d
	on a.csTeamId = d.csTeamId
	and a.year = d.year
left join lagoon.base.Am_Divisions e
	on d.divisionID = e.ID
where a.year >= 2011 and e.csDivAbbr in ('D1','D2','D3','JC','NAIA','SUM') and csVenueId is not null 
	and ((b.confirmedTrueHomeGame = 1 and e.csDivAbbr = 'D1') or b.confirmedTrueHomeGame = 0) and c.state is not null
group by a.divAbbr, c.state
order by a.divAbbr desc

---- Null fill small conference samples with division totals
--update a
--set a.AB = b.AB, a.[1B] = b.[1B], a.[2B] = b.[2B], a.[3B] = b.[3B], a.[HR] = b.[HR]
--from #XBHComp_ABsConfADj a
--left join #XBHComp_DivTotal b
--	on a.csDivAbbr = b.divAbbr
--	and a.year = b.year
--where a.AB is NULL and b.AB > 1000

-- Trim to most same conference ABs
drop table #XBHComp_ABsConfADj_MaxABs
select a.*
into #XBHComp_ABsConfADj_MaxABs
from #XBHComp_ABsConfADj a
join (select csVenueId, max(AB) as AB
		from #XBHComp_ABsConfADj a
		group by csVenueId) b
 on a.csVenueId = b.csVenueId
 and a.AB = b.AB
where b.AB >= 5000 -- about 75 games

-- Update to account for conference quality where possible (423)
update a
set a.AB = b.AB, a.[1B] = b.[1B], a.[2B] = b.[2B], a.[3B] = b.[3B], a.[HR] = b.[HR]
from #XBHComp a
join #XBHComp_ABsConfADj_MaxABs b
	on a.csvenueId = b.csVenueId

-- Expected Outcomes
drop table #XBHComp_DivAdj

select  
	a.csVenueId, a.homeTeamDiv, a.AB, a.[1B], a.[2B], a.[3B], a.[HR]
	,case when b.AB >= 1000
		then cast(a.AB as float) * cast(b.[1B] as float)/cast(b.AB as float) 
		else case when c.AB >= 1000
			then cast(a.AB as float) * cast(c.[1B] as float)/cast(c.AB as float) 
		else cast(a.AB as float) * cast(d.[1B] as float)/cast(d.AB as float)
			end end as exp1B
	,case when b.AB >= 1000
		then cast(a.AB as float) * cast(b.[2B] as float)/cast(b.AB as float) 
		else case when c.AB >= 1000
			then cast(a.AB as float) * cast(c.[2B] as float)/cast(c.AB as float) 
		else cast(a.AB as float) * cast(d.[2B] as float)/cast(d.AB as float)
			end end as exp2B
	,case when b.AB >= 1000
		then cast(a.AB as float) * cast(b.[3B] as float)/cast(b.AB as float) 
		else case when c.AB >= 1000
			then cast(a.AB as float) * cast(c.[3B] as float)/cast(c.AB as float) 
		else cast(a.AB as float) * cast(d.[3B] as float)/cast(d.AB as float)
			end end as exp3B
	,case when b.AB >= 1000
		then cast(a.AB as float) * cast(b.[HR] as float)/cast(b.AB as float) 
		else case when c.AB >= 1000
			then cast(a.AB as float) * cast(c.[HR] as float)/cast(c.AB as float) 
		else cast(a.AB as float) * cast(d.[HR] as float)/cast(d.AB as float)
			end end as expHR
into #XBHComp_DivAdj																   
from #XBHComp_ABsDivAdj a -- venue by division by year
left join (select csVenueId, max(year) as year, max(state) as state from lagoon.base.Am_Venues where state is not null group by csVenueId) v
	on a.csVenueId = v.csVenueId
left join #XBHComp b --total venue accounted for conference where possible
	on a.csVenueId = b.csVenueId
left join #XBHComp_DivTotalByState c -- total division by year/state
	on a.homeTeamDiv = c.divAbbr
	and v.state = c.state
	and v.state is not null
left join #XBHComp_DivTotal d -- total division by year
	on a.homeTeamDiv = d.divAbbr

-- Expected Sums
drop table #XBHComp_DivAdjSummed
select a.csVenueId, a.homeTeamDiv
	,sum(a.AB) as AB
	--,sum(a.[1B]) as [1B]
	,sum(a.[2B]) as [2B]
	,sum(a.[3B]) as [3B]
	,sum(a.[HR]) as [HR]
	--,sum([exp1B]) as exp1B
	,sum([exp2B]) as exp2B
	,sum([exp3B]) as exp3B
	,sum([expHR]) as expHR
	,(sum(a.[2B]) - sum([exp2B])) * sum(mean2B) as [deltaRunValue2B]
	,(sum(a.[3B]) - sum([exp3B])) * sum(mean3B) as [deltaRunValue3B]
	,(sum(a.[HR]) - sum([expHR])) * sum(meanHR) as [deltaRunValueHR]
	,((sum(a.[2B]) - sum([exp2B])) * sum(mean2B))
		+ ((sum(a.[3B]) - sum([exp3B])) * sum(mean3B))
		+ ((sum(a.[HR]) - sum([expHR])) * sum(meanHR)) as [deltaRunValueTotal]
into #XBHComp_DivAdjSummed
from #XBHComp_DivAdj a
left join scratch.klinge.finOutputDiv b
	on a.homeTeamDiv = b.homeTeamCSDivAbbr
group by a.csVenueId, a.homeTeamDiv

drop table #XBHComp_FinalTotals
select a.csvenueId, a.[deltaRunValueTotal]
	,sum(a.AB) as AB
	,case when sum(a.AB) < 1000 or a.[deltaRunValueTotal] is null then 0 else sum(a.[deltaRunValueTotal])/sum(a.AB) end as [runValuePerAB]
into #XBHComp_FinalTotals
from #XBHComp_DivAdjSummed a
group by a.csvenueId, a.[deltaRunValueTotal]

-- Yearly PF creation
drop table #XBHComp_FinalAvgByYear

select sum(a.AB) as AB, sum(a.deltaRunValueTotal)/sum(a.AB) as avgRunValuePerAB, b.stDevRunValuePerAB
into #XBHComp_FinalAvgByYear
from #XBHComp_FinalTotals a
cross join (select stdev(runValuePerAB) as stDevRunValuePerAB
			from #XBHComp_FinalTotals 
			where AB >= 1000 and deltaRunValueTotal is not null) b
where a.AB >= 1000 and a.deltaRunValueTotal is not null
group by b.stDevRunValuePerAB
order by b.stDevRunValuePerAB



drop table #XBHComp_Final

select a.csVenueId, a.AB, a.runValuePerAB, b.avgRunValuePerAB
	, case when (((a.runValuePerAB - b.avgRunValuePerAB)/b.avgRunValuePerAB)) > 0
		then 100 + ((a.runValuePerAB - b.avgRunValuePerAB)/b.avgRunValuePerAB)
		else 100 - ((a.runValuePerAB - b.avgRunValuePerAB)/b.avgRunValuePerAB)
		end as PF
into #XBHComp_Final
from #XBHComp_FinalTotals a
cross join #XBHComp_FinalAvgByYear b
where a.runValuePerAB is not null
group by a.csVenueId, a.AB, a.runValuePerAB, a.runValuePerAB, b.avgRunValuePerAB

-- Team PF scores
--drop table scratch.brands.Ama_PF_By_Game

--select a.year, a.csTeamId, c.csVenueId, sum(a.AB) as AB, PF
--into scratch.brands.Ama_PF_By_Game
--from lagoon.cs.Am_Batter_Box_Scores_vw a
--left join lagoon.base.Am_Games_vw b
--	on a.LagoonGameId = b.gameID
--left join lagoon.base.Am_Venues c
--	on b.venueId = c.ID
--left join lagoon.base.Am_Teams d
--	on a.csTeamId = d.csTeamId
--	and a.year = d.year
--left join lagoon.base.Am_Divisions e
--	on d.divisionID = e.ID
--left join #XBHComp_Final f
--	on c.csVenueId = f.csVenueId
--	and a.year = f.year
--where a.year >= 2015 and e.csDivAbbr in ('D1','D2','D3','JC','NAIA','SUM') and c.csVenueId is not null 
--and f.PF is not null
--group by a.year, a.csTeamId, c.csVenueId, PF

update a
set a.PF = b.PF
from scratch.brands.Ama_PF_By_Game a
left join #XBHComp_Final b
	on a.csVenueId = b.csVenueId

drop table #TempPFWeightings

select a.csteamId, a.year, a.csVenueId, a.AB, b.AB as totalAB, a.PF, (cast(a.AB as float)/cast(b.AB as float)) * a.PF as PFweighting
into #TempPFWeightings
from scratch.brands.Ama_PF_By_Game a
left join (select csteamId, year, sum(AB) as AB from scratch.brands.Ama_PF_By_Game group by csteamId, year) b
	on a.csteamId = b.csteamId
	and a.year = b.year
group by a.csteamId, a.year, a.csVenueId, a.AB, b.AB, a.PF


drop table #TempPFWeightingsComp
select a.csteamId, a.year, a.totalAB, b.collegeName, b.confAbbr, b.divAbbr, sum(a.PFweighting) as teamPF, b.team_PF_factor
into #TempPFWeightingsComp
from #TempPFWeightings a
left join scratch.brands.Am_newSOS_PF_team_hitter_summary_202005 b
	on a.csTeamId = b.csTeamId
	and a.year = b.year
group by a.csteamId, a.year, a.totalAB, b.team_PF_factor, b.collegeName, b.confAbbr, b.divAbbr

select a.*, a.teamPF + (100.0 - b.d1PFAvg) as teamPFD1adj
from #TempPFWeightingsComp a
left join (select year, avg(teamPF) as d1PFAvg from #TempPFWeightingsComp where divAbbr = 'D1' group by year) b
	on a.year = b.year

	scratch.brands.Ama_PF_By_Game a where csteamid = 'akr01' and year = 2021