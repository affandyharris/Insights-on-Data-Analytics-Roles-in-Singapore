/* 
Q : What are the top paying data analyst roles?
- Identify the top 10 highest paying data analyst roles in Singapore.
- Focus on the job postings with specified salaries (remove NULLs).
- Why? Highlight the top-paying opportunities for Data Analysts, offering insights into employment.
*/

SELECT  
    job_id,
    job_title,
    name AS company_name,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM 
    job_postings_fact
LEFT JOIN
    company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_title_short = 'Data Analyst' AND 
    job_location = 'Singapore' AND 
    salary_year_avg IS NOT NULL
ORDER BY 
    salary_year_avg DESC
LIMIT 10;
