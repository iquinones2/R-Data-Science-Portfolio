# Renders the ggplot preview used on the home-page "R graphs" project card.
# Run from the project root: Rscript R/make_cards.R
suppressPackageStartupMessages({library(tidyverse); library(ragg)})
source("R/theme_isai.R")

p <- ggplot(mpg, aes(cty, hwy)) +
  geom_point(colour = isai_pal[["equities"]], size = 2.2, alpha = 0.9,
             position = position_jitter(width = 0.25, height = 0.25, seed = 7)) +
  geom_smooth(method = "loess", formula = y ~ x, se = FALSE,
              colour = isai_pal[["yields"]], linewidth = 1.1) +
  labs(x = NULL, y = NULL) +
  theme_isai(base_size = 13) +
  theme(axis.text = element_blank(), panel.grid.major.x = element_blank(),
        plot.margin = margin(8, 8, 8, 8))

agg_png("images/card-ggplot.png", width = 1000, height = 520, res = 200,
        background = isai_pal[["paper"]])
print(p); invisible(dev.off())
