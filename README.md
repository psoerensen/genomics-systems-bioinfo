# Genomics, Systems Biology & Bioinformatics

Standalone Quarto- and R-based teaching materials for molecular data integration and computational modelling.

Course website: <https://psoerensen.github.io/genomics-systems-bioinfo/>

Teaching-materials hub: <https://psoerensen.github.io/gteach/>

## Repository structure

```text
genomics-systems-bioinfo/
  _quarto.yml
  index.qmd
  slides/
  notes/
  tutorials/
  exercises/
  apps/
  data/
  images/
  narration/
  scripts/
  R/
  tools/
  docs/
```

The course overview is migrated from gteach. The other teaching folders are ready for development; no slides or executable practicals are included yet.

## Planned teaching sequence

The original course outline proposes sequencing technologies, genome variation, GWAS principles, fine-mapping, multi-omics integration, network models and machine learning in genomics. Planned practicals cover RNA-seq, GWAS, network analysis and regularized regression. Planned notes cover high-dimensional regression, population-structure correction, multiple testing and reproducible workflows.

These are planned topics, rather than links to materials that already exist. Add sources to the Quarto render list and navigation as each is developed.

## Requirements and rendering

Install Quarto; R is needed when executable R examples are added. No additional R package dependencies are required for the current overview.

Open the RStudio project and render the overview:

```bash
quarto render index.qmd
```

Generated website files are tracked in `docs/`. GitHub Pages publishes from the `main` branch's `/docs` folder, matching the other course repositories. Avoid committing local caches, downloaded private data or credentials.
