SELECT *
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
ORDER BY 3,4

--SELECT *
--FROM PortfolioProject..CovidVaccinations
--ORDER BY 3,4

--Selection of data that will be used:

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2


-- The total cases vs total deaths
-- Shows the likelihood of dying if you contract Covid in your country:

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location like '%Bangladesh%'
and continent is not null
ORDER BY 1,2


-- The total cases vs population:
--Shows what percentage of population got covid:

SELECT location, date, population, total_cases, (total_cases/population)*100 as Percent_Of_Population_Infected
FROM PortfolioProject..CovidDeaths
WHERE location like '%Bangladesh%'
ORDER BY 1,2


-- Countries with highest infection rate compared to population:

SELECT location, population, MAX(total_cases) as Highest_infection_count, MAX((total_cases/population))*100 as Percent_of_Population_Infected
FROM PortfolioProject..CovidDeaths
GROUP BY location, population
ORDER BY Percent_of_Population_Infected desc

--Continent with highest infection rate compared to population:

SELECT date, continent, population, MAX(total_cases) as Highest_infection_count, MAX((total_cases/population))*100 as Percent_of_Population_Infected
FROM PortfolioProject..CovidDeaths
GROUP BY date, continent, population
ORDER BY Percent_of_Population_Infected desc, date

-- Breaking down by continent:

--- Continents with the highest death count per population:

SELECT continent, MAX(cast(total_deaths as int)) as Total_Death_Counts
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY  Total_Death_Counts desc


--Countries with the highest death count per population:

SELECT location, MAX(cast(total_deaths as int)) as Total_Death_Counts
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY  Total_Death_Counts desc


-- Global numbers:
-- Aggregate functions used below:

--Death percentage acrosss the world per day:

SELECT date, SUM(new_cases) as Total_cases, SUM(cast(new_deaths as int)) as Total_Deaths, SUM(cast(new_deaths as int))/ SUM(new_cases) *100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
group by date
ORDER BY 1,2

-- The total cases vs. total deaths:

SELECT  SUM(new_cases) as Total_cases, SUM(cast(new_deaths as int)) as Total_Deaths, SUM(cast(new_deaths as int))/ SUM(new_cases) *100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
ORDER BY 1,2


--Joining CovidDeaths with CovidVaccinations by location and date:
Select *
From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
order by 1,2,3


--The total population vs vaccinations:

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
order by 2,3


--Instead of using total vaccinations, new vaccinations can be used to find out total vaccinations:

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as Rolling_People_Vaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
order by 2,3


--- Total Population Vs. Total Vaccinations: 

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as Rolling_People_Vaccinated
---, (Rolling_People_Vaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
order by 2,3


--- What percentage of the population of a country is vaccinated?
--using cte (common table expression)

With PopvsVac (Continent, Location, Date, Population, new_vaccinations, Rolling_People_Vaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as Rolling_People_Vaccinated
---, (Rolling_People_Vaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
---order by 2,3
)
SELECT *, (Rolling_People_Vaccinated/Population)*100 as Rolling_number
FROM PopvsVac

-- This is showing rolling people vaccinated vs population, as rolling people vaccinated increases, the percentage also increases while population remains stagnant
--Right now, about 7% of the population of Algeria is vaccinated, we can see from this data





---- What percentage of the population of a country is vaccinated using TEMP TABLE?

DROP table if exists #Percentage_Population_Vaccinated
Create Table #Percentage_Population_Vaccinated
(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rolling_people_vaccinated numeric
)

Insert into #Percentage_Population_Vaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as Rolling_People_Vaccinated
---, (Rolling_People_Vaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--- WHERE dea.continent is not null
---order by 2,3


SELECT *, (Rolling_People_Vaccinated/Population)*100 as Rolling_number
FROM #Percentage_Population_Vaccinated



--- Creating view to store data for later visulizations:

--- view 1 

create view Percentage_Population_Vaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as Rolling_People_Vaccinated
---, (Rolling_People_Vaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
---order by 2,3


--- view 2

Create view highest_death_count_per_pop as
SELECT continent, MAX(cast(total_deaths as int)) as Total_Death_Counts
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY continent
---ORDER BY  Total_Death_Counts desc
