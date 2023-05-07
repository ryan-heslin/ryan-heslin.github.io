library(ggplot2)

make_plot <- function(data, palette) {
    year <- unique(data$year)
    palette <- palette[names(palette) %in% data$language]

    ggplot(data, aes(y = rev(cumsum(lines)), x = day, fill = rev(language))) +
        coord_flip() +
        geom_col(color = "black", linewidth = 0.25, position = position_dodge(width = 0)) +
        scale_x_continuous(breaks = data$day, labels = rev(data$day), expand = c(0, 0)) +
        scale_y_continuous(expand = c(.01, 0), breaks = seq(0, 3000, 1000)) +
        scale_fill_manual(values = palette) +
        labs(
            title = paste("Advent of Code", year, "Line Counts"),
            x = "Day", y = "Cumulative Lines", fill = "Language"
        )
}

args <- commandArgs(trailingOnly = TRUE)
if (length(args)) years <- strtoi(args)

line_data <- read.csv(csv, header = TRUE)
if (!all(years %in% line_data$year)) stop("Invalid years")

languages <- c(
    py = "Python", R = "R", sh = "Bash", bash = "Bash",
    js = "JavaScript", rb = "Ruby", lua = "Lua",
    rkt = "Racket"
)

theme_standard <- ggplot2::theme(
    panel.background = ggplot2::element_blank(),
    panel.border = ggplot2::element_rect(
        color = "black",
        fill = NA
    ), panel.grid = ggplot2::element_blank(),
    panel.grid.major.x = ggplot2::element_line(color = "gray93"),
    legend.background = ggplot2::element_rect(fill = "gray93"),
    plot.title = ggplot2::element_text
    (
        size = 15,
        family = "sans", face = "bold",
        vjust = 1.3
    ),
    plot.title.position = "plot", plot.subtitle = ggplot2::element_text(
        size = 10,
        family = "sans"
    ), legend.title =
        ggplot2::element_text(
            size = 10,
            family = "sans", face = "bold"
        ),
    axis.title = ggplot2::element_text(
        size = 9,
        family = "sans", face = "bold"
    ),
    axis.text = ggplot2::element_text(
        size = 8,
        family = "sans"
    ), strip.background = ggplot2::element_rect(
        color = "black",
        fill = "black"
    ), strip.text.x =
        ggplot2::element_text(color = "white"),
    strip.text.y = ggplot2::element_text(color = "white")
)
ggplot2::theme_set(theme_standard)

line_data <- line_data[line_data$file != "total", ]
line_data$language <- languages[tools::file_ext(line_data$file)]
line_data <- line_data[!is.na(line_data$language), ]
line_data$day <- gsub("[^0-9]+", "", line_data$file) |>
    strtoi()
line_data <- line_data[order(line_data$year, line_data$day), ]

languages <- table(line_data$language) |>
    sort(decreasing = TRUE) |>
    names()
colors <- RColorBrewer::brewer.pal(name = "Set3", n = length(languages)) |>
    setNames(languages)
line_data <- line_data[line_data$year %in% years, ]
plots <- split(line_data, line_data$year) |>
    lapply(make_plot, palette = colors)
for (plot in plots) print(plot)
