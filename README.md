# seqbio-variant-scoring
A method for scoring variants based on relationships of individuals.

*WORK IN PROGRESS*

Idea here is to start with a simple R package continaing the functions needed, so that we could import and apply in different workflows or locations as required.
Could incorporate related code from pedigree ranking: https://github.com/SequenceBio/seqbio-pedigree-ranking
and build a scoring/ranking package that we can host on sb-conda.
If ideas are deemed to have external merit, we could make the repository public at some point to add the methods to a manuscript.


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


