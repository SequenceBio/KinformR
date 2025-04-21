

#' Calculate a relatedness-weighted score for a given rare variant.
#'
#' These scores can be used to compare variants of interest within a family.
#'
#' For each individual, a relationship-informed weight is applied to their sharing
#' or not sharing of a variant.
#' The score for affected status is:
#'     (1 / coefficient_of_relatedness) * status_weight
#' For example, an affected cousin (encoded as a 3) would get a score of:
#'     (1/0.125) * affected weight
#'     8 * 1
#'     = 8 points in favour of the variant.
#' Whereas for unaffected unaffected individuals, scores decay the further a person is in
#' relation to the proband based on the formula:
#'     ((unaffected.max*2) * coefficient_of_relatedness ) * unaffected_weight
#' For example, with the default unaffected.max of 8. The sister that does not have a variant would get a score of
#'     ((8*2) 0.5) * unaffected_weight
#'     (16 * 0.5) * 0.5
#'     = 4 points for the variant.
#' If these were the only two relatives considered we could sum the points
#' and get a score in favour of the variant of
#'     8 + 4 = 12
#' Ig there is evidence against a variant, this is factored into the score as:
#'     total_score = evidence_for - evidence_against
#' For example, if there were also an affected sibling without the variant we would have the score against of:
#'  (1/0.5) * 1 = 2
#' The final score for the variant would then be
#'.    for - against = total
#'     12 - 2 = 10
#' Giving a final score of 10 for the variant. Comparing values across variants can be used
#' to rank them based on pedigree-informed levels of variant sharing across affected
#' and unaffected individuals.
#'     Increasing the affected.weight relative to the unaffected.weight will make the scores
#'     give more weight to the correct/incorrect status of affected individuals. The default
#'     is 2:1 weight for affected relative to unaffected, which accounts for the fact that
#'     variants are likely to be incompletely penetrant and we therefore want to be more tolerant
#'     of unaffected individuals that have a variant rather than affected individuals that do not.
#'
#' Input:
#' @param fam_list
#'         - A list with the names: ['A_c', 'A_i', 'U_c', 'U_i']
#'           respectively containing the affected correct, affected incorrect,
#'           unaffected correct and unaffected incorrect.
#'         - This can be generated with the function: score.variant.status
#'         - where each value in the dictionary is a list containing the reference and the
#'           reference's relatives as encoded based on their degree of relatedness to the
#'           reference (reference = 0, sibling/parent/offspring = 1, uncle/grandparent = 2,
#'           cousin = 3, etc.)
#' @param affected.weight A coefficient to multiply the calculated A_c and A_i relatedness values by.
#' @param unaffected.weight A coefficient to multiply the U_c and U_i relatedness values by.
#' @param unaffected.max This  param controls the score given to a first degree unaffected relatives
#'         scores decay from this specified maximum by half for each subsequent relationship degree.
#' @param max.err A heuristic cap of the number of incorrect assignments allowed when scoring. When the total number
#' of incorrect (sum of affected and unaffected) is exceeded,  the variant's score is set to 0, regardless of the number
#' of points for or against. This simplifies scoring and allows for fast filtering of poor quality variants. Default is 4.
#' @return A list with three components: score, score.for, score.against.
#'
#' @examples
#' relations<-list("A_c" = c(0, 1, 3, 1),"A_i" = c(3),"U_c" = c(1, 2),"U_i" = c(1))
#' rv.scores <- calc.rv.score(relations)
#' @export
calc.rv.score <- function(fam_list, affected.weight=1, unaffected.weight=0.5, unaffected.max=8, max.err=4){

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
            scores = c(scores, (unaffected.max*2) * relatedness[[x+1]])
          }
        }
        score_dict[[n]] = scores
    }

    weighted_for =  sum(score_dict[["A_c"]]*affected.weight ) +
                    sum(score_dict[["U_c"]]*unaffected.weight)


    weighted_against = sum(score_dict[["A_i"]]*affected.weight ) +
                    sum(score_dict[["U_i"]]*unaffected.weight)

    out.list <-  list("score" = weighted_for - weighted_against,
                      "score.for" = weighted_for,
                      "score.against" = weighted_against )


    n.incor <- length(score_dict[["A_i"]]) + length(score_dict[["U_i"]])
    if(n.incor > max.err){
      out.list[["score"]] <- 0
    }
    return(
      out.list
    )
}




