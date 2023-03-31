select *
from pwebsite ..CovidDeath$
order by 3,4

--select *
--from pwebsite ..Covidvaccination
--order by 3,4

select location, date, total_cases,new_cases, total_deaths, population
from pwebsite..CovidDeath$
order by 1,2

--analysis of total cases vs total deaths
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
from pwebsite..CovidDeath$
where location like '%Australia%'
order by 1,2
-- this analysis shows the likehood of death incase of getting covid.


--analysis of total cases vs population

select location, date, population,total_cases, (total_cases/population)*100 as populationgotcovidpercentage
from pwebsite..CovidDeath$
where location like '%Australia%'
order by 1,2
-- this analysis gives the percentages of population in australia who got covid in the different range of dates.


--countries with highest infection rate with population
select location, population,MAX(total_cases)as HighestInfectionCount,  Max(total_cases/population)*100 as InfectedpoulationPercentage
from pwebsite..CovidDeath$
--where location like '%Australia%'
group by location,population
order by InfectedpoulationPercentage desc


--countries with the highest death count per population
select location, Max( cast(Total_deaths as int)) as TotalDeathCount
From pwebsite..CovidDeath$
where continent is not null
group by location
order by TotalDeathCount desc


--totaldeathcount with continent
select continent, Max( cast(Total_deaths as int)) as TotalDeathCount
From pwebsite..CovidDeath$
where continent is not null
group by continent
order by TotalDeathCount desc


-- analysis of total case and total deaths with date around the world

select date, sum( new_cases) as total_cases, sum(cast(new_deaths as int))as total_deaths, sum(cast(new_deaths as int))/sum(New_cases)*100 as Deathpercentage
from pwebsite..CovidDeath$
where continent is not null
group by date
order by 1,2

select  sum( new_cases) as total_cases, sum(cast(new_deaths as int))as total_deaths, sum(cast(new_deaths as int))/sum(New_cases)*100 as Deathpercentage
from pwebsite..CovidDeath$
where continent is not null
 
order by 1,2
-- this gives the total case with total deaths

--analysis of Total population vs vaccinations

select*
from pwebsite..Covidvaccination vac
Join pwebsite..CovidDeath$ dea
 on vac.location= dea.location
 and dea.date= vac.date


 select dea.continent,dea.location, dea.date,dea.population, vac.new_vaccinations ,
sum(convert(int,vac.new_vaccinations )) over (partition by dea.location order by dea.location, dea.date)
as rollingpeoplevaccinated
--(rollingpeoplevaccinated/population)*100

From pwebsite..Covidvaccination vac
Join pwebsite..CovidDeath$ dea
   on vac.location= dea.location
   and dea.date= vac.date
 where dea.continent is not null
 order by 2,3




 -- USE CTE
 WITH PopvsVac(continent,location,date, population, New_vaccinations,rollingpeoplevaccinated)
 as
 (
 select dea.continent,dea.location, dea.date,dea.population, vac.new_vaccinations ,
sum(convert(int,vac.new_vaccinations )) over (partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
, (Rollingpeoplevaccinated/population)*100

From pwebsite..Covidvaccination vac
Join pwebsite..CovidDeath$ dea
   on vac.location= dea.location
   and dea.date= vac.date
 where dea.continent is not null
 --order by 2,3
 )
 select*
 from PopvsVac


  



