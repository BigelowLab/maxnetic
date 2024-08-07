
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
#' @export
#' @param x tibble with columns label (0/1) and pred (0-1) 
#' @param ... other arguments for \code{\link[AUC]{auc}}
#' @return numeric Area Under Curve as per \code{\link[AUC]{auc}}
AUC <- function(x, ...){
  r = AUC::auc(ROC(x),...)
  r
}

#' Compute Receiver Operator Curve (ROC) space values 
#' 
#' @export
#' @param x tibble with columns label (0/1) and pred (0-1) 
#' @return list as per \code{\link[AUC]{roc}} with 'area' added
ROC <- function(x){
  if (!is.factor(x$label)) x$label = factor(x$label, levels = c(0,1))
  r = AUC::roc(x$pred, x$label)
  r$area = AUC::auc(r)
  class(r) = c("ROC", class(r))
  r
}


