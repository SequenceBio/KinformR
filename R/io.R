

#' Read in variant and status info for individuals.
#'
#' @param fname A file name, expected format of contents is:
#' name	         status	variant
#' MS-4107-1001      A      0/1
#' @return A data frame.
#' @examples
#' tsv.name1 <-system.file('extdata/7003_notch3.tsv', package = 'seqbio.variant.scoring')
#' id.df1 <- read.indiv(tsv.name1)
#' @export
read.indiv <- function(fname){
  df <- read.csv(fname, sep = "\t")
  return(df)
}

#' Read in relationship matrix
#' Apply the individual names to the rows and columns.
#'
#' Row/column intersections give the degree of relationship for the
#' two individuals. 0 = self, -1 = unrelated.
#'
#' @param fname The file with the relationship matrix information.
#' @return A matrix with the relationships and individual ids as rownames and colnames.
#' @examples
#' mat.name1 <-system.file('extdata/7003_notch3.mat', package = 'seqbio.variant.scoring')
#' mat1 <- read.relation.mat(mat.name1)
#' @export
read.relation.mat <- function(fname){

  rmat <- as.matrix(read.table(fname))
  #this resets the auto replacement of - with . in the colnames
  colnames(rmat)<-rownames(rmat)

  #TODO - add a safety check and error is the matrix is not a diagonal mirror
  # this would suggest an encoding error.
  return(rmat)
}

#' Read in a vcf-like subset of information obtained from
#' use of seqbiopy's vcf_extract function on a vcf with the
#' status encoded in the indivudal's names
#'
#' Note - ensure the status in the names match your desired encoding!
#' There are individuals with ambigious statues, that you may require to
#' be encoded in a specific fashion for you current purposes.
#'
#'
#'
#' @param fname A file name, expected format of contents is:
#' #CHROM  POS       REF  ALT  MS-4107-1001_A  MS-4107-1002_U  ...
#' chr3    46203838  G    A    0/1             0/0      ...
#' @return A dataframe.
#' Data will be worked into a data frame with format.
#' name	         status	variant
#' MS-4107-1001      A      0/1
#' @examples
#' ex.infile <-system.file('extdata/example_vcf_extract_4107.tsv',
#'                          package = 'seqbio.variant.scoring')
#' read.var.table(ex.infile)
#' @export
read.var.table <- function(fname){

  in.table <- read.table(fname, header = TRUE, comment.char = "~")

  in.variants <- unname(unlist(in.table[1,5:length(in.table)]))
  in.ids <- colnames(in.table)[5:length(colnames(in.table))]

  trimmed.ids <-  unlist(lapply(in.ids, function(x){strsplit(x, "_")[[1]][[1]]}))

  subbed.ids <- unlist(lapply(trimmed.ids, function(x){
    gsub("\\.", "-", x)
  }))

  status <- unlist(lapply(in.ids, function(x){strsplit(x, "_")[[1]][[2]]}))

  out.df<-data.frame("name" = subbed.ids,
                     "status" = status,
                     "variant" = in.variants)
  return(out.df)
}



