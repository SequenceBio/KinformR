# KinformR
## The Kinship Informer: An R package for relationship-informed pedigree and variant scoring


## Introduction

Family-based genetic studies are effective for identifying rare variants underlying heritable diseases, yet are often challenged by issues such as incomplete penetrance and the difficulty of prioritizing numerous candidate variants. The proportion of the genome with identity-by-descent (IBD) and estimates of penetrance are metrics that can show the value of different pedigrees in family-based studies. Additionally, IBD and the genotypes of individuals are combined by KinformRto to score the value of candidate variants.

The `KinformR` R package is meant to aid in comparative evaluation of families and candidate variants in rare-variant association studies. The package can be used for two methodologically overlapping but distinct purposes: 1) prior to any genetic/genomic evaluation, evaluation of relative detection power of pedigrees, can direct recruitment efforts by showing which unsampled individuals would be the most meaningful additions to a study, and 2) after sequencing and analysis,  variants based on association with disease status and familial  relationships of individuals, aids in variant prioritization


## Installation

### CRAN version

KinformR can be [installed directly from CRAN](https://cran.r-project.org/web/packages/KinformR/index.html).
```
install.packages("KinformR")
library(KinformR)
```

### Development version
The development version of `KinformR` can be installed directly from GitHub. You'll need to have the R package `devtools` installed and loaded. Also note if the build_vignettes option is set to true, you will need to have the R package `knitr` installed.

```
#install.packages("devtools")
#install.packages("knitr") #required if build_vignettes = TRUE
#library(devtools)
devtools::install_github("SequenceBio/KinformR", build_vignettes = TRUE)
library(KinformR)
```
If you're a mac user and the install command is returning a LaTeX error when `build_vignettes = TRUE`, then [ensure you have a LaTeX distribution installed on your system.](https://CRAN.R-project.org/package=tinytex)

## How it works

The package's vignette contains detailed explanations of the functions and parameters.

For a walk through of the `KinformR` functions for scoring the value of *families* based on penetrance and IBD, see the corresponding vignette file:
`vignettes/KinformR-penetrance_and_ibd.Rmd`
or within R, run:
```
vignette('KinformR-penetrance_and_ibd')
```

For a walk through of the `KinformR` functions for scoring the value of *variants* within families, see the corresponding vignette file:
`vignettes/KinformR-variant_scoring.Rmd`

or within R, run:
```
vignette('KinformR-variant_scoring')
```

## Scoring families

### The encoding file

See the included example data, which encodes 14 families. See the accompanying vignette for more information on encoding pedigrees:
```
  example.pedigree.file <-system.file('extdata/example_pedigree_encoding.tsv', package = 'KinformR')
```
The data can be loaded with the following function:
```
  example.pedigree.df <- read.pedigree(example.pedigree.file)
```
and scoring then performed:
```
    scoring.df <- score.pedigree(example.pedigree.df)
```

## Scoring Variants

When looking at shared rare variants across families, not all sets of affected and unaffected individuals are equal. This R package is designed to score rare variants, assigning values based on the disease status of individuals, the presence or absence of a rare variant in those individuals, and their pairwise coefficients of relatedness. The package uses a custom formula to assign value to a variant that gives more weight to shared variants common to distantly related affected individuals. The variant status for unaffected individuals can optionally be considered as well, with the highest scoring values being given to closely related individuals that *do not* share a variant of interest. Since variants can be incompletely penetrant, the scoring can be based solely on the affected individuals, or the weight of unaffected evidence can be customized.


### The relationship matrix

This input is a matrix containing all the pairwise relationships of individuals in a family. The row and column names are the individual IDs, and the intersecting value denotes the degree of relationship between the individuals (self = 0, 1st degree relations. = 1, etc. Unrelated individuals are given a value of -1). As of version `0.1.0` the relation matrix is a manually created file, where relationship values are assigned via manual inspection of the family pedigree.

```
mat.name<-system.file('extdata/1234_ex2.mat', package = 'KinformR')

rel.mat <- read.relation.mat(mat.name)
```

### The status file

This file includes the same individual IDs used in the relationship matrix as well as the disease and variant status for all individuals.

```
tsv.name<-system.file('extdata/1234_ex2.tsv', package = 'KinformR')
ind.df <- read.indiv(tsv.name)

ind.df.status <- score.variant.status(ind.df)

```

### Scoring variants
The two streams of information can then be combined to score a variant based off the relationships of individuals.

```
score.example <- score.fam(rel.mat, ind.df.status)
```

## Citation
Preprint available on medRxiv.

Nugent CM, MacMillan M, Barber T, Ballew BJ. KinformR: novel pedigree and candidate variant scoring methods for family-based genetic studies. medRxiv. 2025:2025-10. doi: https://doi.org/10.1101/2025.10.06.25337426
