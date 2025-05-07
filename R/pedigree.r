
#' Likelihood function for calculation of Pedigree-based autosomal dominant penetrance value.
#' Formula deployed via optimize so as to determine the optimal value.
#'
#' @param K Seed value for the estimate of penetrance rate.
#' @param a Count of affected individuals
#' @param b Count of obligate carriers
#' @param c Count of children of either affecteds or carriers, with no children of their own
#' @param d Count of Trees of unaffected individuals - specifically, two sequential generations (i.e. a parent and their offspring)
#' @param n Count of the number of second generation progeny in a given tree.
#'
#' @return K Pedigree-based estimation of autosomal dominant penetrance rate.
#' @export
#'
#' @examples
penetrance <- function(K, a, b, c, d, n) {
  a*log(K) + b*log(1-K) + c*log(2-K) + sum(d*log(2^n + (1-K)*(2-K)^n) - d*(n+1)*log(2))
}


#' Calculation of Identity by descent (IBD).
#'
#' Use the relationship informationfrom the pedigree to
#' estimate of the amount of the genome they have inherited it from a
#' common ancestor without recombination.
#'
#' Can do this for the total potential relatedness in a pedigree (theoretical=TRUE),
#' or for the actual relatedness across collected samples (theoretical=FALSE).
#' For the theoretical=TRUE case, in the unaffected trees, if we have a sample from the parent,
#' then the offspring do not provide any additional information for a max IBD calculation.
#' This means that K does not scale with n.
#'
#' For theoretical=FALSE,  sometimes we don’t have the healthy parent in an unaffected tree,
#' and only have a child. In this case, the IBD contribution from the child is 1/4,
#' and since they’re unaffected and therefore are a counter-filter,
#' they would contribute 1-1/4 = 3/4 to the total relatedness.
#' Either the parent is a non-obligate carrier, or is a non-carrier.
#' The probability of the children depends on which of those is true,
#' so we have the additional set of terms in the theoretical=FALSE logic.
#'
#'
#' @param a Count of affected individuals
#' @param b Count of obligate carriers
#' @param c Count of children of either affecteds or carriers, with no children of their own
#' @param d Count of Trees of unaffected individuals - specifically, two sequential generations (i.e. a parent and their offspring)
#' @param n Count of the number of second generation progeny in a given tree.
#' @param K The estimate of penetrance rate.
#' @param theoretical Boolean indicating if the calculation should be
#' theoretical IBD calculation (using only d and k), or if the calculation
#' should use the provided n value.
#'
#'
#' @return pi-hat value. The proportion of genome shared between individuals.
#' @export
#'
#' @examples
ibd <- function(a, b, c, d, n, K, theoretical=TRUE) {
  if (theoretical) {
    x <- sum(d) * 2^K
  } else {
    x <- sum(d*(1 - (2^n-1)/2^(n+1))) * 2^K
  }
  pihat<-(a + b + c * 2^K + x) - 1
  return(pihat)
}



#' Rank the pedigrees using the pihat values.
#'
#' @param pihat Estimated proportion of genome shared between individuals, from function: ibd.
#' @param K Estimated penetrance value, from function: penetrance.
#'
#' @return
#' @export
#'
#' @examples
rank <- function(pihat, K=-1) {
  log(2^pihat)
}


#' Read in the encoded pedigree data file.
#' TODO - can we build this encoded matrix from a more standard file format? i.e. ped-like?
#'
#' @param filename name of the file with the data.
#'
#' @return A data frame containing the encoded pedigree information.
#' @export
#'
#' @examples
#' example.pedigree.file <-system.file('extdata/example_pedigree_encoding.tsv', package = 'seqbio.variant.scoring')
#' example.pedigree.df <- read.pedigree(example.pedigree.file)
read.pedigree <- function(filename){
  h <- read.table(filename, header=TRUE, sep="\t", check.names=FALSE, colClasses=c("Family"="character"))
  return(h)
}



#' Take the encoded information about the pedigrees and calculate penetrance.
#'
#' Determine a value rank of families by comparing their relationship structure.
#' More distant relationships between affecteds (e.g. affected cousins)
#' is more valuable that close relationships (e.g. affected siblings)
#' as there is less IBD and therefore a smaller search space.
#'
#'Simplifying assumptions:
#'   - Autosomal dominant
#'   - No ambiguous statuses
#'   - No more than two sequential generations of unknown carrier status
#'     (non-obligate carrier vs. non-carrier).
#'     Generalized support of arbitrary tree structures gets a lot more complicated, especially for the likelihood function.
#'   - Exclude big giant trees of unaffecteds - related to above.
#'     Will slightly bias the result toward higher penetrance.
#'   - Exclude subjects younger than age of onset
#'
#' @param h A data frame containing the encoded pedigree information
#' @return A data frame containing the theoretical ranking of the power of a
#' family assuming you were able to collect everyone on the simplified pedigree,
#' as well as a current ranking, examining only those for whom you currently have DNA.
#' @export
#'
#' @examples
#' example.pedigree.file <-system.file('extdata/example_pedigree_encoding.tsv', package = 'seqbio.variant.scoring')
#' example.pedigree.df <- read.pedigree(example.pedigree.file)
#' penetrance.df <- score.pedigree(example.pedigree.df)
score.pedigree <- function(h){

  family_vec <- c()
  penetrance_vec <- c()
  max_pihat_vec <- c()
  max_rank_vec <- c()
  current_pihat_vec <- c()
  current_rank_vec <- c()
  for (i in seq_len(nrow(h))) {
    family <- h[i,"Family"]
    max_a <- h[i, "max_a"]
    max_b <- h[i, "max_b"]
    max_c <- h[i, "max_c"]
    max_d <- h[i, "max_d"]
    max_n <- h[i, "max_n"]
    a_actual <- h[i, "a"]
    b_actual <- h[i, "b"]
    c_actual <- h[i, "c"]
    d_actual <- h[i, "d"]
    n_actual <- h[i, "n"]

    max_d <- as.numeric(strsplit(as.character(max_d), ",")[[1]])
    max_n <- as.numeric(strsplit(as.character(max_n), ",")[[1]])

    K <- optimize(penetrance, c(0,1), max_a, max_b, max_c, max_d, max_n, maximum=TRUE)$max
    max_pihat <- ibd(max_a, max_b, max_c, max_d, max_n, K)
    max_rank <- rank(max_pihat, K)
    current_pihat <- ibd(a_actual, b_actual, c_actual, d_actual, n_actual, K, FALSE)
    current_rank <- rank(current_pihat, K)

    family_vec <- c(family_vec, family)
    penetrance_vec <- c(penetrance_vec, K)
    max_pihat_vec <- c(max_pihat_vec, max_pihat)
    max_rank_vec <- c(max_rank_vec, max_rank)
    current_pihat_vec <- c(current_pihat_vec, current_pihat)
    current_rank_vec <- c(current_rank_vec,current_rank)
  }

  df <- data.frame(family_vec, penetrance_vec, max_pihat_vec, max_rank_vec, current_pihat_vec, current_rank_vec)
  colnames(df) <- c("family", "penetrance", "max_pi-hat", "max_rank", "current_pi-hat", "current_rank")
  df$pct_of_max <- df$current_rank / df$max_rank * 100
  df[, -1] <- round(df[, -1], 2)
  return(df)
}
