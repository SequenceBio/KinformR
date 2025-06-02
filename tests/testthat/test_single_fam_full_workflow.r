#library(seqbio.variant.scoring)
test_that("Scoring of variant in family single family proceeds as expected", {

  ##################################
  # test 1

  mat.name1<-system.file('extdata/1234_ex2.mat', package = 'seqbio.variant.scoring')
  ex1234.mat <- read.relation.mat(mat.name1)
  tsv.name1<-system.file('extdata/1234_ex2.tsv', package = 'seqbio.variant.scoring')
  ex1234.df <- read.indiv(tsv.name1)

  ex1234.df.status <-  score.variant.status(ex1234.df)

  ex2.1234.score.default <- score.fam(ex1234.mat, ex1234.df.status)
  expected.ex2.score.custom <- c("score"=21.3, "score.for"=27.6, "score.against"=6.3)
  expect_equal(ex2.1234.score.default, expected.ex2.score.custom)

  #should give a single list with the family totals
  ex2.1234.score.custom <- score.fam(ex1234.mat, ex1234.df.status,
                                 affected.weight=1, unaffected.weight=0.5,
                                 return.sums = TRUE, affected.only = FALSE)

  expected.ex2.score.custom <- c("score"=178.5, "score.for"=244, "score.against"=65.5)
  expect_equal(ex2.1234.score.custom,expected.ex2.score.custom)

  #should give the row-by-row
  ex2.1234.score.indiv.a.only <- score.fam(ex1234.mat, ex1234.df.status, affected.weight=1, unaffected.weight=0.5,
                                       return.means  = FALSE)

  expected.ex2.1234.score.indiv.a.only <- data.frame("score" = c(7., 9., 33.5, 31.5, 25.5),
                                                        "score.for" = c(19., 21., 34.5, 33.5, 30.),
                                                        "score.against" = c(12., 12., 1., 2., 4.5))
  rownames(expected.ex2.1234.score.indiv.a.only) <- c("MS-1234-1001", "MS-1234-1003", "MS-1234-1004",
                                                          "MS-1234-1005", "MS-1234-5001")

  expect_equal(all.equal(expected.ex2.1234.score.indiv.a.only, ex2.1234.score.indiv.a.only), TRUE)

  #affected only calculation
  ex2.1234.score.affected.only <- score.fam(ex1234.mat, ex1234.df.status, affected.weight=1, unaffected.weight=0.0)
  expected.ex2.score.affected.only <- c("score"=19.4, "score.for"=23.6, "score.against"=4.2)
  expect_equal(ex2.1234.score.affected.only,expected.ex2.score.affected.only)


  #affected only -per indiv
  ex2.1234.score.indiv.no.u <- score.fam(ex1234.mat, ex1234.df.status,
                                       affected.weight=1, unaffected.weight=0.0,
                                       return.means = FALSE,
                                       affected.only = TRUE)

  expected.ex2.1234.score.indiv.no.u <- data.frame("score" = c(5, 7, 33, 31, 21),
                                                        "score.for" = c(13, 15, 33, 32, 25),
                                                        "score.against" = c(8, 8, 0, 1, 4))
  rownames(expected.ex2.1234.score.indiv.no.u) <- c("MS-1234-1001", "MS-1234-1003", "MS-1234-1004",
                                                         "MS-1234-1005", "MS-1234-5001")

  expect_equal(all.equal(ex2.1234.score.indiv.no.u, expected.ex2.1234.score.indiv.no.u), TRUE)




  # possibly - mean of scores? Account for not inflating pedigrees with lots of people, or is that a feature not a bug.

  # TODO - try dropping individuals from the matrix, see if it still works. (should be OK)

  # TODO - option to wrap the read/status/score and do it all in one step. basically make it a one liner.


})
