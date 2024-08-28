

--select location , date, total_cases, total_deaths,
--total_deaths/nullif(total_cases,0)*100 as deathspercentage
--from dbo.coviddeth
--where location like 'algeria'
--order by 1,2
----

Select continent ,MAX(total_deaths) HightestDeaths
from dbo.coviddeth
--where location like 'algeria' 
where continent is not null
group by continent 
order by HightestDeaths desc 

----
select det.continent ,det.location , det.date, population , vac.new_vaccinations
from coviddeth det
 join covidvaccinations vac
	on det.location = vac.location
and det.date = vac.date
where det.continent is not null
order by 2,3
------
select det.continent ,det.location , det.date, population , vac.new_vaccinations , 
sum(convert(int,vac.new_vaccinations)) over (partition by det.location order by det.location , det.date) as sum_vaccination ,
(sum(convert(int,vac.new_vaccinations)) over (partition by det.location order by det.location , det.date)/population)*100
from coviddeth det
 join covidvaccinations vac
	on det.location = vac.location
and det.date = vac.date
where det.continent is not null
order by 2,3

With popvsvac 
AS
(
select det.continent ,det.location , det.date, population , vac.new_vaccinations , 
sum(convert(int,vac.new_vaccinations)) over (partition by det.location order by det.location , det.date) as sum_vaccination 
from coviddeth det
 join covidvaccinations vac
	on det.location = vac.location
and det.date = vac.date
where det.continent is not null
--order by 2,3
)
select*,(sum_vaccination/population)*100
from popvsvac



Create table #popvsvac
(
continent nvarchar(255) ,
location nvarchar (255) ,
date datetime ,
population numeric ,
new_vaccination numeric ,
sum_vaccination numeric
)
insert into #popvsvac
select det.continent ,det.location , det.date, population , vac.new_vaccinations , 
sum(convert(int,vac.new_vaccinations)) over (partition by det.location order by det.location , det.date) as sum_vaccination 
from coviddeth det
 join covidvaccinations vac
	on det.location = vac.location
and det.date = vac.date
where det.continent is not null
--order by 2,3
)
select*,(sum_vaccination/population)*100
from popvsvac







Create view percentePopulationVaccinated as
select det.continent ,det.location , det.date, population , vac.new_vaccinations , 
sum(convert(int,vac.new_vaccinations)) over (partition by det.location order by det.location , det.date) as RollingPeopleVaccinted
from coviddeth det
 join covidvaccinations vac
	on det.location = vac.location
and det.date = vac.date
where det.continent is not null
--order by 2,3


















