# Seeded hypothetical teaching data, not observations from livestock.
# Assays use explicit animal IDs. Calls reset the RNG to the supplied seed.
teaching_data <- function(seed = 20261008L) {
  set.seed(seed)
  n <- 48L
  animal <- sprintf("animal%02d", seq_len(n))
  meta <- data.frame(animal = animal,
    diet = factor(rep(c("control", "supplement"), n/2),
                  levels = c("control", "supplement")),
    batch = factor(rep(rep(c("A", "B"), each = 2), n/4)),
    sex = factor(rep(rep(c("F", "M"), each = 4), n/8)),
    farm = factor(rep(c("farm1", "farm2", "farm3"), each = n/3)))
  rownames(meta) <- animal
  G <- matrix(rbinom(n*8, 2, .35), n, 8,
              dimnames = list(animal, paste0("marker", 1:8)))
  treatment <- as.integer(meta$diet == "supplement")
  batch <- as.integer(meta$batch == "B")
  latent <- .6*treatment + .4*G[, 1] + rnorm(n)
  exposure <- rep(c(.8, 1, 1.2, 1.4), length.out = n)
  basal <- exp(seq(log(40), log(500), length.out = 24))
  eta <- matrix(log(basal), 24, n) +
    outer(c(rep(.65, 4), rep(0, 20)), treatment) +
    outer(c(.3, rep(0, 23)), G[, 1]) +
    outer(rep(.15, 24), batch)
  mu <- sweep(exp(eta), 2, exposure, "*")
  counts <- matrix(rnbinom(24*n, mu = as.vector(mu), size = 12), 24, n,
    dimnames = list(sprintf("gene%02d", 1:24), animal))
  protein <- outer(seq(7, 9, length.out = 8), rep(1, n)) +
    outer(seq(.1, .8, length.out = 8), latent) +
    matrix(rnorm(8*n, sd = .4), 8, n)
  dimnames(protein) <- list(sprintf("protein%02d", 1:8), animal)
  protein_missing <- protein
  protein_missing[1, c(2, 5, 12)] <- NA_real_
  protein_missing[2, 1:8] <- NA_real_
  metabolite <- outer(seq(4, 6, length.out = 6), rep(1, n)) +
    outer(seq(.2, .7, length.out = 6), latent) +
    matrix(rnorm(6*n, sd = .5), 6, n)
  dimnames(metabolite) <- list(sprintf("feature%02d", 1:6), animal)
  microbial <- matrix(rpois(6*n, lambda = rep(c(40, 30, 20, 10, 5, 3), n)), 6, n,
    dimnames = list(sprintf("taxon%02d", 1:6), animal))
  meta$response <- 10 + 1.2*treatment + .7*G[, 1] + .8*latent + rnorm(n, sd = .8)
  annotation <- data.frame(gene = sprintf("gene%02d", 1:24),
    transcript = sprintf("transcript%02d", 1:24),
    protein = c(sprintf("protein%02d", 1:8), rep(NA_character_, 16)),
    pathway = rep(c("pathwayA", "pathwayB", "pathwayC"), each = 8))
  stopifnot(identical(colnames(counts), meta$animal),
            identical(rownames(G), meta$animal), all(counts >= 0))
  list(metadata = meta, genotypes = G, counts = counts,
       exposure = setNames(exposure, animal), protein = protein,
       protein_missing = protein_missing, metabolite = metabolite,
       microbial = microbial, annotation = annotation)
}
