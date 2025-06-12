

#' Take a disease status and a genetic variant and determine which category the combo falls in.
#' A.c = Affected individual with ALT variant
#' A.i = Affected individual without ALT variant
#' U.c = Unaffected individual without ALT variant
#' U.i = Unaffected individual with ALT variant
#' If theoretical.max = TRUE the true variant statuses are ignored and all
#' affected/unaffected are assigned A.c and U.c respectively.
#' These encoding can then be used show what a family's max score would be.
#'
#' @param status Disease status of an individual. A = affected, U = unaffected.
#' @param variant Variant for individual. genotypes, phased genotypes, or binary encodings accepted.
#' @param theoretical.max Should the theoretical maxima be returned instead of the observed values?
#' When true, the scoring assumes correct variant-status pair for each individual.
#' Default is FALSE.
#' @return a string
#' @examples
#' assign.status("A", "0/1") == "A.c"
#' assign.status("A", "0|0") == "A.i"
#' assign.status("U", 1) == "U.i"
#' assign.status("U", "0|0") =="U.c"
#' @export
assign.status <- function(status, variant,  theoretical.max=FALSE){

  var.err<-"Incompatible variant value! Supported encodings are: '0' '1' '0/0' '0/1' '0|0' '0|1'"
  if(status == "A"){
    if(theoretical.max){
      return("A.c")
    }
    #NOTE - Once in a while 1/0 genotypes crop up; also 0/2 etc. if derived from multi-allelics. This edge case not covered at present.
    else if(variant == "0/1" || variant == "1/1" || variant == "1" || variant == "0|1" || variant == "1|0" || variant == "1|1"  ){
      return("A.c")
    }else if (variant == "0/0" || variant == "0" || variant == "0|0" ){
      return("A.i")
    }else{
      stop(var.err)
    }
  }else if (status == "U"){
    if(theoretical.max){
      return("U.c")
    } else if(variant == "0/1" || variant == "1/1" || variant == "1" || variant == "0|1" || variant == "1|0" || variant == "1|1"  ){
      return("U.i")
    }else if (variant == "0/0" || variant == "0" || variant == "0|0" ){
      return("U.c")
    }else{
      stop(var.err)
    }
  }else{
    stop("Status must be one of: U or A")
  }
}

#' Take the dataframe with variants and status and determine which indivudals
#' are scored correctly and which are scored incorrectly.
#' Assign an A.c, A.i, U.c, U.i, unk
#'
#' Variants can be encoded as binary (0 or 1, genotypes 0/0 or 0/1, or phased genotypes 0|0 0|1).
#' Note the program assumes alt is the disease allele. homozygous alts are allowed.
#'
#' theoretical.max - bool, default is FALSE
#' when TRUE, function encodes the theoretical max,
#' using a dummy perfect associatng variant generated to see what a family could score.
#' TODO - switch to numbers 1-4 and -1?
#' @param indiv.df A dataframe with the format:
#' name	         status	variant
#' MS-5678-1001      A      0/1
#' @param theoretical.max Should the theoretical maxima be returned instead of the observed values?
#' When true, the scoring assumes correct variant-status pair for each individual.
#' Default is FALSE.
#' @return Copy of input dataframe, with dataframe with the status categroies added as a new column "statvar.cat"
#' @examples
#' #TODO - add
#' @export
score.variant.status <- function(indiv.df, theoretical.max=FALSE){

  #when encoding theoretical max, dummy perfect associating variant generated to see what a family could score.
  if(theoretical.max){
    indiv.df$statvar.cat <- unlist(lapply(1:nrow(indiv.df), function(i){
      assign.status(indiv.df$status[[i]], indiv.df$variant[[i]] ,  theoretical.max=TRUE )
    }))

  }else{
    indiv.df$statvar.cat <- unlist(lapply(1:nrow(indiv.df), function(i){
      assign.status(indiv.df$status[[i]], indiv.df$variant[[i]] )
    }))
  }

return(indiv.df)
}




#' Build dictionary with the relationships falling in the different categories for the query row.
#' @param mat.row A row from a relationship matrix
#' @param name.stat.dict A list with the labelled status/variant combo for each individual.
#' @param drop.unrelated Should unrelated (-1) relationships be dropped? Default = TRUE.
#'
#' @return A list with the categorized relationship/variant information.
#' @export
build.relation.dict <- function( mat.row, name.stat.dict, drop.unrelated=TRUE){
  indiv.rels = list(
    "A.c" = c(),
    "A.i" = c(),
    "U.c" = c(),
    "U.i" = c()
  )

  for(i in seq_along(mat.row)){

    status.i <- name.stat.dict[[names(mat.row)[[i]]]]
    rel.i <- mat.row[[i]]

    if (rel.i != -1 || drop.unrelated == FALSE){
      indiv.rels[[status.i]] <- c(indiv.rels[[status.i]], rel.i)
    }
    }

  return(indiv.rels)
}


#' Take the relationship matrix and the encoded statuses of info.
#' For each row, generate the encoded data for scoring.
#' @param relation.mat The relationship matrix for all pairwise combinations of individuals.
#' @param status.df The ID, status, and genotypes for each individual.
#' @param ... Additional arguments to be passed between methods.
#' @return A dictionary with the per-individual relationship lists.
#' One value for each row of the matrix.
#' @export
encode.rows <- function(relation.mat, status.df, ...){

  name.stat.dict <- status.df$statvar.cat
  names(name.stat.dict) <- status.df$name

  score.dicts <- lapply(1:nrow(relation.mat), function(i){
    build.relation.dict(relation.mat[i,], name.stat.dict)
  })

  names(score.dicts) <- colnames(relation.mat)

  return(score.dicts)
}




