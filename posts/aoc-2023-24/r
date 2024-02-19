find_intersection <- function(pair, low, high) {
    A_pos <- pair[[1]][[1]][-3]
    A_vel <- pair[[1]][[2]][-3]
    B_pos <- pair[[2]][[1]][-3]
    B_vel <- pair[[2]][[2]][-3]
    left <- -A_vel
    b <- A_pos - B_pos
    A <- cbind(left, B_vel)

    # Beta in OLS
    solution <- tryCatch(solve(A, b), error = function(e) {
    })
    if (is.null(solution) || (solution[[1]] < 0) || (solution[[2]] < 0)) {
        return()
    }
    intersection <- A_pos + A_vel * solution[[1]]
    # print(intersection)
    if (all((intersection >= low) & (intersection <= high))) {
        intersection
    } else {
        return()
    }
    # if (!is.null(solution) && !all((A_pos[-3] + A_vel[-3] * solution[[1]]) == (B_pos[-3] + B_vel[-3] * solution[[2]]) ) stop()
    # solution <- (solve(t(A) %*% A) %*% t(A)) %*% b
    # if (all(A %*% solution) == b) {
    #     A_pos[-3] + A_vel[-3] * solution[[1]]
    # }
}

to_int <- function(string) {
    strsplit(string, ",\\s?") |>
        unlist() |>
        as.numeric()
}

parse <- function(line) {
    parts <- strsplit(line, "\\s@\\s") |>
        unlist() |>
        lapply(to_int)
}

# Y DX - X DY = x dy - y dx + Y dx + y DX - x DY - X dy
# (dy'-dy) X + (dx-dx') Y + (y-y') DX + (x'-x) DY = x' dy' - y' dx' - x dy + y dx
# See https://www.reddit.com/r/adventofcode/comments/18q40he/2023_day_24_part_2_a_straightforward_nonsolver/
make_row <- function(pair, first, second) {
    c1 <- pair[[1]][[1]][[first]]
    d1 <- pair[[1]][[2]][[first]]
    c1_prime <- pair[[2]][[1]][[first]]
    d1_prime <- pair[[2]][[2]][[first]]

    c2 <- pair[[1]][[1]][[second]]
    d2 <- pair[[1]][[2]][[second]]
    c2_prime <- pair[[2]][[1]][[second]]
    d2_prime <- pair[[2]][[2]][[second]]

    rhs <- (c1_prime * d2_prime) - (c2_prime * d1_prime) - (c1 * d2) + (c2 * d1)
    c(d2_prime - d2, d1 - d1_prime, c2 - c2_prime, c1_prime - c1, rhs)
}

full_rank <- function(X) {
    tryCatch(
        {
            solve(t(X) %*% X)
            TRUE
        },
        error = function(e) FALSE
    )
}

find_coord <- function(pairs, first, second) {
    equations <- c()
    # browser()
    for (pair in pairs) {
        row <- make_row(pair, first, second)
        # print(row)
        new <- rbind(equations, row)
        if (qr(new)[["rank"]] == nrow(new)) {
            equations <- new
        }
        if (length(equations) && nrow(equations) == 4) break
    }
    # Solve for X, Y, ignore velocities
    result <- solve(equations[, -5], equations[, 5])
    print(result)
    result[1:2]
}

solve_part2 <- function(pairs) {
    start <- find_coord(pairs, 1, 2)
    second <- find_coord(rev(pairs), 1, 3)
    c(start[1:2], second[[2]])
}

raw_input <- readLines("inputs/day24.txt")
parsed <- lapply(raw_input, parse)
lower <- 200000000000000
upper <- 400000000000000
pairs <- combn(parsed, m = 2, FUN = c, simplify = FALSE)
part1 <- lapply(pairs, find_intersection, low = lower, high = upper) |>
    vapply(Negate(is.null), FUN.VALUE = logical(1)) |>
    sum()
print(part1)
part2 <- solve_part2(pairs)
print(sum(part2))
