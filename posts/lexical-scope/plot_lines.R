library(ggplot2)

line_data <- read.csv("line_counts.csv", header = TRUE) |>
    head(-1)

languages <- c(
    py = "Python", R = "R", sh = "Bash",
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

line_data$language <- languages[tools::file_ext(line_data$file)]
line_data$day <- gsub("[^0-9]+", "", line_data$file) |>
    strtoi()
line_data <- line_data[order(line_data$day), ]

plot <- ggplot(line_data, aes(y = rev(cumsum(lines)), x = day, fill = rev(language))) +
    coord_flip() +
    geom_col(color = "black", size = 0.25, position = position_dodge(width = 0)) +
    scale_x_continuous(breaks = line_data$day, labels = rev(line_data$day), expand = c(0, 0)) +
    scale_y_continuous(expand = c(.01, 0), breaks = seq(0, 3000, 1000)) +
    scale_fill_brewer(palette = "Set3") +
    # scale_fill_hue(c=100, l=80) +
    labs(title = "Advent of Code 2022 Line Counts", x = "Day", y = "Cumulative Lines", fill = "Language")
