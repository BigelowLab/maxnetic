#' Compute permutation importance for maxnet covariates
#'
#' This is adapted from Peter D Wilson's [fitMaxnet R package](https://github.com/peterbat1/fitMaxnet).
#'
#' From the [maxnet manual page 14](https://biodiversityinformatics.amnh.org/open_source/maxent/Maxent_tutorial_2021.pdf) "The contribution for each variable is determined by randomly permuting the values of that variable among the training points (both presence and background) and measuring the resulting decrease in training AUC. A large decrease indicates that the model depends heavily on that variable."
#'
#' @export
#' @param x maxnet model
#' @param y table of occurence and background environmental data (data.frame,
#'   tibble, or matrix with column names)
#' @param n num, number of iterations
#' @param arrange char, one of "none" (default), "decreasing" or "increasing" to arrange
#'    the output order
#' @param ... other arguments for \code{\link[maxnet]{predict}} such
#'   as \code{clamp} and \code{type}
#' @return named numeric vector of permutation scores
#' @examples \dontrun{
#'   library(maxnet)
#'   data(bradypus)
#'   p <- bradypus$presence
#'   data <- bradypus[,-1]
#'   mod <- maxnet(p, data)
#'   variable_importance(mod, data, arrange = "decreasing") |> dput()
#'   # c(tmn6190_ann = 35.89, ecoreg = 16.18, tmx6190_ann = 11.75, frs6190_ann = 9.8,
#'   #   h_dem = 7.81, dtr6190_ann = 5.53, pre6190_l10 = 4.15, pre6190_l7 = 2.67,
#'   #   pre6190_l1 = 2.22, pre6190_l4 = 1.71, vap6190_ann = 1.51, cld6190_ann = 0.59,
#'   #   tmp6190_ann = 0.2, pre6190_ann = 0)
#' }
variable_importance = function(x, y,
                               n = 5,
                               arrange = c("none", "increasing", "decreasing")[1],
                               ...){
  baseline = predict(x, y, ...) # the staring point of the model
  ny = nrow(y)
  r = sapply(names(x$samplemeans),
    function(varname){          # shuffle each variable n times
      orig_values = y[,varname, drop = TRUE]
      r = sapply(seq_len(n),
        function(iter){
          index = sample(ny,ny)   # shuffle the variable
          y[,varname] <- orig_values[index]
          m = predict(x, y, ...)
          cor(baseline,m)       # correlate to original
        })
      y[,varname] <- orig_values
      mean(r)                   # find the average of the correlations
    })
  # if the correlations with original are high that means shuffling the variable
  # had little effect on the output models.  Thsu the variable has low influence.
  # invert the importance so ones with low mean correlation are now higher valued.
  r = 1 - r
  # just a convenience for the user
  r = switch(tolower(arrange[1]),
             "decreasing" = sort(r, decreasing = TRUE),
             "increasing" = sort(r),
             r)
  # prettify
  round(100*r/sum(r),2)
}
