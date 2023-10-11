#' Plot ROC curve
#' 
#' @export
#' @param x ROC class object
#' @param xlab char, label for x axis
#' @param ylab char, label for y axis
#' @param use char, one of 'base' or 'ggplot' (default) or 'ggplot2'
#' @param title char title for the plot
#' @param ... ignored
#' @return ggplot2 object if \code{use} is
#'  'ggplot2' or 'ggplot'
plot.ROC <- function(x,
                     xlab = "False Positive Rate (Specificity)",
                     ylab = "True Positive Rate (Sensitivity)", 
                     title = "ROC",
                     use = "ggplot",
                     ...){


  if (any(grepl("ggplot", use, fixed = TRUE))){
    qplot_ROC(x, xlab = xlab, ylab = ylab, title = title, ...)
  } else {
    baseplot_ROC(x, xlab = xlab, ylab = ylab, title = title, ...)
  }
}

baseplot_ROC <- function(x,
                         xlab = "False Positive Rate (Specificity)",
                         ylab = "True Positive Rate (Sensitivity)", 
                         title = "ROC",
                         ...){
  on.exit({
    par(opar)
  })
  opar <- par(no.readonly = TRUE)
  plot(x$fpr, x$tpr, type = "S",
       xlab = xlab, ylab = ylab, main = title, 
       asp = 1,
       xlim = c(0,1),
       ylim = c(0,1), 
       xaxs = "r", 
       yaxs = "r")
  segments(0,0,1,1, col = 'grey')
  text(1,0, sprintf("AUC: %0.3f", x$area),
       adj = c(1,0))
  
}

qplot_ROC <- function(x,
                      xlab = "False Positive Rate (Specificity)",
                      ylab = "True Positive Rate (Sensitivity)", 
                      title = "ROC",
                      ...){
  
  r = data.frame(tpr = x$tpr, fpr = x$fpr)
  auc <- dplyr::tibble(
                       tx = 1,
                       ty = 0, 
                       label = sprintf("AUC: %0.3f", x$area))
  ggplot2::ggplot(data = r,
                  ggplot2::aes(x = .data$fpr, y = .data$tpr)) + 
    ggplot2::geom_step(colour = "black") + 
    ggplot2::geom_segment(ggplot2::aes(x = 0, y = 0, xend = 1, yend = 1), colour = "grey") +
    ggplot2::labs(x = xlab, y = ylab, title = title, ...) +
    ggplot2::coord_fixed() + 
    ggplot2::annotate("text", x = auc$tx, y=auc$ty, label = auc$label, 
                      hjust = 1, vjust = 0) 
  
}



#' Plot pAUC
#' 
#' @export
#' @param x a pAUC class object object
#' @param xlab char, label for x axis
#' @param ylab char, label for y axis
#' @param title char title for the plot
#' @param ... ignored
#' @return ggplot2 object
plot.pAUC = function(x,
                     xlab = "1 - Specificity (Fractional Predicted Area)",
                     ylab = "Sensitivity (1 - Omission Rate)", 
                     title = "Presence-only ROC", 
                     ...){
  
  auc <- dplyr::tibble(
    tx = 1,
    ty = 0, 
    label = sprintf("AUC: %0.3f", x$area))
  
  y = with(x, dplyr::tibble(x = fpa, y = sensitivity))
  
  ggplot2::ggplot(data = y, aes(x = x, y = y)) + 
    ggplot2::geom_step(colour = "black") + 
    ggplot2::geom_segment(ggplot2::aes(x = 0, y = 0, xend = 1, yend = 1), colour = "grey") +
    ggplot2::labs(x = xlab, y = ylab, title = title, ...) +
    ggplot2::coord_fixed() + 
    ggplot2::annotate("text", x = auc$tx, y=auc$ty, label = auc$label, 
                      hjust = 1, vjust = 0) 
}