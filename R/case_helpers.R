# Public real-data teaching cases. No network access or package installation.
case_dir <- if (dir.exists("data/cases")) "data/cases" else "../data/cases"
if (!dir.exists(case_dir)) stop("Open the course project or start in tutorials/.")
case_manifest <- read.csv(file.path(case_dir, "manifest.csv"), stringsAsFactors = FALSE)
case_read <- function(file) {
  expected <- case_manifest$md5[match(file, case_manifest$file)]
  target <- file.path(case_dir, file)
  if (is.na(expected) || !file.exists(target) || unname(tools::md5sum(target)) != expected)
    stop("Missing or modified teaching input: ", file)
  con <- if (grepl("\\.gz$", file)) gzfile(target, "rt") else file(target, "rt")
  on.exit(close(con))
  read.csv(con, check.names = FALSE, stringsAsFactors = FALSE)
}
case_matrix <- function(x, id = 1L) {
  stopifnot(!anyNA(x[[id]]), !anyDuplicated(x[[id]]))
  ans <- as.matrix(x[, -id, drop = FALSE])
  stopifnot(is.numeric(ans))
  rownames(ans) <- x[[id]]
  ans
}
case_session <- function(packages = character()) {
  data.frame(component = c("R", packages),
    version = c(as.character(getRversion()), vapply(packages, function(x)
      as.character(utils::packageVersion(x)), character(1))))
}
