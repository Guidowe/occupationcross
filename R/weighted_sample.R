#' Pick one destination code, optionally weighted (internal)
#'
#' Resolves crosswalk ambiguity by drawing a single code from `candidates`.
#' When `w` (a named numeric vector indexed by destination code) is supplied the
#' draw is proportional to those weights restricted to the candidate set, and it
#' falls back to a uniform draw whenever none of the candidates carries positive
#' weight. With `w = NULL` it is a plain uniform draw, the package default.
#'
#' @param candidates character vector of candidate destination codes
#' @param w optional named numeric vector mapping code -> weight
#' @return a single code (character), or NA_character_ when there are no candidates
#' @keywords internal
#' @noRd
pick_one <- function(candidates, w = NULL) {
  candidates <- candidates[!is.na(candidates)]
  n <- length(candidates)
  if (n == 0) return(NA_character_)
  if (n == 1) return(candidates[[1]])
  if (is.null(w)) return(sample(candidates, size = 1))
  pr <- w[candidates]
  pr[is.na(pr)] <- 0
  if (sum(pr) <= 0) return(sample(candidates, size = 1))  # fallback to uniform
  sample(candidates, size = 1, prob = pr)
}
