% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/variables.R
\name{variable_importance}
\alias{variable_importance}
\title{Compute permutation importance for maxnet covariates}
\usage{
variable_importance(
  x,
  y,
  n = 5,
  arrange = c("none", "increasing", "decreasing")[1],
  ...
)
}
\arguments{
\item{x}{maxnet model}

\item{y}{table of occurrence and background environmental data (data.frame,
tibble, or matrix with column names)}

\item{n}{num, number of iterations}

\item{arrange}{char, one of "none" (default), "decreasing" or "increasing" to arrange
the output order}

\item{...}{other arguments for \code{\link[maxnet]{predict}} such
as \code{clamp} and \code{type}}
}
\value{
table of premutation importance scoires (and raw values)
}
\description{
This is adapted from Peter D Wilson's \href{https://github.com/peterbat1/fitMaxnet}{fitMaxnet R package}.
}
\details{
From the \href{https://biodiversityinformatics.amnh.org/open_source/maxent/Maxent_tutorial_2021.pdf}{maxnet manual page 14} "The contribution for each variable is determined by randomly permuting the values of that variable among the training points (both presence and background) and measuring the resulting decrease in training AUC. A large decrease indicates that the model depends heavily on that variable."
}
\examples{
\dontrun{
  library(maxnet)
  data(bradypus)
  p <- bradypus$presence
  data <- bradypus[,-1]
  mod <- maxnet(p, data)
  variable_importance(mod, data, arrange = "decreasing") |> dput()
  # c(tmn6190_ann = 35.89, ecoreg = 16.18, tmx6190_ann = 11.75, frs6190_ann = 9.8,
  #   h_dem = 7.81, dtr6190_ann = 5.53, pre6190_l10 = 4.15, pre6190_l7 = 2.67,
  #   pre6190_l1 = 2.22, pre6190_l4 = 1.71, vap6190_ann = 1.51, cld6190_ann = 0.59,
  #   tmp6190_ann = 0.2, pre6190_ann = 0)
}
}
