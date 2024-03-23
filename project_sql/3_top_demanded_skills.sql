/*
Q: What are the most in-demand skills for data analysts in Singapore?
-   Join job postings to inner join table similiar to Query 2.
-   Identify the top 5 in-demand skills for a data analyst in Singapore
-   Focus on all Data Analyst job postings
-   Why? Retrieves the top 5 skills with the highest demand in the job market,
    providing insights into the most valuable skills for job seekers
*/

SELECT 
    skills,
    COUNT(jp.job_id) AS demand_count
FROM 
    job_postings_fact jp
INNER JOIN 
    skills_job_dim sj ON jp.job_id = sj.job_id
INNER JOIN 
    skills_dim sk ON sk.skill_id = sj.skill_id
WHERE 
    jp.job_location = 'Singapore' AND
    jp.job_title_short = 'Data Analyst'
GROUP BY    
    skills
ORDER BY 
    demand_count DESC
LIMIT 5;