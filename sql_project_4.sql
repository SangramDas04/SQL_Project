-- Create Table
create table hrdata
(
	emp_no int8 PRIMARY KEY,
	gender varchar(50) NOT NULL,
	marital_status varchar(50),
	age_band varchar(50),
	age int8,
	department varchar(50),
	education varchar(50),
	education_field varchar(50),
	job_role varchar(50),
	business_travel varchar(50),
	employee_count int8,
	attrition varchar(50),
	attrition_label varchar(50),
	job_satisfaction int8,
	active_employee int8
);

-- import data in table using query
Copy file_name from 'location' DELIMITER ',' CSV HEADER;

select * from hrdata;

-- Employee Count:
select sum(employee_count) from hrdata;

-- Employee Count by applying filters:
select sum(employee_count)
from hrdata
where education = 'High School'

select sum(employee_count)
from hrdata
where department = 'R&D'

select sum(employee_count) as employee_count
from hrdata
where education_field = 'Medical';


-- Attrition Count:
select count(attrition) 
from hrdata
where attrition = 'Yes';

select count(attrition) 
from hrdata
where attrition = 'Yes' 
and education = 'Doctoral Degree';

select count(attrition) 
from hrdata
where attrition = 'Yes' 
and department = 'R&D';

select count(attrition) 
from hrdata
where attrition = 'Yes' 
and department = 'R&D' 
and education_field = 'Medical';

select count(attrition) 
from hrdata
where attrition = 'Yes' 
and department = 'R&D' 
and education_field = 'Medical'
and education = 'High School';


-- Attriton Rate
select round(count(attrition)/(select sum(employee_count) from hrdata) * 100,2)
from hrdata
where attrition = 'Yes';
-- OR
select 
round (((select count(attrition) from hrdata where attrition='Yes')/ 
sum(employee_count)) * 100,2)
from hrdata;

-- Attriton Rate by applying filters
select round(count(attrition)/(select sum(employee_count) from hrdata where department = 'Sales') * 100,2)
from hrdata
where attrition = 'Yes'
and department = 'Sales';
-- OR
select round(((select count(attrition) from hrdata where department = 'Sales' and attrition = 'Yes')/sum(employee_count)) * 100,2)
from hrdata
where department = 'Sales';


-- Active Employee:
select sum(employee_count) - (select count(attrition) from hrdata where attrition = 'Yes')
from hrdata;

-- Active Employee by applying filters
select sum(employee_count) - (select count(attrition) from hrdata where attrition = 'Yes' and gender = 'Male')
from hrdata
where gender = 'Male';


-- Average Age:
select round(avg(age),0) as avg_age from hrdata;


-- Attrition by Gender
select gender, count(attrition)
from hrdata
where attrition = 'Yes'
group by gender;

-- Active Employee by applying filters
select gender, count(attrition)
from hrdata
where attrition = 'Yes' and education = 'High School'
group by gender;


-- Department wise Attrition:
select department, count(attrition)
from hrdata
where attrition = 'Yes'
group by department; 

select department,count(attrition),round((cast(count(attrition) as numeric)/(select count(attrition) from hrdata where attrition = 'Yes')) * 100,2) as pct
from hrdata
where attrition = 'Yes'
group by department; 

-- Department wise Attrition by applying filters:
select department,count(attrition),round((cast(count(attrition) as numeric)/(select count(attrition) from hrdata where attrition = 'Yes' and gender = 'Female')) * 100,2) as pct
from hrdata
where attrition ='Yes' and gender = 'Female'
group by department;


-- No of Employee by Age Group
select age,sum(employee_count)
from hrdata
group by age
order by age;

-- No of Employee by Age Group by applying filters
select age,sum(employee_count)
from hrdata
where department = 'R&D'
group by age
order by age;


-- Education Field wise Attrition:
select education_field,count(attrition)
from hrdata
where attrition = 'Yes'
group by education_field
order by count(attrition) desc;

-- Education Field wise Attrition by applying filters
select education_field,count(attrition)
from hrdata
where attrition = 'Yes' and department = 'Sales'
group by education_field
order by count(attrition) desc;


-- Attrition Rate by Gender for different Age Group
select age_band,gender,count(attrition)
from hrdata
where attrition = 'Yes'
group by age_band,gender
order by age_band,gender;

select age_band,gender,count(attrition),round(((cast(count(attrition) as numeric))/(select count(attrition) from hrdata where attrition = 'Yes'))*100,2)
from hrdata
where attrition = 'Yes'
group by age_band,gender
order by age_band,gender;


-- Job Satisfaction Rating
-- -Run this query first to activate the cosstab() function in postgres
CREATE EXTENSION IF NOT EXISTS tablefunc;

SELECT *
FROM crosstab(
  'SELECT job_role, job_satisfaction, sum(employee_count)
   FROM hrdata
   GROUP BY job_role, job_satisfaction
   ORDER BY job_role, job_satisfaction'
	) AS ct(job_role varchar(50), one numeric, two numeric, three numeric, four numeric)
ORDER BY job_role;


-- No of employees by age group
select age_band,gender,sum(employee_count) 
from hrdata
group by age_band,gender
order by age_band,gender desc;










