# Global-Layoffs-Data-Cleaning-Exploratory-Data-Analysis-MySQL
SQL project focused on cleaning and analyzing global layoffs data using MySQL, window functions, CTEs, and aggregate queries to uncover trends and insights.


📌 Project Overview

This project demonstrates a complete SQL workflow involving data cleaning and exploratory data analysis (EDA) on a global layoffs dataset.

Using MySQL, the raw dataset was cleaned, standardized, and analyzed to uncover trends related to layoffs across companies, industries, countries, and years.

The project showcases practical SQL skills commonly used by Data Analysts, including window functions, Common Table Expressions (CTEs), joins, aggregations, and ranking techniques.

🎯 Objectives
Clean and prepare raw data for analysis.
Identify and remove duplicate records.
Standardize inconsistent values.
Handle missing and null values.
Perform exploratory data analysis to discover patterns and trends.
Generate business insights from the layoffs data.
🛠 Tools & Technologies
MySQL
SQL
Window Functions
Common Table Expressions (CTEs)
Aggregate Functions
Joins
Ranking Functions
📂 Dataset

The dataset contains information regarding:

Company
Location
Industry
Total Employees Laid Off
Percentage of Workforce Laid Off
Date
Company Stage
Country
Funds Raised
🧹 Data Cleaning Process
Step 1: Creating a Staging Table
Created duplicate tables to preserve the original data.
Inserted raw data into staging tables for transformation.
Step 2: Removing Duplicate Records

Used:

ROW_NUMBER()
PARTITION BY
CTEs

to identify and eliminate duplicate rows.

Step 3: Standardizing Data

Performed:

Trimming company names.
Standardizing industry names.
Formatting dates.
Cleaning country values.
Filling missing industry values using self joins.
Step 4: Handling Missing Values
Identified null values.
Removed rows containing no meaningful layoff information.
Updated missing values where possible.
Step 5: Removing Unnecessary Columns

Dropped helper columns used during the cleaning process.

📈 Exploratory Data Analysis

The analysis answers several business questions:

🔹 Which companies had the highest number of layoffs?

Calculated total layoffs by company.

🔹 Which industries were most affected?

Aggregated layoffs across industries to identify heavily impacted sectors.

🔹 Which countries experienced the highest layoffs?

Compared layoffs among countries.

🔹 How did layoffs vary over time?

Analyzed layoffs by year and month.

🔹 What were the monthly rolling totals?

Used window functions to calculate cumulative layoffs over time.

🔹 Which company stages experienced the most layoffs?

Compared layoffs among:

Seed
Series A
Series B
IPO
Post-IPO companies
🔹 Top Companies by Year

Applied:

DENSE_RANK()
Window Functions

to identify the top companies with the highest layoffs each year.

💡 SQL Concepts Demonstrated
Data Cleaning

✔ Removing Duplicates

✔ Handling Null Values

✔ Data Standardization

✔ Updating Records

✔ Table Alterations

