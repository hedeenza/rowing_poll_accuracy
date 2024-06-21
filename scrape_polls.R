# Only Pulling CRCA polls and RankOar polls from approximately the same time in the year

# CRCA Polls from early April to Mid May 
# dropped April 12, 2023 because of hidden info in the page that made it break.
crca_polls <- data.frame(Date = c("2024_5_15", "2024_5_8", "2024_5_1", "2024_4_24", "2024_4_17", "2024_4_10", "2024_4_3",
                                  "2023_5_17", "2023_5_3", "2023_4_26", "2023_4_19", "2023_4_5", 
                                  "2022_5_18", "2022_5_11", "2022_5_4", "2022_4_27", "2022_4_20", "2022_4_13", "2022_4_6"),
                         Number = c(983, 977, 969, 961, 951, 945, 939,
                                    924, 914, 903, 896, 881,
                                    868, 860, 854, 849, 837, 827, 825))

# RankOar Polls from early April to Mid May 
rankoar_polls <- data.frame(Date = c("2024_5_17", "2024_5_10", "2024_5_1", "2024_4_25", "2024_4_18", "2024_4_9",
                                     "2023_5_4", "2023_4_27", "2023_4_13",
                                     "2022_5_17", "2022_5_11", "2022_5_3", "2022_4_27", "2022_4_20"),
                            Number = c(986, 980, 968, 964, 954, 946,
                                       917, 909, 891, 
                                       865, 861, 858, 845, 839))

# Scrapping the CRCA Coaches polls
# Make a blank data frame to fill into
crca_df <- data.frame(0,0,0,0,0)
# Name the columns so things feed together 
names(crca_df) <- c("Rank", "Team", "Points", "Previous", "ID")
# for every webpage ID, complete the url, read the html, extract the D1 votes table, add in the url ID, rename, 
# bind to the growing df, print an indication the loop is done
for (page_result in crca_polls$Number) {
  poll <- paste0("https://www.row2k.com/polls/index.cfm?cat=college&ID=", page_result, "&type=Pocock%20CRCA%20Poll")
  poll_html <- read_html(poll)
  d1_table <- poll_html %>% html_nodes("table") %>% html_table() %>% .[[1]]
  d1_id <- d1_table %>% mutate(ID = page_result)
  names(d1_id) <- c("Rank", "Team", "Points", "Previous", "ID")
  
  crca_df <- rbind(crca_df, d1_id)
  
  print(paste("Page:", page_result))
}

# Scrapping the RankOar Polls
# Make a blank data frame to fill into
rankoar_df <- data.frame(0,0,0,0)
# Name the columns so things feed together 
names(rankoar_df) <- c("Rank", "Team", "Points", "ID")
# for every webpage ID, complete the url, read the html, extract the D1 votes table, add in the url ID, rename, 
# bind to the growing df, print an indication the loop is done
for (page_result in rankoar_polls$Number) {
  poll <- paste0("https://www.row2k.com/polls/index.cfm?cat=college&ID=", page_result, "&type=rankOar%20Women%27s%20College%20Rowing%20Computer%20Ranking")
  poll_html <- read_html(poll)
  d1_finish <- poll_html %>% html_nodes("table") %>% html_table() %>% .[[1]]
  finish_id <- d1_table %>% mutate(ID = page_result)
  names(finish_id) <- c("Rank", "Team", "Points", "ID")
  
  rankoar_df <- rbind(rankoar_df, finish_id)
  
  print(paste("Page:", page_result))
}

# Writing CSVs so I can stop scrapping over and over
write.csv(crca_df, "Data/crca_polls.csv")
write.csv(rankoar_df, "Data/rankoar_polls.csv")