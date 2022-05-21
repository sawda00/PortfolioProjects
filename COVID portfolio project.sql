SELECT Location, Date, Total_Cases, New_Cases, Total_Deaths, Population
 FROM PortfolioProject.CovidDeaths
 WHERE continent IS NOT NULL -- some data in location has continents
 ORDER BY 1, 2;

-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country
SELECT Location, Date, Total_Cases, Total_Deaths, (total_deaths/total_cases)*100 AS DeathPercentage
 FROM PortfolioProject.CovidDeaths 
 WHERE location LIKE '%kingdom%' AND continent IS NOT NULL 
 ORDER BY 1, 2;
 
-- Looking at the Total Cases vs Population
-- Shows what percentage of population got Covid
SELECT Location, Date, Population, Total_Cases, (total_cases/population)*100 AS PercentPopulationInfected
 FROM PortfolioProject.CovidDeaths
 WHERE location LIKE '%kingdom%'
 ORDER BY 1, 2;
 
-- Looking at countries with the Highest Infection Rate compared to Population

SELECT Location, Population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentPopulationInfected
 FROM PortfolioProject.CovidDeaths
 GROUP BY location, population
 ORDER BY PercentPopulationInfected DESC;
 
-- Showing countries with Highest Death Count per Population

SELECT Location, MAX(total_deaths) AS TotalDeathCount
 FROM PortfolioProject.CovidDeaths
 WHERE continent IS NOT NULL 
 GROUP BY location
 ORDER BY TotalDeathCount DESC;
 
-- LET'S BREAK THINGS DOWN BY CONTINENT
 
-- Showing continents with the Highest Death Count per Population

SELECT Continent, MAX(total_deaths) AS TotalDeathCount
 FROM PortfolioProject.CovidDeaths
 WHERE continent IS NOT NULL 
 GROUP BY continent
 ORDER BY TotalDeathCount DESC;
 
SELECT Location, MAX(total_deaths) AS TotalDeathCount
 FROM PortfolioProject.CovidDeaths
 WHERE continent IS NULL 
 GROUP BY location
 ORDER BY TotalDeathCount DESC;

-- GLOBAL NUMBERS

SELECT Date, SUM(new_cases) AS Total_Cases, SUM(new_deaths) AS Total_Deaths, SUM(new_deaths)/SUM(new_cases)*100 AS DeathPercentage
 FROM PortfolioProject.CovidDeaths 
 WHERE continent IS NOT NULL 
 GROUP BY date
 ORDER BY 1, 2;
 
SELECT SUM(new_cases) AS Total_Cases, SUM(new_deaths) AS Total_Deaths, SUM(new_deaths)/SUM(new_cases)*100 AS DeathPercentage
 FROM PortfolioProject.CovidDeaths 
 WHERE continent IS NOT NULL
 ORDER BY 1, 2;

-- Looking at Total Population vs Vaccinations

SELECT d.Continent, d.Location, d.Date, d.Population, v.New_Vaccinations, 
 SUM(v.new_vaccinations) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS RollingPeopleVaccinated
 -- , (RollingPeopleVaccinated/Population)*100
 FROM PortfolioProject.CovidDeaths AS d
 JOIN PortfolioProject.CovidVaccinations AS v
  ON d.location = v.location 
  AND d.date = v.date
 WHERE d.continent IS NOT NULL
 ORDER BY 2, 3;
 
-- USE CTE

WITH 
 PopVSVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
 AS (
 SELECT d.Continent, d.Location, d.Date, d.Population, v.New_Vaccinations, 
  SUM(v.new_vaccinations) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS RollingPeopleVaccinated
  -- , (RollingPeopleVaccinated/Population)*100
  FROM PortfolioProject.CovidDeaths AS d
   JOIN PortfolioProject.CovidVaccinations AS v
   ON d.location = v.location 
   AND d.date = v.date
  WHERE d.continent IS NOT NULL
  -- ORDER BY 2, 3
  )
  SELECT *, (RollingPeopleVaccinated/Population)*100
  FROM PopVSVac;
 
-- TEMP TABLE

DROP TEMPORARY TABLE IF EXISTS PercentPopulationVaccinated;
CREATE TEMPORARY TABLE PercentPopulationVaccinated (
	Continent VARCHAR(55),
    Location VARCHAR(55),
    Date datetime,
    Population BIGINT,
    New_Vaccinations INT,
    RollingPeopleVaccinated BIGINT
);

INSERT INTO PercentPopulationVaccinated
 SELECT d.Continent, d.Location, d.Date, d.Population, v.New_Vaccinations, 
  SUM(v.new_vaccinations) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS RollingPeopleVaccinated
  -- , (RollingPeopleVaccinated/Population)*100
  FROM PortfolioProject.CovidDeaths AS d
   JOIN PortfolioProject.CovidVaccinations AS v
   ON d.location = v.location 
   AND d.date = v.date
  WHERE d.continent IS NOT NULL;
  -- ORDER BY 2, 3
  
SELECT *, (RollingPeopleVaccinated/Population)*100
  FROM PercentPopulationVaccinated;
  
-- Creating View to store data for later visualizations

CREATE OR REPLACE VIEW PercentPopulationVaccinated AS
 SELECT d.Continent, d.Location, d.Date, d.Population, v.New_Vaccinations, 
  SUM(v.new_vaccinations) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS RollingPeopleVaccinated
  -- , (RollingPeopleVaccinated/Population)*100
  FROM PortfolioProject.CovidDeaths AS d
   JOIN PortfolioProject.CovidVaccinations AS v
   ON d.location = v.location 
   AND d.date = v.date
  WHERE d.continent IS NOT NULL
  ORDER BY 2, 3;
  