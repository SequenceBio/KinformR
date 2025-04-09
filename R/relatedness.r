

# Calculate a relatedness-weighted score for a given rare variant.
# 
# These scores can be used to compare variants of interest within a family
# 
# For each individual, a relationship-informed weight is applied to their sharing
# or not sharing of a variant.
# Their score is:
#     (1 / coefficient_of_relatedness) * status_weight
# For example, an affected cousin (encoded as a 3) would get a score of:
#     (1/0.125) * affected weight
#     8 * 1
#     = 8 points in favour of the variant.
# Whereas a unaffected sister that has a variant would get a score of
#     (1 / 0.5) * unaffected weight
#     2 * 0.5
#     = 1 point against the variant.
# If these were the only two relatives considered we could sum the points for and against
# for - against
# 8 - 1
# = 7
# Giving a final score of 7 for the variant. Comparing values across variants can be used
# to rank them based on pedigree-informed levels of variant sharing across affected
# and unaffected individuals.
# 
# Input:
#     fam_dict
#         - A dictionary with the keys: ['A_c', 'A_i', 'U_c', 'U_i']
#           respectively containing the affected correct, affected incorrect,
#           unaffected correct and unaffected incorrect.
#         - where each value in the dictionary is a list containing the proband and the
#           proband's relatives as encoded based on their degree of relatedness to the
#           proband. (proband = 0, sibling/parent/offspring = 1, uncle/grandparent = 2,
#           cousin = 3, etc.)
#     affected_weight
#         - a coefficient to multiply the calculated A_c and A_i relatedness values by.
#     unaffected_weight
#         - a coefficient to multiply the U_c and U_i relatedness values by.
# 
#     Increasing the affected_weight relative to the unaffected_weight will make the scores
#     give more weight to the correct/incorrect status of affected individuals. The default
#     is 2:1 weight for affected relative to unaffected, which accounts for the fact that
#     variants are likely to be incompletely penetrant and we therefore want to be more tolerant
#     of unaffected individuals that have a variant rather than affected individuals that do not.
calc_rv_score <- function(fam_list, affected_weight=1, unaffected_weight=0.5){

    relatedness = list()
    
    for(i in 0:6){
        relatedness[i+1] =  1 / (2 ** (i)) 
        }

    score_dict = list()

    for (n in names(fam_list)){
        scores = c()
        for (x in fam_list[[n]]){
            scores = c(scores, 1/relatedness[[x+1]])
        }
        score_dict[[n]] = scores
    }

    weighted_for =  sum(score_dict[["A_c"]]*affected_weight ) + 
                    sum(score_dict[["U_c"]]*unaffected_weight)
    

    weighted_against = sum(score_dict[["A_i"]]*affected_weight ) + 
                    sum(score_dict[["U_i"]]*unaffected_weight)


    return(
        list("score" = weighted_for - weighted_against,
        "for" = weighted_for,
        "against" = weighted_against )
    )

}


# Count the number of non-overlapping paths between all pedigree members
# (1/2)^n. 
# We can do this twice - once for the total potential relatedness in a pedigree, 
# and again for the actual relatedness across collected samples. 
pedigree_paths <- function(n){
    return(0.5^n)
}


main <- function(){
    family_A = list(
        "A_c" = c(0, 1, 1),
        "A_i" = c(),
        "U_c" = c(1),
        "U_i" = c()
    )

    calc_rv_score(family_A)
}

