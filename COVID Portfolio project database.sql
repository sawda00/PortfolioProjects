-- Create schema
CREATE DATABASE PortfolioProject;

USE PortfolioProject;

-- Create tables 
CREATE TABLE `CovidDeaths` (
  `iso_code` text,
  `continent` text,
  `location` text,
  `date` date DEFAULT NULL,
  `population` bigint DEFAULT NULL,
  `total_cases` int DEFAULT NULL,
  `new_cases` int DEFAULT NULL,
  `new_cases_smoothed` float DEFAULT NULL,
  `total_deaths` int DEFAULT NULL,
  `new_deaths` int DEFAULT NULL,
  `new_deaths_smoothed` float DEFAULT NULL,
  `total_cases_per_million` float DEFAULT NULL,
  `new_cases_per_million` float DEFAULT NULL,
  `new_cases_smoothed_per_million` float DEFAULT NULL,
  `total_deaths_per_million` float DEFAULT NULL,
  `new_deaths_per_million` float DEFAULT NULL,
  `new_deaths_smoothed_per_million` float DEFAULT NULL,
  `reproduction_rate` float DEFAULT NULL,
  `icu_patients` int DEFAULT NULL,
  `icu_patients_per_million` float DEFAULT NULL,
  `hosp_patients` int DEFAULT NULL,
  `hosp_patients_per_million` float DEFAULT NULL,
  `weekly_icu_admissions` int DEFAULT NULL,
  `weekly_icu_admissions_per_million` float DEFAULT NULL,
  `weekly_hosp_admissions` int DEFAULT NULL,
  `weekly_hosp_admissions_per_million` float DEFAULT NULL
);

CREATE TABLE `CovidVaccinations` (
  `iso_code` text,
  `continent` text,
  `location` text,
  `date` date DEFAULT NULL,
  `total_tests` bigint DEFAULT NULL,
  `new_tests` int DEFAULT NULL,
  `total_tests_per_thousand` float DEFAULT NULL,
  `new_tests_per_thousand` float DEFAULT NULL,
  `new_tests_smoothed` int DEFAULT NULL,
  `new_tests_smoothed_per_thousand` float DEFAULT NULL,
  `positive_rate` float DEFAULT NULL,
  `tests_per_case` float DEFAULT NULL,
  `tests_units` text,
  `total_vaccinations` bigint DEFAULT NULL,
  `people_vaccinated` bigint DEFAULT NULL,
  `people_fully_vaccinated` bigint DEFAULT NULL,
  `total_boosters` int DEFAULT NULL,
  `new_vaccinations` int DEFAULT NULL,
  `new_vaccinations_smoothed` int DEFAULT NULL,
  `total_vaccinations_per_hundred` float DEFAULT NULL,
  `people_vaccinated_per_hundred` float DEFAULT NULL,
  `people_fully_vaccinated_per_hundred` float DEFAULT NULL,
  `total_boosters_per_hundred` float DEFAULT NULL,
  `new_vaccinations_smoothed_per_million` int DEFAULT NULL,
  `new_people_vaccinated_smoothed` int DEFAULT NULL,
  `new_people_vaccinated_smoothed_per_hundred` float DEFAULT NULL,
  `stringency_index` float DEFAULT NULL,
  `population_density` float DEFAULT NULL,
  `median_age` float DEFAULT NULL,
  `aged_65_older` float DEFAULT NULL,
  `aged_70_older` float DEFAULT NULL,
  `gdp_per_capita` float DEFAULT NULL,
  `extreme_poverty` float DEFAULT NULL,
  `cardiovasc_death_rate` float DEFAULT NULL,
  `diabetes_prevalence` float DEFAULT NULL,
  `female_smokers` int DEFAULT NULL,
  `male_smokers` float DEFAULT NULL,
  `handwashing_facilities` float DEFAULT NULL,
  `hospital_beds_per_thousand` float DEFAULT NULL,
  `life_expectancy` float DEFAULT NULL,
  `human_development_index` float DEFAULT NULL,
  `excess_mortality_cumulative_absolute` float DEFAULT NULL,
  `excess_mortality_cumulative` float DEFAULT NULL,
  `excess_mortality` float DEFAULT NULL,
  `excess_mortality_cumulative_per_million` float DEFAULT NULL);

-- Load data onto the tables

-- --------- DATA FOR COVID DEATHS ------------------

SET FOREIGN_KEY_CHECKS = 0;

  SET UNIQUE_CHECKS = 0;

 

