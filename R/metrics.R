
#' Compute True Positive Rate \code{TP/P}
#' 
#' @export
#' @param x tibble with columns pres (0/1) and pred (0-1) 
#' @param threshold, numeric values at or above are 'positive' predictions
#' @return vector of TPR
TPR <- function(x, threshold = seq(from = 0, by = 0.01, length = 100)){
  present <- x$pres > 0
  P <- sum(present)
  TP <- sapply(threshold,
               function(thresh, present = NULL) {
                 sum(x$pred >= thresh & present)
               }, present = present)
  TP/P
}

#' False Positive Rate \code{FP/N}
#' 
#' @export
#' @param x tibble with columns pres (0/1) and pred (0-1) 
#' @param threshold, numeric values at or above are 'positive' predictions
#' @return vector of FPR
FPR <- function(x, threshold = seq(from = 0, by = 0.01, length = 100)){
  negative <- x$pres <= 0
  N <- sum(negative)
  FP <- sapply(threshold,
               function(thresh, negative = NULL) {
                 sum(x$pred >= thresh & negative)
               }, negative = negative)
  FP/N
}

#' Compute the AUC for ROC values
#' 
#' @export
#' @param x numeric, vector of \code{TPR} or \code{ROC} object
#' @param y numeric, vector of \\code{FPR} or ignored if \code{x} inherits from class \code{ROC}
#' @return numeric Area Under Curve
AUC <- function(x, y){
  if (inherits(x, "ROC")){
    return(AUC(x$tpr, x$fpr))
  }
  auc = 0
  for(i in seq_len(length(x) - 1)) {
    auc = auc + (0.5 * (y[i] - y[i + 1]) * (x[i + 1] + x[i]))
  }
  return(auc)
  # r <- range(y)
  # mean(x)/(r[2]-r[1])
}

#' Compute Receiver Operator Curve (ROC) space values 
#' 
#' @export
#' @param x tibble with columns pres (0/1) and pred (0-1) 
#' @param threshold, numeric values at or above are 'positive' predictions
#' @return data frame of class ROC with variables \code{tpr} and \code{fpr}
ROC <- function(x, threshold = seq(from = 0, by = 0.01, length = 100)){
  roc <- dplyr::tibble(
    tpr = TPR(x, threshold = threshold),
    fpr = FPR(x, threshold = threshold))
  class(roc) <- c("ROC", class(roc))
  roc
}
