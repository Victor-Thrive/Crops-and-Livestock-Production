library(purrr)
c("dplyr", "tidyr", "readr", "stringr", "lubridate") %>%
  walk(~ library(.x, character.only = TRUE))


# Read the data frame from the RDS file
price <- read_rds("data/clean/1.RDS")
temperature <- read_rds("data/clean/2.RDS")
pesticides <- read_rds("data/clean/3.RDS")
area <- read_rds("data/clean/4.RDS")
 

# Perform an inner join on common columns
merged_data <- price %>%
  inner_join(temperature, by = c("Area Code", "Area Code (M49)", "Area", "Months Code", "Months", "Element Code", "Element", "Unit", "Year")) %>%
  inner_join(pesticides, by = c("Area Code", "Area Code (M49)", "Area", "Item Code", "Item", "Element Code", "Element", "Unit", "Year")) %>%
  inner_join(area, by = c("Area Code", "Area Code (M49)", "Area", "Item Code", "Item", "Element Code", "Element", "Unit", "Year"))

# View the merged data
head(merged_data)

  