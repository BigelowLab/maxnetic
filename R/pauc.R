#' Compute AUC for predicted presences
#'
#' @export
#' @param x object containing all predicted ranked suitability values, such as 
#'   values produced by the `predict()` function. This may be a vector or `stars` object.
#' @param y object containing predicted ranked suitability values for presence points only.
#'   This may be a vector or, if `x` is a `stars` object it muct be a `sf` `POINT` object.
#' @param ... other arguments for `auc_raster` or `auc_vector`.
#' @return a list of 
#' \itemize{
#'  \item{fpa, a vector of fractional predicted area}
#'  \item{sensitivity,a vector of sensitivity (1-omission rate)}
#'  \item{area, scalar AUC value}
#'  }
pAUC = function(x, y, ...){
  if (inherits(x, 'stars')){
    r = pauc_raster(x, y, ...)
  } else {
    r = pauc_vector(x, y, ...)
  }
  class(r) <- c("pAUC", class(r))
  r
}

#' Given a stars object and presence point locations compute the pAUC
#'
#' @export
#' @seealso \code{auc_vector}
#' @param x a stars object
#' @param y sf point object
#' @param time_column char or num, indicates the time-based column in `y` that matches the
#'   time dimension in `x`
#' @param ... further arguments for \code{auc_vector}
#' @return a list of
#' \itemize{
#'  \item{fpa, a vector of fractional predicted area}
#'  \item{sensitive,a vector of sensitivity (1-omission rate)}
#'  \item{area, scalar AUC value}
#'  }
pauc_raster <- function(x, y, time_column = attr(y, "time_column") %||% attr(y, "time_col"), ...){
  v = stars::st_extract(x, y, time_column = time_column)
  pauc_vector(as.vector(as.vector(x[[1]]), as.vector(v[[1]]), ...))
}

#' Compute AUC values ala presence-only data
#'
#' @export
#' @param f a vector of predicted ranked suitability values, NaNs and NAs will be removed
#' @param v a vector of predicted values where there are presences, NaNs and NAs will be removed
#' @param thr a vector of threshold values
#' @param method character, if 'fast' (the default) use the fast implementation
#' @return a list of
#' \itemize{
#'  \item{fpa, a vector of fpa (fractional predicted area)}
#'  \item{sensitivity, a vector of sensitivity (1-omission rate)}
#'  \item{area, AUC}
#'  }
pauc_vector <- function(f, v, 
                       thr = seq(from = 1, to = 0, by = -0.001),
                       method = 'fast'){
  
  if (tolower(method[1]) == 'fast') return(pauc_vector_fast(f,v,thr = thr))
  
  f <- f[!is.na(f)]
  fn <- length(f)
  v <- v[!is.na(v)]
  vn <- length(v)
  x <- rep(0, length(thr))
  y <- x
  for (i in seq_along(x)){
    ix <- sum(f > thr[i])
    x[i] <- ix/fn
    iy <- sum(v > thr[i])
    y[i] <- iy/vn
  }
  list(fpa = x, 
       sensitivity = y,
       area = sum(diff(x) * (y[2:length(y)]+ y[1:length(y)-1])/2) )
  
}

#' Compute AUC values ala presence-only data using a fast algorithm.
#'
#' This function gains speed using \code{Rfast::Sort()} and \code{base::findInterval()}
#'
#' @export
#' @param f a vector of predicted ranked suitability values, NaNs and NAs will be removed
#' @param v a vector of predicted values where there are presences, NaNs and NAs will be removed
#' @param thr a vector of threshold values
#' @return a list of
#' \itemize{
#'  \item{fpa, a vector of fpa (fractional predicted area)}
#'  \item{sensitivity, a vector of sensitivity (1-omission rate)}
#'  \item{area, AUC}
#'  }
pauc_vector_fast <- function(f, v, thr = seq(from = 1, to = 0, by = -0.001)){
  
  f   <- f[is.finite(f)]
  f   <- Rfast::Sort(f, na.last = NA)
  fn  <- length(f)
  v   <- v[is.finite(v)]
  v   <- Rfast::Sort(v, na.last = NA)
  vn  <- length(v)
  x   <- rep(0, length(thr))
  y   <- x
  
  fix <- findInterval(thr, f)
  vix <- findInterval(thr, v)
  x   <- (fn - fix)/fn
  y   <- (vn - vix)/vn
  a   <- sum(diff(x) * (y[2:length(y)] + y[1:length(y)-1])/2)
  
  list(fpa = x,
       sensitivity = y,
       area = a)
}
