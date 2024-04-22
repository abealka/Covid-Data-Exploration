--COVID DATA VISUALIZATION PREP

-- PREVIEW DATA
SELECT*
FROM `portfolio-projects-420617.covid.covid_vax` 
ORDER BY 3,4;


SELECT location, date, total_cases, total_deaths, population
FROM `portfolio-projects-420617.covid.covid_deaths`
ORDER BY 1,2;

-- total cases vs total deaths in the united states

SELECT location, date, total_cases, total_deaths, population, (total_deaths/total_cases)*100 AS death_percentage
FROM `portfolio-projects-420617.covid.covid_deaths`
WHERE date > '2020-03-15' and location = 'United States'
ORDER BY 1,2;

SELECT SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, (SUM(new_deaths)/SUM(new_cases))*100 AS death_percentage
FROM `portfolio-projects-420617.covid.covid_deaths`
WHERE date > '2020-03-15' and location = 'United States'
ORDER BY 1,2;

-- total cases vs population

SELECT location, date, total_cases, population, (total_cases/population)*100 AS percent_population_infected
FROM `portfolio-projects-420617.covid.covid_deaths`
WHERE date > '2020-03-15' and location = 'United States'
ORDER BY 1,2;

-- countries with highest infection rate compared to population

SELECT location, population, MAX(total_cases) as highest_infection_count, MAX((total_cases/population))*100 AS percent_population_infected
FROM `portfolio-projects-420617.covid.covid_deaths`
GROUP BY location, population
ORDER BY percent_population_infected desc;

-- countries with highest death count per population

SELECT location, MAX(total_deaths) as total_death_count
FROM `portfolio-projects-420617.covid.covid_deaths`
WHERE continent IS NOT null
GROUP BY location
ORDER BY total_death_count desc;

-- highest death count per continent

SELECT location, SUM(new_cases) as total_deaths
FROM `portfolio-projects-420617.covid.covid_deaths`
WHERE continent is null
and location not in ('World', 'European Union', 'International', 'High income', 'Low income', 'Lower middle income', 'Upper middle income')
GROUP BY location
ORDER by 1,2;

-- global numbers
 
SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(cast(new_cases as int)) * 100 AS death_percentage
FROM `portfolio-projects-420617.covid.covid_deaths`
WHERE continent is not null
ORDER BY 1,2;

SELECT location, population, MAX(total_cases) as highest_infection_count, (MAX(total_cases)/population)*100 as percent_population_infected
FROM `portfolio-projects-420617.covid.covid_deaths`
GROUP BY location, population
ORDER BY percent_population_infected desc;

SELECT location, population, date, MAX(total_cases) as highest_infection_count, (MAX(total_cases)/population)*100 as percent_population_infected
FROM `portfolio-projects-420617.covid.covid_deaths`
GROUP BY location, population, date
ORDER BY percent_population_infected desc;


-- join vaccinations with deaths

SELECT dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations, 
SUM(vax.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as rolling_people_vaccinated
FROM `portfolio-projects-420617.covid.covid_deaths` dea
JOIN `portfolio-projects-420617.covid.covid_vax` vax
  ON dea.location = vax.location
  and dea.date = vax.date
WHERE dea.continent is not null
ORDER BY 1,2,3;

-- create CTE

WITH pop_vs_vax as (
  SELECT dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations,SUM(vax.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as rolling_people_vaccinated
FROM `portfolio-projects-420617.covid.covid_deaths` dea
JOIN `portfolio-projects-420617.covid.covid_vax` vax
  ON dea.location = vax.location
  and dea.date = vax.date
  WHERE dea.continent is not null)
SELECT *, (rolling_people_vaccinated/population)*100
FROM pop_vs_vax;

--create views

--percent pop vaccinated

/*CREATE VIEW covid.percent_pop_vax AS
 SELECT dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations,SUM(vax.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as rolling_people_vaccinated
FROM `portfolio-projects-420617.covid.covid_deaths` dea
JOIN `portfolio-projects-420617.covid.covid_vax` vax
  ON dea.location = vax.location
  and dea.date = vax.date
  WHERE dea.continent is not null; */

--