#' Given a relationship matrix and status dataframe, score a family by applying the calc.rv.score
#' scoring system to every pairwise combination of individuals.
#'
#' By default all individuals are treated as the reference 'proband' and
#' the given variant's score  is calculated based on relationships to all other individuals.
#' e.g. for each row in the relationship matrix. calc.rv.score is run, with the row name indiciating the
#' reference individual that the calcualtion is relative to.
#'
#' There are several return options possible.
#'
#' - If affected.only is TRUE, the final scores will be reported for only rows where the reference
#' individual is affected (default = True).
#' - If return.means is TRUE, the average scores for the rows will be reported. (default = TRUE)
#' - If return.sums is True, the sum of the scores for all the rows will be reported. (default = False)
#' NOTE: if affected.only = True, the averages and sums are calculated using only the affected reference individuals.
#'
#' @param relation.mat A relationship matrix for the family.
#' @param status.df A dataframe with the encoded variant/disease status of each individual
#' @param affected.weight A coefficient to multiply the calculated A_c and A_i relatedness values by.
#' @param unaffected.weight A coefficient to multiply the U_c and U_i relatedness values by.
#' @param return.sums Boolean indicating if sum of family variant scores should be returned (default = FALSE).
#' @param return.means Boolean indicating if mean of all family variant scores should be returned (default = TRUE).
#' @param affected.only Boolean indicating if the family score should be calculated using only the affected individuals? (default = TRUE).
#' @param max.err A heuristic cap of the number of incorrect assignments allowed when scoring. When the total number
#' of incorrect (sum of affected and unaffected) is exceeded,  the variant's score is set to 0, regardless of the number
#' of points for or against. This simplifies scoring and allows for fast filtering of poor quality variants. Default is 4.
#' @return A labelled vector with names: score, score.for, score.against
#' @examples
#' mat.name1<-system.file('extdata/7003_notch3.mat', package = 'seqbio.variant.scoring')
#' tsv.name1<-system.file('extdata/7003_notch3.tsv', package = 'seqbio.variant.scoring')
#' mat.df <- read.relation.mat(mat.name1)
#' ind.df <- read.indiv(tsv.name1)
#' ind.df.status <-  score.variant.status(ind.df)
#' score_default <- score.fam(mat.df, ind.df.status)
#' @export
score.fam <- function(relation.mat, status.df, affected.weight=1, unaffected.weight=0.5,
                      return.sums  = FALSE, return.means = TRUE,
                      affected.only = TRUE, max.err=4){
  encoded.dat <- encode.rows(relation.mat, status.df, drop.unrelated=TRUE)

  per.indv.scores <- lapply(encoded.dat, calc.rv.score,
                            affected.weight=affected.weight, unaffected.weight=unaffected.weight,
                            max.err=max.err)

  scores <- do.call(rbind.data.frame,  per.indv.scores)

  if (affected.only){
        affected.indiv = status.df[status.df$status == "A",]
        scores<-scores[row.names(scores) %in% affected.indiv$name,]
  }

  if(return.sums){
    return(colSums(scores))
  }else if(return.means){
    return(colMeans(scores))
  }
  return(scores)
}


#' Sum all the given scores and return a single vector with cumulative "score", "for" and "against" vals.
#' For use in instances where one wishes to combine scores from multiple families.
#' @param score.vec A vector will all of the per family score outputs.
#' @return A vector with the summed scores of all inputs.
#' @examples
#' score.fam1 <- c("score" = 1.0, "score.for" = 2.0, "score.against" = 1.0)
#' score.fam2 <- c("score" = 1.0, "score.for" = 3.0, "score.against" = 2.0)
#' # out <- sum.fam.scores(c(score.fam1, score.fam2))
#' #returns:  c("score" = 2.0,"score.for" = 5.0, "score.against" = 3.0)
#' @export
sum.fam.scores <- function(score.vec){
  outvec<-tapply(score.vec, names(score.vec), sum)

  sorted.out<-c("score" = outvec[["score"]],
                "score.for" = outvec[["score.for"]],
                "score.against" = outvec[["score.against"]])
  return(sorted.out)
}




