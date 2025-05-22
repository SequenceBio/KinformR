test_that("Data are read from files correctly", {

  ##################################
  # test 1
  example.pedigree.file <-system.file('extdata/example_pedigree_encoding.tsv', package = 'seqbio.variant.scoring')
  example.pedigree.df <- read.pedigree(example.pedigree.file)
  penetrance.df <- score.pedigree(example.pedigree.df)

  ##################################
  # test 2
  example.pedigree.file2 <-system.file('extdata/example_pedigree_encoding2.tsv', package = 'seqbio.variant.scoring')
  example.pedigree.file2 <- "inst/extdata/example_pedigree_encoding2.tsv"
  example.pedigree.df2 <- read.pedigree(example.pedigree.file2)
  penetrance.df2 <- score.pedigree(example.pedigree.df2)



})