LOAD DATA LOCAL INFILE '/Users/sawda/Downloads/CovidDeaths.csv' IGNORE
    
    INTO TABLE coviddeaths

    FIELDS TERMINATED BY ','

    ENCLOSED BY '"'

    LINES TERMINATED BY '\r\n'  -- a text file generated on a Windows system, proper file reading might require LINES TERMINATED BY '\r\n'. OTHERWISE use \n 
    
    IGNORE 1 ROWS

	(@viso_code, @vcontinent, @vlocation, @vdate, @vpopulation, @vtotal_cases, @vnew_cases, @vnew_cases_smoothed, @vtotal_deaths, @vnew_deaths, 
	@vnew_deaths_smoothed, @vtotal_cases_per_million, @vnew_cases_per_million, @vnew_cases_smoothed_per_million, @vtotal_deaths_per_million, 
	@vnew_deaths_per_million, @vnew_deaths_smoothed_per_million, @vreproduction_rate, @vicu_patients, @vicu_patients_per_million, 
	@vhosp_patients, @vhosp_patients_per_million, @vweekly_icu_admissions, @vweekly_icu_admissions_per_million, @vweekly_hosp_admissions, 
	@vweekly_hosp_admissions_per_million)
    
    SET
    iso_code = NULLIF(@viso_code,''),
    continent = NULLIF(@vcontinent,''),
    location = NULLIF(@vlocation,''),
    date = NULLIF(@vdate,''),
    population = NULLIF(@vpopulation,''),
    total_cases = NULLIF(@vtotal_cases,''),
    new_cases = NULLIF(@vnew_cases,''),
    new_cases_smoothed = NULLIF(@vnew_cases_smoothed,''), 
    total_deaths = NULLIF(@vtotal_deaths,''),
    new_deaths = NULLIF(@vnew_deaths,''),
	new_deaths_smoothed = NULLIF(@vnew_deaths_smoothed,''),
    total_cases_per_million = NULLIF(@vtotal_cases_per_million,''),
    new_cases_per_million = NULLIF(@vnew_cases_per_million,''),
    new_cases_smoothed_per_million = NULLIF(@vnew_cases_smoothed_per_million,''),
    total_deaths_per_million = NULLIF(@vtotal_deaths_per_million,''),
	new_deaths_per_million = NULLIF(@vnew_deaths_per_million,''),
    new_deaths_smoothed_per_million = NULLIF(@vnew_deaths_smoothed_per_million,''),
    reproduction_rate = NULLIF(@vreproduction_rate,''),
    icu_patients = NULLIF(@vicu_patients,''),
    icu_patients_per_million = NULLIF(@vicu_patients_per_million,''),
	hosp_patients = NULLIF(@vhosp_patients,''),
    hosp_patients_per_million = NULLIF(@vhosp_patients_per_million,''),
    weekly_icu_admissions = NULLIF(@vweekly_icu_admissions,''),
    weekly_icu_admissions_per_million = NULLIF(@vweekly_icu_admissions_per_million,''),
    weekly_hosp_admissions = NULLIF(@vweekly_hosp_admissions,''),
    weekly_hosp_admissions_per_million = NULLIF(@vweekly_hosp_admissions_per_million,'');

  SET UNIQUE_CHECKS = 1;

  SET FOREIGN_KEY_CHECKS = 1;
  
-- --------- DATA FOR COVID VACCINATIONS ------------------
  
SET FOREIGN_KEY_CHECKS = 0;

