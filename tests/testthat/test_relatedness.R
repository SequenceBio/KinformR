test_that("Scoring proceeds as expected in all cases", {


  print("test per encoding score calculation for several combos")
  print("1. simple proband-sib")
  encoded.dat1 <- list("A.c" = c(0, 1),
                      "A.i" = c(),
                      "U.c" = c(),
                      "U.i" = c())

  expected.score1<- list("score" = 3,
                         "score.for" = 3,
                         "score.against" = 0 )
  score1 <- calc.rv.score(encoded.dat1)
  expect_equal(expected.score1, score1)

  print("2.  correct A proband and cousin, incorrect unaffected sib")
  encoded.dat2 <- list("A.c" = c(0, 3),
                      "A.i" = c(),
                      "U.c" = c(),
                      "U.i" = c(1))

  expected.score2<- list("score" = 5,
                         "score.for" = 9,
                         "score.against" = 4 )
  score2 <- calc.rv.score(encoded.dat2)
  expect_equal(expected.score2, score2)

  print("2. repeat, but only consider affecteds in scoring")
  score2.no.u <- calc.rv.score(encoded.dat2, unaffected.weight=0)
  expected.score2.no.u<- list("score" = 9,
                         "score.for" = 9,
                         "score.against" = 0 )
  expect_equal(score2.no.u, expected.score2.no.u)

  print("3.  bad score proband and incorrect unaffected sib")

  encoded.dat3 <- list("A.c" = c(0),
                      "A.i" = c(),
                      "U.c" = c(),
                      "U.i" = c(1))

  expected.score3<- list("score" = -3,
                         "score.for" = 1,
                         "score.against" = 4)
  score3 <- calc.rv.score(encoded.dat3)
  expect_equal(expected.score3, score3)

  print("3.  complex score, all situations covered in one.")

  encoded.dat4 <- list("A.c" = c(0, 1, 3, 1),
                       "A.i" = c(3),
                       "U.c" = c(1, 2),
                       "U.i" = c(1))

  expected.score4<- list("score" = 7,
                         "score.for" = 19,
                         "score.against" = 12 )
  score4 <- calc.rv.score(encoded.dat4)
  expect_equal(expected.score4, score4)


  # TODO
  #scores



  #TODO
  # score.fam

  print("test summing of scores from different families")
  a <- c("score"=10, "score.for"=10, "score.against"=0)
  b <- c("score"=20, "score.for"=20, "score.against"=0)
  c <- c("score"=30, "score.for"=40, "score.against"=10)

  abc<- add.fam.scores(c(a,b,c))
  expected.abc <-  c("score"=60, "score.for"=70, "score.against"=10)
  expect_equal(all.equal(names(abc), names(expected.abc)), TRUE)
  for(i in length(abc)){
    expect_equal(abc[[i]], expected.abc[[i]])
  }

    })
