library(purrr)
c("dplyr", "tidyr", "readr", "stringr", "lubridate") %>%
  walk(~ library(.x, character.only = TRUE))
# load all the data
file_names <- dir("./data/raw", pattern = "*.csv", full.names = TRUE)
data_frames <- map(file_names, read_csv)
# temperature data------------------------------------------------------------------------------------
temperature <- 
  data_frames[[1]] |>
            select(-matches("F$")) |> # remove columns that end with F (FLAG = [Estimated|Missing])
            pivot_longer(cols = Y1961:Y2023,
                         names_to = "Year",
                         values_to = "values") |>
            mutate(Year = as.integer(str_remove(Year, "Y")),
                   Months = match(Months, month.name),
                   across(where(is.character), factor))
## land use data---------------------------------------------------------------------------------------
  land_use <-
         data_frames[[6]] |>
           select(-matches(".*(F|N)$")) |> # remove columns that end with F (FLAG = [Estimated|Missing])
           pivot_longer(cols = Y1961:Y2022,
                        names_to = "Year",
                        values_to = "values") |>
           mutate(Year = as.integer(str_remove(Year, "Y")),
                  across(where(is.character), factor))
## pesticides data------------------------------------------------------------------------------------
pesticides <-   
  data_frames[[8]] |>
        select(-matches(".*(F|N)$")) |> # remove columns that end with F (FLAG = [Estimated|Missing])
        pivot_longer(cols = Y1990:Y2022,
                     names_to = "Year",
                     values_to = "values") |>
        mutate(Year = as.integer(str_remove(Year, "Y")),
               across(where(is.character), factor))
## price data-----------------------------------------------------------------------------------------
  price <- data_frames[[14]] |>
         select(-matches("F$")) |> # remove columns that end with F (FLAG = [Estimated|Missing])
         pivot_longer(cols = Y1991:Y2023,
                      names_to = "Year",
                      values_to = "values") |>
         mutate(Year = as.integer(str_remove(Year, "Y")),
                Months = match(Months, month.name),
                across(where(is.character), factor))
## write clean data to file---------------------------------------------------------------------------
list(price, temperature, pesticides, land_use) %>% 
  imap(~ saveRDS(.x, paste0("./data/clean/", .y, ".RDS")))
