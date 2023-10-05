
#' Compute True Positive Rate `TP/P` aka "sensitivity"
#' 
#' See more [here](https://en.wikipedia.org/wiki/Sensitivity_and_specificity)
#' 
#' @export
#' @param x tibble with columns label (0/1) and pred (0-1) 
#' @param ... further arguments for \code{\link[AUC]{sensitivity}}
#' @return list as per \code{\link[AUC]{sensitivity}}
TPR <- function(x, ...){
  if (!is.factor(x$label)) x$label = factor(x$label, levels = c(0,1))
  r = AUC::sensitivity(x$pred, x$label, ...)
  class(r) <- c("TPR", class(r))
  r
}

#' False Positive Rate `FP/N` aka "specificity"
#' 
#' See more [here](https://en.wikipedia.org/wiki/Sensitivity_and_specificity)
#' @export
#' @param x tibble with columns label (0/1) and pred (0-1) 
#' @param ... further arguments for \code{\link[AUC]{sensitivity}}
#' @return a list as per \code{\link[AUC]{sensitivity}}
FPR <- function(x, ...){
  if (!is.factor(x$label)) x$label = factor(x$label, levels = c(0,1))
  r = AUC::specificity(x$pred, x$label, ...)
  class(r) = c("FPR", class(r))
  r
}

#' Compute the AUC for ROC values
#' 
#'  We use the [trapezoidal rule](https://en.wikipedia.org/wiki/Trapezoidal_rule)
#' @export
#' @param x numeric, vector of \code{TPR} or \code{ROC} object
<<<<<<< HEAD
#' @param y numeric, vector of \\code{FPR} or ignored if \code{x} inherits from class \code{ROC}
#' @return numeric Area Under Curve
AUC <- function(x, y){
  if (inherits(x, "ROC")){
    return(AUC(x$tpr, x$fpr))
  }
  auc = 0
  for(i in seq_len(length(x) - 1)) {
    auc = auc + (0.5 * (y[i + 1] - y[i] ) * (x[i + 1] - x[i]) )
  }
  return(auc)
=======
#' @param ... other arguments for \code{\link[AUC]{auc}}
#' @return numeric Area Under Curve as per \code{\link[AUC]{auc}}
AUC <- function(x, ...){
  r = AUC::auc(ROC(x),...)
  r
>>>>>>> b83e0a1 (add AUC dependency)
}

#' Compute Receiver Operator Curve (ROC) space values 
#' 
#' @export
#' @param x tibble with columns label (0/1) and pred (0-1) 
#' @return list as per \code{\link[AUC]{roc}}
ROC <- function(x){
  if (!is.factor(x$label)) x$label = factor(x$label, levels = c(0,1))
  r = AUC::roc(x$pred, x$label)
  class(r) = c("ROC", class(r))
  r
}
