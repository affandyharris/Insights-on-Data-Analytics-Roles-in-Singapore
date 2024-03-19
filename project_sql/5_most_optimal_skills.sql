/*
Q:  What are the most optimal skills to learn as a Data Analyst in Singapore?
    (aka it's high in demand and high paying)
-   Identify skills in high demand associated with high average salaries for 
    Data Analyst roles in Singapore.
-   Concentrates on roles in Singapore with specified salaries.
-   Why? Targets skills that offer high job security (high demand) and financial
    benefits (high salaries), offering strategic insights for career development.
*/

WITH skills_demand AS (
    SELECT 
        skills_job_dim.skill_id,
        skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM 
        job_postings_fact
    INNER JOIN 
        skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN 
        skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
    WHERE 
        job_postings_fact.job_location = 'Singapore' AND
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL
    GROUP BY    
        skills_job_dim.skill_id,
        skills),

salary_averages AS (
    SELECT 
        skills_job_dim.skill_id,
        ROUND(AVG(salary_year_avg), 0) AS average_salary
    FROM 
        job_postings_fact 
    INNER JOIN 
        skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN 
        skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
    WHERE 
        job_postings_fact.job_location = 'Singapore' AND
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL
    GROUP BY    
        skills_job_dim.skill_id)

SELECT 
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    average_salary
FROM    
    skills_demand
INNER JOIN salary_averages ON skills_demand.skill_id=salary_averages.skill_id
ORDER BY 
    demand_count DESC,
    average_salary DESC;