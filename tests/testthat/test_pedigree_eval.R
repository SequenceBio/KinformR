test_that("Data are read from files correctly", {

  ##################################
  # test 1
  example.pedigree.file <-system.file('extdata/example_pedigree_encoding.tsv', package = 'seqbio.variant.scoring')


  example.pedigree.df <- read.pedigree(example.pedigree.file)


  penetrance.df <- cal.penetrance(example.pedigree.df)
