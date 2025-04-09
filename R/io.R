

#' Read in variant and status info for individuals
#'
read.indiv <- function(fname){

  df<-read_tsv(fname)
  return(df)
}

#' Read in relationship matrix
#' Apply the individual names to the rows and columns.
#'
#' Row/column intersections give the degree of relationship for the
#' two individuals. 0 = self, -1 = unrelated.
read.relation.mat <- function(fname, indiv.df){

  rmat <- as.matrix(read.table(fname))
  #this resets the auto replacement of - with . in the colnames
  colnames(rmat)<-rownames(rmat)

  return(rmat)
}


