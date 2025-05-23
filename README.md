# seqbio.variant.scoring
## An R package method for scoring variants based on relationships of individuals.


## Introduction




## Installation


The development version of `debar` can be installed directly from GitHub. You'll need to have the R package `devtools` installed and loaded. Also note if the build_vignettes option is set to true, you will need to have the R package `knitr` installed.

```
#install.packages("devtools")
#install.packages("knitr") #required if build_vignettes = TRUE
#library(devtools) 
devtools::install_github("SequenceBio/seqbio.variant.scoring", build_vignettes = TRUE)
library(seqbio.variant.scoring)
```

## How it works

The package's vignette contains detailed explanations of the functions and parameters.

For a walk through of the seqbio.variant.scoring functions for scoring the value of *families* based on penetrance and IBD, see the corresponging vignette file: 
`vignettes/seqbio.variant.scoring-penetrance_and_ibd.Rmd`
or within R, run:
```
vignette('seqbio.variant.scoring-penetrance_and_ibd')
```

For a walk through of the seqbio.variant.scoring functions for scoring the value of *variants* within families, see the corresponging vignette file: 
`vignettes/seqbio.variant.scoring-variant_scoring.Rmd`

or within R, run:
```
vignette('seqbio.variant.scoring-variant_scoring')
```

## Scoring families

### The encoding file

See the included example data, which encodes 14 families. See the accompanying vignette for more information on encoding pedigrees:
```
  example.pedigree.file <-system.file('extdata/example_pedigree_encoding.tsv', package = 'seqbio.variant.scoring')
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

When looking at shared rare variants across families, not all sets of affected and unaffected individuals are equal. This R package is designed to score rare variants, assigning values based on the disease status of individuals, the presence or absence of a rare variant in those individuals, and their pairwise coefficients of relatedness. The package uses a custom formula to assign value to a variant that gives more weight to shared variants common to distantly related affected individuals. The variant status for unaffected individuals can optionally be considered as well, with the highest scoring values being given to closely related individuals that *do not* share a variant of interst. Since variants can be incompletely penetrant, the scoring can be based solely on the affected individuals, or the weight of unaffected evidence can be customized.


### The relationship matrix

This input is a matrix containing all the pairwise relationships of individuals in a family. The row and column names are the individual IDs, and the intersecting value denotes the degree of relationship between the individuals (self = 0, 1st degree relations. = 1, etc. Unrelated individuals are given a value of -1). As of version `0.1.0` the relation matrix is a manually created file, where relationship values are assigned via manual inspection of the family pedigree.

```
mat.name<-system.file('extdata/1234_ex2.mat', package = 'seqbio.variant.scoring')

rel.mat <- read.relation.mat(mat.name)
```

### The status file

This file includes the same individual IDs used in the relationship matrix as well as the disease and variant status for all individuals.

```
tsv.name<-system.file('extdata/1234_ex2.tsv', package = 'seqbio.variant.scoring')
ind.df <- read.indiv(tsv.name)

ind.df.status <-  score.variant.status(notch1234.df)

```

### Scoring variants
The two streams of information can then be combined to score a variant based off the relationships of individuals.

```
score.example <- score.fam(rel.mat, ind.df.status)
```