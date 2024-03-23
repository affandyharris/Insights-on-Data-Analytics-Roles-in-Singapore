# Introduction
Dive into the Singaporean Data Analytics job market! This project explores top paying jobs, in demand skills, where high demand meets high salary in data analytics

SQL Queries? Find them here: [project_sql folder](/project_sql/)

# Background
As I aim to navigate this industry effectively, this project was born from a desire to pinpoint what I need and what I can expect from Data Analyst roles in Singapore. 

Data hails from an online [SQL Course](https://www.lukebarousse.com/sql). It's packed with key information not just for roles in  Singapore, but worldwide!

### The questions I wanted to answer through my SQL Queries were:

1. What are the top-paying data analyst jobs in Singapore?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts in Singapore?
4. Which skills are associated with higher salaries? 
5. What are the most optimal skills to learn?

# Tools I Used
For my deep dive, I used several key tools:
- **SQL:** The backbone of my analysis, allowing me to query and unearth critical insights.
- **PostreSQL:** The chosen database management system, ideal for handling the job-posting data.
- **Visual Studio Code:** My go-to for database management and executing SQL queries.
- **Git & Github:** Essential for version control and sharing my scripts and analysis, ensuring collaboration and project tracking.

# The Analysis
Each query for this project is aimed at investigating specific aspects of the Singaporean data analyst job market. Here's how I approached each question:

### 1. Top Paying Data Analyst Jobs in Singapore
To identify such roles, I filtered data analyst positions by average yearly salary, focusing on postings based in Singapore. This query highlights the highest paying opportunities in this field.

```sql
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
```
Here's a breakdown of insights from top paying data analyst roles in Singapore in 2023:

- **Salary Range:**
Top 10 annual salaries range from $100,000 to $150,000.

- **Company Type:**
Job postings for the top 10 highest paying jobs in Singapore came from well-established MNCs from various industries.

### 2. Skills Required For Top-Paying Data Analyst Roles in Singapore

To find out the skills that high-paying companies call for, I reused my first query, and inner-joined that resulting table with the **skills_job** table. 

```sql
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
```
From this query, I learned that: 
- **Most Popular Top-Paying Skills:** 
The most desirable skills from these companies are **Python (6)**, followed by **SQL (4)**, **Spark (4)** and **Tableau (4)**.

- **Bosch's Focus:**
Bosch Group, the company with the highest paying listings, focuses on Spark and Python as their desired skills in applicants. 

### 3. The most in-demand skills for high-paying data
As an extension to Query 2, I wanted to find out what which skills are the most in-demand for Data Analyst roles in Singapore as a whole. I used an inner-join on Data Analyst job postings in Singapore and the skills demanded to aggregate the top 5 in-demand skills. 

```sql
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
```
This query shed light that: 
- **Most In-Demand Skills:** 
Most employers require applicants to know **SQL (3635)**, followed by **Python (3080)**. This is different than what we saw in Query 2. Seems like I made the best choice by learning SQL first! 

### 4. The Highest Paying Skills 
Previously, we saw how many job postings required a certain skill. Now, I wanted to know which skills are the generally highest paying! I obtained the average yearly salary of job postings for the top 25 highest paying skills by:

```sql
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
```
I learned even more from another perspective! This showed the: 
- **Prevalance of SQL, MS Office and Python Related Skills:** 
Within the top 25 highest paying skills, many were extensions of these core skills, such as **Looker ($111175)**, **MS Word ($105838)**, and **Pandas ($100500)**. 

### 5. The Most Optimal Skills to Learn
Finally, I wanted to know which skills are the most optimal, meaning that they have high demand and high salaries amongst listings that specify salaries. I did this by creating CTEs and inner-joining previous queries. 

```sql 
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
```
This showed me that amongst companies that specify yearly salaries on their listings, :
- **The Most In-demand Skills:** 
**SQL (15)** and **Python (12)** top the demand list with 15 and 12 respectively, but are not the highest paying.

- **The Highest Paying Skills:**
**Spark ($121,027)** and **Looker ($111,175)** top this list, but are not the most in-demand. 


# What I Learned
These queries gave me great insight into what I can expect as the Data Analyst in Singapore! Namely:

- **SQL and Python are reliable skills to learn:** 
Both skills are well in demand and pay relatively highly. And are used to branch out into more specific skills as well.

- **Balance between demand and salary:**
Jobs that are high in demand do not pay the highest, often times niche skills pay more. There seems to be an opportunity cost we pay if we have to decide between the two! 

# Conclusions
As an undergraduate who seeks to delve into Data Analytics, this project has opened my eyes to the reality of the industry and gives me the ability to make realistic expectations as I transition into full-time work. 

Furthermore, I now see firsthand how versatile SQL is, and that it can and should be used to optimise our decision-making on a day to day basis! What a useful tool to have today - I will definitely be developing my abilities in this skill moving forward!

