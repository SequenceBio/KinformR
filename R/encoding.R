

#' Take a disease status and a genetic variant and determine which category the combo falls in.
#' A_c = Affected individual with ALT variant
#' A_i = Affected individual without ALT variant
#' U_c = Unaffected individual without ALT variant
#' U_i = Unaffected individual with ALT variant
#' If theoretical.max = TRUE the true variant statuses are ignored and all
#' affected/unaffected are assigned A_c and U_c respectively.
#' These encoding can then be used show what a family's max score would be.
#'
#' @param status Disease status of an individual. A = affected, U = unaffected.
#' @param variant Variant for individual. genotypes, phased genotypes, or binary encodings accepted.
#' @param theoretical.max Should the theoretical maxima be returned instead of the observed values?
#' When true, the scoring assumes correct variant-status pair for each individual.
#' Default is FALSE.
#' @return
#' @examples
#' @export
assign.status <- function(status, variant,  theoretical.max=FALSE){
  if(status == "A"){
    if(theoretical.max){
      return("A_c")
    }
    else if(variant == "0/1" || variant == "1/1" || variant == "1" || variant == "0|1" || variant == "1|0"|| variant == "1|1"  ){
      return("A_c")
    }else if (variant == "0/0" || variant == "0" || variant == "0|0" ){
      return("A_i")
    }else{
      return("unk")
    }
  }else if (status == "U"){
    if(theoretical.max){
      return("U_c")
    } else if(variant == "0/1" || variant == "1/1" || variant == "1" || variant == "0|1" || variant == "1|0"|| variant == "1|1"  ){
      return("U_i")
    }else if (variant == "0/0" || variant == "0" || variant == "0|0" ){
      return("U_c")
    }else{
      return("unk")
    }
  }else{
    return("unk")
  }
}

#' Take the dataframe with variants and status and determine which indivudals
#' are scored correctly and which are scored incorrectly.
#' Assign an A_c, A_i, U_c, U_i, unk
#'
#' Variants can be encoded as binary (0 or 1, genotypes 0/0 or 0/1, or phased genotypes 0|0 0|1).
#' Note the program assumes alt is the disease allele. homozygous alts are allowed.
#'
#' theoretical.max - bool, default is FALSE
#' when TRUE, function encodes the theoretical max,
#' using a dummy perfect associatng variant generated to see what a family could score.
#' TODO - switch to numbers 1-4 and -1?
#' @param indiv.df
#' @param theoretical.max Should the theoretical maxima be returned instead of the observed values?
#' When true, the scoring assumes correct variant-status pair for each individual.
#' Default is FALSE.
#' @return
#' @examples
#' @export
score.variant.status <- function(indiv.df, theoretical.max=FALSE){

  #when encoding theoretical max, dummy perfect associatng variant generated to see what a family could score.
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
#' @param mat.row
#' @param name.stat.dict
#' @param drop.unrelated
#'
#' @return A list with the categorized relationship/variant information.
#' @examples
#' @export
build.relation.dict <- function( mat.row, name.stat.dict, drop.unrelated=TRUE){
  indiv.rels = list(
    "A_c" = c(),
    "A_i" = c(),
    "U_c" = c(),
    "U_i" = c()
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
#' @return A dictionary with the per-individual relationship lists.
#' One value for each row of the matrix.
#' @examples
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




