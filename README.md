# seqbio-variant-scoring
## A method for scoring variants based on relationships of individuals.

*WORK IN PROGRESS - currently a minimal viable product.*

This R package is designed to score rare variants, assigning values based on the disease status of individuals, 
the presence or absence of a rare variant in those individuals, and their pairwise coefficients of relatedness.
The package uses a custom formula to assign value to a variant that gives more weight to shared variants common
to distantly related affected individuals. The variant status for unaffected individuals can optionally be considered
as well, with the highest scoring values being given to closely related individuals that *do not* share a variant of interst.
Since variants can be incompletely penetrant, the scoring can be based solely on the affected individuals, or the weight 
of unaffected evidence can be customized.


## related info

- slides on concept: https://docs.google.com/presentation/d/1yWlj400fbsrS1CCd4wpy7ve9Sov56H82lZh7hoW8vyg/edit#slide=id.g34c18bf0cf2_0_112
- penetrance related code: https://github.com/SequenceBio/seqbio-pedigree-ranking
- penetrance related notes: https://sequencebio.atlassian.net/wiki/spaces/SEQUENCEPE/pages/1443364866/Quantifying+power+of+a+family+for+discovery


## Introduction
When looking at shared rare variants across families, not all sets of affected and unaffected individuals are equal. 
This package is a method for scoring the evidence of a series of individuals in a way that takes into account the relatedness of the individuals as well as their disease status and genotype.


## TODO 
- add a description of the formulas and scoring system here
- outline how to deploy the code
- a means of building the relationship matricies easily?
- generate scores for a variety of situations. Do they make sense? Can they be summed across families?


