test_that("Data are read from files correctly", {

  ##################################
  # test 1

  #tsv.name1<-"extdata/1234_ex2.tsv"
  # TODO - switch all to this style
  tsv.name1 <-system.file('extdata/1234_ex2.tsv', package = 'seqbio.variant.scoring')
  ex1234.df <- read.indiv(tsv.name1)
  #mat.name1<-"extdata/1234_ex2.mat"
  mat.name1 <-system.file('extdata/1234_ex2.mat', package = 'seqbio.variant.scoring')
  ex1234.mat <- read.relation.mat(mat.name1)
  # TODO - could make an s3 class with the two data structures, have single func to
  # wrap this and read in both files.

  #TODO - hard code expected values, run matrix comparisons.


  ##################################
  # test 2 - horizontal tabular vcf-like output

  expected.test2 = data.frame("name" = c("MS-5678-1001", "MS-5678-1002", "MS-5678-1004",
                                         "MS-5678-6001", "MS-5678-1003"),
                              "status" = c("A", "U", "U", "U", "A"),
                              "variant" = c("0/1", "0/0", "0/0", "0/0", "0/1"))
  infile.test2 <-system.file('extdata/example_vcf_extract_5678.tsv',
                             package = 'seqbio.variant.scoring')

  test2.df <- read.var.table(infile.test2)
  expect_equal(test2.df, expected.test2)


  ##################################
  # test 3 - horizontal tabular vcf-like output with phased
  expected.test3 = data.frame("name" = c("MS-9876-1002",  "MS-9876-1009",  "MS-9876-1006",  "MS-9876-1004",
                                         "MS-9876-1007", "MS-9876-1003",  "MS-9876-1001",  "MS-9876-1008",  "MS-9876-1005"),
                              "status" = c("U","U","A","A","U", "U","A","U","U"),
                              "variant" = c("0|0","0|0","0|0","0|1","0|0","0|0","0|1","0|0","0|1"))
  infile.test3 <-system.file('extdata/example_vcf_extract_9876.tsv',
                             package = 'seqbio.variant.scoring')

  test3.df <- read.var.table(infile.test3)
  expect_equal(test3.df, expected.test3)

  ##################################
  # test 4 - TODO run a test where there are more people in the
  # matrix than there are in the status df, make sure that subsetting is performed
  # correctly.

})
