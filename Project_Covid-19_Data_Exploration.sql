--COVID-19 DATA EXPLORATION USING SQL


SELECT *
FROM Project.dbo.CovidDeaths
WHERE continent is not NULL
ORDER BY 3,4



--Selecting the data that we are going to use
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM Project.dbo.CovidDeaths
WHERE continent is not NULL
ORDER BY 1,2



--Total Cases vs Total Deaths in India
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Death_Percentage
FROM Project.dbo.CovidDeaths
WHERE location = 'India'
and continent is not null
ORDER BY 1,2



--Total Cases vs Population
SELECT Location, date, total_cases, population, (total_cases/population)*100 AS Infection_Percentage
FROM Project.dbo.CovidDeaths
ORDER BY 1,2



--Countries with Highest Infection Rate compared to Population
SELECT Location, population, Max(total_cases) AS HighestInfectionCount, Max((total_cases/population))*100 AS PercentPopulationInfected
FROM Project.dbo.CovidDeaths
GROUP BY location, population
ORDER BY PercentPopulationInfected Desc



--Countries with Highest Death Count per Population
SELECT Location, Max(CAST(total_deaths AS int)) as TotalDeathCount
FROM Project.dbo.CovidDeaths
WHERE continent is not NULL
GROUP BY location
ORDER BY TotalDeathCount Desc



--BREAKING THINGS DOWN BY CONTINENT



--Continent with Highest Death Counts per Population
SELECT continent, Max(CAST(total_deaths AS int)) as TotalDeathCount
FROM Project.dbo.CovidDeaths
WHERE continent is not NULL
GROUP BY continent
ORDER BY TotalDeathCount Desc



--Global numbers of TotalCases, TotalDeaths, DeathPercentage
SELECT SUM(new_cases) AS TotalCases, SUM(CAST(new_deaths AS int)) AS TotalDeaths, (SUM(CAST(new_deaths AS int))/SUM(new_cases))*100 AS DeathPercentage
FROM Project.dbo.CovidDeaths
WHERE continent is not null
ORDER BY 1,2



--Total population vs Vaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from Project.dbo.CovidDeaths as dea
Join Project.dbo.CovidVaccinations as vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3
