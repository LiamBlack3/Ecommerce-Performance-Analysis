# E-Commerce Website Analysis - README

## Project Overview

Tasked with analyzing online retailers website's performance using data gathered from Google Analytics (GA). Utilizing two GA datasets containing basic e-commerce metrics, I processed and summarized the website performance, offering crucial insights.

## Datasets

I worked with two primary datasets:

1. **sessionCounts.csv**: 
   - Contains metrics about sessions, transactions, and quantity (QTY).
   - Data is delineated by browser, device category, and date.

2. **addsToCart.csv**: 
   - Details the 'add to cart' actions broken out by month.

## Analysis

The analysis involved crafting an R script that programmatically outputs an Excel file (.xlsx) with two primary worksheets serving as reference tables:

### Worksheet 1: Month * Device Aggregation

- Data aggregated by month and device, showcasing metrics such as Sessions, Transactions, QTY, and ECR (Transactions divided by Sessions).

### Worksheet 2: Month-over-Month Comparison

- Data comparison between the two most recent months.
- Showcases metrics, including both absolute and relative differences.

For a detailed understanding, refer to the provided code. It outlines data exploration, data cleaning, and the necessary steps to obtain the final xlsx output.

## Code Requirements & Dependencies

To run the code, the following R packages are required:

- `tidyverse`
- `lubridate`
- `openxlsx`

You can install these packages via the following commands:

```R
install.packages("tidyverse")
install.packages("lubridate")
install.packages("openxlsx")
```

## Output

The output of the code is an Excel file named output_analysis.xlsx with two sheets (Month_Device_Aggregation and MoM_Comparison), providing insights into the website's performance metrics.
