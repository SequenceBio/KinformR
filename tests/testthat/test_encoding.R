test_that("Families are correctly encoded.", {

  # Test status assignments
  print("assign.status checks")
  expect_equal(assign.status("A", "0/1"), "A.c")
  expect_equal(assign.status("A", "0|1"), "A.c")
  expect_equal(assign.status("A", "1|0"), "A.c")
  expect_equal(assign.status("A", 1), "A.c")

  expect_equal(assign.status("A", 0), "A.i")
  expect_equal(assign.status("A", "0/0"), "A.i")
  expect_equal(assign.status("A", "0|0"), "A.i")

  expect_equal(assign.status("U", 1), "U.i")
  expect_equal(assign.status("U", "0/1"), "U.i")
  expect_equal(assign.status("U", "0|1"), "U.i")
  expect_equal(assign.status("U", "1|0"), "U.i")

  expect_equal(assign.status("U", 0), "U.c")
  expect_equal(assign.status("U", "0/0"), "U.c")
  expect_equal(assign.status("U", "0|0"), "U.c")

  # Test score.variant.status assignments
  #TODO - add the ability to encode a theoretical max
  expect_error(assign.status("BAD", 0), "Status must be one of: U or A")

  expect_error(assign.status("A", "./."), "Incompatible variant value! Supported encodings are: '0' '1' '0/0' '0/1' '0|0' '0|1'")
  expect_error(assign.status("U", "0|."), "Incompatible variant value! Supported encodings are: '0' '1' '0/0' '0/1' '0|0' '0|1'")

  #tsv.name1<-"Data/1234_ex2.tsv"
  tsv.name1<-system.file('extdata/1234_ex2.tsv', package = 'KinformR')
  indiv.df <- read.indiv(tsv.name1)

  print("score values for a real family")
  scores<-score.variant.status(indiv.df)
  expected.scores<-c("A.c", "U.i", "A.c", "A.c", "A.i", "U.c", "A.c", "U.c")
  expect_equal(scores$statvar.cat, expected.scores)

  print("theoretical.max high score values for a family")
  ther.scores <- score.variant.status(indiv.df, theoretical.max=TRUE)

  expected.thermax.scores <- c("A.c","U.c","A.c","A.c","A.c" ,"U.c", "A.c", "U.c")
  expect_equal(ther.scores$statvar.cat, expected.thermax.scores)


})
