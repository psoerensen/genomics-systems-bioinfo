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

The overview is migrated from gteach. The expanded teaching collection contains 18 reusable modules, 31 practicals and a lecture overview. Modules include biological context, method assumptions, original worked examples, interpretation challenges and selected readings. Practicals include sensitivity/diagnostic extensions and suggested reasoning. Both harmonized outlines use the same maintained sources through pathway-specific links.

## Unified curriculum map

[The course map](course_map.qmd) aligns all 10 Genomics, Systems Biology and Bioinformatics modules and all 12 Multi-Omics modules with 18 reusable blocks. It also maps both practical lists, preserves the original assessment weights and proposes pathway-specific extensions.

The repository is the unified home for both outlines. All 26 original practical sessions are linked to 24 shared practicals; seven additional practicals cover supporting and advanced topics. Browse [modules](modules.qmd), [practicals](practicals.qmd) and [slides](slides/introduction_genomics_systems_bioinfo.qmd). Maintain shared resources once and link them into each pathway.

## Learning and real-data resources

[Learning pathway](learning_path.qmd): core/extension/advanced labels, prerequisites, study-time estimates and readiness checks. [Assessment](assessment.qmd): crosswalk, three case assignments and a synthesis rubric preserving formal component weights. [Visual guide](visual_guide.qmd): six original accessible SVG concepts. [Media](media.qmd): checked provider links and viewing prompts.

[Case studies](case_studies.qmd): paired airway RNA-seq, ubiquitin interaction proteomics and observational feedlot cattle RNA/metabolites. Local teaching extracts and complete provenance are in [data notes](data/cases/README.md). Rebuild only explicitly with `scripts/prepare_case_data.R`; raw sources and installation libraries stay outside the repository.

## Requirements and rendering

Install Quarto and R, with knitr/rmarkdown available for Quarto execution. The original module/P01–P31 examples use base R and small teaching helpers in `R/`; they require no biological downloads or extra analysis packages. The P01–P31 generated data are hypothetical, documented in `data/README.md`. Three additional real-data cases use local public extracts in `data/cases/`, with checksums, source versions, licences and explicit preparation rules. Case 1 needs DESeq2 and Case 2 needs limma; their pages provide one-time Bioconductor setup instructions. Case 3 uses base R. No installation or download occurs during rendering.

Open the RStudio project and render the overview:

```bash
quarto render index.qmd
quarto render course_map.qmd
quarto render tutorials/p09_rnaseq.qmd
```

Generated website files are tracked in `docs/`. GitHub Pages publishes from the `main` branch's `/docs` folder, matching the other course repositories. Avoid committing local caches, downloaded private data or credentials.

## Model scope and extension

Read each lesson’s assumptions and limits before adapting it. Restricted quasi-Poisson count examples teach exposure/design/contrasts, rather than replacing a qualified RNA-seq workflow. Alignment, structure, networks, integration and prediction use small transparent examples. Genotype relatedness, real assay processing, tissue/cell composition, missingness and external validation need study-specific treatment. No narrated audio or deployed Shiny applications have been created.
