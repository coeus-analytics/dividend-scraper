
########################################################################
# PACKAGES
########################################################################

# data manipulation
library(dplyr)

# string manipulation
library(stringr)

# scraping tools
library(rvest)
library(xml2)

# cleaning
library(janitor)

# dates
library(lubridate)

# financial tools
library(BatchGetSymbols)

########################################################################
# MORNINGSTAR UPCOMING DIVIDENDS
# - Retrieve the upcoming dividends from Morning Star
# - Estimate the dividend yield based on upcoming dividends (not annualised)
########################################################################

# parse the url
morns_div <- xml2::read_html("https://www.morningstar.com.au/Stocks/UpcomingDividends")

# scrape the upcoming dividends table
morns_div_raw <- morns_div %>% 
  html_nodes(., xpath = "//table[@id = 'OverviewTable']") %>% 
  html_table() %>% 
  as.data.frame()

# clean up the table
morns_div <- morns_div_raw %>% 
  janitor::clean_names() %>% 
  rename("amount_cents" = amount) %>% 
  mutate(ex_dividend_date = lubridate::dmy(ex_dividend_date),
         dividend_pay_date = lubridate::dmy(dividend_pay_date)) 
morns_div

# filter on upcoming ex dividend dates with a name
morns_div %>% 
  filter(ex_dividend_date >= Sys.Date(),
         company_name != "--") %>% 
  arrange(desc(ex_dividend_date)) %>% 
  View()

# specify a number of tickers/asx stocks
asx_tickers <- c("SUN", "AX1", "HVN", "SVW")

# get the last closing date share price
asx_last_price <- BatchGetSymbols::BatchGetSymbols(tickers = paste0(asx_tickers, ".AX"),
                                                   first.date = as.Date("2021-02-25"), 
                                                   last.date = as.Date("2021-02-26"))

# extract the share price data frame
asx_last_price_data <- asx_last_price$df.tickers %>% 
  janitor::clean_names() %>% 
  group_by(ticker) %>% 
  arrange(desc(ref_date)) %>% 
  filter(row_number() == 1) %>% 
  mutate(ticker = stringr::str_replace_all(ticker, ".AX", ""))

# calculate dividend yield only for upcoming dividends
# note that this is not the true dividend yield and the upcoming dividends are not annualised
morns_div %>% 
  dplyr::inner_join(x = .,
                    y = asx_last_price_data %>% select(ticker, price_close),
                    by = c("asx_code" = "ticker")) %>% 
  mutate(est_dividend_yield = (amount_cents / 100) / price_close) 

