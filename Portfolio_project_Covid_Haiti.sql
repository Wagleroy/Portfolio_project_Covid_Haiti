select date 
from portfolioproject..coviddeaths

select date,convert (date,date) 
from portfolioproject..coviddeaths


Alter table portfolioproject..coviddeaths
add converted_date date;

update portfolioproject..coviddeaths
set converted_date= convert (date,date)

select converted_date 
from portfolioproject..coviddeaths
--------

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
from portfolioproject..coviddeaths
where location ='Haiti'
order by 1,2

select location, converted_date,population, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathpercentage
from portfolioproject..coviddeaths
where location= 'Haiti'
and total_deaths is not null
order by 1, 2

select location, converted_date,population, total_cases, new_cases, total_deaths
from portfolioproject..coviddeaths
where location='haiti'
order by 1, 2

select location, converted_date,population, total_cases, (total_cases/population)*100 as casespercentage
from portfolioproject..coviddeaths
where location='haiti'
order by 1, 2

------------

select date 
from portfolioproject..covidvaccinations

select date,convert (date,date) 
from portfolioproject..covidvaccinations



Alter table portfolioproject..covidvaccinations
add converted_date date;

update portfolioproject..covidvaccinations
set converted_date= convert (date,date)

select converted_date 
from portfolioproject..covidvaccinations

-------
select dea.location,dea.converted_date, dea.population, vac.new_vaccinations
from portfolioproject..coviddeaths dea
join portfolioproject..covidvaccinations vac
on dea.location= vac.location
and dea.converted_date= vac.converted_date
where dea.location='Haiti'
and new_vaccinations is  not null
order by 2,3


select dea.location,dea.converted_date, dea.population, vac.new_vaccinations, Sum(CONVERT (bigint,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from portfolioproject..coviddeaths dea
join portfolioproject..covidvaccinations vac
on dea.location= vac.location
and dea.date= vac.date
where dea.location='haiti'
and new_vaccinations is  not null
order by 2,3

With popvsvac (location,converted_date,population, new_vaccinations, rollingpeoplevaccinated)
as
(
select dea.location,dea.converted_date, dea.population, vac.new_vaccinations, Sum(CONVERT (bigint,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.converted_date) as rollingpeoplevaccinated
from portfolioproject..coviddeaths dea
join portfolioproject..covidvaccinations vac
on dea.location= vac.location
and dea.converted_date= vac.converted_date
where dea.location='Haiti'
and new_vaccinations is not null
)
select*, (Rollingpeoplevaccinated/population)*100 as peoplevaccinatedpercentage
from popvsvac