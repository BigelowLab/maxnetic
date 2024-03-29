% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/graphics.R
\name{plot.pAUC}
\alias{plot.pAUC}
\title{Plot pAUC}
\usage{
\method{plot}{pAUC}(
  x,
  xlab = "1 - Specificity (Fractional Predicted Area)",
  ylab = "Sensitivity (1 - Omission Rate)",
  title = "Presence-only ROC",
  ...
)
}
\arguments{
\item{x}{a pAUC class object object}

\item{xlab}{char, label for x axis}

\item{ylab}{char, label for y axis}

\item{title}{char title for the plot}

\item{...}{ignored}
}
\value{
ggplot2 object
}
\description{
Plot pAUC
}
