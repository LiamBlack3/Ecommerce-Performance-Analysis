# Load required libraries

install.packages("tidyverse") 
install.packages("lubridate")
install.packages("openxlsx")

library(tidyverse)
library(lubridate)
library(openxlsx)

# Read in the data
sessionCounts <- read.csv("data/sessionCounts.csv")
addsToCart <- read.csv("data/addsToCart.csv")

# column_names <- colnames(sessionCounts)
# print(column_names)
# 
# column_names <- colnames(addsToCart)
# print(column_names)


# Data Exploration

# Check for any missing values
sum(is.na(sessionCounts))
sum(is.na(addsToCart))

# --- Worksheet 1: Month * Device aggregation ---

# Convert date to month and year format using as.Date
sessionCounts$Month <- format(as.Date(sessionCounts$dim_date, format = "%m/%d/%y"), "%Y-%m")


# Aggregate data by Month and Device
agg_data <- sessionCounts %>%
  # Group by month and type of device
  group_by(Month, dim_deviceCategory) %>%
  summarise(
    # Check for missing values
    Sessions = sum(sessions, na.rm = TRUE),
    Transactions = sum(transactions, na.rm = TRUE),
    QTY = sum(QTY, na.rm = TRUE),
    ECR = sum(Transactions) / sum(Sessions)
  )

# --- Worksheet 2: Month over Month comparison ---

# Construct month-year format for addsToCart that matches session format
addsToCart$Month <- paste(addsToCart$dim_year, sprintf("%02d", addsToCart$dim_month), sep="-")

# Identify the two most recent months from the 'sessionCounts' data
recent_two_months <- sessionCounts %>%
  # Group data by month column
  group_by(Month) %>%
  # Summarize the data for each month to get the number of rows per month
  summarise(Total = n()) %>%
  # Arrange the data in descending order of Month to get the latest months first
  arrange(desc(Month)) %>%
  # Select only the recent 2 months
  slice(1:2) %>%
  # Extract month column
  pull(Month)


# Filter the sessionCounts & addsToCart by the two months
# Only include data values from those two months
filtered_data_sessions <- sessionCounts %>%
  # call upon recent_two_months function
  filter(Month %in% recent_two_months)

filtered_data_cart <- addsToCart %>%
  filter(Month %in% recent_two_months)


# Aggregate the data for the two most recent months
# Check for missing values
agg_recent_sessions <- filtered_data_sessions %>%
  group_by(Month) %>%
  summarise(
    Sessions = sum(sessions, na.rm = TRUE),
    Transactions = sum(transactions, na.rm = TRUE),
    QTY = sum(QTY, na.rm = TRUE),
    ECR = Transactions / Sessions
  )

# Aggregate the filtered add to cart data for the two months
agg_recent_cart <- filtered_data_cart %>%
  group_by(Month) %>%
  summarise(
    AddsToCart = sum(addsToCart, na.rm = TRUE)
  )


# Join the aggregated session and cart data on the month column
joined_data <- full_join(agg_recent_sessions, agg_recent_cart, by = "Month")


# Month over month comparison between most recent two months in data
# Use lag to retrieve previous value in sequence(prior month)
# Relative(Rel) to indicate percentage(increase/decrease) change between months
# Delta to indicate absolute change between months
MoM_comparison <- joined_data %>%
  arrange(Month) %>% # Sort in ascending order
  mutate(
    PriorMonth_Sessions = lag(Sessions),
    PriorMonth_Transactions = lag(Transactions),
    PriorMonth_QTY = lag(QTY),
    PriorMonth_ECR = lag(ECR),
    PriorMonth_AddsToCart = lag(AddsToCart),
    Delta_Sessions = Sessions - PriorMonth_Sessions,
    Rel_Sessions = Delta_Sessions / PriorMonth_Sessions,
    Delta_Transactions = Transactions - PriorMonth_Transactions,
    Rel_Transactions = Delta_Transactions / PriorMonth_Transactions,
    Delta_QTY = QTY - PriorMonth_QTY,
    Rel_QTY = Delta_QTY / PriorMonth_QTY,
    Delta_ECR = ECR - PriorMonth_ECR,
    Rel_ECR = Delta_ECR / PriorMonth_ECR,
    Delta_AddsToCart = AddsToCart - PriorMonth_AddsToCart,
    Rel_AddsToCart = Delta_AddsToCart / PriorMonth_AddsToCart
  ) %>%
  slice(2)  # Keep the most recent month's comparison







# Output the tables into separate worksheets within a single xlsx file
wb <- createWorkbook()

addWorksheet(wb, "Month_Device_Aggregation")
writeData(wb, "Month_Device_Aggregation", agg_data)

addWorksheet(wb, "MoM_Comparison")
writeData(wb, "MoM_Comparison", MoM_comparison)

# Save workbook in the project directory
saveWorkbook(wb, "output_analysis.xlsx", overwrite = TRUE)










