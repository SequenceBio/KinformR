# seqbio.variant.scoring
## An R package method for scoring variants based on relationships of individuals.

*WORK IN PROGRESS - currently a minimal viable product.*

## Introduction
When looking at shared rare variants across families, not all sets of affected and unaffected individuals are equal. 

This R package is designed to score rare variants, assigning values based on the disease status of individuals, 
the presence or absence of a rare variant in those individuals, and their pairwise coefficients of relatedness.
The package uses a custom formula to assign value to a variant that gives more weight to shared variants common
to distantly related affected individuals. The variant status for unaffected individuals can optionally be considered
as well, with the highest scoring values being given to closely related individuals that *do not* share a variant of interst.
Since variants can be incompletely penetrant, the scoring can be based solely on the affected individuals, or the weight 
of unaffected evidence can be customized.


## How it works

For a walk through of the seqbio.variant.scoring functions for scoring the value of *families* based on penetrance and IBD, see the corresponging vignette: 

For a walk through of the seqbio.variant.scoring functions for scoring the value of *variants* within families, see the corresponging vignette: 



### The relationship matrix

This input is a matrix containing all the pairwise relationships of individuals in a family. The row and column names are the individual IDs, and the intersecting value denotes the degree of relationship between the individuals (self = 0, 1st degree relations. = 1, etc. Unrelated individuals are given a value of -1). As of version `0.1.0` the relation matrix is a manually created file, where relationship values are assigned via manual inspection of the family pedigree.

### The status file

This file includes the same individual IDs used in the relationship matrix as well as the disease and variant status for all individuals.


## related info

- slides on concept: https://docs.google.com/presentation/d/1yWlj400fbsrS1CCd4wpy7ve9Sov56H82lZh7hoW8vyg/edit#slide=id.g34c18bf0cf2_0_112
- penetrance related code: https://github.com/SequenceBio/seqbio-pedigree-ranking
- penetrance related notes: https://sequencebio.atlassian.net/wiki/spaces/SEQUENCEPE/pages/1443364866/Quantifying+power+of+a+family+for+discovery



## TODO 
- add a description of the formulas and scoring system here
- outline how to deploy the code
- a means of building the relationship matricies easily?
- generate scores for a variety of situations. Do they make sense? Can they be summed across families?


