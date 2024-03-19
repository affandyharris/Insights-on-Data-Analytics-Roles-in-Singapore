/*
Q: What are the top skills based on salary for Data Analysts in Singpoare?
-   Look at the average salary associated with each skill for Data Analysts in Singapore.
-   Focuses on roles with specified salaries.
-   Why? It reveals how different skills impact salary levels toward Data Analysts and helps
    identify the most financially rewarding skills to acquire or improve.
*/

SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS average_salary
FROM 
    job_postings_fact jp
INNER JOIN 
    skills_job_dim sj ON jp.job_id = sj.job_id
INNER JOIN 
    skills_dim sk ON sk.skill_id = sj.skill_id
WHERE 
    jp.job_location = 'Singapore' AND
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
GROUP BY    
    skills
ORDER BY 
    average_salary DESC
LIMIT 25;
