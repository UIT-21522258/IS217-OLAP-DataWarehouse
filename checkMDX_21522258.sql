-- 3. Liệt kê những đội có chữ cái đầu là "B” và có Tổng 3PM > 10000. (med)
select [dbo].DimTeam.teamName, sum([dbo].FactGameStats._3pm) as total3pm from [dbo].FactGameStats, [dbo].DimTeam
where [dbo].FactGameStats.teamKey = [dbo].DimTeam.teamKey
and [dbo].DimTeam.teamName like 'B%'
group by [dbo].DimTeam.teamName
having sum([dbo].FactGameStats._3pm) > 10000;

-- 4. Trong mua giải 2005, liệt kê 5 đội có OREB cao nhất. (med-(mid-med))
select TOP 5 [dbo].DimTeam.teamName, sum([dbo].FactGameStats.oreb) as totalOREB from [dbo].FactGameStats, [dbo].DimTeam, [dbo].DimTime
where [dbo].FactGameStats.teamKey = [dbo].DimTeam.teamKey
and [dbo].FactGameStats.timeKey = [dbo].DimTime.timeKey
and [dbo].DimTime.year = 2005
group by [dbo].DimTeam.teamName
order by sum([dbo].FactGameStats.oreb) desc;

-- 5. Có 3 loại trận đấu, thống kê số lượng trận của từng loại theo từng năm từ 1996-2003. (easy)
select [dbo].DimGameType.typeName, [dbo].DimTime.year, count([dbo].FactGameStats.gameTypeKey) as TOTALMATCH
from [dbo].DimGameType, [dbo].DimTime, dbo.FactGameStats
where dbo.DimGameType.gameTypeKey = dbo.FactGameStats.gameTypeKey
and dbo.DimTime.timeKey = dbo.FactGameStats.timeKey
and [dbo].DimTime.year between 1996 and 2003
group by [dbo].DimGameType.typeName, [dbo].DimTime.year;

--6. Thống kế tổng trận đầu và tồng số lần phạm lỗi, số lỗi phạm nhiều nhất trong 1 trận của 3 đội có MIA, SAS, BOS. (easy)
select dbo.DimTeam.teamName, count([dbo].FactGameStats.teamKey) as TOTALMATCH, sum(dbo.FactGameStats.pf) TOTALFOUL, max(dbo.FactGameStats.pf) as MAXFOUL
from dbo.FactGameStats, dbo.DimTeam
where dbo.FactGameStats.teamKey = dbo.DimTeam.teamKey
and dbo.DimTeam.teamName in ('BOS', 'MIA', 'SAS')
group by dbo.DimTeam.teamName;

--8. Liệt kê 5 mùa giải có số trận đấu trong tháng 1 cao nhất. (mid-med)
select TOP 5 dbo.DimGame.season, count([dbo].FactGameStats.gameKey) as TOTALMATCH
from dbo.DimGame, dbo.FactGameStats, dbo.DimTime
where dbo.DimGame.gameKey = dbo.FactGameStats.gameKey
and dbo.FactGameStats.timeKey = dbo.DimTime.timeKey
and dbo.DimTime.month = 1
and dbo.DimTime.year between 1996 and 2022
group by dbo.DimGame.season
ORDER BY count([dbo].FactGameStats.gameKey) DESC;

--9. Thống kê tỉ lệ ném phạt thành công của các đội bóng. (easy)
select dbo.DimTeam.teamName,
	FORMAT(SUM(dbo.FactGameStats.ftm) * 100.0 / NULLIF(SUM(dbo.FactGameStats.fta), 0), 'N2') AS NEMPHATTHANHCONG
from dbo.DimTeam, dbo.FactGameStats
where dbo.DimTeam.teamKey = dbo.FactGameStats.teamKey
group by dbo.DimTeam.teamName;