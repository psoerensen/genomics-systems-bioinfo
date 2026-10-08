# Rebuild public teaching extracts from explicitly downloaded source files.
# Run from the course root: Rscript scripts/prepare_case_data.R <source-directory>
# No downloads occur in this script or during website rendering.
args <- commandArgs(trailingOnly = TRUE)
stopifnot(length(args) == 1L)
src <- normalizePath(args[1], mustWork = TRUE)
stopifnot(file.exists('_quarto.yml'), file.exists('R/case_helpers.R'))
out <- file.path('data', 'cases')
dir.create(out, recursive = TRUE, showWarnings = FALSE)
write_gz <- function(x, name) {
  con <- gzfile(file.path(out, name), 'wt')
  on.exit(close(con))
  write.csv(x, con, row.names = FALSE, na = '')
}
write_csv <- function(x, name) write.csv(x, file.path(out, name), row.names = FALSE, na = '')
check_md5 <- function(file, value) stopifnot(unname(tools::md5sum(file.path(src, file))) == value)
check_md5('cattle_metadata_original.xlsx', '25dda6d9cc4e405caaa871548430660f')
check_md5('cattle_metabolites_original.xlsx', '280c6fe6c8e0b1fd7a44c4d347839544')
if (file.exists(file.path(out, 'source_checksums.csv'))) {
  expected <- read.csv(file.path(out, 'source_checksums.csv'))
  actual <- unname(tools::md5sum(file.path(src, expected$file)))
  stopifnot(!anyNA(actual), identical(actual, expected$md5))
}

# Stage outputs outside the project; publish only after every source audit passes.
destination <- out
out <- tempfile('gteach-public-cases-')
dir.create(out)

# airway 1.26.0 / Bioconductor 3.20; preserve all genes and the paired metadata.
stopifnot(as.character(utils::packageVersion('airway')) == '1.26.0')
suppressPackageStartupMessages(library(SummarizedExperiment))
data('airway', package = 'airway')
a <- assay(airway)
write_gz(data.frame(gene_id = rownames(a), a, check.names = FALSE), 'airway_counts.csv.gz')
am <- as.data.frame(colData(airway))
write_csv(data.frame(sample_id = rownames(am), cell = am$cell, dex = am$dex), 'airway_samples.csv')

# DEP's processed protein groups; keep flags and original zero measurements.
e <- new.env()
load(file.path(src, 'UbiLength.rda'), envir = e)
load(file.path(src, 'UbiLength_ExpDesign.rda'), envir = e)
u <- e$UbiLength
keep <- c('Protein.IDs', 'Gene.names', 'Only.identified.by.site', 'Reverse',
          'Potential.contaminant', grep('^LFQ.intensity', names(u), value = TRUE))
write_gz(data.frame(feature_id = sprintf('PG%04d', seq_len(nrow(u))),
                    u[, keep], check.names = FALSE), 'ubiquitin_lfq.csv.gz')
write_csv(e$UbiLength_ExpDesign, 'ubiquitin_samples.csv')

# Canonical phenotype covariates; do not backfill absent phenotype observations.
m <- read.delim(file.path(src, 'cattle_metadata.tsv'), check.names = FALSE)
z <- read.delim(file.path(src, 'cattle_metabolites.tsv'), check.names = FALSE)
cc <- read.csv(gzfile(file.path(src, 'cattle_counts.csv.gz')), check.names = FALSE)
stopifnot(!anyDuplicated(m$AnimalID), !anyDuplicated(z$AnimalID), !anyDuplicated(cc$Geneid))
titles <- names(cc)[-(1:6)]
animal <- sub('_(BRD|NB)$', '', titles)
animal[grepl('^[0-9]{4}$', animal)] <- paste0('R', animal[grepl('^[0-9]{4}$', animal)])
# Explicit correction documented by the public moiraine preparation script:
# P4647 in GEO is P4687 in the animal tables. Never infer other fuzzy matches.
animal[animal == 'P4647'] <- 'P4687'
stopifnot(!anyDuplicated(animal))
counts <- as.matrix(cc[, -(1:6)])
storage.mode(counts) <- 'integer'
rownames(counts) <- cc$Geneid
colnames(counts) <- animal
stopifnot(all(counts >= 0), !anyNA(counts))
# Match the processed count titles to the two GEO platform sample records.
read_geo <- function(path) {
  lines <- readLines(gzfile(path), warn = FALSE)
  field <- function(tag) {
    line <- lines[startsWith(lines, paste0(tag, '\t'))]
    stopifnot(length(line) == 1L)
    as.character(read.table(text = line, sep = '\t', header = FALSE,
                            quote = '"', comment.char = '', stringsAsFactors = FALSE)[1, -1])
  }
  data.frame(title = sub(' \\[Re-analysis.*$', '', field('!Sample_title')),
    geo_status = ifelse(grepl('BRD$', field('!Sample_characteristics_ch1')), 'BRD', 'Control'))
}
geo <- rbind(read_geo(file.path(src, 'cattle_series1.txt.gz')),
             read_geo(file.path(src, 'cattle_series2.txt.gz')))
