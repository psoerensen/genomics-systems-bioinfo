## About these teaching extracts

These files contain actual public measurements. They are separate from the hypothetical fixtures described in `data/README.md`. Prepared on 8 October 2026. `manifest.csv` records MD5 checksums of the teaching inputs; `R/case_helpers.R` verifies them before reading. MD5 is used for accidental-change detection, not security authentication.

## Airway RNA-seq

Source: airway 1.26.0, Bioconductor 3.20, Michael Love; experiment by Himes et al. (2014), DOI [Himes et al. study](https://doi.org/10.1371/journal.pone.0099625), GEO GSE52778. Package: [airway 1.26.0 package](https://bioconductor.org/packages/3.20/data/experiment/html/airway.html) .

The package's complete assay is exported as `airway_counts.csv.gz` (63,677 genes × 8 libraries). `airway_samples.csv` retains sample IDs, cell line and dexamethasone condition. CSV is a changed representation, not a reanalysis of sequencing reads. Gene IDs and integer counts are retained without filtering. The four untreated/treated pairs represent cultured primary smooth-muscle cell lines. See the package vignette for its annotation and counting procedure.

The package declares LGPL. Accompanying `airway-LGPL-2.1.txt`, `airway-LGPL-3.txt` and `airway-GPL-3.txt` retain the LGPL texts and the GPL text incorporated by LGPL-3. Original package and source: [airway source repository](https://github.com/bioconductor-source/airway) . This CSV export is a modified format of the package data; no package authorship is claimed. The original study article is CC BY. Credit Himes et al. and the airway package when reusing.

## Ubiquitin interaction proteomics

Source: DEP by Arne H. Smits and Wolfgang Huber, pinned repository revision `b425d8d0db67b15df4b8bcf87729ef0bf5800256`:
[pinned DEP source](https://github.com/arnesmits/DEP/tree/b425d8d0db67b15df4b8bcf87729ef0bf5800256) .
Files `data/UbiLength.rda` and `data/UbiLength_ExpDesign.rda`. Source reference: Zhang et al. (2017), An Interaction Landscape of Ubiquitin Signaling, DOI [Zhang et al. study](https://doi.org/10.1016/j.molcel.2017.01.004) .

`ubiquitin_lfq.csv.gz` is a modified column/format extract of 3,006 protein groups. It retains all twelve LFQ measurements, protein IDs, gene names and three analytical flags, and adds stable row labels `PG0001` etc. `ubiquitin_samples.csv` retains the original label, condition and replicate design. It does not contain raw spectra, and no observations are imputed. Zeros remain in the extract and are recoded as unquantified only in the analysis. A protein group is not necessarily a uniquely identified protein or gene. These are affinity-enrichment replicates, not animal cohorts.

DEP declares Artistic-2.0. The accompanying `DEP-Artistic-2.0.txt` supplies its licence. Preserve the original attribution, identify this modified teaching extract, and retain access to the original standard data files at the pinned source above. This redistribution does not include publisher artwork or paper text.

## Feedlot cattle disease study

Source: Li et al. (2022), Applying multi-omics data to study the genetic background of bovine respiratory disease infection in feedlot crossbred cattle, DOI [Li et al. study](https://doi.org/10.3389/fgene.2022.1046192) . Public dataset: [Borealis dataset](https://doi.org/10.5683/SP3/ZETWNY) , version 1.0, released 24 October 2022. Borealis declares **CC0 1.0** ([CC0 1.0 terms](https://creativecommons.org/publicdomain/zero/1.0/)). RNA counts: GEO GSE217317, [GEO GSE217317](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE217317) . The study article is CC BY. Retain attribution and study context even where the dataset imposes no attribution requirement.

Inputs: Borealis files 411516 (phenotype) and 411515 (metabolites), plus GEO `GSE217317_143_BRD_CON_readcounts.csv.gz` and its two platform series matrices. `source_checksums.csv` records acquired source bytes. Original Borealis file checksums are verified against its version 1.0 metadata; the original files are XLSX bytes despite the archive's `.tab` labels. For R import we separately use the repository's ingested TSV exports. No original large files are committed here.

`cattle_samples.csv` retains the 138 phenotype records, with status, feedlot, sex, RNA batch, days on feed and three genomic breed-composition covariates. `cattle_metabolites.csv` retains all 139 source records and all 55 HMDB columns. The paper describes 54 metabolites; the teaching extract deliberately preserves the supplied columns and flags this discrepancy. Missing/zero measurements are preserved. No unsupported concentration unit or compound name is added.

RNA names lose `_BRD`/`_NB`, four-digit names receive the `R` prefix, and the explicit `P4647` → `P4687` correction follows the documented public preparation script:
[public identity/preparation source](https://github.com/Plant-Food-Research-Open/moiraine/blob/8c8367777941fae068015d98a82f0b7d76f2be7c/data-raw/example_dataset_li2022.R) . No other fuzzy name matching is performed. All 143 processed count titles are matched to the two GEO platform sample records. `cattle_identity_audit.csv` preserves source title, canonical ID, GEO status, phenotype status, status-conflict flag and assay/metadata availability. Four records (U6623, U6450, U6325, Y3551) have GEO BRD characteristics but Control phenotype/metabolite labels and `_NB` count titles. The primary teaching analysis uses the canonical phenotype table and explicitly repeats the adjusted comparison after excluding these four controls (131 animals). This is a documented working choice, not verification of the correct biological labels. Phenotype sex 0 and metabolite sex 2 are both male; code 1 is female. Shared status/feedlot/recoded sex are checked. `cattle_coding_audit.csv` retains both source sex codes, including unavailable records.

`cattle_rna_samples.csv` preserves 143 RNA identities, original column titles and full-gene library totals. `cattle_rna_panel.csv.gz` contains the 300 highest mean-CPM genes across those 143 libraries, with ties resolved by gene ID. This label-independent selection is for compact exploration, not transcriptome-wide testing. CPM denominators always use full-gene totals.

The primary matched intersection has **135 animals (78 BRD, 57 controls)**. No missing phenotype is reconstructed. PCA uses **36 metabolite columns** positive/observed in all 135 animals; association examples use feature-specific positive observations with sample counts and a minimum of 20 per disease group. No imputation is performed. The study used pen-matched controls, but pen/matched-set IDs are absent from these tables. Independent-animal working-model p-values therefore do not account for the original matching. The lesson does not reproduce the paper's GWAS, differential-expression screen or integrated discovery counts.

## Rebuild explicitly

Website rendering never downloads these sources. To rebuild, create a separate source directory and acquire these public files yourself:

- Install airway **1.26.0** in a compatible Bioconductor 3.20 R environment.
- Download `UbiLength.rda` and `UbiLength_ExpDesign.rda` from the pinned DEP revision above.
- Download `https://borealisdata.ca/api/access/datafile/411516` as `cattle_metadata.tsv` and `411515` as `cattle_metabolites.tsv`.
- Download the same two endpoints with `?format=original` as `cattle_metadata_original.xlsx` and `cattle_metabolites_original.xlsx`.
- From `https://ftp.ncbi.nlm.nih.gov/geo/series/GSE217nnn/GSE217317/`, download `suppl/GSE217317_143_BRD_CON_readcounts.csv.gz` as `cattle_counts.csv.gz`, and the `matrix/GSE217317-GPL23295_series_matrix.txt.gz` and `GPL26012` counterpart as `cattle_series1.txt.gz` and `cattle_series2.txt.gz`.
- Verify downloaded bytes against the existing `source_checksums.csv` before rebuilding. Sources can change; a changed checksum requires review, not automatic acceptance.

From the project root, run `Rscript scripts/prepare_case_data.R <source-directory>`. The script verifies original Borealis checksums and all existing source-manifest checksums before exporting; it checks GEO identity/status differences, writes audits and regenerates manifests in a temporary staging directory, then copies validated outputs into the project. It stops if run outside the course root. Review any manifest differences; compressed outputs may differ with compression-library versions. Keep downloads and installation libraries outside the repository.
