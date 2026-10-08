# Genomics, Systems Biology & Bioinformatics

Standalone Quarto- and R-based teaching materials for molecular data integration and computational modelling.

Course website: <https://psoerensen.github.io/genomics-systems-bioinfo/>

Teaching-materials hub: <https://psoerensen.github.io/gteach/>

## Repository structure

```text
genomics-systems-bioinfo/
  _quarto.yml
  index.qmd
  course_map.qmd
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

## Unified curriculum map

[The course map](course_map.qmd) aligns all 10 Genomics, Systems Biology and Bioinformatics modules and all 12 Multi-Omics modules with 18 reusable blocks. It also maps both practical lists, preserves the original assessment weights and proposes pathway-specific extensions.

The repository is the unified home for both outlines. The map describes planned teaching material; it does not imply that the practicals have been implemented. Maintain shared resources once in the existing folders, label them by block identifier and link them into each pathway.

## Requirements and rendering

Install Quarto; R is needed when executable R examples are added. No additional R package dependencies are required for the current overview.

Open the RStudio project and render the overview:

```bash
quarto render index.qmd
quarto render course_map.qmd
```

Generated website files are tracked in `docs/`. GitHub Pages publishes from the `main` branch's `/docs` folder, matching the other course repositories. Avoid committing local caches, downloaded private data or credentials.
