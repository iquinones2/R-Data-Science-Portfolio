# Builds the data behind the home-page hero chart: a 250-trading-day rolling
# correlation between daily S&P 500 returns and daily changes in the 10-year
# Treasury yield. Run once; output is cached to R/hero_data.csv.
suppressPackageStartupMessages({library(quantmod); library(fredr); library(tidyverse); library(zoo)})
getSymbols("^GSPC", src = "yahoo", from = "2000-01-01", to = "2026-08-20", auto.assign = TRUE)
sp500 <- tibble(date = index(GSPC), sp500 = as.numeric(Cl(GSPC)))
t10 <- fredr(series_id = "DGS10", observation_start = as.Date("2000-01-01")) |>
  select(date, treasury10 = value)
sb <- inner_join(sp500, t10, by = "date") |> arrange(date) |>
  mutate(ret = sp500 / lag(sp500) - 1, dy = treasury10 - lag(treasury10)) |>
  drop_na(ret, dy)
sb$roll <- rollapplyr(seq_len(nrow(sb)), 250, function(i) cor(sb$ret[i], sb$dy[i]), fill = NA)
write_csv(select(sb, date, roll), "R/hero_data.csv")
