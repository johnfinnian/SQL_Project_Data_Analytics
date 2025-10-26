# Introduction
This project is a deep dive into the data job market, with a major focus on data analyst roles. It explores top-paying jobs, in-demand skills, and where high demand jobs meet high salaries in data analytics.

SQL queries? Check the out here:  [project_sql folder](/project_sql/)


# Background 
This project emerged from a commitment to understand and effectively navigate the data analyst job market, focusing on identifying top-paying and in-demand skills to guide professionals toward the most rewarding career paths.

Data hails from my [SQL Course](https://lukebarousse.com/sql). It's packaged with insights on job titles, salaries, locations, and essential skills.

### The questions i wanted to answer through my SQL queries were:
1. What are the top paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in-demand for data analysts?
4. What skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I Used
For my deep dive tinto the data analyst job market, i harnessed the power of several key tools:

- **SQL:** The backbone of my data analysis, allowing me to query the database and unearth critical insights.
- **PostgreSQL:** The chosen database management system, ideal for handling the job posting data.
- **Visual Studio Code:** My go-to for data management and executing SQL queries.
- **Git & GitHub:** Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.  

# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market.
Here is how I approached each question:

### 1. Top Paying Data Analyst Jobs
To to identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.

  ```sql 
SELECT
    job_id,
    job_title_short,
    job_location,
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
```
Here's the breakdown of the top data analyst jobs in 2023:
- **Wide Salary Range:** Top 10 paying data analyst roles span from $186,000 to $650,000, indicating  significant salary potential in the field.
- **Diverse Employers** Companies like SmartAsset, Mata, and AT&T are among those offering high salaries, showing a broad interest across different industries.
- **Job Title Variety:** There's a high diversity in job title, from Data Analyst and Senior Data Analyst, reflecting valid roles and specializations within data analytics. 

![Top Paying Roles](assets\1_Top_10_Paying_Roles.png)

*Bar graph visualizing the salary for the top 10 salaries for data analysts with respect to companies; ChatGPT generated this graph from my SQL query result*

### 2. Top Paying Job Skills 
To understand what skills are required for top-paying jobs, I joined the job postings with the skills data, providing insights into what the empoyers value for high-compensation roles.


```sql
WITH top_paying_jobs AS (
SELECT
    job_id,
    job_title_short,
    salary_year_avg,
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
LIMIT 
    10
    )
SELECT 
    top_paying_jobs.*,
    skills
FROM 
    top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY 
    salary_year_avg DESC
```

Here is the break down of most demanded skills for the top 10 highest paying Data Analyst jobs in 2023:

- **SQL** is leading with a bold count of 8
- **Python** follows closely with a bold count of 7
- **Tableau** is also highly sough after with a bold count of 6. Other skills like **R**, **Snowfkake**, **Pandas**, and **Excel** show varying degree of demand.

![Top Paying Job Skills](assets\2_Top_10_in-demand_skills.jpeg)
*Bar graph visualizing the count of skills for the top 10 paying jobs for Data Analyst; ChatGPT generate this graph from my SQL query results*

### 3. In-Demand Skills for Data Analysts
This query helped identify skills most frequently requested in job postings, directing focus in areas with high demand.

```sql
SELECT 
    skills,
    COUNT (job_postings_fact.job_id) AS demand_count
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_work_from_home IS TRUE
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5
```
Here is the breakdown of most demanded skills for Data Analysts in 2023:

**SQL** and **Excel** remain fundamental, emphasizing the need for strong foundational skills in data processing and spreadsheet manipulation.
**Programming** and **Visualization** **Tools** like **Python**, **Tableau**, and **Power BI** are essential, pointing towards the increasing importance of technical skills in data storytelling and decision support.


| Rank | Skill         | **Demand Count** | Core Use Case / Value                                                             |
| ---- | ------------- | ---------------- | --------------------------------------------------------------------------------- |
| 1    | **SQL**       | **7291**         | Core skill for extracting, cleaning, and managing data from relational databases. |
| 2    | **Python**    | **4611**         | Key for automation, data manipulation, and machine learning integration.          |
| 3    | **Tableau**   | **4330**         | Vital for creating visual reports and interactive dashboards.                     |
| 4    | **R**         | **3745**         | Used for statistical analysis and research-driven data modeling.                  |
| 5    | **Snowflake** | **2609**         | Cloud data platform enabling scalable data storage and analysis.                  |

*Table of demand for the top 5 skills in data analyst postings*

## 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```sql 
SELECT
    skills,
    ROUND (AVG (salary_year_avg),0) AS avg_salary
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL
    AND job_work_from_home is TRUE
GROUP BY skills
ORDER BY avg_salary DESC
LIMIT 25
```
Here is a breakdown of the top paying skills for Data Anaylsts:
- **High Demand for Big Data & ML Skills:** Top salaries are commanded by analyst skilled in big data technologies (PaySpark, Couchbase), Machine learning tools (DataRobot, Jupyter), and Python libraries (Pandas,NumPy), reflecting the industries high valuation of data processing and predictive modeling capabilities.
- **Software Development & Deployment Proficiency:** Knowledge in development and development tools (GitLab, Kubernetes, Airflow) indicates a lucrative crossover between data analysis and engineering, with a premium on skills that facilitate automation and efficient pipeline management.
- **Cloud Computing Expertise:** Familiarity with cloud and data engineering tools (Elasticsearch, Databricks, GCP) underscores the growing importance of cloud-based analytics environments,suggesting that cloud proficiency significantly boosts earning potential in data analytics. 


| Skills	|Average Salary (USD)|
|-----------|--------------------|
|PySpark |$208,172|                                                             
|Bitbucket |$189,155|
|Couchbase |$160,515|
|Watson |$160,515|
|Datarobot |$155,486|
|Gitlab |$156,500|
|Swift |$153,750|
|Jupyter |$152,777|
|Pandas |$151,821|
|Elasticsearch |$145,000|

*Table of the average salary for the top 10 paying skills for data analysts*

## 5. Most Optimal Skills to Learn
Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```sql
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT (skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg),0) 
    AS avg_salary

FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND 
    job_work_from_home = TRUE

GROUP BY
    skills_dim.skill_id
HAVING COUNT (skills_job_dim.job_id) >10
ORDER BY 
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
```

|Skill ID |Skills |Demand Count |Average Salary ($)|
|---------|-------|-------------|------------------|
|8        |go     | 27          |   115,320|
|234      |confluence| 11       |   114,210|
|97       |hadoop |  22         |   113,193|
|80       |snowflake | 37       |   112,948|
|74       |azure |   34         |   111,225|
|77       |bigquery| 13         |   109,654|
|76       | aws     | 32        |   108,317|
|4        | java    | 17        |   106,906|
|194      |ssis   |   12        |   106,683|
|233      |jira    |20          |   104,918|

*Table of the most optimal skills for data analyst sorted by salary*

Here is the breakdown of the most optimal skills for Data Analysts in 2023:
- **High-Demand Programming Languages:** Python and R stand out for their high demand, with demand counts of 236 and 148 respectively. Despite their high demand,their average salaries are around $101,397 for Python and $100,499 for R, indicating that proficiency in these languages is highly value but also widely available.
- **Cloud Tool and Technologies:** Skills in specialized technogies such as Snowflake, Azure, AWS, and BigQuery show significant demand with relatively high average salaries, pointing towards the growing importance of cloud platforms and big data technologies in data analysis.
- **Business Intelligence and Visualization Tools:** Tableau and Looker, with damand counts 230 and 49 respectively, and average salaries around $99,288 and $103,795, highlight the critical role of data visualization and business intelligence in driving actionable insights from data. 
- **Datebase Technologies:** The demand for skills in traditional and NoSQL databases (Oracle, SQL Server, NoSQL) which average salaries ranging from $97,786 to $104,534, reflects the enduring need for data storage, retrieval, and management expertise.  

# What I Learned

It’s been an exciting and rewarding learning journey, giving me a real sense of accomplishment and confidence in my growing data skills.

After completing a comprehensive 4-hour hands-on SQL course, I gained practical experience in writing and optimizing queries, analyzing data, and turning questions into insights.

- **Complex Query Crafting:** Learned to construct advanced SQL queries, join multiple tables seamlessly, and apply WITH clauses to create efficient temporary tables.

- **Data Aggregation Mastery:** Got comfortable using GROUP BY, COUNT(), AVG(), and other aggregate functions to summarize and interpret large datasets.

- **Analytical Problem-Solving:** Strengthened my ability to approach real-world data challenges logically and convert problems/questions into actionable insights through SQL.

# Conclusions  
### Insights
1. **Top-Paying Data Analyst Jobs:** The highest paying Data Analyst jobs that allow remote work offer a wide rang of salaries, the highest at $650,000!
2. **Skills for Top-Paying Jobs:** High-Paying Data Analylst jobs require advanced proficiency in SQL, suggesting it to be a critical skill for earning a top salary.
3. **Host In-Demand Skills:** SQL is also the most demand skill un the data analyst job market, thus making it essential for job seekers.
4. **Skills with Higher Salaries:** Specialized skills, such as SVN and Solidity, indicating a premium on niche expertise.
5. **Optimal Skills for Job Market Value:** SQL leads in demand and offers for a high average salary, postion it as one of the most optimal skills for data analysts to learn to maximize their market value.

### Closing Thoughts 
This project enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serves as a guide to prioritizing skill development and job search efforts. Aspiring data anaylsts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of contineous learning and adaptation to emerging trends in the field of data analytics.