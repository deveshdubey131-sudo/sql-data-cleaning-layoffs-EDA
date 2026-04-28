
# Global Layoffs Data Cleaning and Exploratory Data Analysis using SQL

# About :

This project focuses on transforming raw layoffs data into a clean, analysis-ready dataset and performing exploratory data analysis (EDA) to uncover trends across companies, industries, countries, and time. It demonstrates practical SQL techniques used in real-world data preparation and business insight generation.

# Purpose of the Project :

To clean inconsistent and messy real-world data
To ensure data reliability before analysis
To identify key layoff trends across different dimensions
To support business-level decision-making using data insights

# Skills Required :

SQL (Intermediate to Advanced)
Data Cleaning Techniques
Window Functions (ROW_NUMBER, DENSE_RANK)
Data Transformation (TRIM, STR_TO_DATE, ALTER)
Aggregations (SUM, COUNT, MAX, MIN)
Joins (including Self Join)
CTEs (Common Table Expressions)
Exploratory Data Analysis (EDA) mindset

# Different Analysis Done :

1. Data Cleaning Analysis
Duplicate detection and removal using window functions
Standardization of categorical fields (company, industry, country)
Date format conversion (text → date)
Handling missing and blank values intelligently
Data enrichment using self-joins
Removal of irrelevant rows and columns
2. Descriptive Analysis
Maximum and minimum layoffs in a single record
Count of companies with 100% layoffs
3. Company-Level Analysis
Total layoffs per company
Identification of companies with highest layoffs
4. Industry-Level Analysis
Total layoffs by industry
Identification of most affected sectors
5. Geographic Analysis
Layoffs distribution by country
Identification of most impacted regions
6. Time-Based Analysis
Year-wise layoffs trend
Identification of peak layoff year
7. Trend & Ranking Analysis
Yearly layoffs per company
Top companies per year using DENSE_RANK()
Comparative performance across years

# Business Questions To Answer :

Which companies had the highest layoffs overall?
Which industries were most impacted?
Which country experienced the highest layoffs?
Which year saw the peak layoffs?
How many companies had complete (100%) layoffs?
Which companies dominated layoffs in each year?
Are layoffs concentrated in specific industries or spread across sectors?
Is there a visible trend or spike in layoffs over time?

# Data Challenges Identified :

Inconsistent text data (e.g., “Crypto” vs “Crypto Currency”)
Missing industry values
Duplicate records across multiple columns
Date stored as text
Blank vs NULL confusion
Incomplete data (cannot derive some metrics like exact percentages)
(Added) Key Insights (from your analysis) :
A few large companies contribute heavily to layoffs
Consumer industry shows highest impact
United States dominates layoff numbers
Layoffs peaked significantly in 2022
Some companies completely shut down (100% layoffs)


