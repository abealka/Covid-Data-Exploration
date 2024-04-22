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