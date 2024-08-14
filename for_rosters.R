library(rvest)
library(tidyverse)

# Oregon State University - FUNCTIONS 
osu_links <- c("https://osubeavers.com/sports/mens-rowing/roster",
               "https://osubeavers.com/sports/womens-rowing/roster")
osu_roster <- data.frame(0, 0, 0, 0, 0, 0)
  names(osu_roster) = c("Name", "Position", "Acacdemic-Year", "Height", "Hometown", "Link")

# University of Washington
uw_links <- c("https://gohuskies.com/sports/mens-rowing/roster/2024-25",
                 "https://gohuskies.com/sports/womens-rowing/roster/2023-24")
uw_roster <- data.frame(0, 0, 0, 0, 0, 0)
  names(uw_roster) = c("Name", "Position", "Acacdemic-Year", "Height", "Hometown", "Link")

# Washington State University
wsu_links <- c("https://wsucougars.com/sports/womens-rowing/roster")
wsu_roster <- data.frame(0, 0, 0, 0, 0, 0)
  names(wsu_roster) = c("Name", "Position", "Acacdemic-Year", "Height", "Hometown", "Link")

# University of California LA
ucla_links <- c("https://uclabruins.com/sports/womens-rowing/roster")
ucla_roster <- data.frame(0, 0, 0, 0, 0, 0)
  names(ucla_roster) = c("Name", "Position", "Acacdemic-Year", "Height", "Hometown", "Link")

# University of Southern California
usc_links <- c("https://usctrojans.com/sports/womens-rowing/roster/2023-24")
usc_roster <- data.frame(0, 0, 0, 0, 0, 0)
  names(usc_roster) = c("Name", "Position", "Acacdemic-Year", "Height", "Hometown", "Link")

# Stanford University 
stanford_links <- c("https://gostanford.com/sports/mens-rowing/roster/season/2023-24",
                    "https://gostanford.com/sports/womens-rowing/roster")
stanford_roster <- data.frame(0, 0, 0, 0, 0, 0)
  names(stanford_roster) = c("Name", "Position", "Acacdemic-Year", "Height", "Hometown", "Link")

# University of California Berkley
cal_links <- c("https://calbears.com/sports/womens-rowing/roster/2023-24",
               "https://calbears.com/sports/mens-rowing/roster")
cal_roster <- data.frame(0, 0, 0, 0, 0, 0)
  names(cal_roster) = c("Name", "Position", "Acacdemic-Year", "Height", "Hometown", "Link")

# OSU Scraper - for loop
for (squad in osu_links) {
  url <- squad
  html <- read_html(url) |>
    html_nodes(".c-rosterpage__content") |>
    html_text() |> 
    str_replace_all("([:punct:])([:upper:])", "\\1 \\2") |>
    str_replace_all("([:lower:])([:upper:])", "\\1 \\2") |>
    str_replace_all("Full Bio  for \\w+ \\w+", " \n") |>
    str_split("\n") |>
    as_vector() |>
    str_trim(side = "both") |>
    str_remove_all("Position|Academic Year|Height|Hometown|Last School") |>
    str_squish() |>
    str_replace_all("- Hull Sasha Herrmann", "Sasha Herrman") |>
    str_remove_all("Custom Field 1Ethan de Borja") |>
    str_replace_all(" Rower ", "*Rower*") |>
    str_replace_all(" Coxswain ", "*Coxswain*") |>
    str_replace_all("\\. [:upper:]\\.", '.H.') |>
    str_replace_all("\\. ", "\\.*") |>
    str_replace_all("\'' ", "\''*") |>
    as.data.frame()
  
  names(html) <- "Athletes"
  
  wide_roster <-
    html |>
    separate_wider_delim(
      delim = "*",
      cols = Athletes,
      names = c("Name", "Position", "Acacdemic-Year", "Height", "Hometown", "Last-School"),
      too_few = 'align_start',
      too_many = "drop")
  
  roster_tags <-
    wide_roster |>
    select(Name, Position, `Acacdemic-Year`, Height, Hometown) |>
    mutate(Link = squad)
  
  osu_roster <- rbind(osu_roster, roster_tags)
  
  print(paste("Page:", squad))
}

write_csv(osu_roster, "Data/osu_roster.csv")


# UW Scraper - for loop
for (squad in osu_links) {
  url <- squad
  html <- read_html(url) |>
    html_nodes(".c-rosterpage__content") |>
    html_text() |> 
    str_replace_all("([:punct:])([:upper:])", "\\1 \\2") |>
    str_replace_all("([:lower:])([:upper:])", "\\1 \\2") |>
    str_replace_all("Full Bio  for \\w+ \\w+", " \n") |>
    str_split("\n") |>
    as_vector() |>
    str_trim(side = "both") |>
    str_remove_all("Position|Academic Year|Height|Hometown|Last School") |>
    str_squish() |>
    str_replace_all("- Hull Sasha Herrmann", "Sasha Herrman") |>
    str_remove_all("Custom Field 1Ethan de Borja") |>
    str_replace_all(" Rower ", "*Rower*") |>
    str_replace_all(" Coxswain ", "*Coxswain*") |>
    str_replace_all("\\. [:upper:]\\.", '.H.') |>
    str_replace_all("\\. ", "\\.*") |>
    str_replace_all("\'' ", "\''*") |>
    as.data.frame()
  
  names(html) <- "Athletes"
  
  wide_roster <-
    html |>
    separate_wider_delim(
      delim = "*",
      cols = Athletes,
      names = c("Name", "Position", "Acacdemic-Year", "Height", "Hometown", "Last-School"),
      too_few = 'align_start',
      too_many = "drop")
  
  roster_tags <-
    wide_roster |>
    select(Name, Position, `Acacdemic-Year`, Height, Hometown) |>
    mutate(Link = squad)
  
  osu_roster <- rbind(osu_roster, roster_tags)
  
  print(paste("Page:", squad))
}