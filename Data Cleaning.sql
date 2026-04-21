-- DATA CLEANING --

SELECT *
FROM layoffs;

-- 1. Remove Duplicates If any
-- 2. Standardize the Data
-- 3. Null or Blank values and remove if required
-- 4. Remove any columns and rows if not required, be care.

-- Hence make sure you create Duplicate Table to be safe

-- Creating a table using LIKE to copy columns names from raw data

CREATE TABLE layoffs_stagging
LIKE layoffs;

-- Checking if the columns are reflecting

SELECT *
FROM layoffs_stagging;

-- Inserting all row values

INSERT layoffs_stagging
SELECT *
FROM layoffs;

-- Checking if all rows and data is visible

SELECT *
FROM layoffs_stagging;

-- 1. Removing Duplicates : We create ROW_NUM so that we can find duplicate row number and try deleting them, with all columns

SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_stagging;

-- NOW AS ROW_NUMBER cannot be used directly so changed to numbers instead, and date represented in backtick below esc button on keyboard as date is official term in MYSQL

-- NOW we need filter to find any row_num above 2 to find duplicates, to do this we need to make CTE, directly it will not work as it will give an error stating ROW_NUMBERS does not exist

WITH duplicate_cte AS 
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_stagging
)
SELECT *
FROM duplicate_cte
WHERE ROW_NUMBERS > 1;

-- Now just check of all possible o/p to see if any actual duplicates exist

SELECT *
FROM layoffs_stagging
WHERE company = 'Casper';

-- Now we want to delete only duplicates and not both with same values for all columns, If we use direct delete it will give error, hence we will create new table with th cte

-- ON the schemas click on layoffs_stagging, right click, select SEND TO SQL EDITOR and select create OR type the enter CREATE TABLE statement

CREATE TABLE `layoffs_stagging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT layoffs_stagging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_stagging;

-- CHECKING IF DATA IS reflecting
SELECT *
FROM layoffs_stagging2;

-- Filter with WHERE finding dow row_num is > 1

SELECT *
FROM layoffs_stagging2
WHERE row_num > 1;

-- DELETE Duplicates

DELETE
FROM layoffs_stagging2
WHERE row_num > 1;

-- Checking if deleted

SELECT *
FROM layoffs_stagging2
WHERE row_num > 1;

-- 2. Standardizing Data, finding issue like spacing, etc

SELECT DISTINCT(company)
FROM layoffs_stagging2;

-- As we see some spaces in company names E Inc, and Included Heath

SELECT company, TRIM(company)
FROM layoffs_stagging2;

-- Now we update this is the tables

UPDATE layoffs_stagging2
SET company = TRIM(company);

-- Checking if its updates from main table

SELECT *
FROM layoffs_stagging2;

-- Checking Industry Columns

SELECT DISTINCT(industry)
FROM layoffs_stagging2;

-- Now we see there are Cyrto and Cyrto Currecncy is same but different rows are created to need to standaradize that

SELECT *
FROM layoffs_stagging2
WHERE industry LIKE 'Crypto%';

-- Updating

UPDATE layoffs_stagging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- CHecking

SELECT DISTINCT(industry)
FROM layoffs_stagging2;

SELECT *
FROM layoffs_stagging2;

-- Checking localion columns

SELECT DISTINCT(location)
FROM layoffs_stagging2;

-- Everything is fine

-- Checking country

SELECT DISTINCT(country)
FROM layoffs_stagging2;

-- Checking we find 1 place it UNITED STATIES. instead of just UNITED STATES we use trim

SELECT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_stagging2
ORDER BY country;

-- All clear now update

UPDATE layoffs_stagging2
SET country = TRIM(TRAILING '.' FROM country);

-- Checking

SELECT DISTINCT(country)
FROM layoffs_stagging2;

-- Changes date which is text format to date format. The cmd is STR_TO_DATE(`date`, '%m/%d/%Y) always keep m and d in lower case and Y in upper case

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_stagging2;

-- Update the same

UPDATE layoffs_stagging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- Checking

SELECT *
FROM layoffs_stagging2;

-- Now changes the format to date, till now we just changed date type

ALTER TABLE layoffs_stagging2
MODIFY COLUMN `date` DATE;

-- Now of the schemas under colums the date should DATE format

SELECT *
FROM layoffs_stagging2;

-- 3. Nulls and Blanks

-- In industry Columns there were some NULLS and Blanks lets check.

SELECT DISTINCT(industry)
FROM layoffs_stagging2;

-- Yes there is both
-- Lets find which company has Null and Blanks

SELECT *
FROM layoffs_stagging2
WHERE industry IS NULL
	OR industry = '';

-- Now we see AIRBNB is NULL value lets check if it has Blank as well

SELECT *
FROM layoffs_stagging2
WHERE company = 'Airbnb';

-- As we see 2 rows one is blank and the other one as Travel for same location, hence industry could be Travel for both and hence we have to fill it will travel but there are changes there could be other rows with Airbnb with different location with different industry type
-- Hence we will find that by Self join

SELECT *
FROM layoffs_stagging2  AS t1
JOIN layoffs_stagging2 AS t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

-- Now we can see both company and Location same, some have null and some have blanks

-- Now we have to set t1 industry as NULL cause there is Blank on the other side

UPDATE layoffs_stagging2
SET industry = NULL
WHERE industry = '';

UPDATE layoffs_stagging2 t1
JOIN layoffs_stagging2 AS t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- Checking

SELECT *
FROM layoffs_stagging2
WHERE company = 'Airbnb';

-- Now total laid of and percentage laid off cannot be populated here since we do not have total value, hence we cannot calucate the actual value, hence we ignore

SELECT *
FROM layoffs_stagging2;

-- 4. Remove columns and rows which are not required make sure you do not do it on raw table

SELECT *
FROM layoffs_stagging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Deleting all values

DELETE 
FROM layoffs_stagging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_stagging2;

-- Deleting the extra Column as no longer required, It will ease the quering process

ALTER TABLE layoffs_stagging2
DROP COLUMN row_num;

-- Check if Column Deleted.

SELECT *
FROM layoffs_stagging2.





























