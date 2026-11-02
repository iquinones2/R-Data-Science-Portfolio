# Shared ggplot2 theme and palette for the portfolio, matching theme/isai.scss.
# Posts load it with: source(file.path(Sys.getenv("QUARTO_PROJECT_DIR", "../.."), "R/theme_isai.R"))
library(ggplot2)

isai_pal <- c(
  paper    = "#F5F7F9",  # page background
  ink      = "#1C2733",  # text and axes
  grid     = "#DCE2E8",  # gridlines and rules
  equities = "#2F5D8A",  # primary series
  yields   = "#B7832F",  # second series, only when a second series exists
  shock    = "#E9E2EF"   # shaded event bands
)

# Make the site's typeface available to ragg even if it isn't installed system-wide.
local({
  root <- Sys.getenv("QUARTO_PROJECT_DIR", ".")
  f <- file.path(root, "R", "fonts", "SchibstedGrotesk.ttf")
  if (requireNamespace("systemfonts", quietly = TRUE) && file.exists(f) &&
      !"Schibsted Grotesk" %in% systemfonts::registry_fonts()$family &&
      !"Schibsted Grotesk" %in% systemfonts::system_fonts()$family) {
    systemfonts::register_font("Schibsted Grotesk", plain = f)
  }
})

theme_isai <- function(base_size = 13, base_family = "Schibsted Grotesk") {
  theme_minimal(base_size = base_size, base_family = base_family) %+replace%
    theme(
      plot.background      = element_rect(fill = isai_pal[["paper"]], colour = NA),
      panel.background     = element_rect(fill = isai_pal[["paper"]], colour = NA),
      panel.grid.major     = element_line(colour = isai_pal[["grid"]], linewidth = 0.4),
      panel.grid.minor     = element_blank(),
      axis.text            = element_text(colour = "#5A6672", size = rel(0.85)),
      axis.title           = element_text(colour = "#5A6672", size = rel(0.85)),
      axis.ticks           = element_blank(),
      strip.text           = element_text(colour = isai_pal[["ink"]], hjust = 0, margin = margin(b = 6)),
      text                 = element_text(colour = isai_pal[["ink"]]),
      plot.title           = element_text(size = rel(1.25), hjust = 0, margin = margin(b = 4)),
      plot.subtitle        = element_text(colour = "#5A6672", hjust = 0, margin = margin(b = 12)),
      plot.caption         = element_text(colour = "#5A6672", size = rel(0.75), hjust = 0),
      plot.title.position  = "plot",
      plot.caption.position = "plot",
      legend.position      = "top",
      legend.justification = "left",
      plot.margin          = margin(12, 16, 12, 12)
    )
}

# Default geom colours so plain geom_point()/geom_line()/geom_col() pick up the palette.
use_isai_defaults <- function() {
  theme_set(theme_isai())
  update_geom_defaults("point",  list(colour = isai_pal[["equities"]]))
  update_geom_defaults("line",   list(colour = isai_pal[["equities"]]))
  update_geom_defaults("col",    list(fill = isai_pal[["equities"]]))
  update_geom_defaults("bar",    list(fill = isai_pal[["equities"]]))
  update_geom_defaults("smooth", list(colour = isai_pal[["yields"]], fill = isai_pal[["grid"]]))
  invisible(NULL)
}

scale_colour_isai <- function(...) scale_colour_manual(values = unname(isai_pal[c("equities", "yields")]), ...)
scale_fill_isai   <- function(...) scale_fill_manual(values = unname(isai_pal[c("equities", "yields")]), ...)