SET UNIQUE_CHECKS = 0;

 
LOAD DATA LOCAL INFILE '/Users/sawda/Downloads/CovidVaccinations.csv' IGNORE
    
    INTO TABLE CovidVaccinations

    FIELDS TERMINATED BY ','

    ENCLOSED BY '"'

    LINES TERMINATED BY '\r\n'
    
    IGNORE 1 ROWS
    
    (@viso_code, @vcontinent, @vlocation, @vdate, @vtotal_tests, @vnew_tests, @vtotal_tests_per_thousand, @vnew_tests_per_thousand, 
    @vnew_tests_smoothed, @vnew_tests_smoothed_per_thousand, @vpositive_rate, @vtests_per_case, @vtests_units, @vtotal_vaccinations, 
    @vpeople_vaccinated, @vpeople_fully_vaccinated, @vtotal_boosters, @vnew_vaccinations, @vnew_vaccinations_smoothed, 
    @vtotal_vaccinations_per_hundred, @vpeople_vaccinated_per_hundred, @vpeople_fully_vaccinated_per_hundred, @vtotal_boosters_per_hundred,
    @vnew_vaccinations_smoothed_per_million, @vnew_people_vaccinated_smoothed, @vnew_people_vaccinated_smoothed_per_hundred, 
    @vstringency_index, @vpopulation_density, @vmedian_age, @vaged_65_older, @vaged_70_older, @vgdp_per_capita, @vextreme_poverty,
    @vcardiovasc_death_rate, @vdiabetes_prevalence, @vfemale_smokers, @vmale_smokers, @vhandwashing_facilities, @vhospital_beds_per_thousand,
    @vlife_expectancy, @vhuman_development_index, @vexcess_mortality_cumulative_absolute, @vexcess_mortality_cumulative, @vexcess_mortality,
    @vexcess_mortality_cumulative_per_million)
    
    SET
    iso_code = NULLIF(@viso_code,''),
    continent = NULLIF(@vcontinent,''),
    location = NULLIF(@vlocation,''),
    date = NULLIF(@vdate,''),
	total_tests	= NULLIF(@vtotal_tests,''),
	new_tests = NULLIF(@vnew_tests,''),
    total_tests_per_thousand = NULLIF(@vtotal_tests_per_thousand,''),
    new_tests_per_thousand = NULLIF(@vnew_tests_per_thousand,''),
	new_tests_smoothed = NULLIF(@new_tests_smoothed,''),
	new_tests_smoothed_per_thousand = NULLIF(@vnew_tests_smoothed_per_thousand,''),
	positive_rate = NULLIF(@vpositive_rate,''),
	tests_per_case = NULLIF(@vtests_per_case,''),
	tests_units = NULLIF(@vtests_units,''),
    total_vaccinations = NULLIF(@vtotal_vaccinations,''),
	people_vaccinated = NULLIF(@vpeople_vaccinated,''),
	people_fully_vaccinated	= NULLIF(@vpeople_fully_vaccinated,''),
    total_boosters = NULLIF(@vtotal_boosters,''),
	new_vaccinations = NULLIF(@vnew_vaccinations,''),
	new_vaccinations_smoothed = NULLIF(@vnew_vaccinations_smoothed,''),
	total_vaccinations_per_hundred = NULLIF(@vtotal_vaccinations_per_hundred,''),
	people_vaccinated_per_hundred = NULLIF(@vpeople_vaccinated_per_hundred,''),
	people_fully_vaccinated_per_hundred	= NULLIF(@vpeople_fully_vaccinated_per_hundred,''),
	total_boosters_per_hundred = NULLIF(@vtotal_boosters_per_hundred,''),
	new_vaccinations_smoothed_per_million = NULLIF(@vnew_vaccinations_smoothed_per_million,''),
	new_people_vaccinated_smoothed = NULLIF(@vnew_people_vaccinated_smoothed,''),
	new_people_vaccinated_smoothed_per_hundred = NULLIF(@vnew_people_vaccinated_smoothed_per_hundred,''),
	stringency_index = NULLIF(@vstringency_index,''),
	population_density = NULLIF(@vpopulation_density,''),
	median_age = NULLIF(@vmedian_age,''),
	aged_65_older = NULLIF(@vaged_65_older,''),
	aged_70_older = NULLIF(@vaged_70_older,''),
	gdp_per_capita = NULLIF(@vgdp_per_capita,''),
	extreme_poverty	= NULLIF(@vextreme_poverty,''),
	cardiovasc_death_rate = NULLIF(@vcardiovasc_death_rate,''),
	diabetes_prevalence	= NULLIF(@vdiabetes_prevalence,''),
	female_smokers = NULLIF(@vfemale_smokers,''),
	male_smokers = NULLIF(@vmale_smokers,''),
	handwashing_facilities = NULLIF(@vhandwashing_facilities,''),
	hospital_beds_per_thousand = NULLIF(@vhospital_beds_per_thousand,''),
	life_expectancy = NULLIF(@vlife_expectancy,''),
	human_development_index = NULLIF(@vhuman_development_index,''),
	excess_mortality_cumulative_absolute = NULLIF(@vexcess_mortality_cumulative_absolute,''),
	excess_mortality_cumulative	= NULLIF(@vexcess_mortality_cumulative,''),
    excess_mortality = NULLIF(@vexcess_mortality,''),
    excess_mortality_cumulative_per_million = NULLIF(@vexcess_mortality_cumulative_per_million,'');
  
SET UNIQUE_CHECKS = 1;

SET FOREIGN_KEY_CHECKS = 1;
  

-- Check if data has loaded properly
SELECT * FROM PortfolioProject.CovidDeaths;
SELECT * FROM PortfolioProject.CovidVaccinations;

