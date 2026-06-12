CREATE DATABASE project;

USE project;


####### DATA CLEANING #######


## Importing the Dataset

## Basic Structure Understanding
 
# VIEW THE TABLE

SELECT * from layoffs;

# COLUMN INFORMATION

DESCRIBE layoffs;

# COUNTING THE ROWS

SELECT COUNT(*) AS total_rows_in_layoffs
FROM layoffs;
'''total rows - 2631'''


# Creating a duplicate table same as "layoffs"

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT * FROM layoffs_staging;


# Inserting same data in the duplicate table

INSERT layoffs_staging
SELECT * FROM layoffs;

SELECT * FROM layoffs_staging;



# CHECK FOR DUPLICATES

WITH duplicate_cte AS (
    SELECT *,
	ROW_NUMBER() OVER(PARTITION BY company,location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, 
    funds_raised_millions) AS row_num
    FROM layoffs_staging
)

SELECT *
FROM duplicate_cte
WHERE row_num > 1;



# Creating another table for removing the duplicates 

CREATE TABLE layoffs_staging2 (
   company text,
   location text,
   industry text,
   total_laid_off int DEFAULT NULL,
   percentage_laid_off text,
   date text,
   stage text,
   country text,
   funds_raised_millions int DEFAULT NULL,
   row_num INT
);

SELECT * FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
	ROW_NUMBER() OVER(PARTITION BY company,location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, 
    funds_raised_millions) AS row_num
    FROM layoffs_staging;

### STEP 1. REMOVE DUPLICATES

# Deleting the duplicates

DELETE
FROM layoffs_staging2
WHERE row_num > 1;

SELECT * FROM layoffs_staging2
WHERE row_num > 1;

SELECT * FROM layoffs_staging2;

### STEP 2. STANDARDIZING THE DATA

#company

SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

#industry

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';


SELECT DISTINCT industry
FROM layoffs_staging2;

#country

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE country LIKE 'United States%'
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;


''' changing date datatype '''

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y')

# Changing the datatype of "DATE"

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;


SELECT * FROM layoffs_staging2;

### STEP 3. NULL VALUES OR BLANK VALUES 

# To check the null values in the dataset 

SELECT * 
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

SELECT * 
FROM layoffs_staging2
WHERE company = 'Airbnb';


SELECT t1.industry, t2.industry
FROM layoffs_staging2 AS t1
JOIN layoffs_staging2 AS t2
	ON t1.company = t2.company 
    AND t1.location = t2.location 
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

# updating all the industry values which is blank to NULL values then NULL to their respective values as mentioned in the dataset

UPDATE layoffs_staging2
SET industry = NULL 
WHERE industry = '';


UPDATE layoffs_staging2 AS t1
JOIN layoffs_staging2 AS t2
	ON t1.company = t2.company 
SET t1.industry = t2.industry 
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

# Deleting the rows where total_laid_off & percentage_laid_off values are null values as it doesn't support any real meaning to dataset

SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * FROM layoffs_staging2;

### Step 4. REMOVE ANY COLUMNS

# removing the extra column "row_num"

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT * FROM layoffs_staging2;




###### EXPLORATORY DATA ANALYSIS ######


SELECT * FROM layoffs_staging2;

# total layoffs

SELECT MAX(total_laid_off), 
	   MAX(percentage_laid_off) 
FROM layoffs_staging2;

# check where pecentage_laid_off is '1' i.e. 100 percent laid off where fund raised is highest

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

# check the total laid off grouped by the company 

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;   # 2 means SUM(total_laid_off)

# check the total laid off grouped by the industry

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

# check the total laid off grouped by the country

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

# check the total laid off grouped by the year

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT MIN(`date`),  
	   MAX(`date`)
FROM layoffs_staging2;

# check the total laid off grouped by the month (rolling total)

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_layoffs, SUM(total_layoffs) OVER(ORDER BY `MONTH`) AS rolling_total
FROM rolling_total;


# check the total laid off grouped by the stage

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

# check the total laid off grouped by the company by years (ranking as per highest layoffs)

WITH Company_Year AS
(
SELECT company,
	   YEAR(`date`) AS Years,
       SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(SELECT *, 
        DENSE_RANK() OVER (PARTITION BY years ORDER BY total_layoffs DESC) AS Ranking
FROM Company_Year
WHERE Years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;