stopifnot(!anyDuplicated(geo$title), setequal(titles, geo$title))
status <- geo$geo_status[match(titles, geo$title)]
known <- match(animal, m$AnimalID)
phenotype_status <- m$Status[known]
conflict <- !is.na(phenotype_status) & status != phenotype_status
# Four GEO characteristics disagree with both the phenotype table and the
# processed count titles (_NB). Preserve the discrepancy, use canonical
# phenotype status, and require a sensitivity analysis excluding those records.
stopifnot(setequal(animal[conflict], c('U6623', 'U6450', 'U6325', 'Y3551')))
write_csv(data.frame(source_title = titles, sample_id = animal, geo_status = status,
  phenotype_status = phenotype_status, status_conflict = conflict,
  phenotype_available = !is.na(known), metabolite_available = animal %in% z$AnimalID),
  'cattle_identity_audit.csv')
totals <- colSums(counts)
stopifnot(all(totals > 0))
# Select 300 highest mean CPM genes WITHOUT disease labels. This is a compact
# exploratory panel, not a transcriptome-wide differential-expression screen.
cpm <- sweep(counts, 2, totals / 1e6, '/')
ord <- order(-rowMeans(cpm), rownames(counts))
panel <- counts[ord[seq_len(300)], , drop = FALSE]
write_gz(data.frame(gene_id = rownames(panel), panel, check.names = FALSE), 'cattle_rna_panel.csv.gz')
write_csv(data.frame(sample_id = animal, source_title = titles, library_total = totals), 'cattle_rna_samples.csv')
md <- data.frame(sample_id = m$AnimalID, status = m$Status,
  feedlot = paste0('F', m$Feedlot), sex = ifelse(m$Gender == 0, 'male', 'female'),
  rna_batch = paste0('B', m$BatchofRNAsequencing), day_on_feed = m$Dayonfeed,
  breed1 = m$Genomicbreedingcomposition1, breed2 = m$Genomicbreedingcomposition2,
  breed3 = m$Genomicbreedingcomposition3)
write_csv(md, 'cattle_samples.csv')
hmdb <- grep('^HMDB', names(z), value = TRUE)
write_csv(data.frame(sample_id = z$AnimalID, z[, hmdb], check.names = FALSE), 'cattle_metabolites.csv')
# Audit the repeated covariates, retaining both sex coding systems explicitly.
ix <- match(m$AnimalID, z$AnimalID)
both <- !is.na(ix)
stopifnot(all(m$Gender[both] == ifelse(z$Gender[ix[both]] == 2, 0, z$Gender[ix[both]])))
stopifnot(all(m$Status[both] == z$Status[ix[both]]), all(m$Feedlot[both] == z$Feedlot[ix[both]]))
write_csv(data.frame(sample_id = m$AnimalID, phenotype_sex_code = m$Gender,
  metabolite_sex_code = z$Gender[ix]), 'cattle_coding_audit.csv')
source_files <- c('UbiLength.rda', 'UbiLength_ExpDesign.rda', 'cattle_metadata.tsv',
                 'cattle_metabolites.tsv', 'cattle_metadata_original.xlsx', 'cattle_metabolites_original.xlsx',
                 'cattle_counts.csv.gz', 'cattle_series1.txt.gz', 'cattle_series2.txt.gz')
write_csv(data.frame(file = source_files, md5 = unname(tools::md5sum(file.path(src, source_files)))), 'source_checksums.csv')
outputs <- list.files(out, pattern = '\\.(csv|gz)$', full.names = TRUE)
outputs <- outputs[!grepl('(manifest|source_checksums)', outputs)]
write_csv(data.frame(file = basename(outputs), md5 = unname(tools::md5sum(outputs))), 'manifest.csv')
cat('Airway:', nrow(a), 'genes;', ncol(a), 'libraries\n')
cat('Proteomics:', nrow(u), 'protein groups;', nrow(e$UbiLength_ExpDesign), 'samples\n')
cat('Cattle:', nrow(m), 'phenotype;', nrow(z), 'metabolite;', ncol(counts), 'RNA;', length(hmdb), 'metabolites\n')
cat('Matched:', length(Reduce(intersect, list(m$AnimalID, z$AnimalID, animal))), '\n')
cat('Metabolite zero/negative/NA:', sum(as.matrix(z[, hmdb]) <= 0, na.rm = TRUE), sum(is.na(z[, hmdb])), '\n')
cat('Only RNA:', paste(setdiff(animal, m$AnimalID), collapse = ', '), '\n')
cat('Unmatched phenotype:', paste(setdiff(m$AnimalID, animal), collapse = ', '), '\n')

prepared_files <- list.files(out, full.names = TRUE)
stopifnot(all(file.copy(prepared_files, destination, overwrite = TRUE)))
cat('Published validated extracts to', destination, '\n')
