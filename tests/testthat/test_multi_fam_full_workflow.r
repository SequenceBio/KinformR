test_that("Scoring of variant in family multiple families proceeds as expected", {

  ##################################
  # test 1

  mat.name1<-system.file('extdata/5678_ex1.mat', package = 'KinformR')
  tsv.name1<-system.file('extdata/5678_ex1.tsv', package = 'KinformR')

  mat.name2<-system.file('extdata/9876_ex1.mat', package = 'KinformR')
  tsv.name2<-system.file('extdata/9876_ex1.tsv', package = 'KinformR')

  mat.name3<-system.file('extdata/5432_ex1.mat', package = 'KinformR')
  tsv.name3<-system.file('extdata/5432_ex1.tsv', package = 'KinformR')

  mat.fnames <- c(mat.name1, mat.name2, mat.name3)
  tsv.names <- c(tsv.name1, tsv.name2, tsv.name3)

  mat.df <- lapply(mat.fnames, read.relation.mat)
  indv.df <- lapply(tsv.names, read.indiv)

  status.df <-  lapply(indv.df, score.variant.status)

  bulk.scores <- mapply(score.fam, mat.df, status.df, affected.weight=1, unaffected.weight=0.5, return.sums = TRUE)

  #TODO - formalize this for better interface with bulk processing
  summed.scores<-add.fam.scores(c(bulk.scores[,1], bulk.scores[,2], bulk.scores[,3 ]))

  expected.summed.scores <- c("score" = 102.75,"score.for" = 212.75, "score.against" = 110.0)
  expect_equal(all.equal(expected.summed.scores, summed.scores), TRUE)

  #TODO -possibly refactor above into a "score families" bulk function

})
