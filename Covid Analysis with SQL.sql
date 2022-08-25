SELECT * 
FROM dbo.CovidDeaths
ORDER BY 3,4 

SELECT*
FROM dbo.CovidVaccinations
ORDER BY 3,4

--The data about Covid Deaths 
Select location, date, total_cases, new_cases, total_deaths, population
From dbo.CovidDeaths
Order by 1,2

--Looking at the Total Cases vs TotalDeaths.
--The calculations of the likelihood of death in the continent of Africa.


Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From dbo.CovidDeaths
where location like '%Africa%'
Order by 1,2





--Looking at the Total Cases vs Population.
--Shows the total percentage of population that got Covid.
Select location, date,  Population, total_cases, (total_deaths/population)*100 as PercentpopulationInfected
From dbo.CovidDeaths
Where location like '%Africa%'
Order by 1,2

--Looking at countries with highest infection rate compared to population.
Select location, Population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
From dbo.CovidDeaths
--Where location like '%Africa%'
Group by location, Population
Order by PercentPopulationInfected desc

--showing countries with Highest Death Count per Population 
Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From dbo.CovidDeaths
--where location like '%States%'
 Group by location
Order by TotalDeathCount desc

--BREAK DOWN COVID REPORT BY CONTINENT 

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From dbo.CovidDeaths 
--Where location like '%states%'
where continent is not null
Group by continent
Order by TotalDeathCount desc

Select location, MAX(cast(Total_deaths as int )) as TotalDeathCount
From dbo.CovidDeaths
--Where location like '%states%'
where continent is null 
Group by location
Order by TotalDeathCount desc 

---GLOBAL NUMBERS

Select location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From dbo.CovidDeaths
--where location like '%states%'
where continent is not null 
order by 1,2

Select date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From dbo.CovidDeaths
--where location like '%state%'
where continent is not null 
order by 1,2

Select date, SUM(new_cases), SUM(cast(new_deaths as int))--, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From dbo.CovidDeaths
--where location like '%states%'
where continent is not null 
Group By date
order by 1,2


select date, SUM(new_cases), SUM(cast(new_deaths as int)), SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From dbo.CovidDeaths
--where location like '%states%'
where continent is not null 
Group by date
order by 1,2


--TOTAL POPULATION VS VACCINATION 
Select *
From dbo.CovidDeaths dea
Join dbo.CovidVaccinations vac
    On dea.location = vac.location
    and dea.date = vac.date

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From dbo.CovidDeaths dea
Join dbo.CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date 

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from dbo.CovidDeaths dea
Join dbo.CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3




---USE CTE
With PopvsVac(Continent, Location,Date,Population,RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From dbo.CovidDeaths dea
Join dbo.CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)



---TEMP TABLE 

Create table PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)


Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From dbo.CovidDeaths dea
Join dbo.CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
-- where dea.continent is not null
--order by 2,3


Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated








  



 









