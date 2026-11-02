# Renders the home-page hero chart to images/hero-correlation.png.
# Uses cached data from R/hero_data.R so no API key is needed here.
suppressPackageStartupMessages({library(tidyverse); library(ragg)})
source("R/theme_isai.R")

d <- read_csv("R/hero_data.csv", show_col_types = FALSE) |> drop_na(roll)
bands <- tibble(
  start = as.Date(c("2008-01-01", "2020-01-01")),
  end   = as.Date(c("2009-12-31", "2020-12-31")),
  label = c("2008–09\nfinancial crisis", "COVID-19\nshock")
)

p <- ggplot(d, aes(date, roll)) +
  geom_rect(data = bands, aes(xmin = start, xmax = end, ymin = -Inf, ymax = Inf),
            inherit.aes = FALSE, fill = isai_pal[["shock"]]) +
  geom_hline(yintercept = 0, colour = isai_pal[["ink"]], linewidth = 0.4) +
  geom_line(colour = isai_pal[["equities"]], linewidth = 0.9) +
  geom_text(data = bands, aes(x = start + (end - start) / 2, y = 0.86, label = label),
            inherit.aes = FALSE, family = "Schibsted Grotesk", size = 3.4,
            colour = "#5A6672", lineheight = 0.95) +
  scale_y_continuous(limits = c(-0.45, 0.95), breaks = seq(-0.4, 0.8, 0.4)) +
  scale_x_date(date_breaks = "5 years", date_labels = "%Y", expand = expansion(mult = 0.01)) +
  labs(x = NULL, y = "Correlation") +
  theme_isai(base_size = 14)

agg_png("images/hero-correlation.png", width = 1100, height = 720, res = 200, background = isai_pal[["paper"]])
print(p); invisible(dev.off())
