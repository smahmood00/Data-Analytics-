--CovidDeath Table information
Select *
From PortfolioProject..['CovidDeaths$']
Order by 3,4


---------------------CovidVaccination Table information
Select *
From PortfolioProject..['CovidVaccinations$']    
Order by 3,4


---------------------Total cases vs total deaths 
Select location,date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..['CovidDeaths$']
Order by 1,2


----------------------Total cases vs Population
Select location,date, Population,total_cases, (total_cases/population)*100 as CasePercentage
From PortfolioProject..['CovidDeaths$']
Where location like '%desh%'
Order by 1,2


----------------------Countries with Highest Infection Rate compared to Population
Select location, population, MAX(total_cases) as HighInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..['CovidDeaths$']
Group by location, population
Order by PercentPopulationInfected desc


----------------------Countries with Highest Death Count per population
Select location,  MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..['CovidDeaths$']
Where continent is not null
Group by location
Order by TotalDeathCount desc


----------------------Continents with Highest Death Count per population
Select continent,  MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..['CovidDeaths$']
Where continent is not null 
Group by continent
Order by TotalDeathCount desc


----------------------Global Numbers
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/Sum(new_cases)*100 as DeathPrecentage
From PortfolioProject..['CovidDeaths$']
Where continent is not null 
Order by 1,2


----------------------Total Population vs Vaccinations
Select d.continent, d.location, d.date, d.population, v.new_vaccinations, 
SUM(cast(v.new_vaccinations as bigint)) OVER (Partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
From PortfolioProject..['CovidDeaths$'] d 
Join PortfolioProject..['CovidVaccinations$'] v
	on  d.location=v.location 
	and d.date=v.date
Where d.continent is not null
Order by 2,3


----------------------USING VIEW 
Create View PercentPopulationVaccinated as
Select d.continent, d.location, d.date, d.population, v.new_vaccinations, 
SUM(cast(v.new_vaccinations as bigint)) OVER (Partition by d.location order by d.location, d.date) as RollingPeopleVaccinated 
From PortfolioProject..['CovidDeaths$'] d 
Join PortfolioProject..['CovidVaccinations$'] v
	on  d.location=v.location 
	and d.date=v.date
Where d.continent is not null

Select * , (RollingPeopleVaccinated/population)*100 as percentageRoll
From PercentPopulationVaccinated

