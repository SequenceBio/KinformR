

#' Calculate a relatedness-weighted score for a given rare variant.
#'
#' These scores can be used to compare variants of interest within a family
#'
#' For each individual, a relationship-informed weight is applied to their sharing
#' or not sharing of a variant.
#' Their score is:
#'     (1 / coefficient_of_relatedness) * status_weight
#' For example, an affected cousin (encoded as a 3) would get a score of:
#'     (1/0.125) * affected weight
#'     8 * 1
#'     = 8 points in favour of the variant.
#' Whereas a unaffected sister that has a variant would get a score of
#'     (1 / 0.5) * unaffected weight
#'     2 * 0.5
#'     = 1 point against the variant.
#' If these were the only two relatives considered we could sum the points for and against
#' for - against
#' 8 - 1
#' = 7
#' Giving a final score of 7 for the variant. Comparing values across variants can be used
#' to rank them based on pedigree-informed levels of variant sharing across affected
#' and unaffected individuals.
#'
#' Input:
#'     fam_dict
#'         - A dictionary with the keys: ['A_c', 'A_i', 'U_c', 'U_i']
#'           respectively containing the affected correct, affected incorrect,
#'           unaffected correct and unaffected incorrect.
#'         - where each value in the dictionary is a list containing the proband and the
#'           proband's relatives as encoded based on their degree of relatedness to the
#'           proband. (proband = 0, sibling/parent/offspring = 1, uncle/grandparent = 2,
#'           cousin = 3, etc.)
#'     affected.weight
#'         - a coefficient to multiply the calculated A_c and A_i relatedness values by.
#'     unaffected.weight
#'         - a coefficient to multiply the U_c and U_i relatedness values by.
#'     unaffected_max
#'         - is the param controlling the score given to a first degree unaffected relatives
#'         scores decay from this specified maximum by half for each subsequent relationship degree.
#'
#'     Increasing the affected.weight relative to the unaffected.weight will make the scores
#'     give more weight to the correct/incorrect status of affected individuals. The default
#'     is 2:1 weight for affected relative to unaffected, which accounts for the fact that
#'     variants are likely to be incompletely penetrant and we therefore want to be more tolerant
#'     of unaffected individuals that have a variant rather than affected individuals that do not.
calc.rv.score <- function(fam_list, affected.weight=1, unaffected.weight=0.5, unaffected_max=8){

    relatedness = list()

    for(i in 0:8){
        relatedness[i+1] =  1 / (2 ** (i))
        }

    score_dict = list()

    score_dict[["A_c"]]
    score_dict[["A_i"]]
    score_dict[["U_c"]]
    score_dict[["U_i"]]

    #TODO - change this to apply the different formula for the unaffecteds
    for (n in names(fam_list)){
        scores = c()
        if(n == "A_c" || n == "A_i"){
          for (x in fam_list[[n]]){
            #for affected, importance score gets higher the further from reference individual you get.
            scores = c(scores, 1/relatedness[[x+1]])
          }
        }else if ( n=="U_c" || n == "U_i"){
          for (x in fam_list[[n]]){
            #for unaffected, importance score gets lower the further from reference individual you get.
            scores = c(scores, (unaffected_max*2) * relatedness[[x+1]])
          }
        }
        score_dict[[n]] = scores
    }

    weighted_for =  sum(score_dict[["A_c"]]*affected.weight ) +
                    sum(score_dict[["U_c"]]*unaffected.weight)


    weighted_against = sum(score_dict[["A_i"]]*affected.weight ) +
                    sum(score_dict[["U_i"]]*unaffected.weight)


    return(
        list("score" = weighted_for - weighted_against,
        "for" = weighted_for,
        "against" = weighted_against )
    )

}




#' Given a
score.fam <- function(relation.mat, status.df, affected.weight=1, unaffected.weight=0.5, return.sums = TRUE){
  encoded.dat <- encode.rows(relation.mat, status.df, drop.unrelated=TRUE)

  per.indv.scores <- lapply(encoded.dat, calc.rv.score, affected.weight=affected.weight, unaffected.weight=unaffected.weight)

  scores <- do.call(rbind.data.frame,  per.indv.scores)

  if(return.sums){
    return(colSums(scores))
  }
  return(scores)
}




# Count the number of non-overlapping paths between all pedigree members
# (1/2)^n.
# We can do this twice - once for the total potential relatedness in a pedigree,
# and again for the actual relatedness across collected samples.
pedigree.paths <- function(n){
    return(0.5^n)
}

