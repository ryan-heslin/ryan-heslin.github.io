# Retrieve image saved at path, falling back on callback in failure
get_image <- function(path, img_callback, save_callback = NULL, caption = "") {
    path <- normalizePath(path, mustWork = FALSE)
    if (!file.exists(path)) {
        result <- callback()
        if(!is.null(save_callback)){
            save_callback(path, result)
        }
    }
    # Since relative path from project directory should be /img/${image}
    path <- file.path(basename(dirname(path)), basename(path))
    paste0("![", caption, "](/", path, "){}")
}

get_single_file <- function(repo, path, branch = "main", out_file) {
    stem <- "https://raw.githubusercontent.com"
    url <- file.path(stem, repo, branch, path)
    download.file(url, destfile = out_file, method = "curl")
}

display_file <- function(text, chunk_opts) {
    header <- paste0("```{{", chunk_opts, "}}")
    c(header, text, "```") |>
        cat()
}

render_file <- function(repo, path, branch = "main", chunk_opts) {
    target <- tempfile()
    get_single_file(repo, path, branch = "main", target)
    lines <- readLines(target)
    display_file(lines, chunk_opts)
}
