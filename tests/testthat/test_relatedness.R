test_that("Scoring proceeds as expected in all cases", {

  #TODO
  calc.rv.score

  #TODO
  score.fam

  # TODO
  a <- c("score"=10, "score.for"=10, "score.against"=0)
  b <- c("score"=20, "score.for"=20, "score.against"=0)
  c <- c("score"=30, "score.for"=40, "score.against"=10)

  abc<- sum.fam.scores(c(a,b,c))
  expected.abc <-  c("score"=60, "score.for"=70, "score.against"=10)
  expect_equal(all.equal(names(abc), names(expected.abc)), TRUE)
  for(i in length(abc)){
    expect_equal(abc[[i]], expected.abc[[i]])
  }

    })
