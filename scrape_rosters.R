# Load scraping packages

library(rvest)
library(tidyverse)

# Assign the URL
url <- "https://osubeavers.com/sports/mens-rowing/roster"

# Reading the HTML
html_source <- read_html(url)

# The HTML actually got read in 
html_source %>% html_text()

# Which section of the page will go to the table
css_test_2 <- ".c-rosterpage__content"

# Extracting the text, because the table function isn't functioning
# html_text2() to insert the \n at line breaks to help ease the next steps
tester <- html_nodes(html_source, css_test_2) %>% html_text2()

# Splitting on the line breaks
paragraphs <- tester %>% str_split("\n")

# Coerce to vector to allow work with {stringr}
df <- as_vector(paragraphs)

# Can detect the pattern 
str_detect(df, "[:lower:][:upper:]")

# Make a line break between the mashed together lower case and upper case values in adjacent columns
str_replace_all(df, "([:lower:])([:upper:])", "\\1 \n \\2") |>
# Make a line break between the mashed together period and upper case values in adjacent columns
str_replace_all("([:punct:])([:upper:])", "\\1 \n \\2") |>
# Split into their own cells
str_split("\n") |>

as_vector() |>
head()

# Detecting the cells running together, inserting a line break between them, separating into their own rows
clean_df <- 
  str_replace_all(df, "([:lower:])([:upper:])", "\\1 \n \\2") |>
  str_replace_all("([:punct:])([:upper:])", "\\1 \n \\2") |>
  str_split("\n") |>
  as_vector() |>
str_remove_all('Name|Position|Academic Year|Height|Hometown|Last School') |>
  str_trim(side = "both") |>
  as_vector() |>
  print()

# Oh no... not everyone has the same amount of information...
str_detect(clean_df, "Full Bio")


# Well there's different amounts of information on everyone, but there's always a FULL BIO link,
tester_2 <- html_nodes(html_source, css_test_2) %>% html_text()


in_rows <- 
  tester_2 |>
  # Separate run togethers of punctuation and upper case
  str_replace_all("([:punct:])([:upper:])", "\\1 \\2") |>
  # Separate run-togethers of lower and upper
  str_replace_all("([:lower:])([:upper:])", "\\1 \\2") |>
  # Replacing the FULL BIO FOR "FIRST" "LAST" with a line break, because that's always present
  str_replace_all("Full Bio  for \\w+ \\w+", " \n") |>
  # Splitting each athlete into their own line
  str_split("\n") |>
  # Coercing to vector to continue work 
  as_vector() |>
  # Removing the blank space from the sides
  str_trim(side = "both") |>
  # Removing the category names
  str_remove_all("Position|Academic Year|Height|Hometown|Last School") |>
  # Removing errant white space in the middle
  str_squish() |>
  print()

specific_errors <-
  in_rows |>
  # Removing a single error caused by a hyphenated last name
  str_replace_all("- Hull Sasha Herrmann", "Sasha Herrman") |>
  # Removed another individual name case
  str_remove_all("Custom Field 1Ethan de Borja") |>
  print()
  
delim_add <-
  specific_errors |>
  # Adding custom delimiters between values that will feed into each column
  str_replace_all(" Rower ", "*Rower*") |>
  str_replace_all(" Coxswain ", "*Coxswain*") |>
  # There was a space between the N. H. for New Hampshire
  str_replace_all("\\. [:upper:]\\.", '.H.') |>
  # Adding the delimiter after the academic year
  str_replace_all("\\. ", "\\.*") |>
  # Adding the delimiter after the height
  str_replace_all("\'' ", "\''*") |>
  as.data.frame() |>
  print()

names(delim_add) <- "Athletes"

wide_roster <-
  delim_add |>
  separate_wider_delim(
    delim = "*",
    cols = Athletes,
    names = c("Name", "Position", "Acacdemic Year", "Height", "Hometown", "Last School"),
    too_few = 'align_start')

roster_tags <-
  wide_roster |>
  mutate(University = "OSU", 
         Team = "Men")
