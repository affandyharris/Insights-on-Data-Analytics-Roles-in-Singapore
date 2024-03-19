/*
Q: What skills are required for the top paying data analyst jobs in Singapore?
-   Use the top 10 highest paying Singapore Data Analyst jobs from Query 1.
-   Add the specific skills required for those roles
-   Why? To provide a detailed look at which high-paying jobs demand certain skills,
    helping job seekers understand which skills to develop to align with top salaries.
*/


WITH top_paying_jobs AS (
SELECT  
    job_id,
    job_title,
    name AS company_name,
    salary_year_avg
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
LIMIT 10)

SELECT 
    tpj.*,
    sk.skills
FROM 
    top_paying_jobs tpj
INNER JOIN 
    skills_job_dim sj ON tpj.job_id = sj.job_id
INNER JOIN 
    skills_dim sk ON sk.skill_id = sj.skill_id
ORDER BY 
    salary_year_avg DESC;