test_that("Scoring of variant in family multiple families proceeds as expected", {

  ##################################
  # test 1

  mat.name1<-system.file('extdata/4107_gcn1.mat', package = 'seqbio.variant.scoring')
  gcn1_4107.mat <- read.relation.mat(mat.name1)
  tsv.name1<-system.file('extdata/4107_gcn1.tsv', package = 'seqbio.variant.scoring')
  gcn1_4107.df <- read.indiv(tsv.name1)

  gcn1_4107.df.status <- score.variant.status(gcn1_4107.df)
  gcn1_4107.score <- score.fam(gcn1_4107.mat, gcn1_4107.df.status, affected.weight=1, unaffected.weight=0.5, return.sums = TRUE)


  mat.name2<-system.file('extdata/4974_gcn1.mat', package = 'seqbio.variant.scoring')
  gcn1_4974.mat <- read.relation.mat(mat.name2)
  tsv.name2<-system.file('extdata/4974_gcn1.tsv', package = 'seqbio.variant.scoring')
  gcn1_4974.df <- read.indiv(tsv.name2)

  gcn1_4974.df.status <-  score.variant.status(gcn1_4974.df)
  gcn1_4974.score <- score.fam(gcn1_4974.mat, gcn1_4974.df.status, affected.weight=1, unaffected.weight=0.5, return.sums = TRUE)

  mat.name3<-system.file('extdata/8363_gcn1.mat', package = 'seqbio.variant.scoring')
  gcn1_8363.mat <- read.relation.mat(mat.name3)
  tsv.name3<-system.file('extdata/8363_gcn1.tsv', package = 'seqbio.variant.scoring')
  gcn1_8363.df <- read.indiv(tsv.name3)

  gcn1_8363.df.status <-  score.variant.status(gcn1_8363.df)
  gcn1_8363.score <- score.fam(gcn1_8363.mat, gcn1_8363.df.status, affected.weight=1, unaffected.weight=0.5, return.sums = TRUE)


  #TODO - make this function
  sum.fam.scores(c(gcn1_4107.score, gcn1_4974.score, gcn1_8363.score))


  # TODO - can we refactor above into 3 lapplys for bulk process?
  # if yes, make it a wrapper script for bulk processing.

})
