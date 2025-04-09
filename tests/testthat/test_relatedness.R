test_that("Scoring proceeds as expected in all cases", {

  #TODO
  calc.rv.score

  #TODO
  score.fam

  # TODO
  a <- c("score"=10, "for"=10, "against"=0)
  b <- c("score"=20, "for"=20, "against"=0)
  c <- c("score"=30, "for"=40, "against"=10)

  abc<- sum.fam.scores(c(a,b,c))
  expected.abc <-  c("score"=60, "for"=70, "against"=10)
  expect_equal(abc, expected.abc)
  })
