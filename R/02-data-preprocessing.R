library(purrr)
c("dplyr", "tidyr", "readr", "stringr", "lubridate") %>%
  walk(~ library(.x, character.only = TRUE))

# Full list of African countries
african_countries <- c(
  "Algeria", "Angola", "Benin", "Botswana", "Burkina Faso", "Burundi", "Cabo Verde", "Cameroon", 
  "Central African Republic", "Chad", "Comoros", "Democratic Republic of the Congo", "Djibouti", 
  "Egypt", "Equatorial Guinea", "Eritrea", "Eswatini", "Ethiopia", "Gabon", "Gambia", "Ghana", 
  "Guinea", "Guinea-Bissau", "Ivory Coast", "Kenya", "Lesotho", "Liberia", "Libya", "Madagascar", 
  "Malawi", "Mali", "Mauritania", "Mauritius", "Morocco", "Mozambique", "Namibia", "Niger", 
  "Nigeria", "Republic of the Congo", "Rwanda", "São Tomé and Príncipe", "Senegal", "Seychelles", 
  "Sierra Leone", "Somalia", "South Africa", "South Sudan", "Sudan", "Tanzania", "Togo", "Tunisia", 
  "Uganda", "Zambia", "Zimbabwe"
)


# Read the data frame from the RDS file
price <- read_rds("data/clean/1.RDS") |> 
  filter(Area %in% african_countries, Unit %in% c("LCU", "USD", "SLC")) |>  # Filter first for efficiency
  select(country = Area, crop = Item, Unit, Year, price = values) |>  # Select relevant columns
  mutate(across(c(price), \(x) replace_na(x, 0))) # Replace NA in price column

temp <- read_rds("data/clean/2.RDS") |>
  filter(Area %in% african_countries) |>  # Filter first for efficiency
  select(country = Area, Year, temperature = values) |>  # Select relevant columns
  mutate(across(c(temperature), \(x) replace_na(x, 0)))

pesticides <- read_rds("data/clean/3.RDS") |>
  filter(Area %in% african_countries) |>  # Filter first for efficiency
  select(country = Area,Item, Element,Unit, Year, pesticide = values) |>  # Select relevant columns
  mutate(across(c(pesticide), \(x) replace_na(x, 0)))

area <- read_rds("data/clean/4.RDS") |>
  filter(Area %in% african_countries) |>  # Filter first for efficiency
  select(country = Area,Item, Element,Unit, Year, area = values) |>  # Select relevant columns
  mutate(across(c(area), \(x) replace_na(x, 0)))




# View the merged data
head(merged_data)




price |> 
  filter(crop == "Rice") |>  # Keep only Rice data
  group_by(country, Year) |>  # Group by country and Year
  summarise(price = sum(price, na.rm = TRUE)) |>  # Sum price for each country-year
  arrange(country, Year)  # Sort for better readability


