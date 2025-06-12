test_that("Data are read from files correctly", {

  ##################################
  # test 1
  example.pedigree.file <-system.file('extdata/example_pedigree_encoding.tsv', package = 'KinformR')
  example.pedigree.df <- read.pedigree(example.pedigree.file)
  penetrance.df <- score.pedigree(example.pedigree.df)

  ##################################
  # test 2
  example.pedigree.file2 <-system.file('extdata/example_pedigree_encoding2.tsv', package = 'KinformR')
  #example.pedigree.file2 <- "inst/extdata/example_pedigree_encoding2.tsv"
  example.pedigree.df2 <- read.pedigree(example.pedigree.file2)
  penetrance.df2 <- score.pedigree(example.pedigree.df2)

  ##################################
  # test 3
  example.pedigree.file3 <-system.file('extdata/example_pedigree_encoding3.tsv', package = 'KinformR')
  #example.pedigree.file3 <- "inst/extdata/example_pedigree_encoding3.tsv"
  example.pedigree.df3 <- read.pedigree(example.pedigree.file3)
  penetrance.df3 <- score.pedigree(example.pedigree.df3)

  expected.penetrance.df3 <- data.frame(
    "family" = c("Fam1", "Fam2", "Fam3", "Fam4"),
    "penetrance" = c(0.37,0.58,0.45,0.57),
    "max.pi-hat" = c(9.76,8.97,7.73,8.43),
    "max.score" = c(6.76,6.22,5.36,5.84),
    "current.pi-hat" = c(2.97,2.49,3.36,3.97),
    "current.score" = c(2.06,1.73,2.33,2.75),
    "pct.of.max" = c(30.44,27.79,43.53,47.12)
  )
  colnames(expected.penetrance.df3) <- c("family", "penetrance", "max.pi-hat", "max.score", "current.pi-hat", "current.score", "pct.of.max")

  expect_equal(all.equal(penetrance.df3, expected.penetrance.df3), TRUE)

})
