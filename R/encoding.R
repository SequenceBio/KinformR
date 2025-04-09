


assign.status <- function(status, variant){
  if(status == "A"){
    if(variant == "0/1" || variant == "1/1" || variant == "1" || variant == "0|1" || variant == "1|0"|| variant == "1|1"  ){
      return("A_c")

    }else if (variant == "0/0" || variant == "0" || variant == "0|0" ){
      return("A_i")
    }else{
      return("unk")
    }
  }else if (status == "U"){
    if(variant == "0/1" || variant == "1/1" || variant == "1" || variant == "0|1" || variant == "1|0"|| variant == "1|1"  ){
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
#' TODO - switch to numbers 1-4 and -1?
score.variant.status <- function(indiv.df){

  indiv.df$statvar.cat <- unlist(lapply(seq_along(1:nrow(indiv.df)), function(i){
    assign.status(indiv.df$status[[i]], indiv.df$variant[[i]] )
  }))

return(indiv.df)
}


