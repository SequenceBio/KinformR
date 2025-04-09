

#' Read in variant and status info for individuals
#'
read.indiv <- function(fname){

  df<-read_tsv(fname)
  return(df)
}

#' Read in relationship matrix
#' Apply the individual names to the rows and columns
read.relation.mat <- function(fname, indiv.df){

  mat<-read.matrix(fname)

  return(df)
}
