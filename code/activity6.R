# 1. Load Packages
library(tidyverse)
library(rvest)
library(googlesheets4)

# 2a. Get armedForces data
path <- "/Users/fateenahs./Desktop/STAT184/US_Armed_Forces.csv"
armedForcesRaw <- read.csv(path)

# 2b. Clean armedForces data
armedForces <- armedForcesRaw %>%
  dplyr::select(
    -c(4, 7, 10, 13, 16, 17, 18, 19)
  ) %>%
  rename(
    "Pay Grade" = "Active.Duty.Personnel.by.Service.Branch..Sex..and.Pay.Grade",
    "Army" = c(2, 3),
    "Navy" = c(4, 5),
    "Marine Corps" = c(6, 7),
    "Air Force" = c(8, 9),
    "Space Force" = c(10, 11),
  ) %>%
  slice(
    -c(1, 2, 12, 18, 29, 30, 31)
  ) %>%
  pivot_longer(
    cols = -"Pay Grade",
    names_to = c("Service Branch", "Gender"),
    names_pattern = "(.*)([12])",
    values_to = "Count"
  ) %>%
  mutate(
    Gender = case_match(
      .x = Gender,
      "1" ~ "Male",
      "2" ~ "Female"
    )
  ) %>% 
  filter(
    Count != "N/A*"
  ) %>%
  mutate(
    Count = as.numeric(Count)
  )

# 3a. Get armyRanks data
armyRawList <- read_html(x = "https://neilhatfield.github.io/Stat184_PayGradeRanks.html") %>%
  html_elements(css = "table") %>%
  html_table()

# 3b. Convert list into a table
armyRanksRaw <- bind_cols(armyRawList)

# 3c. Clean armyRanks data
armyRanks <- armyRanksRaw %>% 
  rename(
    "Category" = "...1",
    "Army" = "Ranks by Branch of Service...3",
    "Navy" = "Ranks by Branch of Service...4",
    "Marine Corps" = "Ranks by Branch of Service...5",
    "Air Force" = "Ranks by Branch of Service...6",
    "Space Force" = "Ranks by Branch of Service...7",
    "Coast Guard" = "Ranks by Branch of Service...8"
  ) %>%
  slice(
    -c(1, 26)
  ) %>%
  pivot_longer(
    cols = c("Army", "Navy", "Marine Corps", "Air Force", "Space Force", "Coast Guard"),
    names_to = "Service Branch",
    values_to = "Ranks"
  ) %>%
  filter(
    Ranks != "--"
  )

# 4. Construct a table where each row represents a giroup of army
armyGroup <- left_join(
  x = armedForces,
  y = armyRanks,
  by = join_by("Pay Grade" == "Pay Grade", "Service Branch" == "Service Branch")
)

# 5. Construct a table where each row represents an individual
armyIndividual <- armyGroup %>%
  filter(
    !is.na(Count)
  ) %>% uncount(Count)
