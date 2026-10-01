# Acropoma Diet Partitioning

Analysis code for **trophic resource partitioning between two deep-sea glowbellies, *Acropoma hanedai* and *A. japonicum*, off southwestern Taiwan.**

📄 Published in *Environmental Biology of Fishes* (2026), 109:43: [doi:10.1007/s10641-026-01814-y](https://link.springer.com/article/10.1007/s10641-026-01814-y)

![Diet composition by species and month](SpmVolBarcol.jpg)

*Diet composition by biovolume. Both species feed mostly on teleost fish, but in May* A. japonicum *shifts heavily toward crustaceans.*

## Questions

1. Do the two species differ in standard length by season (February vs. May)?
2. Is the presence of stomach contents biased by size, species or month?
3. How does diet composition (by biovolume and frequency of occurrence) differ between species, months and size classes?
4. Can we predict the occurrence of key prey groups (crustaceans, fish) from species, season and size?
5. How broad are each species' diets, and how much do they overlap?

## Methods

- **Mixed models** (`glmmTMB`): Gaussian and binomial GLMMs with a random effect for specimen jar
- **Multivariate diet composition** (`vegan`): Bray–Curtis dissimilarity, PERMANOVA (`adonis2`) and PCoA ordination
- **Diet indices**: Index of Relative Importance (IRI), niche breadth and niche overlap
- **Sampling completeness**: species accumulation curves

## Repository contents

| File | Description |
|---|---|
| `fishdatacleaning.R` | Cleans and merges the raw per-species diet data |
| `FishDataAnalysis.Rmd` | Full analysis: models, PERMANOVA, IRI, niche metrics and figures |
| `FishDataAnalysis.html` | Rendered analysis report |
| `Ahandietadj.csv`, `Ajapdietadj.csv` | Raw stomach-content data for each species |
| `fishdat1.csv`, `fishdat2.csv`, `fishdat1sum.csv` | Cleaned analysis datasets |
| `*.png`, `*.jpg` | Figures and tables (`bw` = greyscale, `col` = colour versions) |

## Reproducing the analysis

Open `AcropomaResearch.Rproj` in RStudio, install the packages below and knit `FishDataAnalysis.Rmd`.

```r
install.packages(c("tidyverse", "glmmTMB", "multcomp", "vegan", "indicspecies",
                   "gt", "glue", "scales", "gridExtra"))
```

## Citation

If you use this code or data, please cite:

> Ghedotti MJ, Riggin KL, Marsh MA, Bramlett SA, Pearson HD, Rodriguez GJ, Gruber JN, Egan JP, Voss KA (2026). Evidence of deep-sea trophic resource partitioning between the glowbellies *Acropoma hanedai* and *A. japonicum* near Southwestern Taiwan. *Environmental Biology of Fishes* 109:43. https://doi.org/10.1007/s10641-026-01814-y

```bibtex
@article{ghedotti2026acropoma,
  title   = {Evidence of deep-sea trophic resource partitioning between the glowbellies {Acropoma hanedai} and {A. japonicum} near Southwestern Taiwan},
  author  = {Ghedotti, Michael J. and Riggin, Kurt L. and Marsh, Milo A. and Bramlett, Sarah A. and Pearson, Hayden D. and Rodriguez, Gabriel J. and Gruber, Josephine N. and Egan, Joshua P. and Voss, Kristofor A.},
  journal = {Environmental Biology of Fishes},
  volume  = {109},
  pages   = {43},
  year    = {2026},
  doi     = {10.1007/s10641-026-01814-y}
}
```

## Author

**Kurt Riggin** (analysis code): [GitHub](https://github.com/kriggithub) · [ORCID](https://orcid.org/0009-0004-4700-1251)
