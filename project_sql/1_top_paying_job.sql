/* What are the top paying data analyst jobs?
-Identify the top 10 highest paying data analyst roles that are available remotely
-Focuses on job postings with specified salaries (remove nulls)
-Why? Highlight the top paying opportunity for data analysts, offering insights into empoyments*/

SELECT
    job_id,
    job_title_short,
    job_location,WITH remote_job_skills AS 
    (SELECT
        COUNT (*) AS skill_count,
        skill_id
    FROM skills_job_dim
    INNER JOIN job_postings_fact AS job_postings ON skills_job_dim.job_id
        = job_postings.job_id
    WHERE job_postings.job_work_from_home IS TRUE AND job_title_short = 'Data Analyst'
    GROUP BY skill_id) 
SELECT 
    skills_dim.skills AS skill_name,
    remote_job_skills.skill_id,
    skill_count
FROM remote_job_skills
INNER JOIN skills_dim ON remote_job_skills.skill_id = 
skills_dim.skill_id
ORDER BY skill_count DESC
LIMIT 5WITH remote_job_skills AS 
    (SELECT
        COUNT (*) AS skill_count,
        skill_id
    FROM skills_job_dim
    INNER JOIN job_postings_fact AS job_postings ON skills_job_dim.job_id
        = job_postings.job_id
    WHERE job_postings.job_work_from_home IS TRUE
    GROUP BY skill_id) 
SELECT 
    skills_dim.skills AS skill_name,
    remote_job_skills.skill_id,
    skill_count
FROM remote_job_skills
INNER JOIN skills_dim ON remote_job_skills.skill_id = 
skills_dim.skill_id
ORDER BY skill_count DESC
LIMIT 5
    salary_year_avg,
    job_schedule_type,
    job_posted_date,
    name AS company_name
FROM 
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id =
    company_dim.company_id
WHERE 
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10